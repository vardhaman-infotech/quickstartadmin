<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="progressbar.ascx.cs" Inherits="emptimesheet.admin.progressbar" %>
<div style="width: 100%">
    <asp:UpdateProgress ID="UpdateProg1" DisplayAfter="0" runat="server">
        <ProgressTemplate>
            <div class="updateprogress">
            </div>
            <img src="images/indicator.gif" alt="Processing" style="top: 50%; left: 50%; z-index: 9999999;
                position: fixed;" />
        </ProgressTemplate>
    </asp:UpdateProgress>
</div>
