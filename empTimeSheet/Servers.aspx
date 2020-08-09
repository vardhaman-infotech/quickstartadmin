<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="Servers.aspx.cs" Inherits="empTimeSheet.Servers" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="css/server_2.0.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        //Open add/edit div
        function opendiv() {
            setposition("divaddnew");
            document.getElementById("divaddnew").style.display = "block";
            document.getElementById("otherdiv").style.display = "block";
        }
        function closediv() {

            document.getElementById("divaddnew").style.display = "none";
            document.getElementById("otherdiv").style.display = "none";
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:UpdatePanel ID="upadatepanel1" runat="server">
        <ContentTemplate>
            <input type="hidden" id="hidid" runat="server" />
            <input type="hidden" id="hidaddress" runat="server" />
            <input type="hidden" id="hidrate" runat="server" />
            <pg:progress ID="progress1" runat="server" />
            <div class="pageheader">
               <h2> <i class="fa fa-desktop"></i>Server Management </h2>
                <div class="breadcrumb-wrapper mar ">
                    <asp:LinkButton ID="liaddnew" runat="server" CssClass="right_link" OnClick="liaddnew_Click">
                    <i class="fa fa-fw fa-plus topicon"></i>Reset form </asp:LinkButton>
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
                                    Servers</h5>
                                <asp:DropDownList ID="dropclient" runat="server" CssClass="form-control mar pad3">
                                </asp:DropDownList>
                                <div class="clear">
                                </div>
                                <asp:TextBox ID="txtsearch" runat="server" CssClass="form-control mar" placeholder="Keyword"></asp:TextBox>
                                <asp:Button ID="btnsearch" runat="server" Text="Search" CssClass="btn btn-default mar"
                                    OnClick="btnsearch_Click" />
                                <div class="clear">
                                    <div class="nodatafound" id="nodata" runat="server">
                                        No data found</div>
                                    <asp:Repeater ID="dgnews" runat="server" OnItemCommand="dgnews_RowCommand">
                                        <HeaderTemplate>
                                            <ul class="search_list">
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <li class="odd">
                                                <asp:LinkButton ID="lbtndept" runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "nid")%>'
                                                    CommandName="detail">
                                            <%# DataBinder.Eval(Container.DataItem, "ServerCode")%>&nbsp;
                                            <br />
                                            <span>(<%# DataBinder.Eval(Container.DataItem, "ServerName")%>)</span>
                                                </asp:LinkButton>
                                            </li>
                                        </ItemTemplate>
                                        <AlternatingItemTemplate>
                                            <li class="even">
                                                <asp:LinkButton ID="lbtndept" runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "nid")%>'
                                                    CommandName="detail">
                                            <%# DataBinder.Eval(Container.DataItem, "ServerCode")%>&nbsp;
                                            <br />
                                            <span>(<%# DataBinder.Eval(Container.DataItem, "ServerName")%>)</span>
                                                </asp:LinkButton>
                                            </li>
                                        </AlternatingItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-8 col-md-9">
                        <div class="panel panel-default">
                            <div class="panel-body">
                                    <div class="form-group fl_widht">
                                        <div class="ctrlGroup searchgroup" style="margin-left: 15px;">
                                            <label class="lbl">Client :<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*"
                                                    ControlToValidate="ddlclient" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                                            </label>
                                            <div class="txt w2 mar10">
                                                <asp:DropDownList ID="ddlclient" runat="server" CssClass="form-control">
                                                </asp:DropDownList>
                                            </div>
                                        </div>
                                        <div class="ctrlGroup searchgroup">
                                            <label class="lbl">Domain :</label>
                                            <div class="txt w1">
                                                <asp:TextBox ID="txt_domain" runat="server" CssClass="form-control"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="clear"></div>
                                        <div class="ctrlGroup searchgroup" style="margin-left: 15px;">
                                            <label class="lbl">Server ID :<asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="*"
                                                    ControlToValidate="txt_serverid" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                                            </label>
                                            <div class="txt w2 mar10">
                                                <asp:TextBox ID="txt_serverid" runat="server" CssClass="form-control"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="ctrlGroup searchgroup">
                                            <label class="lbl">Server Name :<asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="*"
                                                    ControlToValidate="txt_servername" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                                            </label>
                                            <div class="txt w1">
                                                <asp:TextBox ID="txt_servername" runat="server" CssClass="form-control"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-xs-12">
                                            <asp:Repeater ID="rptconfig" runat="server" OnItemDataBound="rptconfig_ItemDataBound">
                                                <ItemTemplate>
                                                    <h3>
                                                        <%#Eval("type")%></h3>
                                                    <div class="clear">
                                                    </div>
                                                    <asp:Repeater ID="rptinner" runat="server">
                                                        <HeaderTemplate>
                                                            <table cellpadding="4" cellspacing="0" class="tblform" style="width: 96%; margin-bottom: 20px;">
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <tr>
                                                                <td class="tblcol">
                                                                    <%#Eval("name")%>:
                                                                </td>
                                                                <td>
                                                                    <asp:TextBox ID="txtvalue" CssClass="form-control" runat="server" />
                                                                    <asp:HiddenField ID="hidconfigid" runat="server" Value=' <%#Eval("nid")%>' />
                                                                    <asp:HiddenField ID="hidserverconfigid" runat="server" />
                                                                </td>
                                                            </tr>
                                                        </ItemTemplate>
                                                        <FooterTemplate>
                                                            </table>
                                                        </FooterTemplate>
                                                    </asp:Repeater>
                                                    <div class="clear">
                                                    </div>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </div>
                                        <div class="col-xs-12 clear">
                                            <h3>
                                                Server Roles</h3>
                                            <div class="clear">
                                            </div>
                                            <asp:CheckBoxList ID="rbtnroles" runat="server" RepeatLayout="Table" RepeatDirection="Horizontal"
                                                RepeatColumns="2" CssClass="checkboxauto">
                                            </asp:CheckBoxList>
                                        </div>
                                        <div class="col-sm-6">
                                            <asp:Button ID="btnsubmit" runat="server" CssClass="btn btn-primary" Text="Save"
                                                ValidationGroup="save" OnClick="btnsubmit_Click" />
                                            <asp:Button ID="btndelete" runat="server" CssClass="btn btn-primary" Visible="false"
                                                Text="Delete" OnClientClick='return confirm("Delete this record? Yes or No");'
                                                OnClick="btndelete_Click" />
                                            <div class="clear">
                                            </div>
                                        </div>
                                        <div class="clear">
                                        </div>
                                    </div>
                                
                            </div>
                            <div class="clear">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
