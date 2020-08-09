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
    public partial class CumulativeReport : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();
        DataSet dsexcel = new DataSet();
        excelexport objexcel = new excelexport();
        protected void Page_Load(object sender, EventArgs e)
        {

            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                txtfromdate.Text = System.DateTime.Now.AddDays(-7).ToString("MM/dd/yyyy");
                txttodate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");

                if (!objda.checkUserInroles("112"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }



              
                fillemployee();
                fillclient();
                fillproject();
                fillmanager();
                filltasks();
                fillgrid();
            }
        }
        /// <summary>
        /// Fill Projects drop down for seraching
        /// </summary>
        protected void fillproject()
        {
            dropproject.Items.Clear();
            objts.name = "";
            objts.action = "selectbyclient";
            objts.clientid = dropclient.Text;
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
        protected void ddlclient_SelectedIndexChanged(object sender, EventArgs e)
        {
            //fillpopproject();
            ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);

        }

        protected void dropclient_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            fillproject();
            updatePanelSearch.Update();


        }


        /// <summary>
        /// Bind list of managers who assigned the tasks
        /// </summary>
        protected void fillmanager()
        {
            dropassign.Items.Clear();

           

            //This action selects the employee according to Roles id "7", if you chnage the roles please change in Stored Procedure too.
            objuser.action = "selectassignmanager";
            objuser.companyid = Session["companyid"].ToString();
            objuser.id = "";
            ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0)
            {
                dropassign.DataSource = ds;
                dropassign.DataTextField = "username";
                dropassign.DataValueField = "nid";
                dropassign.DataBind();

            }

            ListItem li = new ListItem("--All Manager--", "");
            dropassign.Items.Insert(0, li);

        }

        /// <summary>
        /// Fill tasks drop down for searching
        /// </summary>
        protected void filltasks()
        {
            objts.name = "";
            objts.action = "select";
            objts.companyId = Session["companyid"].ToString();
            objts.nid = "";
            objts.type = "Task";
            objts.deptID = "";
            ds = objts.ManageTasks();

            droptask.DataSource = ds;
            droptask.DataTextField = "taskcodename";
            droptask.DataValueField = "nid";
            droptask.DataBind();

            ListItem li = new ListItem("--All Tasks--", "");
            droptask.Items.Insert(0, li);
        }



        /// <summary>
        /// Fill Employee to select for those who have admin Right
        /// </summary>
        protected void fillemployee()
        {
            objuser.action = "select";
            objuser.companyid = Session["companyid"].ToString();
            objuser.id = "";
            ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0)
            {
                dropemployee.DataSource = ds;
                dropemployee.DataTextField = "username";
                dropemployee.DataValueField = "nid";
                dropemployee.DataBind();

            }

            ListItem li = new ListItem("--All Employees--", "");
            dropemployee.Items.Insert(0, li);
            dropemployee.SelectedIndex = 0;

        }

        /// <summary>
        /// Fill clients drop down for searching
        /// </summary>
        protected void fillclient()
        {
            objuser.clientname = "";
            objuser.action = "select";
            objuser.companyid = Session["companyid"].ToString();
            objuser.id = "";
            ds = objuser.client();
            if (ds.Tables[0].Rows.Count > 0)
            {
                dropclient.DataSource = ds;
                dropclient.DataTextField = "clientcodewithname";
                dropclient.DataValueField = "nid";
                dropclient.DataBind();
                ListItem li = new ListItem("--All Clients--", "");
                dropclient.Items.Insert(0, li);
            }


        }
        protected void fillgrid()
        {
            Session["TaskTable"] = null;
            objts.empid = dropemployee.Text;

            objts.action = "CumulativeReport";
            objts.nid = "";

            objts.clientid = dropclient.Text;
            objts.projectid = dropproject.Text;
            objts.taskid = droptask.Text;
            objts.from = txtfromdate.Text;
            objts.to = txttodate.Text;
            objts.CreatedBy = dropassign.Text;
            ds = objts.AssignTasks();

            int start = dgnews.PageSize * dgnews.PageIndex;
            int end = start + dgnews.PageSize;
            start = start + 1;
            if (ds.Tables.Count > 0)
            {
                if (end >= ds.Tables[0].Rows.Count)
                    end = ds.Tables[0].Rows.Count;
                lblstart.Text = start.ToString();
                lblend.Text = end.ToString();
                lbltotalrecord.Text = ds.Tables[0].Rows.Count.ToString();
            }
            else
            { 
             lblstart.Text = "0";
                lblend.Text = "0";
                lbltotalrecord.Text = "0";
            
            }
            if (ds.Tables.Count > 0)
            {
                if (ds.Tables[0].Rows.Count > 0)
                {
                    Session["TaskTable"] = ds;
                    dgnews.DataSource = ds;
                    dgnews.DataBind();
                    btnexportcsv.Enabled = true;

                    divnodata.Visible = false;
                    dgnews.Visible = true;


                }
                else
                {
                    btnexportcsv.Enabled = false;
                    if (IsPostBack)
                    {
                        divnodata.Visible = true;
                    }
                    dgnews.Visible = false;

                    Session["TaskTable"] = null;
                }
                updatePanelData.Update();
                //dsexcel = ds;
            }
            else
            {
                btnexportcsv.Enabled = false;
                if (IsPostBack)
                {
                    divnodata.Visible = true;
                }
                dgnews.Visible = false;

                Session["TaskTable"] = null;

            }
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
        }
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            fillgrid();

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
            string client = "<b>Client:</b> ", employee = "<b>Employee:</b> ", task = "<b>Task:</b> ", date = "<b>Date:</b> ";
            if (dropclient.Text == "")
            {
                client += "All";
            }
            else
            {
                client += dropclient.SelectedItem.Text;
            }
            if (dropemployee.Text == "")
            {
                employee += "All";
            }
            else
            {
                employee += dropemployee.SelectedItem.Text;
            }

            if (droptask.Text == "")
            {
                task += "All";
            }
            else
            {
                task += droptask.SelectedItem.Text;
            }
            if (txtfromdate.Text != txttodate.Text)
            {
                date += txtfromdate.Text + " - " + txttodate.Text;
            }
            else
            {
                date += txtfromdate.Text;
            }
            string headerstr = "<table width='100%'>";
            if (type == "excel")
            {
                headerstr = "<table width='100%'>";

            }

            str = headerstr +
        @"<tr>
            <td colspan='" + dsexcel.Tables[0].Columns.Count.ToString() + @"' align='center'>
                <h2 style='text-align:center;color:#395ba4;'>
                   " + Companyname + @"
                </h2>
            </td>
        </tr>
