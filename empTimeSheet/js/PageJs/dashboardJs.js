var pagename = "AdminDashboard.aspx";
var opendivid = '', hidrecid = '';
function fillmonthlychar() {
    var sampleData;
    var args = { empid: document.getElementById("hidchatloginid").value };

    $.ajax({

        type: "POST",
        url: pagename + "/getEmpMonthlyDetail",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (msg) {
            if (msg.d != "failure") {

                sampleData = jQuery.parseJSON(msg.d);

                var maxValue = 0, interval=0;
               
                if (sampleData.length > 0) {

                    for (var i in sampleData) {
                        if ((parseInt(sampleData[i].Billable) + parseInt(sampleData[i].NonBillable)) > maxValue) {
                            maxValue = (parseInt(sampleData[i].Billable) + parseInt(sampleData[i].NonBillable));
                        }
                       

                    }
                }

                if (maxValue % 10>0)
                    maxValue = maxValue + (10 - (maxValue % 10));


                if (maxValue > 10)
                {
                    interval = maxValue / 10;
                    if(interval%10!=0)
                    {
                        interval = interval + (10 - (interval % 10));
                        maxValue = interval * 10;

                    }


                }
                else {
                    maxValue = 10;
                    interval = 1;
                }
               

                var settings = {
                    title: "",
                    description: "Billable and Non-Billable Time Summary",
                    enableAnimations: true,
                    showLegend: true,
                    padding: { left: 5, top: 5, right: 5, bottom: 5 },
                    titlePadding: { left: 90, top: 0, right: 0, bottom: 10 },
                    source: sampleData,
                    xAxis:
                        {
                            dataField: 'Month',
                            unitInterval: 1,
                            axisSize: 'auto',
                            tickMarks: {
                                visible: true,
                                interval: 1,
                                color: '#ffffff'
                            },
                            gridLines: {
                                visible: true,
                                interval: 1,
                                color: '#e0e0e0'
                            }
                        },
                    valueAxis:
                    {
                        unitInterval: interval,
                        minValue: 0,
                        maxValue: maxValue,
                        title: { text: 'Time in Hours' },
                        labels: { horizontalAlignment: 'right' },
                        tickMarks: { color: '#ffffff' },
                        gridLinesColor: '#e0e0e0'
                    },
                    colorScheme: 'scheme05',
                    borderLineColor: '#ffffff',
                    seriesGroups:
                        [
                            {
                                type: 'stackedcolumn',
                                columnsGapPercent: 50,
                                seriesGapPercent: 0,
                                series: [
                                        { dataField: 'Billable', displayText: 'Billable', color: '#4CBB17' },
                                        { dataField: 'Non-Billable', displayText: 'Non-Billable', color: '#FF9800' }

                                ]
                            }
                        ]
                };

                document.getElementById("loaderEmpHour").style.display = "none";
                // setup the chart
                // $(".jqx-chart-legend-text:nth-child(3)").css("display", "none");
                $('#chartEmpHour').jqxChart(settings);


                // $('.jqx-chart-legend-text').css("display", "none");
            }

        },
        error: function (x, e) {
            document.getElementById("loaderEmpHour").style.display = "none";


        }
    });
}

