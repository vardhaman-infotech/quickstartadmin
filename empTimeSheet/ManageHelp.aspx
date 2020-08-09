<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="ManageHelp.aspx.cs" Inherits="empTimeSheet.ManageHelp" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit.HTMLEditor"
    TagPrefix="cc2" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        //close all popup
        function closediv() {

            document.getElementById("<%=divaddnew.ClientID %>").style.display = "none";
            document.getElementById("otherdiv").style.display = "none";
        }
        //Open add/edit div
        function opendiv() {
            setposition("<%=divaddnew.ClientID %>", "20%");
            document.getElementById("<%=divaddnew.ClientID %>").style.display = "block";
            document.getElementById("otherdiv").style.display = "block";
        }
        function reset() {
            document.getElementById("<%=txtname.ClientID %>").value = "";
            document.getElementById("<%=txtcategory.ClientID %>").value = "";
            document.getElementById("<%=legendaction.ClientID %>").innerHTML = "Add Help";
            document.getElementById("<%=hidid.ClientID %>").value = "";
            document.getElementById("<%=txtdesc.ClientID %>").value = "";
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div id="otherdiv" onclick="closediv();">
            </div>
            <pg:progress ID="progress1" runat="server" />
            <div class="pageheader">
                <h2>
                    <i class="fa fa-user"></i>Help Master
                </h2>
                <div class="breadcrumb-wrapper mar">
                    <a id="lbtnaddnew" runat="server" class="right_link" onclick="reset();opendiv();"><i
                        class="fa fa-fw fa-plus topicon"></i>Add New </a>
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
                                            Manage Help</h5>
                                    </div>
                                    <div class="col-sm-4 col-md-4 f_left mar clear pad4 ">
                                        <asp:TextBox ID="txtsearch" runat="server" CssClass="form-control" placeholder="Search by Keyword"></asp:TextBox>
                                    </div>
                                    <div class="col-sm-6 col-md-4 pad5">
                                        <asp:Button ID="btnsearch" runat="server" Text="Search" CssClass="btn btn-default mar"
                                            OnClick="btnsearch_OnClick" />
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
                                <div class="panel panel-default">
                                    <div class="panel-body2 ">
                                        <div class="row">
                                            <div class="table-responsive">
                                                <div id="divmsg" runat="Server" class="nodatafound" visible="false">
                                                    No Record Found
                                                </div>
                                                <asp:DataGrid ID="dgnews" runat="server" AllowPaging="True" PagerStyle-Mode="numericpages"
                                                    AllowSorting="true" PageSize="50" GridLines="none" CellPadding="4" CellSpacing="0"
                                                    BorderStyle="None" CssClass="table table-success mb30" ShowFooter="false" AutoGenerateColumns="False"
                                                    Width="100%" OnItemCommand="dgnews_ItemCommand" OnPageIndexChanged="dgnews_PageIndexChanged"
                                                    OnSortCommand="dgnews_SortCommand">
                                                    <Columns>
                                                        <asp:TemplateColumn HeaderText="Topic" SortExpression="code">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem, "topic")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Category" SortExpression="code">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem, "category")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn ItemStyle-Width="20px">
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="eid" ToolTip="Edit" runat="server" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>'
                                                                    CommandName="edititem"><i class="fa fa-fw">
                                                            <img src="images/edit.png" ></i></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn ItemStyle-Width="20px">
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="cid" runat="server" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>'
                                                                    CommandName="deleteitem" OnClientClick='return confirm("Delete this row? Yes or no");'
                                                                    ToolTip="Delete"><i class="fa fa-fw">
                                                            <img src="images/delete.png" alt=""></i></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                    </Columns>
                                                    <HeaderStyle CssClass="gridheader" />
                                                    <PagerStyle CssClass="gridpager" HorizontalAlign="Center" />
                                                </asp:DataGrid>
                                                <input type="hidden" id="hidid" runat="server" />
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
            <div style="display: none; width: 680px;" runat="server" id="divaddnew" class="itempopup">
                <div class="popup_heading">
                    <span id="legendaction" runat="server">Add Help </span>
                    <div class="f_right">
                        <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
                    </div>
                </div>
                <div class="tabContents">
                    <div class="col-xs-12 col-sm-12 mar">
                        <div class="col-xs-12 col-sm-12 form-group f_left pad">
                            <label class="col-xs-12
            col-sm-2 control-label">
                                Name:<asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="*"
                                    ControlToValidate="txtname" controltocompare="txtname" ValidationGroup="save"
                                    CssClass="errmsg"></asp:RequiredFieldValidator>
                            </label>
                            <div class="col-xs-12 col-sm-10">
                                <asp:TextBox ID="txtname" runat="server" CssClass="form-control" Style="width: 98%;"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-xs-12 col-sm-12 form-group f_left pad">
                            <label class="col-xs-12 col-sm-2 control-label">
                                Category:<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                                    ErrorMessage="*" ControlToValidate="txtcategory" controltocompare="txtcategory"
                                    ValidationGroup="save" CssClass="errmsg"></asp:RequiredFieldValidator></label>
                            <div class="col-xs-12 col-sm-10">
                                <asp:TextBox ID="txtcategory" runat="server" CssClass="form-control" Style="width: 98%;"></asp:TextBox>
                                <cc1:AutoCompleteExtender ID="AutoCompleteExtender1" EnableCaching="true" BehaviorID="AutoCompleteCities"
                                    TargetControlID="txtcategory" ServiceMethod="getTopic" MinimumPrefixLength="2"
                                    ContextKey="getTopic" CompletionSetCount="2" runat="server" FirstRowSelected="true"
                                    CompletionInterval="350">
                                </cc1:AutoCompleteExtender>
                            </div>
                        </div>
                        <div class="col-xs-12 col-sm-12 form-group f_left
            pad">
                            <label class="col-sm-2 control-label">
                                Description:
                            </label>
                            <div class="col-xs-12 col-sm-10">
                                <cc2:Editor ID="txtdesc" runat="server" CssClass="form-control" Height="300" Style="width: 98%;" />
                            </div>
                        </div>
                        <div class="clear">
                            <asp:Button ID="btnsubmit" runat="server" CssClass="btn btn-primary" Text="Save"
                                ValidationGroup="save" OnClick="btnsubmit_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
