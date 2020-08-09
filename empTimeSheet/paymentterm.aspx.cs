using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace empTimeSheet
{
    public partial class paymentterm : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        DataSet ds = new DataSet();
        GeneralMethod objgen = new GeneralMethod();
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                if (!objda.checkUserInroles("82"))
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
            ds = objda.ManagePaymentTerm();
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

            txtdes.Text = string.Empty;
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
                objda.name = txtsearch.Text;

                ds = objda.ManagePaymentTerm();
                txtname.Text = ds.Tables[0].Rows[0]["payTerm"].ToString();
                txtdes.Text = ds.Tables[0].Rows[0]["graceDays"].ToString();
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
            objda.description = txtdes.Text;
            objda.action = "insert";
            objda.company = Session["companyid"].ToString();
            ds = objda.ManagePaymentTerm();
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
            ds = objda.ManagePaymentTerm();
            blank();
            fillgrid();
            GeneralMethod.alert(this.Page, "Deleted Successfully!");
        }
    }
}