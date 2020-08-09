<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="PayrollPlan.aspx.cs" Inherits="empTimeSheet.PayrollPlan" %>

<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:UpdatePanel ID="upadatepanel1" runat="server">
        <ContentTemplate>
            <input type="hidden" id="hidid" runat="server" />
            <pg:progress ID="progress1" runat="server" />
            <div class="heading">
                <h1>
                    Payroll Plan
                </h1>
            </div>
            <div class="clear">
            </div>
            <div class="f_left" style="width: 100%; padding-top:10px;">
                <div class="form_1">
                    <asp:Repeater ID="repearning" runat="server">
                        <HeaderTemplate>
                            <div style="width: 45%; float: left; margin-right: 20px;">
                                <table class="tblsheet" width="95%" cellpadding="4" cellspacing="0">
                                    <tr class="gridheader">
                                        <th colspan="2" style="text-align:left;" >
                                            Earnings
                                        </th>
                                    </tr>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr class="odd">
                                <td width="60%">
                                    <input type="hidden" id="hidid" runat="server" value='<%#Eval("nid")%>' />
                                    <asp:TextBox ID="txttitle" Width="98%" runat="server" Text='<%#Eval("title")%>'></asp:TextBox>
                                </td>
                                <td>
                                    <asp:TextBox Width="70px" ID="txtamount" runat="server" Text='<%#Eval("amount")%>'></asp:TextBox>&nbsp;<%#Eval("amt_detail")%></td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                            </table> </div>
                        </FooterTemplate>
                    </asp:Repeater>
                    <asp:Repeater ID="repdeduction" runat="server">
                        <HeaderTemplate>
                            <div style="width: 45%; float: left;">
                                <table class="tblsheet" width="95%" cellpadding="4" cellspacing="0">
                                    <tr class="gridheader">
                                        <th colspan="2" style="text-align:left;">
                                            Deductions
                                        </th>
                                    </tr>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr class="odd">
                                <td width="60%">
                                    <input type="hidden" id="hidid" runat="server" value='<%#Eval("nid")%>' />
                                    <asp:TextBox ID="txttitle" runat="server" Width="98%" Text='<%#Eval("title")%>'></asp:TextBox>
                                </td>
                                <td>
                                    <asp:TextBox Width="70px" ID="txtamount" runat="server" Text='<%#Eval("amount")%>'></asp:TextBox>&nbsp;<%#Eval("amt_detail")%></td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                            </table> </div>
                        </FooterTemplate>
                    </asp:Repeater>
                    <div class="clear"></div>

                     <div style="padding-top:10px;">
                        <asp:Button ID="btnsubmit" runat="server" CssClass="button" Text="Save" ValidationGroup="save"
                            OnClick="btnsubmit_Click" /></div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
