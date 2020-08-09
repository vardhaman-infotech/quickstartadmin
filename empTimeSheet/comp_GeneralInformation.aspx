<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="comp_GeneralInformation.aspx.cs" Inherits="empTimeSheet.comp_GeneralInformation" %>

<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>General Information</title>
    <link rel="stylesheet" type="text/css" href="css/companySettingMain5.0.css" />
    <script type="text/javascript" src="js/companySettings.js"></script>
    <script>
        window.parent.document.getElementById("divcompanyloader").style.display = "block";
    </script>
</head>
<body>

    <form id="form1" runat="server">
        <ajaxToolkit:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </ajaxToolkit:ToolkitScriptManager>
        <asp:UpdatePanel ID="upadatepanel1" runat="server">
            <ContentTemplate>
                <pg:progress ID="progress1" runat="server" />
                <div class="maindiv">
                    <div class="ctrlGroup">
                        <label class="lbl lbl1">
                            Company Name : *
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage=""
                                                                    ControlToValidate="txtcompanyName" ValidationGroup="save" Style="display: none;"></asp:RequiredFieldValidator>
                        </label>
                        <div class="txt w3">
                            <asp:TextBox ID="txtcompanyName" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>
                    <div class="clear">
                    </div>
                    <div class="ctrlGroup">
                        <label class="lbl lbl1">
                            Contact Person : *
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" Style="display: none;" ErrorMessage=""
                                                                    ControlToValidate="txtcperson" ValidationGroup="save"></asp:RequiredFieldValidator>
                        </label>
                        <div class="txt w3">
                            <asp:TextBox ID="txtcperson" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>
                    <div class="clear">
                    </div>

                    <div class="ctrlGroup">
                        <label class="lbl lbl1">
                            Address : *
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" Style="display: none;" ErrorMessage="" ControlToValidate="txtaddress" ValidationGroup="save">

                                                                </asp:RequiredFieldValidator>

                        </label>
                        <div class="txt w3">
                            <asp:TextBox ID="txtaddress" runat="server" CssClass="form-control" TextMode="MultiLine" Height="50px"></asp:TextBox>
                        </div>
                    </div>
                    <div class="clear">
                    </div>
                    <div class="ctrlGroup" style="margin-top:0px;">
                        <label class="lbl lbl1">
                            &nbsp;
                        </label>
                        <div class="txt w3 mar10">
                            <div class="txt w30 pad10">
                                <asp:TextBox ID="txtcity" runat="server" CssClass="form-control" placeholder="City">
                                </asp:TextBox>
                            </div>
                             <div class="txt w20 pad10">
                            <asp:TextBox ID="txtstate" runat="server" CssClass="form-control" placeholder="State">
                            </asp:TextBox>
                        </div>
                        <div class="txt w20 pad10">
                            <asp:TextBox ID="txtzip" runat="server" CssClass="form-control" placeholder="Zip">
                            </asp:TextBox>
                        </div>
                              <div class="txt w30">
                                   <asp:TextBox ID="txtcountry" runat="server" CssClass="form-control" placeholder="Country">
                            </asp:TextBox>
                                  </div>
                        </div>

                       
                    </div>


                    <div class="clear">
                    </div>
                   
                   
                    <div class="ctrlGroup">
                        <label class="lbl lbl1">
                            Contact :
                                                              
                        </label>
                        <div class="txt w3 mar10">
                        <div class="txt w30 pad10">
                            <asp:TextBox ID="txtphone" runat="server" CssClass="form-control" placeholder="Phone">
                            </asp:TextBox>
                        </div>
                         <div class="txt w30 pad10">
                            <asp:TextBox ID="txtfax" runat="server" CssClass="form-control" placeholder="Fax">
                            </asp:TextBox>
                        </div>
                         <div class="txt w40">
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Email"></asp:TextBox>
                        </div>
                            </div>
                    </div>
                   
                   
                   
                    <div class="clear">
                    </div>
                    <div class="ctrlGroup">
                        <label class="lbl lbl1">
                            Website : 
                                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator4" CssClass="errmsg" Style="display: none;" runat="server" ErrorMessage="Invalid Website!" ControlToValidate="txtwebsite" ValidationGroup="save"
                                                                    ValidationExpression="http(s)?://([\w-]+\.)+[\w-]+(/[\w- ./?%&amp;=]*)?"></asp:RegularExpressionValidator>

                        </label>
                        <div class="txt w3">
                            <asp:TextBox ID="txtwebsite" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>
                    <div class="clear">
                    </div>
                    <div class="ctrlGroup">
                        <label class="lbl lbl1">
                            Currency : *
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server" Style="display: none;" ErrorMessage=""
                                                                    ControlToValidate="ddlcurrency" ValidationGroup="save"></asp:RequiredFieldValidator>
                        </label>
                        <div class="txt w1 mar10">
                            <asp:DropDownList ID="ddlcurrency" runat="server" CssClass="form-control">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="ctrlGroup">
                        <label class="lbl lbl1 alignright">
                            Timezone : *
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" Style="display: none;" ErrorMessage=""
                                                                    ControlToValidate="droptimezone" ValidationGroup="save"></asp:RequiredFieldValidator>
                        </label>
                        <div class="txt w1">
                            <asp:DropDownList ID="droptimezone" runat="server" CssClass="form-control">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="clear">
                    </div>
                    <div class="ctrlGroup">
                        <label class="lbl lbl1">
                            &nbsp;
                        </label>
                        <asp:Button ID="btnsaveinfo" runat="server" Text="Save" OnClick="btnSave_OnClick" CausesValidation="true" ValidationGroup="save"
                            OnClientClick="var valFunc1 = validatefieldsbygroup('save');if(valFunc1 == true) {return true;} else{return false;}" CssClass="btn-primary" />

                        <asp:Button ID="btnreset" runat="server" CausesValidation="true" CssClass="btn-primary btn-default" Text="Reset"
                            OnClick="btnreset_Click" />
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>

    <script>
        window.parent.document.getElementById("divcompanyloader").style.display = "none";
    </script>
</body>
</html>
