var json;
var jsontasks;
$(document).ready(function () {

    //---------
    var companyid = document.getElementById("hidcompanyid").value;
    //---------------------Get projects from script methos and put values to an array for autocompleter
    var args = { prefixText: "", companyid: companyid };
    $.ajax({

        type: "POST",
        url: "expenseslog.aspx/getProjects",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {
            //Check length of returned data, if it is less than 0 it means there is some status available
            if (data.d != "failure") {
                json = $.parseJSON(data.d);
                //Call project autocompleter
                bindprojectautocompleter("ddlproject0", "hidproject0");

            }
        }
    });






    //------------------------Get tasks from script methdo and put values to an array for autocompleter
    var args = { companyid: companyid };
    $.ajax({

        type: "POST",
        url: "expenseslog.aspx/getTasks",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {
            //Check length of returned data, if it is less than 0 it means there is some status available
            if (data.d != "failure") {
                jsontasks = $.parseJSON(data.d);
                //Call task autocompleter
                bindtaskautocompleter("ddltask0", "hidtask0");

            }
        }
    });





});


//---BIND projects autocompleter using json---




//---BIND projects autocompleter using json---

function bindprojectautocompleter(inputid, hiddenid) {

    $("#" + inputid + "").autocomplete({

        selectFirst: true,
        delay: 0,
        mustMatch: true,
        autoFocus: true,
        source: json,
        select: function (event, ui) {
            $("#" + hiddenid + "").val(ui.item.value);
            $("#" + inputid + "").val(ui.item.label1);

            return false;
        },
        change: function (event, ui) {

            $(this).val((ui.item ? ui.item.label1 : ""));
            $("#" + hiddenid + "").val((ui.item ? ui.item.value : ""));

        },
        focus: function (event, ui) { event.preventDefault(); }
    });
}

//----------BIND task autocompleter using jsontasks array
function bindtaskautocompleter(inputid, hiddenid) {

    $("#" + inputid + "").autocomplete({
        minLength: 2,
        selectFirst: true,
        delay: 0,
        autoFocus: true,
        source: jsontasks,
        select: function (event, ui) {

            $("#" + hiddenid + "").val(ui.item.value);
            $("#" + inputid + "").val(ui.item.label1);
            bindtaskvalue(hiddenid, ui.item == null ? "" : ui.item.value);



            return false;

        },
        change: function (event, ui) {
            $(this).val((ui.item ? ui.item.label1 : ""));
            $("#" + hiddenid + "").val((ui.item ? ui.item.value : ""));
            bindtaskvalue(hiddenid, ui.item == null ? "" : ui.item.value);


        },
        focus: function (event, ui) { event.preventDefault(); }
    });
}

function hidedetails() {
    $("#divright").hide();
}
function showdetails() {
    $("#divright").show();
}

function bindtaskvalue(id, value) {

    var strfound = id.indexOf("dgnews");
    if (strfound > -1) {
        var rownum = id.replace('hidtask', '');
        if (value != "") {
          
            var taskarr = value.split("#");

            document.getElementById(rownum + "txtdesc").value = taskarr[2];
            if (taskarr[1] == "1" || taskarr[1] == "true")
                document.getElementById(rownum + "chkbillableedit").checked = true;
            else
                document.getElementById(rownum + "chkbillableedit").checked = false;
        }
        else {
            document.getElementById(rownum + "txtdesc").value = "";
        }

    }
    else {
       
        var rownum = id.replace('hidtask', '');
        rownum = rownum.replace('ddltask', '');

        if (value != "") {
            var taskarr = value.split("#");

            document.getElementById("txtdesc" + rownum).value = taskarr[2];
            if (taskarr[1] == "1" || taskarr[1] == "true")
                document.getElementById("chkbillable" + rownum).checked = true;
            else
                document.getElementById("chkbillable" + rownum).checked = false;

            if (taskarr[4] == "1" || taskarr[4] == "true")
                document.getElementById("chkreimbursable" + rownum).checked = true;
            else
                document.getElementById("chkreimbursable" + rownum).checked = false;

            document.getElementById("txtcost" + rownum).value = taskarr[5];
            document.getElementById("txtmu" + rownum).value = taskarr[6];
        }
        else {
            document.getElementById("txtdesc"+rownum).value = "";
        }
    }

}
function bindgridtaskvalue(id, value) {
    var rownum = id.replace('droptask', '');

    if (value != "") {
        var taskarr = value.split("#");

        document.getElementById(rownum + "txtdesc").value = taskarr[2];
        if (taskarr[1] == "1" || taskarr[1] == "true")
            document.getElementById(rownum + "chkbillableedit").checked = true;
        else
            document.getElementById(rownum + "chkbillableedit").checked = false;
    }
    else {

        document.getElementById(rownum + "txtdesc").value = "";
    }
   


}

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

