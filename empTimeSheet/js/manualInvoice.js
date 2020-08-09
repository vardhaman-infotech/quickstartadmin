var json;
var jsontasks;
var pagename = "ManualInvoice.aspx"
$(document).ready(function () {

    //---------
    var companyid = document.getElementById("hidcompanyid").value;
    //---------------------Get projects from script methos and put values to an array for autocompleter
    var args = { prefixText: "", companyid: companyid };
    $.ajax({

        type: "POST",
        url: pagename + "/getProjects",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {
            //Check length of returned data, if it is less than 0 it means there is some status available
            if (data.d != "failure") {
                json = $.parseJSON(data.d);
                //Call project autocompleter
                bindprojectautocompleter("ctl00_ContentPlaceHolder1_dropProject", "ctl00_ContentPlaceHolder1_hidproject");

            }
        }
    });
});
function bindprojectautocompleter(inputid, hiddenid) {

    $("#" + inputid + "").autocomplete({

        selectFirst: true,
        delay: 0,
        mustMatch: true,
        autoFocus: true,
        source: json,
        select: function (event, ui) {
            $("#" + hiddenid + "").val(ui.item.value);
            $("#" + inputid + "").val(ui.item.label1);


            return false;
        },
        change: function (event, ui) {

            $(this).val((ui.item ? ui.item.label1 : ""));
            $("#" + hiddenid + "").val((ui.item ? ui.item.value : ""));
            getclientaddress();

        },
        focus: function (event, ui) { event.preventDefault(); }
    });
}

function checkallunbilled(id) {


    if ($("#tblBillingTask tr").length > 0) {
        var status = document.getElementById(id).checked;
        var i = 0;
        $('#tblBillingTask  tr').each(function () {


            document.getElementById("chkbilling" + i).checked = status;


            i = i + 1;
        });
    }
}
function applybillabletask() {
    var selectedtask = "";
    if ($("#tblBillingTask tr").length > 0) {

        var i = 0;
        $('#tblBillingTask  tr').each(function () {

            if (document.getElementById("chkbilling" + i).checked) {
                selectedtask = selectedtask + document.getElementById("hidbilling" + i).value + ','
                $(this).children().eq(0).html('<img src="images/apply_icon.png" />');
                $(this).children().eq(1).css("color", "#1CAF9A");
                $(this).children().eq(2).css("color", "#1CAF9A");
                $(this).children().eq(3).css("color", "#1CAF9A");
                $(this).children().eq(4).css("color", "#1CAF9A");
                $(this).children().eq(5).css("color", "#1CAF9A");
                $(this).children().eq(6).css("color", "#1CAF9A");
            }
            else {
                $(this).children().eq(0).html('')
                $(this).children().eq(1).css("color", "#000000");
                $(this).children().eq(2).css("color", "#000000");
                $(this).children().eq(3).css("color", "#000000");
                $(this).children().eq(4).css("color", "#000000");
                $(this).children().eq(5).css("color", "#000000");
                $(this).children().eq(6).css("color", "#000000");
            }
            i = i + 1;
        });
    }

    document.getElementById("hidbilledtask").value = selectedtask;

}
function showbillabletask() {

    setposition("divbillabletask");
    $('#otherdiv').show();
    $('#divbillabletask').show();

}
function closediv() {
    $('#otherdiv').hide();
    $('#divbillabletask').hide();
}

