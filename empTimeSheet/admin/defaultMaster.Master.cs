using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace emptimesheet.admin
{
    public partial class defaultMaster : System.Web.UI.MasterPage
    {
        string sPageName = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["adminid"] == null)
            {
                Response.Redirect("logout.aspx");

            }
            //Get current page name
            string sPagePath = System.Web.HttpContext.Current.Request.Url.AbsolutePath;
            System.IO.FileInfo oFileInfo = new System.IO.FileInfo(sPagePath);
            sPageName = (oFileInfo.Name).ToLower();
            if (!IsPostBack)
            {
                //Show logged user name at top right
                lblusername.Text = Session["adminname"].ToString();
            }
            activatemenu();
        }
        /// <summary>
        /// Activate menu according to to currently opened page name
        /// </summary>
        public void activatemenu()
        {
            //Apply "current" class for activate
            switch (sPageName)
            {
                case "managecompany.aspx": lnkcompany.Attributes.Add("class", "current"); break;
                case "managecountry.aspx": lnkcountry.Attributes.Add("class", "current"); break;
                case "managecurrency.aspx": lnkcurrency.Attributes.Add("class", "current"); break;
                case "managestate.aspx": lnkstate.Attributes.Add("class", "current"); break;
                case "managecity.aspx": lnkcity.Attributes.Add("class", "active"); break;

            }


        }
    }
}