<%@ Page Title="" Language="C#" MasterPageFile="~/Client/ClientMaster.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="empTimeSheet.Client.Home" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax" %>
<%@ Register Src="../progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        function showdiv(id) {
            // document.getElementById("ifmanage").src = "LeaveDetails.aspx?empid=" + empid + "&month=" + month + "&year=" + document.getElementById("ctl00_ContentPlaceHolder1_hidyear").value;
            document.getElementById(id).style.display = "block";
            document.getElementById("otherdiv").style.display = "block";

        }
        function closediv() {
            document.getElementById("divmoduledetails").style.display = "none";
            document.getElementById("divtaskdetails").style.display = "none";

            document.getElementById("otherdiv").style.display = "none";
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <pg:progress ID="progress1" runat="server" />
    <div class="pageheader">
        <h1>My Projects
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
    <div class="contentpanel">
        <div class="row">
            <div class="col-sm-12 col-md-12">
                <div class="panel panel-default">


                    <div class="mar2">

                        <div id="otherdiv" onclick="closediv();">
                        </div>
                        <div class="f_right">
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
                        <div class="panel panel-default">
                            <div class="panel-body2">
                                <div class="row">
                                    <div class="table-responsive">
                                        <div class="nodatafound" id="divnodata" runat="server">
                                            No data found
                                        </div>
                                        <asp:GridView ID="dgnews" runat="server" AllowPaging="true" AutoGenerateColumns="False"
                                            PageSize="50" CellPadding="4" CellSpacing="0" Width="100%" ShowHeader="true"
                                            ShowFooter="false" CssClass="table table-success mb30" GridLines="None" AllowSorting="true"
                                            OnSorting="dgnews_Sorting" OnRowCommand="dgnews_RowCommand" OnRowDataBound="dgnews_OnRowDataBound" OnPageIndexChanging="dgnews_PageIndexChanging">
                                            <Columns>
                                                <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="40px">
                                                    <ItemTemplate>
                                                        <%# Container.DataItemIndex + 1 %>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Project ID" SortExpression="projectCode">
                                                    <ItemTemplate>
                                                        <%#DataBinder.Eval(Container.DataItem, "projectCode")%>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Project Name" SortExpression="projectname">
                                                    <ItemTemplate>
                                                        <%#DataBinder.Eval(Container.DataItem, "projectname")%>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="No. of Modules" SortExpression="numofmodules">
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="lnkmodule" runat="server" Text='<%#DataBinder.Eval(Container.DataItem, "numofmodules")%>' ToolTip="Click here to view details"
                                                            CommandArgument='<%#DataBinder.Eval(Container.DataItem, "projectid")%>'
                                                            CommandName="goformodules"></asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="No. of Tasks" SortExpression="numoftasks">
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="lnktasks" runat="server" Text='<%#DataBinder.Eval(Container.DataItem, "numoftasks")%>'
                                                            CommandArgument='<%#DataBinder.Eval(Container.DataItem, "projectid")%>' ToolTip="Click here to view details"
                                                            CommandName="gofortasks"></asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Est. Hours" SortExpression="totalesthours">
                                                    <ItemTemplate>
                                                        <%#DataBinder.Eval(Container.DataItem, "totalesthours")%>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Completion %">
                                                    <ItemTemplate>
                                                        <%#DataBinder.Eval(Container.DataItem, "percomplete")%>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderStyle-Width="18px" ItemStyle-HorizontalAlign="Center">
                                                    <ItemTemplate>
                                                        <a id="lbtnview" href='ProjectStatusReport.aspx?projectid=<%#Eval("projectid")%>'
                                                            title="Project Tree View"><i class="fa fa-fw">
                                                                <img src="images/view.png" /></i>

                                                        </a>
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

                    </div>

                    <div class="clear">
                    </div>
                </div>
                <div class="clear">
                </div>
            </div>
        </div>
    </div>
    <!--Module Pop up dv goes here-->
    <div id="divmoduledetails" class="itempopup" style="width: 750px;">
        <div class="popup_heading">
            <span id="spanstatushead" runat="server">Project Module's Summary</span>
            <div class="f_right">
                <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
            </div>
        </div>
        <div class="innerpopup ">
            <div>
                <div class="f_left">
                    <h3 id="lblprojectcode" runat="server" class="pad3" style=""></h3>
                    <div class="clear"></div>
                    <h3 id="lblprojectname" runat="server" class="pad3" style=""></h3>

                </div>
                <div class="clear">
                </div>
                <div class="line" style="margin-bottom: 5px;">
                </div>
                <%-- <iframe id="ifmanage" width="100%" frameborder="0" noresize="noresize" height="422px"
                    scrolling="auto"></iframe>--%>
                <div class="pad3">
                    <div class="nodatafound" id="divnomoduledata" runat="server">
                        No data found
                    </div>
                    <asp:GridView ID="grdmodule" runat="server" AllowPaging="false" AutoGenerateColumns="False"
                        CellPadding="4" CellSpacing="0" Width="100%" ShowHeader="true"
                        ShowFooter="false" CssClass="table tblsheet " GridLines="None" AllowSorting="false">

                        <Columns>
                            <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="40px">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex + 1 %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Module Title">
                                <ItemTemplate>
                                    <%#DataBinder.Eval(Container.DataItem, "title")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Description">
                                <ItemTemplate>
                                    <%#DataBinder.Eval(Container.DataItem, "description")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="No. of Tasks">
                                <ItemTemplate>
                                    <%#DataBinder.Eval(Container.DataItem, "numoftasks")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Est. Hours">
                                <ItemTemplate>
                                    <%#DataBinder.Eval(Container.DataItem, "totalesthours")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Completion %">
                                <ItemTemplate>
                                    <%#DataBinder.Eval(Container.DataItem, "percomplete")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <%-- <asp:TemplateField HeaderStyle-Width="18px" ItemStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbtnview" CommandName="view" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>'
                                        ToolTip="View Details" runat="server"><i class="fa fa-fw" ><img src="images/view.png" /></i>
                                                            
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>--%>
                        </Columns>
                        <HeaderStyle CssClass="gridheader" />
                        <PagerStyle CssClass="gridpager" HorizontalAlign="Center" />
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>

    <!--Tasks Pop up div goes here-->
    <div id="divtaskdetails" class="itempopup" style="width: 900px;">
        <div class="popup_heading">
            <span id="span1" runat="server">Project Task's Summary</span>
            <div class="f_right">
                <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
            </div>
        </div>
        <div class="innerpopup ">
            <div>
                <div class="f_left">
                    <h3 id="ltrprojectcode" runat="server" class="pad3" style=""></h3>
                    <div class="clear"></div>
                    <h3 id="ltrprojectname" runat="server" class="pad3" style=""></h3>

                </div>
                <div class="clear">
                </div>
                <div class="line" style="margin-bottom: 5px;">
                </div>

                <div class="pad3">
                    <div class="nodatafound" id="divnotaskfound" runat="server">
                        No data found
                    </div>
                    <div class="f_right" style="color: #0000b3;margin-bottom: 10px;">
                        <b>
                          Project Status:  <asp:Literal ID="ltrtotalcommulativehours" runat="server"></asp:Literal> % completed</b>
                    </div>
                    <asp:GridView ID="grdtasks" runat="server" AllowPaging="false" AutoGenerateColumns="False"
                        CellPadding="4" CellSpacing="0" Width="100%" ShowHeader="true"
                        ShowFooter="true" CssClass="table tblsheet " GridLines="None" AllowSorting="false" OnRowDataBound="grdtasks_ItemDataBound">

                        <Columns>
                            <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="40px">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex + 1 %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Task Title">
                                <ItemTemplate>
                                    <%#DataBinder.Eval(Container.DataItem, "title")%>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Module" HeaderStyle-Width="100px">
                                <ItemTemplate>
                                    <%#DataBinder.Eval(Container.DataItem, "parentname")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Est. Hours" HeaderStyle-Width="70px">
                                <ItemTemplate>
                                    <%#DataBinder.Eval(Container.DataItem, "estHours")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Est. End Date" HeaderStyle-Width="100px">
                                <ItemTemplate>
                                    <%#DataBinder.Eval(Container.DataItem, "estEndDate")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Completion %" HeaderStyle-Width="80px">
                                <ItemTemplate>
                                    <%#DataBinder.Eval(Container.DataItem, "percomplete")%>%
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Weightage Hours" HeaderStyle-Width="100px">
                                <ItemTemplate>
                                    <%#DataBinder.Eval(Container.DataItem, "weightagehours")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Commulative Completion %" HeaderStyle-Width="160px">
                                <ItemTemplate>
                                    <%#DataBinder.Eval(Container.DataItem, "commulativestatus")%>%
                                </ItemTemplate>
                                <FooterTemplate>
                                </FooterTemplate>
                            </asp:TemplateField>

                        </Columns>
                        <HeaderStyle CssClass="gridheader" />
                        <PagerStyle CssClass="gridpager" HorizontalAlign="Center" />
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>

    <input type="hidden" id="hidprojectid" runat="server" />
    <input type="hidden" id="hidsearchprojectid" runat="server" />
    <input type="hidden" id="hidcurrentview" runat="server" value="list" />
</asp:Content>
