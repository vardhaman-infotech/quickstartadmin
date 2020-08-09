<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="emptimesheet.admin.Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login</title>
    <link href="css/960.css" rel="stylesheet" type="text/css" media="all" />
    <link href="css/reset.css" rel="stylesheet" type="text/css" media="all" />
    <link href="css/text.css" rel="stylesheet" type="text/css" media="all" />
    <link href="css/login.css" rel="stylesheet" type="text/css" media="all" />
    <link href="css/newstyle.css" rel="stylesheet" type="text/css" media="all" />
    <style type="text/css">
        .btnlogin
        {
            background: #2D2D2D; /* for non-css3 browsers */
            filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#000000', endColorstr='#0E6497'); /* for IE */
            background: -webkit-gradient(linear, left top, left bottom, from(#000000), to(#0E6497)); /* for webkit browsers */
            background: -moz-linear-gradient(top,  #2D2D2D,  #000000); /* for firefox 3.6+ */
            border: 0 none;
            color: #FFFFFF;
            cursor: pointer;
            display: block;
            float: right;
            font-size: 12px;
            font-weight: bold;
            height: 30px;
            margin: 10px 6px 0 0;
            outline: medium none !important;
            overflow: hidden;
            padding: 0 12px 0 0 !important;
            text-decoration: none;
            width: 105px;
            border-radius: 2px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <ajax:ToolkitScriptManager runat="Server" EnableScriptGlobalization="true" EnableScriptLocalization="true"
        ID="ScriptManager1" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <pg:progress ID="progress1" runat="server" />
            <div class="container_16">
                <div class="grid_6 prefix_5 suffix_5">
                    <h1 style="background-image: url(images/emplogin.png); background-repeat: no-repeat;
                        background-position: left; text-align: left; padding-left: 35px;">
                        User Login</h1>
                    <div id="login">
                        <p class="tip">
                            You just need to hit the button and you're in!</p>
                        <p class="error" visible="false" id="error" runat="server">
                            Login ID or password incorrect!</p>
                        <form id="form2" name="form1" method="post" action="">
                        <p>
                            <label>
                                <strong>Login ID </strong>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*"
                                    ControlToValidate="txtloginid" ValidationGroup="g1"></asp:RequiredFieldValidator>
                                <asp:TextBox ID="txtloginid" CssClass="inputText" runat="server"></asp:TextBox>
                            </label>
                        </p>
                        <p>
                            <label>
                                <strong>Password</strong>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="*"
                                    ControlToValidate="txtpassowrd" ValidationGroup="g1"></asp:RequiredFieldValidator>
                                <asp:TextBox ID="txtpassowrd" TextMode="Password" CssClass="inputText" runat="server"></asp:TextBox>
                            </label>
                        </p>
                        <asp:Button ID="btnlogin" runat="server" Text="Login" CssClass="btnlogin" ValidationGroup="g1"
                            OnClick="btnsubmit_Click" />
                        <label>
                            <input type="checkbox" name="checkbox" id="checkbox" />
                            Remember me</label>
                        </form>
                        <br clear="all" />
                    </div>
                    <%--<div id="forgot">
                <a href="#" class="forgotlink"><span>Forgot your username or password?</span></a></div>--%>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <br clear="all" />
    </form>
</body>
</html>
