<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="WorkAllocation.aspx.cs" Inherits="empTimeSheet.WorkAllocation" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<style type="text/css">
    .form-control1
    {
        border-radius:0px;
        box-shadow:none;        
    }
    .tblreport td{
        padding:6px 4px;
        white-space:nowrap;
        text-wrap:none;
    }
</style>
   
    <link rel="stylesheet" href="css/jquery-ui.css" />
    

    <script type="text/javascript" src="js/jquery-ui.js"></script>
    <script src="js/colResizable-1.6.js"></script>
         <script src="js/assigntask2.6.js" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <pg:progress ID="progress1" runat="server" />
    <div class="pageheader">
        <h2>
            <i class="fa fa-tasks"></i>      Work Allocation
        </h2>
        <div class="breadcrumb-wrapper mar ">
            <a id="liaddnew" runat="server" class="right_link" onclick="opendiv();"><i class="fa fa-fw fa-plus topicon">
            </i>Assign New Task</a>
            <asp:LinkButton ID="btnexportcsv" runat="server" OnClick="btnexportcsv_Click" CssClass="right_link">
              <i class="fa fa-fw fa-file-excel-o topicon"></i>Export to Excel
            </asp:LinkButton>
            <a id="lnkrefresh" onclick="searchdata();" class="right_link"><i class="fa fa-fw fa-refresh topicon">
            </i>Refresh</a>
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
                            <div class="col-xs-12 col-sm-12 col-md-12 f_left" style="padding: 0px;">
                                <h5 class="subtitle mb5">
                               Work Allocation </h5>
                            </div>
                            <div class="ctrlGroup searchgroup">
                              <label class="lbl lbl2">From Date :</label>
                                <div class="txt w1 mar10">
                                    <asp:TextBox ID="txtfromdate" runat="server" CssClass="form-control hasDatepicker"></asp:TextBox>
                                    <cc1:CalendarExtender ID="cc1" runat="server" TargetControlID="txtfromdate" PopupButtonID="txtfromdate"
                                        Format="MM/dd/yyyy">
                                    </cc1:CalendarExtender>
                               </div>
                            </div>
                            <div class="ctrlGroup searchgroup">
                             <label class="lbl lbl2">To Date :</label>
                                <div class="txt w1">
                                    <asp:TextBox ID="txttodate" runat="server" CssClass="form-control hasDatepicker"></asp:TextBox>
                                    
                                    <cc1:CalendarExtender ID="cc2" runat="server" TargetControlID="txttodate" PopupButtonID="txttodate"
                                        Format="MM/dd/yyyy">
                                    </cc1:CalendarExtender>
                                </div>
                            </div>
                            <div class="clear"></div>
                            
                            <asp:UpdatePanel ID="updatePanelSearch" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl2">Project :</label>
                                        <div class="txt w1 mar10">
                                        <asp:DropDownList ID="dropproject" runat="server" CssClass="form-control">
                                        </asp:DropDownList>
                                            </div>
                                    </div>
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl2">Client :</label>
                                        <div class="txt w1">
                                        <asp:DropDownList ID="dropclient" runat="server" CssClass="form-control"
                                            AutoPostBack="true" OnSelectedIndexChanged="dropclient_OnSelectedIndexChanged">
                                        </asp:DropDownList>
                                    </div>
                                    </div>
                                    
                                </ContentTemplate>
                                <%-- <Triggers>
            <asp:PostBackTrigger ControlID="btnexportcsv" />
        </Triggers>--%>
                            </asp:UpdatePanel>
                            <div class="clear"></div>
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl lbl2">Task :</label>
                                        <div class="txt w1 mar10">
                                <asp:DropDownList ID="droptask" runat="server" CssClass="form-control">
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
                                <label class="lbl lbl2">Status :</label>
                                        <div class="txt w1 mar10">
                                <asp:DropDownList ID="dropstatus" runat="server" CssClass="form-control">
                                    <asp:ListItem Value="">--All Status--</asp:ListItem>
                                    <asp:ListItem>Not Started</asp:ListItem>
                                    <asp:ListItem>In Process</asp:ListItem>
                                    <asp:ListItem>Partially Completed</asp:ListItem>
                                    <asp:ListItem>Completed</asp:ListItem>
                                </asp:DropDownList>
                                            </div>
                            </div>
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl lbl2">Manager :</label>
                                        <div class="txt w1 mar10">
                                <asp:DropDownList ID="dropassign" runat="server" CssClass="form-control">
                                </asp:DropDownList>
                                            </div>
                            </div>
                           
                            <div class="ctrlGroup searchgroup">
                                <input type="button" id="btnsearch" value="Search" class="btn btn-default" onclick="searchdata();" />
                            </div>
                        </div>
                    </div>
                    <div class="clear">
                    </div>
                    <asp:UpdatePanel ID="updatePanelData" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="false">
                        <ContentTemplate>
                            <div id="otherdiv" onclick="closediv();">
                            </div>
                            <div class="col-sm-12 col-md-12 mar2">
                               
                                <div class="clear">
                                </div>
                                <div class="panel panel-default">
                                    <div class="panel-body2 ">
                                        <div class="row">
                                            <div class="table-responsive">
                                                <div class="nodatafound" id="divnodata" runat="server" style="display: none;">
                                                    No data found
                                                </div>
                                                <%--USE following code to BIND assigned tasks list from code behind
                                                <asp:GridView ID="dgnews" runat="server" AllowPaging="true" OnRowDataBound="dgnews_RowDataBound"
                                                    OnRowCommand="dgnews_RowCommand" AutoGenerateColumns="False" CellPadding="4"
                                                    PageSize="50" CellSpacing="0" Width="100%" ShowHeader="true" ShowFooter="false"
                                                    CssClass="table table-success mb30" GridLines="None" AllowSorting="true" OnSorting="dgnews_Sorting"
                                                    OnPageIndexChanging="dgnews_PageIndexChanging">
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="">
                                                            <ItemTemplate>
                                                                <img id="imgassignedby" runat="server" style="padding-top: 5px;" src="" title='<%# DataBinder.Eval(Container.DataItem, "assignedbyid")%>'
                                                                    alt="" />
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="AssignDate" HeaderStyle-Width="80px" SortExpression="date">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "date")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="LastUpdated" HeaderStyle-Width="80px">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "LastModifiedDate")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Employee" SortExpression="empname">
                                                            <ItemTemplate>
                                                                <span title='<%# DataBinder.Eval(Container.DataItem, "loginid")%>'>
                                                                    <%# DataBinder.Eval(Container.DataItem, "empname")%></span>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                     
                                                        <asp:TemplateField HeaderText="ProjectID" SortExpression="projectCode">
                                                            <ItemTemplate>
                                                                <span title='<%# DataBinder.Eval(Container.DataItem, "projectname")%>'>
                                                                    <%# DataBinder.Eval(Container.DataItem, "projectCode")%></span>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="TaskID" SortExpression="taskcodename">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "taskcodename")%>
                                                                :
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
                                                        <asp:TemplateField HeaderText="BHours" HeaderStyle-Width="30px">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "bhours")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="TimeTaken" HeaderStyle-Width="40px">
                                                            <ItemTemplate>
                                                                <span id="<%#Eval("nid") %>_ltrhours">
                                                                    <%# DataBinder.Eval(Container.DataItem, "totalhour")%></span>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Status" HeaderStyle-Width="70px">
                                                            <ItemTemplate>
                                                                <span id="<%#Eval("nid") %>_ltrstatus">
                                                                    <%# DataBinder.Eval(Container.DataItem, "status")%></span>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Manager" HeaderStyle-Width="50px">
                                                            <ItemTemplate>
                                                                <span title='<%# DataBinder.Eval(Container.DataItem, "managername")%>'>
                                                                    <%# DataBinder.Eval(Container.DataItem, "managerloginid")%></span>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Grade" HeaderStyle-Width="80px">
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
                                                        <asp:TemplateField HeaderText="Comments" HeaderStyle-Width="90px">
                                                            <ItemTemplate>
                                                                <asp:Literal ID="ltrcomments" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "comments")%>'
                                                                    Visible="false"></asp:Literal>
                                                                <asp:TextBox ID="txtcomments" TextMode="MultiLine" runat="server" onchange="savereward(this.id);"
                                                                    Width="98%" Text='<%# DataBinder.Eval(Container.DataItem, "comments")%>' Height="30px"
                                                                    MaxLength="200"></asp:TextBox>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="" ItemStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle"
                                                            HeaderStyle-Width="25px">
                                                            <ItemTemplate>
                                                              
                                                                <a id='<%#Eval("nid") %>_lbtnstatus' onclick='bindstatus(<%#Eval("nid") %>,<%#Eval("empid") %>);'>
                                                                    <i class="fa fa-fw" style="font-size: 18px; color: #d9534f; display: block; margin: auto;
                                                                        padding-top: 8px;">
                                                                        <img src="images/viewstatus.png" alt="" width="20"></i></a>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField ItemStyle-Width="20px" ItemStyle-HorizontalAlign="Center">
                                                            <ItemTemplate>
                                                                <input type="hidden" id="hidnid" runat="server" value='<%#DataBinder.Eval(Container.DataItem,"nid")%>' />
                                                                <asp:LinkButton ID="lbtndelete" CommandName="del" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>'
                                                                    ToolTip="Delete" runat="server" OnClientClick='return confirm("Delete this record? Yes or No");'><i class="fa fa-fw" style="font-size: 18px; color: #d9534f; display: block; margin: auto;
                                                            padding-top: 8px;">
                                                            <img src="images/delete.png" alt=""></i></asp:LinkButton>
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
                                                    <PagerStyle CssClass="gridpager" HorizontalAlign="Center" />
                                                </asp:GridView>--%>
                                                <table id="dgnews" class="tblreport" cellpadding="4" cellspacing="0"
                                                    width="100%">
                                                    
                                                </table>
                                                <div id="divloadmore" style="display: none; text-align: center;">
                                                    <img src="images/loading.gif" />
                                                </div>
                                            </div>
                                        </div>
                                        <!-- row -->
                                    </div>
                                    <!--  panel-body  -->
                                </div>
                                <input type="hidden" id="hidsearchfromdate" runat="server" />
                                <input type="hidden" id="hidsearchtodate" runat="server" />
                                <input type="hidden" id="hidsno" runat="server" />
                                <input type="hidden" id="hidmaxnid" runat="server" />
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
                            </div>
                        </ContentTemplate>
                        <Triggers>
                            <%-- <asp:AsyncPostBackTrigger ControlID="btnsearch" EventName="Click" />--%>
                            <%--  <asp:AsyncPostBackTrigger ControlID="lnkrefresh" EventName="Click" />--%>
                        </Triggers>
                    </asp:UpdatePanel>
                    <div class="clear">
                    </div>
                    <input type="hidden" id="hiduserid" runat="server" />
                    <input type="hidden" id="hidempid" runat="server" />
                    <!-- col-sm-9 -->
                    <div class="clear">
                    </div>
                </div>
                <!-- panel -->
            </div>
        </div>
    </div>
    <!---ADD NEW div goes here-->
    <asp:UpdatePanel ID="updatePanelAssign" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <script type="text/javascript">
                Sys.Application.add_load(bindPageEvent);
            </script>
            <div style="display: none; width: 720px;" runat="server" id="assignedtask_divaddnew"
                clientidmode="Static" class="itempopup">
                <div class="popup_heading">
                    <span id="legendaction" runat="server">Assign Task </span>
                    <div class="f_right">
                        <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
                    </div>
                </div>
                <div class="tabContents">
                    <div class="col-xs-12 col-sm-12">
                        <div class="ctrlGroup">
                            <label class="lbl lbl2">Date :<span id="spanerr_txtscheduledate" class="errmsg"></span>
                            </label>
                            <div class="txt w1 mar10">
                               
                                    <asp:TextBox ID="txtscheduledate" runat="server" CssClass="form-control hasDatepicker"></asp:TextBox>
                                   
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtscheduledate"
                                        PopupButtonID="txtscheduledate" Format="MM/dd/yyyy">
                                    </cc1:CalendarExtender>
                               
                            </div>
                        </div>
                        <div class="clear"></div>
                        <div class="ctrlGroup">
                            <label class="lbl lbl2">Employee :<span id="spanerr_ddlemployee" class="errmsg"></span>
                            </label>
                            <div class="txt w5 mar10">
                                <asp:DropDownList ID="ddlemployee" runat="server" CssClass="form-control pad3">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="ctrlGroup">
                            <label class="lbl lbl2">Manager :<span id="spanerr_ddlmanager" class="errmsg"></span>
                            </label>
                            <div class="txt w5">
                                <asp:DropDownList ID="ddlmanager" runat="server" CssClass="form-control pad3">
                                </asp:DropDownList>
                            </div>
                        </div>
                     
                         <div class="col-xs-12 col-sm-12 pad4" style="margin-top:15px" >
                        <table width="100%" cellpadding="4" cellspacing="0" id="tbldata" class="tblsheet">
                            <tr class="gridheader" id="trheader" runat="server">
                                
                                <th width="160px">
                                    Project ID
                                </th>
                                <th width="130px">
                                    Task
                                </th>
                                <th>
                                    Description
                                </th>
                                <th>
                                    Bud. Hours
                                </th>
                                <th width="20px">
                                </th>
                            </tr>
                            <tr>
                                
                                <td width="140px">
                                    <input type="text" id="ddlproject1" class="form-control" />
                                    <input type="hidden" id="hidproject1"  />
                                </td>
                                <td width="100px">
                                    <input type="text" id="ddltask1" class="form-control form-control1"  />
                                    <input type="hidden" id="hidtask1" />
                                </td>

                                <td>
                                    <input type="text" id="txtdesc1" class="form-control"  onblur="removeSpecialCh(this.id,event);" onkeypress="blockSpecialCh(this,event);" />
                                </td>
                                 <td width="80px">
                                                                <input type="text" id="txtbudhrs1" class="form-control" maxlength="4" onkeypress="TS_blockNonNumbers(this, event, true, false,0);"
                                                                    onblur="extractNumber(this,2,false);calhours();" onkeyup="extractNumber(this,2,false);"  />
                                                            </td>
                                <td width="20px" valign="middle">
                                    <div id="divdel1">
                                    </div>
                                </td>
                            </tr>
                        </table>
                        <div class="fulldiv">
                            <div style="float: right; text-align: right; padding-bottom: 5px; padding-top: 5px;">
                                +&nbsp;<a onclick="return addrow();" id="addmore" style="text-decoration: underline;">Add
                                    New</a>
                            </div>
                        </div>
                        </div>
                     
                        <div class="clear">
                            <asp:Button ID="btnsubmit" runat="server" ValidationGroup="save" CssClass="btn btn-primary"
                                Text="Save" OnClick="btnsubmit_Click" Visible="false" />
                            <input type="button" id="btnSave" class="btn btn-primary" value="Save" onclick="return vaildateAssignTask();" />
                        </div>
                    </div>
            </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <!--Status Div goes here-->
    <asp:UpdatePanel ID="updatePanelStatus" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <input type="hidden" id="hidid" runat="server" />
            <input type="hidden" id="hidrowid" runat="server" />
            <input type="hidden" id="hidstatusid" runat="server" />
            <input type="hidden" id="hidcurrentemp" runat="server" />
            <div id="assignedtask_divstatus" class="itempopup" style="width: 690px;">
                <div class="popup_heading">
                    <span id="spanstatushead" runat="server">Task Status</span>
                    <div class="f_right">
                        <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
                    </div>
                </div>
                <div class="tabContents">
                    <div class="col-xs-12 col-sm-12">
                        <div class="mar" id="divprestatus" runat="server">
                            <div class="f_left">
                                <b>Status Details </b>
                            </div>
                            <div class="clear">
                            </div>
                            <div class="line" style="margin-top: 3px;">
                            </div>
                            <table id="tblStatus" cellspacing="0" cellpadding="4" border="1" style="width: 100%;"
                                class="tblsheet">
                                <tbody>
                                    <tr class="gridheader">
                                        <th width="15%">
                                            Date
                                        </th>
                                        <th width="15%">
                                            Status
                                        </th>
                                        <th width="15%">
                                            Time Taken
                                        </th>
                                        <th>
                                            Emp Remark
                                        </th>
                                        <th width="8%">
                                        </th>
                                    </tr>
                                </tbody>
                            </table>
                            <div class="clear">
                            </div>
                            <div class="nodatafound" id="divnodataforpreviousstatus" runat="server">
                                Status not updated</div>
                            <%-- <div class="line" style="margin-top:3px;">
                        </div>--%>
                        </div>
                        <div class="clear">
                        </div>
                        <div class="mar" id="divnewstatus" runat="server">
                            <div class="f_left mar">
                                <b>New Status </b>
                            </div>
                            <div class="line clear" style="margin-top: 3px;">
                            </div>
                            <div class="mar">
                                <div class="col-xs-12 col-sm-4 form-group   clear f_left pad">
                                    <label style="float:left; padding:0" class="  control-label">
                                        Date: <span id="spanerr_txtnewdate" class="errmsg"></span>
                                    </label>
                                    <div class="col-xs-12 col-sm-9">
                                       
                                            <asp:TextBox ID="txtnewdate" runat="server" CssClass="form-control hasDatepicker"
                                                placeholder="mm/dd/yyyy"></asp:TextBox>
                                            
                                            <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtnewdate"
                                                PopupButtonID="txtnewdate" Format="MM/dd/yyyy">
                                            </cc1:CalendarExtender>
                                      
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-4 form-group  f_left pad">
                                    <label style="float:left; padding:0" class=" control-label">
                                        Time Taken: <span id="spanerr_txtTime" class="errmsg"></span>
                                    </label>
                                    <div class="col-xs-12 col-sm-7">
                                        <asp:TextBox ID="txtTime" runat="server" CssClass="form-control" placeholder="Hours"
                                            onkeypress="blockNonNumbers(this, event, true, false);" onkeyup="extractNumber(this,2,false);"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-4 form-group f_left pad">
                                    <label style="float:left; padding:0" class="  control-label">
                                        Status: <span id="spanerr_ddlstaus" class="errmsg"></span>
                                    </label>
                                    <div class="col-xs-12 col-sm-9" style="padding-right:0; width:79%;">
                                        <asp:DropDownList  ID="ddlstaus" runat="server" CssClass="form-control">
                                            <asp:ListItem Value=""></asp:ListItem>
                                            <asp:ListItem Value="In Process">In Process</asp:ListItem>
                                            <asp:ListItem Value="Partially Completed">Partially Completed</asp:ListItem>
                                            <asp:ListItem Value="Completed">Completed</asp:ListItem>
                                        </asp:DropDownList>
                                        <input type="hidden" id="hidIsUpdateStatus" runat="server" />
                                    </div>
                                </div>
                                <div class="col-xs-12 form-group f_left pad">
                                    <label style="float:left" class=" control-label">
                                        Remark:
                                    </label>
                                    <div class="col-xs-11" style="padding-right:0">
                                        <asp:TextBox ID="txtremark" runat="server" TextMode="MultiLine" Style="height: 80px;" 
                                            CssClass="form-control pad3"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-xs-12 form-group f_left pad">
                                    <label class="col-sm-1 control-label">
                                        &nbsp;
                                    </label>
                                    <div class="col-xs-11">
                                        <%-- <asp:Button ID="btnsave" runat="server" Text="Save" ValidationGroup="savestatus"
                                            CssClass="btn btn-primary" OnClick="btnsave_Click" />--%>
                                        <input type="button" onclick="return vaildatestatus();" class="btn btn-primary" value="Save" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
     <input type="hidden" id="AssignedTask_hidrowno"  clientidmode="Static" runat="server" />
     <input type="hidden" id="AssignedTask_hidsno" clientidmode="Static" runat="server" />
   
     
</asp:Content>
