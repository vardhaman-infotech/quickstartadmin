<%@ Page Title="" Language="C#" MasterPageFile="~/admin/defaultMaster.Master" AutoEventWireup="true"
    CodeBehind="ManageCity.aspx.cs" Inherits="emptimesheet.admin.ManageCity" %>

<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript" language="javascript">


        function showdivnews() {
            blank();
            openpopup();
            window.scrollTo(0, 0);
            return false;
        }
        function hidedivnews() {
            blank();
        }

        function blank() {
            document.getElementById("<%=divmsg.ClientID %>").style.display = "none";
            document.getElementById("<%=divmsg.ClientID %>").innerHTML = "";
            document.getElementById("<%=txtName.ClientID %>").value = "";
            document.getElementById("<%=ddlcountry.ClientID %>").value = "";
            document.getElementById("<%=hidid.ClientID %>").value = "";
            document.getElementById("<%=divmsg.ClientID %>").style.display = "none";

        }

        function checkfield() {
            var flag = 0;
            if (document.getElementById("<%=ddlcountry.ClientID %>").value == "") {
                document.getElementById("tdcountry").className = "tdcolerror";
                flag = 1;
            }
            else {
                document.getElementById("tdcountry").className = "tdcol1";
            }
            if (document.getElementById("<%=ddlstate.ClientID %>").value == "") {
                document.getElementById("tdstate").className = "tdcolerror";
                flag = 1;
            }
            else {
                document.getElementById("tdstate").className = "tdcol1";
            }
            if (document.getElementById("<%=txtName.ClientID %>").value == "") {
                document.getElementById("tdname").className = "tdcolerror";
                flag = 1;
            }
            else {
                document.getElementById("tdname").className = "tdcol1";
            }
            if (flag == 1) {
                return false;
            }
        }

        function openpopup() {
            setlocation("divaddnew");
            document.getElementById("divaddnew").style.display = "block";
            document.getElementById("popupdiv").style.display = "block";

        }
        function closediv() {
            hidedivnews();
            document.getElementById("popupdiv").style.display = "none";
            document.getElementById("divaddnew").style.display = "none";
        }
      
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="grid_9">
        <h1 class="currency">
            Manage City</h1>
    </div>
    <div class="divAddnewLink">
        <ul>
            <li><a onclick="showdivnews();" id="A2" runat="server" class=""><span class="span-icon-addnew">
                Add New</span></a> </li>
            <li>
                <%-- <asp:LinkButton ID="btnExport" runat="server" OnClick="btnExport_Click"><span class="span-icon-export">Export Excel File</span></asp:LinkButton>--%>
            </li>
        </ul>
    </div>
    <div class="clear">
    </div>
    <asp:UpdatePanel ID="upatepanel1" runat="server">
        <ContentTemplate>
            <pg:progress ID="pg1" runat="server" />
            <div id="popupdiv" onclick="closediv();">
            </div>
            <div style="display: none; width: 450px;" id="divaddnew" class="newpopupdiv">
                <div class="popheader">
                    <div class="headername" style="background-image: url(images/projects16.png);">
                        Currency Detail
                    </div>
                    <div class="f-right padright5">
                        <img src="images/closepop.gif" onclick="closediv();" title="Close Window" style="cursor: pointer;" />
                    </div>
                </div>
                <div style="width: 99%; padding-left: 10px; padding-top: 15px;">
                    <table width="98%" align="center" border="0" cellpadding="0" cellspacing="0">
                        <tr style="height: 30px;">
                            <td id="tdcountry" class="tdcol1">
                                Country
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlcountry" runat="server" class="smallInput dropsmall" AutoPostBack="true"
                                    OnSelectedIndexChanged="ddlcountry_SelectedIndexChanged">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr style="height: 30px;">
                            <td id="tdstate" class="tdcol1">
                                State
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlstate" runat="server" class="smallInput dropsmall">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr style="height: 30px;">
                            <td width="120" id="tdname" class="tdcol1">
                                City Name
                            </td>
                            <td>
                                <input type="Text" id="txtName" runat="Server" class="smallInput txtsmall" />
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 5px; text-align: center; padding-top: 20px;" colspan="2">
                                <asp:Button ID="btnsave" runat="Server" Text="Save" CssClass="btnsave" BackColor="#e2ded6"
                                    OnClientClick="return checkfield();" OnClick="btnsave_Click" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <input type="hidden" id="hidid" runat="server" />
                                <input type="hidden" id="hiduser" runat="server" />
                                <input type="hidden" id="hidcompany" runat="server" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <!--    TEXT CONTENT OR ANY OTHER CONTENT START     -->
            <div class="grid_15" id="textcontent">
                <table width="100%">
                    <tr>
                        <td align="center" style="padding-top: 0px; padding-bottom: 0px;">
                            <div id="divmsg" runat="server" class="errmsg" align="center">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <div style="float: right;">
                                <asp:LinkButton ID="lnknext" runat="server" OnClick="lnknext_Click"><img src="images/next24.png" width="18"  alt="" title="Show Next Records" /></asp:LinkButton>
                            </div>
                            <div style="padding: 0px 4px 0px 4px; float: right;">
                                <asp:Label ID="lblstart" runat="server"></asp:Label>
                                -
                                <asp:Label ID="lblend" runat="server"></asp:Label>
                                of
                                <asp:Label ID="lbltotalrecord" Font-Bold="true" runat="server"></asp:Label>
                            </div>
                            <div style="float: right;">
                                <asp:LinkButton ID="lnkprevious" runat="server" OnClick="lnkprevious_Click"><img src="images/previous24.png" width="18" alt="" title="Show Previous Records" /></asp:LinkButton>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td align="center">
                            <div class="divgrid" id="divgrid" runat="server">
                                <asp:DataGrid ID="dgnews" runat="server" AllowPaging="True" PagerStyle-Font-Size="15px"
                                    PagerStyle-Mode="numericpages" BorderColor="White" GridLines="Both" AutoGenerateColumns="False"
                                    CellPadding="4" CssClass="gridstyle" OnPageIndexChanged="dgnews_PageIndexChanged"
                                    FooterStyle-Font-Size="Smaller" OnItemCommand="dgnews_ItemCommand1">
                                    <Columns>
                                        <asp:TemplateColumn HeaderText="S.No.">
                                            <ItemTemplate>
                                                <%#Container.DataSetIndex+1 %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="City Name">
                                            <ItemTemplate>
                                                <%#DataBinder.Eval(Container.DataItem,"cityname")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="State Name">
                                            <ItemTemplate>
                                                <%#DataBinder.Eval(Container.DataItem,"statename")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Country Name">
                                            <ItemTemplate>
                                                <%#DataBinder.Eval(Container.DataItem,"countryname")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn ItemStyle-CssClass="griditem32">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="eid" runat="server" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>'
                                                    CommandName="edit"><img src="images/edit32.png" alt="Edit" title="Edit Department" /></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn ItemStyle-CssClass="griditem32">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="cid" runat="server" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>'
                                                    CommandName="delete" OnClientClick='return confirm("Delete this row? Yes or no");'><img src="images/Delete32.png" alt="Delete" title="Delete Department" /></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    </Columns>
                                    <FooterStyle CssClass="gridfooter" />
                                    <EditItemStyle CssClass="gridedititem" />
                                    <SelectedItemStyle CssClass="gridselected" />
                                    <PagerStyle HorizontalAlign="Center" CssClass="gridpager" />
                                    <AlternatingItemStyle CssClass="gridalternate" />
                                    <ItemStyle CssClass="griditem" />
                                    <HeaderStyle CssClass="gridheader" />
                                </asp:DataGrid>
                                <div id="divnodatafound" runat="server" class="msg warning">
                                    No Record Found
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
