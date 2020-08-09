<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="myacc_ProfilePic.aspx.cs" Inherits="empTimeSheet.myacc_ProfilePic" %>

<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">
        window.parent.document.getElementById("ctl00_ContentPlaceHolder1_progress1_UpdateProg1").style.display = "block";



        function openfile() {
            // $("#ctl00_ContentPlaceHolder1_FileUpload1").click();

            $("#FileUpload1").trigger('click');
            return false;

        }
        function fileupload(val) {
            val = val.replace("C:\\fakepath\\", "");
            document.getElementById("divfilename").innerHTML = val;
            document.getElementById("divfiledetail").style.display = "block";
        }
        function removefile() {

            document.getElementById("divfilename").innerHTML = "";
            document.getElementById("divfiledetail").style.display = "none";
            document.getElementById("<%=FileUpload1.ClientID %>").innerHTML = "";
        }
        function showprogress()
        {
            window.parent.document.getElementById("ctl00_ContentPlaceHolder1_progress1_UpdateProg1").style.display = "block";
            return true;
        }

    </script>
    <link rel="stylesheet" type="text/css"  href="css/companySettingMain5.0.css"  />
    <style type="text/css">
        .background_image {
            padding: 12px;
            float: left;
            width:150px; height:150px;
        }
        .background_image img{
           width:100%;
        }
        .fileupload {
            cursor: pointer;
            height: 175px;
            opacity: 0;
            position: absolute;
            width: 175px;
            z-index: 2;
            display:block;
        }
    </style>

</head>
<body>
    <form id="form1" runat="server">
        <ajaxToolkit:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </ajaxToolkit:ToolkitScriptManager>

        <div class="maindiv">

            <div class="background_image">
                <img id="divuserphoto" runat="server" src="webfile/profile/nophoto.png" alt="" />
            </div>
            <asp:FileUpload ID="FileUpload1" runat="server" CssClass="fileupload" ToolTip="Change Picture"
                onchange="fileupload(this.value);" />
            <div class="clear"></div>
            <div id="divfiledetail" class="pad1" style="display: none; font-size: 12px; float: left;">
                <label class="f_left" id="divfilename" style="padding-top: 7px;padding-left: 10px;font-size: 14px;">
                </label>
                <div style="float: left; padding-left: 5px; padding-top: 10px; ">
                    <a onclick="removefile();">
                        <img src="images/delete.png" title="Remove File" alt=""/></a>
                </div>
                <div id="divupload" style="float: left;padding-left: 10px;">
                    <asp:Button ID="btnupload" runat="server" CssClass="btn btn-primary" Text="Upload"
                        OnClick="btnupload_Click" OnClientClick="return showprogress();" />
                </div>
            </div>
        </div>

    </form>
    <script>
        window.parent.document.getElementById("ctl00_ContentPlaceHolder1_progress1_UpdateProg1").style.display = "none";
    </script>
</body>
</html>
