<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" EnableEventValidation="false" ValidateRequest="false"
    CodeBehind="Timesheet.aspx.cs" Inherits="empTimeSheet.Timesheet" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit.HTMLEditor"
    TagPrefix="cc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
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

        .tblsheet td {
            vertical-align: middle;
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
                <i
                    class="fa fa-fw" style="border: none; font-size: 24px; border-radius: initial; padding: 0px;"></i>Employee Time Entry
            </h2>
            <div class="breadcrumb-wrapper mar ">
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
                <asp:LinkButton ID="btnreview" runat="server" CssClass="right_link" OnClick="setreviewstatus"
                    OnClientClick='return checkreview(); return checkrowselected();  return confirm("Are you sure?");'>
                    <i class="fa fa-fw  fa-check-circle topicon"></i>Review</asp:LinkButton>
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
                                <%--<div class="col-xs-12 col-sm-8 col-md-6 f_left" style="padding: 0px;">
                                    <h5 class="subtitle mb5">sheet View</h5>
                                </div>--%>
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
                                    <div class="row mar">
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
                                                                <asp:TemplateField HeaderStyle-Width="3%" ItemStyle-VerticalAlign="Middle">
                                                                    <ItemTemplate>
                                                                        <asp:LinkButton ID="lbtndelete" CommandName="del" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>'
                                                                            ToolTip="Delete" runat="server" OnClientClick='return confirm("Delete this record? Yes or No");'><i class="fa fa-fw" >
                                                            
                                                            <img src="images/delete.png" alt=""></i></asp:LinkButton>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Approve" HeaderStyle-Width="3%" ItemStyle-HorizontalAlign="Center"
                                                                    ItemStyle-CssClass="billabletd" HeaderStyle-HorizontalAlign="Center">
                                                                    <HeaderTemplate>
                                                                        <input id="chkSelect" runat="server" name="Select All" onclick="SelectAll(this)"
                                                                            type="checkbox" />
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <asp:CheckBox ID="chkapprove" CssClass="chksel" runat="server" />
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Date" HeaderStyle-Width="13%">
                                                                    <ItemTemplate>
                                                                        <input type="text" value='<%# DataBinder.Eval(Container.DataItem, "date")%>' readonly="readonly"
                                                                            class="form-control" />
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <asp:TextBox ID="txtdate" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "date")%>'
                                                                            CssClass="form-control date" onchange="checkdate(this.value,this.id);"></asp:TextBox>
                                                                        <cc1:CalendarExtender ID="txtDatecce" runat="server" TargetControlID="txtdate" PopupButtonID="txtdate"
                                                                            Format="MM/dd/yyyy">
                                                                        </cc1:CalendarExtender>
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

                                                                <asp:TemplateField HeaderText="Project" HeaderStyle-Width="12%">
                                                                    <ItemTemplate>
                                                                        <input type="text" readonly="readonly" value='<%# DataBinder.Eval(Container.DataItem, "projectcode")%>'
                                                                            class="form-control" />
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
                                                                <asp:TemplateField HeaderText="Task" HeaderStyle-Width="12%">
                                                                    <ItemTemplate>
                                                                        <input type="text" readonly="readonly" value='<%# DataBinder.Eval(Container.DataItem, "taskcodenamesmall")%>'
                                                                            class="form-control" />
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <asp:TextBox ID="droptask" runat="server" CssClass="form-control">
                                                                        </asp:TextBox>
                                                                        <input type="hidden" id="hidtask" runat="server" />
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Hours" HeaderStyle-Width="6%">
                                                                    <ItemTemplate>
                                                                        <input type="text" readonly="readonly" value='<%# DataBinder.Eval(Container.DataItem, "Hours")%>'
                                                                            class="form-control" />
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <asp:TextBox ID="txthours" onkeypress="blockNonNumbers(this, event, true, false);"
                                                                            MaxLength="5" onkeyup="extractNumber(this,2,false);" runat="server"
                                                                            CssClass="form-control"></asp:TextBox>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Description">
                                                                    <ItemTemplate>
                                                                        <asp:TextBox ID="txtdesc" runat="server" MaxLength="150" ReadOnly="true"
                                                                            Text='<%# DataBinder.Eval(Container.DataItem, "description")%>'
                                                                            CssClass="form-control" ToolTip='<%# DataBinder.Eval(Container.DataItem, "description")%>'></asp:TextBox>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <asp:TextBox ID="txtdesc" runat="server" MaxLength="150"
                                                                            CssClass="form-control"></asp:TextBox>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="B" HeaderStyle-Width="2%">
                                                                    <ItemTemplate>
                                                                        <asp:CheckBox ID="chkbillableedit" runat="server" />
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <asp:CheckBox ID="chkbillableedit" runat="server" />
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Bill Rate" HeaderStyle-Width="6%">
                                                                    <ItemTemplate>
                                                                        <input type="text" readonly="readonly" value='<%# DataBinder.Eval(Container.DataItem, "Tbillrate")%>'
                                                                            class="form-control" />
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <asp:TextBox ID="txtbillrate" onkeypress="blockNonNumbers(this, event, true, false);"
                                                                            MaxLength="5" onkeyup="extractNumber(this,2,false);" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "Tbillrate")%>'
                                                                            CssClass="form-control"></asp:TextBox>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Pay Rate" HeaderStyle-Width="6%">
                                                                    <ItemTemplate>
                                                                        <input type="text" readonly="readonly" value='<%# DataBinder.Eval(Container.DataItem, "Tcostrate")%>'
                                                                            class="form-control" />
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <asp:TextBox ID="txtpayrate" onkeypress="blockNonNumbers(this, event, true, false);"
                                                                            MaxLength="5" onkeyup="extractNumber(this,2,false);" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "Tcostrate")%>'
                                                                            CssClass="form-control"></asp:TextBox>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="" HeaderStyle-Width="5%">
                                                                    <ItemTemplate>
                                                                        <a id="lnkmemo" runat="server" onclick="opendiv(this.id,0);" title="View Memo">Memo</a>
                                                                        <input id="hidmemo" runat="server" type="hidden" value='<%#Eval("memo") %>' />
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <a id="lnkmemoedit" runat="server" onclick="opendiv(this.id,1);" title="Edit Memo">Memo</a>
                                                                        <input id="hidmemoedit" runat="server" type="hidden" value='<%#Eval("memo") %>' />
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="S" HeaderStyle-Width="3%">
                                                                    <ItemTemplate>
                                                                        <div runat="server" id="divtaskstatus">
                                                                        </div>
                                                                        <%-- <img style="cursor: default;" alt="" src='images/<%#DataBinder.Eval(Container.DataItem,"taskstatus")%>.png'
                                                    title='<%#DataBinder.Eval(Container.DataItem,"taskstatus")%>' />--%>
                                                                        <input type="hidden" id="hidnid1" runat="server"
                                                                            value='<%# DataBinder.Eval(Container.DataItem, "nid")%>' />
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:CommandField InsertVisible="False" ShowDeleteButton="false" HeaderStyle-Width="5%"
                                                                    ShowEditButton="true" ButtonType="Image" EditImageUrl="images/edit.png" UpdateImageUrl="images/approved.png"
                                                                    CancelImageUrl="images/rejected.png" EditText="Edit Details" UpdateText="Save Changes" CancelText="Cancel Editing" />

                                                            </Columns>

                                                            <HeaderStyle CssClass="gridheader" />
                                                            <EmptyDataRowStyle CssClass="nodatafound" />
                                                        </asp:GridView>




                                                    </div>
                                                    <input type="hidden" id="timesheet_hidtotalhrs" runat="server" clientidmode="Static" />
                                                    <input type="hidden" id="timesheet_hidpayrate" runat="server" clientidmode="Static" />
                                                    <input type="hidden" id="timesheet_hidbillrate" runat="server" clientidmode="Static" />

                                                    <input type="hidden" id="timesheet_hidIsFavOpened" clientidmode="Static" />
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                            <div id="divtableaddnew" runat="server">
                                                <div>
                                                    <table width="100%" cellpadding="4" cellspacing="0" id="tbldata" class="tblsheet">
                                                        <%-- <tr class="gridheader" id="trheader" runat="server">
                                <th width="17px">
                                </th>
                                <th width="110px">
                                    Date
                                </th>
                                <th width="140px">
                                    Project ID
                                </th>
                                <th width="150px">
                                    Task
                                </th>
                                <th width="50px">
                                    Hours
                                </th>
                                <th width="200px">
                                    Description
                                </th>
                                <th width="17px">
                                    B
                                </th>
                                <th width="17px">
                                </th>
                                <th width="17px">
                                </th>
                            </tr>--%>
                                                        <tr>
                                                            <td width="3%" valign="middle" oncontextmenu="setcopyoption(0,event);">
                                                                <div class="rightclickcopy" id="divcopy0">
                                                                    <a onclick="copyrecord();">Copy</a>
                                                                </div>
                                                                <div id="divdel0">
                                                                </div>
                                                            </td>
                                                            <td width="3%"></td>
                                                            <td width="14%">
                                                                <input type="text" id="txtdate0" class="form-control txtdate" onkeypress="setdtab(0,event);" onchange="checkdate(this.value,this.id);fncomparedate(this.value,this.id);" />
                                                                <input type="hidden" runat="server" id="hdnflddate0" />
                                                            </td>
                                                            <td width="12%">
                                                                <input type="text" id="ddlproject0" class="form-control ddlprj" onkeypress="setptab(0,event);" />
                                                                <input type="hidden" id="hidproject0" class="form-control hdnprj" />
                                                                <input type="hidden" id="hidbillable0" />
                                                                <input type="hidden" id="hiememorequire0" class="memoreq" />
                                                                <input type="hidden" id="hidistaskreadonly0" />
                                                            </td>
                                                            <td width="12%">
                                                                <input type="text" id="ddltask0" class="form-control ddltsk" onkeypress="settab(0,event);" />
                                                                <input type="hidden" class="hdntask" id="hidtask0" />
                                                            </td>
                                                            <td width="6%">
                                                                <input type="text" id="txthours0" class="form-control txthr" maxlength="5" onkeypress="TS_blockNonNumbers(this, event, true, false,0);"
                                                                    onblur="extractNumber(this,2,false);calhours();" onkeyup="extractNumber(this,2,false);" />
                                                            </td>
                                                            <td>
                                                                <input type="text" id="txtdesc0" maxlength="150" class="form-control txtdsc" onblur="removeSpecialCh(this.id,event)" />
                                                            </td>
                                                            <td width="2%">
                                                                <input type="checkbox" class="chkbilbl" id="chkbillable0" />
                                                            </td>
                                                            <td width="6%" id="td_billrate">
                                                                <input type="text" id="txtbillrate0" class="form-control txtbilrte" maxlength="5" onblur="extractNumber(this,2,false);" onkeyup="extractNumber(this,2,false);" />
                                                            </td>
                                                            <td width="6%" id="td_payrate">
                                                                <input type="text" id="txtpayrate0" class="form-control txtprte" maxlength="5" onblur="extractNumber(this,2,false);" onkeypress='addautorow(0,event);' onkeydown='addautorow(0,event);' onkeyup="extractNumber(this,2,false);" />
                                                            </td>

                                                            <td width="5%">
                                                                <a id="lnkmemo0" class="lkmemo" onclick="opendiv(this.id,1);" title="Add Memo">Memo</a>
                                                                <span id="hidmemo0" class="hdmemo" style="display: none;" />
                                                            </td>
                                                            <td width="3%"></td>
                                                            <td width="5%"></td>
                                                        </tr>
                                                    </table>


                                                    <table width="100%" cellpadding="4" cellspacing="0" class="tblsheet">

                                                        <tr class="gridheader">

                                                            <th width="43%" align="right" style="padding-right: 10px;">
                                                                <b>Total Hours</b>
                                                            </th>
                                                            <th id="tdtotalhrs" style="font-weight: bold;"></th>

                                                        </tr>
                                                    </table>
                                                </div>
                                                <div class="clear"></div>
                                                <div>

                                                    <div class="ctrlGroup searchgroup">
                                                        <input type="button" value="Submit" class="btn btn-primary" onclick="opensubmit();" />


                                                    </div>
                                                    <div class="ctrlGroup searchgroup" style="float: right;">
                                                        <a onclick="return addrow();" id="addmore" style="text-decoration: underline;"><i class="fa fa-plus">&nbsp;</i>Add
                                                            New</a>
                                                        &nbsp;&nbsp;    
                                                      
                                                        <a onclick="openfav();" id="addfav" style="text-decoration: underline;"><i class="fa fa-star">&nbsp;</i>Favorite Tasks</a>
                                                    </div>

                                                </div>

                                            </div>
                                        </div>
                                        <input type="hidden" id="timesheet_hidrowno" clientidmode="Static" runat="server" />
                                        <input type="hidden" id="timesheet_hidsno" clientidmode="Static" runat="server" />
                                        <input type="hidden" id="timesheet_hidempid" clientidmode="Static" runat="server" />
                                        <input type="hidden" id="timesheet_hidisapprove" clientidmode="Static" runat="server" />
                                        <input type="hidden" id="timesheet_joindate" clientidmode="Static" runat="server" />
                                        <input type="hidden" id="hidempname" runat="server" />
                                        <input type="hidden" id="hidproject" runat="server" />
                                        <input type="hidden" id="hidfromdate" runat="server" />
                                        <input type="hidden" id="hidtodate" runat="server" />
                                        <input type="hidden" id="hidcompanyid" runat="server" />
                                        <input type="hidden" id="hiduserid" runat="server" />
                                        <input type="hidden" id="hidtask_project" runat="server" />
                                        <input type="hidden" id="hidtask_date" runat="server" />
                                        <input type="hidden" id="hidtask_task" runat="server" />
                                        <input type="hidden" id="hidtask_hours" runat="server" />
                                        <input type="hidden" id="hidtask_description" runat="server" />
                                        <input type="hidden" id="hidtask_billable" runat="server" />
                                        <input type="hidden" id="hdnjoinDate_byEmp" clientidmode="Static" runat="server" />
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
    <div id="divsubmit" class="itempopup" style="width: 550px; position: fixed;">
        <div class="popup_heading">
            <span id="Span1">Submit Task</span>
            <div class="f_right">
                <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
            </div>
        </div>
        <div class="tabContents">
            <div class="col-xs-12 clear mar">

                <div class="ctrlGroup">
                    <label class="lbl">
                        Submit To:
                   
                    </label>
                    <div class="txt w1 mar10">
                        <asp:RadioButtonList ID="rbtnsubmitto" runat="server" CssClass="checkboxauto" onchange="showspecific();">

                            <asp:ListItem Value="Client Manager" Selected="True">Client Manager</asp:ListItem>
                            <asp:ListItem Value="Project Manager">Project Manager</asp:ListItem>
                            <asp:ListItem Value="Your Manager">Your Manager</asp:ListItem>
                            <asp:ListItem Value="Specific">Specific</asp:ListItem>
                        </asp:RadioButtonList>
                    </div>
                    <div class="txt w1" id="divspecific" style="display: none; padding-top: 118px;">

                        <asp:DropDownList ID="dropspecific" runat="server" CssClass="form-control"></asp:DropDownList>

                    </div>
                </div>

                <div class="clear">
                </div>

                <div class="clear padtop10">
                </div>

                <div class="ctrlGroup" id="divsubmimanager">
                    <label class="lbl">
                        &nbsp;
                   
                    </label>
                    <div class="txt w2">
                        <input type="button" class="btn btn-primary mar3" value="Submit" onclick="savedata();" />
                        <input type="button" class="btn btn-primary mar3" value="Cancel" onclick="closediv();" />
                    </div>
                </div>
                <div class="ctrlGroup" id="divplswait" style="display: none;">
                    <label class="lbl">
                        &nbsp;
                   
                    </label>
                    <div class="txt w2">
                        <img src="images/pleasewait.gif" style="margin-right: 2px;" />Please wait...
                   
                    </div>
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
            <input type="hidden" id="hidselectedmemoid" />
            <div class="pad2">


                <%--<input type="button" id="btnsavememo" class="btn btn-primary" onclick="addmemo();" value="Add Memo" />--%>
                <input type="button" id="btncancelalert" class="btn
            btn-primary"
                    value="Close" onclick="closediv();" />

            </div>
        </div>
    </div>



    <div id="divFavTask" class="itempopup" style="width: 550px; position: absolute;">
        <div class="popup_heading">
            <span>Favorite Tasks</span>
            <div class="f_right">
                <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
            </div>
        </div>
        <div class="tabContents">
            <div class="col-xs-12 clear mar">

                <div class="col-xs-12 col-sm-12 form-group mar f_left pad">
                    <table id="tblFavMain" class="tblsheet" cellspacing="0" cellpadding="4" border="0" style="width: 100%; border-collapse: collapse;">
                    </table>
                </div>

                <div class="clear">
                </div>




            </div>
        </div>
    </div>
    <asp:HiddenField ID="adminuser" runat="server" Value="No" />
    <script type="text/javascript" src="js/jquery-ui.js"></script>
    <script type="text/javascript" src="js/sheetview2.12.js"></script>

    <script type="text/javascript">
        var openmemoid = "";
        var id = parseInt(document.getElementById("timesheet_hidrowno").value);
        $('#txtdate' + (id)).val($("#ctl00_ContentPlaceHolder1_hdnflddate0").val())
        function showspecific() {
            if (document.getElementById('ctl00_ContentPlaceHolder1_rbtnsubmitto_3').checked == true) {
                document.getElementById("divspecific").style.display = "block";
            }
            else {
                document.getElementById("divspecific").style.display = "none";
            }
        }
        function closediv() {
            if (openmemoid != "") {
                addmemo();
            }
            //openmemoid = "";
            document.getElementById("hidselectedmemoid").value = "";
            document.getElementById("divmemo").style.display = "none";
            document.getElementById("divsubmit").style.display = "none";
            document.getElementById("otherdiv").style.display = "none";
            document.getElementById("divFavTask").style.display = "none";
        }

        function opendiv(id, mode) {

            var mode1 = "";
            mode1 = String(mode)
            var txtmemo = $find("ctl00_ContentPlaceHolder1_txtmemo");
            if (mode1 == "0") {
                //  document.getElementById("btnsavememo").style.display = "none";
                document.getElementById("ctl00_ContentPlaceHolder1_ltrmemo").style.display = "block";
                document.getElementById("divtxtmemo").style.display = "none";

                openmemoid = "";
            }
            else {
                //  document.getElementById("btnsavememo").style.display = "inline";

                document.getElementById("ctl00_ContentPlaceHolder1_ltrmemo").style.display = "none";
                document.getElementById("divtxtmemo").style.display = "block";

                openmemoid = "1";

            }
            id = id.replace("lnkmemo", "hidmemo");
            setposition("divmemo");





            var exisitngmemo = "";
            if (id.indexOf("dgnews") > -1) {
                exisitngmemo = document.getElementById(id).value;
            }
            else {
                exisitngmemo = document.getElementById(id).innerHTML;
            }


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
        function addmemo() {
            var txtmemo = $find("ctl00_ContentPlaceHolder1_txtmemo");
            memo = txtmemo.get_content();

            var id = document.getElementById("hidselectedmemoid").value;
            if (id.indexOf("dgnews") > -1) {
                document.getElementById(id).value = memo;
            }
            else {

                document.getElementById(id).innerHTML = memo;
            }



        }
    </script>
    <style>
        .errform-control {
            border: 1px solid red !important;
        }
    </style>
    <script>
        function verifydj(el) {
            var cdt = $(el).val();
            var jdt = $("#timesheet_joindate").val();

            if (new Date(cdt.split("/")[0] + "/" + cdt.split("/")[1] + "/" + cdt.split("/")[2]) <
                new Date(jdt.split("/")[0] + "/" + jdt.split("/")[1] + "/" + jdt.split("/")[2])
            ) {
                alert("You cannot fill time sheet before joining date.");
                $(el).val('');
            }
        }

        $(document).ready(function () {
            /*$(".txtdate").change(function () {
                var cdt = $(this).val();
                var jdt = $("#timesheet_joindate").val();

                if (new Date(cdt.split("/")[0] + "/" + cdt.split("/")[1] + "/" + cdt.split("/")[2]) <
                    new Date(jdt.split("/")[0] + "/" + jdt.split("/")[1] + "/" + jdt.split("/")[2])
                    )
                {
                    alert('ready')
                    alert("You cannot fill time sheet before joining dates.");
                    $(".txtdate").val('');
                }

            })*/
        })
        function checkreview() {


            var rt = true
            $("#ctl00_ContentPlaceHolder1_dgnews tbody tr").each(function (index, item) {
                if ($(item).find(".chksel").find("input").prop("checked") == true) {
                    if ($(item).find(".review").length > 0) {
                        alert("This entry is already reviewed");
                        rt = false;
                    }
                }
            })
            return rt;

        }
    </script>
</asp:Content>
