<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="assetTransferMaster.aspx.cs" Inherits="empTimeSheet.assetTransferMaster" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link rel="stylesheet" type="text/css" href="css/asset.css" />



    <script type="text/javascript">

        function ShowHideDiv() {

            var ddlloc = document.getElementById("ctl00_ContentPlaceHolder1_dropTransferTo");
            var dvEmp = document.getElementById("ctl00_ContentPlaceHolder1_employee_div_display");
            var dvVend = document.getElementById("ctl00_ContentPlaceHolder1_vendor_div_display");

            dvVend.style.display = "none";
            dvEmp.style.display = "none";

            if (ddlloc.value == "Individual") {
                dvEmp.style.display = "block";

            }
            else if (ddlloc.value == "Repair") {
                dvVend.style.display = "block";
            }
        }

    </script>



    <link rel="Stylesheet" href="css/tab_2.0.css" type="text/css" />

    <link rel="stylesheet" href="css/jquery-ui.css" />
    <script type="text/javascript" src="js/jquery-ui.js"></script>
    <script>
        function opendiv() {
            setposition("assignedtask_divaddnew");
            if (document.getElementById('hidasset').value == "")
                reset();
            document.getElementById("assignedtask_divaddnew").style.display = "block";
            document.getElementById("otherdiv").style.display = "block";
        }
        function closediv() {
            document.getElementById("assignedtask_divaddnew").style.display = "none";
            document.getElementById("otherdiv").style.display = "none";
        }
        function checktransferdate(sender, args) {
            if (!comparedate(document.getElementById('ctl00_ContentPlaceHolder1_txt_TransferDate').value, document.getElementById('ctl00_ContentPlaceHolder1_txtDueDate').value)) {
                alert('Asset transfer date cannot bigger then due date.')
                args.IsValid = false;
            }
            else {

                if (!comparedate(document.getElementById('hidtransfer_date').value, document.getElementById('ctl00_ContentPlaceHolder1_txt_TransferDate').value)) {

                    alert('Asset transfer date shoud be greater than previous transfer date.')
                    args.IsValid = false;
                }
                else {
                    args.IsValid = true;
                }
            }
        }
        function reset() {

            document.getElementById("ddlasset").value = "";
            document.getElementById("ddlasset").disabled = false;
            document.getElementById("ctl00_ContentPlaceHolder1_drop_departmentName").disabled = false;
            document.getElementById('ctl00_ContentPlaceHolder1_lbl_assetName').innerHTML = "";
            document.getElementById('ctl00_ContentPlaceHolder1_lbl_assetCode').innerHTML = "";
            document.getElementById('ctl00_ContentPlaceHolder1_label_itemCategory').innerHTML = "";
            document.getElementById('ctl00_ContentPlaceHolder1_label_currentLoc').innerHTML = "";
            document.getElementById('ctl00_ContentPlaceHolder1_label_trnsferDate').innerHTML = "";
            document.getElementById("ctl00_ContentPlaceHolder1_drop_departmentName").selectedIndex = 0;
            document.getElementById("ctl00_ContentPlaceHolder1_dropTransferTo").selectedIndex = 0;
            document.getElementById("ctl00_ContentPlaceHolder1_drop_vendorName").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_drop_employeName").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_dropTransferTo").selectedIndex = 0;

            document.getElementById("Asset_div").style.display = "none";
            document.getElementById("ctl00_ContentPlaceHolder1_employee_div_display").style.display = "none";
            document.getElementById("ctl00_ContentPlaceHolder1_vendor_div_display").style.display = "none";
            document.getElementById("ctl00_ContentPlaceHolder1_txtDueDate").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txt_TransferDate").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txt_Notes").value = "";

            document.getElementById("ctl00_ContentPlaceHolder1_btnsubmit").value = "Save";


        }

    </script>
    <script src="js/assetTransfer.js"></script>
    <script type="text/javascript" src="js/jquery-ui.js"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:HiddenField ClientIDMode="Static" runat="server" ID="AsssetTransfer_isapprove" Value="" />
    <pg:progress ID="progress1" runat="server" />
    <div class="pageheader">
        <h2>
            <i class="fa fa-tasks"></i>Asset Management
        </h2>
        <div class="breadcrumb-wrapper mar ">
            <!--Below i have called a json function bindassetauto('ddlasset', 'hidasset',1), i am doing so to refresh the div, other wisw it will not update hidden text-->
            <a id="liaddnew" runat="server" class="right_link" onclick="reset(); bindassetauto('ddlasset', 'hidasset',1);opendiv();ShowHideDiv();"><i class="fa fa-fw fa-plus topicon"></i>Transfer Assets</a>
            <asp:LinkButton ID="btnexportcsv" runat="server" CssClass="right_link" OnClick="btnexportcsv_Click">
              <i class="fa fa-fw fa-file-excel-o topicon" ></i>Export to Excel
            </asp:LinkButton>

            <asp:LinkButton ID="lbtnapprove" runat="server" OnClick="setstatus" CssClass="right_link" Visible="false" OnClientClick='return confirm("Are you sure for Approve Asset Requests?");'>
             <i class="fa fa-fw  fa-check-circle topicon"></i>Approve</asp:LinkButton>

            <asp:LinkButton ID="lbtnreject" runat="server" OnClick="setstatus" CssClass="right_link" Visible="false" OnClientClick='return confirm("Are you sure for Reject Asset Requests?");'>
            <i class="fa fa-fw  fa-minus-circle topicon"></i>Reject</asp:LinkButton>

            <asp:LinkButton ID="lnkrefresh" runat="server" OnClick="btnrefresh_Click" CssClass="right_link">
            <i class="fa fa-fw fa-refresh topicon"></i>Refresh</asp:LinkButton>
        </div>
        <div class="clear">
        </div>
    </div>
    <div class="contentpanel">
        <div class="row">
            <div class="col-sm-12 col-md-12">
                <div class="panel panel-default">

                    <asp:UpdatePanel ID="updatePanelData" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="false">
                        <ContentTemplate>
                            <div id="otherdiv" onclick="closediv();">
                            </div>
                             
                            <div class="col-sm-12 col-md-12" style="min-height: 500px">
                                <div style="padding-top: 10px;">
                                    <div class="col-xs-12 col-sm-12 col-md-12 f_left" style="padding: 0px;">
                                        <h5 class="subtitle mb5">Transfer Request</h5>
                                    </div>
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl">From Date :</label>
                                        <div class="txt w1 mar10">
                                        <asp:TextBox ID="txtfrom" runat="server" CssClass="form-control hasDatepicker" onchange="comparedate(this.id,'ctl00_ContentPlaceHolder1_txtfrom','ctl00_ContentPlaceHolder1_txtto');"></asp:TextBox>
                                        <cc1:CalendarExtender ID="txtDate_CalendarExtender" runat="server" TargetControlID="txtfrom"
                                            PopupButtonID="txtfrom" Format="MM/dd/yyyy">
                                        </cc1:CalendarExtender>
                                            </div>
                                    </div>
                                    
                                     <div class="ctrlGroup searchgroup">
                                        <label class="lbl">To Date :</label>
                                        <div class="txt w1 mar10">
                                        <asp:TextBox ID="txtto" runat="server" CssClass="form-control hasDatepicker" onchange="comparedate(this.id,'ctl00_ContentPlaceHolder1_txtfrom','ctl00_ContentPlaceHolder1_txtto');"></asp:TextBox>

                                        <cc1:CalendarExtender ID="txtDate_CalendarExtender1" runat="server" TargetControlID="txtto"
                                            PopupButtonID="txtto" Format="MM/dd/yyyy">
                                        </cc1:CalendarExtender>
                                            </div>
                                    </div>
                                    <div class="clear"></div>
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl">Category Code :</label>
                                        <div class="txt w1 mar10">
                                        <asp:DropDownList ID="DropSearchDepartment" runat="server" CssClass="form-control">
                                        </asp:DropDownList>
                                            </div>
                                    </div>
                                   
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl">Asset Name :</label>
                                        <div class="txt w1 mar10">
                                        <asp:TextBox ID="txtSearchAsset" runat="server" CssClass="form-control" placeholder="Asset Name "></asp:TextBox>
                                            </div>
                                    </div>

                                    <%-- <div class="col-sm-4 col-md-4 f_left pad4 mar clear">
                                <asp:DropDownList ID="DropSearchLocation" runat="server" CssClass="form-control pad3">
                                </asp:DropDownList>
                            </div>--%>
                                    <div class="clear"></div>
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl">Status :</label>
                                        <div class="txt w1 mar10">
                                        <asp:DropDownList ID="drostatus" runat="server" CssClass="form-control">
                                            <asp:ListItem Value="">--All Transfer Status--</asp:ListItem>
                                            <asp:ListItem Value="Approved">Approved</asp:ListItem>
                                            <asp:ListItem Value="Rejected">Rejected</asp:ListItem>
                                        </asp:DropDownList>
                                    </div></div>

                                    <div class="ctrlGroup searchgroup mar" style="margin-left: 30px;">
                                        <label class="lbl lbl2 disNone"> &nbsp; </label>
                                        <asp:Button ID="btnsearch" runat="server" Text="Search" CssClass="btn btn-default"
                                            OnClick="btnsearch_Click" />
                                    </div>

                                </div>
                                <div class="f_right" style="padding-top: 10px;">
                                    <span class="f_left">
                                        <asp:LinkButton ID="lnkprevious" runat="server" OnClick="lnkprevious_Click"> <i class="fa fa-fw fa-fast-backward color_green"></i></asp:LinkButton>
                                    </span>
                                    <p class="f_left page">
                                        <asp:Label ID="lblstart" runat="server"></asp:Label>
                                        -
                                        <asp:Label ID="lblend" runat="server"></asp:Label>
                                        of <strong>
                                            <asp:Label ID="lbltotalrecord" Font-Bold="true" runat="server"></asp:Label></strong>
                                    </p>
                                    <span class="f_left">
                                        <asp:LinkButton ID="lnknext" runat="server" OnClick="lnknext_Click">  <i class="fa fa-fw fa-fast-forward color_green"></i></asp:LinkButton>
                                    </span>
                                </div>
                                <div class="clear">
                                </div>
                                <div class="panel panel-default">
                                    <div class="panel-default">
                                        <div class="panel-body2 ">
                                            <div class="row">
                                                <div class="table-responsive">
                                                    <div class="nodatafound" id="divnodata" runat="server">
                                                        No data found
                                                    </div>
                                                    <asp:GridView ID="dgnews" runat="server" AllowPaging="true" AutoGenerateColumns="False"
                                                        OnRowCommand="dgnews_RowCommand" CellPadding="4" CellSpacing="0" BorderWidth="0px"
                                                        PageSize="50" Width="100%" ShowHeader="true" ShowFooter="false" CssClass="table table-success mb30" GridLines="None" BorderStyle="None" AllowSorting="true" OnPageIndexChanging="dgnews_PageIndexChanging"
                                                        OnRowDataBound="dgnews_RowDataBound">
                                                        <Columns>
                                                            <asp:TemplateField ItemStyle-Width="10px">
                                                                <ItemTemplate>
                                                                    <asp:CheckBox ID="chkapprovebox" runat="server"></asp:CheckBox>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <%-- <asp:TemplateField HeaderText="S.No." ItemStyle-Width="15px">
                                                                <ItemTemplate>
                                                                    <%# Container.DataItemIndex + 1 %>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>--%>
                                                            <asp:TemplateField HeaderText="Transfer Date" SortExpression="assetcode" ItemStyle-Width="11%">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "transferdate")%>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>

                                                            <asp:TemplateField HeaderText="Asset" SortExpression="assetName" ItemStyle-Width="15%">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "assetcode")%>: <%# DataBinder.Eval(Container.DataItem, "assetName")%>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Transfer From" ItemStyle-Width="16%">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "PLocation")%>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Transfer To" ItemStyle-Width="18%">
                                                                <ItemTemplate>
                                                                    <i class="fa fa-fw">
                                                                        <asp:Image ID="imgloc" runat="server" Style="padding: 0px 0px 3px 0px" />
                                                                    </i>
                                                                    <%# DataBinder.Eval(Container.DataItem, "Location")%>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>

                                                            <asp:TemplateField HeaderText="Department" ItemStyle-Width="10%">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "departmentname")%>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>


                                                            <asp:TemplateField HeaderText="EmpID" ItemStyle-Width="20px">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "loginid")%>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="ReqDate" ItemStyle-Width="75px">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "reqDate")%>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Status" ItemStyle-Width="3px">
                                                                <ItemTemplate>
                                                                    <div runat="server" id="divtaskstatus">
                                                                    </div>
                                                                    <%--  <%# DataBinder.Eval(Container.DataItem, "statusdetail")%>--%>
                                                                    <input type="hidden" id="hidnid1" runat="server"
                                                                            value='<%# DataBinder.Eval(Container.DataItem, "nid")%>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>

                                                            <asp:TemplateField ItemStyle-Width="5px">
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="lbtnedit" Visible="false" CommandName="edititem" CommandArgument='<%# Eval("nid")%>'
                                                                        ToolTip="Edit" runat="server"><i class="fa fa-fw" ><img  src="images/edit.png" alt="" /></i></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField ItemStyle-Width="5px">
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="lbtndelete" Visible="false" CommandName="del" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>'
                                                                        ToolTip="Delete" runat="server" OnClientClick='return confirm("Delete this record? Yes or No");'><i class="fa fa-fw"><img  src="images/delete.png" alt="Delete" /></i></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>

                                                        </Columns>
                                                        <EmptyDataTemplate>
                                                            No Asset
                                                        </EmptyDataTemplate>
                                                        <HeaderStyle CssClass="gridheader" />
                                                        <RowStyle CssClass="odd" />
                                                        <AlternatingRowStyle CssClass="even" />
                                                        <EmptyDataRowStyle CssClass="nodatafound" />
                                                    </asp:GridView>

                                                    <%-- <table id="dgnews" class="table table-success mb30" cellpadding="4" cellspacing="0"
                                                    width="100%">
                                                </table>--%>
                                                    <input type="hidden" id="hidfromdate" runat="server" />
                                                    <input type="hidden" id="hidtodate" runat="server" />
                                                    <div id="divloadmore" style="display: none; text-align: center;">
                                                        <img src="images/loading.gif" />
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- row -->
                                        </div>
                                        <!--  panel-body  -->
                                    </div>
                                </div>
                            </div>
                        </ContentTemplate>
                        <Triggers>
                        </Triggers>
                    </asp:UpdatePanel>
                    <div class="clear">
                    </div>
                    <asp:HiddenField ClientIDMode="Static" Value="" ID="TransferAsset_hiduserid" runat="server" />
                    <input type="hidden" id="hiduserid" runat="server" />
                    <input type="hidden" id="hidempid" runat="server" />
                    <input type="hidden" id="Hidden1" runat="server" />
                    <input type="hidden" id="Hidden2" runat="server" />
                    <!-- col-sm-9 -->
                    <div class="clear">
                    </div>
                </div>
                <!-- panel -->
            </div>
        </div>
    </div>
    <!---ADD NEW div goes here-->
    <asp:UpdatePanel ID="updatePanelAssign" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div id="assignedtask_divaddnew" class="itempopup" style="display: none; width: 720px; position: absolute; top: -720px; left: 150.5px;">
                <div class="popup_heading">
                    <span id="legendaction" runat="server">Transfer Assets </span>
                    <div class="f_right">
                        <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
                    </div>
                </div>

                <div class="divform poppad">
                    <div class="popuphead">Asset Informations </div>
                    <div class="clear"></div>
                    <!-- see here for asset-->
                    <div class="ctrlGroup searchgroup">
                        <label class="lbl">Asset :<asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="*"
                        ControlToValidate="ddlasset" ClientIDMode="Static" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                        </label>
                        <div class="txt w3">

                            <input type="text" id="ddlasset" runat="server" clientidmode="static" class="form-control col-xs-12 col-sm-4" />
                            <asp:HiddenField ID="hidasset" runat="server" ClientIDMode="Static" />
                            <asp:HiddenField ID="hidlocationid" runat="server" ClientIDMode="Static" />
                            <asp:HiddenField ID="hidtransfer_date" runat="server" ClientIDMode="Static" />
                        </div>
                    </div>
