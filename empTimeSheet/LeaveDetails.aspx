<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LeaveDetails.aspx.cs" Inherits="empTimeSheet.LeaveDetails" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="css/userstyle_2.0.css" rel="stylesheet" type="text/css" />
    <link href="css/style_2.2.css" rel="stylesheet" type="text/css" />
    <link href="css/reset_2.0.css" rel="stylesheet" type="text/css" />
    <link href="css/bootstrap_2.1.min.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
    <div class="pad3">
        <div class="nodatafound" id="divnodata" runat="server">
            No data found</div>

        <asp:GridView ID="dgdetails" runat="server" AllowPaging="false" AutoGenerateColumns="true"
            PageSize="365" CellPadding="0" CellSpacing="0" Width="100%" ShowHeader="false"
            ShowFooter="false" GridLines="None" BorderStyle="None" OnRowDataBound="dgdetails_RowDataBound">
            <Columns>
            </Columns>
        </asp:GridView>
    </div>
    </form>
</body>
</html>
