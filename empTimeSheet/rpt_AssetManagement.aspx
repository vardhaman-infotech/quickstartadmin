<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="rpt_AssetManagement.aspx.cs" Inherits="empTimeSheet.rpt_AssetManagement" %>

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

            var clientid = "ctl00_ContentPlaceHolder1_dropAssetsCategory";
            
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
            <i class="fa fa-clipboard"></i>Asset by Category Report
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
                                    <asp:Label ID="lblReportName" runat="server" Text="Asset By Category  Report"></asp:Label>
                                </h5>
                            </div>
                            <div class="clear"></div>
                           <div class="ctrlGroup searchgroup">
                                <!--Asset Caregory-->
                                    <label class="lbl lbl1">
                                        Category :
                                    </label>
                               <div class="txt w1 mar10">
                                    <asp:TextBox ID="txtAssetsCategory" runat="server" CssClass="form-control" ClientIDMode="Static" placeholder="--All Assets--" onkeypress="searchfilters(this.id,'dropAssetsCategory');" onkeyup="searchfilters(this.id,'dropAssetsCategory');" onkeydown="searchfilters(this.id,'dropAssetsCategory');">
                                    </asp:TextBox>                                                       
                                    <ajaxToolkit:PopupControlExtender ID="PopupControlExtender1" runat="server" TargetControlID="txtAssetsCategory"
                                        PopupControlID="panelAssetsCategory" Position="Bottom">
                                    </ajaxToolkit:PopupControlExtender>                               
                                    <asp:Panel ID="panelAssetsCategory" runat="server" CssClass="poppanel">
                                        <input type="checkbox" id="chkAssetsCategory" onclick="checkall(this.id, 'dropAssetsCategory', '--All Assets--', 'txtAssetsCategory', 'AssetsCategory');" />
                                        <span>Check All</span><div class="clear"></div>
                                        <<<asp:CheckBoxList ID="dropAssetsCategory" runat="server" RepeatLayout="Table" Width="100%"  ClientIDMode="Static" onchange="setcontent(this.id,'txtAssetsCategory','--All Assets--','AssetsCategory');"></asp:CheckBoxList>
                                    </asp:Panel>
                                   </div>
                                <!--End Asset Caregory-->
                               </div>   
                               <!--Department-->
                               <div class="ctrlGroup searchgroup">
                                    <label class="lbl lbl1">
                                        Department :
                                    </label>
                                   <div class="txt w1 mar10">
                                    <asp:TextBox ID="txtDepartment" runat="server" CssClass="form-control" ClientIDMode="Static" placeholder="--All Department--" onkeypress="searchfilters(this.id,'dropDepartment');" onkeyup="searchfilters(this.id,'dropDepartment');" onkeydown="searchfilters(this.id,'dropDepartment');">
                                    </asp:TextBox>                                                       
                                    <ajaxToolkit:PopupControlExtender ID="PopupControlExtender2" runat="server" TargetControlID="txtDepartment"
                                        PopupControlID="panelDepartment" Position="Bottom">
                                    </ajaxToolkit:PopupControlExtender>                               
                                    <asp:Panel ID="panelDepartment" runat="server" CssClass="poppanel">
                                        <input type="checkbox" id="chkDepartment" onclick="checkall(this.id, 'dropDepartment', '--All Department--', 'txtDepartment', 'AssetsCategory');" />
                                        <span>Check All</span><div class="clear"></div>
                                        <asp:CheckBoxList ID="dropDepartment" runat="server" RepeatLayout="Table" Width="100%"  ClientIDMode="Static" onchange="setcontent(this.id,'txtDepartment','--All Department--','Department');"></asp:CheckBoxList>
                                    </asp:Panel>
                                   </div></div>
                               <div class="clear"></div>
                                <!--Assets-->
                               <div class="ctrlGroup searchgroup">
                                    <label class="lbl lbl1">
                                        Assets :
                                    </label>
                                   <div class="txt w1 mar10">
                                    <asp:TextBox ID="txtAssets" runat="server" CssClass="form-control" ClientIDMode="Static" placeholder="--All Assets--" onkeypress="searchfilters(this.id,'dropAssets');" onkeyup="searchfilters(this.id,'dropAssets');" onkeydown="searchfilters(this.id,'dropAssets');">
                                    </asp:TextBox>                                                       
                                    <ajaxToolkit:PopupControlExtender ID="PopupControlExtender3" runat="server" TargetControlID="txtAssets"
                                        PopupControlID="panelAssets" Position="Bottom">
                                    </ajaxToolkit:PopupControlExtender>                               
                                    <asp:Panel ID="panelAssets" runat="server" CssClass="poppanel">
                                        <input type="checkbox" id="chkAssets" onclick="checkall(this.id, 'dropAssets', '--All Assets--', 'txtAssets', 'Assets');" />
                                        <span>Check All</span><div class="clear"></div>
                                        <asp:CheckBoxList ID="dropAssets" runat="server" RepeatLayout="Table" ClientIDMode="Static" onchange="setcontent(this.id,'txtAssets','--All Assets--','Assets');"></asp:CheckBoxList>
                                    </asp:Panel> 
                                       </div>
                                   </div>                                           
                             <!--End assets-->

                              <!--Location-->
<%--                                    <label class="lblleft" style="padding-top:10px;">
                                        Locations
                                    </label>
                                    <asp:TextBox ID="txtLocation" runat="server" CssClass="form-control mar pad3" ClientIDMode="Static" placeholder="--All Location--">
                                    </asp:TextBox>                                                       
                                    <ajaxToolkit:PopupControlExtender ID="PopupControlExtender4" runat="server" TargetControlID="txtLocation"
                                        PopupControlID="panelLocation" Position="Bottom">
                                    </ajaxToolkit:PopupControlExtender>                               
                                    <asp:Panel ID="panelLocation" runat="server" CssClass="poppanel">
                                        <input type="checkbox" id="chkLocation" onclick="checkall(this.id, 'dropLocation', '--All Location--', 'txtLocation', 'Location');" />
                                        <span>Check All</span><div class="clear"></div>
                                        <asp:CheckBoxList ID="dropLocation" runat="server" RepeatLayout="Flow" ClientIDMode="Static" onchange="setcontent(this.id,'txtLocation','--All Location--','Location');">
                                                     <asp:ListItem Value="Stock">Stock</asp:ListItem>
                                                    <asp:ListItem Value="Individual">Individual</asp:ListItem>
                                                    <asp:ListItem Value="Inuse">Inuse</asp:ListItem>
                                                    <asp:ListItem Value="Store">Store</asp:ListItem>
                                                    <asp:ListItem Value="Repair">Repair</asp:ListItem>
                                        </asp:CheckBoxList>

                                    </asp:Panel>   --%>                                         
                             <!--End assets-->

                                                
                             <!--End Department-->

                     


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
