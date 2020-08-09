var pagename = "ManageEmployee.aspx";
var flag = 0;
var hidid = "", hidarressid = "", hidrateid = "";
var hidInTypeRoNum = '', hidTypeLocId = '';


function blank() {
    hidid = ""; hidarressid = ""; hidrateid = "";
    $("#divtitle").html('Add New Employee');
    $(".tabContents").hide();
    $("#btndelete").hide();
    $("#lnktab1detail").show();
    $(".tabContaier ul li a").removeClass("active"); // Remove pre-highlighted link
    $("#lnktab1").addClass("active"); // set clicked link to highlight state
    $("#txtjoin").val('');
    $("#txtempid").val('');
    $("#txtpassword").val('');
    $("#txtfname").val('');
    $("#txtlname").val('');
    $("#txtenrollno").val('');
    $("#txtdob").val('');
    $("#dropdepartment").val('');
    $("#dropdesignation").val('');
    $("#dropbranch").val('1');
    $("#droptimezone").val('1');
    $("#dropmanager").val('');
    $("#dropsubmitto").val('');
    $("#txtcompanyemail").val('');
    $("#dropactive").val('Active');

    $("#txtrelived").val('');
    $('#txtrelived').attr('disabled', false);
    $("#droplogintype").val('User');
    $('#dropRoleGroup').attr('disabled', false);
    $('#dropRoleGroup').val('');

    $("#txttitle").val('');
    $("#txtstreet").val('');
    $("#txtstate").val('');
    $("#txtcity").val('');
    $("#txtzip").val('');
    $("#txtemail").val('');
    $("#txtcell").val('');
    $("#txtphone").val('');
    $("#txtfax").val('');
    $("#txtremark").val('');

    $("#txtbillrate").val('');
    $("#txtpayrate").val('');
    $("#txtoverhead").val('');
    $("#txtovertimebill").val('');
    $("#txtovertimepayrate").val('');
    $("#txtsalary").val('');



}

function opendiv() {
    setposition("divaddnew");
    document.getElementById("divaddnew").style.display = "block";
    document.getElementById("otherdiv").style.display = "block";


}
function closediv() {

    document.getElementById("divaddnew").style.display = "none";
    document.getElementById("otherdiv").style.display = "none";
    document.getElementById("divaddInformation").style.display = "none";
    document.getElementById("otherdiv_inftype").style.display = "none";

}
function closerolergoup() {
    $('#divaddInformation').hide();
    $('#otherdiv_inftype').hide();
    $('#divaddrole').hide();
}
function opentype(id, selval) {
    if (selval == "add") {
        hidInTypeRoNum = '';
        hidTypeLocId = id;
        if (id == "dept") {
            $('#headInfomationType').html('Add  Department');
            $('#thtypehead').html('Departments');
            filldepartment('tbl');
        }
        else {
            $('#headInfomationType').html('Add  Designation');
            $('#thtypehead').html('Designations');
            filldesignation('tbl');
        }
    }




}

