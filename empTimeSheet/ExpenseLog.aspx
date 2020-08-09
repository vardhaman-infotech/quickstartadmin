<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="ExpenseLog.aspx.cs" Inherits="empTimeSheet.ExpenseLog" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit.HTMLEditor"
    TagPrefix="cc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        function bindtaskvalue(id, value) {
            var rownum = id.replace('ddltask', '');
            var taskarr = value.split("#");

            document.getElementById("txtdesc" + rownum).value = taskarr[2];
            if (taskarr[1] == "1" || taskarr[1] == "true")
                document.getElementById("chkbillable" + rownum).checked = true;
            else
                document.getElementById("chkbillable" + rownum).checked = false;
        }
        function bindgridtaskvalue(id, value) {
            var rownum = id.replace('droptask', '');
            var taskarr = value.split("#");

            document.getElementById(rownum + "txtdesc").value = taskarr[2];
            if (taskarr[1] == "1" || taskarr[1] == "true")
                document.getElementById(rownum + "chkbillableedit").checked = true;
            else
                document.getElementById(rownum + "chkbillableedit").checked = false;


        }
    </script>
    <!--Script to validate DATE-->
    <script type="text/javascript">
        function isDate1(date) {
            var objDate,  // date object initialized from the ExpiryDate string 
        mSeconds, // ExpiryDate in milliseconds 
        day,      // day 
        month,    // month 
        year;     // year 
            // date length should be 10 characters (no more no less) 
            if (date.length !== 10) {
                return false;
            }
            // third and sixth character should be '/' 
            if (date.substring(2, 3) !== '/' || date.substring(5, 6) !== '/') {
                return false;
            }
            // extract month, day and year from the ExpiryDate (expected format is mm/dd/yyyy) 
            // subtraction will cast variables to integer implicitly (needed 
            // for !== comparing) 
            month = date.substring(0, 2) - 1; // because months in JS start from 0 
            day = date.substring(3, 5) - 0;
            year = date.substring(6, 10) - 0;
            // test year range 
            if (year < 1000 || year > 3000) {
                return false;
            }
            // convert ExpiryDate to milliseconds 
            mSeconds = (new Date(year, month, day)).getTime();
            // initialize Date() object from calculated milliseconds 
            objDate = new Date();
            objDate.setTime(mSeconds);
            // compare input date and parts from Date() object 
            // if difference exists then date isn't valid 
            if (objDate.getFullYear() !== year ||
        objDate.getMonth() !== month ||
        objDate.getDate() !== day) {
                return false;
            }
            // otherwise return true 
            return true;
        }
    </script>
    <script type="text/javascript">

        function addrow() {
            var table = document.getElementById("tbldata");
            var id = parseInt(document.getElementById("<%=hidrowno.ClientID %>").value);
            var sno = parseInt(document.getElementById("<%=hidsno.ClientID %>").value);
            sno = sno + 1
            var newsno = id + 1;
            var row = table.insertRow(newsno);


            if (id > 0)
                document.getElementById("divdel" + id).innerHTML = "";

            var cellapprove = row.insertCell(0);
            var celldelete = row.insertCell(1);

            var celldate = row.insertCell(2);
            var cellproject = row.insertCell(3);
            var celltask = row.insertCell(4);
            var celldes = row.insertCell(5);
            var cellunits = row.insertCell(6);
            var cellcost = row.insertCell(7);
            var cellmu = row.insertCell(8);
            var cellamount = row.insertCell(9);
            var cellbillable = row.insertCell(10);
            var cellreimbursable = row.insertCell(11);
            var cellmemo = row.insertCell(12);

            var cell13 = row.insertCell(13);
            var cell14 = row.insertCell(14);

            celldelete.innerHTML = "<div id='divdel" + newsno + "' ><a style='cursor: pointer;color:bule;' id='delete' onclick='deleterow(this.id);' ><img src='images/delete.png' /></a></div>";

            celldate.innerHTML = " <input type='text' id='txtdate" + newsno + "' class='form-control date'  onclick='scwShow(scwID(this.id),this);'/>";
            cellproject.innerHTML = "<select id='ddlproject" + newsno + "' class='form-control'>" + document.getElementById("divproject").innerHTML + "</select>";
            celltask.innerHTML = "<select id='ddltask" + newsno + "' class='form-control' onchange='bindtaskvalue(this.id,this.value);' >" + document.getElementById("divtask").innerHTML + "</select>";
            cellunits.innerHTML = "<input type='text' id='txtunits" + newsno + "' class='form-control' onkeypress='blockNonNumbers(this, event, true, false);'  onchange='calcamount(this.id);' onblur='extractNumber(this,2,false);' onkeyup='extractNumber(this,2,false);' />";
            cellcost.innerHTML = "<input type='text' id='txtcost" + newsno + "' class='form-control' onchange='calcamount(this.id);' onkeypress='blockNonNumbers(this, event, true, false);'   onblur='extractNumber(this,2,false);' onkeyup='extractNumber(this,2,false);' />";
            cellmu.innerHTML = "<input type='text' id='txtmu" + newsno + "' class='form-control' onkeypress='blockNonNumbers(this, event, true, false);'   onblur='extractNumber(this,2,false);' onkeyup='extractNumber(this,2,false);' />";
            cellamount.innerHTML = "<input type='text' id='txtamount" + newsno + "' class='form-control' disbled='disabled'  onkeypress='blockNonNumbers(this, event, true, false);'   onblur='extractNumber(this,2,false);' onkeyup='extractNumber(this,2,false);' />";
            cellbillable.innerHTML = "<input type='checkbox' id='chkbillable" + newsno + "'/>";
            cellreimbursable.innerHTML = "<input type='checkbox' id='chkreimbursable" + newsno + "'/>";
            cellmemo.innerHTML = "<a id='lnkmemo" + newsno + "' onclick='opendiv(this.id,1);' >Memo</a>  <span id='hidmemo"+newsno+"' style='display:none;' />";
            celldes.innerHTML = "<input type='text' id='txtdesc" + newsno + "' class='form-control' />";
            document.getElementById("<%=hidrowno.ClientID %>").value = newsno;
            document.getElementById("<%=hidsno.ClientID %>").value = sno;
            var height = $('#divsheetbox')[0].scrollHeight;
            $('#divsheetbox').scrollTop(height);
        }


        //Delete rows
        function deleterow() {

            var table = document.getElementById("tbldata");
            var id = parseInt(document.getElementById("<%=hidrowno.ClientID %>").value);
            var sno = parseInt(document.getElementById("<%=hidsno.ClientID %>").value);
            sno = sno - 1
            var newsno = id - 1;
            table.deleteRow(id);
            if (newsno != "0")
                document.getElementById("divdel" + newsno).innerHTML = "<a style='cursor: pointer;color:bule;' id='delete' onclick='deleterow(this.id);' ><img src='images/delete.png' /></a>";
            document.getElementById("<%=hidrowno.ClientID %>").value = newsno;
            document.getElementById("<%=hidsno.ClientID %>").value = sno;

        }

        //Validate entered TIME
        function savedata() {

            var status = 1;
            var newid = "";
            var id = parseInt(document.getElementById("<%=hidrowno.ClientID %>").value);

            for (var i = 0; i <= id; i++) {

                newid = "ddlproject" + i;

                if (document.getElementById(newid).value == "") {
                    status = 0;
                    document.getElementById(newid).className = "errform-control";
                }
                else {
                    document.getElementById(newid).className = "form-control";
                }
                newid = "txtdate" + i;

                if (document.getElementById(newid).value == "") {
                    status = 0;
                    document.getElementById(newid).className = "errform-control date";
                }
                else {
                    if (isDate1(document.getElementById(newid).value)) {
                        document.getElementById(newid).className = "form-control date";
                    }
                    else {
                        status = 0;
                        document.getElementById(newid).className = "errform-control date";
                    }
                }

                newid = "ddltask" + i;

                if (document.getElementById(newid).value == "") {
                    status = 0;
                    document.getElementById(newid).className = "errform-control";
                }
                else {
                    document.getElementById(newid).className = "form-control";
                }

                newid = "txtunits" + i;

                if (document.getElementById(newid).value == "" || document.getElementById(newid).value == "0") {
                    status = 0;
                    document.getElementById(newid).className = "errform-control";
                }
                else {
                    if (isNaN(document.getElementById(newid).value)) {
                        status = 0;
                        document.getElementById(newid).className = "errform-control";
                    }
                    else {
                        document.getElementById(newid).className = "form-control";
                    }
                }

                newid = "txtcost" + i;

                if (document.getElementById(newid).value == "" || document.getElementById(newid).value == "0") {
                    status = 0;
                    document.getElementById(newid).className = "errform-control";
                }
                else {
                    if (isNaN(document.getElementById(newid).value)) {
                        status = 0;
                        document.getElementById(newid).className = "errform-control";
                    }
                    else {
                        document.getElementById(newid).className = "form-control";
                    }
                }

                newid = "txtamount" + i;

                if (document.getElementById(newid).value == "" || document.getElementById(newid).value == "0") {
                    status = 0;
                    document.getElementById(newid).className = "errform-control";
                }
                else {
                    if (isNaN(document.getElementById(newid).value)) {
                        status = 0;
                        document.getElementById(newid).className = "errform-control";
                    }
                    else {
                        document.getElementById(newid).className = "form-control";
                    }
                }
            }

            if (status == 0) {
                return false;
            }
            else {

                // submitform();
                getinfo();
                return true;

            }

        }

        //Bind entered time info to hidden field after validate the entries
        function getinfo() {
            var newid = "", project = "", task = "", date = "", units = "", des = "", billable = "", cost = "", mu = "", amount = "", reimbursable = "", memo = "";
            var empid = document.getElementById("ctl00_ContentPlaceHolder1_hidempid").value;
            //---------
            var companyid = document.getElementById("hidcompanyid").value;
            var id = parseInt(document.getElementById("<%=hidrowno.ClientID %>").value);

            for (var i = 0; i <= id; i++) {

                newid = "ddlproject" + i;

                project = project + "#" + document.getElementById(newid).value;

                newid = "txtdate" + i;

                date = date + "#" + document.getElementById(newid).value;

                newid = "ddltask" + i;
                var taskvalue = document.getElementById(newid).value;
                var taskarr = taskvalue.split("#");
                //  alert(newid);
                task = task + "#" + taskarr[0];

                newid = "txtdesc" + i;

                des = des + "#" + document.getElementById(newid).value;

                newid = "txtunits" + i;

                units = units + "#" + document.getElementById(newid).value;

                newid = "txtcost" + i;

                cost = cost + "#" + document.getElementById(newid).value;

                newid = "txtmu" + i;

                mu = mu + "#" + document.getElementById(newid).value;

                newid = "txtamount" + i;

                amount = amount + "#" + document.getElementById(newid).value;

                newid = "chkbillable" + i;
                if (document.getElementById(newid).checked == true) {
                    billable = billable + "#1";
                }
                else {
                    billable = billable + "#0";
                }

                newid = "chkreimbursable" + i;
                if (document.getElementById(newid).checked == true) {
                    reimbursable = reimbursable + "#1";
                }
                else {
                    reimbursable = reimbursable + "#0";
                }
                newid = "hidmemo" + i;
                memo = memo + "#" + document.getElementById(newid).innerHTML;

            }
            var args = { taskdate: date, projectid: project, taskid: task, cost: cost, description: des, units: units, amount: amount, billable: billable, mu: mu, reimbursable: reimbursable, memo: memo, companyid: companyid, empid: empid };
            $.ajax({

                type: "POST",
                url: "ExpenseLog.aspx/savetimesheet",
                data: JSON.stringify(args),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                cache: false,
                success: function (data) {
                    //Check length of returned data, if it is less than 0 it means there is some status available
                    if (data.d != "success") {
                        alert('There is some problem in saving information, please try again');
                        return false;
                    }
                    else {

                        alert('Saved Successfully!');
                        resetdata();

                    }
                }
            });
        }


        //Reset valuesof entered time

        function resetdata() {
            var id = parseInt(document.getElementById("<%=hidrowno.ClientID %>").value);
            for (var j = 1; j <= id; j++) {

                deleterow();
            }
            document.getElementById("txtdate0").value = "";
            document.getElementById("ddlproject0").value = ""
            document.getElementById("txtdesc0").value = "";
            document.getElementById("ddltask0").value = "";
            document.getElementById("txtunits0").value = "";
            document.getElementById("txtcost0").value = "";
            document.getElementById("txtmu0").value = "";
            document.getElementById("txtamount0").value = "";
            document.getElementById("chkbillable0").value = "";
            document.getElementById("chkreimbursable0").value = "";
            document.getElementById("hidmemo0").innerHTML = "";
            window.location.href = "ExpenseLog.aspx";

        }

    </script>
    <!--Script to Show and Hide Past Entries Div-->
    <script type="text/javascript">
        function showhidepast(status) {
            var displaystatus = "";

            if (status == "") {
                var a = (document.getElementById("divpast")).style;
                displaystatus = a.display;
            }
            else {
                displaystatus = status;
            }
            if (displaystatus == "block") {
                document.getElementById("divpast").style.display = "none";
                document.getElementById("imgshowhide_past").src = "images/down.png";
                document.getElementById("ctl00_ContentPlaceHolder1_btnapprove").style.display = "none";
                document.getElementById("ctl00_ContentPlaceHolder1_btnreject").style.display = "none";
            }
            else {
                document.getElementById("divpast").style.display = "block";
                document.getElementById("imgshowhide_past").src = "images/up.png";
                document.getElementById("ctl00_ContentPlaceHolder1_btnapprove").style.display = "block";
                document.getElementById("ctl00_ContentPlaceHolder1_btnreject").style.display = "block";
            }
        }

    </script>
    <script type="text/javascript">
        function calcamount(id) {
            if (id.indexOf('txtunits') > -1) {
                var rownum = id.replace("txtunits", "");
            }
            else if (id.indexOf('txtcost') > -1) {
                var rownum = id.replace("txtcost", "");
            }
            else {
                var rownum = id.replace("txtmu", "");
            }

            var units = parseFloat(document.getElementById("txtunits" + rownum).value);
            var cost = parseFloat(document.getElementById("txtcost" + rownum).value);
            var mu = parseFloat(document.getElementById("txtmu" + rownum).value);

            if (isNaN(units)) {
                units = 0;
            }
            if (isNaN(cost)) {
                cost = 0;

            }
            var totalamount = 0
            totalamount = parseFloat(units) * parseFloat(cost);
            if (parseFloat(mu) > 0) {
                var muamount = (totalamount * mu) / 100;
                totalamount = totalamount + muamount;
            }
            document.getElementById("txtamount" + rownum).value = totalamount;
        }
    </script>
    <!---Scripts for Row selection when aprrove.. goes here-->
    <script type="text/javascript">
        function SelectAll(CheckBoxControl) {
            if (CheckBoxControl.checked == true) {
                var i;
                for (i = 0; i < document.forms[0].elements.length; i++) {
                    if ((document.forms[0].elements[i].type == 'checkbox') &&
(document.forms[0].elements[i].name.indexOf('dgnews') > -1)) {
                        if (!document.forms[0].elements[i].disabled) {

                            document.forms[0].elements[i].checked = true;
                        }
                    }
                }
            }
            else {
                var i;
                for (i = 0; i < document.forms[0].elements.length; i++) {
                    if ((document.forms[0].elements[i].type == 'checkbox') &&
(document.forms[0].elements[i].name.indexOf('dgnews') > -1)) {
                        if (!document.forms[0].elements[i].disabled) {
                            document.forms[0].elements[i].checked = false;
                        }

                    }
                }
            }
        }



        //------Check whther any row selected or not
        function checkrowselected(id) {
            var ischecked = 0;
            var i;
            for (i = 0; i < document.forms[0].elements.length; i++) {
                if ((document.forms[0].elements[i].type == 'checkbox') &&
(document.forms[0].elements[i].name.indexOf('dgnews') > -1)) {
                    if (!document.forms[0].elements[i].disabled && document.forms[0].elements[i].checked == true) {

                        ischecked = 1;
                        break;
                    }
                }

            }
            if (ischecked == 1) {

                return true;
            }
            else {
                alert("please select a record first.");
                return false;
            }
        }
    </script>

    <script type="text/javascript">
        function closediv() {
            document.getElementById("hidselectedmemoid").value = "";
            document.getElementById("divmemo").style.display = "none";
            document.getElementById("otherdiv").style.display = "none";
        }

        function opendiv(id, mode) {
            var mode1 = "";
            mode1 = String(mode)
            var txtmemo = $find("<%= txtmemo.ClientID %>");
            if (mode1 == "view") {
                document.getElementById("btnsavememo").style.display = "none";
                document.getElementById("ctl00_ContentPlaceHolder1_ltrmemo").style.display = "block";
                document.getElementById("divtxtmemo").style.display = "none";
            }
            else {
                document.getElementById("btnsavememo").style.display = "inline";

                document.getElementById("ctl00_ContentPlaceHolder1_ltrmemo").style.display = "none";
                document.getElementById("divtxtmemo").style.display = "block";
            }
            setposition("divmemo");
          
            id = id.replace("lnkmemo", "hidmemo");
           
            var exisitngmemo = document.getElementById(id).innerHTML;

            if (mode == "add") {
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
            document.getElementById(id).innerHTML = memo;
            closediv();

        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div style="width: 100%; float: left; vertical-align: top; margin-bottom: 30px;"
        id="divsheetbox">
        <pg:progress ID="progress2" runat="server" />
        <div id="otherdiv" onclick="closediv();">
        </div>
        <div class="pageheader">
            <h2>
                <i class="fa  fa-file-text"></i>Expenses Log
            </h2>
            <div class="breadcrumb-wrapper mar ">
                <input type="hidden" id="hidid" runat="server" />
                <asp:LinkButton ID="btnexportcsv" runat="server" CssClass="right_link" OnClick="btnexportcsv_Click">
                <i class="fa fa-fw fa-file-excel-o topicon"></i>Export to Excel</asp:LinkButton>
                <asp:LinkButton ID="lnkrefresh" runat="server" CssClass="right_link" OnClick="lnkrefresh_Click">
                <i class="fa fa-fw fa-refresh topicon"></i>Refresh</asp:LinkButton>
                <asp:LinkButton ID="btnreject" runat="server" CssClass="right_link" OnClick="setstatus"
                    OnClientClick='return checkrowselected(); return confirm("Are you sure?");'>
                    <i class="fa fa-fw  fa-minus-circle topicon"></i>Reject</asp:LinkButton>
                <asp:LinkButton ID="btnapprove" runat="server" CssClass="right_link" OnClick="setstatus"
                    OnClientClick='return checkrowselected(); return confirm("Are you sure?");'>
                    <i class="fa fa-fw  fa-check-circle topicon"></i>Approve</asp:LinkButton>
            </div>
            <div class="clear">
            </div>
        </div>
        <div class="contentpanel">
            <div class="row">
                <div class="col-sm-12 col-md-12">
                    <div class="panel panel-default">
                        <div class="col-sm-12 col-md-10">
                            <div style="padding-top: 10px;">
                                <div class="col-xs-12 col-sm-8 col-md-6 f_left" style="padding: 0px;">
                                    <h5 class="subtitle mb5">Expenses Log Entry</h5>
                                </div>
                              <div class="clear"></div>
                                <div class="col-xs-3 col-sm-3" style="float:left;padding-right:10px">

                                    <asp:TextBox ID="txtfrom" runat="server" CssClass="form-control hasDatepicker" onchange="hidedetails();"></asp:TextBox>

                                    <cc1:CalendarExtender ID="txtDate_CalendarExtender" runat="server" TargetControlID="txtfrom"
                                        PopupButtonID="txtfrom" Format="MM/dd/yyyy">
                                    </cc1:CalendarExtender>

                                </div>
                                <div class="col-xs-3 col-sm-3" style="float:left;padding-right:10px">

                                    <asp:TextBox ID="txtto" runat="server" CssClass="form-control hasDatepicker" onchange="hidedetails();"></asp:TextBox>

                                    <cc1:CalendarExtender ID="txtDate_CalendarExtender1" runat="server" TargetControlID="txtto"
                                        PopupButtonID="txtto" Format="MM/dd/yyyy">
                                    </cc1:CalendarExtender>

                                </div>
                                 
                                  <div class="col-xs-3 col-sm-3" style="float:left;padding-right:10px">
                                    <asp:DropDownList ID="dropemployee" runat="server" CssClass="form-control" onchange="hidedetails();">
                                    </asp:DropDownList>
                                </div>
                                <div class="col-xs-3 col-sm-3" style="float:left;">
                                    <asp:Button ID="btnsearch" runat="server" Text="Search" CssClass="btn btn-default"
                                        OnClick="btnsearch_Click" />
                                </div>
                            </div>
                        </div>
                        <div class="clear">
                        </div>
                        <div id="divright" class="col-sm-12 col-md-12 mar2">
                            <div class="panel-default">
                                <div class="panel-body2 ">
                                    <div class="row">
                                        <div class="table-responsive">
                                            <asp:UpdatePanel ID="upadatepanel1" runat="server" ChildrenAsTriggers="true" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <asp:GridView ID="dgnews" runat="server" AllowPaging="false" AutoGenerateColumns="False"
                                                        CellPadding="4" CellSpacing="0" Width="100%" ShowHeader="true" ShowFooter="false"
                                                        CssClass="tblsheet" GridLines="None" OnRowCommand="dgnews_RowCommand" OnRowDataBound="dgnews_RowDataBound"
                                                        OnRowCancelingEdit="dgnews_RowCancelingEdit" OnRowDeleting="dgnews_RowDeleting"
                                                        OnRowEditing="dgnews_RowEditing" OnRowUpdating="dgnews_RowUpdating" ShowHeaderWhenEmpty="true">
                                                        <Columns>
                                                            <asp:TemplateField HeaderText="Approve" HeaderStyle-Width="20px" ItemStyle-HorizontalAlign="Center"
                                                                HeaderStyle-HorizontalAlign="Right">
                                                                <HeaderTemplate>
                                                                    <input id="chkSelect" runat="server" name="Select All" onclick="SelectAll(this)" type="checkbox"
                                                                        style="margin-left: 0px;margin-right: 0px;" />
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:CheckBox ID="chkapprove" runat="server" style="margin-left: 0px;margin-right: 0px;"/>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderStyle-Width="20px">
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="lbtndelete" CommandName="del" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>'
                                                                        ToolTip="Delete" runat="server" OnClientClick='return confirm("Delete this record? Yes or No");'><img src="images/delete.png" alt="Delete"  /></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>

                                                            <asp:TemplateField HeaderText="Date" HeaderStyle-Width="12%">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "date")%>
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <asp:TextBox ID="txtdate" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "date")%>'
                                                                        CssClass="form-control date"></asp:TextBox>
                                                                    <cc1:CalendarExtender ID="txtDatecce" runat="server" TargetControlID="txtdate" PopupButtonID="txtdate"
                                                                        Format="MM/dd/yyyy">
                                                                    </cc1:CalendarExtender>
                                                                </EditItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Project" HeaderStyle-Width="15%">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "projectname")%>
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <asp:DropDownList ID="dropproject" runat="server" CssClass="form-control">
                                                                    </asp:DropDownList>
                                                                </EditItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Expense" HeaderStyle-Width="15%">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "codename")%>
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <asp:DropDownList ID="droptask" runat="server" CssClass="form-control" onchange='bindgridtaskvalue(this.id,this.value);'
                                                                        OnSelectedIndexChanged="droptask_selectedIndexChanged">
                                                                    </asp:DropDownList>
                                                                </EditItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Description">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "description")%>
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <asp:TextBox ID="txtdesc" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "description")%>'
                                                                        CssClass="form-control"></asp:TextBox>
                                                                </EditItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Units" HeaderStyle-Width="4%">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "Units")%>
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <asp:TextBox ID="txtunits" onkeypress="blockNonNumbers(this, event, true, false);"
                                                                        onblur="fill(this.id);" onchange="calcamount(this.id);" onkeyup="extractNumber(this,2,false);" runat="server"
                                                                        Text='<%# DataBinder.Eval(Container.DataItem, "units")%>' CssClass="form-control"></asp:TextBox>
                                                                </EditItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Cost" HeaderStyle-Width="5%">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "cost")%>
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <asp:TextBox ID="txtcost" onkeypress="blockNonNumbers(this, event, true, false);"
                                                                        onblur="fill(this.id);" onchange="calcamount(this.id);" onkeyup="extractNumber(this,2,false);" runat="server"
                                                                        Text='<%# DataBinder.Eval(Container.DataItem, "cost")%>' CssClass="form-control"></asp:TextBox>
                                                                </EditItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="MU" HeaderStyle-Width="5%">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "mu")%>
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <asp:TextBox ID="txtmu" onkeypress="blockNonNumbers(this, event, true, false);" onblur="fill(this.id);"
                                                                        onkeyup="extractNumber(this,2,false);" runat="server" onchange="calcamount(this.id);" Text='<%# DataBinder.Eval(Container.DataItem, "mu")%>'
                                                                        CssClass="form-control" ToolTip="Markup %" placeholder="%"></asp:TextBox>
                                                                </EditItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Amount" HeaderStyle-Width="5%">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "amount")%>
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <asp:TextBox ID="txtamount" onkeypress="blockNonNumbers(this, event, true, false);"
                                                                        onblur="fill(this.id);" onkeyup="extractNumber(this,2,false);" runat="server" Enabled="false"
                                                                        Text='<%# DataBinder.Eval(Container.DataItem, "amount")%>' CssClass="form-control"></asp:TextBox>
                                                                </EditItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="B" HeaderStyle-Width="17px">
                                                                <ItemTemplate>
                                                                    <asp:CheckBox ID="chkbillable" runat="server" Enabled="false" ToolTip="Billable" />
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <asp:CheckBox ID="chkbillableedit" runat="server" ToolTip="Billable" />
                                                                </EditItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="R" HeaderStyle-Width="17px">
                                                                <ItemTemplate>
                                                                    <asp:CheckBox ID="chkreimbursable" runat="server" Enabled="false" ToolTip="Reimbursable" />
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <asp:CheckBox ID="chkreimbursableedit" runat="server" ToolTip="Reimbursable" />
                                                                </EditItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="" HeaderStyle-Width="4%">
                                                                <ItemTemplate>
                                                                    <a id="lnkmemo" runat="server" onclick="opendiv(this.id,'view');">Memo</a>
                                                                    <span id="hidmemo" runat="server" style="display:none;"><%#Eval("memo") %></span>
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <a id="lnkmemoedit" runat="server" onclick="opendiv(this.id,'add');">Memo</a>
                                                                    <span id="hidmemoedit" runat="server" style="display:none;"> <%#Eval("memo") %></span>
                                                                </EditItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="S" HeaderStyle-Width="17px">
                                                                <ItemTemplate>
                                                                    <img style="cursor: default;" alt="" src='images/<%#DataBinder.Eval(Container.DataItem,"status")%>.png'
                                                                        title='<%#DataBinder.Eval(Container.DataItem,"status")%>' />
                                                                    <input type="hidden" id="hidnid1" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "nid")%>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>

                                                            <asp:CommandField InsertVisible="False" ShowDeleteButton="false" HeaderStyle-Width="45px"
                                                                ShowEditButton="true" ButtonType="Image" EditImageUrl="images/edit.png" UpdateImageUrl="images/approved.png"
                                                                CancelImageUrl="images/rejected.png" EditText="Edit Details" UpdateText="Save Changes" CancelText="Cancel Editing" />
                                                        </Columns>

                                                        <HeaderStyle CssClass="gridheader" />
                                                        <EmptyDataRowStyle CssClass="nodatafound" />
                                                    </asp:GridView>
                                                </ContentTemplate>
                                               
                                            </asp:UpdatePanel>
                                            <div id="divtableaddnew" runat="server">
                                                <div style="padding-top: 0px;">
                                                    <table width="100%" cellpadding="4" cellspacing="0" id="tbldata" class="tblsheet">
                                                        <tr>
                                                            <td width="20px"></td>
                                                            <td width="20">
                                                                <div id="divdel0">
                                                                </div>
                                                            </td>

                                                            <td width="12%">
                                                                <input type="text" id="txtdate0" class="form-control date" onclick="scwShow(scwID(this.id), this);" />
                                                            </td>
                                                            <td width="15%">
                                                                <select id="ddlproject0" class="form-control">
                                                                    <%=strproject%>
                                                                </select>
                                                            </td>
                                                            <td width="15%">
                                                                <select id="ddltask0" class="form-control" onchange='bindtaskvalue(this.id,this.value);'>
                                                                    <%=strtask%>
                                                                </select>
                                                            </td>
                                                            <td>
                                                                <input type="text" id="txtdesc0" class="form-control" />
                                                            </td>
                                                            <td width="4%">
                                                                <input type="text" id="txtunits0" class="form-control" onkeypress="blockNonNumbers(this, event, true, false);"
                                                                    onblur="extractNumber(this,2,false);" onkeyup="extractNumber(this,2,false);"
                                                                    onchange="calcamount(this.id);" />
                                                            </td>
                                                            <td width="5%">
                                                                <input type="text" id="txtcost0" class="form-control" onkeypress="blockNonNumbers(this, event, true, false);"
                                                                    onblur="extractNumber(this,2,false);" onkeyup="extractNumber(this,2,false);"
                                                                    onchange="calcamount(this.id);" />
                                                            </td>
                                                            <td width="5%">
                                                                <input type="text" id="txtmu0" class="form-control" onkeypress="blockNonNumbers(this, event, true, false);"
                                                                    onblur="extractNumber(this,2,false);" onchange="calcamount(this.id);"
                                                                    onkeyup="extractNumber(this,2,false);" />
                                                            </td>
                                                            <td width="5%">
                                                                <input type="text" id="txtamount0" class="form-control" onkeypress="blockNonNumbers(this, event, true, false);"
                                                                    onblur="extractNumber(this,2,false);" value="0" disabled="disabled" onkeyup="extractNumber(this,2,false);" />
                                                            </td>
                                                            <td width="17px">
                                                                <input type="checkbox" id="chkbillable0" />
                                                            </td>
                                                            <td width="17px">
                                                                <input type="checkbox" id="chkreimbursable0" />
                                                            </td>
                                                            <td width="4%">
                                                                <a id="lnkmemo0" onclick="opendiv(this.id,'add');">Memo</a>
                                                                <span id="hidmemo0" style="display:none;" />
                                                            </td>
                                                            <td width="17px"></td>
                                                            <td width="45px"></td>
                                                        </tr>
                                                    </table>
                                                </div>
                                                <div class="fulldiv">
                                                    <div style="float: right; text-align: right; padding-bottom: 5px; padding-top: 5px;">
                                                        +&nbsp;<a onclick="return addrow();" id="addmore" style="text-decoration: underline;">Add
                                                            New</a>
                                                    </div>
                                                </div>
                                                <div style="margin-bottom: 20px; margin-top: 15px; float: left;">
                                                    <input type="button" value="Submit" class="btn btn-primary" onclick="savedata();" />
                                                    <asp:Button ID="btnsubmit" runat="server" CssClass="btn btn-primary" Text="Submit"
                                                        OnClick="save" Style="display: none;" />

                                                </div>
                                            </div>
                                        </div>
                                        <input type="hidden" id="hidrowno" runat="server" />
                                        <input type="hidden" id="hidsno" runat="server" />
                                        <input type="hidden" id="hidempid" runat="server" />
                                        <input type="hidden" id="hidempname" runat="server" />
                                        <input type="hidden" id="hidfromdate" runat="server" />
                                        <input type="hidden" id="hidtodate" runat="server" />
                                        <input type="hidden" id="hidcompanyid" runat="server" />
                                        <input type="hidden" id="hiduserid" runat="server" />
                                        <input type="hidden" id="hidtask_project" runat="server" />
                                        <input type="hidden" id="hidtask_date" runat="server" />
                                        <input type="hidden" id="hidtask_task" runat="server" />
                                        <input type="hidden" id="hidtask_units" runat="server" />
                                        <input type="hidden" id="hidtask_cost" runat="server" />
                                        <input type="hidden" id="hidtask_mu" runat="server" />
                                        <input type="hidden" id="hidtask_amount" runat="server" />
                                        <input type="hidden" id="hidtask_description" runat="server" />
                                        <input type="hidden" id="hidtask_billable" runat="server" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="clear">
                        </div>
                    </div>
                    <!-- panel -->
                </div>
            </div>
        </div>
    </div>
    <div id="divproject" style="display: none;">
        <%=strproject%>
    </div>
    <div style="display: none;" id="divtask">
        <%=strtask%>
    </div>
    <!-- Expense log's add/view memo div goes here-->
    <div style="width: 640px;" id="divmemo" class="itempopup">
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
            <div id="ltrmemo" runat="server" style="display:none;max-height: 350px;
    overflow-y: auto;"></div>

            <div class=" clear pad2">
                <input type="hidden" id="hidselectedmemoid" />
                <input type="button" id="btnsavememo" class="btn btn-primary" onclick="addmemo();" value="Add Memo" />
                <input type="button" id="btncancelalert" class="btn
            btn-primary"
                    value="Cancel" onclick="closediv();" />
            </div>
        </div>
    </div>
    <script type="text/javascript" src="js/jquery-ui.js"></script>
</asp:Content>
