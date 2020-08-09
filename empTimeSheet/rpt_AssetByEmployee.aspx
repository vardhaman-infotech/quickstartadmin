<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="rpt_AssetByEmployee.aspx.cs" Inherits="empTimeSheet.rpt_AssetByEmployee" %>
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

            var selectedclient = document.getElementById(clientid).value;


            if (selectedproject != "") {
                args.IsValid = true;
            }
            else {

                args.IsValid = false;
            }
            return;
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <pg:progress ID="progress1" runat="server" />
    <asp:UpdatePanel ID="updateclientmst" runat="server">
        <ContentTemplate>
            <div class="pageheader">
                <h2>
                    <i class="fa fa-clipboard"></i>Asset Report
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
                                            <asp:Label ID="lblReportName" runat="server" Text="Asset By Employee Report"></asp:Label>
                                        </h5>
                                    </div>
                                    <div class="clear"></div>
                                    <div class="ctrlGroup searchgroup">    
                                        <label class="lbl"> All Assets : </label>   
                                        <div class="txt w1 mar10">                             
                                        <asp:TextBox ID="txtAsset" runat="server" CssClass="form-control" ClientIDMode="Static" placeholder="--All Assets--" onkeypress="searchfilters(this.id,'txtAsset');" onkeyup="searchfilters(this.id,'txtAsset');" onkeydown="searchfilters(this.id,'txtAsset');">
                                        </asp:TextBox>

                                        <ajaxToolkit:PopupControlExtender ID="PopupControlExtender1" runat="server" TargetControlID="txtAsset"
                                            PopupControlID="panelAsset" Position="Bottom">
                                        </ajaxToolkit:PopupControlExtender>

                                        <asp:Panel ID="panelAsset" runat="server" CssClass="poppanel">
                                            <input type="checkbox" id="chkAsset" onclick="checkall(this.id, 'dropAsset', '--All Assets--', 'txtAsset', 'Asset');" />
                                            <span>Check All</span><div class="clear"></div>
                                            <asp:CheckBoxList ID="dropAsset" runat="server" RepeatLayout="Table" Width="100%"   ClientIDMode="Static" onchange="setcontent(this.id,'txtAsset','--All Assets--','Asset');"></asp:CheckBoxList>
                                        </asp:Panel>
                                            </div>
                                    </div>

                                    <div class="ctrlGroup searchgroup">  
                                        <label class="lbl"> All Department : </label>   
                                        <div class="txt w1">                                    
                                        <asp:TextBox ID="txtDepartment" runat="server" CssClass="form-control" ClientIDMode="Static" placeholder="--All Department--" onkeypress="searchfilters(this.id,'txtDepartment');" onkeyup="searchfilters(this.id,'txtDepartment');" onkeydown="searchfilters(this.id,'txtDepartment');">
                                        </asp:TextBox>

                                        <ajaxToolkit:PopupControlExtender ID="PopupControlExtender2" runat="server" TargetControlID="txtDepartment"
                                            PopupControlID="panelDepartment" Position="Bottom">
                                        </ajaxToolkit:PopupControlExtender>

                                        <asp:Panel ID="panelDepartment" runat="server" CssClass="poppanel">
                                            <input type="checkbox" id="chkDepartment" onclick="checkall(this.id, 'dropDepartment', '--All Department--', 'txtDepartment', 'Department');" />
                                            <span>Check All</span><div class="clear"></div>
                                            <asp:CheckBoxList ID="dropDepartment" runat="server" RepeatLayout="Table" Width="100%"  ClientIDMode="Static" onchange="setcontent(this.id,'txtDepartment','--All Department--','Department');"></asp:CheckBoxList>
                                        </asp:Panel>
                                            </div>
                                    </div>
                                    <div class="clear"></div>
                                    <div class="ctrlGroup searchgroup"> 
                                        <label class="lbl"> All Category : </label>   
                                        <div class="txt w1 mar10">                                  
                                        <asp:TextBox ID="txtCategory" runat="server" CssClass="form-control" ClientIDMode="Static" placeholder="--All Category--" onkeypress="searchfilters(this.id,'txtCategory');" onkeyup="searchfilters(this.id,'txtCategory');" onkeydown="searchfilters(this.id,'txtCategory');">
                                        </asp:TextBox>

                                        <ajaxToolkit:PopupControlExtender ID="PopupControlExtender3" runat="server" TargetControlID="txtCategory"
                                            PopupControlID="panelCategory" Position="Bottom">
                                        </ajaxToolkit:PopupControlExtender>

                                        <asp:Panel ID="panelCategory" runat="server" CssClass="poppanel">
                                            <input type="checkbox" id="chkCategory" onclick="checkall(this.id, 'dropCategory', '--All Category--', 'txtCategory', 'Category');" />
                                            <span>Check All</span><div class="clear"></div>
                                            <asp:CheckBoxList ID="dropCategory" runat="server" RepeatLayout="Table" Width="100%" ClientIDMode="Static" onchange="setcontent(this.id,'txtCategory','--All Category--','Category');"></asp:CheckBoxList>
                                        </asp:Panel>
                                            </div>
                                    </div>

                                     <div class="ctrlGroup searchgroup">   
                                         <label class="lbl"> All Employees : </label>  
                                         <div class="txt w1 mar10">                                     
                                        <asp:TextBox ID="txtEmployee" runat="server" CssClass="form-control" ClientIDMode="Static" placeholder="--All Employees--"  onkeypress="searchfilters(this.id,'dropEmployee');" onkeyup="searchfilters(this.id,'dropEmployee');" onkeydown="searchfilters(this.id,'dropEmployee');">
                                        </asp:TextBox>

                                        <ajaxToolkit:PopupControlExtender ID="PopupControlExtender4" runat="server" TargetControlID="txtEmployee"
                                            PopupControlID="panelemployee" Position="Bottom">
                                        </ajaxToolkit:PopupControlExtender>

                                        <asp:Panel ID="panelemployee" runat="server" CssClass="poppanel">
                                            <input type="checkbox" id="chkEmployee" onclick="checkall(this.id, 'dropEmployee', '--All Employees--', 'txtEmployee', 'Employee');" />
                                            <span>Check All</span><div class="clear"></div>
                                            <asp:CheckBoxList ID="dropEmployee" runat="server" RepeatLayout="Table" ClientIDMode="Static" onchange="setcontent(this.id,'txtEmployee','--All Employees--','Employee');"></asp:CheckBoxList>
                                        </asp:Panel>
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
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
