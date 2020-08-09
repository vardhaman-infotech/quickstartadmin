using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;

namespace empTimeSheet
{
    public partial class FileCategoryMaster : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsFile objfile = new ClsFile();
        DataSet ds = new DataSet();
        DataSet dsexcel = new DataSet();
        GeneralMethod objGen = new GeneralMethod();
        protected void Page_Load(object sender, EventArgs e)
        {
            objGen.validatelogin();

            if (!Page.IsPostBack)
            {
                if (!objda.checkUserInroles("35"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
                fillgrid();
            }

        }



        public void blank()
        {


            txtname.Text = string.Empty;
            hidid.Value = "";

            btnsubmit.Text = "Save";
            btndelete.Visible = false;
        }
        protected void btnsubmit_Click(object sender, EventArgs e)
        {
            objfile.nid = hidid.Value;
            objfile.name = txtname.Text;

            //PAss this action to check whether name already exists or not
            objfile.action = "Validate";
            objfile.companyid = Session["companyid"].ToString();
            ds = objfile.FileCategoryMaster();
            if (ds.Tables[0].Rows.Count > 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "<script type='text/javascript'>alert('Category already exists, please enter other name!');opendiv();fixheader();</script>", false);


                return;
            }
            else
            {
                objfile.action = "insert";

                objfile.userid = Session["userid"].ToString();

                ds = objfile.FileCategoryMaster();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    blank();
                    fillgrid();

                    GeneralMethod.alert(this.Page, "Saved successfully!");
                }
                else
                {
                    GeneralMethod.alert(this.Page, "Could not save, try again.");
                    ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();fixheader();</script>", false);
                }

            }


        }






        protected void btnsearch_Click(object sender, EventArgs e)
        {
            dgnews.PageIndex = 0;
            fillgrid();
        }
        public void fillgrid()
        {
            objfile.nid = "";
            objfile.category = txtsearch.Text;
            objfile.action = "select";
            objfile.companyid = Session["companyid"].ToString();
            ds = objfile.FileCategoryMaster();

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
            objfile.id = hidid.Value;
            objfile.action = "delete";
            objfile.FileCategoryMaster();
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



        protected void dgnews_RowCommand(object sender, GridViewCommandEventArgs e)
        {


            if (e.CommandName.ToLower() == "remove")
            {
                objfile.action = "delete";
                objfile.nid = e.CommandArgument.ToString();
                objfile.FileCategoryMaster();

                fillgrid();
                GeneralMethod.alert(this.Page, "Deleted Successfully!");
            }
            if (e.CommandName.ToLower() == "detail")
            {
                blank();
                objfile.nid = e.CommandArgument.ToString();
                hidid.Value = objfile.nid;
                objfile.action = "select";
                ds = objfile.FileCategoryMaster();
                txtname.Text = ds.Tables[0].Rows[0]["categoryname"].ToString();


                upadatepanel1.Update();
                ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();fixheader();</script>", false);
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
            if (e.Row.RowType == DataControlRowType.DataRow)
            {

                //if (DataBinder.Eval(e.Row.DataItem, "activestatus") != null && DataBinder.Eval(e.Row.DataItem, "activestatus").ToString().ToLower() != "active")
                //{

                //    e.Row.CssClass = "inactiverecord";
                //}

            }
        }


        protected void btnexportcsv_Click(object sender, EventArgs e)
        {
            DataTable dt = new DataTable();
            StringBuilder sb = new StringBuilder();
            StringBuilder sb1 = new StringBuilder();
            bindheader();
            fillgrid();
            if (ds.Tables[0].Rows.Count > 0)
            {
                sb.Append("<table cellpadding='4' cellspacing='0' style='font-family:Calibri;font-size:12px;' border='0'>" + bindheader());
                for (int i = 0; i < dgnews.Columns.Count; i++)
                {
                    

                }
                sb.Append("<tr><th>Category Name</th></tr>");
                for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                {
                    sb.Append("<tr>");

                    //for (int i = 0; i < ds.Tables[0].Columns.Count; i++)
                    {
                        sb.Append("<td>" + ds.Tables[0].Rows[j][2].ToString() + "</td>");

                    }
                    sb.Append("</tr>");
                }
                sb.Append("</table>");
            }

           

            excelexport objexcel = new excelexport();
            objexcel.downloadFile(sb.ToString(), "FileCategories.xls");

        }
        protected string bindheader()
        {
            string str = "";
            string Companyname = Session["companyname"].ToString();

            str += "<tr><td  style='background-color:blue;color:#ffffff;font-size:16px;' align='center'>" + Companyname + "</td></tr>";
            str += "<tr><td style='background-color:blue;color:#ffffff;font-size:14px;' align='center'>File Categories</td></tr>";

            return str;

        }
    }
}