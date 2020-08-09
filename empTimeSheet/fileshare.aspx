<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="fileshare.aspx.cs" Inherits="empTimeSheet.fileshare" %>

<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        function copyToClipboard(id) {
            var charindex = id.lastIndexOf("_");
            if (charindex != -1) {
                id = id.substring(0, charindex + 1);

                var grade = document.getElementById(id + "spanlink").innerHTML;
                
                window.prompt("Copy to clipboard: Ctrl+C, Enter", grade);
            }

              
        }
        function saveFileSize(id) {
            $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
            var charindex = id.lastIndexOf("_");
            if (charindex != -1) {
                id = id.substring(0, charindex + 1);

                var grade = document.getElementById(id + "txtmaxsize").value;

                var nid = document.getElementById(id + "hidnid").value;


                var args = { nid: nid, grade: grade };
                $.ajax({

                    type: "POST",
                    url: "fileshare.aspx/saveempFileSize",
                    data: JSON.stringify(args),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: true,
                    cache: false,
                    success: function (msg) {

                        msg1 = "success";
                        alert("Saved successfully");
                        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                    },
                    error: function (x, e) {
                        alert("The call to the server side failed. " + x.responseText);
                        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();

                    }


                });
            }

        }



        function savefileshareing(id) {
            $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
            var charindex = id.lastIndexOf("_");
            if (charindex != -1) {
                id = id.substring(0, charindex + 1);

                var grade = document.getElementById(id + "ddlopen").value;

                var nid = document.getElementById(id + "hidnid").value;


                var args = { nid: nid, grade: grade };
                $.ajax({

                    type: "POST",
                    url: "fileshare.aspx/saveempFileShare",
                    data: JSON.stringify(args),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: true,
                    cache: false,
                    success: function (msg) {

                        msg1 = "success";
                        alert("Saved successfully");
                        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                    },
                    error: function (x, e) {
                        alert("The call to the server side failed. " + x.responseText);
                        $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();

                    }


                });
            }

        }

        function saveFileLink(id) {
            if (confirm('Are you sure to reset file share link?'))
            {
                $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').show();
                var charindex = id.lastIndexOf("_");
                if (charindex != -1) {
                    id = id.substring(0, charindex + 1);

                    var grade = document.getElementById(id + "ddlopen").value;

                    var nid = document.getElementById(id + "hidnid").value;


                    var args = { nid: nid };
                    $.ajax({

                        type: "POST",
                        url: "fileshare.aspx/saveempFileLink",
                        data: JSON.stringify(args),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        async: true,
                        cache: false,
                        success: function (msg) {

                            document.getElementById(id + "spanlink").innerHTML = msg.d;

                            alert("Saved successfully");
                            $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();
                            return false;
                        },
                        error: function (x, e) {
                            alert("The call to the server side failed. " + x.responseText);
                            $('#ctl00_ContentPlaceHolder1_progress1_UpdateProg1').hide();

                        }


                    });
                }

            }

        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <pg:progress ID="progress1" runat="server" />
    <div class="pageheader">
        <h2>
            <i class="fa fa-tasks"></i>File Sharing
        </h2>

        <div class="clear">
        </div>
    </div>
    <div class="clear"></div>

    <div class="contentpanel">
        <div class="row">
            <div class="col-sm-12 col-md-12">
                <div class="panel panel-default">
                    <div class="panel-body2 ">
                        <div class="ctrlGroup searchgroup">
                            <label class="lblAuto" style="max-width:none;">Employee Name :</label>
                            <div class="txt w1 mar10">
                            <asp:TextBox ID="txtname" runat="server" CssClass="form-control "></asp:TextBox>
                                </div>


                        </div>
                        <div class="col-sm-4 col-md-4 f_left pad4  mar">
                            <asp:Button ID="btnsearch" runat="server" CssClass="btn btn-default" Text="Search" OnClick="btnsearch_Click" />
                           
                        </div>
                        <div class="clear"></div>
                        <div class="table-responsive" style="padding-bottom:20px;">
                            <div class="nodatafound" id="divnodata" runat="server" style="display: none;">
                                No data found
                            </div>
                            <asp:GridView ID="dgnews" runat="server" AllowPaging="false"
                                AutoGenerateColumns="False" CellPadding="0"
                                CellSpacing="0" Width="100%" ShowHeader="true" ShowFooter="false"
                                CssClass="tblreportSimple " GridLines="None" OnRowDataBound="dgnews_RowDataBound">
                                <Columns>


                                    <asp:TemplateField HeaderText="Employee" ItemStyle-Width="150px">
                                        <ItemTemplate>
                                            <input type="hidden" id="hidnid" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "nid")%>' />
                                            <span title='<%# DataBinder.Eval(Container.DataItem, "loginid")%>'>
                                                <%# DataBinder.Eval(Container.DataItem, "username")%></span>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="File Sharing" ItemStyle-Width="120px">
                                        <ItemTemplate>
                                            <asp:DropDownList ID="ddlopen" runat="server" onchange="savefileshareing(this.id);" Width="80px">

                                                <asp:ListItem>On</asp:ListItem>
                                                <asp:ListItem>Off</asp:ListItem>

                                            </asp:DropDownList>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Max upload size(MB)" ItemStyle-Width="150px">
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtmaxsize" runat="server" onkeypress='blockNonNumbers(this, event, true, false);'   onblur='extractNumber(this,2,false);' onkeyup='extractNumber(this,2,false);' onchange="saveFileSize(this.id);"
                                                Width="80px" Text='<%# DataBinder.Eval(Container.DataItem, "filesize")%>'
                                                MaxLength="3"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="File Share URL">
                                        <ItemTemplate>
                                            <span id="spanlink" runat="server"><%# DataBinder.Eval(Container.DataItem, "schedulerURL")%>/emailFileShare.aspx?receiverid=<%# DataBinder.Eval(Container.DataItem, "filesharelink")%></span>&nbsp;
                                            <a id="LinkButton1" runat="server" onclick="copyToClipboard(this.id);">(Copy)

                                            </a>
                                            &nbsp; 
                                            <a id="linkreset" runat="server" onclick="saveFileLink(this.id);">
                                                (Reset)

                                            </a>
                                          

                                        </ItemTemplate>


                                    </asp:TemplateField>

                                </Columns>
                                <EmptyDataTemplate>
                                </EmptyDataTemplate>
                                <HeaderStyle CssClass="gridheader" />
                                <RowStyle CssClass="odd" />
                                <AlternatingRowStyle CssClass="even" />
                                <EmptyDataRowStyle CssClass="nodatafound" />
                                <PagerStyle CssClass="gridpager" HorizontalAlign="Center" />
                            </asp:GridView>
                              <div class="clear"></div>
                        </div>

                        <!-- row -->
                    </div>
                    <!--  panel-body  -->
                </div>
            </div>
        </div>
    </div>
</asp:Content>
