<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="support.aspx.cs" Inherits="empTimeSheet.support" %>

<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>QuickStart Support</title>
    <link href="css/logincss.css" rel="stylesheet" type="text/css" />
    <link href="css/font-awesome.css" rel='stylesheet' type='text/css' />
    <link href="css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link rel="icon" type="image/ico" href="images/favicon.ico" />
    <script type="text/javascript" src="js/timesheetjs2.2.js"></script>
    <script type="text/javascript">

        function opendiv() {
            setposition("divpopup");
            document.getElementById("divpopup").style.display = "block";

            document.getElementById("backdiv").style.display = "block";

        }

        function closediv() {
            document.getElementById("divpopup").style.display = "none";

            document.getElementById("backdiv").style.display = "none";

        }

    </script>
</head>
<body>
    <div class="otherdiv" id="backdiv"></div>
    <div class="popup" id="divpopup">
        <div class="popheadright">
            <a onclick="closediv();">
                <img src="images/close.png" /></a>

        </div>
        <div class="clear"></div>
        <div class="popupcontent">
            <h3>Please contact your system administrator for a password reset.</h3>

        </div>
    </div>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <div class="container">
            <div class="wrapper">
                <div class="wrap">
                    <div class="logo_img">
                        <img src="loginimg/logo.png" alt="" />
                    </div>
                    <asp:UpdatePanel ID="upadatepanel1" runat="server">
                        <ContentTemplate>
                            <pg:progress ID="progress1" runat="server" />
                            <div>
                                <div class="eror_msg" id="diverror" runat="server" visible="false" style="background: #aaf07b; border-color: #288703;">
                                    <span style="padding-top: 11px;">
                                        <img src="images/success.png" alt="" /></span>
                                    <p id="error" runat="server" style="padding-left: 20px;">
                                    </p>
                                </div>
                                <div class="eror_msg" id="diverror1" runat="server" visible="false">
                                    <span>
                                        <img src="images/alert_img.png" alt="" /></span>
                                    <p id="error1" runat="server">
                                    </p>
                                </div>
                                <div class="form-group">




                                    <asp:TextBox ID="txtemail" CssClass="login-text inputfield input-orange inputanimate" type="email" runat="server" placeholder="Enter your email id" onblur=" document.getElementById('diverror').style.display='none';"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*"
                                        ControlToValidate="txtemail" ValidationGroup="g1"></asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="*" ControlToValidate="txtemail" ValidationGroup="g1" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>

                                </div>
                                <div class="form-group">
                                    <asp:TextBox ID="txtcomment" TextMode="MultiLine" CssClass="login-text inputfield1 input-orange1 inputanimate" runat="server" placeholder="Enter your comment"></asp:TextBox>

                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="*"
                                        ControlToValidate="txtcomment" ValidationGroup="g1"></asp:RequiredFieldValidator>
                                    <label id="forgot_password" class="forgot_password"><a>Max character length 500</a></label>
                                </div>
                                <div class="submit_button">
                                    <asp:Button ID="btnsend" runat="server" Text="Submit"
                                        ValidationGroup="g1" OnClick="btnsend_Click" />

                                </div>


                                &nbsp;&nbsp;&nbsp;
                            </div>
                            <div class="clear"></div>
                            <p class="support_type">Click here to  <a href="Default.aspx">Sign In</a></p>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
