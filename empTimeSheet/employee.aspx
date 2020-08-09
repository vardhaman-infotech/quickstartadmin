<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="employee.aspx.cs" Inherits="empTimeSheet.employee" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="Stylesheet" href="css/tab_2.0.css" type="text/css" />

    <link rel="stylesheet" href="css/jquery.dataTables.min.css" />

    <script src="js/jquery.min.js"></script>

    <script type="text/javascript" src="js/jquery.dataTables.min.js"></script>

    <script type="text/javascript" src="js/employee.js">

    </script>
    <style type="text/css">
        .tabContaier {
            padding: 10px;
        }


        .tabContents {
            height: 335px;
        }

        .tabDetails {
            height: auto;
        }

        .roleheader {
            font-size: 13px;
            float: left;
            margin-top: 10px;
        }

        .gridrolestd {
            border: dashed 1px #b1b1b1;
            vertical-align: top;
            padding-left: 5px;
        }
    </style>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <pg:progress ID="progress1" runat="server" />
    <asp:UpdatePanel ID="upadatepanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <input type="hidden" id="hidcurrenttab" />
            <input type="hidden" id="hidtabid" />
            <div class="pageheader">
                <h2>
                    <i class="fa  fa-user"></i>Employee Management
                </h2>
                <div class="breadcrumb-wrapper">
                    <asp:LinkButton ID="btnexportcsv" runat="server" OnClick="btnexportcsv_Click" CssClass="right_link">
            <i class="fa fa-fw fa-file-excel-o topicon"></i>Export to Excel</asp:LinkButton>
                    <asp:LinkButton ID="liaddnew" runat="server" CssClass="right_link" OnClick="liaddnew_Click">
                    <i class="fa fa-fw fa-plus topicon"></i>Add New </asp:LinkButton>
                </div>
                <div class="clear">
                </div>
            </div>


            <div id="divaddnew" class="itempopup" style="width: 875px; display: none;">
                <asp:Button ID="PaggedGridbtnedit" runat="server" Style="display: none;" OnClick="PaggedGridbtnedit_Click" ClientIDMode="Static" />
                   <input type="hidden" id="hidid" runat="server" />
                <div class="popup_heading">
                    <span>Add Employee</span>
                    <div class="f_right">
                        <img src="images/cross.png" onclick="closediv();" alt="X" title="Close
            Window" />
                    </div>
                </div>
                <div class="tabContaier">
                    <ul>
                        <li><a id="lnktab1" href="#tab1" class="active">General</a></li>
                        <li><a id="lnktab5" href="#tab5">Employee Roles</a></li>
                        <li><a id="lnktab2" href="#tab2">Contact</a></li>
                        <li><a id="lnktab3" href="#tab3">Cost</a></li>
                        <%--  <li><a id="lnktab4" href="#tab4">Payroll</a></li>--%>
                    </ul>
                    <!-- //Tab buttons -->
                    <div class="tabDetails">
                        <div class="tabContents" id="tab1" style="display: block;">

                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Employee ID :
                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*"
                                                                ControlToValidate="txtempid" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:TextBox ID="txtempid" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Enroll No :
                                                           
                                </label>
                                <div class="txt w1 mar10">

                                    <asp:TextBox ID="txtenrollno" runat="server" CssClass="form-control"></asp:TextBox>

                                </div>
                            </div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Password :
                                </label>
                                <div class="txt w1">

                                    <asp:TextBox ID="txtpassword" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                            <div class="clear"></div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    First Name :
                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="*"
                                                                ControlToValidate="txtfname" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:TextBox ID="txtfname" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Last Name :  <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server" ErrorMessage="*"
                                                                ControlToValidate="txtlname" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:TextBox ID="txtlname" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                             <div class="ctrlGroup">
                                <label class="lbl">
                                    Date of Birth :
                                </label>
                                <div class="txt w1">
                                     <asp:TextBox ID="txtdob" runat="server" CssClass="form-control hasDatepicker" onchange="checkdate(this.value,this.id);"></asp:TextBox>

                                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtdob" 
                                        PopupButtonID="txtdob" Format="MM/dd/yyyy">
                                    </cc1:CalendarExtender>
                                </div>
                            </div>
                            <div class="clear"></div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Department :<asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                                        ErrorMessage="*" ControlToValidate="dropdepartment" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:DropDownList ID="dropdepartment" runat="server" CssClass="form-control pad3">
                                    </asp:DropDownList>
                                </div>
                            </div>

                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Designation :<asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server"
                                        ErrorMessage="*" ControlToValidate="dropdesignation" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:DropDownList ID="dropdesignation" runat="server" CssClass="form-control pad3">
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Manager :
                                </label>
                                <div class="txt w1">
                                    <asp:DropDownList ID="dropmanager" runat="server" CssClass="form-control pad3">
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="clear"></div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Submit to :
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:DropDownList ID="dropsubmitto" runat="server" CssClass="form-control pad3">
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Join Date : 
                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ErrorMessage="*"
                                                                ControlToValidate="txtjoin" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                                </label>
                                <div class="txt w1 mar10">

                                    <asp:TextBox ID="txtjoin" runat="server" CssClass="form-control hasDatepicker" onchange="checkdate(this.value,this.id);"></asp:TextBox>

                                    <cc1:CalendarExtender ID="txtDate_CalendarExtender" runat="server" TargetControlID="txtjoin"
                                        PopupButtonID="txtjoin" Format="MM/dd/yyyy">
                                    </cc1:CalendarExtender>

                                </div>
                            </div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Relieve Date :  <asp:CustomValidator ID="RequiredFieldValidator9" runat="server" ErrorMessage="*"
                                                                ControlToValidate="txtrelived" CssClass="validation" ValidationGroup="save" ClientValidationFunction="checkreleaseddate"></asp:CustomValidator>
                                </label>
                                <div class="txt w1">

                                    <asp:TextBox ID="txtrelived" runat="server" CssClass="form-control hasDatepicker"
                                        onchange="checkdate(this.value,this.id);"></asp:TextBox>

                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtrelived"
                                        PopupButtonID="txtrelived" Format="MM/dd/yyyy">
                                    </cc1:CalendarExtender>

                                </div>
                            </div>


                            <div class="clear"></div>


                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Email :<asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="*"
                                        ControlToValidate="txtcompanyemail" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ValidationGroup="save"
                                        ControlToValidate="txtcompanyemail" ErrorMessage="Invalid!" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                                </label>
                                <div class="txt w3 mar10">
                                    <asp:TextBox ID="txtcompanyemail" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Staff Type :<asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ErrorMessage="*"
                                        ControlToValidate="dropemptype" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                                </label>
                                <div class="txt w1 ">
                                    <asp:DropDownList ID="dropemptype" runat="server" CssClass="form-control pad3">
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="clear"></div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Timezone :<asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ErrorMessage="*"
                                        ControlToValidate="droptimezone" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                                </label>
                                <div class="txt w3 mar10">
                                    <asp:DropDownList ID="droptimezone" runat="server" CssClass="form-control pad3">
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Active Status :
                                </label>
                                <div class="txt w1 ">

                                    <asp:DropDownList ID="dropactive" runat="server" CssClass="form-control pad3">
                                        <asp:ListItem Value="Active" Selected="True">Active</asp:ListItem>
                                         <asp:ListItem Value="Released">Released</asp:ListItem>
                                        <asp:ListItem Value="Block">Block</asp:ListItem>
                                        
                                    </asp:DropDownList>

                                </div>
                            </div>





                            <div class="clear"></div>


                        </div>


                        <div class="tabContents" id="tab5" style="display: none;">





                            <div class="clear"></div>


                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Role Group :
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:DropDownList ID="droproletype" runat="server" CssClass="form-control pad3" onchange="selectroles();">
                                         <asp:ListItem Value="">Select</asp:ListItem>
                                        <asp:ListItem Value="Basic">Basic</asp:ListItem>
                                         <asp:ListItem Value="Manager">Manager</asp:ListItem>
                                          <asp:ListItem Value="Admin">Admin</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="clear"></div>


                            <div>

                                <asp:DataList ID="reproles" runat="server" OnItemDataBound="reproles_ItemDataBound" Width="99.5%" CellSpacing="0" RepeatColumns="2" CssClass="gridroles">

                                    <ItemTemplate>
                                        <div class="clear"></div>
                                        <div class="roleheader color">
                                            <%#Eval("rGroup")%>
                                        </div>
                                        <div class="clear"></div>
                                        <asp:CheckBoxList ID="rbtnroles" runat="server" RepeatLayout="Table" RepeatDirection="Horizontal"
                                            RepeatColumns="2" CssClass="checkboxauto">
                                        </asp:CheckBoxList><div class="clear"></div>

                                    </ItemTemplate>


                                    <ItemStyle CssClass="gridrolestd" />

                                </asp:DataList>
                            </div>
                            <div class="clear">
                            </div>
                        </div>


                        <div class="tabContents" id="tab2" style="display: none;">

                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Contact Title :
                                </label>
                                <div class="txt w4">
                                    <asp:TextBox ID="txttitle" runat="server" CssClass="form-control "></asp:TextBox>
                                </div>
                            </div>
                            <div class="clear"></div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Street :
                                </label>
                                <div class="txt w4">
                                    <asp:TextBox ID="txtstreet" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                            <div class="clear"></div>
                            <asp:UpdatePanel ID="updatecountry" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <div class="ctrlGroup">
                                        <label class="lbl">
                                            Country :
                                        </label>
                                        <div class="txt w1 mar10">
                                            <asp:DropDownList ID="dropcountry" runat="server" CssClass="form-control" AutoPostBack="True"
                                                OnSelectedIndexChanged="dropcountry_SelectedIndexChanged">
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="ctrlGroup">
                                        <label class="lbl">
                                            State :
                                        </label>
                                        <div class="txt w1 mar10">
                                            <asp:DropDownList ID="dropstate" runat="server" CssClass="form-control" AutoPostBack="True"
                                                OnSelectedIndexChanged="dropstate_SelectedIndexChanged">
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="ctrlGroup">
                                        <label class="lbl">
                                            City :
                                        </label>
                                        <div class="txt w1">
                                            <asp:DropDownList ID="dropcity" runat="server" CssClass="form-control">
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                </ContentTemplate>

                            </asp:UpdatePanel>
                            <div class="clear"></div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    ZIP :
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:TextBox ID="txtzip" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Email :
                                </label>
                                <div class="txt w3">
                                    <asp:TextBox ID="txtemail" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                            <div class="clear"></div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Cell :
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:TextBox ID="txtcell" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Home Phone :
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:TextBox ID="txtphone" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Fax :
                                </label>
                                <div class="txt w1">
                                    <asp:TextBox ID="txtfax" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                            <div class="clear"></div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Remark :
                                </label>
                                <div class="txt w4">
                                    <asp:TextBox ID="txtremark" runat="server" CssClass="form-control"
                                        TextMode="MultiLine" Height="50px"></asp:TextBox>
                                </div>
                            </div>
                        </div>





                        <div class="tabContents" id="tab3" style="display: none;">
                            <div class="col-sm-12">
                                <div class="ctrlGroup">
                                    <label class=" lbl lbl1">
                                        Bill Rate :
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:TextBox ID="txtbillrate" runat="server" CssClass="form-control " placeholder="0.00"
                                            onkeypress="blockNonNumbers(this, event, true, false);" onblur="fill(this.id);"
                                            onkeyup="extractNumber(this,2,false);"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="ctrlGroup">
                                    <label class=" lbl lbl1">
                                        Pay Rate :
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:TextBox ID="txtpayrate" runat="server" CssClass="form-control" placeholder="0.00"
                                            onkeypress="blockNonNumbers(this, event, true, false);" onblur="fill(this.id);"
                                            onkeyup="extractNumber(this,2,false);"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="clear"></div>
                                <div class="ctrlGroup">
                                    <label class=" lbl lbl1">
                                        Overtime Bill Rate :
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:TextBox ID="txtovertimebill" runat="server" CssClass="form-control" placeholder="0.00"
                                            onkeypress="blockNonNumbers(this, event, true, false);" onblur="fill(this.id);"
                                            onkeyup="extractNumber(this,2,false);"></asp:TextBox>
                                    </div>
                                </div>

                                <div class="ctrlGroup">
                                    <label class=" lbl lbl1">
                                        Overtime Pay Rate :
                                    </label>
                                    <div class="txt w1">
                                        <asp:TextBox ID="txtovertimepayrate" runat="server" CssClass="form-control" placeholder="0.00"
                                            onkeypress="blockNonNumbers(this, event, true, false);" onblur="fill(this.id);"
                                            onkeyup="extractNumber(this,2,false);"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="clear"></div>
                                <div class="ctrlGroup">
                                    <label class=" lbl lbl1">
                                        Overhead Multiplier :
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:TextBox ID="txtoverhead" runat="server" CssClass="form-control" Text="1"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="ctrlGroup">
                                    <label class=" lbl lbl1">
                                        Salary Amount :
                                    </label>
                                    <div class="txt w1">
                                        <asp:TextBox ID="txtsalary" runat="server" CssClass="form-control" placeholder="0.00"
                                            onkeypress="blockNonNumbers(this, event, true, false);" onblur="fill(this.id);"
                                            onkeyup="extractNumber(this,2,false);"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="clear"></div>
                                <div class="ctrlGroup">
                                    <label class=" lbl lbl1">
                                        Currency :
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:DropDownList ID="dropcurrency" runat="server" CssClass="form-control">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                            <div class="clear">
                            </div>
                        </div>
                      
                        <div class="col-xs-12 col-sm-12" style="padding: 10px 0px 0px 0px;">
                            <asp:Button ID="btnsubmit" runat="server" CssClass="btn btn-primary" Text="Save"
                                OnClientClick="getinfo();" ValidationGroup="save" OnClick="btnsubmit_Click" />
                            <asp:Button ID="btndelete" runat="server" CssClass="btn btn-default" Visible="false"
                                Text="Delete" OnClientClick='return confirm("Delete this record? Yes or No");'
                                OnClick="btndelete_Click" />
                            <div class="clear">
                            </div>
                        </div>
                    </div>
                </div>

            </div>

            <div id="otherdiv" onclick="closediv();">
            </div>


            <input type="hidden" id="hidaddress" runat="server" />
            <input type="hidden" id="hidrate" runat="server" />
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnexportcsv" />

        </Triggers>
    </asp:UpdatePanel>

    <div class="contentpanel">
        <asp:UpdatePanel ID="updateData" runat="server" UpdateMode="Conditional">
            <ContentTemplate>

             
                <div class="row">
                    <div class="col-sm-12 col-md-12">
                        <div class="panel panel-default">
                            <div class="col-sm-12 col-md-10 mar">
                                <div class="ctrlGroup searchgroup">
                                    <label class="lblAuto">
                                        Emp ID/Name:
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:TextBox ID="txtsearch" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="ctrlGroup searchgroup">
                                    <label class="lblAuto">
                                        Department:
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:DropDownList ID="dropdept" runat="server" CssClass="form-control  pad3">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="ctrlGroup searchgroup">
                                    <label class="lblAuto">
                                        Status:
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:DropDownList ID="drostatus" runat="server" CssClass="form-control  pad3">
                                            <asp:ListItem Selected="True" Value="">--All--</asp:ListItem>
                                            <asp:ListItem Value="Active">Active</asp:ListItem>
                                               <asp:ListItem Value="Released">Released</asp:ListItem>
                                            <asp:ListItem Value="Block">Block</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>

                                <div class="ctrlGroup searchgroup">
                                    <asp:Button ID="btnsearch" runat="server" CssClass="btn btn-default" Text="Search"
                                        OnClick="btnsearch_Click" />
                                </div>
                            </div>
                            <div class="col-sm-12 col-md-2 mar" style="display: none;">
                                <div class="ctrlGroup searchgroup" style="float: right;">
                                    <asp:LinkButton ID="lnkprevious" CssClass="f_left" runat="server" OnClick="lnkprevious_Click">
            <i class="fa fa-fw fa-fast-backward color_green"></i></asp:LinkButton>

                                    <div class="f_left page">
                                        <asp:Label ID="lblstart" runat="server"></asp:Label>
                                        -
                                        <asp:Label ID="lblend" runat="server"></asp:Label>
                                        of <strong>
                                            <asp:Label ID="lbltotalrecord" Font-Bold="true" runat="server"></asp:Label></strong>
                                    </div>
                                    <asp:LinkButton ID="lnknext" CssClass="f_left" runat="server" OnClick="lnknext_Click"><i class="fa fa-fw fa-fast-forward color_green"></i></asp:LinkButton>
                                </div>
                            </div>
                            <div class="clear">
                            </div>
                            <div class="col-sm-12 col-md-12 mar">

                                <div class="clear">
                                </div>
                                <div class="panel panel-default">
                                    <div class="panel-body2 ">
                                        <div class="row">
                                            <div class="table-responsive" style="min-height: 300px;">
                                                <asp:GridView ID="dgnews" runat="server" AllowPaging="false" AutoGenerateColumns="False"
                                                    PageSize="50" CellPadding="4" CellSpacing="0" Width="100%" ShowHeader="true"
                                                    ShowFooter="false" CssClass="tblreport" GridLines="None" AllowSorting="false"
                                                    OnRowDataBound="dgnews_RowDataBound" OnRowCommand="dgnews_RowCommand"
                                                    OnPageIndexChanging="dgnews_PageIndexChanging">
                                                    <Columns>

                                                        <asp:TemplateField HeaderText="Emp ID" SortExpression="loginid" HeaderStyle-Width="100px">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"loginid")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                        <asp:TemplateField HeaderText="Emp Name" SortExpression="fullname">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"fullname")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Depertment" SortExpression="department">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"department")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Designation" SortExpression="designation">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem, "designation")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Join Date" SortExpression="joindate">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"joindate")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Released Date" SortExpression="releaseddate">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"releaseddate")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                        <asp:TemplateField HeaderText="Status" SortExpression="activestatus" HeaderStyle-Width="75px">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"activestatus")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                        <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="70px">
                                                            <ItemTemplate>
                                                                <a onclick='clickedit(<%#DataBinder.Eval(Container.DataItem,"nid")%>);' title="Edit"><i class="fa fa-fw">
                                                                    <img src="images/edit.png"></i></a>
                                                                &nbsp;
                                                                <asp:LinkButton ID="lbtndelete" CommandName="remove" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>'
                                                                    ToolTip="Delete" runat="server" OnClientClick='return confirm("Delete this record? Yes or No");'><i class="fa fa-fw" >
                                                            <img src="images/delete.png" alt=""></i></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                    </Columns>
                                                    <HeaderStyle CssClass="gridheader" />
                                                    <PagerStyle CssClass="gridpager" HorizontalAlign="Center" />
                                                </asp:GridView>


                                                <div class="nodatafound" id="nodata" runat="server">
                                                    No data found
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="clear">
                            </div>
                        </div>
                    </div>
                </div>

            </ContentTemplate>
        </asp:UpdatePanel>
    </div>






    <script type="text/javascript">







        function opendiv() {
            setposition("divaddnew");
            document.getElementById("divaddnew").style.display = "block";
            document.getElementById("otherdiv").style.display = "block";


        }
        function closediv() {

            document.getElementById("divaddnew").style.display = "none";
            document.getElementById("otherdiv").style.display = "none";

        }
        $(document).ready(function () {
            $(".tabContents").hide(); // Hide all tab content divs by default
            $("#tab1").show(); // Show the first div of tab content by default
            bintabcontainerevent();

        });

        //The below code is to generate the script when page refresh in update panel
        var prm = Sys.WebForms.PageRequestManager.getInstance();

        prm.add_endRequest(function () {
            //$(".tabContents").hide(); // Hide all tab content divs by default
            //$(".tabContaier ul li a").removeClass("active");
            //var currenttab = document.getElementById("hidcurrenttab").value;
            //var currenttab1 = document.getElementById("hidtabid").value;
            //if (currenttab1 != "") {
            //    document.getElementById(currenttab1).className = "active";
            //}
            //if (currenttab != "") {
            //    $(currenttab).fadeIn();
            //}
            //else {
            //    $("#tab1").show();
            //    document.getElementById("lnktab1").className = "active"
            //}
            bintabcontainerevent();
            // fixheader();

        });

        function bintabcontainerevent() {


            $(".tabContaier ul li a").click(function () { //Fire the click event

                var activeTab = $(this).attr("href"); // Catch the click link             
                $(".tabContaier ul li a").removeClass("active"); // Remove pre-highlighted link
                $(this).addClass("active"); // set clicked link to highlight state
                $(".tabContents").hide(); // hide currently visible tab content div
                $(activeTab).fadeIn(); // show the target tab content div by matching clicked link.
                document.getElementById("hidtabid").value = $(this).attr("id");
                document.getElementById("hidcurrenttab").value = activeTab;
                return false; //prevent page scrolling on tab click
            });

        }


        function checkreleaseddate(oSrc, args) {
            var status=1;
            if (document.getElementById("ctl00_ContentPlaceHolder1_dropactive").value == "Released")
            {
                if (document.getElementById("ctl00_ContentPlaceHolder1_txtrelived").value == "")
                {
                    status = 0;
                }
            }
            if (status == 1)
                args.IsValid = true;
            else
                args.IsValid = false;
        }
    </script>
</asp:Content>

