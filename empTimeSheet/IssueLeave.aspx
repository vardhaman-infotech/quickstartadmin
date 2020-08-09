<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="IssueLeave.aspx.cs" Inherits="empTimeSheet.IssueLeave" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
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
            if (selectedText.indexOf("Half")>-1) {
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

                

                args.IsValid = true;
            }
            return;
        }
        function getLeaveToDate() {
           
            if (document.getElementById("ctl00_ContentPlaceHolder1_ddlEmployee").value != "") {
             
                if (document.getElementById("ctl00_ContentPlaceHolder1_ddlleavetype").value != "") {
                    getenddate();
                }
                else {
                    document.getElementById("ctl00_ContentPlaceHolder1_divtodate").innerHTML = "";
                    document.getElementById("ctl00_ContentPlaceHolder1_txtnoofdays").value = "";
                    document.getElementById("ctl00_ContentPlaceHolder1_divtodate").style.display = "none";
                    document.getElementById("ctl00_ContentPlaceHolder1_ddlleavetype").focus();
                    alert("Please select a Leave Type first");
                }
            }
            else {
                document.getElementById("ctl00_ContentPlaceHolder1_divtodate").innerHTML = "";
                document.getElementById("ctl00_ContentPlaceHolder1_txtnoofdays").value = "";
                document.getElementById("ctl00_ContentPlaceHolder1_divtodate").style.display = "none";
                document.getElementById("ctl00_ContentPlaceHolder1_ddlEmployee").focus();
                alert("Please select an employee.");
            }

        }

        function getenddate() {
            var empid = document.getElementById("ctl00_ContentPlaceHolder1_ddlEmployee").value;

            if (empid != "") {
                var fromdate = document.getElementById("ctl00_ContentPlaceHolder1_txtleavedate").value;
                var numofdays = document.getElementById("ctl00_ContentPlaceHolder1_txtnoofdays").value;
                var leavetype = document.getElementById("ctl00_ContentPlaceHolder1_ddlleavetype").value;
                if (fromdate != "" && numofdays != "") {

                    var args = { LeaveDate: fromdate, NumOfDays: numofdays, empid: empid, companyid: document.getElementById("hidcompanyid").value };

                    $.ajax({

                        type: "POST",
                        url: "IssueLeave.aspx/getLeaveToDate",
                        data: JSON.stringify(args),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        async: true,
                        cache: false,
                        success: function (msg) {
                            if (msg.d != "fail") {
                                document.getElementById("ctl00_ContentPlaceHolder1_divtodate").style.display = "block";
                                document.getElementById("ctl00_ContentPlaceHolder1_divtodate").innerHTML = "You are requesting leave from <b>" + fromdate + "</b> to <b>" + msg.d + "</b>"; ;
                                document.getElementById("ctl00_ContentPlaceHolder1_hidtodate").value = msg.d;
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
                document.getElementById("ctl00_ContentPlaceHolder1_txtnoofdays").value = "";
                document.getElementById("ctl00_ContentPlaceHolder1_divtodate").style.display = "none";
                document.getElementById("ctl00_ContentPlaceHolder1_ddlEmployee").focus();
                alert("Please select an employee.");

            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <pg:progress ID="progress1" runat="server" />
    <div class="pageheader">
        <h2>
            <i class="fa fa-tasks"></i>Issue Leave
        </h2>
        <div class="breadcrumb-wrapper mar ">
        </div>
        <div class="clear">
        </div>
    </div>
    <div class="contentpanel">
        <div class="row">
            <div class="col-sm-12 col-md-12">
                <div class="panel panel-default">
                    <div class="panel-body">
                        
                            <div class="form-group fl_widht">
                                <asp:UpdatePanel ID="updatePanelAssign" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                       
                                        <div class="ctrlGroup searchgroup">
                                            <label class="lbl">Date :<input type="hidden" id="hidtodate" runat="server" />
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtleavedate"
                                                    ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator></label>
                                            <div class="txt w2 mar10">
                                                 <div class="txt w1">
                                                    <asp:TextBox ID="txtleavedate" runat="server" CssClass="form-control hasDatepicker"
                                                        onchange="getLeaveToDate();"></asp:TextBox>
                                                   
                                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtleavedate"
                                                        PopupButtonID="txtleavedate" Format="MM/dd/yyyy">
                                                    </cc1:CalendarExtender>
                                               
                                            </div>
                                                </div>
                                        </div>
                                      
                                        <div class="ctrlGroup searchgroup">
                                            <label class="lbl">Leave Type :<asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server"
                                                    ControlToValidate="ddlleavetype" ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator></label>
                                            <div class="txt w1 mar10">
                                                <asp:DropDownList ID="ddlleavetype" runat="server" CssClass="form-control" onchange="checkleavetype(this.value);">
                                                </asp:DropDownList>
                                            </div>
                                        </div>
                                        
                                       
                                         
                                       
                                         <div class="clear"></div>
                                        <div class="ctrlGroup searchgroup">
                                            <label class="lbl">Employee :
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="ddlEmployee"
                                                    ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator></label>
                                            <div class="txt w2 mar10">
                                                <asp:DropDownList ID="ddlEmployee" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlEmployee_SelectedIndexChanged" CssClass="form-control" onchange="getenddate();">
                                                </asp:DropDownList>
                                            </div>
                                        </div>
                                         <div id="divnumofdays" runat="server" class="ctrlGroup searchgroup">
                                            <label class="lbl">No.of Days :<asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="*" ValidationGroup="save"
                                                    CssClass="errmsg" ClientValidationFunction="validate1"></asp:CustomValidator>
                                            </label>
                                            <div class="txt w1 mar10">
                                                <asp:TextBox ID="txtnoofdays" runat="server"  onchange="getLeaveToDate(); setmaxval(this)"
                                                    onkeypress="blockNonNumbers(this, event, true, false);" onkeyup="extractNumber(this,2,false);"
                                                    CssClass="form-control"></asp:TextBox>
                                            </div>
                                        </div>
                                       
                                        <div class="ctrlGroup searchgroup">
                                             <label class="lbl">&nbsp;
                                                 </label>
                                            <div id="divtodate" runat="server" style="background-color: #d0d0d0; padding: 5px;
                                                display: none;" class="txt w3">
                                            </div>
                                        </div>
                                        <div class="clear"></div>
                                        <div class="ctrlGroup searchgroup">
                                            <label class="lbl">Description : <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtdescription"
                                                    ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator></label>
                                            <div class="txt w3" style="width:572px;">
                                                <asp:TextBox ID="txtdescription" runat="server" CssClass="form-control"
                                                    TextMode="MultiLine" MaxLength="1000" Height="53px"></asp:TextBox>
                                            </div>
                                        </div>
                                         <div class="clear"></div>
                                        <div class="ctrlGroup searchgroup">
                                            <label class="lbl">&nbsp;</label>
                                            <div class="txt w3">
                                                <asp:Button ID="btnsubmit" runat="server" ValidationGroup="save" CssClass="btn btn-primary"
                                                    OnClick="btnsubmit_Click" Text="Save" />
                                            </div>
                                        </div>
                                        <div class="panel panel-default">
                                     <table width="100%" class="tblsheet" id="tblstatus" visible="false" style="margin-top:10px;" runat="server">
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
                                </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>

        function setmaxval(txt) {
            if (parseInt($(txt).val()) >= 30) {
                $(txt).val(30)
            }
        }
    </script>
</asp:Content>
