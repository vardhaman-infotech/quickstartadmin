<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="ManualInvoice.aspx.cs" Inherits="empTimeSheet.ManualInvoice" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit.HTMLEditor"
    TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link rel="stylesheet" href="css/jquery-ui.css" />
    <script type="text/javascript" src="js/jquery-ui.js"></script>
    <script type="text/javascript" src="js/manualInvoice.js"></script>
    <link rel="stylesheet" type="text/css" href="css/manualInvoice_2.5.css" />
    <script type="text/javascript">
       

        //Get Billing address on selection of project
        function getclientaddress() {
            $("#tblBillingTask").empty();
            $('#divviewtask').hide();
            document.getElementById("hidbilledtask").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtfromdate").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txttodate").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_chkMarkBilled").checked = false;
            var nid = document.getElementById("ctl00_ContentPlaceHolder1_hidproject").value;
            document.getElementById("ctl00_ContentPlaceHolder1_txtaddress").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtclientname").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtcontactperson").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_street").value = "";

            document.getElementById("ctl00_ContentPlaceHolder1_txtcity").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtstate").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtcountry").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtzip").value = "";
            if (nid == "") {
                blank();
            }
            else {


                document.getElementById("ctl00_ContentPlaceHolder1_txtaddress").value = "";
                document.getElementById("ctl00_ContentPlaceHolder1_txtclientname").value = "";
                document.getElementById("ctl00_ContentPlaceHolder1_txtcontactperson").value = "";
                document.getElementById("ctl00_ContentPlaceHolder1_street").value = "";

                document.getElementById("ctl00_ContentPlaceHolder1_txtcity").value = "";
                document.getElementById("ctl00_ContentPlaceHolder1_txtstate").value = "";
                document.getElementById("ctl00_ContentPlaceHolder1_txtcountry").value = "";
                document.getElementById("ctl00_ContentPlaceHolder1_txtzip").value = "";

                document.getElementById("ctl00_ContentPlaceHolder1_txtinvoicenum").value = "";
              //  document.getElementById("ctl00_ContentPlaceHolder1_txtinvoicedate").value = gettodatdate();
                document.getElementById("ctl00_ContentPlaceHolder1_hidid").value = "";
                document.getElementById("ctl00_ContentPlaceHolder1_txtsubtotal").value = "0.00";
                document.getElementById("ctl00_ContentPlaceHolder1_txttaxamount").value = "0.00";
                document.getElementById("ctl00_ContentPlaceHolder1_txtdiscount").value = "0.00";
                document.getElementById("ctl00_ContentPlaceHolder1_droptax").selectedIndex = 0;
                document.getElementById("ctl00_ContentPlaceHolder1_txttaxpercentage").value = "0.0000";
                document.getElementById("ctl00_ContentPlaceHolder1_txtServiceAmount").value = "0.00";
                document.getElementById("ctl00_ContentPlaceHolder1_txttotal").value = "0.00";
                document.getElementById("ctl00_ContentPlaceHolder1_txtpaidamount").value = "0.00";
                document.getElementById("ctl00_ContentPlaceHolder1_txtretainage").value = "0.00";
                document.getElementById("ctl00_ContentPlaceHolder1_txtdueamount").value = "0.00";
                document.getElementById("ctl00_ContentPlaceHolder1_txtretainer").value = "0.00";
                var txtmemo = $find("<%= txtmemo.ClientID %>");
                if (txtmemo != null) {
                    txtmemo.set_content("");
                }
                var rowcount = $('#tbldata tr').length;
                var table = document.getElementById("tbldata");
                for (var i = rowcount - 1; i >= 0; i--) {
                    if (i == 0) {
                        document.getElementById("hidinvoicedetailid_" + i).value = "";
                        document.getElementById("ddltask_" + i).selectedIndex = 0;
                        document.getElementById("txtdesc_" + i).value = "";
                        document.getElementById("txtrate_" + i).value = "0.00";
                        //document.getElementById("txttax_" + i).value = "0.00";
                        //document.getElementById("spantotal_" + i).innerHTML = "";
                    }
                    else {
                        table.deleteRow(i);
                    }

                }
                document.getElementById("<%=hidrowno.ClientID %>").value = 0;
                document.getElementById("<%=hidsno.ClientID %>").value = 1;




                var args = { nid: nid, todate: $("#ctl00_ContentPlaceHolder1_txtinvoicedate").val() };
                $('#ctl00_ContentPlaceHolder1_progress2_UpdateProg1').show();
                $.ajax({

                    type: "POST",
                    url: pagename + "/getclientaddress?v=1",
                    data: JSON.stringify(args),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: true,
                    cache: false,
                    success: function (msg) {
                        if (msg.d != "failure") {
                            var arr = msg.d.split('####');



                            var address = "", custominvoice = "";
                            if (arr.length > 0) {

                                if (arr[1] != "") {
                                    document.getElementById("ctl00_ContentPlaceHolder1_txtinvoicenum").value = arr[1];
                                }
                                else {
                                    document.getElementById("ctl00_ContentPlaceHolder1_txtinvoicenum").value = document.getElementById("ctl00_ContentPlaceHolder1_hidmaxinvoiceno").value;
                                }
                                if (arr[2] != "") {
                                    document.getElementById("ctl00_ContentPlaceHolder1_hidprojectgrt").value = arr[2];
                                }
                                else {
                                    document.getElementById("ctl00_ContentPlaceHolder1_hidprojectgrt").value = "0.00";
                                }
                                if (arr[3] != "") {
                                    document.getElementById("ctl00_ContentPlaceHolder1_hidprojectexpensetax").value = arr[3];
                                }
                                else {
                                    document.getElementById("ctl00_ContentPlaceHolder1_hidprojectexpensetax").value = "0.00";
                                }
                                if (document.getElementById("hidid") != "") {
                                    if (arr[4] != "") {
                                        document.getElementById("ctl00_ContentPlaceHolder1_droptax").value = arr[4];

                                    }
                                    else {
                                        document.getElementById("ctl00_ContentPlaceHolder1_droptax").value = "";
                                    }
                                }
                                if (arr[5] != "") {
                                    document.getElementById("ctl00_ContentPlaceHolder1_txtretainer").value = arr[5];

                                }
                                else {
                                    document.getElementById("ctl00_ContentPlaceHolder1_txtretainer").value = "";
                                }




                                document.getElementById("ctl00_ContentPlaceHolder1_txtprefix").value = arr[6];
                                document.getElementById("ctl00_ContentPlaceHolder1_txtpostfix").value = arr[7];

                                //Fill Project Summary
                                document.getElementById("inv_summary_service").innerHTML = '$' + arr[8] + '*';
                                document.getElementById("inv_summary_expense").innerHTML = '$' + arr[9] + '*';
                                document.getElementById("inv_summary_contractamt").innerHTML = '$' + arr[10] + '*';
                                document.getElementById("inv_summary_contracttype").innerHTML = arr[11] + '*';
                                document.getElementById("inv_summary_percent").innerHTML = arr[12] + '%';

                                //Fill Work-in-Progress (*billable only)
                                document.getElementById("inv_ServiceAmt").innerHTML = '$' + arr[13] + '*';
                                

                                //SLS
                                var servicetotal = parseFloat(arr[13]) - parseFloat(arr[20]);
                                var exptotal = parseFloat(arr[14]) - parseFloat(arr[21])
                                document.getElementById("ctl00_ContentPlaceHolder1_txtServiceAmount").value = servicetotal;

                                document.getElementById("txtrate_0").value = servicetotal;
                                
                                document.getElementById("ctl00_ContentPlaceHolder1_txtExpenseAmount").value = exptotal;

                                document.getElementById("maxservamt").value = servicetotal;
                                document.getElementById("maxexpamt").value = exptotal;

                                document.getElementById("inv_div_total1").innerHTML = '$' +(servicetotal+exptotal);
                                document.getElementById("inv_div_total").innerHTML = '$' + (servicetotal + exptotal);
                                document.getElementById("ctl00_ContentPlaceHolder1_txtsubtotal").value = (servicetotal + exptotal);

                                document.getElementById("inv_expAmt").innerHTML = '$' + arr[14] + '*';



                                //SLS
                               


                               

                                document.getElementById("inv_time").innerHTML = arr[15] + '*';
                                document.getElementById("inv_prebilled").innerHTML = '$' + arr[16] + '*';

                                if (arr[17] != "")
                                    document.getElementById("inv_no").innerHTML = arr[17] + '*';
                                else
                                    document.getElementById("inv_no").innerHTML = "-";
                                if (arr[18] != "")
                                    document.getElementById("inv_date").innerHTML = arr[18] + '*';
                                else
                                    document.getElementById("inv_date").innerHTML = "-";
                                if (arr[19] != "")
                                    document.getElementById("inv_amount").innerHTML = '$' + arr[19] + '*';
                                else
                                    document.getElementById("inv_amount").innerHTML = "-";


                                gettaxpercentage();
                            }
                            else {
                                address = arr[0];
                                document.getElementById("ctl00_ContentPlaceHolder1_txtinvoicenum").value = document.getElementById("ctl00_ContentPlaceHolder1_hidmaxinvoiceno").value;
                            }
                            try {
                                splitaddress(arr[0]);
                            }
                            catch (err) { }




                            $('#ctl00_ContentPlaceHolder1_progress2_UpdateProg1').hide();
                        }

                    },
                    error: function (x, e) {
                        alert("The call to the server side failed. " + x.responseText);
                        $('#ctl00_ContentPlaceHolder1_progress2_UpdateProg1').hide();


                    }
                });
            }
        }


    </script>
    <script type="text/javascript">


        function saveinvoice(invoicetype) {
            $('#ctl00_ContentPlaceHolder1_progress2_UpdateProg1').show();
            var nid, invoiceno, invoicedate, companyid, projectid, subtotal, taxamount, totalamount, discount, amountpaid, dueamount, address, invoicedetail, memo;
            var markbilled = "0", taxid = "", taxpercent = "0", retainage = "0", contactperson, street2, state, city, country, zip;
            var userid = document.getElementById("hidloginid").value;
            var companyid = document.getElementById("hidcompanyid").value;
            nid = document.getElementById("ctl00_ContentPlaceHolder1_hidid").value;
            invoiceno = document.getElementById("ctl00_ContentPlaceHolder1_txtinvoicenum").value;
            invoicedate = document.getElementById("ctl00_ContentPlaceHolder1_txtinvoicedate").value;
            projectid = document.getElementById("ctl00_ContentPlaceHolder1_hidproject").value;
            subtotal = document.getElementById("ctl00_ContentPlaceHolder1_txtsubtotal").value;
            taxamount = document.getElementById("ctl00_ContentPlaceHolder1_txttaxamount").value;
            taxid = gettaxvalue("nid");
            if (document.getElementById("ctl00_ContentPlaceHolder1_txttaxpercentage").value != "") {
                taxpercent = document.getElementById("ctl00_ContentPlaceHolder1_txttaxpercentage").value;
            }
            totalamount = document.getElementById("ctl00_ContentPlaceHolder1_txttotal").value;
            discount = document.getElementById("ctl00_ContentPlaceHolder1_txtdiscount").value;

            if (document.getElementById("ctl00_ContentPlaceHolder1_txtretainage").value != "") {
                retainage = document.getElementById("ctl00_ContentPlaceHolder1_txtretainage").value;
            }

            amountpaid = document.getElementById("ctl00_ContentPlaceHolder1_txtpaidamount").value;
            dueamount = document.getElementById("ctl00_ContentPlaceHolder1_txtdueamount").value;
            address = document.getElementById("ctl00_ContentPlaceHolder1_txtaddress").value;
            contactperson = document.getElementById("ctl00_ContentPlaceHolder1_txtcontactperson").value;
            street2 = document.getElementById("ctl00_ContentPlaceHolder1_street").value;
            state = document.getElementById("ctl00_ContentPlaceHolder1_txtstate").value;
            city = document.getElementById("ctl00_ContentPlaceHolder1_txtcity").value;
            zip = document.getElementById("ctl00_ContentPlaceHolder1_txtzip").value;
            country = document.getElementById("ctl00_ContentPlaceHolder1_txtcountry").value;

            if (document.getElementById("ctl00_ContentPlaceHolder1_chkMarkBilled").checked == true)
                markbilled = "1";
            var txtmemo = $find("<%= txtmemo.ClientID %>");
            memo = txtmemo.get_content();

            invoicedetail = getinvoicedetail();
            var args = { nid: nid, invoiceno: invoiceno, invoicedate: invoicedate, companyid: companyid, projectid: projectid, subtotal: subtotal, taxamount: taxamount, totalamount: totalamount, discount: discount, amountpaid: amountpaid, dueamount: dueamount, address: address, userid: userid, invoicedetail: invoicedetail, memo: memo, markbilled: markbilled, taxid: taxid, taxpercent: taxpercent, invoicetype: invoicetype, retainage: retainage, contactperson: contactperson, street2: street2, state: state, city: city, country: country, zip: zip, billedtask: document.getElementById("hidbilledtask").value };

            $.ajax({

                type: "POST",
                url: "ManualInvoice.aspx/saveinvoice",
                data: JSON.stringify(args),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                cache: false,
                success: function (data) {
                    //Check length of returned data, if it is less than 0 it means there is some status available
                    if (data.d == "Already Exists") {
                        alert('Invoice number already exists, please try another invoice number');
                    }
                    else if (data.d == "success") {
                        if (nid == "") {
                            alert('Invoice generated successfully');
                        }
                        else {
                            alert('Invoice updated successfully');

                        }
                        if (nid == "") {
                            blank();
                            location.href = "ManualInvoice.aspx";
                        }

                        else
                            location.href = "InvoiceReview.aspx";
                    }

                    $('#ctl00_ContentPlaceHolder1_progress2_UpdateProg1').hide();
                },
                error: function (x, e) {
                    alert("The call to the server side failed. " + x.responseText);
                    $('#ctl00_ContentPlaceHolder1_progress2_UpdateProg1').hide();
                }

            });
        }
    </script>

    <script type="text/javascript">

        function bindinvoicebynumber(invoiceno, recordtype) {

            var companyid = document.getElementById("hidcompanyid").value;
            document.getElementById("ctl00_ContentPlaceHolder1_hidid").value = "";

            if (invoiceno != "") {
                $('#ctl00_ContentPlaceHolder1_progress2_UpdateProg1').show();
                var args = { invoicenum: invoiceno, companyid: companyid, recordtype: recordtype };
                $.ajax({

                    type: "POST",
                    url: pagename + "/getinvoicedetailbyinvoicenumber",
                    data: JSON.stringify(args),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    cache: false,
                    success: function (data) {

                        if (data.d != "failure") {
                            var json = $.parseJSON(data.d);
                            //Check length of returned data, if it is less than 0 it means there is no data available
                            if (json.length > 0) {
                                blank2();
                                var inum = json[0].invoiceno.match(/\d/g);
                                inum = inum.join("");
                                var prefix = "", postfix = "";
                                var n = json[0].invoiceno.indexOf(inum);
                                if (n > 0) {
                                    prefix = json[0].invoiceno.substr(0, n);
                                }
                                if (inum.length < json[0].invoiceno.length) {
                                    postfix = json[0].invoiceno.replace(prefix + inum, "");
                                }


                                //if (recordtype != "nid") {
                                //    document.getElementById("ctl00_ContentPlaceHolder1_txtinvoicenum").value = inum;
                                //    document.getElementById("ctl00_ContentPlaceHolder1_txtprefix").value = prefix;
                                //    document.getElementById("ctl00_ContentPlaceHolder1_txtpostfix").value = postfix;
                                //}
                                //else {
                                //}

                                document.getElementById("ctl00_ContentPlaceHolder1_txtinvoicenum").value = inum;
                                document.getElementById("ctl00_ContentPlaceHolder1_txtprefix").value = prefix;
                                document.getElementById("ctl00_ContentPlaceHolder1_txtpostfix").value = postfix;
                                document.getElementById("ctl00_ContentPlaceHolder1_hidid").value = json[0].nid;




                                document.getElementById("inv_projectname").innerHTML = json[0].clientname;
                                //Fill Project Summary
                                document.getElementById("inv_summary_service").innerHTML = '$' + json[0].pserviceAmt + '*';
                                document.getElementById("inv_summary_expense").innerHTML = '$' + json[0].pexpAmt + '*';
                                document.getElementById("inv_summary_contractamt").innerHTML = '$' + json[0].pcontractAmt + '*';
                                document.getElementById("inv_summary_contracttype").innerHTML = json[0].contractType + '*';
                                document.getElementById("inv_summary_percent").innerHTML = json[0].completePercent + '%';

                                //Fill Work-in-Progress (*billable only)
                                document.getElementById("inv_ServiceAmt").innerHTML = '$' + json[0].serviceamt + '*';
                                document.getElementById("inv_expAmt").innerHTML = '$' + json[0].expamt + '*';
                                document.getElementById("inv_time").innerHTML = json[0].totalhrs + '*';
                                document.getElementById("inv_prebilled").innerHTML = '$' + json[0].prebilled + '*';

                                if (json[0].lastinvoice != "")
                                    document.getElementById("inv_no").innerHTML = json[0].lastinvoice + '*';
                                else
                                    document.getElementById("inv_no").innerHTML = "-";
                                if (json[0].lastinvoicedate != "")
                                    document.getElementById("inv_date").innerHTML = json[0].lastinvoicedate + '*';
                                else
                                    document.getElementById("inv_date").innerHTML = "-";
                                if (json[0].lasinvamt != "")
                                    document.getElementById("inv_amount").innerHTML = '$' + json[0].lasinvamt + '*';
                                else
                                    document.getElementById("inv_amount").innerHTML = "-";




                                bindinvoicedetailbyid(json[0].nid);

                                document.getElementById("ctl00_ContentPlaceHolder1_dropProject").value = json[0].projectcode;
                                document.getElementById("ctl00_ContentPlaceHolder1_hidproject").value = json[0].projectid;
                                document.getElementById("ctl00_ContentPlaceHolder1_hidid").value = json[0].nid;
                                document.getElementById("ctl00_ContentPlaceHolder1_hidmaxinvoiceno").value = inum;
                                document.getElementById("ctl00_ContentPlaceHolder1_txtinvoicedate").value = json[0].invoicedate;

                                document.getElementById("ctl00_ContentPlaceHolder1_txtaddress").value = json[0].billingaddress;
                                document.getElementById("ctl00_ContentPlaceHolder1_txtclientname").value = json[0].clientname;
                                document.getElementById("ctl00_ContentPlaceHolder1_txtcontactperson").value = json[0].contactperson;
                                document.getElementById("ctl00_ContentPlaceHolder1_street").value = json[0].address2;
                                document.getElementById("ctl00_ContentPlaceHolder1_txtcity").value = json[0].city;
                                document.getElementById("ctl00_ContentPlaceHolder1_txtstate").value = json[0].state;
                                document.getElementById("ctl00_ContentPlaceHolder1_txtcountry").value = json[0].country;
                                document.getElementById("ctl00_ContentPlaceHolder1_txtzip").value = json[0].zip;


                                document.getElementById("ctl00_ContentPlaceHolder1_txtsubtotal").value = json[0].subamount;


                                document.getElementById("ctl00_ContentPlaceHolder1_dropProject").disabled = true;

                                if (json[0].taxid == "") {
                                    //if (recordtype == "nid") {
                                    //    getclientaddress();
                                    //}
                                    document.getElementById("ctl00_ContentPlaceHolder1_txttaxpercentage").disabled = true;
                                    document.getElementById("ctl00_ContentPlaceHolder1_txttaxpercentage").value = "0.00";
                                    document.getElementById("ctl00_ContentPlaceHolder1_txttaxamount").value = "";
                                }
                                else {
                                    document.getElementById("ctl00_ContentPlaceHolder1_txttaxamount").value = json[0].tax;
                                    document.getElementById("ctl00_ContentPlaceHolder1_txttaxpercentage").value = json[0].taxpercentage;
                                    document.getElementById("ctl00_ContentPlaceHolder1_droptax").value = json[0].nidwithtax;
                                }
                                document.getElementById("ctl00_ContentPlaceHolder1_txtretainer").value = json[0].clientretainer;
                                document.getElementById("ctl00_ContentPlaceHolder1_txtdiscount").value = json[0].discount;

                                document.getElementById("ctl00_ContentPlaceHolder1_txttotal").value = json[0].totalamount;
                                document.getElementById("inv_div_total").innerHTML = '$' + json[0].totalamount;
                                document.getElementById("inv_div_total1").innerHTML = '$' + json[0].totalamount;
                                document.getElementById("ctl00_ContentPlaceHolder1_txtpaidamount").value = json[0].amountpaid;
                                document.getElementById("ctl00_ContentPlaceHolder1_txtretainage").value = json[0].retainage;
                                document.getElementById("ctl00_ContentPlaceHolder1_txtdueamount").value = json[0].dueamount;

                                //if (json[0].invoicetype == "generated") {
                                //    document.getElementById("ctl00_ContentPlaceHolder1_btnsave").style.display = "none";
                                //}



                                if (json[0].billingtask.toString().toLowerCase() == "true") {

                                    document.getElementById("ctl00_ContentPlaceHolder1_chkMarkBilled").checked = true;
                                }
                                else {
                                    document.getElementById("ctl00_ContentPlaceHolder1_chkMarkBilled").checked = false;
                                }
                                fillBillingTask('i');

                                var txtmemo = $find("<%= txtmemo.ClientID %>");
                                if (txtmemo != null)
                                    txtmemo.set_content(json[0].Memo.toString());



                                // gettaxpercentage();
                            }
                            else {

                                blank3();
                                var inum = invoiceno.match(/\d/g);
                                inum = inum.join("");
                                document.getElementById("ctl00_ContentPlaceHolder1_txtinvoicenum").value = inum;

                                document.getElementById("ctl00_ContentPlaceHolder1_dropProject").disabled = false;


                            }
                        }

                        $('#ctl00_ContentPlaceHolder1_progress2_UpdateProg1').hide();
                    },
                    error: function (x, e) {
                        alert("The call to the server side failed. " + x.responseText);
                        $('#ctl00_ContentPlaceHolder1_progress2_UpdateProg1').hide();
                    }

                });
            }
            else {

                blank();
            }

        }



        function bindinvoicedetailbyid(nid) {
            var args = { nid: nid };
            $.ajax({

                type: "POST",
                url: "ManualInvoice.aspx/getinvoicedetailbyid",
                data: JSON.stringify(args),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                cache: false,
                success: function (data) {

                    if (data.d != "failure") {
                        var jsonarr = $.parseJSON(data.d);
                        if (jsonarr.length > 0) {
                            var table = document.getElementById("tbldata");
                            var serviceamount = 0, expenseamount = 0;
                            for (var i in jsonarr) {

                                if (i == 0) {
                                    document.getElementById("hidinvoicedetailid_" + i).value = jsonarr[i].nid;

                                    document.getElementById("ddltask_" + i).value = jsonarr[i].taskvalue;



                                    document.getElementById("txtdesc_" + i).value = String(jsonarr[i].formatteddesc).replace(/\\n/g, '\n');


                                    document.getElementById("txtrate_" + i).value = jsonarr[i].rate;

                                    //document.getElementById("txttax_" + i).value = jsonarr[i].tax;
                                    //document.getElementById("spantotal_" + i).innerHTML = jsonarr[i].subtotal;

                                }
                                else {

                                    var id = parseInt(i) - 1;
                                    var sno = i;
                                    sno = parseInt(sno) + 1
                                    var newsno = parseInt(id) + 1;
                                    var row = table.insertRow(newsno);
                                    //  if (id > 0)
                                    //  document.getElementById("divdel_" + id).innerHTML = "";
                                    var celldelete = row.insertCell(0);

                                    var celltask = row.insertCell(1);
                                    var celldes = row.insertCell(2);
                                    var cellrate = row.insertCell(3);
                                    //var celltax = row.insertCell(4);
                                    // var celltotal = row.insertCell(5);

                                    celldelete.innerHTML = "<input type='hidden' id='hidinvoicedetailid_" + newsno + "' value='" + jsonarr[i].nid + "' /><div id='divdel_" + newsno + "' ><a style='cursor: pointer;color:bule;' id='delete' onclick='deleterow(this.id);' ><i class='fa fa-fw' style='font-size: 18px; color: #d9534f; display: block; margin: auto;'><img src='images/delete.png' alt=''></i></a></div>";
                                    celltask.innerHTML = "<select id='ddltask_" + newsno + "' class='form-control' onchange='bindtaskvalue(this.id,this.value);' >" + document.getElementById("divtask").innerHTML + "</select>";
                                    cellrate.innerHTML = "<input type='text' id='txtrate_" + newsno + "' class='form-control' onkeypress='blockNonNumbers(this, event, true, true);' onblur='fill(this.id);' onkeyup='extractNumber(this,2,true);' value='" + jsonarr[i].rate + "' />";
                                    celldes.innerHTML = "<textarea id='txtdesc_" + newsno + "' class='form-control' value='" + jsonarr[i].formatteddesc + "' onkeyDown='checkTextAreaMaxLength(this,event,1000);'>" + jsonarr[i].formatteddesc + "</textarea>";
                                    //celltax.innerHTML = "<input type='text' id='txttax_" + newsno + "' class='form-control' onkeypress='blockNonNumbers(this, event, true, false);' onblur='fill(this.id);' onkeyup='extractNumber(this,2,false);' value='" + jsonarr[i].tax + "' />";
                                    //celltotal.innerHTML = "$<span id='spantotal_" + newsno + "'>" + jsonarr[i].subtotal + "</span>";
                                    document.getElementById("<%=hidrowno.ClientID %>").value = newsno;
                                    document.getElementById("<%=hidsno.ClientID %>").value = sno;

                                    document.getElementById("ddltask_" + newsno).value = jsonarr[i].taskvalue;
                                }

                                if (jsonarr[i].taskvalue != null && jsonarr[i].taskvalue != "") {
                                    expenseamount = expenseamount + jsonarr[i].rate;
                                }
                                else {
                                    serviceamount = serviceamount + jsonarr[i].rate;
                                }
                            }

                            document.getElementById("ctl00_ContentPlaceHolder1_txtServiceAmount").value = serviceamount;
                            document.getElementById("ctl00_ContentPlaceHolder1_txtExpenseAmount").value = expenseamount;

                        }
                    }


                },
                error: function (x, e) {
                    alert("The call to the server side failed. " + x.responseText);
                    return;
                }

            });

        }
    </script>
    <script type="text/javascript">
        function checkretainer(retainageamount) {
            var retainer = 0.00;
            retainer = document.getElementById("ctl00_ContentPlaceHolder1_txtretainer").value;

            if (retainer != "") {
                if (parseFloat(retainageamount) > parseFloat(retainer)) {
                    alert("Retainage cannot be greater than Retainer");
                    document.getElementById("ctl00_ContentPlaceHolder1_txtretainage").value = "0.00";
                }
            }
            gettotal();
        }
        function gettodatdate() {
            var date = new Date();
            var datestring = ("0" + (date.getMonth() + 1).toString()).substr(-2) + "/" + ("0" + date.getDate().toString()).substr(-2) + "/" + (date.getFullYear().toString());
            return datestring;
        }
        function blank_new() {

            document.getElementById("ctl00_ContentPlaceHolder1_txtaddress").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtclientname").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtcontactperson").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_street").value = "";

            document.getElementById("ctl00_ContentPlaceHolder1_txtcity").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtstate").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtcountry").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtzip").value = "";

            document.getElementById("ctl00_ContentPlaceHolder1_txtinvoicenum").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtinvoicedate").value = gettodatdate();
            document.getElementById("ctl00_ContentPlaceHolder1_hidid").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtsubtotal").value = "0.00";
            document.getElementById("ctl00_ContentPlaceHolder1_txttaxamount").value = "0.00";
            document.getElementById("ctl00_ContentPlaceHolder1_txtdiscount").value = "0.00";
            document.getElementById("ctl00_ContentPlaceHolder1_droptax").selectedIndex = 0;
            document.getElementById("ctl00_ContentPlaceHolder1_txttaxpercentage").value = "0.0000";
            document.getElementById("ctl00_ContentPlaceHolder1_txtServiceAmount").value = "0.00";
            document.getElementById("ctl00_ContentPlaceHolder1_txttotal").value = "0.00";
            document.getElementById("ctl00_ContentPlaceHolder1_txtpaidamount").value = "0.00";
            document.getElementById("ctl00_ContentPlaceHolder1_txtretainage").value = "0.00";
            document.getElementById("ctl00_ContentPlaceHolder1_txtdueamount").value = "0.00";
            document.getElementById("ctl00_ContentPlaceHolder1_txtretainer").value = "0.00";
            var txtmemo = $find("<%= txtmemo.ClientID %>");
            if (txtmemo != null) {
                txtmemo.set_content("");
            }
            var rowcount = $('#tbldata tr').length;
            var table = document.getElementById("tbldata");
            for (var i = rowcount - 1; i >= 0; i--) {
                if (i == 0) {
                    document.getElementById("hidinvoicedetailid_" + i).value = "";
                    document.getElementById("ddltask_" + i).selectedIndex = 0;
                    document.getElementById("txtdesc_" + i).value = "";
                    document.getElementById("txtrate_" + i).value = "0.00";
                    //document.getElementById("txttax_" + i).value = "0.00";
                    //document.getElementById("spantotal_" + i).innerHTML = "";
                }
                else {
                    table.deleteRow(i);
                }

            }
            document.getElementById("<%=hidrowno.ClientID %>").value = 0;
            document.getElementById("<%=hidsno.ClientID %>").value = 1;
            getmaxinvoicenumber();
        }
        function blank2() {
            document.getElementById("ctl00_ContentPlaceHolder1_dropProject").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_hidproject").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtaddress").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtclientname").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtcontactperson").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_street").value = "";

            document.getElementById("ctl00_ContentPlaceHolder1_txtcity").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtstate").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtcountry").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtzip").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtinvoicenum").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtinvoicedate").value = gettodatdate();
            document.getElementById("ctl00_ContentPlaceHolder1_hidid").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtsubtotal").value = "0.00";
            document.getElementById("ctl00_ContentPlaceHolder1_txttaxamount").value = "0.00";
            document.getElementById("ctl00_ContentPlaceHolder1_txtdiscount").value = "0.00";
            document.getElementById("ctl00_ContentPlaceHolder1_droptax").selectedIndex = 0;
            document.getElementById("ctl00_ContentPlaceHolder1_txttaxpercentage").value = "0.0000";
            document.getElementById("ctl00_ContentPlaceHolder1_txtServiceAmount").value = "0.00";
            document.getElementById("ctl00_ContentPlaceHolder1_txttotal").value = "0.00";
            document.getElementById("ctl00_ContentPlaceHolder1_txtpaidamount").value = "0.00";
            document.getElementById("ctl00_ContentPlaceHolder1_txtretainage").value = "0.00";
            document.getElementById("ctl00_ContentPlaceHolder1_txtdueamount").value = "0.00";
            document.getElementById("ctl00_ContentPlaceHolder1_txtretainer").value = "0.00";
            document.getElementById("ctl00_ContentPlaceHolder1_txtExpenseAmount").value = "0.00";
            var txtmemo = $find("<%= txtmemo.ClientID %>");
            if (txtmemo != null) {
                txtmemo.set_content("");
            }
            var rowcount = $('#tbldata tr').length;
            var table = document.getElementById("tbldata");
            for (var i = rowcount - 1; i >= 0; i--) {
                if (i == 0) {
                    document.getElementById("hidinvoicedetailid_" + i).value = "";
                    document.getElementById("ddltask_" + i).selectedIndex = 0;
                    document.getElementById("txtdesc_" + i).value = "";
                    document.getElementById("txtrate_" + i).value = "0.00";
                    //document.getElementById("txttax_" + i).value = "0.00";
                    //document.getElementById("spantotal_" + i).innerHTML = "";
                }
                else {
                    table.deleteRow(i);
                }

            }
            document.getElementById("<%=hidrowno.ClientID %>").value = 0;
            document.getElementById("<%=hidsno.ClientID %>").value = 1;

        }
        function blank3() {

            $("#tblBillingTask").empty();
            $('#divviewtask').hide();
            document.getElementById("hidbilledtask").value = "";

            document.getElementById("ctl00_ContentPlaceHolder1_txtinvoicenum").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtinvoicedate").value = gettodatdate();
            document.getElementById("ctl00_ContentPlaceHolder1_hidid").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtsubtotal").value = "0.00";
            document.getElementById("ctl00_ContentPlaceHolder1_txttaxamount").value = "0.00";
            document.getElementById("ctl00_ContentPlaceHolder1_txtdiscount").value = "0.00";
            document.getElementById("ctl00_ContentPlaceHolder1_droptax").selectedIndex = 0;
            document.getElementById("ctl00_ContentPlaceHolder1_txttaxpercentage").value = "0.0000";
            document.getElementById("ctl00_ContentPlaceHolder1_txtServiceAmount").value = "0.00";
            document.getElementById("ctl00_ContentPlaceHolder1_txttotal").value = "0.00";
            document.getElementById("ctl00_ContentPlaceHolder1_txtpaidamount").value = "0.00";
            document.getElementById("ctl00_ContentPlaceHolder1_txtretainage").value = "0.00";
            document.getElementById("ctl00_ContentPlaceHolder1_txtdueamount").value = "0.00";
            document.getElementById("ctl00_ContentPlaceHolder1_txtretainer").value = "0.00";
            document.getElementById("ctl00_ContentPlaceHolder1_txtExpenseAmount").value = "0.00";
            var txtmemo = $find("<%= txtmemo.ClientID %>");
            if (txtmemo != null) {
                txtmemo.set_content("");
            }
            var rowcount = $('#tbldata tr').length;
            var table = document.getElementById("tbldata");
            for (var i = rowcount - 1; i >= 0; i--) {
                if (i == 0) {
                    document.getElementById("hidinvoicedetailid_" + i).value = "";
                    document.getElementById("ddltask_" + i).selectedIndex = 0;
                    document.getElementById("txtdesc_" + i).value = "";
                    document.getElementById("txtrate_" + i).value = "0.00";
                    //document.getElementById("txttax_" + i).value = "0.00";
                    //document.getElementById("spantotal_" + i).innerHTML = "";
                }
                else {
                    table.deleteRow(i);
                }

            }
            document.getElementById("<%=hidrowno.ClientID %>").value = 0;
            document.getElementById("<%=hidsno.ClientID %>").value = 1;

        }

        function blank() {
            document.getElementById("ctl00_ContentPlaceHolder1_dropProject").disabled = false;
            document.getElementById("ctl00_ContentPlaceHolder1_dropProject").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_hidproject").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtaddress").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtclientname").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtcontactperson").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_street").value = "";

            document.getElementById("ctl00_ContentPlaceHolder1_txtcity").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtstate").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtcountry").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtzip").value = "";


            document.getElementById("ctl00_ContentPlaceHolder1_txtinvoicenum").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtinvoicedate").value = gettodatdate();
            document.getElementById("ctl00_ContentPlaceHolder1_hidid").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtsubtotal").value = "0.00";
            document.getElementById("ctl00_ContentPlaceHolder1_txttaxamount").value = "0.00";
            document.getElementById("ctl00_ContentPlaceHolder1_txtdiscount").value = "0.00";
            document.getElementById("ctl00_ContentPlaceHolder1_droptax").selectedIndex = 0;
            document.getElementById("ctl00_ContentPlaceHolder1_txttaxpercentage").value = "0.0000";
            document.getElementById("ctl00_ContentPlaceHolder1_txtServiceAmount").value = "0.00";
            document.getElementById("ctl00_ContentPlaceHolder1_txttotal").value = "0.00";
            document.getElementById("ctl00_ContentPlaceHolder1_txtpaidamount").value = "0.00";
            document.getElementById("ctl00_ContentPlaceHolder1_txtretainage").value = "0.00";
            document.getElementById("ctl00_ContentPlaceHolder1_txtdueamount").value = "0.00";
            document.getElementById("ctl00_ContentPlaceHolder1_txtretainer").value = "0.00";


            document.getElementById("inv_projectname").innerHTML = '';
            document.getElementById("inv_summary_service").innerHTML = '-';
            document.getElementById("inv_summary_expense").innerHTML = '-';
            document.getElementById("inv_summary_contractamt").innerHTML = '-';
            document.getElementById("inv_summary_contracttype").innerHTML = '-';
            document.getElementById("inv_summary_percent").innerHTML = '-';

            //Fill Work-in-Progress (*billable only)
            document.getElementById("inv_ServiceAmt").innerHTML = '-';
            document.getElementById("inv_expAmt").innerHTML = '-';
            document.getElementById("inv_time").innerHTML = '-';
            document.getElementById("inv_prebilled").innerHTML = '-';
            document.getElementById("inv_no").innerHTML = '-';
            document.getElementById("inv_date").innerHTML = '-';
            document.getElementById("inv_amount").innerHTML = '-';




            var txtmemo = $find("<%= txtmemo.ClientID %>");
            if (txtmemo != null) {
                txtmemo.set_content("");
            }
            var rowcount = $('#tbldata tr').length;
            var table = document.getElementById("tbldata");
            for (var i = rowcount - 1; i >= 0; i--) {
                if (i == 0) {
                    document.getElementById("hidinvoicedetailid_" + i).value = "";
                    document.getElementById("ddltask_" + i).selectedIndex = 0;
                    document.getElementById("txtdesc_" + i).value = "";
                    document.getElementById("txtrate_" + i).value = "0.00";
                    //document.getElementById("txttax_" + i).value = "0.00";
                    //document.getElementById("spantotal_" + i).innerHTML = "";
                }
                else {
                    table.deleteRow(i);
                }

            }
            document.getElementById("<%=hidrowno.ClientID %>").value = 0;
            document.getElementById("<%=hidsno.ClientID %>").value = 1;
            getmaxinvoicenumber();
        }

        function getmaxinvoicenumber() {

            var companyid = document.getElementById("hidcompanyid").value;
            var args = { companyid: companyid, projectid: document.getElementById("ctl00_ContentPlaceHolder1_hidproject").value };
            $.ajax({

                type: "POST",
                url: "ManualInvoice.aspx/getmaxinvoice",
                data: JSON.stringify(args),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                cache: false,
                success: function (data) {

                    if (data.d != "failure") {
                        var arr1 = data.d.split("###");

                        document.getElementById("ctl00_ContentPlaceHolder1_txtinvoicenum").value = arr1[0];
                        document.getElementById("ctl00_ContentPlaceHolder1_hidmaxinvoiceno").value = arr1[0];
                        document.getElementById("ctl00_ContentPlaceHolder1_txtprefix").value = arr1[1];
                        document.getElementById("ctl00_ContentPlaceHolder1_txtpostfix").value = arr1[2];
                    }
                },
                error: function (x, e) {
                    document.getElementById("ctl00_ContentPlaceHolder1_txtinvoicenum").value = "";
                    document.getElementById("ctl00_ContentPlaceHolder1_txtprefix").value = "";
                    document.getElementById("ctl00_ContentPlaceHolder1_txtpostfix").value = "";
                    return;
                }

            });

        }
    </script>
    <!--Validate invoice-->
    <script type="text/javascript">
        function validate(validatefor) {

            var isvalid = true;
            if (document.getElementById("ctl00_ContentPlaceHolder1_dropProject").value == "" || document.getElementById("ctl00_ContentPlaceHolder1_hidproject").value == "") {
                isvalid = false;
                document.getElementById("spanproject").className = "errmsg";
            }
            else {
                document.getElementById("spanproject").className = "";
            }
            if (validatefor != "save") {
                if (document.getElementById("ctl00_ContentPlaceHolder1_txtinvoicenum").value == "") {
                    isvalid = false;
                    document.getElementById("spaninvoicenumber").className = "errmsg";
                }
                else {
                    document.getElementById("spaninvoicenumber").className = "";
                }
            }
            if (document.getElementById("ctl00_ContentPlaceHolder1_txtaddress").value == "") {
                isvalid = false;
                document.getElementById("spanbillingaddress").className = "errmsg";
            }
            else {
                document.getElementById("spanbillingaddress").className = "";
            }
            if (document.getElementById("ctl00_ContentPlaceHolder1_txtinvoicedate").value == "") {
                isvalid = false;
                document.getElementById("spaninvoicedate").className = "errmsg";
            }
            else {
                document.getElementById("spaninvoicedate").className = "";
            }




            var id = parseInt(document.getElementById("<%=hidrowno.ClientID %>").value);

            for (var i = 0; i <= id; i++) {


                newid = "txtdesc_" + i;

                if (document.getElementById(newid).value == "") {
                    isvalid = false;
                    document.getElementById(newid).className = "errform-control";
                }
                else {

                    document.getElementById(newid).className = "form-control";



                }

                newid = "txtrate_" + i;
                //  alert(newid);
                if (document.getElementById(newid).value == "" || document.getElementById(newid).value == "0") {
                    isvalid = false;
                    document.getElementById(newid).className = "errform-control";
                }
                else {
                    if (isNaN(document.getElementById(newid).value)) {
                        status = 0;
                        document.getElementById(newid).className = "errform-control";
                    }
                    else {
                        document.getElementById(newid).className = "form-control";
                    }
                }
                newid = "txtrate_" + i;
                //  alert(newid);
                if (document.getElementById(newid).value == "") {
                    isvalid = false;
                    document.getElementById(newid).className = "errform-control";
                }
                else {
                    if (isNaN(document.getElementById(newid).value)) {
                        isvalid = false;
                        document.getElementById(newid).className = "errform-control";
                    }
                    else {
                        document.getElementById(newid).className = "form-control";
                    }
                }

                if (parseFloat($("#inv_div_total1").html().replace("$", ""))<=0)
                {
                    alert("The total amount cannot less than or equal to 0.");
                    isvalid = false;
                }

                //                   newid = "txttax_" + i;
                //                   if (document.getElementById(newid).value == "" || document.getElementById(newid).value == "0") {
                //                       status = 0;
                //                       document.getElementById(newid).className = "errform-control";
                //                   }
                //                   else {
                //                       if (isNaN(document.getElementById(newid).value)) {
                //                           status = 0;
                //                           document.getElementById(newid).className = "errform-control";
                //                       }
                //                       else {
                //                           document.getElementById(newid).className = "form-control";
                //                       }
                //                   }
            }

            if (isvalid == true) {
                saveinvoice(validatefor);
            }
            else {
                return false;
            }
        }
        function addmemo()
        {
            $("#memodiv").show();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <pg:progress ID="progress2" runat="server" />

    <div id="divbillabletask" class="itempopup" style="width: 850px; position: absolute;">
        <div class="popup_heading">
            <span>Select Billable Tasks</span>
            <div class="f_right">
                <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
            </div>
        </div>
        <div class="tabContents">
            <div class="col-xs-12 col-sm-12 form-group mar pad">
                <div style="padding: 0px 15px;">
                    <div class="ctrlGroup">
                        <label class="lbl lbl2">
                            From Date :
                        </label>
                        <div class="txt w1 mar10">
                            <asp:TextBox ID="txtfromdate" runat="server" CssClass="form-control hasDatepicker"
                                placeholder="MM/DD/YYYY" onchange="checkdate(this.value,this.id);"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtfromdate"
                                PopupButtonID="txtfromdate" Format="MM/dd/yyyy">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="ctrlGroup">
                        <label class="lbl lbl2">
                            To Date :
                        </label>
                        <div class="txt w1 mar10">
                            <asp:TextBox ID="txttodate" runat="server" CssClass="form-control hasDatepicker"
                                placeholder="MM/DD/YYYY" onchange="checkdate(this.value,this.id);"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txttodate"
                                PopupButtonID="txttodate" Format="MM/dd/yyyy">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="ctrlGroup">
                        <input type="button" value="Search" class="btn btn-default" id="btnsearchbillingtask" onclick="fillBillingTask();" />
                    </div>
                    <div class="clear"></div>
                    <div>
                        <table class="tblsheet tblReport" cellspacing="0" cellpadding="4" border="0" style="width: 800px; border-collapse: collapse; max-width: 99%;">
                            <tr>
                                <th style="width: 40px; text-align: center;"></th>
                                <th style="width: 40px; text-align: center;">
                                    <input type="checkbox" checked="checked" onchange="checkallunbilled(this.id);" id="chkallunbilled" />
                                </th>
                                <th style="width: 80px;">Date
                                </th>
                                <th style="width: 120px;">Emp ID
                                </th>
                                <th style="width: 120px;">Task Code
                                </th>
                                <th>Description
                                </th>
                                <th style="width: 80px; text-align: right;">Hours
                                </th>
                            </tr>

                        </table>
                    </div>
                    <div class="clear"></div>
                    <div style="height: 280px; overflow-y: auto;">
                        <table id="trempty" class="tblsheet tblReport tbltasks" cellspacing="0" cellpadding="4" border="0" style="width: 800px; border-collapse: collapse; max-width: 99%; display: none;">
                            <tr>
                                <td style="width: 40px; text-align: center; height: 280px;">&nbsp;
                                </td>
                                <td style="width: 40px; text-align: center;">&nbsp;
                                </td>
                                <td style="width: 80px;">&nbsp;
                                </td>
                                <td style="width: 120px;">&nbsp;
                                </td>
                                <td style="width: 120px;">&nbsp;
                                </td>
                                <td>&nbsp;
                                </td>
                                <td style="width: 80px;">&nbsp;
                                </td>
                            </tr>
                        </table>
                        <table id="tblBillingTask" class="tblsheet tblReport tbltasks" cellspacing="0" cellpadding="4" border="0" style="width: 800px; border-collapse: collapse; max-width: 100%;">
                        </table>
                        <div class="clear"></div>

                    </div>
                    <div class="clear"></div>
                    <div style="padding: 10px 16px 0px 0px; float: right;">
                        <input type="button" value="Apply" class="btn btn-default btnapply" onclick="applybillabletask();" />
                        <input type="button" value="Close" class="btn btn-default" onclick="closediv();" />
                    </div>
                    <div class="clear"></div>
                </div>
            </div>
        </div>
    </div>
    <div id="otherdiv" onclick="closediv();">
    </div>
    <div class="pageheader">
        <h2>
            <i class="fa  fa-file-text"></i>Create Invoice
        </h2>
        <div class="breadcrumb-wrapper">
        </div>
        <div class="clear">
        </div>
    </div>

    <div class="contentpanel">
        <div class="row">
            <div class="col-sm-12 col-md-12">
                <div class="panel panel-default panel_no_border">
                    <div class="left-invoice-box col-sm-12 col-md-3" style="overflow-y: hidden;">
                        <div class="left-invoice-heading">Project Summary</div>
                        <div class="invoice-subhding" id="inv_projectname">
                            &nbsp;
                        </div>

                        <div id="divprojectsummary">
                            <p>Work-in-Progress (*billable only)</p>
                            <div class="invoice-txtbox clearfix">
                                <div class="invc-lft-txt">
                                    <ul>
                                        <li>Time :</li>
                                        <li>Service Amt. :</li>
                                        <li>Expenses Amt. :</li>
                                        <li>Pre-Billed :</li>

                                    </ul>
                                </div>
                                <div class="invc-rht-txt">
                                    <ul>
                                        <li id="inv_time">-</li>
                                        <li id="inv_ServiceAmt">-</li>
                                        <li id="inv_expAmt">-</li>
                                        <li id="inv_prebilled">-</li>

                                    </ul>
                                </div>

                            </div>


                            <p>Project Summary  <span class="spaninvtoggle invtogglearrow" onclick="toggledetail();"></span></p>
                            <div class="invoice-txtbox clearfix divtogglediv">
                                <div class="invc-lft-txt">
                                    <ul>
                                        <li>Contract Type :</li>
                                        <li>Contract Amt. :</li>
                                        <li>Service Amt. :</li>
                                        <li>Expenses Amt. :</li>
                                        <li>% Complete :</li>

                                    </ul>
                                </div>
                                <div class="invc-rht-txt">
                                    <ul>
                                        <li id="inv_summary_contracttype">-</li>
                                        <li id="inv_summary_contractamt">-</li>
                                        <li id="inv_summary_service">-</li>
                                        <li id="inv_summary_expense">-</li>
                                        <li id="inv_summary_percent">-</li>

                                    </ul>
                                </div>

                            </div>
                            <p>
                                Last Invoice
                                <span id="btnlastinv" class="spaninvtoggle" onclick="toggledetail();"></span>
                            </p>
                            <div class="invoice-txtbox clearfix divtogglediv" style="display: none;">

                                <div class="invc-lft-txt">
                                    <ul>
                                        <li>Date : </li>
                                        <li>Invoice No.  :</li>
                                        <li>Amount :</li>

                                    </ul>
                                </div>
                                <div class="invc-rht-txt">
                                    <ul>
                                        <li id="inv_date">-</li>
                                        <li id="inv_no">-</li>
                                        <li id="inv_amount">-</li>

                                    </ul>
                                </div>

                            </div>

                        </div>


                        <div id="divtotalsummary" style="display: none;">
                            <div class="invoice-txtbox clearfix">
                                <div class="invc-lft-txt">
                                    <ul>
                                        <li>Service Amt. :</li>
                                        <li>Expense Amt. :</li>
                                        <li>Sub Total :</li>

                                    </ul>
                                </div>
                                <div class="invc-rht-txt">
                                    <ul>
                                        <li><span>
                                            <%=strcurrency%></span>
                                            <input type="text" id="txtServiceAmount" runat="server" onkeypress="blockNonNumbers(this, event, true, false);"
                                                onkeyup="extractNumber(this,2,false);" value="0.00" class="desibletxt"
                                                style="width: 87%;" readonly="readonly" /></li>
                                        <li><span>
                                            <%=strcurrency%></span>
                                            <input type="text" id="txtExpenseAmount" runat="server" onkeypress="blockNonNumbers(this, event, true, false);"
                                                onkeyup="extractNumber(this,2,false);" value="0.00" class="desibletxt"
                                                style="width: 87%;" readonly="readonly" /></li>
                                        <li><span><%=strcurrency%></span><input type="text" id="txtsubtotal" runat="server" value="0.00"
                                            class="desibletxt" onkeypress="blockNonNumbers(this, event, true, false);"
                                            onkeyup="extractNumber(this,2,false);" readonly="readonly" /></li>

                                    </ul>
                                </div>

                            </div>
                            <div class="invoice-txtbox clearfix">
                                <div class="invc-lft-txt">
                                    <ul>
                                        <li>Tax : </li>
                                        <li>Tax % :</li>
                                        <li>Tax Amount :</li>

                                    </ul>
                                </div>
                                <div class="invc-rht-txt">
                                    <ul>
                                        <li>
                                            <asp:DropDownList ID="droptax" runat="server" onchange="gettaxpercentage();"
                                                class="form-control" />
                                        </li>
                                        <li>
                                            <input type="text" id="txttaxpercentage" runat="server" value="0.0000"
                                                class="form-control" onkeypress="blockNonNumbers(this, event, true, false);"
                                                onkeyup="extractNumber(this,4,false);" onblur="gettotal();" /></li>
                                        <li><span><%=strcurrency%></span><input type="text" id="txttaxamount" runat="server" value="0.00"
                                            class="desibletxt" readonly="readonly" onkeypress="blockNonNumbers(this, event, true, false);"
                                            onkeyup="extractNumber(this,2,false);" /></li>

                                    </ul>
                                </div>

                            </div>
                            <div class="invoice-txtbox clearfix">
                                <div class="invc-lft-txt">
                                    <ul>
                                        <li>Discount : </li>
                                        <li>Retainer (C) :</li>
                                        <li>Total :</li>


                                    </ul>
                                </div>
                                <div class="invc-rht-txt">
                                    <ul>
                                        <li>
                                            <span>
                                                <%=strcurrency%></span>
                                            <input type="text" id="txtdiscount" runat="server" value="0.00" onblur="gettotal();"
                                                class="form-control" onkeypress="blockNonNumbers(this, event, true, false);"
                                                onkeyup="extractNumber(this,2,false);" />
                                        </li>
                                        <li><span>
                                            <%=strcurrency%></span>
                                            <input type="text" id="txtretainer" runat="server" value="0.00" class="desibletxt"
                                                onkeypress="blockNonNumbers(this, event, true, false);"
                                                onkeyup="extractNumber(this,2,false);" readonly="readonly" /></li>
                                        <li><span><%=strcurrency%></span>
                                            <input type="text" id="txttotal" runat="server" value="0.00" class="desibletxt bold_txt"
                                                onkeypress="blockNonNumbers(this, event, true, false);"
                                                onkeyup="extractNumber(this,2,false);" readonly="readonly" /></li>

                                    </ul>
                                </div>

                            </div>

                            <div class="invoice-txtbox clearfix" style="display: none;">
                                <div class="invc-lft-txt">
                                    <ul>
                                        <li>Paid<span id="spanpaidamount">*</span>: </li>
                                        <li>Amount Due :</li>
                                        <li>Retainage :</li>


                                    </ul>
                                </div>
                                <div class="invc-rht-txt">
                                    <ul>
                                        <li>
                                            <span>
                                                <%=strcurrency%></span>
                                            <input type="text" id="txtpaidamount" runat="server" value="0.00" onblur="gettotal();"
                                                class="form-control input-sm" onkeypress="blockNonNumbers(this, event, true, false);"
                                                onkeyup="extractNumber(this,2,false);" style="width: 87%;" />
                                        </li>
                                        <li><span>
                                            <%=strcurrency%></span>
                                            <input type="text" id="txtdueamount" runat="server" value="0.00" class="form-control input-sm"
                                                style="width: 87%;" onkeypress="blockNonNumbers(this, event, true, false);"
                                                onkeyup="extractNumber(this,2,false);" readonly="readonly" /></li>
                                        <li><span><%=strcurrency%></span>
                                            <input type="text" id="txtretainage" runat="server" value="0.00" class="form-control input-sm"
                                                style="width: 87%;" onkeypress="blockNonNumbers(this, event, true, false);"
                                                onkeyup="extractNumber(this,2,false);" onchange="checkretainer(this.value);" /></li>

                                    </ul>
                                </div>

                            </div>
                        </div>

                    </div>

                    <div class="right-invoice-box col-sm-12 col-md-9">
                        <div class="invc-tab-top">
                            <ul id="inv_tab">
                                <li id="inv_tab_1" class="active"><span>1</span>Choose Project</li>
                                <li id="inv_tab_2"><span>2</span>Billing Address</li>
                                <li id="inv_tab_3"><span>3</span>Invoice Items</li>
                                <li style="display:none;" id="inv_tab_4"><span>4</span>Finalize Invoice</li>

                            </ul>

                        </div>

                        <div class="invc-dtl-box clearfix" id="inv_tab_1_detail">

                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Project ID :    <span id="spanproject">*</span>
                                </label>
                                <div class="txt w2 mar10">
                                    <asp:TextBox ID="dropProject" runat="server" CssClass="form-control">
                                    </asp:TextBox>
                                    <input type="hidden" id="hidproject" runat="server" />
                                </div>
                            </div>
                            <div class="clear"></div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Invoice Date : <span id="spaninvoicedate">*</span>
                                </label>
                                <div class="txt w1">
                                    <asp:TextBox ID="txtinvoicedate" runat="server" CssClass="form-control hasDatepicker"
                                        placeholder="MM/DD/YYYY" onchange="checkdate(this.value,this.id); getclientaddress();"></asp:TextBox>
                                    <cc1:CalendarExtender ID="txtDate_CalendarExtender1" runat="server" TargetControlID="txtinvoicedate"
                                        PopupButtonID="txtinvoicedate" Format="MM/dd/yyyy">
                                    </cc1:CalendarExtender>
                                </div>
                            </div>
                            <div class="clear"></div>

                            <div class="invc-nmbr-hding">Invoice Number : <span id="spaninvoicenumber">*</span></div>
                            <div class="clear"></div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Prefix :

                                </label>
                                <div class="txt w1 mar10">
                                    <asp:TextBox ID="txtprefix" CssClass="form-control" runat="server" ReadOnly="true"></asp:TextBox>
                                </div>
                            </div>

                            <div class="clear"></div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Serial No. :<span style="color: Red; visibility: hidden;" class="validation" id="ctl00_ContentPlaceHolder1_RequiredFieldValidator1">*</span>
                                </label>
                                <div class="txt w1">
                                    <asp:TextBox ID="txtinvoicenum" runat="server" CssClass="form-control" placeholder="Invoice No."
                                        onchange="bindinvoicebynumber(this.value,'invoicenum');"></asp:TextBox>
                                </div>
                            </div>
                            <div class="clear"></div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Suffix :
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:TextBox ID="txtpostfix" CssClass="form-control" runat="server" ReadOnly="true"></asp:TextBox>
                                </div>
                            </div>

                        </div>

                        <div class="invc-dtl-box clearfix" style="display: none" id="inv_tab_2_detail">

                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Client Name :
                                </label>
                                <div class="txt w2 mar10">
                                    <asp:TextBox ID="txtclientname" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                </div>
                            </div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Contact Person :
                                </label>
                                <div class="txt w2 mar10">
                                    <asp:TextBox ID="txtcontactperson" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                            <div class="clear"></div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Address 1 : <span id="spanbillingaddress">*</span>
                                </label>
                                <div class="txt w3">
                                    <asp:TextBox ID="txtaddress" runat="server" CssClass="form-control"></asp:TextBox><div class="clear"></div>
                                </div>
                            </div>
                            <div class="clear"></div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Address 2 :
                                </label>
                                <div class="txt w3">
                                    <asp:TextBox ID="street" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                            <div class="clear"></div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    State :<span id="spanstate">*</span>
                                </label>
                                <div class="txt w1">
                                    <asp:TextBox ID="txtstate" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                            <div class="ctrlGroup">
                                <label class="lbl" style="text-align:right;">
                                    City :<span id="spancity">*</span>
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:TextBox ID="txtcity" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>


                            <div class="clear"></div>
                            <div class="ctrlGroup" style="display: none">
                                <label class="lbl">
                                    Country :
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:TextBox ID="txtcountry" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    ZIP :
                                </label>
                                <div class="txt w1">
                                    <asp:TextBox ID="txtzip" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>


                        </div>
                        <div class="clear"></div>

                        <div class="invc-dtl-box clearfix" style="display: none;" id="inv_tab_3_detail">
                            <div class="invc-price-tag" id="inv_div_total">$0.00</div>
                            <div class="clear"></div>
                            <table width="100%" cellpadding="4" cellspacing="0" id="Table1" class="tblsheet">
                                <tr class="gridheader" id="trheader" runat="server">
                                    <th  style="display:none;" width="40px"></th>
                                    <th  style="display:none;" width="180px">Item
                                    </th>
                                    <th style="width:500px;">Description
                                    </th>
                                    <th  style="width:75px;">Rate
                                    </th>
                                    <th  style="width:75px;">Qty
                                    </th>
                                    <th width="120px">
                                        <%=strcurrency%>Amount
                                    </th>

                                </tr>
                            </table>
                            <div class="clear"></div>


                            <table width="100%" cellpadding="4" cellspacing="0" id="tbldata" class="tblsheet">
                                <tr>
                                  <td    valign="middle">
                                        <div id="divdel_0">
                                        </div>
                                    </td>
                                    <%--  <td style="display:none;"  >
                                        
                                    </td>--%>
                                    <td style="width:500px;">
                                        <select  style="display:none;" id="ddltask_0" class="form-control" onchange='bindtaskvalue(this.id,this.value);'>
                                            <%=strtask%>
                                        </select>
                                        
                                        <input type="hidden" id="hidinvoicedetailid_0" />
                                        <textarea id="txtdesc_0" class="form-control" style="height: 50px;" onkeydown="checkTextAreaMaxLength(this,event,'5000');"></textarea>
                                    </td>
                                    <td  style="width:75px;">
                                        <input id="txtrate1_0" onchange="fillprice(0)" onkeypress="TS_blockNonNumbers(this, event, true, false,0);"
                                                                    onblur="extractNumber(this,2,false);" onkeyup="extractNumber(this,2,false);" class="form-control" style="height: 50px;" />
                                    </td>
                                    <td  style="width:75px;"    >
                                        <input id="txtqty_0" onchange="fillprice(0)" onkeypress="TS_blockNonNumbers(this, event, true, false,0);"
                                                                    onblur="extractNumber(this,2,false);" onkeyup="extractNumber(this,2,false);" class="form-control" style="height: 50px;" />
                                    </td>
                                    <td width="120px">
                                        <input readonly type="text" id="txtrate_0" class="form-control" onkeypress="blockNonNumbers(this, event, true, true);fill(this.id);"
                                            onblur="fill(this.id);" onkeyup="extractNumber(this,2,true);fill(this.id);" />
                                    </td>

                                </tr>
                            </table>
                            <div class="add-new-txt">
                             
                              +&nbsp;<a onclick="return addrow();" id="addmore">Add New</a><br />
                                 +&nbsp;<a onclick="return addmemo();" id="addmemo">Add Memo</a>
                            </div>
                            <div class="col-md-12" id="memodiv" style="min-height:342px; display:none;">
                                
                            <div class="ctrlGroup searchgroup" style="display:none;">
                                <asp:CheckBox ID="chkMarkBilled" Text="Include Unbilled Tasks" CssClass="checkboxauto lblAuto" Style="max-width: none;"
                                    runat="server" onchange="fillBillingTask('');" />
                            </div>


                            <div class="ctrlGroup" style="display: none;" id="divviewtask">
                                <label class="lbl" style="width: auto; margin-top: 10px;">
                                    <a onclick="showbillabletask();">(View Billable Tasks)</a>
                                </label>
                            </div>




                            <div class="clear"></div>
                            <div class="clear"></div>
                            <div class="ctrlGroup">
                                <label class="lbl">
                                    Invoice Memo :
                                </label>

                            </div>
                            <div class="clear"></div>
                            <cc1:Editor ID="txtmemo" runat="server" Height="150px" BackColor="#cccccc" Width="100%" Style="max-height: 150px"
                                BorderStyle="Solid" BorderWidth="1" BorderColor="#e0e0e0" />



                            <input type="hidden" id="hidid" runat="server" />
                            <input type="hidden" id="hidrowno" runat="server" />
                            <input type="hidden" id="hidsno" runat="server" />
                            <input type="hidden" id="hidmaxinvoiceno" runat="server" />
                            <input type="hidden" id="hidprojectsno" runat="server" />
                            <input type="hidden" id="hidprojectgrt" runat="server" />
                            <input type="hidden" id="hidprojectexpensetax" runat="server" />
                            <input type="hidden" id="hidbilledtask" />

                            <input type="hidden" id="hidactivetab" value="1" />

                            <div style="display: none;" id="divtask">
                                <%=strtask%>
                            </div>

                            </div>
                        </div>

                        <div class="clear"></div>
                        <div class="invc-dtl-box clearfix" style="display: none;" id="inv_tab_4_detail">

                        </div>
                        <div class="clear"></div>
                        <div class="invc-btom-bar" style="display:none;" id="totlbar">
                            <div class="ttl-amt">Total Amount</div>
                            <div class="invc-amt" id="inv_div_total1">$0.00</div>

                        </div>

                    </div>

                    <div class="clear"></div>
                    <div class="invc-btn-box" id="inv_btn">
                        <div class="blue-btn" id="inv_btn_back_div" style="display: none;">
                            <input type="button" id="inv_btn_back" value="Back" />
                        </div>
                        <div class="blue-btn">
                            <input type="button" id="btnreset" onclick="return location.href = 'ManualInvoice.aspx'" value="Clear" />


                        </div>
                        <div class="green-btn" id="inv_btn_next_div">
                            <input type="button" id="inv_btn_next" value="Next" />
                        </div>

                        <div class="green-btn" style="display: none;" id="inv_btn_finish_div">
                            <input type="button" id="btnsubmit" runat="server" value="Finish"
                                onclick="validate('generated');" />
                        </div>
                        <div class="clear"></div>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <input type="hidden" value="0" id="maxservamt" />
    <input type="hidden" value="0" id="maxexpamt" />
    <script>

        function fillprice(id) {
            
            var rate = $("#txtrate1_" + id).val();
            var qty = $("#txtqty_" + id).val();
            if (qty != "" && rate != "") {
                if (isNaN(rate) && isNaN(qty)) {
                    $("#txtrate1_" + id).val('');
                    $("#txtqty_" + id).val('');
                } else {
                    if (id == "0") {
                        if ((rate * qty) > parseFloat($("#maxservamt").val())) {
                            alert("Amount cannot be more than service amount");
                            $("#txtrate1_" + id).val('0');
                            $("#txtqty_" + id).val('0');
                        } else {
                            $("#txtrate_" + id).val(rate * qty);
                            fill("txtrate_" + id);
                        }
                    }
                    if (id == "1") {
                        if ((rate * qty) > parseFloat($("#maxexpamt").val())) {
                            alert("Amount cannot be more than expense amount");
                            $("#txtrate1_" + id).val('0');
                            $("#txtqty_" + id).val('0');
                        } else {
                            $("#txtrate_" + id).val(rate * qty);
                            fill("txtrate_" + id);
                        }
                    }

                }
            }

        }
        $(document).ready(function () {

            if (document.getElementById("ctl00_ContentPlaceHolder1_hidid").value != "") {
                bindinvoicebynumber(document.getElementById("ctl00_ContentPlaceHolder1_txtinvoicenum").value, 'invoicenum');

                document.getElementById("btnreset").style.display = "none";
            }
            else {

                document.getElementById("btnreset").style.display = "block";
            }

            $('#inv_btn_next').click(function (e) {
                
                var lasID = parseInt(document.getElementById("hidactivetab").value);
                var curID = lasID + 1;

                showhidetab(lasID, curID);
            });

            $('#inv_btn_back').click(function (e) {

                var lasID = parseInt(document.getElementById("hidactivetab").value);
                var curID = lasID - 1;

                showhidetab(lasID, curID);
            });


        });

        function showhidetab(lasID, curID) {
           
            //var id = $(this).attr('id');
            //var curID = parseInt(id.replace('inv_tab_', ''));
            //var lasID = parseInt(document.getElementById("hidactivetab").value);
            if ($("#txtdesc_0").val() == "") {
                $("#txtdesc_0").val("Progressive Invoice for the Audit Services for the F.Y. ended September 30, 2017");
            }
            if (lasID != curID) {

                var status = 1;

                if (lasID < curID) {
                    if (lasID == 1) {
                        if (document.getElementById("ctl00_ContentPlaceHolder1_dropProject").value == "" || document.getElementById("ctl00_ContentPlaceHolder1_hidproject").value == "") {
                            status = 0;
                            document.getElementById("spanproject").className = "errmsg";
                        }
                        else {
                            document.getElementById("spanproject").className = "";
                        }
                        if (document.getElementById("ctl00_ContentPlaceHolder1_txtinvoicenum").value == "") {
                            status = 0;
                            document.getElementById("spaninvoicenumber").className = "errmsg";
                        }
                        else {
                            document.getElementById("spaninvoicenumber").className = "";
                        }
                        if (document.getElementById("ctl00_ContentPlaceHolder1_txtinvoicedate").value == "") {
                            status = 0;
                            document.getElementById("spaninvoicedate").className = "errmsg";
                        }
                        else {
                            document.getElementById("spaninvoicedate").className = "";
                        }

                    }

                    if (lasID == 2) {
                        if (parseInt(document.getElementById("ctl00_ContentPlaceHolder1_hidrowno").value) == 0 &&
                          parseInt(document.getElementById("ctl00_ContentPlaceHolder1_txtExpenseAmount").value) > 0) {
                            addrow();
                        }
                        if (document.getElementById("ctl00_ContentPlaceHolder1_txtaddress").value == "") {
                            status = 0;
                            document.getElementById("spanbillingaddress").className = "errmsg";
                        }
                        else {
                            document.getElementById("spanbillingaddress").className = "";
                        }

                        if (document.getElementById("ctl00_ContentPlaceHolder1_txtstate").value == "") {
                            status = 0;
                            document.getElementById("spanstate").className = "errmsg";
                        }
                        else {
                            document.getElementById("spanstate").className = "";
                        }
                        if (document.getElementById("ctl00_ContentPlaceHolder1_txtcity").value == "") {
                            status = 0;
                            document.getElementById("spancity").className = "errmsg";
                        }
                        else {
                            document.getElementById("spancity").className = "";
                        }
                    }

                    if (lasID == 3) {

                        $("#totlbar").show();

                        var id = parseInt(document.getElementById("<%=hidrowno.ClientID %>").value);

                        for (var i = 0; i <= id; i++) {


                            newid = "txtdesc_" + i;

                            if (document.getElementById(newid).value == "") {
                                status = 0;
                                document.getElementById(newid).className = "errform-control";
                            }
                            else {

                                document.getElementById(newid).className = "form-control";



                            }

                            newid = "txtrate_" + i;
                            //  alert(newid);
                            if (document.getElementById(newid).value == "" || document.getElementById(newid).value == "0") {
                                status = 0;
                                document.getElementById(newid).className = "errform-control";
                            }
                            else {
                                if (isNaN(document.getElementById(newid).value)) {
                                    status = 0;
                                    document.getElementById(newid).className = "errform-control";
                                }
                                else {
                                    document.getElementById(newid).className = "form-control";
                                }
                            }
                            newid = "txtrate_" + i;
                            //  alert(newid);
                            if (document.getElementById(newid).value == "") {
                                status = 0;
                                document.getElementById(newid).className = "errform-control";
                            }
                            else {
                                if (isNaN(document.getElementById(newid).value)) {
                                    status = 0;
                                    document.getElementById(newid).className = "errform-control";
                                }
                                else {
                                    document.getElementById(newid).className = "form-control";
                                }
                            }

                        }


                    }


                    if (lasID >= 2) {

                        $("#totlbar").show();
                    } else {
                        $("#totlbar").hide();
                    }

                }

                if (status == 1) {
                    $('#inv_tab_' + lasID).removeClass('active');
                    $('#inv_tab_' + curID).addClass('active');

                    $('#inv_tab_' + lasID + '_detail').hide();

                    if (curID == 3 || curID == 4) {
                        $('#divprojectsummary').hide();
                        $('#divtotalsummary').show();


                    }
                    else {
                        $('#divprojectsummary').show();
                        $('#divtotalsummary').hide();
                    }
                    $('#inv_btn_back_div').hide();
                    $('#inv_btn_next_div').hide();
                    $('#inv_btn_finish_div').hide();


                    if (curID == 1) {
                        $('#inv_btn_next_div').show();
                    }
                    if (curID == 2) {
                        $('#inv_btn_back_div').show();
                        $('#inv_btn_next_div').show();
                    }
                    
                    if (curID == 3) {
                      

                        $('#inv_btn_finish_div').show();
                        $('#inv_btn_back_div').show();
                        //$('#inv_btn_next_div').show();
                    }
                    if (curID == 4) {
                        $('#inv_btn_finish_div').show();
                        $('#inv_btn_back_div').show();
                    }



                    $('#inv_tab_' + curID + '_detail').show();
                    //$('#inv_tab_' + curID + '_detail').toggle("slide", {
                    //    direction: "right"
                    //});
                    document.getElementById("hidactivetab").value = curID;


                }


            }

        }

        function toggledetail(id, id2) {
            $('.spaninvtoggle').toggleClass('invtogglearrow');
            $('.divtogglediv').slideToggle("slow");
        }
        $(document).ready(function () {
         
            $("#txtdesc_0").val("Progressive Invoice for the Audit Services for the F.Y. ended September 30, 2017");
         
        })
    </script>
    <style>
        #inv_btn_next {
            margin-left: 5px;
        }
    </style>
</asp:Content>

