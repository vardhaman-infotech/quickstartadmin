<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="masksoftware.aspx.cs" Inherits="empTimeSheet.masksoftware" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:FileUpload ID="FileUpload1" runat="server" />
        <asp:Button ID="btnmask" runat="server" Text="Upload" OnClick="btnmask_Click" />
    </div>
    </form>
</body>
</html>
