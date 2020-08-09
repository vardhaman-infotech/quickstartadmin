<%@ Page Title="" Language="C#" MasterPageFile="defaultMaster.Master" AutoEventWireup="true"
    CodeBehind="ManageCompany.aspx.cs" Inherits="emptimesheet.admin.ManageCompany" %>

<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script type="text/javascript" language="javascript">
        function showdivnews() {
            blank();
            openpopup();
            return false;
        }
        function hidedivnews() {
            blank();
        }

        function blank() {
            document.getElementById("<%=txtcode.ClientID %>").value = "";
            document.getElementById("<%=txtCompany.ClientID %>").value = "";
            document.getElementById("<%=txtaddress.ClientID %>").value = "";
            document.getElementById("<%=txtCity.ClientID %>").value = "";
            document.getElementById("<%=txtState.ClientID %>").value = "";
            document.getElementById("<%=txtZip.ClientID %>").value = "";
            document.getElementById("<%=txtCountry.ClientID %>").value = "";
            document.getElementById("<%=txtphone.ClientID %>").value = "";
            document.getElementById("<%=txtFax.ClientID %>").value = "";
            document.getElementById("<%=txtemail.ClientID %>").value = "";
            document.getElementById("<%=txtwebsite.ClientID %>").value = "";
            document.getElementById("<%=txtfname.ClientID %>").value = "";
            document.getElementById("<%=txtlname.ClientID %>").value = "";
            document.getElementById("<%=txtcontactperson.ClientID %>").value = "";
            document.getElementById("<%=txtloginid.ClientID %>").value = "";
            document.getElementById("<%=txtpassword.ClientID %>").value = "";
            document.getElementById("<%=hidempid.ClientID %>").value = "";
            document.getElementById("<%=hidid.ClientID %>").value = "";
            document.getElementById("<%=divmsg.ClientID %>").innerHTML = "";
            document.getElementById("<%=divmsg.ClientID %>").style.display = "none";

        }

        function checkfield() {
            var flag = 0;
            if (document.getElementById("<%=txtcode.ClientID %>").value == "") {
                document.getElementById("tdcode").className = "tdcolerror";
                flag = 1;
            }
            else {
                document.getElementById("tdcode").className = "tdcol";
            }
            if (document.getElementById("<%=txtCompany.ClientID %>").value == "") {
                document.getElementById("tdcompany").className = "tdcolerror";
                flag = 1;
            }
            else {
                document.getElementById("tdcompany").className = "tdcol";
            }


            if (document.getElementById("<%=txtCountry.ClientID %>").value == "") {
                document.getElementById("tdcountry").className = "tdcolerror";
                flag = 1;
            }
            else {
                document.getElementById("tdcountry").className = "tdcol";
            }
            if (document.getElementById("<%=txtState.ClientID %>").value == "") {
                document.getElementById("tdstate").className = "tdcolerror";
                flag = 1;
            }
            else {
                document.getElementById("tdstate").className = "tdcol";
            }
            if (document.getElementById("<%=txtCity.ClientID %>").value == "") {
                document.getElementById("tdcity").className = "tdcolerror";
                flag = 1;
            }
            else {
                document.getElementById("tdcity").className = "tdcol";
            }
            if (document.getElementById("<%=txtfname.ClientID %>").value == "") {
                document.getElementById("tdfname").className = "tdcolerror";
                flag = 1;
            }
            else {
                document.getElementById("tdfname").className = "tdcol";
            }
            if (document.getElementById("<%=txtloginid.ClientID %>").value == "") {
                document.getElementById("tdloginid").className = "tdcolerror";
                flag = 1;
            }
            else {
                document.getElementById("tdloginid").className = "tdcol";
            }
            if (document.getElementById("<%=txtpassword.ClientID %>").value == "") {
                document.getElementById("tdpassword").className = "tdcolerror";
                flag = 1;
            }
            else {
                document.getElementById("tdpassword").className = "tdcol";
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
    <asp:UpdatePanel ID="upadte" runat="server">
        <ContentTemplate>
            <pg:progress ID="progress1" runat="server" />
            <%--Popup code--%>
            <div id="popupdiv" onclick="closediv();">
            </div>
            <div style="display: none; width: 650px;" id="divaddnew" class="newpopupdiv">
                <div class="popheader">
                    <div class="headername" style="background-image: url(images/company16.png);">
                        Company Detail
                    </div>
                    <div class="f-right padright5">
                        <img src="images/closepop.gif" onclick="closediv();" title="Close Window" style="cursor: pointer;" />
                    </div>
                </div>
                <table width="98%" align="center" border="0" cellpadding="3" cellspacing="0">
                    <tr style="height: 30px;">
                        <td class="tdcol" id="tdcode">
                            Company Code
                        </td>
                        <td class="tdrightcol" colspan="3">
                            <asp:TextBox ID="txtcode" runat="server" class="smallInput txsmall"></asp:TextBox>
                        </td>
                    </tr>
                    <tr style="height: 30px;">
                        <td class="tdcol" id="tdcompany">
                            Company Name
                        </td>
                        <td class="tdrightcol" colspan="3">
                            <asp:TextBox ID="txtCompany" runat="server" class="smallInput txsmall" Style="height: 32px;
                                width: 100%"></asp:TextBox>
                        </td>
                    </tr>
                    <tr style="height: 30px;">
                        <td class="tdcol" id="tdname">
                            Address
                        </td>
                        <td class="tdrightcol">
                            <input type="Text" id="txtaddress" runat="Server" class="smallInput txtsmall" />
                        </td>
                        <td class="tdcol" id="tdcountry">
                            Country
                        </td>
                        <td class="tdrightcol">
                            <asp:DropDownList type="Text" ID="txtCountry" runat="Server" AutoPostBack="true"
                                class="smallInput dropsmall" OnSelectedIndexChanged="ddlcountry_SelectedIndexChanged">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr style="height: 30px;">
                        <td class="tdcol" id="tdstate">
                            State
                        </td>
                        <td class="tdrightcol">
                            <asp:DropDownList type="Text" ID="txtState" runat="Server" AutoPostBack="true" class="smallInput dropsmall"
                                OnSelectedIndexChanged="ddlstate_SelectedIndexChanged">
                            </asp:DropDownList>
                        </td>
                        <td class="tdcol" id="tdcity">
                            City
                        </td>
                        <td class="tdrightcol">
                            <asp:DropDownList ID="txtCity" runat="Server" class="smallInput dropsmall">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr style="height: 30px;">
                        <td class="tdcol" id="tdzip">
                            Zip
                        </td>
                        <td class="tdrightcol">
                            <input type="text" id="txtZip" runat="Server" class="smallInput txtsmall" />
                        </td>
                        <td class="tdcol" id="tdemplimit">
                            Phone
                        </td>
                        <td class="tdrightcol">
                            <input type="Text" id="txtphone" runat="Server" class="smallInput txtsmall" />
                        </td>
                    </tr>
                    <tr style="height: 30px;">
                        <td class="tdcol" id="td1">
                            Fax
                        </td>
                        <td class="tdrightcol">
                            <input type="Text" id="txtFax" runat="Server" class="smallInput txtsmall" />
                        </td>
                        <td class="tdcol" id="tdemail">
                            Email
                        </td>
                        <td class="tdrightcol">
                            <asp:TextBox ID="txtemail" runat="Server" CssClass="smallInput txtsmall" />
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ValidationGroup="save"
                                ControlToValidate="txtemail" ErrorMessage="Invalid Email." ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                        </td>
                    </tr>
                    <tr style="height: 30px;">
                        <td class="tdcol" id="td3">
                            Contact Person
                        </td>
                        <td class="tdrightcol">
                            <input type="Text" id="txtcontactperson" runat="Server" class="smallInput txtsmall" />
                        </td>
                        <td class="tdcol" id="td4">
                            Website
                        </td>
                        <td class="tdrightcol">
                            <input type="Text" id="txtwebsite" runat="Server" class="smallInput txtsmall" />
                        </td>
                    </tr>
                    <tr>
                        <td class="tdcol">
                            Currency
                        </td>
                        <td class="tdrightcol">
                            <asp:DropDownList ID="ddlcurrency" runat="server" CssClass="smallInput dropsmall">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4" style="border-bottom: 1px solid #cccccc;">
                            User Details
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                        </td>
                    </tr>
                    <tr>
                        <td id="tdusername">
                            First Name
                        </td>
                        <td>
                            <input type="Text" id="txtfname" runat="Server" class="smallInput txtsmall" />
                        </td>
                        <td>
                            Last Name
                        </td>
                        <td>
                            <input type="Text" id="txtlname" runat="Server" class="smallInput txtsmall" />
                        </td>
                    </tr>
                    <tr>
                        <td id="tdloginid">
                            Login ID
                        </td>
                        <td>
                            <input type="Text" id="txtloginid" runat="Server" class="smallInput txtsmall" />
                        </td>
                        <td id="tdpassword">
                            Password
                        </td>
                        <td>
                            <asp:TextBox ID="txtpassword" runat="Server" CssClass="smallInput txtsmall"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="tdcol">
                            Upload Logo
                        </td>
                        <td>
                            <asp:FileUpload ID="fileuploadlogo" runat="server" />
                        </td>
                        <td>
                            <asp:Button ID="btnupload" runat="server" Text="Upload" OnClick="btnupload_click"
                                CssClass="btnold" />
                        </td>
                        <td>
                        </td>
                    </tr>
                      <tr>
                        <td class="tdcol">
                            Upload Logo Icon
                        </td>
                        <td>
                            <asp:FileUpload ID="fileuploadicon" runat="server" />
                        </td>
                        <td>
                            <asp:Button ID="btnuploadicon" runat="server" Text="Upload" OnClick="btnuploadicon_click"
                                CssClass="btnold" />
                        </td>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 100%" colspan="2">
                            <asp:Panel ID="pnlimage" runat="server" GroupingText="Logo" style="min-height:100px">
                                <asp:Image ID="imglogo" runat="server" AlternateText="No Logo Available" />
                            </asp:Panel>
                        </td>
                         <td style="width: 100%" colspan="2">
                          <asp:Panel ID="pnlicon" runat="server" GroupingText="Logo Icon" style="min-height:100px">
                                <asp:Image ID="imglogoicon" runat="server" AlternateText="No Logo Available" Width="100" />
                            </asp:Panel>
                         </td>
                    </tr>
                  
                   
                    <tr>
                        <td style="height: 5px; text-align: center; padding-top: 20px;" colspan="4">
                            <asp:Button ID="btnsave" runat="Server" Text="Save" CssClass="btnsave" OnClientClick="return checkfield();"
                                OnClick="btnsave_Click" ValidationGroup="save" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <input type="hidden" id="hidid" runat="server" />
                            <input type="hidden" id="hiduser" runat="server" />
                            <input type="hidden" id="hidcompany" runat="server" />
                            <input type="hidden" id="hidlogo" runat="server" />
                            <input type="hidden" id="hidlogoicon" runat="server" />

                            <input type="hidden" id="hidempid" runat="server" />
                        </td>
                    </tr>
                </table>
            </div>
            <%--Popup code end here--%>
            <div class="grid_9">
                <h1 class="company">
                    Company</h1>
            </div>
            <!-- CONTENT TITLE RIGHT BOX -->
            <div class="grid_6 addnew1" id="eventbox">
                <asp:LinkButton ID="btnaddnew" runat="server" OnClientClick="return showdivnews();"><div class="addnew-icon-addnew">Add New</div> </asp:LinkButton></div>
            <div class="clear">
            </div>
            <!--    TEXT CONTENT OR ANY OTHER CONTENT START     -->
            <div class="grid_15" id="textcontent">
                <table width="100%">
                    <tr>
                        <td align="center" style="padding-top: 0px;">
                            <div id="divmsg" runat="server" class="errmsg" align="center">
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
                                        <asp:BoundColumn DataField="companyname" HeaderText="Company Name"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderText="Company Code">
                                            <ItemTemplate>
                                                <%#DataBinder.Eval(Container.DataItem,"compcode")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="City">
                                            <ItemTemplate>
                                                <%#DataBinder.Eval(Container.DataItem,"cityid")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="State">
                                            <ItemTemplate>
                                                <%#DataBinder.Eval(Container.DataItem,"stateid")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Contact Person">
                                            <ItemTemplate>
                                                <%#DataBinder.Eval(Container.DataItem,"contactperson")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Creation Date">
                                            <ItemTemplate>
                                                <%#DataBinder.Eval(Container.DataItem,"creationdate")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn ItemStyle-CssClass="griditem32">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="eid" runat="server" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>'
                                                    CommandName="edit"><img src="images/edit32.png" alt="Edit" title="Edit Company" /></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn ItemStyle-CssClass="griditem32">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="cid" runat="server" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>'
                                                    CommandName="delete" OnClientClick='return confirm("Delete this row? Yes or no");'><img src="images/Delete32.png" alt="Delete Company" title="Delete" /></asp:LinkButton>
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
        <Triggers>
            <asp:PostBackTrigger ControlID="btnupload" />
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>
