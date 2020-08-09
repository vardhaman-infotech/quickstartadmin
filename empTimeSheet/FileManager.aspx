<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="FileManager.aspx.cs" Inherits="empTimeSheet.FileManager" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="css/publicdrive5.0.css" rel="stylesheet" type="text/css" />
    <style>
        span.filetype {
    display: none;
}
        .statusBlock {
        color:red;
        }

    </style>
    <script type="text/javascript">


        function onClientUploadComplete(sender, e) {
            onImageValidated("TRUE", e);

            023

        }

        function onImageValidated(arg, context) {

            var test = document.getElementById("testuploaded");
            test.style.display = 'block';

            var fileList = document.getElementById("fileList");
            var item = document.createElement('div');


            item.setAttribute("style", "padding:3px; float:left; width:98%;");
            if (arg == "TRUE") {
                var url = context.get_postedUrl();
                url = url.replace('&amp;', '&');
                item.appendChild(createThumbnail(context, url));
            } else {
                item.appendChild(createFileInfo(context));
            }

            fileList.appendChild(item);
        }

        function createFileInfo(e) {
            var holder = document.createElement('div');
            holder.setAttribute("style", "float:right; width:95%;padding-top:5px;");
            var fsize = (e.get_fileSize() / (1024*1024)).toFixed(3);
            holder.innerHTML = '<b>' + e.get_fileName() + '</b>' + ' with size ' + '<b>' + fsize + '</b>' + ' mb';
            return holder;
        }

        function createThumbnail(e, url) {

            var holder = document.createElement('div');
            var img = document.createElement("img");
            img.style.width = '20px';
            img.style.height = '20px';
            img.setAttribute("src", "Libraryimg/" + url);
            img.setAttribute("style", "float:left; width:20px;");

            holder.appendChild(createFileInfo(e));
            holder.appendChild(img);

            return holder;
        }

        function onClientUploadStart(sender, e) {
            document.getElementById('uploadCompleteInfo').innerHTML = 'Please wait while uploading ' + e.get_filesInQueue() + ' files...';
        }

        function onClientUploadCompleteAll(sender, e) {

            var args = JSON.parse(e.get_serverArguments()),
                unit = args.duration > 60 ? 'minutes' : 'seconds',
                duration = (args.duration / (args.duration > 60 ? 60 : 1)).toFixed(2);

            var info = 'At <b>' + args.time + '</b> server time <b>'
                + e.get_filesUploaded() + '</b> of <b>' + e.get_filesInQueue()
                + '</b> files were uploaded with status code <b>"' + e.get_reason()
                + '"</b> in <b>' + duration + ' ' + unit + '</b>';

            document.getElementById('uploadCompleteInfo').innerHTML = info;
        }


    </script>
    <script type="text/javascript">
        function openpop(divid) {
            setposition(divid);
            if (divid == "popcreatenewdir" && document.getElementById("ctl00_ContentPlaceHolder1_hidparentid").value == "0") {
                divid = "popcategory";
            }
            document.getElementById(divid).style.display = "block";
            document.getElementById("otherdiv").style.display = "block";

            return false;

        }
        function closepop(divid) {

            document.getElementById(divid).style.display = "none";
            document.getElementById("otherdiv").style.display = "none";


        }
        function closeselect() {
            document.getElementById(document.getElementById('ctl00_ContentPlaceHolder1_hiddivid').value).style.display = "none";
            document.getElementById("otherdiv1").style.display = "none";

        }
        function openselect(id, divid) {

            var offsets = document.getElementById(id).getBoundingClientRect();
            var top = offsets.top;
            var left = offsets.left;
            var width = offsets.width;
            left = left + width - 10;
            var divid1 = 'divselect' + divid;

            document.getElementById(divid1).style.top = top + "px";
            document.getElementById(divid1).style.left = left + "px";
            document.getElementById(divid1).style.display = "block";
            document.getElementById('ctl00_ContentPlaceHolder1_hiddivid').value = divid1;
            document.getElementById("otherdiv1").style.display = "block";
            return false;
        }
        function CheckAll(obj) {
            var list = document.getElementById("<%=dlfile.ClientID%>");
            var chklist = list.getElementsByTagName("input");
            for (var i = 0; i < chklist.length; i++) {
                if (chklist[i].type == "checkbox" && chklist[i] != obj) {
                    chklist[i].checked = obj.checked;
                }
            }
        }

        function checkmove(type) {
            var status = 0;
            var list = document.getElementById("<%=dlfile.ClientID%>");
            var chklist = list.getElementsByTagName("input");
            for (var i = 0; i < chklist.length; i++) {
                if (chklist[i].type == "checkbox" && chklist[i] != document.getElementById('ctl00_ContentPlaceHolder1_dlfile_chkselect')) {
                    if (chklist[i].checked == true) {
                        var ckVal = chklist[i].id.replace('chkselect', 'hidnid');
                        
                        $('#ctl00_ContentPlaceHolder1_hidMoveRid').val($('#'+ckVal).val());
                        status = 1;
                    }
                }
            }

            if (status == 0) {
                if (type == "delete") {
                    alert("Select Item to delete.");
                }
                else if (type == "zip") {
                    alert("Select Item to ZIP.");
                }
                else if (type == "copy")
                    alert("Select Item to copy.");
                else {
                    alert("Select Item to move.");
                }
                return false;

            }
            if (type == "delete") {


                return confirm("Delete the selected item? Yes or No");
            }
        }

        $(window).resize(function () {
            setposition("popcategory", "10%");
            setposition("popshareuser", "10%");
            setposition("popupload", "10%");
            setposition("popMove", "10%");
            setposition("popcreatenewdir", "10%");

        });
        function setsearchfocus(e) {

            if (e.keyCode == 13) {
                e.preventDefault();
                $("#ctl00_ContentPlaceHolder1_btnsearch").click();
                //  $('#ctl00_ContentPlaceHolder1_btnsearch').focus();
            }
        }

        function closeall() {
            document.getElementById("popcategory").style.display = "none";
            document.getElementById("popupload").style.display = "none";
            document.getElementById("popshareuser").style.display = "none";
            document.getElementById("popMove").style.display = "none";
            document.getElementById("popcreatenewdir").style.display = "none";
            document.getElementById("otherdiv").style.display = "none";
            document.getElementById("popdetail").style.display = "none";
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div style="display: none; width: 700px; height: 427px;" id="popupload" class="itempopup">
        <div class="popup_heading">
            <span>
                <img src="images/addnew.png" alt="" style="padding-top: 5px; padding-left: 5px;" />
            </span>
            <div class="f_left">
                Upload Files
            </div>
            <div class="f_right">
                <img src="images/cross.png" onclick="closepop('popupload');" alt="X" title="Close Window" />
            </div>
        </div>
        <table width="100%" cellpadding="4">
            <tr>
                <td>
                    <asp:Label runat="server" ID="myThrobber" Style="display: none;"><img align="absmiddle" alt="" src="images/loading.gif"/></asp:Label>
                    <cc1:AjaxFileUpload ID="AjaxFileUpload1" runat="server" padding-bottom="4" padding-left="2"
                        padding-right="1" padding-top="4" ThrobberID="myThrobber" OnClientUploadComplete="onClientUploadComplete"
                        OnUploadComplete="AjaxFileUpload1_OnUploadComplete" MaximumNumberOfFiles="5"
                        AzureContainerName="" OnClientUploadCompleteAll="onClientUploadCompleteAll" OnUploadCompleteAll="AjaxFileUpload1_UploadCompleteAll"
                        OnUploadStart="AjaxFileUpload1_UploadStart" OnClientUploadStart="onClientUploadStart" />
                    <div id="uploadCompleteInfo">

                    </div>
                </td>
            </tr>
            <tr>
                <td style="height: 82px;">
                    <div id="testuploaded" style="display: none; padding: 4px;">
                        <h4 style="padding-bottom: 0px; font-weight: bold;">List of Uploaded Files:</h4>
                        <div id="fileList" style="max-height: 82px; overflow: auto;">
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td align="center">
                    <asp:Button ID="btnupload" runat="server" Text="Save" CssClass="btn btn-default"
                        OnClick="btnupload_Click" />
                </td>
            </tr>
        </table>
    </div>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div id="otherdiv" onclick="closeall();">
            </div>
            <!-- Pop up for category directories goes here --->
            <div style="display: none; width: 750px; height: 350px;" id="popcategory" class="itempopup">
                <div class="popup_heading">

                    <div class="f_left" style="padding-left: 5px;">
                        Create Directory
                    </div>
                    <div class="f_right">
                        <img src="images/cross.png" onclick="closepop('popcategory');" alt="X" title="Close Window" />
                    </div>
                </div>
                <div style="float: left; width: 99.5%; overflow-y: auto;">
                    <div style="padding: 10px;">
                        <asp:DataList ID="dlcategory" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table"
                            Width="100%" CellPadding="5" CellSpacing="0" OnItemCommand="dlcategory_ItemCommand"
                            RepeatColumns="3">
                            <ItemTemplate>
                                <div style="float: left; overflow: hidden; text-align: center; vertical-align: middle;">
                                    <img src="Libraryimg/folder128.png" alt="" width="65" />
                                </div>
                                <div class="f_left" style="width: 150px; margin-left: 0px; overflow: hidden; padding-top: 8px;">
                                    <b>
                                        <asp:Literal ID="ltrcategoryname" runat="server" Text='<%# Eval("categoryname")%>'></asp:Literal></b><div
                                            class="clear">
                                        </div>
                                    <div class="padtop10">
                                        <asp:LinkButton ID="lbtncreatecategory" runat="server" Text="Add" CssClass=" btn btn-primary pad3"
                                            CommandArgument='<%# DataBinder.Eval(Container.DataItem, "nid")%>' CommandName="goto"></asp:LinkButton>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:DataList>
                    </div>
                </div>
            </div>
            <div style="display: none; width: 700px; height: 400px;" id="popdetail" class="itempopup">
                <div class="popup_heading">
                    <span>
                        <img src="images/view.png" alt="" />
                    </span>
                    <div class="f_left">
                        Details
                    </div>
                    <div class="f_right">
                        <img src="images/cross.png" onclick="closepop('popdetail');" alt="X" title="Close Window" />
                    </div>
                </div>
                <div class="clear">
                </div>
                <div style="padding-top: 10px;">
                    <table class="tblReport" width="98%" align="center" cellpadding="10" cellspacing="0">
                        <tr>
                            <th colspan="3" id="tdfilename" runat="server"></th>
                        </tr>
                        <tr>
                            <td id="tdcreatedby" runat="server"></td>
                            <td id="tdcreationdate" runat="server"></td>
                            <td id="tdlastmodificationdate" runat="server"></td>
                        </tr>
                        <tr>
                            <td colspan="3" id="tdshareto" runat="server"></td>
                        </tr>
                    </table>
                    <div class="clear">
                    </div>
                    <div style="padding: 10px 10px; max-height: 283px; overflow: auto;" id="divaccessdetail"
                        runat="server">
                        <div>
                            <b>Access Detail:</b>
                        </div>
                        <div class="clear">
                        </div>
                        <asp:Repeater ID="repdetail" runat="server">
                            <HeaderTemplate>
                                <table class="tblReport" width="98%" align="center" cellpadding="10" cellspacing="0">
                                    <tr>
                                        <th>User
                                        </th>
                                        <th>Recent Access Date
                                        </th>
                                    </tr>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td>
                                        <%# DataBinder.Eval(Container.DataItem, "name")%>
                                    </td>
                                    <td>
                                        <%# DataBinder.Eval(Container.DataItem, "accessdate")%>
                                    </td>
                                </tr>
                            </ItemTemplate>
                            <FooterTemplate>
                                </td> </tr> </table>
                            </FooterTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </div>
            <pg:progress ID="progress1" runat="server" />
            <div id="otherdiv1" class="transdiv" onclick="closeselect();">
            </div>
            <div style="display: none; width: 600px; top: 10%;" id="popshareuser" class="itempopup">
                <div class="popup_heading">

                    <div class="f_left" style="padding-left: 5px;">
                        Share File<input type="hidden" id="hidfileid" runat="server" />
                    </div>
                    <div class="f_right">
                        <img src="images/cross.png" onclick="closepop('popshareuser');" alt="X" title="Close Window" />
                    </div>
                </div>
                <div style="padding: 5px; width: 99%;">
                    <div style="padding-bottom: 5px;">
                        <div class="f_left padright5">
                            <asp:DropDownList ID="dropdepartment" Width="130px" runat="server" AutoPostBack="True"
                                CssClass="form-control" OnSelectedIndexChanged="dropdepartment_SelectedIndexChanged">
                            </asp:DropDownList>
                        </div>
                        <div class="f_left padright5">
                            <asp:TextBox ID="txtsearch" Width="200px" runat="server" AutoPostBack="true" OnTextChanged="txtsearch_TextChanged"
                                CssClass="form-control"></asp:TextBox>
                            <cc1:AutoCompleteExtender ID="AutoCompleteExtender1" EnableCaching="true" BehaviorID="AutoCompleteCities"
                                TargetControlID="txtsearch" ServiceMethod="getName" MinimumPrefixLength="2" ContextKey="getName"
                                CompletionSetCount="2" runat="server" FirstRowSelected="true" CompletionInterval="350">
                            </cc1:AutoCompleteExtender>
                        </div>
                        <div class="f_right padright5">
                            <asp:Button ID="btnsend" runat="server" Text="Send" CssClass="btn btn-primary" OnClick="btnsend_Click" />
                        </div>
                    </div>
                    <div style="float: left; width: 99%;">
                        <div class="fulldiv" style="margin-bottom: 10px; border-bottom: solid 1px #cccccc; padding-top: 10px;">
                            <asp:CheckBox ID="checkall" runat="server" onclick="CheckAll(this);" /><span>Check all</span>
                        </div>
                        <div class="fulldiv" style="height: 310px; overflow: hidden;">
                            <div class="fulldiv" style="height: 300px; overflow: auto;" id="divmemberslist">
                                <asp:DataList ID="DataList1" runat="server" Width="99%" RepeatDirection="Horizontal"
                                    RepeatLayout="Flow" ForeColor="#333333">
                                    <ItemTemplate>
                                        <div class="fleft" style="padding-top: 10px;">
                                            <div class="f_left" style="width: 20px; vertical-align: middle; padding-top: 18px;">
                                                <input type="hidden" id="hidempid" runat="server" value='<%# Eval("loginid") %>' />
                                                <asp:CheckBox ID="checkmember" runat="server" />
                                            </div>
                                            <div style="width: 40px; height: 40px; float: left; border: solid 1px #e0e0e0; overflow: hidden; text-align: center; vertical-align: middle;">
                                                <img src='photo/profile/thumbs/<%# Eval("imgurl") %>' alt="" width="40" />
                                            </div>
                                            <div class="f_left" style="width: 110px; height: 55px; margin-left: 5px; overflow: hidden; padding-top: 5px;">
                                                <b>
                                                    <%# Eval("username") %></b><br />
                                                <%# Eval("designation")%>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:DataList>
                                <div id="nodatfound" runat="server" visible="false" class="nodatafound">
                                    No Record Found.
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div style="display: none; width: 500px; min-height: 200px;" id="popMove" class="itempopup">
                <div class="popup_heading">
                    <span>
                        <img src="Libraryimg/icons/copy.png" alt="" width="24" />
                    </span>
                    <div class="f_left" id="divcopytitle" runat="server" style="padding-left: 0px;">
                        Move
                    </div>
                    <div class="f_right">
                        <img src="images/cross.png" onclick="closepop('popMove');" alt="X" title="Close Window" />
                    </div>
                </div>
                <div style="float: left; height: 200px; overflow: auto; width: 99%;">
                    <table width="100%" align="center" cellpadding="0" cellspacing="0" class="f_left">
                        <tr>
                            <td align="left" style="padding: 5px 0px 10px 8px;">
                                <input type="hidden" id="hidmoveaction" runat="server" />
                                 <input type="hidden" id="hidMoveRid" runat="server" />
                                <table cellpadding="5" align="left" style="text-align: left;">
                                    <tr>
                                        <td style="font-weight: bold;" id="tdcopycol" runat="server">Move to:
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-top: 0px;">
                                            <asp:TreeView ID="treemove" runat="server" ImageSet="XPFileExplorer" OnSelectedNodeChanged="treemove_SelectedNodeChanged">
                                                <NodeStyle ImageUrl="Libraryimg/folder_16.png" VerticalPadding="5" HorizontalPadding="5" />
                                                <SelectedNodeStyle CssClass="rootselected" />
                                            </asp:TreeView>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="fulldiv padtop10" style="text-align: center;">
                    <asp:Button ID="btncopy" runat="server" Text="Copy" CssClass="btn btn-primary" OnClick="btncopy_Click" />
                </div>
            </div>
            <div style="display: none; width: 400px; min-height: 140px;" id="popcreatenewdir"
                class="itempopup">
                <div class="popup_heading">
                    <span>
                        <img src="Libraryimg/icons/create_new.png" alt="" width="24" />
                    </span>
                    <div class="f_left">
                        Create New Directory
                    </div>
                    <div class="f_right">
                        <img src="images/cross.png" onclick="closepop('popcreatenewdir');" alt="X" title="Close Window" />
                    </div>
                </div>
                <table width="100%" align="center" cellpadding="0" cellspacing="0" class="f_left">
                    <tr>
                        <td align="left" style="padding: 30px 0px 10px 8px;">
                            <table cellpadding="4" align="left" width="99%">
                                <tr>
                                    <td width="90px">Directory Name:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtdirname" runat="server" CssClass="form-control" Width="95%"></asp:TextBox><asp:RequiredFieldValidator
                                            ID="RequiredFieldValidator1" runat="server" ErrorMessage="" ValidationGroup="create"
                                            CssClass="validation1" ControlToValidate="txtdirname"></asp:RequiredFieldValidator>
                                    </td>
                                    <td>
                                        <asp:Button ID="btncreatenew" runat="server" Text="Create" CssClass="btn btn-primary" OnClick="btncreatenew_Click"
                                            ValidationGroup="create" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="pageheader">
                <h2>
                    <i class="fa fa-tasks"></i>File Manager
                    <input type="hidden" id="hidparentid" runat="server" value="0" />
                    <input type="hidden" id="hidcategoryid" runat="server" value="0" />
                    <input type="hidden" id="hidid2" runat="server" value="" />
                </h2>
                <div class="breadcrumb-wrapper mar " id="uloperation" runat="server" visible="false">
                    <asp:LinkButton ID="lbtnnew" runat="server" OnClientClick="return openpop('popcreatenewdir');"
                        CssClass="right_link">
                      
                           <i class="fa fa-fw fa-plus topicon"></i>Create New </asp:LinkButton>
                    <asp:LinkButton ID="lbtnupload" runat="server" OnClientClick="return openpop('popupload');"
                        CssClass="right_link">
                      
                            <i class="fa fa-fw fa-upload topicon"></i>Upload
                           
                    </asp:LinkButton>
                    <asp:LinkButton ID="lbtnmove" runat="server" OnClick="lbtnmove_Click" Visible="false"
                        OnClientClick="return checkmove('move');" CssClass="right_link">
                      
                          <i class="fa fa-fw fa-random topicon"></i>Move</asp:LinkButton>
                    <asp:LinkButton ID="lbtncopy" runat="server" Visible="false" OnClick="lbtncopy_Click"
                        OnClientClick="return checkmove('copy');" CssClass="right_link">
                      
                            <i class="fa fa-fw fa-copy topicon"></i>Copy
                          
                    </asp:LinkButton>
                    <asp:LinkButton ID="lbtndelete" runat="server" OnClientClick="return checkmove('delete');"
                        OnClick="lbtndelete_Click" CssClass="right_link">
                      
                          <i class="fa fa-fw fa-trash-o topicon"></i>Delete</asp:LinkButton>
                </div>
                <div class="clear">
                </div>
            </div>
            <div class="contentpanel">
                <div class="row">
                    <div class="col-sm-12 col-md-12">
                        <div class="panel panel-default">
                            <div class="col-sm-12 col-md-12 pad1" style="border-bottom:solid 1px #e0e0e0;">
                                <div class="f_left">
                                    <div class="divsitemap">
                                        <asp:LinkButton ID="lbtnroort" runat="server" OnClick="lbtnroort_Click">Home</asp:LinkButton>
                                    </div>
                                    <div class="f_left" id="divnav" runat="server" visible="false">
                                        <div class="divsitemap">
                                            <asp:LinkButton ID="lbtndir" runat="server" OnClick="lbtndir_Click"></asp:LinkButton>
                                        </div>
                                        <div class="divsitemap" id="sitemapInnerlink" runat="server" visible="false">
                                            <asp:LinkButton ID="lbtnsitemapinner" runat="server" OnClick="lbtnsitemapinner_Click"></asp:LinkButton>
                                        </div>
                                        <div class="f_left">
                                            <asp:DataList ID="dlnav" runat="server" RepeatDirection="Horizontal" OnItemCommand="dlnav_ItemCommand">
                                                <ItemTemplate>
                                                    <div class="divsitemap">
                                                        <input type="hidden" id="hidloginid" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "loginid")%>' />
                                                        <asp:LinkButton ID="lbtndir" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "originalfilename")%>'
                                                            CommandArgument='<%# DataBinder.Eval(Container.DataItem, "nid")%>' CommandName="goto"></asp:LinkButton>
                                                    </div>
                                                </ItemTemplate>
                                            </asp:DataList>
                                        </div>
                                    </div>
                                </div>
                                <div class="f_right" style="padding-right: 2px;">
                                    <div style="padding-top: 10px; margin-right: 10px; float: left;" id="divsearch" runat="server">
                                        <asp:TextBox ID="txtsearchfile" runat="server" CssClass="form-control" Style="width: 120px;"
                                            placeholder="Search" onkeypress="setsearchfocus(event);"></asp:TextBox>
                                        <asp:Button ID="btnsearch" runat="server" Text="" Style="position: relative; width: 0px; display: none;"
                                            OnClick="btnsearch_Click" />
                                    </div>
                                    <div class="f_left" style="padding-top: 10px;">
                                        <asp:DropDownList ID="dropviewas" runat="server" Width="120px" AutoPostBack="true"
                                            OnSelectedIndexChanged="dropviewas_SelectedIndexChanged" CssClass="form-control">
                                            <asp:ListItem Value="Name" Selected="True">
                --Sort As--
                                            </asp:ListItem>
                                            <asp:ListItem Value="Name">
                Name
                                            </asp:ListItem>
                                            <asp:ListItem Value="Modificationdatedesc">
                Last Modified Desc
                                            </asp:ListItem>
                                            <asp:ListItem Value="Modificationdate">
                Last Modified Asc
                                            </asp:ListItem>
                                            <asp:ListItem Value="creationdate">
                Creation Date
                                            </asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-12 col-md-12 pad1" style="vertical-align: top;">
                                <asp:MultiView ID="MultiView1" runat="server">
                                    <asp:View ID="View1" runat="server">
                                        <asp:Repeater ID="dlemployee" runat="server" OnItemCommand="dlemployee_ItemCommand"  
                                           >
                                            <HeaderTemplate>
                                                <table cellpadding="0" class="tblfile-main " cellspacing="0">
                                                    <tr>
                                                        <th>Employee
                                                        </th>
                                                        <th>Date Modified
                                                        </th>
                                                         <th>File Size</th>
                                                          <th>File Type</th>
                                                         
                                                    </tr>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <tr >
                                                    <td >
                                                        <div class="divfile_inner">
                                                            <div style="float: left;">
                                                                <asp:LinkButton ID="lbtnuserfile" runat="server" CommandArgument='<%#Eval("nid") + ";" + Eval("username") %>'
                                                                    CssClass="file-span-open">
                                    <span style="background-image:url(Libraryimg/folder.png);" class='status<%# DataBinder.Eval(Container.DataItem, "activestatus")%>' ><%# DataBinder.Eval(Container.DataItem, "username")%></span>
                                                                </asp:LinkButton>
                                                            </div>
                                                        </div>
                                                        <div class="clear">
                                                        </div>
                                                    </td>
                                                    <td class='status<%# DataBinder.Eval(Container.DataItem, "activestatus")%>'>
                                                        <%# DataBinder.Eval(Container.DataItem, "lastmodified")%>
                                                    </td>
                                                   <%-- <td>
                                                        <asp:LinkButton ID="lbtndetail" ToolTip="View Detail" runat="server" CommandArgument='<%#Eval("nid") + ";" + Eval("username") %>'
                                                            CommandName="detail"><img alt="" src="images/view.png" /></asp:LinkButton>
                                                    </td>
                                                 --%>
                                                    
                                                        <td>
                                                        <%# DataBinder.Eval(Container.DataItem, "filesize")  %>
                                                       </td>

                                                    <td></td>
                                                     <td>
                                                        <asp:LinkButton ID="LinkButton1" ToolTip="View Detail" runat="server" CommandArgument='<%#Eval("nid") + ";" + Eval("username") %>'
                                                            CommandName="detail"><img alt="" src="images/view.png" /></asp:LinkButton>
                                                    </td>
                                                </tr>
                                            </ItemTemplate>

                                         
                                            <FooterTemplate>
                                                </table>
                                            </FooterTemplate>
                                        </asp:Repeater>
                                    </asp:View>
                                    <asp:View ID="View2" runat="server">
                                        <input type="hidden" id="hidselect" runat="server" value="" /><input type="hidden"
                                            id="hiddivid" runat="server" value="" />
                                        <asp:DataList ID="dlfile" CellPadding="0" runat="server" Width="100%" OnItemCommand="dlfile_ItemCommand"
                                            OnItemDataBound="dlfile_ItemDataBound">
                                            <HeaderTemplate>
                                                <table width="99.5%" cellpadding="0" class="tblfile" cellspacing="0">
                                                    <tr>
                                                        <th width="20">
                                                            <asp:CheckBox ID="chkselect" runat="server" CssClass="divcheck" onclick="CheckAll(this);" />
                                                        </th>
                                                        <th width="50%">Name
                                                        </th>
                                                        <th>Date Modified
                                                        </th>
                                                        <th>Type
                                                        </th>
                                                         
                                                         <th>Size
                                                        </th>
                                                         <th>Action
                                                        </th>
                                                    </tr>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <tr>
                                                    <td>
                                                        <asp:CheckBox ID="chkselect" runat="server" CssClass="divcheck" />
                                                    </td>
                                                    <td>
                                                        <div class="divfile_inner">
                                                            <input type="hidden" runat="server" id="hidnid" value='<%# DataBinder.Eval(Container.DataItem, "nid")%>' />
                                                            <input type="hidden" id="hidlinktype" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "linktype")%>' />
                                                            <input type="hidden" id="hidloginid" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "loginid")%>' />
                                                            <div style="float: left;">
                                                                <asp:LinkButton ID="lbtnopen" runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "nid")%>'
                                                                    CommandName="open" CssClass="file-span-open"> <span style='background-image: url(Libraryimg/<%#DataBinder.Eval(Container.DataItem, "newicon")%>)'>
                                                        <%# DataBinder.Eval(Container.DataItem, "originalfilename1")%></span></asp:LinkButton>
                                                               
                                                            </div>
                                                        </div>
                                                        <div class="clear">
                                                        </div>
                                                        <div id="divfilepath" runat="server" class="filepath">
                                                            <%# DataBinder.Eval(Container.DataItem, "filepath")%>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <%# DataBinder.Eval(Container.DataItem, "modificationdate")%>
                                                    </td>
                                                    <td>
                                                        <%# DataBinder.Eval(Container.DataItem,"linktype").ToString()==  "file"?
                                                                DataBinder.Eval(Container.DataItem, "ext").ToString().Replace(".","").ToUpper() :
                                                                DataBinder.Eval(Container.DataItem,"linktype").ToString().ToUpper() %>
                                                    </td>
                                                     <td>
                                                        <%# DataBinder.Eval(Container.DataItem, "FileSize")  %>
                                                    </td>
                                                
                                                    <td>

                                                                <div class="divcontrol">
                                                                    <asp:LinkButton ID="lbtnrename" ToolTip="Rename" runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "nid")%>'
                                                                        CommandName="edit"><img alt="" src="images/edit.png" /></asp:LinkButton>
                                                                    <asp:LinkButton ID="lbtndelete" runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "nid")%>'
                                                                        CommandName="delete" ToolTip="Delete"><img alt="" src="images/delete.png" /></asp:LinkButton>
                                                                    <asp:LinkButton ID="lbtndetail" ToolTip="View Detail" runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "nid")%>'
                                                                        CommandName="detail"><img alt="" src="images/view.png" /></asp:LinkButton>
                                                                </div>
                                                   <%-- <div class="divfile_inner">
                                                            <input type="hidden" runat="server" id="hidnid" value='<%# DataBinder.Eval(Container.DataItem, "nid")%>' />
                                                            <input type="hidden" id="hidlinktype" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "linktype")%>' />
                                                            <input type="hidden" id="hidloginid" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "loginid")%>' />
                                                            <div style="float: left;">
                                                                <asp:LinkButton ID="lbtnopen" runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "nid")%>'
                                                                    CommandName="open" CssClass="file-span-open"> <span style='background-image: url(Libraryimg/<%#DataBinder.Eval(Container.DataItem, "newicon")%>)'>
                                                        <%# DataBinder.Eval(Container.DataItem, "originalfilename1")%></span></asp:LinkButton>
                                                                <div class="divcontrol">
                                                                    <asp:LinkButton ID="lbtnrename" ToolTip="Rename" runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "nid")%>'
                                                                        CommandName="edit"><img alt="" src="images/edit.png" /></asp:LinkButton>
                                                                    <asp:LinkButton ID="lbtndelete" runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "nid")%>'
                                                                        CommandName="delete" ToolTip="Delete"><img alt="" src="images/delete.png" /></asp:LinkButton>
                                                                    <asp:LinkButton ID="lbtndetail" ToolTip="View Detail" runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "nid")%>'
                                                                        CommandName="detail"><img alt="" src="images/view.png" /></asp:LinkButton>
                                                                </div>
                                                            </div>
                                                        </div>--%>
                                                       <%-- <div class="clear">
                                                        </div>
                                                        <div id="divfilepath" runat="server" class="filepath">
                                                            <%# DataBinder.Eval(Container.DataItem, "filepath")%>
                                                        </div>--%>

                                                        </td>
                                                </tr>
                                            </ItemTemplate>
                                            <EditItemTemplate>
                                                <tr>
                                                    <td>
                                                        <asp:CheckBox ID="chkselect" runat="server" CssClass="divcheck" />
                                                    </td>
                                                    <td>
                                                        <div class="divfile_inner">
                                                            <input type="hidden" runat="server" id="hidnid" value='<%# DataBinder.Eval(Container.DataItem, "nid")%>' />
                                                            <input type="hidden" id="hidlinktype" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "linktype")%>' />
                                                            <input type="hidden" id="hidloginid" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "loginid")%>' />
                                                            <div style="float: left;">
                                                                <a><span style='background-image: url(Libraryimg/<%# DataBinder.Eval(Container.DataItem, "newicon")%>)'>
                                                                    <asp:TextBox ID="txtrename" CssClass="txtrename" runat="server" MaxLength="40" Width="102px"
                                                                        Text='<%# DataBinder.Eval(Container.DataItem, "newname")%>'></asp:TextBox>
                                                                </span>
                                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage=""
                                                                        ValidationGroup="rename" ControlToValidate="txtrename"></asp:RequiredFieldValidator>
                                                                </a>
                                                                <div class="divcontrol">
                                                                    <asp:LinkButton ID="lbtnsaverename" ValidationGroup="rename" runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "nid")%>'
                                                                        CommandName="saverename">
                                                       <i class="fa fa-fw fa-check"></i>
                                                                    </asp:LinkButton>
                                                                    <asp:LinkButton Style="margin-left: 2px;" ID="lbtnresetrename" runat="server" Visible="false"
                                                                        CommandArgument='<%# DataBinder.Eval(Container.DataItem, "nid")%>' CommandName="resetrename">
                                                        <img src="images/delete.png" width="13" alt="Delete" />
                                                                    </asp:LinkButton>
                                                                    <asp:LinkButton ID="lbtndelete" runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "nid")%>'
                                                                        CommandName="delete" ToolTip="Delete"><img src="images/delete.png" alt="" /></asp:LinkButton>
                                                                    <asp:LinkButton ID="lbtndetail" ToolTip="View Detail" runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "nid")%>'
                                                                        CommandName="detail"><img src="images/view.png"  /></asp:LinkButton>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <%# DataBinder.Eval(Container.DataItem, "modificationdate")%>
                                                    </td>
                                                    <td>
                                                        <%# DataBinder.Eval(Container.DataItem, "linktype")%>
                                                    </td>
                                                </tr>
                                            </EditItemTemplate>
                                            <%-- <em>
                                <table width="99.5%" cellpadding="0" class="tblfile" cellspacing="0">
                                    <tr>
                                        <th width="20">
                                            <asp:CheckBox ID="chkselect" runat="server" CssClass="divcheck" onclick="CheckAll(this);" /></th>
                                        <th width="50%">Name</th>
                                        <th>Last Modified

                                        </th>
                                        <th>Type

                                        </th>

                                    </tr>
                                </table>

                            </em>--%>
                                            <FooterTemplate>
                                                </table>
                                            </FooterTemplate>
                                        </asp:DataList>
                                        <table width="99.5%" cellpadding="0" class="tblfile" cellspacing="0" id="tblfilelist"
                                            runat="server" visible="false">
                                            <tr>
                                                <th width="20">
                                                    <asp:CheckBox ID="chkselect" runat="server" CssClass="divcheck" onclick="CheckAll(this);" />
                                                </th>
                                                <th width="50%">Name
                                                </th>
                                                <th>Last Modified
                                                </th>
                                                <th>Type
                                                </th>
                                            </tr>
                                        </table>
                                    </asp:View>
                                </asp:MultiView>
                                <div class="clear">
                                </div>
                            </div>
                            <div class="clear">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
