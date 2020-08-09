<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="rpt_EmployeeBillRate.aspx.cs" Inherits="empTimeSheet.rpt_EmployeeBillRate" %>

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
        #dropEmployee {
        width:100%;
        }
    </style>
   
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <pg:progress ID="progress1" runat="server" />
    <div class="pageheader">
        <h2>
            <i class="fa fa-clipboard"></i>Billing Report
        </h2>
        <div class="breadcrumb-wrapper mar ">
        </div>
        <div class="clear">
        </div>
    </div>
    <div class="contentpanel">
        <div class="row">
            <div class="col-sm-12 col-md-12">
                <div class="panel panel-default">
                    <div class="col-sm-12 col-md-10">
                        <div style="padding-top: 10px;">
                            <div class="col-xs-12 col-sm-8 col-md-6 f_left" style="padding: 0px;">
                                <h5 class="subtitle mb5">
                                    <asp:Label ID="lblReportName" runat="server" Text="Employee Default Bill Rate Report"></asp:Label>
                                </h5>
                            </div>

                            <div class="clear"></div>
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl">Employee Title :</label>
                                 <div class="txt w1 mar10">
                                 <asp:TextBox ID="txtemptitle" runat="server" CssClass="form-control" ClientIDMode="Static" placeholder="--All Titles--" onkeypress="searchfilters(this.id,'txtemptitle');" onkeyup="searchfilters(this.id,'txtemptitle');" onkeydown="searchfilters(this.id,'txtemptitle');">
                                    </asp:TextBox>

                                    <ajaxToolkit:PopupControlExtender ID="PopupControlExtender2" runat="server" TargetControlID="txtemptitle"
                                        PopupControlID="paneltitle" Position="Bottom">
                                    </ajaxToolkit:PopupControlExtender>
                                    <asp:Panel ID="paneltitle" runat="server" CssClass="poppanel">

                                        <input type="checkbox" id="chktitle" onclick="checkall(this.id, 'droptitle', '--All Titles--', 'txtemptitle', 'title');" />
                                        <span>Check All</span><div class="clear"></div>
                                        <asp:CheckBoxList ID="droptitle" runat="server" RepeatLayout="Flow" ClientIDMode="Static" onchange="setcontent(this.id,'txtemptitle','--All Titles--','title');"></asp:CheckBoxList>

                                    </asp:Panel>
                                     </div>
                            </div>
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl">Employee :</label>
                                <div class="txt w2 ">
                                   <asp:TextBox ID="txtEmployee" runat="server" CssClass="form-control" ClientIDMode="Static" placeholder="--All Employees--"  onkeypress="searchfilters(this.id,'dropEmployee');" onkeyup="searchfilters(this.id,'dropEmployee');" onkeydown="searchfilters(this.id,'dropEmployee');">
                                    </asp:TextBox>

                                    <ajaxToolkit:PopupControlExtender ID="PopupControlExtender1" runat="server" TargetControlID="txtEmployee"
                                        PopupControlID="panelemployee" Position="Bottom">
                                    </ajaxToolkit:PopupControlExtender>
                                    <asp:Panel ID="panelemployee" runat="server" CssClass="poppanel">

                                        <input type="checkbox" id="chkemployee" onclick="checkall(this.id, 'dropEmployee', '--All Employees--', 'txtEmployee', 'employee');" />
                                        <span>Check All</span><div class="clear"></div>
                                        <asp:CheckBoxList ID="dropEmployee" runat="server" RepeatLayout="Table"  ClientIDMode="Static" onchange="setcontent(this.id,'txtEmployee','--All Employees--','employee');"></asp:CheckBoxList>

                                    </asp:Panel></div>
                            </div>
                             
                            <div class="clear"></div>
                            <div class="ctrlGroup searchgroup">
                                 <label class="lbl">Department :</label>
                                <div class="txt w1 mar10">
                                <asp:TextBox ID="txtdept" runat="server" CssClass="form-control" ClientIDMode="Static" placeholder="--All Department--" onkeypress="searchfilters(this.id,'dropdept');" onkeyup="searchfilters(this.id,'dropdept');" onkeydown="searchfilters(this.id,'dropdept');">
                                    </asp:TextBox>

                                    <ajaxToolkit:PopupControlExtender ID="PopupControlExtender3" runat="server" TargetControlID="txtdept"
                                        PopupControlID="panelclient" Position="Bottom">
                                    </ajaxToolkit:PopupControlExtender>
                                    <asp:Panel ID="panelclient" runat="server" CssClass="poppanel">

                                        <input type="checkbox" id="chkclient" onclick="checkall(this.id, 'dropdept', '--All Department--', 'txtdept', 'department');" />
                                        <span>Check All</span><div class="clear"></div>
                                        <asp:CheckBoxList ID="dropdept" runat="server" RepeatLayout="Flow" ClientIDMode="Static" onchange="setcontent(this.id,'txtdept','--All Department--','department');"></asp:CheckBoxList>

                                    </asp:Panel></div>
                            </div>
                            <div class="ctrlGroup searchgroup">

                                    <label class="lbl">Manager :</label>
                                <div class="txt w2 mar10">
                                    <asp:DropDownList ID="dropassign" runat="server" CssClass="form-control">
                                    </asp:DropDownList>
                                    </div>
                                </div>

                            
                           
                            
                            <div class="divsearch">
                                <asp:Button ID="btnsearch" runat="server" Text="View Report" CssClass="btn btn-default"
                                    OnClick="btnsearch_Click" />
                            </div>

                        </div>
                    </div>
                    <div class="clear">
                    </div>
                    <div class="col-sm-12 col-md-12 mar2">

                        <div class="diverror" id="divnodata" runat="server" visible="false">
                            No data found
                        </div>

                        <div id="divreport" runat="server" class="mainrptdiv" visible="false">

                            <!--Outer Most- CLIENT repeater-->
                            <rsweb:ReportViewer ID="ReportViewer1" runat="server" Width="100%" Height="600px">
                            </rsweb:ReportViewer>

                        </div>
                        <div class="clear"></div>

                        <input type="hidden" id="hidsprojectid" runat="server" />
                        <input type="hidden" id="hidsclientid" runat="server" />
                        <input type="hidden" id="hidsemployeeid" runat="server" />
                    </div>
                    <div class="clear">
                    </div>
                </div>
                <!--Panel-default-->
            </div>
            <!---col-sm-12 col-md-12-->
        </div>
        <!---row-->
    </div>
    <!---contentpanel-->
</asp:Content>
