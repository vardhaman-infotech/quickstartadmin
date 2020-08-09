var json;
var jsontasks;


function setreadonlybox(txtid) {

    document.getElementById(txtid).readOnly = true;

}
$(document).ready(function () {

    //---------
    var companyid = document.getElementById("hidcompanyid").value;
    //---------------------Get projects from script methos and put values to an array for autocompleter
    var args = { prefixText: "", companyid: companyid };
    $.ajax({

        type: "POST",
        url: "Timesheet.aspx/getProjects",
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
        url: "Timesheet.aspx/getTasks",
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

function bindsearchprojectautocompleter() {

    $("#txtsearchproject").autocomplete({

        selectFirst: true,
        delay: 0,
        mustMatch: true,
        autoFocus: true,
        source: json,
        select: function (event, ui) {
            $("#ctl00_ContentPlaceHolder1_hidproject").val(ui.item.value);
            $("#txtsearchproject").val(ui.item.label1);

            return false;
        },
        change: function (event, ui) {

            $(this).val((ui.item ? ui.item.label1 : ""));
            $("#ctl00_ContentPlaceHolder1_hidproject").val((ui.item ? ui.item.value : ""));

        },
        focus: function (event, ui) { event.preventDefault(); }
    });
}

function bindsearchEmpautocompleter() {

    $("#txtsearchemp").autocomplete({

        selectFirst: true,
        delay: 0,
        mustMatch: true,
        autoFocus: true,
        source: json,
        select: function (event, ui) {
            $("#timesheet_hidempid").val(ui.item.value);
            $("#txtsearchemp").val(ui.item.label1);
            $("#ctl00_ContentPlaceHolder1_hidempname").val(ui.item.label1);

            return false;
        },
        change: function (event, ui) {

            $(this).val((ui.item ? ui.item.label1 : ""));
            $("#ctl00_ContentPlaceHolder1_hidempname").val((ui.item ? ui.item.label1 : ""));
            $("#timesheet_hidempid").val((ui.item ? ui.item.value : ""));

        },
        focus: function (event, ui) { event.preventDefault(); }
    });
}


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
            bindprojectvalue(hiddenid, ui.item == null ? "" : ui.item.value1);

            return false;
        },
        change: function (event, ui) {


            $(this).val((ui.item ? ui.item.label1 : ""));
            $("#" + hiddenid + "").val((ui.item ? ui.item.value : ""));
            bindprojectvalue(hiddenid, ui.item == null ? "" : ui.item.value1);

        },
        focus: function (event, ui) { event.preventDefault(); },
        open: function () {
            $('ul.ui-autocomplete').prepend('<li class="list-header" ><div class="ac_project1">Project ID</div><div class="ac_project2">Project</div><div class="ac_project3">Client ID</div></li>');
        }
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
        focus: function (event, ui) { event.preventDefault(); },
        open: function () {
            $('ul.ui-autocomplete').prepend('<li class="list-header" ><div class="ac_task1">Task ID</div><div class="ac_task2">Task</div></li>');
        }
    });
}

function hidedetails() {
    $("#divright").hide();
}
function showdetails() {
    $("#divright").show();
}