function fillchart(reportid, loaderid, chartdivid, clorscheme,title) {

    $('#divreportloader').show();
    $('#chartContainer').hide();
    var sampleData;
    var args = { action: reportid, companyid: document.getElementById("hidcompanyid").value };

    $.ajax({

        type: "POST",
        url: pagename + "/getChartReport",

        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (msg) {
            if (msg.d != "failure") {



                var maxValue = 0;
                var interval = 0;
                var fieldname = "", yname = "";

                switch (reportid) {
                    case "Monthly Billing":
                        fieldname = "Month";
                        yname = "Amount";
                        break;
                    case "Billable Hours":
                        fieldname = "Month";
                        yname = "Hours";
                        break;
                    case "Non-Billable Hours":
                        fieldname = "Month";
                        yname = "Hours";
                        break;
                    case "Un-Billed Time":
                        fieldname = "Month";
                        yname = "Hours";
                        break;
                    case "Top Ten Employees":
                        fieldname = "Employee";
                        yname = "Amount";
                        break;
                    case "Top Ten Activities":
                        fieldname = "Activity";
                        yname = "Amount";
                        break;
                    case "Top Ten Expenses":
                        fieldname = "Expense";
                        yname = "Amount";
                        break;
                    case "Top Ten Clients":
                        fieldname = "Client";
                        yname = "Amount";
                        break;
                    case "Top Ten Projects":
                        fieldname = "Project";
                        yname = "Amount";
                        break;
                    case "Monthly Expenses":
                        fieldname = "Month";
                        yname = "Amount";
                        break;
                    default:
                        fieldname = "Title";
                        yname = "Value";
                        break;

                }

                sampleData = jQuery.parseJSON(msg.d);
                sampleData = JSON.parse(JSON.stringify(sampleData).split('"name":').join('"' + fieldname + '":'));

                sampleData = JSON.parse(JSON.stringify(sampleData).split('"val":').join('"' + yname + '":'));



                var comparedate = jQuery.parseJSON(msg.d);
                if (comparedate.length > 0) {

                    for (var i in comparedate) {
                        if (parseInt(comparedate[i].val) > maxValue) {
                            maxValue = parseInt(comparedate[i].val);
                        }

                    }
                }

               

                if (maxValue % 10 > 0)
                    maxValue = maxValue + (10 - (maxValue % 10));


                if (maxValue > 10) {
                    interval = maxValue / 10;
                    if (interval % 10 != 0) {
                        interval = interval + (10 - (interval % 10));
                        maxValue = interval * 10;

                    }


                }
                else {
                    maxValue = 10;
                    interval = 1;
                }


               

                var settings = {
                    title: "",
                    description: "",
                    enableAnimations: true,
                    showLegend: false,
                    padding: { left: 5, top: 5, right: 5, bottom: 5 },
                    titlePadding: { left: 90, top: 0, right: 0, bottom: 10 },
                    source: sampleData,
                    xAxis:
                        {
                            dataField: fieldname,
                            unitInterval: 1,
                            axisSize: 'auto',
                            tickMarks: {
                                visible: true,
                                interval: 1,
                                color: '#ffffff'
                            },
                            gridLines: {
                                visible: true,
                                interval: 1,
                                color: '#e0e0e0'
                            },
                            labels:
               {
                   angle: 90,
                   horizontalAlignment: 'right',
                   verticalAlignment: 'center',
                   rotationPoint: 'left',
                   offset: { y: -15 }
               }

                        },
                    valueAxis:
                    {
                        unitInterval: interval,
                        minValue: 0,
                        maxValue: maxValue,
                        title: { text: title },
                        labels: { horizontalAlignment: 'right' },
                        tickMarks: { color: '#ffffff' },
                        gridLinesColor: '#e0e0e0',

                    },
                    colorScheme: clorscheme,
                    borderLineColor: '#ffffff',
                    seriesGroups:
                        [
                            {
                                type: 'stackedcolumn',

                                toolTipFormatSettings: { thousandsSeparator: ',' },
                                seriesGapPercent: 0,
                                series: [
                                        {
                                            dataField: yname, displayText: yname
                                            //labels: {
                                            //    visible: true,
                                            //    verticalAlignment: 'top',
                                            //    offset: { x: 0, y: 15 }
                                            //}


                                        },
                                        {}

                                ]
                            }
                        ]
                };
                $('#' + loaderid).hide();
                $('#' + chartdivid).show();
                // setup the chart
                // $(".jqx-chart-legend-text:nth-child(3)").css("display", "none");
                $('#' + chartdivid).jqxChart(settings);

                $(".jqx-chart-legend-text:nth-child(3)").css("display", "none");
                // $('.jqx-chart-legend-text').css("display", "none");
            }

        },
        error: function (x, e) {
            $('#' + loaderid).hide();
            $('#' + chartdivid).show();


        }
    });


}


