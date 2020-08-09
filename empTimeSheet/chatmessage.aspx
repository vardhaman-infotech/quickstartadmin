<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="chatmessage.aspx.cs" Inherits="empTimeSheet.chatmessage" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" type="text/css" href="css/chatMessage.css" />
    <script type="text/javascript">
        var json;
        var jsontasks;
        var pagename = "chatmessage.aspx";

        function funChatMessageGetList()
        {
            var str = "",detailid="";
            $('#chatMessage_Leftloader').show();
            var args = { userid: document.getElementById("hidchatloginid").value };

            $.ajax({

                type: "POST",
                url: pagename+"/getUserList",
                data: JSON.stringify(args),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                cache: false,
                success: function (data) {
                    //Check length of returned data, if it is less than 0 it means there is some status available
                    $('#chatMessage_Leftloader').hide();
                    var jsonarr = $.parseJSON(data.d);
                    if (jsonarr.length > 0) {
                        for (var i in jsonarr) {
                            if (i == 0) {
                              
                                detailid = 'chatMessage_user_' + jsonarr[i].id;
                            }
                            var userimg = "";
                            if (jsonarr[i].imgurl == "" || jsonarr[i].imgurl == "null" || jsonarr[i].imgurl==null)
                            {
                              
                                userimg = "images/no_image.png";
                            }
                            else
                            {
                                userimg = "webfile/profile/thumb/" + jsonarr[i].imgurl;
                            }
                            
                            str = str + ' <li id="chatMessage_user_' + jsonarr[i].id + '" onclick="funChatMessageShowDetail(this.id);"><div class="user-image"> \
                                <img src="' + userimg + '"  /></div> \
                                <div class="user-txt"> \
                                            <h2 id="chatMessage_user_' + jsonarr[i].id + '_name">' + jsonarr[i].name + '</h2> \
                                            <h3>' + jsonarr[i].msg + '</h3>  \
                                            <span>' + jsonarr[i].date + '</span> \
                                        </div></li>';
                        }
                    }
                    document.getElementById("chatMessage_Userlist").innerHTML = str;

                    if(detailid!="")
                    {
                       funChatMessageShowDetail(detailid);
                    }
                },
                error: function (x, e) {
                    alert("The call to the server side failed. " + x.responseText);
                    $('#chatMessage_Leftloader').hide();
                }

            });
            
        }

        function funChatMessageShowDetail(id)
        {
            document.getElementById("chatMessage_chat").innerHTML = "";
            var newid = id.replace("chatMessage_user_", "");

            var str = "";
            $('#chatMessage_Rightloader').show();
            var args = { fromuserid: document.getElementById("hidchatloginid").value, touserid: newid, companyid: document.getElementById("ctl00_ContentPlaceHolder1_hidcompanyid").value };

            $.ajax({

                type: "POST",
                url: pagename + "/getMessage",
                data: JSON.stringify(args),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                cache: false,
                success: function (data) {
                    //Check length of returned data, if it is less than 0 it means there is some status available
                    $('#chatMessage_Rightloader').hide();
                    var jsonarr = $.parseJSON(data.d);
                    if (jsonarr.length > 0) {
                        for (var i in jsonarr) {
                            var userimg = "";
                            if (jsonarr[i].imgurl == "" || jsonarr[i].imgurl == "null" || jsonarr[i].imgurl == null) {
                                userimg = "images/no_image.png";
                            }
                            else {
                                userimg = "webfile/profile/thumb/" + jsonarr[i].imgurl;
                            }
                            if (jsonarr[i].toid == newid) {
                                str = str + '  <li> <div class="user-image"><img src="' + userimg + '" /></div> \
                                        <div class="user-txtbox"><h2 style="float: right; background-color: #2270AA;">' + jsonarr[i].name + '</h2> \
                                            <h3  style="float: left">' + jsonarr[i].chatdate + '</h3> \
                                            <span>' + jsonarr[i].description + '</span>  \
                                        </div> \
                                    </li>';
                            }
                            else {

                                str = str + '  <li> <div class="user-image"><img src="' + userimg + '" /></div> \
                                        <div class="user-txtbox"><h2>'+ jsonarr[i].name + '</h2> \
                                            <h3>' + jsonarr[i].chatdate + '</h3> \
                                            <span>' + jsonarr[i].description + '</span>  \
                                        </div> \
                                    </li>';
                            }
                           
                        }
                    }
                    document.getElementById("chatMessage_chat").innerHTML = str;
                },
                error: function (x, e) {
                    alert("The call to the server side failed. " + x.responseText);
                    $('#chatMessage_Rightloader').hide();
                }


            });

            document.getElementById("chat_message_Username").innerHTML = "chat with " + document.getElementById("chatMessage_user_" + newid + "_name").innerHTML;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input type="hidden" id="hidcompanyid" runat="server" />

    <div class="contentpanel">
        <div class="row">
            <div class="mainChatDiv">
                <div class="col-sm-12 col-md-12 pad ">
                       <div class="col-sm-12 col-md-3">
                    <div class="left-chatbox">
                        <div class="chatmessage">chat message</div>
                        <div class="message-body">
                            <div class="messagebox">
                                <div id="chatMessage_Leftloader" class="chatMessage_loader">
                                    <img src="images/loading.gif" />
                                </div>
                                <ul id="chatMessage_Userlist">
                                    
                                  

                                </ul>
                            </div>
                        </div>

                    </div>
                           </div>
                     <div class="col-sm-12 col-md-9">
                    <div class="right-chatbox">
                        <div class="chatwith" id="chat_message_Username"></div>
                        <div class="chatbody">
                            <div class="chatbox-iner">
                                 <div id="chatMessage_Rightloader" class="chatMessage_loader">
                                    <img src="images/waitimg.gif" />
                                </div>
                                <ul id="chatMessage_chat">
                                  
                                </ul>
                            </div>
                        </div>

                    </div>
                         </div>
                </div>
                <div class="clear"></div>
            </div>
        </div>
    </div>
    <script>
        $(document).ready(function () {
            funChatMessageGetList();
        });
    </script>
</asp:Content>
