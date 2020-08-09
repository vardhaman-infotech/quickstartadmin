<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="rpt_TimeandExpReport.aspx.cs" Inherits="empTimeSheet.rpt_TimeandExpReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
   
    <style type="text/css">
        .theadr {
            border-top: solid 1px #000000 !important;
            border-bottom: solid 1px #000000 !important;
            text-align: right !important;
        }

        .thead {
            border-top: solid 1px #000000 !important;
            border-bottom: solid 1px #000000 !important;
        }

        .tdb {
            font-weight: bold !important;
            text-decoration: underline !important;
        }

        .tdctotal {
            text-align: right !important;
            font-weight: bold !important;
            font-family:sog
        }

            .tdctotal span {
                color: #EB8806 !important;
            }


        .thc {
            color: #000000 !important;
        }

        .thc span {
            color: #BB0E50 !important;
        }

        .tdr {
            text-align: right !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <pg:progress ID="progress1" runat="server" />
    <div class="pageheader">
        <h2>
            <i class="fa fa-clipboard"></i>
Time & Expense Report by Project & Employee 
        </h2>
        <div class="breadcrumb-wrapper mar ">
            <asp:LinkButton ID="btnexportcsv" runat="server" OnClick="btnexportcsv_Click" CssClass="right_link">
            <i class="fa fa-fw fa-file-excel-o topicon"></i>Export to Excel</asp:LinkButton>
            <asp:LinkButton ID="lblexportpdf" runat="server" OnClick="lblexportpdf_Click" CssClass="right_link">
            <i class="fa fa-fw fa-file-excel-o topicon"></i>Export to PDF</asp:LinkButton>
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
Time & Expense Report by Project & Employee </h5>
                            </div>
                            <div class="clear"></div>
                           <div class="ctrlGroup searchgroup">
                                <div class="txt w1 mar10">

                                <asp:TextBox ID="txtfromdate" runat="server" placeholder="From Date" CssClass="form-control hasDatepicker"></asp:TextBox>

                                <cc1:CalendarExtender ID="cc1" runat="server" TargetControlID="txtfromdate" PopupButtonID="txtfromdate"
                                    Format="MM/dd/yyyy">
                                </cc1:CalendarExtender>

                            </div>
                               </div>
                          <div class="ctrlGroup searchgroup">
                                <div class="txt w1">

                                <asp:TextBox ID="txttodate" runat="server" placeholder="To Date" CssClass="form-control hasDatepicker"></asp:TextBox>

                                <cc1:CalendarExtender ID="cc2" runat="server" TargetControlID="txttodate" PopupButtonID="txttodate"
                                    Format="MM/dd/yyyy">
                                </cc1:CalendarExtender>

                            </div>
                              </div>
                             <div class="clear"></div>
                           <div class="ctrlGroup searchgroup">
                                <div class="txt w1 mar10">
                                <asp:TextBox ID="txtemployee" runat="server" CssClass="form-control mar pad3" placeholder="--All Employee--" ClientIDMode="Static">
                                </asp:TextBox>


                                <ajaxToolkit:PopupControlExtender ID="PceSelectCustomer" runat="server" TargetControlID="txtemployee"
                                    PopupControlID="panelemployee" Position="Bottom">
                                </ajaxToolkit:PopupControlExtender>

                                <asp:Panel ID="panelemployee" runat="server" CssClass="poppanel">

                                    <input type="checkbox" id="chkemp" onclick="checkall(this.id, 'dropemployee', '--All Employees--', 'txtemployee', 'employee');" />
                                    <span>Check All</span><div class="clear"></div>
                                      <asp:CheckBoxList ID="dropemployee" runat="server" RepeatLayout="Table" Width="100%"    ClientIDMode="Static" onchange="setcontent(this.id,'txtemployee','--All Employee--','employee');"></asp:CheckBoxList>

                                </asp:Panel>

                            </div>
                               </div>
                           <div class="ctrlGroup searchgroup">
                                <div class="txt w1">
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
                             <div class="clear"></div>
                          <div class="ctrlGroup searchgroup">
                                <div class="txt w1 mar10">
                                <asp:TextBox ID="txtproject" runat="server" CssClass="form-control mar pad3" ClientIDMode="Static" placeholder="--All Projects--">
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
                               
                                <asp:Button ID="btnsearch" runat="server" Text="View Report" CssClass="btn btn-default mar"
                                    OnClick="btnsearch_Click" />
                            </div>

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

                                <div class="panel panel-default">
                                    <div class="panel-body2 ">
                                        <div class="row">
                                            <div class="table-responsive">
                                                <div class="nodatafound" id="divnodata" runat="server" visible="false">
                                                    No data found
                                                </div>
                                                <div id="divreport" runat="server"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <input type="hidden" id="hidsprojectid" runat="server" />
                                <input type="hidden" id="hidsclientid" runat="server" />
                                <input type="hidden" id="hidsemployeeid" runat="server" />
                            </ContentTemplate>
                            <Triggers>
                                <%--  <asp:AsyncPostBackTrigger ControlID="btnsearch" EventName="Click" />
                                <asp:AsyncPostBackTrigger ControlID="lnkrefresh" EventName="Click" />--%>
                            </Triggers>
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
