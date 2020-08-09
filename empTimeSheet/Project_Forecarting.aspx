<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="Project_Forecarting.aspx.cs" Inherits="empTimeSheet.Project_Forecarting" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" type="text/css" href="css/projectForecasting.css" />
    <script type="text/javascript">

        function isNumberKey(evt) {
            var charCode = (evt.which) ? evt.which : event.keyCode
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                alert("Please Enter Only Numeric Value.");
                return false;
            }

            return true;
        }
    </script>
    <script type="text/javascript">
        function validateproject() {

            if (document.getElementById("ctl00_ContentPlaceHolder1_hidselectednode").value == "") {
                alert("please select a node first");
                return false;
            }
            else
                return true;
        }

    </script>
    <script type="text/javascript">
        function setdetailvisible(id) {
            if (document.getElementById(id).value == "") {
                document.getElementById("divtaskdetail").style.display = "none";

                document.getElementById("lblchildtype").innerHTML = "Project Module";

            }
            else {
                document.getElementById("divtaskdetail").style.display = "block";

                document.getElementById("lblchildtype").innerHTML = "Project Activity";
            }

        }
        function findtree() {

            var links = document.getElementById("<%=treemenu.ClientID %>").getElementsByTagName("a");
            for (var i = 0; i < links.length; i++) {
                var val = links[i].getAttribute("href");
                links[i].setAttribute("onclick", "fillproject(this.id,'" + val + "');");
            }

        }
        function fillproject(id, val) {

            document.getElementById("divmain").style.display = "block";
            document.getElementById("ctl00_ContentPlaceHolder1_lnkAddnew").style.display = "block";
            blank();
            var links = document.getElementById("<%=treemenu.ClientID %>").getElementsByTagName("a");
            for (var i = 0; i < links.length; i++) {
                if (i == 2) {
                    links[i].style.color = "#016758";
                }
                links[i].style.backgroundColor = "transparent";
            }

            document.getElementById(id).style.backgroundColor = "#016758";
            document.getElementById(id).style.color = "#ffffff";
            document.getElementById("<%=hidselectednode.ClientID %>").value = val;
            document.getElementById("ctl00_ContentPlaceHolder1_hidselected").value = val;
            var arr = val.split("#");

            document.getElementById("divtaskdetail").style.display = "none";
            if (parseInt(arr.length) == 3) {

                document.getElementById("ctl00_ContentPlaceHolder1_hidparent").value = "";
                document.getElementById("ctl00_ContentPlaceHolder1_hidid").value = "";
                document.getElementById("ctl00_ContentPlaceHolder1_hidproject").value = arr[1];
                document.getElementById("ctl00_ContentPlaceHolder1_lnkAddnew").innerHTML = " <i class='fa fa-fw' style='padding-right: 10px; font-size: 12px; border: none;'></i> Add New  Module";
                document.getElementById("ctl00_ContentPlaceHolder1_lnkAddnew").style.display = "none";
                document.getElementById("lblchildtype").innerHTML = "Project Module";

                document.getElementById("<%=btndelete.ClientID%>").disabled = true;


            }
            else {
                document.getElementById("ctl00_ContentPlaceHolder1_hidparent").value = "";
                document.getElementById("ctl00_ContentPlaceHolder1_hidid").value = arr[3];
                document.getElementById("ctl00_ContentPlaceHolder1_hidproject").value = arr[1];
                document.getElementById("ctl00_ContentPlaceHolder1_lnkAddnew").innerHTML = " <i class='fa fa-fw' style='padding-right: 10px; font-size: 12px; border: none;'></i> Add New Child  Module";
                getdetail(val);

                document.getElementById("<%=btndelete.ClientID%>").disabled = false;
            }



        }

        function blank() {
            document.getElementById('<%=droptask.ClientID%>').value = "";
            document.getElementById("<%=droptask.ClientID%>").disabled = false;
            document.getElementById('<%=txtstartdate.ClientID%>').value = "";
            document.getElementById('<%=txtenddate.ClientID%>').value = "";
            document.getElementById('<%=txtesthrs.ClientID%>').value = "";
            document.getElementById('<%=txtcomplete.ClientID%>').value = "";
            document.getElementById('<%=txttitle.ClientID%>').value = "";
            document.getElementById('<%=txtdescription.ClientID%>').value = "";
            document.getElementById("lblchildtype").innerHTML = "";
            document.getElementById("ctl00_ContentPlaceHolder1_btnsubmit").value = "Save";
            document.getElementById("ctl00_ContentPlaceHolder1_btndelete").style.display = "false";
        }
    </script>
    <script type="text/javascript">

        function getdetail(val) {



            document.getElementById("ctl00_ContentPlaceHolder1_btnsubmit").value = "Update";
            document.getElementById("ctl00_ContentPlaceHolder1_btndelete").style.display = "block";

            $('#divmain').hide();
            $('#prohectforcasting_Rightloader').show();
            var args = { selectedval: val };

            $.ajax({

                type: "POST",
                url: "ProjectForecasting.aspx/getdetail",
                data: JSON.stringify(args),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                cache: false,
                success: function (msg) {


                    if (msg.d != "failure") {

                        var result = msg.d;

                        var arr = result.split("###");

                        //                        if (arr[0] != "") {
                        //                            document.getElementById("ctl00_ContentPlaceHolder1_lnkAddnew").style.display = "none";
                        //                            document.getElementById("ctl00_ContentPlaceHolder1_btnsubmit").value = "Update";
                        //                            document.getElementById("ctl00_ContentPlaceHolder1_btndelete").style.display = "block";


                        //                        }

                        document.getElementById("ctl00_ContentPlaceHolder1_btnsubmit").value = "Update";
                        document.getElementById('<%=droptask.ClientID%>').value = arr[0];
                        document.getElementById('<%=txttitle.ClientID%>').value = arr[1];
                        document.getElementById('<%=txtstartdate.ClientID%>').value = arr[2];
                        document.getElementById('<%=txtesthrs.ClientID%>').value = arr[3];
                        document.getElementById('<%=txtdescription.ClientID%>').value = arr[4];
                        document.getElementById('<%=txtcomplete.ClientID%>').value = arr[5];
                        document.getElementById('<%=txtenddate.ClientID%>').value = arr[7];



                        if (parseInt(arr[8]) == 0) {
                            document.getElementById("ctl00_ContentPlaceHolder1_droptask").disabled = false;
                            if (arr[0] == "") {
                                document.getElementById("divtaskdetail").style.display = "none";
                                document.getElementById("ctl00_ContentPlaceHolder1_lnkAddnew").style.display = "block";
                                document.getElementById("lblchildtype").innerHTML = "Project Module";

                            }
                            else {
                                document.getElementById("divtaskdetail").style.display = "block";
                                document.getElementById("ctl00_ContentPlaceHolder1_lnkAddnew").style.display = "none";
                                document.getElementById("lblchildtype").innerHTML = "Project Activity";

                            }

                        }
                        else {

                            document.getElementById("ctl00_ContentPlaceHolder1_droptask").disabled = "disabled";
                            document.getElementById("divtaskdetail").style.display = "none";
                            document.getElementById("ctl00_ContentPlaceHolder1_lnkAddnew").style.display = "block";

                            document.getElementById("lblchildtype").innerHTML = "Project Module";


                        }


                    }

                    $('#divmain').show();
                    $('#prohectforcasting_Rightloader').hide();
                },
                error: function (x, e) {
                    alert("The call to the server side failed. " + x.responseText);

                    $('#divmain').show();
                    $('#prohectforcasting_Rightloader').hide();

                }
            });
        }
    </script>
    <script type="text/javascript">
        function addnew() {
            blank();
            document.getElementById("ctl00_ContentPlaceHolder1_droptask").disabled = false;
            document.getElementById("ctl00_ContentPlaceHolder1_hidparent").value = document.getElementById("ctl00_ContentPlaceHolder1_hidid").value;
            document.getElementById("ctl00_ContentPlaceHolder1_hidid").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_btndelete").style.display = "none";
            document.getElementById("lblchildtype").innerHTML = "Project Module";

        }

        function reset() {
            document.getElementById("ctl00_ContentPlaceHolder1_droptask").selectedindex = "0";
            document.getElementById("ctl00_ContentPlaceHolder1_txtstartdate").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtesthrs").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtcomplete").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txttitle").value = "";
            document.getElementById("ctl00_ContentPlaceHolder1_txtdescription").value = "";
            document.getElementById("<%=hidid.ClientID %>").value = "";
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="hidselectednode" type="hidden" runat="server" />
    <asp:UpdatePanel ID="upadatepanel1" runat="server">
        <ContentTemplate>
            <input id="hidid" runat="server" type="hidden" />
            <input id="hidproject" runat="server" type="hidden" />
            <input id="hidselected" runat="server" type="hidden" />
            <input type="hidden" id="hidparent" runat="server" value="0" />
            <pg:progress ID="progress1" runat="server" />
            <div class="pageheader">
                <h2>
                    <i class="fa fa-th"></i>Project Forecasting
                </h2>

                <div class="clear">
                </div>
            </div>
            <%-- <h2 class="left_hedding3">
                <span></span>Projects
            </h2>--%>
            <div class="contentpanel">
                <div class="row">
                    <div class="col-sm-12 col-md-12">
                        <div class="panel panel-default panel_no_border">
                            <asp:MultiView ID="multiview1" runat="server" ActiveViewIndex="0">
                                <asp:View ID="viewlist" runat="server">
                                    <div class="col-sm-12 col-md-12">
                                        <div style="margin: 0px auto; width: 550px; max-width: 100%; min-height: 300px; margin-top: 16%;">

                                            <div class="ctrlGroup searchgroup">
                                                <label class="lbl lblbigfont">
                                                    Choose a Project :  
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*"
                                                        ControlToValidate="dropproject" CssClass="validation" ValidationGroup="srarch"></asp:RequiredFieldValidator></label>
                                                <div class="txt w2 mar10">
                                                    <asp:DropDownList ID="dropproject" runat="server" CssClass="form-control">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>

                                            <div class="ctrlGroup searchgroup">
                                                <div class="green-btn">
                                                    <asp:Button ID="btnsearch" runat="server" Text="Next" ValidationGroup="srarch"
                                                        OnClick="btnsearch_Click" />
                                                </div>
                                            </div>

                                        </div>
                                    </div>

                                </asp:View>
                                <asp:View ID="viewDetails" runat="server">

                                    <div class="left-invoice-box col-sm-12 col-md-3">
                                        <div class="left-invoice-heading" id="inv_projectname" runat="server">Project Summary</div>


                                        <div class="treediv">
                                            <asp:TreeView ID="treemenu" runat="server" CssClass="treeview" Width="99%" ImageSet="Arrows" SkipLinkText=""
                                                OnSelectedNodeChanged="treeview_SelectedNodeChanged" ShowLines="True">
                                                <HoverNodeStyle CssClass="roothover" />
                                                <NodeStyle ImageUrl="images/folder_white.png" VerticalPadding="0" HorizontalPadding="0"
                                                    CssClass="nodestyle" />
                                                <ParentNodeStyle NodeSpacing="0px" />
                                                <SelectedNodeStyle CssClass="rootselected" />
                                                <RootNodeStyle CssClass="rootnode" ImageUrl="images/folder_green.png" VerticalPadding="5"
                                                    HorizontalPadding="5" />
                                            </asp:TreeView>
                                        </div>




                                    </div>

                                    <div class="right-invoice-box col-sm-12 col-md-9">
                                        <div class="invc-tab-top">
                                            <div>
                                                <p style="float: left;" id="project_tasktitle">Project Module/Activity</p>

                                                <a id="lnkAddnew" runat="server" onclick="addnew();" class="linkaddnew">
                                                    <i class="fa fa-fw fa-plus topicon"></i>Add New Module/Activity </a>
                                            </div>
                                            <div class="clear"></div>
                                        </div>

                                        <div class="invc-dtl-box clearfix" id="inv_tab_1_detail">
                                            <div id="prohectforcasting_Rightloader" style="padding-top:10%;display:none;text-align:center;">
                                                <img src="images/waitimg.gif" />
                                            </div>
                                            <div class="col-xs-12 col-sm-12" id="divmain" style="display: none;">
                                                <div class="ctrlGroup">
                                                    <label class="lbl">
                                                        Title :
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="*"
                                                        ControlToValidate="txttitle" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                                                    </label>
                                                    <div class="txt w2">
                                                        <asp:TextBox ID="txttitle" MaxLength="200" runat="server" CssClass="form-control" Style="float: left;"></asp:TextBox>
                                                    </div>
                                                </div>
                                                <div class="clear"></div>
                                                <div class="ctrlGroup">
                                                    <label class="lbl">
                                                        Category Task:
                                                    </label>
                                                    <div class="txt w2 mar10">
                                                        <asp:DropDownList ID="droptask" runat="server" CssClass="form-control" onchange="setdetailvisible(this.id)">
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="clear"></div>
                                                <div class="ctrlGroup">
                                                    <label class="lbl">
                                                        Child Type:
                                                    </label>
                                                    <div class="txt w2 mar10">
                                                        <label class="lbl" id="lblchildtype">
                                                        </label>
                                                    </div>
                                                </div>


                                                <div class="clear"></div>
                                                <div id="divtaskdetail" style="display: none;">

                                                    <div class="clear"></div>
                                                    <div class="ctrlGroup">
                                                        <label class="lbl">
                                                            Est. Start Date:
                                                        </label>
                                                        <div class="txt w1">

                                                            <asp:TextBox ID="txtstartdate" ReadOnly="true" runat="server" CssClass="form-control hasDatepicker" placeholder="mm/dd/yyyy" onchange="comparedate(this.id,'ctl00_ContentPlaceHolder1_txtstartdate','ctl00_ContentPlaceHolder1_txtenddate');"></asp:TextBox>

                                                            <ajax:CalendarExtender ID="cc1" runat="server" TargetControlID="txtstartdate" PopupButtonID="txtstartdate"
                                                                Format="MM/dd/yyyy">
                                                            </ajax:CalendarExtender>

                                                        </div>
                                                    </div>
                                                    <div class="clear"></div>
                                                    <div class="ctrlGroup">
                                                        <label class="lbl">
                                                            Est. End Date:
                                                        </label>
                                                        <div class="txt w1 ">

                                                            <asp:TextBox ID="txtenddate" ReadOnly="true" runat="server" CssClass="form-control hasDatepicker" placeholder="mm/dd/yyyy" onchange="comparedate(this.id,'ctl00_ContentPlaceHolder1_txtstartdate','ctl00_ContentPlaceHolder1_txtenddate');"></asp:TextBox>

                                                            <ajax:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtenddate"
                                                                PopupButtonID="txtenddate" Format="MM/dd/yyyy">
                                                            </ajax:CalendarExtender>

                                                        </div>
                                                    </div>
                                                    <div class="clear"></div>
                                                    <div class="ctrlGroup">
                                                        <label class="lbl">
                                                            Estimated Hrs :
                                                        <%-- <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*"
                            ControlToValidate="txtesthrs" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>--%>
                                                        </label>
                                                        <div class="txt w1">
                                                            <asp:TextBox ID="txtesthrs" runat="server" CssClass="form-control" Text="0" MaxLength="3" onkeypress="return isNumberKey(event)"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                    <div class="clear"></div>
                                                    <div class="ctrlGroup">
                                                        <label class="lbl">
                                                            % Complete:   
                                                                    <asp:RangeValidator ID="RangeValidator1" runat="server" ErrorMessage="*" ControlToValidate="txtcomplete" CssClass="validation" ValidationGroup="save" MaximumValue="100" MinimumValue="0"></asp:RangeValidator>
                                                        </label>
                                                        <div class="txt w1">
                                                            <asp:TextBox ID="txtcomplete" runat="server" CssClass="form-control" Text="0" MaxLength="3" onkeypress="return isNumberKey(event)"></asp:TextBox>


                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="clear"></div>

                                                <div class="ctrlGroup">
                                                    <label class="lbl">
                                                        Description :
                                                    </label>
                                                    <div class="txt w2">
                                                        <asp:TextBox ID="txtdescription" runat="server" MaxLength="500" CssClass="form-control" Style="float: left;"
                                                            TextMode="MultiLine"></asp:TextBox>
                                                    </div>
                                                </div>

                                            </div>

                                        </div>



                                    </div>

                                    <div class="clear"></div>
                                    <div class="invc-btn-box" id="inv_btn">
                                        <div class="blue-btn" id="inv_btn_back_div" style="display: none;">
                                            <input type="button" id="inv_btn_back" value="Back" />
                                        </div>
                                        <div class="blue-btn">
                                            <asp:Button ID="btnback" runat="server" Text="Back"
                                                OnClick="btnback_Click" />


                                        </div>


                                        <div class="green-btn" id="inv_btn_finish_div">
                                            <asp:Button ID="btnsubmit" runat="server" Text="Save"
                                                ValidationGroup="save" OnClick="btnsave_Click" OnClientClick="validateproject();" />

                                        </div>
                                        <div class="green-btn" style="margin-right: 10px;">
                                            <asp:Button ID="btndelete" runat="server" Text="Delete"
                                                ValidationGroup="save" OnClick="btndelete_Click" OnClientClick="return confirm('Delete this Menu? Yes or No');"
                                                ToolTip="It will permanenetly remove the Selected Menu and its child menus too." />
                                        </div>
                                        <div class="clear"></div>

                                    </div>
                                </asp:View>
                            </asp:MultiView>
                            <div class="clear">
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

    <style>

        .form-control[disabled], .form-control[readonly], fieldset[disabled] .form-control {
            cursor: text !important;
    background-color: #fff !important;
        
        }
    </style>
</asp:Content>
