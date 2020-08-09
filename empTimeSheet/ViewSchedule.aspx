<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="ViewSchedule.aspx.cs" Inherits="empTimeSheet.ViewSchedule" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="Stylesheet" href="css/tab_2.0.css" type="text/css" />
    <link rel="stylesheet" href="css/jquery.dataTables.min.css" />

    <script src="js/jquery.min.js"></script>

    <script type="text/javascript" src="js/jquery.dataTables.min.js"></script>

    <link href="css/schedulecss.css" rel="stylesheet" />
    <script src="js/schedulejs.js"></script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <pg:progress ID="progress1" runat="server" />
    <asp:UpdatePanel ID="upadatepanel" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:Button ID="PaggedGridbtnedit" runat="server" Style="display: none;" OnClick="PaggedGridbtnedit_Click" ClientIDMode="Static" />
            <asp:Button ID="PaggedGridbtnedit2" runat="server" Style="display: none;" OnClick="PaggedGridbtnedit2_Click" ClientIDMode="Static" />
            <!--- POP UP DIVS goes here-->
            <!--Set Status Pop Up -->
            <div class="divalert" id="divconfirmdiv" style="z-index: 9999999;">

                <a class="divalert-close" onclick="closediv();">
                    <img src="images/cross.png" /></a>

                <div class="clear"></div>
                <div class="divalert-text" id="alerttext"></div>
                <div class="divalert-bottom">
                    <input id="btnaction1" type="button" value="OK" class="divalert-ok" onclick="setactionfrombox('1');" />

                    <input id="btnaction2" type="button" value="Delete" class="divalert-btnclose" onclick="setactionfrombox('2');" />
                </div>
            </div>


            <div id="divstatus" class="itempopup" style="width: 650px;">
                <div class="popup_heading">
                    <span>Edit Status</span>
                    <div class="f_right">
                        <img src="images/cross.png" onclick="closediv1();" alt="X" title="Close
            Window" />
                    </div>
                </div>
                <div class="tabContaier">
                    <div class="tabDetails">
                        <div class="tabContents" style="display: block; height: auto;">

                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Employee :
                                </label>

                                <div class="lbl w2 mar10" style="color: #1caf9a;">
                                    <asp:Literal ID="ltrempname" runat="server"></asp:Literal>
                                </div>
                            </div>
                            <div class="clear">
                            </div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Date :
                                </label>
                                <div class="lbl 2 ">
                                    <asp:Literal ID="ltrdate" runat="server"></asp:Literal>
                                </div>
                            </div>

                            <div class="clear">
                            </div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Client :
                                </label>
                                <div class="lbl w2 mar10">
                                    <asp:Literal ID="ltrclient" runat="server"></asp:Literal>
                                </div>
                            </div>
                            <div class="clear">
                            </div>
                            <div class="ctrlGroup">
                                <label class="lbl">Status :</label>
                                <div class="txt w2">
                                    <asp:DropDownList ID="ddlstaus" runat="server" CssClass="form-control" onchange="showdate(this.value);">
                                        <asp:ListItem Value="Confirmed by the Client">Confirmed by the Client</asp:ListItem>
                                        <asp:ListItem Value="Non-Confirmed by the Client">Non-Confirmed by the Client</asp:ListItem>
                                        <asp:ListItem Value="All Reservations Made">All Reservations Made</asp:ListItem>
                                        <asp:ListItem Value="Re-Schedule">Re-Schedule</asp:ListItem>
                                        <asp:ListItem Value="Postponed">Postponed</asp:ListItem>
                                        <asp:ListItem Value="Cancelled">Cancelled</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="clear">
                            </div>

                            <div id="divdate" class="ctrlGroup" style="display: none;">
                                <label class="lbl">
                                    New Date :
                                <asp:CustomValidator ID="CustomValidator2" runat="server" ErrorMessage="*" ValidationGroup="savestatus"
                                    CssClass="errmsg" ClientValidationFunction="validate2"></asp:CustomValidator>
                                </label>
                                <div class="txt w1">

                                    <asp:TextBox ID="txtnewdate" runat="server" CssClass="form-control hasDatepicker"></asp:TextBox>

                                    <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtnewdate"
                                        PopupButtonID="txtnewdate" Format="MM/dd/yyyy">
                                    </cc1:CalendarExtender>

                                </div>
                            </div>
                            <div class="clear">
                            </div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Remark :
                                </label>
                                <div class="txt w3">
                                    <asp:TextBox ID="txtremark" runat="server" TextMode="MultiLine" CssClass="form-control" Height="50px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="clear">
                            </div>
                        </div>
                        <div class="clear">
                        </div>
                    </div>

                    <div class="clear">
                    </div>
                    <div class="col-xs-12 col-sm-12" style="padding: 10px 0px 0px 0px;">
                        <asp:Button ID="btnsave" runat="server" Text="Save" ValidationGroup="savestatus"
                            CssClass="btn btn-primary" OnClick="btnsave_Click" />
                    </div>
                </div>
            </div>
            <!---Add New div goes here-->
            <div style="width: 750px;" id="divaddnew" class="itempopup">
                <div class="popup_heading">
                    <span id="legendaction" runat="server">Schedule Employee</span>
                    <div class="f_right">
                        <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
                    </div>
                </div>
                <div class="tabContaier">
                    <div class="tabDetails">
                        <div class="tabContents" style="display: block; height: auto;">
                            <div class="ctrlGroup">
                                <label class="lbl lbl3">
                                    From Date :<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                                        ControlToValidate="txtpopfrdate" ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator>
                                </label>
                                <div class="txt w5 mar10">
                                    <div class="txt w1">
                                        <asp:TextBox ID="txtpopfrdate" runat="server" CssClass="form-control hasDatepicker" onchange="comparedate(this.id,'ctl00_ContentPlaceHolder1_txtpopfrdate','ctl00_ContentPlaceHolder1_txtpoptodate');"></asp:TextBox>

                                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtpopfrdate"
                                            PopupButtonID="txtpopfrdate" Format="MM/dd/yyyy">
                                        </cc1:CalendarExtender>
                                    </div>

                                </div>
                            </div>
                            <div class="ctrlGroup">
                                <label class="lbl lbl3">
                                    To Date :<asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                                        ControlToValidate="txtpoptodate" ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator>
                                </label>
                                <div class="txt w5">
                                    <div class="txt w1">
                                        <asp:TextBox ID="txtpoptodate" runat="server" CssClass="form-control hasDatepicker" onchange="comparedate(this.id,'ctl00_ContentPlaceHolder1_txtpopfrdate','ctl00_ContentPlaceHolder1_txtpoptodate');"></asp:TextBox>

                                        <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtpoptodate"
                                            PopupButtonID="txtpoptodate" Format="MM/dd/yyyy">
                                        </cc1:CalendarExtender>
                                    </div>

                                </div>
                            </div>
                            <div class="clear"></div>
                            <div class="ctrlGroup">
                                <label class="lbl lbl3">
                                    Client :<asp:RequiredFieldValidator ID="req1" runat="server" ControlToValidate="drppopclient"
                                        ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator>
                                </label>
                                <div class="txt w5 mar10">
                                    <asp:DropDownList ID="drppopclient" runat="server" CssClass="form-control" AutoPostBack="true"
                                        OnSelectedIndexChanged="drppopclient_SelectedIndexChanged" OnDataBound="drppopclient_DataBound">
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="ctrlGroup">
                                <label class="lbl lbl3">
                                    Project :
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="ddlproject"
                                    ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator></label>
                                <div class="txt w5">
                                    <asp:DropDownList ID="ddlproject" runat="server" CssClass="form-control">
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="clear"></div>
                            <div class="ctrlGroup">
                                <label class="lbl lbl3">
                                    Time :
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:DropDownList ID="drppophour" Style="margin-right: 12px;" runat="server"
                                        CssClass="form-control f_left">
                                    </asp:DropDownList>


                                </div>
                                <div class="txt  mar10">
                                    <asp:DropDownList ID="drppopmin" runat="server" Width="70px" CssClass="form-control f_left">
                                        <asp:ListItem Value="">---- </asp:ListItem>
                                        <asp:ListItem Value="AM">AM</asp:ListItem>
                                        <asp:ListItem Value="PM">PM</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>

                            <div class="ctrlGroup">
                                <label class="lbl lbl3">
                                    Schedule Type :
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="rdbtnscheduleType"
                                    ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator>
                                </label>
                                <div class="txt w5">
                                    <asp:DropDownList ID="rdbtnscheduleType" onchange="showhidestatus();" runat="server"
                                        CssClass="form-control">
                                        <asp:ListItem Value="Field">Field Work</asp:ListItem>
                                        <asp:ListItem Value="Office">Office Work</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="clear"></div>
                            <div id="divschedulestatus" class="ctrlGroup">
                                <label class="lbl lbl3">
                                    Status :
                                </label>
                                <div class="txt w5 mar10">
                                    <asp:DropDownList ID="drppopstatus" runat="server" CssClass="form-control">
                                        <asp:ListItem Value="Confirmed by the Client">Confirmed by the Client</asp:ListItem>
                                        <asp:ListItem Value="Non-Confirmed by the Client">Non-Confirmed by the Client</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="ctrlGroup" id="divaddremark" style="display: none;">
                                <label class="lbl lbl3">
                                    Remark :
                                </label>
                                <div class="txt w5">
                                    <asp:TextBox ID="txtaddremark" runat="server" MaxLength="1000" TextMode="MultiLine"
                                        CssClass="form-control" Height="40px"> </asp:TextBox>
                                </div>
                            </div>
                            <div class="clear">
                            </div>
                            <div class="ctrlGroup" id="divselectemployee" runat="server">
                                <label class="lbl lbl3">
                                    <span id="spanemp" runat="server">Employee :</span>
                                    <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="*" ValidationGroup="save"
                                        CssClass="errmsg" ClientValidationFunction="validate1"></asp:CustomValidator>
                                </label>
                                <div class="txt w5 ">
                                    <asp:ListBox ID="listcode1" runat="server" Style="height: 150px;" SelectionMode="Multiple"
                                        CssClass="form-control nobackimage"></asp:ListBox>
                                </div>
                                <div class="txt  lbl3 mar10" style="padding-top: 40px; text-align: center;">
                                    <input type="button" onclick="move(this.form.ctl00_ContentPlaceHolder1_listcode1, this.form.ctl00_ContentPlaceHolder1_listcode2)"
                                        class="btn btn-default " style="width: 40px; padding: 2px;" value=">>" id="btnAddtoList"
                                        runat="server" />
                                    <br />
                                    <input type="button" onclick="move(this.form.ctl00_ContentPlaceHolder1_listcode2, this.form.ctl00_ContentPlaceHolder1_listcode1)"
                                        class="btn btn-default mar" style="width: 40px; padding: 2px;" value="<<"
                                        id="btnRemovefromList" runat="server" />
                                </div>

                                <div class="txt w5">
                                    <asp:ListBox ID="listcode2" runat="server" SelectionMode="Multiple" Style="height: 150px;"
                                        CssClass="form-control nobackimage"></asp:ListBox>
                                </div>
                            </div>
                            <div class="clear">
                            </div>
                        </div>
                    </div>

                    <div class="col-xs-12 col-sm-12" style="padding: 10px 0px 0px 0px;">
                        <asp:Button ID="btnsubmit" runat="server" CssClass="btn
            btn-primary"
                            Text="Save" ValidationGroup="save" OnClick="btnsubmit_Click" />
                    </div>
                    <input type="hidden" id="hidexpense" runat="server" />
                    <input type="hidden" id="hidstatus" runat="server" />
                    <input type="hidden" id="hidclientid" runat="server" />
                    <input type="hidden" id="hidprjectid" runat="server" />
                    <input type="hidden" id="hidempid" runat="server" />
                </div>
            </div>
            <!-- Already schedule or leave msg
            div goes here-->
            <div style="width: 640px;" id="divstatusmsg" class="itempopup">
                <div class="popup_heading">
                    <span id="Span2" runat="server">Schedule Status</span>
                    <%--<div class="f_right"> <img src="images/cross.png" onclick="closealert();" alt="X"
            title="Close Window" /> </div>--%>
                </div>
                <div style="padding: 10px;">
                    <div style="max-height: 350px; oveflow-y: auto; padding: 10px 0px; font-size: 13px;">
                        <asp:Label ID="lblerr" runat="server" CssClass="errmsg"></asp:Label>
                    </div>
                    <div class="padtop10" style="padding-bottom: 10px;">
                        Click <strong>Continue </strong>to save it anyway or <strong>Cancel </strong>to
                        stop Schedule.
                    </div>
                    <div class=" clear padtop10">
                        <asp:Button ID="btncontinue" runat="server" CssClass="btn btn-primary" Text="Continue"
                            OnClick="btncontinue_Click" />
                        <input type="button" id="btncancelalert" class="btn
            btn-primary"
                            value="Cancel" onclick="closealert();" />
                    </div>
                </div>
            </div>
            <!--Non
            Schedule DIV goes here-->
            <div style="width: 640px;" id="divnonschedule" class="itempopup">
                <div class="popup_heading">
                    <span id="Span3" runat="server">Non-Scheduled Employees List</span>
                    <div class="f_right">
                        <img src="images/cross.png" onclick="closenonscedulediv();" alt="X" title="Close Window" />
                    </div>
                </div>
                <div id="divsearchparam" class="mar" style="font-weight: bold; padding-left: 12px; padding-bottom: 10px;">
                    Non-Scheduled Employees for Date:
                    <asp:Literal ID="ltrsearchparam" runat="server"></asp:Literal><br />
                </div>
                <div class="clear">
                </div>
                <asp:RadioButtonList ID="rdlNonScheduleScheduleType" RepeatLayout="Flow" AutoPostBack="true"
                    OnSelectedIndexChanged="rdlNonScheduleScheduleType_OnSelectedIndexChanged" runat="server"
                    RepeatDirection="Horizontal" CssClass="checkboxauto checkboxinputwithoutmar
            padtop10"
                    Style="float: left; padding-left: 12px; padding-bottom: 10px;">
                    <asp:ListItem Value="Field" Selected="True">Field Work</asp:ListItem>
                    <asp:ListItem Value="Office">Office
            Work</asp:ListItem>
                </asp:RadioButtonList>
                <div class="clear">
                </div>
                <div style="padding: 10px; max-height: 350px; overflow-y: auto;">
                    <div class="nodatafound" id="divnoschedulefound" runat="server" visible="false">
                        No data found
                    </div>
                    <asp:Repeater ID="rptday" runat="server" OnItemDataBound="rptday_ItemDataBound">
                        <HeaderTemplate>
                            <table width="99%" cellpadding="4" cellspacing="0" class="tblsheet">
                                <tr align="left">
                                    <th style="border-top: 1px solid
            #cccccc;">Date
                                    </th>
                                    <th style="border-top: 1px solid #cccccc;">Employee
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
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>
                </div>
            </div>


            <div id="otherdiv" onclick="closediv();">
            </div>
            <div class="pageheader">
                <h2>
                    <i class="fa fa-table"></i>Client Schedule
                </h2>
                <input type="hidden" id="hidid" runat="server" />
                <div class="breadcrumb-wrapper mar ">
                    <div class="f_right">
                        <%-- <asp:LinkButton ID="liaddnew" runat="server" CssClass="add_new" OnClick="liaddnew_Click">--%>
                        <a onclick="reset();opendiv();" id="liaddnew" runat="server" class="right_link">
                            <i class="fa fa-fw fa-plus topicon"></i>
                            New Schedule</a>
                        <asp:LinkButton ID="linknonscemp" runat="server" CssClass="right_link" OnClick="linknonscemp_Click">
                        <i class="fa fa-fw fa-circle-o topicon"></i>Non-Scheduled Employee</asp:LinkButton>
                        <asp:LinkButton ID="btnexportcsv" runat="server" OnClick="btnexportcsv_Click" CssClass="right_link">
                        <i class="fa fa-fw fa-file-excel-o topicon"></i>
                        Export to Excel</asp:LinkButton>
                        <asp:LinkButton ID="lnkrefresh" runat="server" OnClick="btnrefresh_Click" CssClass="right_link">
                        <i class="fa fa-fw fa-refresh topicon"></i>
                        Refresh</asp:LinkButton>
                    </div>
                </div>
                <div class="clear">
                </div>
            </div>

        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnexportcsv" />
        </Triggers>
    </asp:UpdatePanel>



    <div class="contentpanel">
        <asp:UpdatePanel ID="updateData" runat="server" UpdateMode="Conditional">
            <ContentTemplate>


                <div class="row">
                    <div class="col-sm-12 col-md-12">
                        <div class="panel panel-default">
                            <div class="col-sm-12 col-md-10 mar">
                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl">From Date :</label>
                                    <div class="txt w1 mar10">
                                        <asp:TextBox ID="txtfrmdate" runat="server" CssClass="form-control hasDatepicker" onchange="comparedate(this.id,'ctl00_ContentPlaceHolder1_txtfromdate','ctl00_ContentPlaceHolder1_txttodate');"></asp:TextBox>

                                        <cc1:CalendarExtender ID="txtDate_CalendarExtender" runat="server" TargetControlID="txtfrmdate"
                                            PopupButtonID="txtfrmdate" Format="MM/dd/yyyy">
                                        </cc1:CalendarExtender>
                                    </div>
                                </div>
                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl lbl2">To Date:</label>
                                    <div class="txt w1 mar10">
                                        <asp:TextBox ID="txttodate" runat="server" CssClass="form-control hasDatepicker" onchange="comparedate(this.id,'ctl00_ContentPlaceHolder1_txtfromdate','ctl00_ContentPlaceHolder1_txttodate');"></asp:TextBox>

                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txttodate"
                                            PopupButtonID="txttodate" Format="MM/dd/yyyy">
                                        </cc1:CalendarExtender>
                                    </div>
                                </div>
                                <div class="clear"></div>
                                <asp:UpdatePanel ID="updateproject" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <div class="ctrlGroup searchgroup">
                                            <label class="lbl">Project :</label>
                                            <div class="txt w1 mar10">
                                                <asp:DropDownList ID="dropproject" runat="server" CssClass="form-control">
                                                </asp:DropDownList>
                                            </div>
                                        </div>
                                        <div class="ctrlGroup searchgroup">
                                            <label class="lbl lbl2">Client :</label>
                                            <div class="txt w2 mar10">
                                                <asp:DropDownList ID="drpclient" runat="server" CssClass="form-control"
                                                    AutoPostBack="true" OnSelectedIndexChanged="drpclient_OnSelectedIndexChanged">
                                                </asp:DropDownList>
                                            </div>
                                        </div>

                                    </ContentTemplate>
                                </asp:UpdatePanel>
                                <div class="clear"></div>
                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl">Status :</label>
                                    <div class="txt w1 mar10">
                                        <asp:DropDownList ID="dropstatus" runat="server" CssClass="form-control">
                                            <asp:ListItem Value="">--All Status--</asp:ListItem>
                                            <asp:ListItem>Confirmed by the Client</asp:ListItem>
                                            <asp:ListItem>Non-Confirmed by the Client</asp:ListItem>
                                            <asp:ListItem>All Reservations Made</asp:ListItem>
                                            <asp:ListItem>Re-Schedule</asp:ListItem>
                                            <asp:ListItem>Postponed</asp:ListItem>
                                            <asp:ListItem>Cancelled</asp:ListItem>

                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl lbl2">Employee :</label>
                                    <div class="txt w2">
                                        <asp:DropDownList ID="drpemployee" runat="server" CssClass="form-control">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="clear"></div>
                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl">Schedule Type :</label>
                                    <div class="txt w1 mar10">
                                        <asp:DropDownList ID="dropsearchscheduletype" runat="server" CssClass="form-control">
                                            <asp:ListItem Value="">--All Schedule Type--</asp:ListItem>
                                            <asp:ListItem>Field</asp:ListItem>
                                            <asp:ListItem>Office</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl lbl2 disNone">&nbsp;   </label>
                                    <asp:Button ID="btnsearch" runat="server" CssClass="btn btn-default" Text="Search"
                                        OnClick="btnsearch_click" />
                                </div>
                            </div>

                            <div class="ctrlGroup searchgroup" style="float: right; display: none;">
                                <asp:LinkButton ID="lnkprevious" CssClass="f_left" runat="server" OnClick="lnkprevious_Click">
            <i class="fa fa-fw fa-fast-backward color_green"></i></asp:LinkButton>

                                <div class="f_left page">
                                    <asp:Label ID="lblstart" runat="server"></asp:Label>
                                    -
                                        <asp:Label ID="lblend" runat="server"></asp:Label>
                                    of <strong>
                                        <asp:Label ID="lbltotalrecord" Font-Bold="true" runat="server"></asp:Label></strong>
                                </div>
                                <asp:LinkButton ID="lnknext" CssClass="f_left" runat="server" OnClick="lnknext_Click"><i class="fa fa-fw fa-fast-forward color_green"></i></asp:LinkButton>
                            </div>

                            <div class="clear">
                            </div>
                            <div class="col-sm-12 col-md-12 mar">

                                <div class="clear">
                                </div>
                                <div class="panel panel-default">
                                    <div class="panel-body2 ">
                                        <div class="row">
                                            <div class="table-responsive" style="min-height: 300px;">
                                                <asp:GridView ID="dgnews" runat="server" AllowPaging="false" AutoGenerateColumns="False"
                                                    PageSize="50" CellPadding="4" CellSpacing="0" Width="100%" ShowHeader="true"
                                                    ShowFooter="false" CssClass="tblreport" GridLines="None" AllowSorting="false"
                                                    OnRowDataBound="dgnews_RowDataBound" OnRowCommand="dgnews_RowCommand">
                                                    <Columns>

                                                        <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="55px">
                                                            <ItemTemplate>
                                                                <%# Container.DataItemIndex + 1 %>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Date/Time" SortExpression="date" HeaderStyle-Width="137px">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"date")%>
                                                                <%#DataBinder.Eval(Container.DataItem,"time")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Employee">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"empname")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Client">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"clientname")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Project">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"projectname")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Type" HeaderStyle-Width="65px">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem, "scheduletype")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Status" SortExpression="status">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"status")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Remark">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"remark")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="" HeaderStyle-Width="105px">
                                                            <ItemTemplate>


                                                                <a id="lbtnstatus" runat="server" title="Modify Status">Modify Status</a>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                        <asp:TemplateField HeaderStyle-Width="68px" ItemStyle-HorizontalAlign="Center">
                                                            <ItemTemplate>

                                                                <a onclick='clickedit(<%#DataBinder.Eval(Container.DataItem,"nid")%>);' title="Edit"><i class="fa fa-fw">
                                                                    <img src="images/edit.png"></i></a>
                                                                &nbsp;

                                                                 <a id="lbtndelete" runat="server" title="Delete"><i class="fa fa-fw">
                                                                     <img src="images/delete.png" alt=""></i></a>

                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                    </Columns>
                                                    <HeaderStyle CssClass="gridheader" />
                                                    <PagerStyle CssClass="gridpager" HorizontalAlign="Center" />
                                                </asp:GridView>


                                                <div class="nodatafound" id="divnodata" runat="server">
                                                    No data found
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
                <input type="hidden" id="hidsearchscheduletype" runat="server" />
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>

</asp:Content>
