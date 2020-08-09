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
using System.Web.Services;
using System.Web.Script.Services;


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
        private Core.ServiceInspector SI;
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();

            if (!IsPostBack)
            {
                System.Data.DataSet ds = new System.Data.DataSet();
                objda.id = Session["userid"].ToString();
                ds = objda.getUserInRoles();

                if(Session["usertype"].ToString()!="Admin")
                {
                    if (!objda.validatedRoles("5", ds) && !objda.validatedRoles("6", ds))
                    {
                        Response.Redirect("UserDashboard.aspx");
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
                }
                else
                {
                    ViewState["add"] = "1";
                    linknonscemp.Visible = true;
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
            ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>showhidestatus();opendiv();</script>", false);

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
            updateproject.Update();


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
                ds1 = objts.ManageProject();
                if (ds1.Tables[0].Rows.Count > 0)
                {

                    ddlproject.DataSource = ds1;
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
                objuser.activestatus = "active";
                ds = objuser.ManageEmployee();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    objgen.fillActiveInactiveDDL(ds.Tables[0], drpemployee, "username", "nid");
                   
                }
                ListItem li = new ListItem("--All Employees--", "");
                drpemployee.Items.Insert(0, li);
                drpemployee.SelectedIndex = 0;
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
            objts.remark = hidsearchscheduletype.Value;
            ds = objts.schedule();
           
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
            updateData.Update();
            ScriptManager.RegisterStartupScript(updateData, updateData.GetType(), "key", "<script type='text/javascript'>fixheader();</script>", false);
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
            dgnews.PageIndex = 0;
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
            hidsearchscheduletype.Value = dropsearchscheduletype.Text;
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
                objts.Status = "Confirmed by the Client";
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
            if (ddlstaus.Text == "Re-Schedule" && hidstatus.Value == "Postponed")
            {
                objts.Status = "Postponed";
                if(txtremark.Text=="")
                {
                    txtremark.Text = "Re-Scheduled for client";
                }
            }
            else
            {
                objts.Status = ddlstaus.Text;
            }
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

                cc = objda.GetCompanyProperty("ReceiverMail") + ",";

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

                    string subject = "Schedule Status Updated";
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

             
            }
            if (e.CommandName.ToLower() == "del")
            {
                objts.nid = e.CommandArgument.ToString();
                objts.action = "delete";
                objts.schedule();
                fillgrid();
            }
            if (e.CommandName.ToLower() == "edititem")
            {
               

            }
        }
        protected void PaggedGridbtnedit2_Click(object sender, EventArgs e)
        {
           

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
            upadatepanel.Update();
        }
        protected void PaggedGridbtnedit_Click(object sender, EventArgs e)
        {
           
            objts.nid = hidid.Value;
            objts.action = "select";
            ds = objts.schedule();
            if (ds.Tables[0].Rows.Count > 0)
            {

                listcode1.Style.Add("visibility", "hidden");
                listcode2.Style.Add("visibility", "hidden");
                //btnAddtoList.Style.Add("visibility", "hidden");
                //btnRemovefromList.Style.Add("visibility", "hidden");
                divselectemployee.Style.Add("display", "none");
                hidempid.Value = ds.Tables[0].Rows[0]["empid"].ToString();
                txtpopfrdate.Text = ds.Tables[0].Rows[0]["date"].ToString();
                txtpoptodate.Text = ds.Tables[0].Rows[0]["date"].ToString();
                txtpoptodate.Enabled = false;
                txtpopfrdate.Enabled = false;
                drppopclient.Text = ds.Tables[0].Rows[0]["clientid"].ToString();
                fillpopproject();
                ddlproject.Text = ds.Tables[0].Rows[0]["projectid"].ToString();
                if (ds.Tables[0].Rows[0]["time"] != null && ds.Tables[0].Rows[0]["time"].ToString() != "")
                {
                    string[] str = ds.Tables[0].Rows[0]["time"].ToString().Split(' ');
                    drppophour.Text = ds.Tables[0].Rows[0]["time"].ToString().Replace("AM", "").Replace("PM", "");
                    if (ds.Tables[0].Rows[0]["time"].ToString().IndexOf("AM") > 0)
                        drppopmin.Text = "AM";
                    else
                        drppopmin.Text = "PM";
                }
                rdbtnscheduleType.Text = ds.Tables[0].Rows[0]["scheduletype"].ToString();
                txtaddremark.Text = ds.Tables[0].Rows[0]["remark"].ToString();
                drppopstatus.Text = ds.Tables[0].Rows[0]["status"].ToString();
                upadatepanel.Update();
                ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();showhidestatus();</script>", false);

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
            ScriptManager.RegisterStartupScript(updateData, updateData.GetType(), "key", "<script type='text/javascript'>fixheader();</script>", false);
        }
        protected void dgnews_RowCreated(object sender, GridViewRowEventArgs e)
        {
            //check if it is a header row
            //since allowsorting is set to true, column names are added as command arguments to
            //the linkbuttons by DOTNET API
            if (e.Row.RowType == DataControlRowType.Header)
            {
                LinkButton btnSort;
                Image image;
                //iterate through all the header cells
                foreach (TableCell cell in e.Row.Cells)
                {
                    //check if the header cell has any child controls
                    if (cell.HasControls())
                    {
                        //get reference to the button column
                        btnSort = (LinkButton)cell.Controls[0];
                        image = new Image();
                        if (ViewState["SortExpression"] != null)
                        {
                            //see if the button user clicked on and the sortexpression in the viewstate are same
                            //this check is needed to figure out whether to add the image to this header column nor not
                            if (btnSort.CommandArgument == ViewState["SortExpression"].ToString())
                            {
                                //following snippet figure out whether to add the up or down arrow
                                //based on the sortdirection
                                if (ViewState["SortDirection"].ToString() == "ASC")
                                {
                                    image.ImageUrl = "/images/asc.png";
                                }
                                else
                                {
                                    image.ImageUrl = "/images/desc.png";
                                }
                                cell.Controls.Add(image);
                                // return;
                            }
                            else
                            {
                                image.ImageUrl = "/images/updown.png";
                                cell.Controls.Add(image);
                            }
                        }
                        else
                        {
                            image.ImageUrl = "/images/updown.png";
                            cell.Controls.Add(image);
                        }
                    }
                }
            }
        }
        /// <summary>
        /// Get direction for sorting
        /// </summary>
        /// <param name="column"></param>
        /// <returns></returns>
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

        //Popup Add new div
        protected void liaddnew_Click(object sender, EventArgs e)
        {
            blank();
            upadatepanel.Update();
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
            string serviceURL = "";
           
            objts.from = txtpopfrdate.Text;
            objts.to = txtpoptodate.Text;


            //NOTE: Here we are passing project id in clientid param 
            //check whether employee already schedule for same project on same dates
            objts.clientid = ddlproject.Text;

            objts.companyId = Session["companyid"].ToString();
            if (hidid.Value == "")
            {
                objts.CreatedBy = Session["userid"].ToString();
                objts.empid = hidexpense.Value;

                ds = objts.checkschedule();

                if (ds.Tables[0].Rows.Count > 0)
                {
                    if (ds.Tables[0].Rows[0]["errormessage"] != null && ds.Tables[0].Rows[0]["errormessage"].ToString() != "")
                    {
                        lblerr.Text = ds.Tables[0].Rows[0]["errormessage"].ToString();
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>openalert();fixheader();</script>", false);
                      return;
                    }
                }



                insertschedule();
            }
            else
            {
                objts.action = "checkexists";
                objts.date = txtpopfrdate.Text;
                objts.clientid = drppopclient.Text;
                objts.projectid = ddlproject.Text;
                objts.empid = hidempid.Value;

                objts.nid = hidid.Value;

                objts.companyId = Session["companyid"].ToString();
                ds = objts.schedule();
                if (ds.Tables[0].Rows.Count > 0)
                {
                 
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('" + "Employee already scheduled for " + txtpopfrdate.Text + " on " + ddlproject.SelectedItem.Text + "'); opendiv();fixheader();</script>", false);
                    return;

                }
                else
                {
                    //if (serviceURL != "")
                    //{

                    //    ds = objts.getCodeByNidforSchedule();
                    //    if (ds.Tables[0].Rows.Count > 0)
                    //    {
                    //        string msg1 = "";
                    //        SI = new Core.ServiceInspector(new Uri(serviceURL));
                    //        List<object> methodParams = new List<object>();

                    //                     // Case Sensitive! To avoid typos, just copy the WebMethod's signature and paste it
                    //        methodParams.Add(txtpopfrdate.Text);     // all parameters are passed as strings
                    //        methodParams.Add(ds.Tables[0].Rows[0]["projectid"].ToString());
                    //        methodParams.Add(objts.companyId);
                    //        methodParams.Add(ds.Tables[0].Rows[0]["empid"].ToString());
                    //        try
                    //        {
                    //            object result = SI.RunMethod("checkempschedule_Update", methodParams);
                    //             msg1 = result.ToString();
                                            
                    //        }
                    //        catch {  }

                           
                    //        if (msg1 != "")
                    //        {
                               
                    //            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert(" + "Employee already scheduled for " + txtpopfrdate.Text + " on " + ddlproject.SelectedItem.Text + "); opendiv();</script>", false); return;
                    //        }

                    //    }




                    //}
                   
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
                    if (drppophour.Text != "")
                    {
                        objts.hours = drppophour.Text + " " + drppopmin.Text;
                    }
                    else
                    {
                        objts.hours = "";
                    }
                    objts.empid = rdbtnscheduleType.Text;
                    objts.action = "update";
                    ds = objts.schedule();
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        GeneralMethod.alert(this.Page, "Information updated successfully");
                    }
                    fillgrid();

                }
            }

        }


        protected void btncontinue_Click(object sender, EventArgs e)
        {
            insertschedule();
        }

        /// <summary>
        /// Insert New Schedule
        /// Before insert check whther employees already schedule for selected date on specific project
        /// </summary>
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
            upadatepanel.Update();
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>showhidestatus();</script>", false);

        }

        /// <summary>
        /// Send email to all employees who are currently scheduled
        /// </summary>
        /// <param name="dt"></param>
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
                    cc = objda.GetCompanyProperty("ReceiverMail") + ",";

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

            //excelexport objexcel = new excelexport();

            //objexcel.downloadFile(rpthtml.ToString(), "ClientScheduleReport.xls");

            HtmlGenericControl g1 = new HtmlGenericControl();
            g1.InnerHtml = rpthtml;
            Response.Clear();
            Response.Buffer = true;
            Response.ContentType = "application/vnd.ms-excel";
            Response.AddHeader("content-disposition", "attachment;filename=ClientScheduleReport.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);

            StringWriter swr = new StringWriter();
            HtmlTextWriter htmlwr = new HtmlTextWriter(swr);

            g1.RenderControl(htmlwr);
            Response.Output.Write(swr.ToString());
            Response.Flush();
            Response.End();   
          
        }

        protected void dgnews_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.Header)
                e.Row.TableSection = TableRowSection.TableHeader;
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                HtmlAnchor lbtnstatus = (HtmlAnchor)e.Row.FindControl("lbtnstatus");
                HtmlAnchor lbtndelete = (HtmlAnchor)e.Row.FindControl("lbtndelete");

                lbtnstatus.Attributes.Add("onclick", "clickedit2(" + DataBinder.Eval(e.Row.DataItem, "nid").ToString() + ")");
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
                else
                {
                    lbtndelete.Attributes.Add("onclick", "clickdelete('" + DataBinder.Eval(e.Row.DataItem, "nid").ToString() + "');");
                }
            }
        }

        /// <summary>
        /// Bind Header of excel Report
        /// </summary>
        /// <param name="type"></param>
        /// <returns></returns>
        protected string bindheader(string type)
        {
            string str = "";
            string Companyname = Session["companyname"].ToString();
            string companyaddress = Session["companyaddress"].ToString();
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

            str = headerstr +
        @"<tr>
            <td colspan='9' align='center'>
                <h2>
                   " + Companyname + @"
                </h2>
            </td>
        </tr>
<tr>
            <td colspan='9' align='center'>
                <h4>
                   " + companyaddress + @"
                </h4>
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

        }


        /// <summary>
        /// Bind Non Schedule employees
        /// First bind the selecetd dates in repeater.
        /// </summary>
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

            //Insert on dates in ItemTable
            while (StartDate.AddDays(count) <= EndDate)
            {
                // StartDate.AddDays(count);

                itemdr = itemtable.NewRow();


                itemdr["date"] = StartDate.AddDays(count).ToString("MM/dd/yyyy");


                itemtable.Rows.Add(itemdr);

                count++;
            }

            //Bind ItemTable dates in repeater
            if (itemtable.Rows.Count > 0)
            {
                //Bind list of employee on rptday_ItemDataBound
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

            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>opennonscedulediv();</script>", false);
        }

        /// <summary>
        /// Select the non-scheduled employees for each date and and bind it to child repeater
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
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
                objts.remark = rdlNonScheduleScheduleType.Text;
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

        /// <summary>
        /// Refresh the grid, so changes made by any other can reflect.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnrefresh_Click(object sender, EventArgs e)
        {
            fillgrid();
        }


        /// <summary>
        /// Bind the Non-Schedule employees list as per Schedule Type (Field Work or Office Work)
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void rdlNonScheduleScheduleType_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            bindnonschedule();
        }


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string countGroupRec(string nid)
        {
            GeneralMethod objgen = new GeneralMethod();
            string result = "";
            ClsTimeSheet objda = new ClsTimeSheet();
            DataSet ds = new DataSet();
            objda.action = "countgroupschedule";
            objda.nid = nid;
            ds = objda.schedule();
            result = objgen.serilizeinJson(ds.Tables[0]);
            return result;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string deleteschedule(string nid,string action)
        {
            GeneralMethod objgen = new GeneralMethod();
            string result = "";
            ClsTimeSheet objda = new ClsTimeSheet();
            DataSet ds = new DataSet();
            if(action=="" || action=="2")
                objda.action = "delete";
            else
                objda.action = "deletemulti";
            objda.nid = nid;
            ds = objda.schedule();
            result = "1";
            return result;
        }

    }
}







