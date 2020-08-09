using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.UI.HtmlControls;

namespace empTimeSheet
{
    public partial class InvoiceTemplate : System.Web.UI.Page
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
                if (!objda.checkUserInroles("39"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
              
                binddetail();
                bindtemplate();
               
            }
        }
        protected void bindtemplate()
        {
            objadmin.action = "selecttemplate";
            objadmin.companyId = Session["companyid"].ToString();
            ds = objadmin.ManageSettings();
            if(ds.Tables[0].Rows.Count>0)
            {
                dltemplate.DataSource = ds.Tables[0];
                dltemplate.DataBind();
            }
        }

        protected void dltemplate_ItemDataBound(object sender, DataListItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                HtmlInputHidden hidTempid = (HtmlInputHidden)e.Item.FindControl("hidTempid");
               HtmlGenericControl divitem = (System.Web.UI.HtmlControls.HtmlGenericControl)e.Item.FindControl("divcontiner");
                if (hidTempid.Value == hidinvoicetemp.Value)
                {
                    divitem.Attributes.Add("class", "Temp_link_manage active");
                }

            }
        }

        protected void btnSave_OnClick(object sender, EventArgs e)
        {
            objadmin.action = "setcompanytemplate";
            objadmin.companyId = Session["companyid"].ToString();
            objadmin.invoicetemplate = hidseletedtemplate.Value.Trim();
            ds = objadmin.ManageSettings();
            GeneralMethod.alert(this.Page, "Template update successfully");
            binddetail();
            ScriptManager.RegisterStartupScript(this.Page, GetType(), "key", "<script>checkTemp('" + hidseletedtemplate.Value + "')</script>", false);
        }

        /// <summary>
        /// Bind company details
        /// </summary>
        protected void binddetail()
        {
            objadmin.action = "select";
            objadmin.companyId = Session["companyid"].ToString();

            ds = objadmin.ManageSettings();
            if (ds.Tables[0].Rows.Count > 0)
            {
                hidinvoicetemp.Value = ds.Tables[0].Rows[0]["InvoiceTemplate"].ToString();
            }
        }
    }
}