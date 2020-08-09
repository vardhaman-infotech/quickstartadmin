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
    public partial class SavedInvoices : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();
        DataSet ds1 = new DataSet();
        ClsAdmin objadmin = new ClsAdmin();
        excelexport objexcel = new excelexport();
        DataSet dsexcel = new DataSet();
        public string strcurrency = "$";
        protected void Page_Load(object sender, EventArgs e)
        {

            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                txtfromdate.Text = System.DateTime.Now.AddDays(-7).ToString("MM/dd/yyyy");
                txttodate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");

                if (!objda.checkUserInroles("37"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }

                fillclient();
                fillproject();
                fillcurrency();
                searchdata();
            }
        }

        protected void searchdata()
        {
            hidprojectname.Value = dropproject.SelectedItem.Text;
            hidclientname.Value = dropclient.SelectedItem.Text;
            hidfromdate.Value = txtfromdate.Text;
            hidtodate.Value = txttodate.Text;
            hidprojects.Value = dropproject.Text;
            hidclients.Value = dropclient.Text;
          
            fillgrid();
        }
        /// <summary>
        /// Bind currency according to current company
        /// </summary>
        protected void fillcurrency()
        {
            objadmin.action = "select";
            objadmin.nid = Session["companyid"].ToString();
            ds = objadmin.ManageCompany();
            if (ds.Tables[0].Rows.Count > 0)
            {
                strcurrency = ds.Tables[0].Rows[0]["symbol"].ToString();
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

            objts.action = "select";
            objts.companyId = Session["companyid"].ToString();
            objts.clientid = hidclients.Value;
            objts.projectid = hidprojects.Value;
            objts.invoiceno = "";
            objts.from = hidfromdate.Value;
            objts.to = hidtodate.Value;
            objts.Status = "";
            objts.nid = "";
            objts.type = "saved";
            ds = objts.GetInvoice();

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
                //  btnexportcsv.Enabled = true;

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
            updatePanelData.Update();
            dsexcel = ds;
        }


        /// <summary>
        /// Makes row as clickable and show and hide Set status link according to current status and user role
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dgnews_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Cells[0].Attributes.Add("onclick", Page.ClientScript.GetPostBackClientHyperlink(dgnews, "RowCommand$" + DataBinder.Eval(e.Row.DataItem, "nid").ToString()));
                e.Row.Cells[1].Attributes.Add("onclick", Page.ClientScript.GetPostBackClientHyperlink(dgnews, "RowCommand$" + DataBinder.Eval(e.Row.DataItem, "nid").ToString()));
                e.Row.Cells[2].Attributes.Add("onclick", Page.ClientScript.GetPostBackClientHyperlink(dgnews, "RowCommand$" + DataBinder.Eval(e.Row.DataItem, "nid").ToString()));
                e.Row.Cells[3].Attributes.Add("onclick", Page.ClientScript.GetPostBackClientHyperlink(dgnews, "RowCommand$" + DataBinder.Eval(e.Row.DataItem, "nid").ToString()));
                e.Row.Cells[4].Attributes.Add("onclick", Page.ClientScript.GetPostBackClientHyperlink(dgnews, "RowCommand$" + DataBinder.Eval(e.Row.DataItem, "nid").ToString()));
                e.Row.Cells[5].Attributes.Add("onclick", Page.ClientScript.GetPostBackClientHyperlink(dgnews, "RowCommand$" + DataBinder.Eval(e.Row.DataItem, "nid").ToString()));
                e.Row.Cells[6].Attributes.Add("onclick", Page.ClientScript.GetPostBackClientHyperlink(dgnews, "RowCommand$" + DataBinder.Eval(e.Row.DataItem, "nid").ToString()));
                e.Row.Cells[7].Attributes.Add("onclick", Page.ClientScript.GetPostBackClientHyperlink(dgnews, "RowCommand$" + DataBinder.Eval(e.Row.DataItem, "nid").ToString()));

                e.Row.Attributes["onmouseover"] = "this.style.cursor='pointer'";
                LinkButton btndel = (LinkButton)e.Row.FindControl("lbtndelete");
                if (DataBinder.Eval(e.Row.DataItem, "paymentstatus").ToString().ToLower() == "paid")
                {
                    e.Row.Cells[8].Attributes.Add("onclick", Page.ClientScript.GetPostBackClientHyperlink(dgnews, "RowCommand$" + DataBinder.Eval(e.Row.DataItem, "nid").ToString()));

                    btndel.Visible = false;
                }
                else
                {
                    objts.action = "checkinvoiceexistsinpayment";
                    objts.invoiceno = DataBinder.Eval(e.Row.DataItem, "nid").ToString();
                    ds1 = objts.GetPaymentDetails();
                    if (ds.Tables.Count > 0)
                    {
                        if (ds1.Tables[0].Rows.Count > 0)
                        {
                            btndel.Visible = false;
                        }
                    }
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
            if (e.CommandName.ToLower() == "del")
            {
                objts.nid = e.CommandArgument.ToString();
                objts.action = "delete";
                objts.GetInvoice();
                fillgrid();
            }
            if (e.CommandName.ToLower() == "rowcommand")
            {
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('ManualInvoice.aspx?invoiceid=" + e.CommandArgument.ToString() + "');", true);

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
            ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>scrolltotopofList();</script>", false);
        }
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            searchdata();

        }
        protected void btnrefresh_Click(object sender, EventArgs e)
        {
            searchdata();
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
    }
}