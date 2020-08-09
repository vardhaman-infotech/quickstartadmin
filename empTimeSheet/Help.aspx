<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="Help.aspx.cs" Inherits="empTimeSheet.Help" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="Stylesheet" href="css/tab_2.0.css" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="pageheader">
        <h2>
            <i class="fa fa-user"></i>Help
        </h2>
        <div class="breadcrumb-wrapper">
        </div>
        <div class="clear">
        </div>
    </div>
    <input type="hidden" id="hidid" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <pg:progress ID="progress1" runat="server" />
            <div class="contentpanel">
                <div class="row">
                    <div class="col-sm-4 col-md-3">
                        <div class="panel panel-default">
                            <div class="panel-body">
                                <h5 class="subtitle mb5">
                                    Search Help</h5>
                                <asp:TextBox ID="txtkeywords" runat="server" placeholder="search by keyword" CssClass="search_btn"></asp:TextBox>
                                <cc1:AutoCompleteExtender ID="AutoCompleteExtender1" EnableCaching="true" BehaviorID="AutoCompleteCities"
                                    TargetControlID="txtkeywords" ServiceMethod="getTopic" MinimumPrefixLength="2"
                                    ContextKey="getTopic" CompletionSetCount="2" runat="server" FirstRowSelected="true"
                                    CompletionInterval="350">
                                </cc1:AutoCompleteExtender>
                                <asp:Button ID="btnsearch" runat="server" Text="Search" CssClass="button" Style="display: none;"
                                    OnClick="btnsearch_Click" />
                                <div class="clear">
                                </div>
                                <h5 class="color">
                                    Help Topics
                                </h5>
                                <!--Left side -Help Topics Section-->
                                <asp:Repeater ID="Repeater1" runat="server" OnItemCommand="Repeater1_ItemCommand"
                                    OnItemDataBound="Repeater1_ItemDataBound">
                                    <HeaderTemplate>
                                        <ul class="search_list search_list1">
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <li class="odd" id="helpli" runat="server">
                                            <asp:LinkButton ID="lbtnli" runat="server" CommandArgument='<%#Eval("nid") + ";" +  Eval("topic") %>'
                                                CommandName="view"><%#DataBinder.Eval(Container.DataItem,"topic")%></asp:LinkButton>
                                            <input type="hidden" id="hidnid" runat="server" value='<%#Eval("nid")%>' />
                                        </li>
                                    </ItemTemplate>
                                    <AlternatingItemTemplate>
                                        <li class="even" id="helpli" runat="server">
                                            <asp:LinkButton ID="lbtnli" runat="server" CommandArgument='<%#Eval("nid") + ";" +  Eval("topic") %>'
                                                CommandName="view"><%#DataBinder.Eval(Container.DataItem,"topic")%></asp:LinkButton>
                                            <input type="hidden" id="hidnid" runat="server" value='<%#Eval("nid")%>' />
                                        </li>
                                    </AlternatingItemTemplate>
                                    <FooterTemplate>
                                        </ul></FooterTemplate>
                                </asp:Repeater>
                                
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-8 col-md-9">
                        <div class="panel panel-default">
                            <div class="panel-body3">
                                <div class="row">
                                    <div class="col-sm-12 col-md-12">
                                        <div id="divnodatafound" runat="server" class="nodatafound">
                                        </div>
                                        <asp:Repeater ID="Repeater2" runat="server" OnItemCommand="Repeater2_ItemCommand">
                                            <HeaderTemplate>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lbtnli" runat="server" CommandArgument='<%#Eval("nid") + ";" +  Eval("category")%>'
                                                    CommandName="view">  <h2 style="color:#575757;margin-bottom:10px;"><%#DataBinder.Eval(Container.DataItem,"topic")%> 
                    </h2>  </asp:LinkButton>
                                                <div class="line_help">
                                                </div>
                                                <div class="white_base">
                                                    <p>
                                                        <%#DataBinder.Eval(Container.DataItem,"description")%>
                                                    </p>
                                                </div>
                                            </ItemTemplate>
                                            <FooterTemplate>
                                            </FooterTemplate>
                                        </asp:Repeater>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