function fillInvoices() {

    var str = "";
    $("#tblinvoices tbody").empty();
    var args = { companyid: $('#hidcompanyid').val() };
    $('#divinvdataloader').show();
    $.ajax({

        type: "POST",
        url: pagename + "/getInvoices",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {

            if (data.d != "failure") {
                var arr = String(data.d).split("###");
                var jsonarr = $.parseJSON(arr[0]);
                var jsonarr1 = $.parseJSON(arr[1]);

                if (jsonarr.length > 0) {


                    $.each(jsonarr, function (i, item) {

                        str = str + '<tr>';
                        str = str + '<td>' + item.invoicedate + '</td>';
                        str = str + '<td><a class="linkvieinv" id="linkvieinv' + item.nid + '">' + item.invoiceno + '</a></td>';
                        str = str + '<td>' + item.projectname + '</td>';
                        str = str + '<td>$ ' + parseFloat(item.totalamount).toFixed(2) + '</td>';
                        if (parseFloat(item.invoicedueamount) == 0)
                            str = str + '<td> <span class="label label-success">Paid</span></td>';
                        else if (parseFloat(item.invoicedueamount) > 0)
                            str = str + '<td> <span class="label label-warning">Due</span></td>';
                        else if (parseFloat(item.invoicepaidamount) > parseFloat(item.totalamount))
                            str = str + '<td> <span class="label label-danger">Overdue</span></td>';
                        else
                            str = str + '<td></td>';


                        str = str + "</tr>";

                    });
                    $("#tblinvoices tbody").append(str);
                    str = '';
                    str = '<span class="mtop-10"> Paid Invoice: <strong>' + jsonarr1[0].paid + ' \
                        <i class="fa fa-level-up text-primary"></i></strong>,  Unpaid Invoice: <strong> ' + jsonarr1[0].due + '<i class="fa fa-level-down text-danger">\
                        </i></strong></span><a class="pull-right pull-left-xs btn btn-primary btn-sm" href="InvoiceReview.aspx">View All Invoices</a>';

                    $("#divinvsummary").html(str);

                    jsonarr1 = $.parseJSON(arr[2]);
                    $("#strtotal").html(jsonarr1[0].total);
                    $("#strbilled").html(jsonarr1[0].billed);
                    $("#strunbilled").html(jsonarr1[0].total - jsonarr1[0].billed);

                }



                $('#divinvdataloader').hide();

                $(".linkvieinv").click(function () {
                    var newid = $(this).attr("id");
                    newid = newid.replace("linkvieinv", "");
                    window.open("ViewInvoice.aspx?invoiceid=" + newid, "_blank");
                });


            }


        },
        error: function (x, e) {
            alert("The call to the server side failed. " + x.responseText);
            $('#divinvdataloader').hide();
            return;
        }

    });



}

