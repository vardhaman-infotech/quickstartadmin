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
    public partial class rpt_AssetByCondition : System.Web.UI.Page
    {
        #region "Gloabal Variabl Declaration"
        DataAccess objda = new DataAccess();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();
        DataSet dsexcel = new DataSet();
        excelexport objexcel = new excelexport();
        Cls_Asset objAsset = new Cls_Asset();
        #endregion

        #region "Form Load Event"
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                if (!objda.checkUserInroles("96"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
                filldepartment();
                fillAsset();
                fillCategory();
            }
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

        #region"Fill All Category"
        public void fillCategory()
        {
            objAsset.companyId = Session["companyid"].ToString();
            objAsset.action = "selectCategory";
            ds = objAsset.ManageAsset();
            dropCategory.DataSource = ds;
            dropCategory.DataTextField = "categoryname";
            dropCategory.DataValueField = "nid";
            dropCategory.DataBind();

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
            dropAsset.DataSource = ds;
            dropAsset.DataTextField = "assetname";
            dropAsset.DataValueField = "nid";
            dropAsset.DataBind();

        }
        #endregion

        #region "Fill Gid Function"
        protected void fillgrid()
        {
            f_ReportLoad();
        }
        #endregion

        #region "Button Search Click Event"
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            fillgrid();
        }
        #endregion

        #region "Bind Data in Report"
        private void f_ReportLoad()
        {
            try
            {
                string p = Server.MapPath("rdlcreport");
                string strccontact = "";
                objAsset.nid = getchkval(dropAsset);
                objAsset.CategoryID = getchkval(dropCategory);
                objAsset.department = getchkval(dropDepartment);
                objAsset.companyId = Session["companyid"].ToString();
                objAsset.action = "select";
                ds = objAsset.ReportAsset();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    divnodata.Visible = false;
                    divreport.Visible = true;
                    ReportViewer1.LocalReport.ReportPath = p + "\\Asset\\rpt_AssetByCondition.rdlc";
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
                    //string strvalue = "";
                    //strvalue = "taskCode,taskname,description,costrate,isbillable,isReimb,MuRate,tax,";
                    param[2] = new ReportParameter("companyphone", strccontact, true);
                    //param[3] = new ReportParameter("SelectColumn", strvalue, true);


                    ReportDataSource rds1 = new ReportDataSource("DataSet1", ds.Tables[0]);
                    this.ReportViewer1.LocalReport.DataSources.Clear();
                    this.ReportViewer1.LocalReport.EnableExternalImages = true;
                    this.ReportViewer1.LocalReport.DataSources.Add(rds1);
                    this.ReportViewer1.LocalReport.SetParameters(param);
                    this.ReportViewer1.LocalReport.Refresh();
                    ReportViewer1.LocalReport.DisplayName = "Asset Report";
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

    }
}