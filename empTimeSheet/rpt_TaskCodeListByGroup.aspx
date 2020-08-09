<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="rpt_TaskCodeListByGroup.aspx.cs" Inherits="empTimeSheet.rpt_TaskCodeListByGroup" %>
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
   
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
       <asp:UpdatePanel ID="upadatepanel" runat="server">
        <ContentTemplate>
            <pg:progress ID="progress1" runat="server" />
            <div id="otherdiv" onclick="closediv();">
            </div>
            <div class="pageheader">
                <h2>
                    <i class="fa fa-home"></i>Task Report
                </h2>
                <input type="hidden" id="hidid" runat="server" />
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
                                        <h5 class="subtitle mb5">Task Codes List by Group</h5>
                                    </div>
                                    <div class="clear col-sm-6 col-md-4 pad4">
                                        <%-- <asp:CustomValidator ID="req1" runat="server" ClientValidationFunction="validatereport" ValidationGroup="search" ErrorMessage="Select a client or project!"></asp:CustomValidator>--%>
                                    </div>
                                    <div class="clear"></div>
                                    <div class="clear"></div>
                            <div class="ctrlGroup searchgroup" style="display:none;">
                                <label class="lbl lbl1">From Date :</label>
                                <div class="txt w1 mar10">
                                <asp:TextBox ID="txtfromdate" runat="server" placeholder="From Date" CssClass="form-control hasDatepicker"  onchange="comparedate(this.id,'ctl00_ContentPlaceHolder1_txtfromdate','ctl00_ContentPlaceHolder1_txttodate');"></asp:TextBox>

                                <cc1:CalendarExtender ID="cc1" runat="server" TargetControlID="txtfromdate" PopupButtonID="txtfromdate"
                                    Format="MM/dd/yyyy">
                                </cc1:CalendarExtender>
                                    </div>

                            </div>
                          
                            <div class="ctrlGroup searchgroup" style="display:none;">
                                <label class="lbl lbl1">To Date :</label>
                                <div class="txt w1 mar10">
                                <asp:TextBox ID="txttodate" runat="server" placeholder="To Date" CssClass="form-control hasDatepicker"  onchange="comparedate(this.id,'ctl00_ContentPlaceHolder1_txtfromdate','ctl00_ContentPlaceHolder1_txttodate');"></asp:TextBox>

                                <cc1:CalendarExtender ID="cc2" runat="server" TargetControlID="txttodate" PopupButtonID="txttodate"
                                    Format="MM/dd/yyyy">
                                </cc1:CalendarExtender>
                                    </div>
                            </div>
                                    <div class="clear"></div>
                                    <div class="ctrlGroup searchgroup">
                                <label class="lbl lbl1">Task Status :</label>
                                         <div class="txt w1 mar10">
                                <asp:DropDownList ID="dropTaskStatus" runat="server" CssClass="form-control">
                                    <asp:ListItem Text="--All Task Status--" Value=""></asp:ListItem>
                                    <asp:ListItem Text="Approved" Value="Approved"></asp:ListItem>
                                     <asp:ListItem Text="Submitted" Value="Submitted"></asp:ListItem>
                                </asp:DropDownList>
                                             </div>
                            </div>
                                     <div class="ctrlGroup searchgroup">
                                <label class="lbl lbl1">Department :</label>
                                         <div class="txt w2">
                                       <asp:DropDownList ID="dropdeptsearch" runat="server" CssClass="form-control">
                                </asp:DropDownList>
                                             </div>
                                    </div>
                                     <div class="clear"></div>
                             <div class="ctrlGroup searchgroup">
                                <label class="lbl lbl1">Billable :</label>
                                 <div class="txt w1 mar10">
                                <asp:DropDownList ID="dropbillable" runat="server" CssClass="form-control">
                                    <asp:ListItem Text="--All Billable Status--" Value=""></asp:ListItem>
                                    <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                     <asp:ListItem Text="No" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                                     </div>
                            </div>
                                  <div class="ctrlGroup searchgroup">
                                <label class="lbl lbl1">Task Type :</label>
                                      <div class="txt w2">
                                <asp:DropDownList ID="droptasktype" runat="server" CssClass="form-control">
                                    <asp:ListItem Text="--All Task Type--" Value=""></asp:ListItem>
                                    <asp:ListItem Text="Task" Value="Task"></asp:ListItem>
                                     <asp:ListItem Text="Expense" Value="Expense"></asp:ListItem>
                                </asp:DropDownList>
                                          </div>
                            </div>
                                    <div class="clear"></div>
                                     <div class="ctrlGroup searchgroup">
                                <label class="lbl lbl1">Billed :</label>
                                         <div class="txt w1 mar10">
                                <asp:DropDownList ID="dropbilled" runat="server" CssClass="form-control">
                                    <asp:ListItem Text="--All Billed Status--" Value=""></asp:ListItem>
                                    <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                     <asp:ListItem Text="No" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                                             </div>
                            </div>

                                                           
                             <div class="ctrlGroup searchgroup">
                                <label class="lbl lbl1 disNone">&nbsp;</label>
                                <asp:Button ID="btnsearch" runat="server" Text="View Report" CssClass="btn btn-default"
                                    OnClick="btnsearch_Click" />
                            </div>

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
                                <div class="panel panel-default" style="border: none;">
                                    <div class="panel-body2 ">
                                        <div class="row">
                                            <div class="table-responsive">
                                                <div class="nodatafound" id="divnodata" runat="server" visible="false">
                                                    No data found
                                                </div>

                                                <div id="divreport" runat="server" class="mainrptdiv" visible="false">

                                                    <!--Outer Most- CLIENT repeater-->
                                                     <rsweb:ReportViewer ID="ReportViewer1" runat="server" Width="100%" Height="600px"    >
        </rsweb:ReportViewer>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="clear">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <input type="hidden" id="hidsearchfromdate" runat="server" />
            <input type="hidden" id="hidsearchtodate" runat="server" />
            <input type="hidden" id="hidsearchdrpclient" runat="server" />
            <input type="hidden" id="hidsearchdrpproject" runat="server" />

            <input type="hidden" id="hidsearchdrpclientname" runat="server" />
            <input type="hidden" id="hidsearchdrpprojectname" runat="server" />

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
