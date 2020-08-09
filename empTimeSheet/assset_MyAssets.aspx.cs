using empTimeSheet.DataClasses.DAL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace empTimeSheet
{
    public partial class assset_MyAssets : System.Web.UI.Page
    {
        #region "Global variable Declaration"
        GeneralMethod objgen = new GeneralMethod();
        ClsUser objuser = new ClsUser();
        DataSet ds = new DataSet();
        DataAccess objda = new DataAccess();
        Cls_Asset objAsset = new Cls_Asset();
        static DataSet dsexcel = new DataSet();
        excelexport objexcel = new excelexport();
        string depid = "";
        #endregion
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
              
                filldepartment();
                fillCategory();
                fillgrid();
            }
        }

        #region"Fill All Departments"
        public void filldepartment()
        {
            objda.id = "";
            objda.name = "";
            objda.company = Session["companyid"].ToString();
            objda.action = "select";
            ds = objda.department();
            DropSearchDepartment.DataSource = ds;
            DropSearchDepartment.DataTextField = "department";
            DropSearchDepartment.DataValueField = "nid";
            DropSearchDepartment.DataBind();

            ListItem li1 = new ListItem("--All Department--", "");
            DropSearchDepartment.Items.Insert(0, li1);
            DropSearchDepartment.SelectedIndex = 0;

        }
        #endregion

        #region"Fill All Category"
        public void fillCategory()
        {
            objAsset.companyId = Session["companyid"].ToString();
            objAsset.action = "selectCategory";
            ds = objAsset.ManageAsset();
            DropSearchCategory.DataSource = ds;
            DropSearchCategory.DataTextField = "categoryname";
            DropSearchCategory.DataValueField = "nid";
            DropSearchCategory.DataBind();

            ListItem li1 = new ListItem("--All Category--", "");
            DropSearchCategory.Items.Insert(0, li1);
            DropSearchCategory.SelectedIndex = 0;

        }
        #endregion

        #region Fill Grid of Asset Master
        protected void fillgrid()
        {
            objAsset.companyId = Session["companyid"].ToString();
            objAsset.CategoryID = DropSearchCategory.Text;
            objAsset.department = DropSearchDepartment.Text;
            objAsset.name = txtSearchAsset.Text;
            //objAsset.Code = txtSearchAsset.Text;
            objAsset.action = "select";
            objAsset.nid = "";
            objAsset.locationId = Session["userid"].ToString();
            ds = objAsset.ManageAsset();

            int start = dgnews.PageSize * dgnews.PageIndex;
            int end = start + dgnews.PageSize;
            start = start + 1;
            if (end >= ds.Tables[0].Rows.Count)
                end = ds.Tables[0].Rows.Count;
            lblstart.Text = start.ToString();
            lblend.Text = end.ToString();
            lbltotalrecord.Text = ds.Tables[0].Rows.Count.ToString();

            if (ds.Tables[0].Rows.Count > 0)
            {
                dgnews.DataSource = ds;
                dgnews.DataBind();
                divnodata.Visible = false;
                dgnews.Visible = true;

                //btnexportcsv.Enabled = true;
            }
            else
            {

                if (IsPostBack)
                {
                    divnodata.Visible = true;
                }
                dgnews.Visible = false;
                //btnexportcsv.Enabled = false;
            }
            dsexcel = ds;
            updatePanelData.Update();
        }

        #endregion

        #region "Previous Link Button Click Event"
        protected void lnkprevious_Click(object sender, EventArgs e)
        {
            if (dgnews.PageIndex > 0)
            {
                dgnews.PageIndex = dgnews.PageIndex - 1;
                fillgrid();
            }
        }
        #endregion

        #region "Next Link Button Click Event"
        protected void lnknext_Click(object sender, EventArgs e)
        {
            if (int.Parse(lbltotalrecord.Text) > int.Parse(lblend.Text))
            {
                dgnews.PageIndex = dgnews.PageIndex + 1;
                fillgrid();
            }
        }
        #endregion

        #region "DataGridView PageIndex Changing Event"
        protected void dgnews_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            dgnews.PageIndex = e.NewPageIndex;
            fillgrid();
        }
        #endregion

        #region "Search Buttton Click"
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            //hidid.Value = "";
            fillgrid();
        }
        #endregion



    }
}