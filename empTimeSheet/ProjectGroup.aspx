<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="ProjectGroup.aspx.cs" Inherits="empTimeSheet.ProjectGroup" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!---Scripts to move Clients Code GOES here-->
    <script type="text/javascript">

        function move(btnaddmember, btnremove) {

            var arrFrom = new Array(); var arrTo = new Array();
            var arrLU = new Array();
            var i;
            for (i = 0; i < btnremove.options.length; i++) {
                arrLU[btnremove.options[i].text] = btnremove.options[i].value;
                arrTo[i] = btnremove.options[i].text;
            }

            var fLength = 0;
            var tLength = arrTo.length;
            for (i = 0; i < btnaddmember.options.length; i++) {
                arrLU[btnaddmember.options[i].text] = btnaddmember.options[i].value;
                if (btnaddmember.options[i].selected && btnaddmember.options[i].value != "") {
                    arrTo[tLength] = btnaddmember.options[i].text;
                    tLength++;
                }
                else {
                    arrFrom[fLength] = btnaddmember.options[i].text;
                    fLength++;
                }
            }

            btnaddmember.length = 0;
            btnremove.length = 0;
            var ii;
            for (ii = 0; ii < arrFrom.length; ii++) {
                var no = new Option();
                no.value = arrLU[arrFrom[ii]];
                no.text = arrFrom[ii];
                btnaddmember[ii] = no;
            }

            for (ii = 0; ii < arrTo.length; ii++) {
                var no = new Option();
                no.value = arrLU[arrTo[ii]];
                no.text = arrTo[ii];
                btnremove[ii] = no;
            }
            var strval = "";
            var strname = "";
            var tolistbox = document.getElementById('ctl00_ContentPlaceHolder1_listcode2');
            if (tolistbox.options.length > 0) {
                for (k = 0; k < tolistbox.options.length; k++) {

                    strval += tolistbox.options[k].value + ',';
                    strname += tolistbox.options[k].innerHTML + ',';

                }

            }

            document.getElementById('ctl00_ContentPlaceHolder1_hidgroupprojects').value = strval;
            document.getElementById('ctl00_ContentPlaceHolder1_hidlientname').value = strname;
            searchclient();
            sortlist();
        }


    </script>
    <script type="text/javascript">
        function sortlist() {
            var SelList = document.getElementById('ctl00_ContentPlaceHolder1_listcode1');

            var ID = '';
            var Text = '';
            for (x = 0; x < SelList.length - 1; x++) {
                for (y = x + 1; y < SelList.length; y++) {
                    if (SelList[x].text > SelList[y].text) {
                        // Swap rows
                        ID = SelList[x].value;
                        Text = SelList[x].text;
                        SelList[x].value = SelList[y].value;
                        SelList[x].text = SelList[y].text;
                        SelList[y].value = ID;
                        SelList[y].text = Text;
                    }
                }
            }
        }
    </script>
    <script type="text/javascript">
        function validate1(source, args) {

            var id = "ctl00_ContentPlaceHolder1_listcode2";

            var numofelemadded = document.getElementById(id).options.length;

            if (numofelemadded > 0) {
                args.IsValid = true;
            }
            else {

                args.IsValid = false;
            }
            return;
        }
    </script>
    <!--END- scripts to move Clients Code-->
    <!---Scripts to move EMPLOYEES Code GOES here-->
    <script type="text/javascript">

        function move1(btnaddmember, btnremove) {

            var arrFrom = new Array(); var arrTo = new Array();
            var arrLU = new Array();
            var i;
            for (i = 0; i < btnremove.options.length; i++) {
                arrLU[btnremove.options[i].text] = btnremove.options[i].value;
                arrTo[i] = btnremove.options[i].text;
            }

            var fLength = 0;
            var tLength = arrTo.length;
            for (i = 0; i < btnaddmember.options.length; i++) {
                arrLU[btnaddmember.options[i].text] = btnaddmember.options[i].value;
                if (btnaddmember.options[i].selected && btnaddmember.options[i].value != "") {
                    arrTo[tLength] = btnaddmember.options[i].text;
                    tLength++;
                }
                else {
                    arrFrom[fLength] = btnaddmember.options[i].text;
                    fLength++;
                }
            }

            btnaddmember.length = 0;
            btnremove.length = 0;
            var ii;
            for (ii = 0; ii < arrFrom.length; ii++) {
                var no = new Option();
                no.value = arrLU[arrFrom[ii]];
                no.text = arrFrom[ii];
                btnaddmember[ii] = no;
            }

            for (ii = 0; ii < arrTo.length; ii++) {
                var no = new Option();
                no.value = arrLU[arrTo[ii]];
                no.text = arrTo[ii];
                btnremove[ii] = no;
            }
            var strval = "";
            var strname = "";
            var tolistbox = document.getElementById('ctl00_ContentPlaceHolder1_listavailcode2');
            if (tolistbox.options.length > 0) {
                for (k = 0; k < tolistbox.options.length; k++) {

                    strval += tolistbox.options[k].value + ',';
                    strname += tolistbox.options[k].innerHTML + ',';

                }

            }

            document.getElementById('ctl00_ContentPlaceHolder1_hidgroupid').value = strval;
            document.getElementById('ctl00_ContentPlaceHolder1_hidgroupname').value = strname;
            searchavailableto();
            sortlist1();
        }


    </script>
    <script type="text/javascript">
        function sortlist1() {
            var SelList = document.getElementById('ctl00_ContentPlaceHolder1_listavailcode1');

            var ID = '';
            var Text = '';
            for (x = 0; x < SelList.length - 1; x++) {
                for (y = x + 1; y < SelList.length; y++) {
                    if (SelList[x].text > SelList[y].text) {
                        // Swap rows
                        ID = SelList[x].value;
                        Text = SelList[x].text;
                        SelList[x].value = SelList[y].value;
                        SelList[x].text = SelList[y].text;
                        SelList[y].value = ID;
                        SelList[y].text = Text;
                    }
                }
            }
        }
    </script>
    <script type="text/javascript">
        function validate2(source, args) {

            var id = "ctl00_ContentPlaceHolder1_listavailcode2";

            var numofelemadded = document.getElementById(id).options.length;

            if (numofelemadded > 0) {
                args.IsValid = true;
            }
            else {

                args.IsValid = false;
            }
            return;
        }
    </script>
    <!--END- scripts to move Clients Code-->
    <script type="text/javascript">
        function opendiv() {
            setposition("divaddnew");
            document.getElementById("divaddnew").style.display = "block";
            document.getElementById("otherdiv").style.display = "block";
        }
        function closediv() {

            document.getElementById("divaddnew").style.display = "none";
            document.getElementById("otherdiv").style.display = "none";
            document.getElementById("divsettings").style.display = "none";
        }
        function opensettingsdiv() {
            setposition("divsettings");
            document.getElementById("divsettings").style.display = "block";
            document.getElementById("otherdiv").style.display = "block";
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <pg:progress ID="progress1" runat="server" />
    <div class="pageheader">
        <h2>
            <i class="fa fa-tasks"></i>Project Groups
        </h2>
        <div class="breadcrumb-wrapper mar ">
            <a id="liaddnew" runat="server" class="right_link" onclick="opendiv();"><i class="fa fa-fw fa-plus topicon"></i>Add New Group</a>
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
                    <asp:MultiView ID="multiview1" runat="server" ActiveViewIndex="0">
                        <asp:View ID="viewlist" runat="server">
                            <div class="col-sm-12 col-md-10">
                                <div style="padding-top: 10px;">
                                    <div class="col-xs-12 col-sm-12 col-md-12 f_left" style="padding: 0px;">
                                        <h5 class="subtitle mb5">Project Groups</h5>
                                    </div>
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl">Group Title : </label>
                                        <div class="txt w2 mar10">
                                            <asp:TextBox ID="txtsearch" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl">Employees : </label>
                                        <div class="txt w2 mar10">
                                            <asp:DropDownList ID="dropproject" runat="server" CssClass="form-control">
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="ctrlGroup searchgroup">
                                        <asp:Button ID="btnsearch" runat="server" Text="Search" CssClass="btn btn-default"
                                            OnClick="btnsearch_Click" />
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-12 col-md-12 mar2">
                                <%-- <asp:UpdatePanel ID="updatePanelData" runat="server">
                                    <ContentTemplate>--%>
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
                                                    OnRowDataBound="dgnews_RowDataBound" OnSorting="dgnews_Sorting" OnRowCommand="dgnews_RowCommand"
                                                    OnPageIndexChanging="dgnews_PageIndexChanging">
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="40px">
                                                            <ItemTemplate>
                                                                <%# Container.DataItemIndex + 1 %>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Group Title" SortExpression="grouptitle">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"grouptitle")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="No. of Projects" SortExpression="numofprojects">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem, "numofprojects")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Created By" SortExpression="username">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem, "username")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Creation Date">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem, "creationdate")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderStyle-Width="18px" ItemStyle-HorizontalAlign="Center">
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="lbtnsetting" CommandName="settings" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>'
                                                                    ToolTip="Set Group Availabilty" runat="server"><i class="fa fa-gear fa-fw" style="font-size:17px;padding-top:2px;">
                                                          
                                                           </i></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderStyle-Width="18px" ItemStyle-HorizontalAlign="Center">
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="lbtnview" CommandName="view" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>'
                                                                    ToolTip="View Details" runat="server"><i class="fa fa-fw" ><img src="images/view.png" /></i>
                                                            
                                                                </asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderStyle-Width="18px" ItemStyle-HorizontalAlign="Center">
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="lbtnedit" CommandName="edititem" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>'
                                                                    ToolTip="Edit" runat="server"><i class="fa fa-fw">
                                                          
                                                            <img src="images/edit.png" alt="edit" /></i></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderStyle-Width="18px" ItemStyle-HorizontalAlign="Center">
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="lbtndelete" CommandName="del" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>'
                                                                    ToolTip="Delete" runat="server" 
                                                                    OnClientClick='return confirm("Delete this record? Ok or Cancel");'><i class="fa fa-fw">
                                                            
                                                            <img src="images/delete.png" alt=""></i></asp:LinkButton>
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
                                <input type="hidden" id="hidsearchtitle" runat="server" />
                                <input type="hidden" id="hidsearchclientid" runat="server" />
                                <input type="hidden" id="hidsearchclientname" runat="server" />
                                <%--  </ContentTemplate>
                                    <Triggers>
                             
                                        <asp:PostBackTrigger ControlID="btnsearch" />
                                    </Triggers>
                                </asp:UpdatePanel>--%>
                            </div>
                        </asp:View>
                        <asp:View ID="viewDetails" runat="server">
                            <div class="col-sm-12 col-md-10">
                                <div style="padding-top: 10px;">
                                    <div class="col-xs-12 col-sm-8 col-md-6 f_left" style="padding: 0px;">
                                        <h3 class="mb5" id="ltrgrouptitle" runat="server"></h3>
                                    </div>
                                </div>
                            </div>
                            <div class="f_right">
                                <asp:LinkButton ID="lbtnback" runat="server" OnClick="btnback_Click" CssClass="f_right"
                                    Style="padding: 10px 25px;"><img src="images/arrow_left.png" alt="Back" /> </asp:LinkButton>
                            </div>
                            <div class="col-sm-12 col-md-12 mar2">
                                <!--Status Div goes here-->
                                <asp:UpdatePanel ID="updatePanelStatus" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <div class="col-xs-12 clear">
                                            <div class="col-xs-12 col-sm-6 f_left pad">
                                                <label class="col-xs-12 control-label pad" style="margin-left: -10px;">
                                                    Created By:
                                                            <asp:Literal ID="ltrcreatedby" runat="server"></asp:Literal></label>
                                            </div>
                                            <div class="pad f_right">
                                                <label class="col-xs-12 control-label pad">
                                                    Creation Date:
                                                            <asp:Literal ID="ltrcreationdate" runat="server"></asp:Literal></label>
                                            </div>
                                            <div class="clear">
                                            </div>
                                            <div class="nodatafound" id="divnodataforstatus" runat="server">
                                                Project not found
                                            </div>
                                            <div class="panel">
                                                <div class="row">
                                                    <div class="table-responsive">
                                                        <asp:Repeater ID="rptstatus" runat="server">
                                                            <HeaderTemplate>
                                                                <table cellspacing="0" cellpadding="4" border="1" style="width: 100%;" class="table table-success table-bordered">
                                                                    <tbody>
                                                                        <tr class="gridheader">
                                                                            <th width="15%">Project ID
                                                                            </th>
                                                                            <th>Project Name
                                                                            </th>
                                                                        </tr>
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <tr>
                                                                    <td>
                                                                        <%#Eval("projectCode")%>
                                                                    </td>
                                                                    <td>
                                                                        <%#Eval("projectname")%>
                                                                    </td>
                                                                </tr>
                                                            </ItemTemplate>
                                                            <FooterTemplate>
                                                                </table>
                                                            </FooterTemplate>
                                                        </asp:Repeater>
                                                        <div class="clear">
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </asp:View>
                    </asp:MultiView>
                    <div class="clear">
                    </div>
                </div>
                <div class="clear">
                </div>
            </div>
        </div>
    </div>
    <div style="display: none; width: 680px;" id="divaddnew" class="itempopup">
        <input type="hidden" id="hidid" runat="server" />
        <div class="popup_heading">
            <span>Project Group </span>
            <div class="f_right">
                <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
            </div>
        </div>
        <div class="tabContents">
            <div class="col-xs-12 col-sm-12">
                <div class="ctrlGroup searchgroup">
                    <label class="lbl">
                        Group Title :<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtgroup"
                            ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator></label>
                    <div class="txt w3">
                        <asp:TextBox ID="txtgroup" runat="server" CssClass="form-control">
                        </asp:TextBox>
                    </div>
                </div>
                <div class="ctrlGroup searchgroup">
                    <label class="lbl">
                        Select Project :<asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="*" ValidationGroup="save"
                            CssClass="errmsg" ClientValidationFunction="validate1"></asp:CustomValidator></label>
                    <div class="txt w3" style="margin-bottom: 20px;">
                        <asp:TextBox ID="txtsearchclient" runat="server" placeholder="Search Projects by keyword"
                            onkeyup="searchclient();" CssClass="form-control pad3"></asp:TextBox>
                    </div>
                </div>
                <div class="col-xs-12 form-group pad">
                    <div class="f_left">
                        <asp:ListBox ID="listcode1" runat="server" Width="260px" Height="200px" SelectionMode="Multiple"></asp:ListBox>
                        <input type="hidden" id="hidgroupprojects" runat="server" />
                        <input type="hidden" id="hidgroupprojectname" runat="server" />
                    </div>
                    <div class="f_left" style="padding: 22px; text-align: center;">
                        <div class="f_left">
                            <input type="button" onclick="move(this.form.ctl00_ContentPlaceHolder1_listcode1, this.form.ctl00_ContentPlaceHolder1_listcode2)"
                                class="btn btn-default" style="width: 70px; padding: 2px;" value="Add" id="Button1" />
                        </div>
                        <div class="clear">
                        </div>
                        <div class="f_left padtop10">
                            <input type="button" onclick="move(this.form.ctl00_ContentPlaceHolder1_listcode2, this.form.ctl00_ContentPlaceHolder1_listcode1)"
                                class="btn btn-default mar" style="width: 70px; padding: 2px;" value="Remove"
                                id="Button2" />
                        </div>
                    </div>
                    <div class="f_left">
                        <asp:ListBox ID="listcode2" runat="server" Width="260px" Height="200px" SelectionMode="Multiple"></asp:ListBox>
                    </div>
                </div>
                <div class="clear">
                    <asp:Button ID="btnsubmit" runat="server" ValidationGroup="save" CssClass="btn btn-primary"
                        Text="Save" OnClick="btnsubmit_Click" />
                </div>
            </div>
        </div>
    </div>
    <div style="display: none; width: 680px;" id="divsettings" class="itempopup">
        <div class="popup_heading">
            <span>Group Settings </span>
            <div class="f_right">
                <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
            </div>
        </div>
        <div class="tabContents">
            <div class="col-xs-12 col-sm-12">
                <div class="col-xs-12 col-sm-6 f_left pad">
                    <label class="col-xs-12 control-label">
                        <b>Group Title:
                            <asp:Literal ID="ltravailtogrouptitle" runat="server"></asp:Literal></b></label>
                </div>
                <div class="col-xs-12 col-sm-6 clear f_left pad">
                    <label class="col-xs-12 control-label">
                        <b>Created By:
                            <asp:Literal ID="ltravailtocreatedby" runat="server"></asp:Literal></b></label>
                </div>
                <div class="pad f_right">
                    <label class="col-xs-12 control-label">
                        <b>Creation Date:
                            <asp:Literal ID="ltravailtocreationdate" runat="server"></asp:Literal></b></label>
                </div>
                <div class="clear">
                </div>
                <div class="line" style="margin-top: 3px; margin-bottom: 20px;">
                </div>
                <div class="col-xs-12 form-group f_left pad">
                    <label class="col-sm-2 control-label">
                        Available To:
                        <asp:CustomValidator ID="CustomValidator2" runat="server" ErrorMessage="*" ValidationGroup="savesetting"
                            CssClass="errmsg" ClientValidationFunction="validate2"></asp:CustomValidator></label>
                    <div class="col-xs-10">
                        <asp:TextBox ID="txtsearchname" runat="server" placeholder="Search Employees by keyword"
                            onkeyup="searchavailableto();" CssClass="form-control pad3"></asp:TextBox>
                    </div>
                </div>
                <div class="col-xs-12 form-group pad">
                    <div class="f_left">
                        <asp:ListBox ID="listavailcode1" runat="server" Width="260px" Height="200px" SelectionMode="Multiple"></asp:ListBox>
                        <input type="hidden" id="hidgroupid" runat="server" />
                        <input type="hidden" id="hidgroupname" runat="server" />
                    </div>
                    <div class="f_left" style="padding: 22px; text-align: center;">
                        <div class="f_left">
                            <input type="button" onclick="move1(this.form.ctl00_ContentPlaceHolder1_listavailcode1, this.form.ctl00_ContentPlaceHolder1_listavailcode2)"
                                class="btn btn-default" style="width: 70px; padding: 2px;" value="Add" id="Button3" />
                        </div>
                        <div class="clear">
                        </div>
                        <div class="f_left padtop10">
                            <input type="button" onclick="move1(this.form.ctl00_ContentPlaceHolder1_listavailcode2, this.form.ctl00_ContentPlaceHolder1_listavailcode1)"
                                class="btn btn-default mar" style="width: 70px; padding: 2px;" value="Remove"
                                id="Button4" />
                        </div>
                    </div>
                    <div class="f_left">
                        <asp:ListBox ID="listavailcode2" runat="server" Width="260px" Height="200px" SelectionMode="Multiple"></asp:ListBox>
                    </div>
                </div>
                <div class="clear">
                    <asp:Button ID="btnsettings" runat="server" ValidationGroup="savesetting" CssClass="btn btn-primary"
                        Text="Save" OnClick="btnsettings_Click" />
                </div>
            </div>
        </div>
    </div>
    <input type="hidden" id="hidcurrentview" runat="server" value="list" />
    <script type="text/javascript">
        function searchclient() {
            var keyword = $('#ctl00_ContentPlaceHolder1_txtsearchclient').val();

            $("#ctl00_ContentPlaceHolder1_listcode1 > option").each(function () {
                if (keyword == "") {
                    $(this).css("display", "block");
                }
                else {

                    if (this.text.toLowerCase().indexOf(keyword.toLowerCase()) >= 0) {
                        $(this).css("display", "block");
                    }
                    else {
                        $(this).css("display", "none");
                    }

                }

            });
        }

        $('#ctl00_ContentPlaceHolder1_txtsearchclient').keypress(function (e) {
            if (e.keyCode == 13) {
                e.preventDefault();

                return false;
            }
        });

    </script>
    <script type="text/javascript">
        function searchavailableto() {
            var keyword = $('#ctl00_ContentPlaceHolder1_txtsearchname').val();

            $("#ctl00_ContentPlaceHolder1_listavailcode1 > option").each(function () {
                if (keyword == "") {
                    $(this).css("display", "block");
                }
                else {

                    if (this.text.toLowerCase().indexOf(keyword.toLowerCase()) >= 0) {
                        $(this).css("display", "block");
                    }
                    else {
                        $(this).css("display", "none");
                    }

                }

            });
        }

        $('#ctl00_ContentPlaceHolder1_txtsearchname').keypress(function (e) {
            if (e.keyCode == 13) {
                e.preventDefault();

                return false;
            }
        });

    </script>
</asp:Content>
