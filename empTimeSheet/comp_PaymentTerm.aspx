<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="comp_PaymentTerm.aspx.cs" Inherits="empTimeSheet.comp_PaymentTerm" %>


<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Bill Settings</title>
    <link rel="stylesheet" type="text/css"  href="css/companySettingMain5.0.css"  />
    <script type="text/javascript" src="js/companySettings.js"></script>
    <script>
        window.parent.document.getElementById("divcompanyloader").style.display = "block";

        
        function setmaxday(txt) {
            if (parseInt($(txt).val()) > 365) {
                $(txt).val(365);
            }
}
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

                    <asp:GridView ID="dgnews" runat="server" AllowPaging="false" AutoGenerateColumns="False"
                        CellPadding="4" CellSpacing="0" Width="100%" ShowHeader="true" ShowFooter="true"
                        CssClass="tblsheet" GridLines="None" OnRowCommand="dgnews_RowCommand" OnRowDataBound="dgnews_RowDataBound"
                        OnRowCancelingEdit="dgnews_RowCancelingEdit" OnRowDeleting="dgnews_RowDeleting"
                        OnRowEditing="dgnews_RowEditing" OnRowUpdating="dgnews_RowUpdating" ShowHeaderWhenEmpty="true">
                        <Columns>
                            <asp:TemplateField HeaderStyle-Width="3%" ItemStyle-VerticalAlign="Middle">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbtndelete" CommandName="del" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>'
                                        ToolTip="Delete" runat="server" OnClientClick='return confirm("Delete this record? Yes or No");'><i class="fa fa-fw" >
                                                            
                                                            <img src="images/delete.png" alt=""></i></asp:LinkButton>
                                </ItemTemplate>
                                <FooterTemplate>
                                </FooterTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Term Name" HeaderStyle-Width="60%" >
                                <ItemTemplate>

                                    <%# DataBinder.Eval(Container.DataItem, "payTerm")%>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <input id="hidid" runat="server" type="hidden" value='<%# DataBinder.Eval(Container.DataItem, "nid")%>'
                                        class="form-control" />
                                    <asp:TextBox ID="txtpayterm" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "payTerm")%>'
                                        CssClass="form-control" ></asp:TextBox>

                                </EditItemTemplate>
                                <FooterTemplate>

                                    <asp:TextBox ID="txtpayterm" runat="server" Text=''
                                        CssClass="form-control"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtpayterm" Style="display: none;"
                                        ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator>
                                </FooterTemplate>
                            </asp:TemplateField>


                            <asp:TemplateField HeaderText="Grace Days " HeaderStyle-Width="10%" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                                <ItemTemplate>
                                    <%# DataBinder.Eval(Container.DataItem, "graceDays")%>&nbsp;
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtgracedays" onchange="setmaxday(this)" onkeypress="blockNonNumbers(this, event, true, false);"
                                        MaxLength="3" onkeyup="extractNumber(this,2,false);" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "graceDays")%>'
                                        CssClass="form-control" style="width:60px !important; text-align:right; padding-right:5px;float:right; margin-right:3px;"></asp:TextBox>

                                </EditItemTemplate>
                                <FooterTemplate>
                                    <asp:TextBox ID="txtgracedays"  onchange="setmaxday(this)" onkeypress="blockNonNumbers(this, event, true, false);"
                                        MaxLength="3" onkeyup="extractNumber(this,2,false);" runat="server" Text=''
                                        CssClass="form-control" style="width:60px !important; text-align:right; padding-right:5px;float:right;margin-right:3px;"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtgracedays" Style="display: none;"
                                        ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator>
                                </FooterTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderStyle-Width="10%" ItemStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lnkedit" runat="server" CommandName="Edit" ToolTip="Edit" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "nid")%>'>
                                  <img src="images/edit.png" />
                                    </asp:LinkButton>

                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:LinkButton ID="lnkupdate" runat="server" CommandName="Update" ToolTip="Update" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "nid")%>'>
                                  <img src="images/approved.png" />
                                    </asp:LinkButton>
                                    &nbsp;
                                <asp:LinkButton ID="lnkcancel" runat="server" CommandName="Cancel" ToolTip="Cancel" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "nid")%>'>
                                  <img src="images/rejected.png" />
                                </asp:LinkButton>
                                </EditItemTemplate>
                                <FooterTemplate>
                                    <asp:Button ID="btnsubmit" runat="server" CssClass="btn btn-primary" Text="Save" style="margin:0px auto; float:none; display:block;" CausesValidation="true"
                                        ValidationGroup="save"  CommandName="EmptyInsert" OnClientClick="var valFunc1 = validatefieldsbygroup('save');if(valFunc1 == true) {return true;} else{return false;}"  />
                                </FooterTemplate>
                            </asp:TemplateField>





                        </Columns>

                        <HeaderStyle CssClass="gridheader" />
                        <EmptyDataRowStyle CssClass="nodatafound" />
                    </asp:GridView>
                    <div class="ctrlGroup">
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
