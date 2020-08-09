<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="rpt_TaskReport.aspx.cs" Inherits="empTimeSheet.rpt_TaskReport" %>
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
          
            var selectedclient = document.getElementById(clientid).value;
            

            if (selectedclient != "" ) {
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
                    <i class="fa fa-home"></i>Task Managment Report
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
                                    <div class="col-xs-12 col-sm-8 col-md-6 f_left" style="padding: 0px;">
                                        <h5 class="subtitle mb5">Task Managment Report</h5>
                                    </div>
                                    <div class="clear col-sm-6 col-md-4 pad4">
                                        <%-- <asp:CustomValidator ID="req1" runat="server" ClientValidationFunction="validatereport" ValidationGroup="search" ErrorMessage="Select a client or project!"></asp:CustomValidator>--%>
                                    </div>
                                    <div class="clear"></div>
                                   
                                    <div class="col-sm-6 col-md-4  pad4">
                                       <asp:DropDownList ID="dropdeptsearch" runat="server" CssClass="form-control mar pad3">
                                </asp:DropDownList>

                                    </div>
                                    <div class="col-sm-6 col-md-4  pad5">
                                         <asp:TextBox ID="txtColumn" runat="server" CssClass="form-control mar pad3" ClientIDMode="Static" placeholder="--All Columns--" onkeypress="searchfilters(this.id,'dropclient');" onkeyup="searchfilters(this.id,'dropclient');" onkeydown="searchfilters(this.id,'dropclient');">
                                        </asp:TextBox>

                                        <ajaxToolkit:PopupControlExtender ID="PopupControlExtender1" runat="server" TargetControlID="txtColumn"
                                            PopupControlID="panelclient" Position="Bottom">
                                        </ajaxToolkit:PopupControlExtender>
                                        <asp:Panel ID="panelclient" runat="server" CssClass="poppanel">

                                            <input type="checkbox" id="chkclient" onclick="checkall(this.id, 'dropclient', '--All Columns--', 'txtColumn', 'client');" />
                                            <span>Check All</span><div class="clear"></div>
                                            <asp:CheckBoxList ID="dropclient" runat="server" RepeatLayout="Table" Width="100%"   ClientIDMode="Static"    onchange="setcontent(this.id,'txtColumn','--All Columns--','client');" ></asp:CheckBoxList>

                                        </asp:Panel>
                                      
                                    </div>

                                    <div class="col-sm-6 col-md-4 pad4">
                                        <asp:Button ID="btnsearch" runat="server" CssClass="btn btn-default mar" Text="View Report" ValidationGroup="search"
                                            OnClick="btnsearch_Click" />
                                    </div>

                                </div>
                            </div>
                            <div class="col-sm-12 col-md-12 mar2">
                                <div class="f_right">
                                    <%--  <asp:LinkButton ID="lnkprevious" CssClass="f_left" runat="server" OnClick="lnkprevious_Click">
            <i class="fa fa-fw fa-fast-backward color_green"></i></asp:LinkButton>
                                    </span>
                                    <div class="f_left page">
                                        <asp:Label ID="lblstart" runat="server"></asp:Label>
                                        -
                                        <asp:Label ID="lblend" runat="server"></asp:Label>
                                        of <strong>
                                            <asp:Label ID="lbltotalrecord" Font-Bold="true" runat="server"></asp:Label></strong>
                                    </div>
                                    <asp:LinkButton ID="lnknext" CssClass="f_left" runat="server" OnClick="lnknext_Click"><i class="fa fa-fw fa-fast-forward color_green"></i></asp:LinkButton>--%>
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
                                                     <rsweb:ReportViewer ID="ReportViewer1" runat="server" Width="100%" Height="600px"    >
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

            <input type="hidden" id="hidsearchdrpclientname" runat="server" />
            <input type="hidden" id="hidsearchdrpprojectname" runat="server" />

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
