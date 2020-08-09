<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="MyAccount.aspx.cs" Inherits="empTimeSheet.MyAccount" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit.HTMLEditor"
    TagPrefix="cc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="css/myAccount.css" type="text/css" />

   
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
        function setprofileID(id) {
            var id2 = document.getElementById("ctl00_ContentPlaceHolder1_hidprofile_activate").value;
            $('#div_' + id2).slideToggle(300);
            document.getElementById("ctl00_ContentPlaceHolder1_hidprofile_activate").value = id;
            document.getElementById(id2).style.background = "#F8F9FA";

            activateprofile();
        }
        function setprofileID1(id) {
            var id2 = document.getElementById("ctl00_ContentPlaceHolder1_hidprofile_activate").value;
            document.getElementById('div_' + id2).style.display = "none";
            document.getElementById("ctl00_ContentPlaceHolder1_hidprofile_activate").value = id;
            document.getElementById(id2).style.background = "#F8F9FA";

            activateprofile();
        }
        function activateprofile() {
            var id = "div_" + document.getElementById("ctl00_ContentPlaceHolder1_hidprofile_activate").value;
            document.getElementById(document.getElementById("ctl00_ContentPlaceHolder1_hidprofile_activate").value).style.background = "#D2D4D5";
            $('#' + id).slideToggle(300);

        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="pageheader">
        <h2>
            <i class="fa fa-user"></i>Settings
        </h2>
        <div class="breadcrumb-wrapper">
        </div>
        <div class="clear">
        </div>
    </div>
    <input type="hidden" id="hidid" runat="server" />
    <input type="hidden" id="hidprofile_activate" runat="server" value="profile_0" />


    <input type="hidden" id="hidaddress" runat="server" />
    <input type="hidden" id="hidrate" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <pg:progress ID="progress1" runat="server" />
            <div class="contentpanel">
                <div class="row">
                    <div class="col-sm-4 col-md-3">
                        <div class="panel panel-default">
                            <div class="panel-body" style="min-height: 324px;">
                                <ul class="help_menu help_menu_width">
                                    <li><a class="visit_menu show_hide" id="profile_0" onclick="setprofileID(this.id);">Profile Picture </a></li>
                                    <li><a id="profile_1" onclick="setprofileID(this.id);">Profile</a></li>
                                    <li><a id="profile_2" onclick="setprofileID(this.id);">Change Password </a></li>
                                    <li><a id="profile_3" onclick="setprofileID(this.id);">Favourite Tasks  </a></li>
                                    <li><a id="profile_4" onclick="setprofileID(this.id);">Favourite Reports  </a></li>
                                </ul>

                            </div>
                        </div>
                    </div>
                    <div class="col-sm-8 col-md-9">
                        <div class="panel panel-default">
                            <div class="panel-body3">
                                <div class="row">
                                    <div class="col-sm-12 col-md-12" style="min-height: 300px;">
                                        <div class="right_help_box slidingDiv" id="div_profile_0" style="display: block;">
                                            <h1>
                                                <span class="span-profile"></span>
                                                <label>
                                                    Profile Picture</label>
                                            </h1>
                                            <div class="line_help">
                                            </div>
                                            <div class="white_base">
                                                <div class="seting_form">
                                                  <iframe id="if_divprofile_1_detail" class="iframe" src="myacc_ProfilePic.aspx" style="border:none; width:100%; height:230px;"></iframe>
                                                </div>
                                                <div class="clear">
                                                </div>
                                            </div>
                                        </div>



                                        <div class="right_help_box slidingDiv" id="div_profile_1" style="display: none;">
                                            <h1>
                                                <span class="span-profile"></span>Edit Profile
                                            </h1>
                                            <div class="line_help">
                                            </div>
                                            <div class="white_base">
                                                <asp:UpdatePanel ID="updateemail" runat="server" UpdateMode="Conditional">
                                                    <ContentTemplate>
                                                         <div class="seting_form">

                                                    <div class="col-sm-5 col-md-5 pad addressdetail">
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

                                                            <div id="divemailtext">
                                                                <div class="f_left marright ">
                                                                    <p class="f_left pFontSize">Email:</p>

                                                                </div>
                                                                <div class="f_left ">
                                                                    <p class="pFontSize">
                                                                        <asp:Literal ID="ltrEmail" runat="server"></asp:Literal>
                                                                    </p>

                                                                </div>
                                                                <a id="lnkEmail" class="f_right aFontSize" onclick="HideDivs('divEmail');divmailshow();">Edit</a>
                                                            </div>
                                                            <div id="divEmail" style="display: none;">
                                                                <div class="f_left marright ">
                                                                    <p class="f_left pFontSize">Email:</p>
                                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="*"
                                                                        ControlToValidate="txtemail" ValidationGroup="pass1"></asp:RequiredFieldValidator>

                                                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" CssClass="errmsg"
                                                                        runat="server" ErrorMessage="Please Enter Valid Email ID" ControlToValidate="txtemail"
                                                                        ValidationGroup="pass1" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">
                                                                    </asp:RegularExpressionValidator>

                                                                </div>
                                                                <div class="f_left" style="margin-top: 2px;">



                                                                    <asp:TextBox ID="txtemail" runat="server" CssClass="sett_textbox marright f_left"
                                                                        ValidationGroup="pass1">
                                                                    </asp:TextBox>

                                                                    <asp:Button ID="btnChangeEmail" runat="server" Text="Save" OnClick="btnChangeEmail_OnClick"
                                                                        ValidationGroup="pass1" CssClass="btn sett_btn marright f_left"></asp:Button>
                                                                    <input type="button" id="btncancel1" value="Cancel" onclick="divEmailhide();"
                                                                        class="btn sett_btn marright f_left" />
                                                                </div>
                                                            </div>
                                                            <div class="clear">
                                                            </div>
                                                        </div>
                                                        <div class="link_div mar">

                                                            <div id="divcelltext">
                                                                <div class="f_left marright ">
                                                                    <p class="pFontSize">Cell:</p>
                                                                </div>
                                                                <div class="f_left ">
                                                                    <p class="pFontSize">
                                                                        <asp:Literal ID="ltrPhone" runat="server"></asp:Literal>
                                                                    </p>
                                                                </div>
                                                                <a id="lnkCell" class="f_right aFontSize" onclick="HideDivs('divCell');divcellshow();">Edit</a>
                                                            </div>
                                                            <div id="divCell" style="display: none;">
                                                                <div class="f_left marright ">
                                                                    <p class="pFontSize">Cell:</p>
                                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="*"
                                                                        ControlToValidate="txtCell" ValidationGroup="savecell"></asp:RequiredFieldValidator>
                                                                </div>
                                                                <div style="margin-top: 2px;" class="f_left">
                                                                    <asp:TextBox ID="txtCell" runat="server" CssClass="sett_textbox marright f_left"></asp:TextBox>

                                                                    <asp:Button ID="btnChangeCell" runat="server" Text="Save" OnClick="btnChangeCell_OnClick"
                                                                        ValidationGroup="savecell" CssClass="btn sett_btn marright f_left"></asp:Button>
                                                                    <input type="button" id="btncancel2" value="Cancel" onclick="divCellHide();" class="btn sett_btn marright f_left" />
                                                                </div>
                                                            </div>
                                                            <div class="clear">
                                                            </div>
                                                        </div>
                                                        <div class="clear">
                                                        </div>
                                                        <div class="link_div mar">
                                                            <div id="divstextskype">
                                                                <div class="f_left marright ">
                                                                    <p class="pFontSize">Skype:</p>
                                                                </div>
                                                                <div class="f_left ">
                                                                    <p class="pFontSize">
                                                                        <asp:Literal ID="ltrSkype" runat="server"></asp:Literal>
                                                                    </p>
                                                                </div>
                                                                <a id="lnkSkype" class="f_right aFontSize" onclick="HideDivs('divskype');divskypeshow();">Edit</a>
                                                            </div>
                                                            <div id="divskype" style="display: none;">
                                                                <div class="f_left marright ">
                                                                    <p class="pFontSize">Skype:</p>
                                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ErrorMessage="*"
                                                                        ControlToValidate="txtSkype" ValidationGroup="saveSkype"></asp:RequiredFieldValidator>
                                                                </div>
                                                                <div class="f_left">
                                                                    <asp:TextBox ID="txtSkype" runat="server" CssClass="sett_textbox marright f_left"></asp:TextBox>

                                                                    <asp:Button ID="btnChangeSkype" runat="server" Text="Save" OnClick="btnChangeSkype_OnClick"
                                                                        ValidationGroup="saveSkype" CssClass="btn sett_btn marright f_left"></asp:Button>
                                                                    <input type="button" id="Button2" value="Cancel" onclick="divskypeHide();" class="btn sett_btn marright f_left" />
                                                                </div>

                                                            </div>

                                                            <div class="clear">
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                               
                                                <div class="clear">
                                                </div>
                                            </div>
                                        </div>


                                        <div class="right_help_box slidingDiv" id="div_profile_2" style="display: none;">
                                            <h1>
                                                <span class="span-changepass"></span>Change Password
                                            </h1>
                                            <div class="line_help">
                                            </div>
                                               <asp:UpdatePanel ID="updatechangePass" runat="server" UpdateMode="Conditional">
                                                    <ContentTemplate>
                                            <div class="white_base">
                                                <div class="seting_form">
                                                    <div class="link_div">
                                                        <p class="f_left pFontSize">
                                                            Password: **********
                                                        </p>
                                                        <a id="lnkPass" class="f_right aFontSize" onclick="HideDivs('divpasschange');divpassshow();">Edit</a>
                                                        <div class="clear">
                                                        </div>
                                                    </div>
                                                    <asp:Label ID="lblError1" runat="server" CssClass="errmsg" Style="text-align: center; color: Red;"></asp:Label>
                                                    <div id="divpasschange" style="display: none; font-size: 11px;">
                                                        <label class="col-sm-3 control-label pFontSize pad" style="color: Black;">
                                                            Old Password:
                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*"
                                                                ControlToValidate="txtOldPass" ValidationGroup="pass"></asp:RequiredFieldValidator>
                                                        </label>
                                                        <div class="col-sm-6">
                                                            <asp:TextBox ID="txtOldPass" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                                                        </div>
                                                        <div class="clear">
                                                        </div>
                                                        <label class="col-sm-3 control-label pFontSize pad">
                                                            New Password:
                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                                                                ErrorMessage="*" ControlToValidate="txtNew" ValidationGroup="pass"></asp:RequiredFieldValidator>
                                                        </label>
                                                        <div class="col-sm-6">
                                                            <asp:TextBox ID="txtNew" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                                                        </div>
                                                        <div class="clear">
                                                        </div>
                                                        <label class="col-sm-3 control-label pFontSize pad">
                                                            Confirm Password: 
                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="*"
                                                                ControlToValidate="txtConfirm" ValidationGroup="pass"></asp:RequiredFieldValidator>
                                                        </label>
                                                        <div class="col-sm-6">
                                                            <asp:TextBox ID="txtConfirm" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                                                            <asp:CompareValidator ID="CompareValidator2" runat="server" ValidationGroup="pass"
                                                                ControlToValidate="txtConfirm" CssClass="errmsg" ControlToCompare="txtNew"
                                                                ErrorMessage="Your password and confirm password must match.">
                                                            </asp:CompareValidator>
                                                        </div>
                                                        <div class="clear">
                                                        </div>

                                                        <label1 class="col-sm-3 control-label pad">
                                                            &nbsp;
                                                           </label1>
                                                        <div class="col-sm-6">
                                                            <asp:Button ID="btnChangePass" runat="server" Text="Save" OnClick="btnChangePass_OnClick"
                                                                ValidationGroup="pass" CssClass="btn btn-primary"></asp:Button>
                                                            <input type="button" id="btncancel" value="Cancel" onclick="divpasshide();" class="btn btn-primary" />
                                                        </div>
                                                        <div class="clear">
                                                        </div>

                                                    </div>

                                                </div>
                                                <div class="clear">
                                                </div>
                                            </div>
                                                        </ContentTemplate>
                                                   </asp:UpdatePanel>
                                        </div>


                                        <div class="right_help_box slidingDiv" id="div_profile_3" style="display: none;">
                                            <h1>
                                                <span class="span-profile"></span>Favourite Tasks 
                                            </h1>
                                            <div class="line_help">
                                            </div>
                                            <div class="white_base">
                                                <div class="seting_form">
                                                    <div class="breadcrumb-wrapper mar ">
                                                        <a class="right_link" onclick="blankdata();openfav();">
                                                            <i class="fa fa-fw fa-plus topicon"></i>Create New </a>
                                                    </div>
                                                    <div class="clear"></div>
                                                    <table id="tblFavMain" class="tblsheet mar" cellspacing="0" cellpadding="4" border="0" style="width: 100%; border-collapse: collapse;">
                                                    </table>


                                                </div>
                                                <div class="clear">
                                                </div>
                                            </div>
                                        </div>


                                        <div class="right_help_box slidingDiv" id="div_profile_4" style="display: none;">
                                            <h1>
                                                <span class="span-profile"></span>Favourite Reports 
                                            </h1>
                                            <div class="line_help">
                                            </div>
                                            <div class="white_base">
                                                <div class="seting_form">
                                                    <div class="col-xs-12 col-sm-5 pad1">
                                                        <asp:ListBox ID="listcode1" runat="server" Width="95%" Height="200px" SelectionMode="Multiple"  
                                                            CssClass="RadListBox1"></asp:ListBox>
                                                    </div>
                                                    <div class="col-xs-12 col-sm-2" style="padding:48px 0px; text-align: center;">
                                                        <div>
                                                            <input type="button"id="add"
                                                                class="btn btn-default" style="width: 80px; padding: 2px;" value="Add >>" />
   
                                                        </div>
                                                        <div class="clear">
                                                        </div>
                                                        <div class="padtop10">
                                                            <input type="button" 
                                                                class="btn btn-default mar" style="width: 80px; padding: 2px;" value="<< Remove"
                                                                id="remove" />
                                                        </div>
                                                    </div>
                                                    <div class="col-xs-12 col-sm-5 pad1">
                                                        <asp:ListBox ID="listcode2" runat="server" Width="95%" Height="200px" SelectionMode="Multiple"
                                                            CssClass="RadListBox1"></asp:ListBox>
                                                    </div>
                                                 

                                                </div>
                                                <div class="clear">
                                                </div>
                                                <div class="pad1">

                                                     <asp:UpdatePanel ID="updateFavReport" runat="server" UpdateMode="Conditional">

                                                    <ContentTemplate>
                                                           <input type="hidden" id="hidexpense" runat="server" />
                                                           <input type="hidden" id="hidexpense1" runat="server" />

                                                         <asp:Button ID="btnsavefavtask" runat="server" Text="Save" OnClick="btnsavefavtask_OnClick"
                                                                CssClass="btn btn-primary"></asp:Button>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                                </div>
                                               
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>


            <div style="width: 640px; z-index: 9999; background: #e0e0e0;" id="divmemo" class="itempopup">
                <div class="popup_heading">
                    <span id="Span2" runat="server">Log Memo</span>
                    <div class="f_right">
                        <img src="images/cross.png" onclick="closediv();" alt="X"
                            title="Close Window" />
                    </div>
                </div>
                <div style="padding: 10px;">
                    <div id="divtxtmemo">
                        <cc2:Editor ID="txtmemo" runat="server" CssClass="form-control" Height="300" Style="width: 98%;" />
                    </div>
                    <div id="ltrmemo" runat="server" style="display: none; max-height: 350px; overflow-y: auto;">
                    </div>

                    <div class=" clear pad2">
                        <input type="hidden" id="hidselectedmemoid" />

                        <input type="button" id="btnsavememo" class="btn btn-primary" onclick="addmemo();" value="Add Memo" />
                        <input type="button" id="btncancelalert" class="btn
            btn-primary"
                            value="Cancel" onclick="closediv();" />
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>

    <div id="divsubmit" class="itempopup" style="width: 850px; position: absolute;">
        <div class="popup_heading">
            <span id="Span1">Favourite Tasks</span>
            <div class="f_right">
                <img src="images/cross.png" onclick="closeFav();" alt="X" title="Close Window" />
            </div>
        </div>
        <div class="tabContents">
            <div class="col-xs-12 clear mar">
                <input type="hidden" id="favhidid" value="" />
                <div class="col-xs-12 col-sm-12 form-group mar f_left pad">
                    <label class="col-xs-12 col-sm-1 control-label">
                        Title:
                    </label>
                    <div class="col-xs-4 col-sm-4">
                        <asp:TextBox ID="txttitle" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>

                </div>

                <div class="clear">
                </div>

                <div class="clear padtop10">
                </div>
                <div class="col-xs-12 col-sm-12 form-group mar f_left pad">
                    <div id="divtableaddnew">
                        <table width="100%" cellpadding="4" cellspacing="0" id="tbldata1" class="tblsheet">
                            <tr class="gridheader">
                                <th style="width: 3%;" scope="col">&nbsp;</th>

                              <%--  <th style="width: 16%; display:none;" scope="col">Date</th>--%>
                                <th style="width: 12%;" scope="col">Project</th>
                                <th style="width: 12%;" scope="col">Task</th>
                                <th style="width: 6%;" scope="col">Hours</th>
                                <th scope="col">Description</th>
                                <th style="width: 3%;" scope="col">B</th>

                                <th style="width: 6%;" scope="col">&nbsp;</th>

                            </tr>
                        </table>
                        <div>
                            <table width="100%" cellpadding="4" cellspacing="0" id="tbldata" class="tblsheet">

                                <tr>
                                    <td width="3%" valign="middle">
                                        <input type="hidden" id="favhidid_0" value="" />
                                        <div id="divdel0">
                                        </div>
                                        <input type="text" style="display:none" id="txtdate0" class="form-control" onkeypress="setdtab(0,event);" onchange="checkdate(this.value,this.id);" />
                                    </td>

                                   <%-- <td width="16%" style=" display:none;">
                                        
                                    </td>--%>
                                    <td width="12%">
                                        <input type="text" id="ddlproject0" class="form-control" onkeypress="setptab(0,event);" />
                                        <input type="hidden" id="hidproject0" class="form-control" />
                                        <input type="hidden" id="hidbillable0" />
                                        <input type="hidden" id="hiememorequire0" />
                                    </td>
                                    <td width="12%">
                                        <input type="text" id="ddltask0" class="form-control" onkeypress="settab(0,event);" />
                                        <input type="hidden" id="hidtask0" />
                                    </td>
                                    <td width="6%">
                                        <input type="text" id="txthours0" class="form-control" maxlength="5" onkeypress="TS_blockNonNumbers(this, event, true, false,0);"
                                            onblur="extractNumber(this,2,false);calhours();" onkeyup="extractNumber(this,2,false);" />
                                    </td>
                                    <td>
                                        <input type="text" id="txtdesc0" readonly maxlength="150" class="form-control" onkeypress='addautorow(0,event);' onkeydown='addautorow(0,event);' onblur="removeSpecialCh(this.id,event)" />
                                    </td>
                                    <td width="3%">
                                        <input type="checkbox" id="chkbillable0" />
                                    </td>


                                    <td width="6%">
                                        <a id="lnkmemo0" onclick="opendiv(this.id,1);" title="Add Memo">Memo</a>
                                        <span id="hidmemo0" style="display: none;" />
                                    </td>

                                </tr>
                            </table>



                        </div>
                        <div class="clear"></div>
                        <div class="fulldiv">
                            <div style="float: right; text-align: right; padding-bottom: 5px; padding-top: 5px;">
                                +&nbsp;<a onclick="return addrow();" id="addmore" style="text-decoration: underline;">Add
                                                            New</a>
                            </div>
                        </div>
                        <div style="margin-bottom: 20px; margin-top: 15px; float: left;">
                            <input type="button" value="Save" class="btn btn-primary" onclick="savedata();" id="btnsaveFav" />

                            <div class="col-xs-12 form-group f_left pad" id="divplswait" style="display: none;">
                                <img src="images/pleasewait.gif" style="margin-right: 2px;" />Please wait...
                            </div>
                        </div>

                    </div>
                </div>




            </div>
        </div>
    </div>



    <div id="otherdiv" onclick="closeFav();">
    </div>
    <input type="hidden" id="timesheet_hidrowno" clientidmode="Static" runat="server" />
    <input type="hidden" id="timesheet_hidsno" clientidmode="Static" runat="server" />


    <script type="text/javascript" src="js/jquery-ui.js"></script>
    <script type="text/javascript" src="js/FavTasks1.0.js"></script>

    <script type="text/javascript">

        function closediv() {
            document.getElementById("hidselectedmemoid").value = "";
            document.getElementById("divmemo").style.display = "none";

        }

        function opendiv(id, mode) {
            var mode1 = "";
            mode1 = String(mode)
            var txtmemo = $find("<%= txtmemo.ClientID %>");
            if (mode1 == "0") {
                document.getElementById("btnsavememo").style.display = "none";
                document.getElementById("ctl00_ContentPlaceHolder1_ltrmemo").style.display = "block";
                document.getElementById("divtxtmemo").style.display = "none";


            }
            else {
                document.getElementById("btnsavememo").style.display = "inline";

                document.getElementById("ctl00_ContentPlaceHolder1_ltrmemo").style.display = "none";
                document.getElementById("divtxtmemo").style.display = "block";

            }
            id = id.replace("lnkmemo", "hidmemo");
            setposition("divmemo");





            var exisitngmemo = "";
            if (id.indexOf("dgnews") > -1) {
                exisitngmemo = document.getElementById(id).value;
            }
            else {
                exisitngmemo = document.getElementById(id).innerHTML;
            }


            if (mode1 == "1") {
                txtmemo.set_content(exisitngmemo);
            }
            else {
                document.getElementById("ctl00_ContentPlaceHolder1_ltrmemo").innerHTML = exisitngmemo;
            }

            document.getElementById("hidselectedmemoid").value = id;
            document.getElementById("divmemo").style.display = "block";
            document.getElementById("otherdiv").style.display = "block";
        }
        function addmemo() {
            var txtmemo = $find("<%= txtmemo.ClientID %>");
            memo = txtmemo.get_content();

            var id = document.getElementById("hidselectedmemoid").value;
            if (id.indexOf("dgnews") > -1) {
                document.getElementById(id).value = memo;
            }
            else {

                document.getElementById(id).innerHTML = memo;
            }

            closediv();

        }


        $(document).ready(function () {
            var groups = {};
            $("select option[data-category]").each(function () {
                groups[$.trim($(this).attr("data-category"))] = true;
            });
            $.each(groups, function (c) {
                $("select option[data-category='" + c + "']").wrapAll('<optgroup label="' + c + '">');
            });



            var $select1 = $('#ctl00_ContentPlaceHolder1_listcode1');
            var $select2 = $('#ctl00_ContentPlaceHolder1_listcode2');

            $([$select1, $select2]).each(function () {
                $(this).find('optgroup').each(function (idx) {
                    var ogId = 'og' + idx;
                    $(this).attr('id', ogId);
                    $(this).find('option').each(function () {
                        $(this).data('parent', ogId);
                    });
                });
            });

            $('#add').click(function () {
                processOptions($select1, $select2);
            });
            $('#remove').click(function () {
                processOptions($select2, $select1);
            });

            var optgFoundInTarget = {};

            function processOptions(source, target) {
                var selectedOptions = $(source).find('option:selected');
                if (selectedOptions.length) {
                    selectedOptions.each(function () {
                        var movingFromOptGroup = $(this).parent();
                        parentOg = $(movingFromOptGroup).attr('id');
                        if (parentOg.indexOf('_target') > -1) {
                            parentOg = parentOg.replace('_target', '');
                        } else {
                            parentOg += '_target';
                        }
                        if (typeof optgFoundInTarget[parentOg] == 'object') {
                        } else {
                            if (target.find('optgroup#' + parentOg).length) {
                                _el = target.find('optgroup#' + parentOg);
                            } else {
                                _el = $('<optgroup id="' + $(movingFromOptGroup).attr('id') + '_target" label="' + $(movingFromOptGroup).attr('label') + '" />').appendTo(target);
                            }
                            optgFoundInTarget[parentOg] = _el;
                        }
                        targetOptGroup = optgFoundInTarget[parentOg];
                        $(this).data('parent', $(targetOptGroup).attr('id')).appendTo(targetOptGroup);
                    });
                    $([source, target]).each(function () {
                        $(this).find('optgroup').each(function () {
                            $(this).css('display', $(this).find('option').length ? 'block' : 'none');
                        })
                    });
                    target.val(null);
                }

                var strval = "", strval1 = "";
                var tolistbox = document.getElementById('ctl00_ContentPlaceHolder1_listcode2');
                if (tolistbox.options.length > 0) {
                    for (k = 0; k < tolistbox.options.length; k++) {

                        strval += tolistbox.options[k].value + '#';
                        strval1 += tolistbox.options[k].text + '#';

                    }


                }
                document.getElementById('ctl00_ContentPlaceHolder1_hidexpense').value = strval;
                document.getElementById('ctl00_ContentPlaceHolder1_hidexpense1').value = strval1;
            }


            var strSelected = String(document.getElementById('ctl00_ContentPlaceHolder1_hidexpense').value)
            var arr = strSelected.split('#');
            var Fromlistbox = document.getElementById('ctl00_ContentPlaceHolder1_listcode1');

            if (arr.length > 0)
            {

                for (i = 0; i < arr.length; i++) {

                    for (var j = 0; j < Fromlistbox.options.length; j++) {

                        if (Fromlistbox.options[j].value == arr[i])
                            Fromlistbox.options[j].selected = true;
                    }

                }
                document.getElementById('ctl00_ContentPlaceHolder1_hidexpense').value = "";
                document.getElementById('ctl00_ContentPlaceHolder1_hidexpense1').value = "";
                processOptions($select1, $select2);
            }
           

        });




    </script>
</asp:Content>
