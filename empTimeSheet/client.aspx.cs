using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using System.Globalization;
using System.Collections.ObjectModel;
using System.IO;

namespace empTimeSheet
{
    public partial class client : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds1 = new DataSet();
        DataSet ds = new DataSet();
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {




                if (!objda.checkUserInroles("3"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }

                //   gettimezone();
                fillgrid();
                fillmanager();
                fillgroups();
                fillcountry();
            }
        }
        public void fillgroups()
        {

            objuser.action = "select";


            objuser.id = "";
            objuser.createdby = "";
            objuser.clientname = "";
            objuser.name = "";
            objuser.companyid = Session["companyid"].ToString();
            ds = objuser.ManageClientGroup();
            if (ds.Tables[0].Rows.Count > 0)
            {
                chkClientGroup.DataSource = ds;
                chkClientGroup.DataTextField = "grouptitle";
                chkClientGroup.DataValueField = "nid";
                chkClientGroup.DataBind();

            }
        }
        public void gettimezone()
        {


            DateTimeFormatInfo dateFormats = CultureInfo.CurrentCulture.DateTimeFormat;
            ReadOnlyCollection<TimeZoneInfo> timeZones = TimeZoneInfo.GetSystemTimeZones();
            DataTable dt = new DataTable();
            dt.Columns.Add("id");
            dt.Columns.Add("displayname");
            dt.Columns.Add("standardname");
            dt.Columns.Add("DaylightName");
            dt.Columns.Add("country");
            dt.Columns.Add("offset");
            dt.Columns.Add("offset1");


            foreach (TimeZoneInfo timeZone in timeZones)
            {
                DataRow ro = dt.NewRow();
                ro["id"] = timeZone.Id;
                ro["displayname"] = timeZone.DisplayName;
                ro["standardname"] = timeZone.StandardName;
                ro["DaylightName"] = timeZone.DaylightName;
                ro["country"] = "";

                DateTime localtime = TimeZoneInfo.ConvertTime(DateTime.Now,
                 TimeZoneInfo.FindSystemTimeZoneById(timeZone.Id));
                DateTime utctime = System.DateTime.UtcNow;


                ro["offset"] = timeZone.BaseUtcOffset.ToString();
                ro["offset1"] = localtime.Subtract(utctime).TotalMinutes;

                dt.Rows.Add(ro);
            }
            dt.AcceptChanges();
        }



