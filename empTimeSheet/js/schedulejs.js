var pagename = "ViewSchedule.aspx";
var hiddeleteaction = '',hideditaction='',hidgroupid='';
function closediv1() {
    document.getElementById("divstatus").style.display = "none";
    document.getElementById("otherdiv").style.display = "none";
}
//Open Set Status div
function openstatusdiv() {
    setposition("divstatus");
    document.getElementById("divstatus").style.display = "block";
    document.getElementById("otherdiv").style.display = "block";
}

//Open add/edit div
function opendiv() {
    setposition("divaddnew");
    document.getElementById("divaddnew").style.display = "block";
    document.getElementById("otherdiv").style.display = "block";
}
function closediv() {

    document.getElementById("divaddnew").style.display = "none";
    document.getElementById("otherdiv").style.display = "none";
    document.getElementById("divstatusmsg").style.display = "none";
    document.getElementById("divnonschedule").style.display = "none";
    document.getElementById("divconfirmdiv").style.display = "none";

}

function showdate(val) {
    if (val == "Re-Schedule") {
        document.getElementById("divdate").style.display = "block";
    }
    else {
        document.getElementById("divdate").style.display = "none";
    }
}


function closealert() {
    document.getElementById("divstatusmsg").style.display = "none";
    document.getElementById("otherdiv").style.display = "none";
    opendiv();
}
//Open Alert div to Show Existing Schedules of clients
function openalert() {
    setposition("divstatusmsg");

    document.getElementById("divstatusmsg").style.display = "block";
    document.getElementById("otherdiv").style.display = "block";
}

function opennonscedulediv() {
    setposition("divnonschedule");
    document.getElementById("divnonschedule").style.display = "block";
    document.getElementById("otherdiv").style.display = "block";
}
function closenonscedulediv() {

    document.getElementById("divnonschedule").style.display = "none";
    document.getElementById("otherdiv").style.display = "none";
}

function showhidestatus() {
    if (document.getElementById("ctl00_ContentPlaceHolder1_rdbtnscheduleType").value == "Field") {
        document.getElementById("divschedulestatus").style.display = "block";
        document.getElementById("divaddremark").style.display = "none";
        document.getElementById("ctl00_ContentPlaceHolder1_txtaddremark").value = "";

    }
    else if (document.getElementById("ctl00_ContentPlaceHolder1_rdbtnscheduleType").value == "Office") {
        document.getElementById("divschedulestatus").style.display = "none";
        document.getElementById("divaddremark").style.display = "block";

    }
    else {
        document.getElementById("divschedulestatus").style.display = "block";
        document.getElementById("divaddremark").style.display = "none";
        document.getElementById("ctl00_ContentPlaceHolder1_txtaddremark").value = "";
    }
}
function reset() {
    document.getElementById('ctl00_ContentPlaceHolder1_listcode1').style.visibility = "visible";
    document.getElementById('ctl00_ContentPlaceHolder1_listcode2').style.visibility = "visible";
    //            document.getElementById('ctl00_ContentPlaceHolder1_btnAddtoList').style.visibility = "visible";
    //            document.getElementById('ctl00_ContentPlaceHolder1_btnRemovefromList').style.visibility = "visible";
    document.getElementById("ctl00_ContentPlaceHolder1_rdbtnscheduleType").value = "Office";
    document.getElementById('ctl00_ContentPlaceHolder1_txtpopfrdate').disabled = false;
    document.getElementById('ctl00_ContentPlaceHolder1_txtpoptodate').disabled = false;
    document.getElementById('ctl00_ContentPlaceHolder1_hidid').value = "";
    document.getElementById('ctl00_ContentPlaceHolder1_divselectemployee').style.display = "block";
    showhidestatus();
}
function clickedit2(id) {
    document.getElementById("ctl00_ContentPlaceHolder1_hidid").value = id;
    $('#PaggedGridbtnedit2').trigger('click');
}
function fixheader() {

    $.getScript("js/colResizable-1.6.js", function () {

        $("#ctl00_ContentPlaceHolder1_dgnews").colResizable({
            liveDrag: true,
            gripInnerHtml: "<div class='grip'></div>",
            draggingClass: "dragging",
            resizeMode: 'fit'
        });

        var eventFired = function (type) {
            $('html,body').animate({
                scrollTop: $("#ctl00_ContentPlaceHolder1_dgnews_next").position().top
            },
'slow');
        }

        $('#ctl00_ContentPlaceHolder1_dgnews').on('page.dt', function () { eventFired('Page'); }).dataTable({
            "dom": 'lrtip',
            "pageLength": 50,
            'aoColumnDefs': [{
                'bSortable': false,
                'aTargets': [-1] /* 1st one, start by the right */
            }]
        });

    });


}
function move(btnaddmember, btnremove) {


    var arrFrom = new Array(); var arrTo = new Array();
    var arrLU = new Array();
    var i;
    for (i = 0; i < btnremove.options.length; i++) {
        arrLU[btnremove.options[i].text] = btnremove.options[i].value;
        arrTo[i] = btnremove.options[i].text;
    }

    var fLength = 0;
    var tLength = arrTo.length;
    for (i = 0; i < btnaddmember.options.length; i++) {
        arrLU[btnaddmember.options[i].text] = btnaddmember.options[i].value;
        if (btnaddmember.options[i].selected && btnaddmember.options[i].value != "") {
            arrTo[tLength] = btnaddmember.options[i].text;
            tLength++;
        }
        else {
            arrFrom[fLength] = btnaddmember.options[i].text;
            fLength++;
        }
    }

    btnaddmember.length = 0;
    btnremove.length = 0;
    var ii;
    for (ii = 0; ii < arrFrom.length; ii++) {
        var no = new Option();
        no.value = arrLU[arrFrom[ii]];
        no.text = arrFrom[ii];
        btnaddmember[ii] = no;
    }

    for (ii = 0; ii < arrTo.length; ii++) {
        var no = new Option();
        no.value = arrLU[arrTo[ii]];
        no.text = arrTo[ii];
        btnremove[ii] = no;
    }
    var strval = "";
    var tolistbox = document.getElementById('ctl00_ContentPlaceHolder1_listcode2');
    if (tolistbox.options.length > 0) {
        for (k = 0; k < tolistbox.options.length; k++) {

            strval += tolistbox.options[k].value + ',';

        }

    }

    document.getElementById('ctl00_ContentPlaceHolder1_hidexpense').value = strval;
    sortlist();
}

