<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="ARAgingReport.aspx.cs" Inherits="empTimeSheet.ARAgingReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" runat="server" ContentPlaceHolderID="head">
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
                    <i class="fa fa-table"></i>AR Aging Report
                </h2>
                <input type="hidden" id="hidid" runat="server" />
                <div class="breadcrumb-wrapper mar ">
                    <div class="f_right">


                        <asp:LinkButton ID="lbtnpdf" runat="server" OnClick="btnexportpdf_Click"
                            CssClass="right_link"><i class="fa fa-fw"
                    style="padding-right: 10px; font-size: 12px; border: none;"></i>Export to PDF</asp:LinkButton>
                        <asp:LinkButton ID="lnkrefresh" runat="server" OnClick="btnrefresh_Click" CssClass="right_link">
                        <i class="fa fa-fw fa-refresh topicon"></i>
                        Refresh</asp:LinkButton>
                    </div>
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
                                        <h5 class="subtitle mb5">AR Aging Report</h5>
                                    </div>

                                    <div class="clear"></div>
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl1">From Date :</label>
                                        <div class="txt w1 mar10">

                                            <asp:TextBox ID="txtfrmdate" runat="server" CssClass="form-control hasDatepicker" onchange="comparedate(this.id,'ctl00_ContentPlaceHolder1_txtfrmdate','ctl00_ContentPlaceHolder1_txttodate');"></asp:TextBox>

                                            <cc1:CalendarExtender ID="txtDate_CalendarExtender" runat="server" TargetControlID="txtfrmdate"
                                                PopupButtonID="txtfrmdate" Format="MM/dd/yyyy">
                                            </cc1:CalendarExtender>

                                        </div>
                                    </div>

                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl1">To Date :</label>
                                        <div class="txt w1">

                                            <asp:TextBox ID="txttodate" runat="server" CssClass="form-control hasDatepicker" onchange="comparedate(this.id,'ctl00_ContentPlaceHolder1_txtfrmdate','ctl00_ContentPlaceHolder1_txttodate');"></asp:TextBox>

                                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txttodate"
                                                PopupButtonID="txttodate" Format="MM/dd/yyyy">
                                            </cc1:CalendarExtender>

                                        </div>
                                    </div>
                                    <div class="clear"></div>
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl1">Client :</label>
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
                                        <label class="lbl lbl1">Project :</label>
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

                                        <asp:Button ID="btnsearch" runat="server" CssClass="btn btn-default" Text="View Report" ValidationGroup="search"
                                            OnClick="btnsearch_click" />
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
                                                <div class="nodatafound" id="divnodata" runat="server">
                                                    No data found
                                                </div>

                                                <div id="divreport" runat="server" class="mainrptdiv">

                                                    <!--Outer Most- CLIENT repeater-->
                                                    <asp:Repeater ID="rptclients" runat="server" OnItemDataBound="rptclients_ItemDataBound">
                                                        <HeaderTemplate>
                                                            <table width="100%" class="maintable" cellspacing="0" cellpadding="0">
                                                        </HeaderTemplate>
                                                        <ItemTemplate>


                                                            <tr>
                                                                <td style="vertical-align: top;">
                                                                    <table width="100%" cellpadding="0" cellspacing="0">
                                                                        <tr>
                                                                            <td class="pad2" style="padding-left: 0px; padding-right: 0px;">
                                                                                <b>Client ID:</b> <span style="color: #EB8806;"><strong>
                                                                                    <%#Eval("clientcode")%></strong></span> - <%#Eval("clientname")%>
                                                                            </td>
                                                                        </tr>



                                                                        <asp:Repeater ID="rptprojects" runat="server" OnItemDataBound="rptprojects_ItemDataBound">

                                                                            <ItemTemplate>
                                                                                <tr>
                                                                                    <td>&nbsp;

                                                                                    </td>

                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="pad1" style="background: #cccccc; padding: 4pt; font-size: 9pt; font-family: calibri;" bgcolor="#cccccc">
                                                                                        <b style="color: #666666;">&nbsp;Project ID: Name (Manager):</b><strong> <%#Eval("projectcode")%></strong> - <span style="color: #B867BF; font-style: italic;"><%#Eval("projectname")%></span> (<span style="color: #0da08b; font-weight: bold;"> <%#Eval("managername")%> </span>)
                                                                                
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td style="border-top: 2px solid #959595; border-bottom: 2px solid #959595; margin: 8px 0;">
                                                                                        <table class="table" width="100%" cellpadding="2">
                                                                                            <tr bgcolor="#f2f2f2">
                                                                                                <th align="left" width="12%" style="font-weight: bold; color: #333333; font-size: 9pt; font-family: calibri; padding: 6px; vertical-align: top;">InvoiceNum</th>
                                                                                                <th align="left" width="12%" style="font-weight: bold; color: #333333; font-size: 9pt; font-family: calibri; padding: 6px; vertical-align: top;">Date</th>
                                                                                                <th align="left" width="10%" style="text-align: left; font-weight: bold; color: #333333; font-size: 9pt; font-family: calibri; padding: 6px; vertical-align: top;">Bill Amt</th>
                                                                                                <th align="left" width="12%" style="text-align: left; font-weight: bold; color: #333333; font-size: 9pt; font-family: calibri; padding: 6px; vertical-align: top;">Paid</th>
                                                                                                <th align="left" width="10%" style="text-align: left; font-weight: bold; color: #333333; font-size: 9pt; font-family: calibri; padding: 6px; vertical-align: top;">Current</th>
                                                                                                <th align="left" width="13%" style="text-align: left; font-weight: bold; color: #333333; font-size: 9pt; font-family: calibri; padding: 6px; vertical-align: top;">31 To 60</th>
                                                                                                <th align="left" width="13%" style="text-align: left; font-weight: bold; color: #333333; font-size: 9pt; font-family: calibri; padding: 6px; vertical-align: top;">61 To 90</th>
                                                                                                <th align="left" width="10%" style="text-align: left; font-weight: bold; color: #333333; font-size: 9pt; font-family: calibri; padding: 6px; vertical-align: top;">>>90</th>
                                                                                                <th align="left" width="8%" style="text-align: left; font-weight: bold; color: #333333; font-size: 9pt; font-family: calibri; padding: 6px; vertical-align: top;">Balance</th>
                                                                                            </tr>
                                                                                            <asp:Literal ID="ltrprojectdetails" runat="server"></asp:Literal>
                                                                                        </table>

                                                                                    </td>
                                                                                </tr>

                                                                                <tr>
                                                                                    <td>&nbsp;</td>

                                                                                </tr>
                                                                            </ItemTemplate>
                                                                            <FooterTemplate>
                                                                                <tr>
                                                                                    <td style="padding: 0px;">
                                                                                        <table width="100%" class="table pad2 mar3" cellpadding="0" cellspacing="0">
                                                                                            <tr bgcolor="#f2f2f2">

                                                                                                <td width="46%" align="right" style="font-size: 9pt; font-family: calibri;">Client <span style="color: #EB8806; text-transform: uppercase"><strong>
                                                                                                    <asp:Literal ID="ltrclientid" runat="server"></asp:Literal></strong> </span><strong>Total:&nbsp;</strong>
                                                                                                </td>
                                                                                                <td width="10%" align="left" style="border-top: 1px solid #c3c3c3; border-bottom: 1px solid #c3c3c3; font-size: 9pt; font-family: calibri; text-align: left;">$<asp:Literal ID="ltrtotalcurrent" runat="server"></asp:Literal>

                                                                                                </td>
                                                                                                <td width="13%" align="left" style="border-top: 1px solid #c3c3c3; border-bottom: 1px solid #c3c3c3; font-size: 9pt; font-family: calibri; text-align: left;">$<asp:Literal ID="ltrtotalamount1" runat="server"></asp:Literal></td>
                                                                                                <td width="13%" align="left" style="border-top: 1px solid #c3c3c3; border-bottom: 1px solid #c3c3c3; font-size: 9pt; font-family: calibri; text-align: left;">$<asp:Literal ID="ltrtotalamount2" runat="server"></asp:Literal>
                                                                                                </td>
                                                                                                <td width="10%" align="left" style="border-top: 1px solid #c3c3c3; border-bottom: 1px solid #c3c3c3; font-size: 9pt; font-family: calibri; text-align: left;">$<asp:Literal ID="ltrtotalamount3" runat="server"></asp:Literal>
                                                                                                </td>

                                                                                                <td width="8%" align="left" style="border-top: 1px solid #c3c3c3; border-bottom: 1px solid #c3c3c3; font-size: 9pt; font-family: calibri; text-align: left;">$<asp:Literal ID="ltrbalance" runat="server"></asp:Literal>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                </tr>

                                                                            </FooterTemplate>
                                                                        </asp:Repeater>

                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </ItemTemplate>
                                                        <FooterTemplate>
                                                            <%-- <tr>
                                                                <td>
                                                                    <table width="100%" class="table pad2 mar3">
                                                                        <tr bgcolor="#f2f2f2">

                                                                            <td align="right" colspan="3" width="30%" style="font-size: 12pt; font-family: calibri;"><span style="color: #EB8806; text-transform: uppercase"><strong>
                                                                                <asp:Literal ID="ltrclientid" runat="server"></asp:Literal></strong> </span><strong>TOTAL:</strong>
                                                                            </td>
                                                                            <td width="12%" align="right" style="border-top: 1px solid #c3c3c3; border-bottom: 1px solid #c3c3c3; font-size: 10pt; font-family: calibri;">
                                                                                <asp:Literal ID="ltrhrs" runat="server"></asp:Literal>

                                                                            </td>
                                                                            <td width="12%" align="right" style="border-top: 1px solid #c3c3c3; border-bottom: 1px solid #c3c3c3; font-size: 10pt; font-family: calibri;">
                                                                                <asp:Literal ID="ltrbhrs" runat="server"></asp:Literal></td>
                                                                            <td width="13%" align="right">&nbsp;
                                                                            </td>
                                                                            <td width="13%" align="right" style="border-top: 1px solid #c3c3c3; border-bottom: 1px solid #c3c3c3; font-size: 10pt; font-family: calibri;">
                                                                                <asp:Literal ID="ltrcost" runat="server"></asp:Literal>
                                                                            </td>
                                                                            <td width="10%" align="right" style="border-top: 1px solid #c3c3c3; border-bottom: 1px solid #c3c3c3; font-size: 10pt; font-family: calibri;">
                                                                                <asp:Literal ID="ltramount" runat="server"></asp:Literal>
                                                                            </td>
                                                                            <td width="10%" align="right" style="border-top: 1px solid #c3c3c3; border-bottom: 1px solid #c3c3c3; font-size: 10pt; font-family: calibri;">
                                                                                <asp:Literal ID="ltrbalance" runat="server"></asp:Literal>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>--%>
                                                            </table>
                                                        </FooterTemplate>
                                                    </asp:Repeater>
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
