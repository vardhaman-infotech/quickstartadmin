<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="PayrollReport.aspx.cs" Inherits="empTimeSheet.PayrollReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .tblsheet th
        {
            vertical-align: top;
        }
    </style>
    <script type="text/javascript">

        function getstartenddate() {

            var year = document.getElementById("ctl00_ContentPlaceHolder1_hidsalaryyear").value;
            var month = document.getElementById("ctl00_ContentPlaceHolder1_hidsalarymonth").value;

            var date = new Date(), y = year, m = parseInt(month) - 1;

            var firstDay = new Date(y, m, 1);
            var lastDay = new Date(y, m + 1, 0);

            document.getElementById("ctl00_ContentPlaceHolder1_txtfromdate").value = getFormattedDate(firstDay);
            document.getElementById("ctl00_ContentPlaceHolder1_txttodate").value = getFormattedDate(lastDay);
            document.getElementById("ctl00_ContentPlaceHolder1_hidstartdate").value = getFormattedDate(firstDay);
            document.getElementById("ctl00_ContentPlaceHolder1_hidenddate").value = getFormattedDate(lastDay);


        }
        function getFormattedDate(date) {
            var year = date.getFullYear();
            var month = (1 + date.getMonth()).toString();
            month = month.length > 1 ? month : '0' + month;
            var day = date.getDate().toString();
            day = day.length > 1 ? day : '0' + day;
            return month + '/' + day + '/' + year;
        }
        function hidedetails() {
            document.getElementById("divpayrollsummary").style.display = "none";
        }
        function hideemppayroll() {
            document.getElementById("divemppayroll").style.display = "none";
        }
    </script>
    <script type="text/javascript">

        // Script to print the given Div
        function PrintPanel() {

            var panel = document.getElementById("ctl00_ContentPlaceHolder1_divsalaryslip");
            var printWindow = window.open('', '', 'height=400,width=800');
            printWindow.document.write("<head> <link href='css/style.css' rel='stylesheet' type='text/css' /> <title>Print</title>");
            printWindow.document.write('</head><body style="background:none;"><div style="width:99%;margin:5px auto; max-width:1000px;">');
            printWindow.document.write(panel.innerHTML);
            printWindow.document.write('<div></body></html>');
            printWindow.document.close();
            setTimeout(function () {
                printWindow.print();
            }, 500);
            return false;
        }
   
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="pageheader">
        <h2>
            <i class="fa fa-clipboard"></i>Payroll Report
        </h2>
        <div class="breadcrumb-wrapper mar ">
            <asp:LinkButton ID="btnexportcsv" runat="server" OnClick="btnexportcsv_Click" CssClass="right_link"><i class="fa fa-fw"
                    style="padding-right: 10px; font-size: 12px; border: none;"></i>Export to Excel</asp:LinkButton>
            <asp:LinkButton ID="lbtnpdf" runat="server" Visible="false" OnClick="btnexportpdf_Click"
                CssClass="right_link"><i class="fa fa-fw"
                    style="padding-right: 10px; font-size: 12px; border: none;"></i>Export to PDF</asp:LinkButton>
        </div>
        <div class="clear">
        </div>
    </div>
    <div class="contentpanel">
        <div class="row">
            <div class="col-sm-12 col-md-12">
                <div class="panel panel-default">
                    <div class="col-sm-12 col-md-10">
                        <div style="padding-top: 10px;">
                            <div class="col-xs-12 col-sm-8 col-md-6 f_left" style="padding: 0px;">
                                <h5 class="subtitle mb5">
                                    Payroll Report</h5>
                            </div>
                        </div>
                    </div>
                    <div class="clear">
                    </div>
                    <div class="col-sm-12 col-md-12 mar2">
                        <asp:MultiView ID="multiview1" runat="server" ActiveViewIndex="0">
                            <asp:View ID="viewgenerate" runat="server">
                                <div class="col-sm-6 col-md-4  pad4">
                                    <asp:DropDownList ID="dropyear" runat="server" CssClass="form-control mar pad3" onchange="hidedetails();">
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="*"
                                        ValidationGroup="proceed" ControlToValidate="dropyear" CssClass="f_left validation"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-sm-6 col-md-4  pad5">
                                    <asp:DropDownList ID="dropmonthfrom" runat="server" CssClass="form-control mar pad3"
                                        onchange="hidedetails();">
                                        <asp:ListItem Value="1">January</asp:ListItem>
                                        <asp:ListItem Value="2">Feburary</asp:ListItem>
                                        <asp:ListItem Value="3">March</asp:ListItem>
                                        <asp:ListItem Value="4">April</asp:ListItem>
                                        <asp:ListItem Value="5">May</asp:ListItem>
                                        <asp:ListItem Value="6">June</asp:ListItem>
                                        <asp:ListItem Value="7">July</asp:ListItem>
                                        <asp:ListItem Value="8">August</asp:ListItem>
                                        <asp:ListItem Value="9">September</asp:ListItem>
                                        <asp:ListItem Value="10">October</asp:ListItem>
                                        <asp:ListItem Value="11">November</asp:ListItem>
                                        <asp:ListItem Value="12">December</asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="*"
                                        ValidationGroup="proceed" ControlToValidate="dropmonthfrom" CssClass="f_left validation"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-sm-6 col-md-4  pad5">
                                    <asp:DropDownList ID="dropmonthto" runat="server" CssClass="form-control mar pad3"
                                        onchange="hidedetails();">
                                        <asp:ListItem Value="1">January</asp:ListItem>
                                        <asp:ListItem Value="2">Feburary</asp:ListItem>
                                        <asp:ListItem Value="3">March</asp:ListItem>
                                        <asp:ListItem Value="4">April</asp:ListItem>
                                        <asp:ListItem Value="5">May</asp:ListItem>
                                        <asp:ListItem Value="6">June</asp:ListItem>
                                        <asp:ListItem Value="7">July</asp:ListItem>
                                        <asp:ListItem Value="8">August</asp:ListItem>
                                        <asp:ListItem Value="9">September</asp:ListItem>
                                        <asp:ListItem Value="10">October</asp:ListItem>
                                        <asp:ListItem Value="11">November</asp:ListItem>
                                        <asp:ListItem Value="12">December</asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="*"
                                        ValidationGroup="proceed" ControlToValidate="dropmonthto" CssClass="f_left validation"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-sm-6 col-md-4 clear pad4">
                                    <asp:Button ID="btnsearch" runat="server" CssClass="btn btn-default mar" Text="Search"
                                        OnClick="btnsearch_Click" ValidationGroup="proceed" />
                                </div>
                                <div class="clear">
                                </div>
                                <div class="panel panel-default">
                                    <div class="panel-body2 ">
                                        <div class="row">
                                            <div class="table-responsive">
                                                <div id="divpayrollsummary">
                                                    <div class="nodatafound" id="divnodata" runat="server" visible="false">
                                                        No Record Found
                                                    </div>
                                                    <asp:GridView ID="dgnews" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                                        CellSpacing="0" Width="100%" ShowHeader="true" OnRowCommand="dgnews_RowCommand"
                                                        ShowFooter="false" CssClass="tblsheet" GridLines="None">
                                                        <Columns>
                                                            <asp:TemplateField HeaderText="Month">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "monthyear")%>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Total Employees">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "totalemployee")%>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Total Salary">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "totalsalary")%>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Total Earnings">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "totalearnings")%>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Total Deduction">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "totaldeduction")%>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Total Bonus">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "totalbonus")%>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Gross Payment">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "totalgrosspayment")%>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Net Payment">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "NetPayableAmount")%>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField>
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="lbtnview" CommandName="viewdetail" CommandArgument='<%#Eval("salarymonth")+ "," + Eval("salaryyear") %>'
                                                                        ToolTip="View" runat="server"><img alt="view detail" src="images/view.png" /></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                        <HeaderStyle CssClass="gridheader" />
                                                        <RowStyle CssClass="odd" />
                                                        <AlternatingRowStyle CssClass="even" />
                                                        <EmptyDataRowStyle CssClass="nodatafound" />
                                                    </asp:GridView>
                                                    <div class="clear">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </asp:View>
                            <asp:View ID="viewconfrm" runat="server">
                                <div class="">
                                    <div class="col-sm-6 col-md-4 mar  pad4">
                                       
                                            <asp:TextBox ID="txtfromdate" runat="server" CssClass="form-control hasDatepicker"
                                                placeholder="Start Date" onchange="hideemppayroll();"></asp:TextBox>
                                           
                                            <cc1:CalendarExtender ID="txtDate_CalendarExtender" runat="server" TargetControlID="txtfromdate"
                                                PopupButtonID="txtfromdate" Format="MM/dd/yyyy">
                                            </cc1:CalendarExtender>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator16" runat="server" ErrorMessage="*"
                                                ValidationGroup="proceed1" ControlToValidate="txtfromdate" CssClass="f_left validation"></asp:RequiredFieldValidator>
                                       
                                    </div>
                                    <div class="col-sm-6 col-md-4 mar  pad5">
                                        
                                            <asp:TextBox ID="txttodate" runat="server" CssClass="form-control hasDatepicker"
                                                placeholder="End Date" onchange="hideemppayroll();"></asp:TextBox>
                                          
                                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txttodate"
                                                PopupButtonID="txttodate" Format="MM/dd/yyyy">
                                            </cc1:CalendarExtender>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*"
                                                ValidationGroup="proceed1" ControlToValidate="txttodate" CssClass="f_left validation"></asp:RequiredFieldValidator>
                                        
                                    </div>
                                    <div class="col-sm-6 col-md-4  pad4">
                                        <asp:DropDownList ID="dropemployee" runat="server" CssClass="form-control mar pad3"
                                            onchange="hideemppayroll();">
                                        </asp:DropDownList>
                                    </div>
                                    <div class="col-sm-6 col-md-4  pad5">
                                        <asp:Button ID="btnsearchemp" runat="server" CssClass="btn btn-default mar" Text="Search"
                                            OnClick="btnsearchemp_Click" ValidationGroup="proceed1" />
                                    </div>
                                </div>
                                <div class="clear">
                                </div>
                                <div class="f_right padtop10">
                                    <asp:LinkButton ID="lbtnback" runat="server" OnClick="btnback_Click" CssClass="add_new"
                                        Style="margin: 0px; padding: 0px;"><img src="images/arrow_left.png" alt="Back" /> </asp:LinkButton>
                                </div>
                                <div class="clear">
                                </div>
                                <div id="divemppayroll" class="panel panel-default">
                                    <div class="panel-body2 ">
                                        <div class="row">
                                            <div class="table-responsive">
                                                <div class="nodatafound" id="divnoempdetail" runat="server" visible="false">
                                                    No Record Found
                                                </div>
                                                <asp:GridView ID="dgemployee" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                                    CellSpacing="0" Width="100%" ShowHeader="true" OnRowCommand="dgemployee_RowCommand"
                                                    ShowFooter="false" CssClass="table table-success mb30" GridLines="None">
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="ID">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "loginid")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Employee Name">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "empname")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Start Date">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "startdate")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="End Date">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "enddate")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Total Salary">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "totalsalary")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Total Earnings">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "totalearnings")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Total Deduction">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "totaldeduction")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Bonus">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "bonus")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Gross Payment">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "NetPayment")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Net Payment">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "TotalAmount")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Payment Status">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "paymentstatus")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Payment Mode">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "paymentmode")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Check No.">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "checkno")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField>
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="lbtnview" CommandName="viewdetail" CommandArgument='<%#Eval("nid") %>'
                                                                    ToolTip="View" runat="server"><img alt="view detail" src="images/view.png" /></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                    <HeaderStyle CssClass="gridheader" />
                                                    <RowStyle CssClass="odd" />
                                                    <AlternatingRowStyle CssClass="even" />
                                                </asp:GridView>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </asp:View>
                            <asp:View ID="viewPaySlip" runat="server">
                                <div class="f_right padtop10">
                                    <asp:LinkButton ID="lbtnbacktoleavel2" runat="server" OnClick="lbtnbacktoleavel2_Click"
                                        CssClass="add_new" Style="margin: 0px; padding: 0px;"><img src="images/back.png" alt="Back" /> </asp:LinkButton>
                                </div>
                                <div class="clear">
                                </div>
                                <div id="divsalaryslip" runat="server" style="width: 100%; margin: auto; font-family: Tahoma, Geneva, sans-serif;">
                                    <div id="divnosalaryslip" runat="server" class="nodatafound" visible="false">
                                        No Salary Slip Generated
                                    </div>
                                    <h2 style="text-align: center; color: #025ba7; padding: 10px; font-weight: bold;
                                        font-size: 28px;">
                                        Payslip for
                                        <asp:Literal runat="server" ID="ltrmonthyear"></asp:Literal>
                                    </h2>
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0" style="border: solid 1px #666666;
                                        border-bottom: none; font-size: 13px;">
                                        <tr>
                                            <td style="background: #eee8aa; color: #000099; font-weight: lighter; padding: 5px;
                                                border-bottom: solid 1px #a7a7a7; border-right: solid 1px #a7a7a7; font-weight: bold;">
                                                Employee Id
                                            </td>
                                            <td style="background: #ffffff; color: #333333; font-weight: lighter; padding: 5px;
                                                border-bottom: solid 1px #a7a7a7; border-right: solid 1px #a7a7a7;">
                                                <asp:Literal runat="server" ID="ltrloginid"></asp:Literal>
                                            </td>
                                            <td style="background: #eee8aa; color: #000099; font-weight: lighter; border-bottom: solid 1px #a7a7a7;
                                                border-right: solid 1px #a7a7a7; padding: 5px; font-weight: bold;">
                                                Pay Period
                                            </td>
                                            <td style="background: #ffffff; color: #333333; font-weight: lighter; padding: 5px;
                                                border-bottom: solid 1px #a7a7a7; border-right: solid 1px #a7a7a7;">
                                                <asp:Literal runat="server" ID="ltrpayperiod"></asp:Literal>
                                            </td>
                                            <td style="background: #eee8aa; color: #000099; font-weight: lighter; border-bottom: solid 1px #a7a7a7;
                                                border-right: solid 1px #a7a7a7; padding: 5px; font-weight: bold;">
                                                Joining Date
                                            </td>
                                            <td style="background: #ffffff; color: #333333; font-weight: lighter; padding: 5px;
                                                border-bottom: solid 1px #a7a7a7; border-right: solid 1px #a7a7a7;">
                                                <asp:Literal runat="server" ID="ltrjoinDate"></asp:Literal>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="background: #eee8aa; color: #000099; font-weight: lighter; padding: 5px;
                                                border-bottom: solid 1px #a7a7a7; border-right: solid 1px #a7a7a7; font-weight: bold;">
                                                Name
                                            </td>
                                            <td style="background: #ffffff; color: #333333; font-weight: lighter; padding: 5px;
                                                border-bottom: solid 1px #a7a7a7; border-right: solid 1px #a7a7a7;">
                                                <asp:Literal runat="server" ID="ltrempname"></asp:Literal>
                                            </td>
                                            <td style="background: #eee8aa; color: #000099; font-weight: lighter; border-bottom: solid 1px #a7a7a7;
                                                border-right: solid 1px #a7a7a7; padding: 5px; font-weight: bold;">
                                                Total working days
                                            </td>
                                            <td style="background: #ffffff; color: #333333; font-weight: lighter; padding: 5px;
                                                border-bottom: solid 1px #a7a7a7; border-right: solid 1px #a7a7a7;">
                                                <asp:Literal runat="server" ID="ltremptotalworkingdays"></asp:Literal>
                                            </td>
                                            <td style="background: #eee8aa; color: #000099; font-weight: lighter; border-bottom: solid 1px #a7a7a7;
                                                border-right: solid 1px #a7a7a7; padding: 5px; font-weight: bold;">
                                                PFA/Acc
                                            </td>
                                            <td style="background: #ffffff; color: #333333; font-weight: lighter; padding: 5px;
                                                border-bottom: solid 1px #a7a7a7; border-right: solid 1px #a7a7a7;">
                                                <asp:Literal runat="server" ID="ltrPFAccountNum"></asp:Literal>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="background: #eee8aa; color: #000099; font-weight: lighter; padding: 5px;
                                                border-bottom: solid 1px #a7a7a7; border-right: solid 1px #a7a7a7; font-weight: bold;">
                                                Department
                                            </td>
                                            <td style="background: #ffffff; color: #333333; font-weight: lighter; padding: 5px;
                                                border-bottom: solid 1px #a7a7a7; border-right: solid 1px #a7a7a7;">
                                                <asp:Literal runat="server" ID="ltrdepartment"></asp:Literal>
                                            </td>
                                            <td style="background: #eee8aa; color: #000099; font-weight: lighter; border-bottom: solid 1px #a7a7a7;
                                                border-right: solid 1px #a7a7a7; padding: 5px; font-weight: bold;">
                                                Paid Leave
                                            </td>
                                            <td style="background: #ffffff; color: #333333; font-weight: lighter; padding: 5px;
                                                border-bottom: solid 1px #a7a7a7; border-right: solid 1px #a7a7a7;">
                                                <asp:Literal runat="server" ID="ltrpaidleaves"></asp:Literal>
                                            </td>
                                            <td style="background: #eee8aa; color: #000099; font-weight: lighter; border-bottom: solid 1px #a7a7a7;
                                                border-right: solid 1px #a7a7a7; padding: 5px; font-weight: bold;">
                                                Bank Name
                                            </td>
                                            <td style="background: #ffffff; color: #333333; font-weight: lighter; padding: 5px;
                                                border-bottom: solid 1px #a7a7a7; border-right: solid 1px #a7a7a7;">
                                                <asp:Literal runat="server" ID="ltrBankName"></asp:Literal>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="background: #eee8aa; color: #000099; font-weight: lighter; padding: 5px;
                                                border-bottom: solid 1px #a7a7a7; border-right: solid 1px #a7a7a7; font-weight: bold;">
                                                Designation
                                            </td>
                                            <td style="background: #ffffff; color: #333333; font-weight: lighter; padding: 5px;
                                                border-bottom: solid 1px #a7a7a7; border-right: solid 1px #a7a7a7;">
                                                <asp:Literal runat="server" ID="ltrdesignation"></asp:Literal>
                                            </td>
                                            <td style="background: #eee8aa; color: #000099; font-weight: lighter; border-bottom: solid 1px #a7a7a7;
                                                border-right: solid 1px #a7a7a7; padding: 5px; font-weight: bold;">
                                                Unpaid Leave
                                            </td>
                                            <td style="background: #ffffff; color: #333333; font-weight: lighter; padding: 5px;
                                                border-bottom: solid 1px #a7a7a7; border-right: solid 1px #a7a7a7;">
                                                <asp:Literal runat="server" ID="ltrunpaidleaves"></asp:Literal>
                                            </td>
                                            <td style="background: #eee8aa; color: #000099; font-weight: lighter; border-bottom: solid 1px #a7a7a7;
                                                border-right: solid 1px #a7a7a7; padding: 5px; font-weight: bold;">
                                                A/C
                                            </td>
                                            <td style="background: #ffffff; color: #333333; font-weight: lighter; padding: 5px;
                                                border-bottom: solid 1px #a7a7a7; border-right: solid 1px #a7a7a7;">
                                                <asp:Literal runat="server" ID="ltrAccountNum"></asp:Literal>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="border-bottom: solid 1px #a7a7a7; font-weight: lighter; padding: 5px;
                                                border-right: solid 1px #a7a7a7; font-weight: bold;">
                                                &nbsp;
                                            </td>
                                            <td style="border-bottom: solid 1px #a7a7a7; font-weight: lighter; padding: 5px;
                                                border-right: solid 1px #a7a7a7;">
                                                &nbsp;
                                            </td>
                                            <td style="background: #eee8aa; color: #000099; font-weight: lighter; border-bottom: solid 1px #a7a7a7;
                                                border-right: solid 1px #a7a7a7; border-bottom: solid 1px #a7a7a7; padding: 5px;
                                                font-weight: bold; font-weight: lighter; border-right: solid 1px #a7a7a7; padding: 5px;
                                                font-weight: bold;">
                                                Payable Days
                                            </td>
                                            <td style="border-bottom: solid 1px #a7a7a7; font-weight: lighter; padding: 5px;
                                                border-right: solid 1px #a7a7a7;">
                                                <asp:Literal runat="server" ID="ltrpayabledays"></asp:Literal>
                                            </td>
                                            <td style="background: #eee8aa; color: #000099; font-weight: lighter; border-bottom: solid 1px #a7a7a7;
                                                border-right: solid 1px #a7a7a7; border-bottom: solid 1px #a7a7a7; padding: 5px;
                                                font-weight: bold;">
                                                Payment Status
                                            </td>
                                            <td style="border-bottom: solid 1px #a7a7a7; color: #333333; font-weight: lighter;
                                                padding: 5px; border-right: solid 1px #a7a7a7;">
                                                <asp:Literal runat="server" ID="ltrpaymentstatus"></asp:Literal>
                                            </td>
                                        </tr>
                                    </table>
                                    <br />
                                    <h4 style="text-align: center; color: #025ba7; padding: 10px; font-weight: bold;
                                        font-size: 22px;">
                                        Salary Description
                                    </h4>
                                    <table width="50%" border="0" cellpadding="0" cellspacing="0" style="float: left;
                                        border: solid 1px #666666; border-bottom: none; font-size: 13px;">
                                        <tr>
                                            <th style="text-align: left; background: #eee8aa; color: #000099; font-weight: lighter;
                                                padding: 5px; border-bottom: solid 1px #a7a7a7; border-right: solid 1px #a7a7a7;
                                                font-weight: bold; width: 50%;">
                                                Earnings
                                            </th>
                                            <th style="text-align: left; background: #eee8aa; color: #000099; font-weight: lighter;
                                                padding: 5px; border-bottom: solid 1px #a7a7a7; border-right: solid 1px #a7a7a7;
                                                font-weight: bold; width: 50%;">
                                                Amount
                                            </th>
                                        </tr>
                                        <tr>
                                            <td style="font-weight: lighter; border-bottom: solid 1px #a7a7a7; border-right: solid 1px #a7a7a7;
                                                padding: 5px; font-weight: bold;">
                                                Basic
                                            </td>
                                            <td style="font-weight: lighter; padding: 5px; border-bottom: solid 1px #a7a7a7;
                                                border-right: solid 1px #a7a7a7;">
                                                <asp:Literal runat="server" ID="ltrbasicsalary"></asp:Literal>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Literal ID="ltrearnings" runat="server"></asp:Literal>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="font-weight: lighter; border-bottom: solid 1px #a7a7a7; border-right: solid 1px #a7a7a7;
                                                padding: 5px; font-weight: bold;">
                                                Bonus
                                            </td>
                                            <td style="border-bottom: solid 1px #a7a7a7; color: #333333; font-weight: lighter;
                                                padding: 5px; border-right: solid 1px #a7a7a7;">
                                                <asp:Literal runat="server" ID="ltrbonus"></asp:Literal>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="font-weight: lighter; border-right: solid 1px #a7a7a7; padding: 5px; font-weight: bold;
                                                width: 25%;">
                                                Total Earnings
                                            </td>
                                            <td style="color: #333333; font-weight: lighter; padding: 5px; border-right: solid 1px #a7a7a7;
                                                width: 25%;">
                                                <asp:Literal runat="server" ID="ltrtotalearnings"></asp:Literal>
                                            </td>
                                        </tr>
                                    </table>
                                    <table width="50%" border="0" cellpadding="0" cellspacing="0" style="float: left;
                                        border: solid 1px #666666; border-bottom: none; border-left: none; font-size: 13px;">
                                        <tr>
                                            <th style="text-align: left; background: #eee8aa; color: #000099; font-weight: lighter;
                                                padding: 5px; border-bottom: solid 1px #a7a7a7; border-right: solid 1px #a7a7a7;
                                                font-weight: bold; width: 50%;">
                                                Deductions
                                            </th>
                                            <th style="text-align: left; background: #eee8aa; color: #000099; font-weight: lighter;
                                                padding: 5px; border-bottom: solid 1px #a7a7a7; border-right: solid 1px #a7a7a7;
                                                font-weight: bold; width: 50%;">
                                                Amount
                                            </th>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Literal ID="ltrdeduction" runat="server"></asp:Literal>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="font-weight: lighter; border-bottom: solid 1px #a7a7a7; border-right: solid 1px #a7a7a7;
                                                padding: 5px; font-weight: bold; width: 25%;">
                                                Total Deduction
                                            </td>
                                            <td style="border-bottom: solid 1px #a7a7a7; color: #333333; font-weight: lighter;
                                                padding: 5px; border-right: solid 1px #a7a7a7;">
                                                <asp:Literal runat="server" ID="ltrtotaldeduction"></asp:Literal>
                                            </td>
                                        </tr>
                                        <%--   <tr>
                        <td style="font-weight: lighter; border-bottom: solid 1px #a7a7a7; border-right: solid 1px #a7a7a7;
                            padding: 5px; font-weight: bold;">
                            Gross Amount
                        </td>
                        <td style="border-bottom: solid 1px #a7a7a7; color: #333333; font-weight: lighter;
                            padding: 5px; border-right: solid 1px #a7a7a7;">
                            <asp:Literal runat="server" ID="ltrNetPayment"></asp:Literal>
                        </td>
                    </tr>--%>
                                    </table>
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0" style="float: left;
                                        border: solid 1px #666666; border-bottom: none; border-left: none; font-size: 13px;">
                                        <tr>
                                            <td style="text-align: right; background: #eee8aa; color: #000099; font-weight: lighter;
                                                padding: 5px; border-bottom: solid 1px #a7a7a7; border-left: solid 1px #a7a7a7;
                                                border-right: solid 1px #a7a7a7; font-weight: bold; width: 50%;">
                                                Net Amount
                                            </td>
                                            <td style="text-align: left; background: #eee8aa; color: #000099; font-weight: lighter;
                                                padding: 5px; border-bottom: solid 1px #a7a7a7; border-right: solid 1px #a7a7a7;
                                                font-weight: bold;">
                                                <asp:Literal runat="server" ID="ltrtotalamount"></asp:Literal>
                                            </td>
                                        </tr>
                                    </table>
                                    <div class="clear">
                                    </div>
                                    <br />
                                    <br />
                                    <p style="text-align: center; display: block; text-decoration: none; margin: 20px;
                                        font-size: 15px; color: #000000;">
                                        Generated on
                                        <asp:Literal runat="server" ID="ltrgenerationdate"></asp:Literal></p>
                                    <a onclick="PrintPanel();" class="print" style="border-radius: 4px; background: #025ba7;
                                        padding: 5px 0; text-align: center; font-size: 15px; color: #f2f2f2; text-decoration: none;
                                        display: block; margin: auto; width: 10%;">Print </a>
                                </div>
                            </asp:View>
                        </asp:MultiView>
                        <input type="hidden" id="hidemployeeid" runat="server" />
                        <input type="hidden" id="hidmonthfrom" runat="server" />
                        <input type="hidden" id="hidmonthto" runat="server" />
                        <input type="hidden" id="hidyear" runat="server" />
                        <input type="hidden" id="hidstartdate" runat="server" />
                        <input type="hidden" id="hidenddate" runat="server" />
                        <input type="hidden" id="hidsalarymonth" runat="server" />
                        <input type="hidden" id="hidsalaryyear" runat="server" />
                        <input type="hidden" id="hidSalarySlipEmpId" runat="server" />
                        <input type="hidden" id="hidcurrentmode" runat="server" value="summary" />
                    </div>
                    <div class="clear">
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
