

function saveworkstatus(id) {
    var charindex = id.lastIndexOf("_");
    if (charindex != -1) {
        id = id.substring(0, charindex + 1);

        var status = document.getElementById(id + "ddlstatus").value;
        var remark = document.getElementById(id + "txtremark").value;
        var hour = document.getElementById(id + "txthours").value;
        var nid = document.getElementById(id + "hidnid").value;
        var args = { nid: nid, status: status, remark: remark, hours: hour };

        $.ajax({

            type: "POST",
            url: "AssignedTasks.aspx/savestatus",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            cache: false,
            success: function (msg) {

                msg1 = "success";


            },
            error: function (x, e) {
                alert("The call to the server side failed. " + x.responseText);

            }


        });
    }

}
function savereward(id) {
    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
    var charindex = id.lastIndexOf("_");
    if (charindex != -1) {
        id = id.substring(0, charindex + 1);

        var grade = document.getElementById(id + "ddlgrade").value;
        var comments = "";
        if (document.getElementById(id + "txtcomments").value) {
            comments = document.getElementById(id + "txtcomments").value;
        }
        var nid = document.getElementById(id + "hidnid").value;
        var remark = "";

        var args = { nid: nid, grade: grade, comments: comments, remark: remark };

        $.ajax({

            type: "POST",
            url: "AssignedTasks.aspx/savegrade",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            cache: false,
            success: function (msg) {

                msg1 = "success";
                alert("Saved successfully");
                $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
            },
            error: function (x, e) {
                alert("The call to the server side failed. " + x.responseText);
                $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();

            }


        });
    }

}


function saveRemark(id) {

    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
    var charindex = id.lastIndexOf("_");
    if (charindex != -1) {
        id = id.substring(0, charindex + 1);

        //   var grade = document.getElementById(id + "ddlgrade").value;
        //   var comments = document.getElementById(id + "txtcomments").value;
        var nid = document.getElementById(id + "hidnid").value;
        var remark = document.getElementById(id + "txtremark").value;
        var args = { nid: nid, remark: remark };

        $.ajax({

            type: "POST",
            url: "AssignedTasks.aspx/save_Remark",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            cache: false,
            success: function (msg) {

                msg1 = "success";
                alert("Saved successfully");
                $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
            },
            error: function (x, e) {
                alert("The call to the server side failed. " + x.responseText);
                $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();

            }


        });
    }

}


function closediv() {

    document.getElementById("assignedtask_divaddnew").style.display = "none";
    document.getElementById("assignedtask_divstatus").style.display = "none";
    document.getElementById("otherdiv").style.display = "none";

}

function opendiv() {
    setposition("assignedtask_divaddnew");
    document.getElementById("assignedtask_divaddnew").style.display = "block";
    document.getElementById("otherdiv").style.display = "block";
}

//Open Set Status div
function openstatusdiv() {
    setposition("assignedtask_divstatus");
    document.getElementById("assignedtask_divstatus").style.display = "block";
    document.getElementById("otherdiv").style.display = "block";
}



function bindPageEvent() {
    $(function () {

        //---------get company id from MASTER page hidden field
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
                    bindprojectautocompleter("ddlproject1", "hidproject1");

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
                    bindtaskautocompleter("ddltask1", "hidtask1");

                }
            }
        });
     

    });
}


