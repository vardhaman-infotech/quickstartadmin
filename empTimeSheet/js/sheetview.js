var json;
var jsontasks;
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
            bindtaskvalue(hiddenid, ui.item.value)
            return false;
        },
        change: function (event, ui) {
            $(this).val((ui.item ? ui.item.label1 : ""));
            $("#" + hiddenid + "").val((ui.item ? ui.item.value : ""));
            bindtaskvalue(hiddenid, ui.item.value);

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
        var taskarr = value.split("#");

        document.getElementById(rownum + "txtdesc").value = taskarr[2];
        if (taskarr[1] == "1" || taskarr[1] == "true")
            document.getElementById(rownum + "chkbillableedit").checked = true;
        else
            document.getElementById(rownum + "chkbillableedit").checked = false;
    }
    else {
        var rownum = id.replace('hidtask', '');
        var taskarr = value.split("#");

        document.getElementById("txtdesc" + rownum).value = taskarr[2];
        if (taskarr[1] == "1" || taskarr[1] == "true")
            document.getElementById("chkbillable" + rownum).checked = true;
        else
            document.getElementById("chkbillable" + rownum).checked = false;
    }

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




//Scripts for Row selection when aprrove.. goes here

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
    var celldelete = row.insertCell(0);
    var cellchk = row.insertCell(1);

    //            var cellSno = row.insertCell(1);
    var celldate = row.insertCell(2);
    var cellproject = row.insertCell(3);
    var celltask = row.insertCell(4);
    var cellhours = row.insertCell(5);
    var celldes = row.insertCell(6);
    var cellbillable = row.insertCell(7);

    var cellempty1 = row.insertCell(8);
    var cellempty2 = row.insertCell(9);


    celldelete.innerHTML = "<div id='divdel" + newsno + "' ><a style='cursor: pointer;color:bule;' id='delete' onclick='deleterow(this.id);' ><i class='fa fa-fw'><img src='images/delete.png' alt=''></i></a></div>";

    //cellSno.innerHTML = sno;
    celldate.innerHTML = " <input type='text' id='txtdate" + newsno + "' class='form-control date'  onclick='scwShow(scwID(this.id),this);'/>";
    cellproject.innerHTML = "<input type='text' id='ddlproject" + newsno + "' class='form-control'/> <input type='hidden' id='hidproject" + newsno + "' />";
    celltask.innerHTML = "<input type='text' id='ddltask" + newsno + "' class='form-control' onchange='bindtaskvalue(this.id,this.value);' /><input type='hidden' id='hidtask" + newsno + "' />";
    cellhours.innerHTML = "<input type='text' id='txthours" + newsno + "' class='form-control' onkeypress='blockNonNumbers(this, event, true, false);'   onblur='extractNumber(this,2,false);' onkeyup='extractNumber(this,2,false);' />";
    cellbillable.innerHTML = "<input type='checkbox' id='chkbillable" + newsno + "'/>";
    celldes.innerHTML = "<input type='text' id='txtdesc" + newsno + "' class='form-control' />";


    document.getElementById("timesheet_hidrowno").value = newsno;
    document.getElementById("timesheet_hidsno").value = sno;


    var inputprojectid = "ddlproject" + newsno;
    var hiddenprojectid = "hidproject" + newsno;
    bindprojectautocompleter(inputprojectid, hiddenprojectid);

  
    var inputid = "ddltask" + newsno;
    var hiddenid = "hidtask" + newsno;

    bindtaskautocompleter(inputid, hiddenid);

    var height = $('#divsheetbox')[0].scrollHeight;
    $('#divsheetbox').scrollTop(height);
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
    var newid = "", project = "", task = "", date = "", hours = "", des = "", hours1 = "", billable = "";
    var id = parseInt(document.getElementById("timesheet_hidrowno").value);
    var empid = document.getElementById("timesheet_hidempid").value;
    //---------
    var companyid = document.getElementById("hidcompanyid").value;
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

    //---------------------Save time entries
    var args = { taskdate: date, projectid: project, taskid: task, hours: hours, description: des, billable: billable, companyid: companyid, empid: empid };
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
                alert('There is some problem in saving information, please try again');
                return false;
            }
            else {

                document.getElementById('ctl00_ContentPlaceHolder1_btnsubmit').click();

            }
        }
    });

}