//Scripts for Row selection when aprrove... goes here
function SelectAll(CheckBoxControl) {
    if (CheckBoxControl.checked == true) {
        var i;
        for (i = 0; i < document.forms[0].elements.length; i++) {
            if ((document.forms[0].elements[i].type == 'checkbox') &&
(document.forms[0].elements[i].name.indexOf('chkapprove') > -1)) {
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
(document.forms[0].elements[i].name.indexOf('chkapprove') > -1)) {
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
        if ((document.forms[0].elements[i].type == 'checkbox') && (document.forms[0].elements[i].name.indexOf('dgnews') > -1)) {
            if (document.forms[0].elements[i].id != 'ctl00_ContentPlaceHolder1_dgnews_ctl01_chkSelect') {
                if (!document.forms[0].elements[i].disabled && document.forms[0].elements[i].checked == true) {

                    ischecked = 1;
                    break;
                }
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


function addrow() {
    var table = document.getElementById("tbldata");

    var id = parseInt(document.getElementById("timesheet_hidrowno").value);
    var sno = parseInt(document.getElementById("timesheet_hidsno").value);
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
    var cellattach = row.insertCell(13);
    var cell13 = row.insertCell(14);
    var cell14 = row.insertCell(15);

    celldelete.oncontextmenu = function (e) { setcopyoption(newsno, e); };


    celldelete.innerHTML = "<div id='divdel" + newsno + "' ><a style='cursor: pointer;color:bule;' id='delete' onclick='deleterow(this.id);' ><img src='images/delete.png' /></a></div>";

    celldate.innerHTML = " <input type='text' id='txtdate" + newsno + "' onkeypress='settab(this.id,event);' class='form-control date'  onchange='checkdate(this.value,this.id);'/>";
    cellproject.innerHTML = "<input type='text' id='ddlproject" + newsno + "' class='form-control' onkeypress='settab(this.id,event);'  /> <input type='hidden' id='hidproject" + newsno + "' />";
    celltask.innerHTML = "<input type='text' id='ddltask" + newsno + "' class='form-control' onkeypress='settab(this.id,event);' onchange='bindtaskvalue(this.id,this.value);' /><input type='hidden' id='hidtask" + newsno + "' />";
    cellunits.innerHTML = "<input type='text' id='txtunits" + newsno + "' class='form-control' onkeypress='blockNonNumbers(this, event, true, false);settab(this.id,event);'   onblur='extractNumber(this,2,false);calcamount(this.id);' onkeyup='extractNumber(this,2,false);' />";
    cellcost.innerHTML = "<input type='text' id='txtcost" + newsno + "' class='form-control'  onkeypress='blockNonNumbers(this, event, true, false);settab(this.id,event);'   onblur='extractNumber(this,2,false);calcamount(this.id);' onkeyup='extractNumber(this,2,false);' />";
    cellmu.innerHTML = "<input type='text' id='txtmu" + newsno + "' class='form-control' onkeypress='blockNonNumbers(this, event, true, false);settab(this.id,event);'   onblur='extractNumber(this,2,true);calcamount(this.id);' onkeyup='extractNumber(this,2,true);' />";
    cellamount.innerHTML = "<input type='text' id='txtamount" + newsno + "' class='form-control' readonly='readonly'  onkeypress='blockNonNumbers(this, event, true, false);'   onblur='extractNumber(this,2,false);' onkeyup='extractNumber(this,2,false);' />";
    cellbillable.innerHTML = "<input type='checkbox' id='chkbillable" + newsno + "' onkeypress='settab(this.id,event);'/>";
    cellreimbursable.innerHTML = "<input type='checkbox' id='chkreimbursable" + newsno + "'  onkeypress='settab(this.id,event);' />";
    cellmemo.innerHTML = "<a id='lnkmemo" + newsno + "' onclick='opendiv(this.id,1);' title='Add Memo' >Memo</a>  <input type='hidden'  id='hidmemo" + newsno + "'  />";

    cellattach.innerHTML = "<a style='color:#428bca;'  id='lnkfile" + newsno + "' onclick='openattach(this.id,1);'>Attachment</a><input type='hidden'  id='hidoriginalfile" + newsno + "' /><input type='hidden' id='hidsavedfile" + newsno + "'  />";

    celldes.innerHTML = "<input type='text' id='txtdesc" + newsno + "' class='form-control' maxlength='150' onkeydown='addautorow(" + newsno + ",event);' onkeypress='addautorow(" + newsno + ",event);' onblur='removeSpecialCh(this.id,event)'   />";





    document.getElementById("timesheet_hidrowno").value = newsno;
    document.getElementById("timesheet_hidsno").value = sno;

    var inputprojectid = "ddlproject" + newsno;
    var hiddenprojectid = "hidproject" + newsno;
    bindprojectautocompleter(inputprojectid, hiddenprojectid);

    var inputid = "ddltask" + newsno;
    var hiddenid = "hidtask" + newsno;

    bindtaskautocompleter(inputid, hiddenid);

    var height = $('#divsheetbox')[0].scrollHeight;

    $('#txtdate' + newsno).mask('99/99/9999');
    $('#txtdate' + newsno).datepicker();
    $('#divsheetbox').scrollTop(height);
}


function calhours() {
    var id = parseInt(document.getElementById("timesheet_hidrowno").value);
    var totalhrs = 0.0;
    for (var i = 0; i <= id; i++) {
        newid = "txthours" + i;
        //  alert(newid);
        if (document.getElementById(newid).value != "" && !isNaN(document.getElementById(newid).value)) {
            totalhrs += parseFloat(document.getElementById(newid).value);
        }

    }
    totalhrs = totalhrs + parseFloat(document.getElementById("timesheet_hidtotalhrs").value);
    document.getElementById("tdtotalhrs").innerHTML = totalhrs;

}


//Delete rows
function deleterow() {

    var table = document.getElementById("tbldata");
    var id = parseInt(document.getElementById("timesheet_hidrowno").value);
    var sno = parseInt(document.getElementById("timesheet_hidsno").value);
    sno = sno - 1
    var newsno = id - 1;
    table.deleteRow(id);
    if (newsno != "0")
        document.getElementById("divdel" + newsno).innerHTML = "<a style='cursor: pointer;color:bule;' id='delete' onclick='deleterow(this.id);' ><i class='fa fa-fw' style='font-size: 18px; color: #d9534f; display: block; margin: auto;'><img src='images/delete.png' alt=''></i></a>";
    document.getElementById("timesheet_hidrowno").value = newsno;
    document.getElementById("timesheet_hidsno").value = sno;
    calhours();

}

//Validate entered TIME
function savedata() {

    var status = 1;
    var newid = "";
    var newid1 = "";
    var id = parseInt(document.getElementById("timesheet_hidrowno").value);

    for (var i = 0; i <= id; i++) {

        newid = "ddlproject" + i;
        newid1 = "hidproject" + i;
        if (document.getElementById(newid1).value == "") {
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
        newid1 = "hidtask" + i;
        //  alert(newid);
        if (document.getElementById(newid1).value == "") {
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

        newid = "hidmemo" + i;
        newid1 = "lnkmemo" + i;
        if (document.getElementById(newid).value == "") {
            status = 0;
            document.getElementById(newid1).style.border = "1px solid red";
        }
        else {
            document.getElementById(newid1).style.border = "none";
        }

    }

    if (status == 0) {
        return false;
    }
    else {

        saveinfo();
        return true;

    }

}



//Bind entered time info to hidden field after validate the entries
function getinfo() {
    var newid = "", project = "", task = "", date = "", hours = "", des = "", hours1 = "", billable = "";
    var id = parseInt(document.getElementById("timesheet_hidrowno").value);

    for (var i = 0; i <= id; i++) {

        newid = "hidproject" + i;

        project = project + "#" + document.getElementById(newid).value;

        newid = "txtdate" + i;

        date = date + "#" + document.getElementById(newid).value;

        newid = "hidtask" + i;
        var taskvalue = document.getElementById(newid).value;
        var taskarr = taskvalue.split("#");
        //  alert(newid);
        task = task + "#" + taskarr[0];

        newid = "txthours" + i;

        hours = hours + "#" + document.getElementById(newid).value;

        newid = "txtdesc" + i;

        des = des + "#" + document.getElementById(newid).value;

        newid = "chkbillable" + i;
        if (document.getElementById(newid).checked == true) {
            billable = billable + "#1";
        }
        else {
            billable = billable + "#0";
        }

    }
    document.getElementById("<%=hidtask_project.ClientID %>").value = project;
    document.getElementById("<%=hidtask_date.ClientID %>").value = date;
    document.getElementById("<%=hidtask_task.ClientID %>").value = task;
    document.getElementById("<%=hidtask_hours.ClientID %>").value = hours;
    document.getElementById("<%=hidtask_description.ClientID %>").value = des;
    document.getElementById("<%=hidtask_billable.ClientID %>").value = billable;
}


//Reset valuesof entered time

function resetdata() {
    var id = parseInt(document.getElementById("timesheet_hidrowno").value);
    for (var j = 0; j <= id; j++) {

        deleterow();
    }
    document.getElementById("txtdate0").value = "";
    document.getElementById("ddlproject0").value = "";
    document.getElementById("hidproject0").value = "";
    document.getElementById("ddltask0").value = "";
    document.getElementById("hidtask0").value = "";
    document.getElementById("txtdesc0").value = "";
    document.getElementById("txthours0").value = "";

}


function saveinfo() {
    $('#ctl00_ContentPlaceHolder1_progress2_UpdateProg1').show();
    var newid = "", project = "", task = "", date = "", units = "", des = "", billable = "",
        cost = "", mu = "", amount = "", reimbursable = "", memo = "",orgfile="",savedfile="";
    var id = parseInt(document.getElementById("timesheet_hidrowno").value);
    var empid = document.getElementById("timesheet_hidempid").value;
    //---------
    var companyid = document.getElementById("hidcompanyid").value;
    for (var i = 0; i <= id; i++) {

        newid = "hidproject" + i;

        project = project + "###" + document.getElementById(newid).value;

        newid = "txtdate" + i;

        date = date + "###" + document.getElementById(newid).value;

        newid = "hidtask" + i;
        var taskvalue = document.getElementById(newid).value;
        var taskarr = taskvalue.split("#");
        //  alert(newid);
        task = task + "###" + taskarr[0];

        newid = "txtdesc" + i;

        des = des + "###" + document.getElementById(newid).value;

        newid = "txtunits" + i;

        units = units + "###" + document.getElementById(newid).value;

        newid = "txtcost" + i;

        cost = cost + "###" + document.getElementById(newid).value;

        newid = "txtmu" + i;

        mu = mu + "###" + document.getElementById(newid).value;

        newid = "txtamount" + i;

        amount = amount + "###" + document.getElementById(newid).value;

        newid = "chkbillable" + i;
        if (document.getElementById(newid).checked == true) {
            billable = billable + "###1";
        }
        else {
            billable = billable + "###0";
        }

        newid = "chkreimbursable" + i;
        if (document.getElementById(newid).checked == true) {
            reimbursable = reimbursable + "###1";
        }
        else {
            reimbursable = reimbursable + "###0";
        }
        newid = "hidmemo" + i;
        memo = memo + "###" + document.getElementById(newid).value;

        newid = "hidoriginalfile" + i;
        orgfile = orgfile + "###" + document.getElementById(newid).value;

        newid = "hidsavedfile" + i;
        savedfile = savedfile + "###" + document.getElementById(newid).value;



    }

    //---------------------Save time entries
    var args = { taskdate: date, projectid: project, taskid: task, cost: cost, description: des, units: units, amount: amount, billable: billable, mu: mu, reimbursable: reimbursable, memo: memo, companyid: companyid, empid: empid,originalfile:orgfile,savedfile:savedfile };
    $.ajax({

        type: "POST",
        url: "expenseslog.aspx/savetimesheet",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {
            //Check length of returned data, if it is less than 0 it means there is some status available
            if (data.d != "success") {
                $('#ctl00_ContentPlaceHolder1_progress2_UpdateProg1').hide();
                alert('There is some problem in saving information, please try again');

                return false;
            }
            else {
                $('#ctl00_ContentPlaceHolder1_progress2_UpdateProg1').hide();
                document.getElementById('ctl00_ContentPlaceHolder1_btnsubmit').click();

            }
        }
    });

}


var copyid = "";
//  $('#ctl00_ContentPlaceHolder1_txtfrom').mask('99/99/9999');
// $('#ctl00_ContentPlaceHolder1_txtto').mask('99/99/9999');
$('#txtdate0').mask('99/99/9999');

$(function () {
    $("#txtdate0").datepicker();
});


function settab(id, event) {
    var newid = "";
    if (event.keyCode == 13) {
        if (id.indexOf("ddlproject") > -1)
        {
            newid = id.replace("ddlproject", "ddltask");

        }
        else if (id.indexOf("ddltask") > -1)
        {
            newid = id.replace("ddltask", "txtdesc");
        }
        else if (id.indexOf("txtdate") > -1) {
            newid = id.replace("txtdate", "ddlproject");
        }
        else if (id.indexOf("txtunits") > -1) {
            newid = id.replace("txtunits", "txtcost");
        }
        else if (id.indexOf("txtcost") > -1) {
            newid = id.replace("txtcost", "txtmu");
        }
        else if (id.indexOf("txtmu") > -1) {
            newid = id.replace("txtmu", "chkbillable");
        }
        else if (id.indexOf("chkbillable") > -1) {
            newid = id.replace("chkbillable", "chkreimbursable");
        }
        else if (id.indexOf("chkreimbursable") > -1) {
            var newid1 = "";
            newid1 = id.replace("chkreimbursable", "");
            var sno = parseInt(document.getElementById("timesheet_hidrowno").value);

            if (sno == parseInt(newid1)) {
                addrow();
            }
            else {

                var newid1 = parseInt(newid1)+1;
                $('#txtdate' + newid1).focus();

            }

          
        }

        event.preventDefault();
        if (newid != "") {
            $('#' + newid).focus();
        }
    }

}
function setptab(id, event) {

    if (event.keyCode == 13) {
        var hoursid = 'ddltask' + id;

        $('#' + hoursid).focus();
        event.preventDefault();
    }

}
function addautorow(id, event) {


    var sno = parseInt(document.getElementById("timesheet_hidrowno").value);

    if (event.keyCode == 13 || event.keyCode == 9) {
        if (sno == parseInt(id)) {
            addrow();
        }
        else {

            var newid = parseInt(id);
            $('#txtunits' + newid).focus();

        }

        event.preventDefault();
        
    }

}
function setcopyoption(id, event) {

    var left = event.screenX;     // Get the horizontal coordinate
    var top = event.screenY;     // Get the vertical coordinate

    // var left = document.getElementById("divdel" + id).style.left;
    //  var top = document.getElementById("divdel" + id).style.top;

    copyid = id;
    document.getElementById("rightclickback").style.display = "block";
    document.getElementById("divcopy" + id).style.display = "block";


    // document.getElementById("rightclickcopy").style.top = top ;
    // document.getElementById("rightclickcopy").style.left = left ;
    event.preventDefault();
}
function closecopy() {

    document.getElementById("rightclickback").style.display = "none";
    document.getElementById("divcopy" + copyid).style.display = "none";
    copyid = "";
}
function copyrecord() {


    if (String(copyid) != "") {

        var sno = parseInt(document.getElementById("timesheet_hidrowno").value);
        addrow();

        sno = parseInt(document.getElementById("timesheet_hidrowno").value);
        document.getElementById('txtdate' + sno).value = document.getElementById('txtdate' + copyid).value;
        document.getElementById('ddlproject' + sno).value = document.getElementById('ddlproject' + copyid).value;
        document.getElementById('hidproject' + sno).value = document.getElementById('hidproject' + copyid).value;
        document.getElementById('ddltask' + sno).value = document.getElementById('ddltask' + copyid).value;
        document.getElementById('hidtask' + sno).value = document.getElementById('hidtask' + copyid).value;
        document.getElementById('txthours' + sno).value = document.getElementById('txthours' + copyid).value;
        document.getElementById('txtdesc' + sno).value = document.getElementById('txtdesc' + copyid).value;
        document.getElementById('hidmemo' + sno).innerHTML = document.getElementById('hidmemo' + copyid).innerHTML;

        closecopy();
    }

}