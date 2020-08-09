function fn_MasterSearchDataTable(dtval, dtid, num) {
    // alert(dtval);
    if (num == "") {
        $("#" + dtid).DataTable().search(
      dtval

  ).draw();
    }
    else {
        $("#" + dtid).DataTable().columns(num)
      .search(dtval)
      .draw();
    }

}
function fn_MasterFixheader(tblid, target) {

    $.getScript("js/colResizable-1.6.js", function () {

        $("#" + tblid).colResizable({
            liveDrag: true,
            gripInnerHtml: "<div class='grip'></div>",
            draggingClass: "dragging",
            resizeMode: 'fit',

        });

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
function fn_MasterFixheaderNoPage(tblid, target) {

    $('#' + tblid).dataTable({
        "dom": 'lrtip',

        "bPaginate": false,
        'aoColumnDefs': [{
            'bSortable': false,
            "bPaginate": false,
            'aTargets': target/* 1st one, start by the right */
        }]
    });


}


$.fn.pageMe = function (opts) {
    var $this = this,
        defaults = {
            perPage: 20,
            showPrevNext: true,
            hidePageNumbers: false
        },
        settings = $.extend(defaults, opts);

    var listElement = $this;
    var perPage = settings.perPage;
    var children = listElement.children();
    var pager = $('.pager');

    if (typeof settings.childSelector != "undefined") {
        children = listElement.find(settings.childSelector);
    }

    if (typeof settings.pagerSelector != "undefined") {
        pager = $(settings.pagerSelector);
    }

    var numItems = children.size();
    var numPages = Math.ceil(numItems / perPage);

    pager.data("curr", 0);

    if (settings.showPrevNext) {
        $('<li><a href="#" class="prev_link"><img src="images/arrow_left.png" /></a></li>').appendTo(pager);
    }

    var curr = 0;
    while (numPages > curr && (settings.hidePageNumbers == false)) {
        $('<li><a href="#" class="page_link">' + (curr + 1) + '</a></li>').appendTo(pager);
        curr++;
    }

    if (settings.showPrevNext) {
        $('<li><a href="#" class="next_link"><img src="images/arrow_right.png" /></a></li>').appendTo(pager);
    }

    pager.find('.page_link:first').addClass('active');
    pager.find('.prev_link').hide();
    if (numPages <= 1) {
        pager.find('.next_link').hide();
    }
    pager.children().eq(1).addClass("active");

    children.hide();
    children.slice(0, perPage).show();

    pager.find('li .page_link').click(function () {
        var clickedPage = $(this).html().valueOf() - 1;
        goTo(clickedPage, perPage);
        return false;
    });
    pager.find('li .prev_link').click(function () {
        previous();
        return false;
    });
    pager.find('li .next_link').click(function () {
        next();
        return false;
    });

    function previous() {
        var goToPage = parseInt(pager.data("curr")) - 1;
        goTo(goToPage);
    }

    function next() {
        goToPage = parseInt(pager.data("curr")) + 1;
        goTo(goToPage);
    }

    function goTo(page) {
        var startAt = page * perPage,
            endOn = startAt + perPage;

        children.css('display', 'none').slice(startAt, endOn).show();

        if (page >= 1) {
            pager.find('.prev_link').show();
        }
        else {
            pager.find('.prev_link').hide();
        }

        if (page < (numPages - 1)) {
            pager.find('.next_link').show();
        }
        else {
            pager.find('.next_link').hide();
        }

        pager.data("curr", page);
        pager.children().removeClass("active");
        pager.children().eq(page + 1).addClass("active");

    }
};


function initilizeMyMenu() {



    $(".menutoggle").click(function () {

        if ($('#leftpart').hasClass("leftpart_toggle")) {
            $('#leftpart').removeClass("leftpart_toggle");
            $('#rightpart').removeClass("rightpart_toggle");
            $('#rightpart').removeClass("rightpart_toggle2");

            $('#headerbar').removeClass("headerbar_toggle_50");
            $('#logoback').removeClass("logoback_toggle");
            $('#rightpanel').removeClass("rightpanel_toggle");

            //$('#headerbar').css("margin-left","0px");
            //$('#logoback').css("display","block");
            //$('#rightpanel').css("right","-240px");

        }
        else {
            $('#leftpart').addClass("leftpart_toggle");
            $('#rightpart').addClass("rightpart_toggle");

            $('#headerbar').addClass("headerbar_toggle_50");
            $('#logoback').addClass("logoback_toggle");
        }





    });

    $(".chat-icon").click(function () {


        if ($(window).width() >= 1080) {
            if ($('#rightpanel').hasClass("rightpanel_toggle")) {

                $('#rightpanel').removeClass("rightpanel_toggle");
                $('#leftpart').removeClass("leftpart_toggle");
                $('#leftpart').removeClass("leftpart_toggle_mobile");
                $('#rightpart').removeClass("rightpart_toggle");
                $('#headerbar').removeClass("headerbar_toggle_50");
                $('#logoback').removeClass("logoback_toggle");
                $('#rightpart').removeClass("rightpart_toggle2");
                $('#menu').addClass("menu_toggle_icon");
            }
            else {
                $('#rightpanel').addClass("rightpanel_toggle");
                $('#leftpart').addClass("leftpart_toggle");
                $('#rightpart').addClass("rightpart_toggle");
                $('#headerbar').addClass("headerbar_toggle_50");
                $('#logoback').addClass("logoback_toggle");
                $('#rightpart').addClass("rightpart_toggle2");

                $('#menu').addClass("menu_toggle_icon");
            }
        }
        else {

            if ($('#rightpanel').hasClass("rightpanel_toggle")) {

                $('#rightpanel').removeClass("rightpanel_toggle");
                //$('#leftpart').removeClass("leftpart_toggle");
                $('#rightpart').removeClass("rightpart_toggle_mobile")
                $('#rightpart').removeClass("rightpart_toggle");

                $('#headerbar').removeClass("headerbar_toggle_50");
                $('#logoback').removeClass("logoback_toggle");
                $('#rightpart').removeClass("rightpart_toggle2");

            }
            else {
                $('#rightpanel').addClass("rightpanel_toggle");
                $('#leftpart').removeClass("leftpart_toggle");
                $('#rightpart').removeClass("rightpart_toggle");

                $('#rightpart').addClass("rightpart_toggle_mobile");


                $('#headerbar').addClass("headerbar_toggle_50");
                $('#logoback').addClass("logoback_toggle");
                $('#rightpart').addClass("rightpart_toggle2");


            }

        }



    });
}
function clickedit(id) {
    document.getElementById("ctl00_ContentPlaceHolder1_hidid").value = id;
    $('#PaggedGridbtnedit').trigger('click');
}
function healpsearch(keyword, event) {

    if (event.keyCode == 13) {
        location.href = "help.aspx?keyword=" + keyword;

        event.preventDefault();
    }
}
function funViewReportClick() {
    $('#ctl00_ContentPlaceHolder1_btnsearch').trigger('click');
}
function setallbuttons() {

    var a = document.getElementsByTagName("A");
    for (var i = 0; i < a.length; i++) {
        var id = a[i].id;
        if (id.indexOf('lbtndelete') != -1) {
            a[i].href = "#";
            a[i].removeAttribute("onclick");
            a[i].removeAttribute("href");
            a[i].onclick = function () {
                stopclick();
                return false;
            }


        }


    }

    var b = document.querySelectorAll('[type=submit]')
    for (var i = 0; i < b.length; i++) {
        var id = b[i].id;

        if (id.indexOf('btnsubmit') != -1 || id.indexOf('save') != -1) {

            b[i].removeAttribute("onclick");

            b[i].onclick = function () {
                stopclick();
                return false;
            }


        }


    }
}
function closedangernoti() {
    $("#divdangernotification").hide();
}
function stopclick() {
    $("#divdangernotification").fadeIn('slow').delay(5000).fadeOut();

}
function setposition(id) {

    $(function () {
        $.getScript("js/jquery-ui.js", function () {

            $('#' + id).draggable({ cursor: "move", handle: '.popup_heading' });
        });
    });

    //$('#' + id).css({
    //    'left': ($(window).width() / 2) - ($('#' + id).width() / 2),
    //    'top': ($(window).width() / 2) - ($('#' + id).height() / 2)
    //})


    $('#' + id).css("top", Math.max(0, (($(window).height() - $('#' + id).outerHeight()) / 2) +
                                        $(window).scrollTop()) + "px");

    if ($(window).width() < 481) {
        $('#' + id).css("left", "1px");
    }
    else {
        $('#' + id).css("left", Math.max(0, (($(window).width() - $('#' + id).outerWidth()) / 2) +
                                        $(window).scrollLeft()) + "px");
    }

}

$(document).ready(function () {


    $("body").click(function (e) {

        if (e.target.id == "userprofileimage" || e.target.id == "ctl00_imgphoto" || e.target.id == "liprofile") {

            $("#dropprofile").toggle(true);
        }
        else {

            $("#dropprofile").hide();
        }

        if (e.target.id == "lnkannouncenoti" || e.target.id == "liannouncenoti" || e.target.id == "iannouncenoti") {
            if ($('#dropannouncenoti').css('display') == 'none') {
                $("#divloader").toggle(true);
                resetnotification();
            }
            else {
                $("#dropannouncenoti").hide();
            }


        }
        else {
            $("#dropannouncenoti").hide();
        }

        if (e.target.id == "lnkFavReport" || e.target.id == "liFavReport" || e.target.id == "iFavReport") {
            $("#dropfavtask").toggle(true);


        }
        else {
            $("#dropfavtask").hide();
        }


        if (e.target.id == "lnktasknoti" || e.target.id == "litasknoti" || e.target.id == "itasknoti") {

            if ($('#droptasknoti').css('display') == 'none') {
                $("#divloader").toggle(true);
                resettasknotification();
            }
            else {
                $("#droptasknoti").hide();
            }
        }
        else {
            $("#droptasknoti").hide();

        }
    });

    initilizeMyMenu();



    $(".menutoggle").click(function () {
        $('.left').toggleClass("left_toggle");
        $('.menu').toggleClass("menu_toggle_icon");

    });
});





//Bind task notification

function bindtasknotification() {
    if (document.getElementById("hidtasknoti").value == "") {
        var loginid = document.getElementById("hidloginid").value;
        var companyid = document.getElementById("hidcompanyid").value;

        var args = { userid: loginid, companyid: companyid };

        $.ajax({

            type: "POST",
            url: "Dashboard.aspx/bindtasknoti",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            cache: false,
            success: function (msg) {

                if (msg.d != "failure") {
                    document.getElementById("droptasknoti").innerHTML = msg.d;
                    document.getElementById("hidtasknoti").value = msg.d;
                }
                else {
                    alert("Server error please try again");
                }


            },
            error: function (x, e) {
                alert("The call to the server side failed. " + x.responseText);

            }


        });
    }
}


//Reset task notification
function resettasknotification() {
    bindtasknotification();
    var loginid = document.getElementById("hidloginid").value;
    var companyid = document.getElementById("hidcompanyid").value;

    var args = { userid: loginid, companyid: companyid };

    $.ajax({

        type: "POST",
        url: "Dashboard.aspx/resettasknotification",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (msg) {

            if (msg.d != "failure") {
                document.getElementById("ctl00_spantasknoti").innerHTML = msg.d;
            }
            else {
                alert("Server error please try again");
            }
            $("#droptasknoti").toggle(true);
            $("#divloader").hide();
        },
        error: function (x, e) {
            alert("The call to the server side failed. " + x.responseText);

        }


    });
}

//Bind announcment notification

function bindannoucementnotification() {
    if (document.getElementById("hidannouncenoti").value == "") {
        var loginid = document.getElementById("hidloginid").value;
        var companyid = document.getElementById("hidcompanyid").value;

        var args = { userid: loginid, companyid: companyid };

        $.ajax({

            type: "POST",
            url: "Dashboard.aspx/bindannouncenoti",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            cache: false,
            success: function (msg) {

                if (msg.d != "failure") {
                    document.getElementById("dropannouncenoti").innerHTML = msg.d;
                    document.getElementById("hidannouncenoti").value = msg.d;
                }
                else {
                    alert("Server error please try again");
                }


            },
            error: function (x, e) {
                alert("The call to the server side failed. " + x.responseText);

            }


        });
    }
}

//Reset Announcement Notification
function resetnotification() {
    bindannoucementnotification();
    var loginid = document.getElementById("hidloginid").value;
    var companyid = document.getElementById("hidcompanyid").value;

    var args = { userid: loginid, companyid: companyid };

    $.ajax({

        type: "POST",
        url: "Dashboard.aspx/resetnotification",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (msg) {

            if (msg.d != "failure") {
                document.getElementById("ctl00_spanannouncenoti").innerHTML = msg.d;
            }
            else {
                alert("Server error please try again");
            }
            $("#dropannouncenoti").toggle(true);
            $("#divloader").hide();
        },
        error: function (x, e) {
            alert("The call to the server side failed. " + x.responseText);

        }


    });

}



function validatefields() {
    try {
        var val = Page_ClientValidate();

        if (!val) {

            for (var i = 0; i < Page_Validators.length; i++) {
                if (!Page_Validators[i].isvalid) {
                    $("#" + Page_Validators[i].controltovalidate)
                     .css("border-color", "red");
                }
                else {
                    $("#" + Page_Validators[i].controltovalidate)
                    .css("border-color", "#dcdbd5");
                }
            }
        }
        else {
            for (var i = 0; i < Page_Validators.length; i++) {
                if ($("#" + Page_Validators[i].controltovalidate).css("border-color") == "red");
                {
                    $("#" + Page_Validators[i].controltovalidate)
                    .css("border-color", "#dcdbd5");
                }
            }
        }
        return val;
    }
    catch (exception) {

        return false;

    }
}

function validatefieldsbygroup(groupname) {
    try {
        var val = Page_ClientValidate(groupname);
        if (!val) {
            for (var i = 0; i < Page_Validators.length; i++) {
                if (!Page_Validators[i].isvalid) {
                    $("#" + Page_Validators[i].controltovalidate)
                     .css("border-color", "red");
                }
                else {
                    $("#" + Page_Validators[i].controltovalidate)
                    .css("border-color", "#dcdbd5");
                }
            }
        }

        return val;
    }
    catch (exception) {

        return false;

    }

}

function setDateFromat(dateTxt) {

    var nDate = new Date(dateTxt);
    var month = "", day = "", year = "";

    var num = nDate.getMonth() + 1
    month = num;
    if (num < 10) {
        month = "0" + num;
    }




    num = nDate.getDate();
    day = num;
    if (num < 10) {
        day = "0" + num;
    }

    year = nDate.getFullYear();

    return month + "/" + day + "/" + year;


}


function closeAnnouncement() {

    document.getElementById("masterAnnouncement").style.display = "none";
    document.getElementById("Masterotherdiv").style.display = "none";
}
//Open Announcement Popup
function openAnnouncement() {
    setposition("masterAnnouncement");
    document.getElementById("masterAnnouncement").style.display = "block";
    document.getElementById("Masterotherdiv").style.display = "block";
}

function getNoti(el) {
    var companyid = document.getElementById("hidcompanyid").value;

    var args = { id: el, companyid: companyid };

    $.ajax({
        type: "POST",
        url: "Dashboard.aspx/binddetail",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {
            if (data.d != "") {
                var str = String(data.d);
                var array = str.split("###");
                document.getElementById('ctl00_lbladdedon').innerText = array[3];
                document.getElementById('ctl00_lbladdedby').innerText = array[2];
                document.getElementById('ctl00_lblTitle').innerText = array[0];
                document.getElementById('ctl00_lbldesc').innerText = array[1];
                document.getElementById('ctl00_Image1').src = array[4];
                openAnnouncement();
            }
            else {
                alert("Server error please try again");
            }
        }

    });
}


function convertUTCDateToLocalDate(date) {
    var d = new Date(date + " UTC");

    var curr_hour = d.getHours();
    var a_p = "";

    if (curr_hour < 12) {
        a_p = "AM";
    }
    else {
        a_p = "PM";
    }
    if (curr_hour == 0) {
        curr_hour = 12;
    }
    if (curr_hour > 12) {
        curr_hour = curr_hour - 12;
    }

    var curr_min = d.getMinutes();

    var newMin = "";
    var newHrs = "";

    if (curr_min < 10)
        newMin = '0' + curr_min;
    else
        newMin = curr_min;
    if (curr_hour < 10)
        newHrs = '0' + curr_hour;
    else
        newHrs = curr_hour;


    return newHrs + ":" + newMin + " " + a_p;
}


function setcontent(chkid, id, place, type) {
    var str = "", str1 = "";
    var chkBoxList = document.getElementById(chkid);
    var elements = chkBoxList.getElementsByTagName("input");
    var lbl = chkBoxList.getElementsByTagName("label");
    for (i = 0; i < elements.length; i++) {
        if (elements[i].checked) {
            if (str == "") {
                str = lbl[i].innerHTML;

            }
            else {
                str += "," + lbl[i].innerHTML;

            }

        }

    }

    if (str == "")
        document.getElementById(id).placeholder = place;
    else
        document.getElementById(id).placeholder = str;

    document.getElementById(id).value = "";

}

function checkall(id, chkid, place, txtid, type) {

    document.getElementById(id).value = "";
    var ischecked = document.getElementById(id).checked;

    var chkBoxList = document.getElementById(chkid);
    var elements = chkBoxList.getElementsByTagName("input");
    for (i = 0; i < elements.length; i++) {
        if (elements[i].style.display != "none")
            elements[i].checked = ischecked;
    }
    setcontent(chkid, txtid, place, type);
}

function searchfilters(id, chkid) {
    var chkBoxList = document.getElementById(chkid);
    var elements = chkBoxList.getElementsByTagName("input");
    var lbl = chkBoxList.getElementsByTagName("label");
    var txtval = document.getElementById(id).value.toLowerCase();

    for (i = 0; i < elements.length; i++) {

        if (txtval == "") {

            elements[i].parentNode.style.display = "block";

        }
        else {
            var chkval = lbl[i].innerHTML.toLowerCase();
            if (!elements[i].checked) {
                if (chkval.indexOf(txtval) != -1) {

                    elements[i].parentNode.style.display = "block";
                }
                else {
                    elements[i].parentNode.style.display = "none";
                }

            }

        }


    }


}
