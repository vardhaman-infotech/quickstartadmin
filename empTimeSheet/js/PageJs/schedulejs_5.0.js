var pagename = "ClientSchedule.aspx";
var flag = 0, dropid = '';
var schDet_clientid = "", schDet_projectid = "", schDet_empid = "", schDet_status = "", schDet_date = "", schDet_type = "", schDet_Groupid = "";
var sch_nid = "", sch_action = '', sch_emailRecName = '', sch_EmailRec = '';
var opendivid = '';

function fillclient() {
    flag = flag + 1;
    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
    var args = { companyid: $('#hidcompanyid').val() };
    $.ajax({

        type: "POST",
        url: pagename + "/getClient",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {
            //Check length of returned data, if it is less than 0 it means there is some status available
            if (data.d != "failure") {
                var json = $.parseJSON(data.d);
                //Call project autocompleter
                bindAutoCompleteClient("drppopclient", json, "hiddropclient");
                //  Masterfillcity(cityid,dropid);

                flag = flag - 1;

                if (flag == 0) {
                    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                }

            }
        },
        error: function (x, e) {
            alert("The call to the server side failed. " + x.responseText);

            return;
        }
    });
}
function fillProject() {


    if ($('#hiddropclient').val() != "") {
        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
        var args = { companyid: $('#hidcompanyid').val(), clientid: $('#hiddropclient').val() };
        $.ajax({

            type: "POST",
            url: pagename + "/getProject",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            cache: false,
            success: function (data) {
                //Check length of returned data, if it is less than 0 it means there is some status available
                if (data.d != "failure") {
                    var jsonarr = $.parseJSON(data.d);

                    //Call project autocompleter
                    bindAutoCompleteProject("ddlproject", jsonarr, "hidddlproject");
                    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                }
            }
            ,
            error: function (x, e) {
                alert("The call to the server side failed. " + x.responseText);

                return;
            }
        });
    }

}
function bindAutoCompleteClient(inputid, jsonarr, hiddenid) {
    
   

    $("#" + inputid + "").autocomplete({

        selectFirst: true,
        delay: 0,
        mustMatch: true,
        autoFocus: true,
        source: jsonarr,
        minLength: 0,
        select: function (event, ui) {
          
            $("#" + hiddenid + "").val(ui.item.value);
            $("#" + inputid + "").val(ui.item.clientname);


            return false;
        },
        change: function (event, ui) {
           
            $(this).val((ui.item ? ui.item.clientname : ""));
            $("#" + hiddenid + "").val((ui.item ? ui.item.value : ""));

            $("#ddlproject").val("");
            $("#hidddlproject").val("");
            $('#ddlproject').autocomplete({ source: [] }).focus(function () {
                // The following works only once.
                // $(this).trigger('keydown.autocomplete');
                // As suggested by digitalPBK, works multiple times
                // $(this).data("autocomplete").search($(this).val());
                // As noted by Jonny in his answer, with newer versions use uiAutocomplete
                $(this).data("uiAutocomplete").search($(this).val());
            });

            if ($(this).val != '') {

                fillProject();
            }


        },
        focus: function (event, ui) { event.preventDefault(); }
    }).focus(function () {
        //Use the below line instead of triggering keydown
        $(this).autocomplete("search");
    });
}


function bindAutoCompleteProject(inputid, jsonarr, hiddenid) {

    $("#" + inputid + "").autocomplete({

        selectFirst: true,
        delay: 0,
        mustMatch: true,
        autoFocus: true,
        source: jsonarr,
        minLength: 0,
        select: function (event, ui) {

            $("#" + hiddenid + "").val(ui.item.value);
            $("#" + inputid + "").val(ui.item.projectname);
            return false;
        },
        change: function (event, ui) {

            $(this).val((ui.item ? ui.item.projectname : ""));
            $("#" + hiddenid + "").val((ui.item ? ui.item.value : ""));

        },
        focus: function (event, ui) { event.preventDefault(); },
        open: function () {
            $('ul.ui-autocomplete').prepend('<li class="list-header" ><div class="ac_project1">Project ID</div><div class="ac_project2">Project</div><div class="ac_project3">Client ID</div></li>');
        }
    }).focus(function () {
        //Use the below line instead of triggering keydown
        $(this).autocomplete("search");
    });
    if ($("#" + inputid + "").val() == "") {
        $("#" + inputid + "").autocomplete("search");
    }
}

