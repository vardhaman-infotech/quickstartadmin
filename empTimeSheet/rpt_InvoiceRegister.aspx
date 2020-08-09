<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="rpt_InvoiceRegister.aspx.cs" Inherits="empTimeSheet.rpt_InvoiceRegister" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .spanemp {
            -moz-border-bottom-colors: none;
            -moz-border-left-colors: none;
            -moz-border-right-colors: none;
            -moz-border-top-colors: none;
            background: #ffffff none repeat scroll 0 0;
            border-color: #5b5b5b #f2f2f2 #f2f2f2 #797979;
            border-image: none;
            border-style: outset;
            border-width: 1px;
            color: #8a693f;
            font-size: 15px;
        }

        .table tr {
            border: 1px solid #ffffff;
            background: #f2f2f2 none repeat scroll 0 0;
        }
    </style>
   
    <script type="text/javascript">
        function validatereport(source, args) {

            var clientid = "ctl00_ContentPlaceHolder1_drpclient";
            var projectid = "ctl00_ContentPlaceHolder1_dropproject";
            var selectedclient = document.getElementById(clientid).value;
            var selectedproject = document.getElementById(projectid).value;

            if (selectedclient != "" || selectedproject != "") {
                args.IsValid = true;
            }
            else {

                args.IsValid = false;
            }
            return;
        }
    </script>
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

    <div class="pageheader">
        <h2>
            <i class="fa fa-table"></i>Billing Report
        </h2>
        <div class="breadcrumb-wrapper mar ">
        </div>
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
                                <h5 class="subtitle mb5">
                                    <asp:Label ID="lblReportName" runat="server" Text="Invoice Register"></asp:Label>
                                </h5>
                            </div>
                            <div class="clear"></div>
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl lbl2">Date Range :</label>
                                <div class="txt w1 mar10">
                                    <asp:DropDownList ID="dropdaterange" runat="server" CssClass="form-control" onchange="showcustomdate(this.id);">
                                           <asp:ListItem Text="All" Value="All"></asp:ListItem>
                                          <asp:ListItem Text="This Calendar Year" Value="This Calendar Year" Selected="True"></asp:ListItem>
                                          <asp:ListItem Text="Last Calendar Year" Value="Last Calendar Year"></asp:ListItem>
                                        <asp:ListItem Text="Quarterly" Value="Quarterly" ></asp:ListItem>
                                        <asp:ListItem Text="Monthly" Value="Monthly"></asp:ListItem>
                                        <asp:ListItem Text="Biweekly" Value="Biweekly"></asp:ListItem>
                                        <asp:ListItem Text="Weekly" Value="Weekly"></asp:ListItem>
                                        <asp:ListItem Text="Custom" Value="Custom"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                             <div class="clear"></div>
                             <div id="divdate" style="display: none;">
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl lbl2">From Date :</label> <div class="txt w1 mar10">
                              
                                <asp:TextBox ID="txtfromdate" runat="server" placeholder="From Date" CssClass="form-control hasDatepicker" onchange="comparedate(this.id,'ctl00_ContentPlaceHolder1_txtfromdate','ctl00_ContentPlaceHolder1_txttodate');"></asp:TextBox>

                                <cc1:CalendarExtender ID="cc1" runat="server" TargetControlID="txtfromdate" PopupButtonID="txtfromdate"
                                    Format="MM/dd/yyyy">
                                </cc1:CalendarExtender>
                                    
                            </div> </div>
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl lbl2">To Date :</label>
                               
                                      <div class="txt w1">
                                <asp:TextBox ID="txttodate" runat="server" placeholder="To Date" CssClass="form-control hasDatepicker" onchange="comparedate(this.id,'ctl00_ContentPlaceHolder1_txtfromdate','ctl00_ContentPlaceHolder1_txttodate');"></asp:TextBox>

                                <cc1:CalendarExtender ID="cc2" runat="server" TargetControlID="txttodate" PopupButtonID="txttodate"
                                    Format="MM/dd/yyyy">
                                </cc1:CalendarExtender>
                                    </div>
                                    </div>

                           

                                 </div>
                            <div class="clear"></div>
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl lbl2">Client :</label>
                                <div class="txt w1 mar10">
                                  <asp:TextBox ID="txtclient" runat="server" CssClass="form-control" ClientIDMode="Static" placeholder="--All Clients--"  onkeypress="searchfilters(this.id,'dropclient');" onkeyup="searchfilters(this.id,'dropclient');" onkeydown="searchfilters(this.id,'dropclient');">
                                </asp:TextBox>

                                <ajaxToolkit:PopupControlExtender ID="PopupControlExtender1" runat="server" TargetControlID="txtclient"
                                    PopupControlID="panelclient" Position="Bottom">
                                </ajaxToolkit:PopupControlExtender>
                                <asp:Panel ID="panelclient" runat="server" CssClass="poppanel">

                                    <input type="checkbox" id="chkclient" onclick="checkall(this.id, 'dropclient', '--All Clients--', 'txtclient', 'client');" />
                                    <span>Check All</span><div class="clear"></div>
                                    <asp:CheckBoxList ID="dropclient" runat="server" RepeatLayout="Table" Width="100%"   ClientIDMode="Static" onchange="setcontent(this.id,'txtclient','--All Clients--','client');"></asp:CheckBoxList>

                                </asp:Panel>
                                    </div>

                            </div>
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl lbl2">Invoice No :</label>
                                <div class="txt w1 mar10">
                                <asp:TextBox ID="txtinvno" runat="server" CssClass="form-control" ></asp:TextBox>
                            </div></div>
                             <div class="clear"></div>
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl lbl2">Project :</label>
                                <div class="txt w1 mar10">
                                  <asp:TextBox ID="txtproject" runat="server" CssClass="form-control" ClientIDMode="Static" placeholder="--All Projects--"  onkeypress="searchfilters(this.id,'dropproject');" onkeyup="searchfilters(this.id,'dropproject');" onkeydown="searchfilters(this.id,'dropproject');">
                                </asp:TextBox>

                                <ajaxToolkit:PopupControlExtender ID="PopupControlExtender2" runat="server" TargetControlID="txtproject"
                                    PopupControlID="pnlproject" Position="Bottom">
                                </ajaxToolkit:PopupControlExtender>
                                <asp:Panel ID="pnlproject" runat="server" CssClass="poppanel">

                                    <input type="checkbox" id="chkproject" onclick="checkall(this.id, 'dropproject', '--All Projects--', 'txtproject', 'project');" />
                                    <span>Check All</span><div class="clear"></div>
                                    <asp:CheckBoxList ID="dropproject" runat="server" RepeatLayout="Table" Width="100%"   RepeatDirection="Horizontal" RepeatColumns="1" ClientIDMode="Static" onchange="setcontent(this.id,'txtproject','--All Projects--','project');"></asp:CheckBoxList>

                                </asp:Panel>
                                    </div>
                            </div>
                            
                            


                             <div class="ctrlGroup searchgroup">
                           <label class="lbl lbl2">&nbsp;</label>
                                <div class="txt w1 ">
                                
                                <asp:UpdatePanel ID="updatesearch" runat="server">
                                    <ContentTemplate>
                                        <asp:Button ID="btnsearch" runat="server" Text="View Report" CssClass="btn btn-default"
                                            OnClick="btnsearch_Click" />
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                                 </div>

                        </div>
                    </div>
                    <div class="clear">
                    </div>
                    <asp:UpdatePanel ID="updateResult" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <pg:progress ID="progress2" runat="server" />
                            <div class="col-sm-12 col-md-12 mar2">

                                <div class="diverror" id="divnodata" runat="server" visible="false">
                                    No data found
                                </div>

                                <div id="divreport" runat="server" class="mainrptdiv" visible="false">

                                    <!--Outer Most- CLIENT repeater-->
                                    <rsweb:ReportViewer ID="ReportViewer1" runat="server" Width="100%" Height="600px">
                                    </rsweb:ReportViewer>

                                </div>
                                <div class="clear"></div>

                                <input type="hidden" id="hidsprojectid" runat="server" />
                                <input type="hidden" id="hidsclientid" runat="server" />
                                <input type="hidden" id="hidsemployeeid" runat="server" />
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    <div class="clear">
                    </div>
                </div>
                <!--Panel-default-->
            </div>
            <!---col-sm-12 col-md-12-->
        </div>
        <!---row-->
    </div>
    <input type="hidden" id="hidsearchfromdate" runat="server" />
    <input type="hidden" id="hidsearchtodate" runat="server" />
    <input type="hidden" id="hidsearchdrpclient" runat="server" />
    <input type="hidden" id="hidsearchdrpproject" runat="server" />
    <input type="hidden" id="Hidden1" runat="server" />
    <input type="hidden" id="Hidden2" runat="server" />
    <input type="hidden" id="Hidden3" runat="server" />
    <input type="hidden" id="hidsearchdrpclientname" runat="server" />
    <input type="hidden" id="hidsearchdrpprojectname" runat="server" />
    <!---contentpanel-->
</asp:Content>
