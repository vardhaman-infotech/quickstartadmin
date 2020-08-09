using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.IO;
using System.Web.UI.HtmlControls;
using uploadimage;
namespace empTimeSheet
{
    public partial class myacc_ProfilePic : System.Web.UI.Page
    {
        
        ClsUser objuser = new ClsUser();
        GeneralMethod objgen = new GeneralMethod();
        imageupload objimg = new imageupload();
        DataSet ds = new DataSet();
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!Page.IsPostBack)
            {
                binddetail();
            }
        }

        protected void btnupload_Click(object sender, EventArgs e)
        {
            if (FileUpload1.HasFile)
            {
                string filename = "";
                string path2 = "";
                string datetime = DateTime.Now.ToFileTimeUtc().ToString();
                try
                {
                    objuser.id = Session["userid"].ToString();
                    String extension = Path.GetExtension(FileUpload1.PostedFile.FileName);
                    if (extension.ToUpper() != ".JPG" && extension.ToUpper() != ".JPEG" && extension.ToUpper() != ".PNG" && extension.ToUpper() != ".GIF")
                    {

                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('Selected file  has invalid format');</script>", false);
                        return;
                    }
                    filename = "Profile_" + datetime + extension;
                    ViewState["filename"] = filename;
                    //string path = Server.MapPath(FileUpload1.PostedFile.FileName);
                    string path = AppDomain.CurrentDomain.BaseDirectory + "\\webfile\\profile\\" + filename;
                    ViewState["path"] = @"webfile/profile/" + filename;
                    FileUpload1.SaveAs(path);
                    path = Server.MapPath("webfile/profile/" + filename);
                    path2 = Server.MapPath("webfile/profile/thumb/" + filename);


                    objimg.CreateThumbnail(100, 100, path, path2);

                    //Find image control shown on top from Master page and change url
                  //  HtmlImage homethumbimage = (HtmlImage)this.Master.FindControl("imgphoto");

                   
                }
                catch (Exception ex)
                {

                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('" + ex.ToString() + "'Server error please try again later.');</script>", false);
                    return;

                }
                objuser.imgurl = ViewState["filename"].ToString();
                objuser.action = "changephoto";
                ds = objuser.ManageEmployee();
                Response.Cookies["user"]["profilephoto"] = filename;
                Session["profilephoto"] = filename;
                binddetail();
            }
            else
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('Please select a file');</script>", false);
                return;
            }



        }
        public void binddetail()
        {
            objuser.id = Session["userid"].ToString();
            objuser.usertype = Session["usertype"].ToString();
            objuser.action = "selectfulldetail";
            ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0)
            {

              
                if (ds.Tables[0].Rows[0]["imgurl"].ToString() != "")
                {
                    //divuserphoto.Style.Add("background-image", "url(webfile/profile/" + ds.Tables[0].Rows[0]["imgurl"].ToString() + ")");
                    divuserphoto.Src = "webfile/profile/" + ds.Tables[0].Rows[0]["imgurl"].ToString();
                    ViewState["filename"] = ds.Tables[0].Rows[0]["imgurl"].ToString();

                }
                else
                {
                    divuserphoto.Src = "webfile/profile/" + ds.Tables[0].Rows[0]["imgurl"].ToString();

                }
            }
        }
    }
}