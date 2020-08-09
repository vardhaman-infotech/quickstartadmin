<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="assset_MyAssets.aspx.cs" Inherits="empTimeSheet.assset_MyAssets" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .form-control1 {
            border-radius: 0px;
            box-shadow: none;
        }
    </style>
    <link rel="Stylesheet" href="css/tab_2.0.css" type="text/css" />

    <link rel="stylesheet" href="css/jquery-ui.css" />
    <script type="text/javascript" src="js/jquery-ui.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <pg:progress ID="progress1" runat="server" />
    <div class="pageheader">
        <h2>
            <i class="fa fa-tasks"></i>My Assets 
        </h2>
        <div class="breadcrumb-wrapper mar ">
            <%-- <a id="liaddnew" runat="server" class="right_link"><i class="fa fa-fw fa-plus topicon"></i>Add New</a>--%>
            <%--            <asp:LinkButton ID="btnexportcsv" runat="server" CssClass="right_link">
              <i class="fa fa-fw fa-file-excel-o topicon"></i>Export to Excel
            </asp:LinkButton>--%>
            <%-- <a id="lnkrefresh" class="right_link" ><i class="fa fa-fw fa-refresh topicon"></i>Refresh</a>--%>
            <asp:LinkButton ID="lnkrefresh" runat="server" CssClass="right_link">
            <i class="fa fa-fw fa-refresh topicon"></i>Refresh</asp:LinkButton>
        </div>
        <div class="clear">
        </div>
    </div>
    <div class="contentpanel">
        <div class="row">
            <div class="col-sm-12 col-md-12">
                <div class="panel panel-default">
                    <asp:UpdatePanel ID="updatePanelData" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="false">
                        <ContentTemplate>
                            <div id="otherdiv" onclick="closediv();">
                            </div>
                            <div class="col-sm-12 col-md-12 mar2 clear" style="min-height: 500px">
                                <div>
                                    <div class="col-xs-12 col-sm-8 col-md-6  f_left" style="padding: 0px;">
                                        <h5 class="subtitle mb5">My Assets</h5>
                                    </div>
                                    <div class="col-sm-2 col-md-2 f_left pad4  mar clear">
                                        <asp:DropDownList ID="DropSearchCategory" runat="server" CssClass="form-control">
                                        </asp:DropDownList>
                                    </div>
                                    <div class="col-sm-2 col-md-2 f_left pad5 mar">
                                        <asp:TextBox ID="txtSearchAsset" runat="server" CssClass="form-control" placeholder="Asset Name "></asp:TextBox>
                                    </div>

                                    <div class="col-sm-2 col-md-2 f_left pad5 mar">
                                        <asp:DropDownList ID="DropSearchDepartment" runat="server" CssClass="form-control">
                                        </asp:DropDownList>
                                    </div>

                                    <%-- <div class="col-sm-4 col-md-4 f_left pad4 mar clear">
                                <asp:DropDownList ID="DropSearchLocation" runat="server" CssClass="form-control pad3">
                                </asp:DropDownList>
                            </div>--%>

                                    <div class="col-sm-2 col-md-2 f_left pad5 mar">
                                        <asp:Button ID="btnsearch" runat="server" Text="Search" CssClass="btn btn-default " OnClick="btnsearch_Click" />
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
                                                    CellPadding="4" CellSpacing="0" BorderWidth="0px"
                                                    PageSize="50" Width="100%" ShowHeader="true" ShowFooter="false" CssClass="table table-success mb30"
                                                    GridLines="None" BorderStyle="None" AllowSorting="true" OnPageIndexChanging="dgnews_PageIndexChanging">
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="S.No." ItemStyle-Width="50px">
                                                            <ItemTemplate>
                                                                <%# Container.DataItemIndex + 1 %>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Asset Code" SortExpression="assetcode">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "assetcode")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Asset Name" SortExpression="assetName">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "assetName")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                        <asp:TemplateField HeaderText="Category" SortExpression="categoryname">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "categoryname")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Transfer On">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "transferedon")%>
                                                                Transfered By: <span style="color: #1caf9a;"><%# DataBinder.Eval(Container.DataItem, "transferBy")%></span>
                                                            </ItemTemplate>

                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Due Date" SortExpression="Due Date">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "duedate")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                        <asp:TemplateField HeaderText="Department">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "departmentname")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>


                                                        <asp:TemplateField HeaderText="Condition" ItemStyle-Width="80px">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "name")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                    </Columns>
                                                    <EmptyDataTemplate>
                                                        No Asset
                                                    </EmptyDataTemplate>
                                                    <HeaderStyle CssClass="gridheader" />
                                                    <RowStyle CssClass="odd" />
                                                    <AlternatingRowStyle CssClass="even" />
                                                    <EmptyDataRowStyle CssClass="nodatafound" />
                                                </asp:GridView>

                                                <%-- <table id="dgnews" class="table table-success mb30" cellpadding="4" cellspacing="0"
                                                    width="100%">
                                                </table>--%>

                                                <%--<div id="divloadmore" style="display: none; text-align: center;">
                                                    <img src="images/loading.gif" />
                                                </div>--%>
                                            </div>
                                        </div>
                                        <!-- row -->
                                    </div>
                                    <!--  panel-body  -->
                                </div>

                            </div>
                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="btnsearch" EventName="Click" />
                            <asp:AsyncPostBackTrigger ControlID="lnkrefresh" EventName="Click" />
                        </Triggers>
                    </asp:UpdatePanel>
                    <div class="clear">
                    </div>
                    <input type="hidden" id="hiduserid" runat="server" />
                    <input type="hidden" id="hidempid" runat="server" />
                    <!-- col-sm-9 -->
                    <div class="clear">
                    </div>
                </div>
                <!-- panel -->
            </div>
        </div>
    </div>
</asp:Content>
