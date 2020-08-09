using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
namespace empTimeSheet
{
    public partial class comp_BillSettings : System.Web.UI.Page
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
        protected void btnreset_Click(object sender, EventArgs e)
        { binddetail(); }
      
        protected void binddetail()
        {
            objadmin.action = "selectbynid";
            objadmin.companyId = Session["companyid"].ToString();

            ds = objadmin.CompanySettings();
            if (ds.Tables[0].Rows.Count > 0)
            {
             
                txtnextinvoiceno.Text = ds.Tables[0].Rows[0]["fistinvno"].ToString();
                txtprefix.Text = ds.Tables[0].Rows[0]["invprefix"].ToString();
                txtpostfix.Text = ds.Tables[0].Rows[0]["invpostfix"].ToString();



            }

        }
        protected void btnSave_OnClick(object sender, EventArgs e)
        {
            objadmin.action = "updateInvoiceNo";
            objadmin.companyId = Session["companyid"].ToString();

            objadmin.invno = txtnextinvoiceno.Text;
            objadmin.sufix = txtpostfix.Text;
            objadmin.prefix = txtprefix.Text;
            ds = objadmin.CompanySettings();

            GeneralMethod.alert(this.Page, "Information updated successfully!");

        }
    }
}