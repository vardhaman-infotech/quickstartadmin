using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace empTimeSheet
{
    public partial class comp_email : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsAdmin objadmin = new ClsAdmin();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!objda.checkUserInroles("26"))
            {
                Response.Redirect("UserDashboard.aspx");
            }
            if (!Page.IsPostBack)
            {
                

                binddetail();
            }

        }
        protected void btnreset_Click(object sender, EventArgs e)
        { binddetail(); }
        protected void btntestemail_Click(object sender, EventArgs e)
        {
            string senderid = txtsenderEmail.Text.Trim();
            string pass = txtsenderpass.Text.Trim();
            string hostname = txtmailhost.Text.Trim();



            System.Net.Mail.MailMessage mail = new System.Net.Mail.MailMessage();
            string msg = "";
            mail.To.Add(new System.Net.Mail.MailAddress(senderid));

            mail.From = new System.Net.Mail.MailAddress(senderid);
            mail.Subject = "Test Eamil From QuickStart";
            mail.Body = "<h1>Test Eamil!</h1>";

            mail.IsBodyHtml = true;
            System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
            smtp.Host = hostname;

            smtp.Credentials = new System.Net.NetworkCredential(senderid, pass);
            //  smtp.DeliveryMethod = SmtpDeliveryMethod.Network;
            //smtp.Port = 25;
            //smtp.EnableSsl = true;
            try
            {
                smtp.Send(mail); msg = "Test Email sent successfully!";


            }
            catch (Exception ex)
            {
                msg = "Error in sending test email!";

            }
            finally
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('" + msg + "');</script>", false);

            }

        }
        protected void binddetail()
        {
            objadmin.action = "selectbynid";
            objadmin.companyId = Session["companyid"].ToString();

            ds = objadmin.CompanySettings();
            if (ds.Tables[0].Rows.Count > 0)
            {
                txtmailhost.Text = ds.Tables[0].Rows[0]["MailHost"].ToString();
               // txtreceiveremail.Text = ds.Tables[0].Rows[0]["ReceiverMail"].ToString();
                txtsenderEmail.Text = ds.Tables[0].Rows[0]["SenderEmail"].ToString();
                txtsenderpass.Text = ds.Tables[0].Rows[0]["SenderPass"].ToString();

                rdlemailnoti.Text = ds.Tables[0].Rows[0]["EmailNotification"].ToString();


            

            }

        }
        protected void btnSave_OnClick(object sender, EventArgs e)
        {
            objadmin.action = "updateemail";
            objadmin.companyId = Session["companyid"].ToString();

            objadmin.mailhost = txtmailhost.Text;
            objadmin.receivermail = txtsenderEmail.Text;
            objadmin.senderemail = txtsenderEmail.Text;
            objadmin.senderpass = txtsenderpass.Text;
            objadmin.emailnotification = rdlemailnoti.Text;
            ds = objadmin.CompanySettings();

            GeneralMethod.alert(this.Page, "Information saved successfully!");

        }
    }
}