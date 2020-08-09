<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="project.aspx.cs" Inherits="empTimeSheet.project" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="Stylesheet" href="css/tab_2.0.css" type="text/css" />

    <link rel="stylesheet" href="css/jquery.dataTables.min.css" />

    <script src="js/jquery.min.js"></script>

    <script type="text/javascript" src="js/jquery.dataTables.min.js"></script>

    <script>
        function setcustom() {

            if (document.getElementById("<%=chkcustominvoice.ClientID %>").checked == false) {
                document.getElementById("<%=txtprefix.ClientID %>").disabled = "disabled";
                document.getElementById("<%=txtinvoicenumber.ClientID %>").disabled = "disabled";
                document.getElementById("<%=txtSuffix.ClientID %>").disabled = "disabled";

                document.getElementById("<%=txtprefix.ClientID %>").value = "";
                document.getElementById("<%=txtinvoicenumber.ClientID %>").value = "";
                document.getElementById("<%=txtSuffix.ClientID %>").value = "";
            }
            else {
                document.getElementById("<%=txtprefix.ClientID %>").disabled = false;
                document.getElementById("<%=txtinvoicenumber.ClientID %>").disabled = false;
                document.getElementById("<%=txtSuffix.ClientID %>").disabled = false;
            }
        }
        function checkamount() {
            var total = parseFloat($("#ctl00_ContentPlaceHolder1_txtcontractamt").val());
            var servamt = 0;
            if ($("#ctl00_ContentPlaceHolder1_txtserviceamt").val() != "") {
                servamt = parseFloat($("#ctl00_ContentPlaceHolder1_txtserviceamt").val());
            }

            var expamt = 0;
            if ($("#ctl00_ContentPlaceHolder1_txtexpamt").val() != "") {
                expamt = parseFloat($("#ctl00_ContentPlaceHolder1_txtexpamt").val());
            }

            if (total < (servamt + expamt)) {
                $("#ctl00_ContentPlaceHolder1_txtcontractamt").val(total);
                //alert("Total of service amount and expence amount cannot grater then contract amount");
                //$("#ctl00_ContentPlaceHolder1_txtserviceamt").val("");
                //$("#ctl00_ContentPlaceHolder1_txtexpamt").val("");

            }


        }
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
                        'aTargets': [-1] /* 1st one, start by the right */,

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
            height: 350px;
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
            <asp:Button ID="PaggedGridbtnedit" runat="server" Style="display: none;" OnClick="PaggedGridbtnedit_Click" ClientIDMode="Static" />
            <input type="hidden" id="hidid" runat="server" />
            <input type="hidden" id="hidcurrenttab" />
            <input type="hidden" id="hidtabid" />
            <div class="pageheader">
                <h2>
                    <i class="fa fa-th"></i>Project Management
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


            <div id="divaddnew" class="itempopup" style="width: 895px; display: none;">
                <div class="popup_heading">
                    <span>Add Project</span>
                    <div class="f_right">
                        <img src="images/cross.png" onclick="closediv();" alt="X" title="Close
            Window" />
                    </div>
                </div>
                <div class="tabContaier">
                    <ul>
                        <li><a href="#tab1" class="active">General</a></li>
                        <li><a href="#tab2">Billing Information</a></li>
                        <li><a id="recurrTab3" href="#recurrTab">Recurring Info</a></li>
                        <li><a id="lnktab4" href="#tab4">Project Groups</a></li>
                        <li><a href="#tab3">Settings</a></li>
                    </ul>
                    <!-- //Tab buttons -->
                    <div class="tabDetails">
                        <div class="tabContents" id="tab1" style="display: block;">

                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Project ID :
                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*"
                                                                ControlToValidate="txtcode" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:TextBox ID="txtcode" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Title :
                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="*"
                                                                ControlToValidate="txtname" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                                </label>
                                <div class="txt w3 ">
                                    <asp:TextBox ID="txtname" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                            <div class="clear"></div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Client:<asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ErrorMessage="*"
                                        ControlToValidate="dropclient" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:DropDownList ID="dropclient" runat="server" CssClass="form-control">
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Manager :<asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="*"
                                        ControlToValidate="dropmanager" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:DropDownList ID="dropmanager" runat="server" CssClass="form-control">
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Contract Type :
                                </label>
                                <div class="txt w1">
                                    <asp:DropDownList ID="dropcontracttype" runat="server" CssClass="form-control">
                                        <%--                                        <asp:ListItem Selected="True" Value="">--All--</asp:ListItem>--%>
                                        <asp:ListItem Value="Fixed">Fixed</asp:ListItem>
                                        <asp:ListItem Value="Hourly">Hourly</asp:ListItem>
                                        <asp:ListItem Value="Hourlynottoexceed">Hourly not to exceed</asp:ListItem>
                                        <asp:ListItem Value="Percentage">Percentage</asp:ListItem>
                                        <asp:ListItem Value="Recurring">Recurring</asp:ListItem>
                                        <asp:ListItem Value="RecurringwithCAP">Recurring with CAP</asp:ListItem>

                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="clear"></div>

                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Contract Amt. :($)
                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="*"
                                                                ControlToValidate="txtcontractamt" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:TextBox ID="txtcontractamt" runat="server" CssClass="form-control" placeholder="$0.00"
                                        onkeypress="blockNonNumbers(this, event, true, false);" onchange="checkamount(); fillserviceamt(this.value)"
                                        onkeyup="extractNumber(this,2,false);"></asp:TextBox>
                                </div>
                            </div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Service Amt. :($)</label>
                                <div class="txt w1 mar10">
                                    <asp:TextBox ID="txtserviceamt" runat="server" CssClass="form-control" placeholder="$0.00"
                                        onkeypress="blockNonNumbers(this, event, true, false);" onchange="checkamount(); fillcontract()"
                                        onkeyup="extractNumber(this,2,false);"></asp:TextBox>
                                </div>
                            </div>


                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Exp Amt :($)
                                </label>
                                <div class="txt w1">
                                    <asp:TextBox ID="txtexpamt" runat="server" CssClass="form-control" placeholder="$0.00"
                                        onkeypress="blockNonNumbers(this, event, true, false);" onchange="checkamount();fillcontract()"
                                        onkeyup="extractNumber(this,2,false);"></asp:TextBox>
                                </div>
                            </div>
                            <div class="clear"></div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    % Complete :
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:TextBox ID="txtpercent" runat="server" CssClass="form-control" placeholder="0.00"
                                        onkeypress="blockNonNumbers(this, event, true, false);"
                                        onkeyup="extractNumber(this,2,false);"></asp:TextBox>
                                </div>
                            </div>


                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Start Date :
                                </label>
                                <div class="txt w1 mar10">

                                    <asp:TextBox ID="txtstartdate" runat="server" CssClass="form-control hasDatepicker"
                                        placeholder="MM/DD/YYYY"></asp:TextBox>

                                    <ajax:CalendarExtender ID="cc1" runat="server" TargetControlID="txtstartdate" PopupButtonID="txtstartdate"
                                        Format="MM/dd/yyyy">
                                    </ajax:CalendarExtender>

                                </div>
                            </div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Due Date :
                                </label>
                                <div class="txt w1">

                                    <asp:TextBox ID="txtenddate" runat="server" CssClass="form-control hasDatepicker"
                                        placeholder="MM/DD/YYYY"></asp:TextBox>

                                    <ajax:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtenddate"
                                        PopupButtonID="txtenddate" Format="MM/dd/yyyy">
                                    </ajax:CalendarExtender>
                                </div>
                            </div>
                            <div class="clear"></div>

                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Budgeted Hours :
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:TextBox ID="txtBudgetedHours" runat="server" CssClass="form-control" placeholder="0.00"
                                        onkeypress="blockNonNumbers(this, event, true, false);"
                                        onkeyup="extractNumber(this,2,false);"></asp:TextBox>
                                </div>
                            </div>

                            <div class="ctrlGroup">
                                <label class="lbl">
                                    PO# :
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:TextBox ID="txtPO" runat="server" CssClass="form-control" ToolTip="Purchase order"></asp:TextBox>
                                </div>
                            </div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Status :
                                </label>
                                <div class="txt w1 ">
                                    <asp:DropDownList ID="dropactive" runat="server" CssClass="form-control">
                                        <asp:ListItem Value="Active" Selected="True">Active</asp:ListItem>
                                        <asp:ListItem Value="Archived">Archived</asp:ListItem>
                                        <asp:ListItem Value="Completed">Completed</asp:ListItem>
                                        <asp:ListItem Value="Hold">Hold</asp:ListItem>
                                        <asp:ListItem Value="Inactive">Inactive</asp:ListItem>
                                        <asp:ListItem Value="Main">Main</asp:ListItem>
                                        <asp:ListItem Value="Canceled">Canceled</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="clear"></div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Remark :
                                </label>
                                <div class="txt w4">
                                    <asp:TextBox ID="txtremark" runat="server" CssClass="form-control"
                                        TextMode="MultiLine"></asp:TextBox>
                                </div>
                            </div>
                            <div class="clear">
                            </div>
                        </div>

                        <div class="tabContents" id="tab2" style="display: none;">

                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Currency :
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:DropDownList ID="dropcurrency" runat="server" CssClass="form-control">
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Billing Frequency :</label>
                                <div class="txt w1 mar10">
                                    <asp:DropDownList ID="dropfrequency" runat="server" CssClass="form-control">
                                        <asp:ListItem Value="" Selected="True">Weekly</asp:ListItem>

                                        <asp:ListItem Value="BiWeekly">Bi-Weekly</asp:ListItem>
                                        <asp:ListItem Value="SemiMonthly">Semi-Monthly</asp:ListItem>
                                        <asp:ListItem Value="Monthly">Monthly</asp:ListItem>
                                        <asp:ListItem Value="BiMonthly">Bi-Monthly</asp:ListItem>
                                        <asp:ListItem Value="Semi-Annually">Semi-Annually</asp:ListItem>
                                        <asp:ListItem Value="Annually">Annually</asp:ListItem>
                                        <asp:ListItem Value="Upon Limit">Upon Limit</asp:ListItem>
                                        <%--  <asp:ListItem Selected="True" Value="">--All--</asp:ListItem>--%>
                                        <%--  <asp:ListItem Value="Fixed" >Fixed</asp:ListItem>
                                        <asp:ListItem Selected="True" Value="Hourly">Hourly</asp:ListItem>
                                        <asp:ListItem Value="Hourlynottoexceed">Hourly not to exceed</asp:ListItem>
                                        <asp:ListItem Value="Percentage">Percentage</asp:ListItem>
                                        <asp:ListItem Value="Recurring">Recurring</asp:ListItem>
                                        <asp:ListItem Value="RecurringwithCAP">Recurring with CAP</asp:ListItem>--%>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Tax(%) :
                                </label>
                                <div class="txt w1">
                                    <asp:DropDownList ID="droptax" runat="server" CssClass="form-control"></asp:DropDownList>
                                </div>
                            </div>
                            <div class="clear"></div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Main Expense Tax(%) :
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:TextBox ID="txtexpensetax" runat="server" CssClass="form-control" placeholder="0.00"
                                        onkeypress="blockNonNumbers(this, event, true, false);"
                                        onkeyup="extractNumber(this,2,false);"></asp:TextBox>
                                </div>
                            </div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Payment Term :
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:DropDownList ID="droppaymentterm" runat="server" CssClass="form-control"></asp:DropDownList>
                                </div>
                            </div>
                            <div class="clear"></div>
                            <div class="ctrlGroup">
                                <asp:CheckBox ID="chkcustominvoice" runat="server" CssClass="checkboxauto" onclick="setcustom(this.value);"
                                    Text="Use Custom Invoice Number" />
                            </div>
                            <div class="clear"></div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Prefix :
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:TextBox ID="txtprefix" runat="server" CssClass="form-control" placeholder="Invoice Number Prefix"
                                        Enabled="false"></asp:TextBox>
                                </div>
                            </div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Invoice Number :
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:TextBox ID="txtinvoicenumber" runat="server" CssClass="form-control" placeholder="Last Invoice Number"
                                        Enabled="false"></asp:TextBox>
                                </div>
                            </div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Suffix :
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:TextBox ID="txtSuffix" runat="server" CssClass="form-control" placeholder="Invoice Suffix"
                                        Enabled="false"></asp:TextBox>
                                </div>
                            </div>

                            <div class="clear">
                            </div>
                        </div>

                        <!-- recurring tab -->

                        <div class="tabContents" id="recurrTab" style="display: none;">
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Recurring Amount :($)
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:TextBox ID="txtRecurringAmt" runat="server" CssClass="form-control" onkeypress="blockNonNumbers(this, event, true, false);"
                                        onkeyup="extractNumber(this,2,false);" onchange="this.value = parseFloat(this.value.toString()).toFixed(2);" placeholder="$0.00"></asp:TextBox>
                                </div>
                            </div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Interval period :</label>
                                <div class="txt w1 mar10">
                                    <asp:TextBox ID="txtIntervalperiod" onkeypress="blockNonNumbers(this, event, true, false);"
                                        onkeyup="extractNumber(this,2,false);" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                            <div class="clear"></div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Start Date :
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:TextBox ID="txtrecurringStartdate" runat="server" CssClass="form-control hasDatepicker"
                                        placeholder="MM/DD/YYYY"></asp:TextBox>

                                    <ajax:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtrecurringStartdate" PopupButtonID="txtrecurringStartdate"
                                        Format="MM/dd/yyyy">
                                    </ajax:CalendarExtender>

                                </div>
                            </div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    End Date :
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:TextBox ID="txtrecurringEnddate" onchange="RecurrTabcheckdate(this.value,this.id);" runat="server" CssClass="form-control hasDatepicker"
                                        placeholder="MM/DD/YYYY"></asp:TextBox>

                                    <ajax:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtrecurringEnddate" PopupButtonID="txtrecurringEnddate"
                                        Format="MM/dd/yyyy">
                                    </ajax:CalendarExtender>

                                </div>
                            </div>
                            <div class="clear"></div>
                        </div>


                        <div class="tabContents" id="tab3" style="display: none;">
                            <div class="col-sm-12" style="min-height: 300px;">
                                <h5 class="roleheader color">Time Sheet Default Settings</h5>
                                <div class="ctrlGroup lbl">

                                    <asp:CheckBox ID="dropTbillable" runat="server" CssClass="chkboxnew" Text="Default time entry is billable"></asp:CheckBox>


                                </div>
                                <div class="clear"></div>
                                <div class="ctrlGroup lbl">

                                    <asp:CheckBox ID="dropTmemoreq" runat="server" CssClass="chkboxnew" Text="Memo is required for a  time entry"></asp:CheckBox>

                                </div>
                                <div class="clear"></div>
                                <div class="ctrlGroup lbl">


                                    <asp:CheckBox ID="chkTTaskDesc" runat="server" CssClass="chkboxnew" Text="Disallow employee to edit task description"></asp:CheckBox>

                                </div>
                                <div class="clear"></div>

                                <h5 class="roleheader color">Expenses Default Settings</h5>

                                <div class="ctrlGroup lbl">


                                    <asp:CheckBox ID="dropEbillable" runat="server" CssClass="chkboxnew" Text="Default expense entry is billable"></asp:CheckBox>

                                </div>
                                <div class="clear"></div>
                                <div class="ctrlGroup lbl">

                                    <asp:CheckBox ID="dropEmonoreq" runat="server" CssClass="chkboxnew" Text="Memo is required for an expense entry"></asp:CheckBox>

                                </div>
                                <div class="clear"></div>
                                <div class="ctrlGroup lbl">


                                    <asp:CheckBox ID="chkTExpenseDesc" runat="server" CssClass="chkboxnew" Text="Disallow employee to edit expense description"></asp:CheckBox>

                                </div>

                            </div>
                            <div class="clear">
                            </div>
                        </div>

                        <div class="tabContents" id="tab4" style="display: none;">
                            <div class="col-sm-12">
                                <div class="ctrlGroup">
                                    <label class="lbl" style="margin-top: 6px;">
                                        Select Project Groups :

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
                                    <label class="lbl">
                                        Project ID/Title :
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:TextBox ID="txtsearch" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl">
                                        Status :
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:DropDownList ID="drostatus" runat="server" CssClass="form-control">
                                            <asp:ListItem Selected="True" Value="">--All--</asp:ListItem>
                                            <asp:ListItem Value="Active">Active</asp:ListItem>
                                            <asp:ListItem Value="Archived">Archived</asp:ListItem>
                                            <asp:ListItem Value="Completed">Completed</asp:ListItem>
                                            <asp:ListItem Value="Hold">Hold</asp:ListItem>
                                            <asp:ListItem Value="Inactive">Inactive</asp:ListItem>
                                            <asp:ListItem Value="Main">Main</asp:ListItem>
                                            <asp:ListItem Value="Canceled">Canceled</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="clear"></div>
                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl">
                                        Contract Type :
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:DropDownList ID="dropcontracttype1" runat="server" CssClass="form-control">
                                            <asp:ListItem Selected="True" Value="">--All--</asp:ListItem>
                                            <asp:ListItem Value="Weekly">Weekly</asp:ListItem>
                                            <asp:ListItem Value="BiWeekly">BiWeekly</asp:ListItem>
                                            <asp:ListItem Value="SemiMonthly">SemiMonthly</asp:ListItem>
                                            <asp:ListItem Value="Monthly">Monthly</asp:ListItem>
                                            <asp:ListItem Value="BiMonthly">BiMonthly</asp:ListItem>
                                            <asp:ListItem Value="Semi-Annually">Semi-Annually</asp:ListItem>
                                            <asp:ListItem Value="Annually">Annually</asp:ListItem>
                                            <asp:ListItem Value="Upon Limit">Upon Limit</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl">
                                        Client :
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:DropDownList ID="dropclient1" runat="server" CssClass="form-control">
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

                                                        <asp:TemplateField HeaderText="Project ID" SortExpression="projectcode" HeaderStyle-Width="100px">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"projectcode")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                        <asp:TemplateField HeaderText="Title" SortExpression="projectname">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"projectname")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Client" SortExpression="clientname">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"clientname")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Contract Amount" SortExpression="contractAmt">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem, "contractAmt")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="% Complete" SortExpression="completePercent" HeaderStyle-Width="100px">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"completePercent")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Bud. Hours" SortExpression="budgetedHours" HeaderStyle-Width="80px">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"budgetedHours")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Due Date" SortExpression="duedate" HeaderStyle-Width="100px">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"duedate")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>


                                                        <asp:TemplateField HeaderText="Status" SortExpression="projectStatus" HeaderStyle-Width="75px">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"projectStatus")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                        <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="70px">
                                                            <ItemTemplate>
                                                                <a onclick='clickedit(<%#DataBinder.Eval(Container.DataItem,"nid")%>);' title="Edit"><i class="fa fa-fw">
                                                                    <img src="images/edit.png"></i></a>
                                                                &nbsp;
                                                                <asp:LinkButton ID="lbtndelete" CommandName="remove" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>'
                                                                    ToolTip="Delete" runat="server"
                                                                    OnClientClick='return confirm("Delete this record?Yes or No");'><i class="fa fa-fw" >
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
        function fnRecurrTabomparedate(val, id) {
            var txtrecurstartDate = $("#ctl00_ContentPlaceHolder1_txtrecurringStartdate").val()
            var txtrecurendDate= $("#ctl00_ContentPlaceHolder1_txtrecurringEnddate").val()
            var callfrom = "ctl00_ContentPlaceHolder1_txtrecurringStartdate";
            var callto = "ctl00_ContentPlaceHolder1_txtrecurringEnddate";
            if (val != "" && val != "__/__/____") {
                if (!isDate(txtrecurstartDate)) {
                    alert('Invalid date format, date must be in mm/dd/yyyy format');
                    document.getElementById(id).value = "";
                }
                else {
                    if (txtrecurstartDate != "" && txtrecurendDate != "") {
                        var d1 = new Date(txtrecurstartDate);
                        var d2 = new Date(txtrecurendDate);
                        if (d1 > d2) {
                            if (callfrom === id) {
                                alert("Start date should not be greater End date.");
                            } else {
                                alert("End Date range should be with in the Start date.");
                            }
                            event.preventDefault();
                            document.getElementById(id).value = "";
                        }
                    }
                }
            }
        }
        function RecurrTabcheckdate(val, id) {
            if (val != "" && val != "__/__/____") {
                if (!isDate(val)) {
                    alert('Invalid date format, date must be in mm/dd/yyyy format');
                    document.getElementById(id).value = "";
                    $("#" + id).focus();
                } else {
                    return fnRecurrTabomparedate(val, id);
                }
            }
        }
        function fillcontract() {
            if ($("#ctl00_ContentPlaceHolder1_txtserviceamt").val() != "" &&
                $("#ctl00_ContentPlaceHolder1_txtexpamt").val() != "") {
                $("#ctl00_ContentPlaceHolder1_txtcontractamt").val(
                    (parseFloat($("#ctl00_ContentPlaceHolder1_txtserviceamt").val()) +
                        parseFloat($("#ctl00_ContentPlaceHolder1_txtexpamt").val())).toFixed(2));
                $("#ctl00_ContentPlaceHolder1_txtserviceamt").val(parseFloat($("#ctl00_ContentPlaceHolder1_txtserviceamt").val()).toFixed(2))
                $("#ctl00_ContentPlaceHolder1_txtexpamt").val(parseFloat($("#ctl00_ContentPlaceHolder1_txtexpamt").val()).toFixed(2))
            }
        }
        function fillserviceamt(amt) {
            $("#ctl00_ContentPlaceHolder1_txtcontractamt").val(parseFloat(amt).toFixed(2))
            $("#ctl00_ContentPlaceHolder1_txtserviceamt").val(parseFloat(amt).toFixed(2));
            $("#ctl00_ContentPlaceHolder1_txtexpamt").val(0);
        }
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
    </script>
    <script>

        $('form').on('keyup keypress', function (e) {
            var keyCode = e.keyCode || e.which;
            if (keyCode === 13) {
                e.preventDefault();
                return false;
            }
        });
    </script>
</asp:Content>
