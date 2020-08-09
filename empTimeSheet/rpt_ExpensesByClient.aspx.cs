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
    public partial class rpt_ExpensesByClient : System.Web.UI.Page
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
                txtfromdate.Text = System.DateTime.Now.AddDays(-2).ToString("MM/dd/yyyy");
                txttodate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");

                if (!objda.checkUserInroles("58"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }


                fillemployee();
                fillclient();
                fillproject();
                fillmanager();

                //fillgrid();
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





        /// <summary>
        /// Bind list of managers who assigned the tasks
        /// </summary>


        /// <summary>
        /// Fill tasks drop down for searching
        /// </summary>



        /// <summary>
        /// Fill Employee to select for those who have admin Right
        /// </summary>
        protected void fillemployee()
        {
            objuser.action = "select";
            objuser.companyid = Session["companyid"].ToString();
            objuser.id = "";
            ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0)
            {
                objgen.fillActiveInactiveCheck(ds.Tables[0], dropemployee, "username", "nid");

            }

        }
        protected void fillmanager()
        {
            dropassign.Items.Clear();

            objuser.action = "select";
            objuser.companyid = Session["companyid"].ToString();
            objuser.id = "";
            ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0)
            {
                objgen.fillActiveInactiveCheck(ds.Tables[0], dropemployee, "username", "nid");

            }

            ListItem li = new ListItem("--All Manager--", "");
            dropassign.Items.Insert(0, li);

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
                objts.empid = getchkval(dropemployee);
                objts.clientid = getchkval(dropclient);
                objts.taskid = "";
                objts.Status = "";
                objts.CreatedBy = dropassign.Text;
                objts.managerId = dropassign.Text;
                objts.from = txtfromdate.Text;
                objts.to = txttodate.Text;
                objts.projectid = getchkval(dropproject);
                objts.isbillable = dropbillable.SelectedValue.ToString();
                objts.isbilled = dropbilled.SelectedValue.ToString();
                objts.taskStatus = dropTaskStatus.SelectedValue.ToString();
                objts.type = "";
                objts.id = "";
                objts.taskType = "Expense";
                objts.action = "getallexp";

                ReportViewer1.LocalReport.ReportPath = p + "\\client\\rpt_ExpensesByClient.rdlc";
                ReportParameter[] param = new ReportParameter[5];



                param[0] = new ReportParameter("companyname", Session["companyname"].ToString(), true);
                param[1] = new ReportParameter("companyaddress", Session["companyaddress"].ToString(), true);
                ds = objts.timesheetrdlcreport();

                if (ds.Tables[0].Rows.Count > 0)
                {
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
                    param[3] = new ReportParameter("reportfilter", "Report From: " + txtfromdate.Text + " To: " + txttodate.Text, true);
                    param[4] = new ReportParameter("currency", ds.Tables[1].Rows[0]["symbol"].ToString(), true);

                    ReportDataSource rds1 = new ReportDataSource("DataSet1", ds.Tables[0]);


                    this.ReportViewer1.LocalReport.DataSources.Clear();

                    this.ReportViewer1.LocalReport.EnableExternalImages = true;

                    this.ReportViewer1.LocalReport.DataSources.Add(rds1);
                    this.ReportViewer1.LocalReport.SetParameters(param);


                    this.ReportViewer1.LocalReport.Refresh();



                    ReportViewer1.LocalReport.DisplayName = "Expenses by Client";
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
            upadatepanel.Update();

        }
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            fillgrid();
        }
    }
}