function fillBillingTask(openfrom) {
    $("#tblBillingTask").empty();
    document.getElementById("hidbilledtask").value = "";

    if (document.getElementById("ctl00_ContentPlaceHolder1_chkMarkBilled").checked) {
        $('#divviewtask').show();

        var strtbl = '';

        var jsonbilling;

        $('#ctl00_ContentPlaceHolder1_progress2_UpdateProg1').show();
        var args = { projectid: document.getElementById("ctl00_ContentPlaceHolder1_hidproject").value, fromdate: document.getElementById("ctl00_ContentPlaceHolder1_txtfromdate").value, todate: document.getElementById("ctl00_ContentPlaceHolder1_txttodate").value, invoiceid: document.getElementById("ctl00_ContentPlaceHolder1_hidid").value };
        $.ajax({

            type: "POST",
            url: pagename + "/getBillableTask",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            cache: false,
            success: function (data) {
                if (data.d != "failure") {
                    jsonbilling = $.parseJSON(data.d);


                    if (jsonbilling.length > 0) {
                        document.getElementById("trempty").style.display = "none";
                        for (var i in jsonbilling) {
                            var height = "";
                            if (jsonbilling.length < 10) {
                                if (i == jsonbilling.length - 1) {

                                    var newheight = i * 28;
                                    newheight = 280 - newheight;
                                    height = 'height:' + newheight + 'px;';
                                }

                            }
                            strtbl += '<tr><td style="width: 40px; text-align: center;' + height + '"> </td>';

                            if (document.getElementById("ctl00_ContentPlaceHolder1_hidid").value == "") {
                                strtbl += ' <td style="width: 40px; text-align: center;">\
                                    <input id="chkbilling'+ i + '" type="checkbox" checked="checked" /><input type="hidden" id="hidbilling' + i + '" value="' + jsonbilling[i].nid + '" /> \
                                </td>';
                            }
                            else {
                                if (jsonbilling[i].included == "yes") {
                                    strtbl += ' <td style="width: 40px; text-align: center;">\
                                    <input id="chkbilling'+ i + '" type="checkbox" checked="checked" /><input type="hidden" id="hidbilling' + i + '" value="' + jsonbilling[i].nid + '" /> \
                                </td>';

                                }
                                else {
                                    strtbl += ' <td style="width: 40px; text-align: center;">\
                                    <input id="chkbilling'+ i + '" type="checkbox"  /><input type="hidden" id="hidbilling' + i + '" value="' + jsonbilling[i].nid + '" /> \
                                </td>';
                                }
                            }


                            strtbl += '<td style="width: 80px;">' + jsonbilling[i].date + '</td>\
                                        <td style="width: 120px;">' + jsonbilling[i].loginId +
                            '</td>\
                                        <td style="width: 120px;">' + jsonbilling[i].taskcode + ' ' + jsonbilling[i].taskname +
                            '</td> <td>' + jsonbilling[i].description +
                           ' </td>\
                                        <td style="width: 80px; text-align: right;">' + jsonbilling[i].hours +
                            '</td>\
                                    </tr>';
                        }
                    }
                    else {
                        document.getElementById("trempty").style.display = "table";
                    }



                }
                document.getElementById("tblBillingTask").innerHTML = strtbl;
                $('#ctl00_ContentPlaceHolder1_progress2_UpdateProg1').hide();


                if (openfrom == null || openfrom == "")
                    showbillabletask();
                else {
                    applybillabletask();
                }
            }

        });


    }
    else {
        $('#divviewtask').hide();
        document.getElementById("hidbilledtask").value = "";

    }
}


