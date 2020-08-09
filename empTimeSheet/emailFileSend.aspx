<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="emailFileSend.aspx.cs" Inherits="empTimeSheet.emailFileSend" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Sara File Share</title>
    <script type="text/javascript" src="js/jquery-1.11.1.min.js"></script>
    <link rel="stylesheet" type="text/css" href="css/email_fileShare.css" />
    <script type="text/javascript">

        function onClientUploadComplete(sender, e) {
            onImageValidated("TRUE", e);
        }

        function onImageValidated(arg, context) {
          
            var test = document.getElementById("testuploaded");

            var fileList = document.getElementById("fileList");
            if (document.getElementById("hidisvalid").value == "") {
                test.style.display = 'block';

                var fileList = document.getElementById("fileList");
                var item = document.createElement('div');


                item.setAttribute("style", "float:left; width:98%;");
                if (arg == "TRUE") {
                    var url = context.get_postedUrl();
                    url = url.replace('&amp;', '&');
                    item.appendChild(createThumbnail(context, url));
                } else {
                    item.appendChild(createFileInfo(context));
                }

                fileList.appendChild(item);
            }
            else {
                test.style.display = 'none';
                fileList.innerHTML = "";
            }
        }

        function createFileInfo(e) {
           
            var holder = document.createElement('div');
            holder.setAttribute("style", "float:left; width:95%;");
            holder.innerHTML = '<b>' + e.get_fileName() + '</b>' + ' with size ' + '<b>' + e.get_fileSize() + '</b>' + ' bytes';

            return holder;
        }

        function createThumbnail(e, url) {

            var holder = document.createElement('div');
            var img = document.createElement("div");


            holder.appendChild(createFileInfo(e));
            holder.appendChild(img);

            return holder;
        }
        function uploadErrorHandler(sender, args) {
           
            document.getElementById("hidisvalid").value = "false";
        }
        function onClientUploadStart(sender, e) {

            var totalfilesize = parseFloat(document.getElementById("hidcurfilesize").value);
            for (var i = 0; i < sender._filesInQueue.length; i++) {
                totalfilesize = totalfilesize + sender._filesInQueue[i]._fileSize;
            }
            document.getElementById("hidcurfilesize").value = totalfilesize.toFixed(2);
            if (totalfilesize > parseFloat(document.getElementById("hidfilesize").value) * 1024 * 1024) {
                sender._filesInQueue._isUploaded = false;
                //this.setStatusMessage(Sys.Extended.UI.Resources.AjaxFileUpload_UploadCanceled);

                for (var i = 0; i < sender._filesInQueue.length; i++) {
                    var file = sender._filesInQueue[i];
                    if (!file._isUploaded) {
                        sender.setFileStatus(file, 'cancelled', Sys.Extended.UI.Resources.AjaxFileUpload_Canceled);
                    }
                }
                var err = new uploadErrorHandler();
                err.name = 'My API Input Error';
                err.message = 'Only .jpg, .gif, .png files';
                throw (err);


                return false;

            } //End if
            //End for

            document.getElementById('uploadCompleteInfo').innerHTML = 'Please wait while uploading ' + e.get_filesInQueue() + ' files...';
            return true;
        }

        function onClientUploadCompleteAll(sender, e) {
            if (document.getElementById("hidisvalid").value == "") {
                var args = JSON.parse(e.get_serverArguments()),
                    unit = args.duration > 60 ? 'minutes' : 'seconds',
                    duration = (args.duration / (args.duration > 60 ? 60 : 1)).toFixed(2);
              
                var info = 'At <b>' + args.time + '</b> server time <b>'
                    + e.get_filesUploaded() + '</b> of <b>' + e.get_filesInQueue()
                    + '</b> files were uploaded with status code <b>"' + e.get_reason()
                    + '"</b> in <b>' + duration + ' ' + unit + '</b>';

                document.getElementById('uploadCompleteInfo').innerHTML = info;
            }
            else {
                document.getElementById('uploadCompleteInfo').innerHTML = "";
                document.getElementById("AjaxFileUpload1_QueueContainer").innerHTML = "";
                document.getElementById("hidcurfilesize").value = "0";
                alert('The Files you are trying to send exceed the Maximum Limit.');
            }
        }


    </script>
