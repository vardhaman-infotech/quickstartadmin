using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Data;
using System.Web.Services;
using System.Web.Script.Services;
using System.Text;
using empTimeSheet.DataClasses.DAL;

namespace empTimeSheet
{
    public partial class asset_VendorMaster : System.Web.UI.Page
    {
        #region ""Global Variables"
        GeneralMethod objgen = new GeneralMethod();
        DataAccess objda = new DataAccess();
        DataSet ds = new DataSet();
        DataSet ds2 = new DataSet();
        Cls_Asset dbObject = new Cls_Asset();
        #endregion

        #region"Page Load Event"
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                if (!objda.checkUserInroles("92"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
                fillcountry();
                fillgrid();
            }
        }
        #endregion

        #region "Link Button Add New Click Event"
        protected void liaddnew_Click(object sender, EventArgs e)
        {
            blank();
        }
        #endregion

        #region "Blank All Controls"
        public void blank()
        {

            enableAllTextBoxes();
            fillNullInTheTextBoxes();
            btndelete.Visible = false;
            btnsubmit.Text = "Submit";

        }
        #endregion

        #region "Enable All Text Boxex"
        private void enableAllTextBoxes()
        {
            txt_venderCode.Enabled = true;
            txt_venderCode.Enabled = true;
            txt_vendorName.Enabled = true;
            txt_contactPersonName.Enabled = true;
            txt_designation.Enabled = true;
            txt_streetAddress.Enabled = true;
            dropcountry.Enabled = true;
            dropstate.Enabled = true;
            dropcity.Enabled = true;
            txt_zip.Enabled = true;
            txt_Phone.Enabled = true;
            txt_cell.Enabled = true;
            txt_emailId.Enabled = true;
            txt_Fax.Enabled = true;
            txt_Websites.Enabled = true;
            txt_Notes.Enabled = true;
        }
        #endregion

        #region"Fill Null in All Text Boxes"
        private void fillNullInTheTextBoxes()
        {
            hidid.Value = "";
            txt_venderCode.Text = string.Empty;
            txt_vendorName.Text = string.Empty;
            txt_contactPersonName.Text = string.Empty;
            txt_designation.Text = string.Empty;
            txt_streetAddress.Text = string.Empty;
            dropcountry.Text = string.Empty;
            dropstate.Text = string.Empty;
            dropcity.Text = string.Empty;
            txt_zip.Text = string.Empty;
            txt_Phone.Text = string.Empty;
            txt_cell.Text = string.Empty;
            txt_emailId.Text = string.Empty;
            txt_Fax.Text = string.Empty;
            txt_Websites.Text = string.Empty;
            txt_Notes.Text = string.Empty;
        }
        #endregion

        #region "Country Drop Down Selected Index Changed Event"
        protected void dropcountry_SelectedIndexChanged(object sender, EventArgs e)
        {
            fillstate();
        }
        #endregion

        #region "Fill Country"
        public void fillcountry()
        {
            objda.id = "";
            objda.action = "selectcountry";
            ds = objda.ManageMaster();
            dropcountry.DataSource = ds;
            dropcountry.DataTextField = "countryname";
            dropcountry.DataValueField = "nid";
            dropcountry.DataBind();
            ListItem li = new ListItem("--Select--", "");
            dropcountry.Items.Insert(0, li);
            dropcountry.SelectedIndex = 0;
        }
        #endregion

        #region "Fill State"
        public void fillstate()
        {
            string name = dropcountry.Items[dropcountry.SelectedIndex].Text;

            dropstate.Items.Clear();
            dropcity.Items.Clear();
            if (dropcountry.Text != "")
            {
                objda.id = "";
                objda.parentid = dropcountry.Text;
                objda.action = "selectstate";
                ds2 = objda.ManageMaster();
                dropstate.DataSource = ds2;
                dropstate.DataTextField = "statename";
                dropstate.DataValueField = "nid";
                dropstate.DataBind();
            }
            ListItem li = new ListItem("--Select--", "");
            dropstate.Items.Insert(0, li);
            dropstate.SelectedIndex = 0;
            fillcity();
        }
        #endregion

        #region "Search button Click Event"
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            fillgrid();
        }
        #endregion

        #region "Fill City"
        public void fillcity()
        {
            dropcity.Items.Clear();
            if (dropstate.Text != "")
            {
                objda.id = "";
                objda.action = "selectcity";
                objda.parentid = dropstate.Text;
                ds2 = objda.ManageMaster();
                dropcity.DataSource = ds2;
                dropcity.DataTextField = "cityname";
                dropcity.DataValueField = "nid";
                dropcity.DataBind();
            }
            ListItem li = new ListItem("--Select--", "");
            dropcity.Items.Insert(0, li);
            dropcity.SelectedIndex = 0;
        }

