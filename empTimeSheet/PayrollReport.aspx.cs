using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Data;
using System.Web.UI.WebControls;
using System.Collections;
using System.IO;
using System.Web.UI.HtmlControls;
using System.Globalization;
namespace empTimeSheet
{
    public partial class PayrollReport : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        DataSet ds = new DataSet();
        ClsUser objuser = new ClsUser();
        GeneralMethod objgen = new GeneralMethod();
        ClsPayroll objpayroll = new ClsPayroll();
        DataSet dsexcel = new DataSet();
        excelexport objexcel = new excelexport();
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                //Role 21 indicates 
                if (objda.checkUserInroles("21"))
                {
                    ViewState["isadmin"] = "1";
                }
                else
                {
                    ViewState["isadmin"] = null;
                }
                fillyear();
                fillemployee();
                int month = System.DateTime.Now.Month - 1;
                int year = System.DateTime.Now.Year;
                dropmonthfrom.Text = month.ToString();
                dropmonthto.Text = month.ToString();
                dropyear.Text = year.ToString();
                if (ViewState["isadmin"] != null && ViewState["isadmin"].ToString() == "1")
                {
                    multiview1.ActiveViewIndex = 0;
                }
                else
                {
                    hidmonthfrom.Value = dropmonthfrom.Text;
                    hidmonthto.Value = dropmonthto.Text;
                    hidyear.Value = dropyear.Text;
                    string currentmonth = System.DateTime.Now.Month.ToString();
                    string currentyear = System.DateTime.Now.Year.ToString();
                  
                    string startdate = currentmonth + "/" + "01/" + currentyear;
                    DateTime stdate = Convert.ToDateTime(startdate);
                    DateTime endate = stdate;

                    //Get last date of month
                    endate = endate.AddMonths(1);
                    endate = endate.AddDays(-(endate.Day));

                    txtfromdate.Text = stdate.ToString("MM/dd/yyyy");
                    txttodate.Text = endate.ToString("MM/dd/yyyy");

                    hidstartdate.Value = txtfromdate.Text;
                    hidenddate.Value = txttodate.Text;
                    hidemployeeid.Value = dropemployee.Text;
                
                    hidcurrentmode.Value = "empdetail";
                    multiview1.ActiveViewIndex = 1;
                    lbtnback.Visible = false;
                }
            }

        }
        protected void fillemployee()
        {
            if (ViewState["isadmin"] == null || ViewState["isadmin"].ToString() == "")
            {
                ListItem li = new ListItem(Session["username"].ToString(), Session["userid"].ToString());
                dropemployee.Items.Insert(0, li);
                dropemployee.SelectedIndex = 0;

            }
            else
            {
                objuser.action = "select";
                objuser.companyid = Session["companyid"].ToString();
                objuser.id = "";
                ds = objuser.ManageEmployee();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    dropemployee.DataTextField = "username";
                    dropemployee.DataValueField = "nid";
                    dropemployee.DataSource = ds;
                    dropemployee.DataBind();
                    ListItem li = new ListItem("--All Employees--", "");
                    dropemployee.Items.Insert(0, li);
                    dropemployee.SelectedIndex = 0;
                  
                }
            }
            hidemployeeid.Value = dropemployee.Text;
        }
        protected void fillgrid()
        {

            dgnews.DataSource = null;
            dgnews.DataBind();
            divnodata.Visible = true;

            objpayroll.month = hidmonthfrom.Value;
            objpayroll.monthto = hidmonthto.Value;
            objpayroll.year = hidyear.Value;
            objpayroll.companyid = Session["companyid"].ToString();
            objpayroll.action = "getsummary";
            ds = objpayroll.PayrollReport();

            if (ds.Tables[0].Rows.Count > 0)
            {
                dgnews.DataSource = ds.Tables[0];
                dgnews.DataBind();
                divnodata.Visible = false;

            }

            dsexcel = ds.Copy();

        }

        #region Payroll Summary
        /// <summary>
        /// Fill year
        /// </summary>
        protected void fillyear()
        {

            var al = new ArrayList();

            for (var i = System.DateTime.Now.Year; i >= 2013; i--)
            {
                al.Add(i);
            }
            dropyear.DataSource = al;
            dropyear.DataBind();
            dropyear.Text = System.DateTime.Now.Year.ToString();
        }

        protected void dgnews_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName.ToLower() == "viewdetail")
            {
                string[] arr = e.CommandArgument.ToString().Split(',');
                hidsalarymonth.Value = arr[0];
                hidsalaryyear.Value = arr[1];
                //Get First date of mnonth
                string startdate = arr[0] + "/" + "01/" + arr[1];
                DateTime stdate = Convert.ToDateTime(startdate);
                DateTime endate = stdate;

                //Get last date of month
                endate = endate.AddMonths(1);
                endate = endate.AddDays(-(endate.Day));

                txtfromdate.Text = stdate.ToString("MM/dd/yyyy");
                txttodate.Text = endate.ToString("MM/dd/yyyy");
                hidstartdate.Value = txtfromdate.Text;
                hidenddate.Value = txttodate.Text;
                hidemployeeid.Value = dropemployee.Text;
                fillemployeespayroll();
                hidcurrentmode.Value = "empdetail";
                multiview1.ActiveViewIndex = 1;
            }
        }


        /// <summary>
        /// When user click on
        /// show summary of payroll within selecetd month
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            hidmonthfrom.Value = dropmonthfrom.Text;
            hidmonthto.Value = dropmonthto.Text;
            hidyear.Value = dropyear.Text;
            fillgrid();
            multiview1.ActiveViewIndex = 0;
        }

        #endregion

        #region employee payroll
        protected void fillemployeespayroll()
        {
            dgemployee.DataSource = null;
            dgemployee.DataBind();
            divnoempdetail.Visible = true;

            objpayroll.month = hidsalarymonth.Value;
            objpayroll.year = hidsalaryyear.Value;
            objpayroll.startdate = hidstartdate.Value;
            objpayroll.enddate = hidenddate.Value;
            objpayroll.action = "getempwisepayroll";
            objpayroll.companyid = Session["companyid"].ToString();
            objpayroll.Empid = hidemployeeid.Value;
            ds = objpayroll.PayrollReport();
            if (ds.Tables[0].Rows.Count > 0)
            {
                dgemployee.DataSource = ds;
                dgemployee.DataBind();
                divnoempdetail.Visible = false;


            }
            dsexcel = ds.Copy();
        }

        protected void dgemployee_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName.ToLower() == "viewdetail")
            {
                hidSalarySlipEmpId.Value = e.CommandArgument.ToString();
                fillsalaryslip();
                hidcurrentmode.Value = "salaryslip";
                multiview1.ActiveViewIndex = 2;
            }
        }
        protected void btnsearchemp_Click(object sender, EventArgs e)
        {
            hidstartdate.Value = txtfromdate.Text;
            hidenddate.Value = txttodate.Text;
            hidemployeeid.Value = dropemployee.Text;
            fillemployeespayroll();
            multiview1.ActiveViewIndex = 1;
        }

        protected void btnback_Click(object sender, EventArgs e)
        {
            multiview1.ActiveViewIndex = 0;
            hidcurrentmode.Value = "summary";
        }

        #endregion

        #region PaySlip

        protected void fillsalaryslip()
        {
            divnosalaryslip.Visible = true;
         
            objpayroll.nid = hidSalarySlipEmpId.Value;
            objpayroll.action = "getemppayrolldetail";
            ds = objpayroll.PayrollReport();
            if (ds.Tables[0].Rows.Count > 0)
            {
                ltrmonthyear.Text = ds.Tables[0].Rows[0]["monthyear"].ToString();
                ltrloginid.Text = ds.Tables[0].Rows[0]["loginid"].ToString();

                ltrpayperiod.Text = ds.Tables[0].Rows[0]["startdate"].ToString() + "-" + ds.Tables[0].Rows[0]["enddate"].ToString();
                ltrjoinDate.Text = ds.Tables[0].Rows[0]["joinDate"].ToString();

                ltrempname.Text = ds.Tables[0].Rows[0]["empname"].ToString();
                ltremptotalworkingdays.Text = ds.Tables[0].Rows[0]["emptotalworkingdays"].ToString();
                ltrPFAccountNum.Text = ds.Tables[0].Rows[0]["PFAccountNum"].ToString();
                ltrdepartment.Text = ds.Tables[0].Rows[0]["department"].ToString();
                ltrpaidleaves.Text = ds.Tables[0].Rows[0]["paidleaves"].ToString();
                ltrBankName.Text = ds.Tables[0].Rows[0]["BankName"].ToString();

                ltrdesignation.Text = ds.Tables[0].Rows[0]["designation"].ToString();

                ltrunpaidleaves.Text = ds.Tables[0].Rows[0]["unpaidleaves"].ToString();
                ltrAccountNum.Text = ds.Tables[0].Rows[0]["AccountNum"].ToString();
                ltrpayabledays.Text = ds.Tables[0].Rows[0]["payabledays"].ToString();
                ltrpaymentstatus.Text = ds.Tables[0].Rows[0]["paymentstatus"].ToString();


                ltrtotaldeduction.Text = ds.Tables[0].Rows[0]["totaldeduction"].ToString();
                //ltrNetPayment.Text = ds.Tables[0].Rows[0]["NetPayment"].ToString();
                ltrbonus.Text = ds.Tables[0].Rows[0]["bonus"].ToString();
                ltrtotalamount.Text = ds.Tables[0].Rows[0]["totalamount"].ToString();

                ltrgenerationdate.Text = ds.Tables[0].Rows[0]["generationdate"].ToString();

                ltrbasicsalary.Text = ds.Tables[0].Rows[0]["basicsalary"].ToString();

                ltrtotalearnings.Text = (Convert.ToDecimal(ds.Tables[0].Rows[0]["totalearnings"].ToString()) + Convert.ToDecimal(ds.Tables[0].Rows[0]["bonus"].ToString())).ToString();

                divnosalaryslip.Visible = false;
            }

            if (ds.Tables[1].Rows.Count > 0)
            {
               
                string myearnings = "";
                for (int i = 0; i < ds.Tables[1].Rows.Count; i++)
                {

                    myearnings = myearnings + @"<tr>
                                <td style='font-weight: lighter; border-bottom: solid 1px #a7a7a7; border-right: solid 1px #a7a7a7;
                                    padding: 5px; font-weight: bold;'>"
                                    + ds.Tables[1].Rows[i]["title"].ToString() +
                                 @"</td>
                                <td style='font-weight: lighter; padding: 5px; border-bottom: solid 1px #a7a7a7;
                                    border-right: solid 1px #a7a7a7;'>"
                                    + ds.Tables[1].Rows[i]["amount"].ToString();
                    if (i != ds.Tables[1].Rows.Count - 1)
                    {
                        myearnings = myearnings + "</td></tr>";
                    }


                }
                ltrearnings.Text = myearnings;
            }

            if (ds.Tables[2].Rows.Count > 0)
            {

                string mydeduction = "";
                for (int i = 0; i < ds.Tables[2].Rows.Count; i++)
                {
                    mydeduction = mydeduction + @"<tr>
                                <td style='font-weight: lighter; border-bottom: solid 1px #a7a7a7; border-right: solid 1px #a7a7a7;
                                    padding: 5px; font-weight: bold;'>"
                                    + ds.Tables[2].Rows[i]["title"].ToString() +
                                 @"</td>
                                <td style='font-weight: lighter; padding: 5px; border-bottom: solid 1px #a7a7a7;
                                    border-right: solid 1px #a7a7a7;'>"
                                    + ds.Tables[2].Rows[i]["amount"].ToString();
                    if (i != ds.Tables[2].Rows.Count - 1)
                    {
                        mydeduction = mydeduction + "</td></tr>";
                    }


                }
                ltrdeduction.Text = mydeduction;
            }
        }

        protected void lbtnbacktoleavel2_Click(object sender, EventArgs e)
        {
            multiview1.ActiveViewIndex = 1;
            hidcurrentmode.Value = "empdetail";
        }
        protected void rptemppayslip_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                Repeater rptearnings = (Repeater)e.Item.FindControl("rptearnings");
                Repeater rptdeduction = (Repeater)e.Item.FindControl("rptdeduction");

            }
        }



        #endregion

        #region ExPORT to Exce
        protected string bindheader(string reportname, string colnum)
        {
            string str = "";
            string Companyname = Session["companyname"].ToString();
            string Year = "<b>Year:</b> ", Month = "<b>Month:</b> ";

            Year += hidyear.Value;

            string strMonthName = CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(Convert.ToInt32(hidmonthfrom.Value));

            Month += strMonthName;

            string headerstr = "<table width='100%'>";
            if (reportname == "excel")
            {
                headerstr = "<table width='100%'>";

            }

            str = headerstr +
        @"<tr>
                    <td  align='left' colspan='3'>
                        <h1>
                            " + Companyname + @"
                        </h1>
                    </td>
                </tr>
             
               <tr>
                <td colspan='3'>&nbsp;</td></tr>
              

                           <tr>
                                <td align='center' colspan='" + colnum + @"' >
                                    <h4>
                                        " + reportname + @"
                                    </h4>
                                </td>
                            </tr>
                            <tr>
                                <td colspan='" + colnum + @"'>
                                    &nbsp;
                                </td>
                            </tr>

                            <tr>
                            <td colspan='" + colnum + @"'>
                            " + Month + "<br/>" + Year + "<br/>" +

                   @"</td>
                    
                            </tr>
<tr><td colspan='" + colnum + @"'>&nbsp;</td></tr>
 </table>";

            return str;
        }
        protected void btnexportcsv_Click(object sender, EventArgs e)
        {
            string rpthtml = "";
            string reportname = "";
            if (hidcurrentmode.Value == "salaryslip")
            {
                fillsalaryslip();
                reportname = "HCLLPPaySlip";
                rpthtml = bindheader("", "6");

                StringWriter sw = new StringWriter();
                Control ctrl = divsalaryslip;
                              HtmlTextWriter hw = new HtmlTextWriter(sw);

                ctrl.RenderControl(hw);

                StringReader sr = new StringReader(sw.ToString());
             
                rpthtml = rpthtml + sw.ToString();
            }
            else if (hidcurrentmode.Value == "summary")
            {
                reportname = "HCLLPayrollSummary";
                fillgrid();
                rpthtml = bindheader("Payroll Summary Report", "10");

                rpthtml = rpthtml + @"<table align='left' cellpadding='5' width='100%' cellspacing='0' style='font-family: Calibri;
                        font-size: 12px; text-align: left;' border='0'><tr style='font-weight: bold; background: #395ba4; color: #ffffff;'>
<td style='width=38px;'width='100px'>S.No</td>
 <td>Month</td>
 <td>Total Employees</td>
<td>Total Salary</td>
<td>Total Earnings</td>
 <td>Total Deduction</td>
<td>Total Bonus</td>
<td>Gross Payment</td>
<td>Net Payment</td>
                                                                     
</tr>";
                for (int i = 0; i < dsexcel.Tables[0].Rows.Count; i++)
                {
                    rpthtml = rpthtml + "<tr><td>" + Convert.ToString(i + 1) + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["monthyear"].ToString() +
                        "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["totalemployee"].ToString() +

                         "</td><td>" + dsexcel.Tables[0].Rows[i]["totalsalary"].ToString() +
                          "</td><td>" + dsexcel.Tables[0].Rows[i]["totalearnings"].ToString() +
                          "</td><td>" + dsexcel.Tables[0].Rows[i]["totaldeduction"].ToString() +
                                  "</td><td>" + dsexcel.Tables[0].Rows[i]["totalbonus"].ToString() +
                                     "</td><td>" + dsexcel.Tables[0].Rows[i]["totalgrosspayment"].ToString() +
                                        "</td><td>" + dsexcel.Tables[0].Rows[i]["NetPayableAmount"].ToString() +

                       "</td></tr>";
                }
                rpthtml = rpthtml + "</table>";
            }




            else if (hidcurrentmode.Value == "empdetail")
            {
                fillemployeespayroll();
                reportname = "HCLLPayrollDetailReport";
                rpthtml = bindheader("Payroll Detail Report", "14");

                rpthtml = rpthtml + @"<table align='left' cellpadding='5' width='100%' cellspacing='0' style='font-family: Calibri;
                        font-size: 12px; text-align: left;' border='0'><tr style='font-weight: bold; background: #395ba4; color: #ffffff;'>
<td style='width=38px;'width='100px'>S.No</td>
 <td>ID</td>
 <td>Employee</td>
<td>Start Date</td>
<td>End Date</td>
 <td>Total Salary</td>
<td>Total Earnings</td>
<td>Total Deduction</td>
<td>Bonus</td>
      <td>Gross Payment</td>  
   <td>Net Payment</td>    
 <td>Payment Status</td>     
<td>Payment Mode</td>  
<td>Check No.</td>                                                              
</tr>";
                for (int i = 0; i < dsexcel.Tables[0].Rows.Count; i++)
                {
                    rpthtml = rpthtml + "<tr><td>" + Convert.ToString(i + 1) + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["loginid"].ToString() +
                        "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["empname"].ToString() +
                        "<td>" + dsexcel.Tables[0].Rows[i]["startdate"].ToString() +
                         "</td><td>" + dsexcel.Tables[0].Rows[i]["enddate"].ToString() +
                            "</td><td>" + dsexcel.Tables[0].Rows[i]["totalsalary"].ToString() +
                               "</td><td>" + dsexcel.Tables[0].Rows[i]["totalearnings"].ToString() +
                                  "</td><td>" + dsexcel.Tables[0].Rows[i]["totaldeduction"].ToString() +
                                     "</td><td>" + dsexcel.Tables[0].Rows[i]["bonus"].ToString() +
                                        "</td><td>" + dsexcel.Tables[0].Rows[i]["NetPayment"].ToString() +
                                         "</td><td>" + dsexcel.Tables[0].Rows[i]["TotalAmount"].ToString() +
                                          "</td><td>" + dsexcel.Tables[0].Rows[i]["paymentstatus"].ToString() +
                                          "</td><td>" + dsexcel.Tables[0].Rows[i]["paymentmode"].ToString() +
                                          "</td><td>" + dsexcel.Tables[0].Rows[i]["checkno"].ToString() +

                       "</td></tr>";
                }
                rpthtml = rpthtml + "</table>";
            }


            HtmlGenericControl divgen = new HtmlGenericControl();

            divgen.InnerHtml = rpthtml;
            HttpResponse response = HttpContext.Current.Response;
            // first let's clean up the response.object   
            response.Clear();
            response.Charset = "";
            // set the response mime type for excel   

            response.ContentType = "application/vnd.ms-excel";
            response.AddHeader("Content-Disposition", "attachment;filename=\"" + reportname + ".xls\"");
            // create a string writer   
            using (StringWriter sw = new StringWriter())
            {
                using (HtmlTextWriter htw = new HtmlTextWriter(sw))
                {
                    System.Web.UI.HtmlControls.HtmlGenericControl dv = new System.Web.UI.HtmlControls.HtmlGenericControl();
                    dv.InnerHtml = divgen.InnerHtml.Replace("border='0'", "border='1'");

                    dv.RenderControl(htw);
                    response.Write(sw.ToString());
                    response.End();
                }
            }


        }
        protected void btnexportpdf_Click(object sender, EventArgs e)
        {
           //string rpthtml = bindheader("", "6");

            Session["ctrl"] = divsalaryslip;


            string url = "printpdf.aspx";
            string s = "window.open('" + url + "', '_blank');";

            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>" + s + "</script>", false);
        }
        #endregion
    }
}