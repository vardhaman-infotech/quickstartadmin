
var winwidth = $(window).width();
var chatwinwidth = winwidth - 253;
var conswidth = 253;

if (winwidth <= 768)
    conswidth = 5;


$(function () {



    // Declare a proxy to reference the hub. 
    var chatHub = $.connection.chatHub;

    parent.registerClientMethods(chatHub);

    // Start Hub
    $.connection.hub.start().done(function () {

        parent.registerEvents(chatHub);
      

    });

});

