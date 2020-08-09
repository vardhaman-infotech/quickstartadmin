<%@ Page Title="" Language="C#" MasterPageFile="~/Client/ClientMaster.Master" AutoEventWireup="true" CodeBehind="EmpTimeSheet.aspx.cs" Inherits="empTimeSheet.Client.EmpTimeSheet" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax" %>
<%@ Register Src="../progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <pg:progress ID="progress1" runat="server" />
    <div class="pageheader">
        <h1>TimeSheet
        </h1>
        <div class="breadcrumb-wrapper mar ">
            <asp:LinkButton ID="btnexportcsv" runat="server" OnClick="btnexportcsv_Click" CssClass="right_link">
          <i class="fa fa-fw fa-file-excel-o topicon"></i>Export to Excel</asp:LinkButton>
            <%--  <asp:LinkButton ID="lnkrefresh" runat="server" OnClick="btnrefresh_Click" CssClass="right_link">
            <i  class="fa fa-fw" style="padding-right: 10px; font-size: 12px; border: none;"></i>Refresh</asp:LinkButton>--%>
        </div>
        <div class="clear">
        </div>
    </div>




    <div style="padding-top: 10px;">
        <div class="f_left pad4">

            <asp:TextBox ID="txtfrom" runat="server" CssClass="input_width2 hasDatepicker marright5"></asp:TextBox>

            <ajax:CalendarExtender ID="txtDate_CalendarExtender" runat="server" TargetControlID="txtfrom"
                PopupButtonID="txtfrom" Format="MM/dd/yyyy">
            </ajax:CalendarExtender>

        </div>
        <div class="f_left">

            <asp:TextBox ID="txtto" runat="server" CssClass="input_width2 hasDatepicker"></asp:TextBox>

            <ajax:CalendarExtender ID="txtDate_CalendarExtender1" runat="server" TargetControlID="txtto"
                PopupButtonID="txtto" Format="MM/dd/yyyy">
            </ajax:CalendarExtender>

        </div>
        <div class="clear"></div>
        <div class="f_left  mar pad4">
            <asp:DropDownList ID="dropemployee" runat="server" CssClass="drop_width2 marright5">
            </asp:DropDownList>
        </div>
        <div class="f_left  mar">
            <asp:DropDownList ID="dropproject" runat="server" CssClass="drop_width2 marright5">
            </asp:DropDownList>
        </div>
        <div class="col-sm-6 col-md-4 pad5">
            <asp:Button ID="btnsearch" runat="server" Text="Search" CssClass="btn btn-default mar"
                OnClick="btnsearch_Click" />
        </div>
    </div>

    <div class="clear">
    </div>

    <div>
        <div class="mar2">
            <div class="f_right">
                <asp:Label ID="ltrtotalhours" runat="server" CssClass="f_left pad4"></asp:Label>
                <asp:LinkButton ID="lnkprevious" CssClass="f_left" runat="server" OnClick="lnkprevious_Click">
            <i class="fa fa-fw fa-fast-backward color_green"></i></asp:LinkButton>
                <div class="f_left page">
                    <asp:Label ID="lblstart" runat="server"></asp:Label>
                    -
                                        <asp:Label ID="lblend" runat="server"></asp:Label>
                    of <strong>
                        <asp:Label ID="lbltotalrecord" Font-Bold="true" runat="server"></asp:Label></strong>
                </div>
                <asp:LinkButton ID="lnknext" CssClass="f_left" runat="server" OnClick="lnknext_Click"> <i class="fa fa-fw fa-fast-forward color_green"></i></asp:LinkButton>

                
            </div>
            <div class="clear">
            </div>
            <div class="f_right">
            </div>
            <div class="clear"></div>
            <asp:GridView ID="dgnews" runat="server" AllowPaging="true" AutoGenerateColumns="False"
                CellPadding="4" CellSpacing="0" Width="100%" ShowHeader="true" ShowFooter="false" PageSize="50"
                CssClass="table table-success mb30" GridLines="None" ShowHeaderWhenEmpty="true"
                OnRowDataBound="dgnews_OnRowDataBound" OnPageIndexChanging="dgnews_PageIndexChanging">
                <Columns>


                    <asp:TemplateField HeaderText="Date" HeaderStyle-Width="80px">
                        <ItemTemplate>
                            <%#Eval("date")%>
                        </ItemTemplate>

                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Project" HeaderStyle-Width="110px">
                        <ItemTemplate>
                            <%#Eval("projectcode")%>
                        </ItemTemplate>

                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Employee" HeaderStyle-Width="100px">
                        <ItemTemplate>
                            <%#Eval("empname")%>
                        </ItemTemplate>

                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Task ID" HeaderStyle-Width="80px">
                        <ItemTemplate>
                            <%# DataBinder.Eval(Container.DataItem, "taskcodenamesmall")%>
                        </ItemTemplate>

                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Description" FooterStyle-HorizontalAlign="Right">
                        <ItemTemplate>
                            <%# DataBinder.Eval(Container.DataItem, "taskdescription")%>
                        </ItemTemplate>
                        <FooterTemplate>
                            <b>Total Hours: </b>
                        </FooterTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Hours" HeaderStyle-Width="50px">
                        <ItemTemplate>
                            <asp:Literal ID="ltrhours" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "Hours")%>'></asp:Literal>
                        </ItemTemplate>
                        <FooterTemplate>
                            <b>
                                <asp:Literal ID="ltrtotalhours" runat="server"></asp:Literal></b>
                        </FooterTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Activity">
                        <ItemTemplate>
                            <%# DataBinder.Eval(Container.DataItem, "description")%>
                        </ItemTemplate>

                    </asp:TemplateField>


                </Columns>
                <FooterStyle CssClass="gridfooter" />
                <HeaderStyle CssClass="gridheader" />
                <EmptyDataRowStyle CssClass="nodatafound" />
            </asp:GridView>
            <input type="hidden" id="hidfromdate" runat="server" />
            <input type="hidden" id="hidtodate" runat="server" />
            <input type="hidden" id="hidempid" runat="server" />
            <input type="hidden" id="hidtotalhours" runat="server" value="0" />
            <input type="hidden" id="hidsearchproject" runat="server" />
            <input type="hidden" id="hidsearchemp" runat="server" />
            <input type="hidden" id="hidprojectid" runat="server" />
        </div>
    </div>




</asp:Content>
