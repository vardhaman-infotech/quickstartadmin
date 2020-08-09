using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Data;
using System.IO;
using uploadimage;

namespace empTimeSheet
{
    public partial class CompanySettings_old : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsAdmin objadmin = new ClsAdmin();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();
        imageupload objimg = new imageupload();
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                if (!objda.checkUserInroles("25"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
              
                bindcurrency();
                bindtimezone();
                bindemployee();
                binddetail();

            }

        }
        protected void bindtimezone()
        {
           
            ds = objda.getAllTimeZone();
            if (ds.Tables[0].Rows.Count > 0)
            {
                droptimezone.DataTextField = "displayname";
                droptimezone.DataValueField = "nid";
                droptimezone.DataSource = ds;
                droptimezone.DataBind();
            }
            ListItem li = new ListItem();
            li.Text = "--Select Timezone--";
            li.Value = "";
            droptimezone.Items.Insert(0, li);
        }
        protected void bindcurrency()
        {
            objda.action = "selectcurrency";
            ds = objda.ManageMaster();
            if (ds.Tables[0].Rows.Count > 0)
            {
                ddlcurrency.DataTextField = "symbol";
                ddlcurrency.DataValueField = "nid";
                ddlcurrency.DataSource = ds;
                ddlcurrency.DataBind();
            }
            ListItem li = new ListItem();
            li.Text = "--Select Currency--";
            li.Value = "";
            ddlcurrency.Items.Insert(0, li);
        }
        protected void bindemployee()
        {
            listcode1.Items.Clear();
            listleave1.Items.Clear();
            objuser.action = "selectactive";
            objuser.companyid = Session["companyid"].ToString();
            objuser.id = "";
            ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0)
            {
                listleave1.DataSource = ds;
                listleave1.DataTextField = "username";
                listleave1.DataValueField = "nid";
                listleave1.DataBind();

                listcode1.DataSource = ds;
                listcode1.DataTextField = "username";
                listcode1.DataValueField = "nid";
                listcode1.DataBind();

            }
        }

        protected void binddetail()
        {
            objadmin.action = "select";
            objadmin.companyId = Session["companyid"].ToString();

            ds = objadmin.ManageSettings();
            if (ds.Tables[0].Rows.Count > 0)
            {
                Response.Cookies["user"]["companyname"] = HttpUtility.UrlEncode(ds.Tables[0].Rows[0]["companyname"].ToString());
                Response.Cookies["user"]["companyaddress"] = HttpUtility.UrlEncode(ds.Tables[0].Rows[0]["companyfulladdress"].ToString());

                Session["companyaddress"] = ds.Tables[0].Rows[0]["companyfulladdress"].ToString();
                Session["companyname"] = ds.Tables[0].Rows[0]["companyname"].ToString();

                litcompanyname.Text = ds.Tables[0].Rows[0]["companyname"].ToString();
                litemail.Text = ds.Tables[0].Rows[0]["email"].ToString();
                litwebsite.Text = ds.Tables[0].Rows[0]["website"].ToString();
                txtcompanyName.Text = ds.Tables[0].Rows[0]["companyname"].ToString();
                txtEmail.Text = ds.Tables[0].Rows[0]["email"].ToString();
                txtwebsite.Text = ds.Tables[0].Rows[0]["website"].ToString();
                txtmailhost.Text = ds.Tables[0].Rows[0]["MailHost"].ToString();
                txtreceiveremail.Text = ds.Tables[0].Rows[0]["ReceiverMail"].ToString();
                txtsenderEmail.Text = ds.Tables[0].Rows[0]["SenderEmail"].ToString();
                txtsenderpass.Text = ds.Tables[0].Rows[0]["SenderPass"].ToString();
                txtservercompanyname.Text = ds.Tables[0].Rows[0]["ServerCompnyName"].ToString();

                txtnextinvoiceno.Text = ds.Tables[0].Rows[0]["fistinvno"].ToString();
                txtprefix.Text = ds.Tables[0].Rows[0]["invprefix"].ToString();
                txtpostfix.Text = ds.Tables[0].Rows[0]["invpostfix"].ToString();

                txtUserName.Text = ds.Tables[0].Rows[0]["usrNameAtendnceReadr"].ToString();
                txtPassword.Text = ds.Tables[0].Rows[0]["paswrdAtendnceReadr"].ToString();

                hidleaveemailemp.Value = ds.Tables[0].Rows[0]["LeaveEmail"].ToString();
                hidscheduleemailemp.Value = ds.Tables[0].Rows[0]["ScheduleEmail"].ToString();
                rdlemailnoti.Text = ds.Tables[0].Rows[0]["EmailNotification"].ToString();
                ddlcurrency.Text = ds.Tables[0].Rows[0]["currencyid"].ToString();
                droptimezone.Text = ds.Tables[0].Rows[0]["timezone"].ToString();
                if (ds.Tables[0].Rows[0]["logoURL"].ToString() != "")
                {

                    divuserphoto.Src = "webfile/" + ds.Tables[0].Rows[0]["logoURL"].ToString();
                    ViewState["logourl"] = ds.Tables[0].Rows[0]["logoURL"].ToString();

                }
                else
                {
                    divuserphoto.Src = "webfile/" + ds.Tables[0].Rows[0]["logoURL"].ToString();

                }
            }
            if (ds.Tables.Count > 1)
            {
                if (ds.Tables[1].Rows.Count > 0)
                {
                    for (int i = 0; i < ds.Tables[1].Rows.Count; i++)
                    {
                        for (int j = 0; j < listcode1.Items.Count; j++)
                        {
                            if (listcode1.Items[j].Value == ds.Tables[1].Rows[i]["nid"].ToString())
                            {
                                ListItem li = new ListItem(listcode1.Items[j].Text, listcode1.Items[j].Value);
                                listcode2.Items.Add(li);
                                listcode1.Items.RemoveAt(j);
                              
                                break;
                            }
                        }
                    }
                }
                if (ds.Tables[2].Rows.Count > 0)
                {
                    for (int i = 0; i < ds.Tables[2].Rows.Count; i++)
                    {
                        for (int j = 0; j < listleave1.Items.Count; j++)
                        {
                            if (listleave1.Items[j].Value == ds.Tables[2].Rows[i]["nid"].ToString())
                            {
                                ListItem li = new ListItem(listleave1.Items[j].Text, listleave1.Items[j].Value);
                                listleave2.Items.Add(li);
                                listleave1.Items.RemoveAt(j);
                               
                                break;
                            }
                        }
                    }
                }
            }
        }
        protected void btnupload1_Click(object sender, EventArgs e)
        {
            if (FileUpload2.HasFile)
            {
                string filename = "";
                string path2 = "";

                try
                {
                    objuser.id = Session["userid"].ToString();
                    TimeSpan ts = DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0, 0);
                    string FormatedDateTime = Convert.ToInt64(ts.TotalSeconds).ToString();
                    string ssUniqueId = DateTime.UtcNow.ToString("fffffff");
                    string date = DateTime.Now.ToString("MMddyyyy");
                    string unid = date + "_" + ssUniqueId;

                    String extension = Path.GetExtension(FileUpload2.PostedFile.FileName);
                    if (extension.ToUpper() != ".JPG" && extension.ToUpper() != ".JPEG" && extension.ToUpper() != ".PNG" && extension.ToUpper() != ".GIF")
                    {

                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('Selected file  has invalid format');</script>", false);
                        return;
                    }
                    filename = unid + extension;
                    ViewState["logourl1"] = filename;
                    //string path = Server.MapPath(FileUpload1.PostedFile.FileName);
                    string path = AppDomain.CurrentDomain.BaseDirectory + "\\webfile\\" + filename;
                    ViewState["path1"] = @"webfile/" + filename;
                    FileUpload2.SaveAs(path);
                    path = Server.MapPath("webfile/" + filename);

                    divuserphoto.Src = "webfile/" + filename;
                }
                catch (Exception ex)
                {

                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('" + ex.ToString() + "'Server error please try again later.');</script>", false);
                    return;

                }
                objadmin.logoURL = ViewState["logourl1"].ToString();
                objadmin.companyId = Session["companyid"].ToString();
                objadmin.action = "changesmalllogo";
                ds = objadmin.ManageSettings();

                binddetail();
            }
            else
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('Please select a file');</script>", false);
                return;
            }



        }
        protected void btnupload_Click(object sender, EventArgs e)
        {
            if (FileUpload1.HasFile)
            {
                string filename = "";
                string path2 = "";

                try
                {
                    objuser.id = Session["userid"].ToString();
                    TimeSpan ts = DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0, 0);
                    string FormatedDateTime = Convert.ToInt64(ts.TotalSeconds).ToString();
                    string ssUniqueId = DateTime.UtcNow.ToString("fffffff");
                    string date = DateTime.Now.ToString("MMddyyyy");
                    string unid = date + "_" + ssUniqueId;

                    String extension = Path.GetExtension(FileUpload1.PostedFile.FileName);
                    if (extension.ToUpper() != ".JPG" && extension.ToUpper() != ".JPEG" && extension.ToUpper() != ".PNG" && extension.ToUpper() != ".GIF")
                    {

                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('Selected file  has invalid format');</script>", false);
                        return;
                    }
                    filename = unid + extension;
                    ViewState["logourl"] = filename;
                    //string path = Server.MapPath(FileUpload1.PostedFile.FileName);
                    string path = AppDomain.CurrentDomain.BaseDirectory + "\\webfile\\" + filename;
                    ViewState["path"] = @"webfile/" + filename;
                    FileUpload1.SaveAs(path);
                    path = Server.MapPath("webfile/" + filename);

                    divuserphoto.Src = "webfile/" + filename;
                }
                catch (Exception ex)
                {

                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('" + ex.ToString() + "'Server error please try again later.');</script>", false);
                    return;

                }
                objadmin.logoURL = ViewState["logourl"].ToString();
                objadmin.companyId = Session["companyid"].ToString();
                objadmin.action = "changelogo";
                ds = objadmin.ManageSettings();

                binddetail();
            }
            else
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('Please select a file');</script>", false);
                return;
            }



        }
        protected void btntestemail_Click(object sender, EventArgs e)
        {
            string senderid = txtEmail.Text.Trim();
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
                msg="Error in sending test email!";
               
            }
            finally{
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('" + msg+"');</script>", false);
            
            }
        
        }
        protected void btnSave_OnClick(object sender, EventArgs e)
        {
            objadmin.companyId = Session["companyid"].ToString();
            objadmin.Name = txtcompanyName.Text;
            objadmin.email = txtEmail.Text;

            objadmin.website = txtwebsite.Text;

            objadmin.mailhost = txtmailhost.Text;
            objadmin.receivermail = txtreceiveremail.Text;
            objadmin.senderemail = txtsenderEmail.Text;
            objadmin.senderpass = txtsenderpass.Text;
            objadmin.servercompnyname = txtservercompanyname.Text;
            objadmin.symbol = ddlcurrency.Text;
            string schedulemail = "";
            //for (int j = 0; j < dlscheduleemail.Items.Count; j++)
            //{
            //    HtmlInputHidden hidempid = (HtmlInputHidden)dlscheduleemail.Items[j].FindControl("hidempid");
            //    CheckBox chkmember = (CheckBox)dlscheduleemail.Items[j].FindControl("checkmember");
            //    if (chkmember.Checked == true)
            //    {
            schedulemail = hidscheduleemailemp.Value;
            //    }
            //}
            string leavemail = "";

            leavemail = hidleaveemailemp.Value;
             

            objadmin.action = "managesetting";
            objadmin.emailnotification = rdlemailnoti.Text;
            objadmin.scheduleemail = schedulemail;
            objadmin.leaveemail = leavemail;
            objadmin.invoicetemplate = "default";
            objadmin.invno = txtnextinvoiceno.Text;
            objadmin.sufix = txtpostfix.Text;
            objadmin.prefix = txtprefix.Text;
            objadmin.timezone = droptimezone.Text;

            //machine reader variables
            objadmin.machineReadrUsrName = txtUserName.Text;
            objadmin.machineReadrPswd = txtPassword.Text;

            objadmin.ManageSettings();
            hidleaveemailemp.Value = "";
            hidscheduleemailemp.Value = "";
            listleave2.Items.Clear();
            listcode2.Items.Clear();
            bindemployee();
            binddetail();
            
            GeneralMethod.alert(this.Page, "Information saved successfully");
        
          


        }

    }
}