</head>
<body>
    <form id="form1" runat="server">
        <ajaxToolkit:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </ajaxToolkit:ToolkitScriptManager>
        <input type="hidden" id="hidisvalid" runat="server" />
        <input type="hidden" id="hidfilesize" runat="server" />
        <input type="hidden" id="hidcurfilesize" runat="server" value="0" />
        <div class="header_bar">

            <a href="#" class="logo">
                <img src="images/share-file.png" alt="">
            </a>

        </div>

        <div>

            <h2 style="text-align: center; padding-top: 30px;" id="recname" runat="server">Harshwal & Company LLP.</h2>
            <div class="form_box form_widht" id="divfile" runat="server">

                <table width="100%" cellpadding="4">
                    <tr>
                        <td>
                            <asp:Label runat="server" ID="myThrobber" Style="display: none;"><img align="absmiddle" alt="" src="images/loading.gif"/></asp:Label>
                            <cc1:AjaxFileUpload ID="AjaxFileUpload1" runat="server" padding-bottom="4" padding-left="2"
                                padding-right="1" padding-top="4" ThrobberID="myThrobber" OnClientUploadComplete="onClientUploadComplete"
                                OnUploadComplete="AjaxFileUpload1_OnUploadComplete" MaximumNumberOfFiles="5" 
                                AzureContainerName="" OnClientUploadCompleteAll="onClientUploadCompleteAll" OnUploadCompleteAll="AjaxFileUpload1_UploadCompleteAll"
                                OnUploadStart="AjaxFileUpload1_UploadStart" OnClientUploadStart="onClientUploadStart" OnClientUploadError="uploadErrorHandler"   />
                            <div id="uploadCompleteInfo">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <span id="spanmaxupload" runat="server">*Max File Upload Size 20 MB</span>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div id="testuploaded" style="display: none;">
                                <h4 style="padding-bottom: 0px; font-weight: bold; color: #2c93eb; margin-bottom: 0px;">List of Uploaded Files:</h4>
                                <div id="fileList">
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td align="center">
                            <asp:Button ID="btnsubmit" runat="server" ValidationGroup="g1" CssClass="submit_btn" Text="Send" OnClick="btnsubmit_Click" />
                        </td>
                    </tr>
                </table>










                <p>Powerd by Sara Technologies Inc. </p>

                <div class="clear"></div>
            </div>


            <div class="form_box form_widht" id="divmessage" runat="server" visible="false">

                <div style="padding: 10px 0px;">
                    File successfully sent to
                    <asp:Literal ID="litname" runat="server"></asp:Literal><br />

                    <a href="emailFileSend.aspx">Click here</a> to send more files
                </div>










                <p>Powerd by Sara Technologies Inc. </p>

                <div class="clear"></div>
            </div>

        </div>


        <div class="footer">
            <a href="#" class="footer_logo">
                <img src="images/sara_sign.png" alt=""></a>

        </div>
    </form>
    <script type="text/javascript">
        function checkfilesize() {
            var total_filesize_num = 0;
            var filesizenum = parseInt(document.getElementById("hidfilesize").value);
            var myElements = $(".filesize");
            if (myElements.length == 0) {
                $(".ajax__fileupload_uploadbutton").css("visibility", "hidden");
                return;
            }
            for (var i = 0; i < myElements.length; i++) {
                var filesize = myElements.eq(i).html(); //$(".filesize").html();     
                total_filesize_num = total_filesize_num + filesize_tonum(filesize);
            }
            if (total_filesize_num > filesizenum) {
                $(".ajax__fileupload_uploadbutton").css("visibility", "hidden");
                alert('Maximum file size is ' + filesizenum + 'MB only! Please select another one.');
                return;
            } else {
                $(".ajax__fileupload_uploadbutton").css("visibility", "visible");
            }
        }

        function countsumfilesize() {
            var sumfilesize = 0;
            var myElements = $(".filesize");
            for (var i = 0; i < myElements.length; i++) {
                alert(myElements.eq(i).html());
            }
        }

        function filesize_tonum(filesize) {
            var filesize_num = 0;
            if (filesize.indexOf("kb") > 0) {
                var space = filesize.lastIndexOf(" ");
                filesize_num = parseFloat("0." + filesize.substr(0, filesize.length - space + 1));
            }
            else if (filesize.indexOf("MB") > 0) {
                var space = filesize.lastIndexOf(" ");
                filesize_num = parseFloat(filesize.substr(0, filesize.length - space + 1));
            }
            return filesize_num;
        }


        //$(".ajax__fileupload_dropzone").bind("drop", function () {
        //    checkfilesize();
        //});

        //$(".ajax__fileupload_queueContainer").bind("click", function () {
        //    checkfilesize();
        //});

        //$(".ajax__fileupload_uploadbutton").bind("mouseenter", function () {
        //    checkfilesize();
        //});



    </script>
</body>
</html>
