<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="Asset_ItemCategory.aspx.cs" Inherits="empTimeSheet.Asset_ItemCategory" %>

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
                    <i class="fa fa-folder-o"></i>Asset Management
                </h2>
                <div class="breadcrumb-wrapper">
                   
                </div>
                <div class="clear">
                </div>
            </div>
            <div class="contentpanel">
                <div class="row">
                    <div class="col-sm-4 col-md-3">
                        <div class="panel panel-default">
                            <div class="panel-body" style="min-height: 400px;">
                                <h5 class="subtitle mb5">Asset Category</h5>
                                <asp:TextBox ID="txtsearch" MaxLength="20" runat="server" CssClass="search_btn" placeholder="search.."></asp:TextBox>
                                <asp:Button ID="btnsearch" runat="server" Text="Search" OnClick="btnsearch_Click" CssClass="button" Style="display: none;" />

                                <h5 class="color"></h5>

                                <div class="nodatafound" id="nodata" runat="server">
                                    No data found
                                </div>
                                <asp:Repeater ID="dgnews" OnItemCommand="dgnews_RowCommand" runat="server">
                                    <HeaderTemplate>
                                        <ul class="search_list">
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <li class="odd">
                                            <asp:LinkButton ID="lbtndept" runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "nid")%>'
                                                CommandName="detail">
                                            <%# DataBinder.Eval(Container.DataItem, "categoryname")%> <span style="color:#049782;font-family:'Open Sans';display:inline;font-weight:bold;">
                                                
                                                (<%# DataBinder.Eval(Container.DataItem, "itemcount")%>) <%-- (30)--%>

                                                                                                      </span>

                                                  <br />
                                        <span style="color:#049782;"><%# DataBinder.Eval(Container.DataItem, "categorycode")%></span>

                                            </asp:LinkButton>
                                        </li>
                                    </ItemTemplate>
                                    <AlternatingItemTemplate>
                                        <li class="even">
                                            <asp:LinkButton ID="lbtndept" runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "nid")%>'
                                                CommandName="detail">
                                            <%# DataBinder.Eval(Container.DataItem, "categoryname")%> <span style="color:#049782;font-family:'Open Sans';display:inline;font-weight:bold;">
                                                (<%# DataBinder.Eval(Container.DataItem, "itemcount")%>)   

                                                                                                      </span>

                                                 <br />
                                        <span style="color:#049782;"><%# DataBinder.Eval(Container.DataItem, "categorycode")%></span>
                                            </asp:LinkButton>
                                        </li>
                                    </AlternatingItemTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                        <!-- panel -->
                    </div>
                    <!-- col-sm-3 -->
                    <div class="col-sm-8 col-md-9">
                        <div class="panel panel-default">
                            <div class="panel-body" style="min-height: 400px;">
                                <div class="row">
                                    <div class="form-group">

                                        <div class="col-xs-12 col-sm-12 divform">
                                            <div class="ctrlGroup searchgroup">
                                                <label class="lbl lbl1">
                                                    Category Code :<asp:RequiredFieldValidator ID="req1" runat="server" ControlToValidate="txtcode"
                                                        ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator>
                                                </label>
                                                <div class="txt w3 mar10">
                                                    <asp:TextBox ID="txtcode" MaxLength="20" runat="server" CssClass="form-control" placeholder=""></asp:TextBox>

                                                </div>
                                            </div>
                                            <div class="clear"></div>
                                            <div class="ctrlGroup searchgroup">
                                                <label class="lbl lbl1">
                                                    Category Name :<asp:RequiredFieldValidator ID="req2" runat="server" ControlToValidate="txtname"
                                                        ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator>
                                                </label>
                                                <div class="txt w3">

                                                    <asp:TextBox ID="txtname" MaxLength="20" runat="server" CssClass="form-control" placeholder=""></asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="clear"></div>



                                            <%--  <div class="col-xs-12 col-sm-6 form-group f_left pad">
                                                <label class="col-xs-12 col-sm-4 control-label">
                                                    Parent Category:
                                                </label>
                                                <div class="col-xs-12 col-sm-8">
                                                   <asp:TextBox ID="dropparentID" runat="server" CssClass="form-control" placeholder="Select Category" ReadOnly="true">
                                                    </asp:TextBox>


                                                      <ajaxToolkit:PopupControlExtender ID="PopupControlExtender1" runat="server" TargetControlID="dropparentID"
                                    PopupControlID="panelCategory" Position="Bottom">
                                </ajaxToolkit:PopupControlExtender>
                                 <asp:Panel ID="panelCategory" runat="server" CssClass="poppanel">
                                      <h5 class="color" style="margin:0px;">List of Asset Categories
                                </h5>
                                     <asp:TreeView ID="TreeView1" runat="server" ForeColor="Black" >
                                         <SelectedNodeStyle BackColor="#049782" ForeColor="White" />
                                     </asp:TreeView>

                                </asp:Panel>

                                                </div>
                                            </div>--%>
                                            <div class="ctrlGroup">
                                                <label class="lbl lbl1">Description :</label>
                                                <div class="txt w3 mar10">
                                                    <asp:TextBox ID="txtdes" runat="server" CssClass="form-control" Height="80" TextMode="MultiLine"></asp:TextBox>

                                                </div>






                                            </div>
                                             <div class="clear"></div>

                                            <div class="ctrlGroup searchgroup">

                                                <label class="lbl lbl1">&nbsp;</label>
                                                <asp:Button ID="btnsubmit" runat="server" CssClass="btn btn-primary" Text="Save"
                                                    ValidationGroup="save" OnClick="btnsubmit_Click" />
                                                <asp:Button OnClientClick="return confirm('Delete this record?');" ID="btndelete" runat="server" CssClass="btn btn-default" Text="Delete" OnClick="btndelete_Click"
                                                    Visible="false" />
                                                 <asp:LinkButton ID="liaddnew" Visible="false" runat="server" CssClass="btn btn-default" OnClick="liaddnew_Click">
                                          Cancel</asp:LinkButton>

                                            </div>
                                        </div>





                                    </div>

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
