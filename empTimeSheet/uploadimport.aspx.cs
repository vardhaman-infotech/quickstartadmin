using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace empTimeSheet
{
    public partial class uploadimport : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack && FileUpload1.PostedFile != null)
            {

                if (FileUpload1.PostedFile.FileName.Length > 0)
                {

                    string filename = "", originalfname = "";
                    string path2 = "";
                    int fileSize = FileUpload1.PostedFile.ContentLength;
                    string strfilesize = "";

                    if (fileSize > 1024)
                        strfilesize = (fileSize / 1024).ToString() + " KB";
                    else
                    {
                        strfilesize = (fileSize).ToString() + " Byte";
                    }
                    try
                    {

                        originalfname = FileUpload1.PostedFile.FileName;

                        string date = DateTime.Now.ToFileTimeUtc().ToString();


                        String extension = Path.GetExtension(FileUpload1.PostedFile.FileName);


                        filename = date + extension;


                        string path = AppDomain.CurrentDomain.BaseDirectory + "\\webfile\\temp\\" + filename;

                        FileUpload1.SaveAs(path);


                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>callFileClientFunction('" + filename + "','" + strfilesize + "','" + originalfname + "','" + extension + "');</script>", false);


                    }
                    catch (Exception ex)
                    {

                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('" + ex.ToString() + "'Server error please try again later.');</script>", false);
                        return;

                    }

                }
                else
                {
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('Please select a file');</script>", false);
                    return;
                }


            }
        }
        protected void btnupload_Click(object sender, EventArgs e)
        {
            if (FileUpload1.HasFile)
            {
                string filename = "", originalfname = "";
                string path2 = "";
                int fileSize = FileUpload1.PostedFile.ContentLength;
                string strfilesize = "";

                if (fileSize > 1024)
                    strfilesize = (fileSize / 1024).ToString() + " KB";
                else
                {
                    strfilesize = (fileSize).ToString() + " Byte";
                }
                try
                {

                    originalfname = FileUpload1.PostedFile.FileName;

                    string date = DateTime.Now.ToFileTimeUtc().ToString();


                    String extension = Path.GetExtension(FileUpload1.PostedFile.FileName);


                    filename = date + extension;


                    string path = AppDomain.CurrentDomain.BaseDirectory + "\\webfile\\temp\\" + filename;

                    FileUpload1.SaveAs(path);


                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>callFileClientFunction('" + filename + "','" + strfilesize + "','" + originalfname + "');</script>", false);


                }
                catch (Exception ex)
                {

                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('" + ex.ToString() + "'Server error please try again later.');</script>", false);
                    return;

                }

            }
            else
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('Please select a file');</script>", false);
                return;
            }
        }
    }
}