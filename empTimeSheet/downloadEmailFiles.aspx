<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="downloadEmailFiles.aspx.cs" Inherits="empTimeSheet.downloadEmailFiles" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Sara File Share</title>
    <link rel="stylesheet" type="text/css" href="css/email_fileShare.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="header_bar">

            <a href="#" class="logo">
                <img src="images/share-file.png" alt="">
            </a>

        </div>

        <div class="form_widht">

            <h2 style="text-align: center; padding-top: 30px;" id="recname" runat="server">Download Files</h2>
            <div class="form_box">

                <table width="100%" cellpadding="4">

                    <tr>
                        <td>
                            <h4 style="padding-bottom: 0px; font-weight: bold;">List of Files:</h4>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Repeater ID="repfile" runat="server" OnItemCommand="repfile_ItemCommand">
                                <HeaderTemplate>
                                    <table width="100%">
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td width="5">
                                            <img src="images/blue_arrow.png" />
                                        </td>
                                        <td>
                                            <asp:LinkButton ID="linkfile" runat="server" CommandName="downloadfile"
                                                 CommandArgument='<%# DataBinder.Eval(Container.DataItem, "nid")%>' >
                                                <%# DataBinder.Eval(Container.DataItem, "originalfilename")%>

                                            </asp:LinkButton>
                                        </td>

                                    </tr>

                                </ItemTemplate>

                                <FooterTemplate>
                                    </table>
                                </FooterTemplate>
                            </asp:Repeater>

                        </td>

                    </tr>

                </table>










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

