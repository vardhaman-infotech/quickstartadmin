<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="comp_InvEmailTemplate.aspx.cs" Inherits="empTimeSheet.comp_InvEmailTemplate" %>

<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit.HTMLEditor"
    TagPrefix="ajaxeditor" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Invoice Email Template
    </title>
    <link rel="stylesheet" type="text/css"  href="css/companySettingMain5.0.css"  />
    <script type="text/javascript" src="js/companySettings.js"></script>
    <script>
        window.parent.document.getElementById("divcompanyloader").style.display = "block";
    </script>
    <style type="text/css">
        .inner-instruction {
            height: 300px;
            margin: 0px 5px;
        }
    </style>


</head>
<body>

    <form id="form1" runat="server">
        <ajaxToolkit:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </ajaxToolkit:ToolkitScriptManager>
        <asp:UpdatePanel ID="upadatepanel1" runat="server">
            <ContentTemplate>
                <pg:progress ID="progress1" runat="server" />
                 
                <div class="maindiv">

                    <div class="clear"></div>
                    <ajaxeditor:Editor ID="Editor1" runat="server"
                            Height="350px" Width="99%" />
                   
                    <div class="clear"></div>
                    <div class="ctrlGroup">
                        <asp:Button ID="btnsaveinfo" runat="server" Text="Save" OnClick="btnSave_OnClick"
                            CssClass="btn btn-primary" />
                    </div>

                </div>

            </ContentTemplate>
        </asp:UpdatePanel>
    </form>

    <script>
        window.parent.document.getElementById("divcompanyloader").style.display = "none";
    </script>
</body>
</html>

