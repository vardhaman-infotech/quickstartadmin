using empTimeSheet.DataClasses.DAL;
using Microsoft.Reporting.WebForms;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace empTimeSheet
{
    public partial class rpt_AssetManagement : System.Web.UI.Page
    {
        #region "Global Variable Declaration"
        DataAccess objda = new DataAccess();
        Cls_Asset objAsset = new Cls_Asset();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();
        DataSet dsexcel = new DataSet();
        excelexport objexcel = new excelexport();
        #endregion

        #region "Page Load Event"
        protected void Page_Load(object sender, EventArgs e)
        {

            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                if (!objda.checkUserInroles("96"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
                fillAssetsByCategory();
                filldepartment();
                fillAsset();
               
            }
        }
        #endregion

        #region"Fill All Assets"
        public void fillAsset()
        {
            objAsset.companyId = Session["companyid"].ToString();
            objAsset.action = "select";
            objAsset.nid = "";
            objAsset.CategoryID = "";
            objAsset.department = "";
            objAsset.name = "";
            ds = objAsset.ManageAsset();
            dropAssets.DataSource = ds;
            dropAssets.DataTextField = "assetname";
            dropAssets.DataValueField = "nid";
            dropAssets.DataBind();

        }
        #endregion

        #region "Fill Category"
        protected void fillAssetsByCategory()
        {
            objAsset.companyId = Session["companyid"].ToString();
            objAsset.action = "selectCategory";
            ds = objAsset.ManageAsset();
            dropAssetsCategory.DataSource = ds;
            dropAssetsCategory.DataTextField = "categoryname";
            dropAssetsCategory.DataValueField = "nid";
            dropAssetsCategory.DataBind();

           
        }
        #endregion

        #region"Fill All Departments"
        public void filldepartment()
        {
            objda.id = "";
            objda.name = "";
            objda.company = Session["companyid"].ToString();
            objda.action = "select";
            ds = objda.department();
            dropDepartment.DataSource = ds;
            dropDepartment.DataTextField = "department";
            dropDepartment.DataValueField = "nid";
            dropDepartment.DataBind();
        }
        #endregion

        #region "Check Box List Value Get"
        private string getchkval(CheckBoxList chk)
        {
            StringBuilder sb = new StringBuilder();
            for (var i = 0; i < chk.Items.Count; i++)
            {
                if (chk.Items[i].Selected)
                {
                    sb.Append(chk.Items[i].Value + ",");
                }
            }
            return sb.ToString();
        }

        #endregion

        #region "Fillgrid Function"
        protected void fillgrid()
        {
            f_ReportLoad();
        }

        #endregion

        #region "Bind Data in Report"
        private void f_ReportLoad()
        {
            try
            {
                string p = Server.MapPath("rdlcreport");
                string strccontact = "";
                objAsset.department = getchkval(dropDepartment);
                objAsset.companyId = Session["companyid"].ToString();
                objAsset.CategoryID = getchkval(dropAssetsCategory);
                objAsset.nid = getchkval(dropAssets);
                //objAsset.currentLocation = getchkval(dropLocation);
                objAsset.action = "select";
                ds = objAsset.ReportAsset();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    divnodata.Visible = false;
                    divreport.Visible = true;
                    ReportViewer1.LocalReport.ReportPath = p + "\\Asset\\AssetManagement.rdlc";
                    ReportParameter[] param = new ReportParameter[3];
                    param[0] = new ReportParameter("companyname", Session["companyname"].ToString(), true);
                    param[1] = new ReportParameter("companyaddress", Session["companyaddress"].ToString(), true);
                    if (ds.Tables[1].Rows.Count > 0)
                    {
                        if (ds.Tables[1].Rows[0]["phone"].ToString() != "")
                            strccontact += "Tel: " + ds.Tables[1].Rows[0]["phone"].ToString() + " ";
                        if (ds.Tables[1].Rows[0]["fax"].ToString() != "")
                            strccontact += "Fax: " + ds.Tables[1].Rows[0]["fax"].ToString() + " ";
                        if (ds.Tables[1].Rows[0]["email"].ToString() != "")
                            strccontact += "<br/>" + ds.Tables[1].Rows[0]["email"].ToString() + " ";
                        if (ds.Tables[1].Rows[0]["website"].ToString() != "")
                            strccontact += "<br/>" + ds.Tables[1].Rows[0]["website"].ToString() + " ";
                    }
                    param[2] = new ReportParameter("companyphone", strccontact, true);
                    ReportDataSource rds1 = new ReportDataSource("DataSet1", ds.Tables[0]);
                    this.ReportViewer1.LocalReport.DataSources.Clear();
                    this.ReportViewer1.LocalReport.EnableExternalImages = true;
                    this.ReportViewer1.LocalReport.DataSources.Add(rds1);
                    this.ReportViewer1.LocalReport.SetParameters(param);
                    this.ReportViewer1.LocalReport.Refresh();
                    ReportViewer1.LocalReport.DisplayName = "Client Master File";
                    divreport.Visible = true;
                    divnodata.Visible = false;
                }
                else
                {
                    divreport.Visible = false;
                    divnodata.Visible = true;
                }
            }
            catch (Exception ex)
            {
            }
        }
        #endregion

        #region "Button Search Click Event"
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            fillgrid();
        }
        #endregion
    }
}