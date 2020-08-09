<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="rpt_InvoiceList.aspx.cs" Inherits="empTimeSheet.rpt_InvoiceList" %>

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

        .widthclass {
            text-align: right;
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
                    <i class="fa fa-table"></i>Invoice List
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
                                        <h5 class="subtitle mb5">Invoice List</h5>
                                    </div>
                                    <div class="col-sm-4 col-md-4 f_left mar clear pad4 ">

                                        <asp:TextBox ID="txtfromdate" runat="server" placeholder="From Date" CssClass="form-control hasDatepicker"></asp:TextBox>

                                        <cc1:CalendarExtender ID="cc1" runat="server" TargetControlID="txtfromdate" PopupButtonID="txtfromdate"
                                            Format="MM/dd/yyyy">
                                        </cc1:CalendarExtender>

                                    </div>
                                    <div class="col-sm-6 col-md-4 mar pad5">

                                        <asp:TextBox ID="txttodate" runat="server" placeholder="To Date" CssClass="form-control hasDatepicker"></asp:TextBox>

                                        <cc1:CalendarExtender ID="cc2" runat="server" TargetControlID="txttodate" PopupButtonID="txttodate"
                                            Format="MM/dd/yyyy">
                                        </cc1:CalendarExtender>

                                    </div>
                                    <asp:UpdatePanel ID="updatePanelSearch" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <div class="col-sm-6 col-md-4  pad4">
                                                <asp:DropDownList ID="dropclient" runat="server" CssClass="form-control mar" AutoPostBack="true"
                                                    OnSelectedIndexChanged="drpclient_OnSelectedIndexChanged">
                                                </asp:DropDownList>
                                            </div>
                                            <div class="col-sm-6 col-md-4  pad5">
                                                <asp:DropDownList ID="dropproject" runat="server" CssClass="form-control mar">
                                                </asp:DropDownList>
                                            </div>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>

                                    <div class="col-sm-6 col-md-4  pad4">
                                        <asp:TextBox ID="txtinvno" runat="server" CssClass="form-control mar " placeholder="Search by Invoice No."></asp:TextBox>
                                    </div>

                                    <div class="col-sm-6 col-md-4 pad5">
                                        <asp:Button ID="btnsearch" runat="server" Text="Search" CssClass="btn btn-default mar"
                                            OnClick="btnsearch_click" />
                                    </div>

                                </div>
                            </div>
                            <div class="col-sm-12 col-md-12 mar2">
                                <div class="f_right" style="display: none;">
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
                                                <div class="nodatafound" id="divnodata" runat="server" visible="false">
                                                    No data found
                                                </div>

                                                <div id="divreport" runat="server" class="mainrptdiv" visible="false">
                                                    <asp:GridView ID="dgnews" runat="server" AllowPaging="false" AutoGenerateColumns="False"
                                                        CellPadding="4" CellSpacing="0"
                                                         Width="100%" ShowHeader="true" ShowFooter="false" CssClass="table table-success "
                                                        GridLines="None"  AllowSorting="true"
                                                        OnRowDataBound="dgnews_RowDataBound" OnSorting="dgnews_Sorting" OnRowCreated="dgnews_RowCreated">
                                                        <Columns>

                                                            <asp:TemplateField HeaderText="Inv. Date" SortExpression="invoicedate" HeaderStyle-Width="10%" ItemStyle-Width="10%">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "invoicedate")%>
                                                                </ItemTemplate>

                                                                 <ItemStyle CssClass="bordercss" />

                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Inv. Number" SortExpression="invoiceno" HeaderStyle-Width="10%" ItemStyle-Width="10%">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "invoiceno")%>
                                                                </ItemTemplate>

                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Contact - Company" SortExpression="clientname" HeaderStyle-Width="28%" ItemStyle-Width="28%">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "clientname")%>
                                                                </ItemTemplate>

                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Project Name" SortExpression="projectname" HeaderStyle-Width="28%" ItemStyle-Width="28%">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "projectname")%>
                                                                </ItemTemplate>

                                                            </asp:TemplateField>

                                                            <asp:TemplateField HeaderText="Gross Billed*" SortExpression="subamount" HeaderStyle-Width="12%" ItemStyle-Width="12%" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                                                                <ItemTemplate>
                                                                    $<%# DataBinder.Eval(Container.DataItem, "subamount")%>
                                                                </ItemTemplate>
                                                                <HeaderStyle CssClass="widthclass" />
                                                            </asp:TemplateField>


                                                            <asp:TemplateField HeaderText="Net Bill Amount" SortExpression="totalamount" HeaderStyle-Width="12%" ItemStyle-Width="12%" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                                                                <ItemTemplate>
                                                                    $<%# DataBinder.Eval(Container.DataItem, "totalamount")%>
                                                                </ItemTemplate>
                                                                <HeaderStyle CssClass="widthclass" />
                                                                  <ItemStyle CssClass="bordercss1" />
                                                            </asp:TemplateField>


                                                        </Columns>
                                                        <EmptyDataTemplate>
                                                        </EmptyDataTemplate>
                                                        <HeaderStyle CssClass="gridheader" />
                                                        <RowStyle CssClass="odd" />

                                                        <AlternatingRowStyle CssClass="even" />
                                                        <EmptyDataRowStyle CssClass="nodatafound" />
                                                        <PagerStyle CssClass="gridpager" HorizontalAlign="Center" />
                                                    </asp:GridView>

                                                    <table width="100%" cellpadding="4" cellspacing="0" class="table table-success mb30">
                                                        <tr>
                                                            <th style="width: 10%;"></th>
                                                            <th style="width: 10%;"></th>
                                                            <th align="rignt" style="text-align: right; width: 28%; text-align: right;"></th>
                                                            <th align="rignt" style="text-align: right; width: 28%; text-align: right;">Grand Total</th>

                                                            <th align="rignt" style="width: 12%; text-align: right;">
                                                                <asp:Literal ID="litamount1" runat="server"></asp:Literal>
                                                            </th>
                                                            <th align="rignt" style="width: 12%; text-align: right;">
                                                                <asp:Literal ID="litamount2" runat="server"></asp:Literal>
                                                            </th>

                                                        </tr>

                                                    </table>
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
            <input type="hidden" id="hidfromdate" runat="server" />
            <input type="hidden" id="hidtodate" runat="server" />
            <input type="hidden" id="hidclients" runat="server" />
            <input type="hidden" id="hidprojects" runat="server" />
            <input type="hidden" id="hidprojectname" runat="server" />
            <input type="hidden" id="hidclientname" runat="server" />

            <input type="hidden" id="hidinvoiceno" runat="server" />

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

