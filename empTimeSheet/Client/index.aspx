<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="empTimeSheet.Client.index" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <title>Quick Start</title>
    <meta name="viewport" content="width=device-width, initial-scale=1,user-scalable=no" />
    <link href="../css/reset_2.0.css" rel="stylesheet" type="text/css" />
    <%-- <link href="../css/style_2.1.css" rel="stylesheet" type="text/css" />--%>
    <link href="../css/login_2.0.css" rel="stylesheet" type="text/css" />
    <link href="../css/font-awesome.css" rel='stylesheet' type='text/css' />
    
     <link href="../css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link rel="icon" type="image/ico" href="images/favicon.ico" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="top_bg">
            <div class="wrapper">
                <a href="#" class="logo">&nbsp;</a>
                <div class="clear">
                </div>
            </div>
        </div>
        <div class="clear">
        </div>
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <div class="inner_body" style="padding-top: 70px;">
            <div class="wapper">
                <img src="../images/logo2.png" alt="" style="text-align: center; display: block; margin: 20px auto 30px auto;">
                <asp:UpdatePanel ID="upadatepanel1" runat="server">
                    <ContentTemplate>
                        <pg:progress ID="progress1" runat="server" />
                        <div class="testbox">
                            <h1>Client Login</h1>
                            <div class="form">
                                <hr>
                                <div>
                                    <label class="iconlogin" for="name">
                                        <i class="fa fa-users"></i>
                                    </label>
                                    <asp:TextBox ID="txtloginid" runat="server" placeholder="Username" class="login_box"
                                        required></asp:TextBox>
                                </div>
                                <div class="clear"></div>
                                <div class="pad2">
                                    <label class="iconlogin" for="name">
                                        <i class="fa fa-lock"></i>
                                    </label>
                                    <asp:TextBox ID="txtpassword" runat="server" TextMode="Password" placeholder="Password"
                                        class="login_box" required></asp:TextBox>
                                </div>
                                <div class="clear"></div>
                                <asp:Button ID="btnlogin" runat="server" CssClass="login_btn" OnClick="btnsubmit_Click"
                                    Text="Login" />
                                <div class="clear">
                                </div>
                            </div>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </form>
</body>
</html>
