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
    public partial class rpt_ProjectAnalysisReport : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();

        DataSet ds = new DataSet();

        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();

            if (!IsPostBack)
            {

                if (!objda.checkUserInroles("105"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }

                fillclient();
                fillproject();
                // fillmanager();

            }
        }

        /// <summary>
        /// Fill clients drop down for searching
        /// </summary>
        protected void fillclient()
        {
            objuser.clientname = "";
            objuser.action = "select1";
            objuser.companyid = Session["companyid"].ToString();
            objuser.id = "";
            ds = objuser.client();
            if (ds.Tables[0].Rows.Count > 0)
            {
                dropclient.DataSource = ds;
                dropclient.DataTextField = "clientname";
                dropclient.DataValueField = "nid";
                dropclient.DataBind();
                //ListItem li = new ListItem("--All Clients--", "");
                //dropclient.Items.Insert(0, li);
            }


        }
        /// <summary>
        /// Fill Projects drop down for seraching
        /// </summary>
        protected void fillproject()
        {
            dropproject.Items.Clear();
            objts.name = "";
            objts.action = "selectbyclient";
            objts.clientid = "";
            objts.companyId = Session["companyid"].ToString();
            objts.nid = "";
            ds = objts.ManageProject();
            if (ds.Tables[0].Rows.Count > 0)
            {
                dropproject.DataSource = ds;
                dropproject.DataTextField = "projectcode";
                dropproject.DataValueField = "nid";
                dropproject.DataBind();
            }
        }

        protected void btnsearch_click(object sender, EventArgs e)
        {
            searchdata();
        }

        protected void searchdata()
        {
            hidsearchdrpclient.Value = getchkval(dropclient);
            hidsearchdrpproject.Value = getchkval(dropproject);

            hidsearchdrpclientname.Value = "";
            hidsearchdrpprojectname.Value = "";

            fillgrid();
        }

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
            objts.clientid = getchkval(dropclient);
            objts.taskid = "";
            if (dropactive.Text == "--All--")
            {
                objts.Status = "";
            }
            else
            { objts.Status = dropactive.Text; }
            objts.projectid = getchkval(dropproject);
            objts.taskStatus = "Approved";

            objts.action = "analysisreport";
            objts.companyId = Session["companyid"].ToString();
            objts.nid = "";
            ds = objts.ManageProjectMasterClient();


            if (ds.Tables[0].Rows.Count > 0)
            {
                f_ReportLoad();
                divnodata.Visible = false;

                divreport.Visible = true;
            }
            else
            {
                divnodata.Visible = true;
                divreport.Visible = false;
            }
        }

        private void f_ReportLoad()
        {
            try
            {
                string p = Server.MapPath("rdlcreport");
                string strccontact = "";
                string logobig = "";

                //   ReportViewer1.ProcessingMode = ProcessingMode.Local;
                //LocalReport rep = ReportViewer1.LocalReport;

                //reportViewer1.LocalReport.ReportEmbeddedResource = System.IO.Directory.GetCurrentDirectory() + @"\Reports\Rdlc\PaidBill_Check.rdlc";

                ReportViewer1.LocalReport.ReportPath = p + "\\analysis\\projectAnalysisReport.rdlc";
               // ReportViewer1.LocalReport.ReportPath = p + "\\projectAnalysisReport.rdlc";
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
                ReportViewer1.LocalReport.DisplayName = "Project Analysis Report";
            }
            catch (Exception ex)
            {
            }
        }
    }
}