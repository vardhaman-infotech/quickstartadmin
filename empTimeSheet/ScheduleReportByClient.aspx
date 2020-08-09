<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="ScheduleReportByClient.aspx.cs" Inherits="empTimeSheet.ScheduleReportByClient" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        function showcustomdate(id) {

            if (document.getElementById(id).value == "Custom") {
                document.getElementById("divdate").style.display = "block";
            }
            else {
                document.getElementById("divdate").style.display = "none";
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <pg:progress ID="progress1" runat="server" />
    <div id="otherdiv" onclick="closediv();">
    </div>
    <div class="pageheader">
        <h2>
            <i class="fa fa-clipboard"></i>Client Schedule Report
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
                            <div class="col-xs-12 col-sm-8 col-md-6 f_left" style="padding: 0px;">
                                <h5 class="subtitle mb5">Schedule Report by Client</h5>
                            </div>
                            <div class="clear"></div>
                            <div class="divsearch">
                                <label class="lblleft">
                                    Date Range
                                </label>

                                <asp:DropDownList ID="dropdaterange" runat="server" CssClass="form-control pad3" onchange="showcustomdate(this.id);">
                                     <asp:ListItem Text="Current Month" Value="Current Month"></asp:ListItem>
                                    <asp:ListItem Text="Current Week" Value="Current Week"></asp:ListItem>
                                   <asp:ListItem Text="Next Month" Value="Next Month"></asp:ListItem>
                                    <asp:ListItem Text="Next Week" Value="Next Week"></asp:ListItem>
                                      <asp:ListItem Text="Custom" Value="Custom"></asp:ListItem>
                                   
                                </asp:DropDownList>

                            </div>
                            <div class="clear"></div>
                            <div id="divdate" style="display: none;">

                                <div class="divsearch mar">
                                    <label class="lblleft">
                                        From Date
                                    </label>

                                    <asp:TextBox ID="txtfrmdate" runat="server" CssClass="form-control hasDatepicker pad3" onchange="comparedate(this.id,'ctl00_ContentPlaceHolder1_txtfrmdate','ctl00_ContentPlaceHolder1_txttodate');"></asp:TextBox>

                                    <cc1:CalendarExtender ID="txtDate_CalendarExtender" runat="server" TargetControlID="txtfrmdate"
                                        PopupButtonID="txtfrmdate" Format="MM/dd/yyyy">
                                    </cc1:CalendarExtender>

                                </div>
                                <div class="divsearch mar">
                                    <label class="lblleft">
                                        To Date
                                    </label>

                                    <asp:TextBox ID="txttodate" runat="server" CssClass="form-control hasDatepicker pad3" onchange="comparedate(this.id,'ctl00_ContentPlaceHolder1_txtfrmdate','ctl00_ContentPlaceHolder1_txttodate');"></asp:TextBox>

                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txttodate"
                                        PopupButtonID="txttodate" Format="MM/dd/yyyy">
                                    </cc1:CalendarExtender>

                                </div>
                                <div class="clear"></div>
                            </div>
                            <div class="clear"></div>

                             <div class="linkadvancesearch" style="margin-top:5px; margin-bottom:5px;">
                                <a onclick="  $('.divadvancesearch').toggle(300);">Advance search?</a>
                            </div>
                            <div class="divadvancesearch">

                            <asp:UpdatePanel ID="updatePanelSearch" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <div class="divsearch mar">
                                        <label class="lblleft">
                                            Client
                                        </label>

                                        <asp:DropDownList ID="drpclient" runat="server" CssClass="form-control pad3"
                                            AutoPostBack="true" OnSelectedIndexChanged="drpclient_OnSelectedIndexChanged">
                                        </asp:DropDownList>

                                    </div>
                                    <div class="divsearch mar">
                                        <label class="lblleft">
                                            Project
                                        </label>

                                        <asp:DropDownList ID="dropproject" runat="server" CssClass="form-control  pad3">
                                        </asp:DropDownList>

                                    </div>


                                </ContentTemplate>
                            </asp:UpdatePanel>
                            <div class="clear"></div>
                            <div class="divsearch mar">
                                <label class="lblleft">
                                    Status
                                </label>

                                <asp:DropDownList ID="dropstatus" runat="server" CssClass="form-control  pad3">
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
                           
                            <div class="divsearch mar">
                                <label class="lblleft">
                                    
                                </label>

                                <asp:Button ID="btnsearch" runat="server" Text="Search" CssClass="btn btn-default"
                                    OnClick="btnsearch_Click" />
                            </div>

                        </div>
                    </div>
                    <div class="clear">
                    </div>
                    <div class="col-sm-12 col-md-12 mar2">
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
                        <asp:UpdatePanel ID="updatePanelData" runat="server">
                            <ContentTemplate>
                                <div class="panel panel-default">
                                    <div class="panel-body2 ">
                                        <div class="row">
                                            <div class="table-responsive">
                                                <div class="nodatafound" id="divnodata" runat="server" visible="false">
                                                    No data found
                                                </div>
                                                <asp:GridView ID="dgnews" runat="server" AllowPaging="true" AutoGenerateColumns="False"
                                                    PageSize="50" CellPadding="4" CellSpacing="0" Width="100%" ShowHeader="true"
                                                    ShowFooter="false" CssClass="table table-success mb30" GridLines="None" AllowSorting="true"
                                                    OnSorting="dgnews_Sorting" OnPageIndexChanging="dgnews_PageIndexChanging">
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="48px">
                                                            <ItemTemplate>
                                                                <%# Container.DataItemIndex + 1 %>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Client Name" SortExpression="clientname">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"clientname")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Project ID" SortExpression="projectcode">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"projectcode")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                        <asp:TemplateField HeaderText="Start Date" SortExpression="fromdate" HeaderStyle-Width="92px">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"fromdate")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="End Date" SortExpression="todate">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"todate")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Staff">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"staff")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Schedule Type" SortExpression="scheduletype" HeaderStyle-Width="115px">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"scheduletype")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Status">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"status")%>
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
                                  <input type="hidden" id="hidfromdate" runat="server" />
                                <input type="hidden" id="hidtodate" runat="server" />
                            </ContentTemplate>
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
