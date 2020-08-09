using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Net;
using System.Collections;
using System.Drawing.Text;
using System.Text;
using System.Reflection;
using System.IO;
using System.Web.UI.HtmlControls;

namespace empTimeSheet
{
    public partial class ViewSchedule : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds1 = new DataSet();
        DataSet ds = new DataSet();
        DataSet dsexcel = new DataSet();
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();

            if (!IsPostBack)
            {
                System.Data.DataSet ds = new System.Data.DataSet();
                objda.id = Session["userid"].ToString();
                ds = objda.getUserInRoles();


                if (!objda.validatedRoles("5", ds) && !objda.validatedRoles("6", ds))
                {
                    Response.Redirect("Dashboard.aspx");
                }

                if (objda.validatedRoles("5", ds))
                {
                    ViewState["add"] = "1";
                    linknonscemp.Visible = true;
                }
                else
                {
                    liaddnew.Visible = false;
                    ViewState["add"] = null;
                    linknonscemp.Visible = false;
                }

                txtfrmdate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");
                txttodate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");
                txtpopfrdate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");
                txtpoptodate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");


                fillclient();
                fillproject();
                fillemployee();
                searchdata();
                fillhours();
                fillpopclient();
                fillpopproject();
                popbindexpensesList();

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
        protected void drppopclient_SelectedIndexChanged(object sender, EventArgs e)
        {
            fillpopproject();
            ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);

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


        }
        /// <summary>
        /// Fill projects drop down to add
        /// </summary>
        protected void fillpopproject()
        {
            ddlproject.Items.Clear();
            if (drppopclient.Text != "")
            {
                objts.name = "";
                objts.action = "selectbyclient";
                objts.clientid = drppopclient.Text;
                objts.companyId = Session["companyid"].ToString();
                objts.nid = "";
                ds = objts.ManageProject();
                if (ds.Tables[0].Rows.Count > 0)
                {

                    ddlproject.DataSource = ds;
                    ddlproject.DataTextField = "projectnamewithcode";
                    ddlproject.DataValueField = "nid";
                    ddlproject.DataBind();
                }
            }


            ListItem li1 = new ListItem("--Select--", "");
            ddlproject.Items.Insert(0, li1);

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
                objuser.activestatus = "";
                ds = objuser.ManageEmployee();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    drpemployee.DataSource = ds;
                    drpemployee.DataTextField = "username";
                    drpemployee.DataValueField = "nid";
                    drpemployee.DataBind();
                    ListItem li = new ListItem("--All Employees--", "");
                    drpemployee.Items.Insert(0, li);
                    drpemployee.SelectedIndex = 0;
                }
            }
        }

        //Fill Grid View from Database
        public void fillgrid()
        {
            objts.nid = "";
            objts.action = "select";
            objts.companyId = Session["companyid"].ToString();
            objts.from = hidsearchfromdate.Value;
            objts.to = hidsearchtodate.Value;
            objts.clientid = hidsearchdrpclient.Value;
            objts.projectid = hidsearchdrpproject.Value;
            objts.empid = hidsearchdroemployee.Value;
            objts.Status = hidsearchdrpstatus.Value;
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
        //protected void fillgrid1()
        //{
        //    objts.nid = "";
        //    objts.action = "select";
        //    objts.companyId = Session["companyid"].ToString();
        //    objts.from = txtfrmdate.Text;
        //    objts.to = txttodate.Text;
        //    objts.clientid = drpclient.Text;
        //    objts.projectid = dropproject.Text;
        //    objts.empid = drpemployee.Text;
        //    objts.Status = dropstatus.Text.Trim();
        //    ds = objts.schedule();
        //    if (ds.Tables[0].Rows.Count > 0)
        //    {
        //        rptreport.DataSource = ds;
        //        rptreport.DataBind();
        //    }
        //    else
        //    {
        //        rptreport.DataSource = null;
        //        rptreport.DataBind();
        //    }
        //}
        /// <summary>
        /// Fill Hours
        /// </summary>

        public void fillhours()
        {
            string strhour = "";
            string hour = "";
            int j = 0;

            for (int i = 1; i <= 12; i++)
            {

                if (i < 10)
                    hour = "0" + i.ToString();
                else
                    hour = i.ToString();
                strhour += " <option value='" + hour + "'>" + hour + "</option>";
                drppophour.Items.Insert(j, hour + ":00");
                j = j + 1;
                drppophour.Items.Insert(j, hour + ":30");
                j++;
            }
            ListItem li = new ListItem("HH:mm", "");
            drppophour.Items.Insert(0, li);
            drppophour.SelectedIndex = 0;

        }

        /// <summary>
        /// Fill list of existing clients in Pop up
        /// </summary>
        public void fillpopclient()
        {
            objuser.action = "selectactive";

            objuser.name = "";
            objuser.id = "";
            objuser.companyid = Session["companyId"].ToString();
            ds = objuser.client();
            if (ds.Tables[0].Rows.Count > 0)
            {
                drppopclient.DataSource = ds;
                drppopclient.DataTextField = "clientcodewithname";
                drppopclient.DataValueField = "nid";
                drppopclient.DataBind();
                ListItem li = new ListItem("--Select--", "");
                drppopclient.Items.Insert(0, li);
                drppopclient.SelectedIndex = 0;

            }

        }


        protected void drppopclient_DataBound(object sender, EventArgs e)
        {
            //if (drppopclient.Items.Count > 0)
            //{
            //    foreach (ListItem li in ((DropDownList)sender).Items)
            //    {
            //       
            //        li.Text = Server.HtmlDecode(li.Text);

            //    }
            //}
        }


        /// <summary>
        /// Fill List Of Existing Employee In Popup
        /// </summary>
        private void popbindexpensesList()
        {
            objuser.loginid = "";
            objuser.id = "";
            objuser.name = "";
            objuser.companyid = Session["companyid"].ToString();
            objuser.action = "selectactive";
            objuser.activestatus = "active";
            ds = objuser.ManageEmployee();
            listcode1.DataSource = ds;
            listcode1.DataTextField = "username";
            listcode1.DataValueField = "nid";
            listcode1.DataBind();
        }

        /// <summary>
        /// When search any record
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnsearch_click(object sender, EventArgs e)
        {
            searchdata();

        }
        protected void searchdata()
        {
            hidsearchfromdate.Value = txtfrmdate.Text;
            hidsearchtodate.Value = txttodate.Text;
            hidsearchdrpclient.Value = drpclient.Text;
            hidsearchdrpproject.Value = dropproject.Text;
            hidsearchdroemployee.Value = drpemployee.Text;
            hidsearchdrpstatus.Value = dropstatus.Text.Trim();
            hidsearchdrpclientname.Value = drpclient.SelectedItem.Text;
            hidsearchdrpprojectname.Value = dropproject.SelectedItem.Text;
            hidsearchdroemployeename.Value = drpemployee.SelectedItem.Text;
            hidsearchdrpstatusname.Value = dropstatus.SelectedItem.Text;
            fillgrid();
        }

        /// <summary>
        /// Set Status 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>


        protected void btnsave_Click(object sender, EventArgs e)
        {
            objts.Status = ddlstaus.Text;

            if (objts.Status == "Re-Schedule")
            {

                objts.action = "checkexists";
                objts.date = txtnewdate.Text;
                objts.clientid = hidclientid.Value;
                objts.projectid = hidprjectid.Value;
                objts.empid = hidempid.Value;
                objts.Status = "Confirmed By Client";
                objts.nid = "";
                objts.hours = "";
                objts.CreatedBy = Session["userid"].ToString();
                objts.companyId = Session["companyid"].ToString();
                ds = objts.schedule();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    GeneralMethod.alert(this.Page, "Employee already scheduled on " + txtnewdate.Text + " for " + ds.Tables[0].Rows[0]["clientname"].ToString());
                    ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>openstatusdiv();</script>", false);

                }
                else
                {
                    objts.action = "insert";
                    ds = objts.schedule();
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        GeneralMethod.alert(this.Page, "Employee successfully Re-scheduled on " + txtnewdate.Text);
                    }
                }

            }
            objts.Status = ddlstaus.Text;
            objts.nid = hidid.Value;
            objts.remark = txtremark.Text;
            objts.action = "setstatus";

            ds = objts.schedule();
            if (ds.Tables[0].Rows.Count > 0)
            {
               // sendmailstatus(GeneralMethod.getLocalDate(), ltrclient.Text, hidstatus.Value, ddlstaus.Text);

            }

            txtremark.Text = "";
            ddlstaus.SelectedIndex = 0;

            fillgrid();


        }


        /// <summary>
        /// Send mail when staus has changed
        /// </summary>
        /// <param name="date"></param>
        /// <param name="client"></param>
        /// <param name="hidstatus"></param>
        /// <param name="newstatus"></param>
        protected void sendmailstatus(string date, string client, string hidstatus, string newstatus)
        {
            if (hidstatus != newstatus)
            {
                string bccemail = "";
                string cc = "";
                string bcc = bccemail;
                string filename = "";
                //Get users who have Access to Add Schedule to Send Email CC
                cc = System.Web.Configuration.WebConfigurationManager.AppSettings["ReceiverMail"].ToString() + ",";

                objuser.action = "selectschedulemanager";
                objuser.companyid = Session["companyid"].ToString();
                objuser.id = "";
                ds = objuser.ManageEmployee();
                if (ds != null)
                {
                    if (ds.Tables[1].Rows.Count > 0)
                    {
                        if (ds.Tables[1].Rows[0]["EmailCC"] != null)
                            cc = ds.Tables[1].Rows[0]["EmailCC"].ToString();

                    }
                }

                objts.nid = hidid.Value;
                objts.action = "select";
                ds = objts.schedule();
                if (ds.Tables[0].Rows.Count > 0)
                {

                    string subject = "HCLLP Schedule Status Updated";
                    string HTMLTemplatePath = Server.MapPath("EmailTemplates/Statuschange.htm");

                    string HTMLBODY = File.ReadAllText(HTMLTemplatePath);


                    string receiver = ds.Tables[0].Rows[0]["emailid"].ToString() + ",";
                    HTMLBODY = HTMLBODY.Replace("##empname##", ds.Tables[0].Rows[0]["fname"].ToString());
                    HTMLBODY = HTMLBODY.Replace("##date##", date);
                    HTMLBODY = HTMLBODY.Replace("##clientname##", client);
                    HTMLBODY = HTMLBODY.Replace("##oldstatus##", hidstatus);
                    if (newstatus == "Re-Schedule")
                    {
                        newstatus = newstatus + " on " + txtnewdate.Text;
                    }
                    HTMLBODY = HTMLBODY.Replace("##status##", newstatus);
                    objda.SendEmail(receiver, subject, HTMLBODY, cc, bcc, filename);

                }
            }
        }


        /// <summary>
        /// On Row Command Of Grid View
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>

        protected void dgnews_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "SetStatus")
            {
                //hidstatus.Value=arrstatus[];

                hidid.Value = e.CommandArgument.ToString();

                objts.action = "select";
                objts.nid = hidid.Value;
                ds = objts.schedule();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    ltrclient.Text = ds.Tables[0].Rows[0]["clientname"].ToString();
                    ltrdate.Text = ds.Tables[0].Rows[0]["date"].ToString();
                    ltrempname.Text = ds.Tables[0].Rows[0]["empname"].ToString();
                    hidstatus.Value = ds.Tables[0].Rows[0]["status"].ToString();
                    hidclientid.Value = ds.Tables[0].Rows[0]["clientid"].ToString();
                    hidprjectid.Value = ds.Tables[0].Rows[0]["projectid"].ToString();
                    hidempid.Value = ds.Tables[0].Rows[0]["empid"].ToString();
                }

                ddlstaus.Text = hidstatus.Value;

                ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>openstatusdiv();</script>", false);
            }
            if (e.CommandName.ToLower() == "del")
            {
                objts.nid = e.CommandArgument.ToString();
                objts.action = "delete";
                objts.schedule();
                fillgrid();
            }
        }
        /// <summary>
        /// For Sorting in Grid View
        /// </summary>
        /// <param name="source"></param>
        /// <param name="e"></param>
        protected void dgnews_Sorting(object source, GridViewSortEventArgs e)
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
        /// Get direction for sorting
        /// </summary>
        /// <param name="column"></param>
        /// <returns></returns>
        private string GetSortDirection(string column)
        {

            // By default, set the sort direction to ascending.
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
                }
            }

            // Save new values in ViewState.
            ViewState["SortDirection"] = sortDirection;
            ViewState["SortExpression"] = column;

            return sortDirection;
        }

        //Popup Add new div
        protected void liaddnew_Click(object sender, EventArgs e)
        {
            blank();

            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>opendiv();</script>", false);
        }
        /// <summary>
        /// For Submit Entries
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        /// 
        protected void btnsubmit_Click(object sender, EventArgs e)
        {

            string msg = "";
            string grpid = "";
            objts.from = txtpopfrdate.Text;
            objts.to = txtpoptodate.Text;
            //Here we are passing project id in clientid param 
            objts.clientid = dropproject.Text;

            objts.companyId = Session["companyid"].ToString();
            objts.CreatedBy = Session["userid"].ToString();
            objts.empid = hidexpense.Value;

            ds = objts.checkschedule();

            if (ds.Tables[0].Rows.Count > 0)
            {
                if (ds.Tables[0].Rows[0]["errormessage"] != null && ds.Tables[0].Rows[0]["errormessage"].ToString() != "")
                {
                    lblerr.Text = ds.Tables[0].Rows[0]["errormessage"].ToString();
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>openalert();</script>", false);
                    return;
                }
            }
            insertschedule();

        }
        protected void btncontinue_Click(object sender, EventArgs e)
        {
            insertschedule();
        }

        protected void insertschedule()
        {
            string msg = "";
            string grpid = "";
            objts.from = txtpopfrdate.Text;
            objts.to = txtpoptodate.Text;
            objts.clientid = drppopclient.Text;
            objts.date = drppophour.Text + (drppopmin.Text);
           
            objts.companyId = Session["companyid"].ToString();
            objts.CreatedBy = Session["userid"].ToString();
            objts.empid = hidexpense.Value;
            objts.projectid = ddlproject.Text;
            objts.type = rdbtnscheduleType.Text;
            if (rdbtnscheduleType.Text.ToLower() == "office")
            {
                objts.Status = "";
                objts.remark = txtaddremark.Text;
            }
            else
            {
                objts.Status = drppopstatus.Text;
                objts.remark = "";
            }
              ds = objts.insertschedule();
            if (ds != null)
            {
                //if (ds.Tables[0].Rows.Count > 0)
                //{
                //    lblerr.Text = ds.Tables[0].Rows[0]["errormessage"].ToString();
                //    grpid = ds.Tables[0].Rows[0]["groupid"].ToString();
                //}
                if (ds.Tables.Count > 1)
                {
                    if (ds.Tables[1].Rows.Count > 0)
                    {
                        if (objts.type.ToLower() != "office")
                        {
                            sendnewschedulemail(ds.Tables[1]);
                        }
                    }
                }
                txtfrmdate.Text = txtpopfrdate.Text;
                txttodate.Text = txtpoptodate.Text;
                drpclient.Text = drppopclient.Text;
            }
            blank();
            fillgrid();
            if (ds != null)
            {
                if (ds.Tables.Count > 1)
                {
                    if (ds.Tables[1].Rows.Count > 0)
                    {
                        GeneralMethod.alert(this, "Saved Successfully");
                    }
                }
            }

        }

        /// <summary>
        /// Blank Values
        /// </summary>
        public void blank()
        {
            txtpopfrdate.Text = Convert.ToDateTime(GeneralMethod.getLocalDate()).ToString("MM/dd/yyyy");
            txtpoptodate.Text = Convert.ToDateTime(GeneralMethod.getLocalDate()).ToString("MM/dd/yyyy");
            drppopclient.SelectedIndex = 0;
            drppophour.SelectedIndex = 0;
            drppopmin.SelectedIndex = 0;
            drppopstatus.SelectedIndex = 0;
            listcode1.Items.Clear();
            listcode2.Items.Clear();
            hidexpense.Value = "";
            popbindexpensesList();
            ddlproject.SelectedIndex = 0;
            rdbtnscheduleType.ClearSelection();
            txtaddremark.Text = "";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>showhidestatus();</script>", false);

        }


        protected void sendnewschedulemail(DataTable dt)
        {
            string bccemail = "";
            string receiver = "";
            string cc = "";
            string bcc = bccemail;
            string filename = "";
            string message = "";
            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {
                    //Get users who have Access to Add Schedule to Send Email CC
                    cc = System.Web.Configuration.WebConfigurationManager.AppSettings["ReceiverMail"].ToString() + ",";

                    objuser.action = "selectschedulemanager";
                    objuser.companyid = Session["companyid"].ToString();
                    objuser.id = "";
                    ds = objuser.ManageEmployee();
                    if (ds != null)
                    {
                        if (ds.Tables[1].Rows.Count > 0)
                        {
                            //This will return all managers Email Id separated by comma
                            if (ds.Tables[1].Rows[0]["EmailCC"] != null)
                                cc = ds.Tables[1].Rows[0]["EmailCC"].ToString();

                        }
                    }

                    for (int i = 0; i < dt.Rows.Count; i++)
                    {

                        receiver = dt.Rows[i]["emailid"].ToString() + ",";
                        message = dt.Rows[i]["mailmessage"].ToString();
                        string subject = dt.Rows[i]["mailsubject"].ToString();

                        objda.SendEmail(receiver, subject, message, cc, bcc, filename);


                    }
                }
            }

        }

        protected void btnexportcsv_Click(object sender, EventArgs e)
        {

            fillgrid();
            string rpthtml = bindheader("excel");
            for (int i = 0; i < dsexcel.Tables[0].Rows.Count; i++)
            {
                rpthtml = rpthtml + "<tr><td>" + Convert.ToString(i + 1) + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["date"].ToString() + ' ' + dsexcel.Tables[0].Rows[i]["Time"].ToString() +
                    "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["empname"].ToString() + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["clientname"].ToString() + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["projectcode"].ToString() + "</td>"
                    + "<td>" + dsexcel.Tables[0].Rows[i]["scheduletype"].ToString() + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["status"].ToString() + "</td>"
                    + "<td>" + dsexcel.Tables[0].Rows[i]["remark"].ToString() + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["username"].ToString() + "</td></tr>";
            }

            HtmlGenericControl divgen = new HtmlGenericControl();

            divgen.InnerHtml = rpthtml;
            HttpResponse response = HttpContext.Current.Response;
            // first let's clean up the response.object   
            response.Clear();
            response.Charset = "";
            // set the response mime type for excel   

            response.ContentType = "application/vnd.ms-excel";
            response.AddHeader("Content-Disposition", "attachment;filename=\"ClientScheduleReport.xls\"");
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

        protected void dgnews_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                LinkButton lbtnstatus = (LinkButton)e.Row.FindControl("lbtnstatus");
                LinkButton lbtndelete = (LinkButton)e.Row.FindControl("lbtndelete");
                if (DataBinder.Eval(e.Row.DataItem, "status") != null && DataBinder.Eval(e.Row.DataItem, "status").ToString() == "Re-Schedule")
                {
                   
                    lbtnstatus.Visible = false;
                }
                if (DataBinder.Eval(e.Row.DataItem, "scheduletype").ToString().ToLower() == "office")
                {
                    lbtnstatus.Visible = false;
                }
                if (ViewState["add"] == null || ViewState["add"].ToString() == "")
                {
                    lbtndelete.Visible = false;
                }
            }
        }

        protected string bindheader(string type)
        {
            string str = "";
            string client = "<b>Client:</b> ", employee = "<b>Employee:</b> ", task = "<b>Task:</b> ", status = "<b>Status:</b> ", date = "<b>Date:</b> ";
            if (hidsearchdrpclient.Value == "")
            {
                client += "All";
            }
            else
            {
                client += hidsearchdrpclientname.Value;
            }
            if (hidsearchdroemployee.Value == "")
            {
                employee += "All";
            }
            else
            {
                employee += hidsearchdroemployeename.Value;
            }
            if (hidsearchdrpstatus.Value == "")
            {
                status += "All";
            }
            else
            {
                status += hidsearchdrpstatusname.Value;
            }

            if (hidsearchfromdate.Value != hidsearchtodate.Value)
            {
                date += hidsearchfromdate.Value + " - " + hidsearchtodate.Value;
            }
            else
            {
                date += hidsearchfromdate.Value;
            }
            string headerstr = "<table width='100%'>";
            if (type == "excel")
            {
                headerstr = "<table width='100%' border='1'>";

            }

            str  = headerstr +
        @"<tr>
            <td colspan='9' align='center'>
                <h2>
                    Harshwal & Company LLP
                </h2>
            </td>
        </tr>
        <tr>
            <td colspan='9' align='center'>
                <h4>
                    Schedule Report
                </h4>
            </td>
        </tr>
        <tr>
            <td colspan='9'>
                &nbsp;
            </td>
        </tr>
       
        <tr>
        <td colspan='9'>
        " + date + "<br/>" + employee + "<br/>" + client + "<br/>" + task + "<br/>" + status +



       @"</td>

        </tr>
       <tr>
        <td colspan='9'>&nbsp;</td></tr>
       </table>
<table align='left' cellpadding='5' width='100%' cellspacing='0' style='font-family: Calibri;
                        font-size: 12px; text-align: left;' border='0'>
                      
<tr style='font-weight: bold; background: #395ba4; color: #ffffff;'>
<td style='width=38px;'width='100px'>S.No</td>
 <td> Date/Time</td>
 <td>Employee</td>
 <td>Client</td>
 <td>Project</td>
 <td>Schedule Type</td>
 <td>Status</td>
 <td>Remark</td>
 <td>Last Modify By</td>
                                                                     
</tr>";


            return str;
        }


        //--------------------------NON Scheduke Tasks

        protected void linknonscemp_Click(object sender, EventArgs e)
        {

            bindnonschedule();
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>opennonscedulediv();</script>", false);
        }

        protected void bindnonschedule()
        {

            if (txtfrmdate.Text != txttodate.Text)
            {
                ltrsearchparam.Text = txtfrmdate.Text + " - " + txttodate.Text;
            }
            else
            {
                ltrsearchparam.Text = txtfrmdate.Text;
            }

            DateTime StartDate = Convert.ToDateTime(txtfrmdate.Text);
            DateTime EndDate = Convert.ToDateTime(txttodate.Text);
            int count = 0;
            int n = 0;
            var daydiff = EndDate.Subtract(StartDate).Days;

            DataRow itemdr;
            DataColumn itemdc;
            DataTable itemtable = new DataTable();
            itemdc = new DataColumn("date", System.Type.GetType("System.String"));
            itemtable.Columns.Add(itemdc);

            while (StartDate.AddDays(count) <= EndDate)
            {
                // StartDate.AddDays(count);

                itemdr = itemtable.NewRow();


                itemdr["date"] = StartDate.AddDays(count).ToString("MM/dd/yyyy");


                itemtable.Rows.Add(itemdr);

                count++;
            }

            if (itemtable.Rows.Count > 0)
            {
                rptday.DataSource = itemtable;
                rptday.DataBind();
                divnoschedulefound.Visible = false;
            }
            else
            {
                rptday.DataSource = null;
                rptday.DataBind();
                divnoschedulefound.Visible = true;
            }
        }

        protected void rptday_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
            {
                Repeater rptinner = (Repeater)e.Item.FindControl("rptinner");
                Literal ltrmsg = (Literal)e.Item.FindControl("ltrinnermsg");
                objts.date = DataBinder.Eval(e.Item.DataItem, "date").ToString();
                objts.empid = "";
                objts.companyId = Session["CompanyId"].ToString();
                objts.action = "selectnonscheduled";
                ds = objts.schedule();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    rptinner.DataSource = ds;
                    rptinner.DataBind();

                }
                else
                {

                    ltrmsg.Text = "All Employees are Schedule";

                }

            }
        }

        protected void btnrefresh_Click(object sender, EventArgs e)
        {
            fillgrid();
        }

    }
}







