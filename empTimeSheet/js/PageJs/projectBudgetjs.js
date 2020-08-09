
var nid = '',rowno='',srttask='',srtexport='';
var jsonproject, jsontask;
var jsonimport;
var strcol = "", strcolname = "";
var pagename = "projectBudget.aspx";
var isimport = "";


function openimport() {
    setposition("divimport");
    $('#otherdiv').show();
    $('#divimport').show();
    $('#divselectfile').show();
    $('#divselectcol').hide();
    $('#ctl00_ContentPlaceHolder1_hidfilename').val('');
    $('#hidSelecetedLeft').val('');
    $('#hidSelectedRight').val('');
    document.getElementById("divattachfilename").innerHTML = "";



}
function AssemblyFileUpload_Started(sender, args) {
    document.getElementById("divuploadstatus").innerHTML = "";
    $('#ctl00_ContentPlaceHolder1_AsyncFileUpload1_ctl02').css("background-color", "none");
    $('#ctl00_ContentPlaceHolder1_AsyncFileUpload1_ctl01').css("background-color", "none");
    $('#ctl00_ContentPlaceHolder1_AsyncFileUpload1_ctl01').css("color", "#000");
    var filename = args.get_fileName();
    var ext = filename.substring(filename.lastIndexOf(".") + 1);
    ext = (String(ext)).toLowerCase();
    if (ext != 'xls' && ext != 'xlsm' && ext != 'xlsx') {
        throw {
            name: "Invalid File Type",
            level: "Error",
            message: "Invalid File Type (.xlsx, .xls, .xlsm)",
            htmlMessage: "Invalid File Type (.xlsx, .xls, .xlsm)"
        }
        return false;
    }
    return true;
}
function uploadComplete(sender, args) {

    document.getElementById("divuploadstatus").innerHTML = "<img src='images/apply_icon.png' />";
    $('#ctl00_ContentPlaceHolder1_AsyncFileUpload1_ctl02').css("background-color", "#4cbb17");
    $('#ctl00_ContentPlaceHolder1_AsyncFileUpload1_ctl01').css("background-color", "#4cbb17");
    $('#ctl00_ContentPlaceHolder1_AsyncFileUpload1_ctl01').css("color", "#ffffff");
    $('#ctl00_ContentPlaceHolder1_hidfilename').val(args.get_fileName());
    $('#divselectfile').hide();
    $('#divselectcol').show();



}



function uploadError(sender) {

    document.getElementById("divuploadstatus").innerHTML = "<img src='images/warning.png' />";
    $('#ctl00_ContentPlaceHolder1_AsyncFileUpload1_ctl02').css("background-color", "red");
    $('#ctl00_ContentPlaceHolder1_AsyncFileUpload1_ctl01').css("background-color", "red");
    $('#ctl00_ContentPlaceHolder1_AsyncFileUpload1_ctl01').css("color", "#ffffff");
}


function showuploadprogress() {
    $('#divattachfilename').html("<img src='images/pleasewait.gif' />&nbsp;uploadng..")
}
function Attachment_openupload(rectype, id) {

    var iframe = document.getElementById("ifuploadfile");
    var args;
    iframe.contentWindow.selectAttachment(args);

}
function AttachClientFileCall(id, filesize, filename, filext) {
    $('#divattachfilename').html(filename);
    $('#ctl00_ContentPlaceHolder1_hidfilename').val(id);

    $('#divselectfile').hide();
    $('#divselectcol').show();
}