function filleventdetail(id, rectype) {
    if (rectype == "Event") {
        fillevent_detail(id);
    }
    else if (rectype == "Schedule") {
        getSchdetail(id);
    }
    else if (rectype == "Appointment") {
        viewAppdetail(id);
    }
}
function opendiv(id) {
    opendivid = id;
    setposition(id);
    $('#otherdiv').fadeIn("slow");
    $('#' + id).fadeIn("slow");


}
function closediv() {
    if (opendivid != "") {
        if (document.getElementById(opendivid) != null) {
            $('#' + opendivid).hide();
            $('#otherdiv').hide();

        }
    }

}
function editevent() {
    var cal_loginid = document.getElementById("hidchatloginid").value;
    var args = { nid: hidrecid };
    $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").show();
    $.ajax({
        type: "POST",
        contentType: "application/json",
        data: JSON.stringify(args),
        url: pagename + "/getEventDetail",
        dataType: "json",
        success: function (data) {
            $.each(data, function (k, v) {

                document.getElementById('ctl00_ContentPlaceHolder1_txttitle').value = v[0].EventName;
                document.getElementById('ctl00_ContentPlaceHolder1_txtdesc').value = v[0].Description;
                document.getElementById('ctl00_ContentPlaceHolder1_txtlocation').value = v[0].Location;
                document.getElementById('ctl00_ContentPlaceHolder1_txtfromdate').value = v[0].StartDate;

                if (v[0].EndDate != "" && v[0].EndDate != null) {
                    document.getElementById('ctl00_ContentPlaceHolder1_txtenddate').value = v[0].EndDate;
                }
                else {
                    document.getElementById('ctl00_ContentPlaceHolder1_txtenddate').value = v[0].StartDate;
                }
                document.getElementById('ctl00_ContentPlaceHolder1_txtstarttime').value = String(v[0].StartTime).replace(" ", "");
                document.getElementById('ctl00_ContentPlaceHolder1_txtendtime').value = String(v[0].EndTime).replace(" ", "");
                if (v[0].AllDayEvent == "1") {
                    document.getElementById('ctl00_ContentPlaceHolder1_ckhAllDay').checked = true;

                }
                else {
                    document.getElementById('ctl00_ContentPlaceHolder1_ckhAllDay').checked = false;
                }

                if (v[0].eventrepeat != "") {
                    document.getElementById('ctl00_ContentPlaceHolder1_ckhRepeat').checked = true;
                    document.getElementById('ctl00_ContentPlaceHolder1_droprepeat').value = v[0].eventrepeat;

                }
                else {
                    document.getElementById('ctl00_ContentPlaceHolder1_ckhRepeat').checked = false;
                }
                if (v[0].eventtype == "Public") {
                    document.getElementById('ctl00_ContentPlaceHolder1_chkeventtype').checked = true;

                }
                else {
                    document.getElementById('ctl00_ContentPlaceHolder1_chkeventtype').checked = false;
                }



                document.getElementById("Dashboard_hidEventColor").value = v[0].LayerID;




                var allDivTd = document.getElementById("ctl00_ContentPlaceHolder1_replayer").getElementsByTagName("input");
                $("#ctl00_ContentPlaceHolder1_replayer :input").each(function (e) {
                    eleid = this.id;
                    var itemid = $('#' + eleid).attr("itemid")

                    this.checked = false;

                    if (itemid == v[0].LayerID) {
                        // $('#' + eleid).attr('checked', 'checked');
                        this.checked = true;
                    }

                });





            });
            setAllDayEvent();
            setRepeatEvent();
            $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();
            setposition('divShowevent');
            document.getElementById('btnsaveevent').value = "Update";
            document.getElementById('divShowevent').style.display = 'none';
            document.getElementById('otherdiv').style.display = 'block';
            document.getElementById('divevents').style.display = 'block';


        },
        error: function (x, e) {

            $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();
            alert('Server error!');
        }

    });


}
function setAllDayEvent() {
    if (document.getElementById('ctl00_ContentPlaceHolder1_ckhAllDay').checked) {
        document.getElementById("divstarttime").style.display = "none";
        document.getElementById("divendtime").style.display = "none";
    }
    else {
        document.getElementById("divstarttime").style.display = "block";
        document.getElementById("divendtime").style.display = "block";
    }
}
function setRepeatEvent() {

    if (document.getElementById('ctl00_ContentPlaceHolder1_ckhRepeat').checked) {
        document.getElementById("divrepeat").style.display = "block";

    }
    else {
        document.getElementById("divrepeat").style.display = "none";
    }
}
function seteventcolor(id, rb) {

    document.getElementById("Dashboard_hidEventColor").value = id;


    var gv = document.getElementById("ctl00_ContentPlaceHolder1_replayer");

    var rbs = gv.getElementsByTagName("input");



    var row = rb.parentNode.parentNode;

    for (var i = 0; i < rbs.length; i++) {

        if (rbs[i].type == "radio") {

            if (rbs[i].checked && rbs[i] != rb) {

                rbs[i].checked = false;

                break;

            }

        }

    }
}
function fillevent_detail(id1) {
    var cal_loginid = document.getElementById("hidchatloginid").value;
    var args = { nid: id1 };
    $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").show();
    $.ajax({
        type: "POST",
        contentType: "application/json",
        data: JSON.stringify(args),

        url: pagename + "/getEventDetail",
        dataType: "json",
        success: function (data) {
            $.each(data, function (k, v) {

                document.getElementById('diveventhead').innerHTML = v[0].EventName;
                document.getElementById('diveventicon').innerHTML = "<div class='" + v[0].Color + " detaillayer'></div>";
                document.getElementById('diveventText').innerHTML = v[0].eventtype + " event By <span>" + v[0].createdbyName + "</span> ";
                var datestr = "";
                datestr = v[0].StartDate;
                if (v[0].StartTime != "" && v[0].StartTime != null) {
                    datestr += " at " + v[0].StartTime;
                }


                if (v[0].EndDate != "" && v[0].EndDate != null) {
                    datestr += " <span> until </span> " + v[0].EndDate;
                }
                if (v[0].EndTime != "" && v[0].EndTime != null) {
                    if (v[0].EndDate != "")
                        datestr += " at " + v[0].EndTime;
                    else
                        datestr += " <span> until </span> " + v[0].EndTime;
                }
                document.getElementById('divEventDate').innerHTML = datestr;
                document.getElementById('divLocation').innerHTML = v[0].Location;

                document.getElementById('divEventMsg').innerHTML = v[0].Description;
                hidrecid = v[0].NID;


                if (cal_loginid != v[0].Userid) {
                    document.getElementById('btneditevent').style.display = 'none';
                    document.getElementById('btndeleteevent').style.display = 'none';
                }
                else {
                    document.getElementById('btneditevent').style.display = 'block';
                    document.getElementById('btndeleteevent').style.display = 'block';
                }


            });
            $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();
            opendiv("divShowevent");


        },
        error: function (x, e) {

            $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();
            alert('Server error!');
        }

    });

}

