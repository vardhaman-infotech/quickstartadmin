<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="projectBudget.aspx.cs" Inherits="empTimeSheet.projectBudget" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="css/jquery.dataTables.min.css" />
    <script src="js/jquery.min.js"></script>
    <script type="text/javascript" src="js/jquery.dataTables.min.js"></script>
      <script src="js/jquery.table2excel.js"></script>
    <style type="text/css">
        .divlist {
            border: solid 1px #e0e0e0;
            height: 315px;
            width: 220px;
            float: left;
            overflow-y: hidden;
        }

        .divlistinner {
            height: 283px;
            width: 100%;
            float: left;
            overflow-y: auto;
        }

        .tbllist {
            width: 100%;
            margin: 0px;
        }

            .tbllist th {
                border-bottom: solid 1px #e0e0e0;
                background: #e0e0e0;
                color: #000000;
                padding: 5px;
                font-family: "open_sans_semibold",Arial,Helvetica,sans-serif;
                text-align: left;
            }

            .tbllist td {
                padding: 5px;
                text-align: left;
                min-height: 30px;
                border: none;
            }

            .tbllist .form-control {
                height: 25px;
                margin: 0px;
                box-shadow: none;
                width: 95%;
            }

            .tbllist td:hover {
                cursor: pointer;
                background-color: #0078D7;
                color: #ffffff;
            }

        .selectedcell td {
            background-color: #0078D7;
            color: #ffffff;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input type="hidden" id="hidSelecetedLeft" />
    <input type="hidden" id="hidSelectedRight" />
    <input type="hidden" id="hidfilename" runat="server" />

    <div style="width: 700px;" id="divtaskdetail" class="itempopup">
        <div class="popup_heading">
            <span id="spanbuddetail"></span>
            <div class="f_right">
                <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
            </div>
        </div>

        <div style="display: block; height: auto; padding: 10px 20px;">
            <div class="f_right">

                <input type="button" value="Export" class="btn  btn-primary" id="btnexport" />
            </div>

            <div class="clear"></div>
            <div class="ctrlGroup" style="float:none;">
                <div style="height: 400px; overflow: auto">
                    <table width="100%" cellpadding="4" cellspacing="0" id="tblBudgetDetail" class="tblreport">
                        <thead>
                            <tr class="gridheader">


                                <th>Task
                                </th>
                                 <th>Description
                                </th>
                                <th width="50">Bill Rate
                                </th>
                                <th width="50">Pay Rate
                                </th>
                                <th width="100">Bud. Hrs.
                                </th>
                                <th width="100">Actual Hrs.
                                </th>

                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                        <tfoot>
                            <tr>
                                <th colspan="4" style="text-align: center;">Total Budget Hours

                                </th>
                                <th id="tdtotalBhrs">0

                                </th>
                                <th id="tdtotalHhrs">0

                                </th>


                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>

            <div class="clear"></div>


        </div>

    </div>
    <div style="width: 500px;" id="divaddnew" class="itempopup">
        <div class="popup_heading">
            <span>Create a Budget</span>
            <div class="f_right">
                <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
            </div>
        </div>

        <div style="display: block; height: auto; padding: 20px;">
            <div class="ctrlGroup">
                <label class="lbl lbl1">
                    Budget Title: *
                </label>
                <div class="txt w5 mar10">
                    <input type="text" maxlength="200" class="form-control" id="txttitle" />

                </div>
            </div>

            <div class="clear"></div>
            <div class="ctrlGroup">
                <label class="lbl lbl1">
                    Project: *
                </label>
                <div class="txt w5 mar10">
                    <input type="text" class="form-control" id="txtproject" />
                    <input type="hidden" id="hidproject" />

                </div>
            </div>

            <div class="clear"></div>
            <div class="ctrlGroup">
                <label class="lbl lbl1">
                    Budget Template: 
                </label>
                <div class="txt w5 mar10">
                    <select id="dropbudTemplate" class="form-control"></select>

                </div>
            </div>

            <div class="clear"></div>
            <div class="ctrlGroup">
                <label class="lbl lbl1">
                    &nbsp;
                </label>
                <div class="txt w2 mar10">
                    <input type="button" value="Create Budget" class="btn  btn-primary" id="btncreatebudget" />

                </div>
            </div>

        </div>

    </div>
    <div id="divimport" class="itempopup" style="width: 600px; display: none;">
        <div class="popup_heading">
            <span>Import Bugted Tasks</span>
            <div class="f_right">
                <img src="images/cross.png" onclick="closediv();" alt="X" title="Close
            Window" />
            </div>
        </div>


        <div style="margin: 10px 15px;" id="divselectfile">

            <div class="ctrlGroup">
                <label class="lbl lbl4">
                    Select Excel File : *<br />
                    (.xlsx, .xls, .xlsm) 
                </label>

                <div class="txt w2">
                    <input type="button" value="Select a File" id="btn" onclick="Attachment_openupload();" class="btn-primary" />

                    <iframe src="uploadimport.aspx" id="ifuploadfile" style="display: none;"></iframe>


                </div>
                <div style="float: left; margin-left: 2px;" id="divattachfilename">
                </div>


            </div>

        </div>
        <div style="margin: 10px 15px; display: none;" id="divselectcol">
            <div style="padding: 10px 15px; font-family: 'open_sans_semibold';">
                * Now select the fields and associated columns where imported information is located in the excel work sheet
            </div>
            <div class="clear"></div>
            <div class="col-sm-12 col-md-5">
                <div class="divlist">
                    <table class="tbllist">
                        <thead>
                            <tr>
                                <th>Fields
                                </th>
                            </tr>
                        </thead>
                    </table>
                    <div class="divlistinner">
                        <table class="tbllist" id="tblleft">

                            <tbody>
                                <%=strimportcol %>
                            </tbody>

                        </table>
                    </div>

                </div>
            </div>
            <div class="col-sm-12 col-md-2" style="padding-top: 20%; text-align: center;">
                <input type="button" onclick="move('right');"
                    class="btn btn-default " style="width: 40px; padding: 2px;" value=">>" id="btnAddtoList"
                    runat="server" />
                <br />
                <input type="button" onclick="move('left');"
                    class="btn btn-default mar" style="width: 40px; padding: 2px;" value="<<"
                    id="btnRemovefromList" runat="server" />
            </div>
            <div class="col-sm-12 col-md-5">

                <div class="divlist">
                    <table class="tbllist">
                        <thead>
                            <tr>
                                <th>Fields
                                </th>
                                <th width="80px">Column
                                </th>
                            </tr>
                        </thead>
                    </table>
                    <div class="divlistinner">
                        <table class="tbllist" id="tblright">
                        </table>
                    </div>

                </div>
            </div>
            <div class="clear"></div>
            <div style="text-align: center; margin-top: 20px;">
                <a class="btn btn-default btn-primary" onclick="saveimport();">Import</a>
            </div>
        </div>




        <div class="clear">
        </div>


    </div>
    <div style="width: 100%; float: left; vertical-align: top; margin-bottom: 30px;">
        <pg:progress ID="progress1" runat="server" />
        <div id="otherdiv" onclick="closediv();">
        </div>
        <div id="divview">
            <div class="pageheader">
                <h2>
                    <i
                        class="fa fa-tasks" style="border: none; font-size: 24px; border-radius: initial; padding: 0px;"></i>Project Budgeting
                </h2>
                <div class="breadcrumb-wrapper">

                    <a id="linkaddnew" class="right_link"><i class="fa fa-fw fa-plus topicon"></i>Add New  </a>

                </div>
                <div class="clear">
                </div>
            </div>
            <div class="contentpanel">
                <div class="row">
                    <div class="col-sm-12 col-md-12">
                        <div class="panel panel-default" style="min-height: 450px;">
                            <div class="col-sm-12 col-md-10">
                                <div style="padding-top: 10px;">
                                    <div class="clear"></div>
                                    <div class="ctrlGroup searchgroup">

                                        <div class="txt w1">
                                            <input type="text" id="txtkeyword" maxlength="200" class="form-control" onkeypress="fn_MasterSearchDataTable(this.value,'tbldata','');" onkeyup="fn_MasterSearchDataTable(this.value,'tbldata','');" placeholder="Search" />


                                        </div>
                                    </div>

                                </div>
                            </div>
                            <div class="clear">
                            </div>
                            <div id="divright" class="col-sm-12 col-md-12">
                                <div class="panel-default">
                                    <div class="panel-body2 ">
                                        <div class="row mar">
                                            <div class="table-responsive">

                                                <table width="100%" cellpadding="4" cellspacing="0" id="tbldata" class="tblreport">
                                                    <thead>
                                                        <tr class="gridheader">
                                                            <th>Budget Title
                                                            </th>
                                                            <th width="230">Project
                                                            </th>
                                                            <th width="80">Bud. Hrs.
                                                            </th>
                                                            <th width="80">Actual Hrs.
                                                            </th>
                                                            <th width="120">Created By
                                                            </th>
                                                            <th width="100">Created on
                                                            </th>
                                                            <th width="30"></th>
                                                            <th width="30" id="thedit"></th>
                                                            <th width="30" id="thdelete"></th>

                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                    </tbody>
                                                </table>
                                            </div>


                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="clear">
                            </div>
                        </div>
                        <!-- panel -->
                    </div>
                </div>
            </div>
        </div>
        <div id="divview1" style="display: none;">
            <div class="pageheader">
                <h2>
                    <i
                        class="fa fa-tasks" style="border: none; font-size: 24px; border-radius: initial; padding: 0px;"></i>Select Tasks
                </h2>
                <div class="breadcrumb-wrapper">


                    <a id="linksubmit" class="right_link"><i class="fa fa-fw fa-save topicon"></i>Save </a>
                    <a id="linkimport" class="right_link"><i class="fa fa-fw fa-upload topicon"></i>Import </a>
                    <a id="linkback" class="right_link"><i class="fa fa-fw fa-backward topicon"></i>Back </a>

                </div>
                <div class="clear">
                </div>
            </div>
            <div class="contentpanel">
                <div class="row">
                    <div class="col-sm-12 col-md-12">
                        <div class="panel panel-default" style="min-height: 450px;">
                            <div class="col-sm-12 col-md-10 mar">
                                <div class="ctrlGroup searchgroup">
                                    <label class="lblAuto">
                                        Budget Title : *
                                    </label>
                                    <div class="txt w3 ">
                                        <input type="text" id="txtbudgettitle1" class="form-control" />
                                    </div>
                                </div>

                            </div>

                            <div class="clear">
                            </div>
                            <div class="col-sm-12 col-md-12 mar3">
                                <div class="panel-default">
                                    <div class="panel-body2 ">
                                        <div class="row mar">
                                            <div class="table-responsive">
                                                <table width="100%" cellpadding="4" cellspacing="0" id="tblTask" class="tblreport">
                                                    <thead>
                                                        <tr class="gridheader">
                                                            <th width="20"></th>
                                                            <th width="150">Task Code
                                                            </th>
                                                            <th>Task Description
                                                            </th>
                                                            <th width="50">Budget Hrs.
                                                            </th>
                                                            <th width="50">Bill Rate
                                                            </th>
                                                            <th width="50">Pay Rate
                                                            </th>
                                                            <th width="50">Billable
                                                            </th>

                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                    </tbody>
                                                    <tfoot>
                                                        <tr>
                                                            <th colspan="3" style="text-align: center;">Total Budget Hours

                                                            </th>
                                                            <th colspan="4" id="tdtotalhrs">0

                                                            </th>



                                                        </tr>
                                                    </tfoot>
                                                </table>
                                            </div>
                                            <div class="clear"></div>
                                            <div class="ctrlGroup searchgroup" style="float: right;">
                                                <a id="addmore" style="text-decoration: underline;"><i class="fa fa-plus">&nbsp;</i>Add
                                                            New Task</a>

                                            </div>

                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="clear">
                            </div>
                        </div>
                        <!-- panel -->
                    </div>
                </div>
            </div>
        </div>
    </div>



    <script type="text/javascript" src="js/jquery-ui.js"></script>

    <script src="js/PageJs/projectBudgetjs.js"></script>





</asp:Content>
