using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Data;
using System.IO;
using System.Text;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script.Services;
using System.Web.Script.Serialization;
using System.IO.Compression;
using AjaxControlToolkit;
using System.Net;
namespace empTimeSheet
{
    public partial class emailFileSend : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        DataSet ds = new DataSet();
        DataTable tblfile = new DataTable();
        DataRow itemdr;
        DataColumn itemdc;
        ClsFile objfile = new ClsFile();
  
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (Session["email_empid"] == null || Session["email_empname"] == null || Session["email_sendername"] == null || Session["email_senderemail"] == null || Session["email_recemail"] == null || Session["email_maxupload"] == null)
                {
                    Response.Redirect("sessionexpired.html");
                }
                recname.InnerHtml = "Send Files to " + Session["email_empname"].ToString();
                hidfilesize.Value = Session["email_maxupload"].ToString();
                litname.Text = Session["email_empname"].ToString();
                spanmaxupload.InnerHtml = "*Max  Upload Size: " + Session["email_maxupload"].ToString() + " MB";
            }
        }
        protected void btnsubmit_Click(object sender, EventArgs e)
        {
            if (Session["email_empid"] == null || Session["email_empname"] == null || Session["email_sendername"] == null || Session["email_senderemail"] == null)
            {
                Response.Redirect("sessionexpired.html");
            }
            else
            {
                string datetime = DateTime.Now.ToFileTimeUtc().ToString();
                string fileid = "";

                if (Session["file"] != null)
                {
                    tblfile = (DataTable)Session["file"];
                    if (tblfile.Rows.Count > 0)
                    {
                        try
                        {

                            objfile.action = "saveFile";
                            objfile.dob = GeneralMethod.getLocalDateTime();
                            objfile.nid = "";
                            objfile.name = Session["email_sendername"].ToString();
                            objfile.emailid = Session["email_senderemail"].ToString();
                            objfile.sentto = Session["email_empid"].ToString();
                            ds = objfile.ManageEmailFileShare();
                            if (ds.Tables[0].Rows.Count > 0)
                            {
                                objfile.nid = ds.Tables[0].Rows[0]["nid"].ToString();
                                fileid = ds.Tables[0].Rows[0]["filecode"].ToString();
                                for (int i = 0; i < tblfile.Rows.Count; i++)
                                {

                                    objfile.originalfile = tblfile.Rows[i]["originalname"].ToString();
                                    objfile.savedfile = tblfile.Rows[i]["savename"].ToString();
                                    ds = objfile.ManageEmailFileShare();
                                }

                                hidcurfilesize.Value = "0";

                            }


                            if (sendemail(tblfile.Rows.Count, fileid))
                            {
                                Session["file"] = null;
                                divfile.Visible = false;
                                divmessage.Visible = true;
                            }
                            else
                            {
                                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('Error in Sending!');</script>", false);
                            }
                        }
                        catch
                        {
                            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('Error in Sending!');</script>", false);
                            return;

                        }
                    }
                    else
                    {
                        Session["file"] = null;
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('File does not exist.');</script>", false);
                        return;

                    }


                }
                else
                {

                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('File does not exist.');</script>", false);
                    return;

                }
            }
        }


        public bool sendemail(int num, string fileid)
        {
            string filenum = "";
            try
            {
                string subject = "Files Shared";
                string HTMLTemplatePath = Server.MapPath("EmailTemplates/emailshare.htm");

                string HTMLBODY = File.ReadAllText(HTMLTemplatePath);



                HTMLBODY = HTMLBODY.Replace("##empname##", Session["email_empname"].ToString());
                HTMLBODY = HTMLBODY.Replace("##sender##", Session["email_sendername"].ToString());
                HTMLBODY = HTMLBODY.Replace("##senderemail##", Session["email_senderemail"].ToString());
                if (num == 1)
                    filenum = "file";
                else
                    filenum = "files";

                HTMLBODY = HTMLBODY.Replace("##num##", num.ToString() + " " + filenum);

                HTMLBODY = HTMLBODY.Replace("##filelink##", "<a style='font-size:14px;' href='" + System.Web.Configuration.WebConfigurationManager.AppSettings["SchedulerURL"].ToString() + "/downloadEmailFiles.aspx?fileid=" + fileid + "'>Click here</a> to download " + filenum + ".");
                objda.SendEmail(Session["email_recemail"].ToString() + ",", subject, HTMLBODY, "", "", "");
                return true;
            }
            catch { return false; }
        }

        #region Upload Files

        public DataTable createtable()
        {

            DataColumn itemdc;
            DataTable itemtable = new DataTable();
            itemdc = new DataColumn("originalname", System.Type.GetType("System.String"));
            itemtable.Columns.Add(itemdc);
            itemdc = new DataColumn("savename", System.Type.GetType("System.String"));
            itemtable.Columns.Add(itemdc);
            itemdc = new DataColumn("ext", System.Type.GetType("System.String"));
            itemtable.Columns.Add(itemdc);
            return itemtable;
        }

        protected void AjaxFileUpload1_OnUploadComplete(object sender, AjaxFileUploadEventArgs file)
        {
            if (hidisvalid.Value =="")
            {
                string datetime = DateTime.Now.ToFileTimeUtc().ToString();
                string filename = "";
                string originalfile = "";
                if ((Convert.ToDouble(hidcurfilesize.Value) + file.FileSize) <= Convert.ToDouble(hidfilesize.Value) * 1024 * 1024)
                {
                    try
                    {
                        String extension = Path.GetExtension(file.FileName);
                        filename = datetime + extension;
                        originalfile = file.FileName;
                        // Limit preview file for file equal or under 4MB only, otherwise when GetContents invoked
                        // System.OutOfMemoryException will thrown if file is too big to be read.
                        if (file.FileSize <= Convert.ToDouble(hidfilesize.Value) * 1024 * 1024)
                        {
                            Session["fileContentType_" + file.FileId] = file.ContentType;
                            Session["fileContents_" + file.FileId] = file.GetContents();

                            // Set PostedUrl to preview the uploaded file.         
                            // file.PostedUrl = string.Format("?preview=1&fileId={0}", file.FileId);
                            file.PostedUrl = "downloads.png";
                        }
                        else
                        {
                            file.PostedUrl = "downloads.png";
                        }

                        hidcurfilesize.Value = (Convert.ToDouble(hidcurfilesize.Value) + file.FileSize).ToString();
                        string directory = @"webfile/emailfile/";
                        // Since we never call the SaveAs method(), we need to delete the temporary fileß
                        string dir = Server.MapPath(directory);
                        if (!Directory.Exists(Server.MapPath(directory)))
                        {
                            Directory.CreateDirectory(Server.MapPath(directory));

                        }
                           AjaxFileUpload1.SaveAs(MapPath(directory + filename), true);

                        if (Session["file"] == null)
                        {
                            tblfile = createtable();

                        }
                        else
                        {
                            tblfile = (DataTable)Session["file"];

                        }

                        itemdr = tblfile.NewRow();



                        itemdr["originalname"] = originalfile;

                        itemdr["savename"] = filename;
                        itemdr["ext"] = extension;
                        tblfile.Rows.Add(itemdr);

                        Session["file"] = tblfile;

                        file.DeleteTemporaryData();

                    }
                    catch
                    {
                    }
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'> alert('File exceeds upload size limit');</script>", false);
                }

                //}
                //else
                //{
                //    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'> alert('The Files you are trying to send exceed the Max Limit.');</script>", false);

                //}


            }
        }

        protected void AjaxFileUpload1_UploadCompleteAll(object sender, AjaxFileUploadCompleteAllEventArgs e)
        {
            var startedAt = (DateTime)Session["uploadTime"];
            var now = DateTime.Now;
            e.ServerArguments = new JavaScriptSerializer()
                .Serialize(new
                {
                    duration = (now - startedAt).Seconds,
                    time = DateTime.Now.ToShortTimeString()
                });

        }

        protected void AjaxFileUpload1_UploadStart(object sender, AjaxFileUploadStartEventArgs e)
        {
            //AjaxFileUpload1.up
            var now = DateTime.Now;
            e.ServerArguments = now.ToShortTimeString();
            Session["uploadTime"] = now;

        }
        #endregion
    }

}