

include('js/calendar/lib/moment.min.js');
include('js/calendar/lib/jquery.min.js');
include('js/calendar/lib/jquery-ui.custom.min.js');
include('js/calendar/fullcalendar.min.js');
//include('js/calendar/lib/jquery.ui.touch-punch.js');
include('js/calendar/lib/jquery.ui.touch.js');

include('js/calendar_view5.0.js');



//----Include-Function----
function include(url) {
    document.write('<script type="text/javascript" src="' + url + '" ></script>');
}