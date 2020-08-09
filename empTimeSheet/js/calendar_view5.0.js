var str_layerid = "";

var pagename = "AdminDashboard.aspx";


function fn_downloadfile(id) {
    if (document.getElementById("ifdownload") == null) {
        var iframe = document.createElement("iframe");
        iframe.id = "ifdownload";
        iframe.src = encodeURI("downloadfile.aspx?id=" + id);
        iframe.style.display = "none";
        document.body.appendChild(iframe);
    }
    else {
        document.getElementById("ifdownload").src = encodeURI("downloadfile.aspx?id=" + id);

    }
}





function fillstandarddetail(id1) {
    var args = { id: id1 };
    $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").show();
    $.ajax({
        type: "POST",
        contentType: "application/json",
        data: JSON.stringify(args),
        url: "CalendarView.aspx/GetStandardDetail",
        dataType: "json",
        success: function (data) {
            $.each(data, function (k, v) {
                document.getElementById('tdtitle').innerHTML = '<span style="color:#2a3542; font-size:13px;">' + v[0].title + '(' + v[0].titlecode + ')</span><br/>' + v[0].subtitle;
                document.getElementById('tdstandardcode').innerHTML = '<b>' + v[0].standardcode;
                document.getElementById('tdstandard').innerHTML = v[0].standard;
                document.getElementById('tdpractice').innerHTML = v[0].practice;
                document.getElementById('tdexample').innerHTML = v[0].example;
            });
            $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();
            setposition('divstandarddetail');
            document.getElementById('divstandarddetail').style.display = 'block';
            document.getElementById('otherdiv').style.display = 'block';
            document.getElementById("divlayercreation").style.display = 'none';


        },
        error: function (x, e) {

            $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();
            alert('Server error!');
        }

    });

}






function converttime(valtime) {
    var time = valtime;
    var hours = Number(time.match(/^(\d+)/)[1]);
    var minutes = Number(time.match(/:(\d+)/)[1]);
    var AMPM = time.match(/\s(.*)$/)[1];
    if (AMPM == "PM" && hours < 12) hours = hours + 12;
    if (AMPM == "AM" && hours == 12) hours = hours - 12;
    var sHours = hours.toString();
    var sMinutes = minutes.toString();
    if (hours < 10) sHours = "0" + sHours;
    if (minutes < 10) sMinutes = "0" + sMinutes;
    return sHours + ":" + sMinutes;

}
function isTouchDevice() {
    var ua = navigator.userAgent;
    var isTouchDevice = (ua.match(/iPad/i) || ua.match(/iPhone/i) || ua.match(/iPod/i) || ua.match(/Android/i));

    return isTouchDevice;
}







$(document).ready(function () {


    /* initialize the calendar
    -----------------------------------------------------------------*/

    initilizefullcalendar();







});




