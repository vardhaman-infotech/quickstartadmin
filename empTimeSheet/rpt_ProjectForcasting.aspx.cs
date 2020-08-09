using Microsoft.Reporting.WebForms;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

namespace empTimeSheet
{
    public partial class rpt_ProjectForcasting : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();
        DataSet dsexcel = new DataSet();
        excelexport objexcel = new excelexport();

        protected void Page_Load(object sender, EventArgs e)
        {

            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
               

                if (!objda.checkUserInroles("81"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
              
                fillproject();
               
            }
        }
        /// <summary>
        /// Fill Projects drop down for seraching
        /// </summary>
        protected void fillproject()
        {
          
            objts.name = "";
            objts.action = "getproject";
            objts.clientid = "";
            objts.companyId = Session["companyid"].ToString();
            objts.nid = "";
            ds = objts.rpt_ProjectAllocation();
            if (ds.Tables[0].Rows.Count > 0)
            {
                txtproject.DataSource = ds;
                txtproject.DataTextField = "projectcodename";
                txtproject.DataValueField = "projectid";
                txtproject.DataBind();
            }



        }





        /// <summary>
        /// Bind list of managers who assigned the tasks
        /// </summary>


        /// <summary>
        /// Fill tasks drop down for searching
        /// </summary>



        /// <summary>
        /// Fill Employee to select for those who have admin Right
        /// </summary>
    

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



        protected void fillgrid()
        {


            f_ReportLoad();




        }


        private void f_ReportLoad()
        {
            try
            {
                string p = Server.MapPath("rdlcreport");
                string strccontact = "";
               
                objts.nid = txtproject.Text;
               
                objts.type = "";
                objts.id = "";

                objts.action = "forcasting";
                objts.companyId = Session["companyid"].ToString();
                ReportViewer1.LocalReport.ReportPath = p + "\\project\\rpt_ProjectForecasting.rdlc";
                ReportParameter[] param = new ReportParameter[3];



                param[0] = new ReportParameter("companyname", Session["companyname"].ToString(), true);
                param[1] = new ReportParameter("companyaddress", Session["companyaddress"].ToString(), true);
                ds = objts.rpt_ProjectAllocation();

                if (ds.Tables[0].Rows.Count > 0)
                {
                    if (ds.Tables[2].Rows.Count > 0)
                    {
                        if (ds.Tables[2].Rows[0]["phone"].ToString() != "")
                            strccontact += "Tel: " + ds.Tables[2].Rows[0]["phone"].ToString() + " ";
                        if (ds.Tables[2].Rows[0]["fax"].ToString() != "")
                            strccontact += "Fax: " + ds.Tables[2].Rows[0]["fax"].ToString() + " ";
                        if (ds.Tables[2].Rows[0]["email"].ToString() != "")
                            strccontact += "<br/>" + ds.Tables[2].Rows[0]["email"].ToString() + " ";
                        if (ds.Tables[2].Rows[0]["website"].ToString() != "")
                            strccontact += "<br/>" + ds.Tables[2].Rows[0]["website"].ToString() + " ";

                    }

                    param[2] = new ReportParameter("companyphone", strccontact, true);
                  


                    ReportDataSource rds1 = new ReportDataSource("DataSet1", ds.Tables[0]);
                    ReportDataSource rds2 = new ReportDataSource("DataSet2", ds.Tables[1]);
                  


                    this.ReportViewer1.LocalReport.DataSources.Clear();

                    this.ReportViewer1.LocalReport.EnableExternalImages = true;

                    this.ReportViewer1.LocalReport.DataSources.Add(rds1);
                    this.ReportViewer1.LocalReport.DataSources.Add(rds2);
                    this.ReportViewer1.LocalReport.SetParameters(param);


                    this.ReportViewer1.LocalReport.Refresh();



                    ReportViewer1.LocalReport.DisplayName = "Project Forcasting";
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
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            fillgrid();
        }
    }
}