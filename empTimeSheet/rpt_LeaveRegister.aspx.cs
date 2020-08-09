using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.UI.HtmlControls;
using System.IO;
using System.Collections;

namespace empTimeSheet
{
    public partial class LeaveReport : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsPayroll objpayroll = new ClsPayroll();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();

        static DataSet dsexcel = new DataSet();
        excelexport objexcel = new excelexport();
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();

            if (!IsPostBack)
            {
                if (!objda.checkUserInroles("22"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }

                //if (objda.validatedRoles("22", ds))
                //{
                //    ViewState["add"] = "1";

                //}
                //else
                //{
                //    ViewState["add"] = null;

                //}

                fillyear();
                dropmonth.Text = System.DateTime.Now.Month.ToString();
                searchdata();




            }
        }
        /// <summary>
        /// Fill year drop down for searching
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



        /// <summary>
        /// fiil List of Leaves For Searched parameters
        /// </summary>

        protected void btnrefresh_Click(object sender, EventArgs e)
        {
            fillgrid();
            ScriptManager.RegisterStartupScript(this, GetType(), "temp", "<script>showhidemonth('" + dropReportType.Text + "');</script>", false);
        }
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            searchdata();

        }
        protected void searchdata()
        {
            hidyear.Value = dropyear.Text;
            hidmonth.Value = dropmonth.Text;
            hidreportype.Value = dropReportType.Text;
          
            fillgrid();
          
        }
        //Fill Grid View from Database
        public void fillgrid()
        {
            objpayroll.nid = "";
            objpayroll.action = "getreport";
            objpayroll.companyid = Session["companyid"].ToString();
            objpayroll.Leavetypeid = hidreportype.Value;
            //NOTE: here we are using "Date" param to pass "Month" and "NumOfDays" to pass "Year"
            objpayroll.RequestDate = hidmonth.Value;
            objpayroll.NumofDays = hidyear.Value;
            objpayroll.Status = "";

            ds = objpayroll.LeaveRequest();
          
            if (ds.Tables[0].Rows.Count > 0)
            {
                divdata.InnerHtml = ds.Tables[0].Rows[0][0].ToString();
               
                btnexportcsv.Enabled = true;
                divdata.Visible = true;
                divnodata.Visible = false;

            }
            else
            {
                btnexportcsv.Enabled = false;
               
                divdata.Visible = false;
                if (IsPostBack)
                    divnodata.Visible = true;
            }
            ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>showhidemonth('" + dropReportType.Text + "');fixSchedule();</script>", false);
            dsexcel = ds;
           
        }

        #region Export
        protected string bindheader(string type)
        {

            string str = "";
            string Companyname = Session["companyname"].ToString();
            string companyaddress = Session["companyaddress"].ToString();

            string headerstr = "<table width='100%'>";
            if (type == "excel")
            {
                headerstr = "<table width='100%'>";

            }

            str = headerstr +
        @"<tr>
            <td colspan='" + dsexcel.Tables[0].Columns.Count.ToString() + @"' align='center'>
                <h2 style='text-align:left;color:#395ba4;'>
                   " + Companyname + @"
                </h2>
            </td>
        </tr>
<tr>
            <td colspan='" + dsexcel.Tables[0].Columns.Count.ToString() + @"' align='center'>
                <h4 style='text-align:left;color:#395ba4;'>
                   " + companyaddress + @"
                </h4>
            </td>
        </tr>
        <tr>
            <td  align='center'>
                <h4  style='text-align:center;color:#395ba4;'>
                   Leave Report
                </h4>
            </td>
        </tr>";




            return str;


        }
        protected void btnexportcsv_Click(object sender, EventArgs e)
        {

            objpayroll.nid = "";
            objpayroll.action = "getreport";
            objpayroll.companyid = Session["companyid"].ToString();
            objpayroll.Leavetypeid = hidreportype.Value;
            //NOTE: here we are using "Date" param to pass "Month" and "NumOfDays" to pass "Year"
            objpayroll.RequestDate = hidmonth.Value;
            objpayroll.NumofDays = hidyear.Value;
            objpayroll.Status = "Excel";

            ds = objpayroll.LeaveRequest();

            string rpthtml = "";
            if (ds.Tables[0].Rows.Count > 0)
            {
                rpthtml = ds.Tables[0].Rows[0]["description"].ToString();
            }
            string rptname = "LeaveReport.xls";

            if (hidreportype.Value == "Monthly Report")
            {
                rptname = "LeaveMonthlyReport-" + hidmonth.Value + "-" + hidyear.Value;
            }
            else
            {
                rptname = "LeaveYearlyReport-" + hidyear.Value;

            }
            HtmlGenericControl divgen = new HtmlGenericControl();


            divgen.InnerHtml = rpthtml;
            HttpResponse response = HttpContext.Current.Response;

            // first let's clean up the response.object   
            response.Clear();
            response.Charset = "";

            // set the response mime type for excel   
            response.ContentType = "application/vnd.ms-excel";
            response.AddHeader("Content-Disposition", "attachment;filename=\"LeaveReport.xls\"");

            // create a string writer   
            using (StringWriter sw = new StringWriter())
            {
                using (HtmlTextWriter htw = new HtmlTextWriter(sw))
                {
                    System.Web.UI.HtmlControls.HtmlGenericControl dv = new System.Web.UI.HtmlControls.HtmlGenericControl();
                    dv.InnerHtml = divgen.InnerHtml.Replace("border='0'", "border='1'");
                    //dv.InnerHtml = dv.InnerHtml.Replace("<tr><td colspan='6'><hr style='width:100%;' /></td>", "");

                    dv.RenderControl(htw);
                    response.Write(sw.ToString());
                    response.End();
                }
            }


        }
        #endregion


        protected void dgnews_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Display the company name in italics.
                foreach (TableCell column in e.Row.Cells)
                {
                    column.Text = Server.HtmlDecode(column.Text);
                }

            }
        }
        protected void dgnews_RowCommand(object sender, GridViewCommandEventArgs e)
        {

        }
    }
}