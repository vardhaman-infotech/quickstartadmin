<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="sample.aspx.cs" Inherits="empTimeSheet.sample" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" type="text/css" href="css/manualInvoice.css" />
    <link rel="stylesheet" type="text/css" href="css/bootstrap_2.1.min.css" />

    <script>
        $(function () {

            $('.invc-tab-top a').click(function () {

                $('.invc-tab-top .active').removeClass('active'); // remove the class from the currently selected
                $(this).addClass('active'); // add the class to the newly clicked link

            });

        });

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="pageheader">
        <h2>
            <i class="fa fa-fw"></i>Manual Invoice
        </h2>
        <div class="breadcrumb-wrapper">
        </div>
        <div class="clear">
        </div>
    </div>

    <div class="contentpanel">
    <div class="row">
        <div class="col-sm-12 col-md-12">
            <div class="panel panel-default">
                <div class="left-invoice-box">
                    <div class="left-invoice-heading">client summary</div>
                    <div class="invoice-subhding">Vinay and Associates<p>Work-in-Progress (*billable only)</p></div>
                    <div class="invoice-txtbox clearfix">
                        <div class="invc-lft-txt">
                            <ul>
                                <li>Service Amt. :</li>
                                <li>Expense Amt. :</li>
                                <li>Sub Total :</li>

                            </ul></div>
                        <div class="invc-rht-txt">
                            <ul>
                                <li>$0.00*</li>
                                <li>$0.00*</li>
                                <li>$0.00*</li>

                            </ul></div>

                    </div>
                    <div class="invoice-txtbox clearfix">
                        <div class="invc-lft-txt">
                            <ul>
                                <li>Tax : </li>
                                <li>Tax % :</li>
                                <li>Tax Amount :</li>

                            </ul></div>
                        <div class="invc-rht-txt">
                            <ul>
                            <li>
                                <select class="form-control" id="ctl00_ContentPlaceHolder1_drostatus" name="ctl00$ContentPlaceHolder1$drostatus">
                                <option value="" selected="selected">--None--</option></select>
                            </li>
                                <li>$0.00*</li>
                                <li>$0.00*</li>

                            </ul></div>

                    </div>
                    <div class="invoice-txtbox clearfix">
                        <div class="invc-lft-txt">
                            <ul>
                                <li>Discount : </li>
                                <li>Retainer (C) :</li>
                                <li>Total :</li>

                            </ul></div>
                        <div class="invc-rht-txt">
                            <ul>
                            <li>
                                <input type="text" class="form-control" id="ctl00_ContentPlaceHolder1_txtsearch" name="ctl00$ContentPlaceHolder1$txtsearch" placeholder="0.00">
                            </li>
                                <li>$0.00*</li>
                                <li>$0.00*</li>

                            </ul></div>

                    </div>

                </div>

                <div class="right-invoice-box">
                    <div class="invc-tab-top">
                       <ul>
                          <li class="active"><span>1</span>Choose Project</li>
                           <li><span>2</span>Billing Address</li>
                           <li><span>3</span>Invoice Items</li>
                           <li><span>4</span>Finalize Invoice</li>

                       </ul>

                            </div>

                    <div class="invc-dtl-box clearfix">

                        <div class="ctrlGroup">
                                <label class="lbl">
                                    Employee ID :
                                                            <span style="color:Red;visibility:hidden;" class="validation" id="ctl00_ContentPlaceHolder1_RequiredFieldValidator1">*</span>
                                </label>
                                <div class="txt w2 mar10">
                                    <input type="text" class="form-control" id="ctl00_ContentPlaceHolder1_txtempid" name="ctl00$ContentPlaceHolder1$txtempid">
                                </div>
                            </div>
                        <div class="clear"></div>
                        <div class="invc-nmbr-hding">Invoice Number :</div>
                        <div class="ctrlGroup">
                                <label class="lbl">Prefix :<span style="color:Red;visibility:hidden;" class="validation" id="ctl00_ContentPlaceHolder1_RequiredFieldValidator1">*</span>
                                </label>
                                <div class="txt w1 mar10">
                                    <input type="text" class="form-control" id="ctl00_ContentPlaceHolder1_txtempid" name="ctl00$ContentPlaceHolder1$txtempid" disabled="disabled">
                                </div>
                            </div>
                        <div class="clear"></div>
                        <div class="ctrlGroup">
                                <label class="lbl">Suffix : <span style="color:Red;visibility:hidden;" class="validation" id="ctl00_ContentPlaceHolder1_RequiredFieldValidator1">*</span>
                                </label>
                                <div class="txt w1 mar10">
                                    <input type="text" class="form-control" id="ctl00_ContentPlaceHolder1_txtempid" name="ctl00$ContentPlaceHolder1$txtempid" disabled="disabled">
                                </div>
                            </div>
                        <div class="clear"></div>
                        <div class="ctrlGroup">
                                <label class="lbl">No :<span style="color:Red;visibility:hidden;" class="validation" id="ctl00_ContentPlaceHolder1_RequiredFieldValidator1">*</span>
                                </label>
                                <div class="txt w2 mar10">
                                    <input type="text" class="form-control" id="ctl00_ContentPlaceHolder1_txtempid" name="ctl00$ContentPlaceHolder1$txtempid">
                                </div>
                            </div>
                        
                    </div>

                    <div class="invc-dtl-box clearfix" style="display:none">
                        <div class="invc-nmbr-hding">Billing Address :</div>
                        <div class="ctrlGroup">
                                <label class="lbl">Client Name :<span style="color:Red;visibility:hidden;" class="validation" id="ctl00_ContentPlaceHolder1_RequiredFieldValidator1">*</span>
                                </label>
                                <div class="txt w2 mar10">
                                    <input type="text" class="form-control" id="ctl00_ContentPlaceHolder1_txtempid" name="ctl00$ContentPlaceHolder1$txtempid">
                                </div>
                            </div>
                        <div class="ctrlGroup">
                                <label class="lbl">Contact Person :<span style="color:Red;visibility:hidden;" class="validation" id="ctl00_ContentPlaceHolder1_RequiredFieldValidator1">*</span>
                                </label>
                                <div class="txt w2 mar10">
                                    <input type="text" class="form-control" id="ctl00_ContentPlaceHolder1_txtempid" name="ctl00$ContentPlaceHolder1$txtempid">
                                </div>
                            </div>
                        <div class="clear"></div>
                        <div class="ctrlGroup">
                                <label class="lbl">Address 1 :<span style="color:Red;visibility:hidden;" class="validation" id="ctl00_ContentPlaceHolder1_RequiredFieldValidator1">*</span>
                                </label>
                                <div class="txt w4 mar10">
                                    <input type="text" class="form-control" id="ctl00_ContentPlaceHolder1_txtempid" name="ctl00$ContentPlaceHolder1$txtempid">
                                </div>
                            </div>
                        <div class="clear"></div>
                        <div class="ctrlGroup">
                                <label class="lbl">Address 2 :<span style="color:Red;visibility:hidden;" class="validation" id="ctl00_ContentPlaceHolder1_RequiredFieldValidator1">*</span>
                                </label>
                                <div class="txt w4 mar10">
                                    <input type="text" class="form-control" id="ctl00_ContentPlaceHolder1_txtempid" name="ctl00$ContentPlaceHolder1$txtempid">
                                </div>
                            </div>
                        <div class="clear"></div>
                        <div class="ctrlGroup">
                                <label class="lbl">City :<span style="color:Red;visibility:hidden;" class="validation" id="ctl00_ContentPlaceHolder1_RequiredFieldValidator1">*</span>
                                </label>
                                <div class="txt w2 mar10">
                                    <input type="text" class="form-control" id="ctl00_ContentPlaceHolder1_txtempid" name="ctl00$ContentPlaceHolder1$txtempid">
                                </div>
                            </div>
                        <div class="ctrlGroup">
                                <label class="lbl">State :<span style="color:Red;visibility:hidden;" class="validation" id="ctl00_ContentPlaceHolder1_RequiredFieldValidator1">*</span>
                                </label>
                                <div class="txt w2 mar10">
                                    <input type="text" class="form-control" id="ctl00_ContentPlaceHolder1_txtempid" name="ctl00$ContentPlaceHolder1$txtempid">
                                </div>
                            </div>
                        
                        <div class="clear"></div>
                        <div class="ctrlGroup">
                                <label class="lbl">Country :<span style="color:Red;visibility:hidden;" class="validation" id="ctl00_ContentPlaceHolder1_RequiredFieldValidator1">*</span>
                                </label>
                                <div class="txt w2 mar10">
                                    <input type="text" class="form-control" id="ctl00_ContentPlaceHolder1_txtempid" name="ctl00$ContentPlaceHolder1$txtempid">
                                </div>
                            </div>
                        <div class="ctrlGroup">
                                <label class="lbl">ZIP :<span style="color:Red;visibility:hidden;" class="validation" id="ctl00_ContentPlaceHolder1_RequiredFieldValidator1">*</span>
                                </label>
                                <div class="txt w2 mar10">
                                    <input type="text" class="form-control" id="ctl00_ContentPlaceHolder1_txtempid" name="ctl00$ContentPlaceHolder1$txtempid">
                                </div>
                            </div>


                    </div>
                    <div class="clear"></div>

                    <div class="invc-dtl-box clearfix" style="display:none;">
                        <div class="invc-price-tag">$0.00</div>
                        <div class="clear"></div>
                        <div class="itm-hding-box clearfix">
                            <div class="itm-hding">Items</div>
                            <div class="des-hding">Description</div>
                            <div class="amt-hding">$ Amount</div>

                        </div>
                        <div class="clear"></div>
                        
                        <div class="clear"></div>
                        <div class="addnw-line-box">
                            <div class="itm-hding"><select onchange="bindtaskvalue(this.id,this.value);" class="form-control" id="ddltask_0">
                                                                <option value="" selected="selected"></option><option value="1141#0#Client - Entertainment#Expense">Exp:1 Client - Entertainment (Client - Entertainment)</option><option value="1355#0#Travel - Air Ticket#Expense">Exp:10 Travel - Air Ticket (Travel - Air Ticket)</option><option value="1356#1#Travel - Mileage#Expense">Exp:11 Travel - Mileage (Travel - Mileage)</option><option value="1357#1#Travel - Rental Car#Expense">Exp:12 Travel - Rental Car (Travel - Rental Car)</option><option value="1358#1#Travel - Rental Car Gas#Expense">Exp:13 Travel - Rental Car Gas (Travel - Rental Car Gas)</option><option value="1359#1#Travel - Taxicab/Shuttle#Expense">Exp:14 Travel - Taxicab/Shuttle (Travel - Taxicab/Shuttle)</option><option value="1360#1#CPE#Expense">Exp:15 CPE (CPE)</option><option value="1361#1#Bank confirmation-Comfirmation.com#Expense">Exp:16 Bank confirmation-Comfirmation.com (Bank confirmation-Comfirmation.com)</option><option value="1362#1#Expenses#Expense">Exp:17 Expenses (Expenses)</option><option value="1363#1#Cash payment on behalf of Client#Expense">Exp:18 Cash payment on behalf of Client (Cash payment on behalf of Client)</option><option value="1364#0#Travel - Company Car Gas#Expense">Exp:19 Travel - Company Car Gas (Travel - Company Car Gas)</option><option value="1142#1#Lodging -Hotel#Expense">Exp:2 Lodging -Hotel (Lodging -Hotel)</option><option value="1382#0#Travel: Gasoline used in business trip of a personal car#Expense">Exp:20 Travel: Gasoline used in business trip of a personal car (Travel: Gasoline used in business trip of a personal car)</option><option value="1378#1#Travel - Toll Charge#Expense">Exp:21 Travel - Toll Charge (Travel - Toll Charge)</option><option value="1384#0#Company Car Expenses#Expense">Exp:22 Company Car Expenses (Company Car Expenses)</option><option value="1348#1#Miscellaneous-I#Expense">Exp:3 Miscellaneous-I (Miscellaneous-I)</option><option value="1349#1#Miscellaneous-II#Expense">Exp:4 Miscellaneous-II (Miscellaneous-II)</option><option value="1350#1#Office Supplies#Expense">Exp:5 Office Supplies (Office Supplies)</option><option value="1351#1#Per Diem Allowance#Expense">Exp:6 Per Diem Allowance (Per Diem Allowance)</option><option value="1352#1#Postage &amp; Shipping#Expense">Exp:7 Postage &amp; Shipping (Postage &amp; Shipping)</option><option value="1353#1#Telephone- Business#Expense">Exp:8 Telephone- Business (Telephone- Business)</option><option value="1354#1#Travel -  Parking#Expense">Exp:9 Travel -  Parking (Travel -  Parking)</option>
                                                            </select></div>
                            <div class="des-hding"><textarea onkeydown="checkTextAreaMaxLength(this,event,'5000');" style="height: 27px;" class="form-control" id="txtdesc_0"></textarea></div>
                            <div class="amt-hding"><input type="text" onkeyup="extractNumber(this,2,true);" onblur="fill(this.id);" onkeypress="blockNonNumbers(this, event, true, true);" class="form-control" id="txtrate_0"></div>

                        </div>
                        <div class="add-new-txt">+ Add More Lines</div>

                    </div>

                    <div class="clear"></div>
                    <div class="invc-dtl-box clearfix" style="display:none;">
                        <textarea onkeydown="checkTextAreaMaxLength(this,event,'5000');" style="height: 50px;" class="form-control" id="txtdesc_0"></textarea>

                        <div style="margin-bottom: 20px; margin-top: 15px;" class="clear">
                                                
                                                <input type="button" style="margin-right: 5px;" onclick="validate('generated');" value="Save &amp; Generate Invoice" class="btn btn-primary f_left" id="ctl00_ContentPlaceHolder1_btnsubmit" name="ctl00$ContentPlaceHolder1$btnsubmit">
                                                <input type="button" style="margin-right: 5px; display: none;" onclick="return location.href = 'InvoiceReview.aspx'" value="Cancel" class="btn btn-primary f_left" id="btncancel">
                                                <input type="button" style="margin-right: 5px; display: block;" onclick="return location.href = 'ManualInvoice.aspx'" value="Reset" class="btn btn-primary f_left" id="btnreset">
                                            </div>
                    </div>

                    <div class="invc-btom-bar">
                        <div class="ttl-amt">Total Amount</div>
                        <div class="invc-amt">$0.00</div>

                    </div>
                    <div class="clear"></div>
                    <div class="invc-btn-box">
                        <div class="blue-btn"><a href="#">Back</a></div>
                        <div class="blue-btn"><a href="#">Cancel</a></div>
                        <div class="green-btn"><a href="#">Next</a></div>

                    </div>
                </div>
            </div>
        </div>
    </div></div>
</asp:Content>