function deleteevent() {
    if (confirm("Do you want to delete this event?")) {
        var cal_loginid = document.getElementById("hidchatloginid").value;
        var args = { nid: hidrecid };
        $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").show();
        $.ajax({
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify(args),
            url: pagename + "/deleteevent",
            dataType: "json",
            success: function (data) {
                $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();
                if (data.d == "") {


                    document.getElementById('divShowevent').style.display = 'none';
                    document.getElementById('otherdiv').style.display = 'none';
                    blankEvent();
                    document.getElementById('ifevent').contentWindow.mapevents();

                }
                else {

                    alert(data.d);
                }




            },
            error: function (x, e) {

                $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();
                alert('Server error!');
            }

        });

    }



}
function blankEvent() {
    document.getElementById("ctl00_ContentPlaceHolder1_txttitle").value = "";
    document.getElementById("ctl00_ContentPlaceHolder1_txtdesc").value = "";
    document.getElementById("ctl00_ContentPlaceHolder1_txtfromdate").value = "";
    document.getElementById("ctl00_ContentPlaceHolder1_txtstarttime").value = "";
    document.getElementById("ctl00_ContentPlaceHolder1_txtenddate").value = "";
    document.getElementById("ctl00_ContentPlaceHolder1_txtendtime").value = "";
    hidrecid = "";
    document.getElementById('btnsaveevent').value = "Save";


}
function validateEvent() {
    var status = 1;

    if (document.getElementById("ctl00_ContentPlaceHolder1_txttitle").value == "") {
        status = 0;
        document.getElementById("ctl00_ContentPlaceHolder1_txttitle").style.borderColor = "red";
    }
    else {
        document.getElementById("ctl00_ContentPlaceHolder1_txttitle").style.borderColor = "#cdcdcd";
    }
    if (document.getElementById("ctl00_ContentPlaceHolder1_txtdesc").value == "") {
        status = 0;
        document.getElementById("ctl00_ContentPlaceHolder1_txtdesc").style.borderColor = "red";
    }
    else {
        document.getElementById("ctl00_ContentPlaceHolder1_txtdesc").style.borderColor = "#cdcdcd";
    }

    if (document.getElementById("ctl00_ContentPlaceHolder1_txtlocation").value == "") {
        status = 0;
        document.getElementById("ctl00_ContentPlaceHolder1_txtlocation").style.borderColor = "red";
    }
    else {
        document.getElementById("ctl00_ContentPlaceHolder1_txtlocation").style.borderColor = "#cdcdcd";
    }

    if (document.getElementById("ctl00_ContentPlaceHolder1_txtfromdate").value == "") {
        status = 0;
        document.getElementById("ctl00_ContentPlaceHolder1_txtfromdate").style.borderColor = "red";
    }
    else {
        document.getElementById("ctl00_ContentPlaceHolder1_txtfromdate").style.borderColor = "#cdcdcd";
    }
    if (document.getElementById("ctl00_ContentPlaceHolder1_txtenddate").value == "") {
        status = 0;
        document.getElementById("ctl00_ContentPlaceHolder1_txtenddate").style.borderColor = "red";
    }
    else {
        document.getElementById("ctl00_ContentPlaceHolder1_txtenddate").style.borderColor = "#cdcdcd";
    }

    if (document.getElementById("Dashboard_hidEventColor").value == "") {
        status = 0;
        if (status == 1)
            alert("Choose event color");
    }

    if (status == 0) {
        return false;
    }
    else {
        return true;
    }


}

