using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace empTimeSheet
{
    public partial class CompanySettings : System.Web.UI.Page
    {
        GeneralMethod objgen = new GeneralMethod();
        DataAccess objda = new DataAccess();
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                if (!objda.checkUserInroles("26"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }

              

            }
        }
    }
}