function addrowcc() {
     
    var table = document.getElementById("tbldata");
    var id = parseInt(document.getElementById("ctl00_ContentPlaceHolder1_hidrowno").value);
    var sno = parseInt(document.getElementById("ctl00_ContentPlaceHolder1_hidsno").value);
    sno = sno + 1
    var newsno = id + 1;
    var row = table.insertRow(newsno);
    if (id > 0)
        document.getElementById("divdel_" + id).innerHTML = "";

    var celldelete = row.insertCell(0);
    var celltask = row.insertCell(1);
    var celldes = row.insertCell(2);

    var cellrate1 = row.insertCell(3);
    var cellqty = row.insertCell(4);
    var cellrate = row.insertCell(5);
    // var celltax = row.insertCell(4);
    //var celltotal = row.insertCell(5);

    celldelete.innerHTML = "<input type='hidden' id='hidinvoicedetailid_" + newsno + "' /><div id='divdel_" + newsno + "' ><a style='cursor: pointer;color:bule;' id='delete' onclick='deleterow(this.id);' ><i class='fa fa-fw' style='font-size: 18px; color: #d9534f; display: block; margin: auto;'><img src='images/delete.png' alt=''></i></a></div>";
    celltask.innerHTML = "<select id='ddltask_" + newsno + "' class='form-control' onchange='bindtaskvalue(this.id,this.value);' >" + document.getElementById("divtask").innerHTML + "</select>";
    cellrate1.innerHTML = "<input id='txtrate1_" + newsno + "' onchange='fillprice(" + newsno + ")' class='form-control' style='height: 50px;'   />";
    cellqty.innerHTML = "<input id='txtqty_'" + newsno + " onchange='fillprice(" + newsno + ")' class='form-control' style='height: 50px;'   />";
    cellrate.innerHTML = "<input readonly type='text' id='txtrate_" + newsno + "' class='form-control' onkeypress='blockNonNumbers(this, event, true, true);fill(this.id);' onblur='fill(this.id);' onkeyup='extractNumber(this,2,true);fill(this.id);' />";
    celldes.innerHTML = "<textarea id='txtdesc_" + newsno + "' class='form-control' style='height:50px;' onkeyDown='checkTextAreaMaxLength(this,event,5000);'></textarea>";
    //celltax.innerHTML = "<input type='text' id='txttax_" + newsno + "' class='form-control' onkeypress='blockNonNumbers(this, event, true, false);' onblur='fill(this.id);' onkeyup='extractNumber(this,2,false);' />";
    //celltotal.innerHTML = "$<span id='spantotal_" + newsno + "'>0.00</span>";
    document.getElementById("ctl00_ContentPlaceHolder1_hidrowno").value = newsno;
    document.getElementById("ctl00_ContentPlaceHolder1_hidsno").value = sno;
    //var height = $('#divsheetbox').scrollHeight;
    //$('#divsheetbox').scrollTop(height);
}

//Delete rows
function deleterow() {
    var table = document.getElementById("tbldata");
    var id = parseInt(document.getElementById("ctl00_ContentPlaceHolder1_hidrowno").value);
    var sno = parseInt(document.getElementById("ctl00_ContentPlaceHolder1_hidsno").value);
    sno = sno - 1
    var newsno = id - 1;
    table.deleteRow(id);
    if (newsno != "0")
        document.getElementById("divdel_" + newsno).innerHTML = "<a style='cursor: pointer;color:bule;' id='delete' onclick='deleterow(this.id);' ><i class='fa fa-fw' style='font-size: 18px; color: #d9534f; display: block; margin: auto;'><img src='images/delete.png' alt=''></i></a>";
    document.getElementById("ctl00_ContentPlaceHolder1_hidrowno").value = newsno;
    document.getElementById("ctl00_ContentPlaceHolder1_hidsno").value = sno;
    fill('txtrate_' + newsno);

}
function gettaxvalue(recordtype) {
    var taskarr = document.getElementById("ctl00_ContentPlaceHolder1_droptax").value.split("###");
    if (recordtype == "nid") {
        return taskarr[0];
    }
    else {
        return taskarr[1];
    }
}

//bind selected task descripton
function bindtaskvalue(id, value) {



    var rownum = id.replace('ddltask_', '');
    var taskarr = value.split("#");

    if (value != "")
        document.getElementById("txtdesc_" + rownum).value = taskarr[2];
    else
        document.getElementById("txtdesc_" + rownum).value = "";
    //if (taskarr[3].toString().toLowerCase() == "task") {
    //    document.getElementById("txttax_" + rownum).value = document.getElementById("ctl00_ContentPlaceHolder1_hidprojectgrt").value;
    //}
    //else {
    //    document.getElementById("txttax_" + rownum).value = document.getElementById("ctl00_ContentPlaceHolder1_hidprojectexpensetax").value;

    //}
    fill("txttax_" + rownum);
}

