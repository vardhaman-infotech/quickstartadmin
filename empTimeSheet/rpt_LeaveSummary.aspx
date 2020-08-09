<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="rpt_LeaveSummary.aspx.cs" Inherits="empTimeSheet.rpt_LeaveSummary" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="css/jquery.bxslider.css" rel="stylesheet" />
    <style type="text/css">
        .recordempname {
            text-align: center;
            font-size: 18px;
            margin: 10px;
            display:block;

        }

        .tdmonthname {
            font-family: 'open_sans_semibold' !important;
        }

        .tdtotal {
        }
        .bx-viewport{min-height:500px;}
            .tdtotal td {
                font-family: 'open_sans_semibold';
                color: #1caf9a;
                border-bottom:solid 1px #dddddd !important;
            }
            .bx-wrapper .bx-pager{ font-family: 'open_sans_semibold'; font-size:14px;}
        .lft-right-arow {
            display: block;
            float: right;
            margin-bottom: 5px;
    margin-right: 5px;
        }

        .lft-arow {
            display: inline-block;
        }

        .rht-arow {
            display: inline-block;
        }

        .lft-right-arow .lft-arow a {
            display: inline-block;
            padding: 2px 8px;
            background: #d7d7d7;
            border: solid 1px #b9b9b9;
        }

        .lft-right-arow .rht-arow a {
            display: inline-block;
            padding: 2px 8px;
            background: #d7d7d7;
            border: solid 1px #b9b9b9;
        }

        .lft-right-arow a:hover {
            background: #173967;
        }
    </style>
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
                                        <h5 class="subtitle mb5">Employee Leave Summary</h5>
                                    </div>

                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl2">Year :</label>
                                        <div class="txt w1 mar10">
                                            <asp:DropDownList ID="dropyear" runat="server" CssClass="form-control">
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

                                    <div class="ctrlGroup searchgroup">
                                        <asp:Button ID="btnsearch" runat="server" Text="View Report" CssClass="btn btn-default"
                                            OnClick="btnsearch_Click" />
                                    </div>
                                </div>
                            </div>
                            <div class="clear">
                            </div>
                            <div class="col-sm-12 col-md-12 mar">
                                <div class="clear">
                                </div>
                                <div class="panel panel-default">
                                    <div class="panel-body2 ">
                                        <div class="row">
                                            <div class="table-responsive">
                                                <div class="table-responsive">
                                                    <div class="nodatafound" id="divnodata" runat="server" visible="false">
                                                        No data found
                                                    </div>
                                                    <div class="lft-right-arow" id="divpager" runat="server" visible="false" >
                                                        <div class="lft-arow">
                                                            <a id="goleft" title="Go to previous record">
                                                                <img src="Appointment/images/left-arow.png" alt="" /></a>
                                                        </div>
                                                        <div class="rht-arow">
                                                            <a id="goright" title="Go to next record">
                                                                <img src="Appointment/images/right-arow.png" alt="" /></a>
                                                        </div>
                                                    </div>
                                                    <div class="clear"></div>
                                                    <div id="divdata" runat="server" class="bxslider">
                                                    </div>
                                                    <div class="clear"></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <input type="hidden" id="hidreportype" runat="server" />
                                    <input type="hidden" id="hidyear" runat="server" />
                                    <input type="hidden" id="hidmonth" runat="server" />
                                    <input type="hidden" id="hidempid" runat="server" />
                                    <div class="clear">
                                    </div>
                                </div>

                            </div>
                            <div class="clear">
                            </div>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <script src="js/jquery.min.js"></script>
    <script src="js/jquery-ui.js"></script>
    <script src="appointment/js/jquery.bxslider.min.js"></script>
    <script>
        function fixSchedule() {

          
            var slider = $('.bxslider').bxSlider({
                default: 'horizontal',
                infiniteLoop: true,
                minSlides: 1,
                maxSlides: 1,
                pager: true,
                touchEnabled:true,
                pagerType: 'short'
              
            });
            $('#goright').click(function () {
                slider.goToNextSlide();
                return false;
            });
            $('#goleft').click(function () {
                slider.goToPrevSlide();
                return false;
            });
        }

    </script>
</asp:Content>
