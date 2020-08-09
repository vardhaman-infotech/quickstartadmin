<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="BudgetedReport.aspx.cs" Inherits="empTimeSheet.BudgetedReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <pg:progress ID="progress1" runat="server" />
    <div class="pageheader">
        <h2>
            <i class="fa fa-clipboard"></i>Budgeted Task Report
        </h2>
        <div class="breadcrumb-wrapper mar ">
            <asp:LinkButton ID="btnexportcsv" runat="server" OnClick="btnexportcsv_Click" CssClass="right_link">
            <i class="fa fa-fw fa-file-excel-o topicon"></i>Export to Excel</asp:LinkButton>
            <asp:LinkButton ID="lnkrefresh" runat="server" OnClick="btnrefresh_Click" CssClass="right_link">
            <i class="fa fa-fw fa-refresh topicon"></i>Refresh</asp:LinkButton>
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
                                <h5 class="subtitle mb5">Budgeted Task Report</h5>
                            </div>

                            <div class="col-sm-6 col-md-4 clear  pad4">
                                <asp:DropDownList ID="dropdeptsearch" runat="server" CssClass="form-control mar">
                                </asp:DropDownList>
                            </div>
                            <div class="col-sm-6 col-md-4 pad5">
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
                                <div class="f_right" style="padding-top: 10px;">
                                    <span class="f_left">
                                        <asp:LinkButton ID="lnkprevious" runat="server" OnClick="lnkprevious_Click"> <i class="fa fa-fw fa-fast-backward color_green"></i></asp:LinkButton>
                                    </span>
                                    <p class="f_left page">
                                        <asp:Label ID="lblstart" runat="server"></asp:Label>
                                        -
                                    <asp:Label ID="lblend" runat="server"></asp:Label>
                                        of <strong>
                                            <asp:Label ID="lbltotalrecord" Font-Bold="true" runat="server"></asp:Label></strong>
                                    </p>
                                    <span class="f_left">
                                        <asp:LinkButton ID="lnknext" runat="server" OnClick="lnknext_Click">  <i class="fa fa-fw fa-fast-forward color_green"></i></asp:LinkButton>
                                    </span>
                                </div>
                                <div class="clear">
                                </div>

                                <div class="panel panel-default">
                                    <div class="panel-body2 ">
                                        <div class="row">
                                            <div class="table-responsive">
                                                <div class="nodatafound" id="divnodata" runat="server">
                                                    No data found
                                                </div>
                                                <asp:GridView ID="dgnews" runat="server" AllowPaging="true" AutoGenerateColumns="False"
                                                    CellPadding="4" CellSpacing="0" Width="100%" ShowHeader="true" PageSize="50"
                                                    ShowFooter="false" CssClass="table table-success mb30" GridLines="None" AllowSorting="true" OnPageIndexChanging="dgnews_PageIndexChanging" OnSorting="dgnews_Sorting">
                                                    <Columns>
                                                        <%-- <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="42px" ItemStyle-CssClass="tdsno"
                                            HeaderStyle-CssClass="tdsno">
                                            <ItemTemplate>
                                                <%# Container.DataItemIndex + 1 %>
                                            </ItemTemplate>
                                        </asp:TemplateField>--%>
                                                        <asp:TemplateField HeaderText="Act ID" HeaderStyle-Width="12%" SortExpression="taskcodename">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "taskcodename")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Description">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "description")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Hours/Units" HeaderStyle-Width="10%" SortExpression="empname">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "Bhours")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Rate" HeaderStyle-Width="10%">
                                                            <ItemTemplate>

                                                               $<%# DataBinder.Eval(Container.DataItem, "BillRate")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Tax" HeaderStyle-Width="10%">
                                                            <ItemTemplate>
                                                                $<%# DataBinder.Eval(Container.DataItem, "tax")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Amount" HeaderStyle-Width="10%">
                                                            <ItemTemplate>
                                                                $<%# DataBinder.Eval(Container.DataItem, "billamount")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                    </Columns>
                                                    <HeaderStyle CssClass="gridheader" />
                                                    <PagerStyle CssClass="gridpager" HorizontalAlign="Center" />
                                                </asp:GridView>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="btnsearch" EventName="Click" />
                                <asp:AsyncPostBackTrigger ControlID="lnkrefresh" EventName="Click" />
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
        <input type="hidden" runat="server" id="hiddeptid" />
        <input type="hidden" runat="server" id="hiddeptname" />
    </div>
    <!---contentpanel-->
</asp:Content>