//Calculate amount whenever rate or tax added or updated in any rows
//and bind total calculated amount to text boxes
function fill(id) {
    id = id.substr(id.indexOf("_") + 1)
    var total = 0.00;
    var tax = 0.00;
    var subtotal = 0.00;
    var discount = 0.00;
    var serviceamount = 0.00;
    var expenseamount = 0.00;

    var paid = 0.00;
    

    for (var i = 0; i <= parseInt(document.getElementById("ctl00_ContentPlaceHolder1_hidrowno").value) ; i++) {
        var rate = 0.00, rowtotal = 0.00, taxamount = 0.00, taxpercent = 0.00;

        if (document.getElementById("txtrate_" + i).value != "")
            rate = parseFloat(document.getElementById("txtrate_" + i).value);
        else
            rate = 0.00;

        //if (document.getElementById("ddltask_" + i).value != "")
        //    expenseamount = expenseamount + rate;
        //else
        //    serviceamount = serviceamount + rate;

        //SLS 
        if (i == "0")
           serviceamount = serviceamount + rate;
        else
            expenseamount = expenseamount + rate;

        //if (document.getElementById("txttax_" + i).value != "")
        //    taxpercent = parseFloat(document.getElementById("txttax_" + i).value);
        //else
        taxpercent = 0.00;

        taxamount = parseFloat(rate * taxpercent) / 100;
        rowtotal = rate + taxamount;
        // document.getElementById("spantotal_" + i).innerHTML = parseFloat(rowtotal).toFixed(2);

        subtotal = (parseFloat(subtotal) + parseFloat(rate)).toFixed(2);
        total = total + parseFloat(rate);
        tax = tax + taxamount;

    }
    if (document.getElementById("ctl00_ContentPlaceHolder1_txttaxpercentage").value != "")
        taxpercent = parseFloat(document.getElementById("ctl00_ContentPlaceHolder1_txttaxpercentage").value);

    taxamount = parseFloat(serviceamount * taxpercent) / 100;

    if (document.getElementById("ctl00_ContentPlaceHolder1_txtdiscount").value == "") {
        discount = 0.00;
    }
    else {
        discount = parseFloat(document.getElementById("ctl00_ContentPlaceHolder1_txtdiscount").value).toFixed(2);
    }
    total = (total - discount).toFixed(2);
    if (document.getElementById("ctl00_ContentPlaceHolder1_txtpaidamount").value == "") {
        paid = 0.00;
    }
    else {
        paid = parseFloat(document.getElementById("ctl00_ContentPlaceHolder1_txtpaidamount").value);
    }
    total = parseFloat(total).toFixed(2) + taxamount

    //if (i == "0") {
        document.getElementById("ctl00_ContentPlaceHolder1_txtServiceAmount").value = serviceamount;
   // } else {
        document.getElementById("ctl00_ContentPlaceHolder1_txtExpenseAmount").value = expenseamount;
   // }

    var retainageamt = document.getElementById("ctl00_ContentPlaceHolder1_txtretainage").value;
   
    document.getElementById("ctl00_ContentPlaceHolder1_txttaxamount").value = taxamount;
    document.getElementById("ctl00_ContentPlaceHolder1_txtsubtotal").value = subtotal;
    document.getElementById("ctl00_ContentPlaceHolder1_txttotal").value = parseFloat(total).toFixed(2);
    document.getElementById("ctl00_ContentPlaceHolder1_txtdueamount").value = parseFloat(total - (parseFloat(paid) + parseFloat(retainageamt))).toFixed(2);
    gettaxpercentage();
}

