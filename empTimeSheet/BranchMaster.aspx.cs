using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace empTimeSheet
{
    public partial class BranchMaster : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        DataSet ds = new DataSet();
        GeneralMethod objgen = new GeneralMethod();
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                if (!objda.checkUserInroles("1"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
                btndelete.Visible = false;
                fillgrid();

            }
        }




        //Fill Department List from Database
        public void fillgrid()
        {
            objda.id = "";
            objda.action = "select";
            objda.company = Session["companyid"].ToString();
            objda.name = txtsearch.Text;
            ds = objda.ManageBranch();
            if (ds.Tables[0].Rows.Count > 0)
            {
                dgnews.DataSource = ds;
                dgnews.DataBind();
                dgnews.Visible = true;
                nodata.Visible = false;

            }
            else
            {
                dgnews.Visible = false;
                nodata.Visible = true;
            }

        }


        public void blank()
        {

           
            txtname.Text = string.Empty;
            hidid.Value = "";
            btndelete.Visible = false;
            btnsubmit.Text = "Save";
        }

        /// <summary>
        /// event fires when clicks to Edit/Delete in List
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dgnews_RowCommand(object sender, RepeaterCommandEventArgs e)
        {

            if (e.CommandName.ToLower() == "detail")
            {
                hidid.Value = e.CommandArgument.ToString();
                objda.id = e.CommandArgument.ToString();
                objda.action = "select";
     
                ds = objda.ManageBranch();
                txtname.Text = ds.Tables[0].Rows[0]["branchname"].ToString();
               
                btnsubmit.Text = "Update";
                btndelete.Visible = true;

            }

        }

        protected void btnsearch_Click(object sender, EventArgs e)
        {
            fillgrid();
        }

        protected void liaddnew_Click(object sender, EventArgs e)
        {
            blank();
        }

        protected void btnsubmit_Click(object sender, EventArgs e)
        {
            objda.id = hidid.Value;
            objda.name = txtname.Text;
         
            objda.action = "insert";
            objda.company = Session["companyid"].ToString();
            ds = objda.ManageBranch();
            blank();
            fillgrid();
            GeneralMethod.alert(this.Page, "Saved Successfully!");


        }
        /// <summary>
        /// Delete record
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btndelete_Click(object sender, EventArgs e)
        {
            objda.action = "delete";
            objda.id = hidid.Value;
            ds = objda.ManageBranch();
            blank();
            fillgrid();
            GeneralMethod.alert(this.Page, "Deleted Successfully!");
        }
    }
}