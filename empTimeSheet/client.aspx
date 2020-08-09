<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="client.aspx.cs" Inherits="empTimeSheet.client" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="Stylesheet" href="css/tab_2.0.css" type="text/css" />

    <link rel="stylesheet" href="css/jquery.dataTables.min.css" />

    <script src="js/jquery.min.js"></script>

    <script type="text/javascript" src="js/jquery.dataTables.min.js"></script>

    <script>
        function fixheader() {

            $.getScript("js/colResizable-1.6.js", function () {

                $("#ctl00_ContentPlaceHolder1_dgnews").colResizable({
                    liveDrag: true,
                    gripInnerHtml: "<div class='grip'></div>",
                    draggingClass: "dragging",
                    resizeMode: 'fit'
                });

                $('#ctl00_ContentPlaceHolder1_dgnews').dataTable({
                    "dom": 'lrtip',
                    "pageLength": 100,
                    'aoColumnDefs': [{
                        'bSortable': false,
                        'aTargets': [-1] /* 1st one, start by the right */
                    }]
                });

            });



        }
    </script>
    <style type="text/css">
        .tabContaier {
            padding: 10px;
        }


        .tabContents {
            height: 425px;
        }

        .tabDetails {
            height: auto;
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <pg:progress ID="progress1" runat="server" />
    <asp:UpdatePanel ID="upadatepanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="pageheader">
                <h2>
                    <i class="fa fa-user"></i>Client Management
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
            <input type="hidden" id="hidid" runat="server" />
            <input type="hidden" id="hidaddress" runat="server" />
            <input type="hidden" id="hidrate" runat="server" />

            <div id="divaddnew" class="itempopup" style="width: 900px; display: none;">
                <asp:Button ID="PaggedGridbtnedit" runat="server" Style="display: none;" OnClick="PaggedGridbtnedit_Click" ClientIDMode="Static" />
                <div class="popup_heading">
                    <span>Add Client</span>
                    <div class="f_right">
                        <img src="images/cross.png" onclick="closediv();" alt="X" title="Close
            Window" />
                    </div>
                </div>
                <div class="tabContaier">
                    <ul>
                        <li><a id="lnktab1" href="#tab1" class="active">General</a></li>
                        <li><a id="lnktab2" href="#tab2">Contact Information</a></li>
                        <li><a id="lnktab3" href="#tab3">Client Groups</a></li>
                    </ul>
                    <!-- //Tab buttons -->
                    <div class="tabDetails">
                        <div class="tabContents" id="tab1" style="display: block;">
                            <div class="col-xs-12 col-sm-12">

                                <div class="ctrlGroup">
                                    <label class="lbl">
                                        Client Name :
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="*"
                                                                    ControlToValidate="txtname" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                                    </label>
                                    <div class="txt w3 mar10">
                                        <asp:TextBox ID="txtname" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="ctrlGroup">
                                    <label class="lbl">
                                        Client ID :
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*"
                                                                    ControlToValidate="txtclientcode" CssClass="validation" ValidationGroup="save">
                                                                </asp:RequiredFieldValidator>
                                    </label>
                                    <div class="txt w1 ">
                                        <asp:TextBox ID="txtclientcode" runat="server" CssClass="form-control">
                                        </asp:TextBox>
                                    </div>
                                </div>
                                <div class="clear"></div>
                                <div class="ctrlGroup ">
                                    <label class="lbl">
                                        Contact Person :
                                                            <%--    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="*"
                                                                    ControlToValidate="txtcompany" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>--%>
                                    </label>
                                    <div class="txt w3 mar10">
                                        <asp:TextBox ID="txtcompany" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>

                                <div class="ctrlGroup">
                                    <label class="lbl">
                                        Designation :
                                    </label>
                                    <div class="txt w1">
                                        <asp:TextBox ID="txtdesignation" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="clear"></div>


                                <div class="ctrlGroup ">
                                    <label class="lbl">
                                        Home Phone :
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:TextBox ID="txtphone1" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>

                                <div class="ctrlGroup">
                                    <label class="lbl">
                                        Work Phone :
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:TextBox ID="txtworkphone" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>


                                <div class="ctrlGroup ">
                                    <label class="lbl">
                                        Cell :
                                    </label>
                                    <div class="txt w1">
                                        <asp:TextBox ID="txtcell1" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="clear"></div>
                                <div class="ctrlGroup ">
                                    <label class="lbl">
                                        Fax :
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:TextBox ID="txtfax1" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="ctrlGroup ">
                                    <label class="lbl">
                                        Email:<%--<asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="*"
                                                                    ControlToValidate="txtemail1" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>--%><asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ValidationGroup="save"
                                                                        ControlToValidate="txtemail1" ErrorMessage="Invalid!" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:TextBox ID="txtemail1" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>



                                <div class="ctrlGroup ">
                                    <label class="lbl">
                                        Website :
                                    </label>
                                    <div class="txt w1">
                                        <asp:TextBox ID="txtwebsite" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="clear"></div>

                                <div class="ctrlGroup">
                                    <label class="lbl">
                                        Address 1:
                                    </label>
                                    <div class="txt w3 ">
                                        <asp:TextBox ID="txtstreet1" runat="server" CssClass="form-control" placeholder="Street, PO Box" TextMode="MultiLine" Height="40px">
                                        </asp:TextBox>
                                    </div>
                                </div>
                                <div class="clear"></div>
                                <div class="ctrlGroup ">
                                    <label class="lbl">
                                        Address 2:
                                    </label>
                                    <div class="txt w3">
                                        <asp:TextBox ID="txtaddress2" runat="server" CssClass="form-control" TextMode="MultiLine" Height="40px">
                                        </asp:TextBox>
                                    </div>
                                </div>
                                <div class="clear"></div>


                                <div class="ctrlGroup">
                                    <label class="lbl">
                                        Country :
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:DropDownList ID="dropcountry1" runat="server" CssClass="form-control" AutoPostBack="true"
                                            OnSelectedIndexChanged="dropcountry1_SelectedIndexChanged">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="ctrlGroup">
                                    <label class="lbl">
                                        State :
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:DropDownList ID="dropstate1" runat="server" CssClass="form-control" AutoPostBack="true"
                                            OnSelectedIndexChanged="dropstate1_SelectedIndexChanged">
                                        </asp:DropDownList>
                                    </div>
                                </div>

                                <div class="ctrlGroup ">
                                    <label class="lbl">
                                        City :
                                    </label>
                                    <div class="txt w1">
                                        <asp:DropDownList ID="dropcity1" runat="server" CssClass="form-control">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="clear"></div>
                                <div class="ctrlGroup ">
                                    <label class="lbl">
                                        ZIP :
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:TextBox ID="txtzip1" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>

                                <div class="ctrlGroup">
                                    <label class="lbl">
                                        Manager:<asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="*"
                                            ControlToValidate="dropmanager" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:DropDownList ID="dropmanager" runat="server" CssClass="form-control pad3">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="ctrlGroup ">
                                    <label class="lbl">
                                        Active Status :
                                    </label>
                                    <div class="txt w1">
                                        <asp:DropDownList ID="dropactive" runat="server" CssClass="form-control">
                                            <asp:ListItem Value="Active" Selected="True">Active</asp:ListItem>
                                            <asp:ListItem Value="Block">Block</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>

                                <div class="clear"></div>








                            </div>
                            <div class="clear">
                            </div>
                        </div>
                        <div class="tabContents" id="tab2" style="display: none;">
                            <div class="col-sm-12">
                                <div class="ctrlGroup">
                                    <label class="lbl">
                                        Contact Name :
                                    </label>
                                    <div class="txt w3">
                                        <asp:TextBox ID="txttitle" runat="server" CssClass="form-control " placeholder=""></asp:TextBox>
                                    </div>
                                </div>
                                <div class="clear"></div>
                                <div class="ctrlGroup">
                                    <label class="lbl">
                                        Street :
                                    </label>
                                    <div class="txt w3 mar10">
                                        <asp:TextBox ID="txtstreet" runat="server" CssClass="form-control" placeholder=""></asp:TextBox>
                                    </div>
                                </div>
                                <div class="ctrlGroup">
                                    <label class="lbl">
                                        Country :
                                    </label>
                                    <div class="txt w1">
                                        <asp:DropDownList ID="dropcountry" runat="server" CssClass="form-control" AutoPostBack="true"
                                            OnSelectedIndexChanged="dropcountry_SelectedIndexChanged">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="clear"></div>
                                <div class="ctrlGroup">
                                    <label class="lbl">
                                        State :
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:DropDownList ID="dropstate" runat="server" CssClass="form-control" AutoPostBack="true"
                                            OnSelectedIndexChanged="dropstate_SelectedIndexChanged">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="ctrlGroup">
                                    <label class="lbl">
                                        City :
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:DropDownList ID="dropcity" runat="server" CssClass="form-control">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="ctrlGroup">
                                    <label class="lbl">
                                        ZIP :
                                    </label>
                                    <div class="txt w1">
                                        <asp:TextBox ID="txtzip" runat="server" CssClass="form-control" placeholder=""></asp:TextBox>
                                    </div>
                                </div>
                                <div class="clear"></div>
                                <div class="ctrlGroup">
                                    <label class="lbl">
                                        Remark :
                                    </label>
                                    <div class="txt w3 mar10">
                                        <asp:TextBox ID="txtremark" runat="server" CssClass="form-control" placeholder="Remark"
                                            TextMode="MultiLine" Height="40px"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="ctrlGroup">
                                    <label class="lbl">
                                        Email :
                                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ValidationGroup="save"
                                                                    ControlToValidate="txtemail" ErrorMessage="Invalid!" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                                    </label>
                                    <div class="txt w1">
                                        <asp:TextBox ID="txtemail" runat="server" CssClass="form-control" placeholder=""></asp:TextBox>
                                    </div>
                                </div>
                                <div class="clear"></div>
                                <div class="ctrlGroup">
                                    <label class="lbl">
                                        Cell :
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:TextBox ID="txtcell" runat="server" CssClass="form-control" placeholder=""></asp:TextBox>
                                    </div>
                                </div>
                                <div class="ctrlGroup">
                                    <label class="lbl">
                                        Home Phone :
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:TextBox ID="txtphone" runat="server" CssClass="form-control" placeholder=""></asp:TextBox>
                                    </div>
                                </div>
                                <div class="ctrlGroup">
                                    <label class="lbl">
                                        Fax :
                                    </label>
                                    <div class="txt w1">
                                        <asp:TextBox ID="txtfax" runat="server" CssClass="form-control" placeholder=""></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="clear">
                            </div>
                        </div>

                        <div class="tabContents" id="tab3" style="display: none;">
                            <div class="col-sm-12">
                                <div class="ctrlGroup">
                                    <label class="lbl" style="margin-top:6px;">
                                       Select Client Groups :

                                    </label>
                                    <div class="txt w4 ">
                                        <asp:CheckBoxList ID="chkClientGroup" runat="server" RepeatLayout="Table" RepeatDirection="Horizontal"
                                            RepeatColumns="1" CssClass="checkboxauto " Width="100%">
                                           
                                        </asp:CheckBoxList>
                                    </div>

                                </div>
                                <div class="clear"></div>

                            </div>
                            <div class="clear">
                            </div>
                        </div>
                        <div class="col-xs-12 col-sm-12" style="padding: 10px 0px 0px 0px;">
                            <asp:Button ID="btnsubmit" runat="server" CssClass="btn btn-primary" Text="Save"
                                ValidationGroup="save" OnClick="btnsubmit_Click" />
                            <asp:Button ID="btndelete" runat="server" CssClass="btn btn-default" Visible="false"
                                Text="Delete" OnClientClick='return confirm("Delete this record? Yes or No");'
                                OnClick="btndelete_Click" />
                        </div>
                    </div>
                </div>

            </div>

            <div id="otherdiv" onclick="closediv();">
            </div>
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
                                        Client ID/Name:
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:TextBox ID="txtsearch" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="ctrlGroup searchgroup">
                                    <label class="lblAuto">
                                        Status:
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:DropDownList ID="drostatus" runat="server" CssClass="form-control  pad3">
                                            <asp:ListItem Value="">--All--</asp:ListItem>
                                            <asp:ListItem Value="Active">Active</asp:ListItem>
                                            <asp:ListItem Value="Inactive">Inactive</asp:ListItem>
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

                                                        <asp:TemplateField HeaderText="Client ID" SortExpression="code" HeaderStyle-Width="100px">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"code")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                        <asp:TemplateField HeaderText="Client" SortExpression="fullname">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"fullname")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Contact Person" SortExpression="company">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"company")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Designation" SortExpression="designation">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem, "designation")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Manager">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"managername")%>
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
                                                                    ToolTip="Delete" runat="server" OnClientClick='return confirm("Delete this record?
            Yes or No");'><i class="fa fa-fw" >
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





        function blank() {
            document.getElementById("txtclientcode").value = "";
            document.getElementById("txtname").value = "";
            document.getElementById("txtcompany").value = "";
            document.getElementById("txtemail").value = "";
            document.getElementById("txtcell").value = "";
            document.getElementById("txtfax").value = "";
            document.getElementById("txtphone").value = "";
            document.getElementById("txtremark").value = "";
            document.getElementById("txtstreet").value = "";
            document.getElementById("txttitle").value = "";
            document.getElementById("txtzip").value = "";
            document.getElementById("dropmanager").value = "";
            document.getElementById("dropactive").value = "Active";
            document.getElementById("dropstate").value = "";
            document.getElementById("dropstate1").value = "";
            document.getElementById("dropcountry").value = "";
            document.getElementById("dropcountry1").value = "";
            document.getElementById("dropcity").value = "";
            document.getElementById("dropcity1").value = "";
            document.getElementById("txtemail1").value = "";
            document.getElementById("txtcell1").value = "";
            document.getElementById("txtphone1").value = "";
            document.getElementById("txtwebsite").value = "";
            document.getElementById("txtaddress2").value = "";
            document.getElementById("txtworkphone").value = "";
            document.getElementById("txtzip1").value = "";
            document.getElementById("hidid").value = "";

            document.getElementById("hidaddress").value = "";
            document.getElementById("btndelete").style.display = "block";
            document.getElementById("btnsubmit").value = "Submit";

            document.getElementById("txtclientcode").desiabled = false;
            document.getElementById("txtdesignation").value = "";


        }

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
            $(".tabContents").hide(); // Hide all tab content divs by default
            $(".tabContaier ul li a").removeClass("active");
            var currenttab = document.getElementById("hidcurrenttab").value;
            var currenttab1 = document.getElementById("hidtabid").value;
            if (currenttab1 != "") {
                document.getElementById(currenttab1).className = "active";
            }
            if (currenttab != "") {
                $(currenttab).fadeIn();
            }
            else {
                $("#tab1").show();
                document.getElementById("lnktab1").className = "active"
            }
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
    </script>
    <input type="hidden" id="hidcurrenttab" />
    <input type="hidden" id="hidtabid" />
</asp:Content>
