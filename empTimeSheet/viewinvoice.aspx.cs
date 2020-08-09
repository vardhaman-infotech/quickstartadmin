using Microsoft.Reporting.WebForms;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;


namespace empTimeSheet
{
    public partial class viewinvoice : System.Web.UI.Page
    {
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();
        DataAccess objda = new DataAccess();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack) {
         
                objgen.validatelogin();
                 if (!objda.checkUserInroles("37"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
                //Request.QueryString["invoiceno"] != null && 
                 if (Request.QueryString["invoiceid"] != null)
                 {
                     f_ReportLoad();
                 }
            }
          
        }
        private void f_ReportLoad()
        {
            try
            {
                string p = Server.MapPath("rdlcreport\\invoice");
                string logosmall = "";
                string logobig = "";

                //   ReportViewer1.ProcessingMode = ProcessingMode.Local;
                //LocalReport rep = ReportViewer1.LocalReport;

                //reportViewer1.LocalReport.ReportEmbeddedResource = System.IO.Directory.GetCurrentDirectory() + @"\Reports\Rdlc\PaidBill_Check.rdlc";
                objts.nid = Request.QueryString["invoiceid"].ToString();
                ds = objts.printinvoice();

                int num = 8;
                if (ds.Tables[3].Rows[0]["nid"].ToString() == "1")
                    num = 2;

               
                if(ds.Tables[1].Rows.Count<num)
                {
                    for (int i = ds.Tables[1].Rows.Count; i <= num; i++)
                    {
                         DataRow row = ds.Tables[1].NewRow();
                        
                         ds.Tables[1].Rows.Add(row);

                    }
                    ds.Tables[1].AcceptChanges();
                }

               
             

                ReportViewer1.LocalReport.ReportPath = p + "\\" + ds.Tables[3].Rows[0]["rdlcfile"].ToString();
               
                ReportParameter[] param = new ReportParameter[2];

                if (ds.Tables[0].Rows[0]["logosmall"].ToString() == "")
                {
                    logosmall = "images\\nologo.png";

                }
                else
                {
                    logosmall = "webfile\\" + ds.Tables[0].Rows[0]["logosmall"].ToString();

                }

                if (ds.Tables[0].Rows[0]["logoURL"].ToString() == "")
                {
                    logobig = "images\\nologo.png";

                }
                else
                {
                    logobig = "webfile\\" + ds.Tables[0].Rows[0]["logoURL"].ToString();

                }
                param[0]=new ReportParameter("filename", "file:\\" + Server.MapPath(logobig), true);
                param[1] = new ReportParameter("logosmall", "file:\\" + Server.MapPath(logosmall), true);


                ReportDataSource rds1 = new ReportDataSource("DataSet1", ds.Tables[0]);
                ReportDataSource rds2 = new ReportDataSource("DataSet2", ds.Tables[1]);
                ReportDataSource rds3 = new ReportDataSource("DataSet3", ds.Tables[2]);
                this.ReportViewer1.LocalReport.DataSources.Clear();

                this.ReportViewer1.LocalReport.EnableExternalImages = true;
              
                this.ReportViewer1.LocalReport.DataSources.Add(rds1);
                this.ReportViewer1.LocalReport.DataSources.Add(rds2);
                this.ReportViewer1.LocalReport.DataSources.Add(rds3);
                this.ReportViewer1.LocalReport.SetParameters(param);

                this.ReportViewer1.LocalReport.Refresh();

           

                ReportViewer1.LocalReport.DisplayName = ds.Tables[0].Rows[0]["invoiceno"].ToString();
            }
            catch (Exception ex)
            {
            }
            

           

        }
    }
}