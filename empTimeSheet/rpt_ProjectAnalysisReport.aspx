﻿<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="rpt_ProjectAnalysisReport.aspx.cs" Inherits="empTimeSheet.rpt_ProjectAnalysisReport" %>

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
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:UpdatePanel ID="upadatepanel" runat="server">
        <ContentTemplate>
            <pg:progress ID="progress1" runat="server" />
            <div id="otherdiv" onclick="closediv();">
            </div>
            <div class="pageheader">
                <h2>
                    <i class="fa fa-table"></i>Analysis Report
                </h2>
                <input type="hidden" id="hidid" runat="server" />
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
                                    <div class="col-xs-12 col-sm-8 col-md-8 f_left" style="padding: 0px;">
                                        <h5 class="subtitle mb5">Project Analysis Report</h5>
                                    </div>

                                    <div class="clear"></div>


                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl2">Client :</label>

                                        <div class="txt w2 mar10">
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
                                        <label class="lbl lbl2">
                                            Status :
                                        </label>
                                        <div class="txt w1">
                                            <asp:DropDownList ID="dropactive" runat="server" CssClass="form-control">
                                                <asp:ListItem Value="--All--" Selected="True">--All--</asp:ListItem>
                                                <asp:ListItem Value="Active">Active</asp:ListItem>
                                                <asp:ListItem Value="Archived">Archived</asp:ListItem>
                                                <asp:ListItem Value="Completed">Completed</asp:ListItem>
                                                <asp:ListItem Value="Hold">Hold</asp:ListItem>
                                                <asp:ListItem Value="Inactive">Inactive</asp:ListItem>
                                                <asp:ListItem Value="Main">Main</asp:ListItem>
                                                <asp:ListItem Value="Canceled">Canceled</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="clear"></div>

                                    <div class="ctrlGroup searchgroup">

                                        <label class="lbl lbl2">
                                            Project :
                                        </label>
                                        <div class="txt w2 mar10">
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
                                       <label class="lbl lbl2">
                                           &nbsp;
                                        </label>
                                        <asp:Button ID="btnsearch" runat="server" CssClass="btn btn-default " Text="View Report" ValidationGroup="search"
                                            OnClick="btnsearch_click" />
                                    </div>



                                    <%--                       <div class="linkadvancesearch">
                                <a onclick="  $('.divadvancesearch').toggle(300);">Advance search?</a>
                            </div>--%>
                                </div>
                            </div>
                            <div class="col-sm-12 col-md-12 mar2">
                                <div class="f_right">
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
                            </div>
                            <div class="clear">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <input type="hidden" id="hidsearchfromdate" runat="server" />
            <input type="hidden" id="hidsearchtodate" runat="server" />
            <input type="hidden" id="hidsearchdrpclient" runat="server" />
            <input type="hidden" id="hidsearchdrpproject" runat="server" />
            <input type="hidden" id="hidsprojectid" runat="server" />
            <input type="hidden" id="hidsclientid" runat="server" />
            <input type="hidden" id="hidsemployeeid" runat="server" />
            <input type="hidden" id="hidsearchdrpclientname" runat="server" />
            <input type="hidden" id="hidsearchdrpprojectname" runat="server" />

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
