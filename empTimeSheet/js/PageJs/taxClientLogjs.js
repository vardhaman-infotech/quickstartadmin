var json;
var jsontasks;
var pagename = "taxClientLog.aspx"


function fillproject() {
    $("#ctl00_ContentPlaceHolder1_txttaxclient").empty();
    $('#divdata').hide();
    if (document.getElementById("ctl00_ContentPlaceHolder1_txtyear").value != "") {
        var args = { taxyear: document.getElementById("ctl00_ContentPlaceHolder1_txtyear").value, companyid: document.getElementById("hidcompanyid").value };

        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
        $.ajax({

            type: "POST",
            url: pagename + "/getProjects",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            cache: false,
            success: function (data) {

                if (data.d != "failure") {
                    var jsonarr = $.parseJSON(data.d);
                    $("#ctl00_ContentPlaceHolder1_txttaxclient").append("<option value='' selected='selected'>" + "--Select--" + "</option>");
                    if (jsonarr.length > 0) {


                        $.each(jsonarr, function (i, item) {


                            $("#ctl00_ContentPlaceHolder1_txttaxclient").append("<option value=" + item.nid + ">" + item.name + "</option>");
                        });

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

}
function filltaxlog() {

    $('#divdata').hide();
    $("#tblogdata").empty();
    if (document.getElementById("ctl00_ContentPlaceHolder1_txttaxclient").value != "") {
        var str = "";

        str = '<table width="100%" class="tblReport " id="tblogdata"><tr><th width="30px"></th><th>Action</th> \
                                                        <th width="16%">Updated By</th> <th width="17%">Last Modification Date</th> \
                                                        <th width="70px"></th></tr>';

        $('#divdata').show();

        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
        var args = { gettaxlog: document.getElementById("ctl00_ContentPlaceHolder1_txtyear").value, taxcompanyid: document.getElementById("ctl00_ContentPlaceHolder1_txttaxclient").value, companyid: document.getElementById("hidcompanyid").value };
        $.ajax({

            type: "POST",
            url: pagename + "/gettaxlog",
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
                            // Create and append the new options into the select list
                            var cls = "";
                            if (i == 0) {
                                cls = " class='log_firstrow' "
                            }
                            str += ' <tr ' + cls + '> <td><div id="divlogplus' + item.nid + '" class="divlogplus" \
                                    onclick="showlogdetail(this.id);"> </div></td> \
                                                        <td class="actionname" onclick="showlogdetail(&quot;divlogplus' + item.nid + '&quot;);">' + item.actionName +
                                                '</td>\
                                                        <td>' + item.fName + ' ' + item.lName + '</td>\
                                                        <td>' + item.modificationDate1 + '</td>\
                                                        <td><a onclick="edittaxlog(' + item.nid + ');"><i class="fa fa-fw"> \
                                                        <img src="images/edit-icon.png"></i></a>\
                                                            &nbsp; <a onclick="deletetaxlog(' + item.nid + ');">\
                                                            <i class="fa fa-fw"><img src="images/delete-icon.png"> </i></a> \
                                                            </td></tr>';
                            str += '<tr class="fieldboxtr" id="detail_divlogplus' + item.nid + '"><td></td><td colspan="4">\
                                        <div class="fieldbox2"><table width="100%">';
                            switch (item.actionId) {
                                case "1":
                                    str += "<tr><th>Medium</th><th>Date</th></tr>";
                                    str += "<tr><td>" + item.actionDetail + "</td><td>" + item.aDate + "</td></tr>";
                                    break;
                                case "2":
                                    str += "<tr><th>Medium</th><th>Date</th></tr>";
                                    str += "<tr><td>" + item.actionDetail + "</td><td>" + item.aDate + "</td></tr>";
                                    break;
                                case "3":
                                    str += "<tr><th>Comments</th><th>Date</th></tr>";
                                    str += "<tr><td>" + item.comments + "</td><td>" + item.aDate + "</td></tr>";
                                    break;
                                case "4":
                                    str += "<tr><th>Date</th><th>Prepared By</th></tr>";
                                    str += "<tr><td>" + item.aDate + "</td><td>" + item.actionbyfname + " "
                                        + item.actionbylname + "</td></tr>";
                                    break;
                                case "5":
                                    str += "<tr><th>Finalized by</th><th>Date</th></tr>";
                                    str += "<tr><td>" + item.actionbyfname + " " + item.actionbylname +
                                        "</td><td>" + item.aDate + "</td></tr>";
                                    break;
                                case "6":
                                    str += "<tr><th>Date Sent</th><th>Date Received</th></tr>";
                                    str += "<tr><td>" + item.aDate + "</td><td>" + item.recDate + "</td></tr>";
                                    break;
                                case "7":
                                    str += "<tr><th>Date </th></tr>";
                                    str += "<tr><td>" + item.aDate + "</td></tr>";
                                    break;
                                case "8":
                                    str += "<tr><th>Extension organizer sent</th><th>Date</th></tr>";
                                    str += "<tr><td>" + item.actionDetail + "</td><td>" + item.aDate + "</td></tr>";
                                    break;
                                case "9":
                                    str += "<tr><th>Date</th><th>Payement with extension</th><th>Amount Paid</th></tr>";
                                    str += "<tr><td>" + item.aDate + "</td><td>" + item.actionDetail + "</td><td>" + item.comments + "</td></tr>";
                                    break;
                                case "10":
                                    str += "<tr><th>Medium</th><th>Date</th></tr>";
                                    str += "<tr><td>" + item.actionDetail + "</td><td>" + item.aDate + "</td></tr>";
                                    break;
                            }
                            str += "</table></div></td></tr>";

                        });

                    }
                    str += '</table>';
                    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();

                    $("#tblogdata").html(str);
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

function showlogdetail(id) {
    var newid = '#detail_' + id;
    $(newid).fadeToggle();
    $('#' + id).toggleClass('divlogplus_expend', 300);

}
function showaction(chkid, id) {

    if (document.getElementById(chkid).checked) {
        $('#taxradion_divtaxlog_' + id).show(300);
    }
    else {
        $('#taxradion_divtaxlog_' + id).hide(300);

    }

}
function hideallaction() {
    $('.taxlogfieldbox').hide();
}
function savedata() {
    var taxCompanyID = "", actionId = "", aDate = "", actionDetail = "", comments = "", actionByID = "", recDate = "",
        createdby = "";
    taxCompanyID = document.getElementById("ctl00_ContentPlaceHolder1_txttaxclient").value;
    createdby = document.getElementById("hidloginid").value;

    var status = 1;


    var inputs = document.getElementsByName("radionbtnaction");
    var selected;
    for (var i = 0; i < inputs.length; i++) {
        if (inputs[i].checked) {
            selected = inputs[i];
            actionId = selected.value;
            break;
        }
    }
    if (actionId == "") {
        status = 0;
        alert("Select an action!");
        return;
    }
    actionId = "";
    for (var i = 0; i < inputs.length; i++) {

        if (inputs[i].checked) {
            selected = inputs[i];
            actionId += selected.value + "#";


            switch (selected.value) {
                case "1":
                    if (document.getElementById("ctl00_ContentPlaceHolder1_txtdate1").value == "") {
                        status = 0;
                        document.getElementById("ctl00_ContentPlaceHolder1_txtdate1").style.borderColor = "red";
                    }
                    else {
                        document.getElementById("ctl00_ContentPlaceHolder1_txtdate1").style.borderColor = "#cdcdcd";
                        aDate += document.getElementById("ctl00_ContentPlaceHolder1_txtdate1").value + '#';
                        actionDetail += document.getElementById("dropmediam1").value + '#';
                        recDate += "" + "#";
                        comments += "" + "#";
                        actionByID += "" + "#";
                    }
                    break;
                case "2":
                    if (document.getElementById("ctl00_ContentPlaceHolder1_txtdate2").value == "") {
                        status = 0;
                        document.getElementById("ctl00_ContentPlaceHolder1_txtdate2").style.borderColor = "red";
                    }
                    else {
                        document.getElementById("ctl00_ContentPlaceHolder1_txtdate2").style.borderColor = "#cdcdcd";
                        aDate += document.getElementById("ctl00_ContentPlaceHolder1_txtdate2").value + '#';
                        actionDetail += document.getElementById("dropmediam2").value + '#';
                        recDate += "" + "#";
                        comments += "" + "#";
                        actionByID += "" + "#";
                    }
                    break;
                case "3":
                    if (document.getElementById("ctl00_ContentPlaceHolder1_txtdate3").value == "") {
                        status = 0;
                        document.getElementById("ctl00_ContentPlaceHolder1_txtdate3").style.borderColor = "red";
                    }
                    else {
                        document.getElementById("ctl00_ContentPlaceHolder1_txtdate3").style.borderColor = "#cdcdcd";
                        aDate += document.getElementById("ctl00_ContentPlaceHolder1_txtdate3").value + '#';
                        comments += document.getElementById("txtcomment3").value + '#';
                        recDate += "" + "#";
                        actionDetail += "" + "#";
                        actionByID += "" + "#";
                    }
                    break;

                case "4":
                    if (document.getElementById("ctl00_ContentPlaceHolder1_txtdate4").value == "") {
                        status = 0;
                        document.getElementById("ctl00_ContentPlaceHolder1_txtdate4").style.borderColor = "red";
                    }
                    else {
                        document.getElementById("ctl00_ContentPlaceHolder1_txtdate4").style.borderColor = "#cdcdcd";
                        aDate += document.getElementById("ctl00_ContentPlaceHolder1_txtdate4").value + "#";
                        recDate += "" + "#";
                        actionDetail += "" + "#";
                        comments += "" + "#";

                    }
                    if (document.getElementById("ctl00_ContentPlaceHolder1_droppreperedby4").value == "") {
                        status = 0;
                        document.getElementById("ctl00_ContentPlaceHolder1_droppreperedby4").style.borderColor = "red";
                    }
                    else {
                        document.getElementById("ctl00_ContentPlaceHolder1_droppreperedby4").style.borderColor = "#cdcdcd";
                        actionByID += document.getElementById("ctl00_ContentPlaceHolder1_droppreperedby4").value + "#";

                    }
                    break;

                case "5":
                    if (document.getElementById("ctl00_ContentPlaceHolder1_txtdate5").value == "") {
                        status = 0;
                        document.getElementById("ctl00_ContentPlaceHolder1_txtdate5").style.borderColor = "red";
                    }
                    else {
                        document.getElementById("ctl00_ContentPlaceHolder1_txtdate5").style.borderColor = "#cdcdcd";
                        aDate += document.getElementById("ctl00_ContentPlaceHolder1_txtdate5").value + "#";

                    }
                    if (document.getElementById("ctl00_ContentPlaceHolder1_dropfinilizedby5").value == "") {
                        status = 0;
                        document.getElementById("ctl00_ContentPlaceHolder1_dropfinilizedby5").style.borderColor = "red";
                    }
                    else {
                        document.getElementById("ctl00_ContentPlaceHolder1_dropfinilizedby5").style.borderColor = "#cdcdcd";
                        actionByID += document.getElementById("ctl00_ContentPlaceHolder1_dropfinilizedby5").value + "#";

                    }

                    recDate += "" + "#";
                    actionDetail += "" + "#";
                    comments += "" + "#";
                    break;

                case "6":
                    if (document.getElementById("ctl00_ContentPlaceHolder1_txtdate61").value == "") {
                        status = 0;
                        document.getElementById("ctl00_ContentPlaceHolder1_txtdate61").style.borderColor = "red";
                    }
                    else {
                        document.getElementById("ctl00_ContentPlaceHolder1_txtdate61").style.borderColor = "#cdcdcd";
                        aDate += document.getElementById("ctl00_ContentPlaceHolder1_txtdate61").value + "#";

                    }
                    if (document.getElementById("ctl00_ContentPlaceHolder1_txtdate62").value == "") {
                        status = 0;
                        document.getElementById("ctl00_ContentPlaceHolder1_txtdate62").style.borderColor = "red";
                    }
                    else {
                        document.getElementById("ctl00_ContentPlaceHolder1_txtdate62").style.borderColor = "#cdcdcd";
                        recDate += document.getElementById("ctl00_ContentPlaceHolder1_txtdate62").value + "#";

                    }
                    actionByID += "" + "#";
                    actionDetail += "" + "#";
                    comments += "" + "#";
                    break;

                case "7":
                    if (document.getElementById("ctl00_ContentPlaceHolder1_txtdate7").value == "") {
                        status = 0;
                        document.getElementById("ctl00_ContentPlaceHolder1_txtdate7").style.borderColor = "red";
                    }
                    else {
                        document.getElementById("ctl00_ContentPlaceHolder1_txtdate7").style.borderColor = "#cdcdcd";
                        aDate += document.getElementById("ctl00_ContentPlaceHolder1_txtdate7").value + "#";

                    }
                    actionByID += "" + "#";
                    actionDetail += "" + "#";
                    comments += "" + "#";
                    recDate += "" + "#";
                    break;
                case "8":
                    if (document.getElementById("ctl00_ContentPlaceHolder1_txtdate8").value == "") {
                        status = 0;
                        document.getElementById("ctl00_ContentPlaceHolder1_txtdate8").style.borderColor = "red";
                    }
                    else {
                        document.getElementById("ctl00_ContentPlaceHolder1_txtdate8").style.borderColor = "#cdcdcd";
                        aDate += document.getElementById("ctl00_ContentPlaceHolder1_txtdate8").value + "#";
                        actionDetail += document.getElementById("dropmediam8").value + "#";

                    }
                    actionByID += "" + "#";
                    comments += "" + "#";
                    recDate += "" + "#";
                    break;
                case "9":
                    if (document.getElementById("ctl00_ContentPlaceHolder1_txtdate9").value == "") {
                        status = 0;
                        document.getElementById("ctl00_ContentPlaceHolder1_txtdate9").style.borderColor = "red";
                    }
                    else {
                        document.getElementById("ctl00_ContentPlaceHolder1_txtdate9").style.borderColor = "#cdcdcd";
                        aDate += document.getElementById("ctl00_ContentPlaceHolder1_txtdate9").value + "#";
                        actionDetail += document.getElementById("dropmediam9").value + "#";
                        comments += document.getElementById("txtamount9").value + "#";
                    }
                    actionByID += "" + "#";
                    recDate += "" + "#";
                    break;
                case "10":
                    if (document.getElementById("ctl00_ContentPlaceHolder1_txtdate10").value == "") {
                        status = 0;
                        document.getElementById("ctl00_ContentPlaceHolder1_txtdate10").style.borderColor = "red";
                    }
                    else {
                        document.getElementById("ctl00_ContentPlaceHolder1_txtdate10").style.borderColor = "#cdcdcd";
                        aDate += document.getElementById("ctl00_ContentPlaceHolder1_txtdate10").value + "#";
                        actionDetail += document.getElementById("dropmediam10").value + "#";

                    }
                    actionByID += "" + "#";
                    recDate += "" + "#";
                    comments += "" + "#";
                    break;
            }


        }

    }



    if (status == 1) {

        if (actionByID == "") {
            actionByID = createdby;
        }
        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
        var args = { nid: document.getElementById("ctl00_ContentPlaceHolder1_hidid").value, taxCompanyID: taxCompanyID, actionId: actionId, aDate: aDate, actionDetail: actionDetail, comments: comments, actionByID: actionByID, recDate: recDate, createdby: createdby, remark: document.getElementById("ctl00_ContentPlaceHolder1_txtremark").value };
        $.ajax({

            type: "POST",
            url: pagename + "/savedata",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            cache: false,
            success: function (data) {

                if (data.d == "") {


                    filltaxlog();
                    alert("saved successfully");
                    closediv();
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
    else {
        alert("Please fill required fields!");

    }
}
function blank() {

    document.getElementById("ctl00_ContentPlaceHolder1_hidid").value = "";
    document.getElementById("dropmediam1").value = "Phone";
    document.getElementById("ctl00_ContentPlaceHolder1_txtdate1").value = "";

    document.getElementById("dropmediam1").value = "Phone";
    document.getElementById("ctl00_ContentPlaceHolder1_txtdate1").value = "";
    document.getElementById("dropmediam2").value = "Physical";
    document.getElementById("ctl00_ContentPlaceHolder1_txtdate2").value = "";

    document.getElementById("ctl00_ContentPlaceHolder1_txtdate3").value = "";
    document.getElementById("ctl00_ContentPlaceHolder1_droppreperedby4").value = "";
    document.getElementById("ctl00_ContentPlaceHolder1_txtdate4").value = "";

    document.getElementById("ctl00_ContentPlaceHolder1_dropfinilizedby5").value = "";
    document.getElementById("ctl00_ContentPlaceHolder1_txtdate5").value = "";

    document.getElementById("ctl00_ContentPlaceHolder1_txtdate62").value = "";
    document.getElementById("ctl00_ContentPlaceHolder1_txtdate61").value = "";


    document.getElementById("ctl00_ContentPlaceHolder1_txtdate7").value = "";
    document.getElementById("dropmediam8").value = "Yes";
    document.getElementById("ctl00_ContentPlaceHolder1_txtdate8").value = "";
    document.getElementById("dropmediam9").value = "Yes";
    document.getElementById("ctl00_ContentPlaceHolder1_txtdate9").value = "";
    document.getElementById("ctl00_ContentPlaceHolder1_txtremark").value = "";
    document.getElementById("dropmediam10").value = "Phone";
    document.getElementById("ctl00_ContentPlaceHolder1_txtdate10").value = "";
    $('.taxlogfieldbox').hide();

    var inputs = document.getElementsByName("radionbtnaction");

    for (var i = 0; i < inputs.length; i++) {
        inputs[i].checked = false;
    }
}

function openaddnew() {
    blank();
    if (document.getElementById("ctl00_ContentPlaceHolder1_txttaxclient").value == "") {
        alert("Select a Tax Client!");
        return;
    }
    opendiv();

}
function opendiv() {
    setposition("divaddnew");
    $('#otherdiv').show();
    $('#divaddnew').fadeIn();

}
function deletetaxlog(nid) {
    if (confirm("Delete this record? Ok or Cancel")) {
        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
        var args = { id: nid };
        $.ajax({

            type: "POST",
            url: pagename + "/deletelog",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            cache: false,
            success: function (data) {

                if (data.d != "failure") {
                    filltaxlog();
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

}
function edittaxlog(nid) {
    blank();
    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
    var args = { id: nid };
    $.ajax({

        type: "POST",
        url: pagename + "/gettaxlogbynid",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {

            if (data.d != "failure") {
                var jsonarr = $.parseJSON(data.d);
                if (jsonarr.length > 0) {
                    $('#taxlogfieldbox').hide();
                    document.getElementById("taxradion_" + jsonarr[0].actionId).checked = true;
                    document.getElementById("taxradion_divtaxlog_" + jsonarr[0].actionId).style.display = "block";

                    switch (jsonarr[0].actionId) {
                        case "1":
                            document.getElementById("ctl00_ContentPlaceHolder1_txtdate1").value = jsonarr[0].aDate;
                            document.getElementById("dropmediam1").value = jsonarr[0].actionDetail;

                            break;
                        case "2":
                            document.getElementById("ctl00_ContentPlaceHolder1_txtdate2").value = jsonarr[0].aDate;
                            document.getElementById("dropmediam2").value = jsonarr[0].actionDetail;

                        case "3":
                            document.getElementById("ctl00_ContentPlaceHolder1_txtdate3").value = jsonarr[0].aDate;
                            document.getElementById("txtcomment3").value = jsonarr[0].comments;

                            break;

                        case "4":
                            document.getElementById("ctl00_ContentPlaceHolder1_txtdate4").value = jsonarr[0].aDate;
                            document.getElementById("ctl00_ContentPlaceHolder1_droppreperedby4").value = jsonarr[0].actionByID;

                            break;

                        case "5":
                            document.getElementById("ctl00_ContentPlaceHolder1_txtdate5").value = jsonarr[0].aDate;
                            document.getElementById("ctl00_ContentPlaceHolder1_dropfinilizedby5").value = jsonarr[0].actionByID;

                            break;

                        case "6":
                            document.getElementById("ctl00_ContentPlaceHolder1_txtdate61").value = jsonarr[0].aDate;
                            document.getElementById("ctl00_ContentPlaceHolder1_txtdate62").value = jsonarr[0].recDate;

                            break;

                        case "7":
                            document.getElementById("ctl00_ContentPlaceHolder1_txtdate7").value = jsonarr[0].aDate;

                            break;
                        case "8":
                            document.getElementById("ctl00_ContentPlaceHolder1_txtdate8").value = jsonarr[0].aDate;
                            document.getElementById("dropmediam8").value = jsonarr[0].actionDetail;


                            break;
                        case "9":
                            document.getElementById("ctl00_ContentPlaceHolder1_txtdate9").value = jsonarr[0].aDate;
                            document.getElementById("dropmediam9").value = jsonarr[0].actionDetail;
                            document.getElementById("txtamount9").value = jsonarr[0].comments;

                            break;
                        case "10":
                            document.getElementById("ctl00_ContentPlaceHolder1_txtdate10").value = jsonarr[0].aDate;
                            document.getElementById("dropmediam10").value = jsonarr[0].actionDetail;
                            break;
                    }


                    document.getElementById("ctl00_ContentPlaceHolder1_txtremark").value = jsonarr[0].comment1;

                    document.getElementById("ctl00_ContentPlaceHolder1_hidid").value = jsonarr[0].nid;


                    opendiv();
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



function opendiv() {
    setposition("divaddnew");
    document.getElementById("divaddnew").style.display = "block";
    document.getElementById("otherdiv").style.display = "block";
}
function closediv() {

    document.getElementById("divaddnew").style.display = "none";
    document.getElementById("otherdiv").style.display = "none";

}
