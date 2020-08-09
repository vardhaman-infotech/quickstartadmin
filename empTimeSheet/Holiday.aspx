<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="Holiday.aspx.cs" Inherits="empTimeSheet.Holiday" %>

<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">

        function closediv() {

            document.getElementById("<%=divaddnew.ClientID %>").style.display = "none";

            document.getElementById("otherdiv").style.display = "none";

        }

        function opendiv() {
            setposition("<%=divaddnew.ClientID %>");
            document.getElementById("<%=divaddnew.ClientID %>").style.display = "block";
            document.getElementById("otherdiv").style.display = "block";
        }
        

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:UpdatePanel ID="upadatepanel1" runat="server">
        <ContentTemplate>
            <input type="hidden" id="hidid" runat="server" />
            <pg:progress ID="progress1" runat="server" />
            <div class="pageheader">
                <h2>
                    <i class="fa fa-calendar-o"></i>Holidays
                </h2>
                <div class="breadcrumb-wrapper mar ">
                    <asp:LinkButton ID="btnexportcsv" runat="server" CssClass="right_link" OnClick="btnexportcsv_Click">
                    <i class="fa fa-fw fa-file-excel-o topicon"></i>Export to Excel</asp:LinkButton>
                    <a id="liaddnew" runat="server" class="right_link" onclick="opendiv();"><i class="fa fa-fw fa-plus topicon">
                    </i>Add Holiday</a>
                </div>
                <div class="clear">
                </div>
            </div>
            <div class="contentpanel">
                <div id="otherdiv" onclick="closediv();">
                </div>
                <div class="row">
                    <div class="col-sm-12 col-md-12">
                        <div class="panel panel-default">
                            <div class="col-sm-12 col-md-10">
                                <div style="padding-top: 10px;">
                                    <div class="col-xs-12 col-sm-12 col-md-12 f_left" style="padding: 0px;">
                                        <h5 class="subtitle mb5">
                                            Holidays</h5>
                                    </div>
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl2">Year :</label>
                                        <div class="txt w1 mar10">
                                        <asp:DropDownList ID="dropyear" runat="server" CssClass="form-control">
                                         
                                        </asp:DropDownList>
                                    </div></div>
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl">Months :</label>
                                        <div class="txt w1 mar10">
                                        <asp:DropDownList ID="dropmonth" runat="server" CssClass="form-control">
                                            <asp:ListItem Value="">--All Months--</asp:ListItem>
                                            <asp:ListItem Value="1">January</asp:ListItem>
                                            <asp:ListItem Value="2">February</asp:ListItem>
                                            <asp:ListItem Value="3">March</asp:ListItem>
                                            <asp:ListItem Value="4">April</asp:ListItem>
                                            <asp:ListItem Value="5">May</asp:ListItem>
                                            <asp:ListItem Value="6">June</asp:ListItem>
                                            <asp:ListItem Value="7">July</asp:ListItem>
                                            <asp:ListItem Value="8">August</asp:ListItem>
                                            <asp:ListItem Value="9">September</asp:ListItem>
                                            <asp:ListItem Value="10">October</asp:ListItem>
                                            <asp:ListItem Value="11">November</asp:ListItem>
                                            <asp:ListItem Value="12">December</asp:ListItem>
                                        </asp:DropDownList>
                                            </div>
                                    </div>
                                    <div class="clear"></div>
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl2">Staff :</label>
                                        <div class="txt w1 mar10">
                                        <asp:DropDownList ID="dropbranchsearch" runat="server" CssClass="form-control">
                                        </asp:DropDownList>
                                            </div>
                                    </div>
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl">Holiday Name :</label>
                                        <div class="txt w1 mar10">
                                        <asp:TextBox ID="txtsearch" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                        </div>
                                    <div class="clear"></div>
                                     <div class="ctrlGroup searchgroup">
                                         <label class="lbl lbl2">Type :</label>
                                         <div class="txt w1 mar10">
                                         <asp:DropDownList ID="dropholidaytype" runat="server" CssClass="form-control">
                                          <asp:ListItem Value="">--All Type--</asp:ListItem>
                                         <asp:ListItem Value="General">General</asp:ListItem>
                                         <asp:ListItem Value="Weekend">Weekend</asp:ListItem>
                                        </asp:DropDownList>
                                             </div>
                                    </div>
                                    
                                    <div class="ctrlGroup searchgroup" style="margin-left: 30px;">
                                        <label class="lbl lbl2 disNone">&nbsp; </label>
                                        <asp:Button ID="btnsearch" runat="server" Text="Search" CssClass="btn btn-default"
                                            OnClick="btnsearch_Click" />
                                    </div>
                                </div>
                            </div>
                            <div class="clear">
                            </div>
                            <div class="col-sm-12 col-md-12 mar2">
                                <div class="f_right">
                                    <span class="f_left">
                                        <asp:LinkButton ID="lnkprevious" runat="server" OnClick="lnkprevious_Click">
            <i class="fa fa-fw fa-fast-backward color_green"></i></asp:LinkButton>
                                    </span>
                                    <p class="f_left
            page">
                                        <asp:Label ID="lblstart" runat="server"></asp:Label>
                                        -
                                        <asp:Label ID="lblend" runat="server"></asp:Label>
                                        of <strong>
                                            <asp:Label ID="lbltotalrecord" Font-Bold="true" runat="server"></asp:Label></strong>
                                    </p>
                                    <span class="f_left">
                                        <asp:LinkButton ID="lnknext" runat="server" OnClick="lnknext_Click"> <i class="fa fa-fw fa-fast-forward color_green"></i></asp:LinkButton>
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
                                                <asp:GridView ID="dgnews" runat="server" AllowPaging="true" AutoGenerateColumns="False"
                                                    PageSize="50" OnRowCommand="dgnews_RowCommand" CellPadding="4" CellSpacing="0"
                                                    BorderWidth="0px" Width="100%" ShowHeader="true" ShowFooter="false" CssClass="table table-success mb30"
                                                    GridLines="None" BorderStyle="None" AllowSorting="true" OnPageIndexChanging="dgnews_PageIndexChanging"
                                                    OnRowDataBound="dgnews_RowDataBound">
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="42px">
                                                            <ItemTemplate>
                                                                <%# Container.DataItemIndex + 1 %>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Date" SortExpression="date" HeaderStyle-Width="120px">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "date")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Holiday Name" SortExpression="name">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "name")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Branch Name" SortExpression="branchname">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "branchname")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderStyle-Width="60px">
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="lbtnedit" CommandName="viewdetail" CommandArgument='<%# Eval("nid")%>'
                                                                    ToolTip="Edit" runat="server" Style="float: left;"><i class="fa fa-fw" style="font-size: 18px; color: #d9534f; display: block; margin: auto;
                                                            padding-top: 10px;">
                                                            <img src="images/edit.png" alt=""></i></asp:LinkButton>
                                                                <asp:LinkButton ID="lbtndelete" CommandName="del" Style="margin-top: 2px; float: left;"
                                                                    CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>' ToolTip="Delete"
                                                                    runat="server" 
                                                                    OnClientClick='return confirm("Delete this record?Yes or No");'><i class="fa fa-fw" style="font-size: 18px; color: #d9534f; display: block; margin: auto;
                                                            padding-top: 8px;">
                                                            <img src="images/delete.png" alt=""></i></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                    <EmptyDataTemplate>
                                                        No Holiday</EmptyDataTemplate>
                                                    <HeaderStyle CssClass="gridheader" />
                                                    <RowStyle CssClass="odd" />
                                                    <AlternatingRowStyle CssClass="even" />
                                                    <EmptyDataRowStyle CssClass="nodatafound" />
                                                    <PagerStyle CssClass="gridpager" HorizontalAlign="Center" />
                                                </asp:GridView>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <input type="hidden" runat="server" id="Hidden1" />
                                <div class="clear">
                                </div>
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
            <!---ADD NEW div goes here-->
            <div style="display: none; width: 600px;" runat="server" id="divaddnew" class="itempopup">
                <div class="popup_heading">
                    <span id="legendaction" runat="server">Add Holiday</span>
                    <div class="f_right">
                        <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
                    </div>
                </div>
                <div class="tabContents">
                    <div class="col-xs-12 clear mar">
                        <div class="ctrlGroup searchgroup">
                            <label class="lbl">Date :<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtdate"
                                    ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator>
                            </label>
                            <div class="txt w2">
                               
                                    <asp:TextBox ID="txtdate" runat="server" CssClass="form-control hasDatepicker" onchange="checkdate(this.value,this.id);"></asp:TextBox>
                                  
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtdate"
                                        PopupButtonID="txtdate" Format="MM/dd/yyyy">
                                    </cc1:CalendarExtender>
                               
                            </div>
                        </div>
                        <div class="ctrlGroup searchgroup">
                            <label class="lbl">Holiday Name :<asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                                    ErrorMessage="*" ValidationGroup="save" CssClass="errmsg" ControlToValidate="txtholidayname"></asp:RequiredFieldValidator>
                            </label>
                            <div class="txt w2">
                                <asp:TextBox ID="txtholidayname" runat="server" CssClass="form-control"></asp:TextBox>
                            </div> 
                        </div>
                        <div class="ctrlGroup searchgroup">
                            <label class="lbl">Branch Name:</label>
                            <div class="txt w2">
                                <asp:DropDownList ID="dropbranch" runat="server" CssClass="form-control">
                                </asp:DropDownList>
                            </div>
                        </div>
                         <div class="ctrlGroup searchgroup">
                            <label class="lbl">Type:</label>
                            <div class="txt w2">
                              <asp:DropDownList ID="dropholidaytype2" runat="server" CssClass="form-control">
                                       
                                         <asp:ListItem Value="General">General</asp:ListItem>
                                         <asp:ListItem Value="Weekend">Weekend</asp:ListItem>
                                        </asp:DropDownList>
                            </div>
                        </div>
                        <div class="ctrlGroup searchgroup">
                            <div class="col-xs-10">
                                <asp:Button ID="btnsubmit" runat="server" CssClass="btn btn-primary" Text="Save"
                                    ValidationGroup="save" OnClick="btnsubmit_Click" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
             
    </script>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnsearch" EventName="Click" />
            <asp:PostBackTrigger ControlID="btnexportcsv" />
        </Triggers>
    </asp:UpdatePanel>
  
</asp:Content>
