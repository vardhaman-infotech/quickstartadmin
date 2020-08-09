<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="test.aspx.cs" Inherits="empTimeSheet.test" %>

<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .pac-container {
            z-index: 9999999999 !important;
        }
    </style>
    <%--<link href="css/events.css" type="text/css" rel="Stylesheet" />--%>
    <!--Application Home/ Dashboard-->

    <link rel="stylesheet" href="js/jquery.timepicker.css" type="text/css" />

    <link rel="stylesheet" href="css/dashboard.css" type="text/css" />
    <link href='js/calendar/fullcalendar.css' rel='stylesheet' />



    <script type="text/javascript">
        //Close events list popup
        function closeventediv() {

            document.getElementById("divevents").style.display = "none";
            document.getElementById("divShowevent").style.display = "none";
            document.getElementById("otherdiv").style.display = "none";

        }
        //Open events list popup
        function openeventdiv() {
            setposition("divevents");
            document.getElementById("divevents").style.display = "block";
            document.getElementById("otherdiv").style.display = "block";



        }

        //close all events popup either it is list or detail




        $(window).resize(function () {
            setposition("divevents");
        });




    </script>


    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCumcmPhxv_y-77BrKoPQiGo5Qwb-I02uY&libraries=places"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <pg:progress ID="progress1" runat="server" />
    <div id="divcompanyloader" style="display: none; position: absolute; z-index: 999999999; text-align: center;">

        <img src="images/pleasewait.gif" />
        Loading...
       
    </div>
    <input type="hidden" id="Dashboard_hidAddEvent" runat="server" clientidmode="Static" />
    <input type="hidden" id="Dashboard_hidAddPEvent" runat="server" clientidmode="Static" />
    <div id="otherdiv" onclick="closeventediv();">
    </div>
    <div style="display: none; width: 700px;" id="divevents" class="itempopup">
        <div class="popup_heading">
            <span id="legendaction" runat="server">Event Managemnt </span>
            <div class="f_right">
                <img src="images/cross.png" onclick="closeventediv();" alt="X" title="Close Window" />
            </div>
        </div>

        <div class="tabContents" style="display: block;">

            <div class="ctrlGroup">
                <label class="lbl">
                    Event Title :
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txttitle"
                                    ValidationGroup="saveevent" ErrorMessage="*" CssClass="errmsg"></asp:RequiredFieldValidator>
                </label>
                <div class="txt w3">
                    <asp:TextBox ID="txttitle" runat="server" CssClass="form-control" Width="98%" onKeyUp="checkLength(this.id,500);"></asp:TextBox>
                </div>
            </div>
            <div class="clear"></div>
            <div class="ctrlGroup">
                <label class="lbl">
                    Description :<asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                        ControlToValidate="txtdesc" ErrorMessage="*" ValidationGroup="saveevent"
                        CssClass="errmsg"></asp:RequiredFieldValidator>
                </label>
                <div class="txt w3">
                    <asp:TextBox ID="txtdesc" runat="server" CssClass="form-control" TextMode="MultiLine"
                        Height="150px"></asp:TextBox>
                </div>
            </div>
            <div class="clear"></div>
            <div class="ctrlGroup">
                <label class="lbl">
                    Event Location :
                               
                </label>
                <div class="txt w3">
                    <asp:TextBox ID="txtlocation" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>
            <div class="ctrlGroup">
                <label class="lbl">
                    Event Type :
                </label>
                <div class="txt w1 mar10">

                    <asp:CheckBox ID="ckhAllDay" runat="server" Text="All Day Event" CssClass="chkboxnew" onclick="setAllDayEvent();" />

                    <asp:CheckBox ID="ckhRepeat" runat="server" Text="Event Repeat" CssClass="chkboxnew" onclick="setRepeatEvent();" />

                </div>
                <script>
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

                </script>

            </div>
            <div class="ctrlGroup" id="divrepeat" style="display: none;">
                <div class="txt w1">
                    <asp:DropDownList ID="droprepeat" runat="server" CssClass="form-control">

                        <asp:ListItem Value="Daily">Daily</asp:ListItem>
                        <asp:ListItem Value="Weekly">Weekly</asp:ListItem>
                        <asp:ListItem Value="Monthly">Monthly</asp:ListItem>
                    </asp:DropDownList>
                </div>


            </div>
            <div class="clear"></div>
            <div class="ctrlGroup">
                <label class="lbl">
                    Start Date :<asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                        ErrorMessage="*" ControlToValidate="txtfromdate" CssClass="errmsg" ValidationGroup="saveevent"></asp:RequiredFieldValidator>
                </label>
                <div class="txt w1 mar10">

                    <asp:TextBox ID="txtfromdate" runat="server" CssClass="form-control hasDatepicker" Style="margin-top: 0px;" onchange="validateEventDate(this.id,'ctl00_ContentPlaceHolder1_txtfromdate','ctl00_ContentPlaceHolder1_txtendtime');" placeholder="mm/dd/yyyy"></asp:TextBox>

                    <ajaxToolkit:CalendarExtender ID="cal1" runat="server" TargetControlID="txtfromdate" PopupButtonID="txtfromdate"
                        Format="MM/dd/yyyy">
                    </ajaxToolkit:CalendarExtender>

                </div>

                <div class="txt w1" id="divstarttime">

                    <asp:TextBox ID="txtstarttime" runat="server" CssClass="form-control timepicker" Width="50%" placeholder="hh:mm AM|PM"></asp:TextBox>
                    <asp:RegularExpressionValidator ID="RequiredFieldValidator5" runat="server" ValidationExpression="^ *(1[0-2]|[1-9]):[0-5][0-9] *(a|p|A|P)(m|M) *$"
                        ControlToValidate="txtstarttime" ErrorMessage="" ValidationGroup="saveevent"
                        CssClass="errmsg"></asp:RegularExpressionValidator>

                </div>
            </div>
            <div class="clear"></div>

            <div class="ctrlGroup" id="divenddate">



                <label class="lbl">
                    End Date :<asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server"
                        ErrorMessage="*" ControlToValidate="txtenddate" CssClass="errmsg" ValidationGroup="saveevent"></asp:RequiredFieldValidator>
                </label>
                <div class="txt w1 mar10">

                    <asp:TextBox ID="txtenddate" runat="server" CssClass="form-control hasDatepicker" Style="margin-top: 0px;" onchange="validateEventDate(this.id,'ctl00_ContentPlaceHolder1_txtfromdate','ctl00_ContentPlaceHolder1_txtendtime');" placeholder="mm/dd/yyyy"></asp:TextBox>

                    <ajaxToolkit:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtenddate" PopupButtonID="txtenddate"
                        Format="MM/dd/yyyy">
                    </ajaxToolkit:CalendarExtender>

                </div>
                <div class="txt w1" id="divendtime">

                    <asp:TextBox ID="txtendtime" runat="server" CssClass="form-control timepicker" Width="50%" placeholder="hh:mm AM|PM"></asp:TextBox>

                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ValidationExpression="^ *(1[0-2]|[1-9]):[0-5][0-9] *(a|p|A|P)(m|M) *$"
                        ControlToValidate="txtendtime" ErrorMessage="" ValidationGroup="saveevent"
                        CssClass="errmsg"></asp:RegularExpressionValidator>



                </div>
            </div>


            <div class="clear"></div>
            <div class="ctrlGroup">
                <label class="lbl">
                    Event Color :
                        <input type="hidden" id="Dashboard_hidEventColor" runat="server" clientidmode="Static" />
                </label>
                <div class="txt w3">

                    <asp:DataList ID="replayer" runat="server" CellPadding="0" CellSpacing="0" RepeatLayout="Table" RepeatColumns="2" RepeatDirection="Horizontal" OnItemDataBound="replayer_ItemDataBound">

                        <ItemTemplate>

                            <div style="float: left; padding-right: 5px;">
                                <input itemid='<%#Eval("nid") %>' id="radionLayer" type="radio" runat="server" />


                            </div>


                            <span style="float: left;" class='<%#Eval("css")+" layer1" %>'></span>




                        </ItemTemplate>

                    </asp:DataList>

                </div>


            </div>
            <div class="clear"></div>
            <div class="ctrlGroup" id="divpublicevent">
                <label class="lbl">
                    &nbsp;
                </label>
                <div class="txt w3">
                    <asp:CheckBox ID="chkeventtype" runat="server" Text="Public Event" CssClass="chkboxnew" />
                </div>
            </div>
            <div class="clear"></div>
            <div class="ctrlGroup">
                <label class="lbl">
                    &nbsp;
                </label>
                <div class="txt w3">
                    <input type="button" id="btnsaveevent" value="Save" class="btn btn-primary" onclick="saveEvent();" />
                </div>
            </div>

        </div>

    </div>


    <div style="display: none; width: 700px;" id="divShowevent" class="itempopup">
        <div class="popup_heading">
            <span id="Span1" runat="server">View Event</span>
            <div class="f_right">
                <img src="images/cross.png" onclick="closeventediv();" alt="X" title="Close Window" />
            </div>
        </div>
        <div class="tabContents">
            <div class="col-xs-12 clear mar">
                <div class="diveventhead">
                    <h1 id="diveventhead"></h1>
                    <div class="clear"></div>
                    <div id="diveventicon" class="diveventicon">
                    </div>

                    <div id="diveventText" class="diveventText"></div>
                    <div class="clear"></div>

                </div>
                <div class="divEvent">
                    <div class="diveventicon">
                        <i class="fa fa-calendar" aria-hidden="true"></i>

                    </div>
                    <div class="divEventDate" id="divEventDate"></div>
                </div>
                <div class="divEvent">
                    <div class="diveventicon">
                        <i class="fa fa-map-marker" aria-hidden="true"></i>

                    </div>
                    <div class="divLocation" id="divLocation"></div>
                </div>
                <div class="divEvent">
                    <div class="diveventicon">
                        <i class="fa fa-calendar-o" aria-hidden="true"></i>

                    </div>
                    <div class="divEventMsg" id="divEventMsg"></div>
                </div>

                <div class="clear"></div>

                <div class="col-xs-12  form-group f_left pad" style="margin-bottom: 0; margin-top: 15px; padding-left: 0;">

                    <input type="button" class="btn btn-primary" onclick="editevent();" value="Edit" id="btneditevent" style="float: left; margin-right: 5px;" />
                    <input type="button" class="btn btn-default" onclick="deleteevent();" value="Delete" id="btndeleteevent" />
                    <input type="hidden" id="dashboardEventEditid" />
                </div>

            </div>
        </div>
    </div>



    <div class="pageheader">
        <h2>
            <i class="fa fa-home"></i>Dashboard
        </h2>
        <div class="breadcrumb-wrapper">
            <ol class="breadcrumb">
                <li><a href="#">Quick Start</a></li>
                <li class="active">Dashboard</li>
            </ol>
        </div>
        <div class="clear">
        </div>
    </div>
    <div class="contentpanel">
        <div class="row">
            <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                <div class="imp-shrtct-hding">
                    <img src="images/task-summary-icon.png" />Task Summary
                </div>
                <div class="shrtct-box">
                     <img src="images/loading.gif" id="divtaskloader" class="annouceloader" style="margin-top:50px;" />
                    <div id="divtasksummary" style="display:none;">
                    <div class="sumerybox">
                        <h2>Total</h2>
                        <figure>
                            <img src="images/total-icon.png" />
                        </figure>
                        <p id="taskSum_total">0</p>
                    </div>
                    <div class="sumerybox">
                        <h2>in process</h2>
                        <figure>
                            <img src="images/in-process-icon.png" />
                        </figure>
                        <p id="taskSum_inproc">0</p>
                        
                    </div>
                    <div class="sumerybox" style="border: 0;">
                        <h2>Completed</h2>
                        <figure>
                            <img src="images/completed-icon.png" />
                        </figure>
                        <p id="taskSum_complete">0</p>
                    </div>
                        </div>
                </div>
            </div>
            <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                <div class="imp-shrtct-hding">
                    <img src="images/imp-shrtct-icon.png" />shortcuts
                </div>
                <div class="shrtct-box">
                    <div class="col-sm-6 col-md-6">
                        <a class="panel-1" href="settings.aspx">
                            <img src="images/icon1.png" alt="" class="f_left">
                            <em><span>User</span>
                                <div class="clear">
                                </div>
                                <i>Profile</i> </em></a>
                    </div>
                    <div class="col-sm-6 col-md-6">
                        <a class="panel-1 redbg" href="Timesheet.aspx">
                            <img src="images/icon2.png" alt="" class="f_left"><em><span>Employee</span>
                                <div class="clear">
                                </div>
                                <i>Time Entry</i> </em></a>
                    </div>
                    <div class="col-sm-6 col-md-6">
                        <a class="panel-1 bluebg" href="ViewSchedule.aspx">
                            <img src="images/icon3.png" alt="" class="f_left"><em><span>Client</span>
                                <div class="clear">
                                </div>
                                <i>Schedule</i> </em></a>
                    </div>
                    <div class="col-sm-6 col-md-6">
                        <a class="panel-1 darkbg" href="expenseslog.aspx">
                            <img src="images/icon4.png" alt="" class="f_left">
                            <em><span>Employee</span>
                                <div class="clear">
                                </div>
                                <i>Expenses</i></em></a>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">

            <div class="col-sm-6 col-md-6">
                <div class="panel-body" style="margin-top: 0px; padding-top: 0px;">
                    <div class="row">


                        <div id='calendar'>
                        </div>
                    </div>
                    <!-- row -->
                </div>
                <!-- panel -->
            </div>
            <!-- col-sm-9 -->
            <div class="col-sm-6">
                <div class="imp-shrtct-hding">
                    <img src="images/emp-hrs.png" />Employee Hours
                </div>
                <div class="chart-box">

                    <iframe id="ifEmphours" src="dashboardChart.aspx" style="width: 100%; height: 460px; margin: 0px; padding: 0px; overflow: hidden; border: none;"></iframe>


                </div>
            </div>

            <!-- col-sm-3 -->

        </div>

        <div class="row">

            <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                <div class="panel panel-default">
                    <div class="announcebox">
                        <div class="imp-shrtct-hding">
                            <img src="images/announce-icon.png" />Latest announcement
               
                        </div>


                        <div class="clear"></div>
                        <div class="annoucement-box">
                            <div class="inner">
                                <img src="images/loading.gif" id="Dash_AnnounceLoder" class="annouceloader" />
                                <ul id="ulDashboard_Announcement"></ul>

                            </div>



                        </div>



                    </div>
                    <!-- panel-body -->
                </div>
                <!-- panel -->
            </div>

            <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
               
                
                 
                <div class="imp-shrtct-hding">
                    <img src="images/leave-icon.png" /><span id="leave_date">leave status on nov 08, 2016</span> 
                </div>
                <div class="leave-status" >
                     <img src="images/loading.gif" id="divleaveloader" class="annouceloader" style="margin-top:50px;" />
                    <div id="divleavedetail" style="display:none;">
                        <div class="leave-box">
                        <h2>Paid leave</h2>
                        <figure>
                            <img src="images/pl.png">
                        </figure>
                        <p id="leave_paid">0</p>
                    </div>
                    <div class="leave-box">
                        <h2>Accrued PL</h2>
                        <figure>
                            <img src="images/accrued-L.png">
                        </figure>
                        <p id="leave_accru">0</p>
                    </div>
                    <div class="leave-box">
                        <h2>Taken PL </h2>
                        <figure>
                            <img src="images/taken-PL.png" id="divleaveposition">
                        </figure>
                        <p id="leave_ltaken">0</p>
                    </div>
                    <div class="leave-box">
                        <h2>Taken UPL</h2>
                        <figure>
                            <img src="images/taken-UPL.png">
                        </figure>
                        <p id="leave_takenupl">0</p>
                        
                    </div>
                    <div class="leave-box">
                        <h2>Balance PL</h2>
                        <figure>
                            <img src="images/balance-PL.png">
                        </figure>
                        <p id="leave_balance">0</p>
                    </div>
                    </div>
                    <div class="clear"></div>
                    
                </div>
            </div>

        </div>


        <div class="row">
            <div class="col-sm-12 col-md-12">
                <div class="imp-shrtct-hding">
                    <img src="images/time-icon.png" />Recent Time Entries
                </div>
                <div class="time-table-box">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th width="8%">Date</th>
                                <th width="20%">Project</th>
                                <th width="18%">Task</th>
                                <th width="7%">Hours</th>
                                <th width="44%">description</th>
                                <th>&nbsp;</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>

                        </tbody>
                    </table>
                </div>
            </div>
        </div>

    </div>

    <script>
        function fillTaskStatus() {
            
            document.getElementById("divtaskloader").style.display = "block";

            var args = { empid: window.parent.document.getElementById("hidchatloginid").value };
            var jsonarr;
            $.ajax({

                type: "POST",
                url: "Dashboard.aspx/getEmpProcess",
                data: JSON.stringify(args),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                cache: false,
                success: function (msg) {
                    if (msg.d != "failure") {

                        jsonarr = jQuery.parseJSON(msg.d);
                        if (jsonarr.length > 0) {

                            for (var i in jsonarr) {
                                document.getElementById("taskSum_inproc").innerHTML = jsonarr[i].totalinprocesstasks;
                                document.getElementById("taskSum_total").innerHTML = jsonarr[i].totalassignedtasks;
                                document.getElementById("taskSum_complete").innerHTML = jsonarr[i].totalcompletedtasks;
                              
                            }
                        }

                        
                        document.getElementById("divtasksummary").style.display = "block";
                        document.getElementById("divtaskloader").style.display = "none";
                        // setup the chart

                    }

                },
                error: function (x, e) {
                    document.getElementById("divtaskloader").style.display = "none";


                }
            });
        }
        function fillleavedetail()
        {

            var args = { empid: window.parent.document.getElementById("hidchatloginid").value };
            var jsonarr;
            $.ajax({

                type: "POST",
                url: "Dashboard.aspx/getLeaveDetail",
                data: JSON.stringify(args),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                cache: false,
                success: function (msg) {
                    if (msg.d != "failure") {

                        jsonarr = jQuery.parseJSON(msg.d);
                        if (jsonarr.length > 0) {

                            for (var i in jsonarr) {
                                document.getElementById("leave_paid").innerHTML = jsonarr[i].noofpaid;
                                document.getElementById("leave_accru").innerHTML = jsonarr[i].totalacc;
                                document.getElementById("leave_ltaken").innerHTML = jsonarr[i].totalpaid;
                                document.getElementById("leave_takenupl").innerHTML = jsonarr[i].unpaidleave;
                                document.getElementById("leave_balance").innerHTML = jsonarr[i].remAcc;
                            }
                        }


                        
                        document.getElementById("divleaveloader").style.display = "none";
                        document.getElementById("divleavedetail").style.display = "block";
                        // setup the chart
                        fillTaskStatus();
                    }

                },
                error: function (x, e) {
                    document.getElementById("divleaveloader").style.display = "none";

                    fillTaskStatus();


                }
            });
        }


        $(document).ready(function () {
            var p = $("#ifEmphours");
            var position = p.offset();
            document.getElementById("divcompanyloader").style.left = (position.left + (p.width / 2)) + "px";
            document.getElementById("divcompanyloader").style.top = (position.top + (p.height / 2)) + "px";
            document.getElementById("divcompanyloader").style.display = "block";

            fillleavedetail();

           


        });
    </script>
    <script src='js/calendar_view_main2.js' type="text/javascript"></script>
</asp:Content>