function selecttd(type, id) {
    if (type == 0) {
        $('.tblcolleft').removeClass('selectedcell');
        $('#' + id).addClass('selectedcell');
        $('#hidSelecetedLeft').val(id);
    }
    else {
        $('.tblcolright').removeClass('selectedcell');
        $('#' + id).addClass('selectedcell');
        $('#hidSelectedRight').val(id);
    }

}
function nextChar(c) {
    return String.fromCharCode(c.charCodeAt(0) + 1);
}
function move(type) {
    if (type == 'right') {
        if ($('#hidSelecetedLeft').val() != "") {

            var table = document.getElementById("tblright");
            var strval = "A";

            if (table.rows.length > 0) {
                for (var i = 0, row; row = table.rows[i]; i++) {
                    var id = row.getAttribute("id").replace("tdcolright", "");
                    if ($('#txtcolright' + id).val() != "") {
                        var strcurrent = $('#txtcolright' + id).val().toUpperCase();
                        if (strcurrent.charCodeAt(0) >= strval.charCodeAt(0)) {
                            strval = nextChar(strcurrent);
                        }
                    }

                }
            }
            var id = $('#hidSelecetedLeft').val().replace("tdcol", "");

            var innertaxt = $('#spancol' + id).html();

            var hidval = $('#hidcol' + id).val();
            var str = "<tr class='tblcolright' id='tdcolright" + id + "' onclick='selecttd(1,this.id);'><td style='border-right:dotted 1px #e0e0e0;'> <span id='spancolright" + id + "'>" + innertaxt + "</span><input type='hidden' id='hidcolright" + id + "' value='" + hidval + "' /></td><td width='70'><input type='text' id='txtcolright" + id + "' value='" + strval + "' maxlength='1' class='form-control' onkeypress='return onlyAlphabets(event,this);' style='text-transform:uppercase;' /></td></tr>";

            var newid = $('#' + $('#hidSelecetedLeft').val()).next('tr').attr('id');

            $('#' + $('#hidSelecetedLeft').val()).remove();

            $('#tblright').append(str);
            $('#hidSelecetedLeft').val('');
            if (document.getElementById(newid) != null)
                selecttd(0, newid);
        }
    }
    else {
        if ($('#hidSelectedRight').val() != "") {
            var id = $('#hidSelectedRight').val().replace("tdcolright", "");
            var innertaxt = $('#spancolright' + id).html();
            var hidval = $('#hidcolright' + id).val();
            var str = "<tr class='tblcolleft' id='tdcol" + id + "' onclick='selecttd(0,this.id);'><td> <span id='spancol" + id + "'>" + innertaxt + "</span><input type='hidden' id='hidcol" + id + "' value='" + hidval + "' /></td></tr>";
            $('#' + $('#hidSelectedRight').val()).remove();
            $('#tblleft').append(str);

            $('#hidSelectedRight').val('');
        }
    }

}

function saveimport() {
    var table = document.getElementById("tblright");
    var status = 1; strval = "", status1 = 0, status2 = 0;
    strcol = "";
    strcolname = "";
    if (table.rows.length == 0) {
        status = 0;
        alert("Select the fields and associated columns where imported information is located in the excel work sheet!");
        return;
    }
    for (var i = 0, row; row = table.rows[i]; i++) {
        id = row.getAttribute("id").replace("tdcolright", "");
        if ($('#hidcolright' + id).val() == "TaskCode")
            status1 = 1;

        if ($('#hidcolright' + id).val() == "TaskName")
            status2 = 1;

        strcol = strcol + $('#hidcolright' + id).val() + '#';
        strcolname = strcolname + $('#spancolright' + id).html() + '##';
        strval = strval + $('#txtcolright' + id).val() + '#';


    }

    if (status1 == 0) {
        alert("Task Code is Required!");
        return;
    }
    else {
        if (status2 == 0) {
            alert("Task Name is Required!");
            return;
        }
    }


    if (status == 1 && status1 == 1 && status2 == 1) {
        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
        var args = { path: document.getElementById("ctl00_ContentPlaceHolder1_hidfilename").value, cols: strcol, val: strval, companyid: document.getElementById("hidcompanyid").value };
        $.ajax({

            type: "POST",
            url: pagename + "/importTask",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            cache: false,
            success: function (data) {

                if (data.d == "-1") {

                    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();

                    alert("Imported excel file does not have records!");
                    return;
                    //closediv();
                }
                else {
                    var totalsub = 0, totalsaved = 0; totalerror = 0, totalup = 0;
                    jsonimport = $.parseJSON(data.d);
                    if (jsonimport.length > 0) {
                        totalsub = jsonimport.length;
                        for (var i = 0; i < jsonimport.length; i++) {
                            addnewrow();

                            $("#hidbudTask_nid" + rowno).val("");
                            $("#ddltask" + rowno).val(jsonimport[i].TaskCode + ':' + jsonimport[i].TaskName);
                            $("#hidtask" + rowno).val(jsonimport[i].nid);
                            $("#txtdesc" + rowno).val(jsonimport[i].description);
                            $("#txtbujhrs" + rowno).val(jsonimport[i].budHrs);
                            $("#txtbillrate" + rowno).val(jsonimport[i].billRate);
                            $("#txtcostrate" + rowno).val(jsonimport[i].payRate);
                            $("#chkbillable" + rowno).prop('checked', jsonimport[i].billable);
                        }

                        closediv();
                        isimport = "1";
                       
                    }
                    else {
                        alert("Error in Data Import!");
                        return;
                    }
                    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();

                }


            },
            error: function (x, e) {
                alert("The call to the server side failed. " + x.responseText);
                $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                return;
            }

        });

    }
    else {
        alert("Please fill required fields!");

    }

}


