<%@ Page Language="C#" AutoEventWireup="true" Inherits="manage_logout" Codebehind="logout.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Please Wait..</title>
</head>
<body>
    <form id="form1" runat="server">
    <div style="width:500px; max-width:99%; margin:40px auto;">
   <%--Logout completed successfully<br />--%>
    <img src="images/loading.gif" />
    </div>
    </form>
    <script type="text/javascript">
      //  window.location.href = "default.aspx";
    </script>
</body>
</html>
