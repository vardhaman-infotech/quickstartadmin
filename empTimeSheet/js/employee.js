
function showpassword() {
    $('#viewpass').toggle();
    $('#divpassword').toggle();

}


function addrow() {
    var table = document.getElementById("tbldata");
    var id = parseInt(document.getElementById("ctl00_ContentPlaceHolder1_hidrowno").value);
    var sno = parseInt(document.getElementById("ctl00_ContentPlaceHolder1_hidsno").value);

    if (id == -1) {
        table.style.display = "table";
        document.getElementById("ctl00_ContentPlaceHolder1_hidrowno").value = "0";
    }
    else {
        sno = sno + 1
        var newsno = id + 1;

        var row = table.insertRow(newsno);


        if (id >= 0)
            document.getElementById("divdel" + id).innerHTML = "";

        var celltitle = row.insertCell(0);
        var cellamount = row.insertCell(1);



        celltitle.innerHTML = " <input type='text' id='txtothertitle" + newsno + "' class='form-control' style='width:120px;' />";

        cellamount.innerHTML = " <input type='text' id='txtotheramount" + newsno + "' class='form-control f_left' style='width:86% !important;' placeholder='0.00' onkeypress='blockNonNumbers(this, event, true, false);' onchange='calculatebasic();'  onkeyup='extractNumber(this,2,false);' />"
         + "<div id='divdel" + newsno + "' style='padding-top: 2px;padding-left:3px;float:left;'><a style='cursor: pointer;color:bule;' id='delete' onclick='deleterow(this.id);' ><img src='images/delete.png' /></a></div>";



        document.getElementById("ctl00_ContentPlaceHolder1_hidrowno").value = newsno;
        document.getElementById("ctl00_ContentPlaceHolder1_hidsno").value = sno;



    }

}


//Delete rows
function deleterow() {

    var table = document.getElementById("tbldata");
    var id = parseInt(document.getElementById("ctl00_ContentPlaceHolder1_hidrowno").value);
    var sno = parseInt(document.getElementById("ctl00_ContentPlaceHolder1_hidsno").value);
    sno = sno - 1
    var newsno = id - 1;
    //table.deleteRow(id);
    //if (newsno != "1")
    // document.getElementById("divdel" + newsno).innerHTML = "<a style='cursor: pointer;color:bule;' id='delete' onclick='deleterow(this.id);' ><img src='images/delete_icon.png' /></a>";
    document.getElementById("ctl00_ContentPlaceHolder1_hidrowno").value = newsno;
    document.getElementById("ctl00_ContentPlaceHolder1_hidsno").value = sno;
    if (parseInt(id) >= 1) {
        table.deleteRow(id);
    }
    else {

        document.getElementById("txtothertitle" + id).value = "";
        document.getElementById("txtotheramount" + id).value = "";
        table.style.display = "none";
    }

    if (parseInt(newsno) >= 0) {
        document.getElementById("divdel" + newsno).innerHTML = "<a style='cursor: pointer;color:bule;' id='delete' onclick='deleterow(this.id);' ><img src='images/delete.png' /></a>";
    }
    calculatebasic();
    calculatededcution();
}

//Bind entered time info to hidden field after validate the entries
function getinfo() {
    var newid = "", otherTitle = "", otherAmount = "";
    var id = parseInt(document.getElementById("ctl00_ContentPlaceHolder1_hidrowno").value);

    for (var i = 0; i <= id; i++) {

        newid = "txtothertitle" + i;

        otherTitle = otherTitle + "###" + document.getElementById(newid).value;

        newid = "txtotheramount" + i;

        otherAmount = otherAmount + "###" + document.getElementById(newid).value;

    }
    document.getElementById("ctl00_ContentPlaceHolder1_hidOtherTitle").value = otherTitle;
    document.getElementById("ctl00_ContentPlaceHolder1_hidOtherAmount").value = otherAmount;
    getinfo1();
}

