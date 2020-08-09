<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="ScheduleReport.aspx.cs" Inherits="empTimeSheet.ScheduleReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <pg:progress ID="progress1" runat="server" />
    <div id="otherdiv" onclick="closediv();">
    </div>
    <div class="pageheader">
        <h2>
            <i class="fa fa-clipboard"></i>Client Schedule Report
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
                                <h5 class="subtitle mb5">Schedule Report by Employee and Client</h5>
                            </div>
                            <div class="col-sm-4 col-md-4 f_left mar clear pad4 ">

                                <asp:TextBox ID="txtfrmdate" runat="server" placeholder="From Date" CssClass="form-control hasDatepicker"></asp:TextBox>

                                <cc1:CalendarExtender ID="txtDate_CalendarExtender" runat="server" TargetControlID="txtfrmdate"
                                    PopupButtonID="txtfrmdate" Format="MM/dd/yyyy">
                                </cc1:CalendarExtender>

                            </div>
                            <div class="col-sm-6 col-md-4 mar  pad5">

                                <asp:TextBox ID="txttodate" runat="server" placeholder="To Date" CssClass="form-control hasDatepicker"></asp:TextBox>

                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txttodate"
                                    PopupButtonID="txttodate" Format="MM/dd/yyyy">
                                </cc1:CalendarExtender>

                            </div>
                            <asp:UpdatePanel ID="updatePanelSearch" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <div class="col-sm-6 col-md-4  pad4">
                                        <asp:DropDownList ID="drpclient" runat="server" CssClass="form-control mar pad3"
                                            AutoPostBack="true" OnSelectedIndexChanged="drpclient_OnSelectedIndexChanged">
                                        </asp:DropDownList>
                                    </div>
                                    <div class="col-sm-6 col-md-4  pad5">
                                        <asp:DropDownList ID="dropproject" runat="server" CssClass="form-control mar pad3">
                                        </asp:DropDownList>
                                    </div>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                            <div class="col-sm-6 col-md-4  pad4">
                                <asp:DropDownList ID="drpemployee" runat="server" CssClass="form-control mar pad3">
                                </asp:DropDownList>
                            </div>
                            <div class="col-sm-6 col-md-4  pad5">
                                <asp:DropDownList ID="dropstatus" runat="server" CssClass="form-control mar pad3">
                                    <asp:ListItem Value="">--All Status--</asp:ListItem>
                                    <asp:ListItem>Confirmed by the Client</asp:ListItem>
                                    <asp:ListItem>Non-Confirmed by the Client</asp:ListItem>
                                    <asp:ListItem>All Reservations Made</asp:ListItem>
                                    <asp:ListItem>Re-Schedule</asp:ListItem>
                                    <asp:ListItem>Postponed</asp:ListItem>
                                    <asp:ListItem>Cancelled</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-sm-6 col-md-4 pad4">
                                <asp:Button ID="btnsearch" runat="server" Text="Search" CssClass="btn btn-default mar"
                                    OnClick="btnsearch_Click" />
                            </div>
                        </div>
                    </div>
                    <div class="clear">
                    </div>
                    <div class="col-sm-12 col-md-12 mar2">
                        <div class="f_right">
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
                        <asp:UpdatePanel ID="updatePanelData" runat="server">
                            <ContentTemplate>
                                <div class="panel panel-default">
                                    <div class="panel-body2 ">
                                        <div class="row">
                                            <div class="table-responsive">
                                                <div class="nodatafound" id="divnodata" runat="server">
                                                    No data found
                                                </div>
                                                <asp:GridView ID="dgnews" runat="server" AllowPaging="true" AutoGenerateColumns="False"
                                                    PageSize="50" CellPadding="4" CellSpacing="0" Width="100%" ShowHeader="true"
                                                    ShowFooter="false" CssClass="table table-success mb30" GridLines="None" AllowSorting="true"
                                                    OnSorting="dgnews_Sorting" OnPageIndexChanging="dgnews_PageIndexChanging">
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="48px">
                                                            <ItemTemplate>
                                                                <%# Container.DataItemIndex + 1 %>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Start Date/Time" SortExpression="date">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"date")%>
                                                                <%#DataBinder.Eval(Container.DataItem,"time")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Employee" SortExpression="empname">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"empname")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Client" SortExpression="clientname">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"clientname")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Project" SortExpression="projectname">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"projectname")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Status" HeaderStyle-Width="140px">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"status")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Remark">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"remark")%>
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
