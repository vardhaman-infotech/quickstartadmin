<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="LeaveRequest.aspx.cs" Inherits="empTimeSheet.LeaveRequest" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .itempopup h4 {
            color: #1caf9a;
        }
    </style>
    <link rel="stylesheet" href="css/jquery.dataTables.min.css" />

    <script src="js/jquery.min.js"></script>

    <script type="text/javascript" src="js/jquery.dataTables.min.js"></script>
    <script type="text/javascript">
        function fixheader() {

            $('#ctl00_ContentPlaceHolder1_dgnews').dataTable({
                "dom": 'lrtip',
                "pageLength": 50,
                'aoColumnDefs': [{
                    'bSortable': false,
                    'aTargets': [-1] /* 1st one, start by the right */
                }]
            });



        }
        function closediv() {

            document.getElementById("<%=divaddnew.ClientID %>").style.display = "none";
            document.getElementById("divstatus").style.display = "none";
            document.getElementById("otherdiv").style.display = "none";
        }

        function opendiv() {
            setposition("<%=divaddnew.ClientID %>");
            document.getElementById("<%=divaddnew.ClientID %>").style.display = "block";
            document.getElementById("otherdiv").style.display = "block";
        }
        function openstatusdiv() {
            setposition("divstatus");
            document.getElementById("divstatus").style.display = "block";
            document.getElementById("otherdiv").style.display = "block";
        }
        function reset() {
            document.getElementById("ctl00_ContentPlaceHolder1_hidid").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtnoofdays").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_ddlleavetype").SelectedIndex = 0;
            document.getElementById("ctl00_ContentPlaceHolder1_txtdescription").value = "";

        }
        function getlastdate() {
            var todate = new Date();
            var fromdate = document.getElementById("ctl00_ContentPlaceHolder1_txtleavedate").value;
            var numofdays = document.getElementById("ctl00_ContentPlaceHolder1_txtnoofdays").value;
            var newdate = new Date(fromdate);
            if (fromdate != "" && numofdays != "") {
                numofdays = parseInt(numofdays) - 1;
                todate.setDate(newdate.getDate() + parseInt(numofdays));
                var LeaveToDate = getFormattedDate(todate);

                document.getElementById("ctl00_ContentPlaceHolder1_divtodate").style.display = "block";
                if (fromdate == LeaveToDate) {
                    document.getElementById("ctl00_ContentPlaceHolder1_divtodate").innerHTML = "You are requesting leave for <b>" + fromdate + "</b>";

                }
                else {
                    document.getElementById("ctl00_ContentPlaceHolder1_divtodate").innerHTML = "You are requesting leave from <b>" + fromdate + "</b> to <b>" + LeaveToDate + "</b>";
                }
                document.getElementById("ctl00_ContentPlaceHolder1_hidtodate").value = LeaveToDate;

            }
            else {
                document.getElementById("ctl00_ContentPlaceHolder1_divtodate").style.display = "none";
            }


        }
        function getFormattedDate(date) {
            var year = date.getFullYear();
            var month = (1 + date.getMonth()).toString();
            month = month.length > 1 ? month : '0' + month;
            var day = date.getDate().toString();
            day = day.length > 1 ? day : '0' + day;
            return month + '/' + day + '/' + year;
        }

        function checkleavetype(leavetype) {

            var t = document.getElementById("ctl00_ContentPlaceHolder1_ddlleavetype");
            var selectedText = t.options[t.selectedIndex].text;
            document.getElementById("ctl00_ContentPlaceHolder1_txtnoofdays").value = "";
            if (selectedText.indexOf("Half") > -1) {
                //Hide Num of Days DIV
                document.getElementById("ctl00_ContentPlaceHolder1_divnumofdays").style.display = "none";
                //Reset value of Num of Days textbox
                document.getElementById("ctl00_ContentPlaceHolder1_txtnoofdays").value = "";
                //Hide selected dates description div
                document.getElementById("ctl00_ContentPlaceHolder1_divtodate").innerHTML = "";
                document.getElementById("ctl00_ContentPlaceHolder1_divtodate").style.display = "none";

            }
            else {
                //SHOW Num of Days DIV
                document.getElementById("ctl00_ContentPlaceHolder1_divnumofdays").style.display = "block";

            }

        }

    </script>
    <script type="text/javascript">
        function validate1(source, args) {

            var t = document.getElementById("ctl00_ContentPlaceHolder1_ddlleavetype");
            var selectedText = t.options[t.selectedIndex].text;
            var numofdays = document.getElementById("ctl00_ContentPlaceHolder1_txtnoofdays").value;
            if (!(selectedText.indexOf("Half") > -1) && numofdays == "") {

                args.IsValid = false;
            }
            else {

                if (selectedText.indexOf("Paid Leave") > -1) {

                    if (parseFloat(document.getElementById("ctl00_ContentPlaceHolder1_txtnoofdays").value) > (parseFloat(document.getElementById("ctl00_ContentPlaceHolder1_hidaccleave").value))) {
                        alert("You can't enter more paid leave then accrued Paid Leave ");
                        {
                            document.getElementById("ctl00_ContentPlaceHolder1_txtnoofdays").value = document.getElementById("ctl00_ContentPlaceHolder1_hidaccleave").value;
                        }

                    }
                }

                args.IsValid = true;
            }
            return;
        }
        function resetleave() {
            document.getElementById("ctl00_ContentPlaceHolder1_txtnoofdays").value = "";
        }
        function getLeaveToDate() {

            var t = document.getElementById("ctl00_ContentPlaceHolder1_ddlleavetype");
            var selectedText = t.options[t.selectedIndex].text;
            if (selectedText.indexOf("Paid Leave") > -1) {
                if (document.getElementById("ctl00_ContentPlaceHolder1_txtnoofdays").value != "") {
                    if (parseFloat(document.getElementById("ctl00_ContentPlaceHolder1_txtnoofdays").value) > (parseFloat(document.getElementById("ctl00_ContentPlaceHolder1_hidaccleave").value))) {
                        alert("You can't enter more paid leave then accrued Paid Leave ");
                        {
                            document.getElementById("ctl00_ContentPlaceHolder1_txtnoofdays").value = parseInt(document.getElementById("ctl00_ContentPlaceHolder1_hidaccleave").value);
                        }

                    }
                }
            }

            var fromdate = document.getElementById("ctl00_ContentPlaceHolder1_txtleavedate").value;
            var numofdays = document.getElementById("ctl00_ContentPlaceHolder1_txtnoofdays").value;
            if (parseFloat(numofdays) == 0) {
                alert("0 is not allowed.");
                document.getElementById("ctl00_ContentPlaceHolder1_txtnoofdays").value = "";
                return false;
            }
            var leavetype = document.getElementById("ctl00_ContentPlaceHolder1_ddlleavetype").value;
            var cYear, lYear;
            var empid = document.getElementById("hidloginid").value;
            if (leavetype != "") {
                if (fromdate != "" && numofdays != "") {

                    var args = { LeaveDate: fromdate, NumOfDays: numofdays, empid: empid };

                    $.ajax({

                        type: "POST",
                        url: "LeaveRequest.aspx/getLeaveToDate",
                        data: JSON.stringify(args),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        async: true,
                        cache: false,
                        success: function (msg) {
                            if (msg.d != "fail") {
                                cYear = (new Date(fromdate)).getYear();
                                lYear = (new Date(msg.d)).getYear();
                                if (cYear == lYear) {

                                    document.getElementById("ctl00_ContentPlaceHolder1_divtodate").style.display = "block";
                                    document.getElementById("ctl00_ContentPlaceHolder1_divtodate").innerHTML = "You are requesting leave from <b>" + fromdate + "</b> to <b>" + msg.d + "</b>";;
                                    document.getElementById("ctl00_ContentPlaceHolder1_hidtodate").value = msg.d;
                                }
                                else {
                                    document.getElementById("ctl00_ContentPlaceHolder1_txtnoofdays").value = "";
                                    document.getElementById("ctl00_ContentPlaceHolder1_hidtodate").value = "";
                                    document.getElementById("ctl00_ContentPlaceHolder1_divtodate").style.display = "none";
                                    alert("You can request only for current year");
                                }
                            }
                            else {
                                document.getElementById("ctl00_ContentPlaceHolder1_txtnoofdays").value = "";
                                document.getElementById("ctl00_ContentPlaceHolder1_hidtodate").value = "";
                                document.getElementById("ctl00_ContentPlaceHolder1_divtodate").style.display = "none";
                                alert("The date you have selected is not a working day, please select another date");
                            }
                        },
                        error: function (x, e) {
                            alert("The call to the server side failed. " + x.responseText);

                        }


                    });
                }
                else {
                    document.getElementById("ctl00_ContentPlaceHolder1_divtodate").innerHTML = "";
                    document.getElementById("ctl00_ContentPlaceHolder1_divtodate").style.display = "none";
                }
            }
            else {
                document.getElementById("ctl00_ContentPlaceHolder1_divtodate").innerHTML = "";
                document.getElementById("ctl00_ContentPlaceHolder1_divtodate").style.display = "none";
                alert("Please select a Leave Type first");
            }

        }
    </script>
    <style type="text/css">
        .tblreport td{
            white-space:normal;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <pg:progress ID="progress1" runat="server" />
    <div class="pageheader">
        <h2>
            <i class="fa fa-tasks"></i>Leave Request
        </h2>
        <div class="breadcrumb-wrapper mar ">
            <a id="liaddnew" runat="server" class="right_link" onclick="reset();opendiv();"><i
                class="fa fa-fw fa-plus topicon"></i>New Request</a>
            <asp:LinkButton ID="btnexportcsv" runat="server" OnClick="btnexportcsv_Click" CssClass="right_link">
           <i class="fa fa-fw fa-file-excel-o topicon"></i>Export to Excel</asp:LinkButton>
            <asp:LinkButton ID="lnkrefresh" runat="server" OnClick="btnrefresh_Click" CssClass="right_link">
            <i class="fa fa-fw fa-refresh topicon"></i>Refresh</asp:LinkButton>
        </div>
        <div class="clear">
        </div>
    </div>
    <div class="contentpanel">
        <div class="row">
            <div class="col-sm-12 col-md-12">
                <div class="panel panel-default">
                    <div class="col-sm-12 col-md-10">
                        <div style="padding-top: 10px;"><%--<div class="col-xs-12 col-sm-12 col-md-12 f_left" style="padding: 0px;">
                                <h5 class="subtitle mb5">Leave Request
                                </h5>
                            </div>--%>
                            
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl lbl2">From Date :</label>
                                <div class="txt w1 mar10">
                                    <asp:TextBox   ID="txtfromdate" runat="server" placeholder="From Date" CssClass="form-control hasDatepicker"
                                        onchange="comparedate(this.id,'ctl00_ContentPlaceHolder1_txtfromdate','ctl00_ContentPlaceHolder1_txttodate');"></asp:TextBox>

                                    <cc1:CalendarExtender ID="cc1" runat="server" TargetControlID="txtfromdate" PopupButtonID="txtfromdate"
                                        Format="MM/dd/yyyy">
                                    </cc1:CalendarExtender>
                                </div>

                            </div>
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl lbl2">To Date :</label>
                                <div class="txt w1 mar10">
                                    <asp:TextBox    ID="txttodate" runat="server" placeholder="From Date" CssClass="form-control hasDatepicker"
                                        onchange="comparedate(this.id,'ctl00_ContentPlaceHolder1_txtfromdate','ctl00_ContentPlaceHolder1_txttodate');"></asp:TextBox>

                                    <cc1:CalendarExtender ID="cc2" runat="server" TargetControlID="txttodate" PopupButtonID="txttodate"
                                        Format="MM/dd/yyyy">
                                    </cc1:CalendarExtender>
                                </div>
                            </div>
                            <div class="clear"></div>
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl lbl2">Status :</label>
                                <div class="txt w1 mar10">
                                    <asp:DropDownList ID="dropstatus" runat="server" CssClass="form-control">
                                        <asp:ListItem Value="">--All Status--</asp:ListItem>
                                        <asp:ListItem>Pending</asp:ListItem>
                                        <asp:ListItem>Approved</asp:ListItem>
                                        <asp:ListItem>Rejected</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl lbl2">Employee :</label>
                                <div class="txt w1 mar10">
                                    <asp:DropDownList ID="dropemployee" runat="server" CssClass="form-control">
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="clear"></div>
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl lbl2">Leave Type :</label>
                                <div class="txt w1 mar10">
                                    <asp:DropDownList ID="dropleavetype" runat="server" CssClass="form-control">
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl lbl2 disNone">&nbsp;  </label>
                                <input type="hidden" id="hidnid" runat="server" />
                                <asp:Button ID="btnsearch" runat="server" Text="Search" CssClass="btn btn-default"
                                    OnClick="btnsearch_Click" />
                            </div>
                        </div>
                    </div>
                    <div class="clear">
                    </div>
                    <asp:UpdatePanel ID="updatePanelData" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="false">
                        <ContentTemplate>
                            <div class="col-sm-12 col-md-12 mar2">
                                <div id="otherdiv" onclick="closediv();">
                                </div>
                                <div class="f_right" style="padding-top: 10px; display: none;">
                                    <span class="f_left">
                                        <asp:LinkButton ID="lnkprevious" runat="server" OnClick="lnkprevious_Click"> <i class="fa fa-fw fa-fast-backward color_green"></i></asp:LinkButton>
                                    </span>
                                    <p class="f_left page">
                                        <asp:Label ID="lblstart" runat="server"></asp:Label>
                                        -
                                        <asp:Label ID="lblend" runat="server"></asp:Label>
                                        of <strong>
                                            <asp:Label ID="lbltotalrecord" Font-Bold="true" runat="server"></asp:Label></strong>
                                    </p>
                                    <span class="f_left">
                                        <asp:LinkButton ID="lnknext" runat="server" OnClick="lnknext_Click">  <i class="fa fa-fw fa-fast-forward color_green"></i></asp:LinkButton>
                                    </span>
                                </div>
                                <div class="clear">
                                </div>
                                <div class="panel panel-default">
                                    <div class="panel-body2 ">
                                        <div class="row">
                                            <div class="table-responsive">
                                                <div class="nodatafound" id="divnodata" runat="server">
                                                    No data found
                                                </div>
                                                <asp:GridView ID="dgnews" runat="server" AllowPaging="false" AutoGenerateColumns="False"
                                                    PageSize="50" CellPadding="4" CellSpacing="0" Width="100%" ShowHeader="true"
                                                    ShowFooter="false" CssClass="tblreport" GridLines="None" AllowSorting="false"
                                                    OnRowDataBound="dgnews_RowDataBound" OnRowCommand="dgnews_RowCommand"
                                                    OnPageIndexChanging="dgnews_PageIndexChanging">
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="60px">
                                                            <ItemTemplate>
                                                                <%# Container.DataItemIndex + 1 %>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Emp ID" SortExpression="emploginid" HeaderStyle-Width="8%">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "emploginid")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Emp Name" SortExpression="empname" HeaderStyle-Width="15%">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "empname")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="From Date" SortExpression="LeaveDate" HeaderStyle-Width="9%">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "LeaveDate")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="To Date" SortExpression="LeaveToDate" HeaderStyle-Width="9%">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "LeaveToDate")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Days" HeaderStyle-Width="6%" SortExpression="numofdaysbyweight">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "numofdaysbyweight")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Leave Type" HeaderStyle-Width="12%" SortExpression="LeaveType">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "LeaveType")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Description">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "Description")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Requested Date" HeaderStyle-Width="15%">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "RequestDate")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="" HeaderStyle-Width="120px">
                                                            <ItemTemplate>
                                                                <%--   <asp:LinkButton ID="lbtnstatus" runat="server" Visible="true" CommandArgument='<%#Eval("nid") %>'
                                    CommandName="SetStatus">Set Status</asp:LinkButton>--%>
                                                                <asp:LinkButton ID="lbtnapprove" runat="server" ToolTip="Approve" Visible="true"
                                                                    OnClientClick='return confirm("Do you want to approve this request?");' CommandArgument='<%#Eval("nid") %>'
                                                                    CommandName="Approved" Style="margin-right: 10px;" CssClass="right"></asp:LinkButton>
                                                                <asp:LinkButton ID="lbtnreject" runat="server" ToolTip="Reject" Visible="true" CommandArgument='<%#Eval("nid") %>'
                                                                    OnClientClick='return confirm("Do you want to reject this request?");' CommandName="Rejected"
                                                                    CssClass="reject"></asp:LinkButton>
                                                                <asp:Label ID="ltrcurrentstatus" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "status")%>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                        <asp:TemplateField HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Right">
                                                            <ItemTemplate>
                                                                <a id="lbtnedit" runat="server" title="Edit"><i class="fa fa-fw">
                                                                    <img src="images/edit.png"></i></a> &nbsp;
                                                                <asp:LinkButton ID="lbtndelete" CommandName="del" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>'
                                                                    ToolTip="Delete" runat="server" OnClientClick='return confirm("Delete this record? Yes or No");'><i class="fa fa-fw"><img src="images/delete.png" alt="Delete" /></i></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                    <EmptyDataTemplate>
                                                        No Assigned task
                                                    </EmptyDataTemplate>
                                                    <HeaderStyle CssClass="gridheader" />
                                                    <RowStyle CssClass="odd" />
                                                    <AlternatingRowStyle CssClass="even" />
                                                    <EmptyDataRowStyle CssClass="nodatafound" />
                                                </asp:GridView>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="btnsearch" EventName="Click" />
                            <asp:AsyncPostBackTrigger ControlID="lnkrefresh" EventName="Click" />
                        </Triggers>
                    </asp:UpdatePanel>
                    <div class="clear">
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!---ADD NEW div goes here-->
    <asp:UpdatePanel ID="updatePanelAssign" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:Button ID="PaggedGridbtnedit" runat="server" Style="display: none;" OnClick="PaggedGridbtnedit_Click" ClientIDMode="Static" />
            <input type="hidden" id="hidid" runat="server" />
            <input type="hidden" id="hidtodate" runat="server" />
            <div style="display: none; width: 680px;" runat="server" id="divaddnew" class="itempopup">
                <div class="popup_heading">
                    <span id="legendaction" runat="server">Leave Request</span>
                    <div class="f_right">
                        <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
                    </div>
                </div>
                <div class="tabContents">
                    <asp:UpdatePanel ID="updateleavestatus" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="false">
                        <ContentTemplate>
                            <div class="col-xs-12 col-sm-12">
                                <div>
                                    <h4>Leave Status as on 
                                        <asp:Literal ID="litleavestatus" runat="server"></asp:Literal></h4>
                                    <table width="100%" class="tblsheet">
                                        <tr class="gridheader">
                                            <th>PL

                                            </th>
                                            <th>Accrued PL

                                            </th>
                                            <th>Taken PL

                                            </th>
                                            <th>Taken UPL

                                            </th>
                                            <th>Balance PL

                                            </th>


                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Literal ID="litpl" runat="server"></asp:Literal>
                                            </td>
                                            <td>
                                                <asp:Literal ID="litapl" runat="server"></asp:Literal>
                                            </td>
                                            <td>
                                                <asp:Literal ID="littakenpl" runat="server"></asp:Literal>
                                            </td>
                                            <td>
                                                <asp:Literal ID="littakenupl" runat="server"></asp:Literal>
                                            </td>
                                            <td>
                                                <asp:Literal ID="litbalancepl" runat="server"></asp:Literal>
                                            </td>

                                        </tr>
                                    </table>
                                    <input type="hidden" runat="server" id="hidaccleave" value="0" />

                                </div>
                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl">
                                        Leave Type :<asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="ddlleavetype"
                                            ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator></label>
                                    <div class="txt w1">
                                        <asp:DropDownList ID="ddlleavetype" runat="server" CssClass="form-control" onchange="checkleavetype(this.value);">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="clear"></div>
                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl">
                                        Date :
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtleavedate"
                                            ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator></label>
                                    <div class="txt w1 mar10">

                                        <asp:TextBox ID="txtleavedate" runat="server" CssClass="form-control hasDatepicker" AutoPostBack="True" OnTextChanged="txtleavedate_TextChanged"></asp:TextBox>

                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtleavedate"
                                            StartDate='<%#Convert.ToDateTime("01/01/"+DateTime.Now.Year.ToString()) %>'
                                            PopupButtonID="txtleavedate" Format="MM/dd/yyyy">
                                        </cc1:CalendarExtender>

                                    </div>
                                </div>
                              
                                <div id="divnumofdays" runat="server" class="ctrlGroup searchgroup">
                                    <label class="lbl">
                                        No.of Days :<asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="*" ValidationGroup="save"
                                            CssClass="errmsg" ClientValidationFunction="validate1"></asp:CustomValidator>
                                    </label>
                                    <div class="txt w1">
                                        <asp:TextBox ID="txtnoofdays" runat="server" placeholder="No of Days" onchange="getLeaveToDate();" MaxLength="3"
                                            onkeypress="blockNonNumbers(this, event, false, false);"
                                            onkeyup="extractNumber(this,0,false);" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="clear">
                                </div>
                                <div class="ctrlGroup searchgroup">
                                     <label class="lbl">&nbsp;
                                         </label>
                                    <div id="divtodate" runat="server" class="txt w3 mar10" style="background-color: #f3edb6; padding: 5px; display: none;">
                                    </div>
                                </div>
                                 <div class="clear">
                                </div>
                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl">
                                        Description :<asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtdescription"
                                            ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator></label>
                                    <div class="txt w3">
                                        <asp:TextBox ID="txtdescription" runat="server" placeholder="Description" CssClass="form-control"
                                            TextMode="MultiLine" Height="100px"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="ctrlGroup searchgroup">
                                  <label class="lbl">&nbsp;
                                         </label>
                                    <asp:Button ID="btnsubmit" runat="server" ValidationGroup="save" CssClass="btn btn-primary"
                                        OnClick="btnsubmit_Click" Text="Save" />
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdatePanel ID="updatePanelStatus" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="false">
        <ContentTemplate>
            <div id="divstatus" class="itempopup" style="width: 550px;">
                <div class="popup_heading">
                    <span id="Span1" runat="server">Leave Status</span>
                    <div class="f_right">
                        <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
                    </div>
                </div>
                <div class="tabContents">
                    <div class="col-xs-12 clear mar">
                        <div class="col-xs-12 col-sm-6 f_left pad">
                            <label class="col-xs-12 control-label">
                                <b>Leave Date:
                                    <asp:Literal ID="ltrdate" runat="server"></asp:Literal></b>
                        </div>
                        <div class="pad f_right">
                            <label class="col-xs-12 control-label">
                                <b>Employee:
                                    <asp:Literal ID="ltrempname" runat="server"></asp:Literal></b>
                        </div>
                        <div class="clear">
                        </div>
                        <div class="col-xs-12 col-sm-6 f_left pad">
                            <label class="col-sm-12 control-label">
                                <b>Requested Date:
                                    <asp:Literal ID="ltrrequestdate" runat="server"></asp:Literal></b>
                        </div>
                        <div class="f_right padtop10">
                            <b>Current Status:
                                <asp:Literal ID="ltrstatus" runat="server"></asp:Literal></b>
                        </div>
                        <div class="clear">
                        </div>
                        <div class="line">
                        </div>
                        <div class="col-xs-12 form-group mar f_left pad">
                            <label class="col-sm-2 control-label">
                                Status:
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="ddlstaus"
                                    ValidationGroup="savestatus" ErrorMessage="*"></asp:RequiredFieldValidator></label>
                            <div class="col-xs-12 col-sm-5">
                                <asp:DropDownList ID="ddlstaus" runat="server" CssClass="form-control">
                                    <asp:ListItem Value="">--Select--</asp:ListItem>
                                    <asp:ListItem Value="Approved">Approve</asp:ListItem>
                                    <asp:ListItem Value="Rejected">Reject</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="clear">
                        </div>
                        <%-- <label>
                        Remark:
                    </label>
                    <asp:TextBox ID="txtremark" runat="server" TextMode="MultiLine" Style="height: 80px;
                        width: 350px;" CssClass="popinput"></asp:TextBox>
                    <div class="clear">
                    </div>--%>
                        <div class="col-xs-12 form-group f_left pad">
                            <asp:Button ID="btnsave" runat="server" Text="Save" ValidationGroup="savestatus"
                                CssClass="btn btn-primary" OnClick="btnsave_Click" />
                        </div>
                    </div>
                </div>
            </div>
            </label>
            </label>
            </label>
        </ContentTemplate>
    </asp:UpdatePanel>

     <style>

        .form-control[disabled], .form-control[readonly], fieldset[disabled] .form-control {
            cursor: text !important;
    background-color: #fff !important;
        
        }
    </style>
</asp:Content>
