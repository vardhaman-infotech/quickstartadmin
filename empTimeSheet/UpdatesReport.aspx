<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="UpdatesReport.aspx.cs" Inherits="empTimeSheet.UpdatesReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="otherdiv" onclick="closediv();">
    </div>
    <div class="pageheader">
        <h2>
            <i class="fa fa-desktop"></i>Updates Report
        </h2>
        <div class="breadcrumb-wrapper mar ">
            <input type="hidden" id="hidid" runat="server" />
            <asp:LinkButton ID="btnexportcsv" runat="server" CssClass="right_link" OnClick="btnexportcsv_Click">
            <i class="fa fa-fw fa-file-excel-o topicon"></i>Export to Excel</asp:LinkButton>
        </div>
        <div class="clear">
        </div>
        <pg:progress ID="progress1" runat="server" />
    </div>
    <div class="contentpanel">
        <div class="row">
            <div class="col-sm-12 col-md-12">
                <div class="panel panel-default">
                    <div class="col-sm-12 col-md-10">
                        <div style="padding-top: 10px;">
                            <div class="col-xs-12 col-sm-8 col-md-6 f_left" style="padding: 0px;">
                                <h5 class="subtitle mb5">Updates Report</h5>
                            </div>
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl lbl2"> Task Status : </label>

                                <asp:TextBox ID="txtfromdate" runat="server" placeholder="From Date" CssClass="form-control hasDatepicker"></asp:TextBox>

                                <cc1:CalendarExtender ID="txtDate_CalendarExtender" runat="server" TargetControlID="txtfromdate"
                                    PopupButtonID="txtfromdate" Format="MM/dd/yyyy">
                                </cc1:CalendarExtender>

                            </div>
                            <div class="col-sm-6 col-md-4  pad5">

                                <asp:TextBox ID="txttodate" runat="server" placeholer="To Date" CssClass="form-control hasDatepicker"></asp:TextBox>

                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txttodate"
                                    PopupButtonID="txttodate" Format="MM/dd/yyyy">
                                </cc1:CalendarExtender>

                            </div>
                            <div class="col-sm-6 col-md-4  pad4">
                                <asp:DropDownList ID="dropclient" runat="server" CssClass="form-control mar pad3"
                                    AutoPostBack="true" OnSelectedIndexChanged="dropclient_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>
                            <div class="col-sm-6 col-md-4  pad5">
                                <asp:DropDownList ID="dropserver" runat="server" CssClass="form-control mar pad3">
                                </asp:DropDownList>
                            </div>
                            <div class="col-sm-6 col-md-4 pad4">
                                <asp:Button ID="btnsearch" runat="server" CssClass="btn btn-default mar" Text="View Report"
                                    OnClick="btnsearch_click" />
                            </div>
                        </div>
                    </div>
                    <div class="clear">
                    </div>
                    <div class="col-sm-12 col-md-12 mar2">
                        <div class="f_right">
                            <span class="f_left">
                                <asp:LinkButton ID="lnkprevious" runat="server"> <i class="fa fa-fw fa-fast-backward color_green"></i></asp:LinkButton>
                            </span>
                            <p class="f_left page">
                                <asp:Label ID="lblstart" runat="server"></asp:Label>
                                -
                                <asp:Label ID="lblend" runat="server"></asp:Label>
                                of <strong>
                                    <asp:Label ID="lbltotalrecord" Font-Bold="true" runat="server"></asp:Label></strong>
                            </p>
                            <span class="f_left">
                                <asp:LinkButton ID="lnknext" runat="server">  <i class="fa fa-fw fa-fast-forward color_green"></i></asp:LinkButton>
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
                                        <asp:GridView ID="dgnews" runat="server" AllowPaging="true" AutoGenerateColumns="false"
                                            CellPadding="4" CellSpacing="0" BorderWidth="0px" Width="100%" ShowHeader="true"
                                            ShowFooter="false" CssClass="table table-success mb30" GridLines="None" PageSize="50"
                                            OnPageIndexChanging="dgnews_PageIndexChanging">
                                            <Columns>
                                                <asp:TemplateField HeaderText="S.No." ItemStyle-Width="45px">
                                                    <ItemTemplate>
                                                        <%# Container.DataItemIndex + 1 %>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="ClientName" ItemStyle-Width="20%">
                                                    <ItemTemplate>
                                                        <%# DataBinder.Eval(Container.DataItem, "clientname")%>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Server ID" ItemStyle-Width="10%">
                                                    <ItemTemplate>
                                                        <%# DataBinder.Eval(Container.DataItem, "servercode")%>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Server Name" ItemStyle-Width="15%">
                                                    <ItemTemplate>
                                                        <%# DataBinder.Eval(Container.DataItem, "servername")%>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Date" ItemStyle-Width="10%">
                                                    <ItemTemplate>
                                                        <%# DataBinder.Eval(Container.DataItem, "date")%>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Update Summary">
                                                    <ItemTemplate>
                                                        <%# DataBinder.Eval(Container.DataItem, "UpdateSummary")%>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                            <HeaderStyle CssClass="gridheader" />
                                            <PagerStyle CssClass="gridpager" HorizontalAlign="Center" />
                                        </asp:GridView>
                                    </div>
                                </div>
                                <!-- row -->
                            </div>
                            <!--  panel-body  -->
                        </div>
                    </div>
                    <div class="clear">
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
