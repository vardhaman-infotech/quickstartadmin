<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="ViewSchedule.aspx.cs" Inherits="empTimeSheet.ViewSchedule" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .style1
        {
            width: 132px;
        }
    </style>
    <script type="text/javascript">

        function move(btnaddmember, btnremove) {


            var arrFrom = new Array(); var arrTo = new Array();
            var arrLU = new Array();
            var i;
            for (i = 0; i < btnremove.options.length; i++) {
                arrLU[btnremove.options[i].text] = btnremove.options[i].value;
                arrTo[i] = btnremove.options[i].text;
            }

            var fLength = 0;
            var tLength = arrTo.length;
            for (i = 0; i < btnaddmember.options.length; i++) {
                arrLU[btnaddmember.options[i].text] = btnaddmember.options[i].value;
                if (btnaddmember.options[i].selected && btnaddmember.options[i].value != "") {
                    arrTo[tLength] = btnaddmember.options[i].text;
                    tLength++;
                }
                else {
                    arrFrom[fLength] = btnaddmember.options[i].text;
                    fLength++;
                }
            }

            btnaddmember.length = 0;
            btnremove.length = 0;
            var ii;
            for (ii = 0; ii < arrFrom.length; ii++) {
                var no = new Option();
                no.value = arrLU[arrFrom[ii]];
                no.text = arrFrom[ii];
                btnaddmember[ii] = no;
            }

            for (ii = 0; ii < arrTo.length; ii++) {
                var no = new Option();
                no.value = arrLU[arrTo[ii]];
                no.text = arrTo[ii];
                btnremove[ii] = no;
            }
            var strval = "";
            var tolistbox = document.getElementById('ctl00_ContentPlaceHolder1_listcode2');
            if (tolistbox.options.length > 0) {
                for (k = 0; k < tolistbox.options.length; k++) {

                    strval += tolistbox.options[k].value + ',';

                }

            }

            document.getElementById('ctl00_ContentPlaceHolder1_hidexpense').value = strval;
            sortlist();
        }

     
    </script>
    <script type="text/javascript">
        function sortlist() {
            var lb = document.getElementById('ctl00_ContentPlaceHolder1_listcode1');
            arrTexts = new Array();

            for (i = 0; i < lb.length; i++) {
                arrTexts[i] = lb.options[i].text;
            }

            arrTexts.sort();

            for (i = 0; i < lb.length; i++) {
                lb.options[i].text = arrTexts[i];
                lb.options[i].value = arrTexts[i];
            }
        }
    </script>
    <script type="text/javascript">
        function scrolltotopofList() {
            var divPosition = $('#ctl00_ContentPlaceHolder1_dgnews').offset();
            $('html, body').animate({ scrollTop: divPosition.top }, "fast");
        }
    </script>
    <script type="text/javascript">
        function validate1(source, args) {

            var tolistbox1 = document.getElementById('ctl00_ContentPlaceHolder1_listcode2');

            var numofelemadded = tolistbox1.options.length;
            if (numofelemadded > 0) {
                args.IsValid = true;
            }
            else {

                args.IsValid = false;
            }
            return;
        }
    </script>
    <script type="text/javascript">
        function validate2(source, args) {


            var status = 0;
            if (document.getElementById("ctl00_ContentPlaceHolder1_ddlstaus").value == "Re-Schedule") {
                if (document.getElementById("ctl00_ContentPlaceHolder1_txtnewdate").value == "")

                    status = 1;

            }

            if (status == 0) {
                args.IsValid = true;
            }
            else {

                args.IsValid = false;
            }
            return;
        }
    </script>
    <script type="text/javascript">


        function closediv1() {
            document.getElementById("divstatus").style.display = "none";
            document.getElementById("otherdiv").style.display = "none";
        }
        //Open Set Status div
        function openstatusdiv() {
            setposition("divstatus");
            document.getElementById("divstatus").style.display = "block";
            document.getElementById("otherdiv").style.display = "block";
        }

        //Open add/edit div
        function opendiv() {
            setposition("divaddnew");
            document.getElementById("divaddnew").style.display = "block";
            document.getElementById("otherdiv").style.display = "block";
        }
        function closediv() {

            document.getElementById("divaddnew").style.display = "none";
            document.getElementById("otherdiv").style.display = "none";
            document.getElementById("divstatusmsg").style.display = "none";
            document.getElementById("divnonschedule").style.display = "none";
        }

        function showdate(val) {
            if (val == "Re-Schedule") {
                document.getElementById("divdate").style.display = "block";
            }
            else {
                document.getElementById("divdate").style.display = "none";
            }
        }


        function closealert() {
            document.getElementById("divstatusmsg").style.display = "none";
            document.getElementById("otherdiv").style.display = "none";
            opendiv();
        }
        //Open Alert div to Show Existing Schedules of clients
        function openalert() {
            setposition("divstatusmsg");

            document.getElementById("divstatusmsg").style.display = "block";
            document.getElementById("otherdiv").style.display = "block";
        }
    </script>
    <script type="text/javascript">
        function opennonscedulediv() {
            setposition("divnonschedule");
            document.getElementById("divnonschedule").style.display = "block";
            document.getElementById("otherdiv").style.display = "block";
        }
        function closenonscedulediv() {

            document.getElementById("divnonschedule").style.display = "none";
            document.getElementById("otherdiv").style.display = "none";
        } 
    </script>
    <script type="text/javascript">
        function showhidestatus() {
            if (document.getElementById("ctl00_ContentPlaceHolder1_rdbtnscheduleType_0").checked == true) {
                document.getElementById("divschedulestatus").style.display = "block";
                document.getElementById("divaddremark").style.display = "none";

            }
            else if (document.getElementById("ctl00_ContentPlaceHolder1_rdbtnscheduleType_1").checked == true) {
                document.getElementById("divschedulestatus").style.display = "none";
                document.getElementById("divaddremark").style.display = "block";

            }
            else {
                document.getElementById("divschedulestatus").style.display = "block";
                document.getElementById("divaddremark").style.display = "none";
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:UpdatePanel ID="upadatepanel" runat="server">
        <ContentTemplate>
            <pg:progress ID="progress1" runat="server" />
            <div id="otherdiv" onclick="closediv();">
            </div>
            <div class="heading">
                <h1>
                    Schedule
                </h1>
                <input type="hidden" id="hidid" runat="server" />
                <div class="f_right">
                    <%-- <asp:LinkButton ID="liaddnew" runat="server" CssClass="add_new" OnClick="liaddnew_Click">--%>
                    <a onclick="opendiv();" id="liaddnew" runat="server" class="add_new">
                        <img src="images/add.png" alt="add new">
                        New Schedule</a>
                    <asp:LinkButton ID="linknonscemp" runat="server" CssClass="add_new" OnClick="linknonscemp_Click"><img src="images/notshed.png" alt="add new" />Non-Scheduled Employee</asp:LinkButton>
                    <asp:LinkButton ID="btnexportcsv" runat="server" OnClick="btnexportcsv_Click" CssClass="add_new"><img src="images/excel.png" alt="add new" />Export to Excel</asp:LinkButton>
                    <asp:LinkButton ID="lnkrefresh" runat="server" OnClick="btnrefresh_Click" CssClass="add_new"><img src="images/refresh.png" alt="add new" />Refresh</asp:LinkButton>
                </div>
            </div>
            <div class="clear">
            </div>
            <div class="left_inner">
                <div class="">
                    <asp:TextBox ID="txtfrmdate" runat="server" CssClass="form_2_input3 date"></asp:TextBox>
                    <cc1:CalendarExtender ID="txtDate_CalendarExtender" runat="server" TargetControlID="txtfrmdate"
                        PopupButtonID="txtfrmdate" Format="MM/dd/yyyy">
                    </cc1:CalendarExtender>
                    <asp:TextBox ID="txttodate" runat="server" CssClass="form_2_input3 date"></asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txttodate"
                        PopupButtonID="txttodate" Format="MM/dd/yyyy">
                    </cc1:CalendarExtender>
                    <div class="clear">
                    </div>
                    <asp:DropDownList ID="drpclient" runat="server" CssClass="form_2_input5" AutoPostBack="true"
                        OnSelectedIndexChanged="drpclient_OnSelectedIndexChanged">
                    </asp:DropDownList>
                    <asp:DropDownList ID="dropproject" runat="server" CssClass="form_2_input5">
                    </asp:DropDownList>
                    <asp:DropDownList ID="drpemployee" runat="server" CssClass="form_2_input5">
                    </asp:DropDownList>
                    <asp:DropDownList ID="dropstatus" runat="server" CssClass="form_2_input5">
                        <asp:ListItem Value="">--All Status--</asp:ListItem>
                        <asp:ListItem>Confirmed by the Client</asp:ListItem>
                        <asp:ListItem>Non-Confirmed by the Client</asp:ListItem>
                        <asp:ListItem>All Reservations Made</asp:ListItem>
                        <asp:ListItem>Re-Schedule</asp:ListItem>
                        <asp:ListItem>Cancelled</asp:ListItem>
                    </asp:DropDownList>
                    <div class="clear">
                    </div>
                    <div style="margin-left: 3px">
                        <asp:Button ID="btnsearch" runat="server" CssClass="button" Text="View Report" OnClick="btnsearch_click" />
                    </div>
                </div>
            </div>
            <div class="right_inner">
                <div>
                    <div class="f_right" style="padding-top: 10px;">
                        <span class="f_left">
                            <asp:LinkButton ID="lnkprevious" runat="server" OnClick="lnkprevious_Click"> <img src="images/arrow_left.png" alt="arrow" /></asp:LinkButton>
                        </span>
                        <p class="f_left page">
                            <asp:Label ID="lblstart" runat="server"></asp:Label>
                            -
                            <asp:Label ID="lblend" runat="server"></asp:Label>
                            of <strong>
                                <asp:Label ID="lbltotalrecord" Font-Bold="true" runat="server"></asp:Label></strong>
                        </p>
                        <span class="f_left">
                            <asp:LinkButton ID="lnknext" runat="server" OnClick="lnknext_Click">  <img src="images/arrow_right.png" alt="arrow" /></asp:LinkButton>
                        </span>
                    </div>
                    <div class="clear">
                    </div>
                    <div class="clear">
                    </div>
                    <div class="nodatafound" id="divnodata" runat="server">
                        No data found</div>
                    <asp:GridView ID="dgnews" runat="server" AllowPaging="true" AutoGenerateColumns="False"
                        PageSize="50" CellPadding="4" CellSpacing="0" Width="100%" ShowHeader="true"
                        ShowFooter="false" CssClass="tblsheet" GridLines="None" AllowSorting="true" OnRowDataBound="dgnews_RowDataBound"
                        OnSorting="dgnews_Sorting" OnRowCommand="dgnews_RowCommand" OnPageIndexChanging="dgnews_PageIndexChanging">
                        <Columns>
                            <asp:TemplateField HeaderText="S. No." ItemStyle-Width="45px">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex + 1 %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Date/Time" SortExpression="date">
                                <ItemTemplate>
                                    <%#DataBinder.Eval(Container.DataItem,"date")%>
                                    <%#DataBinder.Eval(Container.DataItem,"time")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Employee" SortExpression="empname">
                                <ItemTemplate>
                                    <%#DataBinder.Eval(Container.DataItem,"empname")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Client" SortExpression="clientname">
                                <ItemTemplate>
                                    <%#DataBinder.Eval(Container.DataItem,"clientname")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Project" SortExpression="projectname">
                                <ItemTemplate>
                                    <%#DataBinder.Eval(Container.DataItem,"projectname")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Type" SortExpression="scheduletype">
                                <ItemTemplate>
                                    <%#DataBinder.Eval(Container.DataItem, "scheduletype")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Status" ItemStyle-Width="140px">
                                <ItemTemplate>
                                    <%#DataBinder.Eval(Container.DataItem,"status")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Remark">
                                <ItemTemplate>
                                    <%#DataBinder.Eval(Container.DataItem,"remark")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="" ItemStyle-Width="80px">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbtnstatus" runat="server" Visible="true" CommandArgument='<%#Eval("nid")%>'
                                        CommandName="SetStatus">Set Status</asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField ItemStyle-Width="20px" ItemStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbtndelete" CommandName="del" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>'
                                        ToolTip="Delete" runat="server" OnClientClick='return confirm("Delete this record? Yes or No");'><img src="images/delete_red.png" alt="Delete" /></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <HeaderStyle CssClass="gridheader" />
                        <PagerStyle CssClass="gridpager" HorizontalAlign="Center" />
                    </asp:GridView>
                </div>
                <%--   <!-- HIDDEN div for export to Excel goes here-->
                <div id="divreport" runat="server" style="display: none; margin: 5px;">
                    <asp:Literal ID="ltrreport" runat="server"></asp:Literal>
                    <asp:Repeater ID="rptreport" runat="server">
                        <HeaderTemplate>
                            <table cellspacing="0" cellpadding="4" border="1" style="width: 98%;" class="tblsheet">
                                <tbody>
                                    <tr class="gridheader">
                                        <td width="10%">
                                            Date/Time
                                        </td>
                                        <td width="10%">
                                            Employee
                                        </td>
                                        <td width="15%">
                                            Client
                                        </td>
                                        <td width="15%">
                                            Project ID
                                        </td>
                                        <td width="10%">
                                            Schedule Type
                                        </td>
                                        <td width="10%">
                                            Status
                                        </td>
                                        <td width="20%">
                                            Remark
                                        </td>
                                        <td width="10%">
                                            Last Modified By
                                        </td>
                                    </tr>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr class="odd">
                                <td width="10%">
                                    <%#Eval("date")%>
                                    <%#Eval("time")%>
                                </td>
                                <td width="10%">
                                    <%#Eval("empname")%>
                                </td>
                                <td width="15%">
                                    <%#Eval("clientname")%>
                                </td>
                                <td width="15%">
                                    <%#Eval("projectCode")%>
                                </td>
                                <td width="10%">
                                    <%#Eval("scheduletype")%>
                                </td>
                                <td width="10%">
                                    <%#Eval("status")%>
                                </td>
                                <td width="20%">
                                    <%#Eval("remark")%>
                                </td>
                                <td width="10%">
                                    <%#Eval("username")%>
                                </td>
                            </tr>
                        </ItemTemplate>
                        <AlternatingItemTemplate>
                            <tr class="even">
                                <td width="10%">
                                    <%#Eval("date")%>
                                    <%#Eval("time")%>
                                </td>
                                <td width="25%">
                                    <%#Eval("empname")%>
                                </td>
                                <td width="25%">
                                    <%#Eval("clientname")%>
                                </td>
                                <td width="10%">
                                    <%#Eval("status")%>
                                </td>
                                <td width="20%">
                                    <%#Eval("remark")%>
                                </td>
                                <td width="10%">
                                    <%#Eval("username")%>
                                </td>
                            </tr>
                        </AlternatingItemTemplate>
                        <FooterTemplate>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>
                </div>--%>
                <!--Status Div goes here-->
                <div id="divstatus" class="itempopup" style="width: 550px;">
                    <div class="popup_heading">
                        <span id="Span1" runat="server">Edit Status</span>
                        <div class="f_right">
                            <img src="images/cross.png" onclick="closediv1();" alt="X" title="Close Window" />
                        </div>
                    </div>
                    <div class="innerpopup">
                        <div class="f_left">
                            <b>Date:
                                <asp:Literal ID="ltrdate" runat="server"></asp:Literal></b></div>
                        <div class="f_right">
                            <b>Employee:
                                <asp:Literal ID="ltrempname" runat="server"></asp:Literal></b></div>
                        <div class="clear">
                        </div>
                        <div class="f_left padtop10">
                            <b>Client:
                                <asp:Literal ID="ltrclient" runat="server"></asp:Literal></b></div>
                        <div class="clear">
                        </div>
                        <div class="line">
                        </div>
                        <label class="f_left">
                            Status:
                        </label>
                        <div class="f_left">
                            <asp:DropDownList ID="ddlstaus" runat="server" CssClass="popinputsmall " onchange="showdate(this.value);">
                                <asp:ListItem Value="Confirmed by the Client">Confirmed by the Client</asp:ListItem>
                                <asp:ListItem Value="Non-Confirmed by the Client">Non-Confirmed by the Client</asp:ListItem>
                                <asp:ListItem Value="All Reservations Made">All Reservations Made</asp:ListItem>
                                <asp:ListItem Value="Re-Schedule">Re-Schedule</asp:ListItem>
                                <asp:ListItem Value="Cancelled">Cancelled</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="clear">
                        </div>
                        <div id="divdate" style="display: none;">
                            <label>
                                New Date:
                                <asp:CustomValidator ID="CustomValidator2" runat="server" ErrorMessage="*" ValidationGroup="savestatus"
                                    CssClass="errmsg" ClientValidationFunction="validate2"></asp:CustomValidator>
                            </label>
                            <asp:TextBox ID="txtnewdate" runat="server" CssClass="popinputsmall date"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtnewdate"
                                PopupButtonID="txtnewdate" Format="MM/dd/yyyy">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="clear">
                        </div>
                        <label>
                            Remark:
                        </label>
                        <asp:TextBox ID="txtremark" runat="server" TextMode="MultiLine" Style="height: 80px;
                            width: 350px;" CssClass="popinput"></asp:TextBox>
                        <div class="clear">
                        </div>
                        <div class="padtop10">
                            <asp:Button ID="btnsave" runat="server" Text="Save" ValidationGroup="savestatus"
                                CssClass="button" OnClick="btnsave_Click" />
                        </div>
                    </div>
                </div>
                <!---Add New div goes here-->
                <div style="width: 840px;" id="divaddnew" class="itempopup">
                    <div class="popup_heading">
                        <span id="legendaction" runat="server">Schedule Employee</span>
                        <div class="f_right">
                            <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
                        </div>
                    </div>
                    <div class="form_2">
                        <label>
                            From Date :<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                                ControlToValidate="txtpopfrdate" ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator>
                        </label>
                        <asp:TextBox ID="txtpopfrdate" runat="server" CssClass="form_2_input3 date"></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtpopfrdate"
                            PopupButtonID="txtpopfrdate" Format="MM/dd/yyyy">
                        </cc1:CalendarExtender>
                        <label class="pad1">
                            To Date :<asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                                ControlToValidate="txtpoptodate" ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator>
                        </label>
                        <asp:TextBox ID="txtpoptodate" runat="server" CssClass="form_2_input3 date"></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtpoptodate"
                            PopupButtonID="txtpoptodate" Format="MM/dd/yyyy">
                        </cc1:CalendarExtender>
                        <div class="clear">
                        </div>
                        <label>
                            Client :<asp:RequiredFieldValidator ID="req1" runat="server" ControlToValidate="drppopclient"
                                ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator>
                        </label>
                        <asp:DropDownList ID="drppopclient" runat="server" CssClass="form_2_input5" AutoPostBack="true"
                            OnSelectedIndexChanged="drppopclient_SelectedIndexChanged" OnDataBound="drppopclient_DataBound">
                        </asp:DropDownList>
                        <label class="pad1">
                            Project:
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="ddlproject"
                                ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator></label>
                        <asp:DropDownList ID="ddlproject" runat="server" CssClass="form_2_input5">
                        </asp:DropDownList>
                        <label>
                            Time:
                        </label>
                        <div class="f_left">
                            <asp:DropDownList ID="drppophour" Width="190px" runat="server" CssClass="form_2_input5">
                            </asp:DropDownList>
                            <asp:DropDownList ID="drppopmin" runat="server" Width="60px" CssClass="form_2_input5">
                                <asp:ListItem Value="">---- </asp:ListItem>
                                <asp:ListItem Value="AM">AM</asp:ListItem>
                                <asp:ListItem Value="PM">PM</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <label class="pad1">
                            Schedule Type:
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="rdbtnscheduleType"
                                ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator>
                        </label>
                        <asp:RadioButtonList ID="rdbtnscheduleType" onchange="showhidestatus();" runat="server"
                            RepeatDirection="Horizontal" CssClass="checkboxauto">
                            <asp:ListItem Value="Field">Field Work</asp:ListItem>
                            <asp:ListItem Value="Office">Office Work</asp:ListItem>
                        </asp:RadioButtonList>
                        <div class="clear">
                        </div>
                        <div id="divschedulestatus">
                            <label>
                                Status :
                            </label>
                            <asp:DropDownList ID="drppopstatus" runat="server" CssClass="form_2_input5">
                                <asp:ListItem>Confirmed by the Client</asp:ListItem>
                                <asp:ListItem>Non-Confirmed by the Client</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div id="divaddremark" style="display: none;">
                            <label>
                                Remark :
                            </label>
                            <asp:TextBox ID="txtaddremark" runat="server" MaxLength="1000" TextMode="MultiLine"
                                CssClass="form_2_input" Style="float: left;">
                            </asp:TextBox>
                        </div>
                        <div class="clear">
                        </div>
                        <label>
                            Employee:
                            <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="*" ValidationGroup="save"
                                CssClass="errmsg" ClientValidationFunction="validate1"></asp:CustomValidator>
                        </label>
                        <div class="f_left">
                            <asp:ListBox ID="listcode1" runat="server" Width="260px" Height="200px" SelectionMode="Multiple"
                                CssClass="RadListBox1"></asp:ListBox>
                        </div>
                        <div class="f_left" style="padding: 43px; text-align: center;">
                            <div class="f_left">
                                <input type="button" onclick="move(this.form.ctl00_ContentPlaceHolder1_listcode1,this.form.ctl00_ContentPlaceHolder1_listcode2)"
                                    class="btnadd" value="Add" id="Button1">
                            </div>
                            <div class="clear">
                            </div>
                            <div class="f_left padtop10">
                                <input type="button" onclick="move(this.form.ctl00_ContentPlaceHolder1_listcode2,this.form.ctl00_ContentPlaceHolder1_listcode1)"
                                    class="btnadd" value="Remove" id="Button2">
                            </div>
                        </div>
                        <div class="f_left">
                            <asp:ListBox ID="listcode2" runat="server" Width="260px" Height="200px" SelectionMode="Multiple"
                                CssClass="listcode2"></asp:ListBox>
                        </div>
                        <div class="clear">
                        </div>
                    </div>
                    <div class="clear">
                    </div>
                    <div style="margin-left: 139px">
                        <asp:Button ID="btnsubmit" runat="server" CssClass="button" Text="Save" ValidationGroup="save"
                            OnClick="btnsubmit_Click" />
                    </div>
                    <input type="hidden" id="hidexpense" runat="server" />
                    <input type="hidden" id="hidstatus" runat="server" />
                    <input type="hidden" id="hidclientid" runat="server" />
                    <input type="hidden" id="hidprjectid" runat="server" />
                    <input type="hidden" id="hidempid" runat="server" />
                </div>
                <div style="width: 640px;" id="divstatusmsg" class="itempopup">
                    <div class="popup_heading">
                        <span id="Span2" runat="server">Schedule Status</span>
                        <%--<div class="f_right">
                            <img src="images/cross.png" onclick="closealert();" alt="X" title="Close Window" />
                        </div>--%>
                    </div>
                    <div style="padding: 10px;">
                        <div style="max-height: 350px; oveflow-y: auto;">
                            <asp:Label ID="lblerr" runat="server" CssClass="errmsg"></asp:Label>
                        </div>
                        <div class="padtop10">
                            Click <strong>Continue </strong>to save it anyway or <strong>Cancel </strong>to
                            stop Schedule.</div>
                        <div class="padtop10">
                            <asp:Button ID="btncontinue" runat="server" CssClass="button" Text="Continue" OnClick="btncontinue_Click" />
                            <input type="button" id="btncancelalert" class="button" value="Cancel" onclick="closealert();" />
                        </div>
                    </div>
                </div>
                <!--Non Schedule DIV goes here-->
                <div style="width: 640px;" id="divnonschedule" class="itempopup">
                    <div class="popup_heading">
                        <span id="Span3" runat="server">Non-Scheduled Employees List</span>
                        <div class="f_right">
                            <img src="images/cross.png" onclick="closenonscedulediv();" alt="X" title="Close Window" />
                        </div>
                    </div>
                    <div id="divsearchparam" class="padtop10" style="font-weight: bold; padding-left: 12px;
                        padding-bottom: 10px;">
                        Non-Scheduled Employees for Date:
                        <asp:Literal ID="ltrsearchparam" runat="server"></asp:Literal><br />
                    </div>
                    <div class="clear">
                    </div>
                    <div style="padding: 10px; max-height: 350px; overflow-y: auto;">
                        <div class="nodatafound" id="divnoschedulefound" runat="server" visible="false">
                            No data found</div>
                        <asp:Repeater ID="rptday" runat="server" OnItemDataBound="rptday_ItemDataBound">
                            <HeaderTemplate>
                                <table width="99%" cellpadding="4" cellspacing="0" class="tblsheet">
                                    <tr align="left">
                                        <th style="border-top: 1px solid #cccccc;">
                                            Date
                                        </th>
                                        <th style="border-top: 1px solid #cccccc;">
                                            Employee
                                        </th>
                                    </tr>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td valign="top" width="120px">
                                        <b>
                                            <%#Eval("date")%></b>
                                    </td>
                                    <td>
                                        <asp:Repeater ID="rptinner" runat="server">
                                            <ItemTemplate>
                                                <div style="padding-bottom: 5px;">
                                                    <%#Eval("fname")%>
                                                    <%#Eval("lname")%>
                                                </div>
                                                <div style="clear: both;">
                                                </div>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                        <asp:Literal ID="ltrinnermsg" runat="server"></asp:Literal>
                                    </td>
                            </ItemTemplate>
                            <FooterTemplate>
                                </table>
                            </FooterTemplate>
                        </asp:Repeater>
                    </div>
                </div>
                <input type="hidden" id="hidsearchfromdate" runat="server" />
                <input type="hidden" id="hidsearchtodate" runat="server" />
                <input type="hidden" id="hidsearchdrpclient" runat="server" />
                <input type="hidden" id="hidsearchdrpproject" runat="server" />
                <input type="hidden" id="hidsearchdroemployee" runat="server" />
                <input type="hidden" id="hidsearchdrpstatus" runat="server" />
                <input type="hidden" id="hidsearchdrpclientname" runat="server" />
                <input type="hidden" id="hidsearchdrpprojectname" runat="server" />
                <input type="hidden" id="hidsearchdroemployeename" runat="server" />
                <input type="hidden" id="hidsearchdrpstatusname" runat="server" />
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnexportcsv" />
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>
