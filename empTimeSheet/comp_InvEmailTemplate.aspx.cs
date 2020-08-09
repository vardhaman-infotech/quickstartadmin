using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.UI.HtmlControls;
using System.IO;

namespace empTimeSheet
{
    public partial class comp_InvEmailTemplate : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();

        ClsAdmin objadmin = new ClsAdmin();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                if (!objda.checkUserInroles("26"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }

                binddetail();


            }
        }
        public void binddetail()
        {

            string HTMLTemplatePath = Server.MapPath("EmailTemplates/invEmail.html");
            string HTMLBODY = File.Exists(HTMLTemplatePath) ? File.ReadAllText(HTMLTemplatePath) : "Enter Email Text";

            Editor1.Content = HTMLBODY;


        }

        protected void btnSave_OnClick(object sender, EventArgs e)
        {
            string HTMLTemplatePath = Server.MapPath("EmailTemplates/invEmail.html");
            string HTMLBODY = Editor1.Content;

            File.WriteAllText(HTMLTemplatePath, HTMLBODY);
            GeneralMethod.alert(this.Page, "Saved Successfully!");
        
        }
    }
}