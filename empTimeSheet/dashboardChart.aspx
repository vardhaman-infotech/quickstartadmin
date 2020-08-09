<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="dashboardChart.aspx.cs" Inherits="empTimeSheet.dashboardChart" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" type="text/css" href="css/DashboardChart.css" />
    <script type="text/javascript" src="js/chart/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="js/chart/jqxcore.js"></script>
    <script type="text/javascript" src="js/chart/jqxdata.js"></script>
    <script type="text/javascript" src="js/chart/jqxdraw.js"></script>
    <script type="text/javascript" src="js/chart/jqxchart.core.js"></script>
<style type="text/css">
    .jqx-chart-legend-text:nth-child(3)
    {
        display:none;
    }
</style>

    <script type="text/javascript">
        $(document).ready(function () {
            var sampleData;
            var args = { empid: window.parent.document.getElementById("hidchatloginid").value };
         
            $.ajax({

                type: "POST",
                url:  "Dashboard.aspx/getEmpMonthlyDetail",
                data: JSON.stringify(args),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                cache: false,
                success: function (msg) {
                    if (msg.d != "failure") {
                       
                        sampleData = jQuery.parseJSON(msg.d);
                      

                     




                        var settings = {
                            title: "Employee Monthly Entered Hours",
                            description: "Billable and Non-Billable Time Summary",
                            enableAnimations: true,
                            showLegend: true,
                            padding: { left: 5, top: 5, right: 5, bottom: 5 },
                            titlePadding: { left: 90, top: 0, right: 0, bottom: 10 },
                            source: sampleData,
                            xAxis:
                                {
                                    dataField: 'Month',
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
                                    }
                                },
                            valueAxis:
                            {
                                unitInterval: 20,
                                minValue: 0,
                                maxValue: 240,
                                title: { text: 'Time in Hours' },
                                labels: { horizontalAlignment: 'right' },
                                tickMarks: { color: '#ffffff' },
                                gridLinesColor: '#e0e0e0'
                            },
                            colorScheme: 'scheme06',
                            borderLineColor: '#ffffff',
                            seriesGroups:
                                [
                                    {
                                        type: 'stackedcolumn',
                                        columnsGapPercent: 50,
                                        seriesGapPercent: 0,
                                        series: [
                                                { dataField: 'Billable', displayText: 'Billable' },
                                                { dataField: 'Non-Billable', displayText: 'Non-Billable' }

                                        ]
                                    }
                                ]
                        };
                        window.parent.document.getElementById("ifEmphours").style.display = "block";
                        window.parent.document.getElementById("divcompanyloader").style.display = "none";
                        // setup the chart
                       // $(".jqx-chart-legend-text:nth-child(3)").css("display", "none");
                        $('#chartContainer').jqxChart(settings);

                       
                       // $('.jqx-chart-legend-text').css("display", "none");
                    }

                },
                error: function (x, e) {
                    window.parent.document.getElementById("ifEmphours").style.display = "block";
                    window.parent.document.getElementById("divcompanyloader").style.display = "none";


                }
            });

            // prepare chart data as an array
            //var sampleData = [
            //        { Month: 'Jan', Billable: 30, 'Non-Billable': 0 },
            //        { Month: 'Feb', Billable: 25, 'Non-Billable': 25 },
            //        { Month: 'Mar', Billable: 30, 'Non-Billable': 0 },
            //        { Month: 'Apr', Billable: 35, 'Non-Billable': 25 },
            //        { Month: 'May', Billable: 0, 'Non-Billable': 20 },
            //        { Month: 'Jun', Billable: 30, 'Non-Billable': 0 },
            //        { Month: 'July', Billable: 60, 'Non-Billable': 45 },
            //        { Month: 'July', Billable: 60, 'Non-Billable': 45 },
            //          { Month: 'Aug', Billable: 60, 'Non-Billable': 45 },
            //            { Month: 'Sep', Billable: 60, 'Non-Billable': 45 },
            //              { Month: 'Oct', Billable: 60, 'Non-Billable': 45 },
            //                { Month: 'Nov', Billable: 60, 'Non-Billable': 45 },
            //                  { Month: 'Dec', Billable: 60, 'Non-Billable': 45 }

            //];

            // prepare jqxChart settings
          

        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
       
        <div class="maindiv">
            <div id='chartContainer' style="width: 100%; height: 420px;" />
        </div>
    </form>
</body>
</html>
