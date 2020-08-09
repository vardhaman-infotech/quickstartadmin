using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.IO;
using System.Data;


namespace empTimeSheet
{
    public partial class ProjectAllocationReport : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();
        DataSet dsexcel = new DataSet();
        protected void Page_Load(object sender, EventArgs e)
        {

            objgen.validatelogin();

            if (!IsPostBack)
            {
               if(Session["usertype"].ToString()!="Admin")
               {
                   System.Data.DataSet ds = new System.Data.DataSet();
                   objda.id = Session["userid"].ToString();
                   ds = objda.getUserInRoles();

                   if (!objda.validatedRoles("75", ds))
                   {
                       Response.Redirect("UserDashboard.aspx");
                   }

               }
                fillproject();
                searchdata();


            }
        }

        /// <summary>
        /// Fill list of existing clients For Search
        /// </summary>
        protected void fillproject()
        {
            dropproject.Items.Clear();
            objts.name = "";
            objts.action = "selectbyclient";
            objts.clientid = dropproject.Text;
            objts.companyId = Session["companyid"].ToString();
            objts.nid = "";
            ds = objts.ManageProject();
            if (ds.Tables[0].Rows.Count > 0)
            {
                dropproject.DataSource = ds;
                dropproject.DataTextField = "projectnamewithcode";
                dropproject.DataValueField = "nid";
                dropproject.DataBind();
            }

            ListItem li = new ListItem("--All Projects--", "");
            dropproject.Items.Insert(0, li);

        }


        /// <summary>
        /// Fill list of existing client groups
        /// </summary>
        protected void fillgrid()
        {
            Session["TaskTable"] = null;

            objts.action = "getprojectsummary";
            objts.companyId = Session["companyid"].ToString();
            objts.projectid = hidsearchprojectid.Value;
            ds = objts.GetProjectAllocationReport();
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
                // btnexportcsv.Enabled = true;

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
            // updatePanelData.Update();
            dsexcel = ds;
        }

        protected void searchdata()
        {
            hidsearchprojectid.Value = dropproject.Text;
            fillgrid();

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

        protected void btnsearch_Click(object sender, EventArgs e)
        {
            searchdata();

        }

        /// <summary>
        /// event fires when clicks to Edit/Delete in List
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dgnews_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName.ToLower() == "view")
            {
                hidprojectid.Value = e.CommandArgument.ToString();
                ds = getmodulesummary();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    grdmodule.DataSource = ds.Tables[0];
                    grdmodule.DataBind();
                    divnomoduledata.Visible = false;
                }
                else
                {
                    grdmodule.DataSource = null;
                    grdmodule.DataBind();

                }
                if (ds.Tables[1].Rows.Count > 0)
                {
                    ltrprojecttitle.InnerHtml = ds.Tables[1].Rows[0]["projectcode"].ToString() + " " + ds.Tables[1].Rows[0]["projectname"].ToString();
                }