//---------------------------------BIND STATUS table
function bindstatus(id, empid) {
    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
    //id, empid: Two paramteres "id" represnts nid of assigne task and "empid" indicates "employee id" for that particular task
    document.getElementById("ctl00_ContentPlaceHolder1_hidid").value = id;
    //Get values of Add and View roles value from Hidden fields:

    //Here addrole value "1" indicates that user have right to Assign Role
    var addrole = document.getElementById("viewstateadd").value;
    //userid contains the current user's nid
    var userid = document.getElementById("hidloginid").value;

    //Put the empid in hiddenfield
    document.getElementById("ctl00_ContentPlaceHolder1_hidcurrentemp").value = empid;
    document.getElementById("ctl00_ContentPlaceHolder1_divnewstatus").style.display = "block";
    //Check whther user have "New Assign Task" role or not
    if (addrole == "1") {
        //If user have "New Assign Task":

        //Check whther clicked task is logged user's  task or not
        if (empid != userid) {
            //If it is not logged user task, then:
            //Change Pop up title
            document.getElementById("ctl00_ContentPlaceHolder1_spanstatushead").innerHTML = "View Task Status";
            //hide Add New status div
            document.getElementById("ctl00_ContentPlaceHolder1_divnewstatus").style.display = "none";
        }
        else {
            document.getElementById("ctl00_ContentPlaceHolder1_spanstatushead").innerHTML = "Task Status"


        }
    }
    //By default show "No staus" div and hide status details table
    document.getElementById("ctl00_ContentPlaceHolder1_divnodataforpreviousstatus").style.display = "block";
    $("#tblStatus").hide();
    $("#tblStatus").empty();
    $("#tblStatus").append("<tr class='gridheader'><th width='15%'>Date</th><th width='15%'>Status</th><th width='15%'>Time Taken</th><th>Emp Remark</th><th width='8%'></th></tr>");
    var laststatus = "";

    var args = { nid: id };

    $.ajax({

        type: "POST",
        url: "AssignedTasks.aspx/getstatusdata",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {
            //Check length of returned data, if it is less than 0 it means there is some status available
            if (data.d.length > 0) {
                // Hide no status available div
                document.getElementById("ctl00_ContentPlaceHolder1_divnodataforpreviousstatus").style.display = "none";
                //Show status details table
                $("#tblStatus").show();

                for (var i = 0; i < data.d.length; i++) {

                    var divtask = "";
                    var linkedit = "<a ID='lbtnedit'  onclick='bindeditstatus(\"" + data.d[i].nid + "\",\"" + data.d[i].statusdate + "\",\"" + data.d[i].Status + "\",\"" + data.d[i].TimeTaken + "\",\"" + data.d[i].remark + "\",\"" + data.d[i].laststatus + "\",\"" + data.d.length.toString() + "\",\"" + i.toString() + "\");' title='Click here to edit'><i style='text-align: center; padding-top: 10px;'><img src='images/edit.png' alt=''></i></a>&nbsp;";
                    var linkdelete = "<a ID='lbtndelete'  onclick='deletestatus(" + data.d[i].nid + ")' title='Click here to delete'><i style='text-align: center; padding-top: 10px;'><img src='images/delete.png' alt=''></i></a>";
                    var grade = data.d[i].grade;
                    laststatus = data.d[i].laststatus;
                    //Check whther status approve/rejected from timesheet or not
                    if (data.d[i].taskstatus == "approved" || data.d[i].taskstatus == "rejected") {
                        //if it is, then Show status Approved/Rejected
                        divtask = data.d[i].taskstatus;
                        //Reset values of linkedit and linkdelete, so edit and delete button will not be available
                        linkedit = "";
                        linkdelete = "";
                    }
                    //check whther any grade assigned by supervisor for task
                    else if (grade != "") {
                        //if it is, Reset values of linkedit and linkdelete, so edit and delete button will not be available
                        linkedit = "";
                        linkdelete = "";
                        document.getElementById("ctl00_ContentPlaceHolder1_divnewstatus").style.display = "none";
                    }
                    else if (empid != userid) {
                        //If it is not task of current logged in employee, then edit and del button will not be available
                        linkedit = "";
                        linkdelete = "";
                    }

                    //Append row to show status details in tblStatus table.
                    $("#tblStatus").append("<tr><td>" + data.d[i].statusdate + "</td><td>" + data.d[i].Status + "</td><td>" + data.d[i].TimeTaken + "</td><td>" + data.d[i].remark + "</td><td>" + linkedit + linkdelete + divtask + "</td></tr>");
                }
                binddropdownstatus(laststatus);
            }
            //Call function to open status Pop up
            openstatusdiv();
            $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
        },
        error: function (x, e) {
            alert("The call to the server side failed. " + x.responseText);
            $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
        }


    });
}
//--------------------Bind status details to textboxes to edit the details-------------------------------------

