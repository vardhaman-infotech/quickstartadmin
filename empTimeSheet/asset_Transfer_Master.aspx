<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="asset_Transfer_Master.aspx.cs" Inherits="empTimeSheet.asset_Transfer_Master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit.HTMLEditor"
    TagPrefix="cc2" %>



<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        function ShowHideDiv() {

            var ddlloc = document.getElementById("ctl00_ContentPlaceHolder1_dropTransferTo");
            var dvEmp = document.getElementById("ctl00_ContentPlaceHolder1_employee_div_display");
            var dvVend = document.getElementById("ctl00_ContentPlaceHolder1_vendor_div_display");
            if (ddlloc.value == "Individual") {
                dvEmp.style.display = "block";
                dvVend.style.display = "none";
            }
            else if (ddlloc.value == "Repair") {
                dvEmp.style.display = "none";
                dvVend.style.display = "block";
            }
            else {
                dvEmp.style.display = "none";
                dvVend.style.display = "none";
                document.getElementById("ctl00_ContentPlaceHolder1_dropTransferTo").value = "";
                document.getElementById("ctl00_ContentPlaceHolder1_drop_vendorCode").value = "";
                alert("Placed at :" + ddlloc.value);
            }
        }
    </script>
    <script src="js/assetTransfer.js"></script>
    <script type="text/javascript" src="js/jquery-ui.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:UpdatePanel ID="upadatepanel1" runat="server">
        <ContentTemplate>
            <input type="hidden" id="hidid" runat="server" />
            <pg:progress ID="progress1" runat="server" />
            <div class="pageheader">
                <h2>
                    <i class="fa fa-cube"></i>Transfer Master
                </h2>
                <div class="clear">
                </div>
            </div>
            <div class="contentpanel">
                <div class="row">
                    <!-- col-sm-3 -->
                    <div class="col-sm-12 col-md-12">
                        <div class="panel panel-default" style="margin-right: 0px; margin-left: 0px;">
                            <div class="panel-body" style="padding: 55px;">
                                <div class="row">
                                    <div class="col-xs-12 col-sm-6 form-group col-md-12 f_left" style="padding: 0px;">
                                        <h5 class="col-xs-12 col-sm-4  subtitle mb5">Asset Informations </h5>
                                    </div>
                                    <!-- see here for asset-->
                                    <div class="col-xs-12 col-sm-6 form-group col-md-12 f_left" style="padding: 0px;">
                                        <label class="col-xs-12 col-sm-2 control-label">
                                            Asset:   <asp:RequiredFieldValidator ID="RequiredFieldValidator3"  runat="server" ErrorMessage="*"
                                                ControlToValidate="ddlasset"  ClientIDMode="Static" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>  </label>
                                        <div class="col-xs-12 col-sm-4">
                                            <input type="text" id="ddlasset" runat="server" clientidmode="static"  class="form-control col-xs-12 col-sm-4" />
                                            <input type="hidden" id="hidasset" />
                                        </div>
                                    </div>
                                    <!-- end here-->
                                    <!-- Asset div start here-->
                                    <div class="col-xs-12 col-sm-12 alig"  id="Asset_div" style="border: 1px dotted grey; display: none;background-color: #ebebeb;">
                                        </br>
                                        <div class="col-xs-12 col-sm-6  f_left pad">
                                            <label class="col-xs-12 col-sm-4 control-label">
                                                Asset Name:
                                            </label>
                                            <div class="col-xs-12 col-sm-8" style="padding-top:11px;">
                                                <asp:Label ID="lbl_assetName" runat="server"></asp:Label>
                                            </div>
                                        </div>
                                        <div class="col-xs-12 col-sm-6  f_left pad">
                                            <label class="col-xs-12 col-sm-4 control-label">
                                                Asset Code:
                                            </label>
                                            <div class="col-xs-12 col-sm-8" style="padding-top:11px;">
                                                <asp:Label ID="lbl_assetCode" runat="server"></asp:Label>
                                            </div>
                                        </div>
                                        <div class="col-xs-12 col-sm-6  f_left pad">
                                            <label class="col-xs-12 col-sm-4 control-label">
                                                Asset Catg.:
                                            </label>
                                            <div class="col-xs-12 col-sm-8"style="padding-top:11px;">
                                                <asp:Label ID="label_itemCategory" runat="server" placeholder="Enter Category"></asp:Label>
                                            </div>
                                        </div>
                                        <div class="col-xs-12 col-sm-6  f_left pad">
                                            <label class="col-xs-12 col-sm-4 control-label">
                                                Current Loc.:
                                            </label>
                                            <div class="col-xs-12 col-sm-8" style="padding-top:11px;">
                                                <asp:Label ID="label_currentLoc" runat="server" placeholder="Enter Current Location"></asp:Label>
                                            </div>
                                        </div>
                                        <div class="col-xs-12 col-sm-6 f_left pad">
                                            <label class="col-xs-12 col-sm-4 control-label">
                                                Asset date:
                                            </label>
                                            <div class="col-xs-12 col-sm-8" style="padding-top:11px;">
                                                <asp:Label ID="label_trnsferDate" runat="server" placeholder="Enter Current Location"></asp:Label>
                                            </div>
                                        </div>
                                    </div>
                                    <!--asset div ends here-->
                                    <div class="col-xs-12 col-sm-6 form-group col-md-12 f_left" style="padding: 0px;">
                                        </br>
                                        <h5 class="col-xs-12 col-sm-4  subtitle mb5">Transfer Information </h5>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 f_left pad">
                                        <div class="col-xs-12 col-sm-6  f_left pad">
                                            <label class="col-xs-12 col-sm-4 control-label">
                                                Transfr To:<asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="dropTransferTo"
                                                    ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator>
                                            </label>
                                     
                                            <div class="col-xs-12 col-sm-5">
                                                <asp:DropDownList ID="dropTransferTo" runat="server" CssClass="form-control pad3" onchange="ShowHideDiv()">
                                                    <asp:ListItem Value="Stock" Selected="True">Stock</asp:ListItem>
                                                    <asp:ListItem Value="Individual">Individual</asp:ListItem>
                                                    <asp:ListItem Value="Inuse">Inuse</asp:ListItem>
                                                    <asp:ListItem Value="Store">Store</asp:ListItem>
                                                    <asp:ListItem Value="Repair">Repair</asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                        </div>
                                        <div class="col-xs-12 col-sm-6  f_left pad">
                                            <label class="col-xs-12 col-sm-6 control-label">
                                                Due Date : 
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ErrorMessage="*"
                                                ControlToValidate="txtDueDate" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                                            </label>
                                            <div class="col-xs-12 col-sm-6">
                                                <asp:TextBox ID="txtDueDate" runat="server" CssClass="form-control hasDatepicker" placeholder="Due Date" onchange="checkdate(this.value,this.id);"></asp:TextBox>
                                                <cc1:CalendarExtender ID="txtDate_CalendarDueDate" runat="server" TargetControlID="txtDueDate"
                                                    PopupButtonID="txtDueDate" Format="MM/dd/yyyy">
                                                </cc1:CalendarExtender>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 f_left pad">
                                        <div class="col-xs-12 col-sm-6  f_left pad">
                                            <label class="col-xs-12 col-sm-4 control-label">
                                                Department:<asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="drop_departmentName"
                                                    ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator>
                                            </label>
                                            <div class="col-xs-12 col-sm-5">
                                                <asp:DropDownList ID="drop_departmentName" runat="server" CssClass="form-control">
                                                </asp:DropDownList>
                                            </div>
                                        </div>
                                        <div class="col-xs-12 col-sm-6  f_left pad">
                                            <label class="col-xs-12 col-sm-6 control-label">
                                                Transfer Date : 
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*"
                                                ControlToValidate="txt_TransferDate" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                                            </label>
                                            <div class="col-xs-12 col-sm-6">

                                                <asp:TextBox ID="txt_TransferDate" runat="server" CssClass="form-control hasDatepicker" placeholder="Transfer Date" onchange="checkdate(this.value,this.id);"></asp:TextBox>

                                                <cc1:CalendarExtender ID="CalendarTransferDate" runat="server" TargetControlID="txt_TransferDate"
                                                    PopupButtonID="txt_TransferDate" Format="MM/dd/yyyy">
                                                </cc1:CalendarExtender>

                                            </div>
                                        </div>
                                    </div>
                                    <!--Employee div disappear-->
                                    <div id='employee_div_display' runat="server" class="col-xs-12 col-sm-12" style="border: 1px dotted grey; display: none;background-color: #ebebeb;">
                                        <br />
                                        <div class="col-xs-12 col-sm-8  col-md-12 f_left" style="padding: 0px;">
                                            <h5 class="col-xs-12 col-sm-6  subtitle mb5">Employee information </h5>
                                        </div>
                                        <div class="col-xs-12 col-sm-6 form-group f_left pad">
                                            <label class="col-xs-12 col-sm-6 control-label">
                                                Employee Name:
                                            </label>
                                            <div class="col-xs-12 col-sm-6">
                                                <asp:DropDownList ID="drop_employeName" runat="server" CssClass="form-control">
                                                </asp:DropDownList>
                                            </div>
                                        </div>
                                    </div>
                                    <!--Vendor div disappear-->
                                    <div id='vendor_div_display' runat="server" class="col-xs-12 col-sm-12" style="border: 1px dotted grey; display: none;background-color: #ebebeb;">
                                        <br />
                                        <div class="col-xs-12 col-sm-8  col-md-12 f_left" style="padding: 0px;">
                                            <h5 class="col-xs-12 col-sm-6  subtitle mb5">Vendor information </h5>
                                        </div>
                                        <div class="col-xs-12 col-sm-6 form-group f_left pad">
                                            <label class="col-xs-12 col-sm-6 control-label">
                                                Vendor Name:
                                            </label>
                                            <div class="col-xs-12 col-sm-6">
                                                <asp:DropDownList ID="drop_vendorName" runat="server" CssClass="form-control">
                                                </asp:DropDownList>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 form-group f_left pad">
                                        </br>
                                       <label class="col-xs-12 col-sm-1 control-label">
                                           Notes:
                                       </label>
                                        <div class="col-xs-12 col-sm-10 control-label">
                                            <asp:TextBox ID="txt_Notes" runat="server" TextMode="MultiLine" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                    <!-- end-->
                                    <div class="clear">
                                    </div>
                                    <div class="col-xs-12 col-sm-4">
                                        </br>
                                        <asp:Button ID="btnsubmit" runat="server" CssClass="btn btn-primary" Text="Save"
                                            ValidationGroup="save" OnClick="btnsubmit_Click" />
                                        <asp:Button ID="btnReset" runat="server" CssClass="btn btn-default" Text="Reset"
                                            OnClick="btnbtnReset_Click" />
                                        <div class="clear">
                                        </div>
                                    </div>
                                </div>
                                <!-- row -->
                            </div>
                            <!-- panel-body -->
                        </div>
                        <!-- panel -->
                    </div>
                    <!-- col-sm-9 -->
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