//Whenever changes to Discount, Ratiner amount, bind the Total Amount to be paid
function gettotal() {
    
    var total = 0.00;
    var taxpercent = 0.00;
    var taxamount = 0.00;
    var subtotal = 0.00;
    var discount = 0.00;
    var serviceamount = 0.00;
    var expenseamount = 0.00;
    if (document.getElementById("ctl00_ContentPlaceHolder1_txtServiceAmount").value != "") {
        serviceamount = document.getElementById("ctl00_ContentPlaceHolder1_txtServiceAmount").value;
    }

    if (document.getElementById("ctl00_ContentPlaceHolder1_txtExpenseAmount").value != "") {
        expenseamount = document.getElementById("ctl00_ContentPlaceHolder1_txtExpenseAmount").value;
    }

    if (document.getElementById("ctl00_ContentPlaceHolder1_txttaxpercentage").value != "") {
        taxpercent = parseFloat(document.getElementById("ctl00_ContentPlaceHolder1_txttaxpercentage").value);
    }

    taxamount = parseFloat(serviceamount * taxpercent) / 100;
    document.getElementById("ctl00_ContentPlaceHolder1_txttaxamount").value = taxamount;

    var paid = 0.00;
    if (document.getElementById("ctl00_ContentPlaceHolder1_txtdiscount").value == "") {
        discount = 0.00;
    }
    else {
        discount = parseFloat(document.getElementById("ctl00_ContentPlaceHolder1_txtdiscount").value);
    }
    total = (parseFloat(document.getElementById("ctl00_ContentPlaceHolder1_txtsubtotal").value)
    + parseFloat(document.getElementById("ctl00_ContentPlaceHolder1_txttaxamount").value))
    - parseFloat(discount).toFixed(2);

    if (document.getElementById("ctl00_ContentPlaceHolder1_txtpaidamount").value == "") {
        paid = 0.00;
    }
    else {
        paid = parseFloat(document.getElementById("ctl00_ContentPlaceHolder1_txtpaidamount").value).toFixed(2);
    }
    document.getElementById("ctl00_ContentPlaceHolder1_txttotal").value = parseFloat(total).toFixed(2);
    document.getElementById("inv_div_total1").innerHTML = '$' + parseFloat(total).toFixed(2);
    document.getElementById("inv_div_total").innerHTML = '$' + parseFloat(total).toFixed(2);

    var retainageamt = document.getElementById("ctl00_ContentPlaceHolder1_txtretainage").value;
    document.getElementById("ctl00_ContentPlaceHolder1_txtdueamount").value = (parseFloat(total) - (parseFloat(paid) + parseFloat(retainageamt))).toFixed(2);
}


function addrow() {
    var table = document.getElementById("tbldata");
    var id = parseInt(document.getElementById("ctl00_ContentPlaceHolder1_hidrowno").value);
    var sno = parseInt(document.getElementById("ctl00_ContentPlaceHolder1_hidsno").value);
    sno = sno + 1
    var newsno = id + 1;
    var row = table.insertRow(newsno);
    if (id > 0)
        document.getElementById("divdel_" + id).innerHTML = "";

     var celldelete = row.insertCell(0);
  //  var celltask = row.insertCell(1);
    var celldes = row.insertCell(1);

    var cellrate1 = row.insertCell(2);
    var cellqty = row.insertCell(3);
    var cellrate = row.insertCell(4);
    // var celltax = row.insertCell(4);
    //var celltotal = row.insertCell(5);

    //celldelete.innerHTML = "<input type='hidden' id='hidinvoicedetailid_" + newsno + "' /><div id='divdel_" + newsno + "' ><a style='cursor: pointer;color:bule;' id='delete' onclick='deleterow(this.id);' ><i class='fa fa-fw' style='font-size: 18px; color: #d9534f; display: block; margin: auto;'><img src='images/delete.png' alt=''></i></a></div>";
    //celltask.innerHTML = "<select id='ddltask_" + newsno + "' class='form-control' onchange='bindtaskvalue(this.id,this.value);' >" + document.getElementById("divtask").innerHTML + "</select>";

    celldelete.innerHTML =  "<input type='hidden' id='hidinvoicedetailid_" + newsno + "' /><div id='divdel_" + newsno + "' ><a style='cursor: pointer;color:bule;' id='delete' onclick='deleterow(this.id);' ><i class='fa fa-fw' style='font-size: 18px; color: #d9534f; display: block; margin: auto;'><img src='images/delete.png' alt=''></i></a></div>";
     var fcell = "<select style='display:none;' id='ddltask_" + newsno + "' class='form-control' onchange='bindtaskvalue(this.id,this.value);' >" + document.getElementById("divtask").innerHTML + "</select>";

    cellrate1.innerHTML = "<input id='txtrate1_" + newsno + "' onchange='fillprice(" + newsno + ")' class='form-control' style='height: 50px;'   />";
    cellqty.innerHTML = "<input id='txtqty_" + newsno + "' onchange='fillprice(" + newsno + ")' class='form-control' style='height: 50px;'   />";

    cellrate.innerHTML = "<input type='text' id='txtrate_" + newsno + "' class='form-control' onkeypress='blockNonNumbers(this, event, true, true);fill(this.id);' onblur='fill(this.id);' onkeyup='extractNumber(this,2,true);fill(this.id);' />";
    celldes.innerHTML = fcell+ "<textarea id='txtdesc_" + newsno + "' class='form-control' style='height:50px;' onkeyDown='checkTextAreaMaxLength(this,event,5000);'></textarea>";
    //celltax.innerHTML = "<input type='text' id='txttax_" + newsno + "' class='form-control' onkeypress='blockNonNumbers(this, event, true, false);' onblur='fill(this.id);' onkeyup='extractNumber(this,2,false);' />";
    //celltotal.innerHTML = "$<span id='spantotal_" + newsno + "'>0.00</span>";
    document.getElementById("ctl00_ContentPlaceHolder1_hidrowno").value = newsno;
    document.getElementById("ctl00_ContentPlaceHolder1_hidsno").value = sno;
    //var height = $('#divsheetbox').scrollHeight;
    //$('#divsheetbox').scrollTop(height);\\
    if (newsno == 1) {
        $('#txtdesc_' + newsno).val("Out of Pocket Expenses");
        $('#txtrate_' + newsno).val($("#ctl00_ContentPlaceHolder1_txtExpenseAmount").val());
    }
}

