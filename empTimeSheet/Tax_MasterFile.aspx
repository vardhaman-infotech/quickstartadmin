<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="Tax_MasterFile.aspx.cs" Inherits="empTimeSheet.Tax_MasterFile" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

   <link rel="stylesheet" href="css/taxlogcss.css" />
    <script src="js/jquery.min.js"></script>
   <script src="js/jquery.table2excel.js"></script>


    <script type="text/javascript">
        var json;      
        var pagename = "Tax_MasterFile.aspx"
        function fixheader() {

            //$('#tbldata').dataTable({
            //    scrollY: "300px",
            //    scrollX: true,
            //    scrollCollapse: true,
            //    paging: false,
            //    fixedColumns: {
            //        leftColumns: 4,
            //        rightColumns: 1
            //    }
            //});
            //$('#tbldata').fixedHeaderTable({
            //    altClass: 'odd',
            //    footer: true,
            //    fixedColumns:3,
            //});
           


        }
        function excelexport()
        {
            var args = { taxcompany: document.getElementById("ctl00_ContentPlaceHolder1_txttaxclient").value, taxyear: document.getElementById("ctl00_ContentPlaceHolder1_txtyear").value, companyid: document.getElementById("hidcompanyid").value,rectype:"excel" };

            $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
            $.ajax({

                type: "POST",
                url: pagename + "/getdata",
                data: JSON.stringify(args),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                cache: false,
                success: function (data) {

                    if (data.d != "failure") {
                        var jsonarr = $.parseJSON(data.d);
                        if (jsonarr.length > 0) {
                            var str = jsonarr[0].strdta;
                            var el = $(str);

                            el.table2excel({
                                name: "TaxMasterFile",
                                filename: "TaxMasterFile"

                            });
                          
                          

                        }
                        else {
                           
                        }

                        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                    }


                },
                error: function (x, e) {
                    alert("The call to the server side failed. " + x.responseText);
                    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                    return;
                }

            });
        }
        function filldata() {
            var args = { taxcompany: document.getElementById("ctl00_ContentPlaceHolder1_txttaxclient").value, taxyear: document.getElementById("ctl00_ContentPlaceHolder1_txtyear").value, companyid: document.getElementById("hidcompanyid").value, rectype:""};

            $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
            $.ajax({

                type: "POST",
                url: pagename + "/getdata",
                data: JSON.stringify(args),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                cache: false,
                success: function (data) {

                    if (data.d != "failure") {
                        var jsonarr = $.parseJSON(data.d);
                        if (jsonarr.length > 0) {

                            document.getElementById("divdata").innerHTML = jsonarr[0].strdta;
                            $('#divdata').show();
                            $('#nodata').hide();

                            fixheader();
                        }
                        else {
                            document.getElementById("divdata").innerHTML = "";

                            $('#divdata').hide();
                            $('#nodata').show();
                        }
                       
                        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                    }


                },
                error: function (x, e) {
                    alert("The call to the server side failed. " + x.responseText);
                    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                    return;
                }

            });
        }

       


     
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <pg:progress ID="progress1" runat="server" />


    <div class="pageheader">
        <h2>
            <i class="fa fa-cube"></i>Tax Client Master File
        </h2>
        <div class="breadcrumb-wrapper">

            <a onclick="excelexport();" class="right_link">
            <i class="fa fa-fw fa-file-excel-o topicon"></i>Export to Excel</a>


        </div>
        <div class="clear">
        </div>
    </div>


   

    <div id="otherdiv" onclick="closediv();">
    </div>


    <div class="contentpanel">


        <input type="hidden" id="hidid" runat="server" />
        <div class="row">
            <div class="col-sm-12 col-md-12">
                <div class="panel panel-default">
                 
                            <div class="col-sm-12 col-md-10 mar">
                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl lbl2">Tax Client :</label>
                                    <div class="txt w1 mar10">
                                        <asp:DropDownList ID="txttaxclient" runat="server" CssClass="form-control"></asp:DropDownList>

                                    </div>
                                </div>
                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl lbl2">Tax Year :</label>
                                    <div class="txt w1 mar10">
                                        <asp:DropDownList ID="txtyear" runat="server" CssClass="form-control"></asp:DropDownList>
                                    </div>
                                </div>





                                <div class="ctrlGroup searchgroup">
                                    <input type="button" id="btnsearch" runat="server" class="btn btn-default" value="Search"
                                        onclick="filldata();" />
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


                                            <div class="table-responsive" >
                                              <div id="divdata" style="width:100%; overflow:auto; height:400px;"></div>


                                                <div class="nodatafound" id="nodata" style="display:none;">
                                                    No data found
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






    <script type="text/javascript">







        function opendiv() {
            setposition("divaddnew");
            document.getElementById("divaddnew").style.display = "block";
            document.getElementById("otherdiv").style.display = "block";
        }
        function closediv() {

            document.getElementById("divaddnew").style.display = "none";
            document.getElementById("otherdiv").style.display = "none";

        }



    </script>

</asp:Content>