<tr>
            <td colspan='" + dsexcel.Tables[0].Columns.Count.ToString() + @"' align='center'>
                <h4 style='text-align:center;color:#395ba4;'>
                   " + companyaddress + @"
                </h4>
            </td>
        </tr>
        <tr>
            <td colspan='" + dsexcel.Tables[0].Columns.Count.ToString() + @"' align='center'>
                <h4  style='text-align:center;color:#395ba4;'>
                   Cumulative Report
                </h4>
            </td>
        </tr>
        <tr>
            <td colspan='" + dsexcel.Tables[0].Columns.Count.ToString() + @"'>
                &nbsp;
            </td>
        </tr>
       
        <tr>
        <td colspan='" + dsexcel.Tables[0].Columns.Count.ToString() + @"'>
        " + date + "<br/>" + employee + "<br/>" + client + "<br/>" + task + "<br/>" +



       @"</td>

        </tr>
       <tr>
        <td colspan='" + dsexcel.Tables[0].Columns.Count.ToString() + @"'>&nbsp;</td></tr>
       </table><table width='100%' cellpadding='5' cellspacing='0' style='font-family: Calibri;
                        font-size: 13px; text-align: left;' border='1'>
                       
                         
  <tr style='font-weight: bold; background: #395ba4; color: #ffffff;'>";
            for (int i = 0; i < dsexcel.Tables[0].Columns.Count; i++)
            {
                str += @"<td>" + dsexcel.Tables[0].Columns[i].ColumnName + "</td>";

            }
            str += "</tr>";

            return str;


        }
        protected void btnexportcsv_Click(object sender, EventArgs e)
        {

            dsexcel = (DataSet)Session["TaskTable"];
            string rpthtml = bindheader("excel");
            for (int i = 0; i < dsexcel.Tables[0].Rows.Count; i++)
            {

                rpthtml += "<tr>";
                for (int j = 0; j < dsexcel.Tables[0].Columns.Count; j++)
                {

                    rpthtml += "<td>" + dsexcel.Tables[0].Rows[i][j].ToString() + "</td>";
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
            response.AddHeader("Content-Disposition", "attachment;filename=\"CumulativeReport.xls\"");

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
            dsexcel = (DataSet)Session["TaskTable"];
            DataTable dt = dsexcel.Tables[0];

            if (dt != null)
            {
                //Sort the data.
                dt.DefaultView.Sort = e.SortExpression + " " + GetSortDirection(e.SortExpression);
                dgnews.DataSource = dt;
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
    }
}