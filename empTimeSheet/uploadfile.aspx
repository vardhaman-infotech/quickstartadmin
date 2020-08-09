<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="uploadfile.aspx.cs" Inherits="empTimeSheet.uploadfile" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .btn {
            border: 1px solid transparent;
            border-radius: 4px;
            cursor: pointer;
            display: inline-block;
            font-size: 13px;
            font-weight: 400;
            line-height: 1.42857;
            margin-bottom: 0;
            padding: 2px 12px;
            text-align: center;
            vertical-align: middle;
            white-space: nowrap;
            background-color: #428bca;
            border-color: #357ebd;
            color: #fff;
        }

        .fileuploadouter {
            border: 1px solid transparent;
            border-radius: 4px;
            cursor: pointer;
            display: inline-block;
            font-size: 13px;
            font-weight: 400;
            line-height: 1.42857;
            margin-bottom: 0;
            padding: 2px 12px;
            text-align: center;
            vertical-align: middle;
            white-space: nowrap;
            background-color: #428bca;
            border-color: #357ebd;
            color: #fff;
        }

        .fileupload {
            background-color: #428bca;
            border-color: #357ebd;
            color: #fff;
        }
    </style>
    <script>
        function uploadComplete() {
            window.parent.document.getElementById('timesheet_hidorgfile').value = document.getElementById("timesheet_hidorgfile").value;
            window.parent.document.getElementById('timesheet_hidsavedfile').value = document.getElementById("timesheet_hidsavedfile").value;
            window.parent.uploadComplete();
        }

    </script>
</head>
<body>
    <form id="form1" runat="server">


         <asp:FileUpload ID="fileupload1" runat="server" CssClass="fileupload" />
 <asp:Button UseSubmitBehavior="false" ID="btnupload" runat="server" Text="Upload" OnClick="btnupload_Click" CssClass="btn" />
        <input type="hidden" id="timesheet_hidorgfile" runat="server" clientidmode="Static" />
        <input type="hidden" id="timesheet_hidsavedfile" runat="server" clientidmode="Static" />
    </form>
</body>
</html>
