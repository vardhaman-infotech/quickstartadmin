<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="settings.aspx.cs" Inherits="empTimeSheet.settings" %>

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
            background: #1d2939;
            padding: 12px;
            float: left;
        }

            .background_image img {
                border-radius: 45%;
                width: 150px;
            }

        .link_div {
            border-bottom: dashed 1px #999999;
            padding-bottom: 4px;
            width: 100%;
            clear: both;
            margin-bottom: 6px;
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
            val = val.replace("C:\\fakepath\\", "");
            document.getElementById("divfilename").innerHTML = val;
            document.getElementById("divfiledetail").style.display = "block";
        }
        function removefile() {

            document.getElementById("divfilename").innerHTML = "";
            document.getElementById("divfiledetail").style.display = "none";
            document.getElementById("<%=FileUpload1.ClientID %>").innerHTML = "";
        }
    </script>
    <script type="text/javascript">

        function divpassshow() {
            $('#divpasschange').toggle();
        }

        function divmailshow() {
            $('#divemailtext').hide();
            $('#divEmail').show();
        }


        function divcellshow() {
            $('#divcelltext').hide();
            $('#divCell').show();
        }

        function divskypeshow() {

            $('#divstextskype').hide();
            $('#divskype').show();
        }


        function divpasshide() {
            $('#divpasschange').hide();
        }

        function divEmailhide() {
            $('#divEmail').hide();
            $('#divemailtext').show();
        }

        function divCellHide() {
            $('#divCell').hide();
            $('#divcelltext').show();

        }

        function divskypeHide() {
            $('#divskype').hide();
            $('#divstextskype').show();

        }


        function HideDivs(id) {
            switch (id) {
                case "divpasschange":
                    {
                        divEmailhide();
                        divCellHide();
                        divskypeHide();

                        break;
                    }
                case "divEmail":
                    {
                        divpasshide();
                        divCellHide();
                        divskypeHide();

                        break;
                    }

                case "divCell":
                    {
                        divpasshide();
                        divEmailhide();
                        divskypeHide();

                        break;
                    }

                case "divskype":
                    {
                        divpasshide();
                        divEmailhide();
                        divCellHide();
                    }


            }
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:UpdatePanel ID="upadatepanel1" runat="server">
        <ContentTemplate>
            <input type="hidden" id="hidid" runat="server" />
            <input type="hidden" id="hidaddress" runat="server" />
            <input type="hidden" id="hidrate" runat="server" />
            <pg:progress ID="progress1" runat="server" />
            <div class="pageheader">
                <h2>
                    <i class="fa circle"></i> Settings
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
                                            <div id="divupload">
                                                <asp:Button ID="btnupload" runat="server" CssClass="btn btn-primary" Text="Upload"
                                                    OnClick="btnupload_Click" />
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-12 col-md-12">
                                        <div class="m_Panel">
                                            <div class="panel-default">
                                                <div class="panel-body">
                                                    <div class="col-sm-5 col-md-5 pad">
                                                        <h3 class="pad6 font_size2">
                                                            <strong>
                                                                <asp:Literal ID="litusername1" runat="server"></asp:Literal></strong> <span class="font_size">
                                                                    <asp:Literal ID="litdsignation1" runat="server" Text=""></asp:Literal></span>
                                                        </h3>
                                                        <p class="pFontSize">
                                                            <asp:Literal ID="litdepartment1" runat="server" Text=""></asp:Literal>
                                                        </p>
                                                        <p class="pFontSize">
                                                            <asp:Literal ID="ltrAddress1" runat="server"></asp:Literal>
                                                        </p>
                                                        <p class="pFontSize">
                                                            <asp:Literal ID="ltrAddress2" runat="server"></asp:Literal>
                                                        </p>
                                                        <p class="pFontSize">
                                                            <asp:Literal ID="ltrAddress3" runat="server"></asp:Literal>
                                                        </p>
                                                    </div>
                                                    <div class="col-sm-7 col-md-7">
                                                        <div class="link_div">
                                                            <p class="f_left pFontSize">
                                                                Password: **********
                                                            </p>
                                                            <a id="lnkPass" class="f_right aFontSize" onclick="HideDivs('divpasschange');divpassshow();">Edit</a>
                                                            <div class="clear">
                                                            </div>
                                                        </div>
                                                        <asp:Label ID="lblError1" runat="server" CssClass="errmsg" Style="text-align: center; color: Red;"></asp:Label>
                                                        <div id="divpasschange" style="display: none; font-size: 11px; border-bottom: 1px dashed #999999;">
                                                            <label class="col-sm-4 control-label pFontSize" style="color: Black;">
                                                                Old Password:
                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*"
                                                                ControlToValidate="txtOldPass" ValidationGroup="pass"></asp:RequiredFieldValidator>
                                                            </label>
                                                            <div class="col-sm-8">
                                                                <asp:TextBox ID="txtOldPass" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                                                            </div>
                                                            <div class="clear">
                                                            </div>
                                                            <label class="col-sm-4 control-label pFontSize" style="color: Black;">
                                                                New Password:
                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                                                                ErrorMessage="*" ControlToValidate="txtNew" ValidationGroup="pass"></asp:RequiredFieldValidator>
                                                            </label>
                                                            <div class="col-sm-8">
                                                                <asp:TextBox ID="txtNew" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                                                            </div>
                                                            <div class="clear">
                                                            </div>
                                                            <label class="col-sm-4 control-label pFontSize" style="color: Black;">
                                                                Confirm Password: 
                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="*"
                                                                ControlToValidate="txtConfirm" ValidationGroup="pass"></asp:RequiredFieldValidator>
                                                            </label>
                                                            <div class="col-sm-8">
                                                                <asp:TextBox ID="txtConfirm" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                                                                <asp:CompareValidator ID="CompareValidator2" runat="server" ValidationGroup="pass"
                                                                    ControlToValidate="txtConfirm" CssClass="errmsg" ControlToCompare="txtNew"
                                                                    ErrorMessage="Your password and confirm password must match.">
                                                                </asp:CompareValidator>
                                                            </div>
                                                            <div class="clear">
                                                            </div>

                                                            <label1 class="col-sm-4 control-label">
                                                            &nbsp;
                                                           </label1>
                                                            <div class="col-sm-8">
                                                                <asp:Button ID="btnChangePass" runat="server" Text="Save" OnClick="btnChangePass_OnClick"
                                                                    ValidationGroup="pass" CssClass="btn btn-primary"></asp:Button>
                                                                <input type="button" id="btncancel" value="Cancel" onclick="divpasshide();" class="btn btn-primary" />
                                                            </div>
                                                            <div class="clear">
                                                            </div>

                                                        </div>
                                                        <div class="link_div mar4">
                                                            <div class="f_left marright ">
                                                                <p class="f_left pFontSize">Email:</p>

                                                            </div>
                                                            <div id="divemailtext" class="f_left ">
                                                                <p class="pFontSize">
                                                                    <asp:Literal ID="ltrEmail" runat="server"></asp:Literal>
                                                                </p>

                                                            </div>

                                                            <div id="divEmail" style="display: none; margin-top: 2px;" class="f_left">

                                                                <asp:TextBox ID="txtemail" runat="server" CssClass="sett_textbox marright f_left"
                                                                    ValidationGroup="pass1">
                                                                </asp:TextBox>
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="*"
                                                                    ControlToValidate="txtemail" ValidationGroup="pass1"></asp:RequiredFieldValidator>

                                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" CssClass="errmsg"
                                                                    runat="server" ErrorMessage="Please Enter Valid Email ID" ControlToValidate="txtemail"
                                                                    ValidationGroup="pass1" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">
                                                                </asp:RegularExpressionValidator>
                                                                <asp:Button ID="btnChangeEmail" runat="server" Text="Save" OnClick="btnChangeEmail_OnClick"
                                                                    ValidationGroup="pass1" CssClass="btn sett_btn marright f_left"></asp:Button>
                                                                <input type="button" id="btncancel1" value="Cancel" onclick="divEmailhide();"
                                                                    class="btn sett_btn marright f_left" />
                                                            </div>
                                                            <a id="lnkEmail" class="f_right aFontSize" onclick="HideDivs('divEmail');divmailshow();">Edit</a>
                                                            <div class="clear">
                                                            </div>
                                                        </div>
                                                        <div class="link_div mar">
                                                            <div class="f_left marright ">
                                                                <p class="pFontSize">Cell:</p>
                                                            </div>
                                                            <div id="divcelltext" class="f_left ">
                                                                <p class="pFontSize">
                                                                    <asp:Literal ID="ltrPhone" runat="server"></asp:Literal>
                                                                </p>
                                                            </div>
                                                            <div id="divCell" style="display: none; margin-top: 2px;" class="f_left">
                                                                <asp:TextBox ID="txtCell" runat="server" CssClass="sett_textbox marright f_left"></asp:TextBox>
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="*"
                                                                    ControlToValidate="txtCell" ValidationGroup="savecell"></asp:RequiredFieldValidator>
                                                                <asp:Button ID="btnChangeCell" runat="server" Text="Save" OnClick="btnChangeCell_OnClick"
                                                                    ValidationGroup="savecell" CssClass="btn sett_btn marright f_left"></asp:Button>
                                                                <input type="button" id="btncancel2" value="Cancel" onclick="divCellHide();" class="btn sett_btn marright f_left" />
                                                            </div>
                                                            <a id="lnkCell" class="f_right aFontSize" onclick="HideDivs('divCell');divcellshow();">Edit</a>
                                                            <div class="clear">
                                                            </div>
                                                        </div>
                                                        <div class="clear">
                                                        </div>
                                                        <div class="link_div mar">
                                                            <div class="f_left marright ">
                                                                <p class="pFontSize">Skype:</p>
                                                            </div>
                                                            <div id="divstextskype" class="f_left ">
                                                                <p class="pFontSize">
                                                                    <asp:Literal ID="ltrSkype" runat="server"></asp:Literal>
                                                                </p>
                                                            </div>
                                                            <div id="divskype" style="display: none;" class="f_left">
                                                                <asp:TextBox ID="txtSkype" runat="server" CssClass="sett_textbox marright f_left"></asp:TextBox>
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ErrorMessage="*"
                                                                    ControlToValidate="txtSkype" ValidationGroup="saveSkype"></asp:RequiredFieldValidator>
                                                                <asp:Button ID="btnChangeSkype" runat="server" Text="Save" OnClick="btnChangeSkype_OnClick"
                                                                    ValidationGroup="saveSkype" CssClass="btn sett_btn marright f_left"></asp:Button>
                                                                <input type="button" id="Button2" value="Cancel" onclick="divskypeHide();" class="btn sett_btn marright f_left" />
                                                            </div>
                                                            <a id="lnkSkype" class="f_right aFontSize" onclick="HideDivs('divskype');divskypeshow();">Edit</a>
                                                            <div class="clear">
                                                            </div>
                                                        </div>
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
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnupload" />
        </Triggers>
    </asp:UpdatePanel>

</asp:Content>
