using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace empTimeSheet
{
    public partial class comp_GeneralInformation : System.Web.UI.Page
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
            if(!Page.IsPostBack)
            {
                bindcurrency();
                bindtimezone();

                binddetail();
            }
          
        }
        protected void bindtimezone()
        {

            ds = objda.getAllTimeZone();
            if (ds.Tables[0].Rows.Count > 0)
            {
                droptimezone.DataTextField = "displayname";
                droptimezone.DataValueField = "nid";
                droptimezone.DataSource = ds;
                droptimezone.DataBind();
            }
            ListItem li = new ListItem();
            li.Text = "--Select Timezone--";
            li.Value = "";
            droptimezone.Items.Insert(0, li);
        }
        protected void bindcurrency()
        {
            objda.action = "selectcurrency";
            ds = objda.ManageMaster();
            if (ds.Tables[0].Rows.Count > 0)
            {
                ddlcurrency.DataTextField = "symbol";
                ddlcurrency.DataValueField = "nid";
                ddlcurrency.DataSource = ds;
                ddlcurrency.DataBind();
            }
            ListItem li = new ListItem();
            li.Text = "--Select Currency--";
            li.Value = "";
            ddlcurrency.Items.Insert(0, li);
        }
        protected void binddetail()
        {
            objadmin.action = "selectbynid";
            objadmin.companyId = Session["companyid"].ToString();

            ds = objadmin.CompanySettings();
            if (ds.Tables[0].Rows.Count > 0)
            {
                Response.Cookies["user"]["companyname"] = HttpUtility.UrlEncode(ds.Tables[0].Rows[0]["companyname"].ToString());
                Response.Cookies["user"]["companyaddress"] = HttpUtility.UrlEncode(ds.Tables[0].Rows[0]["companyfulladdress"].ToString());

                Session["companyaddress"] = ds.Tables[0].Rows[0]["companyfulladdress"].ToString();
                Session["companyname"] = ds.Tables[0].Rows[0]["companyname"].ToString();

              
                txtcompanyName.Text = ds.Tables[0].Rows[0]["companyname"].ToString();
                txtEmail.Text = ds.Tables[0].Rows[0]["email"].ToString();
                txtwebsite.Text = ds.Tables[0].Rows[0]["website"].ToString();
               
               // txtservercompanyname.Text = ds.Tables[0].Rows[0]["ServerCompnyName"].ToString();


                txtcperson.Text = ds.Tables[0].Rows[0]["contactperson"].ToString();
                txtaddress.Text = ds.Tables[0].Rows[0]["address"].ToString();
                txtcity.Text = ds.Tables[0].Rows[0]["cityid"].ToString();
                txtstate.Text = ds.Tables[0].Rows[0]["stateid"].ToString();
                txtcountry.Text = ds.Tables[0].Rows[0]["countryid"].ToString();
                txtzip.Text = ds.Tables[0].Rows[0]["zip"].ToString();
                txtphone.Text = ds.Tables[0].Rows[0]["phone"].ToString();
                txtfax.Text = ds.Tables[0].Rows[0]["fax"].ToString();

              

             
                ddlcurrency.Text = ds.Tables[0].Rows[0]["currencyid"].ToString();
                droptimezone.Text = ds.Tables[0].Rows[0]["timezone"].ToString();
               
            }
          
        }
        protected void btnreset_Click(object sender, EventArgs e)
        { binddetail(); }
        protected void btnSave_OnClick(object sender, EventArgs e)
        {
            objadmin.action = "updategeneral";
            objadmin.companyId = Session["companyid"].ToString();

            objadmin.Name = txtcompanyName.Text;
            objadmin.email = txtEmail.Text;

            objadmin.website = txtwebsite.Text;           
          //  objadmin.servercompnyname = txtservercompanyname.Text;
            objadmin.symbol = ddlcurrency.Text;
            objadmin.timezone = droptimezone.Text;
            objadmin.contactPerson = txtcperson.Text;
            objadmin.address = txtaddress.Text;
            objadmin.stateId = txtstate.Text;
            objadmin.cityId = txtcity.Text;
            objadmin.countryId = txtcountry.Text;
            objadmin.zip = txtzip.Text;
            objadmin.phone = txtphone.Text;
            objadmin.fax = txtfax.Text;
            ds = objadmin.CompanySettings();
            binddetail();
            GeneralMethod.alert(this.Page, "Information saved successfully!");

        }
    }
}