function fixheader() {

   $.getScript("js/colResizable-1.6.js", function () {
              
                $("#ctl00_ContentPlaceHolder1_dgnews").colResizable({
                    liveDrag: true,
                    gripInnerHtml: "<div class='grip'></div>",
                    draggingClass: "dragging",
                    resizeMode: 'fit'
                });

                $('#ctl00_ContentPlaceHolder1_dgnews').dataTable({
                    "dom": 'lrtip',
                    "pageLength": 50,
                    'aoColumnDefs': [{
                        'bSortable': false,
                        'aTargets': [-2,-1] /* 1st one, start by the right */
                    }]
                });
               
            });


}
function addrow1() {
    var table = document.getElementById("tbldata1");
    var id = parseInt(document.getElementById("ctl00_ContentPlaceHolder1_hidrowno1").value);
    var sno = parseInt(document.getElementById("ctl00_ContentPlaceHolder1_hidsno1").value);

    if (parseInt(id) == -1) {
        table.style.display = "table";
        document.getElementById("ctl00_ContentPlaceHolder1_hidrowno1").value = "0";
    }
    else {
        sno = sno + 1
        var newsno = id + 1;

        var row = table.insertRow(newsno);


        if (parseInt(id) >= 0)
            document.getElementById("divdeldeduction" + id).innerHTML = "";

        var celltitle = row.insertCell(0);
        var cellamount = row.insertCell(1);



        celltitle.innerHTML = " <input type='text' id='txtothertitlededuction" + newsno + "' class='form-control' style='width:120px;'  />";

        cellamount.innerHTML = " <input type='text' id='txtotheramountdeduction" + newsno + "' class='form-control f_left' style='width:86% !important;' placeholder='0.00' onkeypress='blockNonNumbers(this, event, true, false);' onchange='calculatededcution();'  onkeyup='extractNumber(this,2,false);' />"
   + "<div id='divdeldeduction" + newsno + "' style='padding-top: 2px;padding-left:3px;float:left;'><a style='cursor: pointer;color:bule;' id='delete' onclick='deleterow1(this.id);' ><img src='images/delete.png' /></a></div>";



        document.getElementById("ctl00_ContentPlaceHolder1_hidrowno1").value = newsno;
        document.getElementById("ctl00_ContentPlaceHolder1_hidsno1").value = sno;



    }

}


//Delete rows
function deleterow1() {

    var table = document.getElementById("tbldata1");
    var id = parseInt(document.getElementById("ctl00_ContentPlaceHolder1_hidrowno1").value);
    var sno = parseInt(document.getElementById("ctl00_ContentPlaceHolder1_hidsno1").value);
    sno = sno - 1
    var newsno = id - 1;
    //table.deleteRow(id);
    //if (newsno != "1")
    document.getElementById("ctl00_ContentPlaceHolder1_hidrowno1").value = newsno;
    document.getElementById("ctl00_ContentPlaceHolder1_hidsno1").value = sno;
    if (parseInt(id) >= 1) {
        table.deleteRow(id);
    }
    else {
        document.getElementById("txtothertitlededuction" + id).value = "";
        document.getElementById("txtotheramountdeduction" + id).value = "";
        table.style.display = "none";
    }

    if (parseInt(newsno) >= 0) {

        document.getElementById("divdeldeduction" + newsno).innerHTML = "<a style='cursor: pointer;color:bule;' id='delete' onclick='deleterow1(this.id);' ><img src='images/delete.png' /></a>";
    }
    calculatebasic();
    calculatededcution();
}


//Bind entered time info to hidden field after validate the entries
function getinfo1() {
    var newid = "", otherTitle = "", otherAmount = "";
    var id = parseInt(document.getElementById("ctl00_ContentPlaceHolder1_hidrowno1").value);

    for (var i = 0; i <= id; i++) {

        newid = "txtothertitlededuction" + i;

        otherTitle = otherTitle + "###" + document.getElementById(newid).value;

        newid = "txtotheramountdeduction" + i;

        otherAmount = otherAmount + "###" + document.getElementById(newid).value;

    }
    document.getElementById("ctl00_ContentPlaceHolder1_hidOtherTitle1").value = otherTitle;
    document.getElementById("ctl00_ContentPlaceHolder1_hidOtherAmount1").value = otherAmount;

}
function selectroles() {

    //---------get selected role type
    var roletype = document.getElementById("ctl00_ContentPlaceHolder1_droproletype").value;
    var list = document.getElementById('ctl00_ContentPlaceHolder1_reproles');
    var chklist = list.getElementsByTagName("input");
    var listOfSpans = list.getElementsByTagName("label");

    if (roletype.trim() != "" && roletype.trim() != "Admin") {
        //---------------------Get Roles decided as per role type
        var args = { roletype: roletype };
        $.ajax({

            type: "POST",
            url: "employee.aspx/selectrolebytype",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            cache: false,
            success: function (data) {
                //Check length of returned data, if it is less than 0 it means there is some status available
                if (data.d != "failure") {
                    $('#ctl00_ContentPlaceHolder1_reproles').find("input").attr("disabled", false);
                    json = $.parseJSON(data.d);
                  

                  

                    for (var i = 0; i < chklist.length; i++) {
                        listOfSpans[i].style.color = "#5a5a5a";

                        if (chklist[i].type == "checkbox") {

                            chklist[i].checked = false;
                            chklist[i].disabled = false;
                        }
                        for (var count in json) {
                            var listtext = listOfSpans[i].innerHTML.toLowerCase().replace(/&amp;/g, "&");
                            var arrvalue = json[count].roleName.toLowerCase();
                            if (chklist[i].type == "checkbox" && listtext == arrvalue) {
                                chklist[i].checked = true;
                            }
                        }
                    }
                   

                }
            }
        });
    }
    else {

        for (var i = 0; i < chklist.length; i++) {
            listOfSpans[i].style.color = "#e0e0e0";
            if (chklist[i].type == "checkbox") {

                chklist[i].checked = false;
                chklist[i].disabled = true;
            }
           
        }
       
       
    }
}