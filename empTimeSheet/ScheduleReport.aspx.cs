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
    public partial class ScheduleReport : System.Web.UI.Page
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
               // System.Data.DataSet ds = new System.Data.DataSet();
                if (Session["usertype"].ToString() == "Admin")
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

                txtfrmdate.Text = System.DateTime.Now.AddDays(-7).ToString("MM/dd/yyyy");
                txttodate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");



                fillclient();
                fillproject();
                fillemployee();
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
            objts.clientid = drpclient.Text;
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
        protected void drpclient_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            fillproject();
            updatePanelSearch.Update();

        }

        /// <summary>
        /// Fill list of existing clients For Search
        /// </summary>
        public void fillclient()
        {
            objuser.action = "select";

            objuser.name = "";
            objuser.id = "";
            objuser.companyid = Session["companyId"].ToString();
            ds = objuser.client();
            if (ds.Tables[0].Rows.Count > 0)
            {
                drpclient.DataSource = ds;
                drpclient.DataTextField = "clientcodewithname";
                drpclient.DataValueField = "nid";
                drpclient.DataBind();
                ListItem li = new ListItem("--All Clients--", "");
                drpclient.Items.Insert(0, li);
                drpclient.SelectedIndex = 0;

            }

        }


        /// <summary>
        /// fiil List of Employee For Search
        /// </summary>
        private void fillemployee()
        {
            if (ViewState["add"] == null || ViewState["add"].ToString() == "")
            {
                ListItem li = new ListItem(Session["username"].ToString(), Session["userid"].ToString());
                drpemployee.Items.Insert(0, li);
                drpemployee.SelectedIndex = 0;
            }
            else
            {
                objuser.loginid = "";
                objuser.name = "";
                objuser.companyid = Session["companyid"].ToString();
                objuser.action = "select";
                objuser.activestatus = "active";
                ds = objuser.ManageEmployee();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    objgen.fillActiveInactiveDDL(ds.Tables[0], drpemployee, "username", "nid");
                    ListItem li = new ListItem("--All Employees--", "");
                    drpemployee.Items.Insert(0, li);
                    drpemployee.SelectedIndex = 0;
                }
            }
        }
        protected void btnrefresh_Click(object sender, EventArgs e)
        {
            fillgrid();
        }
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            dgnews.PageIndex = 0;
            fillgrid();

        }

        //Fill Grid View from Database
        public void fillgrid()
        {
            objts.nid = "";
            objts.action = "select";
            objts.companyId = Session["companyid"].ToString();
            objts.from = txtfrmdate.Text;
            objts.to = txttodate.Text;
            objts.clientid = drpclient.Text;
            objts.projectid = dropproject.Text;
            objts.empid = drpemployee.Text;
           
            objts.Status = dropstatus.Text.Trim();
            ds = objts.schedule();
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
                dgnews.DataSource = ds;
                dgnews.DataBind();
                btnexportcsv.Enabled = true;
                dgnews.Visible = true;
                divnodata.Visible = false;

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
                btnexportcsv.Enabled = false;
                dgnews.DataSource = null;
                dgnews.DataBind();
                dgnews.Visible = false;
                if (IsPostBack)
                    divnodata.Visible = true;
            }
            Session["TaskTable"] = ds.Tables[0];
            dsexcel = ds;
        }

        #region Export
        protected string bindheader(string type)
        {
            string str = "";
            string Companyname = Session["companyname"].ToString();
            string companyaddress = Session["companyaddress"].ToString();
            string client = "<b>Client:</b> ", employee = "<b>Employee:</b> ", task = "<b>Task:</b> ", status = "<b>Status:</b> ", date = "<b>Date:</b> ";
            if (drpclient.Text == "")
            {
                client += "All";
            }
            else
            {
                client += drpclient.SelectedItem.Text;
            }
            if (drpemployee.Text == "")
            {
                employee += "All";
            }
            else
            {
                employee += drpemployee.SelectedItem.Text;
            }
            if (dropstatus.Text == "")
            {
                status += "All";
            }
            else
            {
                status += dropstatus.SelectedItem.Text;
            }

            if (txtfrmdate.Text != txttodate.Text)
            {
                date += txtfrmdate.Text + " - " + txttodate.Text;
            }
            else
            {
                date += txtfrmdate.Text;
            }
            string headerstr = "<table width='100%'>";
            if (type == "excel")
            {
                headerstr = "<table width='100%' style='font-family: 'Century Gothic';font-size:9pt;'>";

            }

            str = headerstr +
        @"<tr>
            <td colspan='4' align='left'>
                <h2 style='color:DarkBlue;font-size:14pt;'>
                   " + Companyname + @"
                </h2>
            </td>
        </tr>
<tr>
            <td colspan='4' align='left'>
                <h4>
                   " + companyaddress + @"
                </h4>
            </td>
       
            <td colspan='3' align='right'>
                <h4>
                    Schedule Report by Employee and Client
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
        " + date + "<br/>" + employee + "<br/>" + client + "<br/>" + status +

       @"</td>

        </tr>
       <tr>
        <td colspan='7'>&nbsp;</td></tr>
       </table><table width='100%' cellpadding='5' cellspacing='0' style='font-family: 'Century Gothic';   font-size: 9pt; text-align: left;' border='0'>
                       
                         
  <tr style='font-weight: bold; background: #395ba4; color: #ffffff;'>
 <td>S.No.</td>
 <td>Date/Time</td>
 <td>Employee</td>
 <td>Client</td>
 <td>Project</td>
 <td>Status</td>
  <td>Remark</td>
                                                          
</tr>";
            return str;


        }
        protected void btnexportcsv_Click(object sender, EventArgs e)
        {

            fillgrid();
            string rpthtml = bindheader("excel");
            for (int i = 0; i < dsexcel.Tables[0].Rows.Count; i++)
            {
                string time = "",remark="&nbsp;";

                if (dsexcel.Tables[0].Rows[i]["time"] != null && dsexcel.Tables[0].Rows[i]["time"].ToString() != "")
                    time = " " + dsexcel.Tables[0].Rows[i]["time"].ToString();
                if (dsexcel.Tables[0].Rows[i]["remark"] != null && dsexcel.Tables[0].Rows[i]["remark"].ToString() != "")
                    remark = dsexcel.Tables[0].Rows[i]["remark"].ToString();

                rpthtml = rpthtml + "<tr><td>" + Convert.ToString(i + 1) + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["date"].ToString() + time +
               "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["empname"].ToString() + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["clientname"].ToString() + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["projectname"].ToString() + "</td>" +
              "<td>" + dsexcel.Tables[0].Rows[i]["status"].ToString() + "</td><td>"
              + dsexcel.Tables[0].Rows[i]["remark"].ToString() + "</td></tr>";
            }

            HtmlGenericControl divgen = new HtmlGenericControl();


            divgen.InnerHtml = rpthtml;
            HttpResponse response = HttpContext.Current.Response;

            // first let's clean up the response.object   
            response.Clear();
            response.Charset = "";

            // set the response mime type for excel   
            response.ContentType = "application/vnd.ms-excel";
            response.AddHeader("Content-Disposition", "attachment;filename=\"ScheduleReportByEmployeeAndClient.xls\"");

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