function validateEventDate(id, from, to, event) {
    var val = document.getElementById(id).value;
    // alert(val);
    if (val != "" && val != "__/__/____") {
        if (!isDate(val)) {
            alert('Invalid date format, date must be in mm/dd/yyyy format');

            document.getElementById(id).value = "";


        }
        else {

            var fromval = document.getElementById(from).value;
            var toval = document.getElementById(to).value;



            if (fromval != "" && toval != "") {

                var d1 = new Date(fromval);
                var d2 = new Date(toval);
                if (d1 > d2) {
                    alert('"Start Date" should not be greater than "End Date"');

                    document.getElementById(id).value = "";

                }



            }



        }
    }

}
function saveEvent() {
    var status = false;
    status = validateEvent();

    if (status == false) {
        return false;
    }

    var cal_loginid = document.getElementById("hidchatloginid").value;

    var isPublicevent = "";
    var repeat = "", isallday = "0";
    if (document.getElementById('ctl00_ContentPlaceHolder1_chkeventtype').checked) {
        isPublicevent = "Public";
    } else {
        isPublicevent = "Private";
    }


    if (document.getElementById('ctl00_ContentPlaceHolder1_ckhRepeat').checked) {
        repeat = document.getElementById('ctl00_ContentPlaceHolder1_droprepeat').value;
    }
    if (document.getElementById('ctl00_ContentPlaceHolder1_ckhAllDay').checked) {
        isallday = "1";
    }

    var args = {
        nid: hidrecid,
        title: document.getElementById("ctl00_ContentPlaceHolder1_txttitle").value, description: document.getElementById("ctl00_ContentPlaceHolder1_txtdesc").value,
        dob: document.getElementById("ctl00_ContentPlaceHolder1_txtfromdate").value, time1: document.getElementById("ctl00_ContentPlaceHolder1_txtstarttime").value,
        dob2: document.getElementById("ctl00_ContentPlaceHolder1_txtenddate").value, time2: document.getElementById("ctl00_ContentPlaceHolder1_txtendtime").value, isalldayevent: isallday, eventttype: isPublicevent, loginid: cal_loginid, layerid: document.getElementById("Dashboard_hidEventColor").value, repeat: repeat, location: document.getElementById("ctl00_ContentPlaceHolder1_txtlocation").value, repeat: repeat, companyid: document.getElementById("hidcompanyid").value
    };

    $.ajax({
        type: "POST",
        contentType: "application/json",
        data: JSON.stringify(args),

        url: pagename + "/AddNewEvent",
        dataType: "json",
        success: function (data) {
            document.getElementById('ifevent').contentWindow.mapevents();

            $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').css('display', 'none');

            alert("Saved Successfully!");
            blankEvent();
            closediv();


        },
        error: function (x, e) {
            $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();
        }

    });



}
function getSchdetail(id) {
    $("#tblschdetail tbody").empty();
    $("#divschdes").empty();
    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
    var str = '';
    var args = { companyid: $('#hidcompanyid').val(), nid: id };

    $.ajax({

        type: "POST",
        url: pagename + "/getSchDetailData",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {

            if (data.d != "failure") {

                var jsonarr = $.parseJSON(data.d);


                if (jsonarr.length > 0) {


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

                        str = str + '</tr>';


                    });


                    $("#tblschdetail tbody").append(str);
                    opendiv("divSchDetail");

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

function setEventHTML(strall, strevent, strsch, strapp) {
     $("#tabAllEvent_Detail").html(strall);
            $("#tabEvent_Detail").html(strevent);
            $("#tabAPP_Detail").html(strapp);
            $("#tabSch_Detail").html(strsch);

            $(".linkEvent").click(function () {
                var newid = $(this).attr("id");
                newid = newid.replace("linkEvent", "");
                fillevent_detail(newid);

            });
            $(".linkAppointment").click(function () {
                var newid = $(this).attr("id");
                newid = newid.replace("linkAppointment", "");
                viewAppdetail(newid);

            });

            $(".linkSchedule").click(function () {
                var newid = $(this).attr("id");
                newid = newid.replace("linkSchedule", "");
                getSchdetail(newid);

            });
}

function viewAppdetail(id) {
 

    $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").show();

    var args1 = { nid: id, fromdate: "", todate: "", status: "", companyid: "" };
    $.ajax({
        type: "POST",
        contentType: "application/json",
        data: JSON.stringify(args1),
        url: pagename+"/getAppointments",
        dataType: "json",
        success: function (data) {

            if (data.d != "failure") {

                jsonarr = jQuery.parseJSON(data.d);

                if (jsonarr.length > 0) {


                    for (var i in jsonarr) {

                       

                        var str = '';

                        document.getElementById("view_Status").innerHTML = jsonarr[i].curStatus;
                        document.getElementById("view_Time").innerHTML = jsonarr[i].adate1 + ' ' + jsonarr[i].frmTime + ' to ' + jsonarr[i].ToTime;
                        document.getElementById("view_Service").innerHTML = jsonarr[i].service;
                        document.getElementById("view_emp").innerHTML = jsonarr[i].empname;

                        str = jsonarr[i].vName + ', <span class="appoint_desig">' + jsonarr[i].designation + '</span><br/>';
                        str = str + '<span class="appoint_company">' + jsonarr[i].company + '</span>';
                        str = str + '<span class="appoint_email">' + jsonarr[i].email + '</span>';
                        str = str + '<span class="appoint_contact">' + jsonarr[i].contactno + '</span>';

                        document.getElementById("view_visitor").innerHTML = str;

                        $('#view_Status').addClass('status_' + jsonarr[i].curStatus);

                       
                    }
                    opendiv("divviewappointment");

                }

                $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();

            }




        },
        error: function (x, e) {
            $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();
        }

    });
}
$(document).ready(function () {

    fillchart("Top Ten Employees", "loadertopemp", "charttopEmp", 'scheme05','Hours X Bill Rate');
    fillchart("Top Ten Expenses", "chartloader", "charttopexp", 'scheme03', 'Amount');
    fillchart("Top Ten Activities", "loadertopact", "charttopact", 'scheme04', 'Hours X Bill Rate');
    fillchart("Monthly Billing", "loaderMonthBilling", "chartMonthBilling", 'scheme05','Amount');
    fillmonthlychar();
    fillInvoices();
    $('#ctl00_ContentPlaceHolder1_txtstarttime').timepicker({

        'step': function (i) {
            return (i % 2) ? 15 : 45;
        }

    });
    $('#ctl00_ContentPlaceHolder1_txtendtime').timepicker({
        'step': function (i) {
            return (i % 2) ? 15 : 45;
        }
    });
    

    $(".eventtab_link").click(function () {
        var newid = $(this).attr("id");
        newid = newid.replace("linkvieinv", "");
        $('.tab-pane').removeClass("active");
        $('.eventtab_link').removeClass("active");
        $("#" + newid).addClass("active");
        $("#" + newid+"_Detail").addClass("active");
    });


    if (document.getElementById("Dashboard_hidAddPEvent").value != "1") {
        document.getElementById('ctl00_ContentPlaceHolder1_chkeventtype').checked = false;


        document.getElementById('divpublicevent').style.display = "none";
    }

    var input = document.getElementById('ctl00_ContentPlaceHolder1_txtlocation');
    var autocomplete = new google.maps.places.Autocomplete(input);

});