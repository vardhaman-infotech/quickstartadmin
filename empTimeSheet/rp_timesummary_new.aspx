<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="rp_timesummary_new.aspx.cs" Inherits="empTimeSheet.rp_timesummary_new" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">

        function showcustomdate(id) {

            if (document.getElementById(id).value == "Custom") {
                document.getElementById("divdate").style.display = "block";
            }
            else {
                document.getElementById("divdate").style.display = "none";
            }
        }
    

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <pg:progress ID="progress1" runat="server" />
    <div class="pageheader">
        <h2>
            <i class="fa fa-clipboard"></i>Time Summary Report
        </h2>

        <div class="clear">
        </div>
    </div>
    <div class="contentpanel">
        <div class="row">
            <div class="col-sm-12 col-md-12">
                <div class="panel panel-default">
                    <div class="col-sm-12 col-md-10">
                        <div style="padding-top: 10px;">
                            <div class="col-xs-12 col-sm-8 col-md-6 f_left" style="padding: 0px;">
                                <h5 class="subtitle mb5">Time Summary Report By Employee</h5>
                            </div>
                            <div class="clear"></div>
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl lbl2">Date Range :</label>
                                <div class="txt w1 mar10">
                                    <asp:DropDownList ID="dropdaterange" runat="server" CssClass="form-control" onchange="showcustomdate(this.id);">
                                        <asp:ListItem Text="Quarterly" Value="Quarterly"></asp:ListItem>
                                        <asp:ListItem Text="Monthly" Value="Monthly"></asp:ListItem>
                                        <asp:ListItem Text="Biweekly" Value="Biweekly"></asp:ListItem>
                                        <asp:ListItem Text="Weekly" Value="Weekly"></asp:ListItem>
                                        <asp:ListItem Text="Custom" Value="Custom"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>  <div class="clear"></div>
                         
                            <div class="clear"></div>
                            <div id="divdate" style="display: none;">

                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl lbl2">
                                        From Date :
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:TextBox ID="txtfrmdate" runat="server" CssClass="form-control hasDatepicker" onchange="comparedate(this.id,'ctl00_ContentPlaceHolder1_txtfrmdate','ctl00_ContentPlaceHolder1_txttodate');"></asp:TextBox>

                                        <cc1:CalendarExtender ID="txtDate_CalendarExtender" runat="server" TargetControlID="txtfrmdate"
                                            PopupButtonID="txtfrmdate" Format="MM/dd/yyyy">
                                        </cc1:CalendarExtender>
                                    </div>

                                </div> <div class="clear"></div>
                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl lbl2">
                                        To Date :
                                    </label>
                                    <div class="txt w1">
                                        <asp:TextBox ID="txttodate" runat="server" CssClass="form-control hasDatepicker pad3" onchange="comparedate(this.id,'ctl00_ContentPlaceHolder1_txtfrmdate','ctl00_ContentPlaceHolder1_txttodate');"></asp:TextBox>

                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txttodate"
                                            PopupButtonID="txttodate" Format="MM/dd/yyyy">
                                        </cc1:CalendarExtender>
                                    </div>
                                </div>
                                <div class="clear"></div>
                            </div>
                            <div class="clear"></div>
                               <div class="ctrlGroup searchgroup">
                                <label class="lbl lbl2">Client :</label>
                                <div class="txt w2 mar10">
                                    <asp:TextBox ID="txtclient" runat="server" CssClass="form-control" ClientIDMode="Static" placeholder="--All Clients--" onkeypress="searchfilters(this.id,'dropclient');" onkeyup="searchfilters(this.id,'dropclient');" onkeydown="searchfilters(this.id,'dropclient');">
                                    </asp:TextBox>

                                    <ajaxToolkit:PopupControlExtender ID="PopupControlExtender1" runat="server" TargetControlID="txtclient"
                                        PopupControlID="panelclient" Position="Bottom">
                                    </ajaxToolkit:PopupControlExtender>
                                    <asp:Panel ID="panelclient" runat="server" CssClass="poppanel">

                                        <input type="checkbox" id="chkclient" onclick="checkall(this.id, 'dropclient', '--All Clients--', 'txtclient', 'client');" />
                                        <span>Check All</span><div class="clear"></div>
                                        <asp:CheckBoxList ID="dropclient" runat="server" RepeatLayout="UnorderedList" ClientIDMode="Static" onchange="setcontent(this.id,'txtclient','--All Clients--','client');"></asp:CheckBoxList>

                                    </asp:Panel>
                                </div>

                            </div>
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl lbl2">Project :</label>
                                <div class="txt w2">
                                    <asp:TextBox ID="txtproject" runat="server" CssClass="form-control" ClientIDMode="Static" placeholder="--All Projects--" onkeypress="searchfilters(this.id,'dropproject');" onkeyup="searchfilters(this.id,'dropproject');" onkeydown="searchfilters(this.id,'dropproject');">
                                    </asp:TextBox>

                                    <ajaxToolkit:PopupControlExtender ID="PopupControlExtender2" runat="server" TargetControlID="txtproject"
                                        PopupControlID="pnlproject" Position="Bottom">
                                    </ajaxToolkit:PopupControlExtender>
                                    <asp:Panel ID="pnlproject" runat="server" CssClass="poppanel">

                                        <input type="checkbox" id="chkproject" onclick="checkall(this.id, 'dropproject', '--All Projects--', 'txtproject', 'project');" />
                                        <span>Check All</span><div class="clear"></div>
                                        <asp:CheckBoxList ID="dropproject" runat="server" RepeatLayout="UnorderedList" RepeatDirection="Vertical" RepeatColumns="1" ClientIDMode="Static" onchange="setcontent(this.id,'txtproject','--All Projects--','project');"></asp:CheckBoxList>

                                    </asp:Panel>
                                </div>
                            </div>
                             <div class="clear"></div>
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl lbl2">Employee :</label>
                                <div class="txt w2 mar10">
                                    <asp:TextBox ID="txtemployee" runat="server" CssClass="form-control " placeholder="--All Employee--" ClientIDMode="Static" onkeypress="searchfilters(this.id,'dropemployee');" onkeyup="searchfilters(this.id,'dropemployee');" onkeydown="searchfilters(this.id,'dropemployee');">
                                    </asp:TextBox>


                                    <ajaxToolkit:PopupControlExtender ID="PceSelectCustomer" runat="server" TargetControlID="txtemployee"
                                        PopupControlID="panelemployee" Position="Bottom">
                                    </ajaxToolkit:PopupControlExtender>

                                    <asp:Panel ID="panelemployee" runat="server" CssClass="poppanel">

                                        <input type="checkbox" id="chkemp" onclick="checkall(this.id, 'dropemployee', '--All Employees--', 'txtemployee', 'employee');" />
                                        <span>Check All</span><div class="clear"></div>
                                        <asp:CheckBoxList ID="dropemployee" runat="server" RepeatLayout="UnorderedList" RepeatDirection="Vertical" ClientIDMode="Static" onchange="setcontent(this.id,'txtemployee','--All Employee--','employee');"></asp:CheckBoxList>

                                    </asp:Panel>
                                </div>
                            </div>


                       


                            <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>


                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl2 disNone">&nbsp;  </label>
                                        <asp:Button ID="btnsearch" runat="server" Text="View Report" CssClass="btn btn-default"
                                            OnClick="btnsearch_click" />
                                    </div>

                                </ContentTemplate>
                            </asp:UpdatePanel>

                        </div>
                    </div>
                    <div class="clear">
                    </div>
                    <div class="col-sm-12 col-md-12 mar2">
                        <asp:UpdatePanel ID="updatePanelData" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="false">
                            <ContentTemplate>
                                <div id="otherdiv" onclick="closediv();">
                                </div>
                                <div class="clear">
                                </div>
                                <div class="panel panel-default" style="border: none;">
                                    <div class="panel-body2 ">
                                        <div class="row">
                                            <div class="table-responsive">
                                                <div class="nodatafound" id="divnodata" runat="server" visible="false">
                                                    No data found
                                                </div>

                                                <div id="divreport" runat="server" class="mainrptdiv" visible="false">

                                                    <!--Outer Most- CLIENT repeater-->
                                                    <rsweb:ReportViewer ID="ReportViewer1" runat="server" Width="100%" Height="600px">
                                                    </rsweb:ReportViewer>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <input type="hidden" id="hidsprojectid" runat="server" />
                                <input type="hidden" id="hidsclientid" runat="server" />
                                <input type="hidden" id="hidsemployeeid" runat="server" />
                            </ContentTemplate>

                        </asp:UpdatePanel>
                    </div>
                    <div class="clear">
                    </div>
                </div>
                <!--Panel-default-->
            </div>
            <!---col-sm-12 col-md-12-->
        </div>
        <!---row-->
    </div>
    <!---contentpanel-->
</asp:Content>