function fillemployee() {
    flag = flag + 1;
    var str = "";
    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
    var args = { companyid: $('#hidcompanyid').val() };
    $.ajax({

        type: "POST",
        url: pagename + "/getEmployee",
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

                        str += '  <li><input type="checkbox" name="chkemp" value="' + item.nid + '" /><a>' + item.username + '</a></li>';


                    });

                }
                $("#" + "dropemp" + "_detail ul").append(str);
                $("#" + "dropemp1" + "_detail ul").append(str);

                var strx = "";
                $("#ctl00_ContentPlaceHolder1_dropclient > option").each(function () {
                   
                    strx += '  <li><input type="checkbox" name="chkclient" value="' + $(this).val() + '" /><a>' + $(this).text() + '</a></li>';
                });
                $("#" + "dropclint" + "_detail ul").append(strx);

                activateSearch();
                flag = flag - 1;
                if (flag == 0) {
                    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();

                }


            }


        },
        error: function (x, e) {
            alert("The call to the server side failed. " + x.responseText);
            $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
            return;
        }

    });
}
function activateSearch() {


    $(".dropctrl").click(function () {
        dropid = $(this).attr("id");

        var $clicked = $('#' + dropid + '_detail')
        if ($clicked.is(':visible')) {
            $(".droplist").slideUp();


        }
        else {
            $(".droplist").hide();
            $clicked.slideDown()
        }
    });


     


    $(document).bind('click', function (e) {
        var $clicked = $(e.target);
        if (!$clicked.parents().parents().hasClass("divdrop") && !$clicked.hasClass("dropctrl")) {
            dropid = '';
            $(".droplist").hide();
        }

    });






    $(".droplist ul li").click(function (e) {
        var val = $(this).find("input").val();
        var val1 = $(this).find("a").html();
        var newid = dropid + "span" + val;
        if ($(this).find("input").is(':checked')) {
            $(this).find("input").prop('checked', false);

            $('span[id="' + newid + val + '"]').remove();
            if ($('#' + dropid).html() == "") {
                $('#' + dropid).html("All");
            }


        }
        else {
            $(this).find("input").prop('checked', true);
            if ($('#' + dropid).html() == "All") {
                $('#' + dropid).html("");
            }

            $('#' + dropid).append('<span id="' + newid + val + '"> ' + val1 + ',<span>');
        }


    });
    $(".droplist ul li input").click(function () {
        var val = $(this).val();
        var val2 = $(this).parent().find("a").html();
        var newid = dropid + "span" + val;

        if ($(this).is(':checked')) {
            $(this).prop('checked', false);


            $('span[id="' + newid + val + '"]').remove();
            if ($('#' + dropid).html() == "") {
                $('#' + dropid).html("");
            }
        }
        else {
            $(this).prop('checked', true);
            if ($('#' + dropid).html() == "") {
                $('#' + dropid).html("");
            }
            $('#' + dropid).append('<span id="' + newid + val + '"> ' + val2 + ',<span>');
        }


    });
    $('.txtdate').datepicker();

    $(".hasDatepicker").change(function () {
        checkdate($(this).val(), $(this).attr("id"));
    });

}
function showhidestatus() {
    $('#drppopstatus').val('');
    if (document.getElementById("rdbtnscheduleType").value == "Field") {
        $('#drppopstatus').attr('disabled', false);
        $("#lbldefstatus").html(" Default Status :  *");


    }
    else {
        $('#drppopstatus').attr('disabled', true);
        $("#lbldefstatus").html(" Default Status :  ");

    }

}

