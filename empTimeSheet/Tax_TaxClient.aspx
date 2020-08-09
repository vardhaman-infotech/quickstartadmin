<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="Tax_TaxClient.aspx.cs" Inherits="empTimeSheet.Tax_TaxClient" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">


    <link rel="stylesheet" href="css/jquery-ui.css" />
    <style type="text/css">
        .divlist {
            border: solid 1px #e0e0e0;
            height: 315px;
            width: 220px;
            float: left;
            overflow-y: hidden;
        }

        .divlistinner {
            height: 283px;
            width: 100%;
            float: left;
            overflow-y: auto;
        }

        .tbllist {
            width: 100%;
            margin: 0px;
        }

            .tbllist th {
                border-bottom: solid 1px #e0e0e0;
                background: #e0e0e0;
                color: #000000;
                padding: 5px;
                font-family: "open_sans_semibold",Arial,Helvetica,sans-serif;
                text-align: left;
            }

            .tbllist td {
                padding: 5px;
                text-align: left;
                min-height: 30px;
                border: none;
            }

            .tbllist .form-control {
                height: 25px;
                margin: 0px;
                box-shadow: none;
                width: 95%;
            }

            .tbllist td:hover {
                cursor: pointer;
                background-color: #0078D7;
                color: #ffffff;
            }

        .selectedcell td {
            background-color: #0078D7;
            color: #ffffff;
        }
    </style>
    <script type="text/javascript" src="js/jquery-ui.js"></script>

    <script type="text/javascript" src="js/taxClientjs.js"></script>



