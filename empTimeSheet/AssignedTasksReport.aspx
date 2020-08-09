<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="AssignedTasksReport.aspx.cs" Inherits="empTimeSheet.AssignedTasksReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <pg:progress ID="progress1" runat="server" />
    <div class="pageheader">
        <h2>
            <i class="fa fa-clipboard"></i> Assigned Tasks Report
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
                                <h5 class="subtitle mb5">Assigned Tasks Report</h5>
                            </div>
                            <div class="col-sm-4 col-md-4 f_left clear pad4 ">

                                <asp:TextBox ID="txtfromdate" runat="server" placeholder="From Date" CssClass="form-control hasDatepicker"></asp:TextBox>

                                <cc1:CalendarExtender ID="cc1" runat="server" TargetControlID="txtfromdate" PopupButtonID="txtfromdate"
                                    Format="MM/dd/yyyy">
                                </cc1:CalendarExtender>

                            </div>
                            <div class="col-sm-6 col-md-4  pad5">

                                <asp:TextBox ID="txttodate" runat="server" placeholder="To Date" CssClass="form-control hasDatepicker"></asp:TextBox>

                                <cc1:CalendarExtender ID="cc2" runat="server" TargetControlID="txttodate" PopupButtonID="txttodate"
                                    Format="MM/dd/yyyy">
                                </cc1:CalendarExtender>

                            </div>
                            <div class="col-sm-6 col-md-4  pad4">
                                <asp:DropDownList ID="dropemployee" runat="server" CssClass="form-control mar pad3">
                                </asp:DropDownList>
                            </div>
                            <asp:UpdatePanel ID="updatePanelSearch" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <div class="col-sm-6 col-md-4  pad5">
                                        <asp:DropDownList ID="dropclient" runat="server" CssClass="form-control mar pad3"
                                            AutoPostBack="true" OnSelectedIndexChanged="dropclient_OnSelectedIndexChanged">
                                        </asp:DropDownList>
                                    </div>
                                    <div class="col-sm-6 col-md-4  pad4">
                                        <asp:DropDownList ID="dropproject" runat="server" CssClass="form-control mar pad3">
                                        </asp:DropDownList>
                                    </div>
                                </ContentTemplate>
                            </asp:UpdatePanel>

                            <div class="col-sm-6 col-md-4  pad5">
                                <asp:DropDownList ID="dropassign" runat="server" CssClass="form-control mar pad3">
                                </asp:DropDownList>
                            </div>
                            <div class="col-sm-6 col-md-4 pad4">
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
                                                        <asp:TemplateField HeaderText="AssignDate" HeaderStyle-Width="8%" SortExpression="date">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "date")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="LastUpdated" HeaderStyle-Width="8%">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "LastModifiedDate")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Employee" HeaderStyle-Width="8%" SortExpression="empname">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "empname")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="ProjectID" HeaderStyle-Width="15%" SortExpression="projectCode">
                                                            <ItemTemplate>
                                                                <span title='<%# DataBinder.Eval(Container.DataItem, "projectname")%>'>
                                                                    <%# DataBinder.Eval(Container.DataItem, "projectCode")%></span>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="TaskID" HeaderStyle-Width="10%" SortExpression="taskcodename">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "taskcodename")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Description">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "task")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Remark" HeaderStyle-Width="10%">
                                                            <ItemTemplate>
                                                                <div style="float: left; max-width: 120px; overflow: hidden;" title='<%# DataBinder.Eval(Container.DataItem, "remark")%>'>
                                                                    <%# DataBinder.Eval(Container.DataItem, "remark")%>
                                                                </div>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="B-Hours" HeaderStyle-Width="5%">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "bhours")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="TimeTaken" HeaderStyle-Width="5%">
                                                            <ItemTemplate>
                                                                <asp:Literal ID="ltrhours" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "totalhour")%>'></asp:Literal>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Status" HeaderStyle-Width="8%">
                                                            <ItemTemplate>
                                                                <asp:Literal ID="ltrstatus" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "status")%>'></asp:Literal>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Manager" HeaderStyle-Width="8%">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "managername")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Grade" HeaderStyle-Width="5%">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "grade")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Comments" HeaderStyle-Width="5%">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "comments")%>
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
    </div>
    <style>
         .panel-body2 {
    padding: 0 15px;
    overflow: scroll;
}

    </style>
    <!---contentpanel-->
</asp:Content>