        #endregion

        #region "State Drop Down Selected Index Changed Event "
        protected void dropstate_SelectedIndexChanged(object sender, EventArgs e)
        {
            fillcity();
        }
        #endregion

        #region "Fill GridView of Vendor List"
        public void fillgrid()
        {
            dbObject.nid = "";
            dbObject.action = "select";
            dbObject.companyId = Session["companyid"].ToString();
            dbObject.VendorName = txtsearch.Text;
            ds = dbObject.vendor();
            if (ds.Tables[0].Rows.Count > 0)
            {
                dgnews.DataSource = ds;
                dgnews.DataBind();
                dgnews.Visible = true;
                nodata.Visible = false;
            }
            else
            {
                dgnews.Visible = false;
                nodata.Visible = true;
            }
        }
        #endregion

        #region "DataGrdView Row Command Event"
        protected void dgnews_RowCommand(object sender, RepeaterCommandEventArgs e)
        {

            if (e.CommandName.ToLower() == "detail")
            {
                hidid.Value = e.CommandArgument.ToString();
                dbObject.nid = e.CommandArgument.ToString();
                dbObject.action = "select";
                dbObject.name = "";

                ds = dbObject.vendor();
                txt_venderCode.Enabled = false;
                txt_venderCode.Text = ds.Tables[0].Rows[0]["Code"].ToString();
                txt_vendorName.Text = ds.Tables[0].Rows[0]["VenderName"].ToString();
                txt_contactPersonName.Text = ds.Tables[0].Rows[0]["ContactPerson"].ToString();
                txt_designation.Text = ds.Tables[0].Rows[0]["Designation"].ToString();
                txt_streetAddress.Text = ds.Tables[0].Rows[0]["StreetAddress"].ToString();
                dropcountry.Text = ds.Tables[0].Rows[0]["Country"].ToString();
                fillstate();
                dropstate.Text = ds.Tables[0].Rows[0]["State"].ToString();
                fillcity();
                dropcity.Text = ds.Tables[0].Rows[0]["City"].ToString();
                txt_zip.Text = ds.Tables[0].Rows[0]["ZIP"].ToString();
                txt_Phone.Text = ds.Tables[0].Rows[0]["Phone"].ToString();
                txt_cell.Text = ds.Tables[0].Rows[0]["Cell"].ToString();
                txt_emailId.Text = ds.Tables[0].Rows[0]["email"].ToString();
                txt_Fax.Text = ds.Tables[0].Rows[0]["Fax"].ToString();
                txt_Websites.Text = ds.Tables[0].Rows[0]["Website"].ToString();
                txt_Notes.Text = ds.Tables[0].Rows[0]["notes"].ToString();
                btnsubmit.Text = "Update";
                btndelete.Visible = true;
            }

        }
        #endregion

        #region "Button Submit Click Event"
        protected void btnsubmit_Click(object sender, EventArgs e)
        {

            if (hidid.Value == "")
            {
                dbObject.Code = txt_venderCode.Text;
                dbObject.action = "checkvendorcode";
                ds = dbObject.vendor();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    GeneralMethod.alert(this.Page, "Vendor Code Already Exists!");
                    return;

                }
            }

            dbObject.nid = hidid.Value;
            dbObject.Code = txt_venderCode.Text;
            dbObject.VendorName = txt_vendorName.Text;
            dbObject.ContactPerson = txt_contactPersonName.Text;
            dbObject.Designation = txt_designation.Text;
            dbObject.Street = txt_streetAddress.Text;
            dbObject.Country = dropcountry.Text;
            dbObject.State = dropstate.Text;
            dbObject.City = dropcity.Text;
            dbObject.Zip = txt_zip.Text;
            dbObject.Phone = txt_Phone.Text;
            dbObject.Cell = txt_cell.Text;
            dbObject.Email = txt_emailId.Text;
            dbObject.Fax = txt_Fax.Text;
            dbObject.action = "insert";
            dbObject.Website = txt_Websites.Text;
            dbObject.Notes = txt_Notes.Text;
            dbObject.companyId = Session["companyid"].ToString();
            ds = dbObject.vendor();
            blank();
            fillgrid();


            GeneralMethod.alert(this.Page, "Saved Successfully!");
        }
        #endregion

        #region "Button Delete Click Event"
        protected void btndelete_Click(object sender, EventArgs e)
        {

            dbObject.action = "delete";
            dbObject.nid = hidid.Value;
            ds = dbObject.vendor();
            blank();
            fillgrid();

            GeneralMethod.alert(this.Page, "Deleted Successfully!");
        }
        #endregion

    }
}




