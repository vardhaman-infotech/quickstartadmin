<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="rpt_LeaveRegister.aspx.cs" Inherits="empTimeSheet.LeaveReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="css/defaultTheme.css" type="text/css" />
      <script src="js/jquery.fixedheadertable.js"></script>
    <script>
        function fixSchedule() {
            $('#myTable05').fixedHeaderTable({
                altClass: 'odd',
                footer: true,
                fixedColumns: 1,
            });

        }
    </script>
    <script type="text/javascript">
        function showhidemonth(selectedvalue) {
            if (selectedvalue == "Monthly Report") {
                document.getElementById("divsearchbymonth").style.display = "block";
            }
            else {
                document.getElementById("divsearchbymonth").style.display = "none";

            }
        }

        function showdiv(empid, month) {
            document.getElementById("ifmanage").src = "LeaveDetails.aspx?empid=" + empid + "&month=" + month + "&year=" + document.getElementById("ctl00_ContentPlaceHolder1_hidyear").value;
            document.getElementById("divdetails").style.display = "block";
            document.getElementById("otherdiv").style.display = "block";

        }
        function closediv() {
            document.getElementById("divdetails").style.display = "none";
            document.getElementById("otherdiv").style.display = "none";
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <pg:progress ID="progress1" runat="server" />
    <div id="otherdiv" onclick="closediv();">
    </div>
    <div class="pageheader">
        <h2>
            <i class="fa fa-clipboard"></i>Leave Report
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
          <asp:UpdatePanel ID="updatePanelData" runat="server">
                            <ContentTemplate>
        <div class="row">
            <div class="col-sm-12 col-md-12">
                <div class="panel panel-default">
                    <div class="col-sm-12 col-md-10">
                        <div style="padding-top: 10px;">
                            <div class="col-xs-12 col-sm-12 col-md-12 f_left" style="padding: 0px;">
                                <h5 class="subtitle mb5">
                                    Employee Leave Register</h5>
                            </div>
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl lbl2">Report :</label>
                                <div class="txt w1 mar10">
                                <asp:DropDownList ID="dropReportType" runat="server" CssClass="form-control"
                                    onchange="showhidemonth(this.value);">
                                    <asp:ListItem>Monthly Report</asp:ListItem>
                                    <asp:ListItem>Yearly Report</asp:ListItem>
                                </asp:DropDownList>
                                    </div>
                            </div>
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl lbl2">Year :</label>
                                <div class="txt w1 mar10">
                                <asp:DropDownList ID="dropyear" runat="server" CssClass="form-control">
                                </asp:DropDownList>
                                    </div>
                            </div>
                            <div class="ctrlGroup searchgroup" id="divsearchbymonth">
                                <label class="lbl lbl2">Month :</label>
                                <div class="txt w1 mar10">
                                <asp:DropDownList ID="dropmonth" runat="server" CssClass="form-control">
                                    <asp:ListItem Value="1">January</asp:ListItem>
                                    <asp:ListItem Value="2">Feburary</asp:ListItem>
                                    <asp:ListItem Value="3">March</asp:ListItem>
                                    <asp:ListItem Value="4">April</asp:ListItem>
                                    <asp:ListItem Value="5">May</asp:ListItem>
                                    <asp:ListItem Value="6">June</asp:ListItem>
                                    <asp:ListItem Value="7">July</asp:ListItem>
                                    <asp:ListItem Value="8">August</asp:ListItem>
                                    <asp:ListItem Value="9">September</asp:ListItem>
                                    <asp:ListItem Value="10">October</asp:ListItem>
                                    <asp:ListItem Value="11">November</asp:ListItem>
                                    <asp:ListItem Value="12">December</asp:ListItem>
                                </asp:DropDownList>
                                    </div>
                            </div>
                            <div class="ctrlGroup searchgroup">
                                <asp:Button ID="btnsearch" runat="server" Text="View Report" CssClass="btn btn-default"
                                    OnClick="btnsearch_Click" />
                            </div>
                        </div>
                    </div>
                    <div class="clear">
                    </div>
                    <div class="col-sm-12 col-md-12 mar2">
                      
                                <div class="panel-body2 ">
                                    <div class="row">
                                        <div class="table-responsive">
                                             <div class="table-responsive">
                                            <div class="nodatafound" id="divnodata" runat="server">
                                                No data found
                                            </div>
                                            <div style="width: 99%; overflow: auto; height:400px; margin-top:15px;" id="divdata" runat="server">
                                              
                                            </div>
                                        </div>
                                        </div>
                                    </div>
                                </div>
                                <input type="hidden" id="hidreportype" runat="server" />
                                <input type="hidden" id="hidyear" runat="server" />
                                <input type="hidden" id="hidmonth" runat="server" />
                          
                    </div>
                    <div class="clear">
                    </div>
                </div>
            </div>
        </div>
                                </ContentTemplate>
              </asp:UpdatePanel>
    </div>
    <div id="divdetails" class="itempopup" style="width: 680px;">
        <div class="popup_heading">
            <span id="spanstatushead" runat="server">Employee Leave Report</span>
            <div class="f_right">
                <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
            </div>
        </div>
        <div class="innerpopup">
            <div>
                <div class="f_left">
                    <label class="pad3">
                        <b>Leave Details </b>
                    </label>
                </div>
                <div class="clear">
                </div>
                <div class="line" style="margin-bottom: 5px;">
                </div>
                <iframe id="ifmanage" width="100%" frameborder="0" noresize="noresize" height="422px"
                    scrolling="auto"></iframe>
            </div>
        </div>
    </div>
</asp:Content>
