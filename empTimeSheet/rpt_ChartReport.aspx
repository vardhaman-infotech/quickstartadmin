<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="rpt_ChartReport.aspx.cs" Inherits="empTimeSheet.rpt_ChartReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
         .jqx-chart-axis-text
        {
            font-family:'open_sans_semibold';
            font-size:12px;
            color:#333333;
        }
        .jqx-chart-legend-text{
           
        }
        line{
            stroke:#e0e0e0;
        }
        .jqx-chart-title-text{
             font-family:'open_sans_semibold';
              font-size:15px;
        }
        .jqx-chart-tooltip-text{
            display:block;
            padding:10px;
              font-family:'open_sans_semibold';
        }
        
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="pageheader">
        <h2>
            <i class="fa fa-table"></i>Chart Report
        </h2>
        <input type="hidden" id="hidid" runat="server" />
        <div class="breadcrumb-wrapper mar ">
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
                                <label class="lbl lbl3">
                                    Report Type :
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:DropDownList ID="dropreporttype" runat="server" CssClass="form-control">
                                        <asp:ListItem Value="">--Select--</asp:ListItem>
                                        <asp:ListItem Value="Monthly Billing">Monthly Billing</asp:ListItem>
                                        <asp:ListItem Value="Billable Hours">Billable Hours</asp:ListItem>
                                        <asp:ListItem Value="Non-Billable Hours">Non-Billable Hours</asp:ListItem>
                                        <asp:ListItem Value="Un-Billed Time">Un-Billed Time</asp:ListItem>
                                        <asp:ListItem Value="Top Ten Employees">Top Ten Employees</asp:ListItem>
                                        <asp:ListItem Value="Top Ten Activities">Top Ten Activities</asp:ListItem>
                                        <asp:ListItem Value="Top Ten Expenses">Top Ten Expenses</asp:ListItem>
                                        <asp:ListItem Value="Top Ten Clients">Top Ten Clients</asp:ListItem>
                                        <asp:ListItem Value="Top Ten Projects">Top Ten Projects</asp:ListItem>
                                        <asp:ListItem Value="Monthly Expenses">Monthly Expenses</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="ctrlGroup searchgroup">
                                 <label class="lbl lbl3">
                                    Year :
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:DropDownList ID="dropyear" runat="server" CssClass="form-control">
                                    </asp:DropDownList>
                                </div>


                            </div>
                           
                            <div class="ctrlGroup searchgroup">
                                <input type="button" onclick="fillchart();" class="btn btn-default" value="View Report" />

                            </div>




                        </div>



                    </div>
                    <div class="col-sm-12 col-md-12 mar2">


                        <div class="panel panel-default" style="border: none;">
                            <div class="panel-body2 ">
                                <div class="row">
                                    <div class="table-responsive">




                                        <div id="divreport" class="mainrptdiv" visible="false">

                                            <div style="padding-top: 50px; text-align: center; display: none;height: 420px;" id="divreportloader">
                                                <img src="images/loading.gif" />
                                            </div>
                                            <div id='chartContainer' style="width: 100%; height: 420px;"></div>

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
    </div>
    <script type="text/javascript" src="js/chart/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="js/chart/jqxcore.js"></script>
    <script type="text/javascript" src="js/chart/jqxdata.js"></script>
    <script type="text/javascript" src="js/chart/jqxdraw.js"></script>
    <script type="text/javascript" src="js/chart/jqxchart.core.js"></script>

    <script>
        function fillchart() {
            if (document.getElementById("ctl00_ContentPlaceHolder1_dropreporttype").value == "") {
                alert("Select report type");
                return;
            }
            $('#divreportloader').show();
            $('#chartContainer').hide();
            var sampleData;
            var args = { action: document.getElementById("ctl00_ContentPlaceHolder1_dropreporttype").value, year: document.getElementById("ctl00_ContentPlaceHolder1_dropyear").value, companyid: document.getElementById("hidcompanyid").value };

            $.ajax({

                type: "POST",
                url: "rpt_ChartReport.aspx/getChartReport",
                data: JSON.stringify(args),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                cache: false,
                success: function (msg) {
                    if (msg.d != "failure") {

                     

                        var maxValue = 0;
                        var interval = 0;
                        var fieldname = "",yname="";

                        switch (document.getElementById("ctl00_ContentPlaceHolder1_dropreporttype").value) {
                            case "Monthly Billing":
                                fieldname = "Month";
                                yname = "Amount";
                                break;
                            case "Billable Hours":
                                fieldname = "Month";
                                yname = "Hours";
                                break;
                            case "Non-Billable Hours":
                                fieldname = "Month";
                                yname = "Hours";
                                break;
                            case "Un-Billed Time":
                                fieldname = "Month";
                                yname = "Hours";
                                break;
                            case "Top Ten Employees":
                                fieldname = "Employee";
                                yname = "Amount";
                                break;
                            case "Top Ten Activities":
                                fieldname = "Activity";
                                yname = "Amount";
                                break;
                            case "Top Ten Expenses":
                                fieldname = "Expense";
                                yname = "Amount";
                                break;
                            case "Top Ten Clients":
                                fieldname = "Client";
                                yname = "Amount";
                                break;
                            case "Top Ten Projects":
                                fieldname = "Project";
                                yname = "Amount";
                                break;
                            case "Monthly Expenses":
                                fieldname = "Month";
                                yname = "Amount";
                                break;
                            default:
                                fieldname = "Title";
                                yname = "Value";
                                break;

                        }

                        sampleData = jQuery.parseJSON(msg.d);
                        sampleData = JSON.parse(JSON.stringify(sampleData).split('"name":').join('"' + fieldname + '":'));

                        sampleData = JSON.parse(JSON.stringify(sampleData).split('"val":').join('"' + yname + '":'));

                       

                        var comparedate = jQuery.parseJSON(msg.d);
                        if (comparedate.length > 0) {

                            for (var i in comparedate) {
                                if (parseInt(comparedate[i].val) > maxValue) {
                                    maxValue = parseInt(comparedate[i].val);
                                }

                            }
                        }

                        if (maxValue % 10)
                            maxValue = maxValue + (10 - maxValue % 10);
                       
                        maxValue = maxValue + 10;
                        interval = maxValue / 10;
                        interval = parseInt(interval);

                        var settings = {
                            title: document.getElementById("ctl00_ContentPlaceHolder1_dropreporttype").value,
                            description: "",
                            enableAnimations: true,
                            showLegend: false,
                            padding: { left: 5, top: 5, right: 5, bottom: 5 },
                            titlePadding: { left: 90, top: 0, right: 0, bottom: 10 },
                            source: sampleData,
                            xAxis:
                                {
                                    dataField: fieldname,
                                    unitInterval: 1,
                                    axisSize: 'auto',
                                    tickMarks: {
                                        visible: true,
                                        interval: 1,
                                        color: '#ffffff'
                                    },
                                    gridLines: {
                                        visible: true,
                                        interval: 1,
                                        color: '#e0e0e0'
                                    },
                                 
                                   
                                },
                            valueAxis:
                            {
                                unitInterval: interval,
                                minValue: 0,
                                maxValue: maxValue,
                                title: { text: '' },
                                labels: { horizontalAlignment: 'right' },
                                tickMarks: { color: '#ffffff' },
                                gridLinesColor: '#e0e0e0',

                            },
                            colorScheme: 'scheme05',
                            borderLineColor: '#ffffff',
                            seriesGroups:
                                [
                                    {
                                        type: 'stackedcolumn',
                                      
                                        toolTipFormatSettings: { thousandsSeparator: ',' },
                                        seriesGapPercent: 0,
                                        series: [
                                                {
                                                    dataField: yname, displayText: yname
                                                    //labels: {
                                                    //    visible: true,
                                                    //    verticalAlignment: 'top',
                                                    //    offset: { x: 0, y: 15 }
                                                    //}
                                                    

                                                },
                                                {}

                                        ]
                                    }
                                ]
                        };
                        $('#divreportloader').hide();
                        $('#chartContainer').show();
                        // setup the chart
                        // $(".jqx-chart-legend-text:nth-child(3)").css("display", "none");
                        $('#chartContainer').jqxChart(settings);

                        $(".jqx-chart-legend-text:nth-child(3)").css("display", "none");
                        // $('.jqx-chart-legend-text').css("display", "none");
                    }

                },
                error: function (x, e) {
                    $('#divreportloader').hide();
                    $('#chartContainer').show();


                }
            });


        }
    </script>

</asp:Content>
