using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace empTimeSheet
{
    public partial class ExpenseMaster : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds1 = new DataSet();
        DataSet ds = new DataSet();
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!objda.checkUserInroles("4"))
            {
                Response.Redirect("UserDashboard.aspx");
            }
            if (!Page.IsPostBack)
            {
                fillgrid();
            }
        }



        public void blank()
        {
            txtcode.Text = string.Empty;
            txtcode.Enabled = true;
            txtdescription.Text = "";
            txtcostrate.Text = "";
            txtbillrate.Text = "";
            txtMuAmount.Text = "";
            //dropdepartment.SelectedIndex = 0;
            txtname.Text = string.Empty;
            hidid.Value = "";
            dropactive.SelectedIndex = 0;

            btnsubmit.Text = "Save";
            btndelete.Visible = false;
            rbtnbillable.SelectedIndex = 1;
            rbtnReimb.SelectedIndex = 1;
        }
        protected void btnsubmit_Click(object sender, EventArgs e)
        {
            objts.nid = hidid.Value;
            objts.companyId = Session["companyid"].ToString();

            objts.action = "checkexist";
            objts.Code = txtcode.Text;
            objts.name = txtname.Text;
            objts.type = "Expense";
            ds = objts.ManageTasks();
            if (ds.Tables[0].Rows.Count > 0)
            {

                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "<script type='text/javascript'>alert('Expense ID already exists!');opendiv();</script>", false);
                return;
            }

            objts.action = "insert";
            objts.nid = hidid.Value;

            objts.description = txtdescription.Text;
            objts.Status = dropactive.Text;
            objts.isbillable = rbtnbillable.Text;
            objts.deptID = "";
            if (txtcostrate.Text != "")
            {
                objts.costrate = txtcostrate.Text;
                objts.billrate = txtcostrate.Text;

            }
            else
            {
                objts.costrate = "0.00";
                objts.billrate = "0.00";
            }
            if (txtbillrate.Text != "")
                objts.tax = txtbillrate.Text;
            else
                objts.tax = "0.00";

            objts.hours = "0.00";
            objts.isRemimb = rbtnReimb.Text;
            if (txtMuAmount.Text != "")
            {
                objts.MU = txtMuAmount.Text;
            }
            else
            {
                objts.MU = "0.00";
            }


            //objts.billrate = rbtnbillable.Text;
            objts.CreatedBy = Session["userid"].ToString();
            ds = objts.ManageTasks();
            if (ds.Tables[0].Rows.Count > 0)
            {
                blank();
                fillgrid();
                GeneralMethod.alert(this.Page, "Saved Successfully!");
            }
        }

        /// <summary>
        /// Fill Employee to select as a manager
        /// </summary>

        protected void liaddnew_Click(object sender, EventArgs e)
        {
            blank();
            ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);
        }


        protected void btnsearch_Click(object sender, EventArgs e)
        {
            dgnews.PageIndex = 0;
            fillgrid();
        }
        public void fillgrid()
        {
            objts.name = txtsearch.Text;
            objts.action = "select";
            objts.companyId = Session["companyid"].ToString();
            objts.nid = "";
            objts.deptID = "";
            objts.type = "Expense";
            objts.Status = drostatus1.Text;
            objts.isbillable = "";
            ds = objts.ManageTasks();

            DataTable dt = new DataTable();
            dt = ds.Tables[0];

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
                if (ViewState["SortDirection"] != null && ViewState["SortExpression"] != null)
                {
                    dt.DefaultView.Sort = ViewState["SortExpression"].ToString() + " " + ViewState["SortDirection"].ToString();
                }
                Session["TaskTable"] = dt;

                dgnews.DataSource = dt;
                dgnews.DataBind();
                //btnexportcsv.Enabled = true;

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

        protected void btndelete_Click(object sender, EventArgs e)
        {
            objts.action = "delete";
            objts.nid = hidid.Value;
            ds = objts.ManageTasks();
            blank();
            fillgrid();
            GeneralMethod.alert(this.Page, "Deleted Successfully!");
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

        protected void PaggedGridbtnedit_Click(object sender, EventArgs e)
        {
           

            objts.action = "select";
            objts.nid = hidid.Value;
            blank();
            ds = objts.ManageTasks();
            if (ds.Tables[0].Rows.Count > 0)
            {
                hidid.Value = ds.Tables[0].Rows[0]["nid"].ToString();
                txtcode.Text = ds.Tables[0].Rows[0]["taskcode"].ToString();
                txtname.Text = ds.Tables[0].Rows[0]["taskname"].ToString();
                txtdescription.Text = ds.Tables[0].Rows[0]["description"].ToString();
                dropactive.Text = ds.Tables[0].Rows[0]["activestatus"].ToString();
                if (Convert.ToBoolean(ds.Tables[0].Rows[0]["isBillable"].ToString()) == true)
                {
                    rbtnbillable.SelectedValue = "1";

                }
                else
                {
                    rbtnbillable.SelectedValue = "0";
                }
                if (ds.Tables[0].Rows[0]["isReimb"] != DBNull.Value)
                {
                    if (Convert.ToBoolean(ds.Tables[0].Rows[0]["isReimb"].ToString()) == true)
                    {
                        rbtnReimb.SelectedValue = "1";

                    }
                    else
                    {
                        rbtnReimb.SelectedValue = "0";
                    }
                }
                //rbtnbillable.SelectedValue = ds.Tables[0].Rows[0]["isBillable"].ToString();
                txtcostrate.Text = ds.Tables[0].Rows[0]["costrate"].ToString();
                txtbillrate.Text = ds.Tables[0].Rows[0]["tax"].ToString();
                txtMuAmount.Text = (ds.Tables[0].Rows[0]["MuRate"] == DBNull.Value || ds.Tables[0].Rows[0]["MuRate"] == null) ? "0.00" : ds.Tables[0].Rows[0]["MuRate"].ToString();

                btnsubmit.Text = "Update";
                btndelete.Visible = true;
                upadatepanel1.Update();
                ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);
            }
        }

        protected void dgnews_RowCommand(object sender, GridViewCommandEventArgs e)
        {


            if (e.CommandName.ToLower() == "remove")
            {
                objts.action = "delete";
                objts.nid = e.CommandArgument.ToString();
                ds = objts.ManageTasks();

               
                if (ds.Tables[0].Rows[0]["Status"].ToString() == "Success") {
                    GeneralMethod.alert(this.Page, "Record deleted successfully!");
                } else {
                    GeneralMethod.alert(this.Page, "Unable to delete record, this have entiry with a employee");
                }
                fillgrid();
               
            }
            if (e.CommandName.ToLower() == "detail")
            {
              

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

        protected void dgnews_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.Header)
                e.Row.TableSection = TableRowSection.TableHeader;
            if (e.Row.RowType == DataControlRowType.DataRow)
            {

                //if (DataBinder.Eval(e.Row.DataItem, "activestatus") != null && DataBinder.Eval(e.Row.DataItem, "activestatus").ToString().ToLower() != "active")
                //{

                //    e.Row.CssClass = "inactiverecord";
                //}

            }
        }



    }
}