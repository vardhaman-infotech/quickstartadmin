<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="projectAllocation_new.aspx.cs" Inherits="empTimeSheet.projectAllocation_new" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .detailbox {
            width: 100%;
            float: left;
            background: #f0f3f8;
            margin-bottom: 20px;
            color: #000000;
            font-family: Arial;
        }

        .detailbox_label {
            color: #000000;
            font-family: Arial;
            font-size: 12px;
            width: 100%;
            float: left;
            margin-bottom: 2px;
        }

            .detailbox_label a {
                color: rgb(18, 126, 244);
                text-decoration: underline;
            }

        .detailbox_inner {
            padding: 10px;
        }


        .detailbox_row1 {
            color: rgb(18, 126, 244);
            font-size: 19px;
            float: left;
            width: 100%;
        }

        .detailbox_parentarrow {
            padding: 0px 5px;
            color: rgb(18, 126, 244);
        }

        .detailbox_row2 {
            color: rgb(221, 123, 8);
            float: left;
            width: 100%;
            margin: 15px 0px;
        }

        .detailbox_row3 {
            float: left;
            width: 100%;
        }

        .detailbox_status {
            float: left;
            margin-right: 10px;
            margin-bottom: 5px;
        }

        .detailbox a {
            color: rgb(18, 126, 244);
            text-decoration: underline;
        }

        .detailbox_table {
            width: 100%;
            border-left: solid 1px #e0e0e0;
            line-height: 23px;
        }

            .detailbox_table td {
                width: 14.28%;
                padding: 5px 0px;
                border: solid 1px #e0e0e0;
                border-left: none;
                text-align: center;
            }

                .detailbox_table td span {
                    color: rgb(18, 126, 244);
                }
    </style>
    <script type="text/javascript">
        function reset() {
            document.getElementById('ctl00_ContentPlaceHolder1_ddlstaus').selectedIndex = 0;
            document.getElementById('ctl00_ContentPlaceHolder1_txtnewdate').value = "";
            document.getElementById('ctl00_ContentPlaceHolder1_txtcom').value = "";
            document.getElementById('ctl00_ContentPlaceHolder1_txtcompletedate').value = "";
            document.getElementById("spanstatus").innerHTML = "";
            document.getElementById("spanstdate").innerHTML = "";
            document.getElementById("spancomper").innerHTML = "";
        }
    </script>
    <script type="text/javascript">
        var spanid;
        function check_dd() {

            if (document.getElementById('ctl00_ContentPlaceHolder1_ddlstaus').value == "Started") {
                document.getElementById('divdate').style.display = 'block';
                document.getElementById('ctl00_ContentPlaceHolder1_txtnewdate').value = "";
            }
            else {
                document.getElementById('divdate').style.display = 'none';
            }
            if (document.getElementById('ctl00_ContentPlaceHolder1_ddlstaus').value == "Process") {
                document.getElementById('divpercentage').style.display = 'block';
                document.getElementById('ctl00_ContentPlaceHolder1_txtcom').value = "";
            }
            else {
                document.getElementById('divpercentage').style.display = 'none';
            }
            if (document.getElementById('ctl00_ContentPlaceHolder1_ddlstaus').value == "Completed") {
                document.getElementById('divcompletedate').style.display = 'block';
                document.getElementById('ctl00_ContentPlaceHolder1_txtcompletedate').value = "";

            }
            else {
                document.getElementById('divcompletedate').style.display = 'none';
            }

        }
    </script>
    <script type="text/javascript">
        function validatestatus() {
            var value = "1";

            var status = document.getElementById('<%=ddlstaus.ClientID %>').value;
            status = status.toLowerCase();

            if (status == "") {
                document.getElementById("spanstatus").innerHTML = "*";
                value = "0";
            }
            else {
                document.getElementById("spanstatus").innerHTML = "";

                if (status == "started") {
                    if (document.getElementById("ctl00_ContentPlaceHolder1_txtnewdate").value == "") {
                        document.getElementById("spanstdate").innerHTML = "*";
                        value = "0";
                    }
                    else {
                        document.getElementById("spanstdate").innerHTML = "";

                    }
                }
                else if (status == "process") {
                    if (document.getElementById("ctl00_ContentPlaceHolder1_txtcom").value == "") {
                        document.getElementById("spancomper").innerHTML = "*";
                        value = "0";
                    }
                    else {
                        document.getElementById("spancomper").innerHTML = "";
                    }
                }
                else if (status == "completed") {
                    if (document.getElementById("ctl00_ContentPlaceHolder1_txtcompletedate").value == "") {
                        document.getElementById("spancomdate").innerHTML = "*";
                        value = "0";
                    }
                    else {
                        document.getElementById("spancomdate").innerHTML = "";
                    }

                }
            }

            if (value == "0") {
                return false;
            }
            else {
                return true;
            }
        }
        function saveworkstatus() {
            if (validatestatus()) {
                var statusid = document.getElementById("hidstatusid").value;
                var status = document.getElementById('<%=ddlstaus.ClientID %>').value;
                var startdate = "", percentage = "", completedate = "";


                if (status == "Started") {
                    startdate = document.getElementById('<%=txtnewdate.ClientID %>').value;
                    percentage = "";
                    completedate = "";
                }
                else if (status == "Process") {
                    startdate = "";
                    percentage = document.getElementById('<%=txtcom.ClientID %>').value;
                    completedate = "";
                }
                else {
                    startdate = "";
                    percentage = "100";
                    completedate = document.getElementById('<%=txtcompletedate.ClientID %>').value;
                }

            $('#btnsavestatus').hide();
            $('#statuswaitimg').show();

            var args = { statusid: statusid, status: status, startdate: startdate, percentage: percentage, enddate: completedate };




            $.ajax
        ({

            type: "POST",
            url: "ProjectAllocation_new.aspx/savestatus",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            cache: false,
            success: function (msg) {

                if (msg.d != "failure") {
                    var nid = document.getElementById("hidstatusid").value;
                    var status = document.getElementById('<%=ddlstaus.ClientID %>').value;

                    if (parseFloat(msg.d) == 100) {
                        document.getElementById(spanid).innerHTML = "100% Completed";
                    }
                    else {
                        document.getElementById(spanid).innerHTML = msg.d + '% Completed (<a onclick="openstatusdiv(' + nid + ', ' + spanid + ');">Set Satus</a>)';

                    }

                    document.getElementById('ctl00_ContentPlaceHolder1_ddlstaus').selectedIndex = 0;
                    document.getElementById('ctl00_ContentPlaceHolder1_txtnewdate').value = "";
                    document.getElementById('ctl00_ContentPlaceHolder1_txtcom').value = "";
                    document.getElementById('ctl00_ContentPlaceHolder1_txtcompletedate').value = "";
                    closediv();
                    $('#btnsavestatus').show();
                    $('#statuswaitimg').hide();

                    alert("Saved Successfully");

                }
            },
            error: function (x, e) {
                alert("The call to the server side failed. " + x.responseText);
                $('#btnsavestatus').show();
                $('#statuswaitimg').hide();
            }


        });
    }
}
    </script>
    <script type="text/javascript">
        function closediv() {
            document.getElementById("divaddallocation").style.display = "none";
            document.getElementById("divstatus").style.display = "none";
            document.getElementById("otherdiv").style.display = "none";
        }


        //Open Set Status div
        function openstatusdiv(nid, spanid1) {
            reset();
            spanid = $(spanid1).attr("id");
            document.getElementById("hidstatusid").value = nid;
            setposition("divstatus");
            document.getElementById("divstatus").style.display = "block";
            document.getElementById("otherdiv").style.display = "block";
        }

        function assigntask(type, nid, id, id2) {
            if (type == "A") {
                setposition("divaddallocation");
                document.getElementById("divaddallocation").style.display = "block";
                document.getElementById("otherdiv").style.display = "block";
                document.getElementById("assig_hid_nid").value = nid;
                document.getElementById("assig_hid_linkid").value = id;
                document.getElementById("assig_hid_divid").value = id2;
            }
            else {

                if (confirm('do you want to release this task?')) {


                    var args = {
                        struserid: document.getElementById('<%=allcation_empid.ClientID %>').value, strnid: nid
                    };

                    $.ajax({

                        type: "POST",
                        url: "ProjectAllocation_new.aspx/release_task",
                        data: JSON.stringify(args),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        async: true,
                        cache: false,
                        success: function (msg) {


                            if (msg.d != "failure") {

                                var result = msg.d;



                                document.getElementById(id2).innerHTML = "";
                                document.getElementById(id).innerHTML = "Assign";


                                var strval = $('#' + id).attr("onclick");
                                $('#' + id).removeAttr("onclick");

                                strval = strval.replace("R", "A");

                                $('#' + id).attr("onclick", strval);


                                alert("Saved Successfully");
                                closediv();
                            }
                        },
                        error: function (x, e) {
                            alert("The call to the server side failed. " + x.responseText);

                        }
                    });




                }
            }




        }

        function saveAssign() {



            var status = 1;
            var linkid = document.getElementById('assig_hid_linkid').value;
            var divid = document.getElementById('assig_hid_divid').value;

            if (document.getElementById('<%=txtdate.ClientID %>').value == "") {
                $('#val_date').addClass("errmsg");
                status = 0;
            }
            else {
                $('#val_date').removeClass("errmsg");
            }
            if (document.getElementById('<%=droppopemployee.ClientID %>').value == "") {
                $('#val_emp').addClass("errmsg");
                status = 0;
            }
            else {
                $('#val_emp').removeClass("errmsg");
            }
            if (document.getElementById('<%=dropopmanager.ClientID %>').value == "") {
                $('#val_manager').addClass("errmsg");
                status = 0;
            }
            else {
                $('#val_manager').removeClass("errmsg");
            }

            if (status == 0 || document.getElementById("assig_hid_nid").value == "") {
                return false;
            }
            else {
                $('#btnsaveassign').hide();
                $('#assignwaitimg').show();
                var args = {
                    struserid: document.getElementById('<%=allcation_empid.ClientID %>').value, strnid: document.getElementById("assig_hid_nid").value, strempid: document.getElementById('<%=droppopemployee.ClientID %>').value,
                    strmanagerid: document.getElementById('<%=dropopmanager.ClientID %>').value, strdate: document.getElementById('<%=txtdate.ClientID %>').value
                };

                $.ajax({

                    type: "POST",
                    url: "ProjectAllocation_new.aspx/assign_task",
                    data: JSON.stringify(args),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: true,
                    cache: false,
                    success: function (msg) {


                        if (msg.d != "failure") {

                            var result = msg.d;

                            var arr = result.split("###");

                            document.getElementById(divid).innerHTML = "Assigned to <b>" + arr[0] + "</b> on <b>" + arr[1] + "</b>";
                            document.getElementById(linkid).innerHTML = "Release";
                            document.getElementById('assig_hid_linkid').value = "";
                            document.getElementById('assig_hid_divid').value = "";
                            document.getElementById('<%=txtdate.ClientID %>').value = "";

                            var strval = $('#' + linkid).attr("onclick");
                            $('#' + linkid).removeAttr("onclick");

                            strval = strval.replace("A", "R");

                            $('#' + linkid).attr("onclick", strval);

                            $('#btnsaveassign').show();
                            $('#assignwaitimg').hide();
                            alert("Saved Successfully");
                            closediv();
                        }
                    },
                    error: function (x, e) {
                        alert("The call to the server side failed. " + x.responseText);
                        $('#btnsaveassign').show();
                        $('#assignwaitimg').hide();
                    }
                });


            }

        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:UpdatePanel ID="updatepanelfull" runat="server">
        <ContentTemplate>
            <input type="hidden" id="allcation_empid" runat="server" />
            <pg:progress ID="progress1" runat="server" />
            <div class="clear">
            </div>
            <div class="pageheader">
                <h2>
                    <i class="fa fa-th"></i>Project Allocation
                </h2>
                <div class="clear">
                </div>
            </div>
            <div class="contentpanel">
                <div class="row">
                    <asp:UpdatePanel ID="updatepanel1" runat="server">
                        <ContentTemplate>
                            <div class="col-sm-4 col-md-3">
                                <div class="panel panel-default">
                                    <div class="panel-body">
                                        <h5 class="subtitle mb5">Projects</h5>
                                        <asp:DropDownList ID="dropproject" runat="server" CssClass="form-control" OnSelectedIndexChanged="dropproject_SelectedIndexChanged"
                                            AutoPostBack="true">
                                        </asp:DropDownList>
                                        <div class="clear">
                                        </div>
                                        <div class="nodatafound" id="divmsg" runat="server">
                                            No Module found
                                        </div>
                                        <div class="clear">
                                        </div>
                                        <div style="height: 320px; overflow-y: scroll;">
                                            <asp:TreeView ID="treemenu" runat="server" CssClass="treeview" Width="99%" ImageSet="Simple"
                                                OnSelectedNodeChanged="treeview_SelectedNodeChanged" ShowLines="True">
                                                <HoverNodeStyle CssClass="roothover" />
                                                <NodeStyle ImageUrl="images/black_folder.png" VerticalPadding="5" HorizontalPadding="5"
                                                    CssClass="nodestyle" />
                                                <ParentNodeStyle NodeSpacing="0px" />
                                                <SelectedNodeStyle CssClass="rootselected" />
                                                <RootNodeStyle CssClass="rootnode" ImageUrl="images/rootnode.png" VerticalPadding="5"
                                                    HorizontalPadding="5" />
                                            </asp:TreeView>
                                            <input id="hidnode" runat="server" type="hidden" />
                                            <input id="hidid" runat="server" type="hidden" />
                                            <input type="hidden" id="hidparent" runat="server" value="0" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    <div class="col-sm-8 col-md-9">
                        <div class="panel panel-default">
                            <div class="panel-body" style="min-height: 410px;">
                                <div class="row">
                                    <div class="col-sm-12 col-md-12">
                                        <div id="otherdiv" onclick="closediv();">
                                        </div>
                                        <div class="clear">
                                        </div>
                                        <asp:Repeater ID="rptinner" runat="server" OnItemCommand="rptinner_OnItemCommand"
                                            OnItemDataBound="rptinner_OnItemDataBound">
                                            <HeaderTemplate>
                                                <table class="tblReport" cellspacing="0">
                                                    <tr>

                                                        <th>Task</th>
                                                        <th>Parent</th>
                                                        <th>Est.Start Date</th>
                                                        <th>Est.End Date</th>
                                                        <th>Est.Hrs.</th>
                                                        <th>StartDate</th>
                                                        <th>EndDate</th>
                                                        <th>Hrs</th>
                                                        <th>Status</th>

                                                    </tr>
                                            </HeaderTemplate>
                                            <ItemTemplate>

                                                <td></td>
                                                <td></td>
                                                <td></td>
                                                <td></td>
                                                <td></td>
                                            </ItemTemplate>
                                            <FooterTemplate>
                                                </table>
                                            </FooterTemplate>
                                            <ItemTemplate>
                                                <div class="detailbox_label">
                                                    <div class="f_left">
                                                        <%#Eval("taskcodename")%>:<%#Eval("task")%>
                                                    </div>
                                                    <div class="f_right">
                                                        <span id="litassignto" runat="server"></span>&nbsp; &nbsp; (<a id="linkassign" runat="server">
                                                            Assign</a>)
                                                    </div>
                                                </div>
                                                <div class="clear">
                                                </div>
                                                <div class="detailbox">
                                                    <div class="detailbox_inner">
                                                        <div class="detailbox_row1">
                                                            <%#Eval("title")%>
                                                        </div>
                                                        <div class="detailbox_row3">
                                                            <%#Eval("description")%>
                                                        </div>
                                                        <div class="detailbox_row2">
                                                            <%#Eval("parentname")%>
                                                        </div>
                                                        <div class="detailbox_status">
                                                            Status: <span id="litstatus" runat="server"></span>
                                                        </div>
                                                    </div>
                                                    <table cellspacing="0" cellpadding="0" class="detailbox_table">
                                                        <tr>
                                                            <td>
                                                                <span>Est.Start Date </span>
                                                                <br />
                                                                <%#Eval("estStartdate")%>
                                                            </td>
                                                            <td>
                                                                <span>Est.End Date </span>
                                                                <br />
                                                                <%#Eval("estEndDate")%>
                                                            </td>
                                                            <td>
                                                                <span>Est.Hours </span>
                                                                <br />
                                                                <%#Eval("estHours")%>
                                                            </td>
                                                            <td>
                                                                <span>Start Date </span>
                                                                <br />
                                                                <%#Eval("projectstartdate")%>
                                                            </td>
                                                            <td>
                                                                <span>End Date </span>
                                                                <br />
                                                                <%#Eval("projectenddate")%>
                                                            </td>
                                                            <td>
                                                                <span>Time Taken </span>
                                                                <br />
                                                                <%#Eval("timetaken")%>
                                                            </td>
                                                            <td>
                                                                <span>Emp Status </span>
                                                                <br />
                                                                <%#Eval("empstatus")%>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                                <div class="clear">
                                                </div>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                        <input type="hidden" id="hidfrmdate" runat="server" />
                                        <input type="hidden" id="hidtodate" runat="server" />
                                        <input type="hidden" id="hiddrpemployee" runat="server" />
                                        <input type="hidden" id="hiddrpmaanger" runat="server" />
                                        <input type="hidden" id="hiddrpproject" runat="server" />
                                        <input type="hidden" id="hiddrptask" runat="server" />
                                        <input type="hidden" id="hidstatus" runat="server" />
                                        <div class="clear">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="clear">
                    </div>
                </div>
            </div>
            <!---ADD NEW Allocation goes here-->
            <div id="divaddallocation" class="itempopup" style="width: 550px;">
                <input type="hidden" id="assig_hid_nid" />
                <input type="hidden" id="assig_hid_linkid" />
                <input type="hidden" id="assig_hid_divid" />
                <div class="popup_heading">
                    <span id="Span1" runat="server">Assign Task to Employee</span>
                    <div class="f_right">
                        <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
                    </div>
                </div>
                <div class="tabContents">
                    <div class="col-xs-12 col-sm-12">
                        <div class="col-xs-12 col-sm-12 form-group clear f_left mar pad">
                            <label class="col-sm-2 control-label">
                                Assign Date: <span id="val_date">*</span>
                            </label>
                            <div class="col-xs-6 col-sm-6">

                                <asp:TextBox ID="txtdate" runat="server" CssClass="form-control hasDatepicker" placeholder="MM/dd/yyyy"></asp:TextBox>

                                <ajax:CalendarExtender ID="cc1" runat="server" TargetControlID="txtdate" PopupButtonID="txtdate"
                                    Format="MM/dd/yyyy">
                                </ajax:CalendarExtender>

                            </div>
                        </div>
                        <div class="col-xs-12 form-group f_left pad">
                            <label class="col-sm-2 control-label">
                                Employee: <span id="val_emp">*</span>
                            </label>
                            <div class="col-xs-6 col-sm-6">
                                <asp:DropDownList ID="droppopemployee" runat="server" CssClass="form-control">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-xs-12 form-group f_left pad">
                            <label class="col-sm-2 control-label">
                                Manager: <span id="val_manager">*</span>
                            </label>
                            <div class="col-xs-6 col-sm-6">
                                <asp:DropDownList ID="dropopmanager" runat="server" CssClass="form-control">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="clear padtop10">
                            <span id="assignwaitimg" class="waitimg">Please wait.. </span>
                            <input type="button" id="btnsaveassign" value="Save" class="btn btn-primary" onclick="saveAssign();" />
                        </div>
                    </div>
                </div>
            </div>
            <div id="divstatus" class="itempopup" style="width: 550px;">
                <input type="hidden" id="hidstatusid" />
                <input type="hidden" id="hidspanid" />
                <div class="popup_heading">
                    <span id="spanstatushead" runat="server">Set Task Status</span>
                    <div class="f_right">
                        <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
                    </div>
                </div>
                <div class="tabContents">
                    <div class="col-xs-12 col-sm-12">
                        <div class="col-xs-12 col-sm-12 form-group clear f_left mar pad">
                            <label class="col-sm-3 control-label">
                                Status:<span class="errmsg" id="spanstatus"></span>
                            </label>
                            <div class="col-xs-6 col-sm-6">
                                <asp:DropDownList ID="ddlstaus" runat="server" CssClass="form-control" onchange="check_dd();">
                                    <asp:ListItem Value="">--Select--</asp:ListItem>
                                    <asp:ListItem>Started</asp:ListItem>
                                    <asp:ListItem>Process</asp:ListItem>
                                    <asp:ListItem>Completed</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div id="divdate" class="col-xs-12 col-sm-12 form-group clear f_left mar pad hide">
                            <label class="col-sm-3 control-label">
                                Start Date:<span class="errmsg " id="spanstdate"></span>
                            </label>
                            <div class="col-xs-6 col-sm-6">

                                <asp:TextBox ID="txtnewdate" runat="server" CssClass="form-control"></asp:TextBox>

                                <ajax:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtnewdate"
                                    PopupButtonID="txtnewdate" Format="MM/dd/yyyy">
                                </ajax:CalendarExtender>

                            </div>
                        </div>
                        <div id="divpercentage" class="col-xs-12 col-sm-12 form-group clear f_left mar pad hide">
                            <label class="col-sm-3 control-label">
                                Running Status:<span class="errmsg" id="spancomper"></span>
                            </label>
                            <div class="col-xs-6 col-sm-6">
                                <asp:TextBox ID="txtcom" runat="server" CssClass="form-control" Style="float: left; padding-top: 10px;"
                                    onkeypress="blockNonNumbers(this, event, true, false);" onblur="extractNumber(this,2,false);"
                                    onkeyup="extractNumber(this,2,false);"></asp:TextBox>
                            </div>
                            <span style="padding-top: 10px; float: left;">%</span>
                        </div>
                        <div id="divcompletedate" class="col-xs-12 col-sm-12 form-group clear f_left mar pad hide">
                            <label class="col-sm-3 control-label">
                                Completion Date:<span class="errmsg " id="spancomdate"></span>
                            </label>
                            <div class="col-xs-6 col-sm-6">
                                <asp:TextBox ID="txtcompletedate" runat="server" CssClass="form-control hasDatepicker"></asp:TextBox>
                                <ajax:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtcompletedate"
                                    PopupButtonID="txtcompletedate" Format="MM/dd/yyyy">
                                </ajax:CalendarExtender>
                            </div>
                        </div>
                        <div class="clear">
                        </div>
                        <span id="statuswaitimg" class="waitimg">Please wait.. </span>
                        <input type="button" id="btnsavestatus" value="Save" class="btn btn-primary" onclick="saveworkstatus();" />
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

