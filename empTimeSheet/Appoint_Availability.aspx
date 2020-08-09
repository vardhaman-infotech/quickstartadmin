<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="Appoint_Availability.aspx.cs" Inherits="empTimeSheet.Appoint_Availability" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">


    <link rel="stylesheet" href="js/jquery.timepicker.css" type="text/css" />

    <style type="text/css">
        input.form-control[disabled], .form-control[readonly], fieldset[disabled] .form-control {
            background-color: #fff;
            border-color: #fff;
            cursor: auto;
            box-shadow: none;
            padding: 2px;
        }


        #tbldata .hasDatepicker {
            max-width: 300px;
        }

        #tbldata .timepicker {
            max-width: 100px;
        }




        .tblsheet td {
            vertical-align: middle;
        }

        .appointmentcontent {
            padding: 3px 0px;
            font-size: 14px;
            color:#333333;
        }

            .appointmentcontent b {
                color: #1caf9a;
                font-family: 'open_sans_semibold',Arial,Helvetica,sans-serif;
                font-size: 15px;
            }
            .appointmentcontent .status_Pending{
                color:orange;
                font-family: 'open_sans_semibold',Arial,Helvetica,sans-serif;
            }
             .appointmentcontent .status_Confirmed{
                color:green;
                font-family: 'open_sans_semibold',Arial,Helvetica,sans-serif;
            }
             .appointmentcontent .status_Cancled{
                color:red;
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
    <div class="rightclickback" id="rightclickback" onclick="closecopy();"></div>

    <div style="width: 100%; float: left; vertical-align: top; margin-bottom: 30px;"
        id="divsheetbox">
        <pg:progress ID="progress1" runat="server" />
        <div id="otherdiv" onclick="closediv();">
        </div>
        <div class="pageheader">
            <h2>
                <i
                    class="fa fa-fw" style="border: none; font-size: 24px; border-radius: initial; padding: 0px;"></i>Employee Availability
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
                                        Date :
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
                                        Employee :
                                    </label>

                                    <div class="txt w1 mar10">
                                        <asp:DropDownList ID="dropemployee" runat="server" CssClass="form-control" onchange="hidedetails();">
                                        </asp:DropDownList>
                                    </div>

                                </div>



                                <div class="ctrlGroup searchgroup">
                                    <input type="button" value="Search" class="btn btn-default" onclick="getAvailability();" />

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

                                            <div id="divtableaddnew" style="display: none;">
                                                <div>
                                                    <table width="100%" cellpadding="4" cellspacing="0" id="tbldata" class="tblsheet">
                                                        <thead>
                                                            <tr class="gridheader">
                                                                <th width="30px"></th>
                                                                <th width="300px">Date
                                                                </th>
                                                                <th width="100px">From Time
                                                                </th>
                                                                <th>To Time
                                                                </th>

                                                                <th width="30px"></th>
                                                                <th width="30px"></th>

                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <tr id="tr_0">
                                                                <td>
                                                                    <div id="divdel0">
                                                                    </div>
                                                                    <input type="hidden" id="hidApp_id0" />
                                                                </td>
                                                                <td>
                                                                    <input type="text" id="txtdate0" class="form-control" onchange="checkdate(this.value,this.id);" />
                                                                </td>
                                                                <td>
                                                                    <input type="text" id="txtfromtime0" class="form-control" />
                                                                </td>
                                                                <td>
                                                                    <input type="text" id="txttotime0" class="form-control" />
                                                                </td>
                                                                <td></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>



                                                </div>
                                                <div class="clear"></div>
                                                <div>

                                                    <div class="ctrlGroup searchgroup">
                                                        <input type="button" value="Submit" class="btn btn-primary" onclick="savedata();" />


                                                    </div>
                                                    <div class="ctrlGroup searchgroup" style="float: right;">
                                                        <a onclick="return addnewrow();" id="addmore" style="text-decoration: underline;"><i class="fa fa-plus">&nbsp;</i>Add
                                                            New</a>

                                                    </div>

                                                </div>

                                            </div>
                                        </div>
                                        <input type="hidden" id="appointment_hidrowno" clientidmode="Static" runat="server" />
                                        <input type="hidden" id="appointment_hidsno" clientidmode="Static" runat="server" />
                                        <input type="hidden" id="appointment_minDate" clientidmode="Static" runat="server" />
                                        <input type="hidden" id="appointment_hidempid" clientidmode="Static" runat="server" />

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
                        <b style="color:#333333;">Status : </b>
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

            </div>
            <div class="clear"></div>




        </div>
    </div>

   
    <script src="js/jquery-ui.js"></script>

    <script src="js/jquery.timepicker.js"></script>






    <script>

        function closediv() {
            $('#divviewappointment').hide();
            $('#otherdiv').hide();
        }
        function viewappointment(id) {


            $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").show();

            var args1 = { nid: id };
            $.ajax({
                type: "POST",
                contentType: "application/json",
                data: JSON.stringify(args1),
                url: "Appoint_Availability.aspx/getAppointments",
                dataType: "json",
                success: function (data) {

                    if (data.d != "failure") {

                        jsonarr = jQuery.parseJSON(data.d);

                        if (jsonarr.length > 0) {


                            for (var i in jsonarr) {

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
        function getAvailability() {

            $('#tbldata tbody > tr').remove();
            $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").show();
            var args1 = { empid: document.getElementById("ctl00_ContentPlaceHolder1_dropemployee").value, compid: document.getElementById("hidcompanyid").value, fromdate: document.getElementById("ctl00_ContentPlaceHolder1_txtfrom").value, todate: document.getElementById("ctl00_ContentPlaceHolder1_txtto").value };
            $.ajax({
                type: "POST",
                contentType: "application/json",
                data: JSON.stringify(args1),
                url: "Appoint_Availability.aspx/getEmpAvailability",
                dataType: "json",
                success: function (data) {

                    if (data.d != "failure") {

                        jsonarr = jQuery.parseJSON(data.d);
                        if (jsonarr.length > 0) {

                            for (var i in jsonarr) {

                                var str = '';
                                var cls = '';



                                str = str + '<tr id="tr_' + i + '"><td>';
                                if (jsonarr[i].recType == 'Appoint') {

                                    cls = ' readonly="readonly" style="color:blue;" ';
                                    str = str + '<div id="divdel' + i + '">';
                                }
                                else {
                                    str = str + '<div id="divdel' + i + '"><a><img src="images/delete.png" onclick="deleteappoint(' + i + ');"  /></a>';
                                }

                                str = str + '</div><input type="hidden" id="hidApp_id' + i + '" value="' + jsonarr[i].nid + '" /></td>';
                                str = str + '<td><input ' + cls + ' type="text" id="txtdate' + i + '" class="form-control" onchange="checkdate(this.value,this.id);" value="' + jsonarr[i].adate1 + '" /></td>';
                                str = str + '<td><input ' + cls + ' type="text" id="txtfromtime' + i + '" class="form-control timepicker" onchange="checktime(1,' + i + ');" value="' + String(jsonarr[i].afrmTime).replace(" ", "") + '" /></td>';
                                str = str + ' <td><input ' + cls + ' type="text" id="txttotime' + i + '" class="form-control timepicker" onchange="checktime(2,' + i + ');"  value="' + String(jsonarr[i].aToTime).replace(" ", "") + '" /></td><td><img src="images/submitted.png" title="Saved Free Interval" /></td>';

                                if (jsonarr[i].recType == "Appoint") {
                                    str = str + '<td><a onclick="viewappointment(' + jsonarr[i].nid + ');"><img src="images/time_icon16.png" title="Appointment Booked" /></a></td></tr>';
                                }
                                else {
                                    str = str + '<td></td></tr>';
                                }

                                var el = $(str);
                                $('#tbldata > tbody:last').append(el);


                                if (jsonarr[i].recType != 'Appoint') {
                                    $('#txtfromtime' + i).timepicker({

                                        interval: 60

                                    });
                                    $('#txttotime' + i).timepicker({

                                        interval: 60

                                    });
                                    $('#txtdate' + i).datepicker({
                                        minDate: new Date(document.getElementById("appointment_minDate").value),
                                    });
                                }
                                document.getElementById("appointment_hidrowno").value = i;


                            }
                        }
                        $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();
                        addnewrow();
                    }



                    document.getElementById("divtableaddnew").style.display = "block";
                },
                error: function (x, e) {
                    $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();
                }

            });

        }

        function addnewrow() {
            var i = 0;
            if (document.getElementById("appointment_hidrowno").value != "") {
                i = parseInt(document.getElementById("appointment_hidrowno").value) + 1;

            }
            var str = '';
            str = str + '<tr id="tr_' + i + '"><td> <div id="divdel' + i + '"><a><img src="images/delete.png" onclick="deleteappoint(' + i + ');" /></a></div><input type="hidden" id="hidApp_id' + i + '"  /></td>';
            str = str + '<td><input type="text" id="txtdate' + i + '" class="form-control" onchange="checkdate(this.value,this.id);" value="" /></td>';
            str = str + '<td><input type="text" id="txtfromtime' + i + '" class="form-control timepicker" onchange="checktime(1,' + i + ');"  /></td>';
            str = str + ' <td><input type="text" id="txttotime' + i + '" class="form-control timepicker" onchange="checktime(2,' + i + ');"  /></td> <td></td><td></td></tr>';

            var el = $(str);
            $('#tbldata > tbody:last').append(el);

            //alert($(el).find('#txtfromtime' + i).attr("id"));



            $('#txtfromtime' + i).timepicker({

                interval: 60,
                defaultTime: '10:00pm'

            });
            $('#txttotime' + i).timepicker({

                interval: 60

            });
            $('#txtdate' + i).datepicker({
                minDate: new Date(document.getElementById("appointment_minDate").value),
            });
            //$('#txtdate' + i).datepicker();

            document.getElementById("appointment_hidrowno").value = i;

        }

        function checktime(id, id2) {

            var regexp = /^ *(1[0-2]|[1-9]):[0-5][0-9] *(a|p|A|P)(m|M) *$/;

            var newid = "";
            if (id == 1)
                newid = "txtfromtime" + id2;
            else
                newid = "txttotime" + id2;


            if ($('#' + newid).val() != "") {
                var correct = ($('#' + newid).val().search(regexp) >= 0) ? true : false;
                if (!correct) {
                    document.getElementById(newid).value = "";
                    alert("Wrong time format");
                    return;
                }
                else {
                    var newval = $('#' + newid).val();
                    var arr = newval.split(':');
                    newval = arr[1];
                    newval = (newval.replace("am", "")).replace("pm", "");

                    if(newval!="00" && newval!="30")
                    {
                        document.getElementById(newid).value = "";
                        alert("Select time from list!");
                        return;
                    }
                }

            }
            var fromtime = document.getElementById("txtfromtime" + id2).value;
            var totime = document.getElementById("txttotime" + id2).value;

            if (fromtime != "" && totime != "") {

                if (new Date("01/01/2000 " + fromtime.replace('a', ' a').replace('p', ' p')) > new Date("01/01/2000 " + totime.replace('a', ' a').replace('p', ' p'))) {

                    document.getElementById(newid).value = "";
                    alert("From Time should not be greater then To Time!");

                    return;
                }
                else {
                    if (new Date("01/01/2000 " + fromtime.replace('a', ' a').replace('p', ' p')) == new Date("01/01/2000 " + totime.replace('a', ' a').replace('p', ' p'))) {
                        document.getElementById(newid).value = "";
                        alert("From Time and To Time should  be diffrent!");

                        return;
                    }
                }
            }

        }
        function deleteappoint(id) {

            var val = document.getElementById("hidApp_id" + id).value;
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
                        url: "Appoint_Availability.aspx/deleteAppointment",
                        dataType: "json",
                        success: function (data) {

                            if (data.d != "failure") {
                                msg = "1";
                                $('#tr_' + id).remove();
                                $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();
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
        function hidedetails() {
            document.getElementById("divtableaddnew").style.display = "none";
        }
        function savedata() {
            var tnid = ""; date = "", fTtime = "", tTime = "", newid = "";

            var regexp = /^ *(1[0-2]|[1-9]):[0-5][0-9] *(a|p|A|P)(m|M) *$/;


            var status = 1;
           
            if ($("#ctl00_ContentPlaceHolder1_dropemployee").val() == "" || $("#ctl00_ContentPlaceHolder1_dropemployee").val() == null) {
                document.getElementById("ctl00_ContentPlaceHolder1_dropemployee").style.borderColor = "red";
                alert("Select an employee to schedule availability!");
                status = 0;
            }
            else {
                document.getElementById("ctl00_ContentPlaceHolder1_dropemployee").style.borderColor = "#cdcdcd";

            }
            var table = $("#tbldata tbody");
            table.find('tr').each(function (i, el) {
                var id = $(this).attr('id');


                id = id.replace("tr_", "");

                newid = "hidApp_id" + id;
                tnid = tnid + document.getElementById(newid).value + '#';

                newid = "txtdate" + id;
                if (document.getElementById(newid).value == "") {
                    status = 0;
                    document.getElementById(newid).style.borderColor = "red";
                    date = date + document.getElementById(newid).value + '#';
                }
                else {
                    document.getElementById(newid).style.borderColor = "#cdcdcd";

                    date = date + document.getElementById(newid).value + '#';
                }
                newid = "txtfromtime" + id;
                if (document.getElementById(newid).value == "") {
                    status = 0;
                    document.getElementById(newid).style.borderColor = "red";


                }
                else {
                    var correct = ($('#' + newid).val().search(regexp) >= 0) ? true : false;
                    if (correct) {
                        fTtime = fTtime + document.getElementById(newid).value + '#';
                        document.getElementById(newid).style.borderColor = "#cdcdcd";
                    }

                    else {

                        status = 0;
                        document.getElementById(newid).style.borderColor = "red";


                    }
                }

                newid = "txttotime" + id;
                if (document.getElementById(newid).value == "") {
                    status = 0;
                    document.getElementById(newid).style.borderColor = "red";
                }
                else {
                    document.getElementById(newid).style.borderColor = "#cdcdcd";

                    var correct = ($('#' + newid).val().search(regexp) >= 0) ? true : false;
                    if (correct) {
                        document.getElementById(newid).style.borderColor = "#cdcdcd";
                        tTime = tTime + document.getElementById(newid).value + '#';
                    }
                    else {

                        status = 0;
                        document.getElementById(newid).style.borderColor = "red";
                    }
                }

            });

            if (status == 1) {
                $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").show();
                var args1 = { nid: tnid, empid: document.getElementById("ctl00_ContentPlaceHolder1_dropemployee").value, aDate: date, afrmDate: fTtime, aToDate: tTime };
                $.ajax({
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify(args1),
                    url: "Appoint_Availability.aspx/saveEmpAvailability",
                    dataType: "json",
                    success: function (data) {

                        if (data.d != "failure") {
                            msg = "1";
                            $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();
                            getAvailability();
                            alert("Saved Successfully");
                        }




                    },
                    error: function (x, e) {
                        $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();
                    }

                });
            }

        }



        $(document).ready(function () {


            getAvailability();


        });
    </script>
</asp:Content>

