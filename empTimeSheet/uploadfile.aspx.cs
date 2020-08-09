using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
namespace empTimeSheet
{
    public partial class uploadfile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {


        }
        protected string UploadFolderPath = "~/webfile/attachfiles/";
        protected void btnupload_Click(object sender, EventArgs e)
        {
            if (fileupload1.HasFile)
                try
                {
                    string datetime = DateTime.Now.ToFileTimeUtc().ToString();
                    string filename = "";
                    string filename1 = System.IO.Path.GetFileName(fileupload1.FileName);
                    String extension = Path.GetExtension(fileupload1.FileName);
                    int filesize = fileupload1.PostedFile.ContentLength;
                    int maxsize = 104857600;
                    filename = datetime + extension;
                    if (filesize <= maxsize)
                    {


                        timesheet_hidorgfile.Value = filename1;
                        timesheet_hidsavedfile.Value = filename;
                        fileupload1.SaveAs(Server.MapPath(this.UploadFolderPath) + filename);
                      
                        ScriptManager.RegisterStartupScript(this, GetType(), "temp", "<script>uploadComplete();</script>", false);


                        // updatepanel3.Update();
                    }
                    else
                    {
                        timesheet_hidorgfile.Value = "";
                        timesheet_hidsavedfile.Value = "";

                        GeneralMethod.alert(this.Page, "File size cannot be greater than 100Mb.");
                        return;

                    }
                }
                catch
                {
                    timesheet_hidorgfile.Value = "";
                    timesheet_hidsavedfile.Value = "";
                    GeneralMethod.alert(this.Page, "There is some problem in uploading file, please try again.");
                }
                finally
                {
                    // fileupload1.ClearAllFilesFromPersistedStore();
                }
         
        }
    }
}