//End Import 





function opendiv() {
    setposition("divaddnew");
    document.getElementById("divaddnew").style.display = "block";
    document.getElementById("otherdiv").style.display = "block";


}
function closediv() {

    document.getElementById("divaddnew").style.display = "none";
    document.getElementById("otherdiv").style.display = "none";
    $('#divimport').hide();
    $('#divtaskdetail').hide();

}
function blank() {
    nid = "";
    $("#txttitle").val("");
    $("#hidproject").val("");
    $("#txtproject").val("");
    $("#dropbudTemplate").val("");
    $("#txtbudgettitle1").val("");
    $("#tblTask tbody").empty();
    document.getElementById("tdtotalhrs").innerHTML = "0.00";
    isimport = "";
    srttask = '';
    rowno = "";
}







function bindprojectautocompleter(inputid, hiddenid) {

    $("#" + inputid + "").autocomplete({

        selectFirst: true,
        delay: 0,
        mustMatch: true,
        autoFocus: true,
        source: jsonproject,
        select: function (event, ui) {

            $("#" + hiddenid + "").val(ui.item.value);
            $("#" + inputid + "").val(ui.item.label1);          

            return false;
        },
        change: function (event, ui) {


            $(this).val((ui.item ? ui.item.label1 : ""));
            $("#" + hiddenid + "").val((ui.item ? ui.item.value : ""));
           

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
        source: jsontask,
        select: function (event, ui) {

            $("#" + hiddenid + "").val(ui.item.value);
            $("#" + inputid + "").val(ui.item.label1);
            bindtaskvalue(hiddenid, ui.item == null ? "" : ui.item.value, ui.item == null ? "" : ui.item.CostRate, ui.item == null ? "" : ui.item.BillRate,
                ui.item == null ? "" : ui.item.BHours,
                ui.item == null ? "" : ui.item.isbillable,
                ui.item == null ? "" : ui.item.description);
            return false;

        },
        change: function (event, ui) {
            $(this).val((ui.item ? ui.item.label1 : ""));
            $("#" + hiddenid + "").val((ui.item ? ui.item.value : ""));
            bindtaskvalue(hiddenid, ui.item == null ? "" : ui.item.value, ui.item == null ? "" : ui.item.CostRate, ui.item == null ? "" : ui.item.BillRate,
                ui.item == null ? "" : ui.item.BHours,
                ui.item == null ? "" : ui.item.isbillable,
                ui.item == null ? "" : ui.item.description);


        },
        focus: function (event, ui) { event.preventDefault(); },
        open: function () {
            $('ul.ui-autocomplete').prepend('<li class="list-header" ><div class="ac_task1">Task ID</div><div class="ac_task2">Task</div></li>');
        }
    });
}

function bindtaskvalue(id, value, CostRate, BillRate, BHours, isbillable, description) {

    var rownum = id.replace('hidtask', '');
    rownum = rownum.replace('ddltask', '');

    if (value != "") {
        

        document.getElementById("txtdesc" + rownum).value = description;
        if (isbillable)
            document.getElementById("chkbillable" + rownum).checked = true;
        else
            document.getElementById("chkbillable" + rownum).checked = false;

        document.getElementById("txtbillrate" + rownum).value = BillRate;
        document.getElementById("txtbujhrs" + rownum).value = BHours;
        document.getElementById("txtcostrate" + rownum).value = CostRate;

    }
    else {
        document.getElementById("txtdesc" + rownum).value = "";
        document.getElementById("txtbillrate" + rownum).value = "";
        document.getElementById("txtbujhrs" + rownum).value = "";
        document.getElementById("txtcostrate" + rownum).value = "";
    }

}

function filldata() {

    var str = "",str1="<option value=''>New Budget</option>";
    $("#divview").show();
    $("#divview1").hide();
    $("#ctl00_ContentPlaceHolder1_progress1_UpdateProg1").show();
    $("#tbldata tbody").empty();
    $("#dropbudTemplate").empty();
    var args = { nid: "", projectid: "", companyid: $('#hidcompanyid').val() };
   
    $.ajax({

        type: "POST",
        url: pagename + "/getdata",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {

            if (data.d != "failure") {
                var jsonarr = $.parseJSON(data.d);

                if (jsonarr.length > 0) {


                    $.each(jsonarr, function (i, item) {

                        str = str + '<tr>';
                        str = str + '<td>' + item.budgetTitle + '</td>';
                        str = str + '<td><b>' + item.projectcode + '</b>: ' + item.projectname + '</td>';
                        str = str + '<td>' + item.budhrs + '</td>';
                        str = str + '<td>' + item.totalhours + '</td>';
                        str = str + '<td>' + item.fname + ' ' + item.lname + '</td>';
                        str = str + '<td>' + item.creationdate1 + '</td>';

                        str = str + '<td style="text-align:center" style="width:30px;"> <a  id="linkedit###' + item.projectcode + '###' + item.budgetTitle + '" onclick="ViewBuddetail(this.id,' + item.nid + ')" title="View Detail"><img src="images/view.png" /></a></td><td> <a  id="linkedit' + item.nid + '###' + item.projectid + '###' + item.projectcode + '###' + item.budgetTitle + '" onclick="getdetail(this.id,' + item.nid + ')" title="Edit Detail"><img src="images/edit.png" /></a></td> <td style="text-align:center" width="30"> <a id="linkdelete' + item.nid + '" onclick="deletebudget(' + item.nid + ')" title="Delete this record"><img src="images/delete.png" /></a></td></tr>';
                        str1 += '<option value="' + item.nid + '">' + item.budgetTitle + '</option>';

                    });

                }
                $("#tbldata tbody").append(str);
                $("#dropbudTemplate").append(str1);
                fn_MasterFixheaderNoPage("tbldata", [-3,-2, -1]);
                $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
            }


        },
        error: function (x, e) {
            alert("The call to the server side failed. " + x.responseText);
            $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
            return;
        }

    });



}

function ViewBuddetail(id, id2) {
    $("#ctl00_ContentPlaceHolder1_progress1_UpdateProg1").show();
    var str = "";  
    $("#tblBudgetDetail tbody").empty();
    var args = { nid: id2, projectid: "", companyid: $('#hidcompanyid').val() };
    var arr = id.split("###");
    var thrs = 0, bhrs = 0;
    $.ajax({

        type: "POST",
        url: pagename + "/getdataforDetail",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {

            if (data.d != "failure") {
                var jsonarr = $.parseJSON(data.d);

                if (jsonarr.length > 0) {

                  
                    $.each(jsonarr, function (i, item) {

                        str = str + '<tr>';
                        str = str + '<td>' + item.taskCode + ":" + item.taskname + '</td>';
                        str = str + '<td>' + item.description + '</td>';
                        str = str + '<td>' + item.billRate + '</td>';
                        str = str + '<td>' + item.payRate + '</td>';
                        str = str + '<td>' + item.budHrs + '</td>';
                        str = str + '<td>' + item.ahours + '</td>';
                        str = str + '</tr>';
                        thrs += parseFloat(item.ahours);
                        bhrs += parseFloat(item.budHrs);
                    });
                    $("#spanbuddetail").html(arr[2]);
                    $("#tblBudgetDetail tbody").append(str);
                    $("#tdtotalBhrs").html(bhrs.toFixed(2));
                    $("#tdtotalHhrs").html(thrs.toFixed(2));
                }
               
                setposition("divtaskdetail");
                $('#divtaskdetail').show();

                $('#otherdiv').show();

                $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();

            }


        },
        error: function (x, e) {
            alert("The call to the server side failed. " + x.responseText);
            $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
            return;
        }

    });

}

function getdetail(id,id2) {
    $("#ctl00_ContentPlaceHolder1_progress1_UpdateProg1").show();
    blank();
    var args = { nid: id2, projectid: "", companyid: $('#hidcompanyid').val() };
    var arr=id.split("###");
    $.ajax({

        type: "POST",
        url: pagename + "/getdata",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {

            if (data.d != "failure") {
                var jsonarr = $.parseJSON(data.d);

                if (jsonarr.length > 0) {

                    nid = id2;
                    $.each(jsonarr, function (i, item) {

                        addnewrow();

                        $("#hidbudTask_nid" + rowno).val(item.nid);
                        $("#ddltask" + rowno).val(item.taskCode + ":" + item.taskname);
                        $("#hidtask" + rowno).val(item.taskid);
                        $("#txtdesc" + rowno).val(item.description);
                        $("#txtbujhrs" + rowno).val(item.budHrs);
                        $("#txtbillrate" + rowno).val(item.billRate);
                        $("#txtcostrate" + rowno).val(item.payRate);
                        $("#chkbillable" + rowno).prop('checked', item.billable);

                    });
                    $("#txttitle").val(arr[3]);
                    $("#hidproject").val(arr[1]);
                    $("#txtproject").val(arr[2]);
                    $("#dropbudTemplate").val("");
                    $("#txtbudgettitle1").val(arr[3]);

                    $("#divview1").show();
                    $("#divview").hide();
                    calculatetotal();
                }

                $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
            }


        },
        error: function (x, e) {
            alert("The call to the server side failed. " + x.responseText);
            $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
            return;
        }

    });

}
function addnewrow() {
    var i = 0;
    if (rowno!="") {
        i = parseInt(rowno) + 1;

    }
    var str = '';

    str = str + '<tr id="tr_' + i + '"> <td align="center">';
    str = str + '<div id="divdel' + i + '"><a><img src="images/delete.png" onclick="deleterecord(' + i + ');"  /></a></div>';
    str = str + '<input type="hidden" id="hidbudTask_nid' + i + '" value="" /></td>';
    str = str + '<td><input type="text" id="ddltask' + i + '" class="form-control" /><input  type="hidden"  id="hidtask' + i + '"  /></td>';
    str = str + '<td><input type="text" id="txtdesc' + i + '" class="form-control" readonly/></td>';
    str = str + '<td><input type="text" id="txtbujhrs' + i + '" class="form-control" onblur="extractNumber(this,2,false);calculatetotal();" onkeyup="extractNumber(this,2,false);" /></td>';
    str = str + '<td><input type="text" id="txtbillrate' + i + '" class="form-control" onblur="extractNumber(this,2,false);" onkeyup="extractNumber(this,2,false);" /></td>';
    str = str + '<td><input type="text" id="txtcostrate' + i + '" class="form-control" onblur="extractNumber(this,2,false);" onkeyup="extractNumber(this,2,false);" /></td>';
    str = str + '<td style="text-align:center;"><input type="checkbox" id="chkbillable' + i + '" /></td>';
     str = str + '</tr>';

    var el = $(str);
    $('#tblTask > tbody:last').append(el);

    bindtaskautocompleter("ddltask" + i, "hidtask" + i);
    rowno = i.toString();

}
function calculatetotal() {
    var table = $("#tblTask tbody");
    var rowcount = $('#tblTask >tbody >tr').length;

    var totalhrs = 0.0;
   
    table.find('tr').each(function (i, el) {

        var id = $(this).attr('id');
        id = id.replace("tr_", "");

       
       var  newid = "txtbujhrs" + id;
        if (document.getElementById(newid).value != "" && !isNaN(document.getElementById(newid).value)) {
            totalhrs += parseFloat(document.getElementById(newid).value);
        }
    });
    
    document.getElementById("tdtotalhrs").innerHTML = totalhrs.toFixed(2);

}
function deletebudget(id) {

    if (confirm("Do you want to delete this record?")) {

        var args = { nid: id, companyid: $('#hidcompanyid').val() };
        $("#ctl00_ContentPlaceHolder1_progress1_UpdateProg1").show();
        $.ajax({

            type: "POST",
            url: pagename + "/deletedata",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            cache: false,
            success: function (data) {

                if (data.d != "failure") {
                    var jsonarr = $.parseJSON(data.d);
                    $('#ContentPlaceHolder1_progress1_UpdateProg1').hide();
                    if (jsonarr.length > 0) {
                        if (jsonarr[0].result == "1") {

                            $('#tbldata').DataTable().destroy();
                            filldata();
                          
                        }
                        else {

                            alert(jsonarr[0].msg);
                            $("#ctl00_ContentPlaceHolder1_progress1_UpdateProg1").hide();
                        }
                       
                    }

                }


            },
            error: function (x, e) {
                alert("The call to the server side failed. " + x.responseText);
                $("#ctl00_ContentPlaceHolder1_progress1_UpdateProg1").hide();
                return;
            }

        });
    }
}
function deleterecord(id) {
    if (confirm("Do you want to delete this record?")) {
       
        if ($("#hidbudTask_nid"+id).val() == "") {
            $('#tr_' + id).remove();
            calculatetotal();
        }
        else {
            var args = { nid: id, companyid: $('#hidcompanyid').val() };
            $("#ctl00_ContentPlaceHolder1_progress1_UpdateProg1").show();
            $.ajax({

                type: "POST",
                url: pagename + "/deleteTask",
                data: JSON.stringify(args),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                cache: false,
                success: function (data) {

                    if (data.d != "failure") {
                        var jsonarr = $.parseJSON(data.d);
                        $('#ContentPlaceHolder1_progress1_UpdateProg1').hide();
                        if (jsonarr.length > 0) {
                            if (jsonarr[0].result == "1") {


                                $('#tr_' + id).remove();
                            }
                            else {
                             
                                alert(jsonarr[0].msg);
                            }
                            $("#ctl00_ContentPlaceHolder1_progress1_UpdateProg1").hide();
                            calculatetotal();
                        }

                    }


                },
                error: function (x, e) {
                    alert("The call to the server side failed. " + x.responseText);
                    $("#ctl00_ContentPlaceHolder1_progress1_UpdateProg1").hide();
                    return;
                }

            });
        }

      
    }
}

function createBudgetTask(id) {

    $("#ctl00_ContentPlaceHolder1_progress1_UpdateProg1").show();
   
    var args = { nid: id, projectid: "", companyid: $('#hidcompanyid').val() };

    $.ajax({

        type: "POST",
        url: pagename + "/getdata",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {

            if (data.d != "failure") {
                var jsonarr = $.parseJSON(data.d);

                if (jsonarr.length > 0) {


                    $.each(jsonarr, function (i, item) {

                        addnewrow();
                        $("#ddltask"+rowno).val(item.taskCode + ":" + item.taskname);
                        $("#hidtask" + rowno).val(item.taskid);
                        $("#txtdesc" + rowno).val(item.description);
                        $("#txtbujhrs" + rowno).val(item.budHrs);
                        $("#txtbillrate" + rowno).val(item.billRate);
                        $("#txtcostrate" + rowno).val(item.payRate);
                        $("#chkbillable" + rowno).prop('checked', item.billable);

                    });

                }
                calculatetotal();
                $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
            }


        },
        error: function (x, e) {
            alert("The call to the server side failed. " + x.responseText);
            $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
            return;
        }

    });

}

function getTaskinTable() {
    //var rowcount = $('#tblTask tr').length;
    var status = 1;
    srttask = "[";
    var table = $("#tblTask tbody");   
    var rowcount = $('#tblTask >tbody >tr').length;
    table.find('tr').each(function (i, el) {

        var id = $(this).attr('id');
        id = id.replace("tr_", "");

        newid = "hidtask" + id;

        if (document.getElementById(newid).value == '') {
            newid = "ddltask" + id;
            document.getElementById(newid).style.borderColor = "red";
            status = 0;
        }
        else {
            newid = "ddltask" + id;
            document.getElementById(newid).style.borderColor = "#dadada";
           
        }
        newid = "txtbujhrs" + id;
        if (document.getElementById(newid).value == '') {           
            document.getElementById(newid).style.borderColor = "red";
            status = 0;
        }
        else {           
            document.getElementById(newid).style.borderColor = "#dadada";
           
        }
        newid = "txtbillrate" + id;
        if (document.getElementById(newid).value == '') {
            document.getElementById(newid).style.borderColor = "red";
            status = 0;
        }
        else {
            document.getElementById(newid).style.borderColor = "#dadada";
          
        }
        newid = "txtcostrate" + id;
        if (document.getElementById(newid).value == '') {
            document.getElementById(newid).style.borderColor = "red";
            status = 0;
        }
        else {
            document.getElementById(newid).style.borderColor = "#dadada";
          
        }
        var bill = "0";
        if (document.getElementById("chkbillable" + id).checked) {
            bill = "1";
        }
        srttask = srttask + "{'nid':'" + $("#hidbudTask_nid" + id).val() + "','taskid':'" + $("#hidtask" + id).val() + "','budHrs':'" + $("#txtbujhrs" + id).val() + "','billRate':'" + $("#txtbillrate" + id).val() + "','billable':'" + bill + "','payRate':'" + $("#txtcostrate" + id).val() + "'";
        if (i == rowcount) {
            srttask = srttask + "}";
        }
        else {
            srttask = srttask + "},";
        }
       

    });
    srttask = srttask + "]";
    if (status == 0)
        return false;
    else
        return true;
}

function saveBudget() {

    var status = 1;

    if ($("#hidproject").val() == "") {
        document.getElementById('txtproject').style.borderColor = "red";
        status = 0;
    }
    else {
        document.getElementById('txtproject').style.borderColor = "#dadada";
    }
    if ($("#txtbudgettitle1").val() == "") {
        document.getElementById('txtbudgettitle1').style.borderColor = "red";
        status = 0;
    }
    else {
        document.getElementById('txtbudgettitle1').style.borderColor = "#dadada";
    }

    if (!getTaskinTable()) {
        status = 0;
       
    }
    if ($('#tblTask >tbody >tr').length == 0) {
        alert("Add tasks in a project budget");
        status = 0;
    }

    if (status == 1) {

        var args = {
            nid: nid, projectid: $("#hidproject").val(), budgetTitle: $("#txtbudgettitle1").val(), createdby: $("#hidloginid").val(), companyid: $("#hidcompanyid").val(),
            tbl: srttask, isimport: isimport
        };


        $("#ctl00_ContentPlaceHolder1_progress1_UpdateProg1").show();

        $.ajax({

            type: "POST",
            url: pagename + "/savedata",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            cache: false,
            success: function (data) {

                if (data.d != "failure") {
                    var jsonarr = $.parseJSON(data.d);

                    if (jsonarr.length > 0) {

                        if (jsonarr[0].result == "1") {

                            $('#tbldata').DataTable().destroy();                          
                          
                            filldata();
                            alert('Saved Successfully!')
                        }
                        else {
                            alert(jsonarr[0].msg);
                        }
                    }
                    else {
                        alert("The call to the server side failed. ");

                    }


                }
                else {
                    alert(data.d);
                }

            },
            error: function (x, e) {
                alert("The call to the server side failed. " + x.responseText);
                showbuttonloader('btnsave', 'e');
                return;
            }

        });

    }
}

$(document).ready(function () {

       var args = { prefixText: "", companyid: $("#hidcompanyid").val() };
    $.ajax({

        type: "POST",
        url: "projectBudget.aspx/getProjects",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {
            //Check length of returned data, if it is less than 0 it means there is some status available
            if (data.d != "failure") {
                jsonproject = $.parseJSON(data.d);
                //Call project autocompleter
                bindprojectautocompleter("txtproject", "hidproject");

            }
        }
    });

    //------------------------Get tasks from script methdo and put values to an array for autocompleter
    var args = { companyid: $("#hidcompanyid").val() };
    $.ajax({

        type: "POST",
        url: "projectBudget.aspx/getTasks",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {
            //Check length of returned data, if it is less than 0 it means there is some status available
            if (data.d != "failure") {
                jsontask = $.parseJSON(data.d);
                // bindtaskautocompleter("ddltask0", "hidtask0");

            }
        }
    });



    $("#linkaddnew").click(function () {
        blank();
        opendiv();
    });
    $("#addmore").click(function () {
        addnewrow();
    });
    $("#linkback").click(function () {
        $("#divview").show();
        $("#divview1").hide();
    });
    $("#linksubmit").click(function () {
        saveBudget();
    });
    $("#linkimport").click(function () {
        openimport();
    });
    $("#btnexport").click(function () {
        var str = "<table>"+$("#tblBudgetDetail").html()+"</table>";
        var el = $(str);

        el.table2excel({
            name: "Budget",
            filename: "Budget"

        });
    });
    $("#btncreatebudget").click(function () {
        var status = 1;

        if ($("#hidproject").val() == "") {
            document.getElementById('txtproject').style.borderColor = "red";
            status = 0;
        }
        else {
            document.getElementById('txtproject').style.borderColor = "#dadada";
        }
        if ($("#txttitle").val() == "") {
            document.getElementById('txttitle').style.borderColor = "red";
            status = 0;
        }
        else {
            document.getElementById('txttitle').style.borderColor = "#dadada";
        }

        if (status == 1) {
            $("#txtbudgettitle1").val($("#txttitle").val());
            if ($("#dropbudTemplate").val() == "") {
                addnewrow();
            }
            else {
                createBudgetTask($("#dropbudTemplate").val());
            }
            $("#divview1").show();
            $("#divview").hide();
            closediv();
        }
        
    });

    filldata();
});