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
    public partial class com_Logo : System.Web.UI.Page
    {
        ClsUser objuser = new ClsUser();
        ClsAdmin objadmin = new ClsAdmin();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();
        imageupload objimg = new imageupload();
        protected void Page_Load(object sender, EventArgs e)
        {
           
            objgen.validatelogin();
            if(!Page.IsPostBack)
            {
                DataAccess objda = new DataAccess();
                if (!objda.checkUserInroles("26"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
                binddetail();
            }
        }
        protected void binddetail()
        {
            objadmin.action = "selectbynid";
            objadmin.companyId = Session["companyid"].ToString();

            ds = objadmin.CompanySettings();

            if (ds.Tables[0].Rows[0]["logoURL"].ToString() != "")
            {

                divbiglogo.InnerHtml = "<img src='webfile/" + ds.Tables[0].Rows[0]["logoURL"].ToString()+"' alt='Big Logo' />";
                ViewState["logourl"] = ds.Tables[0].Rows[0]["logoURL"].ToString();

            }
            else
            {
                divbiglogo.InnerHtml = "<img src='images/nologo.png' width='100%' heignt='100%' />";

            }

            if (ds.Tables[0].Rows[0]["logosmall"].ToString() != "")
            {

                divsmalllogo.InnerHtml = "<img src='webfile/" + ds.Tables[0].Rows[0]["logosmall"].ToString() + "' alt='Small Logo' />";
                ViewState["logosmall"] = ds.Tables[0].Rows[0]["logosmall"].ToString();

            }
            else
            {
                divsmalllogo.InnerHtml = "<img src='images/nologo.png' width='100%' heignt='100%' />";

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

                   

                    divbiglogo.InnerHtml = "<img src='webfile/" + filename + "' width='100%' heignt='100%' />";
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

                    divsmalllogo.InnerHtml = "<img src='webfile/" + filename + "' width='100%' heignt='100%' />";
                   
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
    }
}