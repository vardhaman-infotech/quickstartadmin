using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.UI.HtmlControls;
using System.IO;

namespace empTimeSheet
{
    public partial class BudgetedReport : System.Web.UI.Page
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
            if (!Page.IsPostBack)
            {

                if (!objda.checkUserInroles("43"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
                filldepartment();
                searchdata();
            }
        }


        /// <summary>
        /// Fill deprtment's dropdown
        /// </summary>

        public void filldepartment()
        {
            objda.id = "";
            objda.name = "";
            objda.company = Session["companyid"].ToString();
            objda.action = "select";
            ds = objda.department();

            dropdeptsearch.DataSource = ds;
            dropdeptsearch.DataTextField = "department";
            dropdeptsearch.DataValueField = "nid";
            dropdeptsearch.DataBind();

            ListItem li = new ListItem("--All Department--", "");

            dropdeptsearch.Items.Insert(0, li);
            dropdeptsearch.SelectedIndex = 0;
        }
        protected void searchdata()
        {
            hiddeptid.Value = dropdeptsearch.Text;
            hiddeptname.Value = dropdeptsearch.SelectedItem.Text;
            fillgrid();
        }


        protected void fillgrid()
        {
            Session["TaskTable"] = null;
            objts.deptID = hiddeptid.Value;
            objts.companyId = Session["companyid"].ToString();
            objts.action = "getbudgetedreport";
            objts.keyword = "";

            ds = objts.GetBudgetedReport();

            int start = dgnews.PageSize * dgnews.PageIndex;
            int end = start + dgnews.PageSize;
            start = start + 1;
            if (end >= ds.Tables[0].Rows.Count)
                end = ds.Tables[0].Rows.Count;
            lblstart.Text = start.ToString();
            lblend.Text = end.ToString();
            lbltotalrecord.Text = ds.Tables[0].Rows.Count.ToString();

            if (ds.Tables[0].Rows.Count > 0)
            {
                Session["TaskTable"] = ds.Tables[0];
                dgnews.DataSource = ds;
                dgnews.DataBind();
                btnexportcsv.Enabled = true;

                divnodata.Visible = false;
                dgnews.Visible = true;
                lnkprevious.Enabled = true;
                lnknext.Enabled = true;
                if (lbltotalrecord.Text == lblend.Text)
                {
                    lnknext.Enabled = false;
                }
                if (lblstart.Text == "1")
                {
                    lnkprevious.Enabled = false;
                }

            }
            else
            {
                lblstart.Text = "0";
                lnkprevious.Enabled = false;
                lnknext.Enabled = false;
                //  btnexportcsv.Enabled = false;
                if (IsPostBack)
                {
                    divnodata.Visible = true;
                }
                dgnews.Visible = false;

                Session["TaskTable"] = null;
            }
            updatePanelData.Update();
            dsexcel = ds;
        }

        /// <summary>
        /// Paging- Go to previous page
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void lnkprevious_Click(object sender, EventArgs e)
        {
            if (dgnews.PageIndex > 0)
            {
                dgnews.PageIndex = dgnews.PageIndex - 1;
                fillgrid();
            }
        }

        /// <summary>
        /// Paging- Move to next page
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void lnknext_Click(object sender, EventArgs e)
        {
            if (int.Parse(lbltotalrecord.Text) > int.Parse(lblend.Text))
            {
                dgnews.PageIndex = dgnews.PageIndex + 1;
                fillgrid();
            }
        }

        /// <summary>
        /// Move to clicked page number
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dgnews_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            dgnews.PageIndex = e.NewPageIndex;
            fillgrid();
            ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>scrolltotopofList();</script>", false);
        }
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            searchdata();

        }
        protected void btnrefresh_Click(object sender, EventArgs e)
        {
            fillgrid();
        }

        #region Export
        protected string bindheader(string type)
        {
            string str = "";
            string Companyname = Session["companyname"].ToString();
            string companyaddress = Session["companyaddress"].ToString();
            string dept = "<b>Budget ID:</b>";

            if (hiddeptid.Value == "")
            {
                dept += "All";
            }
            else
            {
                dept += hiddeptname.Value;
            }


            string headerstr = "<table width='100%'>";
            if (type == "excel")
            {
                headerstr = "<table width='100%'>";

            }

            str = headerstr +
        @"<tr>
            <td colspan='7' align='left'>
                <h2>
                   " + Companyname + @"
                </h2>
            </td>
        </tr>
<tr>
            <td colspan='7' align='left'>
                <h4>
                   " + companyaddress + @"
                </h4>
            </td>
        </tr>
        <tr>
            <td colspan='7' align='left'>
                <h4>
                    Budgeted Task Report
                </h4>
            </td>
        </tr>
        <tr>
            <td colspan='7'>
                &nbsp;
            </td>
        </tr>
       
        <tr>
        <td colspan='7'>
        " + dept + "<br/>" +



       @"</td>

        </tr>
       <tr>
        <td colspan='7'>&nbsp;</td></tr>
       </table><table width='100%' cellpadding='5' cellspacing='0' style='font-family: Calibri;
                        font-size: 12px; text-align: left;' border='1'>
                       
                         
  <tr style='font-weight: bold; background: #395ba4; color: #ffffff;'>
 <td>S.No.</td>
 <td>Act ID</td>
<td>Description</td>
 <td>Hours/Units</td>
 <td>Rate</td>
 <td>Tax</td>
 <td>Amount</td>
                                                            
</tr>";
            return str;


        }
        protected void btnexportcsv_Click(object sender, EventArgs e)
        {

            fillgrid();
            string rpthtml = bindheader("excel");
            for (int i = 0; i < dsexcel.Tables[0].Rows.Count; i++)
            {
                rpthtml = rpthtml + "<tr><td>" + Convert.ToString(i + 1) + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["taskcodename"].ToString() +
                    "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["description"].ToString() +
                    "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["Bhours"].ToString() + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["BillRate"].ToString() + "</td>" +
                   "<td>" + dsexcel.Tables[0].Rows[i]["tax"].ToString() + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["billamount"].ToString() +
                 "</td></tr>";

                //rpthtml = rpthtml + "<tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td<td>&nbsp;</td><td>&nbsp;</td>" + "<td>&nbsp;</td></td></tr>";
            }

            HtmlGenericControl divgen = new HtmlGenericControl();


            divgen.InnerHtml = rpthtml;
            HttpResponse response = HttpContext.Current.Response;

            // first let's clean up the response.object   
            response.Clear();
            response.Charset = "";

            // set the response mime type for excel   
            response.ContentType = "application/vnd.ms-excel";
            response.AddHeader("Content-Disposition", "attachment;filename=\"BudgetedTaskReport.xls\"");

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


        #region SORTING
        /// <summary>
        /// List sorting on a specified SortExpression in Design view
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dgnews_Sorting(object sender, GridViewSortEventArgs e)
        {

            //Retrieve the table from the session object.
            DataTable dt = Session["TaskTable"] as DataTable;

            if (dt != null)
            {
                //Sort the data.
                dt.DefaultView.Sort = e.SortExpression + " " + GetSortDirection(e.SortExpression);
                dgnews.DataSource = Session["TaskTable"];
                dgnews.DataBind();
                updatePanelData.Update();
            }

        }


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
    }
}