function openrolegroup(selval) {
    if (selval == "add") {
        $("#txtmasterrolename").val("");


        $('#divrolebox input[name="chkrole"]').each(function () {
            this.checked = false;
        });



        setposition('divaddrole');
        $('#divaddrole').show();
        $('#otherdiv_inftype').show();
    }
}
function bintabcontainerevent() {


    $(".tabContaier ul li a").click(function () { //Fire the click event

        var activeTab = $(this).attr("id"); // Catch the click link             
        $(".tabContaier ul li a").removeClass("active"); // Remove pre-highlighted link
        $(this).addClass("active"); // set clicked link to highlight state
        $(".tabContents").hide(); // hide currently visible tab content div
        $("#" + activeTab + "detail").fadeIn(); // show the target tab content div by matching clicked link.

        return false; //prevent page scrolling on tab click
    });

}
function fillcurrency() {
    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
    flag = flag + 1;
    var str = '<option value="">--Select One--</option>';
    var args = {};
    $.ajax({

        type: "POST",
        url: pagename + "/getCurrency",
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
                for (var i = 0; i < json.length; i++) {

                    str += '<option value="' + json[i].nid + '">' + json[i].currencyName + '</option>';



                }
                $('#dropcurrency').append(str);
                flag = flag - 1;
                if (flag == 0)
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

function filldepartment(typectrl) {

    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
    if (typectrl == "drop") {
        $('#dropdepartment').empty();
        $('#dropsearchdept').empty();

    }
    else {
        $("#tblinftype tbody").empty();
    }
    flag = flag + 1;
    var str = '';
    var args = { companyid: $("#hidcompanyid").val() };
    $.ajax({

        type: "POST",
        url: pagename + "/getDepartment",
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
                for (var i = 0; i < json.length; i++) {
                    if (typectrl == "drop") {
                        str += '<option value="' + json[i].nid + '">' + json[i].department + '</option>';
                    }

                    else {
                        addnewTyperow();
                        $('#txtinftype' + hidInTypeRoNum).val(json[i].department);
                        $('#hidInsType_id' + hidInTypeRoNum).val(json[i].nid);
                    }


                }
                if (typectrl == "drop") {

                    $('#dropdepartment').append('<option value="">--Select One--</option>' + str);
                    $('#dropdepartment').append('<option value="add">--Add New--</option>');
                    $('#dropsearchdept').append('<option value="">--All--</option>' + str);

                }
                else {
                    setposition("divaddInformation");
                    document.getElementById("divaddInformation").style.display = "block";
                    document.getElementById("otherdiv_inftype").style.display = "block";
                }


                flag = flag - 1;
                if (flag == 0)
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

function filldesignation(typectrl) {
    if (typectrl == "drop") {
        $('#dropdesignation').empty();

    }
    else {
        $("#tblinftype tbody").empty();
    }
    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
    flag = flag + 1;
    var str = '';
    var args = { companyid: $("#hidcompanyid").val() };
    $.ajax({

        type: "POST",
        url: pagename + "/getDesignation",
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
                for (var i = 0; i < json.length; i++) {



                    if (typectrl == "drop") {
                        str += '<option value="' + json[i].nid + '">' + json[i].designation + '</option>';
                    }

                    else {
                        addnewTyperow();
                        $('#txtinftype' + hidInTypeRoNum).val(json[i].designation);
                        $('#hidInsType_id' + hidInTypeRoNum).val(json[i].nid);
                    }

                }
                if (typectrl == "drop") {

                    $('#dropdesignation').append('<option value="">--Select One--</option>' + str);
                    $('#dropdesignation').append('<option value="add">--Add New--</option>');
                }
                else {
                    setposition("divaddInformation");
                    document.getElementById("divaddInformation").style.display = "block";
                    document.getElementById("otherdiv_inftype").style.display = "block";
                }

                flag = flag - 1;
                if (flag == 0)
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
function addnewTyperow() {
    var i = 0;
    if (hidInTypeRoNum != "") {
        i = parseInt(hidInTypeRoNum) + 1;

    }
    var str = '';

    str = str + '<tr id="trinftype_' + i + '"> ';
    str = str + '<td><input type="text"  id="txtinftype' + i + '"  class="form-control"  /></td>';
    str += '<td align="center" width="50px">';
    str = str + '<div id="divdel' + i + '"><a><img src="images/delete.png" onclick="deleteInfType(' + i + ');"  /></a></div>';
    str = str + '<input type="hidden" id="hidInsType_id' + i + '" value="" /></td> </tr>';

    var el = $(str);
    $('#tblinftype > tbody:last').append(el);
    hidInTypeRoNum = (String)(i);

}

function deleteInfType(id) {
    var newid = document.getElementById("hidInsType_id" + id).value;
    if (newid != "") {
        if (confirm('Do you want to delete this record?')) {

            var args = { companyid: $("#hidcompanyid").val(), locid: hidTypeLocId, nid: newid };
            $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
            $.ajax({

                type: "POST",
                url: pagename + "/DeleteType",
                data: JSON.stringify(args),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                cache: false,
                success: function (data) {

                    if (data.d != "failure") {
                        var jsonarr = $.parseJSON(data.d);
                        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                        if (jsonarr.length > 0) {
                            if (jsonarr[0].result == "1") {
                                if (hidTypeLocId == "desig") {
                                    filldesignation("drop");

                                }
                                else {
                                    filldesignation("drop");

                                }

                                $('#trinftype_' + id).remove();

                            }
                            else {

                                alert(jsonarr[0].msg);
                            }
                            $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();

                        }

                    }
                    else {
                        location.href = "dashboard.aspx";
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
    else {
        $('#trinftype_' + id).remove();
    }


}
function saveInfomationType() {
    var status = 1;
    var newid = '', title = '', nid = '';
    var table = $("#tblinftype tbody");
    table.find('tr').each(function (i, el) {

        var id = $(this).attr('id');
        id = id.replace("trinftype_", "");

        newid = "txtinftype" + id;

        if (document.getElementById(newid).value == '') {
            document.getElementById(newid).style.borderColor = "red";
            status = 0;
        }
        else {
            document.getElementById(newid).style.borderColor = "#dadada";
            title = title + document.getElementById(newid).value + "#";
        }

        newid = "hidInsType_id" + id;
        nid = nid + document.getElementById(newid).value + "#";

    });
    if (status == 1) {


        var args = {
            companyid: $("#hidcompanyid").val(), typeid: hidTypeLocId, typetitle: title,
            nid: nid
        };


        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();

        $.ajax({

            type: "POST",
            url: pagename + "/SaveType",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            cache: false,
            success: function (data) {

                if (data.d != "failure") {
                    var jsonarr = $.parseJSON(data.d);

                    if (jsonarr.length > 0) {

                        if (jsonarr[0].result == "1") {

                            $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                            closerolergoup();
                            if (hidTypeLocId == "desig") {
                                filldesignation("drop");

                            }
                            else {
                                filldepartment("drop");

                            }

                        }
                        else {
                            alert(jsonarr[0].msg);
                            $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                        }
                    }
                    else {
                        alert("The call to the server side failed. ");

                    }


                }
                else {
                    alert(data.d);
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
function fillroles(rolegroupId) {
    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
    $('#dropmasterrole').empty();
    $('#dropRoleGroup').empty();
    flag = flag + 1;
    var str = '';
    var args = { companyid: $("#hidcompanyid").val(), nid: "" };
    $.ajax({

        type: "POST",
        url: pagename + "/getRoleGroup",
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
                for (var i = 0; i < json.length; i++) {
                    str += '<option value="' + json[i].nid + '">' + json[i].rolename + '</option>';
                }
                
                $('#dropmasterrole').append("<option value=''>Add New</option>" + str);
                $('#dropRoleGroup').append("<option value=''>Select one</option>" + str);
                $('#dropRoleGroup').append("<option value='add'>--Add New-- </option>");
                if (rolegroupId != undefined && rolegroupId != null)
                    $('#dropRoleGroup').val(rolegroupId);

                flag = flag - 1;
                if (flag == 0)
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


function MasterGetAllRoleHTML() {
    var args = {};
    flag = flag + 1;
    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
    $.ajax({

        type: "POST",
        url: pagename + "/getRoleHTML",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        cache: false,
        success: function (data) {
            //Check length of returned data, if it is less than 0 it means there is some status available
            if (data.d != "failure") {

                $("#divrolebox").append(data.d);


                flag = flag - 1;

                if (flag == 0) {
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
function fillbranch() {
    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
    flag = flag + 1;
    var str = '';
    var args = { companyid: $("#hidcompanyid").val() };
    $.ajax({

        type: "POST",
        url: pagename + "/getBranch",
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
                for (var i = 0; i < json.length; i++) {

                    str += '<option value="' + json[i].nid + '">' + json[i].branchname + '</option>';



                }
                $('#dropbranch').append(str);
                $('#dropbranch').val('1')
                flag = flag - 1;
                if (flag == 0)
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
function filltimezone() {
    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
    flag = flag + 1;
    var str = '';//'<option value="">--Select One--</option>';
    var args = {};
    $.ajax({

        type: "POST",
        url: pagename + "/getTimeZone",
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
                for (var i = 0; i < json.length; i++) {

                    str += '<option value="' + json[i].nid + '">' + json[i].displayname + '</option>';



                }
                $('#droptimezone').append(str);
                $('#droptimezone').val('1')
                flag = flag - 1;
                if (flag == 0)
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

function fillManager() {
    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
    flag = flag + 1;
    var str = '';
    var args = { companyid: $("#hidcompanyid").val() };
    $.ajax({

        type: "POST",
        url: pagename + "/getManager",
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
                for (var i = 0; i < json.length; i++) {

                    str += '<option value="' + json[i].nid + '">' + json[i].username + '</option>';



                }
                $('#dropmanager').append('<option value="">--Select One--</option>' + str);
                $('#dropsubmitto').append('<option value="">--Select One--</option>' + str);

                flag = flag - 1;
                if (flag == 0)
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
function getRoleDetail() {
    $("#txtmasterrolename").val("");


    $('#divrolebox input[name="chkrole"]').each(function () {
        this.checked = false;
    });

    if ($("#dropmasterrole").val() != "") {
        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();



        var args = { companyid: $("#hidcompanyid").val(), nid: $("#dropmasterrole").val() };
        $.ajax({

            type: "POST",
            url: pagename + "/getRoleGroup",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            cache: false,
            success: function (data) {
                //Check length of returned data, if it is less than 0 it means there is some status available
                if (data.d != "failure") {
                    json = $.parseJSON(data.d);
                    var arr = json[0].Roles.split("#");
                    $("#txtmasterrolename").val(json[0].rolename);
                    //Call project autocompleter
                    for (var i = 0; i < arr.length; i++) {

                        $('#divrolebox').find("input").each(function () {
                            if ($(this).val() == arr[i])
                                this.checked = true;
                        });



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

function masterSaveRoleGroup() {
    
    var status = 1, roleid = "", rolecheck = 0; rolegroupId = 0;
    if (document.getElementById('txtmasterrolename').value == '') {
        document.getElementById('txtmasterrolename').style.borderColor = "red";
        status = 0;
    }
    else {
        document.getElementById('txtmasterrolename').style.borderColor = "#cdcdcd";
    }
    $('#divrolebox input[name="chkrole"]').each(function () {
        if (this.checked)
            roleid = roleid + $(this).val() + "#";
        rolecheck = 1;
    });

    if (rolecheck == 0) {
        alert("Select roles for a Role Group!");

        return;
    }
    if (status == 1) {
        var args = { nid: $('#dropmasterrole').val(), rolename: $('#txtmasterrolename').val(), roleid: roleid, companyid: $('#hidcompanyid').val() };
        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
        $.ajax({

            type: "POST",
            url: pagename + "/saverolegroup",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            cache: false,
            success: function (data) {

                if (data.d != "failure") {
                    


                    if (data.d != "") {
                        rolegroupId = data.d;
                        flag = 0;
                        fillroles(rolegroupId);
                        closerolergoup();

                    }
                    else {

                        alert(data.d);
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
}

function filldata() {

    var str = "";
    $("#tbldata tbody").empty();
    var args = { nid: "", companyid: $('#hidcompanyid').val() };
    $('#divdataloader').show();
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


                    $.each(jsonarr, function (i, item) {

                        str = str + '<tr>';
                        str = str + '<td>' + item.loginId + '</td>';
                        str = str + '<td>' + item.username + '</td>';
                        str = str + '<td>' + item.branchname + '</td>';
                        str = str + '<td>' + item.department + '</td>';
                        str = str + '<td>' + item.designation + '</td>';
                        str = str + '<td style="text-align: center;">' + item.joinDate + '</td><td style="text-align: center;">' + item.activeStatus + '</td>';

                        str = str + '<td style="text-align:center;">  <a class="linkedit" id="linkedit' + item.nid + '"  title="Modify Details"><img src="images/edit.png" /></a></td><td style="text-align:center;"><a class="linkdelete" id="linkdelete' + item.nid + '"  title="Delete this record"><img src="images/delete.png" /></a></td> </tr>';


                    });

                }

                $("#tbldata tbody").append(str);
                fn_MasterFixheader1("tbldata", [-2, -1]);
                $('#divdataloader').hide();

                $(".linkedit").click(function () {
                    var newid = $(this).attr("id");
                    newid = newid.replace("linkedit", "");
                    getdetail(newid);
                });
                $(".linkdelete").click(function () {
                    var newid = $(this).attr("id");
                    newid = newid.replace("linkdelete", "");
                    deleterecord(newid);
                });

            }


        },
        error: function (x, e) {
            alert("The call to the server side failed. " + x.responseText);
            $('#divdataloader').hide();
            return;
        }

    });



}


function exportExcel() {

    var str = "<table id='tmptbl'> <thead>";

    var args = { nid: "", companyid: $('#hidcompanyid').val() };
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

                    str = str + '<tr><th>Emp ID</th><th>First Name</th><th>Last Name</th><th>Branch</th><th>Department</th><th>Designation</th><th>Join Date</th><th>Release Date</th>\
                        <th>DOB</th><th>Email ID</th><th>Status</th></tr></thead><tbody>';
                    $.each(jsonarr, function (i, item) {

                        str = str + '<tr>';
                        str = str + '<td>' + item.loginId + '</td>';
                        str = str + '<td>' + item.fName + '</td>';
                        str = str + '<td>' + item.lName + '</td>';
                        str = str + '<td>' + item.branchname + '</td>';
                        str = str + '<td>' + item.department + '</td>';
                        str = str + '<td>' + item.designation + '</td><td style="text-align: center;">' + item.joinDate + '</td>';
                        str = str + '<td style="text-align: center;">' + item.releasedDate + '</td><td style="text-align: center;">' + item.dob + '</td><td>' + item.emailid + '</td><td style="text-align: center;">' + item.activeStatus + '</td>';

                        str = str + '</tr>';


                    });

                    str = str + '</tbody></table>';
                    var el = $(str);
                    $("#temptbl").empty();
                    $("#temptbl").html(str);
                    $("#tmptbl").table2excel({
                        name: "Employees",
                        filename: "Employees"

                    });

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

function deleterecord(id) {
    if (confirm("Do you want to delete this record?")) {
        var args = { companyid: $('#hidcompanyid').val(), nid: id };
        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
        $.ajax({

            type: "POST",
            url: pagename + "/deletedata",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            cache: false,
            success: function (data) {

                if (data.d != "failure") {
                    var jsonarr = $.parseJSON(data.d);
                    $('#ContentPlaceHolder1_progress1_UpdateProg1').hide();
                    if (jsonarr.length > 0) {
                        if (jsonarr[0].result == "1") {


                            $('#tbldata').DataTable().destroy();
                            closediv();
                            filldata();

                            alert("Record deleted successfully!");
                        }
                        else {

                            alert(jsonarr[0].msg);
                        }
                        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                    }

                }
                else {
                    location.href = "logout.aspx";
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
function getdetail(id) {
    
    var args = { nid: id, companyid: $('#hidcompanyid').val() };
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
                var arr = String(data.d).split("##{}##");
                var jsonarr = $.parseJSON(arr[0]);

                if (jsonarr.length > 0) {
                    blank();
                    hidid = id;



                    $("#divtitle").html('Modify Employee');

                    $("#txtempid").val(jsonarr[0].loginId);
                    $("#txtpassword").val(jsonarr[0].password);
                    $("#txtfname").val(jsonarr[0].fName);
                    $("#txtlname").val(jsonarr[0].lName);
                    $("#txtenrollno").val(jsonarr[0].enrollno);
                    $("#txtdob").val(jsonarr[0].dob);
                    $("#dropdepartment").val(jsonarr[0].deptId);
                    $("#dropdesignation").val(jsonarr[0].desigId);
                    $("#dropbranch").val(jsonarr[0].BranchType);
                    $("#droptimezone").val(jsonarr[0].timezone);
                    $("#dropmanager").val(jsonarr[0].managerid);
                    $("#dropsubmitto").val(jsonarr[0].submitTo);
                    $("#txtcompanyemail").val(jsonarr[0].emailid);
                    $("#dropactive").val(jsonarr[0].activeStatus);
                    $("#txtjoin").val(jsonarr[0].joinDate);
                    $("#txtrelived").val(jsonarr[0].releasedDate);
                    $("#droplogintype").val(jsonarr[0].userType);
                    $("#dropRoleGroup").val(jsonarr[0].roles);


                    $("#chekappointment").prop("checked", jsonarr[0].appointment)


                    if (jsonarr[0].userType == "Admin")
                        $('#dropRoleGroup').attr('disabled', true);
                    if (arr[1] != "") {
                        var jsonarr1 = $.parseJSON(arr[1]);
                        if (jsonarr1.length > 0) {
                            hidarressid = jsonarr1[0].nid
                            $("#txttitle").val(jsonarr1[0].name);
                            $("#txtstreet").val(jsonarr1[0].street);
                            $("#txtstate").val(jsonarr1[0].state);
                            $("#txtcity").val(jsonarr1[0].city);
                            $("#txtzip").val(jsonarr1[0].zip);
                            $("#txtemail").val(jsonarr1[0].email);
                            $("#txtcell").val(jsonarr1[0].mobile);
                            $("#txtphone").val(jsonarr1[0].phone);
                            $("#txtfax").val(jsonarr1[0].fax);
                            $("#txtremark").val(jsonarr1[0].remark);
                        }

                    }

                    if (arr[2] != "") {
                        var jsonarr1 = $.parseJSON(arr[2]);
                        if (jsonarr1.length > 0) {
                            hidrateid = jsonarr1[0].nid;
                            $("#txtbillrate").val(jsonarr1[0].billrate);
                            $("#txtpayrate").val(jsonarr1[0].payrate);
                            $("#txtoverhead").val(jsonarr1[0].overheadMulti);
                            $("#txtovertimebill").val(jsonarr1[0].overtimeBillRate);
                            $("#txtovertimepayrate").val(jsonarr1[0].overtimePayrate);
                            $("#txtsalary").val(jsonarr1[0].salaryAmount);
                            $("#dropcurrency").val(jsonarr1[0].currencyId);
                        }

                    }




                    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();

                    opendiv();

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
function validateform() {

    var status = 1;
    var chkstatus = 0;
    if (document.getElementById('txtempid').value == '') {
        document.getElementById('txtempid').style.borderColor = "red";
        status = 0;
    }
    else {
        document.getElementById('txtempid').style.borderColor = "#dadada";
    }
    if (document.getElementById('txtpassword').value == '') {
        document.getElementById('txtpassword').style.borderColor = "red";
        status = 0;
    }
    else {
        document.getElementById('txtpassword').style.borderColor = "#dadada";
    }
    if (document.getElementById('txtfname').value == '') {
        document.getElementById('txtfname').style.borderColor = "red";
        status = 0;
    }
    else {
        document.getElementById('txtfname').style.borderColor = "#dadada";
    }

    if (document.getElementById('txtlname').value == '') {
        document.getElementById('txtlname').style.borderColor = "red";
        status = 0;
    }
    else {
        document.getElementById('txtlname').style.borderColor = "#dadada";
    }

    if (document.getElementById('dropbranch').value == '') {
        document.getElementById('dropbranch').style.borderColor = "red";
        status = 0;
    }
    else {
        document.getElementById('dropbranch').style.borderColor = "#dadada";
    }


    if (document.getElementById('txtenrollno').value == '') {
        document.getElementById('txtenrollno').style.borderColor = "red";
        status = 0;
    }
    else {
        document.getElementById('txtenrollno').style.borderColor = "#dadada";
    }

    if (document.getElementById('dropdepartment').value == '') {
        document.getElementById('dropdepartment').style.borderColor = "red";
        status = 0;
    }
    else {
        document.getElementById('dropdepartment').style.borderColor = "#dadada";
    }
    if (document.getElementById('dropdesignation').value == '') {
        document.getElementById('dropdesignation').style.borderColor = "red";
        status = 0;
    }
    else {
        document.getElementById('dropdesignation').style.borderColor = "#dadada";
    }

    if (document.getElementById('dropmanager').value == '') {
        document.getElementById('dropmanager').style.borderColor = "red";
        status = 0;
    }
    else {
        document.getElementById('dropmanager').style.borderColor = "#dadada";
    }


    if (document.getElementById('droptimezone').value == '') {
        document.getElementById('droptimezone').style.borderColor = "red";
        status = 0;
    }
    else {
        document.getElementById('droptimezone').style.borderColor = "#dadada";
    }
    if (document.getElementById('txtjoin').value == '') {
        document.getElementById('txtjoin').style.borderColor = "red";
        status = 0;
    }
    else {
        document.getElementById('txtjoin').style.borderColor = "#dadada";
    }


    if (document.getElementById('txtcompanyemail').value == '') {
        document.getElementById('txtcompanyemail').style.borderColor = "red";
        status = 0;
    }
    else {
        if (CheckEmail(document.getElementById('txtcompanyemail').value)) {
            document.getElementById('txtcompanyemail').style.borderColor = "#dadada";
        }
        else {
            document.getElementById('txtcompanyemail').style.borderColor = "red";
            status = 0;
        }

    }




    if (document.getElementById('dropactive').value == '') {
        document.getElementById('dropactive').style.borderColor = "red";
        status = 0;
    }
    else {
        document.getElementById('dropactive').style.borderColor = "#dadada";
    }

    if (document.getElementById('droplogintype').value == '') {
        document.getElementById('droplogintype').style.borderColor = "red";
        status = 0;
    }
    else {
        document.getElementById('droplogintype').style.borderColor = "#dadada";
    }




    if (document.getElementById('droplogintype').value == 'User') {

        if (document.getElementById('dropRoleGroup').value == '' || document.getElementById('dropRoleGroup').value == 'add') {
            document.getElementById('dropRoleGroup').style.borderColor = "red";
            status = 0;
        }
        else {
            document.getElementById('dropRoleGroup').style.borderColor = "#dadada";
        }

    }


    if (status == 0) {
        return false;
    }
    else {
        return true;
    }

}

function save() {


    if (validateform()) {

        var appmt = '0'
        if ($("#chekappointment").prop("checked") == true) {
            appmt = '1'
        }

        var args = {
            id: hidid, companyid: $("#hidcompanyid").val(), loginid: $("#txtempid").val(), enrollno: $("#txtenrollno").val(), fname: $("#txtfname").val(),
            lname: $("#txtlname").val(), password: $("#txtpassword").val(), usertype: $("#droplogintype").val(), roles: $("#dropRoleGroup").val(), managerid: $("#dropmanager").val(),
            submitto: $("#dropsubmitto").val(), deptid: $("#dropdepartment").val(), desigid: $("#dropdesignation").val(), joindate: $("#txtjoin").val(), releaseddate: $("#txtrelived").val(),
            createdby: $("#hidchatloginid").val(), activestatus: $("#dropactive").val(), email: $("#txtcompanyemail").val(), imgurl: $("#dropbranch").val(), timezone: $("#droptimezone").val(),
            dob: $("#txtdob").val(), hidaddress: hidarressid, name: $("#txttitle").val(),
            street: $("#txtstreet").val(), city: $("#txtcity").val(), state: $("#txtstate").val(), country: "", zip: $("#txtzip").val(),
            addressemail: $("#txtemail").val(), phone: $("#txtphone").val(), mobile: $("#txtcell").val(), fax: $("#txtfax").val(), remark: $("#txtremark").val(),
            hidrate: hidrateid, billrate: $("#txtbillrate").val(), payrate: $("#txtpayrate").val(), overtimeBillRate: $("#txtovertimebill").val(),
            overtimePayrate: $("#txtovertimepayrate").val(), currencyId: $("#dropcurrency").val(), overheadMulti: $("#txtoverhead").val(),
            salaryAmount: $("#txtsalary").val(),
            appointment: appmt

        };


        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();

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

                    if (jsonarr.length > 0) {

                        if (jsonarr[0].result == "1") {

                            $('#tbldata').DataTable().destroy();
                            $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                            closediv();
                            filldata();
                            alert('Saved Successfully!')
                        }
                        else {
                            $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                            alert(jsonarr[0].msg);
                        }
                    }
                    else {
                        alert("The call to the server side failed. ");

                    }


                }
                else {
                    $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                    alert(data.d);

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
        alert('Please fill required fields!');
        return;
    }
}
$(document).ready(function () {

    fillcurrency();
    filldepartment("drop");
    filldesignation("drop");
    fillroles();
    MasterGetAllRoleHTML();
    fillbranch();
    filltimezone();
    fillManager();
    filldata();

    $("#txtjoin").datepicker();
    $("#txtrelived").datepicker({
        maxDate: 0
    });
    $("#txtdob").datepicker({
        changeMonth: true,
        changeYear: true
    });

    $(".hasDatepicker").change(function () {
        checkdate($(this).val(), $(this).attr("id"));
    });
    $("#dropmasterrole").change(function () {
        getRoleDetail();
    });
    $("#droplogintype").change(function () {
        if ($("#droplogintype").val() == "Admin") {
            $('#dropRoleGroup').attr('disabled', true);
        }
        else {
            $('#dropRoleGroup').attr('disabled', false);
        }
    });

    $("#txtsearch").keyup(function () {

        fn_MasterSearchDataTable($(this).val(), "tbldata", "");
    });
    $("#txtsearch").keypress(function () {

        fn_MasterSearchDataTable($(this).val(), "tbldata", "");
    });

    $("#dropsearchdept").change(function () {
        if ($("#dropsearchdept").val() == "")
            fn_MasterSearchDataTable("", "tbldata", 3);
        else {
            fn_MasterSearchDataTable($("#dropsearchdept option:selected").text(), "tbldata", 3);
        }
    });
    $("#drostatus").change(function () {
        if ($("#drostatus").val() == "")
            fn_MasterSearchDataTable("", "tbldata", 6);
        else
            fn_MasterSearchDataTable($("#drostatus option:selected").text(), "tbldata", 6);
    });

    $(".tabContents").hide();
    $("#lnktab1detail").show();
    bintabcontainerevent();


    $("#btnsaveRole").click(function () {
        masterSaveRoleGroup();

    });
    $("#btnsaveRole1").click(function () {
        masterSaveRoleGroup();

    });
    $("#liaddnew").click(function () {
        blank();
        opendiv();

    });
    $("#btnSaveInformation").click(function () {
        saveInfomationType();

    });
    $("#btnsubmit").click(function () {
        save();

    });
    $("#btndelete").click(function () {
        deleterecord(hidid);

    });

    $("#btnexportcsv").click(function () {
        exportExcel();

    });




});

function fn_MasterFixheader1(tblid, target) {

    $.getScript("js/colResizable-1.6.js", function () {

        //$("#" + tblid).colResizable({
        //    liveDrag: true,
        //    gripInnerHtml: "<div class='grip'></div>",
        //    draggingClass: "dragging",
        //    resizeMode: 'fit',

        //});

        $('#' + tblid).dataTable({
            "dom": 'lrtip',

            "bPaginate": false,
            'aoColumnDefs': [{
                'bSortable': false,
                "bPaginate": false,
                'aTargets': target/* 1st one, start by the right */
            }]
        });

    });


}