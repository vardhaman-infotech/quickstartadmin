<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InvoicePreview.aspx.cs"
    Inherits="empTimeSheet.InvoicePreview" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Invoice Preview</title>
    <link rel="stylesheet" type="text/css" media="print" href="css/print.css" />
    <script type="text/javascript">

        // Script to print the given Div
        function PrintPanel() {

            var panel = document.getElementById("divinvdetail");
            var printWindow = window.open('', '', 'height=400,width=800');
            printWindow.document.write("<head> <link href='css/style_2.2.css' rel='stylesheet' type='text/css' /> <title>Print</title>");
            printWindow.document.write('</head><body style="background:none;">');
            printWindow.document.write(panel.innerHTML);
            printWindow.document.write('<div></body></html>');
            printWindow.document.close();
            setTimeout(function () {
                printWindow.print();
            }, 500);
            return false;
        }
   
    </script>
    
</head>
<body>
    <form id="form1" runat="server">
    <div style="padding: 10px; width: 700px; margin: 0 auto;" id="divprintpanel">
        <a id="btnprint" onclick="PrintPanel();" class="print" style="border-radius: 4px;
            background: #025ba7; padding: 5px 0; text-align: center; float: right; font-size: 15px;
            color: #f2f2f2; text-decoration: none; display: block; margin-right: 10px; width: 10%;
            cursor: pointer;">Print </a>
        <asp:LinkButton ID="lbtnpdf" runat="server" OnClick="btnexportpdf_Click" Style="border-radius: 4px;
            background: #025ba7; padding: 5px; text-align: center; float: right; font-size: 15px;
            color: #f2f2f2; text-decoration: none; display: block; margin: auto; cursor: pointer;
            margin-right: 10px;">Export to PDF</asp:LinkButton>
        <div class="clear">
        </div>
        <div id="divinvdetail" runat="server" style="padding: 10px; width: 700px; margin: 40px auto;">
        </div>
        <div style="clear:both;"></div>
        <div id="divinvdetailpage2" runat="server" style="padding: 10px; width: 700px; margin: 20px auto;">
        </div>
    </div>
    <input type="hidden" id="hidnid" runat="server" />
    </form>
</body>
</html>
