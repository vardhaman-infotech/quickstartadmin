<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="InvoicePayment.aspx.cs" Inherits="empTimeSheet.InvoicePayment" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .labelpayment {
            font-family: "open_sans_semibold",Arial,Helvetica,sans-serif;
        }

        #spanamounttitle {
            color: #000000;
        }
    </style>
    <script type="text/javascript">

        function setvisibility(id) {
            var val = document.getElementById(id).value;
            document.getElementById("ctl00_ContentPlaceHolder1_txtamount").value = "0";
            document.getElementById("ctl00_ContentPlaceHolder1_chkapplyretainer").removeAttribute("disabled");
            document.getElementById("ctl00_ContentPlaceHolder1_chkapplyretainer").checked = false;
            document.getElementById("spanretaineramount").style.display = "block";

            document.getElementById("spanamounttitle").innerHTML = "Amount:";
            if (val == "Use Retainer") {
                desablegridview();
                document.getElementById("ctl00_ContentPlaceHolder1_txtamount").value = document.getElementById("ctl00_ContentPlaceHolder1_txtClientRetainer").value;
                document.getElementById("ctl00_ContentPlaceHolder1_chkapplyretainer").checked = true;
                document.getElementById("ctl00_ContentPlaceHolder1_chkapplyretainer").setAttribute("disabled", true);
                document.getElementById("spanamounttitle").innerHTML = "Total Retainer Amount:";

            }
            if (val == "Write Off") {
                desablegridview();
                document.getElementById("spanamounttitle").innerHTML = "Total Write Off Amount:";
                document.getElementById("spanretaineramount").style.display = "none";
                document.getElementById("ctl00_ContentPlaceHolder1_chkapplyretainer").setAttribute("disabled", true);


            }

        }
        function desablegridview() {

            var table = document.getElementById("ctl00_ContentPlaceHolder1_dgnews");
            if (table != null) {
                var tbody = table.tBodies[0];

                for (var i = 2; i <= tbody.rows.length; i++) {
                    var rownum = zeroFill(i, 2);
                    //Get checkbox id
                    var checkboxid = "ctl00_ContentPlaceHolder1_dgnews_ctl" + rownum + "_chkapply";

                    //Get textbox id for amt applied for the row
                    var txtamtid = "ctl00_ContentPlaceHolder1_dgnews_ctl" + rownum + "_txtamtapplied";

                    document.getElementById(checkboxid).checked = false;
                    document.getElementById(txtamtid).value = "0";
                }
            }
            showtotal(0, 0);
        }
        function setmaxamount(id) {

            if (document.getElementById("ctl00_ContentPlaceHolder1_ddlpaymentmethod").value == "Use Retainer") {
                if (document.getElementById(id).value != "") {


                    if (parseFloat(document.getElementById(id).value) > parseFloat(document.getElementById("ctl00_ContentPlaceHolder1_txtClientRetainer").value)) {

                        document.getElementById(id).value = document.getElementById("ctl00_ContentPlaceHolder1_txtClientRetainer").value;
                        alert("Applied amount could not be greater then retainer amount.");
                    }

                }
            }
            calculateamount();
        }
    </script>

    <script type="text/javascript">

        function validate1(source, args) {

            var id = "ctl00_ContentPlaceHolder1_txtamount";
            if (document.getElementById(id).value != "") {
                var amount = parseFloat(document.getElementById(id).value);

                if (amount > 0) {
                    args.IsValid = true;
                }
                else {
                    alert("Payment amount should greater then 0!")
                    args.IsValid = false;
                }
            }
            else {
                args.IsValid = true;
            }
            return;
        }
        function validate2(source, args) {

            var id = "ctl00_ContentPlaceHolder1_ddlpaymentmethod";

            var paymethod = parseFloat(document.getElementById(id).value);
            if (document.getElementById("ctl00_ContentPlaceHolder1_chkapplyretainer").checked == false) {
                if (amount != "") {
                    args.IsValid = true;
                }
                else {

                    args.IsValid = false;
                }
            }
            else {
                args.IsValid = true;
            }
            return;
        }

        function validatesearch() {
            var isvalid = true;
            if (document.getElementById("ctl00_ContentPlaceHolder1_dropclient").value == "" && document.getElementById("ctl00_ContentPlaceHolder1_dropproject").value == "") {
                isvalid = false;
            }
            if (isvalid) {
                return true;
            }
            else {
                alert("Please select a client or project name");
                return false;
            }
        }

        function validateinvoice() {

            var i;
            var ischecked = false;
            for (i = 0; i < document.forms[0].elements.length; i++) {
                if ((document.forms[0].elements[i].type == 'checkbox') &&
(document.forms[0].elements[i].name.indexOf('dgnews') > -1)) {

                    if (document.forms[0].elements[i].checked == true) {

                        ischecked = true;
                    }

                }
            }
            if (ischecked == true) {
                document.getElementById("ctl00_ContentPlaceHolder1_btnsubmit").disabled = false;

            }
            else {
                document.getElementById("ctl00_ContentPlaceHolder1_btnsubmit").disabled = "disabled";

            }
        }

        function calculateamount() {
            var totalamount = 0, appliedamount = 0; var ischecked = false;
            totalamount = document.getElementById("ctl00_ContentPlaceHolder1_txtamount").value;
            table = document.getElementById("ctl00_ContentPlaceHolder1_dgnews");
            if (table != null)
                tbody = table.tBodies[0];
            if (parseFloat(totalamount) > 0) {


                for (var i = 2; i <= tbody.rows.length; i++) {
                    var rownum = zeroFill(i, 2);
                    //Get checkbox id
                    var checkboxid = "ctl00_ContentPlaceHolder1_dgnews_ctl" + rownum + "_chkapply";

                    //Get textbox id for amt applied for the row
                    var txtamtid = "ctl00_ContentPlaceHolder1_dgnews_ctl" + rownum + "_txtamtapplied";
                    //Check whether row has selected or not
                    if (document.getElementById(checkboxid).checked == true) {
                        ischecked = true;
                        var newid = "", invoicedue = 0, applyamount = 0;
                        newid = "ctl00_ContentPlaceHolder1_dgnews_ctl" + rownum + "_hidinvoicedue";

                        invoicedue = parseFloat(document.getElementById(newid).value);
                        var remainingamount = 0;
                        remainingamount = totalamount - appliedamount;
                        if (remainingamount > invoicedue) {
                            applyamount = invoicedue;
                        }
                        else {
                            applyamount = remainingamount;
                        }
                        document.getElementById(txtamtid).value = applyamount.toFixed(2);

                        appliedamount = appliedamount + applyamount;
                    }
                    else {
                        document.getElementById(txtamtid).value = "0.00";
                    }

                }


                showtotal(totalamount, appliedamount);

            }
            else if (tbody != null) {

                for (var i = 2; i <= tbody.rows.length; i++) {
                    var rownum = zeroFill(i, 2);
                    //Get checkbox id
                    var checkboxid = "ctl00_ContentPlaceHolder1_dgnews_ctl" + rownum + "_chkapply";

                    //Get textbox id for amt applied for the row
                    var txtamtid = "ctl00_ContentPlaceHolder1_dgnews_ctl" + rownum + "_txtamtapplied";
                    document.getElementById(checkboxid).checked = false;
                    document.getElementById(txtamtid).value = "0.00";


                }


                showtotal(0, 0);
            }
        }
        //Show total amount at bottom
        function showtotal(totalamount, appliedamount) {
            //Show total amount applied on invoices
            document.getElementById("spantotalamount").innerHTML = "<b>Total Amount Applied: </b>$ " + appliedamount;

            //If TotalAmount is going to pay is greater that applied amount on invoices then the remaining amount will be treated as client reatiner
            if (totalamount > appliedamount) {

                document.getElementById("ctl00_ContentPlaceHolder1_hidretaineramount").value = (parseFloat(totalamount - appliedamount)).toFixed(2);
                document.getElementById("spanretaineramount").innerHTML = "<b>Retainer Amount: </b>$ " + (parseFloat(totalamount - appliedamount)).toFixed(2);
            }
            else {
                document.getElementById("ctl00_ContentPlaceHolder1_hidretaineramount").value = "0.00";
                document.getElementById("spanretaineramount").innerHTML = "";

            }
            //if currently available retainer amount is greater than 0 and "Apply as retainer" is selected then we will apply that amount on applied amount and show applied retainer total
            var currentreatineramount = document.getElementById("ctl00_ContentPlaceHolder1_txtClientRetainer").value;
            if (parseFloat(currentreatineramount) > 0 && document.getElementById("ctl00_ContentPlaceHolder1_chkapplyretainer").checked == true) {
                if (appliedamount > currentreatineramount) {
                    document.getElementById("ctl00_ContentPlaceHolder1_hidretainageapplied").value = currentreatineramount;
                }
                else {
                    document.getElementById("ctl00_ContentPlaceHolder1_hidretainageapplied").value = appliedamount;
                }
                document.getElementById("spanretainerapplied").innerHTML = "<b>Applied Retainer Amount: </b>$" + (document.getElementById("ctl00_ContentPlaceHolder1_hidretainageapplied").value);

            }
            else {
                document.getElementById("ctl00_ContentPlaceHolder1_hidretainageapplied").value = "0.00";
                document.getElementById("spanretainerapplied").innerHTML = "";
            }
        }


        //Calculate total applied amount if users change manually in amt applied
        function calculaterowtotal() {
            var totalappliedamount = 0;
            var table = document.getElementById("ctl00_ContentPlaceHolder1_dgnews");
            var tbody = table.tBodies[0];
            totalamount = document.getElementById("ctl00_ContentPlaceHolder1_txtamount").value;
            for (var i = 2; i <= tbody.rows.length; i++) {
                var rownum = zeroFill(i, 2);
                //Get checkbox id
                var checkboxid = "ctl00_ContentPlaceHolder1_dgnews_ctl" + rownum + "_chkapply";

                //Get textbox id for amt applied for the row
                var txtamtid = "ctl00_ContentPlaceHolder1_dgnews_ctl" + rownum + "_txtamtapplied";

                var txtdueamount = "ctl00_ContentPlaceHolder1_dgnews_ctl" + rownum + "_hidinvoicedue";

                //Check whether row has selected or not
                if (document.getElementById(checkboxid).checked == true) {
                    var amtapplied = parseFloat(document.getElementById(txtamtid).value);
                    var dueamt = parseFloat(document.getElementById(txtdueamount).value);


                    if (amtapplied > dueamt) {
                        alert("Applied amount on an invoice should not greater then balance amount!");
                        document.getElementById(txtamtid).value = dueamt;
                    }


                    if ((totalappliedamount + amtapplied) > totalamount) {
                        alert("'Total Applied Amount' on invoices cannot grater than 'Payment Amount'");
                        document.getElementById(txtamtid).value = (totalamount - totalappliedamount).toFixed(2);
                    }

                    totalappliedamount = totalappliedamount + parseFloat(document.getElementById(txtamtid).value);
                }
            }
            showtotal(totalamount, totalappliedamount);

        }

        function validatepyment() {
         
            var isvalid = true;
            var status = 0;
            var table = document.getElementById("ctl00_ContentPlaceHolder1_dgnews");
            var tbody = table.tBodies[0];
            var totalWAmt = 0;

            if (document.getElementById("ctl00_ContentPlaceHolder1_ddlpaymentmethod").value == "Check"  )
            {
                if (document.getElementById("ctl00_ContentPlaceHolder1_txtcheckno").value == "") {
                    alert("Please enter check/transcrion refe no.");
                    isvalid = false;
                    return false;
                }
            }
             

            var chkchecked = false;
            for (var i = 2; i <= tbody.rows.length; i++) {
                var rownum = zeroFill(i, 2);
                //Get checkbox id
                var checkboxid = "ctl00_ContentPlaceHolder1_dgnews_ctl" + rownum + "_chkapply";
               
                //Get textbox id for amt applied for the row
                var txtamtid = "ctl00_ContentPlaceHolder1_dgnews_ctl" + rownum + "_txtamtapplied";

                //Check whether row has selected or not
                if (document.getElementById(checkboxid).checked == true) {
                    chkchecked = true;
                    status = 1;
                    if (document.getElementById(txtamtid).value == "" || parseFloat(document.getElementById(txtamtid).value) <= 0) {
                        isvalid = false;
                        document.getElementById(txtamtid).className = "errform-control";
                    }
                    else {
                        totalWAmt = totalWAmt + parseFloat(document.getElementById(txtamtid).value);
                        document.getElementById(txtamtid).className = "form-control";
                    }


                }

            }

            if (chkchecked == false && document.getElementById("ctl00_ContentPlaceHolder1_chkapplyretainer").checked == false) {
                alert("Please select any invoice.");
                isvalid = false;
                return false;
            }
            if (document.getElementById("ctl00_ContentPlaceHolder1_ddlpaymentmethod").value == "Use Retainer" || document.getElementById("ctl00_ContentPlaceHolder1_ddlpaymentmethod").value == "Write Off") {
                if (status == 0) {
                    alert("Select at least one invoice in case of '" + document.getElementById("ctl00_ContentPlaceHolder1_ddlpaymentmethod").value + "'");
                    isvalid = false;
                }
                else {
                    
                    if (document.getElementById("ctl00_ContentPlaceHolder1_ddlpaymentmethod").value == "Write Off" && (totalWAmt < parseFloat(document.getElementById("ctl00_ContentPlaceHolder1_txtamount").value))) {
                        alert("Total 'Write Off Amount' should equal to total of amount applied on invoices! ");
                        isvalid = false;
                    }
                }
            }
            return isvalid;
        }
    </script>
    <script type="text/javascript">
        //Open add/edit div
        function opendiv() {
            var ischecked = false;
            for (i = 0; i < document.forms[0].elements.length; i++) {
                if ((document.forms[0].elements[i].type == 'checkbox') &&
(document.forms[0].elements[i].name.indexOf('dgnews') > -1)) {
                    if (document.forms[0].elements[i].checked == true) {
                        ischecked = true;
                    }

                }
            }
            if (ischecked == false) {
                alert('Please select invoice first');
            }
            else {
                setposition("divpaymentdetails");
                document.getElementById("divpaymentdetails").style.display = "block";
                document.getElementById("otherdiv").style.display = "block";
            }
        }
        function closediv() {

            document.getElementById("divpaymentdetails").style.display = "none";
            document.getElementById("otherdiv").style.display = "none";
        }


        $(document).ready(function () {
            $("#ctl00_ContentPlaceHolder1_txtamount").focus(function () {
                if (parseInt( $("#ctl00_ContentPlaceHolder1_txtamount").val()) == 0) {
                    $("#ctl00_ContentPlaceHolder1_txtamount").val("");
                }
            });
        })
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <pg:progress ID="progress1" runat="server" />
    <div id="otherdiv" onclick="closediv();">
    </div>
    <div class="pageheader">
        <h2>
            <i class="fa fa-money"></i>Receive Payment
        </h2>
        <div class="breadcrumb-wrapper mar ">
        </div>
        <div class="clear">
        </div>
    </div>
    <div class="contentpanel">
        <div class="row">
            <div class="col-sm-12 col-md-12">
                <div class="panel panel-default" style="min-height: 250px;">
                    <div class="col-sm-12 col-md-10">
                        <div style="padding-top: 10px;">
                            <div class="col-xs-12 col-sm-12 col-md-12 f_left" style="padding: 0px;">
                                <h5 class="subtitle mb5">Receive Invoice Payment</h5>
                            </div>
                            <asp:UpdatePanel ID="updatePanelSearch" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                     <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl2">Client : </label>
                                        <div class="txt w2 mar10">
                                            <asp:DropDownList ID="dropclient" runat="server" CssClass="form-control" AutoPostBack="true"  
                                                OnSelectedIndexChanged="dropclient_OnSelectedIndexChanged">
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="dropclient"
                                                ValidationGroup="save1" ErrorMessage="*" Style="display: none;"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                  
                                    <div class="clear"></div>
                                   
                                      <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl2">Project : </label>
                                        <div class="txt w1 mar10">
                                            <asp:DropDownList ID="dropproject" runat="server" CssClass="form-control" onchange="document.getElementById('ctl00_ContentPlaceHolder1_divpayment').style.display = 'none';">
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                </ContentTemplate>
                            </asp:UpdatePanel>

                            <%--  <asp:TextBox ID="txtinvno" runat="server" CssClass="form-control mar "></asp:TextBox>--%>
                            <div class="ctrlGroup searchgroup">
                                <asp:Button ID="btnsearch" runat="server" Text="Search" CssClass="btn btn-default"
                                    OnClientClick="return validatesearch();" OnClick="btnsearch_Click" />
                            </div>
                        </div>
                    </div>
                    <div class="clear">
                    </div>

                    <div id="divpayment" runat="server" visible="false" class="mar2">
                        <div class="col-xs-3 col-sm-3 leftdivpayment">
                            <div class="col-xs-12 col-xs-12 form-group f_left pad">
                                <label class="col-sm-12 control-label pad4 labelpayment">
                                    Date:<asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtdate"
                                        ValidationGroup="save1" ErrorMessage="*" Style="display: none;"></asp:RequiredFieldValidator>
                                </label>

                                <div class="clear"></div>
                                <div class="col-xs-12 col-sm-10 pad4">

                                    <asp:TextBox ID="txtdate" runat="server" CssClass="form-control hasDatepicker f_left"
                                        placeholder="Payment Date" Enabled="true"></asp:TextBox>


                                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtdate"
                                        PopupButtonID="txtdate" Format="MM/dd/yyyy">
                                    </cc1:CalendarExtender>
                                </div>
                            </div>
                            <div class="col-xs-12 col-xs-12 form-group  f_left pad">
                                <label class="col-sm-12 control-label pad4 labelpayment">
                                    Payment Method:
                                  <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="ddlpaymentmethod"
                                      ValidationGroup="save1" ErrorMessage="*" Style="display: none;"></asp:RequiredFieldValidator></label>
                                <div class="col-xs-12 col-sm-10 pad4">
                                    <asp:DropDownList ID="ddlpaymentmethod" runat="server" CssClass="form-control" Enabled="true" onchange="setvisibility(this.id);">
                                        <asp:ListItem Selected="True" Value="">--Select--</asp:ListItem>
                                        <asp:ListItem>Cash</asp:ListItem>
                                        <asp:ListItem>Check</asp:ListItem>
                                        <asp:ListItem>Credit Card</asp:ListItem>
                                        <asp:ListItem>Write Off</asp:ListItem>
                                        <%-- <asp:ListItem>Debit</asp:ListItem>
                                        <asp:ListItem>NSF</asp:ListItem>
                                        <asp:ListItem>EFT</asp:ListItem>
                                        <asp:ListItem>Money Order</asp:ListItem>
                                        <asp:ListItem>Write Off</asp:ListItem>
                                        <asp:ListItem>Other</asp:ListItem>--%>
                                        <asp:ListItem>Use Retainer</asp:ListItem>
                                        <asp:ListItem>Paypal</asp:ListItem>
                                        <asp:ListItem>E-Check</asp:ListItem>
                                        <%--<asp:ListItem>Wire Transfer</asp:ListItem>--%>
                                    </asp:DropDownList>
                                </div>

                            </div>
                            <div class="clear">
                            </div>
                            <div class="col-xs-12 col-xs-12 form-group  f_left pad">
                                <label class="col-sm-12 control-label pad4 labelpayment">
                                    Check/Transaction #:</label>
                                <div class="col-xs-12 col-sm-10 pad4">
                                    <asp:TextBox ID="txtcheckno" runat="server" CssClass="form-control" placeholder="Check/Transaction #"
                                        Enabled="true"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-xs-12 col-xs-12 form-group  f_left pad">
                                <label class="col-sm-12 control-label pad4 labelpayment">
                                    <span id="spanamounttitle">Amount:</span><asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtamount"
                                        ValidationGroup="save1" ErrorMessage="*" Style="display: none;"></asp:RequiredFieldValidator>
                                </label>
                                <div class="col-xs-12 col-sm-10 pad4">
                                    <span class="f_left" style="margin-top: 6px;">
                                        <%=strcurrency %></span><asp:TextBox ID="txtamount" CssClass="form-control f_left"
                                            runat="server" onkeypress="blockNonNumbers(this, event, true, false);" onkeyup="extractNumber(this,2,false);"
                                            Style="width: 95%;" Text="0.00" Enabled="true" onchange="setmaxamount(this.id);"></asp:TextBox>
                                </div>
                            </div>

                            <div class="clear"></div>
                            <div class="col-xs-12 col-xs-12 form-group f_left pad">
                                <label class="col-sm-12 control-label pad4 labelpayment">
                                    Client Retainer Available:
                                </label>

                                <div class="clear"></div>
                                <div class="col-xs-12 col-sm-10 pad4">
                                    <span class="f_left" style="margin-top: 6px;">
                                        <%=strcurrency %></span>
                                    <asp:TextBox ID="txtClientRetainer" runat="server" CssClass="form-control f_left" Enabled="false"
                                        placeholder="Client Retainer" onkeypress="blockNonNumbers(this, event, true, false);" onkeyup="extractNumber(this,2,false);"
                                        Style="width: 95%;" Text="0.00"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-xs-12 col-xs-12 form-group f_left pad chkpayment">

                                <asp:CheckBox ID="chkapplyretainer" runat="server" Text="Apply as Retainer" CssClass="checkboxauto chkpayment" />
                            </div>
                            <div class="col-xs-12 pad4 clear">
                                <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage=""
                                    ValidationGroup="save2" CssClass="errmsg"
                                    ClientValidationFunction="validate1" Style="display: none;"></asp:CustomValidator>
                            </div>
                        </div>

                        <div class="col-sm-9 col-md-9 rightdivpayment">
                            <div class="panel">
                                <div class="panel-body">
                                    <div class="row">
                                        <%--  <asp:UpdatePanel ID="updatePanelData" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="false">
                                                    <ContentTemplate>--%>
                                        <div class="table-responsive">
                                            <div class="nodatafound mar2" id="divnodata" runat="server" visible="false">
                                                No invoice found
                                            </div>
                                            <asp:GridView ID="dgnews" runat="server" AllowPaging="true" AutoGenerateColumns="False"
                                                CellPadding="4" CellSpacing="0" Width="100%" ShowHeader="true" PageSize="50"
                                                ShowFooter="false" CssClass="table tblsheet mb30" GridLines="None" AllowSorting="true">
                                                <Columns>
                                                    <asp:TemplateField HeaderText="Apply" HeaderStyle-Width="50px" HeaderStyle-HorizontalAlign="Center">
                                                        <ItemTemplate>
                                                            <asp:CheckBox ID="chkapply" runat="server" onchange="calculateamount();" />
                                                            <asp:HiddenField ID="hidinvoiceid" runat="server" Value='<%# DataBinder.Eval(Container.DataItem, "nid")%>' />
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Project ID">
                                                        <ItemTemplate>
                                                            <%# DataBinder.Eval(Container.DataItem, "projectCode")%>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Invoice#" HeaderStyle-Width="10%">
                                                        <ItemTemplate>
                                                            <%# DataBinder.Eval(Container.DataItem, "invoiceno")%>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Date" HeaderStyle-Width="12%">
                                                        <ItemTemplate>
                                                            <%# DataBinder.Eval(Container.DataItem, "invoicedate")%>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <%-- <asp:TemplateField HeaderText="Project Name" SortExpression="projectname">
                                                                        <ItemTemplate>
                                                                            <%# DataBinder.Eval(Container.DataItem, "projectname")%>
                                                                        </ItemTemplate>
                                                                    </asp:TemplateField>--%>
                                                    <asp:TemplateField HeaderText="Net Bill" HeaderStyle-Width="10%" ItemStyle-HorizontalAlign="right"
                                                        HeaderStyle-HorizontalAlign="right" HeaderStyle-CssClass="talignright">
                                                        <ItemTemplate>
                                                            <%=strcurrency %><%# DataBinder.Eval(Container.DataItem, "totalamount")%>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Paid" HeaderStyle-Width="10%" ItemStyle-HorizontalAlign="right"
                                                        HeaderStyle-HorizontalAlign="right" HeaderStyle-CssClass="talignright">
                                                        <ItemTemplate>
                                                            <%=strcurrency %><%# DataBinder.Eval(Container.DataItem, "invoicepaidamount")%>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Balance" HeaderStyle-Width="10%" ItemStyle-HorizontalAlign="right"
                                                        HeaderStyle-HorizontalAlign="right" HeaderStyle-CssClass="talignright">
                                                        <ItemTemplate>
                                                            <%=strcurrency %><%# DataBinder.Eval(Container.DataItem, "invoicedueamount")%>
                                                            <input type="hidden" id="hidinvoicedue" runat="server"
                                                                value='<%# DataBinder.Eval(Container.DataItem, "invoicedueamount")%>' />

                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Amt Applied($)" HeaderStyle-Width="15%" ItemStyle-HorizontalAlign="right"
                                                        HeaderStyle-HorizontalAlign="right" HeaderStyle-CssClass="talignright">
                                                        <ItemTemplate>
                                                            <%--<%=strcurrency %>--%><asp:TextBox ID="txtamtapplied" runat="server" onkeypress="blockNonNumbers(this, event, true, false);" CssClass="form-control" Style="text-align: right"
                                                                onkeyup="extractNumber(this,2,false);" Width="75px" Text="0" onchange="calculaterowtotal();"></asp:TextBox>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                                <HeaderStyle CssClass="gridheader" />
                                                <PagerStyle CssClass="gridpager" HorizontalAlign="Center" />
                                            </asp:GridView>
                                            <div class="f_right pad2">
                                                <span id="spantotalamount" class="pad2 f_right" style="text-align: right"></span>
                                                <div class="clear"></div>
                                                <span id="spanretainerapplied" class="pad2 f_right" style="text-align: right"></span>
                                                <div class="clear"></div>
                                                <span id="spanretaineramount" class="pad2 f_right" style="text-align: right"></span>
                                            </div>
                                        </div>
                                        <div class="clear">
                                        </div>
                                        <%--    <a id="lnkpayment" runat="server" class="right_link" onclick="opendiv();" visible="false">
                                                    <i class="fa fa-fw  topicon"></i>Receive Payment</a>--%>
                                        <%--    </ContentTemplate>
                                                    <Triggers>
                                                        <asp:AsyncPostBackTrigger ControlID="btnsearch" EventName="Click" />
                                                       
                                                    </Triggers>
                                                </asp:UpdatePanel>--%>
                                    </div>
                                </div>
                                <div class="clear">
                                </div>
                            </div>
                        </div>

                        <div class="col-xs-12 col-sm-12" style="padding-bottom: 15px; padding-top: 10px; text-align: center;">
                            <asp:Button ID="btnsubmit" runat="server" CssClass="btn btn-primary" CausesValidation="true"
                                Text="Submit" ValidationGroup="save1" OnClientClick="var f1= validatepyment();var f2=validatefieldsbygroup('save1');var f3=validatefieldsbygroup('save2'); if(f1==true && f2==true && f3==true){return true;} else{return false};" OnClick="btnsave_Click" />
                            <input type="hidden" id="hidclientid" runat="server" />
                            <input type="hidden" id="hidprojectid" runat="server" />
                            <input type="hidden" id="hidretainageapplied" runat="server" />
                            <input type="hidden" id="hidretaineramount" runat="server" />

                        </div>
                    </div>
                    <div class="clear"></div>

                    <!--Panel-default-->
                </div>
            </div>
        </div>
    </div>
</asp:Content>
