<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="comp_AttandanceReaderSettings.aspx.cs" Inherits="empTimeSheet.comp_AttandanceReaderSettings" %>

<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Attendance Reader  Settings</title>
    <link rel="stylesheet" type="text/css"  href="css/companySettingMain5.0.css"  />
    <script type="text/javascript" src="js/companySettings.js"></script>
    <script>
        window.parent.document.getElementById("divcompanyloader").style.display = "block";


        function bindPageEvent() {
            $(function () {
                function moveItems(origin, dest) {
                    $(origin).find(':selected').appendTo(dest);
                }
                $('#Button2').click(function () {
                    moveItems('#listcode2', '#listcode1'); //left
                    addscheduleinhidden();
                });

                $('#Button1').click(function () {
                    moveItems('#listcode1', '#listcode2');  //right
                    addscheduleinhidden();
                });

               

            });
        }

        function addscheduleinhidden() {
            var strval = "";
            $("#listcode2 > option").each(function () {

                strval += this.value + '#';
            });
            document.getElementById('hidscheduleemailemp').value = strval;
        }
    </script>
</head>
<body>

    <form id="form1" runat="server">
        <ajaxToolkit:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </ajaxToolkit:ToolkitScriptManager>
        <asp:UpdatePanel ID="upadatepanel1" runat="server">
            <ContentTemplate>
                 <script type="text/javascript">
                     Sys.Application.add_load(bindPageEvent);
            </script>
                <pg:progress ID="progress1" runat="server" />
                <div class="maindiv">

                    <div class="ctrlGroup">
                        <label class="lbl">
                           Username * :
                             <asp:RequiredFieldValidator ID="RequiredFieldValidator12" runat="server" ErrorMessage=""
                                                                    ControlToValidate="txtUserName" ValidationGroup="save" Style="display: none;"></asp:RequiredFieldValidator>
                        </label>
                         <div class="txt w1">
                          <asp:TextBox ID="txtUserName" runat="server" CssClass="form-control" MaxLength="12"></asp:TextBox>
                        </div>
                    </div>
                    <div class="clear">
                    </div>
                    <div class="ctrlGroup">
                        <label class="lbl">
                           Password * :
                              <asp:RequiredFieldValidator ID="RequiredFieldValidator13" runat="server" Style="display: none;" ErrorMessage=""
                                                                    ControlToValidate="txtPassword" ValidationGroup="save"></asp:RequiredFieldValidator>
                        </label>
                         <div class="txt w1">
                          <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" MaxLength="30"></asp:TextBox>
                        </div>
                    </div>

                    
                    <div class="clear">
                    </div>
                    <div class="ctrlGroup">
                        
                        <label class="lbl">&nbsp;
                            </label>
                        <asp:Button ID="btnsaveinfo" runat="server" Text="Save" OnClick="btnSave_OnClick" CausesValidation="true" ValidationGroup="save"
                             CssClass="btn-primary" OnClientClick="var valFunc1 = validatefieldsbygroup('save');if(valFunc1 == true) {return true;} else{return false;}"  />

                       
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

