<%@ Page Title="" Language="C#" MasterPageFile="~/Client/ClientMaster.Master" AutoEventWireup="true" CodeBehind="ProjectStatusReport.aspx.cs" Inherits="empTimeSheet.Client.ProjectStatusReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax" %>
<%@ Register Src="../progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <pg:progress ID="progress1" runat="server" />
    <div class="pageheader">
        <h1>
           Project Status Report
        </h1>
        <div class="breadcrumb-wrapper mar ">
            <asp:LinkButton ID="btnexportcsv" runat="server" OnClick="btnexportcsv_Click" CssClass="right_link">
          <i class="fa fa-fw fa-file-excel-o topicon"></i>Export to Excel</asp:LinkButton>
            <%--  <asp:LinkButton ID="lnkrefresh" runat="server" OnClick="btnrefresh_Click" CssClass="right_link">
            <i  class="fa fa-fw" style="padding-right: 10px; font-size: 12px; border: none;"></i>Refresh</asp:LinkButton>--%>
        </div>
        <div class="clear">
        </div>
    <div class="contentpanel">
        <div class="row">
            <div class="col-sm-12 col-md-12">
                <div class="panel panel-default">
                    <div class="col-sm-6 col-md-4 clear pad4">
                        <asp:DropDownList ID="dropproject" runat="server" CssClass="input_width3 marright5">
                        </asp:DropDownList>
                    </div>
                    <div class="col-sm-4 col-md-2 pad5">
                        <asp:Button ID="btnsearch" runat="server" Text="Search" CssClass="btn btn-default"
                            OnClick="btnsearch_Click" />
                    </div>
                    <div class="clear">
                    </div>
                    <div class="col-sm-12 col-md-12 mar2">
                        <div class="nodatafound" id="divmsg" runat="server" visible="false">
                            No Module found
                        </div>
                        <div class="clear">
                        </div>
                        <div style="height: 520px; overflow-y: scroll;">
                            <asp:TreeView ID="treemenu" runat="server" CssClass="treeview" Width="99%" ImageSet="Simple"
                                 ShowLines="True" NodeStyle-CssClass="treelink">
                                <HoverNodeStyle CssClass="roothover" />
                                <NodeStyle ImageUrl="images/black_folder.png" VerticalPadding="5" HorizontalPadding="5"
                                    CssClass="nodestyle spantask" />
                                <ParentNodeStyle NodeSpacing="0px" CssClass="spanmodule" />
                                <SelectedNodeStyle CssClass="rootselected" />
                                <RootNodeStyle CssClass="rootnode spanproject" ImageUrl="images/rootnode.png" VerticalPadding="5"
                                    HorizontalPadding="5" />
                            </asp:TreeView>
                            <input id="hidnode" runat="server" type="hidden" />
                            <input id="hidid" runat="server" type="hidden" />
                            <input type="hidden" id="hidparent" runat="server" value="0" />
                        </div>
                    </div>
                </div>
                <div class="clear">
                </div>
            </div>
        </div>
    </div>
</asp:Content>
