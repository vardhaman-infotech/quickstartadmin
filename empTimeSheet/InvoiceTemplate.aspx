<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="InvoiceTemplate.aspx.cs" Inherits="empTimeSheet.InvoiceTemplate" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
 
    <style type="text/css">
        .m_Panel
        {
            background-color: #fff;
            margin-bottom: 20px;
            box-shadow: 5px 3px 5px #888;
            border-radius: 4px;
            min-height: 200px;
            height: auto;
            width: 100%;
            font-size: 12px;
        }
        
        .pad6
        {
            padding-bottom: 8px;
        }
        
        .font_size
        {
            font-size: 15px;
        }
        
        .font_size2
        {
            font-size: 20px;
        }
        
        .mar4
        {
            margin-top: 30px;
        }
        
        .background_image
        {
            background: #f3f3f3;
            padding: 12px;
            float: left;
        }
        
        .background_image img
        {
            width: 150px;
        }
        
        .link_div
        {
            border-bottom: dashed 1px #999999;
            padding-bottom: 4px;
            width: 100%;
            clear: both;
            margin-bottom: 6px;
            margin-top: 10px;
            font-weight: bold;
        }
        
        .link_div p
        {
            padding: 8px 0 0 0;
            margin: 0px;
        }
        
        .aFontSize
        {
            font-size: 12px;
            padding-top: 14px;
        }
        
        .pFontSize
        {
            font-size: 13px;
        }
        
        .sett_textbox
        {
            background-color: #fff;
            background-image: none;
            border: 1px solid #cdcdcd;
            border-radius: 4px;
            box-shadow: 0 1px 1px rgba(0, 0, 0, 0.075) inset;
            color: #555;
            display: block;
            font-size: 13px;
            padding: 6px 12px;
            transition: border-color 0.15s ease-in-out 0s, box-shadow 0.15s ease-in-out 0s;
            width: 200px;
        }
        
        .sett_btn
        {
            background-color: #428bca;
            border-color: #357ebd;
            color: #fff;
            padding: 3px 10px;
            font-size: 12px;
            margin-top: 10px;
        }
        
        .marright
        {
            margin-right: 5px;
        }
        
        .martop
        {
            margin: 8px 0 0;
        }
    </style>
    <style type="text/css">
        .Temp_link_manage
        {
            width: 100%;
            background: #CCCCCC;
            text-align: center;
            padding-bottom: 7px;
            height: 300px;
            font-size: 11px;
            margin: 0px auto;
        }
        .Temp_link_manage img
        {
            padding: 10px 0 0 0;
            width: 90%;
            height: 90%;
        }
        .Temp_link_manage br
        {
            display: block;
            margin-top: 8px;
        }
        .Temp_link_manage:hover
        {
            background: #18AAFF;
            color: #ffffff;
        }
        .Temp_link_manage.active
        {
            background: #18AAFF;
            color: #ffffff;
        }
    </style>
    <script type="text/javascript">
        function checkTemp(id) {

            var totalelm = $('#ctl00_ContentPlaceHolder1_dltemplate > span').length;

            for (var j = 0; j < totalelm; j++) {
                var nid = document.getElementById("ctl00_ContentPlaceHolder1_dltemplate_ctl0" + j + "_hidTempid").value;
                if (id != nid) {
                    document.getElementById("ctl00_ContentPlaceHolder1_dltemplate_ctl0" + j + "_divcontiner").className = "Temp_link_manage";

                }
                else {
                    document.getElementById("ctl00_ContentPlaceHolder1_dltemplate_ctl0" + j + "_divcontiner").className = "Temp_link_manage active";

                }

            }

            document.getElementById("ctl00_ContentPlaceHolder1_hidseletedtemplate").value = id;


        }
        function zoomtemplete(url)
        {
          
            document.getElementById("divzoom").innerHTML = "<img src='InvoiceTemplates/" + url + "' />";
            document.getElementById("otherdiv").style.display = "block";
            setposition("divzoom");
            $('#divzoom').show();
        }
        function closediv()
        {
            document.getElementById("otherdiv").style.display = "none";
            $('#divzoom').hide();
        }
    </script>
  
    <style type="text/css">
        .divzoom {
        display:none;
        cursor:zoom-out;
        position:fixed;
        z-index:999999;
         max-width:100%;
            max-height:100%;
            width:600px;
            height:600px;
        }
        .divzoom img {
            max-width:100%;
            max-height:100%;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="divzoom" class="divzoom" onclick="closediv();"></div>
   
    <div id="otherdiv" onclick="closediv();"></div>
    <pg:progress ID="progress1" runat="server" />
    <asp:UpdatePanel ID="upadatepanel1" runat="server">
        <ContentTemplate>
            <div class="pageheader">
                <h2>
                    <i class="fa circle"></i>Invoice Template
                </h2>
                <div class="breadcrumb-wrapper">
                </div>
                <div class="clear">
                </div>
            </div>
            <div class="clear">
            </div>
            <div class="contentpanel">
                <div class="row">
                    <!-- col-sm-3 -->
                    <div class="col-sm-12 col-md-12">
                        <div class="panel-default">
                            <div class="panel-body">
                                <div class="row">
                                    <div class="col-sm-12 col-md-12">
                                        <div class="m_Panel">
                                            <div class="panel-default">
                                                <div class="panel-body">
                                                    <div class="col-sm-5 col-md-5 pad">
                                                        <h3 class="pad6 font_size2">
                                                        </h3>
                                                    </div>
                                                    <div class="clear">
                                                    </div>
                                                    <div>
                                                        <asp:DataList ID="dltemplate" runat="server" Width="100%" RepeatDirection="Horizontal"
                                                            RepeatLayout="Flow" CellPadding="0" CellSpacing="0" ForeColor="#333333" OnItemDataBound="dltemplate_ItemDataBound">
                                                            <ItemTemplate>
                                                                <input type="hidden" id="hidTempid" runat="server" value='<%#Eval("nid")%>' />
                                                            <div class="Temp_link_manage " id="divcontiner" runat="server" 
                                                                    onclick='<%# "checkTemp(" + Eval("nid") + ");" %>'>
                                                                    <img id='<%# Eval("imgurl")%>' src='InvoiceTemplates/<%# Eval("imgurl")%>' alt="" ondblclick="zoomtemplete(this.id);" title="Double click to zoom template" />
                                                                    <br />
                                                                    <label id="lblname<%# Eval("nid")%>">
                                                                        <%# Eval("name") %></label>
                                                                </div>
                                                               
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="col-sm-4" />
                                                        </asp:DataList>
                                                    </div>
                                                    <div class="clear">
                                                    </div>
                                                    <div class="col-sm-12 col-md-12 pad5">
                                                        <p class="mar2">
                                                            Note: Click on any template to select it, currently selected template is highlighted
                                                            with blue color. To apply selected template as defaul invoice template click <i>Save</i>.</p>
                                                            <div class="clear"></div>
                                                        <asp:Button ID="btnsaveinfo" runat="server" Text="Save" OnClick="btnSave_OnClick"
                                                            CssClass="btn sett_btn marright f_left" />
                                                    </div>
                                                    <!-- panel-body -->
                                                </div>
                                                <!-- panel -->
                                            </div>
                                        </div>
                                        <!-- col-sm-3 -->
                                    </div>
                                </div>
                            </div>
                            <div class="clear">
                            </div>
                        </div>
                    </div>
                    <div class="clear">
                    </div>
                    <input type="hidden" id="hidinvoicetemp" runat="server" />
                    <input type="hidden" id="hidseletedtemplate" runat="server" />
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
