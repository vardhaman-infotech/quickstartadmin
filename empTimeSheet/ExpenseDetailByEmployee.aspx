<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="ExpenseDetailByEmployee.aspx.cs" Inherits="empTimeSheet.ExpenseDetailByEmployee" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .gridpager table td {
            background-color: transparent !important;
            border: medium none;
            color: #d9534f;
            font-size: 13px;
            font-weight: lighter !important;
            padding: 3px;
            text-shadow: 1px 1px #ffffff;
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
                    <i class="fa fa-table"></i>Expense Detail by Employee
                </h2>
                <input type="hidden" id="hidid" runat="server" />
                <div class="breadcrumb-wrapper mar ">
                    <div class="f_right">


                        <asp:LinkButton ID="lbtnpdf" runat="server" OnClick="btnexportpdf_Click"
                            CssClass="right_link" Enabled="false"><i class="fa fa-fw"
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
                                        <h5 class="subtitle mb5">Expense Detail by Employee</h5>
                                    </div>
                                    <div class="clear col-sm-6 col-md-4 pad4">
                                        <asp:CustomValidator ID="req1" runat="server" ClientValidationFunction="validatereport" ValidationGroup="search" ErrorMessage="Select a client or project!"></asp:CustomValidator>
                                    </div>
                                    <div class="clear"></div>
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
                                        <asp:Button ID="btnsearch" runat="server" CssClass="btn btn-default mar" Text="View Report" ValidationGroup="search"
                                            OnClick="btnsearch_click" />
                                    </div>

                                </div>
                            </div>
                            <div class="col-sm-12 col-md-12 mar2">
                                <div class="f_right">
                                    <asp:LinkButton ID="lnkprevious" CssClass="f_left" runat="server" OnClick="lnkprevious_Click">
            <i class="fa fa-fw fa-fast-backward color_green"></i></asp:LinkButton>
                                    </span>
                                    <div class="f_left page">
                                        <asp:Label ID="lblstart" runat="server"></asp:Label>
                                        -
                                        <asp:Label ID="lblend" runat="server"></asp:Label>
                                        of <strong>
                                            <asp:Label ID="lbltotalrecord" Font-Bold="true" runat="server"></asp:Label></strong>
                                    </div>
                                    <asp:LinkButton ID="lnknext" CssClass="f_left" runat="server" OnClick="lnknext_Click"><i class="fa fa-fw fa-fast-forward color_green"></i></asp:LinkButton>
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
                                                    <div id="ltrreporthead" runat="server" class="hide"></div>
                                                    <!--Outer Most- CLIENT repeater-->
                                                    <asp:GridView ID="rptEmployee" runat="server" OnRowDataBound="rptEmployee_ItemDataBound" AllowPaging="true" AutoGenerateColumns="False"
                                                        CellPadding="0" CellSpacing="0" Width="100%" ShowHeader="false" PageSize="1" ShowFooter="false"
                                                        GridLines="None" OnPageIndexChanging="dgnews_PageIndexChanging">
                                                        <Columns>

                                                            <asp:TemplateField ItemStyle-Width="100%">
                                                                <ItemTemplate>
                                                                    <table width="100%" cellpadding="0" cellspacing="0" class="table">
                                                                        <tr>
                                                                            <td colspan="8">
                                                                                <span style="color: #BB0E50;"><strong>
                                                                                    <%#Eval("loginid")%></strong></span> - <%#Eval("empname")%>
                                                                            </td>
                                                                        </tr>
                                                                        <tr bgcolor="#999191">
                                                                            <th width="8%" style="font-weight: bold; color: #000000; font-size: 9pt; font-family: calibri; padding: 6px; vertical-align: top;">Date</th>
                                                                            <th width="12%" style="font-weight: bold; color: #000000; font-size: 9pt; font-family: calibri; padding: 6px; vertical-align: top;">Project ID</th>
                                                                            <th style="font-weight: bold; color: #000000; font-size: 9pt; font-family: calibri; padding: 6px; vertical-align: top;">Description</th>

                                                                            <th width="8%" style="text-align: left; font-weight: bold; color: #000000; font-size: 9pt; font-family: calibri; padding: 6px; vertical-align: top;">Units</th>
                                                                            <th width="10%" style="text-align: left; font-weight: bold; color: #000000; font-size: 9pt; font-family: calibri; padding: 6px; vertical-align: top;">Cost Rate</th>
                                                                            <th width="10%" style="text-align: left; font-weight: bold; color: #000000; font-size: 9pt; font-family: calibri; padding: 6px; vertical-align: top;">Reimb Cost</th>
                                                                            <th width="8%" style="text-align: left; font-weight: bold; color: #000000; font-size: 9pt; font-family: calibri; padding: 6px; vertical-align: top;">MU%</th>
                                                                            <th width="8%" style="text-align: left; font-weight: bold; color: #000000; font-size: 9pt; font-family: calibri; padding: 6px; vertical-align: top;">Amount</th>
                                                                            
                                                                        </tr>

                                                                        <asp:Repeater ID="rptprojects" runat="server" OnItemDataBound="rptprojects_ItemDataBound">
                                                                            <HeaderTemplate>
                                                                            </HeaderTemplate>
                                                                            <ItemTemplate>
                                                                                <asp:Literal ID="ltrprojectdetails" runat="server" Text='<%#Eval("details")%>'>
                                                                                </asp:Literal>
                                                                            </ItemTemplate>
                                                                            <FooterTemplate>
                                                                            </FooterTemplate>
                                                                        </asp:Repeater>


                                                                    </table>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>


                                                        </Columns>
                                                        <PagerStyle CssClass="gridpager" HorizontalAlign="Center" />
                                                    </asp:GridView>
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
