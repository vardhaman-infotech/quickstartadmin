using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace empTimeSheet.Client
{
    public partial class ClientMaster : System.Web.UI.MasterPage
    {
        string sPageName = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                string sPagePath = System.Web.HttpContext.Current.Request.Url.AbsolutePath;
                System.IO.FileInfo oFileInfo = new System.IO.FileInfo(sPagePath);
                sPageName = (oFileInfo.Name).ToLower();
                activatemenu();
            }

        }
        public void activatemenu()
        {
            switch (sPageName)
            {
                case "home.aspx": lnkhome.Attributes.Add("class", "active"); break;
                case "projectstatusreport.aspx": lnkreport.Attributes.Add("class", "active"); break;
                case "emptimesheet.aspx": lnktimesheet.Attributes.Add("class", "active"); break;

            }

        }
    }
}