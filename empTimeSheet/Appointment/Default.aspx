<%@ Page Title="" Language="C#" MasterPageFile="~/Appointment/AppointmentMaster.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="empTimeSheet.Appointment.Default" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="js/jquery.timepicker.css" type="text/css" />
    <link rel="stylesheet" href="css/flickity.css" media="screen" />
     <link rel="stylesheet" type="text/css" href="css/email_fileShare.css" />
    <script src='https://www.google.com/recaptcha/api.js'></script>
    <%--<style type="text/css">
       .lbltime{
            color:#630500;
        }
        .trselected {
            background: #630500;
        }

        .table .isdata td:hover {
            background: #630500;
        }

        .msg-hding {
            color: #630500;
        }

        footer {
            background: #630500;
        }

        .com-hding {
            color: #630500;
        }

        .table .button a {
            background: #630500;
        }

        .graybox2 .hding {
            color: #630500;
        }

        .bookHeading {
            color: #630500;
        }

        .button a {
            background: #630500;
        }

        .item {
            width: 100%;
        }

        .carousel {
            width: 100%;
        }

        .flickity-slider li {
            width: 100%;
        }

        .flickity-prev-next-button {
            display: none;
        }

        .flickity-page-dots {
            display: none;
        }
    </style>--%>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="alertbox" id="divalertbox">
        <div class="alertbox-inner">
            <div class="alertbox-inner-message" id="divAlertMessage"></div>
            <div class="alertbox-inner-buttonbox">
                <input type="button" value="OK" class="alertbox-inner-button" onclick="$('#divalertbox').hide();" />
            </div>
        </div>
    </div>
    <pg:progress ID="progress1" runat="server" />
    <input type="hidden" id="app_hid_company" runat="server" value="1" clientidmode="Static" />
    <div class="mainfrom">
        <div class="graybox" id="div1">
            <div class="com-hding">
                <span>Welcome
                    <%-- to--%>  
                    <asp:Literal Visible="false" ID="litcompanyname" runat="server" Text="Harshwal & Company LLP"></asp:Literal>
                </span>
                <br />
                Online Appointment System
               
            </div>
            <div class="fielbox">
                <label>Consultants:</label>

                <asp:DropDownList ID="dropcontactperson" runat="server" ClientIDMode="Static">
                </asp:DropDownList>




            </div>
            <div class="clear"></div>
            <div class="button"><a onclick="getAvailability();">Next</a></div>
        </div>


        <div class="graybox2" style="display: none;" id="div2">
            <div class="leftbox">
                <div class="hding" id="divavheading" style="display: none;">Availability of Sanwar Harshwal</div>
                <div class="hding">Pick a time slot</div>

                <div class="lft-right-arow"><input type="hidden" id="hiddenDate" />
                    <a class="switchtodate" id="linkswitchtodate">    Switch to a date</a>
                
                    <div class="lft-arow">
                        <a id="goleft">
                            <img src="images/left-arow.png" alt="" /></a>
                    </div>
                    <div class="rht-arow">
                        <a id="goright">
                            <img src="images/right-arow.png" alt="" /></a>
                    </div>
                </div>
                <div class="clear"></div>
                <div class="table">
                    <div id="divtable" class="main-carousel">
                    </div>

                    <div class="button" onclick="goprevious(1,2);" style="display: none;"><a>Back</a></div>

                </div>
            </div>
            <div class="rightbox">
                <div class="rightback">
                    <div class="button"><a onclick="goprevious(1,2);">Back</a></div>
                </div>
                <div class="rightfrom">
                    <div class="bookHeading" style="display: none;">
                        <span>Schedule an Appointment</span><br />
                        <asp:Literal ID="litcompanyname2" runat="server" Text="Harshwal & Company LLP" Visible="false"></asp:Literal>

                    </div>
                    <div class="bookHeading">
                        Schedule an Appointment

                    </div>


                    <div class="inputbox">
                        <b>Fields marked with an asterisk (*) are required.
                        <br />
                            &nbsp;
                        </b>
                        <div class="clear"></div>
                        <input type="hidden" id="hidslabid" />
                        <input type="hidden" id="hidadate" />
                        <input type="hidden" id="hidfromtime" />
                          <input type="hidden" id="hiselectedtime" value="" />
                        <input type="hidden" id="hidtotime" />
                        <div class="clear"></div>
                        <div class="fldbox" id="divselecedTime" style="display:none;">
                            <label>Appointment Date : </label>
                            <div class="lbltime" id="divtime"></div>
                        </div>
                        <div class="clear"></div>
                        <div class="fldbox">
                            <label>Appointment For : *</label>
                            <select id="dropservice" class="w1">
                                <option value="">-Select a service-</option>
                                <option value="Accounting">Accounting</option>
                                <option value="Auditing">Auditing</option>
                                <option value="Tax">Tax</option>
                                <option value="Infromation Technology">Infromation Technology</option>
                            </select>
                        </div>


                        <div class="clear"></div>


                        <div class="fldbox">
                            <label>Name : *</label>
                            <input type="text" id="txtname" />
                        </div>

                        <div class="clear"></div>

                        <div class="fldbox" style="display: none;">
                            <label>Designation : </label>
                            <input type="text" id="txtdesignation" />
                        </div>

                        <div class="clear"></div>

                        <div class="fldbox">
                            <label>Orgnization : </label>
                            <input type="text" id="txtorg" />
                        </div>

                        <div class="clear"></div>

                        <div class="fldbox">
                            <label>Email : *</label>
                            <input type="email" id="txtemail" />
                        </div>
                        <div class="clear"></div>

                        <div class="fldbox">
                            <label>Phone : </label>
                            <input type="tel" id="txtcontact" />
                        </div>
                           <div class="clear"></div>
                        <div class="fldbox">
                            <label>&nbsp;</label>
                             <div style="float:left;width:290px; margin-top:10px;"><div class="g-recaptcha" data-sitekey="6LdDaCAUAAAAABo2oml1NA-JjvcD1vdDzFs2-Gjl"></div></div> 
                        </div>
                        <div class="clear"></div>
                        <div class="table">
                            <div class="button"><a onclick="saveappointment();">Make an Appointment</a></div>
                            <div class="button"><a onclick="goprevious(1,2);">Back</a></div>

                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div id="div3" class="graybox3" style="display: none;">
        </div>

        <div id="div4" class="graybox3" style="display: none;">
            <div class="msg-hding">
                Thank you for scheduling an appointment. 
            <br />
                <span>You will receive a confirmation email shortly.</span>
            </div>





        </div>
        <div class="clear"></div>
    </div>
    <script src="js/jquery.min.js"></script>
    <script src="js/jquery-ui.js"></script>
    <script src="js/flickity.pkgd.min.js"></script>


    <script type="text/javascript">

        $(function () {
            $('#hiddenDate').datepicker({
                changeYear: 'true',
                changeMonth: 'true',
                startDate: '07/16/1989',
                firstDay: 1
            });
            $('#linkswitchtodate').click(function (e) {
                $('#hiddenDate').datepicker("show");
                e.preventDefault();
            });

            $("#hiddenDate").change(function () {
              
                switchdate();
            });
        });

      

        function showalert(msg) {

            document.getElementById("divAlertMessage").innerHTML = msg;
            $('#divalertbox').show();
        }
        var previousid = "";
        function goprevious(id, id1) {
            $('#div' + id).show();
            $('#div' + id1).hide();
        }
        function setappointment(id, id2,idTime) {
            $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").show();
            var args1 = { nid: id };
            $.ajax({
                type: "POST",
                contentType: "application/json",
                data: JSON.stringify(args1),
                url: "Default.aspx/getEmpAvailabilitybyid",
                dataType: "json",
                success: function (data) {

                    if (data.d != "failure") {


                        $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();

                        if (previousid != "") {
                            $('#' + previousid).removeClass("trselected");

                        }
                        previousid = $(id2).attr("id");

                        //$('#div3').show();
                        // $('#div2').hide();

                        jsonarr = jQuery.parseJSON(data.d);
                        if (jsonarr.length > 0) {

                            for (var i in jsonarr) {
                                $(id2).addClass("trselected");
                                document.getElementById("hidslabid").value = jsonarr[i].nid;
                                document.getElementById("hidadate").value = jsonarr[i].adate1;
                                document.getElementById("hidfromtime").value = jsonarr[i].afrmTime;
                                document.getElementById("hidtotime").value = jsonarr[i].aToTime;
                                document.getElementById("hiselectedtime").value = idTime;
                                document.getElementById("divselecedTime").style.display = "block";
                                document.getElementById("divtime").innerHTML = jsonarr[i].adate1 + ' ' + document.getElementById("hiselectedtime").value.replace("am"," AM").replace("pm"," PM");

                                //initilizetime(jsonarr[i].afrmTime, jsonarr[i].aToTime);


                            }
                        }
                    }



                },
                error: function (x, e) {
                    $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();
                }

            });

        }
        var jstatus = 0;
        var $carousel = $('.main-carousel')
        function getAvailability() {

            var status = 1;
            if (document.getElementById("dropcontactperson").value == "") {
                status = 0;
                document.getElementById("dropcontactperson").style.borderColor = "red";
            }
            else {
                document.getElementById("dropcontactperson").style.borderColor = "#cccccc";
            }
            if (status == 1) {
                $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").show();
                var args1 = { empid: document.getElementById("dropcontactperson").value };
                $.ajax({
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify(args1),
                    url: "Default.aspx/getEmpAvailability",
                    dataType: "json",
                    success: function (data) {

                        if (data.d != "failure") {
                            if (jstatus != 0) {
                                $carousel.flickity('destroy');
                            }
                            jstatus = jstatus + 1;

                            $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();


                            previousid = "";
                            document.getElementById("hidslabid").value = "";
                            document.getElementById("hidadate").value = "";
                            document.getElementById("hidfromtime").value = "";
                            document.getElementById("hidtotime").value = "";
                            document.getElementById("hiselectedtime").value = "";
                            document.getElementById("divtime").innerHTML = "";
                            document.getElementById("divselecedTime").style.display = "none";
                            document.getElementById("divtable").innerHTML = data.d;
                            document.getElementById("divavheading").innerHTML = "Availability of " + $("#dropcontactperson :selected").text();
                            $('#div1').hide();
                            $('#div2').show();




                            $carousel.flickity({
                                // options

                                cellAlign: 'left',
                                contain: true
                            });


                            $('#goleft').on('click', function () {
                                $carousel.flickity('previous');
                            });


                            $('#goright').on('click', function () {
                                $carousel.flickity('next');
                            });
                        }



                    },
                    error: function (x, e) {
                        $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();
                    }

                });
            }

        }

        function switchdate() {
            var index = 0,result=0;
            $(".flickity-slider > li").each(function () {
                var dtid = $(this).attr("id");
             
                if (dtid == document.getElementById("hiddenDate").value) {
                   
                    result = 1;
                    $carousel.flickity('select', index);
                }
                index = index + 1;
            });

            if(result==0)
            {
                showalert("Selected date does not exists in availability list!");
            }
        }

        function checktime(id) {

            var status = true;
            var regexp = /^ *(1[0-2]|[1-9]):[0-5][0-9] *(a|p|A|P)(m|M) *$/;

            var fromtime = document.getElementById("txtfrmtime").value;
            var totime = document.getElementById("txtotime").value;
            var newid = "";
            if (id == 1)
                newid = "txtfrmtime";
            else
                newid = "txtotime";

            var ctime;

            if ($('#' + newid).val() != "") {
                var correct = ($('#' + newid).val().search(regexp) >= 0) ? true : false;
                if (!correct) {
                    document.getElementById(newid).value = "";
                    showalert("Wrong time format");
                    status = false;
                }
                else {
                    var newval = $('#' + newid).val();
                    var arr = newval.split(':');
                    newval = arr[1];
                    newval = (newval.replace("am", "")).replace("pm", "");

                    if (newval != "00" && newval != "30") {
                        document.getElementById(newid).value = "";
                        showalert("Select time from list!");
                        return;
                    }
                }

                if (id == 1) {

                    ctime = document.getElementById("hidfromtime").value;
                    if (new Date("01/01/2000 " + fromtime.replace('a', ' a').replace('p', ' p')) < new Date("01/01/2000 " + ctime.replace('a', ' a').replace('p', ' p'))) {

                        document.getElementById(newid).value = "";
                        showalert("From Time should greater then " + ctime + "!");

                        status = false;
                    }


                }
                else {
                    ctime = document.getElementById("hidtotime").value;
                    if (new Date("01/01/2000 " + totime.replace('a', ' a').replace('p', ' p')) > new Date("01/01/2000 " + ctime.replace('a', ' a').replace('p', ' p'))) {

                        document.getElementById(newid).value = "";
                        showalert("To Time should not be greater then " + ctime + "!");

                        status = false;
                    }
                }

            }




            if (fromtime != "" && totime != "") {


                if (new Date("01/01/2000 " + fromtime.replace('a', ' a').replace('p', ' p')) > new Date("01/01/2000 " + totime.replace('a', ' a').replace('p', ' p'))) {

                    document.getElementById(newid).value = "";
                    showalert("From Time should not be greater then To Time!");

                    status = false;
                }
                else {

                    if (fromtime == totime) {
                        document.getElementById(newid).value = "";
                        showalert("From Time and To Time should  be different !");

                        status = false;
                    }
                }

            }
            return status;
        }

        function saveappointment() {
            var status = 1;
            var newid = "";

           
            if (document.getElementById("hidslabid").value == "" || document.getElementById("hidadate").value == "" || document.getElementById("hiselectedtime").value == "") {
                status = 0;
                showalert("Please pick a time slot from availability list!");

            }
            


            newid = "dropservice";
            if (document.getElementById(newid).value == "") {
                status = 0;
                document.getElementById(newid).style.borderColor = "red";

            }
            else {
                document.getElementById(newid).style.borderColor = "#cdcdcd";


            }

            newid = "txtname";
            if (document.getElementById(newid).value == "") {
                status = 0;
                document.getElementById(newid).style.borderColor = "red";

            }
            else {
                document.getElementById(newid).style.borderColor = "#cdcdcd";


            }
            //newid = "txtdesignation";
            //if (document.getElementById(newid).value == "") {
            //    status = 0;
            //    document.getElementById(newid).style.borderColor = "red";

            //}
            //else {
            //    document.getElementById(newid).style.borderColor = "#cdcdcd";


            //}

            //newid = "txtorg";
            //if (document.getElementById(newid).value == "") {
            //    status = 0;
            //    document.getElementById(newid).style.borderColor = "red";

            //}
            //else {
            //    document.getElementById(newid).style.borderColor = "#cdcdcd";


            //}

            //newid = "txtcontact";
            //if (document.getElementById(newid).value == "") {
            //    status = 0;
            //    document.getElementById(newid).style.borderColor = "red";

            //}
            //else {
            //    document.getElementById(newid).style.borderColor = "#cdcdcd";


            //}


            newid = "txtemail";
            if (document.getElementById(newid).value == "") {
                status = 0;
                document.getElementById(newid).style.borderColor = "red";
            }
            else {
                document.getElementById(newid).style.borderColor = "#cdcdcd";

                var correct = validateEmail(document.getElementById(newid).value);
                if (correct) {
                    document.getElementById(newid).style.borderColor = "#cdcdcd";

                }
                else {

                    status = 0;
                    document.getElementById(newid).style.borderColor = "red";
                }
            }
           
           

            //newid = "txtotime";
            //if (document.getElementById(newid).value == "") {
            //    status = 0;
            //    document.getElementById(newid).style.borderColor = "red";
            //}
            //else {
            //    if (!checktime(2))
            //        status = 0;
            //}

            if (status == 1) {
                $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").show();
                var args1 = { sloatid: document.getElementById("hidslabid").value, empid: document.getElementById("dropcontactperson").value, aDate: document.getElementById("hidadate").value, frmTime: document.getElementById("hiselectedtime").value, ToTime:"", vName: document.getElementById("txtname").value, designation: document.getElementById("txtdesignation").value, company: document.getElementById("txtorg").value, email: document.getElementById("txtemail").value, contactno: document.getElementById("txtcontact").value, service: document.getElementById("dropservice").value };
                $.ajax({
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify(args1),
                    url: "Default.aspx/saveEmpAvailability",
                    dataType: "json",
                    success: function (data) {

                        if (data.d != "failure") {
                            msg = "1";
                            $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();
                            $('#div2').hide();
                            $('#div4').show();
                        }




                    },
                    error: function (x, e) {
                        $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();
                    }

                });
            }
        }
        function initilizetime(mintime, maxtime) {
            $.getScript("js/jquery.timepicker.js", function () {

                $('#txtfrmtime').timepicker({

                    'step': 60,
                    minTime: mintime,
                    maxTime: maxtime


                });
                $('#txtotime').timepicker({

                    'step': 60,
                    minTime: mintime,
                    maxTime: maxtime



                });


            });
        }
        $(document).ready(function () {


            // getAvailability();


        });
    </script>

    <script type="text/html"></script>
</asp:Content>
