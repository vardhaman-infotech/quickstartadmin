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
using System.Text;

namespace empTimeSheet
{
    public partial class UserDefindedFields : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();

        GeneralMethod objgen = new GeneralMethod();

        DataSet ds = new DataSet();
        DataSet dsexcel = new DataSet();

        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();

            if (!IsPostBack)
            {

                objda.id = Session["userid"].ToString();
                ds = objda.getUserInRoles();


                if (!objda.validatedRoles("5", ds) && !objda.validatedRoles("6", ds))
                {
                    Response.Redirect("UserDashboard.aspx");
                }

                filllmodule();
                fillgrid();





            }

        }

        /// <summary>
        /// Fill Projects drop down for seraching
        /// </summary>
        protected void filllmodule()
        {
            objda.action = "getModule";
            ds = objda.ManageUserDefinedField();
            if (ds.Tables[0].Rows.Count > 0)
            {
                dropmodule.DataSource = ds;
                dropmodule1.DataSource = ds;

                dropmodule.DataTextField = "modulename";
                dropmodule1.DataTextField = "modulename";

                dropmodule.DataValueField = "nid";
                dropmodule1.DataValueField = "nid";
                dropmodule.DataBind();
                dropmodule1.DataBind();


            }
            dropmodule1.Items.Insert(0, new ListItem("--All Module--", ""));
            dropmodule1.SelectedIndex = 0;

        }

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

        //Fill Grid View from Database
        public void fillgrid()
        {
            objda.id = "";
            objda.action = "selectUDF";
            objda.company = Session["companyid"].ToString();
            objda.name = txtkeyword.Text;
            objda.moduleid = dropmodule1.Text;
            objda.recid = "";

            ds = objda.ManageUserDefinedField();
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










        protected void btnsearch_click(object sender, EventArgs e)
        {
            dgnews.PageIndex = 0;
            fillgrid();

        }


        /// <summary>
        /// Set Status 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnsave_Click(object sender, EventArgs e)
        {


            fillgrid();


        }



        /// <summary>
        /// On Row Command Of Grid View
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>

        protected void dgnews_RowCommand(object sender, GridViewCommandEventArgs e)
        {

            if (e.CommandName.ToLower() == "del")
            {
                objda.id = e.CommandArgument.ToString();
                objda.action = "delete";
                objda.ManageUserDefinedField();
                fillgrid();
            }
            if (e.CommandName.ToLower() == "edititem")
            {
                hidid.Value = e.CommandArgument.ToString();
                ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);

            }
        }
        /// <summary>
        /// For Sorting in Grid View
        /// </summary>
        /// <param name="source"></param>
        /// <param name="e"></param>
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

            objda.action = "insertUDF";
            objda.id = hidid.Value;
            objda.moduleid = dropmodule.Text;
            objda.description = dropvaluetype.Text;
            objda.ctrlType = dropcontrol.Text;
            objda.ctrlVal = hiddata.Value;
            objda.valueNid = hiddatanid.Value;
            objda.company = Session["companyid"].ToString();
            ds = objda.ManageUserDefinedField();
            fillgrid();
            ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>alert('Saved Successfully!');</script>", false);
        }



        /// <summary>
        /// Blank Values
        /// </summary>
        public void blank()
        {


        }

        /// <summary>
        /// Send email to all employees who are currently scheduled
        /// </summary>
        /// <param name="dt"></param>




        protected void dgnews_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                //LinkButton lbtnstatus = (LinkButton)e.Row.FindControl("lbtnstatus");
                //LinkButton lbtndelete = (LinkButton)e.Row.FindControl("lbtndelete");
                //if (DataBinder.Eval(e.Row.DataItem, "status") != null && DataBinder.Eval(e.Row.DataItem, "status").ToString() == "Re-Schedule")
                //{

                //    lbtnstatus.Visible = false;
                //}
                //if (DataBinder.Eval(e.Row.DataItem, "scheduletype").ToString().ToLower() == "office")
                //{
                //    lbtnstatus.Visible = false;
                //}
                //if (ViewState["add"] == null || ViewState["add"].ToString() == "")
                //{
                //    lbtndelete.Visible = false;
                //}
            }
        }


    }
}







