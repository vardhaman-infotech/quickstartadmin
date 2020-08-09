<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="ServerLogReport.aspx.cs" Inherits="empTimeSheet.ServerLogReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="Stylesheet" type="text/css" href="css/server_2.0.css" />
    <script type="text/javascript">
        function closediv() {
            document.getElementById("divlog").style.display = "none";
            document.getElementById("otherdiv").style.display = "none";
        }
        function opendiv() {
            setposition("divlog");
            document.getElementById("divlog").style.display = "block";
            document.getElementById("otherdiv").style.display = "block";
        }
        //Show attachment in popup
        function openattach() {
            document.getElementById("divattachment").style.display = "block";
            document.getElementById("otherdiv").style.display = "block";

        }
        function closediv1() {
            document.getElementById("divattachment").style.display = "none";
            document.getElementById("otherdiv").style.display = "none";
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:UpdatePanel ID="upadatepanel" runat="server">
        <ContentTemplate>
            <div id="otherdiv" onclick="closediv();">
            </div>
            <div class="pageheader">
                <h2>
                    <i class="fa fa-desktop"></i>Server Log Report
                </h2>
                <div class="breadcrumb-wrapper mar ">
                    <input type="hidden" id="hidid" runat="server" />
                    <asp:LinkButton ID="btnexportcsv" runat="server" OnClick="btnexportcsv_Click" CssClass="right_link">
                    <i class="fa fa-fw fa-file-excel-o topicon"></i>Export to Excel</asp:LinkButton>
                </div>
                <div class="clear">
                </div>
            </div>
            <div class="contentpanel">
                <pg:progress ID="progress1" runat="server" />
                <div class="row">
                    <div class="col-sm-12 col-md-12">
                        <div class="panel panel-default">
                            <div class="col-sm-12 col-md-10">
                                <div style="padding-top: 10px;">
                                    <div class="col-xs-12 col-sm-8 col-md-6 f_left" style="padding: 0px;">
                                        <h5 class="subtitle mb5">Server Log Report</h5>
                                    </div>
                                    <div class="clear">
                                    </div>
                                </div>
                            </div>
                            <div class="clear">
                            </div>
                            <div class="col-sm-12 col-md-12">
                                <asp:MultiView ID="multiview1" runat="server" ActiveViewIndex="0">
                                    <asp:View ID="view1" runat="server">
                                        <div class="col-sm-4 col-md-4 f_left mar clear pad4 ">
                                           
                                                <asp:TextBox ID="txtfromdate" runat="server" CssClass="form-control hasDatepicker"></asp:TextBox>

                                                <cc1:CalendarExtender ID="txtDate_CalendarExtender" runat="server" TargetControlID="txtfromdate"
                                                    PopupButtonID="txtfromdate" Format="MM/dd/yyyy">
                                                </cc1:CalendarExtender>
                                            
                                        </div>
                                        <div class="col-sm-6 col-md-4 mar pad5">

                                            <asp:TextBox ID="txttodate" runat="server" CssClass="form-control hasDatepicker"></asp:TextBox>

                                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txttodate"
                                                PopupButtonID="txttodate" Format="MM/dd/yyyy">
                                            </cc1:CalendarExtender>

                                        </div>
                                        <div class="clear">
                                        </div>
                                        <asp:UpdatePanel ID="updatePanelSearch" runat="server" UpdateMode="Conditional">
                                            <ContentTemplate>
                                                <div class="col-sm-6 col-md-4  pad4">
                                                    <asp:DropDownList ID="dropclient" runat="server" CssClass="form-control mar pad3"
                                                        AutoPostBack="true" OnSelectedIndexChanged="dropclient_SelectedIndexChanged">
                                                    </asp:DropDownList>
                                                    <%--  <asp:DropDownList ID="dropproject" runat="server" CssClass="form_2_input5">
                    </asp:DropDownList>--%>
                                                </div>
                                                <div class="col-sm-6 col-md-4  pad5">
                                                    <asp:DropDownList ID="dropserver" runat="server" CssClass="form-control mar pad3">
                                                    </asp:DropDownList>
                                                </div>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                        <div class="col-sm-6 col-md-4 pad4">
                                            <asp:Button ID="btnsearch" runat="server" CssClass="btn btn-default mar" Text="View Report"
                                                OnClick="btnsearch_click" />
                                            <asp:Button ID="btnFullReport" runat="server" CssClass="btn btn-default mar" Text="View Full Report"
                                                OnClick="btnFullReport_click" />
                                        </div>
                                        <div class="col-sm-6 col-md-4 pad4">
                                        </div>
                                        <div class="clear">
                                        </div>
                                        <div class="f_right">
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
                                                        <asp:GridView ID="dgnews" runat="server" AllowPaging="true" AutoGenerateColumns="false"
                                                            CellPadding="4" CellSpacing="0" BorderWidth="0px" Width="100%" ShowHeader="true"
                                                            PageSize="50" ShowFooter="false" CssClass="table table-success mb30" GridLines="None"
                                                            OnRowCommand="dgnews_ItemCommand" OnRowDataBound="dgnews_RowDataBound" OnPageIndexChanging="dgnews_PageIndexChanging">
                                                            <Columns>
                                                                <asp:TemplateField HeaderText="S.No." ItemStyle-Width="20px">
                                                                    <ItemTemplate>
                                                                        <%# Container.DataItemIndex + 1 %>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Date" ItemStyle-Width="10%">
                                                                    <ItemTemplate>
                                                                        <%# DataBinder.Eval(Container.DataItem, "date")%>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Server" ItemStyle-Width="15%">
                                                                    <ItemTemplate>
                                                                        <%# DataBinder.Eval(Container.DataItem, "servercodename")%>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="RAM Utilization" ItemStyle-Width="15%">
                                                                    <ItemTemplate>
                                                                        <%# DataBinder.Eval(Container.DataItem, "RAMUtilization")%>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="CPU Utilization" ItemStyle-Width="15%">
                                                                    <ItemTemplate>
                                                                        <%# DataBinder.Eval(Container.DataItem, "CPUUtilization")%>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Free Space" ItemStyle-Width="13%">
                                                                    <ItemTemplate>
                                                                        <%# DataBinder.Eval(Container.DataItem, "Usedspace")%>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Critical">
                                                                    <ItemTemplate>
                                                                        <asp:LinkButton ID="lbtncritical" runat="server" CommandArgument='<%#Eval("nid") + ";" + "Critical" %>'
                                                                            CommandName="showlog"><%#Eval("criticallog")%></asp:LinkButton>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Error">
                                                                    <ItemTemplate>
                                                                        <asp:LinkButton ID="lbtnerror" runat="server" CommandArgument='<%#Eval("nid") + ";" + "Error" %>'
                                                                            CommandName="showlog"><%#Eval("errorlog")%></asp:LinkButton>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Warning">
                                                                    <ItemTemplate>
                                                                        <asp:LinkButton ID="lbtnwarning" runat="server" CommandArgument='<%#Eval("nid") + ";" + "Warning" %>'
                                                                            CommandName="showlog"><%#Eval("warninglog")%></asp:LinkButton>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField ItemStyle-Width="15%">
                                                                    <ItemTemplate>
                                                                        <asp:LinkButton ID="lbtnattachment" runat="server" ToolTip="Click to see attchments"
                                                                            Text='<%#Eval("numofattachment")%>' CommandArgument='<%#Eval("nid") %>' CommandName="download"></asp:LinkButton>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField ItemStyle-Width="17px">
                                                                    <ItemTemplate>
                                                                        <asp:LinkButton ID="lbtnedit" CommandName="viewdetail" CommandArgument='<%#Eval("date") + ";" + Eval("serverid") %>'
                                                                            ToolTip="View" runat="server"><i class="fa fa-fw" style="margin: auto;
                                                            padding-top: 8px;"><img src="images/view.png" /></i></asp:LinkButton>
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
                                    </asp:View>
                                    <asp:View ID="viewdetail" runat="server">
                                        <div class="f_right">
                                            <asp:LinkButton ID="lbtnback" runat="server" OnClick="btnback_Click" CssClass="right_link"
                                                Style="margin: 0px; padding: 0px; background: none;"><img src="images/arrow_left.png" alt="Back" /> </asp:LinkButton>
                                        </div>
                                        <div class="right_index">
                                            <h1 class="heading">Server Log Report From
                                                <asp:Literal ID="litfromdate" runat="server"></asp:Literal>&nbsp;To&nbsp;<asp:Literal
                                                    ID="littodate" runat="server"></asp:Literal>
                                            </h1>
                                            <div class="clear">
                                            </div>
                                            <div class="server_box mar20">
                                                <div class="server_inner">
                                                    <div class="server_box">
                                                        <asp:Repeater ID="rptinner" runat="server">
                                                            <ItemTemplate>
                                                                <div class="rowserver row_color_blue">
                                                                    <div class="width_server">
                                                                        <label>
                                                                            Client Name
                                                                        </label>
                                                                        <span>
                                                                            <%#Eval("clientname")%>
                                                                        </span>
                                                                    </div>
                                                                    <div class="width_server">
                                                                        <label>
                                                                            Domain
                                                                        </label>
                                                                        <span>
                                                                            <%#Eval("domain")%>
                                                                        </span>
                                                                    </div>
                                                                    <div class="clear">
                                                                    </div>
                                                                </div>
                                                                <div class="rowserver row_color_yellow">
                                                                    <div class="width_server">
                                                                        <label>
                                                                            Server ID
                                                                        </label>
                                                                        <span>
                                                                            <%#Eval("servercode")%>
                                                                        </span>
                                                                    </div>
                                                                    <div class="width_server">
                                                                        <label>
                                                                            Server name
                                                                        </label>
                                                                        <span>
                                                                            <%#Eval("servername")%>
                                                                        </span>
                                                                    </div>
                                                                    <div class="clear">
                                                                    </div>
                                                                </div>
                                                            </ItemTemplate>
                                                            <FooterTemplate>
                                                            </FooterTemplate>
                                                        </asp:Repeater>
                                                        <div class="clear">
                                                        </div>
                                                        <div class="clear">
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="line">
                                                </div>
                                                <div class="clear">
                                                </div>
                                                <div class="server_inner">
                                                    <div class="nodatafound" id="div1" runat="server">
                                                        No data found
                                                    </div>
                                                    <asp:Repeater ID="rptconfig" runat="server" OnItemDataBound="rptconfig_ItemDataBound">
                                                        <ItemTemplate>
                                                            <div class="server_inner">
                                                                <h2 class="heading_2">
                                                                    <%#Eval("type")%>
                                                                </h2>
                                                                <div class="clear">
                                                                </div>
                                                                <div class="server_box mar20 row_color_blue">
                                                                    <asp:DataList ID="rptconfig_inner" runat="server" RepeatColumns="2" Width="100%"
                                                                        CellPadding="0" RepeatDirection="Horizontal" CellSpacing="0">
                                                                        <ItemTemplate>
                                                                            <div class="width_server">
                                                                                <label>
                                                                                    <%#Eval("name")%>:
                                                                                </label>
                                                                                <span>
                                                                                    <%#Eval("configvalue")%>
                                                                                </span>
                                                                            </div>
                                                                            <div class="clear">
                                                                            </div>
                                                                        </ItemTemplate>
                                                                        <ItemStyle CssClass="row1" />
                                                                    </asp:DataList>
                                                                </div>
                                                                <div class="clear">
                                                                </div>
                                                            </div>
                                                        </ItemTemplate>
                                                    </asp:Repeater>
                                                </div>
                                            </div>
                                            <h1 class="heading pad30">Log Report
                                            </h1>
                                            <div class="clear">
                                            </div>
                                            <asp:Repeater ID="replogreport" runat="server" OnItemDataBound="replogreport_ItemDataBound">
                                                <ItemTemplate>
                                                    <div class="server_box mar20">
                                                        <div class="date_heding">
                                                            <div class="rowserver">
                                                                <div class="width_server">
                                                                    <label>
                                                                        Date
                                                                    </label>
                                                                    <span>
                                                                        <%#Eval("date")%>
                                                                    </span>
                                                                </div>
                                                                <div class="clear">
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="clear">
                                                        </div>
                                                        <div class="server_inner">
                                                            <h2 class="heading_2">Resourse Status
                                                            </h2>
                                                            <div class="clear">
                                                            </div>
                                                            <div class="server_box">
                                                                <div class="rowserver row_color_blue">
                                                                    <div class="width_server">
                                                                        <label>
                                                                            RAM Utilization
                                                                        </label>
                                                                        <span>
                                                                            <%#Eval("ramutilization")%>
                                                                        </span>
                                                                    </div>
                                                                    <div class="width_server">
                                                                        <label>
                                                                            CPU Utilization
                                                                        </label>
                                                                        <span>
                                                                            <%#Eval("CPUUtilization")%>
                                                                        </span>
                                                                    </div>
                                                                    <div class="clear">
                                                                    </div>
                                                                </div>
                                                                <div class="rowserver row_color_yellow">
                                                                    <div class="width_server">
                                                                        <label>
                                                                            Free Space
                                                                        </label>
                                                                        <span>
                                                                            <%#Eval("UsedSpace")%>
                                                                        </span>
                                                                    </div>
                                                                    <div class="width_server">
                                                                        <label>
                                                                            Updated
                                                                        </label>
                                                                        <span>
                                                                            <%#Eval("IsUpdated")%>
                                                                        </span>
                                                                    </div>
                                                                    <div class="clear">
                                                                    </div>
                                                                </div>
                                                                <div class="rowserver row_color_blue" id="divUpdateSummary" runat="server">
                                                                    <div class="width_server" style="width: 98%;">
                                                                        <label>
                                                                            Update Summary
                                                                        </label>
                                                                        <span>
                                                                            <%#Eval("UpdateSummary")%>
                                                                        </span>
                                                                    </div>
                                                                    <div class="clear">
                                                                    </div>
                                                                </div>
                                                                <div class="rowserver row_color_yellow">
                                                                    <div class="width_server">
                                                                        <label>
                                                                            Backup
                                                                        </label>
                                                                        <span>
                                                                            <%#Eval("TakenBackup")%>
                                                                        </span>
                                                                    </div>
                                                                    <div class="width_server">
                                                                        <span>
                                                                            <%#Eval("BackupDescription")%>
                                                                        </span>
                                                                    </div>
                                                                    <div class="clear">
                                                                    </div>
                                                                </div>
                                                                <div class="clear">
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="line">
                                                        </div>
                                                        <div class="clear">
                                                        </div>
                                                        <div class="server_inner">
                                                            <h2 class="heading_2">Log Entry
                                                            </h2>
                                                            <div class="clear">
                                                            </div>
                                                            <div class="server_box ">
                                                                <asp:Repeater ID="rptlogentry" runat="server">
                                                                    <HeaderTemplate>
                                                                        <table width="100%" cellpadding="4" cellspacing="0" class="tblsheet">
                                                                            <tr class="gridheader">
                                                                                <th>S. No.
                                                                                </th>
                                                                                <th>Log Type
                                                                                </th>
                                                                                <th>Eventid
                                                                                </th>
                                                                                <th>Description
                                                                                </th>
                                                                                <th>Severity Level
                                                                                </th>
                                                                                <th>Action
                                                                                </th>
                                                                                <th>Remark
                                                                                </th>
                                                                            </tr>
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <tr class="row_color_yellow">
                                                                            <td>
                                                                                <%#Container.ItemIndex+1 %>
                                                                            </td>
                                                                            <td>
                                                                                <%#Eval("LogType")%>
                                                                            </td>
                                                                            <td>
                                                                                <%#Eval("EventID")%>
                                                                            </td>
                                                                            <td>
                                                                                <%#Eval("Description")%>
                                                                            </td>
                                                                            <td>
                                                                                <%#Eval("Severity")%>
                                                                            </td>
                                                                            <td>
                                                                                <%#Eval("ActionPerformed")%>
                                                                            </td>
                                                                            <td>
                                                                                <%#Eval("Remark")%>
                                                                            </td>
                                                                        </tr>
                                                                        <%--<asp:HiddenField ID="hidconfigid" runat="server" Value=' <%#Eval("nid")%>' />
                                                                <asp:HiddenField ID="hidserverconfigid" runat="server" />--%>
                                                                    </ItemTemplate>
                                                                    <FooterTemplate>
                                                                        </table>
                                                                    </FooterTemplate>
                                                                </asp:Repeater>
                                                                <div class="clear">
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="line">
                                                        </div>
                                                        <div class="clear">
                                                        </div>
                                                        <div class="server_inner">
                                                            <h2 class="heading_2">Attachments
                                                            </h2>
                                                            <div class="clear">
                                                            </div>
                                                            <div class="nodatafound" id="divnoattachment" runat="server" visible="false">
                                                                No Attachment Exists
                                                            </div>
                                                            <asp:Repeater ID="repattachment" runat="server" OnItemCommand="repattachment_ItemCommand">
                                                                <HeaderTemplate>
                                                                    <table width="100%" cellpadding="4" cellspacing="0" id="Table1" class="tblsheet"
                                                                        style="margin-bottom: 20px;">
                                                                        <tr class="gridheader">
                                                                            <th>Title
                                                                            </th>
                                                                            <th>Attachment
                                                                            </th>
                                                                        </tr>
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <tr>
                                                                        <td>
                                                                            <%#Eval("title")%>
                                                                        </td>
                                                                        <td>
                                                                            <asp:LinkButton ID="lbndownload" runat="server" CommandName="download" ToolTip="Download file"
                                                                                ForeColor="#308CC1" Font-Bold="false" CommandArgument='<%#Eval("uploadfilename") + ";" + Eval("originalfilename") %>'>
                                                   
                                                        <%#Eval("originalfilename").ToString()%>
                                                                            </asp:LinkButton>
                                                                        </td>
                                                                    </tr>
                                                                </ItemTemplate>
                                                                <FooterTemplate>
                                                                    </table>
                                                                </FooterTemplate>
                                                            </asp:Repeater>
                                                        </div>
                                                        <div class="clear">
                                                        </div>
                                                    </div>
                                                    <div class="clear">
                                                    </div>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                            <div id="divnolog" runat="server" class="nodatafound">
                                                No Log Exists
                                            </div>
                                        </div>
                                        <div id="divdetailreport" runat="server" style="display: none;">
                                            <asp:Literal ID="ltrreport" runat="server"></asp:Literal>
                                            <table width="100%" cellpadding="5" cellspacing="0" style="font-family: Calibri; font-size: 12px; text-align: left;"
                                                border="0">
                                                <tr>
                                                    <td style="font-weight: bold;" align="left" colspan="7">
                                                        <h2>Server Log Report From
                                                            <asp:Literal ID="litfromdate1" runat="server"></asp:Literal>&nbsp;To&nbsp;<asp:Literal
                                                                ID="littodate1" runat="server"></asp:Literal>
                                                        </h2>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="7">&nbsp;
                                                    </td>
                                                </tr>
                                            </table>
                                            <table width="500" cellpadding="5" cellspacing="0" style="font-family: Calibri; font-size: 12px; text-align: left;"
                                                border="0">
                                                <tr>
                                                    <td>
                                                        <asp:Repeater ID="rptinner1" runat="server">
                                                            <HeaderTemplate>
                                                                <table border="1">
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <tr style="font-weight: bold; background: #395ba4; color: #ffffff;">
                                                                    <td align="left" colspan="2">Client Name
                                                                    </td>
                                                                    <td align="left" style="font-weight: bold;">Server ID
                                                                    </td>
                                                                    <td align="left" style="font-weight: bold;" colspan="2">Server name
                                                                    </td>
                                                                    <td align="left" style="font-weight: bold;" colspan="2">Domain
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td align="left" style="font-weight: bold;" colspan="2">
                                                                        <%#Eval("clientname")%>
                                                                    </td>
                                                                    <td align="left" style="font-weight: bold;">
                                                                        <%#Eval("servercode")%>
                                                                    </td>
                                                                    <td align="left" style="font-weight: bold;" colspan="2">
                                                                        <%#Eval("servername")%>
                                                                    </td>
                                                                    <td align="left" style="font-weight: bold;" colspan="2">
                                                                        <%#Eval("domain")%>
                                                                    </td>
                                                                </tr>
                                                            </ItemTemplate>
                                                            <FooterTemplate>
                                                                </table>
                                                            </FooterTemplate>
                                                        </asp:Repeater>
                                                    </td>
                                                </tr>
                                            </table>
                                            <asp:Repeater ID="rptconfig1" runat="server" OnItemDataBound="rptconfig1_ItemDataBound">
                                                <HeaderTemplate>
                                                    <table width="500" cellpadding="5" cellspacing="0" style="font-family: Calibri; font-size: 12px; text-align: left;"
                                                        border="0">
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <tr>
                                                        <td align="left" style="color: #395ba4; float: left; font-size: 16px; letter-spacing: 1px; padding-bottom: 8px;">
                                                            <h3>
                                                                <%#Eval("type")%>
                                                            </h3>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="left">
                                                            <asp:DataList ID="rptconfig_inner1" runat="server" RepeatColumns="2" Width="100%"
                                                                CellPadding="0" RepeatLayout="Flow" RepeatDirection="Horizontal" CellSpacing="0">
                                                                <HeaderTemplate>
                                                                    <table width="100%" border="1">
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <tr>
                                                                        <td align="left" style="font-weight: bold;" width="100">
                                                                            <%#Eval("name")%>
                                                                        </td>
                                                                        <td align="left" colspan="6">
                                                                            <%#Eval("configvalue")%>
                                                                        </td>
                                                                    </tr>
                                                                </ItemTemplate>
                                                                <FooterTemplate>
                                                                    </table>
                                                                </FooterTemplate>
                                                            </asp:DataList>
                                                        </td>
                                                    </tr>
                                                </ItemTemplate>
                                                <FooterTemplate>
                                                    </table>
                                                </FooterTemplate>
                                            </asp:Repeater>
                                            <asp:Repeater ID="replogreport1" runat="server" OnItemDataBound="replogreport1_ItemDataBound">
                                                <HeaderTemplate>
                                                    <table width="500" cellpadding="5" cellspacing="0" style="font-family: Calibri; font-size: 12px; text-align: left;"
                                                        border="0">
                                                        <tr>
                                                            <td>&nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="font-weight: bold; font-size: 23px; color: #A91D12;">Log Report
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td></td>
                                                        </tr>
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <tr>
                                                        <td align="left" style="background: #EDF177; color: #000000; font-size: 16px; font-weight: bold;">
                                                            <%#Eval("date")%>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="color: #395ba4; float: left; font-size: 16px; letter-spacing: 1px; padding-bottom: 8px;">
                                                            <h3>Resourse Status
                                                            </h3>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table width="100%" border="1">
                                                                <tr>
                                                                    <td align="left" style="font-weight: bold;" width="100">RAM Utilization
                                                                    </td>
                                                                    <td align="left" colspan="6">
                                                                        <%#Eval("ramutilization")%>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td align="left" style="font-weight: bold;" width="100">CPU Utilization
                                                                    </td>
                                                                    <td align="left" colspan="6">
                                                                        <%#Eval("CPUUtilization")%>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td align="left" style="font-weight: bold;" width="100">Free Space
                                                                    </td>
                                                                    <td align="left" colspan="6">
                                                                        <%#Eval("UsedSpace")%>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td align="left" style="font-weight: bold;" width="100">Updated
                                                                    </td>
                                                                    <td align="left" colspan="6">
                                                                        <%#Eval("IsUpdated")%>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td align="left" style="font-weight: bold;" width="100">Update Summary
                                                                    </td>
                                                                    <td align="left" colspan="6">
                                                                        <%#Eval("UpdateSummary")%>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="color: #395ba4; float: left; font-size: 16px; letter-spacing: 1px; padding-bottom: 8px;">
                                                            <h3>Log Entry
                                                            </h3>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Repeater ID="rptlogentry1" runat="server">
                                                                <HeaderTemplate>
                                                                    <table width="100%" cellspacing="0" border="1" class="tblsheet">
                                                                        <tr class="gridheader">
                                                                            <th align="left" width="50">S. No.
                                                                            </th>
                                                                            <th align="left">Log Type
                                                                            </th>
                                                                            <th align="left">Eventid
                                                                            </th>
                                                                            <th align="left">Description
                                                                            </th>
                                                                            <th align="left">Severity Level
                                                                            </th>
                                                                            <th align="left">Action
                                                                            </th>
                                                                            <th align="left">Remark
                                                                            </th>
                                                                        </tr>
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <tr>
                                                                        <td align="left">
                                                                            <%#Container.ItemIndex+1 %>
                                                                        </td>
                                                                        <td align="left">
                                                                            <%#Eval("LogType")%>
                                                                        </td>
                                                                        <td align="left">
                                                                            <%#Eval("EventID")%>
                                                                        </td>
                                                                        <td align="left">
                                                                            <%#Eval("Description")%>
                                                                        </td>
                                                                        <td align="left">
                                                                            <%#Eval("Severity")%>
                                                                        </td>
                                                                        <td align="left">
                                                                            <%#Eval("ActionPerformed")%>
                                                                        </td>
                                                                        <td align="left">
                                                                            <%#Eval("Remark")%>
                                                                        </td>
                                                                    </tr>
                                                                </ItemTemplate>
                                                                <FooterTemplate>
                                                                    </table>
                                                                </FooterTemplate>
                                                            </asp:Repeater>
                                                        </td>
                                                    </tr>
                                                </ItemTemplate>
                                                <FooterTemplate>
                                                    </table>
                                                </FooterTemplate>
                                            </asp:Repeater>
                                        </div>
                                    </asp:View>
                                </asp:MultiView>
                            </div>
                            <div class="clear">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--Log POP UP div goes here-->
            <div id="divlog" class="itempopup" style="width: 650px;">
                <div class="popup_heading">
                    <span id="Span1" runat="server">Log Details</span>
                    <div class="f_right">
                        <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
                    </div>
                </div>
                <div class="innerpopup">
                    <div class="f_left">
                        <b>
                            <asp:Literal ID="ltrloghead" runat="server">Log Details</asp:Literal>
                        </b>
                    </div>
                    <div class="clear">
                    </div>
                    <div class="line" style="margin-top: 3px;">
                    </div>
                    <asp:Repeater ID="rptstatus" runat="server">
                        <HeaderTemplate>
                            <table cellspacing="0" cellpadding="4" border="1" style="width: 100%;" class="tblsheet">
                                <tbody>
                                    <tr class="gridheader">
                                        <th width="15%">Event ID
                                        </th>
                                        <th>Description
                                        </th>
                                        <th width="15%">Severity
                                        </th>
                                        <th width="20%">Action Performed
                                        </th>
                                        <th width="20%">Remark
                                        </th>
                                    </tr>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr class="odd">
                                <td width="10%">
                                    <%#Eval("EventID")%>
                                </td>
                                <td>
                                    <%#Eval("Description")%>
                                </td>
                                <td width="15%">
                                    <%#Eval("Severity")%>
                                </td>
                                <td width="20%">
                                    <%#Eval("ActionPerformed")%>
                                </td>
                                <td width="20%">
                                    <%#Eval("Remark")%>
                                </td>
                            </tr>
                        </ItemTemplate>
                        <AlternatingItemTemplate>
                            <tr class="even">
                                <td width="10%">
                                    <%#Eval("EventID")%>
                                </td>
                                <td>
                                    <%#Eval("Description")%>
                                </td>
                                <td width="15%">
                                    <%#Eval("Severity")%>
                                </td>
                                <td width="20%">
                                    <%#Eval("ActionPerformed")%>
                                </td>
                                <td width="20%">
                                    <%#Eval("Remark")%>
                                </td>
                            </tr>
                        </AlternatingItemTemplate>
                        <FooterTemplate>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>
                    <div class="clear">
                    </div>
                </div>
            </div>
            <!---POP UP DIVs HTML to Show attachments goes here--->
            <div style="width: 600px; position: fixed;" id="divattachment" class="itempopup">
                <div class="popup_heading">
                    <span id="Span3" runat="server">Attachments</span>
                    <div class="f_right">
                        <img src="images/cross.png" onclick="closediv1();" alt="X" title="Close Window" />
                    </div>
                </div>
                <div class="clear">
                </div>
                <div style="height: 250px; overflow: auto; padding: 5px 10px">
                    <asp:Repeater ID="repattachment1" runat="server" OnItemCommand="repattachment1_ItemCommand">
                        <ItemTemplate>
                            <div style="margin-top: 4px;">
                                <div class="floatleft" style="font-size: 14px;">
                                    <img src="images/calendar_arrow_right.png" height="11" style="margin-top: 2px;" />&nbsp;
                                    <asp:LinkButton ID="lbtnattachment" runat="server" CommandName="download" ToolTip="Download file"
                                        ForeColor="#308CC1" Font-Bold="false" CommandArgument='<%#Eval("uploadfilename") + ";" + Eval("originalfilename") %>'><%# DataBinder.Eval(Container.DataItem, "originalfilename")%></asp:LinkButton>
                                </div>
                            </div>
                            <div class="clear">
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnexportcsv" />
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>