function bindeditstatus(statusid, date, status, timetaken, remark, laststatus, length, index) {

    //Length indicates number of status available
    //Current edited row index
    document.getElementById("ctl00_ContentPlaceHolder1_txtnewdate").value = date;
    document.getElementById("ctl00_ContentPlaceHolder1_txtremark").value = remark;
    document.getElementById("ctl00_ContentPlaceHolder1_txtTime").value = timetaken;
    document.getElementById("ctl00_ContentPlaceHolder1_hidstatusid").value = statusid;
    if (index != length - 1) {

        document.getElementById("ctl00_ContentPlaceHolder1_ddlstaus").disabled = "disabled";
        document.getElementById("ctl00_ContentPlaceHolder1_hidIsUpdateStatus").value = "";
    }
    else {
        var args = { nid: statusid };

        $.ajax({

            type: "POST",
            url: "AssignedTasks.aspx/selectstatus",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            cache: false,
            success: function (data) {
                if (data.d != "failure") {
                    laststatus = data.d;
                    binddropdownstatus(laststatus);
                }
            },
            error: function (x, e) {
                alert("The call to the server side failed. " + x.responseText);

            }


        });
        document.getElementById("ctl00_ContentPlaceHolder1_ddlstaus").disabled = false;
        document.getElementById("ctl00_ContentPlaceHolder1_hidIsUpdateStatus").value = "1";

    }
    document.getElementById("ctl00_ContentPlaceHolder1_ddlstaus").value = status;
    document.getElementById("ctl00_ContentPlaceHolder1_divnewstatus").style.display = "block";
}
function binddropdownstatus(currentstatus) {

    $("#ctl00_ContentPlaceHolder1_ddlstaus option[value='In Process']").show();

    if (currentstatus == "Partially Completed") {
        $("#ctl00_ContentPlaceHolder1_ddlstaus option[value='In Process']").hide();
    }
}
//--------------------------------DELETE status---------------------------------------------
function deletestatus(nid) {
    var args = { nid: nid };
 
    $.ajax({

        type: "POST",
        url: "AssignedTasks.aspx/deletestatus",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {
            if (data.d != "failure") {
                alert("Deleted successfully");
                bindstatus(document.getElementById("ctl00_ContentPlaceHolder1_hidid").value, document.getElementById("ctl00_ContentPlaceHolder1_hidcurrentemp").value);
                //Call this function to make changes in main grid after delete status
                resetgridvalues(data.d.toString());
            }
        },
        error: function (x, e) {
            alert("The call to the server side failed. " + x.responseText);

        }


    });
}
//-----------------This function changes in list values after delete and save status-----------------
function resetgridvalues(result) {
    var nid = document.getElementById("ctl00_ContentPlaceHolder1_hidid").value;
    var arr = result.split(",");
    document.getElementById(document.getElementById("ctl00_ContentPlaceHolder1_hidid").value + "_ltrhours").innerHTML = arr[1];
    document.getElementById(document.getElementById("ctl00_ContentPlaceHolder1_hidid").value + "_ltrstatus").innerHTML = arr[0];
    document.getElementById(document.getElementById("ctl00_ContentPlaceHolder1_hidid").value + "_ltrLastModifiedDate").innerHTML = arr[3];

    if (arr[0].toString().toLowerCase() == "completed") 
    {
        document.getElementById(nid + "_txtremark").innerHTML = arr[2];
        document.getElementById(nid + "_lbtndelete").style.display = "none";
        document.getElementById("ctl00_ContentPlaceHolder1_divnewstatus").style.display = "none";
    }
    else if (arr[0].toString().toLowerCase() == "not started") 
    {
        document.getElementById(nid + "_txtremark").innerHTML = "<textarea style='height:30px;width:90px;' id='" + nid + "_txtremark'  onchange='saveRemark(this.id);' cols='20' rows='2'>" + arr[2] + "</textarea>";
        document.getElementById(nid + "_lbtndelete").style.display = "block";
    }

}
//------------------------Validate status form------------------------------------
function vaildatestatus() {
    var isvalid = true;
    if (document.getElementById("ctl00_ContentPlaceHolder1_txtnewdate").value == "") {
        document.getElementById("spanerr_txtnewdate").innerHTML = "*";
        isvalid = false;
    }
    else {
        document.getElementById("spanerr_txtnewdate").innerHTML = "";
    }
    if (document.getElementById("ctl00_ContentPlaceHolder1_txtTime").value == "") {
        document.getElementById("spanerr_txtTime").innerHTML = "*";
        isvalid = false;
    }
    else {
        document.getElementById("spanerr_txtTime").innerHTML = "";
    }
    if (document.getElementById("ctl00_ContentPlaceHolder1_ddlstaus").value == "") {
        document.getElementById("spanerr_ddlstaus").innerHTML = "*";
        isvalid = false;
    }
    else {
        document.getElementById("spanerr_ddlstaus").innerHTML = "";
    }
    if (isvalid == true)
        savestatus();
    else
        return false;
}


