<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="ClientSchedule.aspx.cs" Inherits="empTimeSheet.ClientSchedule" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit.HTMLEditor"
    TagPrefix="ajaxeditor" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%--  <script src="js/jquery.min.js"></script>
    <script type="text/javascript" src="js/jquery-ui.js"></script>--%>
    <script src="js/jquery.table2excel.js"></script>
    <link rel="stylesheet" href="js/jquery.timepicker.css" type="text/css" />
    <link href="css/schedule_5.0.css" rel="stylesheet" />
    <link href='js/calendar/fullcalendar5.0.css' rel='stylesheet' />
    <link href="js/calendar/fullcalendar.min.css" rel="stylesheet" />
    <style type="text/css">
        #calendar {
            width: 99%;
            margin: 0px auto;
        }

        .fc th, .fc td {
            border: 0px !important;
        }

        .fc-year-view .txthiglitedpt, .fc-year-view .fc-start {
            width: 10px;
            height: 10px;
            margin: 0 auto;
            color: transparent !important;
        }

        .fc-year-view .txthiglited {
            background: rgb(194, 206, 218);
            color: #ffc400 !important;
            border: 0px !important;
        }

        .fc-ltr .fc-year-view .fc-day-top .fc-day-number {
            float: none;
        }

        .divdrop .droplist {
            z-index: 999 !important;
        }

        span.clrtag {
            width: 10px;
            height: 10px;
            float: left;
            margin-right: 5px;
            line-height: 0 !important;
        }

        .fc-year-view td[colspan]:not([colspan="1"]) > .txthiglitedpt {
            width: auto !important;
        }

        td[colspan]:not([colspan="1"]) {
        }

        #colorcodes label {
            float: left;
            padding: 10px;
            line-height: 11px;
        }
    </style>
    <%--<script src="js/calendar/lib/jquery.min.js"></script>--%>

    <%--<script src="js/calendar/lib/moment.min.js"></script>--%>
    <script src="//cdnjs.cloudflare.com/ajax/libs/moment.js/2.10.6/moment.js"></script>
    <%--<script src="js/calendar/lib/jquery-ui.custom.min.js"></script>--%>
    <script src="js/calendar/fullcalendar.min.js"></script>
    <%--<script src="js/calendar/lib/jquery.ui.touch.js"></script>--%>
    <%--<script src="js/calendar_view5.0.js"></script>--%>


    <script>
        var colorArray = [
"#63b598", "#ce7d78", "#ea9e70", "#a48a9e", "#c6e1e8", "#648177", "#0d5ac1",
"#f205e6", "#1c0365", "#14a9ad", "#4ca2f9", "#a4e43f", "#d298e2", "#6119d0",
"#d2737d", "#c0a43c", "#f2510e", "#651be6", "#79806e", "#61da5e", "#cd2f00",
"#9348af", "#01ac53", "#c5a4fb", "#996635", "#b11573", "#4bb473", "#75d89e",
"#2f3f94", "#2f7b99", "#da967d", "#34891f", "#b0d87b", "#ca4751", "#7e50a8",
"#c4d647", "#e0eeb8", "#11dec1", "#289812", "#566ca0", "#ffdbe1", "#2f1179",
"#935b6d", "#916988", "#513d98", "#aead3a", "#9e6d71", "#4b5bdc", "#0cd36d",
"#250662", "#cb5bea", "#228916", "#ac3e1b", "#df514a", "#539397", "#880977",
"#f697c1", "#ba96ce", "#679c9d", "#c6c42c", "#5d2c52", "#48b41b", "#e1cf3b",
"#5be4f0", "#57c4d8", "#a4d17a", "#0225b8", "#be608b", "#96b00c", "#088baf",
"#f158bf", "#e145ba", "#ee91e3", "#05d371", "#5426e0", "#4834d0", "#802234",
"#6749e8", "#0971f0", "#8fb413", "#b2b4f0", "#c3c89d", "#c9a941", "#41d158",
"#fb21a3", "#51aed9", "#5bb32d", "#807fb0", "#21538e", "#89d534", "#d36647",
"#7fb411", "#0023b8", "#3b8c2a", "#986b53", "#f50422", "#983f7a", "#ea24a3",
"#79352c", "#521250", "#c79ed2", "#d6dd92", "#e33e52", "#b2be57", "#fa06ec",
"#1bb699", "#6b2e5f", "#64820f", "#1c271", "#21538e", "#89d534", "#d36647",
"#7fb411", "#0023b8", "#3b8c2a", "#986b53", "#f50422", "#983f7a", "#ea24a3",
"#79352c", "#521250", "#c79ed2", "#d6dd92", "#e33e52", "#b2be57", "#fa06ec",
"#1bb699", "#6b2e5f", "#64820f", "#1c271", "#9cb64a", "#996c48", "#9ab9b7",
"#06e052", "#e3a481", "#0eb621", "#fc458e", "#b2db15", "#aa226d", "#792ed8",
"#73872a", "#520d3a", "#cefcb8", "#a5b3d9", "#7d1d85", "#c4fd57", "#f1ae16",
"#8fe22a", "#ef6e3c", "#243eeb", "#1dc18", "#dd93fd", "#3f8473", "#e7dbce",
"#421f79", "#7a3d93", "#635f6d", "#93f2d7", "#9b5c2a", "#15b9ee", "#0f5997",
"#409188", "#911e20", "#1350ce", "#10e5b1", "#fff4d7", "#cb2582", "#ce00be",
"#32d5d6", "#17232", "#608572", "#c79bc2", "#00f87c", "#77772a", "#6995ba",
"#fc6b57", "#f07815", "#8fd883", "#060e27", "#96e591", "#21d52e", "#d00043",
"#b47162", "#1ec227", "#4f0f6f", "#1d1d58", "#947002", "#bde052", "#e08c56",
"#28fcfd", "#bb09b", "#36486a", "#d02e29", "#1ae6db", "#3e464c", "#a84a8f",
"#911e7e", "#3f16d9", "#0f525f", "#ac7c0a", "#b4c086", "#c9d730", "#30cc49",
"#3d6751", "#fb4c03", "#640fc1", "#62c03e", "#d3493a", "#88aa0b", "#406df9",
"#615af0", "#4be47", "#2a3434", "#4a543f", "#79bca0", "#a8b8d4", "#00efd4",
"#7ad236", "#7260d8", "#1deaa7", "#06f43a", "#823c59", "#e3d94c", "#dc1c06",
"#f53b2a", "#b46238", "#2dfff6", "#a82b89", "#1a8011", "#436a9f", "#1a806a",
"#4cf09d", "#c188a2", "#67eb4b", "#b308d3", "#fc7e41", "#af3101", "#ff065",
"#71b1f4", "#a2f8a5", "#e23dd0", "#d3486d", "#00f7f9", "#474893", "#3cec35",
"#1c65cb", "#5d1d0c", "#2d7d2a", "#ff3420", "#5cdd87", "#a259a4", "#e4ac44",
"#1bede6", "#8798a4", "#d7790f", "#b2c24f", "#de73c2", "#d70a9c", "#25b670",
"#88e9b8", "#c2b0e2", "#86e98f", "#ae90e2", "#1a806b", "#436a9e", "#0ec0ff",
"#f812b3", "#b17fc9", "#8d6c2f", "#d3277a", "#2ca1ae", "#9685eb", "#8a96c6",
"#dba2e6", "#76fc1b", "#608fa4", "#20f6ba", "#07d7f6", "#dce77a", "#77ecca"]
        $(document).ready(function () {
            initilizefullcalendarx();
        });
        function initilizefullcalendarx() {
            $(".txthiglitedpt").removeClass("txthiglitedpt");
            $(".txthiglited").removeClass("txthiglited");
            //  $('#calendar').fullCalendar('destroy')
            var strall = "", strevent = "", strapp = "", strsch = "";
            var cal_loginid = window.parent.document.getElementById("hidchatloginid").value;


            var clients = "";
            $("#dropclient").find("[type=checkbox]").each(function (index, item) {
                if ($(item).prop("checked") == true) {

                    if (clients == "") {
                        clients = $(item).attr("val");
                    } else {
                        clients = clients + "," + $(item).attr("val");
                    }
                } else { }
            })

            var emps = "";
            $("#dropemployee").find("[type=checkbox]").each(function (index, item) {
                if ($(item).prop("checked") == true) {

                    if (emps == "") {
                        emps = $(item).attr("val");
                    } else {
                        emps = emps + "," + $(item).attr("val");
                    }
                } else { }
            })

            var args = {
                userid: cal_loginid,
                nid: "",
                companyid: window.parent.document.getElementById("hidcompanyid").value,
                status: $("#dropstatus").val(),
                client: clients,
                project: '',
                employee: emps
            };

            $.ajax({
                type: "POST",
                contentType: "application/json",
                data: JSON.stringify(args),
                url: pagename + "/GetEvents",
                dataType: "json",
                success: function (data) {
                    var monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Octr", "Nov", "Dec"];
                    $.map(data.d, function (item, i) {




                        // page is now ready, initialize the calendar...

                        var calendar = $('#calendar').fullCalendar({
                            // put your options and callbacks here
                            header: {
                                left: 'prev,next today',
                                center: 'title',
                                right: 'year,month,basicWeek,basicDay'

                            },
                            timezone: 'local',
                            height: "auto",
                            selectable: true,
                            dragabble: true,
                            defaultView: 'year',
                            yearColumns: 4,

                            durationEditable: true,
                            bootstrap: false,

                            events: $.map(data.d, function (item, i) {

                                //var event = new Object();
                                //event.standardid = item.EventID;
                                //event.start = new Date(item.StartDate);
                                //event.end = new Date(item.EndDate);
                                //event.title = item.EventName;
                                //event.layerid = item.LayerID;
                                //event.color = item.Color;
                                //event.id = item.NID;
                                //event.userid = item.Userid;
                                //event.rectype = item.recType;
                                //event.className = item.classname;
                                //return event;
                                 //console.log(item.EndDate);
                                 //console.log(new Date(item.EndDate.split(' ')[0] + ' 11:00 PM'))
                                var event = new Object();
                                event.title = item.EventName;
                                event.start = new Date(item.StartDate);
                                event.end = new Date(item.EndDate.split(' ')[0] + ' 11:00 PM');
                                event.id = item.NID.replace(new RegExp(",", 'g'), "");
                                event.color = item.clientid <= 280 ? colorArray[item.clientid] : colorArray[item.clientid % 280];
                                event.allDay = true;
                                event.editable = true;
                                event.eventDurationEditable = true;

                                return event;
                            }),


                            dayClick: function (date, jsEvent, view) {

                                date = new Date(date);
                                blank(); opendiv('divaddnew');
                                $("#txtpopfrdate").val((date.getMonth() + 1) + "/" + date.getDate() + "/" + date.getFullYear());
                                $("#txtpoptodate").val((date.getMonth() + 1) + "/" + date.getDate() + "/" + date.getFullYear());


                            },
                            eventResize: function (event, delta, revertFunc) {

                                var str_eventid = event.id;

                                var str_eventdate = event.start;
                                var str_eventEnddate = event.end;

                                if (str_eventEnddate == null || str_eventEnddate == "")
                                    str_eventEnddate = str_eventdate;

                                var args1 = { schduleId: str_eventid, startDate: str_eventdate, endDate: str_eventEnddate };

                                $.ajax({
                                    type: "POST",
                                    contentType: "application/json",
                                    data: JSON.stringify(args1),
                                    url: "ClientSchedule.aspx/UpdateTime",
                                    dataType: "json",
                                    success: function (data) {
                                        if (data.d == "notallowed") {
                                            alert("This event created by other user you can't modify");
                                            revertFunc();
                                        }
                                        $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();
                                        filldata()

                                    },
                                    error: function (x, e) {
                                        $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();
                                    }

                                });

                            },
                            eventDrop: function (event, dayDelta, revertFunc) {


                                var str_eventid = event.id;

                                var str_eventdate = event.start;
                                var str_eventEnddate = event.end;

                                if (str_eventEnddate == null || str_eventEnddate == "")
                                    str_eventEnddate = str_eventdate;

                                var args1 = { schduleId: str_eventid, startDate: str_eventdate, endDate: str_eventEnddate };

                                $.ajax({
                                    type: "POST",
                                    contentType: "application/json",
                                    data: JSON.stringify(args1),
                                    url: "ClientSchedule.aspx/UpdateTime",
                                    dataType: "json",
                                    success: function (data) {
                                        if (data.d == "notallowed") {
                                            alert("This event created by other user you can't modify");
                                            revertFunc();
                                        }
                                        $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();
                                        filldata()

                                    },
                                    error: function (x, e) {
                                        $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();
                                    }

                                });

                            },

                            eventClick: function (calEvent, jsEvent, view) {



                                // window.parent.filleventdetail(calEvent.id, calEvent.rectype);

                                getdetailforEdit1(calEvent.id, calEvent.id);


                            },
                            eventRender: function (event, element) {
                                $(element).addClass("txthiglitedpt");

                               // $("td[data-date=" + event.start.format('YYYY-MM-DD') + "]").addClass("txthiglited");
                            },
                        })
                    });
                }
            })



        }


        function getdetailforEdit1(id, xnid) {
            
            blank();
            $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
            var args = { companyid: $('#hidcompanyid').val(), nid: xnid };
             
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
                            var endd = jsonarr[0].enddate;
                            console.log(schDet_date.split('-').length);
                            if (schDet_date.split('-').length > 1) {
                                $('#txtpopfrdate').val(schDet_date.split('-')[1] + "/" + schDet_date.split('-')[2] + "/" + schDet_date.split('-')[0]);
                            } else {
                                $('#txtpopfrdate').val(schDet_date);
                            }
                            if (endd.split('-').length > 1) {
                                $('#txtpoptodate').val(endd.split('-')[1] + "/" + endd.split('-')[2] + "/" + endd.split('-')[0]);
                            } else {
                                $('#txtpoptodate').val(endd);
                            }

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
                           // $('#divtodate').hide();
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
        function refereshcalendar() {


            $(".txthiglitedpt").removeClass("txthiglitedpt");
            $(".txthiglited").removeClass("txthiglited");

            var strall = "", strevent = "", strapp = "", strsch = "";
            var cal_loginid = window.parent.document.getElementById("hidchatloginid").value;


            
            $("#colorcodes").empty();
            $("#colorcodes").show();
             




            var clients = "";
            var addemp = true;
            $("#dropclient").find("[type=checkbox]").each(function (index, item) {
                if ($(item).prop("checked") == true) {
                    var ccid = parseInt($(item).attr("val"));
                    $("#colorcodes").append("<label><span class='clrtag' style='background:" + (ccid <= 280 ? colorArray[ccid] : colorArray[ccid % 280]) + "'></span>" + $(this).parent().find("label").html() + "</label>")
                    addemp = false;
                    if (clients == "") {
                        clients = $(item).attr("val");
                    } else {
                        clients = clients + "," + $(item).attr("val");
                    }
                } else { }
            })
         
           
            var emps = "";
            $("#dropemployee").find("[type=checkbox]").each(function (index, item) {
                if ($(item).prop("checked") == true) {
                    if (addemp == true) {
                        var ccid = parseInt($(item).attr("val"));
                        $("#colorcodes").append("<label><span class='clrtag' style='background:" + (ccid <= 280 ? colorArray[ccid] : colorArray[ccid % 280]) + "'></span>" + $(this).parent().find("label").html() + "</label>")
                    }
                    if (emps == "") {
                        emps = $(item).attr("val");
                    } else {
                        emps = emps + "," + $(item).attr("val");
                    }
                } else { }
            })

            var args = {
                userid: cal_loginid,
                nid: "",
                companyid: window.parent.document.getElementById("hidcompanyid").value,
                status: $("#dropstatus").val(),
                client: clients,//$("#ctl00_ContentPlaceHolder1_dropclient").val(),
                project: '',
                employee: emps,//$("#ctl00_ContentPlaceHolder1_dropemployee").val()
            };

            $.ajax({
                type: "POST",
                contentType: "application/json",
                data: JSON.stringify(args),
                url: pagename + "/GetEvents",
                dataType: "json",
                success: function (data) {

                    var events = $.map(data.d, function (item, i) {

                        var color = item.clientid <= 280 ? colorArray[item.clientid] : colorArray[item.clientid % 280];
                        if (addemp == true) {
                           
                            color = parseInt(item.empid.split(',')[0])
                                <= 280 ? colorArray[parseInt(item.empid.split(',')[0])] :
                                colorArray[parseInt(item.empid.split(',')[0]) % 280];
                        }

                        var event = new Object();

                        event.start = new Date(item.StartDate);
                        event.end = new Date(item.EndDate);
                        event.title = item.EventName;
                        event.color = color;//item.clientid <= 280 ? colorArray[item.clientid] : colorArray[item.clientid % 280];
                        event.id = item.NID.replace(new RegExp(",", 'g'), "");
                        event.allDay = true;
                        event.editable = true;
                        event.eventDurationEditable = true;
                        return event;
                    })
                   
                    $('#calendar').fullCalendar('removeEvents');
                    $('#calendar').fullCalendar('addEventSource', events);
                    $('#calendar').fullCalendar('refetchEvents');
                    if (events.length == 0) {
                        alert("client/employee not scheduled.");

                    }



                },


                eventRender: function (event, element) {
                    if (event.Userid != cal_loginid) {
                        event.editable = false;
                    }
                },


                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    

                }
            });

        }
        


    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <pg:progress ID="progress1" runat="server" />

    <div id="schBackOtherdiv" class="otherdiv" onclick="closeSchBackdiv();" style="z-index: 1006">
    </div>
    <div id="otherdiv" onclick="closediv();">
    </div>




    <div id="divSchEmail" class="itempopup" style="width: 750px;">
        <div class="popup_heading">
            <span>Email Schedule</span>
            <div class="f_right">
                <img src="images/cross.png" onclick="closediv();" alt="X" title="Close
            Window" />
            </div>
        </div>
        <div style="margin: 15px auto;">
            <div class="col-sm-12 col-xs-12">
                <div class="ctrl" id="divreceiver">
                    <label class="col-sm-3 col-xs-12 lbl">Receiver : *</label>

                    <div class="col-sm-6 col-xs-12 w1">
                        <input type="text" id="txtreceiver" class="form-control" readonly />


                    </div>


                </div>
                <div class="clearfix"></div>
                <div class="ctrl">
                    <label class="col-sm-3 col-xs-12 lbl">Subject : *</label>

                    <div class="col-sm-9 col-xs-12 w1">
                        <input type="text" id="txtsubject" class="form-control" />


                    </div>


                </div>
                <div class="clearfix"></div>
                <div class="ctrl">


                    <div class="col-sm-12 col-xs-12 w1">

                        <ajaxeditor:Editor ID="htmleditor1" runat="server"
                            Height="350px" Width="99%" />
                    </div>

                </div>
                <div class="clearfix"></div>
                <div class="ctrl">
                    <div class="col-sm-12 col-xs-12">
                        <div class="f_right">
                            <input type="button" id="btnsendEmail" value="Send Email" class="btn btn-primary" />
                            <input type="button" value="Close" class="btn btn-default" onclick="closediv();" />
                        </div>
                    </div>
                </div>

            </div>
            <div class="clear"></div>


        </div>
    </div>
    <div id="divstatus" class="itempopup" style="width: 500px; z-index: 1007;">
        <div class="popup_heading">
            <span>Modify Status</span>
            <div class="f_right">
                <img src="images/cross.png" onclick="closeSchBackdiv();" alt="X" title="Close
            Window" />
            </div>
        </div>
        <div style="margin: 15px auto;">
            <div class="col-sm-12 col-xs-12">
                <div class="ctrl">
                    <label class="col-sm-3 col-xs-12 lbl">
                        Status:  *
                                                          
                    </label>
                    <div class="col-sm-7 col-xs-10">
                        <select id="ddlstaus" class="form-control" onchange="showdate(this.value);">
                            <option value="">Select One</option>
                            <option value="Confirmed by the Client">Confirmed by the Client</option>
                            <option value="Non-Confirmed by the Client">Non-Confirmed by the Client</option>
                            
                        </select>

                    </div>


                </div>
                <div class="clear">
                </div>
                <div class="ctrl" id="divdate">
                    <label class="col-sm-3 col-xs-12 lbl">
                        New Date : *
                                                          
                    </label>
                    <div class="col-sm-7 col-xs-10">
                        <input type="text" id="txtnewdate" class="form-control" />

                    </div>


                </div>
                <div class="clear">
                </div>
                <div class="ctrl">
                    <label class="col-sm-3 col-xs-12 lbl">
                        Remark :
                                                          
                    </label>
                    <div class="col-sm-9 col-xs-12">

                        <textarea id="txtremark" class="form-control" style="height: 40px;"></textarea>
                    </div>
                    <div class="clear">
                    </div>
                    <div class="ctrl">
                        <div class="col-sm-12 col-xs-12" style="text-align: right;">
                            <input type="button" id="btnsavestatus" value="Save" class="btn btn-primary" />
                        </div>
                    </div>

                </div>
            </div>
        </div>

    </div>
    <div id="divnonschedule" class="itempopup" style="width: 750px;">
        <div class="popup_heading">
            <span>Non-Scheduled Employees List</span>
            <div class="f_right">
                <img src="images/cross.png" onclick="closediv();" alt="X" title="Close
            Window" />
            </div>
        </div>
        <div style="margin: 15px auto;">

            <div class="col-sm-12 col-xs-12">
                <div class="ctrlGroup searchgroup">
                    <label class="lblAuto">From Date :</label>
                    <div class="txt w1 mar10">
                        <input type="text" class="form-control" id="txtnsfrmdate" />

                    </div>
                </div>
                <div class="ctrlGroup searchgroup">
                    <label class="lblAuto">To Date:</label>
                    <div class="txt w1 mar10">
                        <input type="text" class="form-control" id="txtnstodate" />

                    </div>
                </div>
                <div class="ctrlGroup searchgroup">
                    <label class="lblAuto">TWrok Type:</label>
                    <div class="txt w1 mar10">
                        <select class="form-control" id="dronsworktype">
                            <option value="Field" selected>Field Work</option>
                            <option value="Office">Office Work</option>
                        </select>

                    </div>
                </div>

                <div class="ctrlGroup searchgroup">
                    <input type="button" id="btnsearchns" class="btn btn-default" value="Search" />

                </div>
            </div>
            <div class="clear"></div>
            <div class="col-sm-12 col-xs-12">
                <table class="tblreport" id="tblNonschdetail">

                    <tbody>
                        <tr>
                            <td>
                                <div class="pop_datebox">
                                    <div class="pop_datebox_inner" id="pop_datebox_inner">
                                        <div class="datedetail">Wed <span>30 Aug </span></div>
                                        <div class="monthdetail">2017 </div>
                                    </div>
                                </div>
                                <div class="pop_detail">
                                </div>

                            </td>

                        </tr>
                    </tbody>
                </table>
            </div>

        </div>
    </div>

    <div id="divSchDetail" class="itempopup" style="width: 750px;">
        <div class="popup_heading">
            <span id="divschtitle">Schedule Detail</span>
            <div class="f_right">
                <img src="images/cross.png" onclick="closediv();" alt="X" title="Close
            Window" />
            </div>
        </div>
        <div style="margin: 15px auto;">
            <div class="col-sm-12 col-xs-12 schpop" id="divschdes">
            </div>
            <div class="clear"></div>
            <div class="col-sm-12 col-xs-12">
                <table class="tblreport" id="tblschdetail">
                    <thead>
                        <tr>

                            <th>Employee
                            </th>
                            <th>Type
                            </th>
                            <th>Status
                            </th>
                            <th>Remark
                            </th>
                            <th style="width: 30px; text-align: center;">Delete
                            </th>
                            <th style="width: 50px; text-align: center;">Modify Status
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Emp ID
                            </td>
                            <td>Emp Name
                            </td>
                            <td>Type
                            </td>
                            <td>Status
                            </td>
                            <td>Remark
                            </td>
                            <td style="text-align: center;">
                                <a title="Edit">
                                    <img src="images/edit.png"></a>
                            </td>
                            <td style="text-align: center;">
                                <a title="Delete">
                                    <img src="images/delete.png"></a>
                            </td>
                            <td style="text-align: center;">
                                <a title="Modify Status">
                                    <img src="images/user_online.png"></a>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

        </div>
    </div>

    <div style="width: 500px;" id="divaddnew" class="itempopup">
        <div class="popup_heading">
            <span id="legendaction">Schedule Employee</span>
            <div class="f_right">
                <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
            </div>
        </div>
        <div class="clear"></div>
        <div class="col-sm-12 col-xs-12">
            <div class="ctrl">
                <label class="col-sm-4 col-xs-12 lbl" id="lblfromdate">
                    From Date :  *
                                                          
                </label>
                <div class="col-sm-5 col-xs-12">
                    <input id="txtpopfrdate" type="text" class="form-control" />

                </div>

            </div>
            <div class="clear"></div>
            <div class="ctrl" id="divtodate">

                <label class="col-sm-4 col-xs-12 lbl ">
                    To Date :  *
                </label>
                <div class="col-sm-5 col-xs-12">
                    <input id="txtpoptodate" type="text" class="form-control" />

                </div>
            </div>
            <div class="clear"></div>
            <div class="ctrl">
                <label class="col-sm-4 col-xs-12 lbl">
                    Time :  
                                                          
                </label>
                <div class="col-sm-4 col-xs-12">
                    <input id="drppophour" type="text" class="form-control" />

                </div>


            </div>

            <div class="clear"></div>
            <div class="ctrl">
                <label class="col-sm-4 col-xs-12 lbl">
                    Work Type :  *
                </label>
                <div class="col-sm-5 col-xs-12">
                    <select class="form-control" id="rdbtnscheduleType" onchange="showhidestatus();">
                        <option value="Field">Field Work</option>
                        <option value="Office">Office Work</option>
                    </select>

                </div>
            </div>
            <div class="clear"></div>
            <div class="ctrl">
                <label class="col-sm-4 col-xs-12 lbl">
                    Client :  *
                                                          
                </label>
                <div class="col-sm-8 col-xs-12">
                    <input id="drppopclient" type="text" class="form-control" />
                    <input type="hidden" id="hiddropclient" />
                </div>


            </div>
            <div class="clear"></div>
            <div class="ctrl">
                <label class="col-sm-4 col-xs-12 lbl ">
                    Project :  *
                </label>
                <div class="col-sm-8 col-xs-12">
                    <input id="ddlproject" type="text" class="form-control" />
                    <input type="hidden" id="hidddlproject" />

                </div>
            </div>


            <div class="clear"></div>
            <div class="ctrl">
                <label class="col-sm-4 col-xs-12 lbl">
                    Employee :  *
                                                          
                </label>
                <div class="col-sm-8 col-xs-12">

                    <div class="divdrop w1">
                        <div class="dropctrl" id="dropemp"></div>
                        <div class="clearfix"></div>
                        <div class="droplist" id="dropemp_detail">
                            <ul class="dropemp_innner">
                            </ul>

                        </div>
                    </div>

                </div>
            </div>
            <div class="clear"></div>
            <div class="ctrl" id="divdefaultstatus">
                <label class="col-sm-4 col-xs-12 lbl " id="lbldefstatus">
                    Default Status :  *
                  
                </label>
                <div class="col-sm-8 col-xs-12">
                    <select class="form-control" id="drppopstatus">
                        <option value="">Select One</option>
                        <option value="Confirmed by the Client">Confirmed by the Client</option>
                        <option value="Non-Confirmed by the Client">Non-Confirmed by the Client</option>
                    </select>

                </div>
            </div>
            <div class="clear"></div>
            <div class="ctrl">
                <label class="col-sm-4 col-xs-12 lbl">
                    Remark :  
                                                          
                </label>
                <div class="col-sm-8 col-xs-12">

                    <textarea id="txtaddremark" class="form-control" style="height: 40px;"></textarea>
                </div>
            </div>
            <div class="clear"></div>
            <div class="ctrl">





                <div class="col-sm-12 col-xs-12">
                    <div class="f_right">
                        <input type="button" id="btnsubmit" value="Save" class="btn btn-primary" />
                        <input type="button" id="btnclose" value="Close" class="btn btn-default" onclick="closediv();" />
                    </div>
                </div>
            </div>
        </div>
    </div>


    <div class="pageheader">
        <h2>
            <i class="fa fa-table"></i>Client Schedule
        </h2>
        <input type="hidden" id="hidid" runat="server" />
        <div class="breadcrumb-wrapper mar ">
            <div class="f_right">
                <a onclick="blank();opendiv('divaddnew');" id="liaddnew" class="right_link">
                    <i class="fa fa-fw fa-plus topicon"></i>
                    New Schedule</a>

                <%--  <a id="linknonscemp" class="right_link">
                    <i class="fa fa-fw fa-circle-o topicon"></i>
                    Non-Scheduled Employee</a>--%>

                <a id="btnexportcsv" class="right_link">
                    <i class="fa fa-fw fa-file-excel-o topicon"></i>
                    Export to Excel</a>
            </div>
        </div>
        <div class="clear">
        </div>
    </div>

    <div class="row">
        <div class="col-sm-12 col-md-12">
            <div class="panel panel-default">
                <div class="col-sm-12 col-md-12 mar">
                    <div class="ctrlGroup searchgroup" style="display: none">
                        <label class="lblAuto">From Date :</label>
                        <div class="txt w1 mar10">
                            <input type="text" class="form-control" id="txtfrmdate" />

                        </div>
                    </div>
                    <div class="ctrlGroup searchgroup" style="display: none">
                        <label class="lblAuto">To Date:</label>
                        <div class="txt w1 mar10">
                            <input type="text" class="form-control" id="txttodate" />

                        </div>
                    </div>
                    <div class="ctrlGroup searchgroup">
                        <label class="lblAuto">Status :</label>
                        <div class="txt w1 mar10">

                            <select id="dropstatus" class="form-control">
                                <option value="">--All--</option>
                                <option value="Confirmed by the Client">Confirmed by the Client</option>
                                <option value="Non-Confirmed by the Client">Non-Confirmed by the Client</option>
                                 

                            </select>
                        </div>
                    </div>

                    <div class="ctrlGroup searchgroup">
                        <label class="lblAuto">Client :</label>
                        <div class="txt w1 mar10">


                            <asp:TextBox ID="txtclient" runat="server" CssClass="form-control pad3" ClientIDMode="Static" placeholder="--All Clients--" onkeypress="searchfilters(this.id,'dropclient');" onkeyup="searchfilters(this.id,'dropclient');" onkeydown="searchfilters(this.id,'dropclient');">
                            </asp:TextBox>

                            <ajaxToolkit:PopupControlExtender ID="PopupControlExtender1" runat="server" TargetControlID="txtclient"
                                PopupControlID="panelclient" Position="Bottom">
                            </ajaxToolkit:PopupControlExtender>
                            <asp:Panel ID="panelclient" runat="server" CssClass="poppanel">

                                <input type="checkbox" id="chkclient" onclick="checkall(this.id, 'dropclient', '--All Clients--', 'txtclient', 'client');" />
                                <span>Check All</span><div class="clear"></div>
                                <%--<asp:CheckBoxList ID="dropclient" runat="server" RepeatLayout="Table" Width="100%" ClientIDMode="Static" onchange="setcontent(this.id,'txtclient','--All Clients--','client');"></asp:CheckBoxList>--%>
                                <table id="dropclient" onchange="setcontent(this.id,'txtclient','--All Clients--','client');" border="0" style="width: 100%;">
                                    <tbody>
                                        <asp:Repeater ID="dropclient" runat="server">
                                            <ItemTemplate>
                                                <tr>
                                                    <td>
                                                        <input val="<%# Eval("nid") %>" id="dropclient_<%# Container.ItemIndex %>" type="checkbox" name="dropclient_<%# Container.ItemIndex %>">
                                                        <label for="dropclient_<%# Container.ItemIndex %>"><%# Eval("clientcodewithname") %></label></td>
                                                </tr>

                                            </ItemTemplate>
                                        </asp:Repeater>

                                    </tbody>
                                </table>

                            </asp:Panel>
                        </div>
                    </div>
                    <div class="ctrlGroup searchgroup">
                        <label class="lblAuto">Employee :</label>
                        <div class="txt w1 mar10">

                            <asp:TextBox ID="txtemployee" runat="server" CssClass="form-control pad3" ClientIDMode="Static" placeholder="--All Employees--" onkeypress="searchfilters(this.id,'dropemployee');" onkeyup="searchfilters(this.id,'dropemployee');" onkeydown="searchfilters(this.id,'dropemployee');">
                            </asp:TextBox>

                            <ajaxToolkit:PopupControlExtender ID="PopupControlExtender2" runat="server" TargetControlID="txtemployee"
                                PopupControlID="panelemployee" Position="Bottom">
                            </ajaxToolkit:PopupControlExtender>
                            <asp:Panel ID="panelemployee" runat="server" CssClass="poppanel">

                                <input type="checkbox" id="chkemployee" onclick="checkall(this.id, 'dropemployee', '--All Employee--', 'txtemployee', 'employee');" />
                                <span>Check All</span><div class="clear"></div>
                                <%--<asp:CheckBoxList ID="dropemployee" OnDataBound="dropemployee_DataBound" runat="server" RepeatLayout="Table" Width="100%" ClientIDMode="Static" onchange="setcontent(this.id,'txtemployee','--All Employee--','employee');"></asp:CheckBoxList>--%>
                                <table id="dropemployee" onchange="setcontent(this.id,'txtemployee','--All Employee--','employee');" border="0" style="width: 100%;">
                                    <tbody>
                                        <asp:Repeater ID="dropemployee" runat="server">
                                            <ItemTemplate>
                                                <tr>
                                                    <td>
                                                        <input val="<%# Eval("nid") %>" id="dropemployee_<%# Container.ItemIndex %>" type="checkbox" name="dropemployee_<%# Container.ItemIndex %>">
                                                        <label for="dropemployee_<%# Container.ItemIndex %>"><%# Eval("username") %></label></td>
                                                </tr>

                                            </ItemTemplate>
                                        </asp:Repeater>

                                    </tbody>
                                </table>
                            </asp:Panel>

                        </div>
                    </div>
                    <div class="ctrlGroup searchgroup">
                        <label class="lblAuto">&nbsp;</label>
                        <input type="button" id="btnsearch" class="btn btn-default" value="Search" />

                    </div>
                </div>

                <div style="display: none" class="col-sm-12 col-md-12 mar" id="colorcodes">
                </div>

                <div class="clear">
                </div>
                <div class="col-sm-12 col-md-12 mar">

                    <div class="clear">
                    </div>
                    <div class="panel panel-default" style="min-height: 300px;">
                        <div class="panel-body2 ">
                            <div class="row">
                                <div id='calendar'>
                                </div>
                                <div class="table-responsive" id="divschdata">
                                </div>
                                <div id="divdataloader" style="text-align: center;">
                                    <img src="images/loading.gif" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="clear">
                </div>
            </div>
        </div>
    </div>


    <style>
        .ctrlGroup {
            width: 16%;
        }

        .searchgroup .lblAuto {
            width: 100%;
        }
    </style>
    <%--<script src='js/calendar_view_main5.0.js' type="text/javascript"></script>--%>
    <script src="js/jquery.timepicker.js"></script>
    <script src="js/PageJs/schedulejs_5.0.js"></script>
</asp:Content>