//Delete rows
function deleterow() {
    var table = document.getElementById("tbldata");
    var id = parseInt(document.getElementById("ctl00_ContentPlaceHolder1_hidrowno").value);
    var sno = parseInt(document.getElementById("ctl00_ContentPlaceHolder1_hidsno").value);
    sno = sno - 1
    var newsno = id - 1;
    table.deleteRow(id);
    if (newsno != "0")
        document.getElementById("divdel_" + newsno).innerHTML = "<a style='cursor: pointer;color:bule;' id='delete' onclick='deleterow(this.id);' ><i class='fa fa-fw' style='font-size: 18px; color: #d9534f; display: block; margin: auto;'><img src='images/delete.png' alt=''></i></a>";
    document.getElementById("ctl00_ContentPlaceHolder1_hidrowno").value = newsno;
    document.getElementById("ctl00_ContentPlaceHolder1_hidsno").value = sno;
    fill('txtrate_' + newsno);

}
function gettaxvalue(recordtype) {
    var taskarr = document.getElementById("ctl00_ContentPlaceHolder1_droptax").value.split("###");
    if (recordtype == "nid") {
        return taskarr[0];
    }
    else {
        return taskarr[1];
    }
}

//bind selected task descripton
function bindtaskvalue(id, value) {



    var rownum = id.replace('ddltask_', '');
    var taskarr = value.split("#");

    if (value != "")
        document.getElementById("txtdesc_" + rownum).value = taskarr[2];
    else
        document.getElementById("txtdesc_" + rownum).value = "";
    //if (taskarr[3].toString().toLowerCase() == "task") {
    //    document.getElementById("txttax_" + rownum).value = document.getElementById("ctl00_ContentPlaceHolder1_hidprojectgrt").value;
    //}
    //else {
    //    document.getElementById("txttax_" + rownum).value = document.getElementById("ctl00_ContentPlaceHolder1_hidprojectexpensetax").value;

    //}
    fill("txttax_" + rownum);
}