function initilizefullcalendar() {
    var strall = "", strevent = "", strapp = "", strsch = "";
    var cal_loginid = window.parent.document.getElementById("hidchatloginid").value;

    var args = { userid: cal_loginid, nid: "", companyid: window.parent.document.getElementById("hidcompanyid").value };

    $.ajax({
        type: "POST",
        contentType: "application/json",
        data: JSON.stringify(args),
        url: pagename + "/GetEvents1",
        dataType: "json",
        success: function (data) {
            var monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Octr", "Nov", "Dec" ];
            $.map(data.d, function (item, i) {
                var date = new Date(item.EndTime);
              
                var str = "";
                str += '<div class="box">';
                str += '<div class="col-lg-9 col-sm-9 col-xs-12 pad"><div class="tab-date link' + item.recType + '"  id="link' + item.recType + item.NID + '"> <h2>' + item.daynum + '</h2> <span>' + monthNames[item.monthnum-1] + '</span> </div>  <div class="tab-info"><h3>' + item.EventName + '</h3><p>' + item.Description + '</p></div> </div>';
                str += '<div class="col-lg-3 col-sm-3 col-xs-12"><div class="time-type-box"><div class="tab-time">';

                if (item.recType == "Event")
                {
                    str += '<img src="images/icon1.png" alt="" />&nbsp;&nbsp;Event</div>';
                }
                else if (item.recType == "Schedule") {
                    str += '<img src="images/icon2.png" alt="" />&nbsp;&nbsp;Schedule</div>';
                }
                else {
                    str += '<img src="images/icon3.png" alt="" />&nbsp;&nbsp;Appointment</div>';
                }
                if (item.StartTime != "") {
                    str += '<div class="clear"></div><div class="tab-time eventtime"> <img src="images/clock.png" alt="" />&nbsp;&nbsp;' + item.StartTime + '</div>';

                }
                str += ' </div></div></div>';

                strall += str;

                if (item.recType == "Event") {
                    strevent += str;
                }
                else if (item.recType == "Schedule") {
                    strsch += str;
                }
                else {
                    strapp += str;
                }
                              
               
            });
            window.parent.setEventHTML(strall,strevent,strsch,strapp);
           


            $('#calendar').fullCalendar({

                header: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'month,agendaWeek,agendaDay'
                },
                height: 420,
                timeFormat: {
                    agenda: 'h:mm tt'
                },
                disableDragging:true,
                dayNamesShort: ['S', 'M', 'T', 'W', 'T', 'F', 'S'],
                dayClick: function (date, jsEvent, view) {

                    // alert('Clicked on: ' + date.format());

                    if (window.parent.document.getElementById("Dashboard_hidAddPEvent").value == "1" || window.parent.document.getElementById("Dashboard_hidAddEvent").value == "1") {
                        window.parent.blankEvent();
                        var startdate = date.format();
                        startdate = window.parent.setDateFromat(startdate);
                        window.parent.document.getElementById("ctl00_ContentPlaceHolder1_txtfromdate").value = startdate;
                        window.parent.document.getElementById("ctl00_ContentPlaceHolder1_txtenddate").value = startdate;
                        window.parent.opendiv("divevents");
                    }

                    // alert('Current view: ' + view.name);

                    // change the day's background color just for fun


                },
                editable: false,


                droppable: false, // this allows things to be dropped onto the calendar
                dayRender: function (date, cell) {

                    cell.addTouch();

                },
                


                eventReceive: function (event) {

                    var str_time = event.eventtime;
                    var str_eventdate = event.start;
                    var str_layerid = event.layerid;
                    var str_standardid = event.standardid;


                    var args1 = { eventdate: str_eventdate, eventtime: str_time, layerid: str_layerid, standardid: str_standardid, userid: cal_loginid, addedby: cal_loginid };
                    $.ajax({
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify(args1),
                        url: "CalendarView.aspx/addevent",
                        dataType: "json",
                        success: function (data) {

                            event.id = data.d;

                        },
                        error: function (x, e) {

                        }

                    });


                },
                //eventDragStop: function (event, jsEvent) {



                //},
                eventDrop: function (event, dayDelta, revertFunc) {


                    var str_eventid = event.id;

                    var str_eventdate = event.start;
                    var str_eventEnddate = event.end;
                    alert(str_eventEnddate);
                    if (str_eventEnddate == null || str_eventEnddate == "")
                        str_eventEnddate = str_eventdate;

                    var args1 = { eventid: str_eventid, eventdate: str_eventdate, enddate: str_eventEnddate, userid: cal_loginid };

                    $.ajax({
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify(args1),
                        url: "AdminDashboard.aspx/updateevent",
                        dataType: "json",
                        success: function (data) {
                            if (data.d == "notallowed") {
                                alert("This event created by other user you can't modify");
                                revertFunc();
                            }
                            $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();

                        },
                        error: function (x, e) {
                            $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();
                        }

                    });

                },

                eventClick: function (calEvent, jsEvent, view) {



                    window.parent.filleventdetail(calEvent.id, calEvent.rectype);




                },


                events: $.map(data.d, function (item, i) {
                    var event = new Object();
                    event.standardid = item.EventID;
                    event.start = new Date(item.StartDate);
                    event.end = new Date(item.EndDate);
                    event.title = item.EventName;
                    event.layerid = item.LayerID;
                    event.color = item.Color;
                    event.id = item.NID;
                    event.userid = item.Userid;
                    event.rectype = item.recType;
                    event.className = item.classname;
                    return event;
                })
            });

            //    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').css('display', 'none');


        },


        eventRender: function (event, element) {
            if (event.Userid != cal_loginid) {
                event.editable = false;
            }
        },


        error: function (XMLHttpRequest, textStatus, errorThrown) {
            debugger;

        }
    });


}



function isOverlapping(event) {
    var calendar = $('#calendar');
    var array = calendar.fullCalendar('clientEvents');

    for (i in array) {
        if (array[i].id == event.id) {
            return true;
        }
    }

    return false;
}



function mapevents() {
    $('#calendar').fullCalendar('removeEvents');
    initilizefullcalendar();

}
function setcalendar(id1, chkid) {

    var check = "";
    if (chkid == null || chkid == "") {
        check = "Subscribe";
    }
    else {
        if (document.getElementById(chkid).checked) {
            check = "ActiveLayer";
        }
        else {
            check = "InactiveLayer";
        }
    }


    var cal_loginid = window.parent.document.getElementById("hidchatloginid").value;
    var args = { userid: cal_loginid, layerid: id1, status: check, companyid: window.parent.document.getElementById("hidcompanyid").value };
    var event = new Object();

    $.ajax({
        type: "POST",
        contentType: "application/json",
        data: JSON.stringify(args),
        url: pagename + "/GetEvents1",
        dataType: "json",
        success: function (data) {
            $.map(data.d, function (item, i) {

                if (check == "ActiveLayer" || check == "Subscribe") {
                    var myCalendar = $('#calendar');
                    myCalendar.fullCalendar();
                    var event = new Object();
                    event.standardid = item.EventID;
                    event.start = new Date(item.StartDate);
                    event.end = new Date(item.EndDate);
                    event.title = item.EventName;
                    event.layerid = item.LayerID;
                    event.color = item.Color;
                    event.id = item.NID;
                    if (!isOverlapping(event))
                        myCalendar.fullCalendar('renderEvent', event);

                }
                else {

                    $('#calendar').fullCalendar('removeEvents', item.NID);

                }
                return i;
            });





        },
        error: function (x, e) {

        }

    });


}



