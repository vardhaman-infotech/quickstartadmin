<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="asset_VendorMaster.aspx.cs" Inherits="empTimeSheet.asset_VendorMaster" %>

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
                    <i class="fa fa-cube"></i>Vendor Master
                </h2>
                <div class="breadcrumb-wrapper">
                    <asp:LinkButton ID="liaddnew" runat="server" CssClass="right_link" OnClick="liaddnew_Click">
                    <i class="fa fa-fw fa-plus topicon"></i>Reset Form</asp:LinkButton>
                </div>
                <div class="clear">
                </div>
            </div>
            <div class="contentpanel">
                <div class="row">
                    <div class="col-sm-4 col-md-3">
                        <div class="panel panel-default">
                            <div class="panel-body" style="height:505px;overflow-y:auto;">
                                <h5 class="subtitle mb5">List Of Vendors</h5>
                                <asp:TextBox ID="txtsearch" runat="server" CssClass="search_btn" placeholder="search.." onkeypress="searchKeyPress(event);"></asp:TextBox>
                                <asp:Button ID="btnsearch" runat="server" Text="Search" CssClass="button" OnClick="btnsearch_Click" Style="display: none;" />
                                <h5 class="color">Vendors
                                </h5>

                                <div class="nodatafound" id="nodata" runat="server">
                                    No data found
                                </div>
                                <asp:Repeater ID="dgnews" runat="server" OnItemCommand="dgnews_RowCommand">
                                    <HeaderTemplate>
                                        <ul class="search_list">
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <li class="odd">
                                            <asp:LinkButton ID="lbtndept" runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "nid")%>'
                                                CommandName="detail">
                                            <%# DataBinder.Eval(Container.DataItem, "vendername")%>

                                                  <br />
                                        <span>(<%# DataBinder.Eval(Container.DataItem, "Code")%>)</span>

                                            </asp:LinkButton>
                                        </li>
                                    </ItemTemplate>
                                    <AlternatingItemTemplate>
                                        <li class="even">
                                            <asp:LinkButton ID="lbtndept" runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "nid")%>'
                                                CommandName="detail">
                                            <%# DataBinder.Eval(Container.DataItem, "vendername")%>

                                                 <br />
                                        <span>(<%# DataBinder.Eval(Container.DataItem, "Code")%>)</span>
                                            </asp:LinkButton>
                                        </li>
                                    </AlternatingItemTemplate>
                                    <FooterTemplate>
                                        </ul>
                                    </FooterTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                        <!-- panel -->
                    </div>
                    <!-- col-sm-3 -->
                    <div class="col-sm-8 col-md-9">
                        <div class="panel panel-default">
                            <div class="panel-body">
                                
                                    <div class="ctrlGroup">
                                        <label class="lbl">
                                            Vendor Name:<asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txt_vendorName"
                                                ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator>
                                        </label>
                                        <div class="txt w3 mar10">
                                            <asp:TextBox ID="txt_vendorName" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="ctrlGroup">
                                        <label class="lbl">
                                            Vendor Code:<asp:RequiredFieldValidator ID="RequiredFieldValidator11" runat="server" ControlToValidate="txt_venderCode"
                                                ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator>
                                        </label>
                                        <div class="txt w1 ">
                                            <asp:TextBox ID="txt_venderCode" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>


                                    
                                    <div class="clear"></div>
                                    <div class="ctrlGroup">
                                        <label class="lbl">
                                            Cont. Person:
                                        </label>
                                        <div class="txt w3 mar10">
                                            <asp:TextBox ID="txt_contactPersonName" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="ctrlGroup">
                                        <label class="lbl">
                                            Designation:
                                        </label>
                                        <div class="txt w1 ">
                                            <asp:TextBox ID="txt_designation" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                    

                                    
                                    <div class="clear"></div>
                                    <div class="ctrlGroup">
                                        <label class="lbl">
                                            Street:
                                        </label>
                                        <div class="txt w3 mar10">
                                            <asp:TextBox ID="txt_streetAddress" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                    
                                    <div class="ctrlGroup">
                                        <label class="lbl">
                                            Country:
                                        </label>
                                        <div class="txt w1">
                                            <asp:DropDownList ID="dropcountry" runat="server" CssClass="form-control" AutoPostBack="True"
                                                OnSelectedIndexChanged="dropcountry_SelectedIndexChanged">
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="clear"></div>

                                    <div class="ctrlGroup">
                                        <label class="lbl">
                                            State:
                                        </label>
                                        <div class="txt w1 mar10">
                                            <asp:DropDownList ID="dropstate" runat="server" CssClass="form-control" AutoPostBack="True"
                                                OnSelectedIndexChanged="dropstate_SelectedIndexChanged">
                                            </asp:DropDownList>
                                        </div>
                                    </div>

                                    <div class="ctrlGroup">
                                        <label class="lbl">
                                            City:
                                        </label>
                                        <div class="txt w1 mar10">
                                            <asp:DropDownList ID="dropcity" runat="server" CssClass="form-control">
                                            </asp:DropDownList>
                                        </div>
                                    </div>

                                    <!-- end drop down-->

                                    <div class="ctrlGroup">
                                        <label class="lbl">
                                            ZIP:
                                        </label>
                                        <div class="txt w1">
                                            <asp:TextBox ID="txt_zip" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="clear"></div>
                                    <div class="ctrlGroup">
                                        <label class="lbl">
                                            Phone:
                                        </label>
                                        <div class="txt w1 mar10">
                                            <asp:TextBox ID="txt_Phone" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="ctrlGroup">
                                        <label class="lbl">
                                            Cell:
                                            <%--<asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server"
                                                ControlToValidate="txt_cell" ErrorMessage="*"
                                                ValidationExpression="[0-9]{10}"></asp:RegularExpressionValidator>--%>
                                        </label>
                                        <div class="txt w1 mar10">
                                            <asp:TextBox ID="txt_cell" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="ctrlGroup">
                                        <label class="lbl">
                                            Fax:
                                        </label>
                                        <div class="txt w1">
                                            <asp:TextBox ID="txt_Fax" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="ctrlGroup">
                                        <label class="lbl">
                                            Email:<asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ValidationGroup="save"
                                                ControlToValidate="txt_emailId" ErrorMessage="Invalid!" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                                        </label>
                                        <div class="txt w2 mar10">
                                            <asp:TextBox ID="txt_emailId" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                    

                                    <div class="ctrlGroup">
                                        <label class="lbl">
                                            Websites:
                                        </label>
                                        <div class="txt w2">
                                            <asp:TextBox ID="txt_Websites" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                   <%-- <div class="col-xs-12 col-sm-6 form-group f_left pad">
                                        <label class="col-xs-12 col-sm-4 control-label">
                                            Notes:
                                        </label>
                                        <div class="col-xs-12 col-sm-8 control-label">
                                            <asp:TextBox ID="txt_Notes" runat="server" TextMode="MultiLine" CssClass="form-control" placeholder="Notes"></asp:TextBox>
                                        </div>
                                    </div>--%>
                                    <div class="clear"></div>
                                    <div class="ctrlGroup">
                                        <label class="lbl">
                                            Notes :
                                        </label>
                                        <div class="txt w2 mar10">
                                            <asp:TextBox ID="txt_Notes" runat="server" CssClass="form-control" 
                                                TextMode="MultiLine" Height="50px"></asp:TextBox>
                                        </div>
                                    </div>

                                    <!-- end-->

                                    
                                    <div class="ctrlGroup searchgroup">
                                        <asp:Button ID="btnsubmit" runat="server" CssClass="btn btn-primary" Text="Save"
                                            ValidationGroup="save" OnClick="btnsubmit_Click" />
                                        <asp:Button ID="btndelete" runat="server" CssClass="btn btn-default" Text="Delete"
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