        /// <summary>
        /// When Add new button clicked
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void liaddnew_Click(object sender, EventArgs e)
        {
            blank();
            ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);
        }

        /// <summary>
        /// Fill Employee to select as a manager
        /// </summary>
        protected void fillmanager()
        {
            objuser.action = "selectactive";
            objuser.companyid = Session["companyid"].ToString();
            objuser.id = "";
            ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0)
            {
                dropmanager.DataSource = ds;
                dropmanager.DataTextField = "username";
                dropmanager.DataValueField = "nid";
                dropmanager.DataBind();
                ListItem li = new ListItem("--Select--", "");
                dropmanager.Items.Insert(0, li);
                dropmanager.SelectedIndex = 0;


            }


        }

        /// <summary>
        /// Fill list of existing clients
        /// </summary>
        public void fillgrid()
        {
            objuser.clientname = txtsearch.Text;
            objuser.action = "select";
            objuser.companyid = Session["companyid"].ToString();
            objuser.id = "";
            objuser.activestatus = drostatus.Text;
            ds = objuser.client();

            DataTable dt = new DataTable();
            dt = ds.Tables[0];

            //int start = dgnews.PageSize * dgnews.PageIndex;
            //int end = start + dgnews.PageSize;
            //start = start + 1;
            //if (end >= ds.Tables[0].Rows.Count)
            //    end = ds.Tables[0].Rows.Count;
            //lblstart.Text = start.ToString();
            //lblend.Text = end.ToString();
            //lbltotalrecord.Text = ds.Tables[0].Rows.Count.ToString();

            if (ds.Tables[0].Rows.Count > 0)
            {
                //if (ViewState["SortDirection"] != null && ViewState["SortExpression"] != null)
                //{
                //    dt.DefaultView.Sort = ViewState["SortExpression"].ToString() + " " + ViewState["SortDirection"].ToString();
                //}
                Session["TaskTable"] = dt;

                dgnews.DataSource = dt;
                dgnews.DataBind();
                btnexportcsv.Enabled = true;

                nodata.Visible = false;
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
                    nodata.Visible = true;
                }
                dgnews.Visible = false;

                Session["TaskTable"] = null;
            }
            updateData.Update();
            ScriptManager.RegisterStartupScript(updateData, updateData.GetType(), "key", "<script type='text/javascript'>fixheader();</script>", false);

        }
        protected void dgnews_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            dgnews.PageIndex = e.NewPageIndex;
            fillgrid();

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
        protected void btnexportcsv_Click(object sender, EventArgs e)
        {
            DataTable dt = new DataTable();
            StringBuilder sb = new StringBuilder();
            bindheader();
            fillgrid();
            if (ds.Tables[0].Rows.Count > 0)
            {
                sb.Append("<table cellpadding='4' cellspacing='0' style='font-family:Calibri;font-size:12px;' border='0'>" + bindheader() + "<tr><th style='text-align:center;'>S.No.</th><th  style='text-align:left;'>Client Code</th><th style='text-align:left;'>Client Name</th><th style='text-align:left;'>Contact Name</th><th style='text-align:left;'>Email Id</th><th style='text-align:left;'>Phone</th><th style='text-align:left;'>Cell</th><th style='text-align:left;'>Fax</th><th style='text-align:left;'>Website</th><th style='text-align:left;'>Address</th><th style='text-align:left;'>City</th><th style='text-align:left;'>State</th><th style='text-align:left;'>Country</th><th style='text-align:left;'>ZIP</th><th style='text-align:left;'>Manager</th><th style='text-align:left;'>Active Status</th></tr>");

                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    if (ds.Tables[0].Rows[i]["activestatus"].ToString().ToLower() == "block")
                        sb.Append("<tr style= 'color:red;'><td style='text-align:center;'>" + (i + 1).ToString() + "</td><td>" + ds.Tables[0].Rows[i]["code"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["clientname"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["company"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["email"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["phone"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["mobile"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["fax"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["website"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["street"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["city"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["state"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["country"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["zip"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["managername"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["activestatus"].ToString() + "</td></tr>");
                    else
                        sb.Append("<tr><td style='text-align:center;'>" + (i + 1).ToString() + "</td><td>" + ds.Tables[0].Rows[i]["code"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["clientname"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["company"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["email"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["phone"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["mobile"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["fax"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["website"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["street"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["city"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["state"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["country"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["zip"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["managername"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["activestatus"].ToString() + "</td></tr>");

                }
                sb.Append("</table>");

            }

            excelexport objexcel = new excelexport();
            objexcel.downloadFile(sb.ToString(), "Client.xls");

        }
        protected string bindheader()
        {
            string str = "";
            string Companyname = Session["companyname"].ToString();

            str += "<tr><td colspan='16' style='background-color:blue;color:#ffffff;font-size:16px;' align='center'>" + Companyname + "</td></tr>";
            str += "<tr><td colspan='16' style='background-color:blue;color:#ffffff;font-size:14px;' align='center'>Client List</td></tr>";

            return str;

        }
        /// <summary>
        /// Save information
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnsubmit_Click(object sender, EventArgs e)
        {
            objuser.id = hidid.Value;
            objuser.companyid = Session["companyid"].ToString();
            objuser.action = "checkexist";
            objuser.loginid = txtclientcode.Text;
            ds = objuser.client();
            if (ds.Tables[0].Rows.Count > 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "<script type='text/javascript'>alert('Client ID already exists!');opendiv();fixheader();</script>", false);

                return;
            }
            objuser.action = "insert";

            objuser.clientname = txtname.Text;
            objuser.companyname = txtcompany.Text;
            objuser.street = txtstreet1.Text;
            if (dropcountry1.Text != "")

                objuser.country = dropcountry1.SelectedItem.Text;

            else
                objuser.country = "";
            if (dropstate1.Text != "")

                objuser.state = dropstate1.SelectedItem.Text;
            else
                objuser.state = "";
            if (dropcity1.Text != "")
                objuser.city = dropcity1.SelectedItem.Text;
            else
                objuser.city = "";
            objuser.email = txtemail1.Text;
            objuser.phone = txtphone1.Text;
            objuser.mobile = txtcell1.Text;
            objuser.website = txtwebsite.Text;
            objuser.zip = txtzip1.Text;
            objuser.activestatus = dropactive.Text;
            objuser.fax = txtfax1.Text;

            objuser.managerid = dropmanager.Text;
            objuser.createdby = Session["userid"].ToString();
            objuser.activestatus = dropactive.Text;
            objuser.desigid = txtdesignation.Text;
            objuser.address2 = txtaddress2.Text;
            objuser.workphone = txtworkphone.Text;
            ds = objuser.client();

            if (ds.Tables[0].Rows.Count > 0)
            {


                objuser.id = hidaddress.Value;
                objuser.userid = ds.Tables[0].Rows[0]["nid"].ToString();
                objuser.usertype = "Client";
                objuser.name = txttitle.Text;
                objuser.street = txtstreet.Text;
                if (dropcountry.Text != "")
                    objuser.country = dropcountry.SelectedItem.Text;
                else
                    objuser.country = "";
                if (dropstate.Text != "")
                    objuser.state = dropstate.SelectedItem.Text;
                else
                    objuser.state = "";
                if (dropcity.Text != "")
                    objuser.city = dropcity.SelectedItem.Text;
                else
                    objuser.city = "";
                objuser.email = txtemail.Text;
                objuser.phone = txtphone.Text;
                objuser.mobile = txtcell.Text;
                objuser.remark = txtremark.Text;
                objuser.zip = txtzip.Text;

                ds = objuser.address();

                string strgroup = "";
                for (int i = 0; i < chkClientGroup.Items.Count; i++)
                {
                    if (chkClientGroup.Items[i].Selected)
                    {
                        strgroup = strgroup + chkClientGroup.Items[i].Value + ",";
                    }
                }
                objuser.clientname = strgroup;
                objuser.id = objuser.userid;
                objuser.action = "insertclientingroup";
                ds = objuser.ManageClientGroup();

                blank();
                fillgrid();
                GeneralMethod.alert(this.Page, "Saved Successfully!");
            }


        }
        protected void dgnews_RowCommand(object sender, GridViewCommandEventArgs e)
        {


            if (e.CommandName.ToLower() == "remove")
            {
                objuser.action = "delete";
                objuser.id = e.CommandArgument.ToString();
                ds = objuser.client();

                fillgrid();
                GeneralMethod.alert(this.Page, "Deleted Successfully!");
            }
            if (e.CommandName.ToLower() == "detail")
            {

            }
        }

        protected void PaggedGridbtnedit_Click(object sender, EventArgs e)
        {


            objuser.id = hidid.Value;
            blank();
            hidid.Value = objuser.id;
            objuser.action = "select";
            objuser.name = txtsearch.Text;

            ds = objuser.client();
            //txtclientcode.Enabled = false;
            txtname.Text = ds.Tables[0].Rows[0]["clientname"].ToString();
            txtcompany.Text = ds.Tables[0].Rows[0]["company"].ToString();

            try
            {
                dropmanager.Text = ds.Tables[0].Rows[0]["managerid"].ToString();
            }
            catch
            {
                dropmanager.SelectedIndex = 0;
            }

            txtclientcode.Text = ds.Tables[0].Rows[0]["code"].ToString();
            txtdesignation.Text = ds.Tables[0].Rows[0]["designation"].ToString();
            dropactive.Text = ds.Tables[0].Rows[0]["ActiveStatus"].ToString();
            ListItem itemToSelect;
            try
            {
                if (Convert.ToString(ds.Tables[0].Rows[0]["country"]) != "")
                {
                    //Get the List Item if matched with the name existing in database COUNTRY field
                    itemToSelect = dropcountry1.Items.FindByText(ds.Tables[0].Rows[0]["country"].ToString());

                    //Check whether item found or not, NULL indicates- item not found
                    if (itemToSelect != null)
                    {
                        //if found- select Listitem's value in dropdown
                        dropcountry1.Text = itemToSelect.Value;

                    }
                    int index = dropcountry1.SelectedIndex;
                    fillstate(dropstate1, dropcity1, dropcountry1.Text);
                }

                if (Convert.ToString(ds.Tables[0].Rows[0]["state"]) != "")
                {
                    itemToSelect = dropstate1.Items.FindByText(ds.Tables[0].Rows[0]["state"].ToString());

                    if (itemToSelect != null)
                    {
                        dropstate1.Text = itemToSelect.Value;

                    }
                    fillcity(dropcity1, dropstate1.Text);
                }
            }
            catch { }
            try
            {
                dropcity1.Text = Convert.ToString(ds.Tables[0].Rows[0]["city"]);
            }
            catch
            {
            }

            txtzip1.Text = Convert.ToString(ds.Tables[0].Rows[0]["zip"]);
            txtphone1.Text = Convert.ToString(ds.Tables[0].Rows[0]["phone"]);
            txtstreet1.Text = Convert.ToString(ds.Tables[0].Rows[0]["street"]);
            txtcell1.Text = Convert.ToString(ds.Tables[0].Rows[0]["mobile"]);
            txtfax1.Text = Convert.ToString(ds.Tables[0].Rows[0]["fax"]);
            txtwebsite.Text = Convert.ToString(ds.Tables[0].Rows[0]["website"]);
            txtemail1.Text = Convert.ToString(ds.Tables[0].Rows[0]["email"]);

            if (ds.Tables[1].Rows.Count > 0)
            {
                hidaddress.Value = Convert.ToString(ds.Tables[1].Rows[0]["nid"]);
                txtzip.Text = Convert.ToString(ds.Tables[1].Rows[0]["zip"]);
                txtphone.Text = Convert.ToString(ds.Tables[1].Rows[0]["phone"]);
                txtstreet.Text = Convert.ToString(ds.Tables[1].Rows[0]["street"]);
                txtcell.Text = Convert.ToString(ds.Tables[1].Rows[0]["mobile"]);
                txtfax.Text = Convert.ToString(ds.Tables[1].Rows[0]["fax"]);
                txtremark.Text = Convert.ToString(ds.Tables[1].Rows[0]["remark"]);
                txtemail.Text = Convert.ToString(ds.Tables[1].Rows[0]["email"]);
                txttitle.Text = Convert.ToString(ds.Tables[1].Rows[0]["name"]);
                if (Convert.ToString(ds.Tables[1].Rows[0]["country"]) != "")
                {
                    itemToSelect = dropcountry.Items.FindByText(ds.Tables[1].Rows[0]["country"].ToString());

                    //check whether item exists with passed country name
                    if (itemToSelect != null)
                    {
                        //if name exists, select value of listitem
                        dropcountry.Text = itemToSelect.Value;

                    }
                    int index = dropcountry.SelectedIndex;
                    fillstate(dropstate, dropcity, dropcountry.Text);
                }

                if (Convert.ToString(ds.Tables[1].Rows[0]["state"]) != "")
                {
                    itemToSelect = dropstate.Items.FindByText(ds.Tables[1].Rows[0]["state"].ToString());

                    if (itemToSelect != null)
                    {
                        dropstate.Text = itemToSelect.Value;

                    }
                    fillcity(dropcity, dropstate.Text);
                }

                dropcity.Text = Convert.ToString(ds.Tables[1].Rows[0]["city"]);

            }
           
                for(int i=0;i<chkClientGroup.Items.Count;i++)
                {
                    chkClientGroup.Items[i].Selected = false;

                     if (ds.Tables[2].Rows.Count > 0)
                    {
                        for (int j = 0; j < ds.Tables[2].Rows.Count; j++)
                        {
                            if(ds.Tables[2].Rows[j]["nid"].ToString()==chkClientGroup.Items[i].Value)
                            {
                                chkClientGroup.Items[i].Selected = true;
                            }

                        }

                     }
                }

           
            btnsubmit.Text = "Update";
            btndelete.Visible = true;
            upadatepanel1.Update();
            ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);
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

        protected void dgnews_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.Header)
                e.Row.TableSection = TableRowSection.TableHeader;
            if (e.Row.RowType == DataControlRowType.DataRow)
            {

                if (DataBinder.Eval(e.Row.DataItem, "activestatus") != null && DataBinder.Eval(e.Row.DataItem, "activestatus").ToString().ToLower() != "active")
                {

                    e.Row.CssClass = "inactiverecord";
                }

            }
        }

        /// <summary>
        /// Reset values
        /// </summary>
        public void blank()
        {
            txtclientcode.Text = string.Empty;
            txtname.Text = string.Empty;
            txtcompany.Text = string.Empty;
            txtemail.Text = string.Empty;
            txtcell.Text = string.Empty;
            txtfax.Text = string.Empty;
            txtphone.Text = string.Empty;
            txtremark.Text = string.Empty;
            txtstreet.Text = string.Empty;
            txttitle.Text = string.Empty;
            txtzip.Text = string.Empty;
            dropmanager.SelectedIndex = 0;
            dropactive.SelectedIndex = 0;
            dropstate.SelectedIndex = 0;
            dropstate1.SelectedIndex = 0;
            dropcountry.SelectedIndex = 0;
            dropcountry1.SelectedIndex = 0;
            dropcity.SelectedIndex = 0;
            dropcity1.SelectedIndex = 0;

            txtemail1.Text = string.Empty;
            txtcell1.Text = string.Empty;
            txtfax1.Text = string.Empty;
            txtphone1.Text = string.Empty;
            txtaddress2.Text = string.Empty;
            txtworkphone.Text = string.Empty;

            txtstreet1.Text = string.Empty;
            txtwebsite.Text = "";
            txtzip1.Text = string.Empty;
            hidid.Value = "";
            hidaddress.Value = "";
            btndelete.Visible = false;
            btnsubmit.Text = "Submit";
            txtclientcode.Enabled = true;
            txtdesignation.Text = "";

        }

        /// <summary>
        /// When search any record
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            fillgrid();
        }

        /// <summary>
        /// Fill country
        /// </summary>
        public void fillcountry()
        {
            objda.id = "";
            objda.action = "selectcountry";
            ds1 = objda.ManageMaster();
            dropcountry.DataSource = ds1;
            dropcountry.DataTextField = "countryname";
            dropcountry.DataValueField = "nid";

            dropcountry1.DataSource = ds1;
            dropcountry1.DataTextField = "countryname";
            dropcountry1.DataValueField = "nid";

            dropcountry.DataBind();
            dropcountry1.DataBind();
            ListItem li = new ListItem("--Select--", "");
            dropcountry.Items.Insert(0, li);
            dropcountry.SelectedIndex = 0;

            dropcountry1.Items.Insert(0, li);
            dropcountry1.SelectedIndex = 0;
            //Fill state dropdown (dropstate1- For GENERAL TAB) for selected country, if no country has selected it will bind a blank value 
            fillstate(dropstate1, dropcity1, dropcountry1.Text);
            //Fill state dropdown (dropstate- For CONTACT TAB) for selected country, if no country has selected it will bind a blank value 
            fillstate(dropstate, dropcity, dropcountry.Text);

        }

        /// <summary>
        /// Fill state
        /// </summary>
        public void fillstate(DropDownList ddlstate, DropDownList ddlcity, string countryid)
        {
            ddlstate.Items.Clear();
            if (countryid != "")
            {
                objda.id = "";
                objda.parentid = countryid;
                objda.action = "selectstate";
                ds1 = objda.ManageMaster();
                ddlstate.DataSource = ds1;
                ddlstate.DataTextField = "statename";
                ddlstate.DataValueField = "nid";


                ddlstate.DataBind();
            }

            ListItem li = new ListItem("--Select--", "");

            ddlstate.Items.Insert(0, li);
            ddlstate.SelectedIndex = 0;
            //Fill city dropdown For GENERAL TAB and  for selected country, if no country has selected it will bind a blank value 

            fillcity(ddlcity, ddlstate.Text);
            upadatepanel1.Update();
        }

        /// <summary>
        /// Fill city
        /// </summary>
        public void fillcity(DropDownList ddlcity, string stateid)
        {
            ddlcity.Items.Clear();
            if (stateid != "")
            {
                objda.id = "";
                objda.action = "selectcity";
                objda.parentid = stateid;
                ds1 = objda.ManageMaster();
                ddlcity.DataSource = ds1;
                ddlcity.DataTextField = "cityname";
                ddlcity.DataValueField = "cityname";
                ddlcity.DataBind();
            }


            ListItem li = new ListItem("--Select--", "");
            ddlcity.Items.Insert(0, li);
            ddlcity.SelectedIndex = 0;



        }

        /// <summary>
        /// when selects country
        /// Event fires for  selects country in GENERAL tab 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dropcountry1_SelectedIndexChanged(object sender, EventArgs e)
        {
            // DropDownList ddlcountry = (DropDownList)sender;

            fillstate(dropstate1, dropcity1, dropcountry1.Text);
            ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);
        }
        /// <summary>
        /// when selects country
        /// Event fires for  selects country in GENERAL tab 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dropcountry_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddlcountry = (DropDownList)sender;

            fillstate(dropstate, dropcity, dropcountry.Text);
            ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);
        }

        /// <summary>
        /// when selects state
        /// Event fires when selects state in GENERAL tab
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dropstate1_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddlstate = (DropDownList)sender;
            fillcity(dropcity1, dropstate1.Text);
            upadatepanel1.Update();
            ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);
        }

        /// <summary>
        /// when selects state
        /// Event fires when selects state in GENERAL tab
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dropstate_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddlstate = (DropDownList)sender;
            fillcity(dropcity, dropstate.Text);
            ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);
        }

        /// <summary>
        /// Delete selected record
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btndelete_Click(object sender, EventArgs e)
        {
            objuser.action = "delete";
            objuser.id = hidid.Value;
            ds = objuser.client();
            blank();
            fillgrid();
            GeneralMethod.alert(this.Page, "Deleted Successfully!");
        }
    }
}