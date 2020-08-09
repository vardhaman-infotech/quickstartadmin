<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="CompanySettings_Old.aspx.cs" Inherits="empTimeSheet.CompanySettings_old" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .m_Panel {
            background-color: #fff;
            margin-bottom: 20px;
            box-shadow: 5px 3px 5px #888;
            border-radius: 4px;
            min-height: 200px;
            height: auto;
            width: 100%;
            font-size: 12px;
        }

        .pad6 {
            padding-bottom: 8px;
        }

        .font_size {
            font-size: 15px;
        }

        .font_size2 {
            font-size: 20px;
        }

        .mar4 {
            margin-top: 30px;
        }

        .background_image {
            background: #ffffff;
            padding: 12px;
            float: left;
            border-top-left-radius: 5px;
            border-top-right-radius: 5px;
        }

            .background_image img {
                max-width: 200px;
            }

        .link_div {
            border-bottom: dashed 1px #999999;
            padding-bottom: 4px;
            width: 100%;
            clear: both;
            margin-bottom: 6px;
            margin-top: 10px;
            font-weight: bold;
        }

            .link_div p {
                padding: 8px 0 0 0;
                margin: 0px;
            }

        .aFontSize {
            font-size: 12px;
            padding-top: 14px;
        }

        .pFontSize {
            font-size: 13px;
        }

        .sett_textbox {
            background-color: #fff;
            background-image: none;
            border: 1px solid #cdcdcd;
            border-radius: 4px;
            box-shadow: 0 1px 1px rgba(0, 0, 0, 0.075) inset;
            color: #555;
            display: block;
            font-size: 13px;
            padding: 6px 12px;
            transition: border-color 0.15s ease-in-out 0s, box-shadow 0.15s ease-in-out 0s;
            width: 200px;
        }

        .sett_btn {
            background-color: #428bca;
            border-color: #357ebd;
            color: #fff;
            padding: 3px 10px;
            font-size: 12px;
            margin-top: 10px;
        }

        .marright {
            margin-right: 5px;
        }

        .martop {
            margin: 8px 0 0;
        }
    </style>
    <script type="text/javascript">
        function openfile() {
            // $("#ctl00_ContentPlaceHolder1_FileUpload1").click();

            $("#ctl00_ContentPlaceHolder1_FileUpload1").trigger('click');
            return false;

        }
        function fileupload(val) {


            var fileEl = document.getElementById('<%=FileUpload1.ClientID%>');

            var fileName = fileEl.files[0].name;
            var dotPosition = fileName.lastIndexOf(".");
            var extension = String(fileName.substring(dotPosition)).toUpperCase();
            if (extension != ".JPG" && extension != ".JPEG" && extension != ".PNG" && extension != ".GIF") {
                removefile();
                alert("Selected file is not an Image");
                return false;
            }
            else {
                val = val.replace("C:\\fakepath\\", "");
                document.getElementById("divfilename").innerHTML = val;
                document.getElementById("divfiledetail").style.display = "block";
            }
        }
        function removefile() {

            document.getElementById("divfilename").innerHTML = "";
            document.getElementById("divfiledetail").style.display = "none";
            document.getElementById("<%=FileUpload1.ClientID %>").innerHTML = "";
        }
    </script>
    <script type="text/javascript">

        function bindPageEvent() {
            $(function () {
                function moveItems(origin, dest) {
                    $(origin).find(':selected').appendTo(dest);
                }
                $('#Button2').click(function () {
                    moveItems('#ctl00_ContentPlaceHolder1_listcode2', '#ctl00_ContentPlaceHolder1_listcode1'); //left
                    addscheduleinhidden();
                });

                $('#Button1').click(function () {
                    moveItems('#ctl00_ContentPlaceHolder1_listcode1', '#ctl00_ContentPlaceHolder1_listcode2');  //right
                    addscheduleinhidden();
                });

                $('#btnremoveleave').click(function () {
                    moveItems('#ctl00_ContentPlaceHolder1_listleave2', '#ctl00_ContentPlaceHolder1_listleave1'); //left
                    addleaveinhidden();
                });

                $('#btnaddleave').click(function () {
                    moveItems('#ctl00_ContentPlaceHolder1_listleave1', '#ctl00_ContentPlaceHolder1_listleave2');  //right
                    addleaveinhidden();
                });

            });
        }

        function addscheduleinhidden() {
            var strval = "";
            $("#ctl00_ContentPlaceHolder1_listcode2 > option").each(function () {

                strval += this.value + '#';
            });
            document.getElementById('ctl00_ContentPlaceHolder1_hidscheduleemailemp').value = strval;
        }
        function addleaveinhidden() {
            var strval = "";
            $("#ctl00_ContentPlaceHolder1_listleave2 > option").each(function () {

                strval += this.value + '#';
            });
            document.getElementById('ctl00_ContentPlaceHolder1_hidleaveemailemp').value = strval;
        }
    </script>
    <script type="text/javascript">
        function validate() {

        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:UpdatePanel ID="upadatepanel1" runat="server">
        <ContentTemplate>
            <script type="text/javascript">
                Sys.Application.add_load(bindPageEvent);
            </script>
            <input type="hidden" id="hidid" runat="server" />
            <input type="hidden" id="hidaddress" runat="server" />
            <input type="hidden" id="hidrate" runat="server" />
            <pg:progress ID="progress1" runat="server" />
            <div class="pageheader">
                <h2>
                    <i class="fa circle"></i>Company Settings
                </h2>
                <div class="breadcrumb-wrapper">
                </div>
                <div class="clear">
                </div>
            </div>
            <div class="clear">
            </div>
            <div class="contentpanel">
                <div class="row">
                    <!-- col-sm-3 -->
                    <div class="col-sm-12 col-md-12">
                        <div class="panel-default">
                            <div class="panel-body">
                                <asp:ValidationSummary ID="valSum"
                                    DisplayMode="BulletList"
                                    EnableClientScript="true"
                                    HeaderText="There were errors in your form submission:<br/>Please complete all mandatory fields."
                                    runat="server" ValidationGroup="save" CssClass="errorsummary" />
                                <div class="row">
                                    <div class="col-sm-12 col-md-12">
                                        <div class="background_image">
                                            <img id="divuserphoto" runat="server" src="webfile/profile/nophoto.png" alt="" />
                                        </div>
                                        <asp:FileUpload ID="FileUpload1" runat="server" CssClass="fileupload" ToolTip="Change Picture"
                                            onchange="fileupload(this.value);" />
                                        <div id="divfiledetail" class="pad1" style="display: none; font-size: 12px; float: left;">
                                            <label class="f_left" id="divfilename">
                                            </label>
                                            <div style="float: left; padding-left: 5px; padding-top: 10px;">
                                                <a onclick="removefile();">
                                                    <img src="images/delete.png" title="Remove File" alt="" /></a>
                                            </div>
                                            <div id="divupload" class="pad5 mar">
                                                <asp:Button ID="btnupload" runat="server" CssClass="btn btn-primary" Text="Upload"
                                                    OnClick="btnupload_Click" />
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-12 col-md-12">
                                        <div class="m_Panel">
                                            <div class="panel-default">
                                                <div class="panel-body">
                                                    <div class="col-sm-5 col-md-5 pad" style="margin-left: 15px;">
                                                        <h3 class="pad6 font_size2">
                                                            <b><strong>
                                                                <asp:Literal ID="litcompanyname" runat="server"></asp:Literal></strong></b> <span class="font_size">
                                                                    <asp:Literal ID="litdsignation1" runat="server" Text=""></asp:Literal></span>
                                                        </h3>
                                                        <p class="pFontSize">
                                                            <asp:Literal ID="litemail" runat="server" Text=""></asp:Literal>
                                                        </p>
                                                        <p class="pFontSize">
                                                            <asp:Literal ID="litwebsite" runat="server"></asp:Literal>
                                                        </p>
                                                    </div>
                                                    <div class="clear">
                                                    </div>
                                                    <div class="col-sm-12 col-md-12 " style="font-size: 11px;">
                                                        <div class="link_div">
                                                            <label class="col-sm-2 control-label pFontSize pad4" style="color: Black;">
                                                                <b>Company Small Logo:</b>

                                                            </label>
                                                            <div class="col-sm-2">
                                                                <asp:FileUpload ID="FileUpload2" runat="server" ToolTip="Change Picture" />

                                                            </div>
                                                            <div class="col-sm-4">
                                                                <asp:Button ID="btnupload1" runat="server" CssClass="btn btn-primary" Text="Upload"
                                                                    OnClick="btnupload1_Click" />
                                                            </div>
                                                            <div class="clear">
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="clear">
                                                    </div>
                                                    <div class="col-sm-6 col-md-6">
                                                        <div class="link_div">
                                                            General Information
                                                            <div class="clear">
                                                            </div>
                                                        </div>

                                                        <div class="clear">
                                                        </div>
                                                        <div style="font-size: 11px;">

                                                            <label class="col-sm-4 control-label pFontSize pad4" style="color: Black;">
                                                                Name *
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage=""
                                                                    ControlToValidate="txtcompanyName" ValidationGroup="save" Style="display: none;"></asp:RequiredFieldValidator>
                                                            </label>
                                                            <div class="col-sm-8">
                                                                <asp:TextBox ID="txtcompanyName" runat="server" CssClass="form-control"></asp:TextBox>
                                                            </div>
                                                            <div class="clear">
                                                            </div>
                                                            <label class="col-sm-4 control-label pFontSize pad4" style="color: Black;">
                                                                Server Company Name *
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" Style="display: none;" ErrorMessage=""
                                                                    ControlToValidate="txtservercompanyname" ValidationGroup="save"></asp:RequiredFieldValidator>
                                                            </label>
                                                            <div class="col-sm-8">
                                                                <asp:TextBox ID="txtservercompanyname" runat="server" CssClass="form-control"></asp:TextBox>
                                                            </div>
                                                            <div class="clear">
                                                            </div>
                                                            <label class="col-sm-4 control-label pFontSize pad4" style="color: Black;">
                                                                Email *
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" Style="display: none;" ErrorMessage="" ControlToValidate="txtEmail" ValidationGroup="save">

                                                                </asp:RequiredFieldValidator>
                                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" CssClass="errmsg" Style="display: none;" runat="server" ErrorMessage="Invalid Email!" ControlToValidate="txtEmail" ValidationGroup="save"
                                                                    ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">
                                                                </asp:RegularExpressionValidator>
                                                            </label>
                                                            <div class="col-sm-8">
                                                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"></asp:TextBox>
                                                            </div>
                                                            <div class="clear">
                                                            </div>
                                                            <label class="col-sm-4 control-label pFontSize pad4" style="color: Black;">
                                                                Website   
                                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator4" CssClass="errmsg" Style="display: none;" runat="server" ErrorMessage="Invalid Website!" ControlToValidate="txtwebsite" ValidationGroup="save"
                                                                    ValidationExpression="http(s)?://([\w-]+\.)+[\w-]+(/[\w- ./?%&amp;=]*)?"></asp:RegularExpressionValidator>

                                                            </label>
                                                            <div class="col-sm-8">
                                                                <asp:TextBox ID="txtwebsite" runat="server" CssClass="form-control"></asp:TextBox>
                                                            </div>
                                                            <div class="clear">
                                                            </div>
                                                            <label class="col-sm-4 control-label pFontSize pad4" style="color: Black;">
                                                                Currency *
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server" Style="display: none;" ErrorMessage=""
                                                                    ControlToValidate="ddlcurrency" ValidationGroup="save"></asp:RequiredFieldValidator>
                                                            </label>
                                                            <div class="col-sm-8">
                                                                <asp:DropDownList ID="ddlcurrency" runat="server" CssClass="form-control">
                                                                </asp:DropDownList>
                                                            </div>

                                                            <div class="clear">
                                                            </div>
                                                            <label class="col-sm-4 control-label pFontSize pad4" style="color: Black;">
                                                                Timezone *
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" Style="display: none;" ErrorMessage=""
                                                                    ControlToValidate="droptimezone" ValidationGroup="save"></asp:RequiredFieldValidator>
                                                            </label>
                                                            <div class="col-sm-8">
                                                                <asp:DropDownList ID="droptimezone" runat="server" CssClass="form-control">
                                                                </asp:DropDownList>
                                                            </div>
                                                            <div class="clear">
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-sm-6 col-md-6">
                                                        <div class="link_div">
                                                            Email Settings
                                                            <div class="clear">
                                                            </div>
                                                        </div>
                                                        <div style="font-size: 11px;">
                                                            <label class="col-sm-4 control-label pFontSize pad4" style="color: Black;">
                                                                Sender Email *
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="Invalid Sender Email!"
                                                                    ControlToValidate="txtsenderEmail" ValidationGroup="email" Style="display: none;"></asp:RequiredFieldValidator>
                                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator2" CssClass="errmsg"
                                                                    runat="server" ErrorMessage="Invalid!" ControlToValidate="txtsenderEmail" ValidationGroup="email"
                                                                    ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">
                                                                </asp:RegularExpressionValidator>
                                                            </label>
                                                            <div class="col-sm-8">
                                                                <asp:TextBox ID="txtsenderEmail" runat="server" CssClass="form-control"></asp:TextBox>
                                                            </div>
                                                            <div class="clear">
                                                            </div>
                                                            <label class="col-sm-4 control-label pFontSize pad4" style="color: Black;">
                                                                Sender Password *
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ErrorMessage=""
                                                                    ControlToValidate="txtsenderpass" ValidationGroup="email" Style="display: none;"></asp:RequiredFieldValidator>
                                                            </label>
                                                            <div class="col-sm-8">
                                                                <asp:TextBox ID="txtsenderpass" runat="server" CssClass="form-control"></asp:TextBox>
                                                            </div>
                                                            <div class="clear">
                                                            </div>
                                                            <label class="col-sm-4 control-label pFontSize pad4" style="color: Black;">
                                                                Receiver Email *
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="Invalid Receiver Email!"
                                                                    ControlToValidate="txtreceiveremail" ValidationGroup="email" Style="display: none;"></asp:RequiredFieldValidator>
                                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator3" CssClass="errmsg"
                                                                    runat="server" ErrorMessage="Invalid!" ControlToValidate="txtreceiveremail" ValidationGroup="email"
                                                                    ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">
                                                                </asp:RegularExpressionValidator>
                                                            </label>
                                                            <div class="col-sm-8">
                                                                <asp:TextBox ID="txtreceiveremail" runat="server" CssClass="form-control"></asp:TextBox>
                                                            </div>
                                                            <div class="clear">
                                                            </div>
                                                            <label class="col-sm-4 control-label pFontSize pad4" style="color: Black;">
                                                                Mail Host *<asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server"
                                                                    ErrorMessage="" ControlToValidate="txtmailhost" ValidationGroup="email" Style="display: none;"></asp:RequiredFieldValidator>
                                                            </label>
                                                            <div class="col-sm-8">
                                                                <asp:TextBox ID="txtmailhost" runat="server" CssClass="form-control"></asp:TextBox>
                                                            </div>
                                                            <div class="clear">
                                                            </div>
                                                            <label class="col-sm-4 control-label pFontSize pad4" style="color: Black;">
                                                                Email Notifications * 
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ErrorMessage=""
                                                                    ControlToValidate="rdlemailnoti" ValidationGroup="email" Style="display: none;"></asp:RequiredFieldValidator>
                                                            </label>
                                                            <div class="col-sm-4">
                                                                <asp:RadioButtonList ID="rdlemailnoti" CssClass="checkboxauto" runat="server" RepeatDirection="Horizontal">
                                                                    <asp:ListItem Selected="True">On</asp:ListItem>
                                                                    <asp:ListItem>Off</asp:ListItem>
                                                                </asp:RadioButtonList>

                                                            </div>
                                                            <div class="col-sm-4">
                                                                <asp:Button ID="btntestemail" runat="server" CausesValidation="true" ValidationGroup="email" CssClass="btn btn-default" Text="Send Test Email" OnClientClick="var valFunc1 = validatefieldsbygroup('email');if(valFunc1 == true) {return true;} else{return false;}"
                                                                    OnClick="btntestemail_Click" />

                                                            </div>
                                                            <div class="clear">
                                                            </div>
                                                        </div>
                                                    </div>


                                                    <div class="clear">
                                                    </div>
                                                    <div class="col-sm-12 col-md-12">
                                                        <div class="link_div">
                                                            Billing Setting
                                                            <div class="clear">
                                                            </div>
                                                        </div>
                                                        <div style="font-size: 11px;">

                                                            <label class="col-sm-2 control-label pFontSize pad4" style="color: Black;">
                                                                Next Invoice No. *
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator11" runat="server" Style="display: none;" ErrorMessage=""
                                                                    ControlToValidate="txtnextinvoiceno" ValidationGroup="save"></asp:RequiredFieldValidator>
                                                            </label>
                                                            <div class="col-sm-4">
                                                                <asp:TextBox ID="txtnextinvoiceno" runat="server" CssClass="form-control" onkeypress="blockNonNumbers(this, event, true, false);"
                                                                    onkeyup="extractNumber(this,2,false);"></asp:TextBox>
                                                            </div>
                                                            <div class="clear"></div>
                                                            <label class="col-sm-2 control-label pFontSize pad4" style="color: Black;">
                                                                Invoice Prefix
                                                            
                                                            </label>
                                                            <div class="col-sm-4">
                                                                <asp:TextBox ID="txtprefix" runat="server" CssClass="form-control" MaxLength="15"></asp:TextBox>
                                                            </div>
                                                            <div class="clear"></div>
                                                            <label class="col-sm-2 control-label pFontSize pad4" style="color: Black;">
                                                                Invoice Suffix
                                                              
                                                            </label>
                                                            <div class="col-sm-4">
                                                                <asp:TextBox ID="txtpostfix" runat="server" CssClass="form-control"></asp:TextBox>
                                                            </div>
                                                            <div class="clear">
                                                            </div>


                                                        </div>
                                                    </div>

                                                    <div class="clear">
                                                    </div>
                                                    <div class="col-sm-12 col-md-12">
                                                        <div class="link_div">
                                                            Schedule Email Send To
                                                            <div class="clear">
                                                            </div>
                                                        </div>
                                                        <div style="font-size: 11px;">
                                                            <div class="f_left pad1">
                                                                <asp:ListBox ID="listcode1" runat="server" Width="200px" Height="200px" SelectionMode="Multiple"
                                                                    CssClass="RadListBox1"></asp:ListBox>
                                                            </div>
                                                            <div class="f_left" style="padding: 48px 24px; text-align: center;">
                                                                <div class="f_left">
                                                                    <input type="button" id="Button1" class="btn btn-default" style="width: 70px; padding: 2px;"
                                                                        value="Add" />
                                                                </div>
                                                                <div class="clear">
                                                                </div>
                                                                <div class="f_left padtop10">
                                                                    <input type="button" class="btn btn-default mar" style="width: 70px; padding: 2px;"
                                                                        value="Remove" id="Button2" />
                                                                </div>
                                                            </div>
                                                            <div class="f_left pad1">
                                                                <asp:ListBox ID="listcode2" runat="server" Width="200px" Height="200px" SelectionMode="Multiple"
                                                                    CssClass="listcode2"></asp:ListBox>
                                                            </div>
                                                            <div class="clear">
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-sm-12 col-md-12">
                                                        <div class="link_div">
                                                            Leave Request Email Send To
                                                            <div class="clear">
                                                            </div>
                                                        </div>
                                                        <div style="font-size: 11px; border-bottom: 1px dashed #999999;">
                                                            <div class="f_left pad1">
                                                                <asp:ListBox ID="listleave1" runat="server" Width="200px" Height="200px" SelectionMode="Multiple"
                                                                    CssClass="RadListBox1"></asp:ListBox>
                                                            </div>
                                                            <div class="f_left" style="padding: 48px 20px; text-align: center;">
                                                                <div class="f_left">
                                                                    <input type="button" id="btnaddleave" class="btn btn-default" style="width: 70px; padding: 2px;"
                                                                        value="Add" />
                                                                </div>
                                                                <div class="clear">
                                                                </div>
                                                                <div class="f_left padtop10">
                                                                    <input type="button" class="btn btn-default mar" style="width: 70px; padding: 2px;"
                                                                        value="Remove" id="btnremoveleave" />
                                                                </div>
                                                            </div>
                                                            <div class="f_left pad1">
                                                                <asp:ListBox ID="listleave2" runat="server" Width="200px" Height="200px" SelectionMode="Multiple"
                                                                    CssClass="listcode2"></asp:ListBox>
                                                            </div>
                                                            <div class="clear">
                                                            </div>

                                                            <!-- Attendance Reader code starts-->
                                                            <div class="clear">
                                                            </div>
                                                            <div class="col-sm-12 col-md-12">
                                                                <div class="link_div">
                                                                    Attendance Reader
                                                            <div class="clear">
                                                            </div>
                                                                </div>

                                                                <div class="clear">
                                                                </div>
                                                                <div style="font-size: 11px;">

                                                                    <label class="col-sm-2 control-label pFontSize pad4" style="color: Black;">
                                                                        User Name *
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator12" runat="server" ErrorMessage=""
                                                                    ControlToValidate="txtUserName" ValidationGroup="save" Style="display: none;"></asp:RequiredFieldValidator>
                                                                    </label>
                                                                    <div class="col-sm-4">
                                                                        <asp:TextBox ID="txtUserName" runat="server" CssClass="form-control"></asp:TextBox>
                                                                    </div>

                                                                    <label class="col-sm-2 control-label pFontSize pad4" style="color: Black; padding-left:20px;">
                                                                        Password *
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator13" runat="server" Style="display: none;" ErrorMessage=""
                                                                    ControlToValidate="txtPassword" ValidationGroup="save"></asp:RequiredFieldValidator>
                                                                    </label>
                                                                    <div class="col-sm-4">
                                                                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control"></asp:TextBox>
                                                                    </div>
                                                                    <div class="clear">
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <!-- Attendance Reader code ends-->



                                                            <div class="clear">
                                                            </div>

                                                            <asp:Button ID="btnsaveinfo" runat="server" Text="Save" OnClick="btnSave_OnClick" CausesValidation="true" ValidationGroup="save"
                                                                OnClientClick="var valFunc1 = validatefieldsbygroup('save'); var valFunc2 = validatefieldsbygroup('email');if(valFunc1 == true && valFunc2==true) {return true;} else{return false;}" CssClass="btn sett_btn marright f_left" />
                                                        </div>
                                                    </div>
                                                    <div class="clear">
                                                    </div>
                                                    <div class="col-sm-12 col-md-12">
                                                    </div>
                                                    <!-- panel-body -->
                                                </div>
                                                <!-- panel -->
                                            </div>
                                        </div>
                                        <!-- col-sm-3 -->
                                    </div>
                                </div>
                            </div>
                            <div class="clear">
                            </div>
                        </div>
                    </div>
                    <div class="clear">
                    </div>
                </div>
            </div>
            <!--tabdetails--->
            </div>
            <!--tabContaier--->
            </div>
            <!--Row-->
            </div>
            <!-- panel-body3-->
            </div>
            <!-- panel panel-default-->
            </div>
            <!-- col-sm-8 col-md-9-->
            </div>
            <!--Row-->
            </div>
            <!--contentpanel-->
            <input type="hidden" id="hidscheduleemailemp" runat="server" />
            <input type="hidden" id="hidleaveemailemp" runat="server" />
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnupload" />
            <asp:PostBackTrigger ControlID="btnupload1" />
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>
