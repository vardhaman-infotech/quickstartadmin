
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
		
		$(".chat-icon1").click(function(){
      
	
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
					
		}
		else
		{
			$('#rightpanel').addClass("rightpanel_toggle");			
			$('#leftpart').addClass("leftpart_toggle");		
			$('#rightpart').addClass("rightpart_toggle");
			$('#headerbar').addClass("headerbar_toggle_50");
			$('#logoback').addClass("logoback_toggle");
			$('#rightpart').addClass("rightpart_toggle2");
			
					
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
 
 