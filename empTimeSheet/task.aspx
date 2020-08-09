<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="task.aspx.cs" Inherits="empTimeSheet.task" %>



<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="Stylesheet" href="css/tab_2.0.css" type="text/css" />

    
       <link rel="stylesheet"  href="css/jquery.dataTables.min.css" />

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

                $('#ctl00_ContentPlaceHolder1_dgnews').dataTable({
                    "dom": 'lrtip',
                    "pageLength": 50,
                    'aoColumnDefs': [{
                        'bSortable': false,
                        'aTargets': [-1] /* 1st one, start by the right */
                    }]
                });

            });



        }
        $(document).ready(function () {
        $('input').keypress(function (event) {
            var keycode = (event.keyCode ? event.keyCode : event.which);
            if (keycode == '13') {
                $("#ctl00_ContentPlaceHolder1_btnsearch").trigger("click");
                return false;
            }
        });
        });
        //$(document).ready(function () {
        //    $("#ctl00_ContentPlaceHolder1_txtsearch").on('keyup', function (e) {
        //        if (e.keyCode == 13) {
        //          //  $("#ctl00_ContentPlaceHolder1_btnsearch").trigger("click");
        //            return false;
        //        }
        //    });

        //})
    </script>
    <style type="text/css">
        .tabContaier {
            padding: 10px;
        }


        .tabContents {
            height: 265px;
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
                    <i class="fa fa-home f_left"></i>Manage Task
                </h2>
                <div class="breadcrumb-wrapper">

                    <asp:LinkButton ID="liaddnew" runat="server" CssClass="right_link" OnClick="liaddnew_Click">
                    <i class="fa fa-fw fa-plus topicon"></i>Add New </asp:LinkButton>
                </div>
                <div class="clear">
                </div>
            </div>


            <div id="divaddnew" class="itempopup" style="width: 610px; display: none;"> <asp:Button ID="PaggedGridbtnedit" runat="server" Style="display: none;" OnClick="PaggedGridbtnedit_Click" ClientIDMode="Static" />
                <div class="popup_heading">
                    <span>Add Task</span>
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
                                <label class="lbl">Task ID :
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="*"
                                                    ControlToValidate="txtname" CssClass="l" ValidationGroup="save"></asp:RequiredFieldValidator>
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:TextBox ID="txtname" runat="server" CssClass="form-control"
                                        MaxLength="100"></asp:TextBox>
                                </div>
                            </div>
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl">Task Name :
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*"
                                                    ControlToValidate="txtcode" ValidationGroup="save"></asp:RequiredFieldValidator>
                                </label>
                                <div class="txt w1">
                                    <asp:TextBox ID="txtcode" runat="server" CssClass="form-control" placeholder="Task Name"
                                        MaxLength="50"></asp:TextBox>
                                </div>
                            </div>
                            <div class="clear"></div>
                            
                        
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl">Department :
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:DropDownList ID="dropdepartment" runat="server" CssClass="form-control">
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
                                <label class="lbl">Cost Rate :($)
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:TextBox ID="txtcostrate" runat="server" CssClass="form-control" placeholder="0.00"
                                        onkeypress="blockNonNumbers(this, event, true, false);" onblur="fill(this.id);"
                                        onkeyup="extractNumber(this,2,false);"></asp:TextBox>
                                </div>
                            </div>
                           
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl">Bill Rate :($)
                                </label>
                                <div class="txt w1">
                                    <asp:TextBox ID="txtbillrate" runat="server" CssClass="form-control" placeholder="0.00"
                                        onkeypress="blockNonNumbers(this, event, true, false);" onblur="fill(this.id);"
                                        onkeyup="extractNumber(this,2,false);"></asp:TextBox>
                                </div>
                            </div>
                              <div class="clear"></div>
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl">Budgeted Hrs :<asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server"
                                        ErrorMessage="*" ControlToValidate="txtBHours" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                                </label>
                                <div class="txt w1 mar10">
                                    <asp:TextBox ID="txtBHours" runat="server" CssClass="form-control" placeholder="0"
                                        onkeypress="blockNonNumbers(this, event, true, false);" onblur="fill(this.id);"
                                        onkeyup="extractNumber(this,2,false);"></asp:TextBox>
                                </div>
                            </div>
                            
                            <div class="ctrlGroup searchgroup">
                                <label class="lbl">Billable :</label>
                                <div class="txt w1">
                                    <asp:DropDownList ID="rbtnbillable" runat="server" CssClass="form-control">
                                        <asp:ListItem Value="1">Yes</asp:ListItem>
                                        <asp:ListItem Value="0" Selected="True">No</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                              <div class="clear"></div>
                            

                            <div class="ctrlGroup searchgroup">
                                <label class="lbl">Description :
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="*"
                                                    ControlToValidate="txtdescription" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                                </label>
                                <div class="txt w3 mar10">
                                    <asp:TextBox ID="txtdescription" runat="server" CssClass="form-control" TextMode="MultiLine"
                                        MaxLength="500" Height="80px" placeholder="Task Description"></asp:TextBox>
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

    </asp:UpdatePanel>

    <div class="contentpanel">
        <asp:UpdatePanel ID="updateData" runat="server" UpdateMode="Conditional">
            <ContentTemplate>

                <input type="hidden" id="hidid" runat="server" />
                <div class="row">
                    <div class="col-sm-12 col-md-12">
                        <div class="panel panel-noborder">
                            <div class="col-sm-12 col-md-10 mar">
                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl">
                                        Task Code/Name:
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:TextBox ID="txtsearch" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl">
                                        Department:
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:DropDownList ID="dropdept1" runat="server" CssClass="form-control  pad3">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="clear"></div>
                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl">
                                        Status:
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:DropDownList ID="drostatus1" runat="server" CssClass="form-control  pad3">
                                            <asp:ListItem Selected="True" Value="">--All--</asp:ListItem>
                                            <asp:ListItem Value="Active">Active</asp:ListItem>
                                            <asp:ListItem Value="Block">Block</asp:ListItem>

                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl">
                                        Bill Status:
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:DropDownList ID="dropbillalbe" runat="server" CssClass="form-control  pad3">
                                            <asp:ListItem Value="">--All--</asp:ListItem>
                                            <asp:ListItem Value="1">Billable</asp:ListItem>
                                            <asp:ListItem Value="0">Non-Billable</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="ctrlGroup searchgroup">
                                    <asp:Button ID="btnsearch" runat="server" CssClass="btn btn-default" Text="Search"
                                        OnClick="btnsearch_Click" />
                                </div>
                            </div>
                           <div class="col-sm-12 col-md-2 mar" style="display:none;">
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
                                             <asp:GridView ID="dgnews" runat="server" AllowPaging="false" AutoGenerateColumns="False"
                                                    PageSize="50" CellPadding="4" CellSpacing="0" Width="100%" ShowHeader="true"
                                                    ShowFooter="false" CssClass="tblreport" GridLines="None" AllowSorting="false"
                                                    OnRowDataBound="dgnews_RowDataBound" OnRowCommand="dgnews_RowCommand"
                                                    OnPageIndexChanging="dgnews_PageIndexChanging">
                                                    <Columns>

                                                        <asp:TemplateField HeaderText="Task Name" SortExpression="taskcode" HeaderStyle-Width="100px">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"taskcode")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                        <asp:TemplateField HeaderText="Task Code" SortExpression="taskname">
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
                                                        <asp:TemplateField HeaderText="Bill Rate" SortExpression="BillRate">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"BillRate")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Budgeted Hrs" SortExpression="BHours">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"BHours")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Billable" Visible="false" SortExpression="billableword">
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
                                                                    OnClientClick='return confirm("Delete this record? Yes or No");'><i class="fa fa-fw" >
                                                            <img src="images/delete.png" alt=""></i></asp:LinkButton>
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





        function blank() {
            document.getElementById("txtclientcode").value = "";
            document.getElementById("txtname").value = "";
            document.getElementById("txtcompany").value = "";
            document.getElementById("txtemail").value = "";
            document.getElementById("txtcell").value = "";
            document.getElementById("txtfax").value = "";
            document.getElementById("txtphone").value = "";
            document.getElementById("txtremark").value = "";
            document.getElementById("txtstreet").value = "";
            document.getElementById("txttitle").value = "";
            document.getElementById("txtzip").value = "";
            document.getElementById("dropmanager").value = "";
            document.getElementById("dropactive").value = "Active";
            document.getElementById("dropstate").value = "";
            document.getElementById("dropstate1").value = "";
            document.getElementById("dropcountry").value = "";
            document.getElementById("dropcountry1").value = "";
            document.getElementById("dropcity").value = "";
            document.getElementById("dropcity1").value = "";
            document.getElementById("txtemail1").value = "";
            document.getElementById("txtcell1").value = "";
            document.getElementById("txtphone1").value = "";
            document.getElementById("txtwebsite").value = "";
            document.getElementById("txtaddress2").value = "";
            document.getElementById("txtworkphone").value = "";
            document.getElementById("txtzip1").value = "";
            document.getElementById("hidid").value = "";

            document.getElementById("hidaddress").value = "";
            document.getElementById("btndelete").style.display = "block";
            document.getElementById("btnsubmit").value = "Submit";

            document.getElementById("txtclientcode").desiabled = false;
            document.getElementById("txtdesignation").value = "";


        }

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
