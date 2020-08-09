<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="ServerLog.aspx.cs" Inherits="empTimeSheet.ServerLog" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="css/server_2.0.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">

        function addrow() {
            var table = document.getElementById("tbldata");
            var id = parseInt(document.getElementById("<%=hidrowno.ClientID %>").value);
            var sno = parseInt(document.getElementById("<%=hidsno.ClientID %>").value);
            sno = sno + 1
            var newsno = id + 1;
            var row = table.insertRow(newsno);


            if (id > 1)
                document.getElementById("divdel" + id).innerHTML = "";

            var celldelete = row.insertCell(0);
            var cellSno = row.insertCell(1);
            var celllogtype = row.insertCell(2);
            var cellevntid = row.insertCell(3);
            var celldescription = row.insertCell(4);
            var cellseveritylevel = row.insertCell(5);
            var cellaction = row.insertCell(6);
            var cellremark = row.insertCell(7);


            celldelete.innerHTML = "<div id='divdel" + newsno + "'><a style='cursor: pointer;color:bule;' id='delete' onclick='deleterow(this.id);' ><img src='images/delete.png' /></a></div>";
            cellSno.innerHTML = sno;
            celllogtype.innerHTML = "<select id='ddllog" + newsno + "' class='form-control pad3'> <option>Critical</option> <option>Error</option> <option>Warning</option></select>";
            cellevntid.innerHTML = "<input type='text' id='txt_eventid" + newsno + "' onchange='binddescription(this.id,this.value);' class='form-control pad3'/>";
            celldescription.innerHTML = "<input type='text' id='txt_description" + newsno + "' class='form-control pad3' />";
            cellseveritylevel.innerHTML = "<select id='ddlseverity" + newsno + "' class='form-control pad3'><option>Ignorable</option><option>Need Action</option></select>";
            cellaction.innerHTML = "<select id='ddlaction" + newsno + "' class='form-control pad3'> <option>Pending</option><option>In Process</option><option>Fixed</option></select>";
            cellremark.innerHTML = "<input type='text' id='txt_remark" + newsno + "' class='form-control pad3' />";


            document.getElementById("<%=hidrowno.ClientID %>").value = newsno;
            document.getElementById("<%=hidsno.ClientID %>").value = sno;


            var height = $('#divsheetbox')[0].scrollHeight;
            $('#divsheetbox').scrollTop(height);
        }


        //Delete rows
        function deleterow() {

            var table = document.getElementById("tbldata");
            var id = parseInt(document.getElementById("<%=hidrowno.ClientID %>").value);
            var sno = parseInt(document.getElementById("<%=hidsno.ClientID %>").value);
            sno = sno - 1
            var newsno = id - 1;
            table.deleteRow(id);
            if (newsno != "1")
                document.getElementById("divdel" + newsno).innerHTML = "<a style='cursor: pointer;color:bule;' id='delete' onclick='deleterow(this.id);' ><img src='images/delete.png' /></a>";
            document.getElementById("<%=hidrowno.ClientID %>").value = newsno;
            document.getElementById("<%=hidsno.ClientID %>").value = sno;




        }
        function savedata() {

            var status = 1;
            var newid = "";
            var id = parseInt(document.getElementById("<%=hidrowno.ClientID %>").value);

            for (var i = 1; i <= id; i++) {

                newid = ddllog + i;
                if (document.getElementById(newid).value != "") {
                    newid = "txt_eventid" + i;

                    if (document.getElementById(newid).value == "") {
                        status = 0;
                        document.getElementById(newid).className = "errform-control ";
                    }
                    else {
                        
                            document.getElementById(newid).className = "form-control ";
                        
                    }

                    newid = "txt_description" + i;
                    //  alert(newid);
                    if (document.getElementById(newid).value == "") {
                        status = 0;
                        document.getElementById(newid).className = "errform-control";
                    }
                    else {
                        document.getElementById(newid).className = "form-control";
                    }


                }

            }

            if (status == 0) {
                return false;
            }
            else {

                // submitform();
                getinfo();
                return true;

            }

        }

        //Bind entered time info to hidden field after validate the entries
        function getinfo() {
         
            var newid = "", LogType = "", Eventid = "", Des = "", Level = "", Action = "", Remark = "";
            var id = parseInt(document.getElementById("<%=hidrowno.ClientID %>").value);

            for (var i = 1; i <= id; i++) {

                newid = "ddllog" + i;

                LogType = LogType + "###" + document.getElementById(newid).value;

                newid = "txt_eventid" + i;

                Eventid = Eventid + "###" + document.getElementById(newid).value;

                newid = "txt_description" + i;

                Des = Des + "###" + document.getElementById(newid).value;

                newid = "ddlseverity" + i;

                Level = Level + "###" + document.getElementById(newid).value;

                newid = "ddlaction" + i;

                Action = Action + "###" + document.getElementById(newid).value;

                newid = "txt_remark" + i;

                Remark = Remark + "###" + document.getElementById(newid).value;

            }
            document.getElementById("<%=hidlog.ClientID %>").value = LogType;
            document.getElementById("<%=hidevent.ClientID %>").value = Eventid;
            document.getElementById("<%=hiddes.ClientID %>").value = Des;
            document.getElementById("<%=hidlevel.ClientID %>").value = Level;
            document.getElementById("<%=hidaction.ClientID %>").value = Action;
            document.getElementById("<%=hidremark.ClientID %>").value = Remark;

        }
 
    </script>
    <!--Script to bind description of existing events goes here-->
    <script type="text/javascript">
        function binddescription(id, value) {
            var rownum = id.replace('txt_eventid', '');
            var companyid = document.getElementById("ctl00_ContentPlaceHolder1_hidcompanyid").value;

            var args = { eventid: value, companyid: companyid };

            $.ajax({
                type: "POST",
                url: "ServerLog.aspx/geteventdesc",
                data: JSON.stringify(args),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                cache: false,
                success: function (msg) {


                    if (msg.d != "failure")
                        document.getElementById("txt_description" + rownum).value = msg.d;
                    else
                        document.getElementById("txt_description" + rownum).value = "";

                },
                error: function (x, e) {
                    alert("The call to the server side failed. " + x.responseText);

                }

            });

        }
         
    </script>

     <script type="text/javascript">
         function bindbackupdescription() {
             var serverid = document.getElementById("ctl00_ContentPlaceHolder1_ddlserver").value;
             var companyid = document.getElementById("ctl00_ContentPlaceHolder1_hidcompanyid").value;

                 var args = { serverid: serverid, companyid: companyid };
                 $.ajax({
                     type: "POST",
                     url: "ServerLog.aspx/getbackupdesc",
                     data: JSON.stringify(args),
                     contentType: "application/json; charset=utf-8",
                     dataType: "json",
                     async: true,
                     cache: false,
                     success: function (msg) {

                         if (msg.d != "failure")
                             document.getElementById("ctl00_ContentPlaceHolder1_txtbackupdescription").value = msg.d;

                         else
                             document.getElementById("ctl00_ContentPlaceHolder1_txtbackupdescription").value = "";
                     },
                     error: function (x, e) {
                         alert("The call to the server side failed. " + x.responseText);

                     }

                 });
         }
         
    </script>
    <script type="text/javascript">

        function showupdate() // if you pass the form, checkValue(form)
        {
            var status = 0;
            if (document.getElementById("ctl00_ContentPlaceHolder1_rdlupdated_0").checked == true) {
                document.getElementById("ctl00_ContentPlaceHolder1_divupdated").style.display = "block";
                
            }
            else {
                document.getElementById("ctl00_ContentPlaceHolder1_divupdated").style.display = "none";
                document.getElementById("ctl00_ContentPlaceHolder1_txtUpdateSummary").value = "";

            }

        }
        function showbackup() // if you pass the form, checkValue(form)
        {
            var status = 0;
            if (document.getElementById("ctl00_ContentPlaceHolder1_rdlbackup_0").checked == true) {
                document.getElementById("ctl00_ContentPlaceHolder1_divbackup").style.display = "block";
                bindbackupdescription();
            }
            else {
                document.getElementById("ctl00_ContentPlaceHolder1_divbackup").style.display = "none";
                document.getElementById("ctl00_ContentPlaceHolder1_txtbackupdescription").value = "";

            }

        }
    </script>
    <script type="text/javascript">
        function validate() {

            var status = 0;
            if (document.getElementById("ctl00_ContentPlaceHolder1_ddlclient").value == "") {
                document.getElementById("ctl00_ContentPlaceHolder1_RequiredFieldValidator1").style.visibility = "visible";
                status = 1;
            }
            else {
                document.getElementById("ctl00_ContentPlaceHolder1_RequiredFieldValidator1").style.visibility = "hidden";
            }
            if (document.getElementById("ctl00_ContentPlaceHolder1_ddlserver").value == "") {
                document.getElementById("ctl00_ContentPlaceHolder1_RequiredFieldValidator2").style.visibility = "visible";
                status = 1;
            }
            else {
                document.getElementById("ctl00_ContentPlaceHolder1_RequiredFieldValidator2").style.visibility = "hidden";
            }

            if (document.getElementById("ctl00_ContentPlaceHolder1_txtlogdate").value == "") {
                document.getElementById("ctl00_ContentPlaceHolder1_RequiredFieldValidator3").style.visibility = "visible";
                status = 1;
            }
            else {
                document.getElementById("ctl00_ContentPlaceHolder1_RequiredFieldValidator3").style.visibility = "hidden";
            }
            if (document.getElementById("ctl00_ContentPlaceHolder1_rbtnramutilization").value == "") {

                document.getElementById("ctl00_ContentPlaceHolder1_RequiredFieldValidator4").style.visibility = "visible";
                status = 1;

            }
            else {
                document.getElementById("ctl00_ContentPlaceHolder1_RequiredFieldValidator4").style.visibility = "hidden";
            }
            if (document.getElementById("ctl00_ContentPlaceHolder1_rbtncpuutilization").value == "") {

                document.getElementById("ctl00_ContentPlaceHolder1_RequiredFieldValidator5").style.visibility = "visible";
                status = 1;
            }
            else {
                document.getElementById("ctl00_ContentPlaceHolder1_RequiredFieldValidator5").style.visibility = "hidden";
            }
            if (document.getElementById("ctl00_ContentPlaceHolder1_txt_space").value == "") {
                document.getElementById("ctl00_ContentPlaceHolder1_req1").style.visibility = "visible";
                status = 1;
            }
            else {
                document.getElementById("ctl00_ContentPlaceHolder1_req1").style.visibility = "hidden";
            }

            var newid = "";
            var id = parseInt(document.getElementById("<%=hidrowno.ClientID %>").value);

            for (var i = 1; i <= id; i++) {

                newid = "ddllog" + i;
                if (document.getElementById(newid).value != "") {
                    newid = "txt_eventid" + i;

                    if (document.getElementById(newid).value == "") {
                        status = 1;
                        document.getElementById(newid).className = "errform-control ";
                    }
                    else {
                      
                      document.getElementById(newid).className = "form-control ";
                       
                    }

                    newid = "txt_description" + i;
                    //  alert(newid);
                    if (document.getElementById(newid).value == "") {
                        status = 1;
                        document.getElementById(newid).className = "errform-control";
                    }
                    else {
                        document.getElementById(newid).className = "form-control";
                    }


                }

            }
            if (status == 1) {
                return false;
               
            }
            else {

                getinfo();
               
            }

        }
    </script>
    <script type="text/javascript">
        function setcolor(id) {

            var value = document.getElementById(id).value;
            if (value == "High") {
                document.getElementById(id).style.background = "#F50827";
            }
            else if (value == "Medium") {
                document.getElementById(id).style.background = "#ffffa0";
            }
            else if (value == "Low") {
                document.getElementById(id).style.background = "#369c36";
            }
            else {
                document.getElementById(id).style.background = "transparent";
            }
        }
        function setramcolor() {

            var value = document.getElementById("ctl00_ContentPlaceHolder1_rbtnramutilization").value;
            if (value == "High") {
                document.getElementById("ctl00_ContentPlaceHolder1_rbtnramutilization").style.background = "#F50827";
            }
            else if (value == "Medium") {
                document.getElementById("ctl00_ContentPlaceHolder1_rbtnramutilization").style.background = "#ffffa0";
            }
            else if (value == "Low") {
                document.getElementById("ctl00_ContentPlaceHolder1_rbtnramutilization").style.background = "#369c36";
            }
            else {
                document.getElementById("ctl00_ContentPlaceHolder1_rbtnramutilization").style.background = "transparent";
            }
        }
        function setcpucolor() {

            var value = document.getElementById("ctl00_ContentPlaceHolder1_rbtncpuutilization").value;
            if (value == "High") {
                document.getElementById("ctl00_ContentPlaceHolder1_rbtncpuutilization").style.background = "#F50827";
            }
            else if (value == "Medium") {
                document.getElementById("ctl00_ContentPlaceHolder1_rbtncpuutilization").style.background = "#ffffa0";
            }
            else if (value == "Low") {
                document.getElementById("ctl00_ContentPlaceHolder1_rbtncpuutilization").style.background = "#369c36";
            }
            else {
                document.getElementById("ctl00_ContentPlaceHolder1_rbtncpuutilization").style.background = "transparent";
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:UpdatePanel ID="upadatepanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <pg:progress ID="progress1" runat="server" />
            <div class="pageheader">
                <h2>
                    <i class="fa fa-desktop"></i>Server Log </h1>
                    <div class="breadcrumb-wrapper mar ">
                        <asp:LinkButton ID="liaddnew" runat="server" CssClass="right_link" OnClick="liaddnew_Click"
                            Visible="false"><i class="fa fa-fw fa-plus topicon"></i> Add New </asp:LinkButton>
                    </div>
                    <div class="clear">
                    </div>
            </div>
            <div class="contentpanel">
                <div class="row">
                    <div class="col-sm-4 col-md-3">
                        <div class="panel panel-default">
                            <div class="panel-body" style="min-height: 575px; float: left;">
                                <h5 class="subtitle mb5">
                                    Server Log</h5>
                                <asp:DropDownList ID="ddlclient" runat="server" CssClass="form-control mar pad3 f_left" style="width:96%;"
                                    AutoPostBack="true" OnSelectedIndexChanged="ddlclient_SelectedIndexChanged">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="ddlclient"
                                    ValidationGroup="save" ErrorMessage="*" CssClass="f_left mar"></asp:RequiredFieldValidator>
                                <div class="clear">
                                </div>
                                <asp:DropDownList ID="ddlserver" runat="server" CssClass="form-control mar pad3 f_left" style="width:96%;"
                                    AutoPostBack="true" OnSelectedIndexChanged="ddlserver_SelectedIndexChanged">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="ddlserver"
                                    ValidationGroup="save" ErrorMessage="*" CssClass="f_left mar"></asp:RequiredFieldValidator>
                                <div class="clear">
                                </div>
                                <div class="mar" style="width:96%;">
                                    <asp:TextBox ID="txtlogdate" runat="server" CssClass="form-control hasDatepicker f_left"
                                        placeholder="Log Date" AutoPostBack="true" OnTextChanged="txtlogdate_TextChanged"></asp:TextBox>
                                   
                                </div>
                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtlogdate"
                                    PopupButtonID="txtlogdate" Format="MM/dd/yyyy">
                                </cc1:CalendarExtender>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtlogdate"
                                    ValidationGroup="save" ErrorMessage="*" CssClass="f_left"></asp:RequiredFieldValidator>
                            </div>
                            <div class="clear">
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-8 col-md-9">
                        <div class="panel panel-default">
                            <div class="panel-body">
                                <div class="row">
                                    <div class="form-group fl_widht">
                                        <div class="col-xs-12 col-sm-12">
                                            <asp:Repeater ID="rptinner" runat="server">
                                                <HeaderTemplate>
                                                    <h2 style="padding-top: 0px; padding-bottom: 13px;">
                                                        Server Detail</h2>
                                                    <table cellpadding="5" cellspacing="0" class="tblsheet" style="margin-bottom: 20px;">
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <tr>
                                                        <td style="border-top: 1px solid #d0d0d0; padding-bottom: 15px;">
                                                            <span>Server Code:</span> <strong>
                                                                <%#Eval("ServerCode")%>
                                                            </strong>
                                                        </td>
                                                        <td style="border-top: 1px solid #d0d0d0; padding-bottom: 15px;">
                                                            <span>Server Name: </span><strong>
                                                                <%#Eval("ServerName")%>
                                                            </strong>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="padding-bottom: 15px;">
                                                            <span>Domain: </span><strong>
                                                                <%#Eval("Domain")%>
                                                            </strong>
                                                        </td>
                                                        <td style="padding-bottom: 15px;">
                                                            <span>Client Name:</span> <strong>
                                                                <%#Eval("Clientname")%>
                                                            </strong>
                                                        </td>
                                                    </tr>
                                                    <asp:HiddenField ID="hidconfigid" runat="server" Value=' <%#Eval("nid")%>' />
                                                    <asp:HiddenField ID="hidserverconfigid" runat="server" />
                                                </ItemTemplate>
                                                <FooterTemplate>
                                                    </table>
                                                </FooterTemplate>
                                            </asp:Repeater>
                                        </div>
                                        <div class="clear">
                                        </div>
                                        <div class="col-xs-12">
                                            <div class="col-xs-12">
                                                <h3 style="padding-top: 0px; padding-bottom: 13px;">
                                                    Server Status</h3>
                                            </div>
                                            <div class="ctrlGroup" style="margin-left:15px;">
                                                <label class="lbl">
                                                    RAM Utilization:<asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server"
                                                        ControlToValidate="rbtnramutilization" ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator>
                                                </label>
                                                <div class="txt w1 mar10">
                                                    <asp:DropDownList ID="rbtnramutilization" runat="server" CssClass="form-control"
                                                        onchange="setcolor(this.id);">
                                                        <asp:ListItem Selected="True" Value="">--Select--</asp:ListItem>
                                                        <asp:ListItem>Low</asp:ListItem>
                                                        <asp:ListItem>Medium</asp:ListItem>
                                                        <asp:ListItem>High</asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="ctrlGroup">
                                                <label class="lbl">
                                                    CPU Utilization:<asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server"
                                                        ControlToValidate="rbtncpuutilization" ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator></label>
                                                <div class="txt w1 mar10">
                                                    <asp:DropDownList ID="rbtncpuutilization" runat="server" CssClass="form-control pad3"
                                                        onchange="setcolor(this.id);">
                                                        <asp:ListItem Selected="True" Value="">--Select--</asp:ListItem>
                                                        <asp:ListItem>Low</asp:ListItem>
                                                        <asp:ListItem>Medium</asp:ListItem>
                                                        <asp:ListItem>High</asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="ctrlGroup">
                                                <label class="lbl">
                                                    Free Space:<asp:RequiredFieldValidator ID="req1" runat="server" ControlToValidate="txt_space"
                                                        ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator>
                                                </label>
                                                <div class="txt w2">
                                                    <asp:TextBox ID="txt_space" runat="server" CssClass="form-control f_left" onkeypress="blockNonNumbers(this, event, true, false);"
                                                        onkeyup="extractNumber(this,2,false);" Style="width: 62%; margin-right: 5px;"></asp:TextBox>
                                                    <asp:DropDownList ID="ddlspece" runat="server" CssClass="form-control f_left" Style="width: 68px;">
                                                        <asp:ListItem>GB</asp:ListItem>
                                                        <asp:ListItem>MB</asp:ListItem>
                                                        <asp:ListItem>TB</asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="clear"></div>
                                            <div class="ctrlGroup" style="margin-left:15px;">
                                                <label class="lbl">
                                                    Updated:</label>
                                                <div class="txt w1">
                                                    <asp:RadioButtonList ID="rdlupdated" runat="server" CssClass="f_left checkboxauto"
                                                        RepeatDirection="Horizontal" RepeatLayout="Flow" onchange="showupdate();">
                                                        <asp:ListItem Value="Yes">Yes</asp:ListItem>
                                                        <asp:ListItem Value="No" Selected="True">No</asp:ListItem>
                                                    </asp:RadioButtonList>
                                                </div>
                                            </div>
                                            <div class="col-xs-12 col-sm-12 form-group f_left pad clear" id="divupdated" runat="server"
                                                style="display: none; float: left;">
                                                <label class="col-sm-3 control-label" style="padding-right: 0px; width: 23%;">
                                                    Update Summary:</label>
                                                <div class="col-sm-9 pad">
                                                    <asp:TextBox ID="txtUpdateSummary" runat="server" CssClass="form-control" TextMode="MultiLine"
                                                        Style="height: 80px;"></asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="ctrlGroup">
                                                <label class="lbl">
                                                    Backup:</label>
                                                <div class="txt w1 mar10">
                                                    <asp:RadioButtonList ID="rdlbackup" runat="server" CssClass="f_left checkboxauto"
                                                        RepeatDirection="Horizontal" RepeatLayout="Flow" onchange="showbackup();">
                                                        <asp:ListItem Value="Yes">Yes</asp:ListItem>
                                                        <asp:ListItem Value="No" Selected="True">No</asp:ListItem>
                                                    </asp:RadioButtonList>
                                                </div>
                                            </div>
                                            <div class="col-xs-12 col-sm-12 form-group f_left pad clear" id="divbackup" runat="server"
                                                style="display: none; float: left;">
                                                <label class="col-sm-3 control-label" style="padding-right: 0px; width: 23%;">
                                                    Backup Description:</label>
                                                <div class="col-sm-9 pad">
                                                    <asp:TextBox ID="txtbackupdescription" runat="server" CssClass="form-control" TextMode="MultiLine"
                                                        Style="height: 80px;"></asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-xs-12">
                                                <h3 style="padding-top: 0px; padding-bottom: 15px;" id="headlogentry" runat="server"
                                                    visible="false">
                                                    Old Log Entry</h3>
                                                <asp:UpdatePanel ID="updatepanel2" runat="server">
                                                    <ContentTemplate>
                                                        <asp:GridView ID="dgnews" runat="server" AllowPaging="false" AutoGenerateColumns="False"
                                                            CellPadding="4" CellSpacing="0" BorderWidth="0px" Width="100%" ShowHeader="true"
                                                            ShowFooter="false" CssClass="tblsheet" GridLines="None" BorderStyle="None" OnRowCommand="dgnews_RowCommand"
                                                            OnRowDataBound="dgnews_RowDataBound" OnRowCancelingEdit="dgnews_RowCancelingEdit"
                                                            OnRowDeleting="dgnews_RowDeleting" OnRowEditing="dgnews_RowEditing" OnRowUpdating="dgnews_RowUpdating">
                                                            <Columns>
                                                                <asp:TemplateField ItemStyle-Width="11px">
                                                                    <ItemTemplate>
                                                                        <asp:LinkButton ID="lbtndelete" CommandName="del" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>'
                                                                            ToolTip="Delete" runat="server"><img src="images/delete.png" alt="Delete" OnClientClick='return confirm("Delete this record? Yes or No");'/></asp:LinkButton>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="S.No." ItemStyle-Width="20px">
                                                                    <ItemTemplate>
                                                                        <%# Container.DataItemIndex + 1 %>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Log Type" ItemStyle-Width="16%">
                                                                    <ItemTemplate>
                                                                        <%# DataBinder.Eval(Container.DataItem, "logtype")%>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <asp:DropDownList ID="ddllog" runat="server" CssClass="form-control">
                                                                            <asp:ListItem>Critical</asp:ListItem>
                                                                            <asp:ListItem>Error</asp:ListItem>
                                                                            <asp:ListItem>Warning</asp:ListItem>
                                                                        </asp:DropDownList>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Event ID" ItemStyle-Width="12%">
                                                                    <ItemTemplate>
                                                                        <%# DataBinder.Eval(Container.DataItem, "eventid")%>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <asp:TextBox ID="txt_eventid" runat="server" CssClass="form-control" Text='<%# DataBinder.Eval(Container.DataItem, "eventid")%>'
                                                                            onchange="binddescription(this.id,this.value);"></asp:TextBox>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Description" ItemStyle-Width="18%">
                                                                    <ItemTemplate>
                                                                        <%# DataBinder.Eval(Container.DataItem, "description")%>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <asp:TextBox ID="txt_description" runat="server" CssClass="form-control" Text='<%# DataBinder.Eval(Container.DataItem, "description")%>'>
                                                                        </asp:TextBox>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Severity Level" ItemStyle-Width="17%">
                                                                    <ItemTemplate>
                                                                        <%# DataBinder.Eval(Container.DataItem, "Severity")%>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <asp:DropDownList ID="ddlseverity" runat="server" CssClass="form-control">
                                                                            <asp:ListItem>Ignorable</asp:ListItem>
                                                                            <asp:ListItem>Need Action</asp:ListItem>
                                                                        </asp:DropDownList>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Action">
                                                                    <ItemTemplate>
                                                                        <%# DataBinder.Eval(Container.DataItem, "ActionPerformed")%>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <asp:DropDownList ID="ddlaction" runat="server" CssClass="form-control">
                                                                            <asp:ListItem>Pending</asp:ListItem>
                                                                            <asp:ListItem>In Process</asp:ListItem>
                                                                            <asp:ListItem>Fixed</asp:ListItem>
                                                                        </asp:DropDownList>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Remark">
                                                                    <ItemTemplate>
                                                                        <%# DataBinder.Eval(Container.DataItem, "remark")%>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <asp:TextBox ID="txt_remark" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "remark")%>'
                                                                            CssClass="form-control"></asp:TextBox>
                                                                        <input type="hidden" id="hidnid1" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "nid")%>' />
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:CommandField InsertVisible="False" ShowDeleteButton="false" ItemStyle-Width="17px"
                                                                    ItemStyle-CssClass="gridedit" ShowEditButton="true" />
                                                            </Columns>
                                                            <HeaderStyle CssClass="gridheader" />
                                                        </asp:GridView>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                                <div class="clear">
                                                </div>
                                                <h3 style="padding-top: 10px; padding-bottom: 15px;">
                                                    Log Entry</h3>
                                                <table width="100%" cellpadding="4" style="border-top: 1px solid #d0d0d0;" cellspacing="0"
                                                    id="tbldata" class="tblsheet">
                                                    <tr class="gridheader">
                                                        <th>
                                                        </th>
                                                        <th>
                                                            S.No.
                                                        </th>
                                                        <th>
                                                            Log Type
                                                        </th>
                                                        <th>
                                                            Event ID
                                                        </th>
                                                        <th>
                                                            Description
                                                        </th>
                                                        <th>
                                                            Severity Level
                                                        </th>
                                                        <th>
                                                            Action
                                                        </th>
                                                        <th>
                                                            Remark
                                                        </th>
                                                    </tr>
                                                    <tr>
                                                        <td width="11px" valign="middle" style="min-width: 11px;">
                                                            <div id="divdel0">
                                                            </div>
                                                        </td>
                                                        <td width="20px">
                                                            <%=strsno%>
                                                        </td>
                                                        <td width="16%">
                                                            <select id="ddllog1" class="form-control pad3">
                                                                <option value="">--Select--</option>
                                                                <option>Critical</option>
                                                                <option>Error</option>
                                                                <option>Warning</option>
                                                            </select>
                                                        </td>
                                                        <td width="15%">
                                                            <input type="text" id="txt_eventid1" class="form-control pad3" onchange="binddescription(this.id,this.value);" />
                                                        </td>
                                                        <td width="25%">
                                                            <input type="text" id="txt_description1" class="form-control pad3" />
                                                        </td>
                                                        <td width="16%">
                                                            <select id="ddlseverity1" class="form-control pad3">
                                                                <option>Ignorable</option>
                                                                <option>Need Action</option>
                                                            </select>
                                                        </td>
                                                        <td width="15%">
                                                            <select id="ddlaction1" class="form-control pad3">
                                                                <option>Pending</option>
                                                                <option>In Process</option>
                                                                <option>Fixed</option>
                                                            </select>
                                                        </td>
                                                        <td width="17%">
                                                            <input type="text" id="txt_remark1" class="form-control pad3" />
                                                        </td>
                                                    </tr>
                                                </table>
                                                <div class="fulldiv">
                                                    <div style="float: right; text-align: right; padding-bottom: 5px; padding-top: 5px;">
                                                        +&nbsp; <a style="text-decoration: underline;" id="addmore" onclick="return addrow();">
                                                            Add new row</a>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-xs-12 clear">
                                                <h3 style="padding-bottom: 15px;">
                                                    Attachments</h3>
                                                <asp:UpdatePanel ID="UpdatePanel6" runat="server">
                                                    <ContentTemplate>
                                                        <asp:Repeater runat="server" ID="repattachment" OnItemCommand="repattachment_ItemCommand">
                                                            <HeaderTemplate>
                                                                <table width="100%" border="0" class="tblsheet" cellpadding="0" cellspacing="0" style="padding-bottom:10px;">
                                                                    <tr class="gridheader">
                                                                        <th>
                                                                            Attachment Title
                                                                        </th>
                                                                        <th>
                                                                            File name
                                                                        </th>
                                                                        <th>
                                                                            &nbsp;
                                                                        </th>
                                                                    </tr>
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <tr class="odd">
                                                                    <td>
                                                                        <%#Eval("title") %>
                                                                    </td>
                                                                    <td>
                                                                        <%#Eval("originalfilename") %>
                                                                    </td>
                                                                    <td style="text-align: center">
                                                                        <asp:LinkButton ID="linkdelete" runat="server" OnClientClick="return confirm('Are you sure to delete this file?');"
                                                                            CommandArgument='<%#Eval("nid") %>' CommandName="delete">   <img src="images/delete.png" alt="delete"></asp:LinkButton>
                                                                        <asp:HiddenField ID="hidattachmentid" runat="server" Value='<%#Eval("attachid") %>' />
                                                                    </td>
                                                                </tr>
                                                            </ItemTemplate>
                                                            <AlternatingItemTemplate>
                                                                <tr class="even">
                                                                    <td>
                                                                        <%#Eval("title") %>
                                                                    </td>
                                                                    <td>
                                                                        <%#Eval("originalfilename") %>
                                                                    </td>
                                                                    <td style="text-align: center">
                                                                        <asp:LinkButton ID="linkdelete" runat="server" OnClientClick="return confirm('Are you sure to delete this file?');"
                                                                            CommandArgument='<%#Eval("nid") %>' CommandName="delete">   <img src="images/delete.png" alt="delete"></asp:LinkButton>
                                                                    </td>
                                                                </tr>
                                                            </AlternatingItemTemplate>
                                                            <FooterTemplate>
                                                                </table>
                                                            </FooterTemplate>
                                                        </asp:Repeater>
                                                        <div class="clear">
                                                        </div>
                                                        <div class="ctrlGroup">
                                                            <label class="lbl">
                                                                Attachment Title:<asp:RequiredFieldValidator ID="RequiredFieldValidator16" runat="server"
                                                                    ErrorMessage="*" ValidationGroup="saveAttachment" ControlToValidate="txtattachmenttitle"
                                                                    CssClass="validation"></asp:RequiredFieldValidator>
                                                            </label>
                                                            <div class="txt w3 mar10">
                                                                <asp:TextBox ID="txtattachmenttitle" runat="server" CssClass="form-control"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                        <div class="col-xs-12 col-sm-6 form-group f_left pad" style="margin-top: 10px">
                                                            <div class="col-xs-12 col-sm-5">
                                                                <cc1:AsyncFileUpload ID="AsyncFileUpload1" ThrobberID="imgLoader" runat="server"
                                                                    Width="200px" UploaderStyle="Traditional" UploadingBackColor="#CCFFFF" OnUploadedComplete="FileUploadComplete"
                                                                    OnClientUploadStarted="uploadStarted" />
                                                                <asp:Image ID="imgLoader" runat="server" ImageUrl="images/loading.gif" /><br />
                                                                <br />
                                                                <img id="imgDisplay" alt="" src="" style="display: none" />
                                                            </div>
                                                            <div>
                                                                <asp:Button ID="btnupload" runat="server" Text="Upload" CssClass="btn btn-default"
                                                                    ValidationGroup="saveAttachment" OnClick="btnupload_Click" />
                                                            </div>
                                                        </div>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                                <div class="clear">
                                                </div>
                                                <div style="margin-bottom: 20px; float: left;">
                                                    <asp:Button ID="btnsubmit" runat="server" CssClass="btn btn-primary" Text="Submit"
                                                        OnClientClick="return validate();" ValidationGroup="save" OnClick="save" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <input type="hidden" id="hidid" runat="server" />
                                <input type="hidden" id="hidrowno" runat="server" />
                                <input type="hidden" id="hidsno" runat="server" />
                                <input type="hidden" id="hidcompanyid" runat="server" />
                                <input type="hidden" id="hidlog" runat="server" />
                                <input type="hidden" id="hidevent" runat="server" />
                                <input type="hidden" id="hiddes" runat="server" />
                                <input type="hidden" id="hidlevel" runat="server" />
                                <input type="hidden" id="hidaction" runat="server" />
                                <input type="hidden" id="hidremark" runat="server" />
                                <input type="hidden" id="hidfilecount" runat="server" value="0" />
                                <input type="hidden" id="hidserverlogid" runat="server" />
                            </div>
                            <div class="clear">
                            </div>
                        </div>

                    </div>
                    <div class="clear">
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <script type="text/javascript">
        function uploadStarted() {
            $get("imgDisplay").style.display = "none";
        }
        function uploadComplete(sender, args) {
            var imgDisplay = $get("imgDisplay");
            imgDisplay.src = "images/loader.gif";
            imgDisplay.style.cssText = "";
            var img = new Image();
            img.onload = function () {
                imgDisplay.style.cssText = "height:100px;width:100px";
                imgDisplay.src = img.src;
            };
            img.src = "<%=ResolveUrl(UploadFolderPath) %>" + args.get_fileName();
        }
    </script>
</asp:Content>
