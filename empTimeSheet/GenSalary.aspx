<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="GenSalary.aspx.cs" Inherits="empTimeSheet.GenSalary" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .tblsheet th
        {
            vertical-align: top;
        }
    </style>
    <!--Scirpt for get working dayas and month and year selection goes here-->
    <script type="text/javascript">
        function getstartenddate() {

            var year = document.getElementById("ctl00_ContentPlaceHolder1_dropyear").value;
            var month = document.getElementById("ctl00_ContentPlaceHolder1_dropmonth").value;

            var date = new Date(), y = year, m = parseInt(month) - 1;

            var firstDay = new Date(y, m, 1);
            var lastDay = new Date(y, m + 1, 0);

            document.getElementById("ctl00_ContentPlaceHolder1_txtfromdate").value = getFormattedDate(firstDay);
            document.getElementById("ctl00_ContentPlaceHolder1_txttodate").value = getFormattedDate(lastDay);

            document.getElementById("ctl00_ContentPlaceHolder1_btnconfirm").style.display = "none";

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
            document.getElementById("divgeneratesalary").style.display = "none";
            document.getElementById("divworkingdaysummary").style.display = "none";

        }

    </script>
    <!--Script to check and unchek all rows of gris goes here--->
    <script type="text/javascript">
        function SelectAll(CheckBoxControl) {
            if (CheckBoxControl.checked == true) {
                var i;
                for (i = 0; i < document.forms[0].elements.length; i++) {
                    if ((document.forms[0].elements[i].type == 'checkbox') &&
(document.forms[0].elements[i].name.indexOf('dgnews') > -1)) {
                        if (!document.forms[0].elements[i].disabled) {

                            document.forms[0].elements[i].checked = true;
                        }
                    }
                }
            }
            else {
                var i;
                for (i = 0; i < document.forms[0].elements.length; i++) {
                    if ((document.forms[0].elements[i].type == 'checkbox') &&
(document.forms[0].elements[i].name.indexOf('dgnews') > -1)) {
                        if (!document.forms[0].elements[i].disabled) {
                            document.forms[0].elements[i].checked = false;
                        }

                    }
                }
            }
        }
       
    </script>
    <!-- Script to validate generate salary for confirmation goes here--->
    <script type="text/javascript">
        function zeroPad(num, places) {
            var zero = places - num.toString().length + 1;
            return Array(+(zero > 0 && zero)).join("0") + num;
        }
        function validate() {
            var ischecked = 0;
            var i;
            for (i = 0; i < document.forms[0].elements.length; i++) {
                if ((document.forms[0].elements[i].type == 'checkbox') && (document.forms[0].elements[i].name.indexOf('dgnews') > -1)) {
                    if (!document.forms[0].elements[i].disabled && document.forms[0].elements[i].checked == true) {

                        ischecked = 1;
                        break;
                    }
                }

            }
            if (ischecked == 1) {
                var status = 1;
                var i;
                var earningtablecount = $('#ctl00_ContentPlaceHolder1_dgnews tr').length;
                for (var j = 2; j <= earningtablecount; j++) {
                    var i = zeroPad(j, 2);


                    if (document.getElementById("ctl00_ContentPlaceHolder1_dgnews_ctl" + i + "_chkapprove").checked == true) {
                        if (document.getElementById("ctl00_ContentPlaceHolder1_dgnews_ctl" + i + "_txtbonus").value == "") {
                            document.getElementById("ctl00_ContentPlaceHolder1_dgnews_ctl" + i + "_txtbonus").className = "errmsg";
                            status = 0;
                        }
                        else {
                            document.getElementById("ctl00_ContentPlaceHolder1_dgnews_ctl" + i + "_txtbonus").className = "";
                        }

                        if (document.getElementById("ctl00_ContentPlaceHolder1_dgnews_ctl" + i + "_txtstartdate").value == "") {
                            document.getElementById("ctl00_ContentPlaceHolder1_dgnews_ctl" + i + "_txtstartdate").className = "errmsg";
                            status = 0;
                        }
                        else {
                            document.getElementById("ctl00_ContentPlaceHolder1_dgnews_ctl" + i + "_txtstartdate").className = "";
                        }
                        if (document.getElementById("ctl00_ContentPlaceHolder1_dgnews_ctl" + i + "_txtenddate").value == "") {
                            document.getElementById("ctl00_ContentPlaceHolder1_dgnews_ctl" + i + "_txtenddate").className = "errmsg";
                            status = 0;
                        }
                        else {
                            document.getElementById("ctl00_ContentPlaceHolder1_dgnews_ctl" + i + "_txtenddate").className = "";
                        }


                    }
                    else {
                        document.getElementById("ctl00_ContentPlaceHolder1_dgnews_ctl" + i + "_txtbonus").className = "";

                        document.getElementById("ctl00_ContentPlaceHolder1_dgnews_ctl" + i + "_txtenddate").className = "";
                        document.getElementById("ctl00_ContentPlaceHolder1_dgnews_ctl" + i + "_txtstartdate").className = "";
                    }
                }
                if (status == 0) {
                    return false;
                }
                else {
                    return true;
                }
                window.scrollTo(0, 0);

            }
            else {
                alert("please select an employee first.");
                return false;
            }
        }
    </script>
    <!--Script to check enable and disable textbox for Check/DD/NEFT no. when paymeny mode selects goes here-->
    <script type="text/javascript">
        function checkamounttype(id, value) {

            var charindex = id.lastIndexOf("_");
            if (charindex != -1) {
                id = id.substring(0, charindex + 1);
                if (value.toLowerCase() == "cash") {
                    document.getElementById(id + "txtcheckno").value = "";
                    document.getElementById(id + "txtcheckno").disabled = true;

                }
                else {
                    document.getElementById(id + "txtcheckno").disabled = false;
                }
            }
        }
    </script>
    <script type="text/javascript">
        function validateconfirm() {
            var status = 1;
            var i;
            var rowcount = $('#ctl00_ContentPlaceHolder1_dgconfirm tr').length;
            for (var j = 2; j <= rowcount; j++) {
                var i = zeroPad(j, 2);
                var paymentmode = document.getElementById("ctl00_ContentPlaceHolder1_dgconfirm_ctl" + i + "_ddlpaymentmode").value;
                var paymentstatus = document.getElementById("ctl00_ContentPlaceHolder1_dgconfirm_ctl" + i + "_ddlpaymentstatus").value;

                if (paymentmode.toLowerCase() != "cash" && paymentstatus.toLowerCase() == "paid") {
                    if (document.getElementById("ctl00_ContentPlaceHolder1_dgconfirm_ctl" + i + "_txtcheckno").value == "") {
                        document.getElementById("ctl00_ContentPlaceHolder1_dgconfirm_ctl" + i + "_txtcheckno").className = "errmsg";
                        status = 0;
                    }
                    else {
                        document.getElementById("ctl00_ContentPlaceHolder1_dgconfirm_ctl" + i + "_txtcheckno").className = "";
                    }
                }
                else {
                    document.getElementById("ctl00_ContentPlaceHolder1_dgconfirm_ctl" + i + "_txtcheckno").className = "";
                }
            }

            if (status == 0) {
                return false;
                alert('fill Check/DD/Trans No.');
            }
            else {
                return true;
            }
        }
    </script>
    <!--Script to calcullate employee working days and leaves if chnages the start date and end date-->
    <script type="text/javascript">
        function getemployeeworkingdays(id) {
            var charindex = id.lastIndexOf("_");
            if (charindex != -1) {
                id = id.substring(0, charindex + 1);
                var startdate = document.getElementById(id + "txtstartdate").value;
                var enddate = document.getElementById(id + "txtenddate").value;
                var empid = document.getElementById(id + "hidempid").value;
                var month = document.getElementById("ctl00_ContentPlaceHolder1_dropmonth").value;
                var year = document.getElementById("ctl00_ContentPlaceHolder1_dropyear").value;
                var companyid = document.getElementById("ctl00_ContentPlaceHolder1_hidcompanyid").value;
                if (startdate != "" && enddate != "") {
                    var args = { empid: empid, startdate: startdate, enddate: enddate, month: month, year: year, companyid: companyid };

                    $.ajax({

                        type: "POST",
                        url: "GenSalary.aspx/getemployeeworkingdays",
                        data: JSON.stringify(args),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        async: true,
                        cache: false,
                        success: function (msg) {
                            if (msg.d != "fail") {
                                var myarr = msg.d.toString().split("#");
                                if (myarr.length > 0) {
                                    document.getElementById(id + "hidtotalearnings").value = myarr[0];
                                    document.getElementById(id + "hidtotaldeduction").value = myarr[1];
                                    document.getElementById(id + "hidNetPayable").value = myarr[2];
                                    document.getElementById(id + "hidtotalpayabledays").value = myarr[3];
                                    document.getElementById(id + "hidtotalpaidleaves").value = myarr[4];
                                    document.getElementById(id + "hidtotalunpaidleaves").value = myarr[5];
                                    document.getElementById(id + "ltremptotalworkingdays").innerHTML = myarr[6];
                                    document.getElementById(id + "hidemptotalworkingdays").value = myarr[6];
                                    document.getElementById(id + "txtemptotalworkingdays").value = myarr[6];
                                    document.getElementById(id + "hidtotalworkingdays").value = myarr[7];
                                    document.getElementById(id + "hidtotalctc").value = myarr[8];
                                    document.getElementById(id + "hidBasicSalary").value = myarr[9];
                                }

                            }
                            else {
                                alert("The call to the server side failed.");
                            }
                        },
                        error: function (x, e) {
                            alert("The call to the server side failed. " + x.responseText);

                        }


                    });
                }

            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="heading">
        <h1>
            Generate Salary
        </h1>
    </div>
    <div class="clear">
    </div>
    <div class="left_inner">
        <asp:DropDownList ID="dropyear" runat="server" CssClass="form_2_input5_1" Style="width: 250px;"
            onchange="getstartenddate();hidedetails();">
        </asp:DropDownList>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="*"
            ValidationGroup="proceed" ControlToValidate="dropyear" CssClass="f_left validation"></asp:RequiredFieldValidator>
        <asp:DropDownList ID="dropmonth" runat="server" CssClass="form_2_input5_1" Style="width: 250px;"
            onchange="getstartenddate();hidedetails();">
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
            ValidationGroup="proceed" ControlToValidate="dropmonth" CssClass="f_left validation"></asp:RequiredFieldValidator>
        <asp:TextBox ID="txtfromdate" runat="server" CssClass="form_2_input5_1 date" Style="width: 238px;"
            placeholder="Start Date" onchange="hidedetails();"></asp:TextBox>
        <cc1:CalendarExtender ID="txtDate_CalendarExtender" runat="server" TargetControlID="txtfromdate"
            PopupButtonID="txtfromdate" Format="MM/dd/yyyy">
        </cc1:CalendarExtender>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator16" runat="server" ErrorMessage="*"
            ValidationGroup="proceed" ControlToValidate="txtfromdate" CssClass="f_left validation"></asp:RequiredFieldValidator>
        <asp:TextBox ID="txttodate" runat="server" CssClass="form_2_input5_1 date" Style="width: 238px;"
            placeholder="End Date" onchange="hidedetails();"></asp:TextBox>
        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txttodate"
            PopupButtonID="txttodate" Format="MM/dd/yyyy">
        </cc1:CalendarExtender>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*"
            ValidationGroup="proceed" ControlToValidate="txttodate" CssClass="f_left validation"></asp:RequiredFieldValidator>
        <div class="clear">
        </div>
        <div style="margin-left: 3px">
            <asp:Button ID="btnsearch" runat="server" CssClass="button" Text="Search" OnClick="btnsearch_Click"
                ValidationGroup="proceed" />
        </div>
        <div class="padtop10">
            <asp:UpdatePanel ID="updateworkingdays" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <div id="divworkingdaysummary">
                        <asp:Repeater ID="rptworkingdaysdetail" runat="server">
                            <HeaderTemplate>
                                <table cellspacing="0" cellpadding="5" style="margin-bottom: 20px; margin-top: 20px;
                                    width: 95%;" class="tblsheet">
                                    <tr class="gridheader">
                                        <th colspan="2">
                                            Working Days Summary
                                        </th>
                                    </tr>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td style="padding-bottom: 15px;">
                                        Total Days:
                                    </td>
                                    <td>
                                        <strong>
                                            <%#Eval("totaldays")%></strong>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-bottom: 15px;">
                                        Total Holidays:
                                    </td>
                                    <td>
                                        <strong>
                                            <%#Eval("totalholidays")%></strong>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Total Working Days:
                                    </td>
                                    <td>
                                        <strong>
                                            <%#Eval("totalworkingdays")%></strong>
                                    </td>
                                </tr>
                            </ItemTemplate>
                            <FooterTemplate>
                                </table>
                            </FooterTemplate>
                        </asp:Repeater>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <div class="right_inner">
        <asp:MultiView ID="multiview1" runat="server" ActiveViewIndex="0">
            <asp:View ID="viewgenerate" runat="server">
             <div id="divgeneratesalary">
                <div class="nodatafound" id="divnodata" runat="server" visible="false">
                    Salary already generated
                </div>
                <asp:GridView ID="dgnews" runat="server" AutoGenerateColumns="False" CellPadding="4"
                    OnRowDataBound="dgnews_RowDataBound" CellSpacing="0" Width="100%" ShowHeader="true"
                    ShowFooter="false" CssClass="tblsheet" GridLines="None">
                    <Columns>
                        <asp:TemplateField HeaderStyle-Width="35px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                            <HeaderTemplate>
                                <input id="chkSelect" name="Select All" onclick="SelectAll(this)" type="checkbox"
                                    checked="checked"></input>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:CheckBox ID="chkapprove" runat="server" Checked="true" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Employee ID" SortExpression="loginid">
                            <ItemTemplate>
                                <%# DataBinder.Eval(Container.DataItem, "loginid")%>
                                <input type="hidden" id="hidempid" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "nid")%>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Employee Name" SortExpression="empname">
                            <ItemTemplate>
                                <%# DataBinder.Eval(Container.DataItem, "empname")%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Bonus">
                            <ItemTemplate>
                                <asp:TextBox ID="txtbonus" runat="server" onkeypress="blockNonNumbers(this, event, true, false);"
                                    onkeyup="extractNumber(this,2,false);" Width="100px" Text="0"></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Start Date">
                            <ItemTemplate>
                                <asp:TextBox ID="txtstartdate" runat="server" Width="100px" Text='<%# DataBinder.Eval(Container.DataItem, "startdate")%>'
                                    onchange="getemployeeworkingdays(this.id);" CssClass="date"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender99" ClientIDMode="AutoID" Format="MM/dd/yyyy"
                                    TargetControlID="txtstartdate" PopupButtonID="txtstartdate" runat="server">
                                </cc1:CalendarExtender>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="End Date">
                            <ItemTemplate>
                                <asp:TextBox ID="txtenddate" runat="server" Width="100px" Text='<%# DataBinder.Eval(Container.DataItem, "enddate")%>'
                                    onchange="getemployeeworkingdays(this.id);" CssClass="date"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtenderendate" ClientIDMode="AutoID" Format="MM/dd/yyyy"
                                    TargetControlID="txtenddate" PopupButtonID="txtenddate" runat="server">
                                </cc1:CalendarExtender>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Presents">
                            <ItemTemplate>
                                <asp:Label ID="ltremptotalworkingdays" runat="server" Style="display: none;" Text='<%# DataBinder.Eval(Container.DataItem, "emptotalworkingdays")%>'></asp:Label>
                                <asp:TextBox ID="txtemptotalworkingdays" Width="50px" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "emptotalworkingdays")%>'></asp:TextBox>
                                <input type="hidden" id="hidemptotalworkingdays" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "emptotalworkingdays")%>' />
                                <input type="hidden" id="hidtotalctc" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "totalctc")%>' />
                                <input type="hidden" id="hidtotalearnings" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "totalearnings")%>' />
                                <input type="hidden" id="hidtotaldeduction" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "totaldeduction")%>' />
                                <input type="hidden" id="hidNetPayable" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "NetPayable")%>' />
                                <input type="hidden" id="hidtotalworkingdays" runat="server" value='  <%# DataBinder.Eval(Container.DataItem, "totalworkingdays")%>' />
                                <input type="hidden" id="hidtotalpaidleaves" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "totalpaidleaves")%>' />
                                <input type="hidden" id="hidtotalunpaidleaves" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "totalunpaidleaves")%>' />
                                <input type="hidden" id="hidtotalpayabledays" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "totalpayabledays")%>' />
                                <input type="hidden" id="hidBasicSalary" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "basicsalary")%>' />
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
                <div class="padtop10">
                    <asp:Button ID="btnconfirm" runat="server" Text="Confirm" CssClass="button" OnClick="btnconfirm_Click"
                        OnClientClick="return validate();" Style="display: none;" />
                </div>
                </div>
            </asp:View>
            <asp:View ID="viewconfrm" runat="server">
                <div class="padtop10">
                    <h2>
                        Confirm Salary
                    </h2>
                </div>
                <div class="clear">
                </div>
                <div class="f_right padtop10">
                    <asp:LinkButton ID="lbtnback" runat="server" OnClick="btnback_Click" CssClass="add_new"
                        Style="margin: 0px; padding: 0px;"><img src="images/back.png" alt="Back" /> </asp:LinkButton>
                </div>
                <div class="clear">
                </div>
                <div class="padtop10" style="overflow-x: auto;">
                    <asp:GridView ID="dgconfirm" runat="server" AutoGenerateColumns="False" CellPadding="4"
                        OnRowDataBound="dgconfirm_RowDataBound" CellSpacing="0" ShowHeader="true" ShowFooter="false"
                        CssClass="tblsheet" GridLines="None">
                        <Columns>
                            <asp:TemplateField HeaderStyle-Width="35px" HeaderText="S.No.">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex + 1 %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="ID" SortExpression="loginid">
                                <ItemTemplate>
                                    <%# DataBinder.Eval(Container.DataItem, "loginid")%>
                                    <input type="hidden" id="hidempid" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "nid")%>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Employee" SortExpression="empname">
                                <ItemTemplate>
                                    <%# DataBinder.Eval(Container.DataItem, "empname")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Salary">
                                <ItemTemplate>
                                    <asp:Literal ID="ltrCTC" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "totalctc")%>'></asp:Literal>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Start Date">
                                <ItemTemplate>
                                    <asp:Literal ID="ltrstartdate" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "startdate")%>'></asp:Literal>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="End Date">
                                <ItemTemplate>
                                    <asp:Literal ID="ltrenddate" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "enddate")%>'></asp:Literal>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Working Days">
                                <ItemTemplate>
                                    <%# DataBinder.Eval(Container.DataItem, "emptotalworkingdays")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Paid Leaves">
                                <ItemTemplate>
                                    <%# DataBinder.Eval(Container.DataItem, "totalpaidleaves")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Unpaid Leaves">
                                <ItemTemplate>
                                    <%# DataBinder.Eval(Container.DataItem, "totalunpaidleaves")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Payable Days">
                                <ItemTemplate>
                                    <%--   <asp:Literal ID="ltrpayabledays" runat="server" Text=''></asp:Literal>--%>
                                    <asp:Literal ID="ltrtotalpayabledays" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "totalpayabledays")%>'></asp:Literal>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Earnings">
                                <ItemTemplate>
                                    <asp:Literal ID="ltrtotalearnings" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "totalearnings")%>'></asp:Literal>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Deduction">
                                <ItemTemplate>
                                    <asp:Literal ID="ltrtotaldeduction" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "totaldeduction")%>'></asp:Literal>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Bonus">
                                <ItemTemplate>
                                    <asp:Literal ID="ltrbonus" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "bonus")%>'></asp:Literal>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Gross Amt.">
                                <ItemTemplate>
                                    <asp:Literal ID="ltrNetPayable" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "NetPayable")%>'></asp:Literal>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="NetPayable Amt.">
                                <ItemTemplate>
                                    <asp:Literal ID="ltrtotalamt" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "NetPayable")%>'></asp:Literal>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Payment Status">
                                <ItemTemplate>
                                    <asp:DropDownList ID="ddlpaymentstatus" runat="server" Width="80px">
                                        <asp:ListItem>Paid</asp:ListItem>
                                        <asp:ListItem>Unpaid</asp:ListItem>
                                    </asp:DropDownList>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Payment Mode">
                                <ItemTemplate>
                                    <asp:DropDownList ID="ddlpaymentmode" runat="server" Width="80px" onchange="checkamounttype(this.id,this.value);">
                                        <asp:ListItem>Check</asp:ListItem>
                                        <asp:ListItem>DD</asp:ListItem>
                                        <asp:ListItem>NEFT</asp:ListItem>
                                        <asp:ListItem>Cash</asp:ListItem>
                                    </asp:DropDownList>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Check/DD/Trans No.">
                                <ItemTemplate>
                                    <asp:TextBox ID="txtcheckno" runat="server" Width="100px"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <HeaderStyle CssClass="gridheader" />
                        <RowStyle CssClass="odd" />
                        <AlternatingRowStyle CssClass="even" />
                        <EmptyDataRowStyle CssClass="nodatafound" />
                    </asp:GridView>
                </div>
                <div class="clear">
                </div>
                <div class="padtop10">
                <!--return validateconfirm(); -->
                    <asp:Button ID="btnsave" runat="server" Text="Generate Salary" CssClass="button"
                        OnClientClick='return confirm("Are you sure to generate salary?");'
                        OnClick="btnsave_Click" />
                </div>
            </asp:View>
        </asp:MultiView>
        <input type="hidden" id="hidSelectedEmp" runat="server" />
        <input type="hidden" id="hidpayabledays" runat="server" />
        <input type="hidden" id="hidmonth" runat="server" />
        <input type="hidden" id="hidyear" runat="server" />
        <input type="hidden" id="hidstartdate" runat="server" />
        <input type="hidden" id="hidenddate" runat="server" />
        <input type="hidden" id="hidcompanyid" runat="server" />
    </div>
</asp:Content>
