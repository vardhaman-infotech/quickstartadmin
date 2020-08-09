using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace empTimeSheet
{
    public partial class informationType : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();

        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {




                if (!objda.checkUserInroles("109"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }

                fillLocation();
                fillgrid();

            }
        }




        protected void liaddnew_Click(object sender, EventArgs e)
        {
            blank();
            ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);
        }

        /// <summary>
        /// Fill Employee to select as a manager
        /// </summary>
        protected void fillLocation()
        {
            objda.action = "getallLocation";
            objda.company = Session["companyid"].ToString();
            objda.id = "";
            ds = objda.ManageInformationType();
            if (ds.Tables[0].Rows.Count > 0)
            {
                droplocation.DataSource = ds;
                droplocation.DataTextField = "locationName";
                droplocation.DataValueField = "nid";
                droplocation.DataBind();
                droplocation.Items.Insert(0, new ListItem("-Select One-", ""));
                droplocation.Items.Insert(droplocation.Items.Count, new ListItem("Add", "add"));
                droplocation.SelectedIndex = 0;

                droplocation1.DataSource = ds;
                droplocation1.DataTextField = "locationName";
                droplocation1.DataValueField = "nid";
                droplocation1.DataBind();
                droplocation1.Items.Insert(0, new ListItem("", ""));
                droplocation1.SelectedIndex = 0;


            }


        }

        /// <summary>
        /// Fill list of existing clients
        /// </summary>
        public void fillgrid()
        {
            objda.title = txtsearch.Text;
            objda.action = "select";
            objda.company = Session["companyid"].ToString();
            objda.id = "";
            objda.location = droplocation1.Text;
            ds = objda.ManageInformationType();

            DataTable dt = new DataTable();
            dt = ds.Tables[0];


            if (ds.Tables[0].Rows.Count > 0)
            {

                Session["TaskTable"] = dt;

                dgnews.DataSource = dt;
                dgnews.DataBind();


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

        /// <summary>
        /// Save information
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnsubmit_Click(object sender, EventArgs e)
        {
            objda.id = hidid.Value;
            objda.company = Session["companyid"].ToString();
            objda.action = "insert";
            objda.location = droplocation.Text;
            objda.title = txtname.Text;
            objda.description = txtdes.Text;
            ds = objda.ManageInformationType();


            blank();
            fillgrid();
            GeneralMethod.alert(this.Page, "Saved Successfully!");



        }
        protected void dgnews_RowCommand(object sender, GridViewCommandEventArgs e)
        {


            if (e.CommandName.ToLower() == "remove")
            {
                objda.action = "delete";
                objda.id = e.CommandArgument.ToString();
                ds = objda.ManageInformationType();

                fillgrid();
                GeneralMethod.alert(this.Page, "Deleted Successfully!");
            }
            if (e.CommandName.ToLower() == "detail")
            {

            }
        }

        protected void PaggedGridbtnedit_Click(object sender, EventArgs e)
        {


            objda.id = hidid.Value;
            blank();
            hidid.Value = objda.id;
            objda.action = "select";


            ds = objda.ManageInformationType();
            //txtclientcode.Enabled = false;
            txtname.Text = ds.Tables[0].Rows[0]["typetitle"].ToString();
            txtdes.Text = ds.Tables[0].Rows[0]["typeDes"].ToString();
            droplocation.Text = ds.Tables[0].Rows[0]["locationid"].ToString();

         

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
            
        }

        /// <summary>
        /// Reset values
        /// </summary>
        public void blank()
        {
            txtname.Text = "";
            txtdes.Text = "";
            droplocation.Text = "";
            hidid.Value = "";
            hidaddress.Value = "";
            btndelete.Visible = false;
            btnsubmit.Text = "Submit";
         

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

       
        protected void btndelete_Click(object sender, EventArgs e)
        {
            objda.action = "delete";
            objda.id = hidid.Value;
            ds = objda.ManageInformationType();
            blank();
            fillgrid();
            GeneralMethod.alert(this.Page, "Deleted Successfully!");
        }
    }
}