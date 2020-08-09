function onlyAlphabets(e, t) {
    try {
        var inputValue = e.which;
        if (!(inputValue >= 65 && inputValue <= 120) && (inputValue != 32 && inputValue != 0 && inputValue != 8)) {
            e.preventDefault();
        }
    }
    catch (err) {
        alert(err.Description);
    }
}

function fixheader() {

    $.getScript("js/colResizable-1.6.js", function () {

        $("#ctl00_ContentPlaceHolder1_dgnews").colResizable({
            liveDrag: true,
            gripInnerHtml: "<div class='grip'></div>",
            draggingClass: "dragging",
            resizeMode: 'fit'
        });

    });



}


var json;
var jsonimport;
var strcol = "", strcolname = "";
var pagename = "Tax_TaxClient.aspx"
$(document).ready(function () {

    //---------
   
});






function fillbytaxyear() {
    if (document.getElementById("ctl00_ContentPlaceHolder1_txttaxyear").value != "" && document.getElementById("ctl00_ContentPlaceHolder1_hidid").value != "") {
        var args = { nid: document.getElementById("ctl00_ContentPlaceHolder1_hidid").value, taxyear: document.getElementById("ctl00_ContentPlaceHolder1_txttaxyear").value, companyid: document.getElementById("hidcompanyid").value };

        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
        $.ajax({

            type: "POST",
            url: pagename + "/getTaxClientbyTaxYear",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            cache: false,
            success: function (data) {

                if (data.d != "failure") {
                    var jsonarr = $.parseJSON(data.d);
                    if (jsonarr.length > 0) {

                        document.getElementById("ctl00_ContentPlaceHolder1_txtfyyear").value = jsonarr[0].yearEndDate;
                        document.getElementById("ctl00_ContentPlaceHolder1_txtduedate").value = jsonarr[0].dueDate;
                        document.getElementById("ctl00_ContentPlaceHolder1_txtrefund").value = jsonarr[0].refund;
                        document.getElementById("ctl00_ContentPlaceHolder1_txtprevaig").value = jsonarr[0].aig;
                        document.getElementById("ctl00_ContentPlaceHolder1_txtlastyear").value = jsonarr[0].taxpaid;
                        document.getElementById("ctl00_ContentPlaceHolder1_txtpretotax").value = jsonarr[0].totaltax;

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

}
function savedata() {
    var status = 1;
    if (document.getElementById("ctl00_ContentPlaceHolder1_txtproject").value == "" ) {
        status = 0;
        document.getElementById("ctl00_ContentPlaceHolder1_txtproject").style.borderColor = "red";
    }
    else {
        document.getElementById("ctl00_ContentPlaceHolder1_txtproject").style.borderColor = "#cdcdcd";

    }
   

    if (document.getElementById("ctl00_ContentPlaceHolder1_txttaxyear").value == "") {
        status = 0;
        document.getElementById("ctl00_ContentPlaceHolder1_txttaxyear").style.borderColor = "red";
    }
    else {
        document.getElementById("ctl00_ContentPlaceHolder1_txttaxyear").style.borderColor = "#cdcdcd";

    }

  


    if (status == 1) {
        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
        var args = {
            nid: $('#ctl00_ContentPlaceHolder1_hidid').val(), name: $('#ctl00_ContentPlaceHolder1_txtproject').val(), address: $('#ctl00_ContentPlaceHolder1_txtaddress').val(),
            city: $('#ctl00_ContentPlaceHolder1_txtcity').val(), state: $('#ctl00_ContentPlaceHolder1_txtstate').val(), zip: $('#ctl00_ContentPlaceHolder1_txtzip').val(),
            phone: $('#ctl00_ContentPlaceHolder1_txtphone').val(), email: $('#ctl00_ContentPlaceHolder1_txtemail').val(), typeid: $('#ctl00_ContentPlaceHolder1_droptype').val(),
            taxtypeID: $('#ctl00_ContentPlaceHolder1_droptaxtype').val(), taxFormID: $('#ctl00_ContentPlaceHolder1_drotaxform').val(), taxYear: $('#ctl00_ContentPlaceHolder1_txttaxyear').val(),
            yearEndDate: $('#ctl00_ContentPlaceHolder1_txtfyyear').val(), dueDate: $('#ctl00_ContentPlaceHolder1_txtduedate').val(), prevaig: $('#ctl00_ContentPlaceHolder1_txtprevaig').val()
            , prevTotalTax: $('#ctl00_ContentPlaceHolder1_txtpretotax').val(), taxpaid: $('#ctl00_ContentPlaceHolder1_txtlastyear').val(), lastYRRefund: $('#ctl00_ContentPlaceHolder1_txtrefund').val(), companyId: $('#hidcompanyid').val()
        }
         $.ajax({

            type: "POST",
            url: pagename + "/savedata",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            cache: false,
            success: function (data) {

                if (data.d != "failure") {
                    var jsonarr = $.parseJSON(data.d);
                    if (jsonarr[0].result =="1") {
                        $('#ctl00_ContentPlaceHolder1_btnsearch').trigger('click');
                        alert("saved successfully");
                        closediv();
                    }
                    else {
                        alert(jsonarr[0].msg);
                    }
                
                }
                else {
                    alert(data.d);
                }

                $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
            },
            error: function (x, e) {
                alert("The call to the server side failed. " + x.responseText);
                $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                return;
            }

        });

    }
    else {
        alert("Please fill required fields!");

    }
}
function blank() {
  
    document.getElementById("ctl00_ContentPlaceHolder1_txtproject").value = "";
    document.getElementById("ctl00_ContentPlaceHolder1_txtaddress").value = "";
    document.getElementById("ctl00_ContentPlaceHolder1_txtproject").value = "";
    document.getElementById("ctl00_ContentPlaceHolder1_txtcity").value = "";
    document.getElementById("ctl00_ContentPlaceHolder1_txtstate").value = "";
    document.getElementById("ctl00_ContentPlaceHolder1_txtzip").value = "";
    document.getElementById("ctl00_ContentPlaceHolder1_txtemail").value = "";
    document.getElementById("ctl00_ContentPlaceHolder1_txtphone").value = "";

    document.getElementById("ctl00_ContentPlaceHolder1_droptaxtype").value = "";
    document.getElementById("ctl00_ContentPlaceHolder1_droptype").value = "";
    document.getElementById("ctl00_ContentPlaceHolder1_txttaxyear").value = "";
    document.getElementById("ctl00_ContentPlaceHolder1_drotaxform").value = "";
    document.getElementById("ctl00_ContentPlaceHolder1_txtfyyear").value = "";
    document.getElementById("ctl00_ContentPlaceHolder1_txtduedate").value = "";
    document.getElementById("ctl00_ContentPlaceHolder1_txtlastyear").value = "";
    document.getElementById("ctl00_ContentPlaceHolder1_txtrefund").value = "";
    document.getElementById("ctl00_ContentPlaceHolder1_hidid").value = "";
    document.getElementById("ctl00_ContentPlaceHolder1_txtprevaig").value = "";
    document.getElementById("ctl00_ContentPlaceHolder1_txtpretotax").value = "";

   
}

function opendiv() {
    setposition("divaddnew");
    $('otherdiv').show();
    $('divaddnew').show(300);

}

function opnsummary() {
    setposition("divimportsummary");

    $('#otherdiv').show();
    $('#divimportsummary').show(300);

}

function saveimport() {
    var table = document.getElementById("tblright");
    var status = 1; strval = "", status1 = 0, status2 = 0;
    strcol = "";
    strcolname = "";
    if (table.rows.length == 0) {
        status = 0;
        alert("Select the fields and associated columns where imported information is located in the excel work sheet!");
        return;
    }
    for (var i = 0, row; row = table.rows[i]; i++) {
        id = row.getAttribute("id").replace("tdcolright", "");
        if ($('#hidcolright' + id).val() == "ClientName")
            status1 = 1;

        if ($('#hidcolright' + id).val() == "TaxYear")
            status2 = 1;

        strcol = strcol + $('#hidcolright' + id).val() + '#';
        strcolname = strcolname + $('#spancolright' + id).html() + '##';
        strval = strval + $('#txtcolright' + id).val() + '#';


    }

    if (status1 == 0) {
        alert("Client Name is Required!");
        return;
    }
    else {
        if (status2 == 0) {
            alert("Tax Year is Required!");
            return;
        }
    }


    if (status == 1 && status1 == 1 && status2 == 1) {
        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
        var args = { path: document.getElementById("ctl00_ContentPlaceHolder1_hidfilename").value, cols: strcol, val: strval, companyid: document.getElementById("hidcompanyid").value };
        $.ajax({

            type: "POST",
            url: pagename + "/importtaxclient",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            cache: false,
            success: function (data) {

                if (data.d == "-1") {

                    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();

                    alert("Imported excel file does not have records!");
                    return;
                    //closediv();
                }
                else {
                    var totalsub = 0, totalsaved = 0; totalerror = 0, totalup = 0;
                     jsonimport = $.parseJSON(data.d);
                    if (jsonimport.length > 0) {
                        totalsub = jsonimport.length;
                        for (var i = 0; i < jsonimport.length; i++) {
                            if (jsonimport[i].status == "0") {
                                totalerror = totalerror + 1;
                            }
                            if (jsonimport[i].status == "1") {
                                totalsaved = totalsaved + 1;
                            }
                            if (jsonimport[i].status == "2") {
                                totalup = totalup + 1;
                            }
                        }

                        $('#tdtotalsub').html('<a onclick="showimportrecord(3);">' + totalsub + '</a>');
                        $('#tdnewrecord').html('<a onclick="showimportrecord(1);">' + totalsaved + '</a>');
                        $('#tdoldrecord').html('<a onclick="showimportrecord(2);">' + totalup + '</a>');
                        $('#tderrorinrecord').html('<a onclick="showimportrecord(0);">' + totalerror + '</a>');
                        closediv();
                        $('#ctl00_ContentPlaceHolder1_btnsearch').trigger('click');
                        opnsummary();
                    }
                    else {
                        alert("Error in Data Import!");
                        return;
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
    else {
        alert("Please fill required fields!");

    }

}
function showimportrecord(type) {
    var str = "";
    if (jsonimport.length > 0) {
        if (type == "0") {
            $('#spandetailtext').html("Error in Records");
        }
        else if (type == "1") {
            $('#spandetailtext').html("New Records Inserted");
        }
        else if (type == "2") {
            $('#spandetailtext').html("Old Records Updated");
        }
        else if (type == "3") {
            $('#spandetailtext').html("Total Submitted Records ");
        }

        var arr = strcol.split('#')
        var arr1 = strcolname.split('##')
        for (var i = 0; i < arr.length; i++) {
            if (arr1[i] != "")
                str += "<th>" + arr1[i] + "</th>";
            //str+""

        }
        if (type == "0")
        {
            str += "<th>Status</th>";
        }
        str = "<tr>" + str + "</tr>";
       
        if (jsonimport.length > 0) {
            for (var j = 0; j < jsonimport.length; j++) {
              

                if (type == "3") {
                    str += "<tr>";
                    for (var i = 0; i < arr.length; i++) {
                        if (arr[i] != "")
                            switch(arr[i])
                            {
                                case "ClientName":
                                    str += "<td>" + jsonimport[j].ClientName + '</td>';
                                    break;
                                case "TaxYear":
                                    str += "<td>" + jsonimport[j].TaxYear + '</td>';
                                    break;
                                case "Address":
                                    str += "<td>" + jsonimport[j].Address + '</td>';
                                    break;
                                case "City":
                                    str += "<td>" + jsonimport[j].City + '</td>';
                                    break;
                                case "State":
                                    str += "<td>" + jsonimport[j].State + '</td>';
                                    break;
                                case "Zip":
                                    str += "<td>" + jsonimport[j].Zip + '</td>';
                                    break;
                                case "Email":
                                    str += "<td>" + jsonimport[j].Email + '</td>';
                                    break;
                                case "Phone":
                                    str += "<td>" + jsonimport[j].Phone + '</td>';
                                    break;
                                case "TaxType":
                                    str += "<td>" + jsonimport[j].TaxType + '</td>';
                                    break;
                                case "Type":
                                    str += "<td>" + jsonimport[j].Type + '</td>';
                                    break;
                                case "TaxForm":
                                    str += "<td>" + jsonimport[j].TaxForm + '</td>';
                                    break;
                                case "FYEnding":
                                    str += "<td>" + jsonimport[j].FYEnding + '</td>';
                                    break;
                                case "DueDate":
                                    str += "<td>" + jsonimport[j].DueDate + '</td>';
                                    break;
                                case "TaxPaid":
                                    str += "<td>" + jsonimport[j].TaxPaid + '</td>';
                                    break;
                                case "Refund":
                                    str += "<td>" + jsonimport[j].Refund + '</td>';
                                    break;
                                case "AIG":
                                    str += "<td>" + jsonimport[j].AIG + '</td>';
                                    break;
                                case "TotalTax":
                                    str += "<td>" + jsonimport[j].TotalTax + '</td>';
                                    break;
                              
                                 


                            }
                          
                    }
                   
                    str += "</tr>";
                }
                else {
                    if (jsonimport[j].status == type) {
                        str += "<tr>";
                        for (var i = 0; i < arr.length; i++) {
                            if (arr[i] != "")
                            {
                                switch (arr[i]) {
                                    case "ClientName":
                                        str += "<td>" + jsonimport[j].ClientName + '</td>';
                                        break;
                                    case "TaxYear":
                                        str += "<td>" + jsonimport[j].TaxYear + '</td>';
                                        break;
                                    case "Address":
                                        str += "<td>" + jsonimport[j].Address + '</td>';
                                        break;
                                    case "City":
                                        str += "<td>" + jsonimport[j].City + '</td>';
                                        break;
                                    case "State":
                                        str += "<td>" + jsonimport[j].State + '</td>';
                                        break;
                                    case "Zip":
                                        str += "<td>" + jsonimport[j].Zip + '</td>';
                                        break;
                                    case "Email":
                                        str += "<td>" + jsonimport[j].Email + '</td>';
                                        break;
                                    case "Phone":
                                        str += "<td>" + jsonimport[j].Phone + '</td>';
                                        break;
                                    case "TaxType":
                                        str += "<td>" + jsonimport[j].TaxType + '</td>';
                                        break;
                                    case "Type":
                                        str += "<td>" + jsonimport[j].Type + '</td>';
                                        break;
                                    case "TaxForm":
                                        str += "<td>" + jsonimport[j].TaxForm + '</td>';
                                        break;
                                    case "FYEnding":
                                        str += "<td>" + jsonimport[j].FYEnding + '</td>';
                                        break;
                                    case "DueDate":
                                        str += "<td>" + jsonimport[j].DueDate + '</td>';
                                        break;
                                    case "TaxPaid":
                                        str += "<td>" + jsonimport[j].TaxPaid + '</td>';
                                        break;
                                    case "Refund":
                                        str += "<td>" + jsonimport[j].Refund + '</td>';
                                        break;
                                    case "AIG":
                                        str += "<td>" + jsonimport[j].AIG + '</td>';
                                        break;
                                    case "TotalTax":
                                        str += "<td>" + jsonimport[j].TotalTax + '</td>';
                                        break;


                                }
                            }

                        }
                        if (type == "0") {
                            str += "<td style='color:red;'>" + jsonimport[j].emsg + '</td>';
                        }
                        str += "</tr>";

                    }

                }

            }
        }
        $('#tblsummarydetail').empty();
        $('#tblsummarydetail').html(str);

        setposition('divimportsummary_detail');
        document.getElementById("otherdivimport").style.display = "block";
        $('#divimportsummary_detail').show();
      
    }
}
function closedivsummary() {
    $('#divimportsummary_detail').hide();
    $('#otherdivimport').hide();
}
function editcompany(nid,taxyear) {
    blank();
    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
    var args = { id: nid, taxyear: taxyear };
    $.ajax({

        type: "POST",
        url: pagename + "/getTaxClientbyNid",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {

            if (data.d != "failure") {
                var jsonarr = $.parseJSON(data.d);
                if (jsonarr.length > 0) {
                 
                    document.getElementById("ctl00_ContentPlaceHolder1_txtproject").value = jsonarr[0].name;
                  
                    document.getElementById("ctl00_ContentPlaceHolder1_droptaxtype").value = jsonarr[0].taxtypeID;
                    document.getElementById("ctl00_ContentPlaceHolder1_droptype").value = jsonarr[0].typeid;
                  
                    document.getElementById("ctl00_ContentPlaceHolder1_drotaxform").value = jsonarr[0].taxFormID;
                 
                    document.getElementById("ctl00_ContentPlaceHolder1_hidid").value = jsonarr[0].nid;
                    document.getElementById("ctl00_ContentPlaceHolder1_txtaddress").value = jsonarr[0].address;
                    document.getElementById("ctl00_ContentPlaceHolder1_txtcity").value = jsonarr[0].city;
                    document.getElementById("ctl00_ContentPlaceHolder1_txtstate").value = jsonarr[0].state;
                    document.getElementById("ctl00_ContentPlaceHolder1_txtzip").value = jsonarr[0].zip;
                    document.getElementById("ctl00_ContentPlaceHolder1_txtemail").value = jsonarr[0].email;
                    document.getElementById("ctl00_ContentPlaceHolder1_txtphone").value = jsonarr[0].phone;

                    document.getElementById("ctl00_ContentPlaceHolder1_txttaxyear").value = jsonarr[0].taxyear;
                    document.getElementById("ctl00_ContentPlaceHolder1_txtfyyear").value = jsonarr[0].yearEndDate;
                    document.getElementById("ctl00_ContentPlaceHolder1_txtduedate").value = jsonarr[0].dueDate;
                    document.getElementById("ctl00_ContentPlaceHolder1_txtrefund").value = jsonarr[0].refund;
                    document.getElementById("ctl00_ContentPlaceHolder1_txtprevaig").value = jsonarr[0].aig;
                    document.getElementById("ctl00_ContentPlaceHolder1_txtlastyear").value = jsonarr[0].taxpaid;
                    document.getElementById("ctl00_ContentPlaceHolder1_txtpretotax").value = jsonarr[0].totaltax;

                 
                    opendiv();
                    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                }
            }


        },
        error: function (x, e) {
            alert("The call to the server side failed. " + x.responseText);
            $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
            return;
        }

    });
}

function openimport() {
    setposition("divimport");
    $('#otherdiv').show();
    $('#divimport').show();
    $('#divselectfile').show();
    $('#divselectcol').hide();
    $('#ctl00_ContentPlaceHolder1_hidfilename').val('');
    $('#hidSelecetedLeft').val('');
    $('#hidSelectedRight').val('');
    document.getElementById("divattachfilename").innerHTML = "";

    
  
}
function AssemblyFileUpload_Started(sender, args) {
    document.getElementById("divuploadstatus").innerHTML = "";
    $('#ctl00_ContentPlaceHolder1_AsyncFileUpload1_ctl02').css("background-color", "none");
    $('#ctl00_ContentPlaceHolder1_AsyncFileUpload1_ctl01').css("background-color", "none");
    $('#ctl00_ContentPlaceHolder1_AsyncFileUpload1_ctl01').css("color", "#000");
    var filename = args.get_fileName();
    var ext = filename.substring(filename.lastIndexOf(".") + 1);
    ext = (String(ext)).toLowerCase();
    if (ext != 'xls' && ext != 'xlsm' && ext != 'xlsx') {
        throw {
            name: "Invalid File Type",
            level: "Error",
            message: "Invalid File Type (.xlsx, .xls, .xlsm)",
            htmlMessage: "Invalid File Type (.xlsx, .xls, .xlsm)"
        }
        return false;
    }
    return true;
}
function uploadComplete(sender, args) {

    document.getElementById("divuploadstatus").innerHTML = "<img src='images/apply_icon.png' />";
    $('#ctl00_ContentPlaceHolder1_AsyncFileUpload1_ctl02').css("background-color", "#4cbb17");
    $('#ctl00_ContentPlaceHolder1_AsyncFileUpload1_ctl01').css("background-color", "#4cbb17");
    $('#ctl00_ContentPlaceHolder1_AsyncFileUpload1_ctl01').css("color", "#ffffff");
    $('#ctl00_ContentPlaceHolder1_hidfilename').val(args.get_fileName());
    $('#divselectfile').hide();
    $('#divselectcol').show();



}



function uploadError(sender) {

    document.getElementById("divuploadstatus").innerHTML = "<img src='images/warning.png' />";
    $('#ctl00_ContentPlaceHolder1_AsyncFileUpload1_ctl02').css("background-color", "red");
    $('#ctl00_ContentPlaceHolder1_AsyncFileUpload1_ctl01').css("background-color", "red");
    $('#ctl00_ContentPlaceHolder1_AsyncFileUpload1_ctl01').css("color", "#ffffff");
}


function showuploadprogress() {
    $('#divattachfilename').html("<img src='images/pleasewait.gif' />&nbsp;uploadng..")
}
function Attachment_openupload(rectype, id) {

    var iframe = document.getElementById("ifuploadfile");
    var args;
    iframe.contentWindow.selectAttachment(args);

}
function AttachClientFileCall(id, filesize, filename, filext) {
    $('#divattachfilename').html(filename);
    $('#ctl00_ContentPlaceHolder1_hidfilename').val(id);

    $('#divselectfile').hide();
    $('#divselectcol').show();
}

function selecttd(type, id) {
    if (type == 0) {
        $('.tblcolleft').removeClass('selectedcell');
        $('#' + id).addClass('selectedcell');
        $('#hidSelecetedLeft').val(id);
    }
    else {
        $('.tblcolright').removeClass('selectedcell');
        $('#' + id).addClass('selectedcell');
        $('#hidSelectedRight').val(id);
    }

}
function nextChar(c) {
    return String.fromCharCode(c.charCodeAt(0) + 1);
}
function move(type) {
    if (type == 'right') {
        if ($('#hidSelecetedLeft').val() != "") {

            var table = document.getElementById("tblright");
            var strval = "A";

            if (table.rows.length > 0) {
                for (var i = 0, row; row = table.rows[i]; i++) {
                    var id = row.getAttribute("id").replace("tdcolright", "");
                    if ($('#txtcolright' + id).val() != "") {
                        var strcurrent = $('#txtcolright' + id).val().toUpperCase();
                        if (strcurrent.charCodeAt(0) >= strval.charCodeAt(0)) {
                            strval = nextChar(strcurrent);
                        }
                    }

                }
            }
            var id = $('#hidSelecetedLeft').val().replace("tdcol", "");

            var innertaxt = $('#spancol' + id).html();

            var hidval = $('#hidcol' + id).val();
            var str = "<tr class='tblcolright' id='tdcolright" + id + "' onclick='selecttd(1,this.id);'><td style='border-right:dotted 1px #e0e0e0;'> <span id='spancolright" + id + "'>" + innertaxt + "</span><input type='hidden' id='hidcolright" + id + "' value='" + hidval + "' /></td><td width='70'><input type='text' id='txtcolright" + id + "' value='" + strval + "' maxlength='1' class='form-control' onkeypress='return onlyAlphabets(event,this);' style='text-transform:uppercase;' /></td></tr>";

            var newid = $('#' + $('#hidSelecetedLeft').val()).next('tr').attr('id');

            $('#' + $('#hidSelecetedLeft').val()).remove();

            $('#tblright').append(str);
            $('#hidSelecetedLeft').val('');
            if (document.getElementById(newid) != null)
                selecttd(0, newid);
        }
    }
    else {
        if ($('#hidSelectedRight').val() != "") {
            var id = $('#hidSelectedRight').val().replace("tdcolright", "");
            var innertaxt = $('#spancolright' + id).html();
            var hidval = $('#hidcolright' + id).val();
            var str = "<tr class='tblcolleft' id='tdcol" + id + "' onclick='selecttd(0,this.id);'><td> <span id='spancol" + id + "'>" + innertaxt + "</span><input type='hidden' id='hidcol" + id + "' value='" + hidval + "' /></td></tr>";
            $('#' + $('#hidSelectedRight').val()).remove();
            $('#tblleft').append(str);

            $('#hidSelectedRight').val('');
        }
    }

}