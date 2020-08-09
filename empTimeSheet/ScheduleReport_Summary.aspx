<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="ScheduleReport_Summary.aspx.cs" Inherits="empTimeSheet.ScheduleReport_Summary" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="css/defaultTheme.css" type="text/css" />
      <script src="js/jquery.fixedheadertable.js"></script>
    <script>
        function fixSchedule()
        {
            $('#myTable05').fixedHeaderTable({
                altClass: 'odd',
                footer: true,
                fixedColumns: 1,
            });

        }
    </script>
    <style type="text/css">
       
    </style>
   
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <pg:progress ID="progress1" runat="server" />
    <div id="otherdiv" onclick="closediv();">
    </div>
    <div class="pageheader">
        <h2>
            <i class="fa fa-home"></i>Schedule Summary Report
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
                                <h5 class="subtitle mb5">Schedule Summary Report</h5>
                            </div>
                            <div class="col-sm-12 col-md-3 clear pad4">
                                <asp:DropDownList ID="dropsearchscheduletype" runat="server" CssClass="form-control mar">
                                    <asp:ListItem Value="Field">Field Work</asp:ListItem>
                                    <asp:ListItem Value="Office">Office Work</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-sm-12 col-md-3 f_left pad5 ">
                                <asp:DropDownList ID="dropyear" runat="server" CssClass="form-control mar">
                                </asp:DropDownList>
                            </div>
                            <div class="clear"></div>
                            <div class="col-sm-12 col-md-3 f_left clear pad4">
                                <asp:DropDownList ID="dropfrommonth" runat="server" CssClass="form-control mar">
                                    <asp:ListItem Value="">--Month From--</asp:ListItem>
                                    <asp:ListItem Value="01" Selected="True">January</asp:ListItem>
                                    <asp:ListItem Value="02">Feburary</asp:ListItem>
                                    <asp:ListItem Value="03">March</asp:ListItem>
                                    <asp:ListItem Value="04">April</asp:ListItem>
                                    <asp:ListItem Value="05">May</asp:ListItem>
                                    <asp:ListItem Value="06">June</asp:ListItem>
                                    <asp:ListItem Value="07">July</asp:ListItem>
                                    <asp:ListItem Value="08">August</asp:ListItem>
                                    <asp:ListItem Value="09">September</asp:ListItem>
                                    <asp:ListItem Value="10">October</asp:ListItem>
                                    <asp:ListItem Value="11">November</asp:ListItem>
                                    <asp:ListItem Value="12">December</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-sm-12 col-md-3 f_left pad5">
                                <asp:DropDownList ID="droptomonth" runat="server" CssClass="form-control mar">
                                    <asp:ListItem Value="">--Month To--</asp:ListItem>
                                    <asp:ListItem Value="01">January</asp:ListItem>
                                    <asp:ListItem Value="02">Feburary</asp:ListItem>
                                    <asp:ListItem Value="03">March</asp:ListItem>
                                    <asp:ListItem Value="04">April</asp:ListItem>
                                    <asp:ListItem Value="05">May</asp:ListItem>
                                    <asp:ListItem Value="06">June</asp:ListItem>
                                    <asp:ListItem Value="07">July</asp:ListItem>
                                    <asp:ListItem Value="08">August</asp:ListItem>
                                    <asp:ListItem Value="09">September</asp:ListItem>
                                    <asp:ListItem Value="10">October</asp:ListItem>
                                    <asp:ListItem Value="11">November</asp:ListItem>
                                    <asp:ListItem Value="12" Selected="True">December</asp:ListItem>
                                </asp:DropDownList>
                                <input type="hidden" id="txtfrmdate" runat="server" />
                                <input type="hidden" id="txttodate" runat="server" />
                            </div>
                            <%--  <div class="col-sm-4 col-md-4 f_left clear pad4 ">
                                <div class="input-group mar">
                                    <asp:TextBox ID="txtfrmdate" runat="server" placeholder="From Date" CssClass="form-control hasDatepicker"></asp:TextBox>
                                    <span class="input-group-addon" id="spantxtfrmdate"><i class="fa fa-fw"></i></span>
                                    <cc1:CalendarExtender ID="txtDate_CalendarExtender" runat="server" TargetControlID="txtfrmdate"
                                        PopupButtonID="spantxtfrmdate" Format="MM/dd/yyyy">
                                    </cc1:CalendarExtender>
                                </div>
                            </div>
                            <div class="col-sm-6 col-md-4  pad5">
                                <div class="input-group mar">
                                    <asp:TextBox ID="txttodate" runat="server" placeholder="To Date" CssClass="form-control hasDatepicker"></asp:TextBox>
                                    
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txttodate"
                                        PopupButtonID="spantxttodate" Format="MM/dd/yyyy">
                                    </cc1:CalendarExtender>
                                </div>
                            </div>--%>
                            <div class="col-sm-12 col-md-3 pad5">
                                <asp:Button ID="btnsearch" runat="server" Text="View Report" CssClass="btn btn-default mar"
                                    OnClick="btnsearch_Click" />
                            </div>
                        </div>
                    </div>
                    <div class="clear">
                    </div>
                    <div class="col-sm-12 col-md-12 ">
                        
                        <div class="clear">
                        </div>
                        <asp:UpdatePanel ID="updatePanelData" runat="server">
                            <ContentTemplate>
                                <div class="panel-body2 ">
                                    <div class="row">
                                        <div class="table-responsive">
                                            <div class="nodatafound" id="divnodata" runat="server">
                                                No data found
                                            </div>
                                            <div style="width: 99%; overflow: auto; height:400px; margin-top:15px;" id="divdata" runat="server">
                                              
                                            </div>
                                        </div>
                                    </div>
                                </div>
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