</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <pg:progress ID="progress1" runat="server" />

    <input type="hidden" id="hidSelecetedLeft" />
    <input type="hidden" id="hidSelectedRight" />
    <input type="hidden" id="hidfilename" runat="server" />
    <div class="pageheader">
        <h2>
            <i class="fa fa-cube"></i>Tax Client Setup
        </h2>
        <div class="breadcrumb-wrapper">

            <a class="right_link" onclick="blank(); opendiv();">
                <i class="fa fa-fw fa-plus topicon"></i>Add New </a>
            <a class="right_link" onclick="openimport();">
                <i class="fa fa-fw fa-upload topicon"></i>Import </a>
        </div>
        <div class="clear">
        </div>
    </div>

    <div id="divimportsummary_detail" class="itempopup" style="width: 700px; display: none; z-index: 999999;">
        <div class="popup_heading">
            <span id="spandetailtext">Import Summary</span>
            <div class="f_right">
                <img src="images/cross.png" onclick="closedivsummary();" alt="X" title="Close
            Window" />
            </div>
        </div>



        <div style="margin: 10px 15px; max-height: 300px; overflow: auto;">

            <div class="clear"></div>
            <table class="tblsheet tblReport" id="tblsummarydetail">
            </table>
            <div class="clear"></div>

        </div>




        <div class="clear">
        </div>


    </div>


    <div id="divimportsummary" class="itempopup" style="width: 600px; display: none;">
        <div class="popup_heading">
            <span>Import Summary</span>
            <div class="f_right">
                <img src="images/cross.png" onclick="closediv();" alt="X" title="Close
            Window" />
            </div>
        </div>



        <div style="margin: 10px 15px;">

            <div class="clear"></div>
            <table class="tblsheet tblReport" style="border-top: solid 1px #e0e0e0; text-align: center; font-size: 14px;">
                <tr>
                    <td colspan="2" style="color: #1caf9a; font-family: 'open_sans_semibold';">Data successfully imported, import summary is as:</td>
                </tr>
                <tr>
                    <th>Total Submitted Records :</th>
                    <td id="tdtotalsub" style="width: 80px; text-align: center; font-family: 'open_sans_semibold';"></td>
                </tr>
                <tr>
                    <th>New Records Inserted :</th>
                    <td id="tdnewrecord" style="text-align: center; font-family: 'open_sans_semibold';"></td>
                </tr>
                <tr>
                    <th>Old Records Updated :</th>
                    <td id="tdoldrecord" style="text-align: center; font-family: 'open_sans_semibold';"></td>
                </tr>
                <tr>
                    <th>Error in Records :</th>
                    <td id="tderrorinrecord" style="text-align: center; font-family: 'open_sans_semibold';"></td>
                </tr>
            </table>
            <div class="clear"></div>

        </div>




        <div class="clear">
        </div>


    </div>


    <div id="divimport" class="itempopup" style="width: 600px; display: none;">
        <div class="popup_heading">
            <span>Import Tax Clients</span>
            <div class="f_right">
                <img src="images/cross.png" onclick="closediv();" alt="X" title="Close
            Window" />
            </div>
        </div>


        <div style="margin: 10px 15px;" id="divselectfile">

            <div class="ctrlGroup">
                <label class="lbl lbl4">
                    Select Excel File : *<br />
                    (.xlsx, .xls, .xlsm) 
                </label>

                <div class="txt w2" >
                    <input type="button" value="Select a File" id="btn" onclick="Attachment_openupload();" class="btn-primary" />

                    <iframe src="uploadimport.aspx" id="ifuploadfile" style="display: none;"></iframe>


                </div>
                <div style="float: left; margin-left: 2px;" id="divattachfilename">
                </div>


            </div>

        </div>
        <div style="margin: 10px 15px; display: none;" id="divselectcol">
            <div style="padding: 10px 15px; font-family: 'open_sans_semibold';">
                * Now select the fields and associated columns where imported information is located in the excel work sheet
            </div>
            <div class="clear"></div>
            <div class="col-sm-12 col-md-5">
                <div class="divlist">
                    <table class="tbllist">
                        <thead>
                            <tr>
                                <th>Fields
                                </th>
                            </tr>
                        </thead>
                    </table>
                    <div class="divlistinner">
                        <table class="tbllist" id="tblleft">

                            <tbody>
                                <%=strimportcol %>
                            </tbody>

                        </table>
                    </div>

                </div>
            </div>
            <div class="col-sm-12 col-md-2" style="padding-top: 20%; text-align: center;">
                <input type="button" onclick="move('right');"
                    class="btn btn-default " style="width: 40px; padding: 2px;" value=">>" id="btnAddtoList"
                    runat="server" />
                <br />
                <input type="button" onclick="move('left');"
                    class="btn btn-default mar" style="width: 40px; padding: 2px;" value="<<"
                    id="btnRemovefromList" runat="server" />
            </div>
            <div class="col-sm-12 col-md-5">

                <div class="divlist">
                    <table class="tbllist">
                        <thead>
                            <tr>
                                <th>Fields
                                </th>
                                <th width="80px">Column
                                </th>
                            </tr>
                        </thead>
                    </table>
                    <div class="divlistinner">
                        <table class="tbllist" id="tblright">
                        </table>
                    </div>

                </div>
            </div>
            <div class="clear"></div>
            <div style="text-align: center; margin-top: 20px;">
                <a class="btn btn-default btn-primary" onclick="saveimport();">Import</a>
            </div>
        </div>




        <div class="clear">
        </div>


    </div>

    <div id="divaddnew" class="itempopup" style="width: 730px; display: none;">
        <div class="popup_heading">
            <span>Add/Edit Tax Client</span>
            <div class="f_right">
                <img src="images/cross.png" onclick="closediv();" alt="X" title="Close
            Window" />
            </div>
        </div>

        <div class="clear">
        </div>

        <div style="margin: 10px 0px;">
            <div class="ctrlfloatnone">
                <label class="col-sm-2 col-xs-12 lbl">
                    Client Name : *
                </label>
                <div class="txt col-sm-8 col-xs-12">

                    <asp:TextBox ID="txtproject" runat="server" CssClass="form-control"></asp:TextBox>
                    <input type="hidden" id="hidproject" runat="server" />
                </div>
            </div>
            <div class="clear">
            </div>
            <div class="ctrlfloatnone">
                <label class="col-sm-2 col-xs-12 lbl">
                    Address :
                </label>
                <div class="txt col-sm-8 col-xs-12 ">

                    <asp:TextBox ID="txtaddress" runat="server" CssClass="form-control"></asp:TextBox>

                </div>
            </div>
            <div class="clear">
            </div>
            <div class="ctrlfloatnone">
                <label class="col-sm-2 col-xs-12 lbl">
                    &nbsp;
                </label>
                <div class="txt col-sm-3 col-xs-12">

                    <asp:TextBox ID="txtcity" runat="server" CssClass="form-control" placeholder="City"></asp:TextBox>

                </div>
                <div class="txt col-sm-2 col-xs-12">

                    <asp:TextBox ID="txtstate" runat="server" CssClass="form-control" placeholder="State"></asp:TextBox>

                </div>
                <div class="txt col-sm-3 col-xs-12">

                    <asp:TextBox ID="txtzip" runat="server" CssClass="form-control" placeholder="Zip"></asp:TextBox>

                </div>
            </div>
            <div class="clear">
            </div>
            <div class="ctrlfloatnone">
                <label class="col-sm-2 col-xs-12 lbl">
                    Email :
                </label>
                <div class="txt col-sm-3 col-xs-12">

                    <asp:TextBox ID="txtemail" runat="server" CssClass="form-control"></asp:TextBox>
                    <input type="hidden" id="Hidden5" runat="server" />
                </div>
                <label class="col-sm-2 col-xs-12 lbl lbl1">
                    Phone :
                </label>
                <div class="txt col-sm-3 col-xs-12">

                    <asp:TextBox ID="txtphone" runat="server" CssClass="form-control"></asp:TextBox>
                    <input type="hidden" id="Hidden6" runat="server" />
                </div>
            </div>
            <div class="clear">
            </div>
            <div class="ctrlfloatnone">
                <label class="col-sm-2 col-xs-12 lbl">
                    Tax Type : 
                </label>
                <div class="txt col-sm-3 col-xs-12">
                    <asp:DropDownList ID="droptaxtype" runat="server" CssClass="form-control">
                    </asp:DropDownList>
                </div>
                <label class="col-sm-2 col-xs-12 lbl lbl1">
                    Type : 
                </label>
                <div class="txt col-sm-3 col-xs-12 lbl">
                    <asp:DropDownList ID="droptype" runat="server" CssClass="form-control">
                    </asp:DropDownList>
                </div>
            </div>
            <div class="clear">
            </div>
            <div id="divinsdata">
                <div class="ctrlfloatnone">
                    <label class="col-sm-2 col-xs-12 lbl">
                        Tax Year : *
                    </label>
                    <div class="txt col-sm-3 col-xs-12">
                        <asp:TextBox ID="txttaxyear" runat="server" CssClass="form-control" onkeypress="blockNonNumbers(this, event, true, true);" onkeyup="extractNumber(this,0,true);" onblur="fillbytaxyear();"></asp:TextBox>
                    </div>
                    <label class="col-sm-2 col-xs-12 lbl lbl1">
                        Tax Form : 
                    </label>
                    <div class="txt col-sm-3 col-xs-12">
                        <asp:DropDownList ID="drotaxform" runat="server" CssClass="form-control">
                        </asp:DropDownList>
                    </div>
                </div>

                <div class="clear">
                </div>
                <div class="ctrlfloatnone">
                    <label class="col-sm-2 col-xs-12 lbl">
                        F.Y. Ending : 
                    </label>
                    <div class="txt col-sm-3 col-xs-12">
                        <asp:TextBox ID="txtfyyear" runat="server" CssClass="form-control hasDatepicker" onchange="checkdate(this.value,this.id);"></asp:TextBox>


                        <ajax:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtfyyear"
                            PopupButtonID="txtfyyear" Format="MM/dd/yyyy">
                        </ajax:CalendarExtender>
                    </div>
                    <label class="col-sm-2 col-xs-12 lbl lbl1">
                        Due Date : 
                    </label>
                    <div class="txt col-sm-3 col-xs-12">
                        <asp:TextBox ID="txtduedate" runat="server" CssClass="form-control hasDatepicker" onchange="checkdate(this.value,this.id);"></asp:TextBox>
                        <ajax:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtduedate"
                            PopupButtonID="txtduedate" Format="MM/dd/yyyy">
                        </ajax:CalendarExtender>
                    </div>
                </div>
                <div class="clear">
                </div>

                <div class="ctrlfloatnone">
                    <label class="col-sm-2 col-xs-12 lbl">
                        Tax Paid : 
                    </label>
                    <div class="txt col-sm-3 col-xs-12">
                        <asp:TextBox ID="txtlastyear" runat="server" CssClass="form-control" onkeypress="blockNonNumbers(this, event, true, true);" onkeyup="extractNumber(this,2,true);"></asp:TextBox>
                    </div>
                    <label class="col-sm-2 col-xs-12 lbl lbl1">
                        Refund : 
                    </label>
                    <div class="txt col-sm-3 col-xs-12">
                        <asp:TextBox ID="txtrefund" runat="server" CssClass="form-control" onkeypress="blockNonNumbers(this, event, true, true);" onkeyup="extractNumber(this,2,true);"></asp:TextBox>
                    </div>
                </div>
                <div class="clear">
                </div>

                <div class="ctrlfloatnone">
                    <label class="col-sm-2 col-xs-12 lbl">
                        AGI : 
                    </label>
                    <div class="txt col-sm-3 col-xs-12">
                        <asp:TextBox ID="txtprevaig" runat="server" CssClass="form-control" onkeypress="blockNonNumbers(this, event, true, true);" onkeyup="extractNumber(this,2,true);"></asp:TextBox>
                    </div>
                    <label class="col-sm-2 col-xs-12 lbl lbl1">
                        Total Tax : 
                    </label>
                    <div class="txt col-sm-3 col-xs-12 lbl">
                        <asp:TextBox ID="txtpretotax" runat="server" CssClass="form-control" onkeypress="blockNonNumbers(this, event, true, true);" onkeyup="extractNumber(this,2,true);"></asp:TextBox>
                    </div>
                </div>
            </div>
            <div class="clear"></div>
            <div class="ctrlfloatnone">
                <label class="col-sm-2 col-xs-12 lbl">
                    &nbsp;
                </label>
                <div class="txt col-sm-10 col-xs-12">
                    <input type="button" value="Save" onclick="savedata();" class="btn btn-primary" />
                </div>
            </div>
        </div>




        <div class="clear">
        </div>


    </div>


    <div id="otherdiv" onclick="closediv();">
    </div>
    <div id="otherdivimport" onclick="closedivsummary();" style="z-index: 99999;" class="otherdiv">
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
                                    <label class="lbl lbl2">Tax Client :</label>
                                    <div class="txt w1 mar10">
                                        <asp:TextBox ID="txttaxclient" runat="server" CssClass="form-control"></asp:TextBox>

                                    </div>
                                </div>
                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl lbl2">Tax Year :</label>
                                    <div class="txt w1 mar10">
                                        <asp:DropDownList ID="droptaxyear" runat="server" CssClass="form-control"></asp:DropDownList>
                                    </div>
                                </div>





                                <div class="ctrlGroup searchgroup">
                                    <asp:Button ID="btnsearch" runat="server" CssClass="btn btn-default" Text="Search"
                                        OnClick="btnsearch_Click" />
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


                                            <div class="table-responsive" style="min-height: 300px;">
                                                <asp:GridView ID="dgnews" runat="server" AllowPaging="false" AutoGenerateColumns="False"
                                                    PageSize="50" CellPadding="4" CellSpacing="0" Width="100%" ShowHeader="true"
                                                    ShowFooter="false" CssClass="tblreport" GridLines="None"
                                                    OnRowDataBound="dgnews_RowDataBound" OnRowCommand="dgnews_RowCommand">
                                                    <Columns>

                                                        <asp:TemplateField HeaderText="Client Name">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"name")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>


                                                        <asp:TemplateField HeaderText="Tax Year">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"taxYear")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Tax Type">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"taxtype")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Type">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"typetitle")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Tax Form">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"FromName")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="F.Y. Ending">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"yearEndDate")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Due date">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"dueDate")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="70px">
                                                            <ItemTemplate>
                                                                <a onclick='editcompany(<%#DataBinder.Eval(Container.DataItem,"nid")%>,"<%#DataBinder.Eval(Container.DataItem,"taxyear")%>");'>
                                                                    <i class="fa fa-fw">
                                                                        <img src="images/edit.png">
                                                                </a>

                                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                                <asp:LinkButton ID="lbtndelete" CommandName="remove" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>'
                                                                    ToolTip="Delete" runat="server" 
                                                                    OnClientClick='return confirm("Delete this record? Ok or Cancel");'><i class="fa fa-fw" >
                                                            <img src="images/delete.png" alt=""></i></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                    </Columns>
                                                    <HeaderStyle CssClass="gridheader" />
                                                    <PagerStyle CssClass="gridpager" HorizontalAlign="Center" />
                                                </asp:GridView>


                                                <div class="nodatafound" id="nodata" runat="server">
                                                    No data found
                                                </div>
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






    <script type="text/javascript">







        function opendiv() {
            setposition("divaddnew");
            document.getElementById("divaddnew").style.display = "block";
            document.getElementById("otherdiv").style.display = "block";
        }
        function closediv() {

            document.getElementById("divaddnew").style.display = "none";
            document.getElementById("otherdiv").style.display = "none";
            $('#divimport').hide();
            $('#divimportsummary').hide();


        }



    </script>

</asp:Content>
