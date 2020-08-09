<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="ManageEmployee.aspx.cs" Inherits="empTimeSheet.ManageEmployee" %>

<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="Stylesheet" href="css/tab_2.0.css" type="text/css" />

    <link rel="stylesheet" href="css/jquery.dataTables.min.css" />

    <script src="js/jquery.min.js"></script>
    <script type="text/javascript" src="js/jquery-ui.js"></script>
    <script type="text/javascript" src="js/jquery.dataTables.min.js"></script>
       <script src="js/jquery.table2excel.js"></script>
    <style type="text/css">
        .tabContents {
            overflow: inherit;
            height: auto;
            min-height: 430px;
        }

        .tabDetails {
            height: auto;
        }

        #divrolebox {
            width: 100%;
            border-bottom: solid 1px #e0e0e0;
            border-right: solid 1px #e0e0e0;
        }

            #divrolebox td {
                border-left: solid 1px #e0e0e0;
                border-top: solid 1px #e0e0e0;
                padding: 5px;
                vertical-align: text-top;
            }

        .roleBox {
            padding: 5px 0px;
        }

            .roleBox div {
                clear: both;
                padding: 5px 0px;
            }

                .roleBox div input {
                    margin-right: 5px;
                    float: left;
                }

                .roleBox div span {
                    display: block;
                    float: left;
                }

        .roleContainer {
            padding: 10px;
            border: solid 1px #e0e0e0;
            float: left;
        }

        .roleheader {
            margin-top: 10px;
        }
        .tblsheet td,th{
            padding:5px;
        }
         .tblsheet .form-control{
             width:100%;
             box-shadow:none;
         }
    </style>

    <script>
        

        $(document).ready(function () {

            // 1 Capitalize string - convert textbox user entered text to uppercase
            $('#txtempid').keyup(function () {
                $(this).val($(this).val().toUpperCase());
            });
        });

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <pg:progress ID="progress1" runat="server" />
    <div id="otherdiv_inftype" class="otherdiv" style="z-index: 1005;" onclick="closerolergoup();"></div>
    <div id="divaddrole" class="itempopup" style="width: 875px; display: none; z-index: 1006;">

        <div class="popup_heading">
            <span>Role Group</span>
            <div class="f_right">
                <img src="images/cross.png" onclick="closerolergoup();" alt="X" title="Close
            Window" />
            </div>
        </div>
        <div class="clear"></div>
        <div class="col-sm-12 col-xs-12" style="margin-top: 15px;">

            <div class="ctrlGroup" style="width: 100%;">
                <label class="lbl">
                    Role Group: *
                                                           

                </label>
                <div class="txt w1 mar10">
                    <select id="dropmasterrole" class="form-control"></select>
                 </div>
                <div class="txt w1">
                    <input type="text" id="txtmasterrolename" placeholder="Group Name" class="form-control" />
                </div>
                <div style="float: right;">
                    <input type="button" class="btn btn-primary" value="Save" id="btnsaveRole1" />
                    <input type="button" class="btn btn-default" value="Delete" id="btndeleterole" onclick="deleterolergoup();" />
                      <input type="button" class="btn btn-default" value="Close" id="btncloseinformation1" onclick="closerolergoup();" />
                </div>
            </div>

            <div class="clear"></div>
            <div style="margin-top: 5px; margin-bottom: 5px; width: 100%; height:350px;overflow:auto;">

                <table id="divrolebox">
                </table>






                <div class="clearfix"></div>
            </div>

            <div class="clearfix"></div>
            <div class="ctrl" style="text-align: right; margin-right: 0px;">

                <input type="button" class="btn btn-primary" value="Save" id="btnsaveRole" />  <input type="button" class="btn btn-default" value="Close" onclick="closerolergoup();" />

            </div>
        </div>
    </div>
    <div id="divaddInformation" class="itempopup" style="width: 650px; display: none; z-index: 1006;">
      


            <div class="popup_heading">
                <span id="headInfomationType">Role Group</span>
                <div class="f_right">
                    <img src="images/cross.png" onclick="closerolergoup();" alt="X" title="Close
            Window" />
                </div>
            </div>
            <div class="col-sm-12 col-xs-12" style="margin-top: 15px;">


                <table id="tblinftype" class="tblsheet" style="margin-bottom: 6px;">
                    <thead><tr class="gridheader">
                        <th id="thtypehead" colspan="2">
                            Departments
                        </th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                    <tfoot>
                        <tr>
                            <td colspan="2">
                                <div class="" style="text-align: right;">

                                      <a onclick="return addnewTyperow();"  style="text-decoration: underline;"><i class="fa fa-plus">&nbsp;</i>Add
                                                            New Item</a>
                                  
                                </div>
                            </td>
                        </tr>
                    </tfoot>
                </table>






                <div class="clearfix"></div>


                <div class="clearfix"></div>
                <div class="ctrl" style="text-align: right; margin-right: 0px;">

                    <input type="button" class="btn btn-primary" value="Save" id="btnSaveInformation" />
                    <input type="button" class="btn btn-default" value="Close" id="btncloseinformation" onclick="closerolergoup();" />
                </div>
            </div>
      
    </div>
    <div id="divaddnew" class="itempopup" style="width: 750px; display: none;">

        <div class="popup_heading">
            <span id="divtitle">Add Employee</span>
            <div class="f_right">
                <img src="images/cross.png" onclick="closediv();" alt="X" title="Close Window" />
            </div>
        </div>
        <div class="tabContaier" style="margin-top: 20px; margin-bottom: 20px;">
            <ul>
                <li><a id="lnktab1" class="active">General</a></li>
                <li><a id="lnktab2">Contact</a></li>
                <li><a id="lnktab3">Cost</a></li>

            </ul>
            <!-- //Tab buttons -->
            <div class="tabDetails">
                <div class="tabContents" id="lnktab1detail" style="display: block;">

                    <div class="ctrl">
                        <label class="col-sm-3 col-xs-12 lbl">
                            Employee ID:  *
                                                          
                        </label>
                        <div class="col-sm-3 col-xs-10">
                            <input id="txtempid" type="text" class="form-control" maxlength="6" />

                        </div>
                        
                        <label class="col-sm-2 col-xs-12 lbl ">
                            Password:  *
                        </label>
                        <div class="col-sm-3 col-xs-12">
                            <input id="txtpassword" type="password" class="form-control" maxlength="15" />

                        </div>
                    </div>
                    <div class="clear"></div>
                    <div class="ctrl">
                        <label class="col-sm-3 col-xs-12 lbl">First Name:  *</label>
                        <div class="col-sm-3 col-xs-12">
                            <input type="text" id="txtfname" class="form-control" />


                        </div>
                       
                        <label class="col-sm-2 col-xs-12 lbl ">
                            Last Name:  *
                        </label>
                        <div class="col-sm-3 col-xs-12">

                            <input type="text" id="txtlname" class="form-control" />
                        </div>
                    </div>
                    <div class="clear"></div>

                    <div class="ctrl">
                        <label class="col-sm-3 col-xs-12 lbl">
                            Enroll No:  *
                                                           
                        </label>
                        <div class="col-sm-3 col-xs-12">
                            <input id="txtenrollno" type="text" class="form-control" maxlength="6" />


                        </div>
                       
                        <label class="col-sm-2 col-xs-12 lbl ">
                            Date of Birth: 
                        </label>
                        <div class="col-sm-3 col-xs-12">
                            <input id="txtdob" type="text" class="form-control" />

                        </div>
                    </div>

                    <div class="clear"></div>


                    <div class="clear"></div>
                    <div class="ctrl" >
                        <label class="col-sm-3 col-xs-12 lbl">
                            Department:* 
                        </label>
                        <div class="col-sm-3 col-xs-12">
                            <select id="dropdepartment" onchange="opentype('dept',this.value)" class="form-control">
                            </select>
                           <%--  <a onclick="opentype('dept')" class="addnewtype" title="Add new department">
                                <img src="images/plus-icon.png" /></a>--%>
                        </div>
                       <label class="col-sm-2 col-xs-12 lbl ">
                            Designation:* 
                        </label>
                        <div class="col-sm-3 col-xs-12">

                            <select id="dropdesignation" onchange="opentype('desig',this.value)" class="form-control">
                            </select>
                             <%-- <a onclick="opentype('desig')" class="addnewtype" title="Add new designation">
                                <img src="images/plus-icon.png" /></a>--%>
                        </div>
                        

                    </div>
                    <div class="clear"></div>


                    <div class="ctrl" style="display:none;">

                         
                       
                        <label class="col-sm-2 col-xs-12 lbl">
                            Branch:  *
                        </label>
                        <div class="col-sm-3 col-xs-12">

                            <select id="dropbranch" class="form-control">
                            </select>
                        </div>
                       

                       
                        <label class="col-sm-2 col-xs-12 lbl ">
                            Timezone:  *
                        </label>
                        <div class="col-sm-3 col-xs-12">
                            <select id="droptimezone" class="form-control">
                            </select>
                        </div>

                    </div>

                    <div class="clear"></div>
                    <div class="ctrl">
                        <label class="col-sm-3 col-xs-12 lbl ">
                            Manager: *
                        </label>
                        <div class="col-sm-3 col-xs-12">

                            <select id="dropmanager" class="form-control">
                            </select>
                        </div>
                      
                        <label class="col-sm-2 col-xs-12 lbl ">
                            Submit to: *
                        </label>
                        <div class="col-sm-3 col-xs-12">

                            <select id="dropsubmitto" class="form-control">
                            </select>
                        </div>
                    </div>



                    <div class="clear"></div>


                    <div class="ctrl">
                        <label class="col-sm-3 col-xs-12 lbl ">
                            Email:  *
                        </label>
                        <div class="col-sm-3 col-xs-12">
                            <input id="txtcompanyemail" type="email" class="form-control" />
                        </div>
                      
                        <label class="col-sm-2 col-xs-12 lbl ">
                            Join Date:  *
                                                          
                        </label>
                        <div class="col-sm-3 col-xs-12">
                            <input id="txtjoin" type="text" class="form-control" />



                        </div>
                    </div>


                    <div class="clear"></div>

                    <div class="ctrl">
                        <label class="col-sm-3 col-xs-12 lbl ">
                            Employee Status:  *
                        </label>
                        <div class="col-sm-3 col-xs-12">

                            <select id="dropactive" onchange="empstatus(this)" class="form-control">
                                <option value="Active">Active</option>
                                <option value="Released">Released</option>
                                <option value="Block">Block</option>

                            </select>

                        </div>
                       
                        <label style="display:none;" class="col-sm-2 col-xs-12 lbl reldt">
                            Release Date:  
                                    
                        </label>
                        <div style="display:none;"  class="col-sm-3 col-xs-12 reldt">
                            <input id="txtrelived" type="text" class="form-control" />

                        </div>
                    </div>


                    <div class="clear"></div>

                    <div class="ctrl">
                        <label class="col-sm-3 col-xs-12 lbl ">
                            Login Type:  *
                        </label>
                        <div class="col-sm-3 col-xs-12">

                            <select id="droplogintype" class="form-control">
                                <option value="User">User</option>
                                <option value="Admin">Admin</option>

                            </select>

                        </div>
                       
                        <label class="col-sm-2 col-xs-12 lbl ">
                            Role Group:  *
                                    
                        </label>
                        <div class="col-sm-3 col-xs-12">
                            <select id="dropRoleGroup" onchange="openrolegroup(this.value)" class="form-control">
                            </select>
                           <%--   <a onclick="openrolegroup()" class="addnewtype" title="Add new role group">
                                <img src="images/plus-icon.png" /></a>--%>
                        </div>
                     
                    </div>
                     <div class="clear"></div>
                     <div class="ctrl">
                        <label class="col-sm-3 col-xs-12 lbl ">
                            Appointment:  *
                        </label>
                        <div class="col-sm-3 col-xs-12">
                            <span id=""><input type="checkbox" id="chekappointment" /></span>
                                                         
                        </div>
                       
                         
                     
                    </div>


                    <div class="clear"></div>


                </div>





                <div class="tabContents" id="lnktab2detail" style="display: none;">

                    <div class="ctrl">
                        <label class="col-sm-2 col-xs-12 lbl ">
                            Title: 
                        </label>
                        <div class="col-sm-9 col-xs-12">
                            <input id="txttitle" type="text" class="form-control" />

                        </div>
                    </div>
                    <div class="clear"></div>
                    <div class="ctrl">
                        <label class="col-sm-2 col-xs-12 lbl ">
                            Address: 
                        </label>
                        <div class="col-sm-9 col-xs-12">
                            <input id="txtstreet" type="text" class="form-control" />

                        </div>
                    </div>
                    <div class="clear"></div>
                    <div class="ctrl">
                        <label class="col-sm-2 col-xs-12 lbl ">
                            &nbsp;
                        </label>

                        <div class="col-sm-3 col-xs-12">
                            <input type="text" id="txtstate" class="form-control" placeholder="State" />
                        </div>
                        <div class="col-sm-3 col-xs-12">
                            <input type="text" id="txtcity" class="form-control" placeholder="City" />
                        </div>
                        <div class="col-sm-3 col-xs-12">
                            <input type="text" id="txtzip" class="form-control" placeholder="ZIP" />
                        </div>
                    </div>


                    <div class="clear"></div>

                    <div class="ctrl">
                        <label class="col-sm-2 col-xs-12 lbl ">
                            Email: 
                        </label>
                        <div class="col-sm-9 col-xs-12">
                            <input type="text" id="txtemail" class="form-control" />
                        </div>
                    </div>
                    <div class="clear"></div>
                    <div class="ctrl">
                        <label class="col-sm-2 col-xs-12 lbl ">
                            Contact #:
                        </label>
                        <div class="col-sm-3 col-xs-12">
                            <input type="text" id="txtcell" class="form-control" placeholder="Cell Phone" />
                        </div>
                        <div class="col-sm-3 col-xs-12">
                            <input type="text" id="txtphone" class="form-control" placeholder="Home Phone" />
                        </div>
                        <div class="col-sm-3 col-xs-12">
                            <input type="text" id="txtfax" class="form-control" placeholder="Fax" />
                        </div>
                    </div>

                    <div class="clear"></div>
                    <div class="ctrl">
                        <label class="col-sm-2 col-xs-12 lbl ">
                            Notes: 
                        </label>
                        <div class="col-sm-9 col-xs-12">
                            <textarea id="txtremark" class="form-control" style="height: 40px;">

                                    </textarea>

                        </div>
                    </div>
                </div>





                <div class="tabContents" id="lnktab3detail" style="display: none;">

                    <div class="ctrl">
                        <label class="col-sm-3 col-xs-12 lbl ">
                            Billing Rate: 
                        </label>
                        <div class="col-sm-2 col-xs-12">
                            <input type="text" id="txtbillrate" class="form-control" placeholder="0.00"
                                onkeypress="blockNonNumbers(this, event, true, false);"
                                onkeyup="extractNumber(this,2,false);" />

                        </div>
                        <label class="col-sm-3 col-xs-12 lbl lbl2">
                            Hourly Rate: 
                        </label>
                        <div class="col-sm-2 col-xs-12">
                            <input type="text" id="txtpayrate" class="form-control" placeholder="0.00"
                                onkeypress="blockNonNumbers(this, event, true, false);"
                                onkeyup="extractNumber(this,2,false);" />

                        </div>
                    </div>

                    <div class="clear"></div>
                    <div class="ctrl" style="display:none;">
                        <label class="col-sm-3 col-xs-12 lbl ">
                            Overtime Billing Rate: 
                        </label>
                        <div class="col-sm-2 col-xs-12">
                            <input type="text" id="txtovertimebill" class="form-control" placeholder="0.00"
                                onkeypress="blockNonNumbers(this, event, true, false);"
                                onkeyup="extractNumber(this,2,false);" />

                        </div>
                        <label class="col-sm-3 col-xs-12 lbl lbl2 ">
                            Overtime Rate: 
                        </label>
                        <div class="col-sm-2 col-xs-12">
                            <input type="text" id="txtovertimepayrate" class="form-control" placeholder="0.00"
                                onkeypress="blockNonNumbers(this, event, true, false);"
                                onkeyup="extractNumber(this,2,false);" />

                        </div>
                    </div>

                    <div class="clear"></div>
                    <div class="ctrl">
                        <label  style="display:none;" class="col-sm-3 col-xs-12 lbl ">
                            Overhead Multiplier: 
                        </label>
                        <div  style="display:none;" class="col-sm-2 col-xs-12">
                            <input type="text" id="txtoverhead" class="form-control" placeholder="1"
                                onkeypress="blockNonNumbers(this, event, true, false);"
                                onkeyup="extractNumber(this,1,false);" />

                        </div>
                         <label class="col-sm-3 col-xs-12 lbl ">
                            Currency: 
                        </label>
                        <div class="col-sm-2 col-xs-12">
                            <select id="dropcurrency" class="form-control">
                            </select>
                        </div>
                        <label class="col-sm-3 col-xs-12 lbl lbl2 " style="display:none;">
                            Amount: 
                        </label>
                        <div class="col-sm-2 col-xs-12" style="display:none;">
                            <input type="text" id="txtsalary" class="form-control" placeholder="0.00"
                                onkeypress="blockNonNumbers(this, event, true, false);"
                                onkeyup="extractNumber(this,2,false);" />


                        </div>
                        
                    </div>

                    <div class="clear"></div>
                    <div class="ctrl">
                       
                    </div>
                </div>
                <div class="clear">
                </div>

                <div class="ctrl">
                    <div style="text-align: right; margin: 10px 0px;">
                        <input type="button" id="btnsubmit" value="Save" class="btn btn-primary" />
                        <input type="button" id="btndelete" value="Delete" class="btn btn-default" />

                        <div class="clear">
                        </div>
                    </div>
                </div>
                <div class="clear">
                </div>
            </div>
        </div>
        <div class="clear"></div>
    </div>

    <div id="otherdiv" onclick="closediv();">
    </div>
    <div class="pageheader">
        <h2>
            <i class="fa  fa-user"></i>Employees
        </h2>
        <div class="breadcrumb-wrapper">
            <a id="btnexportcsv" class="right_link">
                <i class="fa fa-fw fa-file-excel-o topicon"></i>Export to Excel</a>

            <a id="liaddnew" class="right_link">
                <i class="fa fa-fw fa-plus topicon"></i>Add New </a>
        </div>
        <div class="clear">
        </div>
    </div>
    <div class="row">
        <div class="col-sm-12 col-md-12">
            <div class="panel panel-default">
                <div class="col-sm-12 col-md-10 mar">
                    <div class="ctrlGroup searchgroup">
                        <label class="lblAuto">
                            Emp ID/Name: 
                        </label>
                        <div class="txt w1 mar10">
                            <input type="text" class="form-control" id="txtsearch" />


                        </div>
                    </div>
                    <div class="ctrlGroup searchgroup">
                        <label class="lblAuto">
                            Department: 
                        </label>
                        <div class="txt w1 mar10">
                            <select id="dropsearchdept" class="form-control  pad3"></select>

                        </div>
                    </div>
                    <div class="ctrlGroup searchgroup">
                        <label class="lblAuto">
                            Status:
                        </label>
                        <div class="txt w1 mar10">
                            <select id="drostatus" class="form-control  pad3">
                                <option selected="selected" value="">--All--</option>
                                <option value="Active">Active</option>
                                <option value="Released">Released</option>
                                <option value="Block">Block</option>

                            </select>

                        </div>
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
                                    <table id="tbldata" class="tblreport">
                                        <thead>
                                          <tr>
                                                <th style="width: 100px;">Emp ID
                                            </th>
                                            <th>Emp Name
                                            </th>
                                             <th>Branch
                                            </th>
                                            <th>Department
                                            </th>
                                            <th>Designation
                                            </th>
                                              
                                            <th style="width: 90px;text-align: center;">Join Date
                                            </th>
                                            <th  style="width: 70px;text-align: center;">Status
                                            </th>
                                            <th style="width: 45px; text-align: center;">Edit
                                            </th>
                                               <th style="width: 60px; text-align: center;">Delete
                                            </th>
                                          </tr>

                                        </thead>
                                        <tbody>

                                        </tbody>

                                    </table>

                                      <div id="divdataloader" style="text-align: center;">
                    <img src="images/loading.gif" />
                </div>



                                </div>

                            </div>
                            <div  style="display:none;" id="temptbl"></div>
                        </div>
                    </div>
                </div>
                <div class="clear">
                </div>
            </div>
        </div>
    </div>
    <script src="js/PageJs/employeejs.js"></script>
    <script>
        function empstatus(e)
        {
            if ($(e).val() == "Released") {
                $(".reldt").show();
            } else {
                $(".reldt").hide();
            }
        }
        
        function deleterolergoup() {
            var args = { RoleGroupId: $("#dropmasterrole").val() };
            $.ajax({

                type: "POST",
                url: "ManageEmployee.aspx/deleterolegroup",
                data: JSON.stringify(args),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                cache: false,
                success: function (data) {
                    //Check length of returned data, if it is less than 0 it means there is some status available
                    if (JSON.parse(data.d)[0].msg != "") {
                        alert(JSON.parse(data.d)[0].msg);
                    }
                    fillroles();
                     
                }
            });
        }
    </script>
</asp:Content>
