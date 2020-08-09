using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.IO;
using System.Data;

namespace empTimeSheet.Client
{
    public partial class Home : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();
        DataSet dsexcel = new DataSet();
        decimal totalcommulativehours = 0;
        protected void Page_Load(object sender, EventArgs e)
        {

            objgen.validateClientlogin();

            if (!IsPostBack)
            {

                fillgrid();


            }
        }



        /// <summary>
        /// Fill list of existing client groups
        /// </summary>
        protected void fillgrid()
        {
            Session["TaskTable"] = null;

            objts.action = "getclientprojectsummary";
            objts.companyId = Session["companyid"].ToString();
            objts.projectid = "";
            objts.clientid = Session["clientloginid"].ToString();
            ds = objts.GetClientsProjectAllocationReport();
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

        protected void dgnews_OnRowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {

                LinkButton lnkmodule = (LinkButton)e.Row.FindControl("lnkmodule");
                LinkButton lnktask = (LinkButton)e.Row.FindControl("lnktasks");

                if (Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "numofmodules").ToString()) <= 0)
                {
                    lnkmodule.Attributes["onclick"] = "return false;";
                }

                if (Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "numoftasks").ToString()) <= 0)
                {
                    lnktask.Attributes["onclick"] = "return false;";
                }
            }
        }
        /// <summary>
        /// event fires when clicks to Edit/Delete in List
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dgnews_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName.ToLower() == "goformodules")
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
                    divnomoduledata.Visible = false;

                }
                if (ds.Tables[1].Rows.Count > 0)
                {
                    lblprojectcode.InnerText = "Project ID: " + ds.Tables[1].Rows[0]["projectcode"].ToString();
                    lblprojectname.InnerText = "Project Name: " + ds.Tables[1].Rows[0]["projectname"].ToString();
                }

                //hidcurrentview.Value = "detail";
                //multiview1.ActiveViewIndex = 1;
                ScriptManager.RegisterStartupScript(this, GetType(), "temp", "<script>showdiv('divmoduledetails');</script>", false);


            }
            if (e.CommandName.ToLower() == "gofortasks")
            {
                totalcommulativehours = 0;
                objts.projectid = e.CommandArgument.ToString();
                objts.action = "gettasksummary";
                objts.companyId = Session["companyid"].ToString();
                ds = objts.GetClientsProjectAllocationReport();

                if (ds.Tables[0].Rows.Count > 0)
                {
                    grdtasks.DataSource = ds.Tables[0];
                    grdtasks.DataBind();
                    divnotaskfound.Visible = false;
                    ltrprojectcode.InnerText = "Project ID: " + ds.Tables[0].Rows[0]["projectcode"].ToString();
                    ltrprojectname.InnerText = "Project Name: " + ds.Tables[0].Rows[0]["projectname"].ToString();
                }
                else
                {
                    grdtasks.DataSource = null;
                    grdtasks.DataBind();
                    divnotaskfound.Visible = true;
                }

                ltrtotalcommulativehours.Text = totalcommulativehours.ToString("0.00");
                //hidcurrentview.Value = "detail";
                //multiview1.ActiveViewIndex = 1;
                ScriptManager.RegisterStartupScript(this, GetType(), "temp", "<script>showdiv('divtaskdetails');</script>", false);


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
            ds = objts.GetClientsProjectAllocationReport();
            return ds;
        }
        protected void grdmodule_RowCommand(object sender, GridViewCommandEventArgs e)
        {
        }
        protected void grdtasks_ItemDataBound(object sender,GridViewRowEventArgs e)
        {

            if(e.Row.RowType == DataControlRowType.DataRow)
            {
                totalcommulativehours = totalcommulativehours + Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "commulativestatus").ToString());               
            }
            

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
        /// <summary>
        /// Export file to excel
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnexportcsv_Click(object sender, EventArgs e)
        {
            string rpthtml = "";

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

            HtmlGenericControl divgen = new HtmlGenericControl();

            divgen.InnerHtml = rpthtml;

            HttpResponse response = HttpContext.Current.Response;

            // first let's clean up the response.object   
            response.Clear();
            response.Charset = "";

            // set the response mime type for excel   
            response.ContentType = "application/vnd.ms-excel";
            response.AddHeader("Content-Disposition", "attachment;filename=\"ProjectSummary.xls\"");

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

        /// <summary>
        /// Bind export file header
        /// </summary>
        /// <param name="type"></param>
        /// <returns></returns>
        protected string bindlistviewheader(string type)
        {
            string Companyname = Session["clientcompanyname"].ToString();

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



        #endregion
    }
}