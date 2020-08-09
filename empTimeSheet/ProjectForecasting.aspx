<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true"
    CodeBehind="ProjectForecasting.aspx.cs" Inherits="empTimeSheet.ProjectForecasting" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
   
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
            }
            else {
                document.getElementById("divtaskdetail").style.display = "block";
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
                links[i].style.backgroundColor = "transparent";
            }

            document.getElementById(id).style.backgroundColor = "#fe8b37";
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
            }
            else {
                document.getElementById("ctl00_ContentPlaceHolder1_hidparent").value = "";
                document.getElementById("ctl00_ContentPlaceHolder1_hidid").value = arr[3];
                document.getElementById("ctl00_ContentPlaceHolder1_hidproject").value = arr[1];
                document.getElementById("ctl00_ContentPlaceHolder1_lnkAddnew").innerHTML = " <i class='fa fa-fw' style='padding-right: 10px; font-size: 12px; border: none;'></i> Add New Child  Module";
                getdetail(val);

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
            document.getElementById("ctl00_ContentPlaceHolder1_btnsubmit").value = "Save";
            document.getElementById("ctl00_ContentPlaceHolder1_btndelete").style.display = "false";
        }     
    </script>
    <script type="text/javascript">

        function getdetail(val) {



            document.getElementById("ctl00_ContentPlaceHolder1_btnsubmit").value = "Update";
            document.getElementById("ctl00_ContentPlaceHolder1_btndelete").style.display = "block";



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

                            }
                            else {
                                document.getElementById("divtaskdetail").style.display = "block";
                                document.getElementById("ctl00_ContentPlaceHolder1_lnkAddnew").style.display = "none";

                            }

                        }
                        else {

                            document.getElementById("ctl00_ContentPlaceHolder1_droptask").disabled = "disabled";
                            document.getElementById("divtaskdetail").style.display = "none";
                            document.getElementById("ctl00_ContentPlaceHolder1_lnkAddnew").style.display = "block";


                        }


                    }
                },
                error: function (x, e) {
                    alert("The call to the server side failed. " + x.responseText);

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
                    <i class="fa fa-th"></i> Project Forecasting
                </h2>
                <div class="breadcrumb-wrapper mar ">
                    <a id="lnkAddnew" runat="server" onclick="addnew();" class="right_link">
                    <i class="fa fa-fw fa-plus topicon"></i> Add New Module </a>
                </div>
                <div class="clear">
                </div>
            </div>
            <%-- <h2 class="left_hedding3">
                <span></span>Projects
            </h2>--%>
            <div class="contentpanel">
                <div class="row">
                    <div class="col-sm-4 col-md-3">
                        <div class="panel panel-default">
                            <div class="panel-body">
                                <h5 class="subtitle mb5">
                                    Projects</h5>
                                <asp:DropDownList ID="dropproject" runat="server" CssClass="form-control" OnSelectedIndexChanged="dropproject_SelectedIndexChanged"
                                    AutoPostBack="true">
                                </asp:DropDownList>
                                <div class="clear">
                                </div>
                                <div class="nodatafound" id="divmsg" runat="server" visible="false">
                                    No Module found</div>
                                <div class="clear">
                                </div>
                                <div class="treediv">
                                    <asp:TreeView ID="treemenu" runat="server" CssClass="treeview" Width="99%" ImageSet="Simple"
                                        OnSelectedNodeChanged="treeview_SelectedNodeChanged" ShowLines="True">
                                        <HoverNodeStyle CssClass="roothover" />
                                        <NodeStyle ImageUrl="images/black_folder.png" VerticalPadding="5" HorizontalPadding="5"
                                            CssClass="nodestyle" />
                                        <ParentNodeStyle NodeSpacing="0px" />
                                        <SelectedNodeStyle CssClass="rootselected" />
                                        <RootNodeStyle CssClass="rootnode" ImageUrl="images/rootnode.png" VerticalPadding="5"
                                            HorizontalPadding="5" />
                                    </asp:TreeView>
                                    <%--          <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="*"
                            ControlToValidate="treemenu" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>--%>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-8 col-md-9">
                        <div class="panel panel-default">
                            <div class="panel-body" style="min-height:410px;">
                                <div class="row">
                                    <div class="form-group fl_widht">
                                        <div class="col-xs-12 col-sm-12" id="divmain" style="display: none;">
                                            <div class="col-xs-12 col-sm-6 form-group f_left pad">
                                                <label class="col-xs-12 col-sm-5 control-label">
                                                    Category Task:
                                                </label>
                                                <div class="col-xs-12 col-sm-7">
                                                    <asp:DropDownList ID="droptask" runat="server" CssClass="form-control" onchange="setdetailvisible(this.id)">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div id="divtaskdetail" style="display: none;">
                                                <div class="col-xs-12 col-sm-6 form-group f_left pad">
                                                    <label class="col-sm-5 control-label">
                                                        % Complete:    <asp:RangeValidator ID="RangeValidator1" runat="server" ErrorMessage="*"  ControlToValidate="txtcomplete" CssClass="validation" ValidationGroup="save" MaximumValue="100" MinimumValue="0" ></asp:RangeValidator>
                                                    </label>
                                                    <div class="col-xs-12 col-sm-7">
                                                        <asp:TextBox ID="txtcomplete" runat="server" CssClass="form-control" Text="0" MaxLength="3" onkeypress="return isNumberKey(event)"></asp:TextBox>

                                                    
                                                    </div>
                                                </div>
                                                <div class="col-xs-12 col-sm-6 form-group f_left pad">
                                                    <label class="col-sm-5 control-label">
                                                        Est. Start Date:
                                                    </label>
                                                    <div class="col-xs-12 col-sm-7">
                                                  
                                                        <asp:TextBox ID="txtstartdate" runat="server" CssClass="form-control hasDatepicker" placeholder="mm/dd/yyyy" onchange="comparedate(this.id,'ctl00_ContentPlaceHolder1_txtstartdate','ctl00_ContentPlaceHolder1_txtenddate');"></asp:TextBox>
                                                      
                                                        <ajax:CalendarExtender ID="cc1" runat="server" TargetControlID="txtstartdate" PopupButtonID="txtstartdate"
                                                            Format="MM/dd/yyyy">
                                                        </ajax:CalendarExtender>
                                                     
                                                    </div>
                                                </div>
                                                <div class="col-xs-12 col-sm-6 form-group f_left pad">
                                                    <label class="col-sm-5 control-label">
                                                        Est. End Date:
                                                    </label>
                                                    <div class="col-xs-12 col-sm-7">
                                                    
                                                        <asp:TextBox ID="txtenddate" runat="server" CssClass="form-control hasDatepicker" placeholder="mm/dd/yyyy" onchange="comparedate(this.id,'ctl00_ContentPlaceHolder1_txtstartdate','ctl00_ContentPlaceHolder1_txtenddate');"></asp:TextBox>
                                                         
                                                        <ajax:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtenddate"
                                                            PopupButtonID="txtenddate" Format="MM/dd/yyyy">
                                                        </ajax:CalendarExtender>
                                                        
                                                    </div>
                                                </div>
                                                <div class="col-xs-12 col-sm-6 clear form-group f_left pad">
                                                    <label class="col-sm-5 control-label">
                                                        Estimated Hrs :
                                                        <%-- <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*"
                            ControlToValidate="txtesthrs" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>--%>
                                                    </label>
                                                    <div class="col-xs-12 col-sm-7">
                                                        <asp:TextBox ID="txtesthrs" runat="server" CssClass="form-control" Text="0" onkeypress="return isNumberKey(event)"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="clear"></div>
                                            <div class="col-xs-12 col-sm-12 form-group f_left pad">
                                             <label class="col-sm-2 control-label" style="width:23%;">
                                                    Title :
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="*"
                                                        ControlToValidate="txttitle" CssClass="validation" ValidationGroup="save"></asp:RequiredFieldValidator>
                                                </label>
                                                <div class="col-sm-9 pad">
                                                    <asp:TextBox ID="txttitle" runat="server" CssClass="form-control" Style="float: left;"
                                                        placeholder="Title"></asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-xs-12 col-sm-12 form-group f_left pad clear">
                                                <label class="col-sm-2 control-label" style="width:23%;">
                                                    Description :
                                                </label>
                                                <div class="col-sm-9 pad">
                                                    <asp:TextBox ID="txtdescription" runat="server" CssClass="form-control" Style="float: left;"
                                                        placeholder="Description" TextMode="MultiLine"></asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-sm-12">
                                             
                                              
                                                <div class="clear">
                                                </div>
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
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
