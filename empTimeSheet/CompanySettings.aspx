<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="CompanySettings.aspx.cs" Inherits="empTimeSheet.CompanySettings" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" type="text/css" href="css/company-setting5.0.css" />

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="pageheader">
        <h2>
            <i class="fa fa-building-o"></i>Company Settings
        </h2>
        <div class="breadcrumb-wrapper">
        </div>
        <div class="clear">
        </div>
    </div>
    <script>
        $(document).ready(function () {
            $('#ulcompanylink li a').click(function (e) {
                $('#ulcompanylink li').each(function () {
                    var oldid = $(this).find("a").attr('id');

                    $('#' + oldid + '_' + 'detail').hide();
                    $(this).find("a").removeClass("active");

                });




                var id = $(this).attr('id');
                id = id + "_detail";
                $('#' + id).fadeIn(300);
                $(this).addClass("active", 300);

                if (document.getElementById("if_" + id).src == "") {
                    document.getElementById("divcompanyloader").style.display = "block";
                    document.getElementById("if_" + id).src = document.getElementById("hid_" + id).value;
                }



            });

            $('#showinvoiceEmailHelp').click(function (e) {
                var varpos = $(this).position();
             
               
                $('#divinstruction').css("left",varpos.left-280);
                
                $('#divinstruction').toggle();
            });

        });
    </script>

    <div class="contentpanel">
        <div class="row">
            <div class="col-sm-12 col-md-12">
                <div class="panel panel-default">
                    <div class="left-company-box">
                        <ul id="ulcompanylink">
                            <li><a id="divcompany_1" class="active">Profile Picture<div></div>
                            </a></li>
                            <li><a id="divcompany_2">General
                                <div></div>
                            </a></li>
                            <li><a id="divcompany_3">Sender Email<div></div>
                            </a></li>

                            <li><a id="divcompany_5">Payment Terms
                                <div></div>
                            </a></li>
                            <li><a id="divcompany_4">Billing
                                <div></div>
                            </a></li>
                            <li><a id="divcompany_6">Invoice Template
                                <div></div>
                            </a></li>
                            <li><a id="divcompany_7">Invoice Email
                                <div></div>
                            </a></li>
                            <li><a id="divcompany_8">Scheduling Email
                                <div></div>
                            </a></li>
                            <li><a id="divcompany_9">Leave Request Email
                                <div></div>
                            </a></li>
                            <li><a id="divcompany_10">Time Clock
                                <div></div>
                            </a></li>
                        </ul>





                    </div>

                    <div class="right-company-box">

                        <div id="divcompanyloader" style="display: block; position: absolute; width: 76%; height: 600px; vertical-align: middle; text-align: center;">
                            <div style="position: relative; top: 40%;">
                                <img src="images/pleasewait.gif" /><br />
                                Loading...
                            </div>
                        </div>

                        <div class="comp-dtl-box clearfix" id="divcompany_1_detail" style="display: block;">
                            <div class="company-nmbr-hding">Profile Picture</div>
                            <input type="hidden" id="hid_divcompany_1_detail" value="com_Logo.aspx" />
                            <iframe id="if_divcompany_1_detail" class="iframe" src="com_Logo.aspx"></iframe>
                        </div>

                        <div class="comp-dtl-box clearfix" id="divcompany_2_detail">
                            <div class="company-nmbr-hding">General</div>
                            <input type="hidden" id="hid_divcompany_2_detail" value="comp_GeneralInformation.aspx" />
                            <iframe id="if_divcompany_2_detail" class="iframe"></iframe>
                            <div class="clear"></div>

                        </div>

                        <div class="comp-dtl-box clearfix" style="display: none;" id="divcompany_3_detail">
                            <div class="company-nmbr-hding">Sender Email</div>
                            <input type="hidden" id="hid_divcompany_3_detail" value="comp_email.aspx" />
                            <iframe id="if_divcompany_3_detail" class="iframe"></iframe>
                            <div class="clear"></div>
                        </div>

                        <div class="comp-dtl-box clearfix" style="display: none;" id="divcompany_4_detail">
                            <div class="company-nmbr-hding">Billing</div>
                            <input type="hidden" id="hid_divcompany_4_detail" value="comp_BillSettings.aspx" />
                            <iframe id="if_divcompany_4_detail" class="iframe"></iframe>
                            <div class="clear"></div>
                        </div>

                        <div class="comp-dtl-box clearfix" style="display: none;" id="divcompany_5_detail">
                            <div class="company-nmbr-hding">Payment Terms</div>
                            <input type="hidden" id="hid_divcompany_5_detail" value="comp_PaymentTerm.aspx" />
                            <iframe id="if_divcompany_5_detail" class="iframe"></iframe>
                            <div class="clear"></div>
                        </div>

                        <div class="comp-dtl-box clearfix" style="display: none;" id="divcompany_6_detail">
                            <div class="company-nmbr-hding">Invoice Template</div>
                            <input type="hidden" id="hid_divcompany_6_detail" value="comp_InvTemplate.aspx" />
                            <iframe id="if_divcompany_6_detail" class="iframe"></iframe>
                            <div class="clear"></div>
                        </div>

                        <div class="comp-dtl-box clearfix" style="display: none;" id="divcompany_7_detail">
                            <div class="dropdown-menu" id="divinstruction" style="background:#ffffff; width:300px; font-size:inherit;margin-top: 42px; padding:0px;">
                                <table class="tblsheet" width="100%">
                                    <tr class="gridheader" style="text-align: center;">
                                        <th colspan="2">Instructions :</th>
                                    </tr>
                                    <tr>
                                        <th>#CompanyName#
                                        </th>
                                        <td>Company Name
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>#ClientID# 
                                        </th>
                                        <td>Client ID
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>#ProjectID#
                                        </th>
                                        <td>Project ID
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>#ClientName# 
                                        </th>
                                        <td>Client Name
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>#ProjectName# 
                                        </th>
                                        <td>Project Name
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>#InvNo#
                                        </th>
                                        <td>Invoice No.

                                        </td>

                                    </tr>
                                    <tr>
                                        <th>#InvAmount#
                                        </th>
                                        <td>Invoice Amount

                                        </td>

                                    </tr>
                                    <tr>
                                        <th>#InvDueAmount#
                                        </th>
                                        <td>Invoice Due Amount

                                        </td>

                                    </tr>
                                    <tr>
                                        <th>#InvDate#
                                        </th>
                                        <td>Invoice Date

                                        </td>

                                    </tr>


                                </table>
                            </div>
                            <div class="company-nmbr-hding">
                                Invoice Email Template
                                <a class="f_right" id="showinvoiceEmailHelp">
                                    <img src="images/help-icon.png" /></a>

                            </div>

                            <input type="hidden" id="hid_divcompany_7_detail" value="comp_InvEmailTemplate.aspx" />
                            <iframe id="if_divcompany_7_detail" class="iframe"></iframe>
                            <div class="clear"></div>
                        </div>
                        <div class="comp-dtl-box clearfix" style="display: none;" id="divcompany_8_detail">
                            <div class="company-nmbr-hding">Scheduling Email</div>
                            <input type="hidden" id="hid_divcompany_8_detail" value="comp_ScheduleEmail.aspx" />
                            <iframe id="if_divcompany_8_detail" class="iframe"></iframe>
                            <div class="clear"></div>
                        </div>
                        <div class="comp-dtl-box clearfix" style="display: none;" id="divcompany_9_detail">
                            <div class="company-nmbr-hding">Leave Email</div>
                            <input type="hidden" id="hid_divcompany_9_detail" value="comp_LeaveEmail.aspx" />
                            <iframe id="if_divcompany_9_detail" class="iframe"></iframe>
                            <div class="clear"></div>
                        </div>

                        <div class="comp-dtl-box clearfix" style="display: none;" id="divcompany_10_detail">
                            <div class="company-nmbr-hding">Attendance Reader Settings</div>
                            <input type="hidden" id="hid_divcompany_10_detail" value="comp_AttandanceReaderSettings.aspx" />
                            <iframe id="if_divcompany_10_detail" class="iframe"></iframe>
                            <div class="clear"></div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