function bindprojectvalue(id, value) {

    var strfound = id.indexOf("dgnews");
    if (strfound > -1) {

        if (value != "") {
            var rownum = id.replace('hidproject', '');
            var taskarr = value.split("#");

            if (taskarr[1] == "Yes")
                document.getElementById(rownum + "chkbillableedit").checked = true;
            else if (taskarr[1] == "No")
                document.getElementById(rownum + "chkbillableedit").checked = false;

            if (taskarr[3] == "Yes")
                document.getElementById(rownum + "txtdesc").readOnly = true;
            else
                document.getElementById(rownum + "txtdesc").readOnly = false;


            document.getElementById(rownum + "hidbillable").value = taskarr[1];
            document.getElementById(rownum + "hiememorequire").value = taskarr[2];
            document.getElementById(rownum + "hidistaskreadonly").value = taskarr[3];



        }
        else {
            document.getElementById(rownum + "hidbillable").value = "";
            document.getElementById(rownum + "hiememorequire").value = "";
            document.getElementById(rownum + "hidistaskreadonly").value = "";
            document.getElementById(rownum + "txtdesc").readOnly = false;
        }


    }
    else {

        var rownum = id.replace('hidproject', '');
        rownum = rownum.replace('ddlproject', '');

        if (value != "") {
            var taskarr = value.split("#");


            if (taskarr[1] == "Yes")
                document.getElementById("chkbillable" + rownum).checked = true;
            else if (taskarr[1] == "No")
                document.getElementById("chkbillable" + rownum).checked = false;

            if (taskarr[3] == "Yes")
                document.getElementById("txtdesc" + rownum).readOnly = true;
            else
                document.getElementById("txtdesc" + rownum).readOnly = false;


            document.getElementById("hidbillable" + rownum).value = taskarr[1];
            document.getElementById("hiememorequire" + rownum).value = taskarr[2];
            document.getElementById("hidistaskreadonly" + rownum).value = taskarr[3];

        }
        else {
            document.getElementById("hidbillable" + rownum).value = "";
            document.getElementById("hiememorequire" + rownum).value = "";
            document.getElementById("hidistaskreadonly" + rownum).value = "";
        }

    }

}
function bindgridprojectvalue(id, value) {
    var rownum = id.replace('dropproject', '');

    if (value != "") {
        var taskarr = value.split("#");


        if (taskarr[1] == "1" || taskarr[1] == "true")
            document.getElementById(rownum + "chkbillableedit").checked = true;
        else
            document.getElementById(rownum + "chkbillableedit").checked = false;

        if (taskarr[3] == "Yes") {
            document.getElementById(rownum + "txtdesc").readonly = true;
        }
        else {
            document.getElementById(rownum + "txtdesc").readonly = false;

        }
    }



}


