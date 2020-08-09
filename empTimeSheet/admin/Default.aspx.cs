using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace emptimesheet.admin
{
    public partial class Default : System.Web.UI.Page
    {
        ClsAdmin objda = new ClsAdmin();
        DataSet ds = new DataSet();
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void btnsubmit_Click(object sender, EventArgs e)
        {
            //Check whether entered user name and password is correct or not
            objda.loginid = txtloginid.Text;
            objda.pass = txtpassowrd.Text;
            objda.action = "login";
            ds = objda.ManageAdmin();
            if (ds.Tables[0].Rows.Count > 0)
            {
                //if entered detals are correct then bind session with current user id and name
                Session["adminname"] = objda.loginid;
                Session["adminid"] = ds.Tables[0].Rows[0]["nid"].ToString();
                Session["usertype"] = "admin";

                Response.Cookies["redirect"].Value = "ManageCompany.aspx";
                Response.Cookies["redirect"].Expires = DateTime.Now.AddDays(1);
                Response.Redirect("ManageCompany.aspx");

            }

            else
            {
                error.Visible = true;

            }
        }
    }
}