<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="project_log.aspx.cs" Inherits="empTimeSheet.project_log" %>

<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="rightclickback" id="rightclickback" onclick="closecopy();"></div>
    <div id="diveventtype" runat="server" clientidmode="Static" style="display: none;"></div>
    <div style="width: 100%; float: left; vertical-align: top; margin-bottom: 30px;"
        id="divsheetbox">
        <pg:progress ID="progress1" runat="server" />
        <div id="otherdiv" onclick="closediv();">
        </div>
        <div class="pageheader">
            <h2>
                <i
                    class="fa fa-fw" style="border: none; font-size: 24px; border-radius: initial; padding: 0px;"></i>Project Logs
            </h2>
            <div class="breadcrumb-wrapper" style="display: none;" id="divexport">
                <a id="btnexportcsv" class="right_link" onclick="exportexcel();">
                    <i class="fa fa-fw fa-file-excel-o topicon"></i>Export to Excel</a>

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
                                    <label class="lbl lbl1">
                                        From Event Date :
                                    </label>
                                    <div class="txt w1 mar10">

                                        <asp:TextBox ID="txtfrom" runat="server" CssClass="form-control hasDatepicker" onchange="comparedate(this.id,'ctl00_ContentPlaceHolder1_txtfrom','ctl00_ContentPlaceHolder1_txtto');"></asp:TextBox>
                                        <cc1:CalendarExtender ID="txtDate_CalendarExtender" runat="server" TargetControlID="txtfrom"
                                            PopupButtonID="txtfrom" Format="MM/dd/yyyy">
                                        </cc1:CalendarExtender>


                                    </div>
                                </div>
                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl lbl1">
                                        To Event Date :
                                    </label>

                                    <div class="txt w1 mar10">
                                        <asp:TextBox ID="txtto" runat="server" CssClass="form-control hasDatepicker" onchange="comparedate(this.id,'ctl00_ContentPlaceHolder1_txtfrom','ctl00_ContentPlaceHolder1_txtto');"></asp:TextBox>

                                        <cc1:CalendarExtender ID="txtDate_CalendarExtender1" runat="server" TargetControlID="txtto"
                                            PopupButtonID="txtto" Format="MM/dd/yyyy">
                                        </cc1:CalendarExtender>


                                    </div>
                                </div>
                                <div class="clear"></div>
                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl lbl1">
                                        Project :
                                    </label>

                                    <div class="txt w1 mar10">
                                        <asp:DropDownList ID="droproject" runat="server" CssClass="form-control" onchange="hidedetails();">
                                        </asp:DropDownList>
                                    </div>

                                </div>
                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl lbl1">
                                        Employee :
                                    </label>

                                    <div class="txt w1 mar10">
                                        <asp:DropDownList ID="dropemployee" runat="server" CssClass="form-control" onchange="hidedetails();">
                                        </asp:DropDownList>
                                    </div>

                                </div>



                                <div class="ctrlGroup searchgroup">
                                    <input type="button" value="Search" class="btn btn-default" onclick="fillprojectdata();" />

                                </div>


                                <div class="clear">
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
                                                                <th width="100px">Event
                                                                </th>
                                                                <th>Description
                                                                </th>
                                                                <th width="125px">Event Date
                                                                </th>
                                                                <th width="80px">Employee
                                                                </th>
                                                                <th width="125px">Follow-Up Date
                                                                </th>
                                                                <th width="125px">Completion Date
                                                                </th>



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
                                                                    <select class="form-control" id="dropevent0"></select>
                                                                </td>
                                                                <td>
                                                                    <input type="text" id="txtdes0" class="form-control" />
                                                                </td>

                                                                <td>
                                                                    <input type="text" id="txteventdate0" class="form-control" onchange="checkdate(this.value,this.id);" />
                                                                </td>
                                                                <td>
                                                                    <input type="text" id="txtemp0" class="form-control" readonly="readonly" />
                                                                </td>
                                                                <td>
                                                                    <input type="text" id="txtfDate0" class="form-control" onchange="checkdate(this.value,this.id);" />
                                                                </td>
                                                                <td>
                                                                    <input type="text" id="txtcdate0" class="form-control" onchange="checkdate(this.value,this.id);" />
                                                                </td>
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
                                        <input type="hidden" id="projectlog_hidrowno" clientidmode="Static" runat="server" />
                                        <input type="hidden" id="projectlog_hidsno" clientidmode="Static" runat="server" />
                                        <input type="hidden" id="projectlog_minDate" clientidmode="Static" runat="server" />
                                        <input type="hidden" id="projectlog_hidempid" clientidmode="Static" runat="server" />

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


    <script src="js/jquery-ui.js"></script>


    <script src="js/jquery.table2excel.js"></script>





    <script>
        var jsonarr;
        function closediv() {
            $('#divviewappointment').hide();
            $('#otherdiv').hide();
        }

        function fillprojectdata() {
            var status = 1;
            if (document.getElementById("ctl00_ContentPlaceHolder1_droproject").value == "") {
                status = 0;
                alert("Please select a project!");
                return;
            }

            $('#tbldata tbody > tr').remove();
            $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").show();
            var args1 = { empid: document.getElementById("ctl00_ContentPlaceHolder1_dropemployee").value, compid: document.getElementById("hidcompanyid").value, fromdate: document.getElementById("ctl00_ContentPlaceHolder1_txtfrom").value, todate: document.getElementById("ctl00_ContentPlaceHolder1_txtto").value, projectid: document.getElementById("ctl00_ContentPlaceHolder1_droproject").value };
            $.ajax({
                type: "POST",
                contentType: "application/json",
                data: JSON.stringify(args1),
                url: "project_log.aspx/getProjectLog",
                dataType: "json",
                success: function (data) {

                    if (data.d != "failure") {

                        jsonarr = jQuery.parseJSON(data.d);
                        if (jsonarr.length > 0) {
                            document.getElementById("divexport").style.display = "block";
                            for (var i in jsonarr) {

                                var str = '';
                                var cls = '';



                                str = str + '<tr id="tr_' + i + '"><td>';
                                str = str + '<div id="divdel' + i + '"><a><img src="images/delete.png" onclick="deleteappoint(' + i + ');"  /></a></div>';

                                str = str + '<input type="hidden" id="hidApp_id' + i + '" value="' + jsonarr[i].nid + '" /></td>';
                                str = str + '<td><select id="dropevent' + i + '" class="form-control" >' + document.getElementById("diveventtype").innerHTML + '</select></td>';
                                str = str + '<td><input type="text" id="txtdes' + i + '" class="form-control"  value="' + jsonarr[i].eventlog + '" /></td>';
                                str = str + '<td><input  type="text" id="txteventdate' + i + '" class="form-control date" onchange="checkdate(this.value,this.id);" value="' + jsonarr[i].edate + '" /></td>';
                                str = str + '<td><input type="text" id="txtemp' + i + '" class="form-control"  value="' + jsonarr[i].loginId + '" readonly="readonly" /></td>';
                                str = str + '<td><input  type="text" id="txtfDate' + i + '" class="form-control date" onchange="checkdate(this.value,this.id);" value="' + jsonarr[i].fDate + '" /></td>';
                                str = str + '<td><input  type="text" id="txtcdate' + i + '" class="form-control date" onchange="checkdate(this.value,this.id);" value="' + jsonarr[i].cdate + '" /></td>';

                                str = str + '</tr>';

                                var el = $(str);
                                $('#tbldata > tbody:last').append(el);


                                $('#txteventdate' + i).datepicker();
                                $('#txtfDate' + i).datepicker();
                                $('#txtcdate' + i).datepicker();
                                $('#dropevent' + i).val(jsonarr[i].typeid);
                                document.getElementById("projectlog_hidrowno").value = i;


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
            if (document.getElementById("projectlog_hidrowno").value != "") {
                i = parseInt(document.getElementById("projectlog_hidrowno").value) + 1;

            }
            var str = '';

            str = str + '<tr id="tr_' + i + '"><td>';
            str = str + '<div id="divdel' + i + '"><a><img src="images/delete.png" onclick="deleteappoint(' + i + ');"  /></a></div>';
            str = str + '<input type="hidden" id="hidApp_id' + i + '" value="" /></td>';
            str = str + '<td><select id="dropevent' + i + '" class="form-control" >' + document.getElementById("diveventtype").innerHTML + '</select></td>';
            str = str + '<td><input type="text" id="txtdes' + i + '" class="form-control"  value="" /></td>';
            str = str + '<td><input  type="text" id="txteventdate' + i + '" class="form-control date" onchange="checkdate(this.value,this.id);" value="" /></td>';
            str = str + '<td><input type="text" id="txtemp' + i + '" class="form-control"  value="" readonly="readonly" /></td>';
            str = str + '<td><input  type="text" id="txtfDate' + i + '" class="form-control date" onchange="checkdate(this.value,this.id);" value="" /></td>';
            str = str + '<td><input  type="text" id="txtcdate' + i + '" class="form-control date" onchange="checkdate(this.value,this.id);" value="" /></td>';

            str = str + '</tr>';

            var el = $(str);
            $('#tbldata > tbody:last').append(el);

            //alert($(el).find('#txtfromtime' + i).attr("id"));



            $('#txteventdate' + i).datepicker();
            $('#txtfDate' + i).datepicker();
            $('#txtcdate' + i).datepicker();

            //$('#txtdate' + i).datepicker();

            document.getElementById("projectlog_hidrowno").value = i;

        }


        function deleteappoint(id) {

            var val = document.getElementById("hidApp_id" + id).value;
            var msg = "1";
            if (val != "") {
                if (confirm('Do you want to delete this log?')) {
                    msg = "0";
                    $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").show();
                    var args1 = { nid: val };
                    $.ajax({
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify(args1),
                        url: "project_log.aspx/deleteLog",
                        dataType: "json",
                        success: function (data) {

                            if (data.d != "failure") {
                                msg = "1";
                                $('#tr_' + id).remove();
                                fillprojectdata();
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
            document.getElementById("divexport").style.display = "none";

        }
        function savedata() {
            var nid1 = "", typeid1 = "", eventlog1 = "", edate1 = "", empid1 = "", fdate1 = "", cdate1 = "", addedby1 = "", companyid1 = "", projectid1 = "";




            var status = 1;

            if (document.getElementById("ctl00_ContentPlaceHolder1_dropemployee").value == "") {
                status = 0;
                alert("Please select an Employee!");
                return;

            }
            if (document.getElementById("ctl00_ContentPlaceHolder1_droproject").value == "") {
                status = 0;
                alert("Please select a project!");
                return;

            }

            addedby1 = document.getElementById("hidloginid").value;
            companyid1 = document.getElementById("hidcompanyid").value;

            var table = $("#tbldata tbody");
            table.find('tr').each(function (i, el) {
                var id = $(this).attr('id');


                id = id.replace("tr_", "");

                newid = "hidApp_id" + id;
                nid1 = nid1 + document.getElementById(newid).value + '#';

                newid = "dropevent" + id;
                if (document.getElementById(newid).value == "") {
                    status = 0;
                    document.getElementById(newid).style.borderColor = "red";

                }
                else {
                    document.getElementById(newid).style.borderColor = "#cdcdcd";
                    typeid1 = typeid1 + document.getElementById(newid).value + '#';

                }
                newid = "txtdes" + id;
                if (document.getElementById(newid).value == "") {
                    status = 0;
                    document.getElementById(newid).style.borderColor = "red";


                }
                else {
                    eventlog1 = eventlog1 + document.getElementById(newid).value + '#';
                    document.getElementById(newid).style.borderColor = "#cdcdcd";
                }

                newid = "txteventdate" + id;
                if (document.getElementById(newid).value == "") {
                    status = 0;
                    document.getElementById(newid).style.borderColor = "red";
                }
                else {
                    document.getElementById(newid).style.borderColor = "#cdcdcd";
                    edate1 = edate1 + document.getElementById(newid).value + '#';
                }
                empid1 = empid1 + document.getElementById("ctl00_ContentPlaceHolder1_dropemployee").value + '#';

                newid = "txtfDate" + id;
                fdate1 = fdate1 + document.getElementById(newid).value + '#';

                newid = "txtcdate" + id;
                cdate1 = cdate1 + document.getElementById(newid).value + '#';

                projectid1 = projectid1 + document.getElementById("ctl00_ContentPlaceHolder1_droproject").value + '#';

            });

            if (status == 1) {
                $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").show();
                var args1 = { nid: nid1, typeid: typeid1, eventlog: eventlog1, edate: edate1, empid: empid1, fdate: fdate1, cdate: cdate1, addedby: addedby1, companyid: companyid1, projectid: projectid1 };
                $.ajax({
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify(args1),
                    url: "project_log.aspx/saveProjectLog",
                    dataType: "json",
                    success: function (data) {

                        if (data.d != "failure") {
                            msg = "1";
                            $("div[id=ctl00_ContentPlaceHolder1_progress1_UpdateProg1]").hide();
                            fillprojectdata();
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


            hidedetails();


        });

        function exportexcel() {
            var str = '<table><tr><th>Event</th><th>Description</th><th>Event Date</th><th>Employee</th><th>Follow-Up-Date</th><th>Completion Date</th></tr>';
            if (jsonarr != null) {
                if (jsonarr.length > 0) {

                    for (var i in jsonarr) {






                        str = str + '<tr>';
                        str = str + '<td>' + jsonarr[i].typetitle + '</td>';
                        str = str + '<td>' + jsonarr[i].eventlog + '</td>';
                        str = str + '<td>' + jsonarr[i].edate + '</td>';
                        str = str + '<td>' + jsonarr[i].loginId + '</td>';
                        str = str + '<td>' + jsonarr[i].fDate + '</td>';
                        str = str + '<td>' + jsonarr[i].cdate + '</td>';

                        str = str + '</tr>';



                    }
                }

            }

            str = str + "</table>";
            var el = $(str);

            el.table2excel({
                name: "ProjectLog",
                filename: "Project Log"

            });
        }

    </script>
</asp:Content>