function sortlist() {
    var SelList = document.getElementById('ctl00_ContentPlaceHolder1_listcode1');
    var ID = '';
    var Text = '';
    for (x = 0; x < SelList.length - 1; x++) {
        for (y = x + 1; y < SelList.length; y++) {
            if (SelList[x].text > SelList[y].text) {
                // Swap rows
                ID = SelList[x].value;
                Text = SelList[x].text;
                SelList[x].value = SelList[y].value;
                SelList[x].text = SelList[y].text;
                SelList[y].value = ID;
                SelList[y].text = Text;
            }
        }
    }
}
function validate1(source, args) {
    if (document.getElementById('ctl00_ContentPlaceHolder1_hidid').value == "") {
        var tolistbox1 = document.getElementById('ctl00_ContentPlaceHolder1_listcode2');

        var numofelemadded = tolistbox1.options.length;
        if (numofelemadded > 0) {
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
function validate2(source, args) {


    var status = 0;
    if (document.getElementById("ctl00_ContentPlaceHolder1_ddlstaus").value == "Re-Schedule") {
        if (document.getElementById("ctl00_ContentPlaceHolder1_txtnewdate").value == "")

            status = 1;

    }

    if (status == 0) {
        args.IsValid = true;
    }
    else {

        args.IsValid = false;
    }
    return;
}

function clickdelete(id)
{
    var args = { nid: id,};
    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
    $.ajax({

        type: "POST",
        url: pagename + "/countGroupRec",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {

            if (data.d != "failure") {

                $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();

                var jsonarr = $.parseJSON(data.d);
                if (jsonarr.length > 0) {

                    hiddeleteaction = "1";
                    hideditaction = "";

                    $('#ctl00_ContentPlaceHolder1_hidid').val(id);
                    if (parseInt(jsonarr[0].num) == 1) {
                        hidgroupid = '';
                        deleterecord("");
                      

                    }
                    else {
                        hidgroupid = jsonarr[0].groupid;
                        $('#alerttext').html(jsonarr[0].num + " schedules are  associated to this record, please choose an action from below");
                        $('#btnaction1').val("Delete All (" + jsonarr[0].num + ")");
                        setposition("divconfirmdiv");
                        document.getElementById("divconfirmdiv").style.display = "block";
                        document.getElementById("otherdiv").style.display = "block";
                    }
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

function setactionfrombox(type)
{
    if(hiddeleteaction!="")
    {
        deleterecord(type);
    }
}

function deleterecord(type) {

    closediv();
    var bool = true;
    if (type == "") {
        bool = confirm("Do you want to delete this record?");
    }

    var action = "", nid = "";
    action = type;


    if (action == "") {
        nid = $('#ctl00_ContentPlaceHolder1_hidid').val();
    }
    else if (action == "2") {
        nid = $('#ctl00_ContentPlaceHolder1_hidid').val();
    }
    else {
        nid = hidgroupid;
    }

    if (bool) {
        var args = { nid: nid, action: action };
        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
        $.ajax({

            type: "POST",
            url: pagename + "/deleteschedule",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            cache: false,
            success: function (data) {

                if (data.d != "failure") {

                    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();

                    var jsonarr = $.parseJSON(data.d);
                    if (data.d == "1") {

                        alert("Deleted successfully!");
                        $('#ctl00_ContentPlaceHolder1_btnsearch').trigger('click');

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

}