
function zeroFill(number, width) {
    width -= number.toString().length;
    if (width > 0) {
        return new Array(width + (/\./.test(number) ? 2 : 1)).join('0') + number;
    }
    return number + ""; // always return a string
}

function CheckEmail(str) {
    var at = "@"
    var dot = "."
    var lat = str.indexOf(at)
    var lstr = str.length
    var ldot = str.indexOf(dot)
    if (str.indexOf(at) == -1) {
        return false;
    }

    if (str.indexOf(at) == -1 || str.indexOf(at) == 0 || str.indexOf(at) == lstr) {
        return false;
    }

    if (str.indexOf(dot) == -1 || str.indexOf(dot) == 0 || str.indexOf(dot) == lstr) {
        return false;
    }

    if (str.indexOf(at, (lat + 1)) != -1) {
        return false;
    }
    if (str.substring(lat - 1, lat) == dot || str.substring(lat + 1, lat + 2) == dot) {
        return false;
    }
    if (str.indexOf(dot, (lat + 2)) == -1) {
        return false;
    }
    if (str.indexOf(" ") != -1) {
        return false;
    }
    return true;
}

function Trim(str) {
    while (str.charAt(0) == (" ")) {
        str = str.substring(1);
    }
    while (str.charAt(str.length - 1) == " ") {
        str = str.substring(0, str.length - 1);
    }
    return str;

}

function comparedate(id, from, to,event) {
    var val = document.getElementById(id).value;
   // alert(val);
    if (val != "" && val != "__/__/____") {
        if (!isDate(val)) {
            alert('Invalid date format, date must be in mm/dd/yyyy format');

            document.getElementById(id).value = "";


        }
        else {

            var fromval = document.getElementById(from).value;
            var toval = document.getElementById(to).value;

            if(fromval!="" && toval!="")
            {
            
                var d1 = new Date(fromval);
                var d2 = new Date(toval);
                if (d1 > d2)
                {
                    alert('"From Date" should not be greater than "To Date"');

                    document.getElementById(id).value = "";
                   
                }


            
            }



            }
    }

}

function checkdate(val, id) {
   
    if (val != "" && val != "__/__/____") {
        if (!isDate(val)) {
            alert('Invalid date format, date must be in mm/dd/yyyy format');

            document.getElementById(id).value = "";
            $("#" + id).focus();
           
        }
       
    }
    

}

function isDate(date) {
    var objDate,  // date object initialized from the ExpiryDate string 
        mSeconds, // ExpiryDate in milliseconds 
        day,      // day 
        month,    // month 
        year;     // year 
    // date length should be 10 characters (no more no less) 
    if (date.length !== 10) {
        return false;
    }
    // third and sixth character should be '/' 
    if (date.substring(2, 3) !== '/' || date.substring(5, 6) !== '/') {
        return false;
    }
    // extract month, day and year from the ExpiryDate (expected format is mm/dd/yyyy) 
    // subtraction will cast variables to integer implicitly (needed 
    // for !== comparing) 
    month = date.substring(0, 2) - 1; // because months in JS start from 0 
    day = date.substring(3, 5) - 0;
    year = date.substring(6, 10) - 0;
    // test year range 
    if (year < 1000 || year > 3000) {
        return false;
    }
    // convert ExpiryDate to milliseconds 
    mSeconds = (new Date(year, month, day)).getTime();
    // initialize Date() object from calculated milliseconds 
    objDate = new Date();
    objDate.setTime(mSeconds);
    // compare input date and parts from Date() object 
    // if difference exists then date isn't valid 
    if (objDate.getFullYear() !== year ||
        objDate.getMonth() !== month ||
        objDate.getDate() !== day) {
        return false;
    }
    // otherwise return true 
    return true;
}

function validateEmail(email) {
    var atpos = email.indexOf("@");
    var dotpos = email.lastIndexOf(".");
    if (atpos < 1 || dotpos < atpos + 2 || dotpos + 2 >= email.length) {
        alert("Not a valid e-mail address");
        return false;
    }
    else
        return true;
}

function blockSpecialCh(obj,event)
{

    //var regex = new RegExp("^[\"#']+$");
    //var key = String.fromCharCode(!event.charCode ? event.which : event.charCode);
    //if (regex.test(key)) {
    //    event.preventDefault();
    //    return false;
  //  }
}
function removeSpecialCh(obj, event) {
    var str = document.getElementById(obj).value;
   // str = document.getElementById(obj).value.replace(/[#'~\"]+/gim, "");
    // document.getElementById(obj).value = str.replace(/("|')/g, "");
    document.getElementById(obj).value = str;
    }

