using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.IO;
using System.Web.UI.HtmlControls;
using System.Text;
using Microsoft.Reporting.WebForms;

namespace empTimeSheet
{
    public partial class rpt_budgetDetail : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        string datefilter = "";
        DataSet ds = new DataSet();



        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();

            if (!IsPostBack)
            {

                if (!objda.checkUserInroles("114"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }

                txtfrmdate.Text = Convert.ToDateTime(GeneralMethod.getLocalDate()).AddDays(-7).ToString("MM/dd/yyyy");
                txttodate.Text = GeneralMethod.getLocalDate();

                fillclient();
                fillproject();

            }
        }

        /// <summary>
        /// Fill list of existing clients For Search
        /// </summary>
        public void fillclient()
        {
            objuser.action = "select";

            objuser.name = "";
            objuser.id = "";
            objuser.companyid = Session["companyId"].ToString();
            ds = objuser.client();
            if (ds.Tables[0].Rows.Count > 0)
            {
                dropclient.DataSource = ds;
                dropclient.DataTextField = "clientcodewithname";
                dropclient.DataValueField = "nid";
                dropclient.DataBind();


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
            objts.clientid = getchkval(dropclient);
            objts.companyId = Session["companyid"].ToString();
            objts.nid = "";
            ds = objts.ManageProject();
            if (ds.Tables[0].Rows.Count > 0)
            {
                dropproject.DataSource = ds;
                dropproject.DataTextField = "projectnamewithcode";
                dropproject.DataValueField = "nid";
                dropproject.DataBind();
            }



        }



        /// <summary>
        /// When search any record
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnsearch_click(object sender, EventArgs e)
        {
            searchdata();
        }
        protected void searchdata()
        {
            if (dropdaterange.Text == "Custom")
            {
                hidsearchfromdate.Value = txtfrmdate.Text;
                hidsearchtodate.Value = txttodate.Text;
                datefilter = "Report From " + hidsearchfromdate.Value + " To " + hidsearchtodate.Value;
            }
            else
            {
                var result = DateRange.getLastDates(dropdaterange.Text, txtfrmdate.Text, txttodate.Text);
                hidsearchfromdate.Value = result.fromdate;
                hidsearchtodate.Value = result.todate;
                datefilter = result.datetext;

            }

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

        //Fill clients
        protected void fillgrid()
        {
            objts.action = "budgetDetail";
            objts.clientid = hidsearchdrpclient.Value;
            objts.projectid = hidsearchdrpproject.Value;

            objts.from = hidsearchfromdate.Value;
            objts.to = hidsearchtodate.Value;
            objts.companyId = Session["companyid"].ToString();
            ds = objts.Budget_Report();

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

                // ReportViewer1.LocalReport.ReportPath = p + "\\aging\\agingrdlc.rdlc";
                ReportViewer1.LocalReport.ReportPath = p + "\\Budget\\BudgeDetail.rdlc";
                ReportParameter[] param = new ReportParameter[4];



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
                param[3] = new ReportParameter("reportfilter", datefilter, true);
                ReportDataSource rds1 = new ReportDataSource("DataSet1", ds.Tables[0]);


                this.ReportViewer1.LocalReport.DataSources.Clear();

                this.ReportViewer1.LocalReport.EnableExternalImages = true;

                this.ReportViewer1.LocalReport.DataSources.Add(rds1);
                this.ReportViewer1.LocalReport.SetParameters(param);


                this.ReportViewer1.LocalReport.Refresh();



                ReportViewer1.LocalReport.DisplayName = "Budget Detail Report";
            }
            catch (Exception ex)
            {
            }




        }


        /// <summary>
        /// Refresh the grid, so changes made by any other can reflect.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>



        public override void VerifyRenderingInServerForm(Control control)
        {
            /* Verifies that the control is rendered */
        }

        /// <summary>
        /// Bind Header of excel Report
        /// </summary>
        /// <param name="type"></param>
        /// <returns></returns>







    }
}