function validateschedule() {
    var status = 1;
    var chkstatus = 0;
    if (document.getElementById('txtpopfrdate').value == '') {
        document.getElementById('txtpopfrdate').style.borderColor = "red";
        status = 0;
    }
    else {
        document.getElementById('txtpopfrdate').style.borderColor = "#cdcdcd";
    }
    if (sch_nid == "") {
        if (document.getElementById('txtpoptodate').value == '') {
            document.getElementById('txtpoptodate').style.borderColor = "red";
            status = 0;
        }
        else {
            document.getElementById('txtpoptodate').style.borderColor = "#cdcdcd";
        }

    }

    if (sch_nid == "" && document.getElementById('rdbtnscheduleType').value == "Field") {
        if (document.getElementById('drppopstatus').value == '') {
            document.getElementById('drppopstatus').style.borderColor = "red";
            status = 0;
        }
        else {
            document.getElementById('drppopstatus').style.borderColor = "#cdcdcd";
        }

    }
    if (document.getElementById('hiddropclient').value == '') {
        document.getElementById('drppopclient').style.borderColor = "red";
        status = 0;
    }
    else {
        document.getElementById('drppopclient').style.borderColor = "#cdcdcd";
    }
    if (document.getElementById('hidddlproject').value == '') {
        document.getElementById('ddlproject').style.borderColor = "red";
        status = 0;
    }
    else {
        document.getElementById('ddlproject').style.borderColor = "#cdcdcd";
    }

    var ul = $("#" + "dropemp" + "_detail ul");
    ul.find('li').each(function (i, el) {
        if ($(this).find("input").is(':checked')) {
            chkstatus = 1;
        }
    });

    if (status == 1 && chkstatus == 1) {
        return true;
    }
    else {
        if (chkstatus == 0) {
            alert("Select employees  for schedule!")
        }
        return false;
    }

}

function saveScheduleData() {
    
    if (validateschedule()) {

        var strempid = "", strstatus = "", strschtype = "";
        if (sch_nid == "") {


            if (document.getElementById('rdbtnscheduleType').value == "Field")
                strstatus = $("#drppopstatus").val();
            else
                strstatus = "";

        }
        else {
            strstatus = schDet_status;
        }

        if (sch_nid == "") {
            strschtype = document.getElementById('rdbtnscheduleType').value;
        }
        else {
            strschtype = schDet_type;
        }
        var ul = $("#" + "dropemp" + "_detail ul");
        ul.find('li').each(function (i, el) {
            if ($(this).find("input").is(':checked')) {
                strempid += $(this).find("input").val() + ',';
            }
        });


        var args = {
            action: sch_action, companyid: $("#hidcompanyid").val(), nid: sch_nid, empid: strempid, clientid: $("#hiddropclient").val(),
            fromdate: $("#txtpopfrdate").val(), todate: $("#txtpoptodate").val(), time: $("#drppophour").val(), status: strstatus, remark: $("#txtaddremark").val(),
            createdby: $("#hidchatloginid").val(), groupid: schDet_Groupid, projectid: $("#hidddlproject").val(), scheduletype: strschtype

        };



        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();

        $.ajax({

            type: "POST",
            url: pagename + "/saveSchedule",
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


                            $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                            closediv();
                            filldata();
                            refereshcalendar();
                            alert('Saved Successfully!')
                        }
                        else {
                            $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                            alert(jsonarr[0].msg);
                        }
                    }
                    else {
                        alert("The call to the server side failed. ");

                    }


                }
                else {
                    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                    alert(data.d);

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
        alert('Please fill required fields!');
        return;
    }
}

