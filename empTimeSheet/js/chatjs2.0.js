
var winwidth = $(window).width();
var chatwinwidth = winwidth - 253;
var conswidth = 253;

if (winwidth <= 768)
    conswidth = 5;


$(function () {



    // Declare a proxy to reference the hub. 
    var chatHub = $.connection.chatHub;

    registerClientMethods(chatHub);

    // Start Hub
    $.connection.hub.start().done(function () {

        registerEvents(chatHub);
        $("#btnStartChat").click();

    });

});



function registerEvents(chatHub) {

    var lid = document.getElementById("hidchatloginid").value;
    var profleimg = document.getElementById("hidchatphoto").value;
    var designation = document.getElementById("hidchatDesignation").value;
    var groupid = document.getElementById("hidchatgroupid").value;
    var chatstatus = document.getElementById("hidchatstatus").value;

    $("#btnStartChat").click(function () {

        if (document.getElementById("hidchatname").value != "") {
            var name = document.getElementById("hidchatname").value;

           
            if (name.length > 0) {
                chatHub.server.connect(name, lid, designation, profleimg, groupid, chatstatus);
            }


        }

    });

    $("#ulchangestatus>li").click(function () {
        var status = $(this).attr('id')
       
        chatHub.server.changeuserchatstatus(lid, groupid, status);
        $('.chatstatus').toggle();
        $('#chat_spanstatus').css('background-image', 'url(images/user_' + status + '.png)');
        document.getElementById("hidchatstatus").value = status;

    });

    filteruserlist();
    $("#chat_spanstatus").click(function () {

        $('.chatstatus').toggle();
    });


   
}

function filteruserlist() {
    $('.right_search').keyup(function (e) {
        var keyword = $('.right_search').val();

        $('#chatuserlist li').each(function () {

            if (keyword == "") {
                $(this).css("display", "block");
            }
            else {
                if ($(this).find('div').text().toLowerCase().indexOf(keyword) >= 0) {
                    $(this).css("display", "block");
                }
                else {
                    $(this).css("display", "none");
                }

            }

        });
    });

}


//Method 3


function registerClientMethods(chatHub) {

    // Calls when user successfully logged in
    chatHub.client.onConnected = function (id, userName, allUsers) {
        var profilestatus = (document.getElementById("hidchatstatus").value).toLowerCase();
        var strstatus = "";

        if (profilestatus == "busy")
            strstatus = "user_busy.png";
        else if (profilestatus == "offline")
            strstatus = "user_offline.png";
        else if (profilestatus == "away")
            strstatus = "user_away.png";
        else
            strstatus = "user_online.png";
      $('#chat_spanstatus').css('background-image', 'url(images/' + strstatus + ')');
     

        // Add All Users
        for (i = 0; i < allUsers.length; i++) {


            AddUser(chatHub, allUsers[i].ConnectionId, allUsers[i].UserName, allUsers[i].UserId, allUsers[i].Status, allUsers[i].Designation, allUsers[i].Profileimg, allUsers[i].chatstatus);



        }




    }

    // On New User Connected
    chatHub.client.onNewUserConnected = function (id, name, loginid, status, UserDesig, profilePhoto, userstatus) {
       
        AddUser(chatHub, id, name, loginid, status, UserDesig, profilePhoto, userstatus);
    }

    // On Change Status
    chatHub.client.changechatstatus = function (id, loginid, userstatus) {

       
        $('#userstatus_' + loginid).css('background-image', 'url(images/'+userstatus+'.png)');
       
    }

    chatHub.client.fillUserMessage = function (touserid, messages) {


        for (i = 0; i < messages.length; i++) {


            AddMessage(touserid, messages[i].UserName, messages[i].Message, messages[i].Date);
        }

    }


    chatHub.client.sendPrivateMessage = function (connectionid, windowId, fromUserName, message, date) {


        var ctrId = 'div_' + windowId;
        var st = 0;
        if (document.getElementById(ctrId) != null) {
            st = 1;
        }
        openchatwindow(windowId, chatHub, fromUserName);

        if (st == 1)
        {
            notifyMe(fromUserName + " sent a new message", message, windowId, chatHub, fromUserName);
            AddMessage(windowId, fromUserName, message, date);

        }
           





    }



    // On User Disconnected


    chatHub.client.onUserDisconnected = function (id, userName) {

      
        $('#userstatus_' + id).css('background-image', 'url(img/offline.png)');
    
    }



}



