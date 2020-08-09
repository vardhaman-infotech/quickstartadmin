<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="timesheetreport.aspx.cs" Inherits="empTimeSheet.timesheetreport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="css/jquery.dataTables.min.css" />
    <script src="js/jquery.min.js"></script>
    <script type="text/javascript" src="js/jquery.dataTables.min.js"></script>
    <script type="text/javascript">

        function showcustomdate(id) {

            if (document.getElementById(id).value == "Custom") {
                document.getElementById("divdate").style.display = "block";
            }
            else {
                document.getElementById("divdate").style.display = "none";
            }
        }
        function fixheader() {

            $.getScript("js/colResizable-1.6.js", function () {

                $("#ctl00_ContentPlaceHolder1_dgnews").colResizable({
                    liveDrag: true,
                    gripInnerHtml: "<div class='grip'></div>",
                    draggingClass: "dragging",
                    resizeMode: 'fit'
                });

                $('#ctl00_ContentPlaceHolder1_dgnews').dataTable({
                    "dom": 'lrtip',
                    "pageLength": 100,
                    'aoColumnDefs': [{
                        'bSortable': false,
                        'aTargets': [-1] /* 1st one, start by the right */
                    }]
                });

            });


        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <pg:progress ID="progress1" runat="server" />
    <div class="pageheader">
        <h2>
            <i class="fa fa-clipboard"></i>Employee Timesheet Report
        </h2>
        <div class="breadcrumb-wrapper mar ">
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
                        <div style="padding-top: 10px;">

                            <div class="clear"></div>
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl lbl2">Date Range :</label>
                                <div class="txt w1 mar10">
                                    <asp:DropDownList ID="dropdaterange" runat="server" CssClass="form-control" onchange="showcustomdate(this.id);">
                                        <asp:ListItem Text="Quarterly" Value="Quarterly"></asp:ListItem>
                                        <asp:ListItem Text="Monthly" Value="Monthly"></asp:ListItem>
                                        <asp:ListItem Text="Biweekly" Value="Biweekly"></asp:ListItem>
                                        <asp:ListItem Text="Weekly" Value="Weekly"></asp:ListItem>
                                        <asp:ListItem Text="Custom" Value="Custom"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>  <div class="clear"></div>
                         
                            <div class="clear"></div>
                            <div id="divdate" style="display: none;">

                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl lbl2">
                                        From Date :
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:TextBox ID="txtfrmdate" runat="server" CssClass="form-control hasDatepicker" onchange="comparedate(this.id,'ctl00_ContentPlaceHolder1_txtfrmdate','ctl00_ContentPlaceHolder1_txttodate');"></asp:TextBox>

                                        <cc1:CalendarExtender ID="txtDate_CalendarExtender" runat="server" TargetControlID="txtfrmdate"
                                            PopupButtonID="txtfrmdate" Format="MM/dd/yyyy">
                                        </cc1:CalendarExtender>
                                    </div>

                                </div> <div class="clear"></div>
                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl lbl2">
                                        To Date :
                                    </label>
                                    <div class="txt w1">
                                        <asp:TextBox ID="txttodate" runat="server" CssClass="form-control hasDatepicker pad3" onchange="comparedate(this.id,'ctl00_ContentPlaceHolder1_txtfrmdate','ctl00_ContentPlaceHolder1_txttodate');"></asp:TextBox>

                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txttodate"
                                            PopupButtonID="txttodate" Format="MM/dd/yyyy">
                                        </cc1:CalendarExtender>
                                    </div>
                                </div>
                                <div class="clear"></div>
                            </div>
                            <div class="clear"></div>
                               <div class="ctrlGroup searchgroup">
                                <label class="lbl lbl2">Client :</label>
                                <div class="txt w2 mar10">
                                    <asp:TextBox ID="txtclient" runat="server" CssClass="form-control" ClientIDMode="Static" placeholder="--All Clients--" onkeypress="searchfilters(this.id,'dropclient');" onkeyup="searchfilters(this.id,'dropclient');" onkeydown="searchfilters(this.id,'dropclient');">
                                    </asp:TextBox>

                                    <ajaxToolkit:PopupControlExtender ID="PopupControlExtender1" runat="server" TargetControlID="txtclient"
                                        PopupControlID="panelclient" Position="Bottom">
                                    </ajaxToolkit:PopupControlExtender>
                                    <asp:Panel ID="panelclient" runat="server" CssClass="poppanel">

                                        <input type="checkbox" id="chkclient" onclick="checkall(this.id, 'dropclient', '--All Clients--', 'txtclient', 'client');" />
                                        <span>Check All</span><div class="clear"></div>
                                        <asp:CheckBoxList ID="dropclient" runat="server" RepeatLayout="UnorderedList" ClientIDMode="Static" onchange="setcontent(this.id,'txtclient','--All Clients--','client');"></asp:CheckBoxList>

                                    </asp:Panel>
                                </div>

                            </div>
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl lbl2">Project :</label>
                                <div class="txt w2">
                                    <asp:TextBox ID="txtproject" runat="server" CssClass="form-control" ClientIDMode="Static" placeholder="--All Projects--" onkeypress="searchfilters(this.id,'dropproject');" onkeyup="searchfilters(this.id,'dropproject');" onkeydown="searchfilters(this.id,'dropproject');">
                                    </asp:TextBox>

                                    <ajaxToolkit:PopupControlExtender ID="PopupControlExtender2" runat="server" TargetControlID="txtproject"
                                        PopupControlID="pnlproject" Position="Bottom">
                                    </ajaxToolkit:PopupControlExtender>
                                    <asp:Panel ID="pnlproject" runat="server" CssClass="poppanel">

                                        <input type="checkbox" id="chkproject" onclick="checkall(this.id, 'dropproject', '--All Projects--', 'txtproject', 'project');" />
                                        <span>Check All</span><div class="clear"></div>
                                        <asp:CheckBoxList ID="dropproject" runat="server" RepeatLayout="UnorderedList" RepeatDirection="Vertical" RepeatColumns="1" ClientIDMode="Static" onchange="setcontent(this.id,'txtproject','--All Projects--','project');"></asp:CheckBoxList>

                                    </asp:Panel>
                                </div>
                            </div>
                             <div class="clear"></div>
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl lbl2">Employee :</label>
                                <div class="txt w2 mar10">
                                    <asp:TextBox ID="txtemployee" runat="server" CssClass="form-control " placeholder="--All Employee--" ClientIDMode="Static" onkeypress="searchfilters(this.id,'dropemployee');" onkeyup="searchfilters(this.id,'dropemployee');" onkeydown="searchfilters(this.id,'dropemployee');">
                                    </asp:TextBox>


                                    <ajaxToolkit:PopupControlExtender ID="PceSelectCustomer" runat="server" TargetControlID="txtemployee"
                                        PopupControlID="panelemployee" Position="Bottom">
                                    </ajaxToolkit:PopupControlExtender>

                                    <asp:Panel ID="panelemployee" runat="server" CssClass="poppanel">

                                        <input type="checkbox" id="chkemp" onclick="checkall(this.id, 'dropemployee', '--All Employees--', 'txtemployee', 'employee');" />
                                        <span>Check All</span><div class="clear"></div>
                                        <asp:CheckBoxList ID="dropemployee" runat="server" RepeatLayout="UnorderedList" RepeatDirection="Vertical" ClientIDMode="Static" onchange="setcontent(this.id,'txtemployee','--All Employee--','employee');"></asp:CheckBoxList>

                                    </asp:Panel>
                                </div>
                            </div>
                               
                            <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl2">&nbsp;</label>
                                        <div class="txt w1 mar10">
                                            <asp:CheckBox ID="chkmemo" runat="server" Text="Show Memo" Checked="true" CssClass="chkboxnew" />
                                        </div>
                                    </div>
                                    <div class="ctrlGroup searchgroup">
                                       
                                        <div class="txt w1 ">
                                            <asp:Button ID="btnsearch" runat="server" Text="View Report" CssClass="btn btn-default "
                                                OnClick="btnsearch_Click" />
                                        </div>
                                    </div>

                                </ContentTemplate>
                            </asp:UpdatePanel>


                        </div>
                    </div>
                    <div class="clear">
                    </div>
                    <div style="width: 640px;" id="divmemo" class="itempopup">
                        <div class="popup_heading">
                            <span id="Span2" runat="server">Memo</span>
                            <div class="f_right">
                                <img src="images/cross.png" onclick="closediv();" alt="X"
                                    title="Close Window" />
                            </div>
                        </div>
                        <div style="padding: 10px;">

                            <div id="ltrmemo"  style="height: 250px; overflow-y: auto;">
                            </div>

                            <div class="pad2">


                                <%--<input type="button" id="btnsavememo" class="btn btn-primary" onclick="addmemo();" value="Add Memo" />--%>
                                <input type="button" id="btncancelalert" class="btn
            btn-primary"
                                    value="Close" onclick="closediv();" />

                            </div>
                        </div>
                    </div>
                    <div class="col-sm-12 col-md-12 mar2">
                        <asp:UpdatePanel ID="updatePanelData" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="false">
                            <ContentTemplate>
                                <div id="otherdiv" onclick="closediv();">
                                </div>


                                <div class="panel panel-default">
                                    <div class="panel-body2 ">
                                        <div class="row">
                                            <div class="table-responsive">
                                                <div class="nodatafound" id="divnodata" runat="server">
                                                    No data found
                                                </div>
                                                <div>
                                                    <asp:GridView ID="dgnews" runat="server" AutoGenerateColumns="False"
                                                        CellPadding="4" CellSpacing="0" Width="100%" ShowHeader="true"
                                                        ShowFooter="false" CssClass="tblreport" GridLines="None" OnRowDataBound="dgnews_RowDataBound">
                                                        <Columns>
                                                            <%-- <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="42px" ItemStyle-CssClass="tdsno"
                                            HeaderStyle-CssClass="tdsno">
                                            <ItemTemplate>
                                                <%# Container.DataItemIndex + 1 %>
                                            </ItemTemplate>
                                        </asp:TemplateField>--%>
                                                            <asp:TemplateField HeaderText="AssignDate" HeaderStyle-Width="90px" SortExpression="date">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "date")%>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="EmpID" HeaderStyle-Width="70px" SortExpression="loginid">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "loginid")%>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Employee" HeaderStyle-Width="120px" SortExpression="empname">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "empname")%>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="ProjectID" HeaderStyle-Width="90px" SortExpression="projectCode">
                                                                <ItemTemplate>
                                                                    <span title='<%# DataBinder.Eval(Container.DataItem, "projectname")%>'>
                                                                        <%# DataBinder.Eval(Container.DataItem, "projectCode")%></span>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="TaskID" HeaderStyle-Width="140px" SortExpression="taskcodename">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "taskcodename")%>: <%# DataBinder.Eval(Container.DataItem, "task")%>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Emp Remark">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "description")%>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Memo" HeaderStyle-Width="150px" SortExpression="memo" >
                                                                <ItemTemplate>

                                                                    <div onclick="showmemo($(this).html())" title="Click here to view memo" style="cursor:pointer;"><%# DataBinder.Eval(Container.DataItem, "memo")%></div>

                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="B-Hours" HeaderStyle-Width="65px">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "bhours")%>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Hours" HeaderStyle-Width="65px">
                                                                <ItemTemplate>
                                                                    <asp:Literal ID="ltrhours" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "hours")%>'></asp:Literal>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Status" HeaderStyle-Width="87px" SortExpression="taskstatus">
                                                                <ItemTemplate>
                                                                    <asp:Literal ID="ltrstatus" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "taskstatus")%>'></asp:Literal>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>

                                                        </Columns>
                                                        <HeaderStyle CssClass="gridheader" />
                                                        <PagerStyle CssClass="gridpager" HorizontalAlign="Center" />
                                                    </asp:GridView>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <input type="hidden" id="hidsprojectid" runat="server" />
                                <input type="hidden" id="hidsclientid" runat="server" />
                                <input type="hidden" id="hidsemployeeid" runat="server" />
                                <input type="hidden" id="hidfromdate" runat="server" />
                                <input type="hidden" id="hidtodate" runat="server" />
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="btnsearch" EventName="Click" />
                                <asp:AsyncPostBackTrigger ControlID="lnkrefresh" EventName="Click" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </div>
                    <div class="clear">
                    </div>
                </div>
                <!--Panel-default-->
            </div>
            <!---col-sm-12 col-md-12-->
        </div>
        <!---row-->
    </div>
    <!---contentpanel-->
    <script>
        function showmemo(html)
        {
            $('#ltrmemo').html(html);
            setposition("divmemo");
            document.getElementById("divmemo").style.display = "block";
            document.getElementById("otherdiv").style.display = "block";
        }
        function closediv()
        {
            document.getElementById("divmemo").style.display = "none";
            document.getElementById("otherdiv").style.display = "none";
        }
    </script>
</asp:Content>
