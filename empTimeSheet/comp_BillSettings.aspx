<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="comp_BillSettings.aspx.cs" Inherits="empTimeSheet.comp_BillSettings" %>

<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Bill Settings</title>
    <link rel="stylesheet" type="text/css"  href="css/companySettingMain5.0.css"  />
    <script type="text/javascript" src="js/companySettings.js"></script>
    <script>
        window.parent.document.getElementById("divcompanyloader").style.display = "block";
    </script>
</head>
<body>

    <form id="form1" runat="server">
        <ajaxToolkit:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </ajaxToolkit:ToolkitScriptManager>
        <asp:UpdatePanel ID="upadatepanel1" runat="server">
            <ContentTemplate>
                <pg:progress ID="progress1" runat="server" />
                <div class="maindiv">

                    <div class="ctrlGroup">
                        <label class="lbl lbl1">
                            Next Invoice No. : *
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator11" runat="server" Style="display: none;" ErrorMessage=""
                                                                    ControlToValidate="txtnextinvoiceno" ValidationGroup="save"></asp:RequiredFieldValidator>
                        </label>
                        <div class="txt w0">
                            <asp:TextBox ID="txtnextinvoiceno" runat="server" CssClass="form-control" onkeypress="blockNonNumbers(this, event, true, false);"
                                onkeyup="extractNumber(this,2,false);" Width="60px"></asp:TextBox>
                        </div>
                    </div>
                    <div class="clear"></div>
                    <div class="ctrlGroup">
                        <label class="lbl lbl1">
                            Invoice Prefix : 
                                                            
                        </label>
                        <div class="txt w0">
                            <asp:TextBox ID="txtprefix" runat="server" CssClass="form-control" MaxLength="15" ></asp:TextBox>
                        </div>
                    </div>
                    <div class="clear"></div>
                    <div class="ctrlGroup">
                        <label class="lbl lbl1">
                            Invoice Suffix :
                                                              
                        </label>
                        <div class="txt w0">
                            <asp:TextBox ID="txtpostfix" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>
                    <div class="clear">
                    </div>
                    <div class="ctrlGroup">
                        <label class="lbl lbl1">
                            &nbsp;
                        </label>
                        <asp:Button ID="btnsaveinfo" runat="server" Text="Save" OnClick="btnSave_OnClick" CausesValidation="true" ValidationGroup="save"
                            OnClientClick="var valFunc1 = validatefieldsbygroup('save');if(valFunc1 == true) {return true;} else{return false;}" CssClass="btn-primary" />
                        <asp:Button ID="btnreset" runat="server" CausesValidation="true" CssClass="btn-primary btn-default" Text="Reset"
                            OnClick="btnreset_Click" />
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

