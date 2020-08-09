<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="Department.aspx.cs" Inherits="empTimeSheet.Department" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="Stylesheet" href="css/tab_2.0.css" type="text/css" />



    <script>

        function fixheader() {

            $.getScript("js/colResizable-1.6.js", function () {

                $("#ctl00_ContentPlaceHolder1_dgnews").colResizable({
                    liveDrag: true,
                    gripInnerHtml: "<div class='grip'></div>",
                    draggingClass: "dragging",
                    resizeMode: 'fit'
                });

            });



        }
    </script>
    <style type="text/css">
        .tabContaier {
            padding: 10px;
        }
        .ctrlGroup .lbl {
        
        width:136px !important;
        }

        .tabContents {
            height: 190px;
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
                   <i class="fa fa-cube"></i>Manage Department
                </h2>
                <div class="breadcrumb-wrapper">
                   
                    <asp:LinkButton ID="liaddnew" runat="server" CssClass="right_link" OnClick="liaddnew_Click">
                    <i class="fa fa-fw fa-plus topicon"></i>Add New </asp:LinkButton>
                </div>
                <div class="clear">
                </div>
            </div>


            <div id="divaddnew" class="itempopup" style="width: 472px; display: none;">
                <div class="popup_heading">
                    <span>Add Department</span>
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
                                        <label class="lbl">Department :<asp:RequiredFieldValidator ID="req1" runat="server" ControlToValidate="txtname"
                                                ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator>
                                        </label>
                                        <div class="txt w2">
                                            <asp:TextBox ID="txtname" runat="server" CssClass="form-control" ></asp:TextBox>
                                        </div>
                                    </div>
                             <div class="clear">
                                    </div>
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl">Manager :<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="dropemployee"
                                                ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator>
                                        </label>
                                        <div class="txt w2">
                                            <asp:DropDownList ID="dropemployee" runat="server" CssClass="form-control" >
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="clear">
                                    </div>
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl">Department Info :</label>
                                        <div class="txt w2">
                                            <asp:TextBox ID="txtdes" runat="server" CssClass="form-control" Height="50" TextMode="MultiLine"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="clear"></div>
                           

                            <div class="clear">
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
                                    <label class="lbl">Keyword :</label>
                                    <div class="txt w2 mar10">
                                        <asp:TextBox ID="txtsearch" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                               
                             
                               
                               
                                <div class="ctrlGroup searchgroup">
                                    <asp:Button ID="btnsearch" runat="server" CssClass="btn btn-default" Text="Search"
                                        OnClick="btnsearch_Click" />
                                </div>
                            </div>
                            <div class="col-sm-12 col-md-2 mar">
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

                                                        <asp:TemplateField HeaderText="Department" SortExpression="department">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"department")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                      
                                                        <asp:TemplateField HeaderText="Description" SortExpression="Description">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"Description")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Manager" SortExpression="managername">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"managername")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                        <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="70px">
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="lbtnedit" CommandName="detail" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>'
                                                                    ToolTip="Edit" runat="server"><i class="fa fa-fw" >
                                                            <img src="images/edit.png" ></i></asp:LinkButton>
                                                                &nbsp;
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