function blank() {
    sch_nid = "";
    sch_action = "One";
    $('#txtpopfrdate').val('');
    $('#txtpoptodate').val('');
    $('#drppophour').val('');
    $('#rdbtnscheduleType').val('Field');
    $('#rdbtnscheduleType').attr('disabled', false);
    $('#drppopclient').val('');
    $('#ddlproject').val('');
    $('#hiddropclient').val('');
    $('#hidddlproject').val('');
    $(".droplist ul li input").prop('checked', false);
    $('#dropemp').html("");
    $('#drppopstatus').val('');
    $('#drppopstatus').attr('disabled', false);
    $("#lbldefstatus").html(" Default Status :  *");
    $("#lblfromdate").html(" From Date :  *");
    $('#txtaddremark').val('');
    $('#divtodate').show();
    $('#divdefaultstatus').show();

}
function opendiv(id) {
    opendivid = id;
    setposition(id);
    $('#otherdiv').fadeIn("slow");
    $('#' + id).fadeIn("slow");


}
function closeSchBackdiv() {
    $('#schBackOtherdiv').hide();
    $('#divstatus').hide();
}
function closediv() {
    if (opendivid != "") {
        if (document.getElementById(opendivid) != null) {
            $('#' + opendivid).hide();
            $('#otherdiv').hide();

        }
    }

}
function filldata() {

    var str = "";
    $("#tbldata tbody").empty();
    var args = {
        companyid: $('#hidcompanyid').val(), fromdate: $('#txtfrmdate').val(), todate: $('#txttodate').val(), status: $('#dropstatus').val(),
        schtype: "", client: "", project: ""
    };
    $('#divdataloader').show();
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
                if (data.d != "") {
                    $("#divschdata").html(data.d);


                    $(".linkschedit").click(function () {
                        var newid = $(this).attr("id");
                        newid = newid.replace("linkschedit", "");
                        getdetailforEdit(newid);
                    });
                    $(".dateviewdet").click(function () {
                        var newid = $(this).attr("id");
                        newid = newid.replace("dateviewdet", "");
                        getdetail(newid);
                    });

                    $(".linkschview").click(function () {
                        var newid = $(this).attr("id");
                        newid = newid.replace("linkschview", "");
                        getdetail(newid);
                    });

                    $(".linkschemail").click(function () {
                        var newid = $(this).attr("id");
                        newid = newid.replace("linkschemail", "");
                        getDetailForEmail(newid);
                    });
                    $(".linkschdelete").click(function () {
                        var newid = $(this).attr("id");
                        newid = newid.replace("linkschdelete", "");
                        sch_action = "group";
                        sch_nid = $("#hidschnid" + newid).val();
                        deleterecord($("#hidschnid" + newid).val());
                    });
                    $(".linkschstatus").click(function () {
                        var newid = $(this).attr("id");
                        newid = newid.replace("linkschstatus", "");

                        var arr = String($("#hidschid" + newid).val()).split("#");

                        sch_action = "group";
                        sch_nid = $("#hidschnid" + newid).val();
                        schDet_clientid = arr[1];
                        schDet_projectid = arr[2];
                        schDet_status = arr[5];
                        schDet_empid = arr[6];
                        schDet_date = arr[0];
                        schDet_type = arr[4];
                        schDet_Groupid = arr[3];
                        $('#ddlstaus').val('');
                        $("#txtnewdate").val('');
                        $("#txtremark").val('');
                        setposition('divstatus');
                        $('#schBackOtherdiv').fadeIn("slow");
                        $('#divstatus').fadeIn("slow");
                        $('#divdate').hide();


                    });
                }
                else {
                    $("#divschdata").html(" <div class='nodatafound'> No schedule exists</div>");

                }
                $('#divdataloader').hide();

            }


        },
        error: function (x, e) {
            alert("The call to the server side failed. " + x.responseText);
            $('#divdataloader').hide();
            return;
        }

    });

}

function fillExportdata() {

    var str = "";

    var args = {
        companyid: $('#hidcompanyid').val(), fromdate: $('#txtfrmdate').val(), todate: $('#txttodate').val(), status: $('#dropstatus').val(),
        schtype: "", client: "", project: ""
    };
    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
    $.ajax({

        type: "POST",
        url: pagename + "/getExportdata",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {

            if (data.d != "failure") {
                if (data.d != "") {

                    var el = $(data.d);

                    el.table2excel({
                        name: "Client Schedule",
                        filename: "Client Schedule"

                    });


                }
                else {
                    alert("No Data Found!");
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
function changeGroupStatus() {
    var status = 1;
    var chkstatus = 0;
    if (document.getElementById('ddlstaus').value == '') {
        document.getElementById('ddlstaus').style.borderColor = "red";
        status = 0;
    }
    else {
        document.getElementById('ddlstaus').style.borderColor = "#dadada";
    }

    if (document.getElementById('ddlstaus').value == 'Re-Schedule') {
        if (document.getElementById('txtnewdate').value == '') {
            document.getElementById('txtnewdate').style.borderColor = "red";
            status = 0;
        }
        else {
            document.getElementById('txtnewdate').style.borderColor = "#dadada";
        }

    }



    if (status == 1) {
        var args = {
            companyid: $('#hidcompanyid').val(), nid: sch_nid, action: sch_action, empid: schDet_empid, projectid: schDet_projectid, groupid: schDet_Groupid, newdate: $("#txtnewdate").val(), status: $("#ddlstaus").val(),
            remark: $("#txtremark").val(), createdby: $("#hidchatloginid").val()
        };
        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
        $.ajax({

            type: "POST",
            url: pagename + "/changeStatus",
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


                            closeSchBackdiv();
                            closediv();
                            filldata();

                            alert("Status updated successfully!");
                        }
                        else {

                            alert(jsonarr[0].msg);
                        }

                        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                    }

                }
                else {
                    location.href = "logout.aspx";
                }


            },
            error: function (x, e) {
                alert("The call to the server side failed. " + x.responseText);
                $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                return;
            }

        });
    }
}

function deleterecord(id) {

    if (confirm("Do you want to delete this record?")) {
        var args = { companyid: $('#hidcompanyid').val(), nid: id, action: sch_action };
        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
        $.ajax({

            type: "POST",
            url: pagename + "/deleteGroupSchedule",
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


                            closeSchBackdiv();
                            closediv();
                            filldata();

                            alert("Record deleted successfully!");
                        }
                        else {

                            alert(jsonarr[0].msg);
                        }
                        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                    }

                }
                else {
                    location.href = "logout.aspx";
                }


            },
            error: function (x, e) {
                alert("The call to the server side failed. " + x.responseText);
                $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                return;
            }

        });
    }
}