function openchatwindow(id, chatHub, username) {
    var chatwin = document.getElementById("div_" + id);
    var position = document.getElementById("hidposition").value;


    if (chatwin == null) {
        createchatwindow(id, position, chatHub, username);

        chatHub.server.filloldmessage(id);

    }
    else {

        if (document.getElementById("div_" + id).style.display == "none") {
            if (position == "")
                position = conswidth;
            else {
                if (parseInt(position) >= chatwinwidth) {
                    position = conswidth;

                }
                else {
                    position = parseInt(position) + 5;
                }
            }


            document.getElementById("hidposition").value = parseInt(position) + 230;
            document.getElementById("div_" + id).style.display = "block";
            document.getElementById("div_" + id).style.right = position + "px";
            document.getElementById("hidopened").value = document.getElementById("hidopened").value + "div_" + id + "###";
        }
    }



}
function createchatwindow(id, position, chatHub, username) {

    if (position == "")
        position = conswidth;
    else {
        if (parseInt(position) >= chatwinwidth) {
            position = conswidth;

        }
        else {
            position = parseInt(position) + 5;
        }
    }
    document.getElementById("hidposition").value = parseInt(position) + 230;
    // alert(position);
    var str = "";
    str = '<div class="chatbox" id="div_' + id + '" style="right:' + position + 'px;" >' +
        '<h1>' +
            '<div>' + username
                +
            '</div>' +
            '<a>' +

                    '<img src="images/cross.png" alt="X" width="14" onclick=closechat("' + id + '") />' +

           '</a> <a onclick=mininizechatbox("div_' + id + '")> <img src="images/min.png" alt="-"    /> </a>  </h1>' +

       ' <div class="chatbox-inner" id="divmessage_' + id + '" >' +


       ' </div>' +
        '<div class="chatbox-txt">' +
       '<textarea id="txt_' + id + '" ></textarea> ' +
        '</div>' +
    '</div>';

    var $div = $(str);
    $('#newchatwindow').append($div);
    $div.find("#txt_" + id).focus();
    document.getElementById("hidopened").value = document.getElementById("hidopened").value + "div_" + id + "###";


    $div.find("#txt_" + id).keypress(function (e) {
        if (e.which == 13) {

            $textBox = $div.find("#txt_" + id);
            var msg = $textBox.val();
            if (msg.length > 0) {

                chatHub.server.sendPrivateMessage(id, msg);
                $textBox.val('');
            }
            return false;
        }
    });

}
function AddMessage(id, userName, message, date) {
    $('#divmessage_' + id).append('<div> <span>' + userName.split(' ').slice(0, -1).join(' ') + ':</span> <e >' + message + '</e> <i>' + date + '</i> </div>');

    var height = $('#divmessage_' + id)[0].scrollHeight;
    $('#divmessage_' + id).scrollTop(height);
}


