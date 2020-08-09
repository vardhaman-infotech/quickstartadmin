using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;


namespace empTimeSheet
{
    public partial class support : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        DataSet ds = new DataSet();
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnsend_Click(object sender, EventArgs e)
        {
            System.Net.Mail.Attachment attachFile = null;
            string strmdetail = "<table cellpadding='4' cellspacing='0' width='700' align='center' style='border:solid 1px #e0e0e0;'><tr><td style='border:solid 1px #e0e0e0;' width='100'>Sender Email:</td><td style='border:solid 1px #e0e0e0;'>" + txtemail.Text + "</td></tr><tr><td style='border:solid 1px #e0e0e0;vertical-align:top;' width='100' valign='top'>Message:</td><td style='border:solid 1px #e0e0e0;vertical-align:top;' height='400' valign='top'>" + txtcomment.Text + "</td></tr>";
            string msg = "";
            objda.action = "select";
            objda.id = "1";

          
            if (ds.Tables[0].Rows.Count > 0)
            {
                msg = objda.SendEmail("sanjay.gupta@saratechnologies.com" + ",", "Support Message on QuickStart", strmdetail, "", "", "");


            }

            if (msg == "Sent")
            {
                error.InnerText = "Your email sent successfully to Administrator.";
                blank();
                diverror.Visible = true;
                diverror1.Visible = false;

            }
            else
            {
                error1.InnerText = "Error in sending email, please try again";
                diverror1.Visible = true;
                diverror.Visible = false;


            }
        }
        public void blank()
        {
            txtemail.Text = "";
            txtcomment.Text = "";

        }
    }
}