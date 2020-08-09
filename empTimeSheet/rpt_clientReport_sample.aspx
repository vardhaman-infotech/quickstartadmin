<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="rpt_clientReport_sample.aspx.cs" Inherits="empTimeSheet.rpt_clientReport_sample" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .spanemp {
            -moz-border-bottom-colors: none;
            -moz-border-left-colors: none;
            -moz-border-right-colors: none;
            -moz-border-top-colors: none;
            background: #ffffff none repeat scroll 0 0;
            border-color: #5b5b5b #f2f2f2 #f2f2f2 #797979;
            border-image: none;
            border-style: outset;
            border-width: 1px;
            color: #8a693f;
            font-size: 15px;
        }

        .table tr {
            border: 1px solid #ffffff;
            background: #f2f2f2 none repeat scroll 0 0;
        }
    </style>
   
    <script type="text/javascript">
        function validatereport(source, args) {

            var clientid = "ctl00_ContentPlaceHolder1_drpclient";
            var projectid = "ctl00_ContentPlaceHolder1_dropproject";
            var selectedclient = document.getElementById(clientid).value;
            var selectedproject = document.getElementById(projectid).value;

            if (selectedclient != "" || selectedproject != "") {
                args.IsValid = true;
            }
            else {

                args.IsValid = false;
            }
            return;
        }
    </script>
       <script>
           function searchdata(event, id, id2) {

               var keyword = $('#' + id).val();

               $('#' + id2 + ' li').each(function () {

                   if (keyword == "") {
                       $(this).css("display", "block");
                   }
                   else {
                       if ($(this).find('label').text().toLowerCase().indexOf(keyword) >= 0) {
                           $(this).css("display", "block");
                       }
                       else {
                           $(this).css("display", "none");
                       }

                   }

               });
           }

                                    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    
    <div id="otherdiv" onclick="closediv();">
    </div>
    <div class="pageheader">
        <h2>
            <i class="fa fa-table"></i><asp:Literal ID="reportname1" runat="server" Text="Client Report"></asp:Literal>
        </h2>
         <div class="breadcrumb-wrapper mar ">
            <asp:LinkButton ID="btnexportcsv" runat="server" OnClick="btnexportcsv_Click" CssClass="right_link">
            <i class="fa fa-fw fa-file-excel-o topicon"></i>Export to Excel</asp:LinkButton>
           
        </div>
        <input type="hidden" id="hidid" runat="server" />
        
        <div class="clear">
        </div>
    </div>
    <div class="contentpanel">
        <div class="row">
            <div class="col-sm-12 col-md-12">
                <div class="panel panel-default">
                    <div class="col-sm-12 col-md-10">
                        <div style="padding-top: 10px;">
                            <div class="col-xs-12 col-sm-8 col-md-8 f_left" style="padding: 0px;">
                                <h5 class="subtitle mb5"><asp:Literal ID="reportname" runat="server" Text="Time & Expense Detail by Client & Project"></asp:Literal></h5>
                            </div>
                            <div class="clear col-sm-6 col-md-4 pad4">
                                <%-- <asp:CustomValidator ID="req1" runat="server" ClientValidationFunction="validatereport" ValidationGroup="search" ErrorMessage="Select a client or project!"></asp:CustomValidator>--%>
                            </div>
                            <div class="clear"></div>
                            <div class="divsearch">
                                <label class="lblleft">
                                    From Date
                                </label>

                                <asp:TextBox ID="txtfrmdate" runat="server" CssClass="form-control hasDatepicker" onchange="comparedate(this.id,'ctl00_ContentPlaceHolder1_txtfrmdate','ctl00_ContentPlaceHolder1_txttodate');"></asp:TextBox>

                                <cc1:CalendarExtender ID="txtDate_CalendarExtender" runat="server" TargetControlID="txtfrmdate"
                                    PopupButtonID="txtfrmdate" Format="MM/dd/yyyy">
                                </cc1:CalendarExtender>

                            </div>
                            <div class="divsearch">
                                <label class="lblleft">
                                    To Date
                                </label>

                                <asp:TextBox ID="txttodate" runat="server" CssClass="form-control hasDatepicker" onchange="comparedate(this.id,'ctl00_ContentPlaceHolder1_txtfrmdate','ctl00_ContentPlaceHolder1_txttodate');"></asp:TextBox>

                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txttodate"
                                    PopupButtonID="txttodate" Format="MM/dd/yyyy">
                                </cc1:CalendarExtender>

                            </div>
                            <div class="linkadvancesearch">
                                <a onclick="  $('.divadvancesearch').toggle(300);">Advance search?</a>
                            </div>

                            <div id="divadvance" class="divadvancesearch">
                                <div class="divsearch">
                                    <label class="lblleft">
                                        Employee
                                    </label>
                                    <asp:TextBox ID="txtemployee" runat="server" CssClass="form-control mar pad3" placeholder="--All Employee--" ClientIDMode="Static" onkeyup="searchdata(event,this.id,'dropemployee');" onchange="setcontent('dropemployee',this.id,'--All Employee--','employee');">
                                    </asp:TextBox>
                                 

                                    <ajaxToolkit:PopupControlExtender ID="PceSelectCustomer" runat="server" TargetControlID="txtemployee"
                                        PopupControlID="panelemployee" Position="Bottom">
                                    </ajaxToolkit:PopupControlExtender>

                                    <asp:Panel ID="panelemployee" runat="server" CssClass="poppanel">

                                        <input type="checkbox" id="chkemp" onclick="checkall(this.id, 'dropemployee', '--All Employees--', 'txtemployee', 'employee');" />
                                        <span>Check All</span><div class="clear"></div>
                                        <asp:CheckBoxList ID="dropemployee" runat="server" RepeatLayout="UnorderedList" RepeatDirection="Vertical" ClientIDMode="Static" onchange="setcontent(this.id,'txtemployee','--All Employee--','employee');"></asp:CheckBoxList>

                                    </asp:Panel>

                                </div>

                                <div class="divsearch">

                                    <label class="lblleft">
                                        Client
                                    </label>
                                    <asp:TextBox ID="txtclient" runat="server" CssClass="form-control mar pad3" ClientIDMode="Static" placeholder="--All Clients--" onkeyup="searchdata(event,this.id,'dropclient');" onchange="setcontent('dropclient',this.id,'--All Clients--','client');">
                                    </asp:TextBox>

                                    <ajaxToolkit:PopupControlExtender ID="PopupControlExtender1" runat="server" TargetControlID="txtclient"
                                        PopupControlID="panelclient" Position="Bottom">
                                    </ajaxToolkit:PopupControlExtender>
                                    <asp:Panel ID="panelclient" runat="server" CssClass="poppanel">

                                        <input type="checkbox" id="chkclient" onclick="checkall(this.id, 'dropclient', '--All Clients--', 'txtclient', 'client');" />
                                        <span>Check All</span><div class="clear"></div>
                                        <asp:CheckBoxList ID="dropclient" runat="server" RepeatLayout="UnorderedList" ClientIDMode="Static" onchange="setcontent(this.id,'txtclient','--All Clients--','client');"></asp:CheckBoxList>

                                    </asp:Panel>


                                </div>

                                <div class="divsearch">

                                    <label class="lblleft">
                                        Project
                                    </label>
                                    <asp:TextBox ID="txtproject" runat="server" CssClass="form-control mar pad3" ClientIDMode="Static" placeholder="--All Projects--" onkeypress="searchfilters(this.id,'txtproject');" onkeyup="searchfilters(this.id,'txtproject');" onkeydown="searchfilters(this.id,'txtproject');">
                                    </asp:TextBox>

                                    <ajaxToolkit:PopupControlExtender ID="PopupControlExtender2" runat="server" TargetControlID="txtproject"
                                        PopupControlID="pnlproject" Position="Bottom">
                                    </ajaxToolkit:PopupControlExtender>
                                    <asp:Panel ID="pnlproject" runat="server" CssClass="poppanel">

                                        <input type="checkbox" id="chkproject" onclick="checkall(this.id, 'dropproject', '--All Projects--', 'txtproject', 'project');" />
                                        <span>Check All</span><div class="clear"></div>
                                        <asp:CheckBoxList ID="dropproject" runat="server" RepeatLayout="UnorderedList" RepeatDirection="Vertical" RepeatColumns="1" ClientIDMode="Static" onchange="setcontent(this.id,'txtproject','--All Projects--','project');"></asp:CheckBoxList>

                                    </asp:Panel>

                                </div>
                                <div class="divsearch">

                                    <label class="lblleft">
                                        Manager
                                    </label>
                                    <asp:DropDownList ID="dropassign" runat="server" CssClass="form-control mar pad3">
                                    </asp:DropDownList>
                                </div>
                                <div class="divsearch">

                                    <label class="lblleft">
                                        Task Status
                                    </label>
                                    <asp:DropDownList ID="dropTaskStatus" runat="server" CssClass="form-control mar pad3">
                                        <asp:ListItem Text="--All Task Status--" Value=""></asp:ListItem>
                                        <asp:ListItem Text="Approved" Value="Approved"></asp:ListItem>
                                        <asp:ListItem Text="Submitted" Value="Submitted"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="divsearch">

                                    <label class="lblleft">
                                        Billable
                                    </label>
                                    <asp:DropDownList ID="dropbillable" runat="server" CssClass="form-control mar pad3">
                                        <asp:ListItem Text="--All Billable Status--" Value=""></asp:ListItem>
                                        <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                        <asp:ListItem Text="No" Value="0"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="divsearch">

                                    <label class="lblleft">
                                        Billed
                                    </label>
                                    <asp:DropDownList ID="dropbilled" runat="server" CssClass="form-control mar pad3">
                                        <asp:ListItem Text="--All Billed Status--" Value=""></asp:ListItem>
                                        <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                        <asp:ListItem Text="No" Value="0"></asp:ListItem>
                                    </asp:DropDownList>


                                </div>

                            </div>
                            <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                   
                                    <div class="divsearch">
                                        <label class="lblleft"></label>

                                        <asp:Button ID="btnsearch" runat="server" CssClass="btn btn-default" Text="View Report" ValidationGroup="search"
                                            OnClick="btnsearch_click" />
                                    </div>
                                     <div class="divsearch">

                                        <asp:CheckBox ID="chkcost" runat="server" Text="Show cost" CssClass="lblleft" Checked="true" AutoPostBack="true" OnCheckedChanged="chkcost_CheckedChanged" />


                                    </div>
                                </ContentTemplate>
                            </asp:UpdatePanel>

                        </div>
                    </div>
                    <div class="col-sm-12 col-md-12 mar2">
                        <div class="f_right">
                            <%--  <asp:LinkButton ID="lnkprevious" CssClass="f_left" runat="server" OnClick="lnkprevious_Click">
            <i class="fa fa-fw fa-fast-backward color_green"></i></asp:LinkButton>
                                    </span>
                                    <div class="f_left page">
                                        <asp:Label ID="lblstart" runat="server"></asp:Label>
                                        -
                                        <asp:Label ID="lblend" runat="server"></asp:Label>
                                        of <strong>
                                            <asp:Label ID="lbltotalrecord" Font-Bold="true" runat="server"></asp:Label></strong>
                                    </div>
                                    <asp:LinkButton ID="lnknext" CssClass="f_left" runat="server" OnClick="lnknext_Click"><i class="fa fa-fw fa-fast-forward color_green"></i></asp:LinkButton>--%>
                        </div>
                        <div class="clear">
                        </div>
                        <asp:UpdatePanel ID="upadatepanel" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <pg:progress ID="progress1" runat="server" />
                                <div class="panel panel-default" style="border: none;">
                                    <div class="panel-body2 ">
                                        <div class="row">
                                            <div class="table-responsive">
                                                <div class="nodatafound" id="divnodata" runat="server" visible="false">
                                                    No data found
                                                </div>

                                                <div id="divreport" runat="server" class="mainrptdiv" >

                                                   
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <input type="hidden" id="hidsearchfromdate" runat="server" />
                                <input type="hidden" id="hidsearchtodate" runat="server" />
                                <input type="hidden" id="hidsearchdrpclient" runat="server" />
                                <input type="hidden" id="hidsearchdrpproject" runat="server" />
                                <input type="hidden" id="hidsprojectid" runat="server" />
                                <input type="hidden" id="hidsclientid" runat="server" />
                                <input type="hidden" id="hidsemployeeid" runat="server" />
                                <input type="hidden" id="hidsearchdrpclientname" runat="server" />
                                <input type="hidden" id="hidsearchdrpprojectname" runat="server" />

                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                    <div class="clear">
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
