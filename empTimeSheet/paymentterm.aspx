<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="paymentterm.aspx.cs" Inherits="empTimeSheet.paymentterm" %>

<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        function searchKeyPress(e) {
            // look for window.event in case event isn't passed in
            e = e || window.event;
            if (e.keyCode == 13) {
                document.getElementById('ctl00_ContentPlaceHolder1_btnsearch').click();
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:UpdatePanel ID="upadatepanel1" runat="server">
        <ContentTemplate>
            <input type="hidden" id="hidid" runat="server" />
            <pg:progress ID="progress1" runat="server" />
            <div class="pageheader">
                <h2>
                   <i class="fa fa-cube"></i>Payment Term Management
                </h2>
                <div class="breadcrumb-wrapper">
                    <asp:LinkButton ID="liaddnew" runat="server" CssClass="right_link" OnClick="liaddnew_Click">
                    <i class="fa fa-fw fa-plus topicon"></i>Add
                    New</asp:LinkButton>
                </div>
                <div class="clear">
                </div>
            </div>
            <div class="contentpanel">
                <div class="row">
                    <div class="col-sm-4 col-md-3">
                        <div class="panel panel-default">
                            <div class="panel-body">
                                <h5 class="subtitle mb5">
                                    Term Name</h5>
                                <asp:TextBox ID="txtsearch" runat="server" CssClass="search_btn" placeholder="search.."
                                    onkeypress="searchKeyPress(event);"></asp:TextBox>
                                <asp:Button ID="btnsearch" runat="server" Text="Search" CssClass="button" OnClick="btnsearch_Click"
                                    Style="display: none;" />
                                <h5 class="color">
                                   Payment Term
                                </h5>
                                <div class="nodatafound" id="nodata" runat="server">
                                    No data found</div>
                                <asp:Repeater ID="dgnews" runat="server" OnItemCommand="dgnews_RowCommand">
                                    <HeaderTemplate>
                                        <ul class="search_list">
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <li class="odd">
                                            <asp:LinkButton ID="lbtn" runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "nid")%>'
                                                CommandName="detail">
                                            <%# DataBinder.Eval(Container.DataItem, "payTerm")%></asp:LinkButton>
                                        </li>
                                    </ItemTemplate>
                                    <AlternatingItemTemplate>
                                        <li class="even">
                                            <asp:LinkButton ID="lbtn" runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "nid")%>'
                                                CommandName="detail">
                                            <%# DataBinder.Eval(Container.DataItem, "payTerm")%></asp:LinkButton>
                                        </li>
                                    </AlternatingItemTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                    </div>
                    <!-- col-sm-3 -->
                    <div class="col-sm-8 col-md-9">
                        <div class="panel panel-default">
                            <div class="panel-body">
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl">
                                            Term Name:<asp:RequiredFieldValidator ID="req1" runat="server" ControlToValidate="txtname"
                                                ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator>
                                        </label>
                                        <div class="txt w2">
                                            <asp:TextBox ID="txtname" runat="server" CssClass="form-control" MaxLength="100"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="clear">
                                    </div>
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl">
                                           Grace Days :<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtdes"
                                                ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator>
                                        </label>
                                        <div class="txt w2 mar10">
                                            <asp:TextBox ID="txtdes" runat="server" CssClass="form-control" 
                                                            onkeypress="blockNonNumbers(this, event, true, false);"
                                                            onkeyup="extractNumber(this,0,false);" ></asp:TextBox>
                                        </div>
                                    </div>
                                    
                                    <div class="ctrlGroup searchgroup">
                                        <asp:Button ID="btnsubmit" runat="server" CssClass="btn btn-primary" Text="Save"
                                            ValidationGroup="save" OnClick="btnsubmit_Click" />
                                        <asp:Button ID="btndelete" runat="server" CssClass="btn btn-primary" Text="Delete"
                                            OnClientClick='return confirm("Delete this record? Yes or No");' OnClick="btndelete_Click" />
                                        <div class="clear">
                                        </div>
                                    </div>
                                
                                <!-- row -->
                            </div>
                            <!-- panel-body -->
                        </div>
                        <!-- panel -->
                    </div>
                    <!-- col-sm-9 -->
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

