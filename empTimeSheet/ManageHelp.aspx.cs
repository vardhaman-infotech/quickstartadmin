using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script.Services;
using System.Data;

namespace empTimeSheet
{
    public partial class ManageHelp : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        DataSet ds = new DataSet();
        DataSet ds1 = new DataSet();
        DataSet dsexcel = new DataSet();
        GeneralMethod objgen = new GeneralMethod();
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                //Role "1" indicates role to "Manage Master" 
                //Here check whther user have this role, if not then redirect user to home page
                if (!objda.checkUserInroles("1"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }

                bindgrid();
            }

        }

        protected void bindgrid()
        {

            objda.id = "";
            objda.name = txtsearch.Text;
            objda.action = "select";
            objda.company = Session["CompanyId"].ToString();

            ds = objda.HelpMaster();

            if (ds.Tables[0].Rows.Count > 0)
            {
                int start = dgnews.PageSize * dgnews.CurrentPageIndex;
                int end = start + dgnews.PageSize;
                start = start + 1;
                if (end >= ds.Tables[0].Rows.Count)
                    end = ds.Tables[0].Rows.Count;
                lblstart.Text = start.ToString();
                lblend.Text = end.ToString();
                lbltotalrecord.Text = ds.Tables[0].Rows.Count.ToString();

                dgnews.DataSource = ds;
                dgnews.DataBind();
                divmsg.Visible = false;

            }
            else
            {
                lbltotalrecord.Text = "0";
                lblend.Text = "0";
                lblstart.Text = "0";
                divmsg.Visible = true;
                dgnews.DataSource = null;
                dgnews.DataBind();
            }

        }
        protected void lbtnaddnew_Click(object sender, EventArgs e)
        {

            blank();
            ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);
        }
        protected void blank()
        {
            hidid.Value = "";
            txtname.Text = "";
            txtcategory.Text = "";
            txtdesc.Content = "";
       //  txtdesc.Content = "";
        }

        protected void btnsubmit_Click(object sender, EventArgs e)
        {
            objda.id = hidid.Value;

            //PAss this action to check whether name already exists or not
            objda.action = "validateHelp";
            objda.company = Session["CompanyId"].ToString();
            objda.name = txtname.Text;
            objda.parentid = txtcategory.Text;
           objda.description = txtdesc.Content;

            ds = objda.HelpMaster();
            //If DS return some row means- entered name already exists, in this case ALERT user with appropriate message
            if (ds.Tables.Count > 0)
            {
                if (ds.Tables[0].Rows.Count > 0)
                {
                    GeneralMethod.alert(this.Page, "Topic already exists");
                    //Focus on named textbox
                    //txtname.Focus();
                    //Reopen the popup
                    ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);
                    return;
                }
                else
                {
                    objda.action = "insert";


                    ds = objda.HelpMaster();
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        blank();
                        bindgrid();

                        GeneralMethod.alert(this.Page, "Saved successfully!");
                    }
                    else
                    {
                        GeneralMethod.alert(this.Page, "Could not save, try again.");
                        ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);
                    }
                }
            }
        }

        protected void dgnews_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            objda.id = e.CommandArgument.ToString();
            if (e.CommandName.ToString().ToLower() == "edititem")
            {

                hidid.Value = objda.id;
                objda.action = "select";
                ds = objda.HelpMaster();
                txtname.Text = ds.Tables[0].Rows[0]["topic"].ToString();
                txtdesc.Content = ds.Tables[0].Rows[0]["description"].ToString();
                txtcategory.Text = ds.Tables[0].Rows[0]["category"].ToString();
                legendaction.InnerHtml = "Edit Help";
                ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);
            }
            if (e.CommandName == "deleteitem")
            {
                objda.action = "delete";
                objda.HelpMaster();
                bindgrid();
            }
        }

        protected void lnkprevious_Click(object sender, EventArgs e)
        {
            if (dgnews.CurrentPageIndex > 0)
            {
                dgnews.CurrentPageIndex = dgnews.CurrentPageIndex - 1;
                bindgrid();
            }
        }

        protected void lnknext_Click(object sender, EventArgs e)
        {
            if (int.Parse(lbltotalrecord.Text) > int.Parse(lblend.Text))
            {
                dgnews.CurrentPageIndex = dgnews.CurrentPageIndex + 1;
                bindgrid();
            }
        }

        protected void dgnews_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
        {
            dgnews.CurrentPageIndex = e.NewPageIndex;
            bindgrid();

        }

        protected void dgnews_SortCommand(object source, DataGridSortCommandEventArgs e)
        {
           // Retrieve the table from the session object.
            DataTable dt = Session["TaskTable"] as DataTable;

            if (dt != null)
            {

               // Sort the data.
                dt.DefaultView.Sort = e.SortExpression + " " + GetSortDirection(e.SortExpression);
                dgnews.DataSource = Session["TaskTable"];
                dgnews.DataBind();
            }
        }
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
        protected void btnsearch_OnClick(object sender, EventArgs e)
        {
            bindgrid();

        }

        /// <summary>
        /// Method to show intellisense when user search any topic
        /// </summary>
        /// <param name="prefixText"></param>
        /// <returns></returns>
        [ScriptMethod()]
        [WebMethod]
        public static List<string> getTopic(string prefixText)
        {
            DataAccess objda = new DataAccess();
            DataSet ds1 = new DataSet();
            objda.action = "selectcategory";
            objda.parentid = prefixText;
            ds1 = objda.HelpMaster();
            List<string> items = new List<string>();
            if (ds1.Tables[0].Rows.Count > 0)
            {
                for (int i = 0; i < ds1.Tables[0].Rows.Count; i++)
                {
                    items.Add(ds1.Tables[0].Rows[i]["category"].ToString().ToLower());

                }

            }
            var returnList = items.Where(item => item.Contains(prefixText.ToLower())).ToList();
            returnList.Sort();
            return returnList;

        }

    }
}