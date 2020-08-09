using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace empTimeSheet.Client
{
    public partial class index : System.Web.UI.Page
    {
        clsLogin objda = new clsLogin();
        DataSet ds = new DataSet();
        protected void Page_Load(object sender, EventArgs e)
        {
           
        }
        protected void btnsubmit_Click(object sender, EventArgs e)
        {
            objda.loginid = txtloginid.Text;
            objda.password = txtpassword.Text;
            objda.company = "HCLLP";
            objda.action = "checkclientlogin";
            ds = objda.login();

            if (ds.Tables[0].Rows.Count > 0)
            {


                Session["clientloginid"] = ds.Tables[0].Rows[0]["nid"].ToString();
                Session["clientname"] = ds.Tables[0].Rows[0]["clientname"].ToString();
                Session["clientcompanyname"] = ds.Tables[0].Rows[0]["company"].ToString();
                Session["companyname"] = ds.Tables[0].Rows[0]["companyname"].ToString();
                Session["companyid"] = ds.Tables[0].Rows[0]["companyid"].ToString();
               
                Response.Redirect("Home.aspx");

            }
            else
            {
                GeneralMethod.alert(this, "Invalid Username or Password!");

            }
        }

    }
}