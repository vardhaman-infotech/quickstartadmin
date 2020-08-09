<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="AttendenceReader.aspx.cs" Inherits="empTimeSheet.AttendenceReader" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>


<%@ Register Assembly="TimePicker" Namespace="MKB.TimePicker" TagPrefix="tPic" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .att_hypen {
        }

        .att_eno {
            font-weight: bold;
        }

        .att_emp {
            font-weight: bold;
            color: blue;
        }

        .att_wo {
            color: red;
        }

        .gridheader th {
            max-width: 110px;
            min-width: 90px;
        }

            .gridheader th:first-child {
                width: auto;
                width: 60px;
            }

        .attpopup table {
            max-width: 450px;
            margin-left: 10px;
        }

            .attpopup table td {
                padding: 6px 4px;
            }

        .timepicker table {
            margin-left: 0px;
        }

            .timepicker table td {
                padding: 0px;
                line-height: 0px;
            }

                .timepicker table td input {
                    width: 8px !important;
                    margin: 0px !important;
                    height: 17px !important;
                    text-align: center;
                }

                    .timepicker table td input:first-child {
                        width: 25px !important;
                        text-align: left;
                    }

                    .timepicker table td input:last-child {
                        width: 25px !important;
                        text-align: left;
                    }

        .table-success td, th {
            border-left: solid 1px #8e8e8e;
            border-right: solid 1px #8e8e8e;
        }

        button[disabled], html input[disabled] {
            background: #dadada;
        }
    </style>

    <script type="text/javascript">
        //close all popup
        function closediv() {

            document.getElementById("AddAttendence").style.display = "none";
            document.getElementById("otherdiv").style.display = "none";
        }


        //Open add/edit div
        function opendiv() {
            setposition("AddAttendence", "10%");
            document.getElementById("AddAttendence").style.display = "block";
            document.getElementById("otherdiv").style.display = "block";

        }


     <%--   $(function () {


            $('#<%= chkINtime.ClientID  %>').click(function (e) {

                
                var textBox1 = $('#<%=TimeSelector1.ClientID %>');
                alert('#<%=TimeSelector1.ClientID %>');

                if (this.checked) {
                  
                    document.getElementById("ctl00_ContentPlaceHolder1_AddAttendence").attr('disabled', 'disabled');
                }
                else {
                    textBox1.removeAttr('disabled');
                }
            });


        });--%>

        function blankdata() {

            document.getElementById('Att_hidintime').value = "";
            document.getElementById('Att_hidotime').value = "";
            document.getElementById('Att_hidInid').value = "";
            document.getElementById('Att_hidOnid').value = "";

            document.getElementById('ctl00$ContentPlaceHolder1$TimeSelector1_txtHour').value = "";
            document.getElementById('ctl00$ContentPlaceHolder1$TimeSelector1_txtMinute').value = "";

            document.getElementById('ctl00$ContentPlaceHolder1$TimeSelector2_txtHour').value = "";
            document.getElementById('ctl00$ContentPlaceHolder1$TimeSelector2_txtMinute').value = "";

            document.getElementById("ctl00_ContentPlaceHolder1_txtdate").value = setDateFromat(Date.now());
            document.getElementById('ctl00_ContentPlaceHolder1_chkINtime').checked = false;
            document.getElementById('ctl00_ContentPlaceHolder1_chkOutTime').checked = false;

            document.getElementById('ctl00$ContentPlaceHolder1$TimeSelector1_txtHour').disabled = true;
            document.getElementById('ctl00$ContentPlaceHolder1$TimeSelector1_txtMinute').disabled = true;


            document.getElementById('ctl00$ContentPlaceHolder1$TimeSelector2_txtHour').disabled = true;
            document.getElementById('ctl00$ContentPlaceHolder1$TimeSelector2_txtMinute').disabled = true;
        }
        function enagleInout(type) {

            if (type = 'I') {
                var intime = document.getElementById('Att_hidintime').value.split(":");


                if (document.getElementById('ctl00_ContentPlaceHolder1_chkINtime').checked == true) {
                    document.getElementById('ctl00$ContentPlaceHolder1$TimeSelector1_txtHour').disabled = false;
                    document.getElementById('ctl00$ContentPlaceHolder1$TimeSelector1_txtMinute').disabled = false;
                }
                else {
                    document.getElementById('ctl00$ContentPlaceHolder1$TimeSelector1_txtHour').disabled = true;
                    document.getElementById('ctl00$ContentPlaceHolder1$TimeSelector1_txtMinute').disabled = true;
                }
                if (intime.length > 1) {
                    document.getElementById('ctl00$ContentPlaceHolder1$TimeSelector1_txtHour').value = intime[0];
                    document.getElementById('ctl00$ContentPlaceHolder1$TimeSelector1_txtMinute').value = intime[1];
                }
                else {

                    document.getElementById('ctl00$ContentPlaceHolder1$TimeSelector1_txtHour').value = "";
                    document.getElementById('ctl00$ContentPlaceHolder1$TimeSelector1_txtMinute').value = "";
                }

            }

            if (type = 'O') {
                var intime = document.getElementById('Att_hidotime').value.split(":");


                if (document.getElementById('ctl00_ContentPlaceHolder1_chkOutTime').checked == true) {
                    document.getElementById('ctl00$ContentPlaceHolder1$TimeSelector2_txtHour').disabled = false;
                    document.getElementById('ctl00$ContentPlaceHolder1$TimeSelector2_txtMinute').disabled = false;
                }
                else {
                    document.getElementById('ctl00$ContentPlaceHolder1$TimeSelector2_txtHour').disabled = true;
                    document.getElementById('ctl00$ContentPlaceHolder1$TimeSelector2_txtMinute').disabled = true;
                }
                if (intime.length > 1) {
                    document.getElementById('ctl00$ContentPlaceHolder1$TimeSelector2_txtHour').value = intime[0];
                    document.getElementById('ctl00$ContentPlaceHolder1$TimeSelector2_txtMinute').value = intime[1];
                }
                else {

                    document.getElementById('ctl00$ContentPlaceHolder1$TimeSelector2_txtHour').value = "";
                    document.getElementById('ctl00$ContentPlaceHolder1$TimeSelector2_txtMinute').value = "";
                }

            }

        }

        function getInOutTime() {

            $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
            var enrollno = document.getElementById("ctl00_ContentPlaceHolder1_dropemployee").value;
            var pDate = document.getElementById("ctl00_ContentPlaceHolder1_txtdate").value;
            var companyid = document.getElementById("hidcompanyid").value;

            var args = { enrollno: enrollno, pdate: pDate, companyid: companyid };

            $.ajax({
                type: "POST",
                url: "AttendenceReader.aspx/getNID",
                data: JSON.stringify(args),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                cache: false,
                success: function (data) {
                    if (data.d != "") {
                        var str = String(data.d);
                        var array = str.split("###");
                        document.getElementById('Att_hidintime').value = array[0];
                        document.getElementById('Att_hidotime').value = array[1];
                        document.getElementById('Att_hidInid').value = array[2];
                        document.getElementById('Att_hidOnid').value = array[3];


                        if (array[2] != "") {

                            var intime = array[0].split(":");
                            document.getElementById('ctl00$ContentPlaceHolder1$TimeSelector1_txtHour').value = intime[0];
                            document.getElementById('ctl00$ContentPlaceHolder1$TimeSelector1_txtMinute').value = intime[1];
                        }
                        else {

                            document.getElementById('ctl00$ContentPlaceHolder1$TimeSelector1_txtHour').value = '00';
                            document.getElementById('ctl00$ContentPlaceHolder1$TimeSelector1_txtMinute').value = '00';
                        }

                        if (array[3] != "") {

                            var outtime = array[1].split(":");
                            document.getElementById('ctl00$ContentPlaceHolder1$TimeSelector2_txtHour').value = outtime[0];
                            document.getElementById('ctl00$ContentPlaceHolder1$TimeSelector2_txtMinute').value = outtime[1];
                        }
                        else {
                            document.getElementById('ctl00$ContentPlaceHolder1$TimeSelector2_txtHour').value = '00';
                            document.getElementById('ctl00$ContentPlaceHolder1$TimeSelector2_txtMinute').value = '00';
                        }
                        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                    }
                    else {
                        alert("Server error please try again");
                        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                    }
                }

            });
        }
        function getAttendance() {
            var userid = "0";
            if (document.getElementById("Att_hidview").value == "1")
            {
                userid = document.getElementById("Att_EnrollNo").value;

            }
            if (document.getElementById("Att_hidViewOthers").value == "1") {
                userid ="";

            }



            var args = { fromdate: document.getElementById("ctl00_ContentPlaceHolder1_txtfrom").value, todate: document.getElementById("ctl00_ContentPlaceHolder1_txtto").value, companyid: document.getElementById("hidcompanyid").value, userid: userid };
            $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
            $.ajax({
                type: "POST",
                url: "AttendenceReader.aspx/getAttandence",
                data: JSON.stringify(args),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                cache: false,
                success: function (data) {
                    if (data.d != "") {
                        document.getElementById("divattendance").innerHTML = data.d;
                        document.getElementById("divnodata").innerHTML = "";
                        document.getElementById("divnodata").style.display = "none";
                    }
                    else {
                        document.getElementById("divattendance").innerHTML = "";
                        document.getElementById("divnodata").innerHTML = "No data found.";
                        document.getElementById("divnodata").style.display = "block";
                    }
                    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                }

            });
        }




        function updateAttendence() {
       
            var ptime = "";
            var ptime1 = "";
            var status = 1;
            if (document.getElementById("ctl00_ContentPlaceHolder1_txtdate").value == "") {
                status = 0;
                document.getElementById("ctl00_ContentPlaceHolder1_txtdate").style.borderColor = "red";

            }
            else {
                document.getElementById("ctl00_ContentPlaceHolder1_txtdate").style.borderColor = "#cdcdcd";
            }
            if (document.getElementById("ctl00_ContentPlaceHolder1_dropemployee").value == "") {
                status = 0;
                document.getElementById("ctl00_ContentPlaceHolder1_dropemployee").style.borderColor = "red";

            }
            else {
                document.getElementById("ctl00_ContentPlaceHolder1_dropemployee").style.borderColor = "#cdcdcd";
            }

            if (document.getElementById("ctl00_ContentPlaceHolder1_chkINtime").checked == true) {
                if (document.getElementById("ctl00$ContentPlaceHolder1$TimeSelector1_txtHour").value == "" || document.getElementById("ctl00$ContentPlaceHolder1$TimeSelector1_txtMinute").value == "") {
                    status = 0;
                    document.getElementById("ctl00$ContentPlaceHolder1$TimeSelector1_txtMinute").style.borderColor = "red";
                    document.getElementById("ctl00$ContentPlaceHolder1$TimeSelector1_txtHour").style.borderColor = "red";
                }
                else {

                    document.getElementById("ctl00$ContentPlaceHolder1$TimeSelector1_txtMinute").style.borderColor = "#cdcdcd";
                    document.getElementById("ctl00$ContentPlaceHolder1$TimeSelector1_txtHour").style.borderColor = "#cdcdcd";
                    ptime = String(document.getElementById("ctl00$ContentPlaceHolder1$TimeSelector1_txtHour").value).trim() + ":" + String(document.getElementById("ctl00$ContentPlaceHolder1$TimeSelector1_txtMinute").value).trim();
                }

            }
            else {
                document.getElementById("ctl00$ContentPlaceHolder1$TimeSelector1_txtMinute").style.borderColor = "#cdcdcd";
                document.getElementById("ctl00$ContentPlaceHolder1$TimeSelector1_txtHour").style.borderColor = "#cdcdcd";
            }

            if (document.getElementById("ctl00_ContentPlaceHolder1_chkOutTime").checked == true) {
                if (document.getElementById("ctl00$ContentPlaceHolder1$TimeSelector2_txtHour").value == "" || document.getElementById("ctl00$ContentPlaceHolder1$TimeSelector2_txtMinute").value == "") {
                    status = 0;
                    document.getElementById("ctl00$ContentPlaceHolder1$TimeSelector2_txtMinute").style.borderColor = "red";
                    document.getElementById("ctl00$ContentPlaceHolder1$TimeSelector2_txtHour").style.borderColor = "red";
                }
                else {

                    document.getElementById("ctl00$ContentPlaceHolder1$TimeSelector2_txtMinute").style.borderColor = "#cdcdcd";
                    document.getElementById("ctl00$ContentPlaceHolder1$TimeSelector2_txtHour").style.borderColor = "#cdcdcd";
                    ptime1 = String(document.getElementById("ctl00$ContentPlaceHolder1$TimeSelector2_txtHour").value).trim() + ":" + String(document.getElementById("ctl00$ContentPlaceHolder1$TimeSelector2_txtMinute").value).trim();
                }

            }
            else {
                document.getElementById("ctl00$ContentPlaceHolder1$TimeSelector2_txtMinute").style.borderColor = "#cdcdcd";
                document.getElementById("ctl00$ContentPlaceHolder1$TimeSelector2_txtHour").style.borderColor = "#cdcdcd";
            }

            if (ptime != "" && ptime1 != "") {
                var dt1=new Date('01/01/2011 ' + ptime);
                var dt2=new Date('01/01/2011 ' + ptime1);



                var startTime = ptime+":00";
                var endTime = ptime1 + ":00";
                var regExp = /(\d{1,2})\:(\d{1,2})\:(\d{1,2})/;
               

                if (parseInt(endTime.replace(regExp, "$1$2$3")) < parseInt(startTime.replace(regExp, "$1$2$3"))) {
                    status = 0;
                    document.getElementById("ctl00$ContentPlaceHolder1$TimeSelector2_txtMinute").style.borderColor = "red";
                    document.getElementById("ctl00$ContentPlaceHolder1$TimeSelector2_txtHour").style.borderColor = "red";

                    document.getElementById("ctl00$ContentPlaceHolder1$TimeSelector1_txtMinute").style.borderColor = "red";
                    document.getElementById("ctl00$ContentPlaceHolder1$TimeSelector1_txtHour").style.borderColor = "red";
                    alert("Time In could not be greater then Time out!")

                }

            }

            if (status == 0) {
                return false;
            }
            else {

                var enrollno = document.getElementById("ctl00_ContentPlaceHolder1_dropemployee").value;
                var pDate = document.getElementById("ctl00_ContentPlaceHolder1_txtdate").value;
                var companyid = document.getElementById("hidcompanyid").value;

                var inid = document.getElementById("Att_hidInid").value;
                var onid = document.getElementById("Att_hidOnid").value;

                var args = { enrollno: enrollno, pdate: pDate, companyid: companyid, inTime: ptime, outTime: ptime1, inNid: inid, oNid: onid, Addedby: document.getElementById("hidloginid").value };
                $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
                $.ajax({
                    type: "POST",
                    url: "AttendenceReader.aspx/manualAtt",
                    data: JSON.stringify(args),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: true,
                    cache: false,
                    success: function (data) {
                        if (data.d != "") {
                            var str = String(data.d);
                            alert("Saved successfully!");
                            closediv();
                            getAttendance();
                        }
                        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                    }

                });
            }


        }
        function hidedetails() { }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div style="width: 100%; float: left; vertical-align: top; margin-bottom: 30px;"
        id="divsheetbox">
        <div id="otherdiv" onclick="closediv();">
        </div>
        <pg:progress ID="progress1" runat="server" />

        <div style="display: none; width: 500px;" id="AddAttendence" class="itempopup">
            <div class="popup_heading">
                <span id="legendaction" runat="server">Manual Time Entry </span>
                <div class="f_right">
                    <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
                </div>
            </div>
            <div class="tabContents attpopup" style="padding-top: 15px;">

                <table align="center">
                    <tr>
                        <td style="width: 105px;">Employee:
                        </td>

                        <td colspan="2">
                            <input type="hidden" id="Att_hidintime" />
                            <input type="hidden" id="Att_hidotime" />
                            <input type="hidden" id="Att_hidInid" />
                            <input type="hidden" id="Att_hidOnid" />
                            <asp:DropDownList ID="dropemployee" runat="server" CssClass="form-control" onchange="getInOutTime();">
                            </asp:DropDownList>

                        </td>
                    </tr>
                    <tr>
                        <td>Date:
                        </td>

                        <td colspan="2">
                            <asp:TextBox ID="txtdate" runat="server" CssClass="form-control hasDatepicker" Style="margin-top: 0px;" onchange="getInOutTime();"></asp:TextBox>

                            <cc1:CalendarExtender ID="cal1" runat="server" TargetControlID="txtdate" PopupButtonID="txtdisplayon"
                                Format="MM/dd/yyyy">
                            </cc1:CalendarExtender>

                        </td>
                    </tr>
                    <tr>

                        <td>
                            <asp:CheckBox ID="chkINtime" runat="server" Text="Time In:" onclick="enagleInout('I');" Checked="true" CssClass="chkboxnew" />
                        </td>

                        <td>
                            <tPic:TimeSelector ID="TimeSelector1" runat="server" DisplaySeconds="false" SelectedTimeFormat="TwentyFour" CssClass="timepicker">
                            </tPic:TimeSelector>
                        </td>



                    </tr>
                    <tr>
                        <td>
                            <asp:CheckBox ID="chkOutTime" runat="server" Text="Time Out:" onclick="enagleInout('O');" Checked="true" CssClass="chkboxnew" />
                        </td>

                        <td>
                            <tPic:TimeSelector ID="TimeSelector2" runat="server" DisplaySeconds="false" SelectedTimeFormat="TwentyFour" CssClass="timepicker">
                            </tPic:TimeSelector>
                        </td>



                    </tr>
                    <tr>
                        <td></td>

                        <td colspan="2">
                            <input type="button" id="btnSubmit" class="btn btn-primary" value="Save" onclick="return updateAttendence();" />

                        </td>
                    </tr>

                </table>




                <div class="clear"></div>



            </div>
        </div>

        <div class="pageheader">
            <h2>
                <i class="fa  fa-file-text"></i>Time  Clock
            </h2>
            <div class="breadcrumb-wrapper mar ">
                <input type="hidden" id="hidid" runat="server" />
                <asp:LinkButton ID="btnexportcsv" runat="server" CssClass="right_link" OnClick="btnexportcsv_Click">
                <i class="fa fa-fw fa-file-excel-o topicon"></i>Export to Excel</asp:LinkButton>

            </div>
            <div class="breadcrumb-wrapper mar ">
                <input type="hidden" id="Hidden1" runat="server" />
                <a class="right_link" id="linkaddnew" runat="server" onclick="blankdata();opendiv();">
                    <i class="fa fa-fw fa-plus topicon"></i>Add Manual Time</a>
            </div>
            <div class="clear">
            </div>
            <div class="clear">
            </div>

            <asp:HiddenField ID="Att_hidAdd" runat="server" ClientIDMode="Static" />
            <asp:HiddenField ID="Att_hidview" runat="server" ClientIDMode="Static" />
            <asp:HiddenField ID="Att_hidViewOthers" runat="server" ClientIDMode="Static" />
             <asp:HiddenField ID="Att_EnrollNo" runat="server" ClientIDMode="Static" />
        </div>
        <div class="contentpanel">
            <div class="row">
                <div class="col-sm-12 col-md-12">
                    <div class="panel panel-default" style="min-height: 450px;">
                        <div class="col-sm-12 col-md-10">
                            <div style="padding-top: 10px;">
                                <div class="col-xs-12 col-sm-8 col-md-6 f_left" style="padding: 0px;">
                                    <h5 class="subtitle mb5">Employees Attendence</h5>

                                </div>

                                <div class="clear">
                                </div>
                                <div style="float: left; width: 800px;">
                                    <div class="col-sm-2 col-md-2 f_left pad f_left">
                                        <asp:TextBox ID="txtfrom" runat="server" CssClass="form-control hasDatepicker" onchange="comparedate(this.id,'ctl00_ContentPlaceHolder1_txtfrom','ctl00_ContentPlaceHolder1_txtto');hidedetails();"></asp:TextBox>
                                        <cc1:CalendarExtender ID="txtDate_CalendarExtender" runat="server" TargetControlID="txtfrom"
                                            PopupButtonID="txtfrom" Format="MM/dd/yyyy">
                                        </cc1:CalendarExtender>

                                    </div>
                                    <div class="col-sm-2  col-md-2  f_left   pad5">

                                        <asp:TextBox ID="txtto" runat="server" CssClass="form-control hasDatepicker" onchange="comparedate(this.id,'ctl00_ContentPlaceHolder1_txtfrom','ctl00_ContentPlaceHolder1_txtto');hidedetails();"></asp:TextBox>

                                        <cc1:CalendarExtender ID="txtDate_CalendarExtender1" runat="server" TargetControlID="txtto"
                                            PopupButtonID="txtto" Format="MM/dd/yyyy">
                                        </cc1:CalendarExtender>


                                    </div>
                                    <div class="col-sm-1 col-md-1 f_left">
                                        <input type="button" onclick="getAttendance();" value="Search" class="btn btn-default" />
                                     
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="clear">
                        </div>
                        <div id="divright" class="col-sm-12 col-md-12 mar3">
                            <div class="panel panel-default">
                                <div class="panel-body2 ">
                                    <div class="row">
                                        <div class="table-responsive">
                                            <div class="nodatafound" id="divnodata">
                                                No data found
                                            </div>
                                            <div id="divattendance"></div>

                                        </div>
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
    <script type="text/javascript">
        $(document).ready(function () { getAttendance(); });


       
    </script>
</asp:Content>