function bindtaskvalue(id, value) {

    var strfound = id.indexOf("dgnews");
    if (strfound > -1) {

        if (value != "") {
            var rownum = id.replace('hidtask', '');
            var taskarr = value.split("#");

            document.getElementById(rownum + "txtdesc").value = taskarr[2];
            if (document.getElementById(rownum + "hidbillable").value == "") {
                if (taskarr[1] == "1" || taskarr[1] == "true")
                    document.getElementById(rownum + "chkbillableedit").checked = true;
                else
                    document.getElementById(rownum + "chkbillableedit").checked = false;
            }

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
            if (document.getElementById("hidbillable" + rownum).value == "") {
                if (taskarr[1] == "1" || taskarr[1] == "true")
                    document.getElementById("chkbillable" + rownum).checked = true;
                else
                    document.getElementById("chkbillable" + rownum).checked = false;
            }

        }
        else {
            document.getElementById("txtdesc" + rownum).value = "";
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
    //var row = table.insertRow(newsno);
    var row = table.insertRow($(table).find("tbody").find("tr").length);

    // if (id > 0)
    //document.getElementById("divdel" + id).innerHTML = "";

    var colnum = 0;
    var celldelete = row.insertCell(colnum);
    colnum++;
    var cellchk = row.insertCell(colnum);
    colnum++;
    //            var cellSno = row.insertCell(1);
    var celldate = row.insertCell(colnum); colnum++;
    var cellproject = row.insertCell(colnum); colnum++;
    var celltask = row.insertCell(colnum); colnum++;
    var cellhours = row.insertCell(colnum); colnum++;
    var celldes = row.insertCell(colnum); colnum++;
    var cellbillable = row.insertCell(colnum); colnum++;
    celldes.innerHTML = "<input type='text' id='txtdesc" + newsno + "' class='form-control txtdsc' maxlength='250'  onblur='removeSpecialCh(this.id,event)'   />";

    if (document.getElementById("timesheet_hidisapprove").value == "1") {
        var cellbillrate = row.insertCell(colnum); colnum++;
        var cellpayrate = row.insertCell(colnum); colnum++;

        var billrate = document.getElementById("timesheet_hidbillrate").value;
        var payrate = document.getElementById("timesheet_hidpayrate").value;


        cellbillrate.innerHTML = "<input type='text' id='txtbillrate" + newsno + "' maxlength='5' class='form-control txtbilrte' onkeypress='TS_blockNonNumbers(this, event, true, false," + newsno + ");'   onblur='extractNumber(this,2,false);' onkeyup='extractNumber(this,2,false);' value='" + billrate + "' />";

        cellpayrate.innerHTML = "<input type='text' id='txtpayrate" + newsno + "' maxlength='5' class='form-control txtprte' onkeydown='addautorow(" + newsno + ",event);' onkeypress='addautorow(" + newsno + ",event);' onkeypress='TS_blockNonNumbers(this, event, true, false," + newsno + ");'   onblur='extractNumber(this,2,false);' onkeyup='extractNumber(this,2,false);' value='" + payrate + "' />";


    } else {
        celldes.innerHTML = "<input type='text' id='txtdesc" + newsno + "' class='form-control txtdsc' maxlength='250'  onkeydown='addautorow(" + newsno + ",event);' onkeypress='addautorow(" + newsno + ",event);'  onblur='removeSpecialCh(this.id,event)'   />";

    }
    var cellmemo = row.insertCell(colnum); colnum++;
    var cellempty1 = row.insertCell(colnum); colnum++;
    var cellempty2 = row.insertCell(colnum); colnum++;


    celldelete.oncontextmenu = function (e) { setcopyoption(newsno, e); };



    celldelete.innerHTML = " <div class='rightclickcopy' id='divcopy" + newsno + "' > <a onclick='copyrecord();'>Copy</a></div><div id='divdel" + newsno + "' ><a style='cursor: pointer;color:bule;' id='delete' onclick='deleterow(this,this.id);' ><i class='fa fa-fw'><img src='images/delete.png' alt=''></i></a></div>";

    //cellSno.innerHTML = sno;
    celldate.innerHTML = " <input type='text' id='txtdate" + newsno + "' onkeypress='setdtab(" + newsno + ",event);' class='form-control date txtdate'  onchange='checkdate(this.value,this.id);'/>";
    cellproject.innerHTML = "<input type='text' id='ddlproject" + newsno + "' class='form-control project ddlprj' onkeypress='setptab(" + newsno + ",event);'  /> <input type='hidden' id='hidproject" + newsno + "' class='hdnprj' />   <input type='hidden' id='hidbillable" + newsno + "'  /><input type='hidden' id='hiememorequire" + newsno + "' class='memoreq'  /><input type='hidden' id='hidistaskreadonly" + newsno + "'  />";
    celltask.innerHTML = "<input type='text' id='ddltask" + newsno + "' class='form-control ddltsk' onkeypress='settab(" + newsno + ",event);' onchange='bindtaskvalue(this.id,this.value);' /><input type='hidden' class='hdntask' id='hidtask" + newsno + "' />";
    cellhours.innerHTML = "<input type='text' id='txthours" + newsno + "' maxlength='5' class='form-control txthr' onkeypress='TS_blockNonNumbers(this, event, true, false," + newsno + ");'   onblur='extractNumber(this,2,false);calhours();' onkeyup='extractNumber(this,2,false);' />";
    cellbillable.innerHTML = "<input class='chklbl' type='checkbox' id='chkbillable" + newsno + "'/>";
     cellmemo.innerHTML = "<a id='lnkmemo" + newsno + "' onclick='opendiv(this.id,1);' title='Add Memo' >Memo</a>  <span class='hdmemo' class='memo' id='hidmemo" + newsno + "' style='display:none;' />";
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

    if ($('#txtdate' + (newsno-1)).length) {
        $('#txtdate' + newsno).val($('#txtdate' + (newsno - 1)).val());
    }
    $('#txtdate' + (newsno)).val($("#ctl00_ContentPlaceHolder1_hdnflddate0").val())

    $('#divsheetbox').scrollTop(height);
}


function calhours() {
    var id = parseInt(document.getElementById("timesheet_hidrowno").value);
    var totalhrs = 0.0;
    for (var i = 0; i <= id; i++) {
        newid = "txthours" + i;
        //  alert(newid);
        if (document.getElementById(newid) && document.getElementById(newid).value != "" && !isNaN(document.getElementById(newid).value)) {
            totalhrs += parseFloat(document.getElementById(newid).value);
        }

    }
    totalhrs = totalhrs + parseFloat(document.getElementById("timesheet_hidtotalhrs").value);
    if (document.getElementById("tdtotalhrs")) {
        document.getElementById("tdtotalhrs").innerHTML = totalhrs.toFixed(2);
    }

}
function deleterow(btn, btnid) {
    $(btn).parent().parent().parent().remove();

}

//Delete rows
function deleterowold() {
    alert(2)
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
    if (opensubmit()) {
        saveinfo();
    }
}
function opensubmit() {
    var status = 1;
    var newid = "";
    var newid1 = "";
    var id = parseInt(document.getElementById("timesheet_hidrowno").value);

    $("#tbldata > tbody > tr").each(function (index, item) {
        

        if ($(item).find(".txtdate").val() == "") {
            status = 0;
            $(item).find(".txtdate").addClass("errform-control");
        }
        else {
            if (isDate1($(item).find(".txtdate").val())) {
                $(item).find(".txtdate").removeClass("errform-control");
            }
            else {
                status = 0;
                $(item).find(".txtdate").addClass("errform-control");
            }
        }

    
        if ($(item).find(".hdnprj").val() == "") {
            status = 0;
            $(item).find(".ddlprj").addClass("errform-control");
        }
        else {
            $(item).find(".ddlprj").removeClass("errform-control");
        }

        if ($(item).find(".hdntask").val() == "") {
            status = 0;
            $(item).find(".ddltsk").addClass("errform-control");
        }
        else {
            $(item).find(".ddltsk").removeClass("errform-control");
        }

        if ($(item).find(".txthr").val() == "" || $(item).find(".txthr").val() == "0") {
            status = 0;
            $(item).find(".txthr").addClass("errform-control");
        }
        else {
            if (isNaN($(item).find(".txthr").val())) {
                status = 0;
                $(item).find(".txthr").addClass("errform-control");
            }
            else {
                $(item).find(".txthr").removeClass("errform-control");
            }
        }


        

        if ($(item).find(".memoreq").val() == "Yes") {


            newid = "hidmemo" + i;
            newid1 = "lnkmemo" + i;

            if ($(item).find(".hdmemo").html().trim() == "") {

                status = 0; 
                $(item).find(".lkmemo").css("border","1px solid red");
            }
            else {
                $(item).find(".lkmemo").css("border", "0px solid red");
            }
        }


    });

    for (var i = 0; i <= -1; i++) {
   // for (var i = 0; i <= id; i++) {

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

        newid = "txthours" + i;
        //  alert(newid);
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
        newid = "hiememorequire" + i;

        if (document.getElementById(newid).value == "Yes") {


            newid = "hidmemo" + i;
            newid1 = "lnkmemo" + i;

            if (document.getElementById(newid).innerText.trim() == "") {

                status = 0;
                document.getElementById(newid1).style.border = "1px solid red";
            }
            else {
                document.getElementById(newid1).style.border = "none";
            }
        }

    }

    if (status == 0) {
        return false;
    }
    else {

        document.getElementById("divsubmit").style.display = "block";
        document.getElementById("otherdiv").style.display = "block";
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
function setdefaultcol() {
    if (document.getElementById("timesheet_hidisapprove").value == "1" && document.getElementById("txtbillrate0")) {
        document.getElementById("txtbillrate0").value = document.getElementById("timesheet_hidbillrate").value;
        document.getElementById("txtpayrate0").value = document.getElementById("timesheet_hidpayrate").value;

    }
    else {

        $("#txtdesc0").attr("onkeypress", "addautorow(0,event)");
        $("#txtdesc0").attr("onkeydown", "addautorow(0,event)");
        if (document.getElementById("td_billrate")) { document.getElementById("td_billrate").style.display = "none"; }
        if (document.getElementById("td_payrate")) { document.getElementById("td_payrate").style.display = "none"; }

    }

}

function saveinfo() {
    $('#divplswait').show();
    $('#divsubmimanager').hide();
    var newid = "", project = "", task = "", date = "", hours = "", des = "", hours1 = "", billable = "", memo = "", billrate = "", payrate = "", submittype = "", submitto = "";
    var id = parseInt(document.getElementById("timesheet_hidrowno").value);
    var empid = document.getElementById("timesheet_hidempid").value;
    submittype = $('#ctl00_ContentPlaceHolder1_rbtnsubmitto input[type=radio]:checked').val();
    submitto = document.getElementById("ctl00_ContentPlaceHolder1_dropspecific").value;
    //---------
    var companyid = document.getElementById("hidcompanyid").value;
    
    $("#tbldata > tbody > tr").each(function (index, item) {


       

        project = project + "###" + $(item).find(".hdnprj").val();
        date = date + "###" + $(item).find(".txtdate").val();


        
        var taskvalue = $(item).find(".hdntask").val()
        var taskarr = taskvalue.split("#");
        //  alert(newid);
        task = task + "###" + taskarr[0];
        hours = hours + "###" + $(item).find(".txthr").val();
        des = des + "###" + $(item).find(".txtdsc").val();

       
        if ($(item).find(".chkbilbl").prop("checked") == true) {
            billable = billable + "###1";
        }
        else {
            billable = billable + "###0";
        }
        


        if (document.getElementById("timesheet_hidisapprove").value == "1") {
          
            if ($(item).find(".txtbilrte").val() == "" || isNaN($(item).find(".txtbilrte").val())) {

                billrate = billrate + "###" + document.getElementById("timesheet_hidbillrate").value;
            }
            else {
                billrate = billrate + "###" + $(item).find(".txtbilrte").val();
            }

           
            if ($(item).find(".txtprte").val() == "" || isNaN($(item).find(".txtprte").val())) {
                payrate = payrate + "###" + document.getElementById("timesheet_hidpayrate").value;
            }
            else {
                payrate = payrate + "###" + $(item).find(".txtprte").val();
            }

        }
        else {
            billrate = billrate + "###" + document.getElementById("timesheet_hidbillrate").value;
            payrate = payrate + "###" + document.getElementById("timesheet_hidpayrate").value;
        }

        
        memo = memo + "###" + $(item).find(".hdmemo").html().trim();


 


    });




    for (var i = 0; i <= -1; i++) {

        newid = "hidproject" + i;

        project = project + "###" + document.getElementById(newid).value;

        newid = "txtdate" + i;

        date = date + "###" + document.getElementById(newid).value;

        newid = "hidtask" + i;
        var taskvalue = document.getElementById(newid).value;
        var taskarr = taskvalue.split("#");
        //  alert(newid);
        task = task + "###" + taskarr[0];

        newid = "txthours" + i;

        hours = hours + "###" + document.getElementById(newid).value;

        newid = "txtdesc" + i;

        des = des + "###" + document.getElementById(newid).value;

        newid = "chkbillable" + i;
        if (document.getElementById(newid).checked == true) {
            billable = billable + "###1";
        }
        else {
            billable = billable + "###0";
        }


        if (document.getElementById("timesheet_hidisapprove").value == "1") {
            newid = "txtbillrate" + i;
            if (document.getElementById(newid).value == "" || isNaN(document.getElementById(newid).value)) {

                billrate = billrate + "###" + document.getElementById("timesheet_hidbillrate").value;
            }
            else {
                billrate = billrate + "###" + document.getElementById(newid).value;
            }

            newid = "txtpayrate" + i;
            if (document.getElementById(newid).value == "" || isNaN(document.getElementById(newid).value)) {
                payrate = payrate + "###" + document.getElementById("timesheet_hidpayrate").value;
            }
            else {
                payrate = payrate + "###" + document.getElementById(newid).value;
            }

        }
        else {
            billrate = billrate + "###" + document.getElementById("timesheet_hidbillrate").value;
            payrate = payrate + "###" + document.getElementById("timesheet_hidpayrate").value;
        }

        newid = "hidmemo" + i;
        memo = memo + "###" + document.getElementById(newid).innerHTML;


    } 
    //---------------------Save time entries
    var args = { taskdate: date, projectid: project, taskid: task, hours: hours, description: des, billable: billable, companyid: companyid, empid: empid, memo: memo, billrate: billrate, payrate: payrate, submittype: submittype, submitto: submitto };
    $.ajax({

        type: "POST",
        url: "Timesheet.aspx/savetimesheet",
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
                $('#divplswait').hide();
                $('#divsubmimanager').show();
                return false;
            }
            else {

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

    if (event.keyCode == 13) {
        var hoursid = 'txthours' + id;

        $('#' + hoursid).focus();
        event.preventDefault();
    }

}
function setdtab(id, event) {

    if (event.keyCode == 13) {
        var hoursid = 'ddlproject' + id;

        $('#' + hoursid).focus();
        event.preventDefault();
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

            var newid = parseInt(id) + 1;
            $('#txtdate' + newid).focus();

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

        document.getElementById('hiememorequire' + sno).value = document.getElementById('hiememorequire' + copyid).value;
        document.getElementById('hidistaskreadonly' + sno).value = document.getElementById('hidistaskreadonly' + copyid).value;


        closecopy();
    }

}



function fillfavtask() {
    $('#ctl00_ContentPlaceHolder1_progress2_UpdateProg1').show();
    var args = { userid: document.getElementById("hidchatloginid").value };
    $.ajax({

        type: "POST",
        url: "Timesheet.aspx/getFavTask",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {
            //Check length of returned data, if it is less than 0 it means there is some status available
            if (data.d != "") {
                document.getElementById("tblFavMain").innerHTML = data.d;

            }
            else {


                document.getElementById("tblFavMain").innerHTML = "";

            }
            document.getElementById("timesheet_hidIsFavOpened").value = "1";
            $('#ctl00_ContentPlaceHolder1_progress2_UpdateProg1').hide();
        }
    });

}

function openfav() {
          if (document.getElementById("timesheet_hidIsFavOpened").value != "1")
        fillfavtask();
    document.getElementById("otherdiv").style.display = "block";
    setposition("divFavTask");
    document.getElementById("divFavTask").style.display = "block";
}

function addfav(id1) {
    $('#ctl00_ContentPlaceHolder1_progress2_UpdateProg1').show();

    var args = { id: id1 };
    $.ajax({

        type: "POST",
        url: "Timesheet.aspx/getFavTaskDetail",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {
            //Check length of returned data, if it is less than 0 it means there is some status available
            if (data.d != "") {
                var table = document.getElementById("tbldata");


                var jsonObj = $.parseJSON(data.d);

                $.each(jsonObj, function (i, item) {

                    

                    var table = document.getElementById("tbldata");

                    var id = parseInt(document.getElementById("timesheet_hidrowno").value);
                    if (i == 0 &&
                        document.getElementById("tbldata").contains(document.getElementById("txtdate" + id))

                         && (document.getElementById("txtdate" + id).value == "" && document.getElementById("ddlproject" + id).value == "" && document.getElementById("ddltask" + id).value == "" && document.getElementById("txthours" + id).value == "")) {
                        //document.getElementById("txtdate" + id).value = ("0" + (new Date().getMonth() + 1)).slice(-2) + "/" +("0"+ new Date().getDate()).slice(-2) + "/" + new Date().getYear();//  item.date;


                        document.getElementById("txtdate" + id).value = new Date().format("MM/dd/yyyy")
                        document.getElementById("ddlproject" + id).value = item.projectcode;
                        document.getElementById("ddltask" + id).value = item.taskname;
                        document.getElementById("txthours" + id).value = item.hours;

                        document.getElementById("hidproject" + id).value = item.projectid;
                        document.getElementById("hidtask" + id).value = item.taskiddes;
                        document.getElementById("hidbillable" + id).value = item.tbillable;
                        document.getElementById("hiememorequire" + id).value = item.tmemorequired;
                        document.getElementById("hidistaskreadonly" + id).value = item.TDesReadonly;

                        document.getElementById("txtdesc" + id).value = item.description;
                        if (item.TDesReadonly == "Yes")
                            document.getElementById("txtdesc" + id).readOnly = true;
                        else
                            document.getElementById("txtdesc" + id).readOnly = false;

                        document.getElementById("hidmemo" + id).innerHTML = item.memo;

                        if (item.isbillable == true) {
                            document.getElementById("chkbillable" + id).checked = true;
                        }
                        else {
                            document.getElementById("chkbillable" + id).checked = false;
                        }




                        if (document.getElementById("timesheet_hidisapprove").value == "1") {

                            var billrate = document.getElementById("timesheet_hidbillrate").value;
                            var payrate = document.getElementById("timesheet_hidpayrate").value;

                            document.getElementById("txtbillrate" + id).value = billrate;
                            document.getElementById("txtpayrate" + id).value = payrate;


                        }
                    }
                    else {
                        var sno = parseInt(document.getElementById("timesheet_hidsno").value);
                        sno = sno + 1
                        var newsno = id + 1;
                       // var row = table.insertRow(newsno);
                        var row = table.insertRow($(table).find("tbody").find("tr").length);

                        //if (id > 0)
                           // document.getElementById("divdel" + id).innerHTML = "";

                        var colnum = 0;
                        var celldelete = row.insertCell(colnum);
                        colnum++;
                        var cellchk = row.insertCell(colnum);
                        colnum++;
                        //            var cellSno = row.insertCell(1);
                        var celldate = row.insertCell(colnum); colnum++;
                        var cellproject = row.insertCell(colnum); colnum++;
                        var celltask = row.insertCell(colnum); colnum++;
                        var cellhours = row.insertCell(colnum); colnum++;
                        var celldes = row.insertCell(colnum); colnum++;
                        var cellbillable = row.insertCell(colnum); colnum++;

                        if (document.getElementById("timesheet_hidisapprove").value == "1") {
                            var cellbillrate = row.insertCell(colnum); colnum++;
                            var cellpayrate = row.insertCell(colnum); colnum++;

                            var billrate = document.getElementById("timesheet_hidbillrate").value;
                            var payrate = document.getElementById("timesheet_hidpayrate").value;


                            cellbillrate.innerHTML = "<input type='text' id='txtbillrate" + newsno + "' maxlength='5' class='form-control' onkeypress='TS_blockNonNumbers(this, event, true, false," + newsno + ");'   onblur='extractNumber(this,2,false);' onkeyup='extractNumber(this,2,false);' value='" + billrate + "' />";

                            cellpayrate.innerHTML = "<input type='text' id='txtpayrate" + newsno + "' maxlength='5' class='form-control' onkeypress='TS_blockNonNumbers(this, event, true, false," + newsno + ");'   onblur='extractNumber(this,2,false);' onkeyup='extractNumber(this,2,false);' value='" + payrate + "' />";


                        }
                        var cellmemo = row.insertCell(colnum); colnum++;
                        var cellempty1 = row.insertCell(colnum); colnum++;
                        var cellempty2 = row.insertCell(colnum); colnum++;


                        celldelete.oncontextmenu = function (e) { setcopyoption(newsno, e); };



                        celldelete.innerHTML = " <div class='rightclickcopy' id='divcopy" + newsno + "' > <a onclick='copyrecord();'>Copy</a>                                          </div><div id='divdel" + newsno + "' ><a style='cursor: pointer;color:bule;' id='delete' onclick='deleterow(this,this.id);' ><i class='fa fa-fw'><img src='images/delete.png' alt=''></i></a></div>";

                        //cellSno.innerHTML = sno;

                        celldate.innerHTML = " <input type='text' id='txtdate" + newsno + "' onkeypress='setdtab(" + newsno + ",event);' class='form-control txtdate date'  onchange='checkdate(this.value,this.id);' value='" + item.date + "' />";
                        cellproject.innerHTML = "<input type='text' id='ddlproject" + newsno + "' class='form-control' onkeypress='setptab(" + newsno + ",event);' value='" + item.projectcode + "' /> <input type='hidden' id='hidproject" + newsno + "' value='" + item.projectid + "' />   <input type='hidden' id='hidbillable" + newsno + "' value='" + item.tbillable + "'   /><input type='hidden' id='hiememorequire" + newsno + "'  value='" + item.tmemorequired + "' /><input type='hidden' id='hidistaskreadonly" + newsno + "'  value='" + item.TDesReadonly + "' />";
                        celltask.innerHTML = "<input type='text' id='ddltask" + newsno + "' class='form-control' onkeypress='settab(" + newsno + ",event);' onchange='bindtaskvalue(this.id,this.value);' value='" + item.taskname + "' /><input type='hidden' id='hidtask" + newsno + "' value='" + item.taskiddes + "' />";
                        cellhours.innerHTML = "<input type='text' id='txthours" + newsno + "' maxlength='5' class='form-control' onkeypress='TS_blockNonNumbers(this, event, true, false," + newsno + ");'   onblur='extractNumber(this,2,false);calhours();' onkeyup='extractNumber(this,2,false);' value='" + item.hours + "' />";
                        if (item.isbillable == true) {
                            cellbillable.innerHTML = "<input type='checkbox' id='chkbillable" + newsno + "' checked='checked'/>";
                        }
                        else {
                            cellbillable.innerHTML = "<input type='checkbox' id='chkbillable" + newsno + "'/>";
                        }
                        if (item.TDesReadonly == "Yes")
                            celldes.innerHTML = "<input type='text' id='txtdesc" + newsno + "' class='form-control' maxlength='150' onkeydown='addautorow(" + newsno + ",event);' onkeypress='addautorow(" + newsno + ",event);' onblur='removeSpecialCh(this.id,event)' value='" + item.description + "' readonly='readonly' />";
                        else
                            celldes.innerHTML = "<input type='text' id='txtdesc" + newsno + "' class='form-control' maxlength='150' onkeydown='addautorow(" + newsno + ",event);' onkeypress='addautorow(" + newsno + ",event);' onblur='removeSpecialCh(this.id,event)' value='" + item.description + "'  />";

                        cellmemo.innerHTML = "<a id='lnkmemo" + newsno + "' onclick='opendiv(this.id,1);' title='Add Memo' >Memo</a>  <span id='hidmemo" + newsno + "' style='display:none;' >" + item.memo + "</span>";
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
                        ///$('#txtdate' + newsno).val(("0" + (new Date().getMonth() + 1)).slice(-2) + "/" + ("0"+ new Date().getDate()).slice(-2) + "/" + new Date().getYear());
                        console.log($('#txtdate' + newsno));
                        $('#divsheetbox').scrollTop(height);

                    }





                });


                calhours();
                $('#ctl00_ContentPlaceHolder1_progress2_UpdateProg1').hide();
                closediv();


            }
            else {

                $('#ctl00_ContentPlaceHolder1_progress2_UpdateProg1').hide();


            }
        }
    });



}