<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="informationType.aspx.cs" Inherits="empTimeSheet.informationType" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="Stylesheet" href="css/tab_2.0.css" type="text/css" />

    <link rel="stylesheet" href="css/jquery.dataTables.min.css" />

    <script src="js/jquery.min.js"></script>

    <script type="text/javascript" src="js/jquery.dataTables.min.js"></script>

    <script>
        function fixheader() {

            $('#ctl00_ContentPlaceHolder1_dgnews').dataTable({
                "dom": 'lrtip',
                "bLengthChange": false,
                "bPaginate": false,
                'aoColumnDefs': [{
                    'bSortable': false,
                    "bPaginate": false,
                    'aTargets': [-2,-1] /* 1st one, start by the right */
                }]
            });



        }
    </script>
    <style type="text/css">
        .tabContaier {
            padding: 10px;
        }


        .tabContents {
            height: 300px;
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
            <div class="pageheader">
                <h2>
                    <i class="fa fa-info-circle"></i>Information Type
                </h2>
                <div class="breadcrumb-wrapper">

                    <asp:LinkButton ID="liaddnew" runat="server" CssClass="right_link" OnClick="liaddnew_Click">
                    <i class="fa fa-fw fa-plus topicon"></i>Add New </asp:LinkButton>
                </div>
                <div class="clear">
                </div>
            </div>
            <input type="hidden" id="hidid" runat="server" />
            <input type="hidden" id="hidaddress" runat="server" />
            <input type="hidden" id="hidrate" runat="server" />

            <div id="divaddnew" class="itempopup" style="width: 600px; display: none;">
                <asp:Button ID="PaggedGridbtnedit" runat="server" Style="display: none;" OnClick="PaggedGridbtnedit_Click" ClientIDMode="Static" />
                <div class="popup_heading">
                    <span>Information Type</span>
                    <div class="f_right">
                        <img src="images/cross.png" onclick="closediv();" alt="X" title="Close
            Window" />
                    </div>
                </div>
                <div class="tabContaier">

                    <!-- //Tab buttons -->
         
                        <div class="col-xs-12 col-sm-12">
                                <div class="ctrlGroup">
                                    <label class="lbl lbl1">
                                        Location :  
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*"
                                            ControlToValidate="droplocation" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                                    </label>
                                    <div class="txt w1">
                                        <asp:DropDownList ID="droplocation" onchange="manageadd(this)" runat="server" CssClass="form-control"></asp:DropDownList>
                                    </div>
                                </div>
                                <div class="clear"></div>
                                <div class="ctrlGroup">
                                    <label class="lbl lbl1">
                                        Type Title :
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="*"
                                                                    ControlToValidate="txtname" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                                    </label>
                                    <div class="txt w2 mar10">
                                        <asp:TextBox ID="txtname" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="clear"></div>
                                <div class="ctrlGroup">
                                    <label class="lbl lbl1">
                                        Type Description :
                                                              
                                    </label>
                                    <div class="txt w2">
                                        <asp:TextBox ID="txtdes" runat="server" CssClass="form-control">
                                        </asp:TextBox>
                                    </div>
                                </div>


                                <div class="clear"></div>
                             <div class="ctrlGroup">
                                    <label class="lbl lbl1">
                                      &nbsp;
                                                              
                                    </label>
                                    <div class="txt w2">
                                        <asp:Button ID="btnsubmit" runat="server" CssClass="btn btn-primary" Text="Save"
                                ValidationGroup="save" OnClick="btnsubmit_Click" />
                            <asp:Button ID="btndelete" runat="server" CssClass="btn btn-default" Visible="false"
                                Text="Delete" OnClientClick='return confirm("Delete this record? Yes or No");'
                                OnClick="btndelete_Click" />
                                    </div>
                                </div>


                            </div>
                    <div class="clear"></div>

                       
                   
                </div>

            </div>


            <div id="divaddnewtype" class="itempopup" style="width: 600px; display: none;">
                <asp:Button ID="Button1" runat="server" Style="display: none;" OnClick="PaggedGridbtnedit_Click" ClientIDMode="Static" />
                <div class="popup_heading">
                    <span>Information Type</span>
                    <div class="f_right">
                        <img src="images/cross.png" onclick="closediv();" alt="X" title="Close
            Window" />
                    </div>
                </div>
                <div class="tabContaier">

                    <!-- //Tab buttons -->
         
                        <div class="col-xs-12 col-sm-12">
                                <div class="ctrlGroup">
                                    <label class="lbl lbl1">
                                        Location :  
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="*"
                                            ControlToValidate="droplocation" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                                    </label>
                                    <div class="txt w1">
                                        <asp:DropDownList ID="DropDownList1" runat="server" CssClass="form-control"></asp:DropDownList>
                                    </div>
                                </div>
                                
                                <div class="clear"></div>
                                
                             <div class="ctrlGroup">
                                    <label class="lbl lbl1">
                                      &nbsp;
                                                              
                                    </label>
                                    <div class="txt w2">
                                        <asp:Button ID="Button2" runat="server" CssClass="btn btn-primary" Text="Save"
                                ValidationGroup="save" OnClick="btnsubmit_Click" />
                          
                                    </div>
                                </div>


                            </div>
                    <div class="clear"></div>

                       
                   
                </div>

            </div>

            <div id="otherdiv" onclick="closediv();">
            </div>
        </ContentTemplate>

    </asp:UpdatePanel>

    <div class="contentpanel">
        <asp:UpdatePanel ID="updateData" runat="server" UpdateMode="Conditional">
            <ContentTemplate>


                <div class="row">
                    <div class="col-sm-12 col-md-12">
                        <div class="panel panel-default">
                            <div class="col-sm-12 col-md-10 mar">
                                <div class="ctrlGroup searchgroup">
                                    <label class="lblAuto">
                                        Type Title:
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:TextBox ID="txtsearch" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="ctrlGroup searchgroup">
                                    <label class="lblAuto">
                                        Location:
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:DropDownList ID="droplocation1" runat="server" CssClass="form-control  pad3">
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
                                                <asp:GridView ID="dgnews" runat="server" AllowPaging="false" AutoGenerateColumns="False"
                                                    PageSize="50" CellPadding="4" CellSpacing="0" Width="100%" ShowHeader="true"
                                                    ShowFooter="false" CssClass="tblreport" GridLines="None" AllowSorting="false"
                                                    OnRowDataBound="dgnews_RowDataBound" OnRowCommand="dgnews_RowCommand"
                                                    OnPageIndexChanging="dgnews_PageIndexChanging">
                                                    <Columns>

                                                        <asp:TemplateField HeaderText="Type Title" SortExpression="typetitle" HeaderStyle-Width="200px">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"typetitle")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                          <asp:TemplateField HeaderText="Description" SortExpression="typeDes">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"typeDes")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Location" SortExpression="locationName">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"locationName")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                      


                                                        <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="30px">
                                                            <ItemTemplate>
                                                                <a onclick='clickedit(<%#DataBinder.Eval(Container.DataItem,"nid")%>);' title="Edit"><i class="fa fa-fw">
                                                                    <img src="images/edit.png"></i></a>
                                                             
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="30px">
                                                            <ItemTemplate>
                                                           
                                                                <asp:LinkButton ID="lbtndelete" CommandName="remove" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>'
                                                                    ToolTip="Delete" runat="server"
                                                                    OnClientClick='return confirm("Delete this record?Yes or No");'><i class="fa fa-fw" >
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

        function manageadd(ddl)
        {
           // alert($(ddl).val());
        }



        function blank() {
            document.getElementById("txtclientcode").value = "";
            document.getElementById("txtname").value = "";
            document.getElementById("txtcompany").value = "";
           
            document.getElementById("hidid").value = "";

            document.getElementById("hidaddress").value = "";
            document.getElementById("btndelete").style.display = "none";
            document.getElementById("btnsubmit").value = "Submit";




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