//Calculate amount whenever rate or tax added or updated in any rows
//and bind total calculated amount to text boxes
function fillx(id) {
    id = id.substr(id.indexOf("_") + 1)
    var total = 0.00;
    var tax = 0.00;
    var subtotal = 0.00;
    var discount = 0.00;
    var serviceamount = 0.00;
    var expenseamount = 0.00;

    var paid = 0.00;


    for (var i = 0; i <= parseInt(document.getElementById("ctl00_ContentPlaceHolder1_hidrowno").value) ; i++) {
        var rate = 0.00, rowtotal = 0.00, taxamount = 0.00, taxpercent = 0.00;

        if (document.getElementById("txtrate_" + i).value != "")
            rate = parseFloat(document.getElementById("txtrate_" + i).value);
        else
            rate = 0.00;

        if (document.getElementById("ddltask_" + i).value != "")
            expenseamount = expenseamount + rate;
        else
            serviceamount = serviceamount + rate;

        //if (document.getElementById("txttax_" + i).value != "")
        //    taxpercent = parseFloat(document.getElementById("txttax_" + i).value);
        //else
        taxpercent = 0.00;

        taxamount = parseFloat(rate * taxpercent) / 100;
        rowtotal = rate + taxamount;
        // document.getElementById("spantotal_" + i).innerHTML = parseFloat(rowtotal).toFixed(2);

        subtotal = (parseFloat(subtotal) + parseFloat(rate)).toFixed(2);
        total = total + parseFloat(rate);
        tax = tax + taxamount;

    }
    if (document.getElementById("ctl00_ContentPlaceHolder1_txttaxpercentage").value != "")
        taxpercent = parseFloat(document.getElementById("ctl00_ContentPlaceHolder1_txttaxpercentage").value);

    taxamount = parseFloat(serviceamount * taxpercent) / 100;

    if (document.getElementById("ctl00_ContentPlaceHolder1_txtdiscount").value == "") {
        discount = 0.00;
    }
    else {
        discount = parseFloat(document.getElementById("ctl00_ContentPlaceHolder1_txtdiscount").value).toFixed(2);
    }
    total = (total - discount).toFixed(2);
    if (document.getElementById("ctl00_ContentPlaceHolder1_txtpaidamount").value == "") {
        paid = 0.00;
    }
    else {
        paid = parseFloat(document.getElementById("ctl00_ContentPlaceHolder1_txtpaidamount").value);
    }
    total = parseFloat(total).toFixed(2) + taxamount
    var retainageamt = document.getElementById("ctl00_ContentPlaceHolder1_txtretainage").value;
    document.getElementById("ctl00_ContentPlaceHolder1_txtServiceAmount").value = serviceamount;
    document.getElementById("ctl00_ContentPlaceHolder1_txtExpenseAmount").value = expenseamount;
    document.getElementById("ctl00_ContentPlaceHolder1_txttaxamount").value = taxamount;
    document.getElementById("ctl00_ContentPlaceHolder1_txtsubtotal").value = subtotal;
    document.getElementById("ctl00_ContentPlaceHolder1_txttotal").value = parseFloat(total).toFixed(2);
    document.getElementById("ctl00_ContentPlaceHolder1_txtdueamount").value = parseFloat(total - (parseFloat(paid) + parseFloat(retainageamt))).toFixed(2);
    gettaxpercentage();
}

//Whenever changes to Discount, Ratiner amount, bind the Total Amount to be paid
function gettotal() {
    
    var total = 0.00;
    var taxpercent = 0.00;
    var taxamount = 0.00;
    var subtotal = 0.00;
    var discount = 0.00;
    var serviceamount = 0.00;
    var expenseamount = 0.00;
    if (document.getElementById("ctl00_ContentPlaceHolder1_txtServiceAmount").value != "") {
        serviceamount = document.getElementById("ctl00_ContentPlaceHolder1_txtServiceAmount").value;
    }

    if (document.getElementById("ctl00_ContentPlaceHolder1_txtExpenseAmount").value != "") {
        expenseamount = document.getElementById("ctl00_ContentPlaceHolder1_txtExpenseAmount").value;
    }

    if (document.getElementById("ctl00_ContentPlaceHolder1_txttaxpercentage").value != "") {
        taxpercent = parseFloat(document.getElementById("ctl00_ContentPlaceHolder1_txttaxpercentage").value);
    }

    taxamount = parseFloat(serviceamount * taxpercent) / 100;
    document.getElementById("ctl00_ContentPlaceHolder1_txttaxamount").value = taxamount;

    var paid = 0.00;
    if (document.getElementById("ctl00_ContentPlaceHolder1_txtdiscount").value == "") {
        discount = 0.00;
    }
    else {
        discount = parseFloat(document.getElementById("ctl00_ContentPlaceHolder1_txtdiscount").value);
    }
    total = (parseFloat(document.getElementById("ctl00_ContentPlaceHolder1_txtsubtotal").value)
    + parseFloat(document.getElementById("ctl00_ContentPlaceHolder1_txttaxamount").value))
    - parseFloat(discount).toFixed(2);

    if (document.getElementById("ctl00_ContentPlaceHolder1_txtpaidamount").value == "") {
        paid = 0.00;
    }
    else {
        paid = parseFloat(document.getElementById("ctl00_ContentPlaceHolder1_txtpaidamount").value).toFixed(2);
    }
    document.getElementById("ctl00_ContentPlaceHolder1_txttotal").value = parseFloat(total).toFixed(2);
    document.getElementById("inv_div_total1").innerHTML = '$' + parseFloat(total).toFixed(2);
    document.getElementById("inv_div_total").innerHTML = '$' + parseFloat(total).toFixed(2);

    var retainageamt = document.getElementById("ctl00_ContentPlaceHolder1_txtretainage").value;
    document.getElementById("ctl00_ContentPlaceHolder1_txtdueamount").value = (parseFloat(total) - (parseFloat(paid) + parseFloat(retainageamt))).toFixed(2);
}

