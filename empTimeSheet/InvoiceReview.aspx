<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="InvoiceReview.aspx.cs" Inherits="empTimeSheet.InvoiceReview" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit.HTMLEditor"
    TagPrefix="ajaxeditor" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="css/jquery.dataTables.min.css" />

    <script src="js/jquery.min.js"></script>

    <script type="text/javascript" src="js/jquery.dataTables.min.js"></script>
    <style type="text/css">
        gridheader th {
            text-align: left;
        }
    </style>
    <script>
        function fixheader() {

            $.getScript("js/colResizable-1.6.js", function () {

                $("#ctl00_ContentPlaceHolder1_dgnews").colResizable({
                    liveDrag: true,
                    gripInnerHtml: "<div class='grip'></div>",
                    draggingClass: "dragging",
                    resizeMode: 'fit'
                });

                $('#ctl00_ContentPlaceHolder1_dgnews').dataTable({
                    "dom": 'lrtip',
                    "bPaginate": false,
                    'aoColumnDefs': [{
                        'bSortable': false,
                        'aTargets': [-1, -2, -3] /* 1st one, start by the right */

                    }]
                });

            });


        }
        function opendiv()
        {
            setposition('divemail');
            document.getElementById("divemail").style.display = "block";
            document.getElementById("otherdiv").style.display = "block";

        }
        function closediv() {
            document.getElementById("divemail").style.display = "none";
            document.getElementById("otherdiv").style.display = "none";

        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <pg:progress ID="progress1" runat="server" />
    <asp:UpdatePanel ID="updateemail" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
              <input type="hidden" id="hidid" runat="server" />
               <div id="otherdiv" onclick="closediv();">
                            </div>
            <div id="divemail" class="itempopup" style="width: 700px; display: none;">
                <asp:Button ID="PaggedGridbtnedit" runat="server" Style="display: none;" OnClick="PaggedGridbtnedit_Click" ClientIDMode="Static" />
                <div class="popup_heading">
                    <span>Email Invoice</span>
                    <div class="f_right">
                        <img src="images/cross.png" onclick="closediv();" alt="X" title="Close
            Window" />
                    </div>
                </div>
                <div style="padding: 10px;">
                    <div class="ctrlGroup">
                        <label class="lbl">Receiver :</label>
                        <div class="txt w2">
                            <asp:TextBox ID="txtreceiver" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>
                    <div class="clear"></div>
                    <div class="ctrlGroup">
                        <label class="lbl">Subject :</label>
                        <div class="txt w2">
                            <asp:TextBox ID="txtsubject" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>
                    <div class="clear"></div>
                    <div class="ctrlGroup">
                        <label class="lbl">Attachment :</label>
                        <div class="txt w2">
                     <asp:Literal ID="litfilename" runat="server"></asp:Literal>
                        </div>
                    </div>
                    <div class="clear"></div>
                    <div class="ctrlGroup">
                        <ajaxeditor:Editor ID="Editor1" runat="server"
                            Height="250px" Width="99%" />
                    </div>
                    <div class="clear"></div>
                    <div class="ctrlGroup">
                        <asp:Button ID="btnsubmit" runat="server" CssClass="btn btn-primary" Text="Send Email"
                            ValidationGroup="save" OnClick="btnsubmit_Click" />
                    </div>
                    <div >
                        
                    </div>

                </div>
            </div>
        </ContentTemplate>
      
    </asp:UpdatePanel>
    <div class="pageheader">
        <h2>
            <i class="fa fa-file-text"></i>Invoice Review
        </h2>
        <div class="breadcrumb-wrapper mar ">
            <asp:LinkButton ID="btnexportcsv" runat="server" OnClick="btnexportcsv_Click" CssClass="right_link">
            <i class="fa fa-fw fa-file-excel-o topicon"></i>Export to Excel</asp:LinkButton>
            <asp:LinkButton ID="lnkrefresh" runat="server" OnClick="btnrefresh_Click" CssClass="right_link">
            <i class="fa fa-fw fa-refresh topicon"></i>Refresh</asp:LinkButton>
        </div>
        <div class="clear">
        </div>
    </div>
    <div class="contentpanel">
        <div class="row">
            <div class="col-sm-12 col-md-12">
                <div class="panel panel-default">

                    <div class="col-sm-12 col-md-10 mar">
                       
                        <div class="ctrlGroup searchgroup">
                            <label class="lbl lbl2">From Date : </label>

                            <div class="txt w1 mar10">
                                <asp:TextBox ID="txtfromdate" runat="server" placeholder="From Date" CssClass="form-control hasDatepicker" onchange="comparedate(this.id,'ctl00_ContentPlaceHolder1_txtfromdate','ctl00_ContentPlaceHolder1_txttodate');"></asp:TextBox>

                                <cc1:CalendarExtender ID="cc1" runat="server" TargetControlID="txtfromdate" PopupButtonID="txtfromdate"
                                    Format="MM/dd/yyyy">
                                </cc1:CalendarExtender>
                            </div>


                        </div>
                        <div class="ctrlGroup searchgroup">
                            <label class="lbl lbl2">To Date : </label>

                            <div class="txt w1">

                                <asp:TextBox ID="txttodate" runat="server" placeholder="To Date" CssClass="form-control hasDatepicker" onchange="comparedate(this.id,'ctl00_ContentPlaceHolder1_txtfromdate','ctl00_ContentPlaceHolder1_txttodate');"></asp:TextBox>

                                <cc1:CalendarExtender ID="cc2" runat="server" TargetControlID="txttodate" PopupButtonID="txttodate"
                                    Format="MM/dd/yyyy">
                                </cc1:CalendarExtender>
                            </div>

                        </div>
                        <div class="clear"></div>




                        <div class="ctrlGroup searchgroup">
                            <label class="lbl lbl2">State : </label>

                            <div class="txt w1 mar10">
                                <div class="txt w1 mar10">
                                    <asp:DropDownList ID="dropstate" runat="server" CssClass="form-control">
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </div>

                        <div class="ctrlGroup searchgroup">
                            <label class="lbl lbl2">Invoice No. : </label>

                            <div class="txt w1">
                                <asp:TextBox ID="txtinvno" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>

                        </div>
                        <div class="clear"></div>
                        <asp:UpdatePanel ID="updatePanelSearch" runat="server" UpdateMode="Conditional" style="float: left;">
                            <ContentTemplate>
                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl lbl2">Client : </label>
                                    <div class="txt w1 mar10">
                                        <asp:DropDownList ID="dropclient" runat="server" CssClass="form-control" AutoPostBack="true"
                                            OnSelectedIndexChanged="dropclient_OnSelectedIndexChanged">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl lbl2">Project : </label>
                                    <div class="txt w1 mar10">
                                        <asp:DropDownList ID="dropproject" runat="server" CssClass="form-control">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                            </ContentTemplate>
                        </asp:UpdatePanel>

                        <div class="ctrlGroup searchgroup">
                            <asp:Button   ID="btnsearch" runat="server" Text="Search" CssClass="btn btn-default"
                                OnClick="btnsearch_Click" />
                        </div>
                    </div>



                    <asp:UpdatePanel ID="updatePanelData" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="false">
                        <ContentTemplate>
                           

                            <div class="ctrlGroup searchgroup" style="float: right; display: none;">
                                <asp:LinkButton ID="lnkprevious" CssClass="f_left" runat="server" OnClick="lnkprevious_Click">
            <i class="fa fa-fw fa-fast-backward color_green"></i></asp:LinkButton>

                                <div class="f_left page">
                                    <asp:Label ID="lblstart" runat="server"></asp:Label>
                                    -
                                        <asp:Label ID="lblend" runat="server"></asp:Label>
                                    of <strong>
                                        <asp:Label ID="lbltotalrecord" Font-Bold="true" runat="server"></asp:Label></strong>
                                </div>
                                <asp:LinkButton ID="lnknext" CssClass="f_left" runat="server" OnClick="lnknext_Click"><i class="fa fa-fw fa-fast-forward color_green"></i></asp:LinkButton>
                            </div>

                            <div class="clear">
                            </div>
                            <div class="col-sm-12 col-md-12 mar">
                                <div class="panel panel-default">
                                    <div class="panel-body2 ">
                                        <div class="row">
                                            <div class="table-responsive">
                                                <div class="nodatafound" id="divnodata" runat="server">
                                                    No data found
                                                </div>
                                                <asp:GridView ID="dgnews" runat="server" AllowPaging="false" AutoGenerateColumns="False"
                                                    PageSize="50" CellPadding="4" CellSpacing="0" Width="100%" ShowHeader="true"
                                                    ShowFooter="false" CssClass="tblreport" GridLines="None" AllowSorting="false"
                                                    OnRowDataBound="dgnews_RowDataBound" OnRowCommand="dgnews_RowCommand"
                                                    OnPageIndexChanging="dgnews_PageIndexChanging">
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="50px" ItemStyle-CssClass="tdsno"
                                                            HeaderStyle-CssClass="tdsno">
                                                            <ItemTemplate>
                                                                <%# Container.DataItemIndex + 1 %>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Invoice#" HeaderStyle-Width="80px">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "invoiceno")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Date" HeaderStyle-Width="80px">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "invoicedate")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Project ID" HeaderStyle-Width="100px">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "projectCode")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Project Name" SortExpression="projectname">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "projectname")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Net Amount" HeaderStyle-Width="80px">
                                                            <ItemTemplate>
                                                                <%=strcurrency %><%# DataBinder.Eval(Container.DataItem, "totalamount")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Write Off" HeaderStyle-Width="80px">
                                                            <ItemTemplate>
                                                                <%=strcurrency %><%# DataBinder.Eval(Container.DataItem, "writeoff")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Paid" HeaderStyle-Width="80px">
                                                            <ItemTemplate>
                                                                <%=strcurrency %><asp:Literal ID="ltrpaidamount" runat="server" Text='<%#(Convert.ToDouble(DataBinder.Eval(Container.DataItem, "invoicepaidamount"))-Convert.ToDouble(DataBinder.Eval(Container.DataItem, "writeoff"))).ToString("0.00") %>'></asp:Literal>

                                                                <asp:Literal ID="ltrpaidamountthroughinvoice" runat="server" Visible="false" Text='<%# DataBinder.Eval(Container.DataItem, "amountpaid")%>'></asp:Literal>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Balance" HeaderStyle-Width="80px">
                                                            <ItemTemplate>
                                                                <%=strcurrency %><%# DataBinder.Eval(Container.DataItem, "invoicedueamount")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                        <asp:TemplateField HeaderStyle-Width="5%" ItemStyle-HorizontalAlign="Center">
                                                            <ItemTemplate>
                                                                <a id="lblemail" onclick='clickedit(<%#DataBinder.Eval(Container.DataItem,"nid")%>);'
                                                                    title="Email Invoice"><i class="fa fa-fw">

                                                                        <img src="images/email-icon.png" /></i></a>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderStyle-Width="5%" ItemStyle-HorizontalAlign="Center">
                                                            <ItemTemplate>
                                                                <a id="lbtnedit" href='<%# "~/ManualInvoice.aspx?invoiceid=" + Eval("nid")%>'
                                                                    title="Edit" runat="server"><i class="fa fa-fw">

                                                                        <img src="images/edit.png" /></i></a>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderStyle-Width="5%" ItemStyle-HorizontalAlign="Center">
                                                            <ItemTemplate>
                                                                <input type="hidden" id="hidnid" runat="server" value='<%#DataBinder.Eval(Container.DataItem,"nid")%>' />
                                                                <asp:LinkButton ID="lbtndelete" CommandName="del" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>'
                                                                    ToolTip="Delete" runat="server" OnClientClick='return confirm("Delete this invoice?");'><i class="fa fa-fw">
                                                            <img src="images/delete.png" alt=""></i></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                    <HeaderStyle CssClass="gridheader" HorizontalAlign="Left" />
                                                    <PagerStyle CssClass="gridpager" HorizontalAlign="Center" />
                                                </asp:GridView>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <input type="hidden" id="hidfromdate" runat="server" />
                                <input type="hidden" id="hidtodate" runat="server" />
                                <input type="hidden" id="hidclients" runat="server" />
                                <input type="hidden" id="hidprojects" runat="server" />
                                <input type="hidden" id="hidprojectname" runat="server" />
                                <input type="hidden" id="hidclientname" runat="server" />

                                <input type="hidden" id="hidinvoiceno" runat="server" />
                            </div>
                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="btnsearch" EventName="Click" />
                            <asp:AsyncPostBackTrigger ControlID="lnkrefresh" EventName="Click" />
                        </Triggers>
                    </asp:UpdatePanel>

                    <div class="clear">
                    </div>

                </div>
                <!--Panel-default-->
            </div>
            <!---col-sm-12 col-md-12-->
        </div>
        <!---row-->
    </div>

    <script>
        $(document).ready(function () {
        $('#ctl00_ContentPlaceHolder1_txtfromdate').keypress(function (event) {
            var keycode = (event.keyCode ? event.keyCode : event.which);
            if (keycode == '13') {
                $("#ctl00_ContentPlaceHolder1_btnsearch").click();
                return false;
            }
        });
        $('#ctl00_ContentPlaceHolder1_txttodate').keypress(function (event) {
            var keycode = (event.keyCode ? event.keyCode : event.which);
            if (keycode == '13') {
                $("#ctl00_ContentPlaceHolder1_btnsearch").click();
                return false;
            }
        });
        $('#ctl00_ContentPlaceHolder1_txtinvno').keypress(function (event) {
            var keycode = (event.keyCode ? event.keyCode : event.which);
            if (keycode == '13') {
                $("#ctl00_ContentPlaceHolder1_btnsearch").click();
                return false;
            }
        });
        });
    </script>
</asp:Content>