function getdetailforEdit(id, xnid) {
    
    blank();
    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
    var args = { companyid: $('#hidcompanyid').val(), nid: $("#hidschnid" + id).val() };
    if (xnid === undefined) {
        args = { companyid: $('#hidcompanyid').val(), nid: $("#hidschnid" + id).val() };
    } else {
        args = { companyid: $('#hidcompanyid').val(), nid: xnid };
    }
    //var args = { companyid: $('#hidcompanyid').val(), nid: $("#hidschnid" + id).val() };

    $.ajax({

        type: "POST",
        url: pagename + "/getDetailData",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {

            if (data.d != "failure") {
                
                var jsonarr = $.parseJSON(data.d);
                

                if (jsonarr.length > 0) {

                    var arr = String($("#hidschid" + id).val()).split("#");

                    sch_action = "group";
                    sch_nid = jsonarr[0].nid;// $("#hidschnid" + id).val();
                    
                    schDet_status = jsonarr[0].status;//arr[5];
                    schDet_empid = jsonarr[0].empid;// arr[6];
                    schDet_date = jsonarr[0].date;//arr[0];
                    schDet_type = jsonarr[0].scheduletype;//arr[4];
                    schDet_Groupid = jsonarr[0].groupid;// arr[3];

                    $('#txtpopfrdate').val(jsonarr[0].date);
                    $('#drppophour').val(jsonarr[0].time);
                    $('#rdbtnscheduleType').val(jsonarr[0].scheduletype);
                    $('#rdbtnscheduleType').attr('disabled', true);
                    $('#hiddropclient').val(jsonarr[0].clientid);
                    $('#drppopclient').val(jsonarr[0].clientname);
                    fillProject();

                    $('#ddlproject').val(jsonarr[0].projectname);
                    $('#hidddlproject').val(jsonarr[0].projectid);


                    $('#drppopstatus').attr('disabled', true);
                    $("#lblfromdate").html("Date :  *");
                    $('#txtaddremark').val(jsonarr[0].remark);
                    $('#divtodate').hide();
                    $('#divdefaultstatus').hide();




                    $.each(jsonarr, function (i, item) {


                        var ul = $("#" + "dropemp" + "_detail ul");
                        ul.find('li').each(function (j, el) {
                            if ($(this).find("input").val() == item.empid) {
                                $(this).find("input").prop('checked', true);

                                var val = item.empid;
                                var newid = "dropemp" + "span" + item.empid;
                                $('#dropemp').append('<span id="' + newid + val + '"> ' + item.empname + ',<span>');
                            }
                        });



                    });



                    opendiv("divaddnew");

                    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();



                }





            }


        },
        error: function (x, e) {
            alert("The call to the server side failed. " + x.responseText);
            $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
            return;
        }

    });



}
function getdetail(id) {
    $("#tblschdetail tbody").empty();
    $("#divschdes").empty();
    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
    var arr = String($("#hidschid" + id).val()).split("#");
    var str = '';
    var args = { companyid: $('#hidcompanyid').val(), nid: $("#hidschnid" + id).val() };

    $.ajax({

        type: "POST",
        url: pagename + "/getDetailData",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {

            if (data.d != "failure") {

                var jsonarr = $.parseJSON(data.d);


                if (jsonarr.length > 0) {

                    schDet_clientid = arr[1];
                    schDet_projectid = arr[2];
                    schDet_status = arr[5];
                    schDet_empid = arr[6];
                    schDet_date = arr[0];
                    schDet_type = arr[4];
                    schDet_Groupid = arr[3];
                    sch_nid = $("#hidschnid" + id).val();
                    str += '<div class="pop_datebox"><div class="pop_datebox_inner" id="pop_datebox_inner"><div class="datedetail">' + jsonarr[0].wDname + ' <span>' + jsonarr[0].theDay + ' ' + jsonarr[0].theMonth + ' </span></div>\
                        <div class="monthdetail">' + jsonarr[0].theYear + ' </div></div></div>\
                <div class="pop_detail"><h1> ' + jsonarr[0].clientname + ' </h1><p>' + jsonarr[0].projectname + '</p></div>';

                    $("#divschdes").html(str);
                    str = "";

                    $.each(jsonarr, function (i, item) {

                        str = str + '<tr>';
                        str = str + '<td>' + item.empname + '</td>';
                        str = str + '<td>' + item.scheduletype + '</td>';
                        str = str + '<td>' + item.status + '</td>';
                        str = str + '<td>' + item.remark + '</td>';

                        str = str + '<td style="text-align:center;"><a class="lnkDelIncSch" id="lnkDelIncSch' + item.nid + '"  title="Delete this record"><img src="images/delete.png" /></a></td><td style="text-align:center;"><a class="lnkStatInvSch" id="lnkStatInvSch' + item.nid + '_' + item.empid + '"  title="Modify Status"><img src="images/imp-shrtct-icon.png" /></a></td> </tr>';


                    });


                    $("#tblschdetail tbody").append(str);
                    opendiv("divSchDetail");
                    $(".lnkStatInvSch").click(function () {
                        var newid = $(this).attr("id");
                        newid = newid.replace("lnkStatInvSch", "");

                        var arr1 = newid.split('_');

                        sch_action = "one";
                        sch_nid = arr1[0];
                        schDet_empid = arr1[1];
                        $('#ddlstaus').val('');
                        $("#txtnewdate").val('');
                        $("#txtremark").val('');

                        setposition('divstatus');
                        $('#divdate').hide();
                        $('#schBackOtherdiv').fadeIn("slow");
                        $('#divstatus').fadeIn("slow");
                    });
                    $(".lnkDelIncSch").click(function () {
                        var newid = $(this).attr("id");
                        newid = newid.replace("lnkDelIncSch", "");
                        sch_action = "one";
                        deleterecord(newid);
                    });

                    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();



                }





            }


        },
        error: function (x, e) {
            alert("The call to the server side failed. " + x.responseText);
            $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
            return;
        }

    });



}
function showdate(val) {
    if (val == "Re-Schedule") {
        document.getElementById("divdate").style.display = "block";
    }
    else {
        document.getElementById("divdate").style.display = "none";
    }
}

