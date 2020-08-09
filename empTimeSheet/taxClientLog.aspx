<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="taxClientLog.aspx.cs" Inherits="empTimeSheet.taxClientLog" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="css/jquery-ui.css" />
    <link rel="stylesheet" href="css/taxlogcss.css" />
    <script type="text/javascript" src="js/jquery-ui.js"></script>




</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <pg:progress ID="progress1" runat="server" />


    <div class="pageheader">
        <h2>
            <i class="fa fa-cube"></i>Tax Client Log
        </h2>
        <div class="breadcrumb-wrapper">

            <a class="right_link" onclick="openaddnew();">
                <i class="fa fa-fw fa-plus topicon"></i>Add New Log </a>
        </div>
        <div class="clear">
        </div>
    </div>


    <div id="divaddnew" class="itempopup" style="width: 500px; display: none;">
        <div class="popup_heading">
            <span>Add/Edit Log</span>
            <div class="f_right">
                <img src="images/cross.png" onclick="closediv();" alt="X" title="Close
            Window" />
            </div>
        </div>



        <div style="margin: 20px;">


            <div class="tabone">
                <div class="radiobox">
                    <div class="radeo">
                        <input type="checkbox" id="taxradion_1" name="radionbtnaction" onchange="showaction(this.id,this.value);" value="1" />
                    </div>
                    <div class="radeo-hding">
                        Initial Communication
                    </div>
                </div>

                <div class="taxlogfieldbox" id="taxradion_divtaxlog_1">
                    <div class="ctrlGroup">
                        <label class="lbl lbl2">Medium :</label>
                        <div class="txt w1 mar10">
                            <select id="dropmediam1" class="form-control">

                                <option value="Phone">Phone</option>
                                <option value="Email">Email</option>
                            </select>
                        </div>
                    </div>
                    <div class="clear"></div>
                    <div class="ctrlGroup">
                        <label class="lbl lbl2">Date :</label>
                        <div class="txt w1">

                            <asp:TextBox ID="txtdate1" runat="server" CssClass="form-control hasDatepicker" onchange="checkdate(this.value,this.id);"></asp:TextBox>
                            <ajax:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtdate1"
                                PopupButtonID="txtdate1" Format="MM/dd/yyyy">
                            </ajax:CalendarExtender>
                        </div>
                    </div>

                    <div class="clear"></div>

                </div>
            </div>
            <div class="clear"></div>
            <div class="tabone">
                <div class="radiobox">
                    <div class="radeo">
                        <input type="checkbox" id="taxradion_2" name="radionbtnaction" onchange="showaction(this.id,this.value);" value="2" />
                    </div>
                    <div class="radeo-hding">
                        Documents Received 
                    </div>
                </div>

                <div class="taxlogfieldbox" id="taxradion_divtaxlog_2">
                    <div class="ctrlGroup">
                        <label class="lbl lbl2">Medium :</label>
                        <div class="txt w1 mar10">
                            <select id="dropmediam2" class="form-control">
                                <option value="Physical">Physical</option>
                                <option value="Phone">Phone</option>
                                <option value="Email">Email</option>
                            </select>
                        </div>
                    </div>
                    <div class="clear"></div>
                    <div class="ctrlGroup">
                        <label class="lbl lbl2">Date :</label>
                        <div class="txt w1">

                            <asp:TextBox ID="txtdate2" runat="server" CssClass="form-control hasDatepicker" onchange="checkdate(this.value,this.id);"></asp:TextBox>
                            <ajax:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtdate2"
                                PopupButtonID="txtdate2" Format="MM/dd/yyyy">
                            </ajax:CalendarExtender>
                        </div>
                    </div>

                    <div class="clear"></div>

                </div>
            </div>

            <div class="clear"></div>
            <div class="tabone">
                <div class="radiobox">
                    <div class="radeo">
                        <input type="checkbox" id="taxradion_3" name="radionbtnaction" onchange="showaction(this.id,this.value);" value="3" />
                    </div>
                    <div class="radeo-hding">
                        Communication with client
                    </div>
                </div>

                <div class="taxlogfieldbox" id="taxradion_divtaxlog_3">
                    <div class="ctrlGroup">
                        <label class="lbl lbl2">Comments :</label>
                        <div class="txt w2">
                            <input type="text" id="txtcomment3" class="form-control" />

                        </div>
                    </div>
                    <div class="clear"></div>
                    <div class="ctrlGroup">
                        <label class="lbl lbl2">Date :</label>
                        <div class="txt w1">

                            <asp:TextBox ID="txtdate3" runat="server" CssClass="form-control hasDatepicker" onchange="checkdate(this.value,this.id);"></asp:TextBox>
                            <ajax:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtdate3"
                                PopupButtonID="txtdate3" Format="MM/dd/yyyy">
                            </ajax:CalendarExtender>
                        </div>
                    </div>

                    <div class="clear"></div>

                </div>
            </div>

            <div class="clear"></div>
            <div class="tabone">
                <div class="radiobox">
                    <div class="radeo">
                        <input type="checkbox" id="taxradion_4" name="radionbtnaction" onchange="showaction(this.id,this.value);" value="4" />
                    </div>
                    <div class="radeo-hding">
                        Draft Return Ready
                    </div>
                </div>

                <div class="taxlogfieldbox" id="taxradion_divtaxlog_4">
                    <div class="ctrlGroup">
                        <label class="lbl">Date :</label>
                        <div class="txt w1">
                            <asp:TextBox ID="txtdate4" runat="server" CssClass="form-control hasDatepicker" onchange="checkdate(this.value,this.id);"></asp:TextBox>
                            <ajax:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtdate4"
                                PopupButtonID="txtdate4" Format="MM/dd/yyyy">
                            </ajax:CalendarExtender>

                        </div>
                    </div>
                    <div class="clear"></div>
                    <div class="ctrlGroup">
                        <label class="lbl">Prepared By :</label>
                        <div class="txt w1">

                            <asp:DropDownList ID="droppreperedby4" runat="server" CssClass="form-control"></asp:DropDownList>
                        </div>
                    </div>


                    <div class="clear"></div>
                </div>
            </div>
            <div class="clear"></div>
            <div class="tabone">
                <div class="radiobox">
                    <div class="radeo">
                        <input type="checkbox" id="taxradion_5" name="radionbtnaction" onchange="showaction(this.id,this.value);" value="5" />
                    </div>
                    <div class="radeo-hding">
                        Return Finalized
                    </div>
                </div>

                <div class="taxlogfieldbox" id="taxradion_divtaxlog_5">
                    <div class="ctrlGroup">
                        <label class="lbl lbl2">Date :</label>
                        <div class="txt w1">
                            <asp:TextBox ID="txtdate5" runat="server" CssClass="form-control hasDatepicker" onchange="checkdate(this.value,this.id);"></asp:TextBox>
                            <ajax:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtdate5"
                                PopupButtonID="txtdate5" Format="MM/dd/yyyy">
                            </ajax:CalendarExtender>

                        </div>
                    </div>
                    <div class="clear"></div>
                    <div class="ctrlGroup">
                        <label class="lbl lbl2">Finalized by :</label>
                        <div class="txt w1">

                            <asp:DropDownList ID="dropfinilizedby5" runat="server" CssClass="form-control"></asp:DropDownList>
                        </div>
                    </div>

                    <div class="clear"></div>

                </div>
            </div>

            <div class="clear"></div>
            <div class="tabone">
                <div class="radiobox">
                    <div class="radeo">
                        <input type="checkbox" id="taxradion_6" name="radionbtnaction" onchange="showaction(this.id,this.value);" value="6" />
                    </div>
                    <div class="radeo-hding">
                        Efile Authorization
                    </div>
                </div>

                <div class="taxlogfieldbox" id="taxradion_divtaxlog_6">
                    <div class="ctrlGroup">
                        <label class="lbl">Date Sent :</label>
                        <div class="txt w1">
                            <asp:TextBox ID="txtdate61" runat="server" CssClass="form-control hasDatepicker" onchange="checkdate(this.value,this.id);"></asp:TextBox>
                            <ajax:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtdate61"
                                PopupButtonID="txtdate61" Format="MM/dd/yyyy">
                            </ajax:CalendarExtender>

                        </div>
                    </div>
                    <div class="clear"></div>
                    <div class="ctrlGroup">
                        <label class="lbl">Date Received :</label>
                        <div class="txt w1">

                            <asp:TextBox ID="txtdate62" runat="server" CssClass="form-control hasDatepicker" onchange="checkdate(this.value,this.id);"></asp:TextBox>
                            <ajax:CalendarExtender ID="CalendarExtender7" runat="server" TargetControlID="txtdate62"
                                PopupButtonID="txtdate62" Format="MM/dd/yyyy">
                            </ajax:CalendarExtender>
                        </div>
                    </div>

                    <div class="clear"></div>

                </div>
            </div>
            <div class="clear"></div>
            <div class="tabone">
                <div class="radiobox">
                    <div class="radeo">
                        <input type="checkbox" id="taxradion_7" name="radionbtnaction" onchange="showaction(this.id,this.value);" value="7" />
                    </div>
                    <div class="radeo-hding">
                        Efile
                    </div>
                </div>

                <div class="taxlogfieldbox" id="taxradion_divtaxlog_7">
                    <div class="ctrlGroup">
                        <label class="lbl lbl2">Date :</label>
                        <div class="txt w1">
                            <asp:TextBox ID="txtdate7" runat="server" CssClass="form-control hasDatepicker" onchange="checkdate(this.value,this.id);"></asp:TextBox>
                            <ajax:CalendarExtender ID="CalendarExtender8" runat="server" TargetControlID="txtdate7"
                                PopupButtonID="txtdate7" Format="MM/dd/yyyy">
                            </ajax:CalendarExtender>

                        </div>
                    </div>

                    <div class="clear"></div>


                </div>
            </div>
            <div class="clear"></div>
            <div class="tabone">
                <div class="radiobox">
                    <div class="radeo">
                        <input type="checkbox" id="taxradion_8" name="radionbtnaction" onchange="showaction(this.id,this.value);" value="8" />
                    </div>
                    <div class="radeo-hding">
                        Extension Requested
                    </div>
                </div>

                <div class="taxlogfieldbox" id="taxradion_divtaxlog_8">
                    <div class="ctrlGroup">
                        <label class="lbl lbl4">Extension organizer sent :</label>
                        <div class="txt w1">
                            <select id="dropmediam8" class="form-control">
                                <option value="Yes">Yes</option>
                                <option value="No">No</option>

                            </select>

                        </div>
                    </div>
                    <div class="clear"></div>
                    <div class="ctrlGroup">
                        <label class="lbl lbl4">Date :</label>
                        <div class="txt w1">

                            <asp:TextBox ID="txtdate8" runat="server" CssClass="form-control hasDatepicker" onchange="checkdate(this.value,this.id);"></asp:TextBox>
                            <ajax:CalendarExtender ID="CalendarExtender10" runat="server" TargetControlID="txtdate8"
                                PopupButtonID="txtdate8" Format="MM/dd/yyyy">
                            </ajax:CalendarExtender>
                        </div>
                    </div>

                    <div class="clear"></div>

                </div>
                <div class="clear"></div>
            </div>

            <div class="clear"></div>
            <div class="tabone">
                <div class="radiobox">
                    <div class="radeo">
                        <input type="checkbox" id="taxradion_9" name="radionbtnaction" onchange="showaction(this.id,this.value);" value="9" />
                    </div>
                    <div class="radeo-hding">
                        Extension Filed
                    </div>
                </div>

                <div class="taxlogfieldbox" id="taxradion_divtaxlog_9">
                    <div class="ctrlGroup">
                        <label class="lbl lbl4">Payment with Extension :</label>
                        <div class="txt w1">
                            <select id="dropmediam9" class="form-control">
                                <option value="Yes">Yes</option>
                                <option value="No">No</option>

                            </select>

                        </div>
                    </div>
                    <div class="clear"></div>
                    <div class="ctrlGroup">
                        <label class="lbl lbl4">Amount Paid :</label>
                        <div class="txt w1">
                            <input type="text" id="txtamount9" class="form-control" />

                        </div>
                    </div>
                    <div class="clear"></div>
                    <div class="ctrlGroup">
                        <label class="lbl lbl4">Date :</label>
                        <div class="txt w1">

                            <asp:TextBox ID="txtdate9" runat="server" CssClass="form-control hasDatepicker" onchange="checkdate(this.value,this.id);"></asp:TextBox>
                            <ajax:CalendarExtender ID="CalendarExtender9" runat="server" TargetControlID="txtdate9"
                                PopupButtonID="txtdate9" Format="MM/dd/yyyy">
                            </ajax:CalendarExtender>
                        </div>
                    </div>

                    <div class="clear"></div>

                </div>
            </div>

            <div class="clear"></div>
            <div class="tabone">
                <div class="radiobox">
                    <div class="radeo">
                        <input type="checkbox" id="taxradion_10" name="radionbtnaction" onchange="showaction(this.id,this.value);" value="10" />
                    </div>
                    <div class="radeo-hding">
                        Further Documents Received
                    </div>
                </div>

                <div class="taxlogfieldbox" id="taxradion_divtaxlog_10">
                    <div class="ctrlGroup">
                        <label class="lbl lbl4">Medium :</label>
                        <div class="txt w1">
                            <select id="dropmediam10" class="form-control">
                                <option value="Physical">Physical</option>
                                <option value="Phone">Phone</option>
                                <option value="Email">Email</option>

                            </select>

                        </div>
                    </div>
                    <div class="clear"></div>
                    <div class="ctrlGroup">
                        <label class="lbl lbl4">Date :</label>
                        <div class="txt w1">

                            <asp:TextBox ID="txtdate10" runat="server" CssClass="form-control hasDatepicker" onchange="checkdate(this.value,this.id);"></asp:TextBox>
                            <ajax:CalendarExtender ID="CalendarExtender11" runat="server" TargetControlID="txtdate10"
                                PopupButtonID="txtdate10" Format="MM/dd/yyyy">
                            </ajax:CalendarExtender>
                        </div>
                    </div>
                    <div class="clear"></div>


                </div>
            </div>
            <div class="clear"></div>


            <div class="ctrlGroup">
                <label class="lbl lbl2">Remark :</label>
                <div class="txt w2">

                    <asp:TextBox ID="txtremark" runat="server" CssClass="form-control" TextMode="MultiLine" Height="50px"></asp:TextBox>

                </div>
            </div>
            <div class="clear"></div>

            <div class="ctrlGroup">
                <div class="radiobox">
                    <label class="lbl lbl2">&nbsp;</label>
                    <div class="radeo-hding">
                        <input type="button" value="Save" onclick="savedata();" class="btn btn-primary" />
                    </div>
                </div>

            </div>




        </div>




        <div class="clear">
        </div>


    </div>

    <div id="otherdiv" onclick="closediv();">
    </div>


    <div class="contentpanel">


        <input type="hidden" id="hidid" runat="server" />
        <div class="row">
            <div class="col-sm-12 col-md-12">
                <div class="panel panel-default">
                    <asp:UpdatePanel ID="updatedata" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <div class="col-sm-12 col-md-10 mar">
                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl lbl2">Tax Year :</label>
                                    <div class="txt w1 mar10">
                                        <asp:DropDownList ID="txtyear" runat="server" CssClass="form-control" onchange="fillproject();"></asp:DropDownList>

                                    </div>
                                </div>
                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl lbl2">Tax Client :</label>
                                    <div class="txt w2 mar10">
                                        <asp:DropDownList ID="txttaxclient" runat="server" CssClass="form-control" onchange="filltaxlog();"></asp:DropDownList>
                                    </div>
                                </div>
                            </div>

                            <div class="clear">
                            </div>
                            <div class="col-sm-12 col-md-12 mar">

                                <div class="clear">
                                </div>
                                <div class="panel panel-default">
                                    <div class="panel-body2 ">
                                        <div class="row">
                                            <div class="table-responsive" style="min-height: 300px; display: none;" id="divdata">

                                                <table width="100%" class="tbllog " id="tblogdata">
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    <div class="clear">
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="js/PageJs/taxClientLogjs.js" type="text/javascript"></script>
</asp:Content>

