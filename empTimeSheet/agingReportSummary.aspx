<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="agingReportSummary.aspx.cs" Inherits="empTimeSheet.agingReportSummary" %>

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
        .widthclass {text-align:right;
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
                    <i class="fa fa-table"></i>Aging Report Summary
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
                                    <div class="clear col-sm-6 col-md-4 pad4">
                                        <%-- <asp:CustomValidator ID="req1" runat="server" ClientValidationFunction="validatereport" ValidationGroup="search" ErrorMessage="Select a client or project!"></asp:CustomValidator>--%>
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

                                    <div class="col-sm-6 col-md-4 pad4">
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

                                                <div id="divreport" runat="server" class="mainrptdiv" visible="false">
                                                    <asp:GridView ID="dgnews" runat="server" AllowPaging="true" AutoGenerateColumns="False"
                                                        PageSize="50" CellPadding="4" CellSpacing="0"
                                                        BorderWidth="0px" Width="100%" ShowHeader="true" ShowFooter="false" CssClass="table table-success mb30"
                                                        GridLines="None" BorderStyle="None" AllowSorting="true" OnPageIndexChanging="dgnews_PageIndexChanging"
                                                        OnRowDataBound="dgnews_RowDataBound" OnSorting="dgnews_Sorting" OnRowCreated="dgnews_RowCreated">
                                                        <Columns>

                                                            <asp:TemplateField HeaderText="Client ID" SortExpression="code" HeaderStyle-Width="12%" ItemStyle-Width="12%">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "code")%>
                                                                </ItemTemplate>
                                                               
                                                           
                                                                
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Company" SortExpression="company" HeaderStyle-Width="28%" ItemStyle-Width="28%">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "company")%>
                                                                </ItemTemplate>
                                                                 
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Current"  SortExpression="currentamt" HeaderStyle-Width="12%" ItemStyle-Width="12%" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                                                                <ItemTemplate>
                                                                    $<%# DataBinder.Eval(Container.DataItem, "currentamt")%>
                                                                </ItemTemplate>
                                                                <HeaderStyle CssClass="widthclass" />
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="31 To 60" SortExpression="amount1" HeaderStyle-Width="12%" ItemStyle-Width="12%" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                                                                <ItemTemplate>
                                                                    $<%# DataBinder.Eval(Container.DataItem, "amount1")%>
                                                                </ItemTemplate>
                                                                  <HeaderStyle CssClass="widthclass" />
                                                            </asp:TemplateField>

                                                            <asp:TemplateField HeaderText="61 To 90" SortExpression="amount2" HeaderStyle-Width="12%" ItemStyle-Width="12%" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                                                                <ItemTemplate>
                                                                    $<%# DataBinder.Eval(Container.DataItem, "amount2")%>
                                                                </ItemTemplate>
                                                                 <HeaderStyle CssClass="widthclass" />
                                                            </asp:TemplateField>


                                                            <asp:TemplateField HeaderText=">>90" SortExpression="amount3" HeaderStyle-Width="12%" ItemStyle-Width="12%" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                                                                <ItemTemplate>
                                                                    $<%# DataBinder.Eval(Container.DataItem, "amount3")%>
                                                                </ItemTemplate>
                                                                 <HeaderStyle CssClass="widthclass" />
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Balance" SortExpression="balance" HeaderStyle-Width="12%" ItemStyle-Width="12%" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                                                                <ItemTemplate>
                                                                    $<%# DataBinder.Eval(Container.DataItem, "balance")%>
                                                                </ItemTemplate>
                                                                    <HeaderStyle CssClass="widthclass" />
                                                            </asp:TemplateField>

                                                        </Columns>
                                                        <EmptyDataTemplate>
                                                            
                                                        </EmptyDataTemplate>
                                                        <HeaderStyle CssClass="gridheader" />
                                                        <RowStyle CssClass="odd"  />
                                                        
                                                        <AlternatingRowStyle CssClass="even" />
                                                        <EmptyDataRowStyle CssClass="nodatafound" />
                                                        <PagerStyle CssClass="gridpager" HorizontalAlign="Center" />
                                                    </asp:GridView>

                                                    <table width="100%" cellpadding="4" cellspacing="0" class="table table-success mb30">
                                                        <tr>
                                                           <th style="width:12%;"></th>
                                                            <th   align="rignt" style="text-align:right;width:28%;text-align:right;">Grand Total</th>
                                                            <th align="rignt" style="width:12%;text-align:right;">
                                                                <asp:Literal ID="litCurrent" runat="server"></asp:Literal>
                                                            </th>
                                                            <th align="rignt" style="width:12%;text-align:right;">
                                                                <asp:Literal ID="litamount1" runat="server"></asp:Literal>
                                                            </th>
                                                            <th align="rignt" style="width:12%;text-align:right;">
                                                                <asp:Literal ID="litamount2" runat="server"></asp:Literal>
                                                            </th>
                                                            <th align="rignt" style="width:12%;text-align:right;">
                                                                <asp:Literal ID="litamount3" runat="server"></asp:Literal>
                                                            </th>
                                                            <th align="rignt" style="width:12%;text-align:right;">
                                                                <asp:Literal ID="litbalance" runat="server"></asp:Literal>
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
            <input type="hidden" id="hidsearchfromdate" runat="server" />
            <input type="hidden" id="hidsearchtodate" runat="server" />
            <input type="hidden" id="hidsearchdrpclient" runat="server" />
            <input type="hidden" id="hidsearchdrpproject" runat="server" />

            <input type="hidden" id="hidsearchdrpclientname" runat="server" />
            <input type="hidden" id="hidsearchdrpprojectname" runat="server" />

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

