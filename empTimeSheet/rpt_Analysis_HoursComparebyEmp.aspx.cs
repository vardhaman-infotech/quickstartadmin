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
    public partial class rpt_Analysis_HoursComparebyEmp : System.Web.UI.Page
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

                if (!objda.checkUserInroles("98"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
                fillemployee();
                fillclient();
                fillproject();
              

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
                string strccontact = "",strreportfileter;
                objts.empid = getchkval(dropemployee);
                objts.clientid = getchkval(dropclient);
                objts.taskid = "";
                objts.Status = "";
                objts.CreatedBy ="";
                objts.managerId = "";
                if (dropdaterange.Text == "Custom")
                {
                    objts.from = txtfromdate.Text;
                    objts.to = txttodate.Text;
                    strreportfileter="From "+txtfromdate.Text+" To "+txttodate.Text;
                }
                else
                {
                    var result = DateRange.getLastDates(dropdaterange.Text,txtfromdate.Text,txttodate.Text);
                    objts.from = result.fromdate;
                    objts.to = result.todate;
                    strreportfileter=result.datetext;

                }
                objts.projectid = getchkval(dropproject);
                objts.isbillable = dropbillable.SelectedValue.ToString();
                objts.isbilled = "";
                objts.taskStatus = dropTaskStatus.SelectedValue.ToString();
                objts.type = "";
                objts.id = "";
                objts.taskType = "Task";
                objts.action = "AnalysisProjectTaskEmp";
                ds = objts.timesheetrdlcreport();

                ds.Tables[0].Columns.Add(new DataColumn("pbujhrs"));
                ds.Tables[0].Columns.Add(new DataColumn("pbujamt"));

                ds.Tables[0].Columns.Add(new DataColumn("ebujhrs"));
                ds.Tables[0].Columns.Add(new DataColumn("ebujamt"));

                ds.Tables[0].Columns.Add(new DataColumn("Tebujhrs"));
                ds.Tables[0].Columns.Add(new DataColumn("Tebujamt"));



                DataView view = new DataView(ds.Tables[0]);
                DataTable distinctValues = view.ToTable(true, "taskid", "projectid", "tbujhrs", "bamount");

                DataView view1 = new DataView(distinctValues);
                DataTable distinctproject = view1.ToTable(true, "projectid");
                double gthrs = 0, gtamt = 0;
                for (int i = 0; i < distinctproject.Rows.Count; i++)
                {

                    DataRow[] result = distinctValues.Select("projectid='" + distinctproject.Rows[i]["projectid"].ToString() + "'");
                    double total = 0, totalamt = 0;
                    foreach (DataRow row in result)
                    {
                        total = total + Convert.ToDouble(row["tbujhrs"]);
                        totalamt = totalamt + Convert.ToDouble(row["bamount"]);
                    }

                    DataRow[] result1 = ds.Tables[0].Select("projectid='" + distinctproject.Rows[i]["projectid"].ToString() + "'");
                    foreach (DataRow row in result1)
                    {
                        row["pbujhrs"] = total.ToString("0.00");
                        row["pbujamt"] = totalamt.ToString("0.00");
                    }

                    gthrs = gthrs + total;
                    gtamt = gtamt + totalamt;
                }

                DataView viewemp = new DataView(ds.Tables[0]);
                DataTable distinctemp = viewemp.ToTable(true, "taskid", "projectid", "empid", "tbujhrs", "bamount");

                DataView view2 = new DataView(distinctemp);
                DataTable distinctempid = view2.ToTable(true, "empid", "taskid", "tbujhrs", "bamount");

                DataView view3 = new DataView(distinctempid);
                DataTable distincttaskid = view3.ToTable(true, "empid", "taskid");


                for (int i = 0; i < distincttaskid.Rows.Count; i++)
                {
                    DataRow[] result = distinctemp.Select("empid='" + distincttaskid.Rows[i]["empid"].ToString() + "' and taskid='" + distincttaskid.Rows[i]["taskid"].ToString() + "'");
                    double total = 0, totalamt = 0;
                    foreach (DataRow row in result)
                    {
                        total = total + Convert.ToDouble(row["tbujhrs"]);
                        totalamt = totalamt + Convert.ToDouble(row["bamount"]);
                    }

                    DataRow[] result1 = ds.Tables[0].Select("empid='" + distincttaskid.Rows[i]["empid"].ToString() + "' and taskid='" + distincttaskid.Rows[i]["taskid"].ToString() + "'");
                    foreach (DataRow row in result1)
                    {
                        row["ebujhrs"] = total.ToString("0.00");
                        row["ebujamt"] = totalamt.ToString("0.00");
                    }
                }


                DataTable distAllEmp = viewemp.ToTable(true, "empid");
                DataTable distAllEmp1 = viewemp.ToTable(true, "empid", "taskid", "ebujhrs", "ebujamt");
                for (int i = 0; i < distAllEmp.Rows.Count; i++)
                {
                    DataRow[] result = distAllEmp1.Select("empid='" + distAllEmp.Rows[i]["empid"].ToString() + "'");
                    double total = 0, totalamt = 0;
                    foreach (DataRow row in result)
                    {
                        total = total + Convert.ToDouble(row["ebujhrs"]);
                        totalamt = totalamt + Convert.ToDouble(row["ebujamt"]);
                    }

                    DataRow[] result1 = ds.Tables[0].Select("empid='" + distAllEmp.Rows[i]["empid"].ToString() + "'");
                    foreach (DataRow row in result1)
                    {
                        row["tebujhrs"] = total.ToString("0.00");
                        row["tebujamt"] = totalamt.ToString("0.00");
                    }
                }

                ReportViewer1.LocalReport.ReportPath = p + "\\analysis\\actualBudgetHoursByEmp.rdlc";
                ReportParameter[] param = new ReportParameter[6];



                param[0] = new ReportParameter("companyname", Session["companyname"].ToString(), true);
                param[1] = new ReportParameter("companyaddress", Session["companyaddress"].ToString(), true);
               

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
                    param[3] = new ReportParameter("reportfilter", strreportfileter, true);
                    param[4] = new ReportParameter("gthours", gthrs.ToString("0.00"), true);
                    param[5] = new ReportParameter("gtamt", gtamt.ToString("0.00"), true);

                    ReportDataSource rds1 = new ReportDataSource("DataSet1", ds.Tables[0]);


                    this.ReportViewer1.LocalReport.DataSources.Clear();

                    this.ReportViewer1.LocalReport.EnableExternalImages = true;

                    this.ReportViewer1.LocalReport.DataSources.Add(rds1);
                    this.ReportViewer1.LocalReport.SetParameters(param);


                    this.ReportViewer1.LocalReport.Refresh();



                    ReportViewer1.LocalReport.DisplayName = "A-Hours B-Hours Comparison by Employee";
                    divreport.Visible = true;
                    divnodata.Visible = false;
                }
                else
                {
                    divreport.Visible = false;
                    divnodata.Visible = true;
                }
                upadatepanel.Update();
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