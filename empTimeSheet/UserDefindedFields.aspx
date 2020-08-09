<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="UserDefindedFields.aspx.cs" Inherits="empTimeSheet.UserDefindedFields" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">





    <script type="text/javascript">


        //Open add/edit div
        function opendiv() {
            setposition("divaddnew");
            document.getElementById("divaddnew").style.display = "block";
            document.getElementById("otherdiv").style.display = "block";
        }
        function closediv() {

            document.getElementById("divaddnew").style.display = "none";
            document.getElementById("otherdiv").style.display = "none";

        }
        function showcontroltype() {
            if (document.getElementById("ctl00_ContentPlaceHolder1_dropvaluetype").value != "Text") {
                document.getElementById("ctl00_ContentPlaceHolder1_dropcontrol").selectedIndex = 0;
                document.getElementById("ctl00_ContentPlaceHolder1_dropcontrol").disable = true;

            }
            else {
                document.getElementById("ctl00_ContentPlaceHolder1_dropcontrol").selectedIndex = 0;
                document.getElementById("ctl00_ContentPlaceHolder1_dropcontrol").disable = false;
            }
            document.getElementById("divoption").style.display = "none";
        }
        function showoption() {

            if (document.getElementById("ctl00_ContentPlaceHolder1_hidsno").value != "") {
                var sno = parseInt(document.getElementById("ctl00_ContentPlaceHolder1_hidsno").value);
                for (var i = 0; i <= sno; i++) {
                    deleterow();

                }
                document.getElementById("ctl00_ContentPlaceHolder1_hidsno").value = "";
            }

            if (document.getElementById("ctl00_ContentPlaceHolder1_dropcontrol").value == "Dropdown") {
                document.getElementById("divoption").style.display = "block";
                var table = document.getElementById("tbldata");



                var newsno = 0;
                var row = table.insertRow(newsno);



                var colnum = 0;
                var celldelete = row.insertCell(colnum);
                colnum++;
                var cellronnum = row.insertCell(colnum);
                colnum++;
                var celloption = row.insertCell(colnum); colnum++;
                var cellAdd = row.insertCell(colnum); colnum++;

                celldelete.innerHTML = "<div id='divdel" + newsno + "' ></div>";

                cellronnum.innerHTML = "  <label class='lbl'>Option " + (newsno + 1) + ":</label> <input type='hidden' id='hidUDFnid_" + newsno + "' value='' />";
                celloption.innerHTML = "<input type='text' id='txtUDFOption_" + newsno + "' value='' onblur='removeSpecial(this.id,event)' class='form-control' />";
                cellAdd.innerHTML = "<div id='divadd" + newsno + "' ><a style='cursor: pointer;color:bule;' id='add' onclick='addrow(this.id);' ><i class='fa fa-add'></i>Add</a></div>";

                document.getElementById("ctl00_ContentPlaceHolder1_hidsno").value = "0";

            }
            else {
                document.getElementById("divoption").style.display = "none";
            }
        }
        function addrow() {
            var table = document.getElementById("tbldata");
            var id = parseInt(document.getElementById("ctl00_ContentPlaceHolder1_hidsno").value);

            var newsno = id + 1;
            var row = table.insertRow(newsno);


            if (id > 0) {
                document.getElementById("divdel" + id).innerHTML = "";

            }
            document.getElementById("divadd" + id).innerHTML = "";
            var row = table.insertRow(newsno);
            var colnum = 0;
            var celldelete = row.insertCell(colnum);
            colnum++;
            var cellronnum = row.insertCell(colnum);
            colnum++;
            var celloption = row.insertCell(colnum); colnum++;
            var cellAdd = row.insertCell(colnum); colnum++;

            celldelete.innerHTML = "<div id='divdel" + newsno + "' ><a style='cursor: pointer;color:bule;' id='delete' onclick='deleterow(this.id);' ><i class='fa fa-fw' style='font-size: 18px; color: #d9534f; display: block; margin: auto;'><img src='images/delete.png' alt=''></i></a></div>";

            cellronnum.innerHTML = "  <label class='lbl'>Option " + (newsno + 1) + ":</label> <input type='hidden' id='hidUDFnid_" + newsno + "' value='' />";
            celloption.innerHTML = "<input type='text' id='txtUDFOption_" + newsno + "' value='' onblur='removeSpecial(this.id,event)' class='form-control' />";
            cellAdd.innerHTML = "<div id='divadd" + newsno + "' ><a style='cursor: pointer;color:bule;' id='add' onclick='addrow(this.id);' ><i class='fa fa-fw'>Add</i></a></div>";

            document.getElementById("ctl00_ContentPlaceHolder1_hidsno").value = newsno;

        }
        function deleterow() {

            var table = document.getElementById("tbldata");
            var id = parseInt(document.getElementById("ctl00_ContentPlaceHolder1_hidsno").value);

            var newsno = id - 1;
            table.deleteRow(id);
            if (newsno != 0) {
                document.getElementById("divdel" + newsno).innerHTML = "<a style='cursor: pointer;color:bule;' id='delete' onclick='deleterow(this.id);' ><i class='fa fa-fw' style='font-size: 18px; color: #d9534f; display: block; margin: auto;'><img src='images/delete.png' alt=''></i></a>";

            }
            document.getElementById("divadd" + newsno).innerHTML = "<a style='cursor: pointer;color:bule;' id='delete' onclick='addrow(this.id);' ><i class='fa fa-fw'>Add</i></a>";
            document.getElementById("ctl00_ContentPlaceHolder1_hidsno").value = newsno;



        }
        function reset() {
            document.getElementById("ctl00_ContentPlaceHolder1_txttitle").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_dropmodule").selectedIndex = 0;
            document.getElementById("ctl00_ContentPlaceHolder1_dropcontrol").selectedIndex = 0;
            document.getElementById("ctl00_ContentPlaceHolder1_dropvaluetype").selectedIndex = 0;
            document.getElementById("ctl00_ContentPlaceHolder1_dropcontrol").disable = false;
            document.getElementById("divoption").style.display = "none";
            document.getElementById("ctl00_ContentPlaceHolder1_hidid").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_hiddata").value = "";


        }

        function blockSpecial(obj, event) {

            var regex = new RegExp("^[\"#']+$");
            var key = String.fromCharCode(!event.charCode ? event.which : event.charCode);
            if (regex.test(key)) {
                event.preventDefault();
                return false;
            }
        }
        function removeSpecial(obj, event) {
            var str = document.getElementById(obj).value;
            str = document.getElementById(obj).value.replace(/[#'~\"]+/gim, "");
            document.getElementById(obj).value = str.replace(/("|')/g, "");
            document.getElementById(obj).value = str;
        }
        function setoptiontext() {
            var str = "";
            var str1 = "";
            var status = 1;

            if (document.getElementById("ctl00_ContentPlaceHolder1_dropcontrol").value == "Dropdown") {
                var id = parseInt(document.getElementById("ctl00_ContentPlaceHolder1_hidsno").value);
                for (var i = 0; i < id; i++) {
                    if (document.getElementById("txtUDFOption_" + i).value == "") {
                        document.getElementById("txtUDFOption_" + i).style.borderColor = "red";
                        status = 0;
                    }
                    else {
                        document.getElementById("txtUDFOption_" + i).style.borderColor = "#cdcdcd";
                        str = str + document.getElementById("txtUDFOption_" + i).value + '#';
                        str1 = str1 + document.getElementById("hidUDFnid_" + i).value + '#';
                    }
                }


            }

            if (status == 0) {
                str = "";
                str1 = "";
                document.getElementById("ctl00_ContentPlaceHolder1_hiddata").value = str;
                document.getElementById("ctl00_ContentPlaceHolder1_hiddatanid").value = str1;
                return false;
            }
            else {
                document.getElementById("ctl00_ContentPlaceHolder1_hiddata").value = str;
                document.getElementById("ctl00_ContentPlaceHolder1_hiddatanid").value = str1;
                return true;
            }
        }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="otherdiv" onclick="closediv();">
    </div>

    <div style="width: 600px;" id="divaddnew" class="itempopup">
        <div class="popup_heading">
            <span id="legendaction" runat="server">Add  User Defined Field</span>
            <div class="f_right">
                <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
            </div>
        </div>
        <div class="tabContents">
            <div class="col-xs-12
            col-sm-12 mar">
                <div style="min-height: 200px;">
                    <div class="ctrlGroup">
                        <label class="lbl">
                            Title :<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                                ControlToValidate="txttitle" ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator>
                        </label>
                        <div class="txt w1 mar10">

                            <asp:TextBox ID="txttitle" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>
                    <div class="ctrlGroup">
                        <label class="lbl">
                            Module :<asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                                ControlToValidate="dropmodule" ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator>
                        </label>
                        <div class="txt w1">

                            <asp:DropDownList ID="dropmodule" runat="server" CssClass="form-control">
                            </asp:DropDownList>

                        </div>
                    </div>
                    <div class="clear"></div>
                    <div class="ctrlGroup">
                        <label class="lbl">
                            Value Type :<asp:RequiredFieldValidator ID="req1" runat="server" ControlToValidate="dropvaluetype"
                                ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator>
                        </label>
                        <div class="txt w1 mar10">
                            <asp:DropDownList ID="dropvaluetype" runat="server" CssClass="form-control" onchange="showcontroltype();">
                                <asp:ListItem Value="Text">Text</asp:ListItem>
                                <asp:ListItem Value="Date">Date</asp:ListItem>
                                <asp:ListItem Value="Number">Number</asp:ListItem>

                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="ctrlGroup">
                        <label class="lbl">
                            Control Type:
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="dropcontrol"
                                    ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator></label>
                        <div class="txt w1">
                            <asp:DropDownList ID="dropcontrol" runat="server" CssClass="form-control" onchange="showoption();">
                                <asp:ListItem Value="Textbox">Textbox</asp:ListItem>
                                <asp:ListItem Value="Dropdown">Dropdown</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="clear"></div>

                    <div id="divoption" style="display: none;" class="ctrlGroup">
                       
                          <div class="ctrlGroup">
                             
                        <div class="txt w4" style="border:solid 1px #e0e0e0;">

                            <input type="hidden" id="hidsno" runat="server" value="" />
                            <input type="hidden" id="hiddata" runat="server" value="" />
                            <input type="hidden" id="hiddatanid" runat="server" value="" />
                            <table id="tbldata" width="100%" class="table" cellpadding="0" style="margin:0px;">
                            </table>

                        </div>
                              </div>

                    </div>

                </div>

                <div class="clear">
                    <asp:Button ID="btnsubmit" runat="server" CssClass="btn
            btn-primary"
                        Text="Save" ValidationGroup="save" OnClick="btnsubmit_Click" CausesValidation="true" OnClientClick="var status=validatefieldsbygroup('save'); var status1=setoptiontext(); if(status == true && status1 ==true) {return true;} else{return false;}" />
                </div>
            </div>


        </div>
    </div>


    <asp:UpdatePanel ID="upadatepanel" runat="server">
        <ContentTemplate>




            <pg:progress ID="progress1" runat="server" />

            <div class="pageheader">
                <h2>
                    <i class="fa fa-table"></i>User Defined Fields
                </h2>
                <input type="hidden" id="hidid" runat="server" />
                <div class="breadcrumb-wrapper mar ">
                    <div class="f_right">
                        <%-- <asp:LinkButton ID="liaddnew" runat="server" CssClass="add_new" OnClick="liaddnew_Click">--%>
                        <a onclick="reset();opendiv();" id="liaddnew" runat="server" class="right_link">
                            <i class="fa fa-fw fa-plus topicon"></i>
                            Add New</a>


                    </div>
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
                                    <label class="lblAuto">
                                        Title:
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:TextBox ID="txtkeyword" runat="server" CssClass="form-control" placeholder="Title"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="ctrlGroup searchgroup">
                                    <label class="lblAuto">
                                        Module:
                                    </label>
                                    <div class="txt w1 mar10">
                                        <asp:DropDownList ID="dropmodule1" runat="server" CssClass="form-control  pad3">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="ctrlGroup searchgroup">
                                    <asp:Button ID="btnsearch" runat="server" CssClass="btn btn-default" Text="View Report"
                                        OnClick="btnsearch_click" />
                                </div>
                            </div>
                            <div class="col-sm-12 col-md-2 mar">
                                <div class="ctrlGroup searchgroup" style="float: right;">
                                    <asp:LinkButton ID="lnkprevious" CssClass="f_left" runat="server" OnClick="lnkprevious_Click">
            <i class="fa fa-fw fa-fast-backward color_green"></i></asp:LinkButton>
                                    </span>
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
                                                <div class="nodatafound" id="divnodata" runat="server">
                                                    No data found
                                                </div>
                                                <asp:GridView ID="dgnews" runat="server" AllowPaging="true" AutoGenerateColumns="False"
                                                    PageSize="50" CellPadding="4" CellSpacing="0" Width="100%" ShowHeader="true"
                                                    ShowFooter="false" CssClass="table table-success mb30" GridLines="None" AllowSorting="true"
                                                    OnRowDataBound="dgnews_RowDataBound" OnSorting="dgnews_Sorting" OnRowCommand="dgnews_RowCommand" OnRowCreated="dgnews_RowCreated"
                                                    OnPageIndexChanging="dgnews_PageIndexChanging">
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="40px">
                                                            <ItemTemplate>
                                                                <%# Container.DataItemIndex + 1 %>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Title" SortExpression="name">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"name")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Value Type" SortExpression="valType" HeaderStyle-Width="100px">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"valType")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Control Type" SortExpression="ctrlType">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"ctrlType")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Module" SortExpression="modulename">
                                                            <ItemTemplate>
                                                                <%#DataBinder.Eval(Container.DataItem,"modulename")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                        <asp:TemplateField HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center">
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="lbtnedit" CommandName="edititem" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>'
                                                                    ToolTip="Edit" runat="server"><i class="fa fa-fw" >
                                                            <img src="images/edit.png" ></i></asp:LinkButton>

                                                                &nbsp;
                                                                  <asp:LinkButton ID="lbtndelete" CommandName="del" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>'
                                                                      ToolTip="Delete" runat="server" OnClientClick='return confirm("Delete this record?
            Yes or No");'><i class="fa fa-fw" >
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
                            </div>
                            <div class="clear">
                            </div>
                        </div>
                    </div>
                </div>
            </div>




        </ContentTemplate>

    </asp:UpdatePanel>
</asp:Content>
