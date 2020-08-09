<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="viewinvoice.aspx.cs" Inherits="empTimeSheet.viewinvoice" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>




<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Invoice</title>
</head>
<body style="background:#e0e0e0;">
    <form id="form1" runat="server">
         <ajaxToolkit:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </ajaxToolkit:ToolkitScriptManager>
    <div style="max-width:100%;width:715px;margin:0px auto;padding:10px;background:#ffffff;">
      
        <rsweb:ReportViewer ID="ReportViewer1" runat="server" Width="100%" Height="600px">
        </rsweb:ReportViewer>
       
        <div style="clear:both;"></div>
    </div>
    </form>
    <script>
       
    </script>
</body>
</html>