function getclientdetail(event) {

    if (event.keyCode == 9) {

        $('#ctl00_ContentPlaceHolder1_txtaddress').focus();

        event.preventDefault();
    }
}


function splitaddress(arr) {
    var arr1 = arr.split("!!!");
    if (arr1.length > 0) {
        document.getElementById("ctl00_ContentPlaceHolder1_txtclientname").value = arr1[0];
        document.getElementById("inv_projectname").innerHTML = arr1[0];

        if (arr1[1] != "") {
            document.getElementById("ctl00_ContentPlaceHolder1_txtcontactperson").value = arr1[1];
            if (arr1[2] != "") {
                document.getElementById("ctl00_ContentPlaceHolder1_txtcontactperson").value = arr1[1] + ", " + arr1[2];
            }

        }
        document.getElementById("ctl00_ContentPlaceHolder1_txtaddress").value = arr1[3];
        document.getElementById("ctl00_ContentPlaceHolder1_street").value = arr1[4];

        document.getElementById("ctl00_ContentPlaceHolder1_txtcity").value = arr1[5];
        document.getElementById("ctl00_ContentPlaceHolder1_txtstate").value = arr1[6];
        document.getElementById("ctl00_ContentPlaceHolder1_txtcountry").value = arr1[7];
        document.getElementById("ctl00_ContentPlaceHolder1_txtzip").value = arr1[8];


    }

}

//Get tax percentage when selects tax name
function gettaxpercentage() {
    var taxpercent = 0.00;
    if (document.getElementById("ctl00_ContentPlaceHolder1_droptax").value != "") {
        document.getElementById("ctl00_ContentPlaceHolder1_txttaxpercentage").disabled = false;
        taxpercent = gettaxvalue("taxpercentage");
    }
    else {
        document.getElementById("ctl00_ContentPlaceHolder1_txttaxpercentage").disabled = true;
        document.getElementById("ctl00_ContentPlaceHolder1_txttaxpercentage").value = "0.00";
    }
    document.getElementById("ctl00_ContentPlaceHolder1_txttaxpercentage").value = taxpercent;

    gettotal();
}


function getinvoicedetail() {
    var rowcount = $('#tbldata tr').length;
    var invoicedetail = "[";
    for (var i = 0; i < rowcount; i++) {
        var invoicedetailid = document.getElementById("hidinvoicedetailid_" + i).value;
        var taskid = document.getElementById("ddltask_" + i).value;
        var taskarr = taskid.split("#");
        var description = document.getElementById("txtdesc_" + i).value.replace(/\r?\n/g, '<br/>');

        description = description.replace("'", '&apos;');

        var regex1 = new RegExp("'", 'g');
        description = description.replace(regex1, '&apos;');


        description = description.replace(/\\/g, "####");





        var rate = document.getElementById("txtrate_" + i).value;
        if (rate == "")
            rate = "0.00";
        tax = "0.00";
        //var tax = document.getElementById("txttax_" + i).value;
        //if (tax == "") {
        //    tax = "0.00";
        //}
        //var total = document.getElementById("spantotal_" + i).innerHTML;
        invoicedetail = invoicedetail + "{'nid':'" + invoicedetailid + "','itemid':'" + taskarr[0] + "','description':'" + description + "','rate':'" + rate + "','tax':'" + tax + "','subtotal':'" + rate + "'";
        if (i == rowcount - 1) {
            invoicedetail = invoicedetail + "}";
        }
        else {
            invoicedetail = invoicedetail + "},";
        }

    }

    invoicedetail = invoicedetail + "]";
    return invoicedetail;
}