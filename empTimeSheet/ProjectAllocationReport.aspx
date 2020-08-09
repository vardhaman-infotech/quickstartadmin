<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="ProjectAllocationReport.aspx.cs" Inherits="empTimeSheet.ProjectAllocationReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <pg:progress ID="progress1" runat="server" />
    <div class="pageheader">
        <h2>
            <i class="fa fa-tasks"></i>Project Breakdown Summary  
        </h2>
        <div class="breadcrumb-wrapper mar ">
            <asp:LinkButton ID="btnexportcsv" runat="server" OnClick="btnexportcsv_Click" CssClass="right_link">
          <i class="fa fa-fw fa-file-excel-o topicon"></i>Export to Excel</asp:LinkButton>
            <%--  <asp:LinkButton ID="lnkrefresh" runat="server" OnClick="btnrefresh_Click" CssClass="right_link">
            <i  class="fa fa-fw" style="padding-right: 10px; font-size: 12px; border: none;"></i>Refresh</asp:LinkButton>--%>
        </div>
        <div class="clear">
        </div>
    </div>
    <div class="contentpanel">
        <div class="row">
            <div class="col-sm-12 col-md-12">
                <div class="panel panel-default">
                    <asp:MultiView ID="multiview1" runat="server" ActiveViewIndex="0">
                        <asp:View ID="viewlist" runat="server">
                            <div class="col-sm-12 col-md-10">
                                <div style="padding-top: 10px;">
                                    <div class="col-xs-12 col-sm-12 col-md-12 f_left" style="padding: 0px;">
                                        <h5 class="subtitle mb5">
                                            Projects Summary Report</h5>
                                    </div>
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl2">Project :</label>
                                        <div class="txt w2 mar10">
                                        <asp:DropDownList ID="dropproject" runat="server" CssClass="form-control">
                                        </asp:DropDownList>
                                            </div>
                                    </div>
                                    <div class="ctrlGroup searchgroup">
                                        <asp:Button ID="btnsearch" runat="server" Text="Search" CssClass="btn btn-default"
                                            OnClick="btnsearch_Click" />
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-12 col-md-12 mar2">
                                <%-- <asp:UpdatePanel ID="updatePanelData" runat="server">
                                    <ContentTemplate>--%>
                                <div id="otherdiv" onclick="closediv();">
                                </div>
                                <div class="f_right">
                                    <asp:LinkButton ID="lnkprevious" CssClass="f_left" runat="server" OnClick="lnkprevious_Click">
            <i class="fa fa-fw fa-fast-backward color_green"></i></asp:LinkButton>
                                    <div class="f_left page">
                                        <asp:Label ID="lblstart" runat="server"></asp:Label>
                                        -
                                        <asp:Label ID="lblend" runat="server"></asp:Label>
                                        of <strong>
                                            <asp:Label ID="lbltotalrecord" Font-Bold="true" runat="server"></asp:Label></strong>
                                    </div>
                                    <asp:LinkButton ID="lnknext" CssClass="f_left" runat="server" OnClick="lnknext_Click"> <i class="fa fa-fw fa-fast-forward color_green"></i></asp:LinkButton>
                                </div>
                                <div class="clear">
                                </div>
                                <div class="panel panel-default">
                                    <div class="panel-body2">
                                        <div class="row">
                                            <div class="table-responsive">
                                                <div class="nodatafound" id="divnodata" runat="server">
                                                    No data found</div>
                                                <asp:GridView ID="dgnews" runat="server" AllowPaging="true" AutoGenerateColumns="False"
                                                    PageSize="50" CellPadding="4" CellSpacing="0" Width="100%" ShowHeader="true"
                                                    ShowFooter="false" CssClass="table table-success mb30" GridLines="None" AllowSorting="true"
                                                    OnSorting="dgnews_Sorting" OnRowCommand="dgnews_RowCommand" OnPageIndexChanging="dgnews_PageIndexChanging">
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="40px">
                                                            <ItemTemplate>
                                                                <%# Container.DataItemIndex + 1 %>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Project ID" SortExpression="projectCode">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem, "projectCode")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Project Name" SortExpression="projectname">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem, "projectname")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="No. of Modules" SortExpression="numofmodules">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem, "numofmodules")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Est. Hours" SortExpression="totalesthours">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem, "totalesthours")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Completion %">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem, "percomplete")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderStyle-Width="18px" ItemStyle-HorizontalAlign="Center">
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="lbtnview" CommandName="view" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"projectid")%>'
                                                                    ToolTip="View Details" runat="server"><i class="fa fa-fw" ><img src="images/view.png" /></i>
                                                            
                                                                </asp:LinkButton>
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
                                <%--  </ContentTemplate>
                                    <Triggers>
                             
                                        <asp:PostBackTrigger ControlID="btnsearch" />
                                    </Triggers>
                                </asp:UpdatePanel>--%>
                            </div>
                        </asp:View>
                        <asp:View ID="viewDetails" runat="server">
                            <div class="col-sm-12 col-md-10">
                                <div style="padding-top: 10px;">
                                    <div class="col-xs-12 col-sm-12 col-md-12 f_left" style="padding: 0px;">
                                        <h3 class="mb5" id="ltrprojecttitle" runat="server">
                                        </h3>
                                    </div>
                                </div>
                            </div>
                            <div class="f_right">
                                <asp:LinkButton ID="lbtnback" runat="server" OnClick="btnback_Click" CssClass="f_right"
                                    Style="padding: 10px 25px;"><img src="images/arrow_left.png" alt="Back" /> </asp:LinkButton>
                            </div>
                            <div class="col-sm-12 col-md-12 mar2">
                                <div class="panel panel-default">
                                    <div class="panel-body2">
                                        <div class="row">
                                            <div class="table-responsive">
                                                <div class="nodatafound" id="divnomoduledata" runat="server">
                                                    No data found</div>
                                                <asp:GridView ID="grdmodule" runat="server" AllowPaging="true" AutoGenerateColumns="False"
                                                    PageSize="50" CellPadding="4" CellSpacing="0" Width="100%" ShowHeader="true"
                                                    ShowFooter="false" CssClass="table table-success mb30" GridLines="None" AllowSorting="true"
                                                    OnRowCommand="grdmodule_RowCommand">
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="40px">
                                                            <ItemTemplate>
                                                                <%# Container.DataItemIndex + 1 %>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Module Title" SortExpression="title">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem, "title")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Description" SortExpression="description">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem, "description")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="No. of Tasks" SortExpression="numoftasks">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem, "numoftasks")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Est. Hours" SortExpression="totalesthours">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem, "totalesthours")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Completion %">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem, "percomplete")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderStyle-Width="18px" ItemStyle-HorizontalAlign="Center">
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="lbtnview" CommandName="view" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>'
                                                                    ToolTip="View Details" runat="server"><i class="fa fa-fw" ><img src="images/view.png" /></i>
                                                            
                                                                </asp:LinkButton>
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
                            </div>
                        </asp:View>
                        <asp:View ID="viewTasks" runat="server">
                      <%--   <asp:DataGrid ID="DataGrid1" runat="server" AllowPaging="True" PagerStyle-Mode="numericpages"
                        AllowSorting="true" PageSize="50" GridLines="None" CssClass="" AutoGenerateColumns="False"
                        Width="100%" OnItemCommand="dgnews_ItemCommand" BorderStyle="None" OnItemDataBound="dgnews_ItemDataBound"
                        ShowHeader="false">
                        <Columns>
                            <asp:TemplateColumn HeaderText="Standard">
                                <ItemTemplate>
                                    <div class="standard-detail">
                                        <div title="Click here to see detail" class="listitem fleft" style="cursor: pointer;"
                                            id='divst<%# DataBinder.Eval(Container.DataItem, "standardid")%>' onclick="showdetail(this.id,'divdes_<%# DataBinder.Eval(Container.DataItem, "standardid")%>');">
                                            <div class="standard_code">
                                                <asp:HiddenField ID="hidtsandid" runat="server" Value='<%#DataBinder.Eval(Container.DataItem,"standardid")%>' />
                                                <%#DataBinder.Eval(Container.DataItem, "standardcode")%>
                                            </div>
                                            <div class="standard_detail">
                                                <%#DataBinder.Eval(Container.DataItem, "standardname")%>
                                            </div>
                                           
                                            <div class="standard_percent" style="float:right;">
                                                <%#Eval("percentage")%>%
                                            </div>
                                        </div>
                                    </div>
                                    <div class="clear">
                                    </div>
                                    <div class="divdes" id='divdes_<%# DataBinder.Eval(Container.DataItem, "standardid")%>'>
                                        <div id="dginner" runat="server">
                                        </div>
                                    </div>
                                    <div class="clear">
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                        </Columns>
                        <ItemStyle CssClass="odd" />
                        <PagerStyle CssClass="gridpager" HorizontalAlign="Center" />
                        <AlternatingItemStyle CssClass="even" />
                        <HeaderStyle CssClass="gridHeader" />
                    </asp:DataGrid>--%>
                        </asp:View>
                    </asp:MultiView>
                    <div class="clear">
                    </div>
                </div>
                <div class="clear">
                </div>
            </div>
        </div>
    </div>
    <input type="hidden" id="hidprojectid" runat="server" />
    <input type="hidden" id="hidsearchprojectid" runat="server" />
    <input type="hidden" id="hidcurrentview" runat="server" value="list" />
</asp:Content>
