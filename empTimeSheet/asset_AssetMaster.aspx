<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="asset_AssetMaster.aspx.cs" Inherits="empTimeSheet.asset_AssetMaster" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style type="text/css">
        .form-control1 {
            border-radius: 0px;
            box-shadow: none;
        }

        div.inline {
            float: left;
        }

        .rotate {
            transform: rotate(90.0deg);
        }

        .roundedcorners {
            -webkit-border-radius: 10px;
            -khtml-border-radius: 10px;
            -moz-border-radius: 10px;
            border-radius: 33px;
        }

        div.aligntRight {
            text-align: right;
        }

        div.aligntLeft {
            text-align: left;
        }

        div.ltr {
            margin-right: 0px;
        }

        div.rtl {
            margin-right: 0px;
            float: right;
        }
    </style>
    <link rel="stylesheet" href="css/jquery.dataTables.min.css" />

    <script src="js/jquery.min.js"></script>

    <script type="text/javascript" src="js/jquery.dataTables.min.js"></script>

    <script>
        function fixheader() {

            $('#ctl00_ContentPlaceHolder1_dgnews').dataTable({
                "dom": 'lrtip',
                "pageLength": 100,
                'aoColumnDefs': [{
                    'bSortable': false,
                    'aTargets': [-1, -2, -3] /* 1st one, start by the right */
                }]
            });



        }
    </script>
    <script type="text/javascript">

        function ShowHideDiv() {
            var ddlloc = document.getElementById("ctl00_ContentPlaceHolder1_dropLocation");
            var dvemp = document.getElementById("ctl00_ContentPlaceHolder1_divEmployee");
            var dvvndr = document.getElementById("ctl00_ContentPlaceHolder1_divVendor");
            if (ddlloc.value == "Individual") {
                dvemp.style.display = "block";
                dvvndr.style.display = "none";
            }
            else if (ddlloc.value == "Repair") {
                dvvndr.style.display = "block";
                dvemp.style.display = "none";
            }
            else {
                dvemp.style.display = "none";
                document.getElementById("ctl00_ContentPlaceHolder1_divEmployee").value = "";
                dvvndr.style.display = "none";
                document.getElementById("ctl00_ContentPlaceHolder1_divVendor").value = "";
            }

            //dvemp.style.display = ddlloc.value == "Individual" ? "block" : "none";
        }



        <%--unction uploadComplete() {
            document.getElementById('<%=lblMsg.ClientID %>').innerHTML = "File Uploaded Successfully";
        }

        function uploadError() {
            document.getElementById('<%=lblMsg.ClientID %>').innerHTML = "File upload Failed.";
        }--%>


        //function uploadStarted() {
        //    $get("imgDisplay").style.display = "none";
        //}

        function uploadComplete(sender, args) {
            var imgDisplay = document.getElementById("ctl00_ContentPlaceHolder1_DisplayImg");
            imgDisplay.src = "images/loading.gif";
            imgDisplay.style.cssText = "";
            var img = new Image();

            img.onload = function () {
                imgDisplay.style.cssText = "height:100px;width:100px";
                imgDisplay.src = img.src;
            };
            img.src = "<%=ResolveUrl(UploadFolderPath) %>" + args.get_fileName();

            //args.get_fileName();
        }
        function clickHistory(id) {
            document.getElementById("ctl00_ContentPlaceHolder1_hidid").value = id;
            $('#btnHistory').trigger('click');
        }
    </script>



    <link rel="Stylesheet" href="css/tab_2.0.css" type="text/css" />

    <link rel="stylesheet" href="css/jquery-ui.css" />
    <script type="text/javascript" src="js/jquery-ui.js"></script>
    <script>
        function openHistoryDiv() {
            document.getElementById("imageDiv").style.display = "block";
            document.getElementById("otherdiv").style.display = "block";
        }
        function opendiv() {
            setposition("assignedtask_divaddnew");
            document.getElementById("assignedtask_divaddnew").style.display = "block";
            document.getElementById("otherdiv").style.display = "block";
        }
        function closediv() {
            document.getElementById("imageDiv").style.display = "none";
            document.getElementById("assignedtask_divaddnew").style.display = "none";
            document.getElementById("otherdiv").style.display = "none";
        }

        function reset() {
            document.getElementById("ctl00_ContentPlaceHolder1_hidid").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtcode").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtname").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_dropcategory").value = ""
            document.getElementById("ctl00_ContentPlaceHolder1_txtdescription").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtbarcode").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtserialno").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtwaranty").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_dropworkingcondition").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_dropLocation").selectedIndex = 0
            document.getElementById("ctl00_ContentPlaceHolder1_dropLocation").disabled = false;
            document.getElementById("ctl00_ContentPlaceHolder1_DropDepartment").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_DropDepartment").disabled = false;
            document.getElementById("ctl00_ContentPlaceHolder1_txtDate").disabled = false;
            document.getElementById("ctl00_ContentPlaceHolder1_txtremark").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_dropvendor").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtmanufacture").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtinvoicenumber").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtprice").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_dropemployee").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_btnsubmit").value = "Save";
            document.getElementById("ctl00_ContentPlaceHolder1_DisplayImg").src = "/webfile/profile/nophoto.png";
            document.getElementById("ctl00_ContentPlaceHolder1_dropemployee").disabled = false;
            document.getElementById("ctl00_ContentPlaceHolder1_DropRepairvndr").disabled = false;
        }

        function validateemployee(sender, args) {
            if (document.getElementById("ctl00_ContentPlaceHolder1_dropLocation").value == "Individual" && document.getElementById("ctl00_ContentPlaceHolder1_dropemployee").value == "") {
                args.IsValid = false;
            }
            else {
                args.IsValid = true;

            }

        }
        function validatevendor(sender, args) {
            if (document.getElementById("ctl00_ContentPlaceHolder1_dropLocation").value == "Repair" && document.getElementById("ctl00_ContentPlaceHolder1_DropRepairvndr").value == "") {
                args.IsValid = false;
            }
            else {
                args.IsValid = true;
            }
        }

    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <pg:progress ID="progress1" runat="server" />
    <div class="pageheader">
        <h2>
            <i class="fa fa-tasks"></i>Asset Master
        </h2>
        <div class="breadcrumb-wrapper mar ">
            <asp:Button ID="PaggedGridbtnedit" runat="server" Style="display: none;" OnClick="PaggedGridbtnedit_Click" ClientIDMode="Static" />
            <a id="liaddnew" runat="server" class="right_link" onclick="reset();opendiv();ShowHideDiv();"><i class="fa fa-fw fa-plus topicon"></i>Add New</a>
            <%--            <asp:LinkButton ID="btnexportcsv" runat="server" CssClass="right_link">
              <i class="fa fa-fw fa-file-excel-o topicon"></i>Export to Excel
            </asp:LinkButton>--%>
            <%-- <a id="lnkrefresh" class="right_link" ><i class="fa fa-fw fa-refresh topicon"></i>Refresh</a>--%>
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
                    <asp:UpdatePanel ID="updatePanelData" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="false">
                        <ContentTemplate>
                            <div id="otherdiv" onclick="closediv();">
                            </div>
                            <div class="col-sm-12 col-md-12 mar2 clear" style="min-height: 500px">
                                <div>
                                    
                                    <div class="col-sm-2 col-md-2 f_left pad4  mar clear">
                                        <asp:DropDownList ID="DropSearchCategory" runat="server" CssClass="form-control">
                                        </asp:DropDownList>
                                    </div>
                                    <div class="col-sm-2 col-md-2 f_left pad5 mar">
                                        <asp:TextBox MaxLength="20" ID="txtSearchAsset" runat="server" CssClass="form-control" placeholder="Asset Name "></asp:TextBox>
                                    </div>

                                    <div class="col-sm-2 col-md-2 f_left pad5 mar">
                                        <asp:DropDownList ID="DropSearchDepartment" runat="server" CssClass="form-control">
                                        </asp:DropDownList>
                                    </div>

                                    <%-- <div class="col-sm-4 col-md-4 f_left pad4 mar clear">
                                <asp:DropDownList ID="DropSearchLocation" runat="server" CssClass="form-control pad3">
                                </asp:DropDownList>
                            </div>--%>

                                    <div class="col-sm-2 col-md-2 f_left pad5 mar">
                                        <asp:Button ID="btnsearch" runat="server" Text="Search" CssClass="btn btn-default "
                                            OnClick="btnsearch_Click" />
                                    </div>
                                    <div class="f_right" style="padding-top: 10px;display: none;">
                                        <span class="f_left">
                                            <asp:LinkButton ID="lnkprevious" runat="server" OnClick="lnkprevious_Click"> <i class="fa fa-fw fa-fast-backward color_green"></i></asp:LinkButton>
                                        </span>
                                        <p class="f_left page">
                                            <asp:Label ID="lblstart" runat="server"></asp:Label>
                                            -
                                        <asp:Label ID="lblend" runat="server"></asp:Label>
                                            of <strong>
                                                <asp:Label ID="lbltotalrecord" Font-Bold="true" runat="server"></asp:Label></strong>
                                        </p>
                                        <span class="f_left">
                                            <asp:LinkButton ID="lnknext" runat="server" OnClick="lnknext_Click">  <i class="fa fa-fw fa-fast-forward color_green"></i></asp:LinkButton>
                                        </span>
                                    </div>

                                </div>

                                <div class="clear">
                                </div>
                                <div class="panel panel-default mar">
                                    <div class="panel-body2 ">
                                        <div class="row">
                                            <div class="table-responsive" style="min-height: 300px;">
                                                <div class="nodatafound" id="divnodata" runat="server">
                                                    No data found
                                                </div>
                                                <asp:GridView ID="dgnews" runat="server" AllowPaging="false" AutoGenerateColumns="False"
                                                   CellPadding="4" CellSpacing="0" BorderWidth="0px"
                                                     Width="100%" ShowHeader="true" ShowFooter="false" CssClass="tblreport"
                                                    GridLines="None" BorderStyle="None" AllowSorting="false" 
                                                    OnRowDataBound="dgnews_RowDataBound" OnRowCommand="dgnews_RowCommand">
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="S.No." ItemStyle-Width="50px">
                                                            <ItemTemplate>
                                                                <%# Container.DataItemIndex + 1 %>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Asset Code" SortExpression="assetcode">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "assetcode")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Asset Name" SortExpression="assetName">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "assetName")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                        <asp:TemplateField HeaderText="Category" SortExpression="categoryname">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "categoryname")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Location">
                                                            <ItemTemplate>
                                                                <i class="fa fa-fw">
                                                                    <asp:Image ID="imgloc" runat="server" Style="padding: 0px 0px 3px 0px" />
                                                                </i>

                                                                <%# DataBinder.Eval(Container.DataItem, "Location")%>
                                                            </ItemTemplate>

                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Location" Visible="false">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "currentLocation")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                        <asp:TemplateField HeaderText="Department">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "departmentname")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                        <asp:TemplateField HeaderText="Condition" ItemStyle-Width="80px">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "name")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                        <asp:TemplateField ItemStyle-Width="30px">
                                                            <ItemTemplate>
                                                               <a onclick='clickedit(<%#DataBinder.Eval(Container.DataItem,"nid")%>);' title="Edit"><i class="fa fa-fw">
                                                                    <img src="images/edit.png"></i></a>  </ItemTemplate>
                                                        </asp:TemplateField>
                                                         <asp:TemplateField  ItemStyle-Width="30px">
                                                            <ItemTemplate>
                                                                 <asp:LinkButton ID="lbtndelete" CommandName="del" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"nid")%>'
                                                                    ToolTip="Delete" runat="server" OnClientClick='return confirm("Delete this record? Yes or No");'><i class="fa fa-fw"><img src="images/delete.png" alt="Delete" /></i></asp:LinkButton>
                                                                        </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField  ItemStyle-Width="30px">
                                                            <ItemTemplate>
                                                                 <a onclick='clickHistory(<%#DataBinder.Eval(Container.DataItem,"nid")%>);' title="View History"><i class="fa fa-fw">
                                                                    <img src="images/History.png"></i></a> 
                                                                    </ItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                    <EmptyDataTemplate>
                                                        No Asset
                                                    </EmptyDataTemplate>
                                                   <HeaderStyle CssClass="gridheader" />
                                                    <PagerStyle CssClass="gridpager" HorizontalAlign="Center" />
                                                    
                                                </asp:GridView>

                                               
                                            </div>
                                        </div>
                                        <!-- row -->
                                    </div>
                                    <!--  panel-body  -->
                                </div>

                            </div>
                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="btnsearch" EventName="Click" />
                            <asp:AsyncPostBackTrigger ControlID="lnkrefresh" EventName="Click" />
                        </Triggers>
                    </asp:UpdatePanel>
                    <div class="clear">
                    </div>
                    <input type="hidden" id="hiduserid" runat="server" />
                    <input type="hidden" id="hidempid" runat="server" />
                    <!-- col-sm-9 -->
                    <div class="clear">
                    </div>
                </div>
                <!-- panel -->
            </div>
        </div>
    </div>

    <!---ADD NEW div goes here-->
    <asp:UpdatePanel ID="updatePanelAssign" runat="server" UpdateMode="Conditional">
        <ContentTemplate>

            <div style="display: none; width: 780px;" runat="server" id="assignedtask_divaddnew"
                clientidmode="Static" class="itempopup">
                <div class="popup_heading">
                    <span id="legendaction" runat="server">Asset Master </span>
                    <div class="f_right">
                        <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
                    </div>
                </div>

                <div style="margin-top: 10px; min-height: 370px;">
                    <div class="tabContaier">
                        <ul>
                            <li><a href="#tab1" class="active">General</a></li>
                            <li><a href="#tab2">Billing Information</a></li>
                        </ul>
                        <!-- //Tab buttons -->
                        <div class="tabDetails">
                            <div class="tabContents" id="tab1" style="display: block; min-height: 434px;">
                                <div class="col-xs-12 col-sm-8">
                                      <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl1">Category:<asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="*"
                                                ControlToValidate="dropcategory" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                                        </label>
                                        <div class="txt w1 mar10">
                                            <asp:DropDownList ID="dropcategory" runat="server" CssClass="form-control">
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="clear"></div>
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl1">Item Code:<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*"
                                                                ControlToValidate="txtcode" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                                        </label>
                                        <div class="txt w1 mar10">
                                            <asp:TextBox MaxLength="20" ID="txtcode" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="clear"></div>
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl1">Item Name:<asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="*"
                                                                ControlToValidate="txtname" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                                        </label>
                                        <div class="txt w2">
                                            <asp:TextBox MaxLength="20" ID="txtname" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="clear"></div>
                                  


                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl1">Description:<asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="*"
                                                                ControlToValidate="txtdescription" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                                        </label>
                                        <div class="txt w2">
                                            <asp:TextBox   ID="txtdescription" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                     <div class="clear"></div>

                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl1">Warranty:</label>
                                        <div class="txt w1 mar10">
                                            <asp:TextBox MaxLength="20" ID="txtwaranty" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl1">Condition:</label>
                                        <div class="txt w1">
                                            <asp:DropDownList ID="dropworkingcondition" runat="server" CssClass="form-control">
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                     <div class="clear"></div>
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl1">Location:</label>
                                        <div class="txt w1 mar10">
                                            <asp:DropDownList ID="dropLocation" runat="server" CssClass="form-control" onchange="ShowHideDiv()">
                                                <asp:ListItem Value="Stock" Selected="True">Stock</asp:ListItem>
                                                <asp:ListItem Value="Individual">Individual</asp:ListItem>
                                                <asp:ListItem Value="Inuse">Inuse</asp:ListItem>
                                                <asp:ListItem Value="Store">Store</asp:ListItem>
                                                <asp:ListItem Value="Repair">Repair</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="clear"></div>
                                    <div class="ctrlGroup searchgroup" id="divDepartment">
                                        <label class="lbl lbl1">Department:<asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ErrorMessage="*"
                                                ControlToValidate="DropDepartment" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                                        </label>
                                        <div class="txt w2">
                                            <asp:UpdatePanel ID="updatePanelSearch" runat="server" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <asp:DropDownList ID="DropDepartment" runat="server" CssClass="form-control">
                                                    </asp:DropDownList>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </div>
                                    </div>
                                      <div class="clear"></div>
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl1">Last Location Date:</label>
                                        <div class="txt w1 mar10">
                                            <asp:TextBox ID="txtDate" runat="server" CssClass="form-control hasDatepicker"
                                                placeholder="MM/DD/YYYY"></asp:TextBox>
                                            <ajax:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtDate" PopupButtonID="txtDate"
                                                Format="MM/dd/yyyy">
                                            </ajax:CalendarExtender>
                                        </div>
                                    </div>
                                    <div class="clear"></div>
                                    <div class="ctrlGroup searchgroup" id="divEmployee" style="display: none" runat="server">
                                        <label class="lbl lbl1">Employee:<asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="*" CssClass="validation" ClientValidationFunction="validateemployee" ValidationGroup="save">
                                            </asp:CustomValidator>
                                        </label>
                                        <div class="txt w2">
                                            <asp:UpdatePanel ID="updatePanel1" runat="server" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <asp:DropDownList ID="dropemployee" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="employee_selecetdIndexChanged">
                                                    </asp:DropDownList>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </div>
                                    </div>

                                    <%-- <asp:CustomValidator ID="EmpCustomValidator" runat="server" ErrorMessage="*"
                                                CssClass="validation" ValidationGroup="save" OnServerValidate="EmpCustomValidator_ServerValidate"></asp:CustomValidator>--%>
                                    <div class="clear"></div>
                                    <div class="ctrlGroup searchgroup"  id="divVendor" style="display: none" runat="server">
                                        <label class="lbl lbl1">
                                            Vendor:<asp:CustomValidator ID="CustomValidator2" runat="server" ErrorMessage="*" CssClass="validation" ClientValidationFunction="validatevendor" ValidationGroup="save">
                                            </asp:CustomValidator>
                                        </label>
                                        <div class="txt w2">
                                            <asp:DropDownList ID="DropRepairvndr" runat="server" CssClass="form-control">
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                     <div class="clear"></div>
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl1">Remark:</label>
                                        <div class="txt w2">
                                            <asp:TextBox ID="txtremark" MaxLength="200" runat="server" CssClass="form-control" placeholder="Remark"
                                                TextMode="MultiLine" Height="50px"></asp:TextBox>
                                        </div>
                                    </div>


                                </div>

                                <div class="col-xs-12 col-sm-4">
                                      <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl2">Asset Image (.png, .jpg)</label>
                                        <div class="txt w1">
                                            <div class="background_image">
                                                <img id="DisplayImg" runat="server" src="webfile/profile/nophoto.png" alt="" style="height: 100px; width: 100px" />


                                                <%-- <asp:Image ID="imgDisplay" src="webfile/profile/nophoto.png" Alt="" Runat="server" />--%>

                                                <asp:Label runat="server" ID="myThrobber" Style="display: none;"><img  alt="" src="images/loading.gif"/>
                                                </asp:Label>
                                                <%--<img id="imgLoad" alt="" src="images/loading.gif" />--%>
                                                <%--<asp:Label ID="lblMsg" runat="server" Text=""></asp:Label>--%>

                                                <%--<cc1:AjaxFileUpload ID="AjaxFileUpload1" runat="server" padding-bottom="4" padding-left="2"
                                                padding-right="1" padding-top="4" ThrobberID="myThrobber"
                                                OnUploadComplete="AjaxFileUpload1_OnUploadComplete" OnClientUploadCompleteAll="onClientUploadCompleteAll" MaximumNumberOfFiles="1"
                                                AzureContainerName="" />--%>

                                                <cc1:AsyncFileUpload ID="AsyncFileUpload1" OnClientUploadComplete="uploadComplete" OnClientUploadStarted="AssemblyFileUpload_Started"
                                                    runat="server" Width="209px" ThrobberID="myThrobber" CompleteBackColor="White"  OnUploadedComplete="FileUploadComplete" />

                                                <%--<ajax:AsyncFileUpload ID="fileUpload1" OnClientUploadComplete="uploadComplete" OnClientUploadError="uploadError"
                                                    CompleteBackColor="White" Width="200px" runat="server"  UploadingBackColor="#CCFFFF"
                                                    ThrobberID="imgLoad" OnUploadedComplete="fileUploadComplete" />--%>
                                            </div>
                                        </div>
                                        <%-- <div id="uploadCompleteInfo">
                                        </div>--%>
                                    </div>
                                </div>
                                  

                                <div class="clear">
                                </div>
                            </div>

                            <div class="tabContents" id="tab2" style="display: none; min-height: 300px;">
                                <div class="col-sm-12">
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl1">Vendor :</label>
                                        <div class="txt w2 mar10">
                                            <asp:DropDownList ID="dropvendor" runat="server" CssClass="form-control">
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="clear"></div>
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl1">Manufacturer :</label>
                                        <div class="txt w2">
                                            <asp:TextBox MaxLength="20" ID="txtmanufacture" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="clear"></div>
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl1">Barcode :</label>
                                        <div class="txt w1 mar10">
                                            <asp:TextBox MaxLength="20" ID="txtbarcode" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="clear"></div>
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl1">Serial No :</label>
                                        <div class="txt w1">
                                            <asp:TextBox MaxLength="20" ID="txtserialno" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="clear"></div>
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl1">Purchase Date :</label>
                                        <div class="txt w1">
                                            <asp:TextBox ID="txtPurchaseDate" runat="server" CssClass="form-control hasDatepicker"
                                                placeholder="MM/dd/yyyy"></asp:TextBox>
                                            <ajax:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtPurchaseDate" PopupButtonID="txtPurchaseDate"
                                                Format="MM/dd/yyyy">
                                            </ajax:CalendarExtender>
                                        </div>
                                    </div>
                                    <div class="clear"></div>
                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl1">Invoice No. :</label>
                                        <div class="txt w1 ">
                                            <asp:TextBox MaxLength="20" ID="txtinvoicenumber" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="clear"></div>

                                    <div class="ctrlGroup searchgroup">
                                        <label class="lbl lbl1">Price :</label>
                                        <div class="txt w1">
                                            <asp:TextBox ID="txtprice" runat="server" CssClass="form-control" onkeypress="blockNonNumbers(this, event, true, false);" onblur="fill(this.id);"
                                                onkeyup="extractNumber(this,2,false); setmax(this);"></asp:TextBox>
                                        </div>
                                    </div>

                                </div>
                                <div class="clear">
                                </div>
                            </div>
                            <div class="clear">
                            </div>
                        </div>

                        <input type="hidden" id="hidid" runat="server" />
                        <div class="col-xs-12 col-sm-12 pad2">
                            <asp:Button ID="btnsubmit" runat="server" CssClass="btn btn-primary" Text="Save"
                                ValidationGroup="save" OnClick="btnsubmit_Click" />
                            <asp:Button ID="btndelete" runat="server" CssClass="btn btn-default" Visible="false"
                                Text="Delete" />
                        </div>
                    </div>
                </div>

            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <!---ADD NEW div goes here on history display-->
    <asp:UpdatePanel ID="updatePanelImageHistory" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:Button ID="btnHistory" runat="server" Style="display: none;" OnClick="btnHistory_Click" ClientIDMode="Static" />
            <script src="js/displayHistoryWithImages.js"></script>

            <div id="imageDiv" class="itempopup" style="display: none; position: absolute; top: 104px; left: 314.5px; width: 790px;">
                <div class="popup_heading">
                    <span id="Span2" runat="server"></span>
                    <div class="f_right">
                        <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
                    </div>
                </div>
                <div style="overflow-y: auto;">
                    <div class="divform poppad" style="overflow-y: auto; height: 386px; margin: 0px auto; padding: 10px; width: 760px;" id="imageDivs">
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <script type="text/javascript">

        function setmax(txt) {
            

        }
        $(document).ready(function () {
            $(".tabContents").hide(); // Hide all tab content divs by default
            $("#tab1").show(); // Show the first div of tab content by default
            bintabcontainerevent();

        });

        //The below code is to generate the script when page refresh in update panel
        var prm = Sys.WebForms.PageRequestManager.getInstance();

        prm.add_endRequest(function () {
            //$(".tabContents").hide(); // Hide all tab content divs by default
            //$(".tabContaier ul li a").removeClass("active");
            //var currenttab = document.getElementById("hidcurrenttab").value;
            //var currenttab1 = document.getElementById("hidtabid").value;
            //if (currenttab1 != "") {
            //    document.getElementById(currenttab1).className = "active";
            //}
            //if (currenttab != "") {
            //    $(currenttab).fadeIn();
            //}
            //else {
            //    $("#tab1").show();
            //    document.getElementById("lnktab1").className = "active"
            //}
            bintabcontainerevent();
            // fixheader();

        });

        function bintabcontainerevent() {


            $(".tabContaier ul li a").click(function () { //Fire the click event

                var activeTab = $(this).attr("href"); // Catch the click link             
                $(".tabContaier ul li a").removeClass("active"); // Remove pre-highlighted link
                $(this).addClass("active"); // set clicked link to highlight state
                $(".tabContents").hide(); // hide currently visible tab content div
                $(activeTab).fadeIn(); // show the target tab content div by matching clicked link.
                document.getElementById("hidtabid").value = $(this).attr("id");
                document.getElementById("hidcurrenttab").value = activeTab;
                return false; //prevent page scrolling on tab click
            });

        }
        function AssemblyFileUpload_Started(sender, args) {
            var filename = args.get_fileName();
            var ext = filename.substring(filename.lastIndexOf(".") + 1);
            if (ext != 'png' && ext != 'jpg') {
                throw {
                    name: "Invalid File Type",
                    level: "Error",
                    message: "Invalid File Type (Only .png or  .jpg)",
                    htmlMessage: "Invalid File Type (Only .png or  .jpg)"
                }
                return false;
            }
            return true;
        }



    </script>

</asp:Content>
