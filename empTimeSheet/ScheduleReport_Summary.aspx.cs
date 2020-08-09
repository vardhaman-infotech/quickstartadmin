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
    public partial class ScheduleReport_Summary : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();

        static DataSet dsexcel = new DataSet();
        excelexport objexcel = new excelexport();
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();

            if (!IsPostBack)
            {
                if(Session["usertype"].ToString()=="Admin")
                {
                    ViewState["add"] = "1";

                }
                else
                {
                    System.Data.DataSet ds = new System.Data.DataSet();
                    objda.id = Session["userid"].ToString();
                    ds = objda.getUserInRoles();


                    if (!objda.validatedRoles("16", ds))
                    {
                        Response.Redirect("UserDashboard.aspx");
                    }

                    if (objda.validatedRoles("16", ds))
                    {
                        ViewState["add"] = "1";

                    }
                    else
                    {
                        ViewState["add"] = null;

                    }
               

                }
                
                fillyear();
               // dropfrommonth.Text = System.DateTime.Now.AddMonths(-2).ToString();
               // droptomonth.Text = System.DateTime.Now.AddMonths(3).ToString();
                searchdata();

            }
        }
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
        /// Fill Projects drop down for seraching
        /// </summary>
      

        /// <summary>
        /// Move to clicked page number
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
      

        /// <summary>
        /// Paging- Go to previous page
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
      

        /// <summary>
        /// Paging- Move to next page
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
       
      

        /// <summary>
        /// Fill list of existing clients For Search
        /// </summary>
   


        /// <summary>
        /// fiil List of Employee For Search
        /// </summary>
    
        protected void btnrefresh_Click(object sender, EventArgs e)
        {
            fillgrid();
        }
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            searchdata();

        }
        protected void searchdata()
        {
            string year = dropyear.Text;
            if (dropfrommonth.Text != "")
            {
                DateTime dtFrom = new DateTime(DateTime.Now.Year, Convert.ToInt32(dropfrommonth.Text), 1);
                dtFrom = dtFrom.AddDays(-(dtFrom.Day - 1));
                txtfrmdate.Value = dtFrom.ToString("MM/dd/yyyy");
            }
            else
            {
                txtfrmdate.Value = "01/01/" + year;
            }
            if (droptomonth.Text != "")
            {
                DateTime dtTo = new DateTime(DateTime.Now.Year, Convert.ToInt32(droptomonth.Text), 1);
                dtTo = dtTo.AddMonths(1);
                dtTo = dtTo.AddDays(-(dtTo.Day));
                txttodate.Value = dtTo.ToString("MM/dd/yyyy");
            }
            else
            {
                txttodate.Value = "12/31/" + year;
            }

            fillgrid();
        }

        //Fill Grid View from Database
        public void fillgrid()
        {
            objts.nid = "";
            objts.action = "selectdetail";
            objts.companyId = Session["companyid"].ToString();
            objts.from = txtfrmdate.Value;
            objts.to = txttodate.Value;
            objts.remark = "";
            objts.Status = dropsearchscheduletype.Text;
            ds = objts.schedule();
          
            if (ds.Tables[0].Rows.Count > 0)
            {
                divdata.InnerHtml = ds.Tables[0].Rows[0][0].ToString();
               
                btnexportcsv.Enabled = true;
              
                divnodata.Visible = false;

            }
            else
            {
                btnexportcsv.Enabled = false;
                divdata.InnerHtml = "";
                if (IsPostBack)
                    divnodata.Visible = true;
            }
            Session["TaskTable"] = ds;
            dsexcel = ds;

            ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>fixSchedule();</script>", false);
        }

        #region Export
        protected string bindheader(string type)
        {

            string str = "";
            string Companyname = Session["companyname"].ToString();
            string companyaddress = Session["companyaddress"].ToString();
            string client = " ", employee = " ", task = " ", date = " ";
            
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
                   Schedule Report
                </h4>
            </td>
        </tr>";
        

      

            return str;


        }
        protected void btnexportcsv_Click(object sender, EventArgs e)
        {

            objts.nid = "";
            objts.action = "selectdetail";
            objts.companyId = Session["companyid"].ToString();
            objts.from = txtfrmdate.Value;
            objts.to = txttodate.Value;
            objts.Status = dropsearchscheduletype.Text;
            objts.remark = "excel";
            ds = objts.schedule();

            string rpthtml ="";
            if (ds.Tables[0].Rows.Count > 0)
            {
                rpthtml = ds.Tables[0].Rows[0]["description"].ToString();
            }

            HtmlGenericControl divgen = new HtmlGenericControl();


            divgen.InnerHtml = rpthtml;
            HttpResponse response = HttpContext.Current.Response;

            // first let's clean up the response.object   
            response.Clear();
            response.Charset = "";

            // set the response mime type for excel   
            response.ContentType = "application/vnd.ms-excel";
            response.AddHeader("Content-Disposition", "attachment;filename=\"ScheduleReport.xls\"");

            // create a string writer   
            using (StringWriter sw = new StringWriter())
            {
                using (HtmlTextWriter htw = new HtmlTextWriter(sw))
                {
                    System.Web.UI.HtmlControls.HtmlGenericControl dv = new System.Web.UI.HtmlControls.HtmlGenericControl();
                    dv.InnerHtml = divgen.InnerHtml.Replace("border='0'", "border='1'");
                    dv.InnerHtml = divgen.InnerHtml.Replace("border=0", "border='1'");
                    //dv.InnerHtml = dv.InnerHtml.Replace("<tr><td colspan='6'><hr style='width:100%;' /></td>", "");

                    dv.RenderControl(htw);
                    response.Write(sw.ToString());
                    response.End();
                }
            }


        }
        #endregion

        #region SORTING


        /// <summary>
        /// List sorting on a specified SortExpression in Design view
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
      


        /// <summary>
        /// Get current sort direction from ViewState[""SortDirection""], and return its reverse for sorting and again assign returned direction to ViewState[""SortDirection""] 
        /// </summary>
        /// <param name=""column""></param>
        /// <returns></returns>"
        private string GetSortDirection(string column)
        {

            string sortDirection = "DESC";


            // Retrieve the last column that was sorted.
            string sortExpression = ViewState["SortExpression"] as string;

            if (sortExpression != null)
            {
                // Check if the same column is being sorted.
                // Otherwise, the default value can be returned.
                if (sortExpression == column)
                {
                    string lastDirection = ViewState["SortDirection"] as string;
                    if ((lastDirection != null) && (lastDirection == "ASC"))
                    {
                        sortDirection = "DESC";
                    }
                    if ((lastDirection != null) && (lastDirection == "DESC"))
                    {
                        sortDirection = "ASC";
                    }
                }
            }

            // Save new values in ViewState.
            ViewState["SortDirection"] = sortDirection;
            ViewState["SortExpression"] = column;

            return sortDirection;
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
    }
}