function getDetailForEmail(id) {
    var args = { companyid: $('#hidcompanyid').val(), nid: $("#hidschnid" + id).val() };
    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();



    $.ajax({

        type: "POST",
        url: pagename + "/generateemail",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {

            if (data.d != "failure") {
                var jsonarr = String(data.d).split("####");

                if (jsonarr.length > 0) {
                    if (jsonarr[0] == "1") {

                        opendiv("divSchEmail");
                        sch_emailRecName = jsonarr[1];
                        sch_EmailRec = jsonarr[2];
                        $('#txtreceiver').val(jsonarr[2]);
                        $('#txtsubject').val(jsonarr[3]);

                        var htmlEditor = $find("ctl00_ContentPlaceHolder1_htmleditor1");

                        htmlEditor.set_content(jsonarr[4]);

                    }
                    else {

                        alert(jsonarr[1]);
                    }
                    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                }

            }


        },
        error: function (x, e) {
            alert("The call to the server side failed. " + x.responseText);
            $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
            return;
        }

    });
}
function sendemail() {
    var status = 1, chkstatus = 0;
    if (document.getElementById('txtreceiver').value == '') {
        document.getElementById('txtreceiver').style.borderColor = "red";
        status = 0;
    }
    else {
        document.getElementById('txtreceiver').style.borderColor = "#dadada";
    }
    if (document.getElementById('txtsubject').value == '') {
        document.getElementById('txtsubject').style.borderColor = "red";
        status = 0;
    }
    else {
        document.getElementById('txtsubject').style.borderColor = "#dadada";
    }

    if (status == 1) {
        var htmlEditor = $find("ctl00_ContentPlaceHolder1_htmleditor1");


        var args = { receiver: sch_EmailRec, subject: $('#txtsubject').val(), detail: htmlEditor.get_content(), companyid: $('#hidcompanyid').val() };
        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
        $.ajax({

            type: "POST",
            url: pagename + "/sendScheduletoMail",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            cache: false,
            success: function (data) {

                if (data.d == "1") {


                    closediv();
                    alert("Email Send Successfully!");


                }
                else {

                    alert(data.d);
                }
                $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();

            },
            error: function (x, e) {
                alert("The call to the server side failed. " + x.responseText);
                $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                return;
            }

        });

    }

}


