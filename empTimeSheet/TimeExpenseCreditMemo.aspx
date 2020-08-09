<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="TimeExpenseCreditMemo.aspx.cs" Inherits="empTimeSheet.TimeExpenseCreditMemo" %>

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
        .table tr
        {
            border:1px solid #ffffff;
            background: #f2f2f2 none repeat scroll 0 0;
        }
 
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:UpdatePanel ID="upadatepanel" runat="server">
        <ContentTemplate>
            <pg:progress ID="progress1" runat="server" />
            <div id="otherdiv" onclick="closediv();">
            </div>
            <div class="pageheader">
                <h2>
                    <i class="fa fa-table"></i>Time & Expense Report by Project & Employee with Cost
                </h2>
                <input type="hidden" id="hidid" runat="server" />
                <div class="breadcrumb-wrapper mar ">
                    <div class="f_right">

                        <asp:LinkButton ID="btnexportcsv" runat="server" OnClick="btnexportcsv_Click" CssClass="right_link">
                        <i class="fa fa-fw fa-file-excel-o topicon"></i>
                        Export to Excel</asp:LinkButton>
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
                                        <h5 class="subtitle mb5">Client Schedule</h5>
                                    </div>
                                    <div class="col-sm-4 col-md-4 f_left mar clear pad4 ">

                                        <asp:TextBox ID="txtfrmdate" runat="server" CssClass="form-control hasDatepicker"></asp:TextBox>

                                        <cc1:CalendarExtender ID="txtDate_CalendarExtender" runat="server" TargetControlID="txtfrmdate"
                                            PopupButtonID="txtfrmdate" Format="MM/dd/yyyy">
                                        </cc1:CalendarExtender>

                                    </div>
                                    <div class="col-sm-6 col-md-4 mar pad5">

                                        <asp:TextBox ID="txttodate" runat="server" CssClass="form-control hasDatepicker"></asp:TextBox>

                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txttodate"
                                            PopupButtonID="txttodate" Format="MM/dd/yyyy">
                                        </cc1:CalendarExtender>

                                    </div>
                                    <div class="col-sm-6 col-md-4  pad4">
                                        <asp:DropDownList ID="drpclient" runat="server" CssClass="form-control mar pad3"
                                            AutoPostBack="true" OnSelectedIndexChanged="drpclient_OnSelectedIndexChanged">
                                        </asp:DropDownList>
                                    </div>
                                    <div class="col-sm-6 col-md-4  pad5">
                                        <asp:DropDownList ID="dropproject" runat="server" CssClass="form-control mar pad3">
                                        </asp:DropDownList>
                                    </div>
                                    <div class="col-sm-6 col-md-4  pad4">
                                        <asp:DropDownList ID="drpemployee" runat="server" CssClass="form-control mar pad3">
                                        </asp:DropDownList>
                                    </div>
                                    <div class="col-sm-6 col-md-4 pad5">
                                        <asp:Button ID="btnsearch" runat="server" CssClass="btn btn-default mar" Text="View Report"
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
                                                <div id="divreport" runat="server">
                                                    <!--Outer Most- CLIENT repeater-->
                                                    <asp:Repeater ID="rptclients" runat="server" OnItemDataBound="rptclients_ItemDataBound">
                                                        <HeaderTemplate>
                                                            <table width="100%" style="padding: 5px;">
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <tr>
                                                                <td class="pad2">
                                                                    <b>Client ID:</b> <span style="color: #EB8806;"><strong><%#Eval("clientcode")%></strong></span> - <%#Eval("clientname")%>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="f_left mar3" style="width: 100%; border-top: 2px solid #959595; border-bottom: 2px solid #959595;">
                                                                    <table class="table">
                                                                        <tr>
                                                                            <th width="100px" style="font-weight: bold; color: #333333;">Date</th>
                                                                            <th style="font-weight: bold; color: #333333;">Description</th>
                                                                            <th width="100px" style="text-align: right; font-weight: bold; color: #333333;">Hrs</th>
                                                                            <th width="100px" style="text-align: right; font-weight: bold; color: #333333;">B-Hr/Unit</th>
                                                                            <th width="100px" style="text-align: right; font-weight: bold; color: #333333;">Bill Rate</th>
                                                                            <th width="100px" style="text-align: right; font-weight: bold; color: #333333;">Cost</th>
                                                                            <th width="100px" style="text-align: right; font-weight: bold; color: #333333;">Amount</th>
                                                                        </tr>
                                                                    </table>

                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="margin-bottom: 15px; float: left; width: 100%;">
                                                                    <asp:Repeater ID="rptprojects" runat="server" OnItemDataBound="rptprojects_ItemDataBound">
                                                                        <HeaderTemplate>
                                                                            <table width="100%" cellpadding="5">
                                                                        </HeaderTemplate>
                                                                        <ItemTemplate>
                                                                            <tr>
                                                                                <td class="pad1" style="background: #cccccc;">
                                                                                    <b style="color: #666666;">Project ID: Name (Manager):</b><strong> <%#Eval("projectcode")%></strong> - <span style="color: #B867BF; font-style: italic;"><%#Eval("projectname")%></span> (<span style="color: #0da08b; font-weight: bold;"> <%#Eval("managername")%> </span>)
                                                                                
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td class="pad2">
                                                                                    <span style="color: #309774; font-size: 15px;">Services:
                                                                                    </span>
                                                                                </td>

                                                                            </tr>
                                                                            <tr>
                                                                                <td class="pad1">
                                                                                    <span class="spanemp">Employees:
                                                                                    </span>
                                                                                </td>

                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:Repeater ID="rptemployees" runat="server" OnItemDataBound="rptemployees_ItemDataBound">
                                                                                        <HeaderTemplate>
                                                                                            <table width="100%" cellpadding="5">
                                                                                        </HeaderTemplate>
                                                                                        <ItemTemplate>
                                                                                            <tr>
                                                                                                <td class="pad1">
                                                                                                    <span style="color: #BB0E50; text-transform: uppercase"><strong><%#Eval("loginid")%></strong> </span>- <%#Eval("empname")%></span> 
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <asp:Repeater ID="rpttasks" runat="server" OnItemDataBound="rpttasks_ItemDataBound">
                                                                                                        <HeaderTemplate>
                                                                                                            <table width="100%" class="table">
                                                                                                        </HeaderTemplate>
                                                                                                        <ItemTemplate>
                                                                                                            <tr>
                                                                                                                <td width="100px">
                                                                                                                    <%#Eval("statusdate") %>
                                                                                                                </td>
                                                                                                                <td>
                                                                                                                    <%#Eval("taskdesc") %>
                                                                                                                </td>
                                                                                                                <td width="100px" align="right">
                                                                                                                    <%#Eval("timetaken") %>
                                                                                                                </td>
                                                                                                                <td width="100px" align="right">
                                                                                                                    <%#Eval("bhours") %>
                                                                                                                </td>
                                                                                                                <td width="100px" align="right">$<%#Eval("billrate") %>
                                                                                                                </td>
                                                                                                                <td width="10px" align="right">$<%#Eval("costrate") %>
                                                                                                                </td>
                                                                                                                <td width="100px" align="right">$<%#Eval("amount") %>
                                                                                                                </td>
                                                                                                            </tr>
                                                                                                        </ItemTemplate>
                                                                                                        <FooterTemplate>
                                                                                                            <tr>
                                                                                                                <td width="100px">&nbsp;
                                                                                                                </td>
                                                                                                                <td align="right">
                                                                                                                    <span style="color: #BB0E50; text-transform: uppercase"><strong>
                                                                                                                        <asp:Literal ID="ltrloginid" runat="server"></asp:Literal></strong> </span><strong>Total:</strong>
                                                                                                                </td>
                                                                                                                <td width="100px" align="right" style="border-top: 1px solid #c3c3c3; border-bottom: 1px solid #c3c3c3;">
                                                                                                                    <asp:Literal ID="ltrhrs" runat="server"></asp:Literal>

                                                                                                                </td>
                                                                                                                <td width="100px" align="right" style="border-top: 1px solid #c3c3c3; border-bottom: 1px solid #c3c3c3;">
                                                                                                                    <asp:Literal ID="ltrbhrs" runat="server"></asp:Literal></td>
                                                                                                                <td width="100px" align="right">&nbsp;
                                                                                                                </td>
                                                                                                                <td width="100px" align="right" style="border-top: 1px solid #c3c3c3; border-bottom: 1px solid #c3c3c3;">
                                                                                                                    <asp:Literal ID="ltrcost" runat="server"></asp:Literal>
                                                                                                                </td>
                                                                                                                <td width="100px" align="right" style="border-top: 1px solid #c3c3c3; border-bottom: 1px solid #c3c3c3;">
                                                                                                                    <asp:Literal ID="ltramount" runat="server"></asp:Literal>
                                                                                                                </td>
                                                                                                            </tr>
                                                                                                            </table>
                                                                                                        </FooterTemplate>
                                                                                                    </asp:Repeater>
                                                                                                </td>
                                                                                            </tr>

                                                                                        </ItemTemplate>
                                                                                        <FooterTemplate>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <table width="100%" class="table pad2 mar3">
                                                                                                        <tr>
                                                                                                            <td width="100px">&nbsp;
                                                                                                            </td>
                                                                                                            <td align="right">
                                                                                                                <span style="color: #8a693f;"><strong>Employee</strong> </span><strong>Total:</strong>
                                                                                                            </td>
                                                                                                            <td width="100px" align="right" style="border-top: 1px solid #c3c3c3; border-bottom: 1px solid #c3c3c3;">
                                                                                                                <asp:Literal ID="ltrhrs" runat="server"></asp:Literal>

                                                                                                            </td>
                                                                                                            <td width="100px" align="right" style="border-top: 1px solid #c3c3c3; border-bottom: 1px solid #c3c3c3;">
                                                                                                                <asp:Literal ID="ltrbhrs" runat="server"></asp:Literal></td>
                                                                                                            <td width="100px" align="right">&nbsp;
                                                                                                            </td>
                                                                                                            <td width="100px" align="right" style="border-top: 1px solid #c3c3c3; border-bottom: 1px solid #c3c3c3;">
                                                                                                                <asp:Literal ID="ltrcost" runat="server"></asp:Literal>
                                                                                                            </td>
                                                                                                            <td width="100px" align="right" style="border-top: 1px solid #c3c3c3; border-bottom: 1px solid #c3c3c3;">
                                                                                                                <asp:Literal ID="ltramount" runat="server"></asp:Literal>
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                        <tr>
                                                                                                            <td width="100px">&nbsp;
                                                                                                            </td>
                                                                                                            <td align="right">
                                                                                                                <span style="color: #309774;"><strong>Services</strong> </span><strong>Total:</strong>
                                                                                                            </td>
                                                                                                            <td width="100px" align="right" style="border-top: 1px solid #c3c3c3; border-bottom: 1px solid #c3c3c3;">
                                                                                                                <asp:Literal ID="ltrshrs" runat="server"></asp:Literal>

                                                                                                            </td>
                                                                                                            <td width="100px" align="right" style="border-top: 1px solid #c3c3c3; border-bottom: 1px solid #c3c3c3;">
                                                                                                                <asp:Literal ID="ltrsbhrs" runat="server"></asp:Literal></td>
                                                                                                            <td width="100px" align="right">&nbsp;
                                                                                                            </td>
                                                                                                            <td width="100px" align="right" style="border-top: 1px solid #c3c3c3; border-bottom: 1px solid #c3c3c3;">
                                                                                                                <asp:Literal ID="ltrscost" runat="server"></asp:Literal>
                                                                                                            </td>
                                                                                                            <td width="100px" align="right" style="border-top: 1px solid #c3c3c3; border-bottom: 1px solid #c3c3c3;">
                                                                                                                <asp:Literal ID="ltrsamount" runat="server"></asp:Literal>
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                        <tr>
                                                                                                            <td width="100px">&nbsp;
                                                                                                            </td>
                                                                                                            <td align="right">Project  <span style="color: #b867bf; text-transform: uppercase"><strong>
                                                                                                                <asp:Literal ID="ltrprojectid" runat="server"></asp:Literal></strong> </span><strong>Total:</strong>
                                                                                                            </td>
                                                                                                            <td width="100px" align="right" style="border-top: 1px solid #c3c3c3; border-bottom: 1px solid #c3c3c3;">
                                                                                                                <asp:Literal ID="ltrphrs" runat="server"></asp:Literal>

                                                                                                            </td>
                                                                                                            <td width="100px" align="right" style="border-top: 1px solid #c3c3c3; border-bottom: 1px solid #c3c3c3;">
                                                                                                                <asp:Literal ID="ltrpbhrs" runat="server"></asp:Literal></td>
                                                                                                            <td width="100px" align="right">&nbsp;
                                                                                                            </td>
                                                                                                            <td width="100px" align="right" style="border-top: 1px solid #c3c3c3; border-bottom: 1px solid #c3c3c3;">
                                                                                                                <asp:Literal ID="ltrpcost" runat="server"></asp:Literal>
                                                                                                            </td>
                                                                                                            <td width="100px" align="right" style="border-top: 1px solid #c3c3c3; border-bottom: 1px solid #c3c3c3;">
                                                                                                                <asp:Literal ID="ltrpamount" runat="server"></asp:Literal>
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                    </table>
                                                                                                </td>
                                                                                            </tr>
                                                                                            </table>
                                                                                        </FooterTemplate>
                                                                                    </asp:Repeater>
                                                                                </td>
                                                                            </tr>
                                                                        </ItemTemplate>
                                                                        <FooterTemplate>
                                                                            <tr>
                                                                                <td>
                                                                                    <table width="100%" class="table pad2 mar3">
                                                                                        <tr>
                                                                                            <td width="100px">&nbsp;
                                                                                            </td>
                                                                                            <td align="right">Client <span style="color: #EB8806; text-transform: uppercase"><strong>
                                                                                <asp:Literal ID="ltrclientid" runat="server"></asp:Literal></strong> </span><strong>Total:</strong>
                                                                                            </td>
                                                                                            <td width="100px" align="right" style="border-top: 1px solid #c3c3c3; border-bottom: 1px solid #c3c3c3;">
                                                                                                <asp:Literal ID="ltrhrs" runat="server"></asp:Literal>

                                                                                            </td>
                                                                                            <td width="100px" align="right" style="border-top: 1px solid #c3c3c3; border-bottom: 1px solid #c3c3c3;">
                                                                                                <asp:Literal ID="ltrbhrs" runat="server"></asp:Literal></td>
                                                                                            <td width="100px" align="right">&nbsp;
                                                                                            </td>
                                                                                            <td width="100px" align="right" style="border-top: 1px solid #c3c3c3; border-bottom: 1px solid #c3c3c3;">
                                                                                                <asp:Literal ID="ltrcost" runat="server"></asp:Literal>
                                                                                            </td>
                                                                                            <td width="100px" align="right" style="border-top: 1px solid #c3c3c3; border-bottom: 1px solid #c3c3c3;">
                                                                                                <asp:Literal ID="ltramount" runat="server"></asp:Literal>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            </table>
                                                                        </FooterTemplate>
                                                                    </asp:Repeater>
                                                                </td>
                                                            </tr>
                                                        </ItemTemplate>
                                                        <FooterTemplate>
                                                            <tr>
                                                                <td>
                                                                    <table width="100%" class="table pad2 mar3">
                                                                        <tr>
                                                                            <td width="100px">&nbsp;
                                                                            </td>
                                                                            <td align="right"> <span style="color: #EB8806; text-transform: uppercase"><strong>
                                                                                <asp:Literal ID="ltrclientid" runat="server"></asp:Literal></strong> </span><strong>TOTAL:</strong>
                                                                            </td>
                                                                            <td width="100px" align="right" style="border-top: 1px solid #c3c3c3; border-bottom: 1px solid #c3c3c3;">
                                                                                <asp:Literal ID="ltrhrs" runat="server"></asp:Literal>

                                                                            </td>
                                                                            <td width="100px" align="right" style="border-top: 1px solid #c3c3c3; border-bottom: 1px solid #c3c3c3;">
                                                                                <asp:Literal ID="ltrbhrs" runat="server"></asp:Literal></td>
                                                                            <td width="100px" align="right">&nbsp;
                                                                            </td>
                                                                            <td width="100px" align="right" style="border-top: 1px solid #c3c3c3; border-bottom: 1px solid #c3c3c3;">
                                                                                <asp:Literal ID="ltrcost" runat="server"></asp:Literal>
                                                                            </td>
                                                                            <td width="100px" align="right" style="border-top: 1px solid #c3c3c3; border-bottom: 1px solid #c3c3c3;">
                                                                                <asp:Literal ID="ltramount" runat="server"></asp:Literal>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
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
            <input type="hidden" id="hidsearchdroemployee" runat="server" />
            <input type="hidden" id="hidsearchdrpclientname" runat="server" />
            <input type="hidden" id="hidsearchdrpprojectname" runat="server" />
            <input type="hidden" id="hidsearchdroemployeename" runat="server" />


        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
