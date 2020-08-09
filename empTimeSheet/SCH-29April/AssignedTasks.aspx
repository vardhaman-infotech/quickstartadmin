<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="AssignedTasks.aspx.cs" Inherits="empTimeSheet.AssignedTasks" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">

        function saveworkstatus(id) {
            var charindex = id.lastIndexOf("_");
            if (charindex != -1) {
                id = id.substring(0, charindex + 1);

                var status = document.getElementById(id + "ddlstatus").value;
                var remark = document.getElementById(id + "txtremark").value;
                var hour = document.getElementById(id + "txthours").value;
                var nid = document.getElementById(id + "hidnid").value;
                var args = { nid: nid, status: status, remark: remark, hours: hour };

                $.ajax({

                    type: "POST",
                    url: "AssignedTasks.aspx/savestatus",
                    data: JSON.stringify(args),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: true,
                    cache: false,
                    success: function (msg) {

                        msg1 = "success";


                    },
                    error: function (x, e) {
                        alert("The call to the server side failed. " + x.responseText);

                    }


                });
            }

        }
        function savereward(id) {
            $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
            var charindex = id.lastIndexOf("_");
            if (charindex != -1) {
                id = id.substring(0, charindex + 1);

                var grade = document.getElementById(id + "ddlgrade").value;
                var comments = document.getElementById(id + "txtcomments").value;
                var nid = document.getElementById(id + "hidnid").value;
                var remark = document.getElementById(id + "txtremark").value;
                var args = { nid: nid, grade: grade, comments: comments, remark: remark };

                $.ajax({

                    type: "POST",
                    url: "AssignedTasks.aspx/savegrade",
                    data: JSON.stringify(args),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: true,
                    cache: false,
                    success: function (msg) {

                        msg1 = "success";
                        alert("Saved successfully");
                        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                    },
                    error: function (x, e) {
                        alert("The call to the server side failed. " + x.responseText);
                        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();

                    }


                });
            }

        }


        function saveRemark(id) {
            $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
            var charindex = id.lastIndexOf("_");
            if (charindex != -1) {
                id = id.substring(0, charindex + 1);

                //   var grade = document.getElementById(id + "ddlgrade").value;
                //   var comments = document.getElementById(id + "txtcomments").value;
                var nid = document.getElementById(id + "hidnid").value;
                var remark = document.getElementById(id + "txtremark").value;
                var args = { nid: nid, remark: remark };

                $.ajax({

                    type: "POST",
                    url: "AssignedTasks.aspx/save_Remark",
                    data: JSON.stringify(args),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: true,
                    cache: false,
                    success: function (msg) {

                        msg1 = "success";
                        alert("Saved successfully");
                        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                    },
                    error: function (x, e) {
                        alert("The call to the server side failed. " + x.responseText);
                        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();

                    }


                });
            }

        }
    </script>
    <script type="text/javascript">

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

        //Open Set Status div
        function openstatusdiv() {
            setposition("divstatus");
            document.getElementById("divstatus").style.display = "block";
            document.getElementById("otherdiv").style.display = "block";
        }
      
     
    </script>
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
            var strname = "";
            var tolistbox = document.getElementById('ctl00_ContentPlaceHolder1_listcode2');
            if (tolistbox.options.length > 0) {
                for (k = 0; k < tolistbox.options.length; k++) {

                    strval += tolistbox.options[k].value + ',';
                    strname += tolistbox.options[k].innerHTML + ',';

                }

            }

            document.getElementById('ctl00_ContentPlaceHolder1_hidtasks').value = strval;
            document.getElementById('ctl00_ContentPlaceHolder1_hidtaskname').value = strname;
            searchtask();
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
        function validate1(source, args) {

            var id = "ctl00_ContentPlaceHolder1_listcode2";

            var numofelemadded = document.getElementById(id).options.length;

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
        function scrolltotopofList() {
            var divPosition = $('#ctl00_ContentPlaceHolder1_dgnews').offset();
            $('html, body').animate({ scrollTop: divPosition.top }, "fast");
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <pg:progress ID="progress1" runat="server" />
    <div class="heading">
        <h1>
            Assigned Tasks
        </h1>
        <div class="f_right">
            <a id="liaddnew" runat="server" class="add_new" onclick="opendiv();">
                <img src="images/add.png" alt="add new">
                Assign New Task</a>
            <%--  <asp:LinkButton id="liaddnew" runat="server" class="add_new" OnClick="lbtnadd_newClick">
                        <img src="images/add.png" alt="add new">
                        Assign New Task </asp:LinkButton>--%>
            <asp:LinkButton ID="btnexportcsv" runat="server" OnClick="btnexportcsv_Click" CssClass="add_new"><img src="images/excel.png" alt="add new" />Export to Excel</asp:LinkButton>
            <asp:LinkButton ID="lnkrefresh" runat="server" OnClick="btnrefresh_Click" CssClass="add_new"><img src="images/refresh.png" alt="add new" />Refresh</asp:LinkButton>
        </div>
    </div>
    <div class="clear">
    </div>
    <div class="divsearch">
        <label class="lblsearch">
            Form Date</label>
        <asp:TextBox ID="txtfromdate" runat="server" CssClass="search date"></asp:TextBox>
        <cc1:CalendarExtender ID="cc1" runat="server" TargetControlID="txtfromdate" PopupButtonID="txtfromdate"
            Format="MM/dd/yyyy">
        </cc1:CalendarExtender>
        <label class="lblsearch">
            To Date</label>
        <asp:TextBox ID="txttodate" runat="server" CssClass="search date"></asp:TextBox>
        <cc1:CalendarExtender ID="cc2" runat="server" TargetControlID="txttodate" PopupButtonID="txttodate"
            Format="MM/dd/yyyy">
        </cc1:CalendarExtender>
        <label class="lblsearch">
            Employee</label>
        <asp:DropDownList ID="dropemployee" runat="server" CssClass="searchdropbox last">
        </asp:DropDownList>
        <div class="clear">
        </div>
        <asp:UpdatePanel ID="updatePanelSearch" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <label class="lblsearch">
                    Client</label>
                <asp:DropDownList ID="dropclient" runat="server" CssClass="searchdropbox" AutoPostBack="true"
                    OnSelectedIndexChanged="dropclient_OnSelectedIndexChanged">
                </asp:DropDownList>
                <label class="lblsearch">
                    Project</label>
                <asp:DropDownList ID="dropproject" runat="server" CssClass="searchdropbox">
                </asp:DropDownList>
            </ContentTemplate>
            <%-- <Triggers>
            <asp:PostBackTrigger ControlID="btnexportcsv" />
        </Triggers>--%>
        </asp:UpdatePanel>
        <label class="lblsearch">
            Task</label>
        <asp:DropDownList ID="droptask" runat="server" CssClass="searchdropbox">
        </asp:DropDownList>
        <div class="clear">
        </div>
        <label class="lblsearch">
            Status</label>
        <asp:DropDownList ID="dropstatus" runat="server" CssClass="searchdropbox">
            <asp:ListItem Value="">--All Status--</asp:ListItem>
            <asp:ListItem>Not Started</asp:ListItem>
            <asp:ListItem>In Process</asp:ListItem>
            <asp:ListItem>Partially Completed</asp:ListItem>
            <asp:ListItem>Completed</asp:ListItem>
        </asp:DropDownList>
        <label class="lblsearch">
            Manager</label>
        <asp:DropDownList ID="dropassign" runat="server" CssClass="searchdropbox">
        </asp:DropDownList>
        <%-- <label class="lblsearch">
            Assigned By</label>
        <asp:DropDownList ID="dropassignedby" runat="server" CssClass="searchdropbox">
        </asp:DropDownList>--%>
        <asp:Button ID="btnsearch" runat="server" Text="Search" CssClass="button" OnClick="btnsearch_Click" />
        <div class="clear">
        </div>
    </div>
    <div class="clear">
    </div>
    <asp:UpdatePanel ID="updatePanelData" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="false">
        <ContentTemplate>
            <div id="otherdiv" onclick="closediv();">
            </div>
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
            <div class="f_left" style="width: 100%; padding-top: 25px;">
                <div class="nodatafound" id="divnodata" runat="server">
                    No data found</div>
                <asp:GridView ID="dgnews" runat="server" AllowPaging="true" OnRowDataBound="dgnews_RowDataBound"
                    OnRowCommand="dgnews_RowCommand" AutoGenerateColumns="False" CellPadding="4"
                    PageSize="50" CellSpacing="0" Width="100%" ShowHeader="true" ShowFooter="false"
                    CssClass="tblsheet" GridLines="None" AllowSorting="true" OnSorting="dgnews_Sorting"
                    OnPageIndexChanging="dgnews_PageIndexChanging">
                    <Columns>
                        <asp:TemplateField HeaderText="">
                            <ItemTemplate>
                                <img id="imgassignedby" runat="server" style="padding-top: 5px;" src="" title='<%# DataBinder.Eval(Container.DataItem, "assignedbyid")%>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="62px">
                            <ItemTemplate>
                                <%# Container.DataItemIndex + 1 %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Date" HeaderStyle-Width="8%" SortExpression="date">
                            <ItemTemplate>
                                <%# DataBinder.Eval(Container.DataItem, "date")%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Employee" HeaderStyle-Width="8%" SortExpression="empname">
                            <ItemTemplate>
                                <%# DataBinder.Eval(Container.DataItem, "empname")%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <%-- <asp:TemplateField HeaderText="Client" ItemStyle-Width="15%" SortExpression="clientname">
                            <ItemTemplate>
                                <%# DataBinder.Eval(Container.DataItem, "clientname")%>
                            </ItemTemplate>
                        </asp:TemplateField>--%>
                        <asp:TemplateField HeaderText="Project ID" HeaderStyle-Width="8%" SortExpression="projectCode">
                            <ItemTemplate>
                                <%# DataBinder.Eval(Container.DataItem, "projectCode")%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Task ID" HeaderStyle-Width="8%" SortExpression="taskcodename">
                            <ItemTemplate>
                                <%# DataBinder.Eval(Container.DataItem, "taskcodename")%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Description" HeaderStyle-Width="10%">
                            <ItemTemplate>
                                <%# DataBinder.Eval(Container.DataItem, "task")%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Remark">
                            <ItemTemplate>
                                <asp:Literal ID="ltrremark" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "remark")%>'
                                    Visible="false"></asp:Literal>
                                <asp:TextBox ID="txtremark" TextMode="MultiLine" runat="server" onchange="saveRemark(this.id);"
                                    Width="90px" Text='<%# DataBinder.Eval(Container.DataItem, "remark")%>' Height="30px"
                                    MaxLength="200"></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="B-Hours" HeaderStyle-Width="5%">
                            <ItemTemplate>
                                <%# DataBinder.Eval(Container.DataItem, "bhours")%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="TimeTaken">
                            <ItemTemplate>
                                <asp:Literal ID="ltrhours" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "totalhour")%>'></asp:Literal>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status" HeaderStyle-Width="8%">
                            <ItemTemplate>
                                <asp:Literal ID="ltrstatus" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "status")%>'></asp:Literal>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Manager" HeaderStyle-Width="8%">
                            <ItemTemplate>
                                <%# DataBinder.Eval(Container.DataItem, "managername")%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Grade" HeaderStyle-Width="5%">
                            <ItemTemplate>
                                <asp:Literal ID="ltrgrade" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "grade")%>'
                                    Visible="false"></asp:Literal>
                                <asp:DropDownList ID="ddlgrade" runat="server" onchange="savereward(this.id);" Width="80px">
                                    <asp:ListItem></asp:ListItem>
                                    <asp:ListItem>Excellent</asp:ListItem>
                                    <asp:ListItem>Good</asp:ListItem>
                                    <asp:ListItem>Average</asp:ListItem>
                                    <asp:ListItem>Below Average</asp:ListItem>
                                    <asp:ListItem>Poor</asp:ListItem>
                                </asp:DropDownList>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Comments" HeaderStyle-Width="5%">
                            <ItemTemplate>
                                <asp:Literal ID="ltrcomments" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "comments")%>'
                                    Visible="false"></asp:Literal>
                                <asp:TextBox ID="txtcomments" TextMode="MultiLine" runat="server" onchange="savereward(this.id);"
                                    Width="90px" Text='<%# DataBinder.Eval(Container.DataItem, "comments")%>' Height="30px"
                                    MaxLength="200"></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="" ItemStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle">
                            <ItemTemplate>
                                <asp:LinkButton ID="lbtnstatus" runat="server" Visible="true" ToolTip="View Status"
                                    CommandArgument='<%#Eval("nid") + ";" + Eval("status") + ";" + Eval("empid") %>'
                                    CommandName="SetStatus"><img src="images/viewstatus.png" height="20" /></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-Width="20px" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <input type="hidden" id="hidnid" runat="server" value='<%#DataBinder.Eval(Container.DataItem,"nid")%>' />
                                <asp:LinkButton ID="lbtndelete" CommandName="del" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>'
                                    ToolTip="Delete" runat="server" OnClientClick='return confirm("Delete this record? Yes or No");'><img src="images/delete_red.png" alt="Delete" /></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        No Assigned task</EmptyDataTemplate>
                    <HeaderStyle CssClass="gridheader" />
                    <RowStyle CssClass="odd" />
                    <AlternatingRowStyle CssClass="even" />
                    <EmptyDataRowStyle CssClass="nodatafound" />
                    <PagerStyle CssClass="gridpager" HorizontalAlign="Center" />
                </asp:GridView>
            </div>
            <input type="hidden" id="hidsearchfromdate" runat="server" />
            <input type="hidden" id="hidsearchtodate" runat="server" />
            <input type="hidden" id="hidsearchdropemployee" runat="server" />
            <input type="hidden" id="hidsearchdropclient" runat="server" />
            <input type="hidden" id="hidsearchdropproject" runat="server" />
            <input type="hidden" id="hidsearchdroptask" runat="server" />
            <input type="hidden" id="hidsearchdropstatus" runat="server" />
            <input type="hidden" id="hidsearchdroassign" runat="server" />

             <input type="hidden" id="hidsearchdropemployeename" runat="server" />
            <input type="hidden" id="hidsearchdropclientname" runat="server" />
            <input type="hidden" id="hidsearchdropprojectname" runat="server" />
            <input type="hidden" id="hidsearchdroptaskname" runat="server" />
            <input type="hidden" id="hidsearchdropstatusname" runat="server" />
            <input type="hidden" id="hidsearchdroassignname" runat="server" />
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnsearch" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="lnkrefresh" EventName="Click" />
        </Triggers>
    </asp:UpdatePanel>
    <div class="clear">
    </div>
    <input type="hidden" id="hiduserid" runat="server" />
    <input type="hidden" id="hidempid" runat="server" />

    <!---ADD NEW div goes here-->
    <asp:UpdatePanel ID="updatePanelAssign" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div style="display: none; width: 680px;" runat="server" id="divaddnew" class="itempopup">
                <div class="popup_heading">
                    <span id="legendaction" runat="server">Assign Task </span>
                    <div class="f_right">
                        <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
                    </div>
                </div>
                <div class="innerpopup">
                    <label>
                        Date:
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtscheduledate"
                            ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator></label>
                    <asp:TextBox ID="txtscheduledate" runat="server" CssClass="popinputsmall date" Style="padding-right: 5px;
                        width: 158px;"></asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtscheduledate"
                        PopupButtonID="txtscheduledate" Format="MM/dd/yyyy">
                    </cc1:CalendarExtender>
                    <div class="clear">
                    </div>
                    <label>
                        Employee:
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="ddlemployee"
                            ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator></label>
                    <asp:DropDownList ID="ddlemployee" runat="server" CssClass="popinputsmall" Style="margin-right: 20px;
                        width: 175px;">
                    </asp:DropDownList>
                    <label>
                        Manager:
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="ddlmanager"
                            ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator></label>
                    <asp:DropDownList ID="ddlmanager" runat="server" CssClass="popinputsmall" Style="margin-right: 20px;
                        width: 158px;">
                    </asp:DropDownList>
                    <div class="clear">
                    </div>
                    <asp:UpdatePanel ID="updpanl" runat="server">
                        <ContentTemplate>
                            <label>
                                Client:
                                <asp:RequiredFieldValidator ID="req1" runat="server" ControlToValidate="ddlclient"
                                    ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator></label>
                            <asp:DropDownList ID="ddlclient" runat="server" CssClass="popinput" AutoPostBack="true"
                                OnSelectedIndexChanged="ddlclient_SelectedIndexChanged">
                            </asp:DropDownList>
                            <div class="clear">
                            </div>
                            <label>
                                Project:
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="ddlproject"
                                    ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator></label>
                            <asp:DropDownList ID="ddlproject" runat="server" CssClass="popinput">
                            </asp:DropDownList>
                            <div class="clear">
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    <label>
                        Select Tasks:
                        <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="*" ValidationGroup="save"
                            CssClass="errmsg" ClientValidationFunction="validate1"></asp:CustomValidator></label>
                    <asp:TextBox ID="txtsearchtask" runat="server" placeholder="Search Task by keyword"
                        onkeyup="searchtask();" CssClass="popinputtxt"></asp:TextBox>
                    <div class="clear">
                    </div>
                    <div class="padtop10">
                        <div class="clear">
                        </div>
                        <asp:ListBox ID="listcode1" runat="server" Width="260px" Height="200px" SelectionMode="Multiple"
                            CssClass="RadListBox1"></asp:ListBox>
                        <input type="hidden" id="hidtasks" runat="server" />
                        <input type="hidden" id="hidtaskname" runat="server" />
                        <div class="f_left" style="padding: 20px; text-align: center;">
                            <div class="f_left">
                                <input type="button" onclick="move(this.form.ctl00_ContentPlaceHolder1_listcode1,this.form.ctl00_ContentPlaceHolder1_listcode2)"
                                    class="btnadd" value="Add" id="Button1" />
                            </div>
                            <div class="clear">
                            </div>
                            <div class="f_left padtop10">
                                <input type="button" onclick="move(this.form.ctl00_ContentPlaceHolder1_listcode2,this.form.ctl00_ContentPlaceHolder1_listcode1)"
                                    class="btnadd" value="Remove" id="Button2" />
                            </div>
                        </div>
                        <div class="f_left">
                            <asp:ListBox ID="listcode2" runat="server" Width="260px" Height="200px" SelectionMode="Multiple"
                                CssClass="listcode2"></asp:ListBox>
                        </div>
                    </div>
                    <div class="clear">
                    </div>
                    <div class="padtop10">
                        <asp:Button ID="btnsubmit" runat="server" ValidationGroup="save" CssClass="button"
                            Text="Save" OnClick="btnsubmit_Click" />
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <!--Status Div goes here-->
    <asp:UpdatePanel ID="updatePanelStatus" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <input type="hidden" id="hidid" runat="server" />
            <input type="hidden" id="hidstatusid" runat="server" />
            <input type="hidden" id="hidcurrentemp" runat="server" />
            <div id="divstatus" class="itempopup" style="width: 680px;">
                <div class="popup_heading">
                    <span id="spanstatushead" runat="server">Task Status</span>
                    <div class="f_right">
                        <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
                    </div>
                </div>
                <div class="innerpopup">
                    <div id="divprestatus" runat="server">
                        <div class="f_left">
                            <b>Status Details </b>
                        </div>
                        <div class="clear">
                        </div>
                        <div class="line" style="margin-top: 3px;">
                        </div>
                        <asp:Repeater ID="rptstatus" runat="server" OnItemDataBound="rptstatus_OnItemDataBound"
                            OnItemCommand="rptstatus_OnItemCommand">
                            <HeaderTemplate>
                                <table cellspacing="0" cellpadding="4" border="1" style="width: 100%;" class="tblsheet">
                                    <tbody>
                                        <tr class="gridheader">
                                            <td width="15%">
                                                Date
                                            </td>
                                            <td width="20%">
                                                Status
                                            </td>
                                            <td width="15%">
                                                Time Taken
                                            </td>
                                            <td>
                                                Emp Remark
                                            </td>
                                            <td>
                                            </td>
                                            <td>
                                            </td>
                                        </tr>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr class="odd">
                                    <td width="15%">
                                        <%#Eval("statusdate")%>
                                    </td>
                                    <td width="20%">
                                        <%#Eval("Status")%>
                                    </td>
                                    <td width="15%">
                                        <%#Eval("TimeTaken")%>
                                    </td>
                                    <td>
                                        <%#Eval("remark")%>
                                    </td>
                                    <td width="7%">
                                        <asp:LinkButton ID="lbtnedit" CommandName="edititem" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>'
                                            ToolTip="Click here to edit" runat="server"><img src="images/edit.png" alt="edit" /></asp:LinkButton>&nbsp;
                                        <asp:LinkButton ID="lbtndelete" CommandName="del" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>'
                                            ToolTip="Delete" runat="server" OnClientClick='return confirm("Delete this record? Yes or No");'><img src="images/delete_red.png" alt="Delete" /></asp:LinkButton>
                                    </td>
                                </tr>
                            </ItemTemplate>
                            <FooterTemplate>
                                </table>
                            </FooterTemplate>
                        </asp:Repeater>
                        <div class="clear">
                        </div>
                        <div class="nodatafound" id="divnodataforpreviousstatus" runat="server">
                            No status exists</div>
                        <%-- <div class="line" style="margin-top:3px;">
                        </div>--%>
                    </div>
                    <div class="clear">
                    </div>
                    <div class="padtop10" id="divnewstatus" runat="server">
                        <div class="f_left padtop10">
                            <b>New Status </b>
                        </div>
                        <div class="clear">
                        </div>
                        <label class="popuplabel">
                            Date:
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtnewdate"
                                ValidationGroup="savestatus" ErrorMessage="*"></asp:RequiredFieldValidator>
                        </label>
                        <div class="f_left">
                            <asp:TextBox ID="txtnewdate" runat="server" CssClass="popinputsmall date" Style="width: 140px;
                                margin-right: 20px;"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtnewdate"
                                PopupButtonID="txtnewdate" Format="MM/dd/yyyy">
                            </cc1:CalendarExtender>
                        </div>
                        <label class="popuplabel">
                            Time Taken:
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="txtTime"
                                ValidationGroup="savestatus" ErrorMessage="*"></asp:RequiredFieldValidator>
                        </label>
                        <div class="f_left">
                            <asp:TextBox ID="txtTime" runat="server" CssClass="popinputsmall" Style="width: 40px;
                                margin-right: 20px;" onkeypress="blockNonNumbers(this, event, true, false);"
                                onblur="fill(this.id);" onkeyup="extractNumber(this,2,false);"></asp:TextBox>
                        </div>
                        <label class="popuplabel">
                            Status:
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ControlToValidate="ddlstaus"
                                ValidationGroup="savestatus" ErrorMessage="*"></asp:RequiredFieldValidator>
                        </label>
                        <div class="f_left">
                            <asp:DropDownList ID="ddlstaus" runat="server" CssClass="popinputsmall" Style="width: 135px;">
                                <asp:ListItem>Not Started</asp:ListItem>
                                <asp:ListItem>In Process</asp:ListItem>
                                <asp:ListItem>Partially Completed</asp:ListItem>
                                <asp:ListItem>Completed</asp:ListItem>
                            </asp:DropDownList>
                            <input type="hidden" id="hidIsUpdateStatus" runat="server" />
                        </div>
                        <div class="clear">
                        </div>
                        <label class="popuplabel">
                            Remark:
                        </label>
                        <asp:TextBox ID="txtremark" runat="server" TextMode="MultiLine" Style="height: 80px;
                            width: 545px;" CssClass="popinput"></asp:TextBox>
                        <div class="clear">
                        </div>
                        <div class="padtop10">
                            <label class="popuplabel">
                                &nbsp;</label>
                            <asp:Button ID="btnsave" runat="server" Text="Save" ValidationGroup="savestatus"
                                CssClass="button" OnClick="btnsave_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <script type="text/javascript">
        function searchtask() {
            var keyword = $('#ctl00_ContentPlaceHolder1_txtsearchtask').val();

            $("#ctl00_ContentPlaceHolder1_listcode1 > option").each(function () {
                if (keyword == "") {
                    $(this).css("display", "block");
                }
                else {

                    if (this.text.toLowerCase().indexOf(keyword.toLowerCase()) >= 0) {
                        $(this).css("display", "block");
                    }
                    else {
                        $(this).css("display", "none");
                    }

                }

            });
        }

        $('#ctl00_ContentPlaceHolder1_txtsearchtask').keypress(function (e) {
            if (e.keyCode == 13) {
                e.preventDefault();

                return false;
            }
        });
    
    </script>
</asp:Content>