                hidcurrentview.Value = "detail";
                multiview1.ActiveViewIndex = 1;

            }

        }

        /// <summary>
        /// Get project wise modules details
        /// </summary>
        protected DataSet getmodulesummary()
        {

            objts.projectid = hidprojectid.Value;
            objts.action = "getmodulesummary";
            objts.companyId = Session["companyid"].ToString();
            ds = objts.GetProjectAllocationReport();
            return ds;
        }
        protected void grdmodule_RowCommand(object sender, GridViewCommandEventArgs e)
        {
        }

        protected void btnback_Click(object sender, EventArgs e)
        {
            hidprojectid.Value = "";
            hidcurrentview.Value = "list";
            multiview1.ActiveViewIndex = 0;
        }
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


        #region EXPORT TO EXCEL
        protected void btnexportcsv_Click(object sender, EventArgs e)
        {
            string rpthtml = "";
            if (hidcurrentview.Value == "detail")
            {
                dsexcel = getmodulesummary();
                rpthtml = binddetailheader("excel");

                for (int i = 0; i < dsexcel.Tables[0].Rows.Count; i++)
                {
                    rpthtml = rpthtml + "<tr><td>" + Convert.ToString(i + 1) + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["title"].ToString() +
                        "</td><td>" + dsexcel.Tables[0].Rows[i]["description"].ToString() + "</td><td>" + dsexcel.Tables[0].Rows[i]["numoftasks"].ToString() +
                        "</td><td>" + dsexcel.Tables[0].Rows[i]["totalesthours"].ToString() + "</td><td>" + dsexcel.Tables[0].Rows[i]["percomplete"].ToString() +
                       "</td></tr>";
                }
            }
            else
            {
                fillgrid();
                rpthtml = bindlistviewheader("excel");

                for (int i = 0; i < dsexcel.Tables[0].Rows.Count; i++)
                {
                    rpthtml = rpthtml + "<tr><td>" + Convert.ToString(i + 1) + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["projectCode"].ToString() +
                        "</td><td>" + dsexcel.Tables[0].Rows[i]["projectname"].ToString() +
                        "</td><td>" + dsexcel.Tables[0].Rows[i]["numofmodules"].ToString() + "</td><td>" + dsexcel.Tables[0].Rows[i]["totalesthours"].ToString()
                        + "</td><td>" + dsexcel.Tables[0].Rows[i]["percomplete"].ToString()
                      + "</td></tr>";
                }
            }
            HtmlGenericControl divgen = new HtmlGenericControl();

            divgen.InnerHtml = rpthtml;

            HttpResponse response = HttpContext.Current.Response;

            // first let's clean up the response.object   
            response.Clear();
            response.Charset = "";

            // set the response mime type for excel   
            response.ContentType = "application/vnd.ms-excel";
            response.AddHeader("Content-Disposition", "attachment;filename=\"HCLLPProjectSummaryReport.xls\"");

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
        protected string bindlistviewheader(string type)
        {
            string Companyname = Session["companyname"].ToString();

            string str = "";
            string project = "<b>Project:</b> ";
            if (hidsearchprojectid.Value == "")
            {
                project += "All";
            }
            else
            {
                project += hidsearchprojectid.Value;
            }

            string headerstr = "<table width='100%'>";
            if (type == "excel")
            {
                headerstr = "<table width='100%' border='1'>";

            }

            str = headerstr +
         @"<tr>
            <td colspan='6' align='center'>
                <h2>
                    " + Companyname + @"
                </h2>
            </td>
        </tr>
        <tr>
            <td colspan='6' align='center'>
                <h4>
                    Projects Summary Report
                </h4>
            </td>
        </tr>
        <tr>
            <td colspan='6'>
                &nbsp;
            </td>
        </tr>
       
        <tr>
        <td colspan='6'>
        " + project + "<br/>" +



        @"</td>

        </tr>
       <tr>
        <td colspan='6'>&nbsp;</td></tr>
       </table>

        <table align='left' cellpadding='6' width='100%' cellspacing='0' style='font-family: Calibri;font-size: 12px; text-align: left;' border='0'> 
         <tr style='font-weight: bold; background: #395ba4; color: #ffffff;'>
        <td style='width=38px;'width='100px'>S.No</td>
        <td>Project ID</td>
        <td>Project Name</td>
        <td>No. of Modules</td>
        <td>Est. Hours</td>
        <td>Completion %</td>
                                                                                                                                                                                                                                                   
        </tr>";

            return str;

        }


        protected string binddetailheader(string type)
        {
            string Companyname = Session["companyname"].ToString();

            string str = "";
            string projectid = "<b>Project ID:</b> ", projectname = "<b>Created By:</b>";
            projectid = projectid + dsexcel.Tables[1].Rows[0]["projectcode"].ToString();
            projectname = projectname + dsexcel.Tables[1].Rows[0]["projectname"].ToString();
      
            string headerstr = "<table width='100%'>";
            if (type == "excel")
            {
                headerstr = "<table width='100%' border='1'>";

            }

            str = headerstr +
         @"<tr>
            <td colspan='6' align='center'>
                <h2>
                    " + Companyname + @"
                </h2>
            </td>
        </tr>
        <tr>
            <td colspan='6' align='center'>
                <h4>
                    Project Wise Modules Summary Report
                </h4>
            </td>
        </tr>
        <tr>
            <td colspan='6'>
                &nbsp;
            </td>
        </tr>
       
        <tr>
        <td colspan='6'>
        " + projectid + "<br/>" + projectname + "<br/>" +
        @"</td>

        </tr>
       <tr>
        <td colspan='6'>&nbsp;</td></tr>
       </table>

        <table align='left' cellpadding='5' width='100%' cellspacing='0' style='font-family: Calibri;
         font-size: 12px; text-align: left;' border='0'> 
         <tr style='font-weight: bold; background: #395ba4; color: #ffffff;'>
        <td style='width=38px;'width='100px'>S.No</td>
        <td>Module Title</td>
        <td>Description</td>
         <td>No. of Tasks</td>
         <td>Est. Hours</td>
         <td>Completion %</td>
          </tr>";

            return str;

        }
        #endregion
    }
}