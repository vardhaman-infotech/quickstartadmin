using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;


namespace empTimeSheet
{
    public partial class emailFileShare : System.Web.UI.Page
    {
        ClsUser objda = new ClsUser();
        DataSet ds = new DataSet();
        protected void Page_Load(object sender, EventArgs e)
        {
           
            if (!Page.IsPostBack)
            {
              

                if (Request.QueryString["receiverid"] == null)
                {
                    Response.Redirect("error.html");
                }
                
                else
                {
                    objda.id = Request.QueryString["receiverid"].ToString();
                    objda.action = "getempbyfileshare";
                    ds=objda.ManageEmployee();
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        Session["email_empid"] = ds.Tables[0].Rows[0]["nid"].ToString();
                        Session["email_recemail"] = ds.Tables[0].Rows[0]["emailid"].ToString();
                        Session["email_empname"] = ds.Tables[0].Rows[0]["fname"].ToString() + " " + ds.Tables[0].Rows[0]["lname"].ToString();
                        Session["email_maxupload"] = ds.Tables[0].Rows[0]["filesize"].ToString();
                        recname.InnerHtml = "Send file to " + ds.Tables[0].Rows[0]["fname"].ToString() + " " + ds.Tables[0].Rows[0]["lname"].ToString();

                    }
                    else
                    {
                        Response.Redirect("linkexpired.html");
                    }
                
                }

            }

        }

        protected void btnsubmit_Click(object sender, EventArgs e)
        {

            if (Session["email_empid"] != null && Session["email_empname"] != null && Session["email_recemail"] != null)
            {
                string EncodedResponse = Request.Form["g-Recaptcha-Response"];
                bool IsCaptchaValid = (empTimeSheet.DataClasses.BAL.ReCaptchaClass.Validate(EncodedResponse) == "True" ? true : false);
                if (IsCaptchaValid)
                {
                Session["email_sendername"] = txtname.Text;
                Session["email_senderemail"] = txtemailid.Text;
                Response.Redirect("emailFileSend.aspx");
                }
            }
            else
            {
                Response.Redirect("sessionexpired.html");
            }
        }
    }
}