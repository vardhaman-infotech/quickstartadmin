<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="empTimeSheet.Default" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>QuickStart Login</title>
    <link href="css/logincss.css" rel="stylesheet" type="text/css" />
   
    <link rel="icon" type="image/ico" href="images/favicon.ico" />
      <script type="text/javascript" src="js/timesheetjs2.2.js"></script>
      <script type="text/javascript">
       
        function opendiv()
        {
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
<body> <div class="otherdiv" id="backdiv"></div>
        <div class="popup" id="divpopup">
            <div class="popheadright">
                <a onclick="closediv();">
                    <img src="images/cancel.png" /></a>

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
                            <pg:progress id="progress1" runat="server" />
                            <div>
                                <div class="form-group">

                                    <asp:TextBox ID="txtloginid" runat="server" placeholder="Enter Username" class="login-text inputfield input-orange inputanimate"
                                        required></asp:TextBox>
                                </div>
                                <div class="form-group">
                                      <asp:TextBox ID="txtpassword" runat="server" TextMode="Password" placeholder=" Enter Password"
                                class="login-text inputfield input-orange inputanimate" required></asp:TextBox>
                                   
                                    <label id="forgot_password" class="forgot_password"><a onclick="opendiv();">Forgot password?</a></label>
                                </div>
                                <div class="submit_button">
                                      <asp:Button ID="btnlogin" runat="server" OnClick="btnsubmit_Click"
                                Text="Login" />
                                   
                                </div>

                                <label for="showsource" title="" class="check_right">
                                    <input id="showsource" type="checkbox" value="yes" name="showsource">
                                    Stay signed in
                                </label>
                            &nbsp;&nbsp;</div>
                            <div class="clear"></div>
                            <p class="support_type">Need help? Contact <a href="support.aspx">Employee Support.</a></p>
                            </div>
                             <input type="hidden" id="hidcompanycode" value="hcllp" runat="server" />
                        </ContentTemplate>
               
                    </asp:UpdatePanel>
                </div>
            </div>
    </form>
</body>
</html>