function closechat(id) {

    var opendedId = document.getElementById("hidopened").value;

    var arr = new Array();
    var status = 0;
    var totalval = 0;
    var right = "";
    arr = opendedId.split("###");
    var totalchatwin = chatwinwidth / 235;


    if (opendedId != "") {

        totalval = parseInt(document.getElementById("hidposition").value);
        for (var i = 0; i < arr.length - 1; i++) {
            right = document.getElementById(arr[i]).style.right;

            right = right.replace("px", "");
            if (arr[i] == "div_" + id) {
                status = 1;
            }
            if (status == 1) {
                document.getElementById(arr[i]).style.right = (parseInt(right) - 235) + "px";

            }
        }
        totalval = totalval - 235;


        if (totalval < 483) {
            if (arr.length > totalchatwin) {
                totalval = arr.length % totalchatwin;
                if (totalval == 1)
                    totalval = conswidth;
                else
                    totalval = totalval * conswidth;

            }
            else {
                totalval = (arr.length - 1) * 235;

                if (arr.length - 1 == 1)
                    totalval = conswidth;


            }

        }
        document.getElementById("hidposition").value = totalval;

    }
    document.getElementById("div_" + id).style.display = "none";
    opendedId = opendedId.replace("div_" + id + "###", "");
    document.getElementById("hidopened").value = opendedId;
}



function AddUser(chatHub, id, name, loginid, status, userdesig, profileimg, chatstatus) {

   

    var userId = $('#hidchatloginid').val();

    var code = "";
    var strstatus = "";
    var struser="";

    if (document.getElementById(loginid) == null) {
        if (userId == loginid) {

           

        }
        else {
          
         
           
            if (status == "1") {

                strstatus = 'style="background-image:url(images/' + chatstatus.toLowerCase() + '.png);"';

            }
            else
                strstatus = 'style="background-image:url(images/offline.png);"';

            var strprofileimg = "webfile/profile/nophoto.jpg";
            if (profileimg != "")
            {
                strprofileimg = 'webfile/profile/thumb/' + profileimg;
            }
            struser = '<li id="' + loginid + '"  class="online"> <div class="media"><a class="pull-left media-thumb"><span  style="background-image:url('+strprofileimg+');" class="media-object" ></span></a>';
            struser += '<div class="media-body"><div id="userstatus_' + loginid + '" class="pull-right online_icon" ' + strstatus + '></div><span>' + name + '</span> <small>' + userdesig + '</small></div> </div></li>';
          
            code = $(struser);

        }

        $("#chatuserlist").append(code);

        if (userId != loginid) {
            $(code).click(function () {



                var id = $(this).attr('id');

                openchatwindow(this.id, chatHub, name);
                // $('#chatusercontainer').toggle();

            });
        }
    }
    else {
      
       
        if (status == "1")
        {
          
            $('#userstatus_' + loginid).css('background-image', 'url(images/' + chatstatus + '.png)');
          
          
         
        }
          
        else
            {
            $('#userstatus_' + loginid).css('background-image', 'url(images/offline.png)');

        }

    }

}

function notifyMe(title,msg, windowId, chatHub, fromUserName) {

    var options = {
        body: msg,
        icon: "images/notification.png",
        sound: 'images/alert.mp3',
  
        onclick: function () { openchatwindow(windowId, chatHub, fromUserName); }
    }

    // Let's check if the browser supports notifications
    if (!("Notification" in window)) {
        alert("This browser does not support system notifications");
    }

        // Let's check whether notification permissions have already been granted
    else if (Notification.permission === "granted") {
        // If it's okay let's create a notification
        var notification = new Notification(title, options);
        setTimeout(notification.close.bind(notification), 60000);
    }

        // Otherwise, we need to ask the user for permission
    else if (Notification.permission !== 'denied') {
        Notification.requestPermission(function (permission) {
            // If the user accepts, let's create a notification
            if (permission === "granted") {
                var notification = new Notification(title, options);
                setTimeout(notification.close.bind(notification), 60000);
            }
        });
    }

    // Finally, if the user has denied notifications and you 
    // want to be respectful there is no need to bother them any more.
}






function mininizechatbox(id) {
    var top = document.getElementById(id).style.bottom;



    // document.getElementById(id).style.bottom = top + "px";
    if (top == 0 || top == '' || top == "0px") {
        $("#" + id).animate({
            bottom: -277 + "px"
        }, 300);

    }
    else {
        $("#" + id).animate({
            bottom: 0 + "px"
        }, 300);

    }

}