<%--                     <input type="hidden" id="OldtransferDate" runat="server" />--%>
                    <div class="clear"></div>
                    <!-- end here-->
                    <!-- Asset div start here-->
                     
                    <div id="Asset_div" class="col-xs-12 col-sm-6 col-md-12 f_left pad4" style="display: none; padding: 20px 0px;">
                        <table class="tbldetail" width="100%">
                            <tr>
                                <th style="width: 15%;">Code</th>
                                <td style="width: 35%;">
                                    <asp:Label ID="lbl_assetCode" runat="server"></asp:Label>
                                </td>
                                <th style="width: 15%;">Asset</th>
                                <td style="width: 35%;">
                                    <asp:Label ID="lbl_assetName" runat="server"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <th>Category</th>
                                <td colspan="3">
                                    <asp:Label ID="label_itemCategory" runat="server" placeholder="Enter Category"></asp:Label>
                                </td>

                            </tr>
                            <tr>
                                <th>Current Location</th>
                                <td colspan="3">
                                    <asp:Label ID="label_currentLoc" runat="server"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <th>Transfer Date</th>
                                <td>
                                    <asp:Label ID="label_trnsferDate" runat="server" placeholder="Enter Current Location"></asp:Label>
                                </td>
                                <th>Added on</th>
                                <td>
                                    <asp:Label ID="lbladded_on" runat="server" placeholder="Enter Current Location"></asp:Label>
                                </td>
                            </tr>

                        </table>

                    </div>
                    <!--asset div ends here-->

                    <div class="popuphead">Transfer Information </div>

                    <div class="col-xs-12 col-sm-12 f_left pad">
                        <div class="ctrlGroup searchgroup">
                            <label class="lbl">Transfr To :<asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="dropTransferTo"
                                    ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator>
                            </label>

                            <div class="txt w1 mar10">  
                                <asp:DropDownList ID="dropTransferTo" runat="server" CssClass="form-control" onchange="ShowHideDiv()">
                                    <asp:ListItem Value="Stock" Selected="True">Stock</asp:ListItem>
                                    <asp:ListItem Value="Individual">Individual</asp:ListItem>
                                    <asp:ListItem Value="Inuse">Inuse</asp:ListItem>
                                    <asp:ListItem Value="Store">Store</asp:ListItem>
                                    <asp:ListItem Value="Repair">Repair</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="ctrlGroup searchgroup">
                            <label class="lbl">Due Date :<asp:CustomValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="*"
                                    CssClass="validation" ValidationGroup="save" ClientValidationFunction="checktransferdate"></asp:CustomValidator>

                            </label>
                            <div class="txt w1">
                                <asp:TextBox ID="txtDueDate" runat="server" CssClass="form-control hasDatepicker" placeholder="Due Date" onchange="checkdate(this.value,this.id);"></asp:TextBox>
                                <cc1:CalendarExtender ID="txtDate_CalendarDueDate" runat="server" TargetControlID="txtDueDate"
                                    PopupButtonID="txtDueDate" Format="MM/dd/yyyy">
                                </cc1:CalendarExtender>
                            </div>
                        </div>
                    </div>
                    <div class="col-xs-12 col-sm-12 f_left pad">
                        <div class="ctrlGroup searchgroup">
                            <label class="lbl">Department :<asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="drop_departmentName"
                                    ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator>
                            </label>
                            <div class="txt w1 mar10">
                                <asp:UpdatePanel ID="updatePanelSearch" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <asp:DropDownList ID="drop_departmentName" runat="server" CssClass="form-control">
                                        </asp:DropDownList>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                        <div class="ctrlGroup searchgroup">
                            <label class="lbl">Transfer Date :<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*"
                                                ControlToValidate="txt_TransferDate" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                            </label>
                            <div class="txt w1">

                                <asp:TextBox ID="txt_TransferDate" runat="server" CssClass="form-control hasDatepicker" placeholder="Transfer Date" onchange="checkdate(this.value,this.id);"></asp:TextBox>

                                <cc1:CalendarExtender ID="CalendarTransferDate" runat="server" TargetControlID="txt_TransferDate"
                                    PopupButtonID="txt_TransferDate" Format="MM/dd/yyyy">
                                </cc1:CalendarExtender>

                            </div>
                        </div>
                    </div>
                    <div class="clear"></div>

                    <!--Employee div disappear-->
                    <div id='employee_div_display' runat="server" style="display: none;">
                        <div class="popuphead">
                            Employee information
                        </div>
                        <div class="col-xs-12 col-sm-12 f_left   pad">
                            <div class="clear"></div>
                            <label class="col-xs-12 col-sm-2">
                                Employee Name:
                            </label>
                            <div class="col-xs-12 col-sm-4">
                                <asp:UpdatePanel ID="updatePanel1" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <asp:DropDownList ID="drop_employeName" AutoPostBack="true" OnSelectedIndexChanged="employee_selecetdIndexChanged" runat="server" CssClass="form-control">
                                        </asp:DropDownList>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                    </div>

                    <div id='vendor_div_display' runat="server" style="display: none;">
                        <div class="popuphead">
                            Vendor information
                        </div>
                        <div class="col-xs-12 col-sm-12  f_right pad">
                            <label class="col-xs-12 col-sm-2">
                                Vendor Name:
                            </label>
                            <div class="col-xs-12 col-sm-4">
                                <asp:DropDownList ID="drop_vendorName" runat="server" CssClass="form-control">
                                </asp:DropDownList>
                            </div>
                        </div>

                    </div>
                    <!--Vendor div disappear-->

                    <div class="ctrlGroup searchgroup">
                              <label class="lbl">Notes :</label>
                                <div class="txt w3">
                                    <asp:TextBox ID="txt_Notes" runat="server" CssClass="form-control" TextMode="MultiLine"></asp:TextBox>
                                </div>
                                <br></br>
                            </br>
                        </br>
                    </div>
                    <!-- end-->
                    <div class="clear">
                    </div>
                    <div class="ctrlGroup searchgroup"  style="margin-left: 28px;">
                        <label class="lbl lbl2 disNone">&nbsp;</label>
                        

                            <asp:Button ID="btnsubmit" runat="server" CssClass="btn btn-primary" Text="Save"
                                ValidationGroup="save" OnClick="btnsubmit_Click" />

                            <%--   <asp:Button ID="btnReset" runat="server" OnClientClick="reset()" CssClass="btn btn-default" Text="Reset" />--%>
                            <div class="clear">
                            </div>
                        
                    </div>
                </div>
            </div>

            <!-- col-sm-9 -->

            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <input type="hidden" id="hidid" runat="server" />
    <script type="text/javascript">
        $(document).ready(function () {

            bintabcontainerevent();

        });

        //The below code is to generate the script when page refresh in update panel
        var prm = Sys.WebForms.PageRequestManager.getInstance();

        prm.add_endRequest(function () {
            //Recall function to bin tabcontainer event on callback
            bintabcontainerevent();

        });

        function bintabcontainerevent() {

            $(".tabContents").hide(); // Hide all tab content divs by default
            $(".tabContents:first").show(); // Show the first div of tab content by default

            $(".tabContaier ul li a").click(function () { //Fire the click event

                var activeTab = $(this).attr("href"); // Catch the click link
                $(".tabContaier ul li a").removeClass("active"); // Remove pre-highlighted link
                $(this).addClass("active"); // set clicked link to highlight state
                $(".tabContents").hide(); // hide currently visible tab content div
                $(activeTab).fadeIn(); // show the target tab content div by matching clicked link.

                return false; //prevent page scrolling on tab click
            });

        }
    </script>

</asp:Content>
