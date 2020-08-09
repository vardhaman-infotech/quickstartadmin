<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="Annoncements.aspx.cs" Inherits="empTimeSheet.Annoncements" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="css/announcement_2.0.css" rel="stylesheet" type="text/css" />


    <script type="text/javascript">
        //close all popup
        function closediv() {
            document.getElementById("ctl00_ContentPlaceHolder1_divaddnew").style.display = "none";
            document.getElementById("viewAnnouncement").style.display = "none";
            document.getElementById("otherdiv").style.display = "none";
        }


        //Open add/edit div
        function opendiv() {
            setposition("viewAnnouncement", "10%");
            document.getElementById("viewAnnouncement").style.display = "block";
            document.getElementById("otherdiv").style.display = "block";

        }



        function openAddEdit() {
            setposition("ctl00_ContentPlaceHolder1_divaddnew", "10%");
            document.getElementById("ctl00_ContentPlaceHolder1_divaddnew").style.display = "block";
            document.getElementById("otherdiv").style.display = "block";


            $(".announceIcons img").click(function () {

                var val = $(this).attr("src");
                val1 = val.match(/[^/]*$/)[0];
                val2 = val.match(/[^/]*$/)[0];
                document.getElementById("Announcement_hidicon").value = val2;
                document.getElementById("ctl00_ContentPlaceHolder1_Image1").src = "images/Announcement/" + val2;


            });
        }

        function closeAddEdit() {

            document.getElementById("ctl00_ContentPlaceHolder1_divaddnew").style.display = "none";
            document.getElementById("otherdiv").style.display = "none";
        }



    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>

            <div id="otherdiv" onclick="closediv();">
            </div>
            <pg:progress ID="progress1" runat="server" />

            <!--View announcment's div-->
            <div style="display: none; width: 650px;" id="viewAnnouncement" class="itempopup">
                <div class="popup_heading">
                    <span id="Span1" runat="server">Announcement </span>
                    <div class="f_right">
                        <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
                    </div>
                </div>
                <div class="tabContents">
                    <div class="col-xs-12 clear mar">
                        <div class="announcetopdetail">
                            <div style="float: right; font-family:'open_sans_semibold', Arial, Helvetica, sans-serif;" class="f-right">

                                <span style="color: #0da08b;">@</span>
                                <asp:Label ID="lbladdedon" runat="server" ForeColor="#0da08b"></asp:Label>&nbsp;
                             <img src="images/announce-pic.png" />
                                <asp:Label ID="lbladdedby" runat="server"></asp:Label>
                                <span style="margin-left: 10px;">
                                    <asp:ImageButton ID="editimage" ImageUrl="~/images/edit.png" OnClick="editimage_Click" runat="server" />
                                </span>
                                <asp:LinkButton ID="cid" runat="server"
                                    OnClientClick='return confirm("Delete this record? Yes or no");' OnClick="cid_Click"
                                    ToolTip="Delete" Style="border-right: none;">  <i class="fa fa-fw">
                                                            <img src="images/delete.png" alt=""></i></asp:LinkButton>

                            </div>
                        </div>
                        <div class="clear">
                        </div>

                        <div id="dvTitle" class="col-xs-12 col-sm-12 form-group f_left pad">


                            <div id="annImg" style="float: left; width: 52px; margin-top: -5px;">
                                <asp:Image ID="Image2" runat="server" ImageUrl="~/images/Announcement/calendar.png" />
                            </div>
                            <div id="popupbody" style="margin-left: 70px;">
                                <b>

                                    <asp:Label ID="lblTitle" runat="server" ForeColor="#0da08b" Font-Size="Large" Font-Names="'open_sans_semibold', Arial, Helvetica, sans-serif"></asp:Label></b>&nbsp;<br />
                                <asp:Label ID="lbldesc" runat="server"></asp:Label>
                                <div class="clear">
                                </div>
                            </div>
                            <div class="clear">
                            </div>



                        </div>
                    </div>
                </div>
            </div>
            <!--View announcment's div-->



            <!--Edit announcment's div-->
            <div style="display: none; width: 650px;" runat="server" id="divaddnew" class="itempopup">
                <div class="popup_heading">
                    <span id="legendaction" runat="server">Add New Announcement </span>
                    <div class="f_right">
                        <img src="images/cross.png" onclick="closeAddEdit();" alt="X" title="Close Window" />
                    </div>
                </div>
                <div class="tabContents">

                    <div class="col-xs-12 clear mar">
                        <div id="tradded" runat="server">

                             <div class="ctrlGroup">
                                <label class="lbl">
                                    <input type="hidden" id="hidid" runat="server" />
                                    Added on:
                                </label>
                               <div class="txt w1">
                                   <label class="lbl">
                                      
                                            <asp:Literal ID="litadderon" runat="server"></asp:Literal>
                                    </label>
                                </div>
                            </div>
                            <div class="ctrlGroup searchgroup">
                               <label class="lbl">
                                    Added by:
                                </label>
                               <div class="txt w1">
                                   <label class="lbl">
                                        <asp:Literal ID="litaddesby" runat="server"></asp:Literal>
                                    </label>
                                </div>
                            </div>
                        </div>
                        <div class="clear">
                        </div>
                        <div class="breadcrumb-wrapper mar ">

                            <input type="hidden" id="Hidden2" runat="server" />

                        </div>

                        <%--  <show div of announcement images>--%>
                        <div class="ctrlGroup searchgroup">
                            <label class="lbl">Choose Icon:</label>
                            <div class="txt w1 mar10">
                                <input type="hidden" id="Announcement_hidicon" runat="server" clientidmode="Static" />
                                <asp:Image ID="Image1" runat="server" ImageUrl="~/images/Announcement/bigpic/calendar.png" />

                                <ajaxToolkit:PopupControlExtender ID="PceSelectCustomer" runat="server" TargetControlID="Image1"
                                    PopupControlID="DetailView" Position="Bottom">
                                </ajaxToolkit:PopupControlExtender>

                                <asp:Panel ID="DetailView" runat="server" CssClass="announceIcons-main">

                                    <div id="masterbox" class="announceIcons">
                                        <ul>
                                            <li>
                                                <img onclick="" src="images/Announcement/arrow-down.png" />
                                            </li>
                                            <li>
                                                <img src="images/Announcement/arrow-up.png" /></li>

                                            <li>
                                                <img src="images/Announcement/brightness.png" /></li>
                                            <li>
                                                <img src="images/Announcement/calendar.png" /></li>
                                            <li>
                                                <img src="images/Announcement/camera.png" /></li>
                                            <li>
                                                <img src="images/Announcement/email.png" /></li>
                                            <li>
                                                <img src="images/Announcement/flag.png" /></li>
                                            <li>
                                                <img src="images/Announcement/genius.png" /></li>
                                            <li>
                                                <img src="images/Announcement/parachute.png" /></li>


                                        </ul>
                                    </div>

                                </asp:Panel>


                            </div>
                        </div>
                        <%--  <show div of announcement images>--%>
                        <div class="clear">
                        </div>
                        <div class="ctrlGroup searchgroup">

                            <label class="lbl">Display on:<asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                                    ErrorMessage="*" ControlToValidate="txtdisplayon" CssClass="errmsg" ValidationGroup="saveannousment"></asp:RequiredFieldValidator>
                            </label>
                            <div class="txt w1 mar10">

                                <asp:TextBox ID="txtdisplayon" runat="server" CssClass="form-control hasDatepicker" Style="margin-top: 0px;"></asp:TextBox>

                                <cc1:CalendarExtender ID="cal1" runat="server" TargetControlID="txtdisplayon" PopupButtonID="txtdisplayon"
                                    Format="MM/dd/yyyy">
                                </cc1:CalendarExtender>

                            </div>
                        </div>
                        <div class="ctrlGroup searchgroup">
                            <div class="txt w2">
                            <asp:CheckBox ID="chkavailableToLogin" runat="server" CssClass="checkboxauto" Text="Display on Login page" />
                                </div>
                        </div>
                        <div class="ctrlGroup searchgroup">
                            <label class="lbl">Title:<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txttitle"
                                    ValidationGroup="saveannousment" ErrorMessage="*" CssClass="errmsg"></asp:RequiredFieldValidator>
                            </label>
                            <div class="txt w3">
                                <asp:TextBox ID="txttitle" runat="server" CssClass="form-control" Width="98%" onKeyUp="checkLength(this.id,500);"></asp:TextBox>
                            </div>
                        </div>
                        <div class="ctrlGroup searchgroup">
                            <label class="lbl">Description:<asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                                    ControlToValidate="txtdesc" ErrorMessage="*" ValidationGroup="saveannousment"
                                    CssClass="errmsg"></asp:RequiredFieldValidator>
                            </label>
                            <div class="txt w3">
                                <asp:TextBox ID="txtdesc" runat="server" CssClass="form-control" TextMode="MultiLine"
                                    Width="99%" Height="130px"></asp:TextBox>
                            </div>
                        </div>
                        <div class="ctrlGroup searchgroup">
                            <label class="lbl disNone">&nbsp;</label>
                            
                                <asp:Button ID="btnsubmit" runat="server" Text="Save" CssClass="btn btn-primary"
                                    OnClick="btnsubmit_Click" />
                            
                        </div>
                    </div>
                </div>
            </div>
            <!--  <Edit Annoucement's Div>-->


            <div class="pageheader">
                <h2>
                    <i class="fa fa-volume-up"></i>Announcements
                </h2>
                <div class="breadcrumb-wrapper mar ">
                    <input type="hidden" id="Hidden1" runat="server" />
                    <asp:LinkButton ID="lbtnaddnew" runat="server" class="right_link" OnClick="lbtnaddnew_Click"> <i class="fa fa-fw fa-plus topicon"></i> Add New</asp:LinkButton>
                </div>
                <div class="clear">
                </div>
            </div>
            <!-- Page headings-->
            <div class="contentpanel">
                <div class="row">
                    <div class="col-sm-12 col-md-12">
                        <div class="panel panel-default">
                        

                           <div class="col-sm-12 col-md-10 mar">
                                <div class="ctrlGroup searchgroup">
                                    <label class="lblAuto">Keyword :</label>
                                    <div class="txt w1 mar10">
                                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                               
                             
                               
                               
                                <div class="ctrlGroup searchgroup">
                                    <asp:Button ID="btnsearch" runat="server" CssClass="btn btn-default" Text="Search"
                                        OnClick="btnsearch_Click" />
                                </div>
                            </div>
                            <div class="col-sm-12 col-md-2 mar">
                                <div class="ctrlGroup searchgroup" style="float: right;">
                                    <asp:LinkButton ID="lnkprevious" CssClass="f_left" runat="server" OnClick="lnkprevious_Click">
            <i class="fa fa-fw fa-fast-backward color_green"></i></asp:LinkButton>

                                    <div class="f_left page">
                                        <asp:Label ID="lblstart" runat="server"></asp:Label>
                                        -
                                        <asp:Label ID="lblend" runat="server"></asp:Label>
                                        of <strong>
                                            <asp:Label ID="lbltotalrecord" Font-Bold="true" runat="server"></asp:Label></strong>
                                    </div>
                                    <asp:LinkButton ID="lnknext" CssClass="f_left" runat="server" OnClick="lnknext_Click"><i class="fa fa-fw fa-fast-forward color_green"></i></asp:LinkButton>
                                </div>
                            </div>
                          

                            <div class="clear">
                            </div>
                            <!--List Section-->
                            <!-- col-sm-12 -->
                            <div class="col-sm-12 col-md-12 mar">
                                <div class="panel">
                                    <div class="panel-body2">
                                        <div class="row">
                                            <div class="table-responsive">
                                                <div id="divmsg" runat="Server" class="nodatafound" visible="false">
                                                </div>
                                                <asp:GridView ID="dgnews" runat="server" CssClass="table table-success mb30" AllowPaging="True"
                                                    AutoGenerateColumns="False" ShowHeader="false" ShowFooter="false" PageSize="50"
                                                    CellPadding="4" PagerStyle-Font-Size="15px" PagerSettings-Mode="NumericFirstLast"
                                                    Width="100%" GridLines="None" OnRowCommand="dgnews_RowCommand" OnRowDataBound="dgnews_RowDataBound"
                                                    OnPageIndexChanging="dgnews_PageIndexChanging">
                                                    <Columns>
                                                        <asp:TemplateField ItemStyle-Width="100%">
                                                            <ItemTemplate>
                                                                <%-- <div class="arrow-left">
                                                                </div>--%>
                                                                <div id="announcetop" runat="server" class="AnnounceTable">


                                                                    <div id="divImage" class="AnnounceImage">
                                                                        <img class="child" id="imgannoIcon" runat="server" />
                                                                    </div>
                                                                    <div id="divTitle" class="AnnounceTitle">
                                                                        <h3 class="title">
                                                                            <%# DataBinder.Eval(Container.DataItem, "title")%>
                                                                        </h3>
                                                                    </div>
                                                                    <div id="divDesc" class="AnnounceDesc">
                                                                        <p >
                                                                            <%# DataBinder.Eval(Container.DataItem, "des1")%>
                                                                        </p>
                                                                    </div>



                                                                </div>
                                                                <div id="announcebottom" runat="server" class="AnnounceDetails">
                                                                    <div id="date" class="AnnounceUser">
                                                                        <h4 class="title"><%#Processdate(Eval("adddate")) %></h4>

                                                                    </div>

                                                                    <div id="month" class="AnnounceUser">
                                                                        <h5 class="title"><%#ProcessMonth(Eval("adddate")) %></h5>

                                                                    </div>



                                                                </div>


                                                            </ItemTemplate>
                                                            <ItemStyle Width="100%" />
                                                        </asp:TemplateField>
                                                    </Columns>
                                                    <EmptyDataTemplate>
                                                        abc
                                                    </EmptyDataTemplate>
                                                    <FooterStyle ForeColor="#4A3C8C" />
                                                    <RowStyle CssClass="announce-even" />
                                                    <PagerSettings Mode="NumericFirstLast" />
                                                    <PagerStyle CssClass="inner_table gridpager" HorizontalAlign="Center" />
                                                    <AlternatingRowStyle CssClass="announce-odd" />
                                                </asp:GridView>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- col-sm-12 -->
                            <div class="clear">
                            </div>
                            <!-- panel -->
                        </div>
                    </div>
                </div>
                <!-- row -->
            </div>
            <!-- content panel -->
        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>
