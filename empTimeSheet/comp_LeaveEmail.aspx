<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="comp_LeaveEmail.aspx.cs" Inherits="empTimeSheet.comp_LeaveEmail" %>

<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Leave Email Settings</title>
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

                    <div class="ctrlGroup searchgroup">
                        <label class="lbl lblAuto">
                            Select receivers to get notification emails on employee leave request  :
                        </label>

                    </div>
                    <div class="clear">
                    </div>
                    <div class="ctrlGroup " style="width:100%;">
                        
                        <div class="txt w20">
                            <asp:ListBox ID="listcode1" runat="server" Width="100%" Height="200px" SelectionMode="Multiple"
                                CssClass="nobackimage form-control"></asp:ListBox>
                        </div>
                        <div  class="txt w15" style="text-align:center; height:200px; padding-top:80px;">
                           
                                <input type="button" id="Button1" class="btnadd" 
                                    value=">>" title="Move Right" /><br />
                                   <input type="button" class="btnadd" 
                                    value="<<" id="Button2" title="Move Left" />
                          
                            
                        </div>
                        <div class="txt w20">
                            <asp:ListBox ID="listcode2" runat="server" Width="100%" Height="200px" SelectionMode="Multiple"
                                CssClass="nobackimage form-control"></asp:ListBox>
                        </div>
                           

                    </div>

                    
                    <div class="clear">
                    </div>
                    <div class="ctrlGroup">
                        
                        <input type="hidden" id="hidscheduleemailemp" runat="server" />
                        <asp:Button ID="btnsaveinfo" runat="server" Text="Save" OnClick="btnSave_OnClick" CausesValidation="true" ValidationGroup="save"
                             CssClass="btn-primary" />

                       
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
