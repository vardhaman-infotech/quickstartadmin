<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="progressbar.ascx.cs" Inherits="Appintment.progressbar" %>
<div style="width: 100%">
    
    <asp:UpdateProgress ID="UpdateProg1" DisplayAfter="0" runat="server" >
        <ProgressTemplate>
            <div class="progressdiv">
            </div>
            <img src="images/loading.gif" alt="Processing" style="top: 50%; left: 48%; z-index: 1005;
                position: fixed;" />
        </ProgressTemplate>
    </asp:UpdateProgress>
</div>