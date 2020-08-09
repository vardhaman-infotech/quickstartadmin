<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="uploadimport.aspx.cs" Inherits="empTimeSheet.uploadimport" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <script src="js/jquery-1.11.1.min.js"></script>
    <link href="css/simplepage.css" rel="stylesheet" />
    <script type="text/javascript">
        function selectfile() {
          
            $("#FileUpload1").trigger("click");
        }
        function onupload() {
            var value = $("#FileUpload1").val();
            var ext = value.substring(value.lastIndexOf('.') + 1).toLowerCase();          


            if (ext != 'xls' && ext != 'xlsm' && ext != 'xlsx') {

                alert("Invalid File Type (only .xlsx, .xls, .xlsm allowed)");
                return;


            }
            else {
                window.parent.showuploadprogress();
                $("#form1").submit();
            }
          
         
           
        }
        function readURL(input) {
            var ext = input.value.substring(input.value.lastIndexOf('.') + 1).toLowerCase();
            var array = ['jpg', 'png', 'jpeg'];

          

            if (ext != 'xls' && ext != 'xlsm' && ext != 'xlsx') {

                alert("Invalid File Type (only .xlsx, .xls, .xlsm allowed)");

               

            }
            else {
                if (input.files && input.files[0]) {
                    var reader = new FileReader();

                    reader.onload = function (e) {

                        document.getElementById("divpreview").style.backgroundImage = "url(" + e.target.result + ")";
                    }

                    reader.readAsDataURL(input.files[0]);
                }
                $('#divload').css("display", "inline");
            }
        }


        function callFileClientFunction(id, filesize, filename,filext) {
            window.parent.AttachClientFileCall(id, filesize, filename, filext);
        }

        window.selectAttachment = function (args) {
            selectfile();
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div style="display: none">
            <div  id="divload">
                <asp:Button ID="btnupload" runat="server" Text="Upload" CssClass="subbtn" OnClick="btnupload_Click" Style="display: inline-block;" />
            </div>
            <asp:FileUpload ID="FileUpload1" runat="server" Width="200px" CssClass="fileupload" onchange="onupload();" />

        </div>
    </form>
</body>
</html>