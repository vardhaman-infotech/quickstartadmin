<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="PerformanceReport.aspx.cs" Inherits="empTimeSheet.PerformanceReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:UpdatePanel ID="upadatepanel" runat="server">
        <ContentTemplate>
            <pg:progress ID="progress1" runat="server" />
            <div id="otherdiv" onclick="closediv();">
            </div>
            <div class="pageheader">
                <h2>
                    <i class="fa fa-clipboard"></i>Performance Report
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
                <div class="row">
                    <div class="col-sm-12 col-md-12">
                        <div class="panel panel-default">
                            <div class="col-sm-12 col-md-10">
                                <div style="padding-top: 10px;">
                                    <div class="col-xs-12 col-sm-12 col-md-12 f_left" style="padding: 0px;">
                                        <h5 class="subtitle mb5">
                                            Performance Report</h5>
                                    </div>
                                    <div class="ctrlGroup searchgroup">
                                       <label class="lbl lbl2">From Date :</label>
                                        <div class="txt w1 mar10">
                                            <asp:TextBox ID="txtfromdate" runat="server" placeholder="From Date" CssClass="form-control hasDatepicker"></asp:TextBox>
                                            
                                            <cc1:CalendarExtender ID="txtDate_CalendarExtender" runat="server" TargetControlID="txtfromdate"
                                                PopupButtonID="txtfromdate" Format="MM/dd/yyyy">
                                            </cc1:CalendarExtender>
                                       </div>
                                    </div>
                                    <div class="ctrlGroup searchgroup">
                                       <label class="lbl lbl2">To Date :</label>
                                        <div class="txt w1">
                                            <asp:TextBox ID="txttodate" runat="server" placeholer="To Date" CssClass="form-control hasDatepicker"></asp:TextBox>
                                            
                                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txttodate"
                                                PopupButtonID="txttodate" Format="MM/dd/yyyy">
                                            </cc1:CalendarExtender>
                                      </div>
                                    </div>
                                    <div class="clear"></div>
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl2">Task :</label>
                                        <div class="txt w1 mar10">
                                        <asp:DropDownList ID="droptask" runat="server" CssClass="form-control">
                                        </asp:DropDownList>
                                            </div>
                                    </div>
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl2">Client :</label>
                                        <div class="txt w2">
                                        <asp:DropDownList ID="dropclient" runat="server" CssClass="form-control">
                                        </asp:DropDownList>
                                            </div>
                                    </div>
                                    <%--  <asp:DropDownList ID="dropproject" runat="server" CssClass="form_2_input5">
                    </asp:DropDownList>--%>
                                    <div class="clear"></div>
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl2">Employee :</label>
                                        <div class="txt w1 mar10">
                                        <asp:DropDownList ID="dropemployee" runat="server" CssClass="form-control">
                                        </asp:DropDownList>
                                            </div>
                                    </div>
                                    
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl2 disNone">&nbsp; </label>
                                        <asp:Button ID="btnsearch" runat="server" CssClass="btn btn-default" Text="View Report"
                                            OnClick="btnsearch_click" />
                                    </div>
                                </div>
                            </div>
                            <div class="clear">
                            </div>
                            <div class="col-sm-12 col-md-12 mar2">
                                <div class="panel panel-default">
                                    <div class="panel-body2 ">
                                        <div class="row">
                                            <div class="table-responsive">
                                                <div class="nodatafound" id="divnodata" runat="server">
                                                    No data found</div>
                                                <asp:GridView ID="dgnews" runat="server" AllowPaging="false" AutoGenerateColumns="true"
                                                    CellPadding="4" CellSpacing="0" BorderWidth="0px" Width="100%" ShowHeader="true"
                                                    ShowFooter="false" CssClass="table table-success mb30" GridLines="None">
                                                    <HeaderStyle CssClass="gridheader" />
                                                </asp:GridView>
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
            </div>
            <div id="divreport" runat="server" style="display: none; margin: 5px;">
                <asp:Literal ID="ltrreport" runat="server"></asp:Literal>
                <asp:Repeater ID="rptreport" runat="server">
                    <HeaderTemplate>
                        <table cellspacing="0" cellpadding="4" border="1" style="width: 98%;" class="tblsheet">
                            <tbody>
                                <tr class="gridheader">
                                    <td width="10%">
                                        Employee
                                    </td>
                                    <td width="10%">
                                        Total Tasks
                                    </td>
                                    <td width="10%">
                                        Remaining Tasks
                                    </td>
                                    <td width="10%">
                                        Excellent
                                    </td>
                                    <td width="10%">
                                        Average
                                    </td>
                                    <td width="3%">
                                        Good
                                    </td>
                                    <td width="3%">
                                        Below Average
                                    </td>
                                    <td width="10%">
                                        Poor
                                    </td>
                                </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr class="odd">
                            <td width="10%">
                                <%#Eval("Employee")%>
                                <%#Eval("Total Tasks")%>
                            </td>
                            <td width="10%">
                                <%#Eval("Remaining Tasks")%>
                            </td>
                            <td width="25%">
                                <%#Eval("Excellent")%>
                            </td>
                            <td width="25%">
                                <%#Eval("Average")%>
                            </td>
                            <td width="10%">
                                <%#Eval("Good")%>
                            </td>
                            <td width="20%">
                                <%#Eval("Below Average")%>
                            </td>
                            <td width="10%">
                                <%#Eval("Poor")%>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <AlternatingItemTemplate>
                        <tr class="odd">
                            <td width="10%">
                                <%#Eval("Employee")%>
                                <%#Eval("Total Tasks")%>
                            </td>
                            <td width="10%">
                                <%#Eval("Remaining Tasks")%>
                            </td>
                            <td width="25%">
                                <%#Eval("Excellent")%>
                            </td>
                            <td width="25%">
                                <%#Eval("Average")%>
                            </td>
                            <td width="10%">
                                <%#Eval("Good")%>
                            </td>
                            <td width="20%">
                                <%#Eval("Below Average")%>
                            </td>
                            <td width="10%">
                                <%#Eval("Poor")%>
                            </td>
                        </tr>
                    </AlternatingItemTemplate>
                </asp:Repeater>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnexportcsv" />
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>
