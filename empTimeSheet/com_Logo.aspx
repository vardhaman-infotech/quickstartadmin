<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="com_Logo.aspx.cs" Inherits="empTimeSheet.com_Logo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Company Logo</title>
    <link rel="stylesheet" type="text/css" href="css/companySettingMain5.0.css" />
    <script type="text/javascript" src="js/companySettings.js"></script>

      <script>
          window.parent.document.getElementById("divcompanyloader").style.display = "block";

          function clickfile(id)
          {
              $("#"+id).click();
          }

          var img;
          var width = 0;
          var height = 0;
          var file;
          var imgdiv;
          var btnid;
          function showimagepreview(input,imgid,btnid1) {
              if (input.files && input.files[0]) {

                  imgdiv = imgid;
                  btnid = btnid1;
                  file = input.files[0];
                  fr = new FileReader();
                  fr.onload = createImage;
                  fr.readAsDataURL(file);

              }
          }

          function createImage() {
              img = document.createElement('img');
              img.onload = imageLoaded;
              img.style.display = 'none'; // If you don't want it showing
              img.src = fr.result;
              document.body.appendChild(img);
          }

          function imageLoaded() {
              width = img.width;
              height = img.height;



              var filerdr = new FileReader();
              filerdr.onload = function (e) {
                  if (e.target.result != ""){
                      document.getElementById(imgdiv).innerHTML = "<img src='" + e.target.result + "' width='99%' height='80px' />";
                      document.getElementById(btnid).style.display = "block";
                  }
                     
                  else {
                      document.getElementById(imgdiv).innerHTML = "";
                      document.getElementById(btnid).style.display = "none";
                  }
                      

              }
              filerdr.readAsDataURL(file);






          }
    </script>
</head>
<body>
    <form id="form1" runat="server">
       
        <div class="logotxt">Big Logo</div>
        <div class="com-logo-big" id="divbiglogo" runat="server">
            <img src="images/logo-big.jpg" />
        </div>
         <asp:FileUpload ID="FileUpload1" runat="server" CssClass="fileupload" ToolTip="Change Picture"
                                            onchange="showimagepreview(this,'divbiglogo','btnupload');" />
           <div class="clear">&nbsp;</div>
        <div class="edit-btn"><input type="button" onclick="clickfile('FileUpload1');" value="Edit" class="btn-primary" />
            &nbsp;
              <asp:Button ID="btnupload" runat="server" CssClass=" btn-primary sett_btn" Text="Upload" style="display:none;"
                                                    OnClick="btnupload_Click" />

        </div>
        <div class="clear">&nbsp;</div>
        <div class="logotxt">Small Logo</div>
        <div class="com-logo-small"  id="divsmalllogo" runat="server">
            <img src="images/logo-small.jpg" />
        </div>
           <asp:FileUpload ID="FileUpload2" runat="server" ToolTip="Change Picture" CssClass="fileupload" onchange="showimagepreview(this,'divsmalllogo','btnupload1');" />
         <div class="clear">&nbsp;</div>
         <div class="edit-btn"><input type="button" onclick="clickfile('FileUpload2');" class="btn-primary"   value="Edit" />&nbsp;

             <asp:Button ID="btnupload1" runat="server" CssClass=" btn-primary sett_btn" Text="Upload"
                                                                    OnClick="btnupload1_Click" style="display:none;" />
        </div>
        <div class="clear"></div>
    </form>
    <script>
        window.parent.document.getElementById("divcompanyloader").style.display = "none";
    </script>
</body>
</html>
