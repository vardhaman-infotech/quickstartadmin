<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="SavedInvoices.aspx.cs" Inherits="empTimeSheet.SavedInvoices" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
 <pg:progress ID="progress1" runat="server" />
    <div class="pageheader">
        <h2>
            <i class="fa fa-file-text"></i>Saved Invoices
        </h2>
        <div class="breadcrumb-wrapper mar ">              
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
                                <h5 class="subtitle mb5">
                                    SAved Invoices</h5>
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
                                            OnSelectedIndexChanged="dropclient_OnSelectedIndexChanged">
                                        </asp:DropDownList>
                                    </div>
                                    <div class="col-sm-6 col-md-4  pad5">
                                        <asp:DropDownList ID="dropproject" runat="server" CssClass="form-control mar">
                                        </asp:DropDownList>
                                    </div>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                            <div class="clear">
                            </div>
                         <%--   <div class="col-sm-6 col-md-4  pad4">
                                <asp:TextBox ID="txtinvno" runat="server" CssClass="form-control mar " placeholder="Search by Invoice No."></asp:TextBox>
                            </div>--%>
                            <div class="col-sm-6 col-md-4 pad4">
                                <asp:Button ID="btnsearch" runat="server" Text="Search" CssClass="btn btn-default mar"
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
                                                    No data found</div>
                                                <asp:GridView ID="dgnews" runat="server" AllowPaging="true" AutoGenerateColumns="False"
                                                    CellPadding="4" CellSpacing="0" Width="100%" ShowHeader="true" PageSize="50"
                                                    ShowFooter="false" CssClass="table table-success mb30" GridLines="None" AllowSorting="true"
                                                    OnPageIndexChanging="dgnews_PageIndexChanging" OnRowDataBound="dgnews_RowDataBound"
                                                    OnRowCommand="dgnews_RowCommand">
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="42px" ItemStyle-CssClass="tdsno"
                                                            HeaderStyle-CssClass="tdsno">
                                                            <ItemTemplate>
                                                                <%# Container.DataItemIndex + 1 %>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                      <%--  <asp:TemplateField HeaderText="Invoice#" HeaderStyle-Width="8%" SortExpression="invoiceno">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "invoiceno")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>--%>
                                                        <asp:TemplateField HeaderText="Date" HeaderStyle-Width="8%" SortExpression="invoicedate">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "invoicedate")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Project ID" HeaderStyle-Width="15%" SortExpression="projectCode">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "projectCode")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Project Name" SortExpression="projectname">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "projectname")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Net Amount" HeaderStyle-Width="10%" SortExpression="totalamount">
                                                            <ItemTemplate>
                                                                <%=strcurrency %><%# DataBinder.Eval(Container.DataItem, "totalamount")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Paid" HeaderStyle-Width="15%">
                                                            <ItemTemplate>
                                                                <%=strcurrency %><%# DataBinder.Eval(Container.DataItem, "amountpaid")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Balance" HeaderStyle-Width="10%">
                                                            <ItemTemplate>
                                                                <%=strcurrency %><%# DataBinder.Eval(Container.DataItem, "dueamount")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                           <asp:TemplateField HeaderText="Created By" HeaderStyle-Width="10%" SortExpression="createdby">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "username")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField ItemStyle-Width="20px" ItemStyle-HorizontalAlign="Center">
                                                            <ItemTemplate>
                                                                <input type="hidden" id="hidnid" runat="server" value='<%#DataBinder.Eval(Container.DataItem,"nid")%>' />
                                                                <asp:LinkButton ID="lbtndelete" CommandName="del" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>'
                                                                    ToolTip="Delete" runat="server" OnClientClick='return confirm("Delete this invoice?");'><i class="fa fa-fw">
                                                            <img src="images/delete.png" alt=""></i></asp:LinkButton>
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
                    <input type="hidden" id="hidfromdate" runat="server" />
                    <input type="hidden" id="hidtodate" runat="server" />
                    <input type="hidden" id="hidclients" runat="server" />
                    <input type="hidden" id="hidprojects" runat="server" />
                     <input type="hidden" id="hidprojectname" runat="server" />
                     <input type="hidden" id="hidclientname" runat="server" />

                </div>
                <!--Panel-default-->
            </div>
            <!---col-sm-12 col-md-12-->
        </div>
        <!---row-->
    </div>
</asp:Content>
