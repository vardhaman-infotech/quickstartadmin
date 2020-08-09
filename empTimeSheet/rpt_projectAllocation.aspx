<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="rpt_projectAllocation.aspx.cs" Inherits="empTimeSheet.rpt_projectAllocation" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        function setcontent(chkid, id, place,type) {
            var str = "", str1 = "";
            var chkBoxList = document.getElementById(chkid);
            var elements = chkBoxList.getElementsByTagName("input");
            var lbl = chkBoxList.getElementsByTagName("label");
            for (i = 0; i < elements.length; i++) {
                if (elements[i].checked) {
                    if (str == "") {
                        str = lbl[i].innerHTML;
                       
                    }
                    else {
                        str += "," + lbl[i].innerHTML;
                        
                    }

                }

            }
         
            if (str == "")
                document.getElementById(id).placeholder = place;
            else
                document.getElementById(id).placeholder = str;

           

        }

        function checkall(id, chkid, place, txtid,type) {


            var ischecked = document.getElementById(id).checked;

            var chkBoxList = document.getElementById(chkid);
            var elements = chkBoxList.getElementsByTagName("input");
            for (i = 0; i < elements.length; i++) {

                elements[i].checked = ischecked;
            }
            setcontent(chkid, txtid, place,type);
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <pg:progress ID="progress1" runat="server" />
    <div class="pageheader">
        <h2>
            <i class="fa fa-clipboard"></i>Project Report
        </h2>
       
        <div class="clear">
        </div>
    </div>
    <div class="contentpanel">
        <div class="row">
            <div class="col-sm-12 col-md-12">
                <div class="panel panel-default">
                    <div class="col-sm-12 col-md-10">
                        <div style="padding-top: 10px;">
                            <div class="col-xs-12 col-sm-8 col-md-6 f_left" style="padding: 0px;">
                                <h5 class="subtitle mb5">Project Allocation Report</h5>
                            </div>
                           <div class="clear"></div>
                            <div class="col-sm-6 col-md-4  pad4">
                                <asp:DropDownList ID="txtproject" runat="server" CssClass="form-control mar pad3">
                                </asp:DropDownList>


                               

                            </div>
                              
                         
                             

                            <div class="col-sm-6 col-md-4  pad5">
                                <asp:Button ID="btnsearch" runat="server" Text="View Report" CssClass="btn btn-default mar"
                                    OnClick="btnsearch_Click" />
                            </div>

                        </div>
                    </div>
                   <div class="clear">
                    </div>
                    <div class="col-sm-12 col-md-12 mar2">
                          
                         <div class="diverror" id="divnodata" runat="server" visible="false">
                                                    No data found
                                                </div>
                      
                        <div id="divreport" runat="server" class="mainrptdiv" >

                                                    <!--Outer Most- CLIENT repeater-->
                                                     <rsweb:ReportViewer ID="ReportViewer1" runat="server" Width="100%" Height="600px"    >
        </rsweb:ReportViewer>
                              
                                                </div>
                        <div class="clear"></div>
                      
                       <input type="hidden" id="hidsprojectid" runat="server" />
                                <input type="hidden" id="hidsclientid" runat="server" />
                                <input type="hidden" id="hidsemployeeid" runat="server" />
                    </div>
                    <div class="clear">
                    </div>
                </div>
                <!--Panel-default-->
            </div>
            <!---col-sm-12 col-md-12-->
        </div>
        <!---row-->
    </div>
    <!---contentpanel-->
</asp:Content>