//----------------------------------SAVE status-----------------------------------------------------------
function savestatus() {
    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
    var id = "";
    var loginid = document.getElementById("hidloginid").value;
    var companyid = document.getElementById("hidcompanyid").value;
    var statusid = document.getElementById("ctl00_ContentPlaceHolder1_hidstatusid").value;
    var nid = document.getElementById("ctl00_ContentPlaceHolder1_hidid").value;
    var status = document.getElementById("ctl00_ContentPlaceHolder1_ddlstaus").value;
    var date = document.getElementById("ctl00_ContentPlaceHolder1_txtnewdate").value;
    var remark = document.getElementById("ctl00_ContentPlaceHolder1_txtremark").value;
    var timetaken = document.getElementById("ctl00_ContentPlaceHolder1_txtTime").value;
    var isupdatestatus = document.getElementById("ctl00_ContentPlaceHolder1_hidIsUpdateStatus").value;
    var args = { nid: nid, status: status, newdate: date, timetaken: timetaken, remark: remark, statusid: statusid, isupdatestatus: isupdatestatus, userid: loginid, companyid: companyid };

    $.ajax({

        type: "POST",
        url: "AssignedTasks.aspx/savestatus",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {
            if (data.d != "failure") {
                alert("Saved successfully");


                document.getElementById("ctl00_ContentPlaceHolder1_ddlstaus").selectedIndex = 0;
                document.getElementById("ctl00_ContentPlaceHolder1_txtnewdate").value = "";
                document.getElementById("ctl00_ContentPlaceHolder1_txtremark").value = "";
                document.getElementById("ctl00_ContentPlaceHolder1_txtTime").value = "";
                document.getElementById("ctl00_ContentPlaceHolder1_hidstatusid").value = "";
                document.getElementById("ctl00_ContentPlaceHolder1_hidIsUpdateStatus").value = "";
                bindstatus(document.getElementById("ctl00_ContentPlaceHolder1_hidid").value,
                document.getElementById("ctl00_ContentPlaceHolder1_hidcurrentemp").value);

                document.getElementById("assignedtask_divstatus").style.display = "none";
                document.getElementById("otherdiv").style.display = "none";
                //Call this function to make changes in main grid after save status
                resetgridvalues(data.d.toString());
            }
        },
        error: function (x, e) {
            alert("The call to the server side failed. " + x.responseText);
            $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
        }


    });
}

//----------------------------------------------------SCRIPTs for ASSIGN TASK goes here-----------------------------------------
//-------------------Save AssignTask on June 6th
function SaveAssignTask() {
    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
    var empid = document.getElementById("ctl00_ContentPlaceHolder1_ddlemployee").value;
    var date = document.getElementById("ctl00_ContentPlaceHolder1_txtscheduledate").value;

    var createdby = document.getElementById("hidloginid").value;
    var companyid = document.getElementById("hidcompanyid").value;
    var hours = document.getElementById("ctl00_ContentPlaceHolder1_ddlmanager").value;
    //---Get values of MULTI PROJECTs and TASKS
    var newid = "", projectid = "", taskid = "", remark = "";
    var id = parseInt(document.getElementById("AssignedTask_hidrowno").value);

    for (var i = 1; i <= id; i++) {

        newid = "hidproject" + i;
        projectid = projectid + document.getElementById(newid).value + "#";

        newid = "hidtask" + i;
        var taskvalue = document.getElementById(newid).value;
        var taskarr = taskvalue.split("#");
        taskid = taskid + taskarr[0] + "#";

        newid = "txtdesc" + i;
        remark = remark + document.getElementById(newid).value + "#";


    }

    var args = { empid: empid, date: date, projectid: projectid, taskid: taskid, companyid: companyid, createdby: createdby, hours: hours, remark: remark };
    $.ajax({

        type: "POST",
        url: "AssignedTasks.aspx/assignTask",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {
            if (data.d != "failure") {
                alert("Saved successfully");
                document.getElementById("ctl00_ContentPlaceHolder1_ddlemployee").selectedIndex = 0;
                document.getElementById("ctl00_ContentPlaceHolder1_txtscheduledate").value = document.getElementById("viewstatetodaydate").value;
            
                document.getElementById("ctl00_ContentPlaceHolder1_ddlmanager").selectedIndex = 0;
                resetprojecttasktable();
              
                bindassignedtasks(data.d);
                closediv();
                $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
            }
        },
        error: function (x, e) {
            alert("The call to the server side failed. " + x.responseText);

        }


    });

}
function resetprojecttasktable() {
    var id = parseInt(document.getElementById("AssignedTask_hidrowno").value);

    for (var j = 2; j <= id; j++) {

        deleterow();
    }
    document.getElementById("ddlproject1").value = "";
    document.getElementById("hidproject1").value = "";
    document.getElementById("ddltask1").value = "";
    document.getElementById("hidtask1").value = "";
    document.getElementById("txtdesc1").value = "";

}
//----------------------------------Validate AssignNewTask form
function vaildateAssignTask() {
    var isvalid = true;
    var newid = "";
    var newid1 = "";
    var id = parseInt(document.getElementById("AssignedTask_hidrowno").value);

    if (document.getElementById("ctl00_ContentPlaceHolder1_txtscheduledate").value == "") {
        document.getElementById("spanerr_txtscheduledate").innerHTML = "*";
        isvalid = false;
    }
    else {
        document.getElementById("spanerr_txtscheduledate").innerHTML = "";
    }

    if (document.getElementById("ctl00_ContentPlaceHolder1_ddlemployee").value == "") {
        document.getElementById("spanerr_ddlemployee").innerHTML = "*";
        isvalid = false;
    }
    else {
        document.getElementById("spanerr_ddlemployee").innerHTML = "";
    }

    if (document.getElementById("ctl00_ContentPlaceHolder1_ddlmanager").value == "") {
        document.getElementById("spanerr_ddlmanager").innerHTML = "*";
        isvalid = false;
    }
    else {
        document.getElementById("spanerr_ddlmanager").innerHTML = "";
    }

   

    //---------------Validate Project task rows--------
    for (var i = 1; i <= id; i++) {

        newid = "ddlproject" + i;
        newid1 = "hidproject" + i;
        if (document.getElementById(newid1).value == "") {
            isvalid = false;
            document.getElementById(newid).className = "errform-control";
        }
        else {
            document.getElementById(newid).className = "form-control";
        }
        newid = "ddltask" + i;
        newid1 = "hidtask" + i;
      
        if (document.getElementById(newid1).value == "") {
            isvalid = false;
            document.getElementById(newid).className = "errform-control";
        }
        else {
            document.getElementById(newid).className = "form-control";
        }

        newid = "txtdesc" + i;
     
        if (document.getElementById(newid).value == "" || document.getElementById(newid).value == "0") {
            isvalid = false;
            document.getElementById(newid).className = "errform-control";
        }
        else {
            document.getElementById(newid).className = "form-control";
        }
    }

    if (isvalid == true) {
        SaveAssignTask();

    }
    else {

        return false;
    }
}

