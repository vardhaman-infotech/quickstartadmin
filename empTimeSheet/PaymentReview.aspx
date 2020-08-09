<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="PaymentReview.aspx.cs" Inherits="empTimeSheet.PaymentReview" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
    <link rel="stylesheet" href="css/jquery.dataTables.min.css" />
   
    <script type="text/javascript" src="js/jquery.dataTables.min.js"></script>
    <script type="text/javascript">
        // Script to print the given Div
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
                        'aTargets': [-1] /* 1st one, start by the right */
                    }]
                });

            });



        }
        function opendiv() {
            document.getElementById("ctl00_ContentPlaceHolder1_hidview").value = "detail";

            setposition("divpaymentdetail");
            $('#divpaymentdetail').show();
            $('#otherdiv').show();
        }
        function closediv() {
            $('#divpaymentdetail').hide();
            $('#otherdiv').hide();
            document.getElementById("ctl00_ContentPlaceHolder1_hidview").value = "";
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <pg:progress ID="progress1" runat="server" />
    <asp:UpdatePanel ID="updatedetail" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <input type="hidden" id="hidview" runat="server" />
            <asp:Button ID="PaggedGridbtnedit" runat="server" Style="display: none;" OnClick="PaggedGridbtnedit_Click" ClientIDMode="Static" />
            <div id="divpaymentdetail" class="itempopup" style="width: 850px; position: absolute;">
                <div class="popup_heading">
                    <span>Payment Detail</span>
                    <div class="f_right">
                        <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
                    </div>
                </div>
                <div class="tabContents">
                    <div class="col-xs-12 col-sm-12 form-group mar pad">
                        <div style="padding: 0px 15px;">

                           <asp:Repeater ID="rptsummary" runat="server">
                                    <HeaderTemplate>
                                        <table cellspacing="0" cellpadding="4" border="0" style="width: 100%;" class="tblsheet tblreport">
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr>
                                            <th width="20%">Payment Date:
                                            </th>
                                            <td width="30%">
                                                <%# DataBinder.Eval(Container.DataItem, "paymentdate")%>
                                            </td>
                                            <th width="20%">Payment Method:
                                            </th>
                                            <td>
                                                <%# DataBinder.Eval(Container.DataItem, "PaymentMode")%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>Client Name:
                                            </th>
                                            <td style="white-space:normal;">
                                                <%# DataBinder.Eval(Container.DataItem, "clientname")%>
                                            </td>
                                            <th>Project Name:
                                            </th>
                                            <td style="white-space:normal;">
                                                <%# DataBinder.Eval(Container.DataItem, "projectname")%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>Amount Paid:
                                            </th>
                                            <td>$<%# DataBinder.Eval(Container.DataItem, "amount")%>
                                            </td>
                                            <th>Check/Transaction #:
                                            </th>
                                            <td>
                                                <%# DataBinder.Eval(Container.DataItem, "checknum")%>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        </table>
                                    </FooterTemplate>
                                </asp:Repeater>
                            <div class="clear"></div>

                            <div class="clear"></div>
                            <div style="height: 280px; overflow-y: auto;">
                                
                                <div class="clear">
                                </div>
                                <div class="panel panel-default mar">
                                    <div class="panel-body2 ">
                                        <div class="row">
                                            <div class="table-responsive">
                                                <asp:Repeater ID="dgdetail" runat="server">
                                                    <HeaderTemplate>
                                                        <table class="tblsheet" cellpadding="4" cellspacing="0">
                                                            <tr class="gridheader">
                                                                <th>Invoice #
                                                                </th>
                                                                <th>Date
                                                                </th>
                                                                <th>Project ID
                                                                </th>
                                                                <th>Project Name
                                                                </th>
                                                                <th>Net Bill
                                                                </th>
                                                                <th>Paid
                                                                </th>
                                                                <th>Balance
                                                                </th>
                                                                <th> Applied Amount
                                                                </th>
                                                            </tr>
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <tr>
                                                            <td>
                                                             <a href="ViewInvoice.aspx?invoiceid=<%# DataBinder.Eval(Container.DataItem, "nid")%>" target="_blank">   <%# DataBinder.Eval(Container.DataItem, "invoiceno")%></a>
                                                            </td>
                                                            <td>
                                                                <%# DataBinder.Eval(Container.DataItem, "invoicedate")%>
                                                            </td>
                                                            <td>
                                                                <%# DataBinder.Eval(Container.DataItem, "projectCode")%>
                                                            </td>
                                                            <td>
                                                                <%# DataBinder.Eval(Container.DataItem, "projectname")%>
                                                            </td>
                                                            <td>
                                                                <%=strcurrency %><%# DataBinder.Eval(Container.DataItem, "totalamount")%>
                                                            </td>
                                                            <td>
                                                                <%=strcurrency %><%# DataBinder.Eval(Container.DataItem, "invoicepaidamount")%>
                                                            </td>
                                                            <td>
                                                                <%=strcurrency %><%# DataBinder.Eval(Container.DataItem, "invoicedueamount")%>
                                                            </td>
                                                            <td>
                                                                <%=strcurrency %><%# DataBinder.Eval(Container.DataItem, "amount")%>
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
                                </div>

                            </div>
                            <div class="clear"></div>

                        </div>
                    </div>
                </div>
            </div>
            <div id="otherdiv" onclick="closediv();">
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdatePanel ID="updatePanelData" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="false">
        <ContentTemplate>
            <div class="pageheader">
                <h2>
                    <i class="fa fa-money"></i>Payment Review
                </h2>
                <div class="breadcrumb-wrapper mar ">
                </div>
                <div class="clear">
                </div>
            </div>

            <div class="contentpanel">
                <div class="row">
                    <div class="col-sm-12 col-md-12">
                        <div class="panel panel-default">
                            <div class="col-sm-12 col-md-12">
                                <div style="padding-top: 10px;">

                                    <div class="clear"></div>
                                    <div class="col-sm-12 col-md-3 f_left pad">
                                        <div class="ctrlGroup searchgroup">
                                            <label class="lbl lbl2">From Date : </label>
                                            <div class="txt w1 mar10">
                                                <asp:TextBox ID="txtfromdate" runat="server" placeholder="From Date" CssClass="form-control hasDatepicker"
                                                    onchange="checkdate(this.value,'txtfromdate');" onKeyPress="return enterpressalert(event, this)"></asp:TextBox>

                                                <cc1:CalendarExtender ID="cc1" runat="server" TargetControlID="txtfromdate" PopupButtonID="txtfromdate"
                                                    Format="MM/dd/yyyy">
                                                </cc1:CalendarExtender>
                                            </div>

                                        </div>
                                        <div class="clear"></div>
                                        <div class="ctrlGroup searchgroup">
                                            <label class="lbl lbl2">To Date : </label>
                                            <div class="txt w1 mar10">
                                                <asp:TextBox ID="txttodate" runat="server" placeholder="To Date" CssClass="form-control hasDatepicker"
                                                    onchange="checkdate(this.value,'txttodate');" onKeyPress="return enterpressalert(event, this)"></asp:TextBox>

                                                <cc1:CalendarExtender ID="cc2" runat="server" TargetControlID="txttodate" PopupButtonID="txttodate"
                                                    Format="MM/dd/yyyy">
                                                </cc1:CalendarExtender>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-12 col-md-6 f_left pad">
                                        <asp:UpdatePanel ID="updatePanelSearch" runat="server" UpdateMode="Conditional">
                                            <ContentTemplate>


                                                <div class="ctrlGroup searchgroup">
                                                    <label class="lbl lbl2">Client : </label>
                                                    <div class="txt w2">
                                                        <asp:DropDownList ID="dropclient" runat="server" CssClass="form-control" AutoPostBack="true"
                                                            OnSelectedIndexChanged="dropclient_OnSelectedIndexChanged">
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="clear"></div>
                                                <div class="ctrlGroup searchgroup">
                                                    <label class="lbl lbl2">Project : </label>
                                                    <div class="txt w2 ">
                                                        <asp:DropDownList ID="dropproject" runat="server" CssClass="form-control">
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>

                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </div>
                                    <div class="clear">
                                    </div>
                                    <div class="col-sm-12 col-md-3 f_left pad">
                                        <div class="ctrlGroup searchgroup">
                                            <label class="lbl lbl2">Search by : </label>
                                            <div class="txt w1 mar10">
                                                <asp:TextBox ID="txtinvno" runat="server" CssClass="form-control " placeholder="Invoice No"
                                                    onKeyPress="return enterpressalert(event, this)"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl2">&nbsp; </label>
                                        <asp:Button ID="btnsearch" runat="server" Text="Search" CssClass="btn btn-default"
                                            OnClick="btnsearch_Click" />
                                    </div>
                                </div>
                            </div>
                            <div class="clear">
                            </div>
                            <div class="col-sm-12 col-md-12 mar2">

                              
                                <div class="clear">
                                </div>
                                <div class="panel panel-default">
                                    <div class="panel-body2 ">
                                        <div class="row">
                                            <div class="table-responsive">
                                                <div class="nodatafound" id="divnodata" runat="server">
                                                    No data found
                                                </div>
                                                <asp:GridView ID="dgnews" runat="server" AllowPaging="false" AutoGenerateColumns="False"
                                                    CellPadding="4" CellSpacing="0" Width="100%" ShowHeader="true" 
                                                    ShowFooter="false" CssClass="tblreport" GridLines="None" OnRowDataBound="dgnews_RowDataBound"
                                                    OnRowCommand="dgnews_RowCommand">
                                                    <Columns>
                                                       

                                                        <asp:TemplateField HeaderText="Date" HeaderStyle-Width="90px" SortExpression="paymentdate">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "paymentdate")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Client ID"  HeaderStyle-Width="120px">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "clientcode")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Client Name">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "clientname")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Payment Method" HeaderStyle-Width="130px" SortExpression="PaymentMode">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "PaymentMode")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                        <asp:TemplateField HeaderText="Amount" HeaderStyle-Width="100px" SortExpression="amount"
                                                            HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right">
                                                            <ItemTemplate>
                                                                <%=strcurrency %><%# DataBinder.Eval(Container.DataItem, "amount")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderStyle-Width="40px"  ItemStyle-HorizontalAlign="Center">
                                                            <ItemTemplate>
                                                                <input type="hidden" id="hidnid" runat="server" value='<%#DataBinder.Eval(Container.DataItem,"nid")%>' />
                                                              <%--  <asp:LinkButton ID="lbtndelete" CommandName="del" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>'
                                                                    ToolTip="Delete" runat="server" OnClientClick='return confirm("Delete this record?");'><i class="fa fa-fw">
                                                            <img src="images/delete.png" alt=""></i></asp:LinkButton>--%>
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
                            <input type="hidden" id="hidid" runat="server" />

                        </div>
                        <!--Panel-default-->
                    </div>
                    <!---col-sm-12 col-md-12-->
                </div>
                <!---row-->
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnsearch" EventName="Click" />
          
        </Triggers>
    </asp:UpdatePanel>

     <script>

         //var prm = Sys.WebForms.PageRequestManager.getInstance();
         //if (prm != null) {
         //    prm.add_endRequest(function (sender, e) {
         //        if (sender._postBackSettings.panelsToUpdate != null) {
         //            setentervent();
                     
         //        }
         //    });
         //};

         //$(document).ready(function () {
         //    setentervent();
         //});

         //function setentervent()
         //{
         //    alert("ajax loaded");
         //    $('#ctl00_ContentPlaceHolder1_txtfromdate').keypress(function (event) {
         //        var keycode = (event.keyCode ? event.keyCode : event.which);
         //        if (keycode == '13') {
         //            $("#ctl00_ContentPlaceHolder1_btnsearch").click();
         //            return false;
         //        }
         //    });
         //    $('#ctl00_ContentPlaceHolder1_txttodate').keypress(function (event) {
         //        var keycode = (event.keyCode ? event.keyCode : event.which);
         //        if (keycode == '13') {
         //            $("#ctl00_ContentPlaceHolder1_btnsearch").click();
         //            return false;
         //        }
         //    });
         //    $('#ctl00_ContentPlaceHolder1_txtinvno').keypress(function (event) {
         //        var keycode = (event.keyCode ? event.keyCode : event.which);
         //        if (keycode == '13') {
         //            $("#ctl00_ContentPlaceHolder1_btnsearch").click();
         //            return false;
         //        }
         //    });
         //}
        //$('input').keypress(function (event) {
        //    var keycode = (event.keyCode ? event.keyCode : event.which);
        //    if (keycode == '13') {
        //        return false;
        //    }
         //});


         function enterpressalert(e, textarea) {
             var code = (e.keyCode ? e.keyCode : e.which);
             if (code == 13) { //Enter keycode
                 $("#ctl00_ContentPlaceHolder1_btnsearch").click();
                 return false;
             }
         }
    </script>
</asp:Content>
