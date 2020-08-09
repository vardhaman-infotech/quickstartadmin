<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="CumulativeReport.aspx.cs" Inherits="empTimeSheet.CumulativeReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <pg:progress ID="progress1" runat="server" />
    <div class="pageheader">
        <h2>
            <i class="fa fa-clipboard"></i>Cumulative Report
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
                            <div class="col-xs-12 col-sm-12 col-md-12 f_left" style="padding: 0px;">
                                <h5 class="subtitle mb5">
                                    Cumulative Report</h5>
                            </div>
                            <div class="ctrlGroup searchgroup">
                               <label class="lbl lbl2">From Date :</label>
                                <div class="txt w1 mar10">
                                    <asp:TextBox ID="txtfromdate" runat="server" placeholder="From Date" CssClass="form-control hasDatepicker"></asp:TextBox>
                                    
                                    <cc1:CalendarExtender ID="cc1" runat="server" TargetControlID="txtfromdate" PopupButtonID="txtfromdate"
                                        Format="MM/dd/yyyy">
                                    </cc1:CalendarExtender>
                               </div>
                            </div>
                            <div class="ctrlGroup searchgroup">
                               <label class="lbl lbl2">To Date :</label>
                                 <div class="txt w1">
                                    <asp:TextBox ID="txttodate" runat="server" placeholder="To Date" CssClass="form-control hasDatepicker"></asp:TextBox>
                                    
                                    <cc1:CalendarExtender ID="cc2" runat="server" TargetControlID="txttodate" PopupButtonID="txttodate"
                                        Format="MM/dd/yyyy">
                                    </cc1:CalendarExtender>
                               </div>
                            </div>
                            <div class="clear"></div>
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl lbl2">Manager :</label>
                                <div class="txt w1 mar10">
                                <asp:DropDownList ID="dropassign" runat="server" CssClass="form-control">
                                </asp:DropDownList>
                                    </div>
                            </div>
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl lbl2">Employee :</label>
                                <div class="txt w2">
                                <asp:DropDownList ID="dropemployee" runat="server" CssClass="form-control">
                                </asp:DropDownList>
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
                            <asp:UpdatePanel ID="updatePanelSearch" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl2">Client :</label>
                                        <div class="txt w2">
                                        <asp:DropDownList ID="dropclient" runat="server" CssClass="form-control"
                                            AutoPostBack="true" OnSelectedIndexChanged="dropclient_OnSelectedIndexChanged">
                                        </asp:DropDownList>
                                            </div>
                                        
                                    </div>
                                    <div class="clear"></div>
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl2">Project :</label>
                                        <div class="txt w1 mar10">
                                        <asp:DropDownList ID="dropproject" runat="server" CssClass="form-control">
                                        </asp:DropDownList>
                                            </div>
                                    </div>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                            
                            
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl lbl2 disNone">&nbsp;</label>
                                <asp:Button ID="btnsearch" runat="server" Text="View Report" CssClass="btn btn-default"
                                    OnClick="btnsearch_Click" />
                            </div>
                        </div>
                    </div>
                    <div class="clear">
                    </div>
                    <div class="col-sm-12 col-md-12 mar2">
                        <asp:UpdatePanel ID="updatePanelData" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="false">
                            <ContentTemplate>
                                <div id="otherdiv" onclick="closediv();">
                                </div>
                                <div class="f_right" style="padding-top: 10px;">
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
                                <div class="panel-body2 ">
                                    <div class="row">
                                        <div class="table-responsive">
                                            <div class="nodatafound" id="divnodata" runat="server">
                                                No data found</div>
                                            <asp:GridView ID="dgnews" runat="server" AllowPaging="true" AutoGenerateColumns="true"
                                                CellPadding="4" CellSpacing="0" Width="100%" ShowHeader="true" PageSize="100"
                                                ShowFooter="false" CssClass="table table-success mb30 tblsheet" GridLines="None"
                                                AllowSorting="true" OnPageIndexChanging="dgnews_PageIndexChanging">
                                                <Columns>
                                                </Columns>
                                                <PagerStyle CssClass="gridpager" HorizontalAlign="Center" />
                                            </asp:GridView>
                                        </div>
                                    </div>
                                </div>
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
</asp:Content>