//---------------------------------Search Assigned Task table by usng search parameters-----------------------------------
function searchdata() {

    document.getElementById("ctl00_ContentPlaceHolder1_hidsearchdropemployee").value = document.getElementById("ctl00_ContentPlaceHolder1_dropemployee").value;
    document.getElementById("ctl00_ContentPlaceHolder1_hidsearchdropstatus").value = document.getElementById("ctl00_ContentPlaceHolder1_dropstatus").value;
    document.getElementById("ctl00_ContentPlaceHolder1_hidsearchdropclient").value = document.getElementById("ctl00_ContentPlaceHolder1_dropclient").value;
    document.getElementById("ctl00_ContentPlaceHolder1_hidsearchdropproject").value = document.getElementById("ctl00_ContentPlaceHolder1_dropproject").value;
    document.getElementById("ctl00_ContentPlaceHolder1_hidsearchdroptask").value = document.getElementById("ctl00_ContentPlaceHolder1_droptask").value;
    document.getElementById("ctl00_ContentPlaceHolder1_hidsearchfromdate").value = document.getElementById("ctl00_ContentPlaceHolder1_txtfromdate").value;
    document.getElementById("ctl00_ContentPlaceHolder1_hidsearchtodate").value = document.getElementById("ctl00_ContentPlaceHolder1_txttodate").value;
    document.getElementById("ctl00_ContentPlaceHolder1_hidsearchdroassign").value = document.getElementById("ctl00_ContentPlaceHolder1_dropassign").value;

    document.getElementById("ctl00_ContentPlaceHolder1_hidsearchdropemployeename").value = $('#ctl00_ContentPlaceHolder1_dropemployee').find('option:selected').text();
    document.getElementById("ctl00_ContentPlaceHolder1_hidsearchdropstatusname").value = $('#ctl00_ContentPlaceHolder1_dropstatus').find('option:selected').text();
    document.getElementById("ctl00_ContentPlaceHolder1_hidsearchdropclientname").value = $('#ctl00_ContentPlaceHolder1_dropclient').find('option:selected').text();
    document.getElementById("ctl00_ContentPlaceHolder1_hidsearchdropprojectname").value = $('#ctl00_ContentPlaceHolder1_dropproject').find('option:selected').text();
    document.getElementById("ctl00_ContentPlaceHolder1_hidsearchdroptaskname").value = $('#ctl00_ContentPlaceHolder1_droptask').find('option:selected').text();
    document.getElementById("ctl00_ContentPlaceHolder1_hidsearchdroassignname").value = $('#ctl00_ContentPlaceHolder1_dropassign').find('option:selected').text();
    document.getElementById("ctl00_ContentPlaceHolder1_hidsno").value = "0";
    document.getElementById("ctl00_ContentPlaceHolder1_hidmaxnid").value = "";
    $("#dgnews").empty();

    bindassignedtasks("");

}

