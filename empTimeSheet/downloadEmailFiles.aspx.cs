using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace empTimeSheet
{
    public partial class downloadEmailFiles : System.Web.UI.Page
    {
        excelexport objexcel = new excelexport();
        ClsFile objda = new ClsFile();
        DataSet ds = new DataSet();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (Request.QueryString["fileid"] == null)
                {
                    Response.Redirect("error.html");
                }
                fillgrid();

            }
        }
        public void fillgrid()
        {
            objda.nid ="";
            objda.filecode = Request.QueryString["fileid"].ToString();
            objda.action = "select";
            ds = objda.ManageEmailFileShare();
            if (ds.Tables[0].Rows.Count > 0)
            {
                repfile.DataSource = ds.Tables[1];
                repfile.DataBind();

            }
            else
            { 
            
            }

        
        }
        protected void repfile_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "downloadfile")
            {
                objda.nid = e.CommandArgument.ToString();
                objda.action = "selectfile";
                ds = objda.ManageEmailFileShare();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    if (!objexcel.downloadVirturalfile(ds.Tables[0].Rows[0]["savedfilename"].ToString(), ds.Tables[0].Rows[0]["originalfilename"].ToString(), "webfile/emailfile"))
                    {
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('File is not available or temporarily removed.'); </script>", false);
                        return;
                    }
                
                
                }
            
            
            }
        }
    }
}