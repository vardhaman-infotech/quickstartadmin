<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="comp_email.aspx.cs" Inherits="empTimeSheet.comp_email" %>

<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Sender Email Settings</title>
    <link rel="stylesheet" type="text/css"  href="css/companySettingMain5.0.css"  />
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
                            Email : *
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="Invalid Sender Email!"
                                                                    ControlToValidate="txtsenderEmail" ValidationGroup="email" Style="display: none;"></asp:RequiredFieldValidator>
                           
                        </label>
                        <div class="txt w1">
                            <asp:TextBox ID="txtsenderEmail" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                         <div class="txt w1"> <asp:RegularExpressionValidator ID="RegularExpressionValidator2" CssClass="errmsg"
                                runat="server" ErrorMessage="Invalid!" ControlToValidate="txtsenderEmail" ValidationGroup="email"
                                ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">
                            </asp:RegularExpressionValidator>
                             </div>
                    </div>
                    <div class="clear">
                    </div>
                    <div class="ctrlGroup">
                        <label class="lbl lbl1">
                            Password : *
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ErrorMessage=""
                                                                    ControlToValidate="txtsenderpass" ValidationGroup="email" Style="display: none;"></asp:RequiredFieldValidator>
                        </label>
                        <div class="txt w1">
                            <asp:TextBox ID="txtsenderpass" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>
                    
                    <div class="clear">
                    </div>
                    <div class="ctrlGroup">
                        <label class="lbl lbl1">
                          SMTP Server : *<asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server"
                                ErrorMessage="" ControlToValidate="txtmailhost" ValidationGroup="email" Style="display: none;"></asp:RequiredFieldValidator>
                        </label>
                        <div class="txt w1">
                            <asp:TextBox ID="txtmailhost" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>
                    <div class="clear">
                    </div>
                    <div class="ctrlGroup">
                        <label class="lbl lbl1">
                            Notifications : * 
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ErrorMessage=""
                                                                    ControlToValidate="rdlemailnoti" ValidationGroup="email" Style="display: none;"></asp:RequiredFieldValidator>
                        </label>
                        <div class="txt w1 mar10">
                            <asp:RadioButtonList ID="rdlemailnoti" CssClass="chkboxnew" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Selected="True">On</asp:ListItem>
                                <asp:ListItem>Off</asp:ListItem>
                            </asp:RadioButtonList>

                        </div>
                    </div>
                    <div class="ctrlGroup" style="display:none;">
                        <div class="txt w1">
                            <asp:Button ID="btntestemail" runat="server" CausesValidation="true" ValidationGroup="email" CssClass="btn-primary sett_btn" Text="Test Email" OnClientClick="var valFunc1 = validatefieldsbygroup('email');if(valFunc1 == true) {return true;} else{return false;}"
                                OnClick="btntestemail_Click" />



                        </div>
                    </div>
                    <div class="clear">
                    </div>
                    <div class="ctrlGroup">
                        <label class="lbl lbl1">
                            &nbsp;
                        </label>
                        <asp:Button ID="btnsaveinfo" runat="server" Text="Save" OnClick="btnSave_OnClick" CausesValidation="true" ValidationGroup="save"
                            OnClientClick="var valFunc1 = validatefieldsbygroup('email');if(valFunc1 == true) {return true;} else{return false;}" CssClass="btn-primary" />
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