$(document).ready(function () {

    fillclient();
    fillemployee();

    //$("#txtfrmdate").datepicker();
    //$("#txttodate").datepicker();
    $("#txtnewdate").datepicker();

    //sls
    //$("#txtpopfrdate").datepicker();
    //$("#txtpoptodate").datepicker();



    $("#txtfrmdate").datepicker({
        dateFormat: "mm/dd/yy",

        onSelect: function () {
            var dt2 = $('#txttodate');
            var startDate = $(this).datepicker('getDate');
            //add 30 days to selected date
            startDate.setDate(startDate.getDate() + 30);
            var minDate = $(this).datepicker('getDate');
            var dt2Date = dt2.datepicker('getDate');
            //difference in days. 86400 seconds in day, 1000 ms in second
            var dateDiff = (dt2Date - minDate) / (86400 * 1000);

            //dt2 not set or dt1 date is greater than dt2 date
            if (dt2Date == null || dateDiff < 0) {
                dt2.datepicker('setDate', minDate);
            }
                //dt1 date is 30 days under dt2 date
            else if (dateDiff > 30) {
                dt2.datepicker('setDate', startDate);
            }
            //sets dt2 maxDate to the last day of 30 days window
            // dt2.datepicker('option', 'maxDate', startDate);
            //first day which can be selected in dt2 is selected date in dt1
            dt2.datepicker('option', 'minDate', minDate);
        }
    });
    $('#txttodate').datepicker({
        dateFormat: "mm/dd/yy",

    });

    $("#txtpopfrdate").datepicker({
        dateFormat: "mm/dd/yy",
        minDate: 0,
        onSelect: function () {
            var dt2 = $('#txtpoptodate');
            var startDate = $(this).datepicker('getDate');
            //add 30 days to selected date
            startDate.setDate(startDate.getDate() + 30);
            var minDate = $(this).datepicker('getDate');
            var dt2Date = dt2.datepicker('getDate');
            //difference in days. 86400 seconds in day, 1000 ms in second
            var dateDiff = (dt2Date - minDate) / (86400 * 1000);

            //dt2 not set or dt1 date is greater than dt2 date
            if (dt2Date == null || dateDiff < 0) {
                dt2.datepicker('setDate', minDate);
            }
                //dt1 date is 30 days under dt2 date
            else if (dateDiff > 30) {
                dt2.datepicker('setDate', startDate);
            }
            //sets dt2 maxDate to the last day of 30 days window
            dt2.datepicker('option', 'maxDate', startDate);
            //first day which can be selected in dt2 is selected date in dt1
            dt2.datepicker('option', 'minDate', minDate);
        }
    });
    $('#txtpoptodate').datepicker({
        dateFormat: "mm/dd/yy",
        minDate: 0
    });

    $('#drppophour').timepicker({

        interval: 30,
        timeFormat: 'h:i A'
    }

    );

    var someDate = new Date();
    $("#txtfrmdate").val(setDateFromat(someDate.setDate(someDate.getDate() + 0)));
    $("#txttodate").val(setDateFromat(someDate.setDate(someDate.getDate() + 30)));




    $(".hasDatepicker").change(function () {
        checkdate($(this).val(), $(this).attr("id"));
    });
    $("#btnsearch").click(function () {
        filldata();
        refereshcalendar();

    });
    $("#btnexportcsv").click(function () {
        fillExportdata();

    });
    $("#btnsavestatus").click(function () {
        changeGroupStatus();

    });
    $("#btnsubmit").click(function () {
        saveScheduleData();

    });
    $("#btnsendEmail").click(function () {
        sendemail();

    });
    filldata();

});