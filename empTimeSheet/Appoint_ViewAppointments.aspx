<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="Appoint_ViewAppointments.aspx.cs" Inherits="empTimeSheet.Appoint_ViewAppointments" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

   
    <script src="js/jquery-ui.js"></script>
    <script src="js/jquery.timepicker.js"></script>
    <link rel="stylesheet" href="js/jquery.timepicker.css" type="text/css" />
    <style type="text/css">
        .appointmentcontent {
            padding: 3px 0px;
            font-size: 14px;
            color: #333333;
        }

            .appointmentcontent b {
                color: #1caf9a;
                font-family: 'open_sans_semibold',Arial,Helvetica,sans-serif;
                font-size: 15px;
            }

            .appointmentcontent .status_Pending {
                color: orange;
                font-family: 'open_sans_semibold',Arial,Helvetica,sans-serif;
            }

            .appointmentcontent .status_Confirmed {
                color: green;
                font-family: 'open_sans_semibold',Arial,Helvetica,sans-serif;
            }

            .appointmentcontent .status_Canceled {
                color: red;
                font-family: 'open_sans_semibold',Arial,Helvetica,sans-serif;
            }

        .appoint_status {
            float: right;
        }

        .appoint_desig {
            font-size: 13px;
        }

        .appoint_company {
            float: left;
            font-family: 'open_sans_semibold',Arial,Helvetica,sans-serif;
            clear: both;
        }

        .appoint_email {
            float: left;
            clear: both;
            background-image: url(images/email-icon.png);
            background-position: left center;
            background-repeat: no-repeat;
            padding-left: 25px;
            margin-top: 5px;
        }

        .appoint_contact {
            float: left;
            clear: both;
            background-image: url(images/phone-call.png);
            background-position: left center;
            background-repeat: no-repeat;
            padding-left: 25px;
            margin-bottom: 10px;
            margin-top: 5px;
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <div style="width: 100%; float: left; vertical-align: top; margin-bottom: 30px;">
        <pg:progress ID="progress1" runat="server" />
        <div id="otherdiv" onclick="closediv();">
        </div>
        <div class="pageheader">
            <h2>
                <i
                    class="fa fa-fw" style="border: none; font-size: 24px; border-radius: initial; padding: 0px;"></i>Appointments
            </h2>
            <div class="breadcrumb-wrapper mar ">
            </div>
            <div class="clear">
            </div>
        </div>
        <div class="contentpanel">
            <div class="row">
                <div class="col-sm-12 col-md-12">
                    <div class="panel panel-default" style="min-height: 450px;">
                        <div class="col-sm-12 col-md-10">
                            <div style="padding-top: 10px;">
                                <%--<div class="col-xs-12 col-sm-8 col-md-6 f_left" style="padding: 0px;">
                                    <h5 class="subtitle mb5">sheet View</h5>
                                </div>--%>
                                <div class="clear"></div>
                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl lbl2">
                                        From Date :
                                    </label>
                                    <div class="txt w1 mar10">

                                        <asp:TextBox ID="txtfrom" runat="server" CssClass="form-control hasDatepicker" onchange="comparedate(this.id,'ctl00_ContentPlaceHolder1_txtfrom','ctl00_ContentPlaceHolder1_txtto');hidedetails();"></asp:TextBox>
                                        <cc1:CalendarExtender ID="txtDate_CalendarExtender" runat="server" TargetControlID="txtfrom"
                                            PopupButtonID="txtfrom" Format="MM/dd/yyyy">
                                        </cc1:CalendarExtender>


                                    </div>
                                </div>
                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl lbl2">
                                        To Date :
                                    </label>

                                    <div class="txt w1 mar10">
                                        <asp:TextBox ID="txtto" runat="server" CssClass="form-control hasDatepicker" onchange="comparedate(this.id,'ctl00_ContentPlaceHolder1_txtfrom','ctl00_ContentPlaceHolder1_txtto');hidedetails();"></asp:TextBox>

                                        <cc1:CalendarExtender ID="txtDate_CalendarExtender1" runat="server" TargetControlID="txtto"
                                            PopupButtonID="txtto" Format="MM/dd/yyyy">
                                        </cc1:CalendarExtender>


                                    </div>
                                </div>
                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl lbl2">
                                        Status :
                                    </label>

                                    <div class="txt w1 mar10">
                                        <asp:DropDownList ID="dropstatus" runat="server" CssClass="form-control">
                                            <asp:ListItem Value="">All</asp:ListItem>
                                            <asp:ListItem Value="Pending">Pending</asp:ListItem>
                                            <asp:ListItem Value="Confirmed">Confirmed</asp:ListItem>
                                            <asp:ListItem Value="Canceled ">Canceled </asp:ListItem>
                                        </asp:DropDownList>
                                    </div>

                                </div>




                                <div class="ctrlGroup searchgroup">
                                    <input type="button" value="Search" class="btn btn-default" onclick="searchdata();" />

                                </div>
                            </div>
                        </div>
                        <div class="clear">
                        </div>
                        <div id="divright" class="col-sm-12 col-md-12 mar3">
                            <div class="panel-default">
                                <div class="panel-body2 ">
                                    <div class="row mar">
                                        <div class="table-responsive">

                                            <div id="divtableaddnew">
                                                <div>
                                                    <table width="100%" cellpadding="4" cellspacing="0" id="tbldata" class="tblreport">
                                                        <thead>
                                                            <tr class="gridheader">
                                                                <th>Employee
                                                                </th>
                                                                <th>Date
                                                                </th>
                                                                <th>Form Time
                                                                </th>
                                                                <th>To Time
                                                                </th>
                                                                <th>Meeting Purpose
                                                                </th>
                                                                <th>Visitor Name
                                                                </th>
                                                                <th>Orgnization
                                                                </th>
                                                                <th>Status</th>
                                                                <th width="30"></th>
                                                                <th width="30"></th>

                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                        </tbody>
                                                    </table>



                                                </div>
                                                <div class="clear"></div>


                                            </div>
                                        </div>
                                        <input type="hidden" id="appointment_hidrowno" clientidmode="Static" runat="server" />

                                        <input type="hidden" id="appointment_minDate" clientidmode="Static" runat="server" />
                                        <input type="hidden" id="appointment_hidid" clientidmode="Static" runat="server" />
                                        <input type="hidden" id="appointment_curstatus" clientidmode="Static" runat="server" />

                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="clear">
                        </div>
                    </div>
                    <!-- panel -->
                </div>
            </div>
        </div>
    </div>



    <div style="width: 640px;" id="divsetstatus" class="itempopup">
        <div class="popup_heading">
            <span>Set Status</span>
            <div class="f_right">
                <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
            </div>
        </div>
        <div>
            <input type="hidden" id="app_hidCurStatus" />
            <div class="tabContaier">
                <div class="tabDetails">
                    <div class="tabContents" style="display: block; height: auto; padding: 10px;">
                        <div class="ctrlGroup">
                            <label class="lbl lbl3">
                                Status
                            </label>
                            <div class="txt w5 mar10">
                                <div class="txt w1">
                                    <select id="app_dropstatus" class="form-control">
                                        <option value="Pending">Pending</option>
                                        <option value="Confirmed">Confirmed</option>
                                        <option value="Canceled">Canceled</option>
                                    </select>

                                </div>

                            </div>
                        </div>

                        <div class="clear"></div>

                        <div style="display: none;" id="divdatetime">
                            <div class="clear"></div>
                            <div class="ctrlGroup">
                                <label class="lbl lbl3" style="width: 100%;">
                                    Confirm Appointment Date and Time
                                </label>
                            </div>
                            <div class="clear"></div>
                            <div class="ctrlGroup">
                                <label class="lbl lbl3">
                                    Date :
                                </label>
                                <div class="txt w2 mar10">
                                    <asp:TextBox ID="txtdate" CssClass="form-control hasDatepicker" runat="server" ClientIDMode="Static" onchange="checkdate(this.value,this.id);"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtdate"
                                        PopupButtonID="txtdate" Format="MM/dd/yyyy">
                                    </cc1:CalendarExtender>

                                </div>
                            </div>
                            <div class="ctrlGroup">
                                <label class="lbl lbl3">
                                    Time :
                                </label>
                                <div class="txt w2">
                                    <input type="text" id="txtfrmtime" class="form-control" onchange="checktime(1)" placeholder="From" style="width: 42%; float: left" />
                                    <span style="float: left; padding: 3px 5px;">to</span>
                                    <input type="text" id="txtotime" class="form-control" onchange="checktime(2)" placeholder="To" style="width: 42%; float: left" />
                                </div>
                            </div>
                        </div>
                        <div class="clear"></div>
                        <div class="ctrlGroup">
                            <label class="lbl lbl3">
                                &nbsp;
                            </label>
                            <div class="txt w2 mar10">
                                <input type="button" value="Update Status" class="btn  btn-primary" id="btnupdatestatus"
                                    onclick="saveAppstatus();" />

                            </div>
                        </div>

                    </div>
                </div>



            </div>
        </div>
    </div>



    <div style="display: none; width: 700px;" id="divviewappointment" class="itempopup">
        <div class="popup_heading">
            <span id="Span1" runat="server">View Appointment</span>
            <div class="f_right">
                <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
            </div>
        </div>
        <div class="tabContents">
            <div class="col-xs-12 clear mar">
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

                <div class="col-xs-12  form-group f_left pad" style="margin-bottom: 0; margin-top: 15px; padding-left: 0;">

                    <input type="button" class="btn btn-primary" onclick="openstatuspop();" value="Set Status" id="btnviewSetstatus" style="float: left; margin-right: 5px;" />
                    <input type="button" class="btn btn-default" onclick="deleteappoint();" value="Delete" id="btndeleteevent" />

                </div>

            </div>
        </div>
    </div>





    <script>
        function closediv() {
            $('#divviewappointment').hide();
            $('#divsetstatus').hide();
            $('#otherdiv').hide();


        }
        function showhidedate(val) {
            if (document.getElementById("app_dropstatus").value == "Confirmed") {
                $('#divdatetime').show();

            }
            else {
                $('#divdatetime').hide();
            }

        }
        function searchdata() {
            closediv();
            $('#tbldata tbody > tr').remove();
            $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").show();
            var args1 = { nid: "", fromdate: document.getElementById("ctl00_ContentPlaceHolder1_txtfrom").value, todate: document.getElementById("ctl00_ContentPlaceHolder1_txtto").value, status: document.getElementById("ctl00_ContentPlaceHolder1_dropstatus").value, companyid: document.getElementById("hidcompanyid").value };
            $.ajax({
                type: "POST",
                contentType: "application/json",
                data: JSON.stringify(args1),
                url: "Appoint_ViewAppointments.aspx/getAppointments",
                dataType: "json",
                success: function (data) {

                    if (data.d != "failure") {

                        jsonarr = jQuery.parseJSON(data.d);

                        if (jsonarr.length > 0) {

                            for (var i in jsonarr) {

                                var str = '';
                                str = str + '<tr id="tr_' + i + '"><td>' + jsonarr[i].empname + '</td><td>' + jsonarr[i].adate1 + ' <input type="hidden" id="hidApp_id' + i + '" value="' + jsonarr[i].nid + '" /></td>';
                                str = str + '<td>' + jsonarr[i].frmTime + '</td>';
                                str = str + '<td>' + jsonarr[i].ToTime + '</td>';
                                str = str + '<td>' + jsonarr[i].service + '</td>';
                                str = str + '<td>' + jsonarr[i].vName + '</td>';
                                str = str + '<td>' + jsonarr[i].company + '</td>';
                                str = str + '<td>' + jsonarr[i].curStatus + '</td>';
                                str = str + '<td><a title="View" onclick="viewdetail(' + jsonarr[i].nid + ')"><img src="images/view.png" /><a></td>';

                                if (jsonarr[i].curStatus != "Canceled") {
                                    str = str + '<td><a title="Set Status" onclick="openstatus(' + jsonarr[i].nid + ')"><img src="images/setstatus.png" /><a></td></tr>';


                                }
                                else {
                                    str = str + '<td></td></tr>';

                                }

                                var el = $(str);
                                $('#tbldata > tbody:last').append(el);
                                document.getElementById("appointment_hidrowno").value = i;


                            }

                        }
                        else {
                            var str = '<tr><td colspan="8"><div class="nodatafound">No data found.</div></td></tr>';
                            var el = $(str);
                            $('#tbldata > tbody:last').append(el);
                        }
                        $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();

                    }




                },
                error: function (x, e) {
                    $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();
                }

            });

        }
        function viewdetail(id) {
            document.getElementById("appointment_hidid").value = id;

            $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").show();

            var args1 = { nid: id, fromdate: "", todate: "", status: "", companyid: "" };
            $.ajax({
                type: "POST",
                contentType: "application/json",
                data: JSON.stringify(args1),
                url: "Appoint_ViewAppointments.aspx/getAppointments",
                dataType: "json",
                success: function (data) {

                    if (data.d != "failure") {

                        jsonarr = jQuery.parseJSON(data.d);

                        if (jsonarr.length > 0) {


                            for (var i in jsonarr) {

                                closediv();
                                setposition("divviewappointment");
                                $('#divviewappointment').show();
                                $('#otherdiv').show();

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

                                if (jsonarr[i].curStatus == "Canceled") {
                                    $('#btnviewSetstatus').hide();
                                }
                                else {
                                    $('#btnviewSetstatus').show();
                                }
                            }

                        }

                        $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();

                    }




                },
                error: function (x, e) {
                    $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();
                }

            });
        }
        function openstatuspop() {
            closediv();
            openstatus(document.getElementById("appointment_hidid").value);
        }
        function openstatus(id) {
            document.getElementById("appointment_hidid").value = id;

            $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").show();
            var args1 = { nid: id, fromdate: "", todate: "", status: "", companyid: "" };
            $.ajax({
                type: "POST",
                contentType: "application/json",
                data: JSON.stringify(args1),
                url: "Appoint_ViewAppointments.aspx/getAppointments",
                dataType: "json",
                success: function (data) {

                    if (data.d != "failure") {

                        jsonarr = jQuery.parseJSON(data.d);

                        if (jsonarr.length > 0) {


                            for (var i in jsonarr) {

                                setposition("divsetstatus");
                                $('#divsetstatus').show();
                                $('#otherdiv').show();

                                document.getElementById("txtdate").value = jsonarr[i].adate1;
                                document.getElementById("txtfrmtime").value = jsonarr[i].frmTime;
                                document.getElementById("txtotime").value = jsonarr[i].ToTime;
                                document.getElementById("app_hidCurStatus").value = jsonarr[i].curStatus;
                                document.getElementById("app_dropstatus").value = jsonarr[i].curStatus;
                                document.getElementById("appointment_curstatus").value = jsonarr[i].curStatus;

                                $('#divdatetime').hide();



                            }

                        }

                        $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();

                    }




                },
                error: function (x, e) {
                    $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();
                }

            });

        }

        function checktime(id) {

            var regexp = /^ *(1[0-2]|[1-9]):[0-5][0-9] *(a|p|A|P)(m|M) *$/;

            var newid = "";
            if (id == 1)
                newid = "txtfrmtime";
            else
                newid = "txtotime";


            if ($('#' + newid).val() != "") {
                var correct = ($('#' + newid).val().search(regexp) >= 0) ? true : false;
                if (!correct) {
                    document.getElementById(newid).value = "";
                    alert("Wrong time format");
                    return;
                }

            }
            var fromtime = document.getElementById("txtfrmtime").value;
            var totime = document.getElementById("txtotime").value;

            if (fromtime != "" && totime != "") {

                if (new Date("01/01/2000 " + fromtime.replace('a', ' a').replace('p', ' p')) > new Date("01/01/2000 " + totime.replace('a', ' a').replace('p', ' p'))) {

                    document.getElementById(newid).value = "";
                    alert("From Time should not be greater then To Time!");

                    return;
                }
            }

        }
        function deleteappoint() {

            var val = document.getElementById("appointment_hidid").value;
            var msg = "1";
            if (val != "") {
                if (confirm('Do you want to delete this appointment?')) {
                    msg = "0";
                    $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").show();
                    var args1 = { nid: val };
                    $.ajax({
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify(args1),
                        url: "Appoint_ViewAppointments.aspx/deleteAppointment",
                        dataType: "json",
                        success: function (data) {

                            if (data.d != "failure") {
                                msg = "1";

                                $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();
                                searchdata();
                                closediv();
                                alert("Deleted successfully.");

                            }




                        },
                        error: function (x, e) {
                            $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();
                        }

                    });
                }

            }

            else {
                $('#tr_' + id).remove();
            }


        }

        function saveAppstatus() {
            var status = 1;
            if (document.getElementById("app_hidCurStatus").value == document.getElementById("app_dropstatus").value)
            {
                status = 0;
                closediv();
            }
               


            if (status == 1) {
                $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").show();
                var args1 = { aDate: "", frmTime:"", ToTime: "", status: document.getElementById("app_dropstatus").value, nid: document.getElementById("appointment_hidid").value };
                $.ajax({
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify(args1),
                    url: "Appoint_ViewAppointments.aspx/savestatus",
                    dataType: "json",
                    success: function (data) {

                        if (data.d != "failure") {
                            msg = "1";
                            $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();
                            searchdata();
                            alert("Saved successfully");
                        }




                    },
                    error: function (x, e) {
                        $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();
                    }

                });
            }

        }



        $(document).ready(function () {

            $('#txtfrmtime').timepicker({

                'step': function (j) {
                    return (j % 2) ? 15 : 45;
                }

            });
            $('#txtotime').timepicker({

                'step': function (j) {
                    return (j % 2) ? 15 : 45;
                }

            });
            searchdata();


        });
        function hidedetails() { }
    </script>
</asp:Content>
