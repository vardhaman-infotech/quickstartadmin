<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="ConfigurationReport.aspx.cs" Inherits="empTimeSheet.ConfigurationReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="Stylesheet" type="text/css" href="css/server_2.0.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script type="text/javascript">
        function clientvalidate() {
            if (document.getElementById("ctl00_ContentPlaceHolder1_dropclient").value == "") {
                alert("Select a Client name");
                return false;
            }
            else {
                return true;
            }

        }

    
    </script>
    <pg:progress ID="progress1" runat="server" />
    <asp:UpdatePanel ID="upadatepanel" runat="server">
        <ContentTemplate>
            <div id="otherdiv" onclick="closediv();">
            </div>
            <div class="pageheader">
                <h2>
                    <i class="fa fa-desktop"></i>Server Configuration Report
                </h2>
                <div class="breadcrumb-wrapper mar ">
                    <input type="hidden" id="hidid" runat="server" />
                    <asp:LinkButton ID="btnexportcsv" runat="server" OnClick="btnexportcsv_Click" CssClass="right_link">
               <i class="fa fa-fw fa-file-excel-o topicon"></i> Export to Excel</asp:LinkButton>
                </div>
                <div class="clear">
                </div>
            </div>
            <div class="contentpanel">
                <div class="row">
                    <div class="col-sm-12 col-md-12">
                        <div class="panel panel-default">
                            <div class="col-sm-12 col-md-10">
                                <div style="padding-top: 10px;">
                                    <div class="col-xs-12 col-sm-8 col-md-6 f_left" style="padding: 0px;">
                                        <h5 class="subtitle mb5">
                                            Configuration Report</h5>
                                    </div>
                                    <div class="clear">
                                    </div>
                                </div>
                                <%-- <div style="margin-left: 3px">
            <asp:Button ID="btnFullReport" runat="server" CssClass="button" Text="View Full Report"
                OnClick="btnFullReport_click " />
        </div>--%>
                            </div>
                            <div class="clear">
                            </div>
                            <div class="col-sm-12 col-md-12">
                                <asp:MultiView ID="multiview1" runat="server" ActiveViewIndex="0">
                                    <asp:View ID="view1" runat="server">
                                        <div class="">
                                            <div class="col-sm-6 col-md-4  pad4">
                                                <asp:DropDownList ID="dropclient" runat="server" CssClass="form-control mar pad3"
                                                    AutoPostBack="true" OnSelectedIndexChanged="dropclient_SelectedIndexChanged">
                                                </asp:DropDownList>
                                            </div>
                                            <div class="col-sm-6 col-md-4  pad5">
                                                <asp:DropDownList ID="dropserver" runat="server" CssClass="form-control mar pad3">
                                                </asp:DropDownList>
                                            </div>
                                            <div class="col-sm-6 col-md-4 pad4">
                                                <asp:Button ID="btnsearch" runat="server" CssClass="btn btn-default mar" Text="View Report"
                                                    OnClick="btnsearch_click" />
                                                <asp:Button ID="btnFullReport" runat="server" CssClass="btn btn-default mar" Text="View Full Report"
                                                    OnClientClick="return                                                  clientvalidate();"
                                                    OnClick="btnFullReport_click" />
                                            </div>
                                        </div>
                                        <div class="clear">
                                        </div>
                                        <div class="f_right" style="padding-top: 10px;">
                                            <span class="f_left">
                                                <asp:LinkButton ID="lnkprevious" runat="server" OnClick="lnkprevious_Click"> <i class="fa fa-fw fa-fast-backward color_green"></i></asp:LinkButton>
                                            </span>
                                            <p class="f_left page">
                                                <asp:Label ID="lblstart" runat="server"></asp:Label>
                                                -
                                                <asp:Label ID="lblend" runat="server"></asp:Label>
                                                of <strong>
                                                    <asp:Label ID="lbltotalrecord" Font-Bold="true" runat="server"></asp:Label></strong>
                                            </p>
                                            <span class="f_left">
                                                <asp:LinkButton ID="lnknext" runat="server" OnClick="lnknext_Click">  <i class="fa fa-fw fa-fast-forward color_green"></i></asp:LinkButton>
                                            </span>
                                        </div>
                                        <div class="clear">
                                        </div>
                                        <div class="panel panel-default">
                                            <div class="panel-body2 ">
                                                <div class="row">
                                                    <div class="table-responsive">
                                                        <div class="nodatafound" id="divnodata" runat="server">
                                                            No data found</div>
                                                        <asp:GridView ID="dgnews" runat="server" AllowPaging="true" AutoGenerateColumns="false"
                                                            CellPadding="4" CellSpacing="0" BorderWidth="0px" Width="100%" ShowHeader="true"
                                                            ShowFooter="false" CssClass="table table-success mb30" GridLines="None" OnRowCommand="dgnews_ItemCommand"
                                                            OnPageIndexChanging="dgnews_PageIndexChanging">
                                                            <Columns>
                                                                <asp:TemplateField HeaderText="S.No." ItemStyle-Width="20px">
                                                                    <ItemTemplate>
                                                                        <%# Container.DataItemIndex + 1 %>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Server ID">
                                                                    <ItemTemplate>
                                                                        <%# DataBinder.Eval(Container.DataItem, "ServerCode")%>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Server Name">
                                                                    <ItemTemplate>
                                                                        <%# DataBinder.Eval(Container.DataItem, "ServerName")%>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Client Name">
                                                                    <ItemTemplate>
                                                                        <%# DataBinder.Eval(Container.DataItem, "clientname")%>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Domain">
                                                                    <ItemTemplate>
                                                                        <%# DataBinder.Eval(Container.DataItem, "domain")%>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField ItemStyle-Width="17px">
                                                                    <ItemTemplate>
                                                                        <asp:LinkButton ID="lbtndetail" CommandName="viewdetail" CommandArgument='<%#Eval("nid") + ";" + Eval("clientid") %>'
                                                                            ToolTip="View" runat="server"><img src="images/view.png" /></asp:LinkButton>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                            </Columns>
                                                            <HeaderStyle CssClass="gridheader" />
                                                            <PagerStyle CssClass="gridpager" HorizontalAlign="Center" />
                                                        </asp:GridView>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </asp:View>
                                    <asp:View ID="viewdetail" runat="server">
                                        <div class="right_index">
                                            <%-- <h1 class="heading">
                        Server Configuration Report
                    </h1>--%>
                                            <div class="f_right">
                                                <asp:LinkButton ID="lbtnback" runat="server" OnClick="btnback_Click"><img src="images/arrow_left.png" alt="Back" /></asp:LinkButton>
                                            </div>
                                            <div class="clear">
                                            </div>
                                            <div id="DivExport" runat="server">
                                                <asp:Repeater ID="repclients" runat="server" OnItemDataBound="repclients_ItemDataBound">
                                                    <ItemTemplate>
                                                        <h1 style="border-bottom: 1px solid #dadada; float: left; margin-bottom: 40px; width: 100%;
                                                            font-size: 30px; color: #333333;" class="heading pad30">
                                                            <%#Eval("ClientName") %>
                                                        </h1>
                                                        <div class="clear">
                                                        </div>
                                                        <asp:Repeater ID="replogreport" runat="server" OnItemDataBound="replogreport_ItemDataBound">
                                                            <ItemTemplate>
                                                                <div class="server_box mar20" style="-moz-border-bottom-colors: none; -moz-border-left-colors: none;
                                                                    -moz-border-right-colors: none; -moz-border-top-colors: none; border-color: #bababa #bababa #e0e0e0;
                                                                    border-image: none; border-style: solid; border-width: 1px 1px 4px; width: 100%;">
                                                                    <div style="background: #eeeeee none repeat scroll 0 0; border-bottom: 1px solid #bababa;"
                                                                        class="date_heding">
                                                                        <div class="rowserver">
                                                                            <table style="width: 100%" border="1" cellpadding="0" cellspacing="0">
                                                                                <tr>
                                                                                    <td width="50%">
                                                                                        <table>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <h3>
                                                                                                        <label>
                                                                                                            Server ID
                                                                                                        </label>
                                                                                                    </h3>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <h3>
                                                                                                        <span>
                                                                                                            <%#Eval("servercode")%>
                                                                                                            <input type="hidden" id="hidserid" runat="server" value=' <%#Eval("nid")%>' />
                                                                                                        </span>
                                                                                                    </h3>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                    <td>
                                                                                        <table>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <h3>
                                                                                                        <label>
                                                                                                            Server ID
                                                                                                        </label>
                                                                                                    </h3>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <h3>
                                                                                                        <span>
                                                                                                            <%#Eval("servercode")%>
                                                                                                            <input type="hidden" id="Hidden1" runat="server" value=' <%#Eval("nid")%>' />
                                                                                                        </span>
                                                                                                    </h3>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                            <div class="clear">
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <div class="clear">
                                                                    </div>
                                                                    <div class="server_inner">
                                                                        <h2 class="heading_2">
                                                                            Basic Information
                                                                        </h2>
                                                                        <div class="clear">
                                                                        </div>
                                                                        <div class="server_box">
                                                                            <div class="rowserver">
                                                                                <div style="width: 100%">
                                                                                    <table style="width: 100%" border="1" cellpadding="0" cellspacing="0">
                                                                                        <tr>
                                                                                            <td width="50%">
                                                                                                <table>
                                                                                                    <tr>
                                                                                                        <td>
                                                                                                            <label>
                                                                                                                Domain
                                                                                                            </label>
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <span>
                                                                                                                <%#Eval("domain")%>
                                                                                                            </span>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                </div>
                                                                                <div class="width_server">
                                                                                    <td>
                                                                                        <table>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <label>
                                                                                                        Added By
                                                                                                    </label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <span>
                                                                                                        <%#Eval("username")%>
                                                                                                    </span>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                    </tr> </table>
                                                                                </div>
                                                                                <div class="clear">
                                                                                </div>
                                                                            </div>
                                                                            <div class="clear">
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <div class="line">
                                                                    </div>
                                                                    <div class="clear">
                                                                    </div>
                                                                    <div class="server_inner">
                                                                        <asp:Repeater ID="rptconfig" runat="server" OnItemDataBound="rptconfig_ItemDataBound">
                                                                            <ItemTemplate>
                                                                                <div class="server_inner">
                                                                                    <h2 class="heading_2">
                                                                                        <%#Eval("type")%>
                                                                                    </h2>
                                                                                    <div class="clear">
                                                                                    </div>
                                                                                    <div class="server_box mar20">
                                                                                        <asp:DataList ID="rptconfig_inner" runat="server" RepeatColumns="2" Width="100%"
                                                                                            CellPadding="0" RepeatDirection="Horizontal" CellSpacing="0">
                                                                                            <ItemTemplate>
                                                                                                <div class="width_server">
                                                                                                    <label>
                                                                                                        <%#Eval("name")%>:
                                                                                                    </label>
                                                                                                    <span>
                                                                                                        <%#Eval("configvalue")%>
                                                                                                    </span>
                                                                                                </div>
                                                                                                <div class="clear">
                                                                                                </div>
                                                                                            </ItemTemplate>
                                                                                            <ItemStyle CssClass="row1" />
                                                                                        </asp:DataList>
                                                                                    </div>
                                                                                    <div class="clear">
                                                                                    </div>
                                                                                </div>
                                                                            </ItemTemplate>
                                                                        </asp:Repeater>
                                                                    </div>
                                                                    <div class="line">
                                                                    </div>
                                                                    <div class="clear">
                                                                    </div>
                                                                    <div class="clear">
                                                                    </div>
                                                                </div>
                                                                <div class="clear">
                                                                </div>
                                                            </ItemTemplate>
                                                        </asp:Repeater>
                                                    </ItemTemplate>
                                                </asp:Repeater>
                                                <div id="divdetailreport" runat="server" style="display: none;">
                                                    <asp:Repeater ID="rptreport" runat="server">
                                                        <HeaderTemplate>
                                                            <table width="100%">
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <tr>
                                                                <td align="left" style="font-weight: bold; background: #395ba4; color: #ffffff;">
                                                                    Client Name
                                                                </td>
                                                                <td>
                                                                    <%#Eval("clientname") %>
                                                                </td>
                                                                <td align="left" style="font-weight: bold; background: #395ba4; color: #ffffff;">
                                                                    Server ID
                                                                </td>
                                                                <td>
                                                                    <%#Eval("servercode") %>
                                                                </td>
                                                                <td align="left" style="font-weight: bold; background: #395ba4; color: #ffffff;">
                                                                    Server Name
                                                                </td>
                                                                <td>
                                                                    <%#Eval("servername") %>
                                                                </td>
                                                            </tr>
                                                        </ItemTemplate>
                                                        <FooterTemplate>
                                                            </table>
                                                        </FooterTemplate>
                                                    </asp:Repeater>
                                                </div>
                                            </div>
                                        </div>
                                    </asp:View>
                                </asp:MultiView>
                            </div>
                            <div class="clear">
                            </div>
                        </div>
                        <!--Panel-default-->
                    </div>
                    <!---col-sm-12 col-md-12-->
                </div>
                <!---row-->
            </div>
            <!---contentpanel-->
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnexportcsv" />
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>