function extractNumber(obj, decimalPlaces, allowNegative) {
    var temp = obj.value;

    // avoid changing things if already formatted correctly
    var reg0Str = '[0-9]*';
    if (decimalPlaces > 0) {
        reg0Str += '\\.?[0-9]{0,' + decimalPlaces + '}';
    } else if (decimalPlaces < 0) {
        reg0Str += '\\.?[0-9]*';
    }
    reg0Str = allowNegative ? '^-?' + reg0Str : '^' + reg0Str;
    reg0Str = reg0Str + '$';
    var reg0 = new RegExp(reg0Str);
    if (reg0.test(temp)) return true;

    // first replace all non numbers
    var reg1Str = '[^0-9' + (decimalPlaces != 0 ? '.' : '') + (allowNegative ? '-' : '') + ']';
    var reg1 = new RegExp(reg1Str, 'g');
    temp = temp.replace(reg1, '');

    if (allowNegative) {
        // replace extra negative
        var hasNegative = temp.length > 0 && temp.charAt(0) == '-';
        var reg2 = /-/g;
        temp = temp.replace(reg2, '');
        if (hasNegative) temp = '-' + temp;
    }

    if (decimalPlaces != 0) {
        var reg3 = /\./g;
        var reg3Array = reg3.exec(temp);
        if (reg3Array != null) {
            // keep only first occurrence of .
            //  and the number of places specified by decimalPlaces or the entire string if decimalPlaces < 0
            var reg3Right = temp.substring(reg3Array.index + reg3Array[0].length);
            reg3Right = reg3Right.replace(reg3, '');
            reg3Right = decimalPlaces > 0 ? reg3Right.substring(0, decimalPlaces) : reg3Right;
            temp = temp.substring(0, reg3Array.index) + '.' + reg3Right;
        }
    }

    obj.value = temp;
}

function TS_blockNonNumbers(obj, e, allowDecimal, allowNegative, id) {
    if (e.keyCode == 13) {
        var hoursid = 'txtdesc' + id;

        $('#' + hoursid).focus();
        e.preventDefault();
    }

    var key;
    var isCtrl = false;
    var keychar;
    var reg;

    if (window.event) {
        key = e.keyCode;
        isCtrl = window.event.ctrlKey
    }
    else if (e.which) {
        key = e.which;
        isCtrl = e.ctrlKey;
    }

    if (isNaN(key)) return true;

    keychar = String.fromCharCode(key);

    // check for backspace or delete, or if Ctrl was pressed
    if (key == 8 || isCtrl) {
        return true;
    }

    reg = /\d/;
    var isFirstN = allowNegative ? keychar == '-' && obj.value.indexOf('-') == -1 : false;
    var isFirstD = allowDecimal ? keychar == '.' && obj.value.indexOf('.') == -1 : false;


   

    return isFirstN || isFirstD || reg.test(keychar);
}


function blockNonNumbers(obj, e, allowDecimal, allowNegative) {
    var key;
    var isCtrl = false;
    var keychar;
    var reg;

    if (window.event) {
        key = e.keyCode;
        isCtrl = window.event.ctrlKey
    }
    else if (e.which) {
        key = e.which;
        isCtrl = e.ctrlKey;
    }

    if (isNaN(key)) return true;

    keychar = String.fromCharCode(key);

    // check for backspace or delete, or if Ctrl was pressed
    if (key == 8 || isCtrl) {
        return true;
    }

    reg = /\d/;
    var isFirstN = allowNegative ? keychar == '-' && obj.value.indexOf('-') == -1 : false;
    var isFirstD = allowDecimal ? keychar == '.' && obj.value.indexOf('.') == -1 : false;

    return isFirstN || isFirstD || reg.test(keychar);
}


function scrolltotopofList() {
   
    $('html, body').animate({ scrollTop: 10 }, "fast");
}


function checkTextAreaMaxLength(textBox, e, length) {

    var mLen = textBox["MaxLength"];
    if (null == mLen)
        mLen = length;

    var maxLength = parseInt(mLen);
    if (!checkSpecialKeys(e)) {
        if (textBox.value.length > maxLength - 1) {
            if (window.event)//IE
                e.returnValue = false;
            else//Firefox
                e.preventDefault();
        }
    }
}
function checkSpecialKeys(e) {
    if (e.keyCode != 8 && e.keyCode != 46 && e.keyCode != 37 && e.keyCode != 38 && e.keyCode != 39 && e.keyCode != 40)
        return false;
    else
        return true;
}

function isValidDate(varFrom, varTo) {
    var fromdate, todate, dt1, dt2, mon1, mon2, yr1, yr2, date1, date2;
    var chkFrom = document.getElementById(varFrom);
    var chkTo = document.getElementById(varTo);
    if (document.getElementById(varFrom).value.trim() == "" && document.getElementById(varTo).value.trim() == "") {
        return true;
    }
    if (document.getElementById(varFrom).value.trim() == "") {
        alert('"From date" should not be empty if "To Date" exists');
        document.getElementById(varFrom).value = "";
        document.getElementById(varFrom).focus();
        return false;
    }
    else if (document.getElementById(varTo).value.trim() == "") {
        alert('"To date" should not be empty if "From Date" exists');
        document.getElementById(varTo).value = "";
        document.getElementById(varTo).focus();
        return false;
    }
    if (varFrom != null && document.getElementById(varFrom).value.trim() != "" && varTo != null && document.getElementById(varTo).value.trim() != "") {

        fromdate = document.getElementById(varFrom).value.trim();
        todate = document.getElementById(varTo).value.trim();

        var fromdt = new Date(fromdate);
        var todt = new Date(todate);
        if (todt < fromdt) {

            alert('"To date" Should be greater than "From date"');
            document.getElementById(varTo).value = "";
            document.getElementById(varTo).focus();
            return false;
        }

    }
    return true;
}