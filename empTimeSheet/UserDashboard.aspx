<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="UserDashboard.aspx.cs" Inherits="empTimeSheet.UserDashboard" %>

<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="css/dashboardcss.css" rel="stylesheet" />
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCumcmPhxv_y-77BrKoPQiGo5Qwb-I02uY&libraries=places"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <pg:progress ID="progress1" runat="server" />
    <input type="hidden" id="Dashboard_hidAddEvent" runat="server" clientidmode="Static" />
    <input type="hidden" id="Dashboard_hidAddPEvent" runat="server" clientidmode="Static" />
    <div id="otherdiv" onclick="closediv();">
    </div>
    <div style="display: none; width: 700px; padding-bottom: 0px;" id="divevents" class="itempopup">
        <div class="popup_heading">
            <span id="legendaction" runat="server">Event Managemnt </span>
            <div class="f_right">
                <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
            </div>
        </div>
        <div class="clear"></div>
        <div class="col-sm-12 col-xs-12">

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
                        Height="80px"></asp:TextBox>
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
            <span id="Span1" runat="server">Event Detail</span>
            <div class="f_right">
                <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
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

                        </tr>
                    </tbody>
                </table>
            </div>

        </div>
    </div>

    <div style="display: none; width: 700px;" id="divviewappointment" class="itempopup">
        <div class="popup_heading">
            <span>Appointment</span>
            <div class="f_right">
                <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
            </div>
        </div>

        <div class="col-xs-12 col-sm-12">
            <div class="appointmentcontent">
                <div class="col-xs-6 clear mar pad">
                    <b>When</b><br />
                    <span id="view_Time"></span>
                </div>
                <div class="col-xs-6  mar">
                    <b style="color: #333333;">Status : </b>
                    <span id="view_Status"></span>
                </div>


                <br />
                <div class="col-xs-12 clear mar pad">
                    <b>Service</b><br />
                    <span id="view_Service"></span>
                </div>


                <div class="col-xs-6 clear mar pad">
                    <b>Visitor</b><br />
                    <span id="view_visitor"></span>
                </div>
                <div class="col-xs-6  mar">
                    <b>Practitioner</b><br />
                    <span id="view_emp"></span>
                </div>


                <br />


            </div>

            <div class="clear"></div>



        </div>

    </div>

    <div class="pageheader">
        <h2>
            <i class="fa fa-home"></i>Dashboard
        </h2>
        <div class="breadcrumb-wrapper">
            <ol class="breadcrumb">
                <li><a href="#">QuickStart Admin</a></li>
                <li class="active">Dashboard</li>
            </ol>
        </div>
        <div class="clear">
        </div>
    </div>
    <div class="contentpanel">
        <div class="row">
            <div class="col-lg-8 col-sm-12 col-xs-12">
                <div class="whitebox">
                    <div class="panel-heading">
                        Top Ten Activities
                        <span class="tools pull-right"></span>
                    </div>
                    <div class="panel-body">
                        <div id="loadertopact" class="chartloader">
                            <img src="images/loading.gif" />
                        </div>
                        <div id="charttopact" class="chartdiv" style="height: 362px;"></div>
                    </div>
                </div>
            </div>

            <div class="col-lg-4 col-sm-12 col-xs-12">
                <div class="whitebox">
                    <div class="panel-heading">
                        shortcuts
                        <span class="tools pull-right"></span>
                    </div>
                    <div class="shortcut-body" style="height:206px;">
                        <ul class="list-unstyled">


                            <li class="media">
                                <figure style="background: #6d5cae"><i class="fa fa-clock-o" aria-hidden="true"></i></figure>
                                <div class="media-body">
                                    <a href="Timesheet.aspx">Employee Time Entry</a>
                                </div>
                            </li>

                            <li class="media">
                                <figure style="background: #f55753"><i class="fa fa-calendar" aria-hidden="true"></i></figure>
                                <div class="media-body">
                                    <a href="ClientSchedule.aspx">Client Schedule</a>
                                </div>
                            </li>

                          <%--  <li class="media">
                                <figure style="background: #428bca"><i class="fa fa-usd" aria-hidden="true"></i></figure>
                                <div class="media-body">
                                    <a href="expenseslog.aspx">Employee Expenses</a>
                                </div>
                            </li>--%>

                            <li class="media">
                                <figure style="background: #cea502"><i class="fa fa-users" aria-hidden="true"></i></figure>
                                <div class="media-body">
                                    <a href="MyAccount.aspx">User Profile</a>
                                </div>
                            </li>

                            



                        </ul>
                    </div>
                </div>
                <div class="clear"></div>
                 <div class="whitebox">
                     <div id="loaderTask" class="chartloader">
                            <img src="images/loading.gif" />
                        </div>
                    <div class="panel-heading">
                        random info
                        <span class="tools pull-right"></span>
                    </div>
                    <div class="panel-body text-center" >
                        <div class="task">
                            <figure id="strtotal">0</figure>
                            <h2>total task</h2>
                        </div>
                        <div class="billed">
                            <figure id="strbilled">0</figure>
                            <h2>In Process</h2>
                        </div>
                        <div class="non-billed">
                            <figure id="strunbilled">0</figure>
                            <h2>Completed</h2>
                        </div>

                    </div>
                </div>
            </div>
        </div>

        <div class="row">

          
            <div class="col-lg-12 col-sm-12 col-xs-12">
                <div class="whitebox">
                    <div class="panel-heading">
                        Employee Hours
                        <span class="tools pull-right"></span>
                    </div>
                    <div class="panel-body" style="text-align: center;">
                        <div id="loaderEmpHour" class="chartloader">
                            <img src="images/loading.gif" />
                        </div>
                        <div id="chartEmpHour" class="chartdiv" style="height: 250px;"></div>


                    </div>
                </div>
            </div>
        </div>



        <div class="row">
            <div class="col-lg-6 col-sm-12 col-xs-12">
                <div class="whitebox">

                    <div class="panel-body text-center">
                        <iframe id="ifevent" src="DashboardCalendar.aspx" style="width: 100%; height: 425px; overflow: auto; margin: 0px; padding: 0px; border: none;"></iframe>

                    </div>
                </div>


            </div>

            <div class="col-lg-6 col-sm-12 col-xs-12">
                <div class="whitebox">
                    <div class="panel-heading2">
                        <ul class="nav nav-pills mb-3" id="pills-tab" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link eventtab_link active" id="tabAllEvent" role="tab" aria-controls="pills-home" aria-expanded="true">all</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link eventtab_link" id="tabEvent" role="tab" aria-controls="pills-profile" aria-expanded="true">events</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link eventtab_link" id="tabAPP" role="tab" aria-controls="pills-appointment" aria-expanded="true">appointment</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link eventtab_link" id="tabSch" role="tab" aria-controls="pills-schedule" aria-expanded="true">client schedule</a>
                            </li>

                        </ul>
                        <span class="tools pull-right nr"></span>
                    </div>
                    <div class="panel-body">
                        <div class="tab-content" id="pills-tabContent">
                            <div class="tab-pane active" id="tabAllEvent_Detail" role="tabpanel" aria-labelledby="pills-home-tab">
                            </div>
                            <div class="tab-pane" id="tabEvent_Detail" role="tabpanel" aria-labelledby="pills-profile-tab">
                            </div>
                            <div class="tab-pane" id="tabAPP_Detail" role="tabpanel" aria-labelledby="pills-appointment-tab">
                            </div>





                            <div class="tab-pane" id="tabSch_Detail" role="tabpanel" aria-labelledby="pills-schedule-tab">
                            </div>
                        </div>


                    </div>
                </div>


            </div>
        </div>

    </div>



    <script src="js/PageJs/dashboardAllJs.js"></script>

    <script src="js/PageJs/dashboardUser.js"></script>

</asp:Content>