//------------------------Bind assigned tasks in list---------------------------------------
function bindassignedtasks(id) {
    $('#divloadmore').show();
    //Get values of Add and View roles value from Hidden fields:
    var empid = "", status = "", clientid = "", projectid = "", taskid = "", fromdate = "", todate = "", assignedby = "", sno = "0", maxnid = "";

    if ((id.trim()).length <= 0) {
        empid = document.getElementById("ctl00_ContentPlaceHolder1_hidsearchdropemployee").value;
        status = document.getElementById("ctl00_ContentPlaceHolder1_hidsearchdropstatus").value;
        clientid = document.getElementById("ctl00_ContentPlaceHolder1_hidsearchdropclient").value;
        projectid = document.getElementById("ctl00_ContentPlaceHolder1_hidsearchdropproject").value;
        taskid = document.getElementById("ctl00_ContentPlaceHolder1_hidsearchdroptask").value;
        fromdate = document.getElementById("ctl00_ContentPlaceHolder1_hidsearchfromdate").value;
        todate = document.getElementById("ctl00_ContentPlaceHolder1_hidsearchtodate").value;
        assignedby = document.getElementById("ctl00_ContentPlaceHolder1_hidsearchdroassign").value;

    }
    maxnid = document.getElementById("ctl00_ContentPlaceHolder1_hidmaxnid").value;
    sno = document.getElementById("ctl00_ContentPlaceHolder1_hidsno").value;
    //Here addrole value "1" indicates that user have right to Assign Role
    var addrole = document.getElementById("viewstateadd").value;
    // Declare variable to get Length of table
    var tablelength = 1;
    //userid contains the current user's nid
    var userid = document.getElementById("hidloginid").value;

    var txtremark = "", ddlgrade = "", txtcomments = "", imgassignedby = "", lbtnstatus = "", deletebuttontext = "";
    var grade = "", LastModifiedDate = "", projectname = "", projectCode = "", taskcodename = "", txtcomments = "", linkdelete = "", hiddenfieldnid = "";


    var args = { nid: id, empid: empid, status: status, clientid: clientid, projectid: projectid, taskid: taskid, fromdate: fromdate, todate: todate, assignedby: assignedby, sno: sno, maxnid: maxnid };
    var tblheader = '<tr class="gridheader"><th>&nbsp;</th><th style="width: 80px;"> AssignDate </th><th style="width: 80px;"> LastUpdated </th><th> Employee</th>' +
                                '<th> ProjectID</th> <th>TaskID</th> <th > Remark</th> <th style="width: 30px;"> BHours</th><th style="width: 40px;">TimeTaken' +
                               '</th><th style="width: 70px;"> Status</th><th style="width: 50px;"> Manager</th><th style="width: 80px;"> Grade</th>' +
                                '<th style="width: 90px;"> Comments</th><th style="width: 25px;"> &nbsp; </th><th > &nbsp;</th></tr>';


    $.ajax({

        type: "POST",
        url: "AssignedTasks.aspx/getassignedtask",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        cache: false,
        success: function (data) {
            //Check length of returned data, if it is less than 0 it means there is some status available
            if (data.d != "failure") {


                var json = $.parseJSON(data.d);

                if (json.length > 0) {

                    document.getElementById("ctl00_ContentPlaceHolder1_divnodata").style.display = "none";
                    if ($('#dgnews > * > tr').length <= 0) {
                        $("#dgnews").append(tblheader);
                    }

                }
                else {
                    if ($('#dgnews > * > tr').length <= 0) {
                        document.getElementById("ctl00_ContentPlaceHolder1_divnodata").style.display = "block";
                    }
                    else {
                        document.getElementById("ctl00_ContentPlaceHolder1_divnodata").style.display = "none";

                    }
                    if (id == "") {
                        document.getElementById("ctl00_ContentPlaceHolder1_hidsno").value = "";
                    }
                }
                var status = "";
                for (var i in json) {

                    if (i == json.length - 1) {

                        document.getElementById("ctl00_ContentPlaceHolder1_hidmaxnid").value = json[i].maxnid;
                    }
                    else {
                        hiddenfieldnid = "<input type='hidden' id='" + json[i].nid + "_hidnid' value=\"" + json[i].nid + "\"/>";
                        txtremark = "<textarea style='height:30px;width:90px;' id='" + json[i].nid + "_txtremark'  onchange='saveRemark(this.id);' cols='20' rows='2'>" + json[i].remark + "</textarea>";
                        ddlgrade = "<select style='width:80px;' onchange='savereward(this.id);' title='Task Grade can be given after completion of task' id='" + json[i].nid + "_ddlgrade'>" +
					                        "<option value=''></option>" +
					                        "<option value='Excellent'>Excellent</option>" +
					                        "<option value='Good'>Good</option>" +
					                        "<option value='Average'>Average</option>" +
					                        "<option value='Below Average'>Below Average</option>" +
					                        "<option value='Poor'>Poor</option></select>";

                        txtcomments = "<textarea style='height:30px;width:98%;' onchange='savereward(this.id);' id='" + json[i].nid + "_txtcomments' cols='20' rows='2' >" + json[i].comments + "</textarea>";
                        imgassignedby = "<img title='Self Assigned' style='padding-top: 5px;' src='images/graydot.png'>"

                        lbtnstatus = "<a onclick='bindstatus(\"" + json[i].nid + "\",\"" + json[i].empid + "\");'><i style='font-size: 18px; color: #d9534f; display: block; margin: auto;padding-top: 8px;' class='fa fa-fw'><img width='20' alt='' src='images/viewstatus.png'></i></a>";
                        deletebuttontext = "<a class='delassign' title='Delete' id='" + json[i].nid + "_lbtndelete'><i style='font-size: 18px; color: #d9534f; display: block; margin: auto;padding-top: 8px;' class='fa fa-fw' onclick='deleteassigntask(\"" + json[i].nid + "\",this); '><img alt='' src='images/delete.png'></i></a>";

                        if (json[i].grade != null) {
                            grade = json[i].grade;
                        }
                        if (json[i].status != null) {

                            status = json[i].status.toString().toLowerCase();
                        }
                        else {
                            ltrstatus = "<span id=" + json[i].nid + "_ltrstatus'></span>";
                            status = "";
                        }
                        if (json[i].assignedbyid == "self assigned") {
                            imgassignedby.Src = "images/graydot.png";
                        }
                        else {
                            imgassignedby.Src = "images/greendot.png";
                        }
                        if (json[i].Lastmodifieddate != null) {
                            LastModifiedDate = json[i].Lastmodifieddate;
                        }
                        else {
                            LastModifiedDate = "";
                        }


                        //Check whether work on task has started or not
                        if (status.toLowerCase() == "not started" || status == "") {
                            //If work has started then
                            //Check whether logged in user is a manager or not
                            //If it is a manager then , it can delete the task yet not started
                            if (addrole == "1") {
                                linkdelete = deletebuttontext;
                            }
                            //If logged in user is not a manager - then check whether it is self assigned task?
                            //If it is self assigned task, then user can delete it. so show the delete button
                            else if (json[i].createdby == userid) {
                                linkdelete = deletebuttontext;
                            }

                        }
                        else {
                            linkdelete = "<a class='delassign' title='Delete' id='" + json[i].nid + "_lbtndelete' style='display:none;'><i style='font-size: 18px; color: #d9534f; display: block; margin: auto;padding-top: 8px;' class='fa fa-fw' onclick='deleteassigntask(\"" + json[i].nid + "\",this); '><img alt='' src='images/delete.png'></i></a>";
                        }

                        if (addrole == "1") {
                            if (status != "completed") {
                                ddlgrade = "<select style='width:80px;' disabled='disabled' onchange='savereward(this.id);' title='Task Grade can be given after completion of task' id='" + json[i].nid + "_ddlgrade'>" +
					                        "<option value=''>" + json[i].grade + "</option>";

                            }
                            if (status == "completed") {

                                if (json[i].remark != null)
                                    txtremark = "<span id='" + json[i].nid + "_txtremark'>" + json[i].remark + "</span>";
                                else
                                    txtremark = "<span id='" + json[i].nid + "_txtremark'></span>";
                            }

                        }
                        else {


                            if (json[i].comments != null) {
                                txtcomments = json[i].comments;
                            }
                            else {
                                txtcomments = "";
                            }
                            if (json[i].grade != null) {
                                ddlgrade = json[i].grade;
                            }
                            else {
                                ddlgrade = "";
                            }

                            if (status == "completed") {
                                if (json[i].remark != null)
                                    txtremark = "<span id='" + json[i].nid + "_txtremark'>" + json[i].remark + "</span>";
                                else
                                    txtremark = "<span id='" + json[i].nid + "_txtremark'></span>";
                            }



                        }
                        if (id == "") {
                            tablelength = $('#dgnews > * > tr').length;

                        }
                        //Bind sno value to the hidden field
                        if (json[i].sno != null) {
                            document.getElementById("ctl00_ContentPlaceHolder1_hidsno").value = json[i].sno;
                        }

                        $('#dgnews > * > tr').eq(tablelength - 1).after("<tr><td>" + imgassignedby + "</td><td>" + json[i].date + "</td><td><span id='" + json[i].nid + "_ltrLastModifiedDate'>" + LastModifiedDate + "</span></td><td><span title='" + json.loginid + "'>" + json[i].empname +
            "</span></td><td><span title='" + json.projectname + "'>" + json[i].projectCode + "</span></td><td>" + json[i].taskcodename + ':' + json[i].task +
            "</td><td>" + txtremark + hiddenfieldnid + "</td><td>" + json[i].bhours + "</td><td><span id='" + json[i].nid + "_ltrhours'>" + json[i].totalhour + "</span></td><td><span id='" + json[i].nid + "_ltrstatus'>" + json[i].status.toString()
            + "</span></td><td><span title='" + json.managername + "'>" + json[i].managerloginid + "</span></td><td>" + ddlgrade + "</td>" +
            "<td>" + txtcomments + "</td><td>" + lbtnstatus + "</td><td>" + linkdelete + "</td></tr>");

                        var ddlgradeid = json[i].nid + "_ddlgrade";
                        if (document.getElementById(ddlgradeid) != null)
                            document.getElementById(ddlgradeid).value = json[i].grade;
                    }

                }
            }

            $('#divloadmore').hide();
        },
        error: function (x, e) {
            alert("The call to the server side failed. " + x.responseText);
            $('#divloadmore').hide();
        }


    });
}


