<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="progressbar.ascx.cs" Inherits="WingsOfAmerica.progressbar" %>
<div style="width: 100%">
    
    <asp:UpdateProgress ID="UpdateProg1" DisplayAfter="0" runat="server" >
        <ProgressTemplate>
             <%-- <div class="progressdiv" style="z-index: 9999999;">
            </div>--%>
        </ProgressTemplate>
    </asp:UpdateProgress>
</div>