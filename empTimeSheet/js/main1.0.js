
function initilizeMyMenu() {


    
 $(".menutoggle").click(function(){
		
		if($('#leftpart').hasClass("leftpart_toggle"))
		{
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
		else
		{
			$('#leftpart').addClass("leftpart_toggle");	
			$('#rightpart').addClass("rightpart_toggle");			
			
			$('#headerbar').addClass("headerbar_toggle_50");
			$('#logoback').addClass("logoback_toggle");
		}
		
		
		
		
				
		});
		
		$(".chat-icon").click(function(){
      
	
		if($(window).width()>=1080)
		{  
		if($('#rightpanel').hasClass("rightpanel_toggle"))
		{
			
			$('#rightpanel').removeClass("rightpanel_toggle");			
			$('#leftpart').removeClass("leftpart_toggle");
			$('#leftpart').removeClass("leftpart_toggle_mobile");		
			$('#rightpart').removeClass("rightpart_toggle");
			$('#headerbar').removeClass("headerbar_toggle_50");
			$('#logoback').removeClass("logoback_toggle");
			$('#rightpart').removeClass("rightpart_toggle2");
			$('#menu').addClass("menu_toggle_icon");			
		}
		else
		{
			$('#rightpanel').addClass("rightpanel_toggle");			
			$('#leftpart').addClass("leftpart_toggle");		
			$('#rightpart').addClass("rightpart_toggle");
			$('#headerbar').addClass("headerbar_toggle_50");
			$('#logoback').addClass("logoback_toggle");
			$('#rightpart').addClass("rightpart_toggle2");

			$('#menu').addClass("menu_toggle_icon");			
		}	
		}
		else
		{
			
			if($('#rightpanel').hasClass("rightpanel_toggle"))
		{
			
			$('#rightpanel').removeClass("rightpanel_toggle");			
			//$('#leftpart').removeClass("leftpart_toggle");
			$('#rightpart').removeClass("rightpart_toggle_mobile")
			$('#rightpart').removeClass("rightpart_toggle");
			
			$('#headerbar').removeClass("headerbar_toggle_50");
			$('#logoback').removeClass("logoback_toggle");
			$('#rightpart').removeClass("rightpart_toggle2");
					
		}
		else
		{
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
 
 
function setposition(id) {


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