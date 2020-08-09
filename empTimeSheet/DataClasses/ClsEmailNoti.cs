using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using empTimeSheet.DataClasses.DAL;
using System.Data;
using System.IO;
using System.Net.Mail;

namespace empTimeSheet.DataClasses
{
    public class ClsEmailNoti : clsDAL
    {
        public void CalculateNotiEmail()
        {
            dbcommand = db.GetStoredProcCommand("sp_EmailNotification", "", "generate", "","");
            db.ExecuteNonQuery(dbcommand);
        }
        public DataSet GetNotiRecord()
        {
            dbcommand = db.GetStoredProcCommand("sp_EmailNotification", "", "fetch", "","");
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetNotiRecordbyID(string rectye, string nid)
        {
            dbcommand = db.GetStoredProcCommand("sp_EmailNotification", nid, "checkrecord", rectye,"");
            return db.ExecuteDataSet(dbcommand);
        }

        public bool sendEmail(string sender, string pass, string hostname, string receiver, string subject, string message)
        {
            bool status;
            if (sender == "" || pass == "" || hostname == "")
            {
                sender = System.Web.Configuration.WebConfigurationManager.AppSettings["SenderEmail"].ToString();
                pass = System.Web.Configuration.WebConfigurationManager.AppSettings["SenderPass"].ToString();
                hostname = System.Web.Configuration.WebConfigurationManager.AppSettings["MailHost"].ToString();
            }
            MailMessage mail = new MailMessage();
            if (receiver != "")
            {
                mail.To.Add(new MailAddress(receiver));

                mail.From = new MailAddress(sender);
                mail.Subject = subject;
                mail.Body = message;

                mail.IsBodyHtml = true;
                SmtpClient smtp = new SmtpClient();
                smtp.Host = hostname;
                smtp.Credentials = new System.Net.NetworkCredential(sender, pass);

                try
                {
                    smtp.Send(mail); status = true; 
                }
                catch (Exception ex)
                {

                    status = false; 
                }

              
            }
            else
            {
                status = false; 
            }

            return status;

        }

        public void sendNotEmail()
        {
            DataSet ds = new DataSet();
         
            ds = GetNotiRecord();
            if (ds.Tables[0].Rows.Count > 0)
            {
                string str = "", HTMLBODY = "", prevrec = "", strSubject = "";
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {

                    if (prevrec != ds.Tables[0].Rows[i]["rectype"].ToString())
                    {
                        string HTMLTemplatePath = "";
                        prevrec = ds.Tables[0].Rows[i]["rectype"].ToString();

                        if (ds.Tables[0].Rows[i]["rectype"].ToString().ToLower() == "tsheet")
                        {
                            
                        }
                            HTMLTemplatePath = AppDomain.CurrentDomain.BaseDirectory+"/EmailTemplates/timesheetemail.html";

                        str = File.Exists(HTMLTemplatePath) ? File.ReadAllText(HTMLTemplatePath) : "";

                    }

                    DataSet ds2 = new DataSet();
                    ds2 = GetNotiRecordbyID(ds.Tables[0].Rows[i]["rectype"].ToString(), ds.Tables[0].Rows[i]["nid"].ToString());
                    if (ds2.Tables.Count > 0)
                    {
                        HTMLBODY = str;
                        if (ds.Tables[0].Rows[i]["rectype"].ToString().ToLower() == "tsheet")
                        {
                            strSubject = "[QuickStartAdmin] Your weekly digest";
                            double bhrs, nbhrs, thrs, bpercent;
                            bhrs = Convert.ToDouble(ds2.Tables[0].Rows[0]["bHrs"]);
                            nbhrs = Convert.ToDouble(ds2.Tables[0].Rows[0]["nbHrs"]);
                            thrs = bhrs + nbhrs;
                            if (thrs!=0)
                            {
                                if (bhrs == 0)
                                {
                                    bpercent = 0;
                                }
                                else
                                {
                                    bpercent = bhrs * 100 / thrs;

                                }
                            }
                            else
                            {
                                bpercent = 0;
                            }
                           
                           

                            HTMLBODY = HTMLBODY.Replace("#FirstName#", ds2.Tables[0].Rows[0]["fName"].ToString());
                            HTMLBODY = HTMLBODY.Replace("#FromDate#", ds2.Tables[0].Rows[0]["fromdate"].ToString());
                            HTMLBODY = HTMLBODY.Replace("#ToDate#", ds2.Tables[0].Rows[0]["todate"].ToString());
                            HTMLBODY = HTMLBODY.Replace("#EmpName#", ds2.Tables[0].Rows[0]["fName"].ToString() + " " + ds2.Tables[0].Rows[0]["lname"].ToString());
                            HTMLBODY = HTMLBODY.Replace("#BHrs#", bhrs.ToString("0.00"));
                            HTMLBODY = HTMLBODY.Replace("#NBHrs#", nbhrs.ToString("0.00"));
                            HTMLBODY = HTMLBODY.Replace("#THrs#", thrs.ToString("0.00"));
                            if(thrs!=0)
                            {
                                HTMLBODY = HTMLBODY.Replace("#BPercent#", bpercent.ToString("0.00"));
                                HTMLBODY = HTMLBODY.Replace("#NBPercent#", (100 - bpercent).ToString("0.00"));
                                HTMLBODY = HTMLBODY.Replace("#ZeroPer#", "0");

                            }
                            else
                            {
                                HTMLBODY = HTMLBODY.Replace("#BPercent#", "0");
                                HTMLBODY = HTMLBODY.Replace("#NBPercent#", "0");
                                HTMLBODY = HTMLBODY.Replace("#ZeroPer#", "100");
                            }
                          

                            HTMLBODY = HTMLBODY.Replace("#URL#", ds2.Tables[0].Rows[0]["schedulerURL"].ToString());
                        }

                        try
                        {
                        
                           if(    sendEmail(ds2.Tables[0].Rows[0]["SenderEmail"].ToString(), ds2.Tables[0].Rows[0]["SenderPass"].ToString(), ds2.Tables[0].Rows[0]["MailHost"].ToString(), ds2.Tables[0].Rows[0]["emailid"].ToString(), strSubject, HTMLBODY))
                           {
                               dbcommand = db.GetStoredProcCommand("sp_EmailNotification", ds.Tables[0].Rows[i]["nid"].ToString(), "updatestatus", ds.Tables[0].Rows[i]["rectype"].ToString(), "Success");
                               db.ExecuteNonQuery(dbcommand);
                           }
                           else
                           {
                               dbcommand = db.GetStoredProcCommand("sp_EmailNotification", ds.Tables[0].Rows[i]["nid"].ToString(), "updatestatus", ds.Tables[0].Rows[i]["rectype"].ToString(), "Error");
                               db.ExecuteNonQuery(dbcommand);
                           }
                        }
                        catch
                        {
                            dbcommand = db.GetStoredProcCommand("sp_EmailNotification", ds.Tables[0].Rows[i]["nid"].ToString(), "updatestatus", ds.Tables[0].Rows[i]["rectype"].ToString(), "Error");

                        }


                    }
                    ds2.Dispose();

                }



            }
            ds.Dispose();

        }

    }
}