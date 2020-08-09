using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace empTimeSheet
{
    public partial class comp_AttandanceReaderSettings : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsAdmin objadmin = new ClsAdmin();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!objda.checkUserInroles("26"))
            {
                Response.Redirect("UserDashboard.aspx");
            }
            if (!Page.IsPostBack)
            {
             
                binddetail();
            }

        }
   
        protected void binddetail()
        {
            objadmin.action = "selectbynid";
            objadmin.companyId = Session["companyid"].ToString();

            ds = objadmin.CompanySettings();
            if (ds.Tables[0].Rows.Count > 0)
            {
                txtUserName.Text = ds.Tables[0].Rows[0]["usrNameAtendnceReadr"].ToString();
                txtPassword.Text = ds.Tables[0].Rows[0]["paswrdAtendnceReadr"].ToString();

            }

        }
        protected void btnreset_Click(object sender, EventArgs e)
        { binddetail(); }
        protected void btnSave_OnClick(object sender, EventArgs e)
        {
            objadmin.action = "updateAttandance";
            objadmin.companyId = Session["companyid"].ToString();
            objadmin.machineReadrUsrName = txtUserName.Text;
            objadmin.machineReadrPswd = txtPassword.Text;

            ds = objadmin.CompanySettings();
            binddetail();
            GeneralMethod.alert(this.Page, "Information saved successfully!");

        }
    }
}