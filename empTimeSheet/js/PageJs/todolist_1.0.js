var todopagename = "webservices/quickstartservice.asmx";
var flag = 0, todonidnid = "";

function ToDo_SaveNewTask() {
    var status = 1, date = "", taskstatus = "Default";
    if ($("#txtnewtask").val() == "") {
        status = 0;
        $("#txtnewtask").css("border-bottom-color", "#ff0000");
    }
    else {
        $("#txtnewtask").css("border-bottom-color", "#e9e9e9");
    }
    if ($("#hidToDodate").val() == "") {
        var someDate = new Date();
        date = setDateFromat(someDate.setDate(someDate.getDate() + 0));
    }
    else {
        date = $("#hidToDodate").val();
    }
    if ($("#hidToDoNewStatus").val() != "") {
        taskstatus = $("#hidToDoNewStatus").val();
    }

    if (status == 1) {
        var args = { taskDate: date, empid: $('#hidchatloginid').val(), notes: $('#txtnewtask').val(), taskStatus: taskstatus };
        $('#todo_btnsave').hide();
        $('#todo_divsaveloader').show();
        $.ajax({

            type: "POST",
            url: todopagename + "/insertToDoList",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            cache: false,
            success: function (data) {

                if (data.d == "1") {


                    $('#txtnewtask').val("");

                    todo_Fill();
                }
                else {

                    alert(data.d);
                }

                $('#todo_btnsave').show();
                $('#todo_divsaveloader').hide();
            },
            error: function (x, e) {
                alert("The call to the server side failed. " + x.responseText);
                $('#todo_btnsave').show();
                $('#todo_divsaveloader').hide();
                return;
            }

        });
    }
}
function removeclasses(controlIndex, classPrefix) {
    var classes = $("#" + controlIndex).attr("class").split(" ");
    $.each(classes, function (index) {
        if (classes[index].indexOf(classPrefix) == 0) {
            $("#" + controlIndex).removeClass(classes[index]);
        }
    });
}
function todo_Fill() {
    var args = { empid: $('#hidchatloginid').val() };
    $('#divtotoTaskList').empty();
    $('#todo_divloader').show();
    $.ajax({

        type: "POST",
        url: todopagename + "/getToDoList",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {

           
            $('#divtotoTaskList').html(data.d);
            $('#todo_divloader').hide();

            $(".tohiddate").datepicker({
                dateFormat: 'mm/dd/yy'
            });
            $(".tohiddate").change(function () {
                var id = $(this).attr("id");
                todonidnid = id.replace("_hiddate", "");
                toDo_update("1", $("#" + todonidnid).data("todoid"), $(this).val(), 1);
            });

            $(".todoimgdate").click(function () {
                var id = $(this).parent().find(".tohiddate").attr("id");
                todonidnid = id.replace("_hiddate", "");
                $("#" + id).datepicker("show");  
            });

            $(".status_box_inner").click(function (e) {
                var id = $(this).attr("id");
                $('.todo_statusDrop').not('#' + id+'_drop').hide();               
                $('#' + id + '_drop').slideToggle();               
                todonidnid = id.replace("_divstatus", "");
            });
            $(".todo_statusDrop").find("a").click(function (e) {              
              
                var id = $(this).parent().parent().parent().attr("id");
                var newid = id.replace("_divstatus_drop", "")
              
                if ($(this).data("status") == "Delete")
                {
                    toDo_update("3", $("#" + newid).data("todoid"), $(this).data("status"), 1);
                }
                else {
                    toDo_update("2", $("#" + newid).data("todoid"), $(this).data("status"), 0);
                    removeclasses(newid + "_divstatus", "todo-");
                    // $("#" + todonidnid + "_divstatus").removeClass();
                    $("#" + newid + "_divstatus").addClass("todo-" + $(this).data("status"));

                    $("#" + newid + "_text").removeClass();
                    $("#" + newid + "_text").addClass("todo-text todo-text-" + $(this).data("status"));
                }
               
                $("#"+id).hide();
            });
            $(".todo-text").find("p").click(function (e) {
                var id = $(this).parent().attr("id");
                todo_appendtext(id);
            });

        },
        error: function (x, e) {
            $('#divtotoTaskList').html(x.responseText);
            
            $('#todo_divloader').hide();
            return;
        }

    });
}
function todo_appendtext(id)
{
    var strtxt = '<input type="text" class="txt-todo-text" value="' + $("#" + id).find("p").html() + '" id="' + id + '_txtbox" />';
    $("#" + id).empty();
    $("#" + id).append(strtxt);
    $("#" + id + "_txtbox").focus();

    $("#" + id + "_txtbox").change(function (e) {
        if ($(this).val() != "") {
            var newid = $(this).attr("id");
            newid = newid.replace("_text_txtbox", "");
            toDo_update("4", $("#" + newid).data("todoid"), $(this).val(), 0);
        }

    });

    $("#" + id + "_txtbox").blur(function (e) {
        if ($(this).val() != "") {
           
            var newid = $(this).attr("id");
            newid = newid.replace("_txtbox", "");
            var strnew = "<p>" + $(this).val() + "</p>";
            $(this).remove();
            $("#" + newid).html(strnew);

            $("#" + newid).find("p").click(function (e) {
                todo_appendtext(newid);
            });
        }

    });
}
function toDo_update(action, nid, desc,isfill) {
    var args = { action: action, nid: nid, desc: desc };
  
    $('#todo_divloader').show();
    $.ajax({

        type: "POST",
        url: todopagename + "/updateToDoList",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {

            if (data.d == "1") {

                if (isfill == 1)
                {
                    todo_Fill();
                }
                else {
                    $('#todo_divloader').hide();
                }
               

                
            }
            else {

                alert(data.d);
            }

           
        },
        error: function (x, e) {
            alert("The call to the server side failed. " + x.responseText);
            $('#todo_divloader').hide();
            return;
        }

    });
}
$(document).ready(function () {

    $(".todo-icon").click(function () {

        $(this).find("img").toggleClass("todoup");
        $("#divtodobox").toggle(300);
    });
    $("#todoclose").click(function () {
        $("#divtodobox").hide();
    });
    $("#hidToDodate").datepicker({
        dateFormat: 'mm/dd/yy'
    });


    $("#todoicoCal").click(function () {
        $("#hidToDodate").datepicker("show")
    });



    $("#todo_btnsave").click(function () {
        ToDo_SaveNewTask();

    });
    $("#todo_divnewstatus").click(function (e) {
        $(this).parent().find(".todo_statusDrop").slideToggle();

    });
    $("#todo_divnewstatus").parent().find(".todo_statusDrop").find("a").click(function (e) {
        $("#todo_divnewstatus").removeClass('[class^="status-box todo-"]');

        $("#hidToDoNewStatus").val($(this).data("status"));
        $("#todo_divnewstatus").removeClass();
        $("#todo_divnewstatus").addClass("status-box todo-" + $(this).data("status"));
        $(this).parent().parent().parent().hide();
    });

    todo_Fill();

    $(document).bind('click', function (e) {
        var $clicked = $(e.target);
        if (!$clicked.parents().hasClass("todo_statusDrop") && !$clicked.hasClass("status-box")) {

            $(".todo_statusDrop").hide();
        }

    });

});