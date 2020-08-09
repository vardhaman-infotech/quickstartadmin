using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace empTimeSheet
{
    public partial class downloadFile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (Request.QueryString["file1"] == null || Request.QueryString["file2"] == null)
                {
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('File is not available or temporarily removed.');window.close();</script>", false);
                    return;


                }
                downloadfile();
            }
        }
        private void downloadfile()
        {
            excelexport objexcel = new excelexport();

            if (!objexcel.downloadVirturalfile(Request.QueryString["file1"].ToString(), Request.QueryString["file2"].ToString(), "webfile/attachfiles"))
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('File is not available or temporarily removed.');window.close(); </script>", false);
                return;
            }
        
        }
    }
}