//--------------------------------DELETE Assigned task---------------------------------------------
function deleteassigntask(nid, btndel) {

    if (confirm("Delete this record? Yes or No")) {
        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
        var args = { nid: nid };
        $.ajax({

            type: "POST",
            url: "AssignedTasks.aspx/deleteassignedtask",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            cache: false,
            success: function (data) {
                if (data.d == "success") {
                    if (typeof (btndel) == "object") {
                        $(btndel).closest("tr").remove();
                    }
                    alert("Deleted successfully");
                    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                }
            },
            error: function (x, e) {
                alert("The call to the server side failed. " + x.responseText);

            }


        });
    }


}
//---------Load more data when user reached at bottom of screen
$(window).scroll(function () {
    if ($(window).scrollTop() == $(document).height() - $(window).height()) {
        if (document.getElementById("ctl00_ContentPlaceHolder1_hidsno").value != "") {

            bindassignedtasks("");
        }
    }
});


//-------------------NEW for Multiprojects in tablular form-------------------------------

var json;
var jsontasks;
$(document).ready(function () {


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
            bindtaskvalue(hiddenid, ui.item.value);
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

//------------------Bind task description when selects a taskcode from autocompleter
function bindtaskvalue(id, value) {

    var rownum = id.replace('hidtask', '');
    var taskarr = value.split("#");

    document.getElementById("txtdesc" + rownum).value = taskarr[2];


}

//---------------ADD NEW row for Project,Task and DEscription when assignes a new task
function addrow() {
    var table = document.getElementById("tbldata");

    var id = parseInt(document.getElementById("AssignedTask_hidrowno").value);
    var sno = parseInt(document.getElementById("AssignedTask_hidsno").value);
    sno = sno + 1
    var newsno = id + 1;
    var row = table.insertRow(newsno);


    if (id > 1)
        document.getElementById("divdel" + id).innerHTML = "";



    var cellproject = row.insertCell(0);
    var celltask = row.insertCell(1);

    var celldes = row.insertCell(2);
    var celldelete = row.insertCell(3);

    cellproject.innerHTML = "<input type='text' id='ddlproject" + newsno + "' class='form-control form-control1'  placeholder='Project ID' /> <input type='hidden' id='hidproject" + newsno + "' />";
    celltask.innerHTML = "<input type='text' id='ddltask" + newsno + "' class='form-control form-control1' onchange='bindtaskvalue(this.id,this.value);'  placeholder='Task Code' /><input type='hidden' id='hidtask" + newsno + "' />";
    celldes.innerHTML = "<input type='text' id='txtdesc" + newsno + "' class='form-control form-control1'  placeholder='Description' />";
    celldelete.innerHTML = "<div id='divdel" + newsno + "' ><a style='cursor: pointer;color:bule;' id='delete' onclick='deleterow(this.id);'><i class='fa fa-fw'><img src='images/delete.png' alt=''></i></a></div>";

    document.getElementById("AssignedTask_hidrowno").value = newsno;
    document.getElementById("AssignedTask_hidsno").value = sno;


    var inputprojectid = "ddlproject" + newsno;
    var hiddenprojectid = "hidproject" + newsno;
    bindprojectautocompleter(inputprojectid, hiddenprojectid);


    var inputid = "ddltask" + newsno;
    var hiddenid = "hidtask" + newsno;

    bindtaskautocompleter(inputid, hiddenid);


}


//------------Delete rows when aasign new task
function deleterow() {
    
    var table = document.getElementById("tbldata");
    var id = parseInt(document.getElementById("AssignedTask_hidrowno").value);
    var sno = parseInt(document.getElementById("AssignedTask_hidsno").value);
    sno = sno - 1
    var newsno = id - 1;

    table.deleteRow(id);
    if (newsno != "1")
        document.getElementById("divdel" + newsno).innerHTML = "<a style='cursor: pointer;color:bule;' id='delete' onclick='deleterow(this.id);'><i class='fa fa-fw' style='font-size: 18px; color: #d9534f; display: block; margin: auto;'><img src='images/delete.png' alt=''></i></a>";


    document.getElementById("AssignedTask_hidrowno").value = newsno;
    document.getElementById("AssignedTask_hidsno").value = sno;

}