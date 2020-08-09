<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="ExpenseMaster.aspx.cs" Inherits="empTimeSheet.ExpenseMaster" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="Stylesheet" href="css/tab_2.0.css" type="text/css" />
    <link rel="stylesheet" href="css/jquery.dataTables.min.css" />

    <script src="js/jquery.min.js"></script>

    <script type="text/javascript" src="js/jquery.dataTables.min.js"></script>


    <script>

        function fixheader() {

            $.getScript("js/colResizable-1.6.js", function () {

                $("#ctl00_ContentPlaceHolder1_dgnews").colResizable({
                    liveDrag: true,
                    gripInnerHtml: "<div class='grip'></div>",
                    draggingClass: "dragging",
                    resizeMode: 'fit'
                });
                if ($.fn.dataTable.isDataTable('#ctl00_ContentPlaceHolder1_dgnews')) {
                    table = $('#ctl00_ContentPlaceHolder1_dgnews').dataTable({
                        "dom": 'lrtip',
                        "pageLength": 50,
                        'aoColumnDefs': [{
                            'bSortable': false,
                            'aTargets': [-1] /* 1st one, start by the right */
                        }]
                    });
                }
                else {
                    table = $('#ctl00_ContentPlaceHolder1_dgnews').dataTable({
                        "dom": 'lrtip',
                        "pageLength": 50,
                        'aoColumnDefs': [{
                            'bSortable': false,
                            'aTargets': [-1] /* 1st one, start by the right */
                        }]
                    });
                }
                

            });



        }
    </script>
    <style type="text/css">
        .tabContaier {
            padding: 10px;
        }


        .tabContents {
            height: 285px;
        }

        .tabDetails {
            height: auto;
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <pg:progress ID="progress1" runat="server" />
    <asp:UpdatePanel ID="upadatepanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <input type="hidden" id="hidcurrenttab" />
            <input type="hidden" id="hidtabid" />
            <div class="pageheader">
                <h2>
                    <i class="fa fa-database"></i>Manage Expenses
                </h2>
                <div class="breadcrumb-wrapper">

                    <asp:LinkButton ID="liaddnew" runat="server" CssClass="right_link" OnClick="liaddnew_Click">
                    <i class="fa fa-fw fa-plus topicon"></i>Add New </asp:LinkButton>
                </div>
                <div class="clear">
                </div>
            </div>


            <div id="divaddnew" class="itempopup" style="width: 610px; display: none;">
                <asp:Button ID="PaggedGridbtnedit" runat="server" Style="display: none;" OnClick="PaggedGridbtnedit_Click" ClientIDMode="Static" />
                <div class="popup_heading">
                    <span>Add Expenses</span>
                    <div class="f_right">
                        <img src="images/cross.png" onclick="closediv();" alt="X" title="Close
            Window" />
                    </div>
                </div>
                <div class="tabContaier">

                    <!-- //Tab buttons -->
                    <div class="tabDetails">
                        <div class="tabContents" style="display: block;">
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl">
                                    Expense Type :<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*"
                                        ControlToValidate="txtcode" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:TextBox ID="txtcode" runat="server" CssClass="form-control"
                                        MaxLength="50"></asp:TextBox>
                                </div>
                            </div>
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl">
                                    Expense Code :<asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="*"
                                        ControlToValidate="txtname" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                                </label>
                                <div class="txt w1">
                                    <asp:TextBox ID="txtname" runat="server" CssClass="form-control" placeholder="00"
                                        MaxLength="100"></asp:TextBox>
                                </div>
                            </div>
                            <div class="clear"></div>




                            <div class="ctrlGroup searchgroup">
                                <label class="lbl">Billable :</label>
                                <div class="txt w1 mar10">
                                    <asp:DropDownList ID="rbtnbillable" runat="server" CssClass="form-control">
                                        <asp:ListItem Value="1">Yes</asp:ListItem>
                                        <asp:ListItem Value="0" Selected="True">No</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl">Active Status :</label>
                                <div class="txt w1">
                                    <asp:DropDownList ID="dropactive" runat="server" CssClass="form-control">
                                        <asp:ListItem Value="Active" Selected="True">Active</asp:ListItem>
                                        <asp:ListItem Value="Block">Block</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="clear"></div>
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl">Mu % :</label>
                                <div class="txt w1 mar10">
                                    <asp:TextBox ID="txtMuAmount" runat="server" CssClass="form-control" placeholder="0.00"
                                        onkeypress="blockNonNumbers(this, event, true, false);" onblur="fill(this.id);"
                                        onkeyup="extractNumber(this,2,false);"></asp:TextBox>
                                </div>
                            </div>
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl">Reimb :</label>
                                <div class="txt w1">
                                    <asp:DropDownList ID="rbtnReimb" runat="server" CssClass="form-control">
                                        <asp:ListItem Value="1">Yes</asp:ListItem>
                                        <asp:ListItem Value="0" Selected="True">No</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>

                            <div class="clear"></div>
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl">Cost Rate :($)</label>
                                <div class="txt w1 mar10">
                                    <asp:TextBox ID="txtcostrate" runat="server" CssClass="form-control" placeholder="0.00"
                                        onkeypress="blockNonNumbers(this, event, true, false);" onblur="fill(this.id);"
                                        onkeyup="extractNumber(this,2,false);"></asp:TextBox>
                                </div>
                            </div>
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl">Tax :(%)</label>
                                <div class="txt w1">
                                    <asp:TextBox ID="txtbillrate" runat="server" CssClass="form-control" placeholder="0.00"
                                        onkeypress="blockNonNumbers(this, event, true, false);" onblur="fill(this.id);"
                                        onkeyup="extractNumber(this,2,false);"></asp:TextBox>
                                </div>
                            </div>
                            <div class="clear"></div>

                            <div class="clear">
                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl">
                                        Description :<asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="*"
                                            ControlToValidate="txtdescription" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                                    </label>
                                    <div class="txt w3 mar10">
                                        <asp:TextBox ID="txtdescription" runat="server" CssClass="form-control" TextMode="MultiLine" Height="80px"
                                            placeholder="Expense Description"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                        </div>


                        <div class="clear">
                        </div>
                    </div>

                    <div class="col-xs-12 col-sm-12" style="padding: 10px 0px 0px 0px;">
                        <asp:Button ID="btnsubmit" runat="server" CssClass="btn btn-primary" Text="Save"
                            ValidationGroup="save" OnClick="btnsubmit_Click" />
                        <asp:Button ID="btndelete" runat="server" CssClass="btn btn-default" Visible="false"
                            Text="Delete" OnClientClick='return confirm("Delete this record? Yes or No");'
                            OnClick="btndelete_Click" />
                    </div>
                </div>

            </div>

            <div id="otherdiv" onclick="closediv();">
            </div>
        </ContentTemplate>
        <%-- <Triggers>
            <asp:PostBackTrigger ControlID="btnexportcsv" />

        </Triggers>--%>
    </asp:UpdatePanel>

    <div class="contentpanel">
        <asp:UpdatePanel ID="updateData" runat="server" UpdateMode="Conditional">
            <ContentTemplate>

                <input type="hidden" id="hidid" runat="server" />
                <div class="row">
                    <div class="col-sm-12 col-md-12">
                        <div class="panel panel-default">
                            <div class="col-sm-12 col-md-10 mar">
                                <div class="ctrlGroup searchgroup">
                                    <label class="lblAuto">
                                        Exp. Code/Name:
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:TextBox ID="txtsearch" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>


                                <div class="ctrlGroup searchgroup">
                                    <label class="lblAuto">
                                        Status:
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:DropDownList ID="drostatus1" runat="server" CssClass="form-control">
                                            <asp:ListItem Selected="True" Value="">--All--</asp:ListItem>
                                            <asp:ListItem Value="Active">Active</asp:ListItem>
                                            <asp:ListItem Value="Block">Block</asp:ListItem>

                                        </asp:DropDownList>
                                    </div>
                                </div>

                                <div class="ctrlGroup searchgroup">
                                    <asp:Button ID="btnsearch" runat="server" CssClass="btn btn-default" Text="Search"
                                        OnClick="btnsearch_Click" />
                                </div>
                            </div>
                            <div class="col-sm-12 col-md-2 mar" style="display: none;">
                                <div class="ctrlGroup searchgroup" style="float: right;">
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
                            </div>
                            <div class="clear">
                            </div>
                            <div class="col-sm-12 col-md-12 mar">

                                <div class="clear">
                                </div>
                                <div class="panel panel-default">
                                    <div class="panel-body2 ">
                                        <div class="row">
                                            <div class="table-responsive" style="min-height: 300px;">
                                                <asp:GridView ID="dgnews" runat="server" AllowPaging="true" AutoGenerateColumns="False"
                                                    PageSize="50" CellPadding="4" CellSpacing="0" Width="100%" ShowHeader="true"
                                                    ShowFooter="false" CssClass="tblreport" GridLines="None" AllowSorting="true"
                                                    OnRowDataBound="dgnews_RowDataBound" OnSorting="dgnews_Sorting" OnRowCommand="dgnews_RowCommand"
                                                    OnPageIndexChanging="dgnews_PageIndexChanging" OnRowCreated="dgnews_RowCreated">
                                                    <Columns>

                                                        <asp:TemplateField HeaderText="Expense Type" SortExpression="taskcode" HeaderStyle-Width="100px">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"taskcode")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                        <asp:TemplateField HeaderText="Expense Code" SortExpression="taskname">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"taskname")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Description" SortExpression="Description">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"Description")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Cost Rate" SortExpression="CostRate">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem, "CostRate")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="MU %" SortExpression="MuRate">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"MuRate")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Reimb" SortExpression="isReimb">
                                                            <ItemTemplate>
                                                                <%# Convert.ToBoolean(DataBinder.Eval(Container.DataItem,"isReimb"))== true?"Yes":"No"%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Billable" SortExpression="billableword">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem, "billableword")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                        <asp:TemplateField HeaderText="Status" SortExpression="activestatus">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem, "activestatus")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                        <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="70px">
                                                            <ItemTemplate>
                                                                <a onclick='clickedit(<%#DataBinder.Eval(Container.DataItem,"nid")%>);' title="Edit"><i class="fa fa-fw">
                                                                    <img src="images/edit.png"></i></a>
                                                                &nbsp;
                                                                <asp:LinkButton ID="lbtndelete" CommandName="remove" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>'
                                                                    ToolTip="Delete" runat="server"
                                                                    OnClientClick='return confirm("Delete this record? Yes or No");'><i class="fa fa-fw" ><img src="images/delete.png" alt=""></i></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                    </Columns>
                                                    <HeaderStyle CssClass="gridheader" />
                                                    <PagerStyle CssClass="gridpager" HorizontalAlign="Center" />
                                                </asp:GridView>


                                                <div class="nodatafound" id="nodata" runat="server">
                                                    No data found
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="clear">
                            </div>
                        </div>
                    </div>
                </div>

            </ContentTemplate>
        </asp:UpdatePanel>
    </div>






    <script type="text/javascript">







        function opendiv() {
            setposition("divaddnew");
            document.getElementById("divaddnew").style.display = "block";
            document.getElementById("otherdiv").style.display = "block";
        }
        function closediv() {

            document.getElementById("divaddnew").style.display = "none";
            document.getElementById("otherdiv").style.display = "none";

        }



    </script>

</asp:Content>
