<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="emailFileShare.aspx.cs" Inherits="empTimeSheet.emailFileShare" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <title>Sara File Share</title>

   
    <link rel="stylesheet" type="text/css" href="css/email_fileShare.css" />
    <script src='https://www.google.com/recaptcha/api.js'></script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header_bar">

            <a href="#" class="logo">
                <img src="images/share-file.png" alt="">
            </a>

        </div>

        <div class="form_widht">

            <h2 style="text-align: center; padding-top: 30px;" id="recname" runat="server">Harshwal & Company LLP.</h2>
            <div class="form_box">

                <div class="gray_bar">
                    <div class="col-md-6 col-lg-12">
                        <label>Your Name</label>
                        <asp:TextBox ID="txtname" runat="server"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="*" ControlToValidate="txtname" ValidationGroup="g1"></asp:RequiredFieldValidator>
                    </div>

                </div>
                <div class="gray_bar">
                    <div class="col-md-6 col-lg-12">
                        <label>Email ID</label>
                        <asp:TextBox ID="txtemailid" runat="server"></asp:TextBox><asp:RequiredFieldValidator ID="RegularExpressionValidator2" runat="server" ErrorMessage="*" ControlToValidate="txtemailid" ValidationGroup="g1"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*" ControlToValidate="txtemailid" ValidationGroup="g1" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                    </div>

                </div>
                <div class="gray_bar">
                    <div class="col-md-6 col-lg-12">
                        <label>
                            Captcha

                        </label>
                        <div style="float: left; margin-top: 0; padding-top: 0;">
                            <div class="g-recaptcha" data-sitekey="6LdDaCAUAAAAABo2oml1NA-JjvcD1vdDzFs2-Gjl"></div>
                        
                        </div>
                    </div>

                </div>








                <asp:Button ID="btnsubmit" runat="server" ValidationGroup="g1" CssClass="submit_btn" Text="Submit" OnClick="btnsubmit_Click" />

                <p>Powerd by Sara Technologies Inc. </p>

                <div class="clear"></div>
            </div>

        </div>

        <div class="footer">
            <a href="#" class="footer_logo">
                <img src="images/sara_sign.png" alt=""></a>

        </div>
    </form>
</body>
</html>
