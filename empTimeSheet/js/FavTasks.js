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



    fillfavtask();

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
            bindprojectvalue(hiddenid, ui.item == null ? "" : ui.item.value1);

            return false;
        },
        change: function (event, ui) {


            $(this).val((ui.item ? ui.item.label1 : ""));
            $("#" + hiddenid + "").val((ui.item ? ui.item.value : ""));
            bindprojectvalue(hiddenid, ui.item == null ? "" : ui.item.value1);

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




            document.getElementById(rownum + "hidbillable").value = taskarr[1];
            document.getElementById(rownum + "hiememorequire").value = taskarr[2];

        }
        else {
            document.getElementById(rownum + "hidbillable").value = "";
            document.getElementById(rownum + "hiememorequire").value = "";
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

            document.getElementById("hidbillable" + rownum).value = taskarr[1];
            document.getElementById("hiememorequire" + rownum).value = taskarr[2];
        }
        else {
            document.getElementById("hidbillable" + rownum).value = "";
            document.getElementById("hiememorequire" + rownum).value = "";
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



function addrow() {
    var table = document.getElementById("tbldata");

    var id = parseInt(document.getElementById("timesheet_hidrowno").value);
    var sno = parseInt(document.getElementById("timesheet_hidsno").value);
    sno = sno + 1
    var newsno = id + 1;
    var row = table.insertRow(newsno);


    if (id > 0)
        document.getElementById("divdel" + id).innerHTML = "";

    var colnum = 0;
    var celldelete = row.insertCell(colnum);
    colnum++;
   
    //            var cellSno = row.insertCell(1);
    var celldate = row.insertCell(colnum); colnum++;
    var cellproject = row.insertCell(colnum); colnum++;
    var celltask = row.insertCell(colnum); colnum++;
    var cellhours = row.insertCell(colnum); colnum++;
    var celldes = row.insertCell(colnum); colnum++;
    var cellbillable = row.insertCell(colnum); colnum++;

    
    var cellmemo = row.insertCell(colnum); colnum++;
   


    celldelete.oncontextmenu = function (e) { setcopyoption(newsno, e); };



    celldelete.innerHTML = "<input type='hidden' id='favhidid_"+newsno+"' value='' /><div id='divdel" + newsno + "' ><a style='cursor: pointer;color:bule;' id='delete' onclick='deleterow(this.id);' ><i class='fa fa-fw'><img src='images/delete.png' alt=''></i></a></div>";

    //cellSno.innerHTML = sno;
    celldate.innerHTML = " <input type='text' id='txtdate" + newsno + "' onkeypress='setdtab(" + newsno + ",event);' class='form-control date'  onchange='checkdate(this.value,this.id);'/>";
    cellproject.innerHTML = "<input type='text' id='ddlproject" + newsno + "' class='form-control' onkeypress='setptab(" + newsno + ",event);'  /> <input type='hidden' id='hidproject" + newsno + "' />   <input type='hidden' id='hidbillable" + newsno + "'  /><input type='hidden' id='hiememorequire" + newsno + "'  />";
    celltask.innerHTML = "<input type='text' id='ddltask" + newsno + "' class='form-control' onkeypress='settab(" + newsno + ",event);' onchange='bindtaskvalue(this.id,this.value);' /><input type='hidden' id='hidtask" + newsno + "' />";
    cellhours.innerHTML = "<input type='text' id='txthours" + newsno + "' maxlength='5' class='form-control' onkeypress='TS_blockNonNumbers(this, event, true, false," + newsno + ");'   onblur='extractNumber(this,2,false);calhours();' onkeyup='extractNumber(this,2,false);' />";
    cellbillable.innerHTML = "<input type='checkbox' id='chkbillable" + newsno + "'/>";
    celldes.innerHTML = "<input type='text' id='txtdesc" + newsno + "' class='form-control' maxlength='150' onkeydown='addautorow(" + newsno + ",event);' onkeypress='addautorow(" + newsno + ",event);' onblur='removeSpecialCh(this.id,event)'   />";
    cellmemo.innerHTML = "<a id='lnkmemo" + newsno + "' onclick='opendiv(this.id,1);' title='Add Memo' >Memo</a>  <span id='hidmemo" + newsno + "' style='display:none;' />";
    document.getElementById("timesheet_hidrowno").value = newsno;
    document.getElementById("timesheet_hidsno").value = sno;

    var inputprojectid = "ddlproject" + newsno;
    var hiddenprojectid = "hidproject" + newsno;
    bindprojectautocompleter(inputprojectid, hiddenprojectid);

    var inputid = "ddltask" + newsno;
    var hiddenid = "hidtask" + newsno;

    bindtaskautocompleter(inputid, hiddenid);

  

    $('#txtdate' + newsno).mask('99/99/9999');
    $('#txtdate' + newsno).datepicker();
   
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


function blankdata()
{
    document.getElementById("ctl00_ContentPlaceHolder1_txttitle").value = "";
    document.getElementById("favhidid_0").value = "";
    document.getElementById("favhidid").value = "";
    document.getElementById("txtdate0").value = "";
    document.getElementById("ddlproject0").value = "";
    document.getElementById("hidproject0").value = "";
    document.getElementById("hidtask0").value = "";
    document.getElementById("txtdesc0").value = "";
    document.getElementById("ddltask0").value = "";
    document.getElementById("txthours0").value = "";
    document.getElementById("chkbillable0").checked = false;
    document.getElementById("hidmemo0").innerHTML = "";

    var id = parseInt(document.getElementById("timesheet_hidrowno").value);

    for (var i = 0; i < id; i++) {
        deleterow();

    }




}

function savedata() {

    var status = 1;
    var newid = "";
    var newid1 = "";

    if (document.getElementById("ctl00_ContentPlaceHolder1_txttitle").value == "") {
        status = 0;
        document.getElementById("ctl00_ContentPlaceHolder1_txttitle").className = "errform-control";
    }
    else {
        document.getElementById("ctl00_ContentPlaceHolder1_txttitle").className = "form-control";
    }

      

    if (status == 0) {
        return false;
    }
    else {

        saveinfo();
        return true;

    }

}

function saveinfo() {
    $('#divplswait').show();
    $('#btnsaveFav').hide();
    var newid = "", project = "", task = "", date = "", hours = "", des = "", hours1 = "", billable = "", memo = "",favnid="";
    var id = parseInt(document.getElementById("timesheet_hidrowno").value);
    var empid = document.getElementById("hidchatloginid").value;
   
    //---------
    var companyid = document.getElementById("hidcompanyid").value;
    for (var i = 0; i <= id; i++) {



        newid = "favhidid_" + i;

        favnid = favnid + "###" + document.getElementById(newid).value;

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


       

        newid = "hidmemo" + i;
        memo = memo + "###" + document.getElementById(newid).innerHTML;


    }

    //---------------------Save time entries
    var args = { nid: document.getElementById("favhidid").value, title: document.getElementById("ctl00_ContentPlaceHolder1_txttitle").value, favnid: favnid, taskdate: date, projectid: project, taskid: task, hours: hours, description: des, billable: billable,  empid: empid, memo: memo };
    $.ajax({

        type: "POST",
        url: "MyAccount.aspx/savetimesheet",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {
            //Check length of returned data, if it is less than 0 it means there is some status available
            if (data.d != "success") {
                $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                alert('There is some problem in saving information, please try again');
                $('#divplswait').hide();
                $('#divsubmimanager').show();
                return false;
            }
            else {

                $('#divplswait').hide();
                $('#btnsaveFav').show();
                fillfavtask();
                alert("Saved Successfully");
                closeFav();

            }
        }
    });

}



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
function editfav(id1) {
    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
    blankdata();
    var args = { id: id1};
    $.ajax({

        type: "POST",
        url: "MyAccount.aspx/getFavTaskDetail",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {
            //Check length of returned data, if it is less than 0 it means there is some status available
            if (data.d != "") {
                var table = document.getElementById("tbldata");

                $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                var jsonObj = $.parseJSON(data.d);

                $.each(jsonObj, function (i, item) {
                   

                  
                    if (i == 0) {
                        document.getElementById("favhidid").value = item.FavoriteID;
                        document.getElementById("ctl00_ContentPlaceHolder1_txttitle").value = item.title;
                        document.getElementById("txtdate0").value = item.date;
                        document.getElementById("ddlproject0").value = item.projectcode;
                        document.getElementById("ddltask0").value = item.taskname;
                        document.getElementById("txthours0").value = item.hours;
                        document.getElementById("txtdesc0").value = item.description;
                        document.getElementById("hidproject0").value = item.projectid;
                        document.getElementById("hidtask0").value = item.taskid;
                        document.getElementById("hidmemo0").value = item.memo;
                        if (item.isbillable == true) {
                            document.getElementById("chkbillable0").checked = true;
                        }
                        else {
                            document.getElementById("chkbillable0").checked = false;
                        }

                    }
                    else {
                        var id = parseInt(document.getElementById("timesheet_hidrowno").value);
                        var sno = parseInt(document.getElementById("timesheet_hidsno").value);
                        sno = sno + 1
                        var newsno = id + 1;
                        var row = table.insertRow(newsno);


                        if (id > 0)
                            document.getElementById("divdel" + id).innerHTML = "";

                        var colnum = 0;
                        var celldelete = row.insertCell(colnum);
                        colnum++;

                        //            var cellSno = row.insertCell(1);
                        var celldate = row.insertCell(colnum); colnum++;
                        var cellproject = row.insertCell(colnum); colnum++;
                        var celltask = row.insertCell(colnum); colnum++;
                        var cellhours = row.insertCell(colnum); colnum++;
                        var celldes = row.insertCell(colnum); colnum++;
                        var cellbillable = row.insertCell(colnum); colnum++;


                        var cellmemo = row.insertCell(colnum); colnum++;
                      






                        celldelete.innerHTML = "<input type='hidden' id='favhidid_" + newsno + "' value='" + item.nid + "' /><div id='divdel" + newsno + "' ><a style='cursor: pointer;color:bule;' id='delete' onclick='deleterow(this.id);' ><i class='fa fa-fw'><img src='images/delete.png' alt=''></i></a></div>";
                      
                        //cellSno.innerHTML = sno;
                        celldate.innerHTML = " <input type='text' id='txtdate" + newsno + "' onkeypress='setdtab(" + newsno + ",event);' class='form-control date'  onchange='checkdate(this.value,this.id);' value='" + item.date + "' />";
                        cellproject.innerHTML = "<input type='text' id='ddlproject" + newsno + "' class='form-control' onkeypress='setptab(" + newsno + ",event);' value='" + item.projectcode
                            + "' /> <input type='hidden' id='hidproject" + newsno + "' value='" + item.projectid + "'  />   <input type='hidden' id='hidbillable" + newsno + "' value='" + item.isbillable + "'  /><input type='hidden' id='hiememorequire" + newsno + "'  />";
                        celltask.innerHTML = "<input type='text' id='ddltask" + newsno + "' class='form-control' onkeypress='settab(" + newsno + ",event);' onchange='bindtaskvalue(this.id,this.value);' value='" + item.taskname + "' /><input type='hidden' id='hidtask" + newsno + "'  value='" + item.taskid + "'  />";
                        cellhours.innerHTML = "<input type='text' id='txthours" + newsno + "' maxlength='5' class='form-control' onkeypress='TS_blockNonNumbers(this, event, true, false," + newsno + ");'   onblur='extractNumber(this,2,false);calhours();' onkeyup='extractNumber(this,2,false);' value='" + item.hours + "' />";
                        if (item.isbillable == true) {
                            cellbillable.innerHTML = "<input type='checkbox' id='chkbillable" + newsno + "' checked='checked'/>";
                        }
                        else {
                            cellbillable.innerHTML = "<input type='checkbox' id='chkbillable" + newsno + "'/>";
                        }

                       
                        celldes.innerHTML = "<input type='text' id='txtdesc" + newsno + "' class='form-control' maxlength='150' onkeydown='addautorow(" + newsno + ",event);' onkeypress='addautorow(" + newsno + ",event);' onblur='removeSpecialCh(this.id,event)' value='" + item.description + "'   />";
                        cellmemo.innerHTML = "<a id='lnkmemo" + newsno + "' onclick='opendiv(this.id,1);' title='Add Memo' >Memo</a>  <span id='hidmemo" + newsno + "' style='display:none;'>" + item.memo + "</span>";
                        document.getElementById("timesheet_hidrowno").value = newsno;
                        document.getElementById("timesheet_hidsno").value = sno;

                        var inputprojectid = "ddlproject" + newsno;
                        var hiddenprojectid = "hidproject" + newsno;
                        bindprojectautocompleter(inputprojectid, hiddenprojectid);

                        var inputid = "ddltask" + newsno;
                        var hiddenid = "hidtask" + newsno;

                        bindtaskautocompleter(inputid, hiddenid);



                        $('#txtdate' + newsno).mask('99/99/9999');
                        $('#txtdate' + newsno).datepicker();


                    }
                   
                   


                });

                openfav();




            }
            else {

                $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
              

            }
        }
    });

}

function delfav(id) {

    if (confirm("Do you want to delete this record?"))
    {
        var args = { id: id };
        $.ajax({

            type: "POST",
            url: "MyAccount.aspx/DeleteFav_Task",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            cache: false,
            success: function (data) {
                //Check length of returned data, if it is less than 0 it means there is some status available
                if (data.d == "success") {
                    fillfavtask();
                }

            }
        });

    }
   

}
function fillfavtask() {
    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
    var args = { userid: document.getElementById("hidchatloginid").value };
    $.ajax({

        type: "POST",
        url: "MyAccount.aspx/getFavTask",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {
            //Check length of returned data, if it is less than 0 it means there is some status available
            if (data.d != "") {
                document.getElementById("tblFavMain").innerHTML = data.d;
                $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
            }
            else {

                $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                document.getElementById("tblFavMain").innerHTML = "";

            }
        }
    });

}



function openfav() {
    
    document.getElementById("otherdiv").style.display = "block";
    setposition("divsubmit");
    document.getElementById("divsubmit").style.display = "block";
}

function closeFav() {

    document.getElementById("otherdiv").style.display = "none";
   
    document.getElementById("divsubmit").style.display = "none";
}




