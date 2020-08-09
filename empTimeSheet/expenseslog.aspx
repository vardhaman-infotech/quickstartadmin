<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="expenseslog.aspx.cs" Inherits="empTimeSheet.expenseslog" ValidateRequest="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit.HTMLEditor"
    TagPrefix="cc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">


    <script type="text/javascript">
        function closediv() {
            document.getElementById("hidselectedmemoid").value = "";
            document.getElementById("divmemo").style.display = "none";
            document.getElementById("divattach").style.display = "none";
            document.getElementById("otherdiv").style.display = "none";
        }

        function opendiv(id, mode) {
            var mode1 = "";
            mode1 = String(mode)
            var txtmemo = $find("<%= txtmemo.ClientID %>");
            if (mode1 == "0") {
                document.getElementById("btnsavememo").style.display = "none";
                document.getElementById("ctl00_ContentPlaceHolder1_ltrmemo").style.display = "block";
                document.getElementById("divtxtmemo").style.display = "none";


            }
            else {
                document.getElementById("btnsavememo").style.display = "inline";

                document.getElementById("ctl00_ContentPlaceHolder1_ltrmemo").style.display = "none";
                document.getElementById("divtxtmemo").style.display = "block";

            }
            id = id.replace("lnkmemo", "hidmemo");
            setposition("divmemo");





            var exisitngmemo = document.getElementById(id).value;

            if (mode1 == "1") {
                txtmemo.set_content(exisitngmemo);
            }
            else {
                document.getElementById("ctl00_ContentPlaceHolder1_ltrmemo").innerHTML = exisitngmemo;
            }

            document.getElementById("hidselectedmemoid").value = id;
            document.getElementById("divmemo").style.display = "block";
            document.getElementById("otherdiv").style.display = "block";
        }

        function checkless(e)
        {
            if(isNaN($(e).val())){
                $(e).val(0);
            }
            else if(parseFloat($(e).val())<0)
            {
                $(e).val(0);
            }
        }
        function addmemo() {
            var txtmemo = $find("<%= txtmemo.ClientID %>");
            memo = txtmemo.get_content();

            var id = document.getElementById("hidselectedmemoid").value;
            document.getElementById(id).value = memo;
            closediv();

        }
    </script>

    <style type="text/css">
        .tblsheet td {
            vertical-align: middle;
        }

        input.form-control[disabled], .form-control[readonly], fieldset[disabled] .form-control {
            background-color: #fff;
            border-color: #fff;
            cursor: auto;
            box-shadow: none;
            padding: 2px;
        }

        .gridred input {
            color: red !important;
        }

        .gridblue input {
            color: blue !important;
        }

        .rightclickback {
            width: 100%;
            height: 100%;
            position: fixed;
            top: 0px;
            left: 0px;
            display: none;
            z-index: 1;
        }

        .rightclickcopy {
            position: absolute;
            background: #1caf9a;
            border-radius: 10px;
            z-index: 2;
            padding: 10px;
            width: 60px;
            height: 30px;
            display: none;
            cursor: pointer;
            color: #000000;
        }

            .rightclickcopy a {
                color: #ffffff !important;
                cursor: pointer;
            }

        .divfilelist ul {
            margin: 0px;
            padding: 0px;
        }

            .divfilelist ul li {
                clear: both;
                border-bottom: dashed 1px #000000;
                margin: 0px;
                padding: 5px 0px;
                padding-bottom: 2px;
                float: left;
            }

                .divfilelist ul li a {
                    background-image: url("images/blue_arrow.png");
                    background-position: left center;
                    background-repeat: no-repeat;
                    float: left;
                    margin-right: 10px;
                    min-width: 200px;
                    padding-left: 10px;
                }

                .divfilelist ul li span {
                    float: left;
                }

        .filehead {
            border-bottom: 1px solid #e0e0e0;
            clear: both;
            display: inline-block;
            float: none !important;
            font-size: 18px;
            margin-bottom: 5px;
            padding: 10px 10px 2px 0;
            width: 100% !important;
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="rightclickback" id="rightclickback" onclick="closecopy();"></div>

    <div style="width: 100%; float: left; vertical-align: top; margin-bottom: 30px;"
        id="divsheetbox">
        <pg:progress ID="progress2" runat="server" />
        <div id="otherdiv" onclick="closediv();">
        </div>
        <div class="pageheader">
            <h2>
                <i class="fa  fa-file-text"></i>
                Expenses Log
            </h2>
            <div class="breadcrumb-wrapper mar ">
                <asp:UpdatePanel ID="updateexport" runat="server" ChildrenAsTriggers="true" UpdateMode="Conditional">
                    <ContentTemplate>
                        <input type="hidden" id="hidid" runat="server" />
                        <asp:LinkButton ID="btnexportcsv" runat="server" CssClass="right_link" OnClick="btnexportcsv_Click">
                <i class="fa fa-fw fa-file-excel-o topicon"></i>Export to Excel</asp:LinkButton>
                        <asp:LinkButton ID="lnkrefresh" runat="server" CssClass="right_link" OnClick="lnkrefresh_Click">
                <i class="fa fa-fw fa-refresh topicon"></i>Refresh</asp:LinkButton>
                        <asp:LinkButton ID="btnreject" runat="server" CssClass="right_link" OnClick="setstatus"
                            OnClientClick='return checkrowselected(); return confirm("Are you sure?");'>
                    <i class="fa fa-fw  fa-minus-circle topicon"></i>Reject</asp:LinkButton>
                        <asp:LinkButton ID="btnapprove" runat="server" CssClass="right_link" OnClick="setstatus"
                            OnClientClick='return checkrowselected(); return confirm("Are you sure?");'>
                    <i class="fa fa-fw  fa-check-circle topicon"></i>Approve</asp:LinkButton>
                    </ContentTemplate>
                    <Triggers>
                        <asp:PostBackTrigger ControlID="btnexportcsv" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
            <div class="clear">
            </div>
        </div>
        <div class="contentpanel">
            <div class="row">
                <div class="col-sm-12 col-md-12">
                    <div class="panel panel-default" style="min-height: 450px;">
                        <div class="col-sm-12 col-md-10">
                            <div style="padding-top: 10px;">
                               <div class="clear"></div>
                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl lbl2">
                                        From Date :
                                    </label>
                                    <div class="txt w1 mar10">

                                        <asp:TextBox ID="txtfrom" runat="server" CssClass="form-control hasDatepicker" onchange="comparedate(this.id,'ctl00_ContentPlaceHolder1_txtfrom','ctl00_ContentPlaceHolder1_txtto');hidedetails();"></asp:TextBox>
                                        <cc1:CalendarExtender ID="txtDate_CalendarExtender" runat="server" TargetControlID="txtfrom"
                                            PopupButtonID="txtfrom" Format="MM/dd/yyyy">
                                        </cc1:CalendarExtender>


                                    </div>
                                </div>
                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl lbl2">
                                        To Date :
                                    </label>

                                    <div class="txt w1">
                                        <asp:TextBox ID="txtto" runat="server" CssClass="form-control hasDatepicker" onchange="comparedate(this.id,'ctl00_ContentPlaceHolder1_txtfrom','ctl00_ContentPlaceHolder1_txtto');hidedetails();"></asp:TextBox>

                                        <cc1:CalendarExtender ID="txtDate_CalendarExtender1" runat="server" TargetControlID="txtto"
                                            PopupButtonID="txtto" Format="MM/dd/yyyy">
                                        </cc1:CalendarExtender>


                                    </div>
                                </div>
                                   <div class="clear"></div>
                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl lbl2">
                                        Employee :
                                    </label>

                                    <div class="txt w1 mar10">
                                        <asp:DropDownList ID="dropemployee" runat="server" CssClass="form-control" onchange="hidedetails();">
                                        </asp:DropDownList>
                                    </div>

                                </div>
                                <div class="ctrlGroup searchgroup">
                                    <label class="lbl lbl2">
                                        Project :
                                    </label>
                                    <div class="txt w1 mar10">

                                        <asp:DropDownList ID="dropproject1" runat="server" CssClass="form-control" onchange="hidedetails();">
                                        </asp:DropDownList>
                                    </div>
                                </div>


                                <div class="ctrlGroup searchgroup">
                                    <asp:Button ID="btnsearch" runat="server" Text="Search" CssClass="btn btn-default"
                                        OnClick="btnsearch_Click" />
                                </div>
                            </div>
                        </div>
                        <div class="clear">
                        </div>
                        <div id="divright" class="col-sm-12 col-md-12 mar3">
                            <div class="panel-default">
                                <div class="panel-body2 ">
                                    <div class="row">
                                        <div class="table-responsive">
                                            <asp:Button ID="btnsubmit" runat="server" CssClass="btn btn-primary" Text="Submit"
                                                OnClick="save" Style="display: none;" Visible="true" />
                                            <asp:UpdatePanel ID="upadatepanel1" runat="server" ChildrenAsTriggers="true" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <div>
                                                        <asp:GridView ID="dgnews" runat="server" AllowPaging="false" AutoGenerateColumns="False"
                                                            CellPadding="4" CellSpacing="0" Width="100%" ShowHeader="true" ShowFooter="false"
                                                            CssClass="tblsheet" GridLines="None" OnRowCommand="dgnews_RowCommand" OnRowDataBound="dgnews_RowDataBound"
                                                            OnRowCancelingEdit="dgnews_RowCancelingEdit" OnRowDeleting="dgnews_RowDeleting"
                                                            OnRowEditing="dgnews_RowEditing" OnRowUpdating="dgnews_RowUpdating" ShowHeaderWhenEmpty="true">
                                                            <Columns>
                                                                <asp:TemplateField HeaderText="Approve" HeaderStyle-Width="2%" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderStyle-HorizontalAlign="Center">
                                                                    <HeaderTemplate>
                                                                        <input id="chkSelect" runat="server" name="Select All" onclick="SelectAll(this)" type="checkbox"
                                                                            style="margin-left: 0px; margin-right: 0px;" />
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <asp:CheckBox ID="chkapprove" runat="server" Style="margin-left: 0px; margin-right: 0px;" />
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderStyle-Width="3%">
                                                                    <ItemTemplate>
                                                                        <asp:LinkButton ID="lbtndelete" CommandName="del" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>'
                                                                            ToolTip="Delete" runat="server" OnClientClick='return confirm("Delete this record? Yes or No");'><img src="images/delete.png" alt="Delete"  /></asp:LinkButton>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>

                                                                <asp:TemplateField HeaderText="Date" HeaderStyle-Width="18%">
                                                                    <ItemTemplate>
                                                                        <%# DataBinder.Eval(Container.DataItem, "date")%>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <asp:TextBox ID="txtdate" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "date")%>'
                                                                            CssClass="form-control date"></asp:TextBox>

                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="EmpID" HeaderStyle-Width="8%">
                                                                    <ItemTemplate>
                                                                        <input type="text" value='<%# DataBinder.Eval(Container.DataItem, "employeeID")%>' readonly="readonly"
                                                                            class="form-control" title='<%# DataBinder.Eval(Container.DataItem, "empname")%>' />
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <input type="text" value='<%# DataBinder.Eval(Container.DataItem, "employeeID")%>' readonly="readonly"
                                                                            class="form-control" title='<%# DataBinder.Eval(Container.DataItem, "empname")%>' />
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Project" HeaderStyle-Width="11%">
                                                                    <ItemTemplate>
                                                                        <%# DataBinder.Eval(Container.DataItem, "projectcode")%>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <asp:TextBox ID="dropproject" runat="server" CssClass="form-control">
                                                                        </asp:TextBox>
                                                                        <input type="hidden" id="hidproject" runat="server" />
                                                                        <input type="hidden" id="hidbillable" runat="server" />
                                                                        <input type="hidden" id="hiememorequire" runat="server" />
                                                                          <input type="hidden" id="hidistaskreadonly" runat="server" />

                                                                          
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Expense" HeaderStyle-Width="11%">
                                                                    <ItemTemplate>
                                                                        <%# DataBinder.Eval(Container.DataItem, "taskcodenamesmall")%>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <asp:TextBox ID="droptask" runat="server" CssClass="form-control">
                                                                        </asp:TextBox>
                                                                        <input type="hidden" id="hidtask" runat="server" />
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Description">
                                                                    <ItemTemplate>
                                                                        <%# DataBinder.Eval(Container.DataItem, "description")%>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <asp:TextBox ID="txtdesc"  runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "description")%>'
                                                                            CssClass="form-control"></asp:TextBox>
                                                                        <asp:HiddenField  ID="hdndesceditable" Value='<%# DataBinder.Eval(Container.DataItem, "TDesReadonly")%>' runat="server" />
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Units" HeaderStyle-Width="5%">
                                                                    <ItemTemplate>
                                                                        <%# DataBinder.Eval(Container.DataItem, "Units")%>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <asp:TextBox ID="txtunits" onkeypress="blockNonNumbers(this, event, true, false);"
                                                                            onblur="extractNumber(this,2,false);calcamount(this.id);" onkeyup="extractNumber(this,2,false);" runat="server"
                                                                            Text='<%# DataBinder.Eval(Container.DataItem, "units")%>' CssClass="form-control"></asp:TextBox>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Cost" HeaderStyle-Width="5%">
                                                                    <ItemTemplate>
                                                                        <%# DataBinder.Eval(Container.DataItem, "cost")%>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <asp:TextBox ID="txtcost" onkeypress="blockNonNumbers(this, event, true, false);"
                                                                            onblur="extractNumber(this,2,false);calcamount(this.id);" onkeyup="extractNumber(this,2,false);" runat="server"
                                                                            Text='<%# DataBinder.Eval(Container.DataItem, "cost")%>' CssClass="form-control"></asp:TextBox>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="MU%" HeaderStyle-Width="5%">
                                                                    <ItemTemplate>
                                                                        <%# DataBinder.Eval(Container.DataItem, "mu")%>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <asp:TextBox ID="txtmu" onkeypress="blockNonNumbers(this, event, true, true);"
                                                                            onkeyup="extractNumber(this,2,true);" runat="server" onblur="extractNumber(this,2,true);calcamount(this.id);" Text='<%# DataBinder.Eval(Container.DataItem, "mu")%>'
                                                                            CssClass="form-control" ToolTip="Markup %" placeholder="%"></asp:TextBox>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Amount" HeaderStyle-Width="6%">
                                                                    <ItemTemplate>
                                                                        <%# DataBinder.Eval(Container.DataItem, "amount")%>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <asp:TextBox ID="txtamount" onkeypress="blockNonNumbers(this, event, true, false);"
                                                                            onkeyup="extractNumber(this,2,false);" runat="server" Enabled="false"
                                                                            Text='<%# DataBinder.Eval(Container.DataItem, "amount")%>' CssClass="form-control"></asp:TextBox>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="B" HeaderStyle-Width="2%">
                                                                    <ItemTemplate>
                                                                        <asp:CheckBox ID="chkbillableedit" runat="server" Enabled="false" ToolTip="Billable" />
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <asp:CheckBox ID="chkbillableedit" runat="server" ToolTip="Billable" />
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="R" HeaderStyle-Width="2%">
                                                                    <ItemTemplate>
                                                                        <asp:CheckBox ID="chkreimbursable" runat="server" Enabled="false" ToolTip="Reimbursable" Checked='<%# DataBinder.Eval(Container.DataItem, "reimbursable")%>' />
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <asp:CheckBox ID="chkreimbursableedit" runat="server" ToolTip="Reimbursable" Checked='<%# DataBinder.Eval(Container.DataItem, "reimbursable")%>' />
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="" HeaderStyle-Width="4%">
                                                                    <ItemTemplate>
                                                                        <a id="lnkmemo" runat="server" onclick="opendiv(this.id,'0');">Memo</a>

                                                                        <input value='<%#Eval("memo") %>' type="hidden" id="hidmemo" runat="server" />
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <a id="lnkmemoedit" runat="server" onclick="opendiv(this.id,'1');">Memo</a>
                                                                        <input value='<%#Eval("memo") %>' type="hidden" id="hidmemoedit" runat="server" />
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>

                                                                <asp:TemplateField HeaderText="" HeaderStyle-Width="9%">
                                                                    <ItemTemplate>
                                                                        <a style="color: #428bca;" id="lnkfile" runat="server" onclick="openattach(this.id,'0');"><%#Eval("attachname") %></a>
                                                                        <input value='<%#Eval("originalfile") %>' type="hidden" id="hidoriginalfile" runat="server" />
                                                                        <input value='<%#Eval("savedfile") %>' type="hidden" id="hidsavedfile" runat="server" />
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <a id="lnkfile" runat="server" onclick="openattach(this.id,'1');"><%#Eval("attachname") %></a>
                                                                        <input value='<%#Eval("originalfile") %>' type="hidden" id="hidoriginalfile" runat="server" />
                                                                        <input value='<%#Eval("savedfile") %>' type="hidden" id="hidsavedfile" runat="server" />

                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>

                                                                <asp:TemplateField HeaderText="S" HeaderStyle-Width="2%">
                                                                    <ItemTemplate>
                                                                        <img style="cursor: default;" alt="" src='images/<%#DataBinder.Eval(Container.DataItem,"status")%>.png'
                                                                            title='<%#DataBinder.Eval(Container.DataItem,"status")%>' />
                                                                        <input type="hidden" id="hidnid1" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "nid")%>' />
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>

                                                                <asp:CommandField InsertVisible="False" ShowDeleteButton="false" HeaderStyle-Width="4%"
                                                                    ShowEditButton="true" ButtonType="Image" EditImageUrl="images/edit.png" UpdateImageUrl="images/approved.png"
                                                                    CancelImageUrl="images/rejected.png" EditText="Edit Details" UpdateText="Save Changes" CancelText="Cancel Editing" />
                                                            </Columns>

                                                            <HeaderStyle CssClass="gridheader" />
                                                            <EmptyDataRowStyle CssClass="nodatafound" />
                                                        </asp:GridView>
                                                         <input type="hidden" id="timesheet_hidtotalhrs" runat="server" clientidmode="Static" />
                                                    </div>




                                                </ContentTemplate>

                                            </asp:UpdatePanel>
                                            <div style="width: 500px; position: fixed;" id="divattach" class="itempopup">
                                                <div class="popup_heading">
                                                    <span id="Span1" runat="server">Attachment</span>
                                                    <div class="f_right">
                                                        <img src="images/cross.png" onclick="closediv();" alt="X"
                                                            title="Close Window" />
                                                    </div>
                                                </div>
                                                <div style="padding: 10px;">

                                                    <div id="divuploadfile">
                                                        <iframe src="uploadfile.aspx" width="100%" height="50"
                                                            style="margin: 0px; padding: 0px; border: none;"></iframe>
                                                        <input type="hidden" id="timesheet_hidorgfile" runat="server" clientidmode="Static" />
                                                        <input type="hidden" id="timesheet_hidsavedfile" runat="server" clientidmode="Static" />

                                                    </div>

                                                    <div id="divfilelist" class="divfilelist">
                                                    </div>


                                                </div>
                                            </div>
                                            <div id="divtableaddnew" runat="server">
                                                <div>
                                                    <table width="100%" cellpadding="4" cellspacing="0" id="tbldata" class="tblsheet">

                                                        <tr>
                                                            <td width="2%"></td>
                                                            <td width="3%" valign="middle" oncontextmenu="setcopyoption(0,event);">
                                                               <%-- <div class="rightclickcopy" id="divcopy0">
                                                                    <a onclick="copyrecord();">Copy</a>
                                                                </div>
                                                                <div id="divdel0">
                                                                </div>--%>


                                                               
                                                                    <div class="rightclickcopy" id="divcopy0" style="display: none;">
                                                                        <a onclick="copyrecord();">Copy</a></div>
                                                                    <div id="divdel0">
                                                                        <a style="cursor: pointer;color:bule;" id="delete" onclick="deleterow(this,this.id);">
                                                                            <i class="fa fa-fw" style="font-size: 18px; color: #d9534f; display: block; margin: auto;">
                                                                                <img src="images/delete.png" alt=""></i>

                                                                        </a>

                                                                    </div>

                                                           


                                                            </td>

                                                            <td width="18%">
                                                                <input type="text" id="txtdate0" class="form-control" onkeypress="settab(this.id,event);" onchange="checkdate(this.value,this.id);" />
                                                            </td>
                                                            <td width="11%">
                                                                <input type="text" id="ddlproject0" class="form-control" onkeypress="settab(this.id,event);" />
                                                                <input type="hidden" id="hidproject0" class="form-control" />

                                                                <input type="hidden" id="hidbillable0" />
                                                                <input type="hidden" id="hiememorequire0" />
                                                                  <input type="hidden" id="hidistaskreadonly0" />

                                                            </td>
                                                            <td width="11%">
                                                                <input type="text" id="ddltask0" class="form-control" onkeypress="settab(this.id,event);" />
                                                                <input type="hidden" id="hidtask0" />
                                                            </td>

                                                            <td>
                                                                <input type="text" id="txtdesc0" maxlength="150" class="form-control"  onblur="removeSpecialCh(this.id,event)" />
                                                            </td>
                                                            <td width="5%">
                                                                <input type="text" id="txtunits0" class="form-control" onkeypress="blockNonNumbers(this, event, true, false);settab(this.id,event);"
                                                                    onblur="extractNumber(this,2,false);calcamount(this.id);" onkeyup="extractNumber(this,2,false);" />
                                                            </td>
                                                            <td width="5%">
                                                                <input type="text" id="txtcost0" class="form-control" onkeypress="blockNonNumbers(this, event, true, false);settab(this.id,event);"
                                                                    onblur="extractNumber(this,2,false);calcamount(this.id);" onkeyup="extractNumber(this,2,false);" />
                                                            </td>
                                                            <td width="5%">
                                                                <input type="text" id="txtmu0" class="form-control"  ' onkeydown='addautorow(0,event);' onkeypress="blockNonNumbers(this, event, true, false);settab(this.id,event); addautorow(0,event);"
                                                                    onblur="extractNumber(this,2,true);calcamount(this.id);"
                                                                    onkeyup="checkless(this);extractNumber(this,2,true);extractNumber(this,2,true);calcamount(this.id);" />
                                                            </td>
                                                            <td width="6%">
                                                                <input type="text" id="txtamount0" class="form-control" onkeypress="blockNonNumbers(this, event, true, false);"
                                                                    onblur="extractNumber(this,2,false);" value="0" disabled="disabled" onkeyup="extractNumber(this,2,false);" />
                                                            </td>
                                                            <td width="2%">
                                                                <input type="checkbox" id="chkbillable0" onkeypress="settab(this.id,event);" />
                                                            </td>
                                                            <td width="2%">
                                                                <input type="checkbox" id="chkreimbursable0" onkeypress="settab(this.id,event);" />
                                                            </td>
                                                            <td width="4%">
                                                                <a id="lnkmemo0" onclick="opendiv(this.id,1);" title="Add Memo">Memo</a>
                                                                <input type="hidden" id="hidmemo0" />
                                                            </td>
                                                            <td width="9%">
                                                                <a id="lnkfile0" onclick="openattach(this.id,'1');" style="color: #428bca;">Attachment</a>
                                                                <input type="hidden" id="hidoriginalfile0" />
                                                                <input type="hidden" id="hidsavedfile0" />

                                                            </td>
                                                            <td width="2%"></td>
                                                            <td width="4%"></td>
                                                        </tr>
                                                    </table>
                                                      <table width="100%" cellpadding="4" cellspacing="0" class="tblsheet">

                                                        <tr class="gridheader">

                                                            <th width="72%" align="right" style="padding-right: 10px;">
                                                                <b>Total Amount</b>
                                                            </th>
                                                            <th id="tdtotalhrs" style="font-weight: bold;"></th>

                                                        </tr>
                                                    </table>


                                                </div>
                                                <div class="clear"></div>
                                                <div class="fulldiv">
                                                    <div style="float: right; text-align: right; padding-bottom: 5px; padding-top: 5px;">
                                                        +&nbsp;<a onclick="return addrow();" id="addmore" style="text-decoration: underline;">Add
                                                            New</a>
                                                    </div>
                                                </div>
                                                <div style="margin-bottom: 20px; margin-top: 15px; float: left;">
                                                    <input type="button" value="Submit" class="btn btn-primary" onclick="savedata();" />


                                                </div>
                                            </div>
                                        </div>
                                        <input type="hidden" id="timesheet_hidrowno" clientidmode="Static" runat="server" />
                                        <input type="hidden" id="timesheet_hidsno" clientidmode="Static" runat="server" />
                                        <input type="hidden" id="timesheet_hidempid" clientidmode="Static" runat="server" />
                                        <input type="hidden" id="hidempname" runat="server" />
                                        <input type="hidden" id="hidproject" runat="server" />
                                        <input type="hidden" id="hidfromdate" runat="server" />
                                        <input type="hidden" id="hidtodate" runat="server" />

                                        <input type="hidden" id="hidcompanyid" runat="server" />
                                        <input type="hidden" id="hiduserid" runat="server" />
                                        <input type="hidden" id="hidtask_project" runat="server" />
                                        <input type="hidden" id="hidtask_date" runat="server" />
                                        <input type="hidden" id="hidtask_task" runat="server" />
                                        <input type="hidden" id="hidtask_cost" runat="server" />
                                        <input type="hidden" id="hidtask_mu" runat="server" />
                                        <input type="hidden" id="hidtask_amount" runat="server" />
                                        <input type="hidden" id="hidtask_description" runat="server" />
                                        <input type="hidden" id="hidtask_billable" runat="server" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="clear">
                        </div>
                    </div>
                    <!-- panel -->
                </div>
            </div>
        </div>
    </div>
    <div style="width: 640px;" id="divmemo" class="itempopup">
        <div class="popup_heading">
            <span id="Span2" runat="server">Log Memo</span>
            <div class="f_right">
                <img src="images/cross.png" onclick="closediv();" alt="X"
                    title="Close Window" />
            </div>
        </div>
        <div style="padding: 10px;">
            <div id="divtxtmemo">
                <cc2:Editor ID="txtmemo" runat="server" CssClass="form-control" Height="300" Style="width: 98%;" />
            </div>
            <div id="ltrmemo" runat="server" style="display: none; max-height: 350px; overflow-y: auto;">
            </div>

            <div class=" clear pad2">
                <input type="hidden" id="hidselectedmemoid" />

                <input type="button" id="btnsavememo" class="btn btn-primary" onclick="addmemo();" value="Add Memo" />
                <input type="button" id="btncancelalert" class="btn
            btn-primary"
                    value="Cancel" onclick="closediv();" />
            </div>
        </div>
    </div>


    <iframe id="ifdownloadfile" style="display: none;"></iframe>




    <script type="text/javascript" src="js/jquery-ui.js"></script>
    <script type="text/javascript" src="js/expenses2.6.js"></script>
    <script type="text/javascript">
        $(document).ready(function(){
        calhours();
        });
        var uploadlinkid = "";
        function uploadStarted() {
            // $get("imgDisplay").style.display = "none";
        }
        function uploadComplete() {



            if (document.getElementById("timesheet_hidorgfile").value != "" && document.getElementById(uploadlinkid) != null) {


                orgid = uploadlinkid.replace("lnkfile", "hidoriginalfile");
                savedid = uploadlinkid.replace("lnkfile", "hidsavedfile");

                document.getElementById(orgid).value = document.getElementById(orgid).value + document.getElementById("timesheet_hidorgfile").value + '#';

                document.getElementById(savedid).value = document.getElementById(savedid).value + document.getElementById("timesheet_hidsavedfile").value + '#';
                fillfiles(orgid, savedid, "1");

            }

        }


        function openattach(id, mode) {
            uploadlinkid = id;





            var mode1 = "";
            var orgid = "", savedid = "";

            mode1 = String(mode)

            if (mode1 == "0") {
                document.getElementById("divuploadfile").style.display = "none";
            }
            else {
                document.getElementById("divuploadfile").style.display = "inline";
            }

            orgid = id.replace("lnkfile", "hidoriginalfile");
            savedid = id.replace("lnkfile", "hidsavedfile");
            fillfiles(orgid, savedid, mode);



            var container = $('#otherdiv');
            var content = $('#divattach');
            //content.css("left", (container.width() - content.width()) / 2);
            content.css("left", "calc(50% - 250px)");
            //content.css("top", (container.height() - content.height()) / 2);
            content.css("top", "98px");

            // setposition("divattach");
            document.getElementById("divattach").style.display = "block";
            document.getElementById("otherdiv").style.display = "block";

        }
        function deleteattachment(id) {
            var orgid = uploadlinkid.replace("lnkfile", "hidoriginalfile");
            var savedid = uploadlinkid.replace("lnkfile", "hidsavedfile");
            var arrorg = document.getElementById(orgid).value.split("#");
            var arrsaved = document.getElementById(savedid).value.split("#");
            var orgfile = "";
            for (var i = 0; i < arrsaved.length - 1; i++) {
                if (arrsaved[i] == id) {
                    orgfile = arrorg[i];
                    break;
                }
            }
            document.getElementById(orgid).value = document.getElementById(orgid).value.replace(orgfile + '#', "");
            document.getElementById(savedid).value = document.getElementById(savedid).value.replace(id + '#', "");
            fillfiles(orgid, savedid, "1");
        }
        function downloadfile(id) {
            var orgid = uploadlinkid.replace("lnkfile", "hidoriginalfile");
            var savedid = uploadlinkid.replace("lnkfile", "hidsavedfile");
            var arrorg = document.getElementById(orgid).value.split("#");
            var arrsaved = document.getElementById(savedid).value.split("#");
            var orgfile = "";
            id = id.replace("a_", "");

            for (var i = 0; i < arrsaved.length - 1; i++) {
                if (arrsaved[i] == id) {
                    orgfile = arrorg[i];
                    break;
                }
            }
            document.getElementById("ifdownloadfile").src = "downloadfile.aspx?file1=" + id + "&file2=" + orgfile;

        }
        function fillfiles(orgid, savedid, mode) {
            var strhtml = "", deletestr = "";
            var mode1 = String(mode)
            if (document.getElementById(orgid).value != "") {
                strhtml = "<h2 class='filehead'>List of attached files</h2><ul>";
                var arrorg = document.getElementById(orgid).value.split("#");
                var arrsaved = document.getElementById(savedid).value.split("#");

                for (var i = 0; i < arrorg.length - 1; i++) {
                    if (mode1 == "1") {
                        deletestr = "<span><img id='" + arrsaved[i] + "' src='images/delete.png' onclick='deleteattachment(this.id);' /></span>";
                    }
                    else {
                        deletestr = "";
                    }
                    strhtml += "<li><a  id='a_" + arrsaved[i] + "' onclick='downloadfile(this.id);'>" + arrorg[i] + "</a>" + deletestr + "</li>";

                }
                strhtml += "</ul>";
                document.getElementById(uploadlinkid).innerHTML = "Attachment (" + (arrorg.length - 1) + ")";
            }
            else {
                document.getElementById(uploadlinkid).innerHTML = "Attachment";
            }

            document.getElementById("divfilelist").innerHTML = strhtml;

        }

        function calcamount(id) {
            var rownum = "", unitid = "", costid = "", muid = "", amtid = "";;


            if (id.indexOf('txtunits') > -1) {

                unitid = id;
                costid = id.replace("txtunits", "txtcost");
                muid = id.replace("txtunits", "txtmu");
                amtid = id.replace("txtunits", "txtamount");
            }
            else if (id.indexOf('txtcost') > -1) {
                costid = id;
                unitid = id.replace("txtcost", "txtunits");
                muid = id.replace("txtcost", "txtmu");
                amtid = id.replace("txtcost", "txtamount");
            }
            else {
                costid = id.replace("txtmu", "txtcost");
                unitid = id.replace("txtmu", "txtunits");
                amtid = id.replace("txtmu", "txtamount");
                muid = id;
            }
            rownum = rownum.replace("", "");
            if (document.getElementById(unitid).value == "") {
                document.getElementById(unitid).value = "1";
            }
            if (document.getElementById(costid).value == "") {
                document.getElementById(costid).value = "0";
            }
            if (document.getElementById(muid).value == "") {
                document.getElementById(muid).value = "0";
            }
            var units = parseFloat(document.getElementById(unitid).value);
            var cost = parseFloat(document.getElementById(costid).value);
            var mu = parseFloat(document.getElementById(muid).value);



            if (isNaN(units)) {
                units = 0;
            }
            if (isNaN(cost)) {
                cost = 0;

            }
            var totalamount = 0
            totalamount = parseFloat(units) * parseFloat(cost);
            if (parseFloat(mu) > 0) {
                var muamount = (totalamount * mu) / 100;
                totalamount = totalamount + muamount;
            }
            else {
                mu = parseFloat(document.getElementById(muid).value.replace("-", ""));
                var muamount = (totalamount * mu) / 100;
                totalamount = totalamount - muamount;
            }
            totalamount = Math.round(totalamount * 100) / 100;
            document.getElementById(amtid).value = totalamount;


            calhours();

        }

        function validategrid(id) {
            var newid = "", newid1 = "";


            var status = 1;
            newid = id.replace("hidproject", "dropproject");

            newid1 = id;
            if (document.getElementById(newid1).value == "") {
                status = 0;
                document.getElementById(newid).className = "errform-control";
            }
            else {
                document.getElementById(newid).className = "form-control";
            }
            newid = id.replace("hidproject", "txtdate");


            if (document.getElementById(newid).value == "") {
                status = 0;
                document.getElementById(newid).className = "errform-control hasDatepicker";
            }
            else {
                if (isDate1(document.getElementById(newid).value)) {
                    document.getElementById(newid).className = "form-control hasDatepicker";
                }
                else {
                    status = 0;
                    document.getElementById(newid).className = "errform-control hasDatepicker";
                }
            }
            newid = id.replace("hidproject", "droptask");
            newid1 = id.replace("hidproject", "hidtask");


            //  alert(newid);
            if (document.getElementById(newid1).value == "") {
                status = 0;
                document.getElementById(newid).className = "errform-control";
            }
            else {
                document.getElementById(newid).className = "form-control";
            }


            newid = id.replace("hidproject", "txtunits");
            if (document.getElementById(newid).value == "" || document.getElementById(newid).value == "0") {
                status = 0;
                document.getElementById(newid).className = "errform-control";
            }
            else {
                if (isNaN(document.getElementById(newid).value)) {
                    status = 0;
                    document.getElementById(newid).className = "errform-control";
                }
                else {
                    document.getElementById(newid).className = "form-control";
                }
            }
            newid = id.replace("hidproject", "txtcost");


            if (document.getElementById(newid).value == "" || document.getElementById(newid).value == "0") {
                status = 0;
                document.getElementById(newid).className = "errform-control";
            }
            else {
                if (isNaN(document.getElementById(newid).value)) {
                    status = 0;
                    document.getElementById(newid).className = "errform-control";
                }
                else {
                    document.getElementById(newid).className = "form-control";
                }
            }
            newid = id.replace("hidproject", "txtamount");


            if (document.getElementById(newid).value == "" || document.getElementById(newid).value == "0") {
                status = 0;
                document.getElementById(newid).className = "errform-control";
            }
            else {
                if (isNaN(document.getElementById(newid).value)) {
                    status = 0;
                    document.getElementById(newid).className = "errform-control";
                }
                else {
                    document.getElementById(newid).className = "form-control";
                }
            }
            newid = id.replace("hidproject", "hidmemoedit");

            var memotext = document.getElementById(newid).value;


            var newid1 = id.replace("hidproject", "hiememorequire");

            if (document.getElementById(newid1).value == "Yes") {
                if (String(memotext).trim() == "") {
                    newid = id.replace("hidproject", "lnkmemoedit");
                    status = 0;
                    document.getElementById(newid).style.border = "1px solid red";
                }
                else {
                    newid = id.replace("hidproject", "lnkmemoedit");
                    document.getElementById(newid).style.border = "none";
                }
            }
            else {

                newid = id.replace("hidproject", "lnkmemoedit");
                document.getElementById(newid).style.border = "none";
            }



            if (status == 0) {
                return false;
            }
            else {


                return true;



            }
        }

        $(document).keypress(
  function (event) {
      if (event.which == '13') {
          event.preventDefault();
      }
  });
    </script>
</asp:Content>
