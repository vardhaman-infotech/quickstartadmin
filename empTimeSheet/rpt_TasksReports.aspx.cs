using Microsoft.Reporting.WebForms;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace empTimeSheet
{
    public partial class rpt_TasksReports : System.Web.UI.Page
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

                System.Data.DataSet ds = new System.Data.DataSet();
                objda.id = Session["userid"].ToString();
                ds = objda.getUserInRoles();

                if (!objda.checkUserInroles("79"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
                if (Request.QueryString["RName"] != null)
                {
                    if (Request.QueryString["RName"].ToString().ToLower() == "empbytask")
                    {
                        lblReportName.Text = "Analysis by Project, Employee & Task";

                    }
                    else if (Request.QueryString["RName"].ToString().ToLower() == "taskbyemp")
                    {
                        lblReportName.Text = "Analysis by Project, Task & Employee";

                    }
                    else if (Request.QueryString["RName"].ToString().ToLower() == "emp")
                    {

                        lblReportName.Text = "Analysis by Employee & Task";
                    }

                }
                fillemployee();
                fillclient();
                fillproject();


                //  fillgrid();
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

                string StrReportPath = "", strReportName = "", strreportfileter;
                string p = Server.MapPath("rdlcreport");
                string strccontact = "";
                NameValueCollection n = Request.QueryString;
                Session["TaskTable"] = null;
                // objts.empid = dropemployee.Text;



                objts.empid = getchkval(dropemployee);
                objts.clientid = getchkval(dropclient);
                objts.taskid = "";
                objts.Status = "";


                if (dropdaterange.Text == "Custom")
                {
                    objts.from = txtfromdate.Text;
                    objts.to = txttodate.Text;
                    strreportfileter = "From " + txtfromdate.Text + " To " + txttodate.Text;
                }
                else
                {
                    var result = DateRange.getLastDates(dropdaterange.Text, txtfromdate.Text, txttodate.Text);
                    objts.from = result.fromdate;
                    objts.to = result.todate;
                    strreportfileter = result.datetext;

                }

                objts.projectid = getchkval(dropproject);
                objts.isbillable = dropbillable.SelectedValue.ToString();
                objts.isbilled = dropbilled.SelectedValue.ToString();
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
                DataTable distinctValues = view.ToTable(true, "taskid", "projectid","tbujhrs","bamount");

                DataView view1 = new DataView(distinctValues);
                DataTable distinctproject = view1.ToTable(true, "projectid");

                for (int i = 0; i < distinctproject.Rows.Count; i++)
                {

                    DataRow[] result = distinctValues.Select("projectid='" + distinctproject.Rows[i]["projectid"].ToString()+"'");
                    double total = 0,totalamt=0;
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

                    if (n.HasKeys())
                    {
                        string k = n.GetKey(0);
                        string v = n.Get(0);
                        if (k == "RName")
                        {
                            switch (v.ToLower())
                            {
                                case "empbytask":

                                    StrReportPath = "\\Task\\activityAnalysisbyproject.rdlc";
                                    strReportName = "Activity Analysis by Project, Employee & Task";
                                    lblReportName.Text = "Activity Analysis by Project, Employee & Task";
                                    break;
                                case "taskbyemp":
                                    StrReportPath = "\\Task\\aasummaryprordlc.rdlc";
                                    strReportName = "Activity Analysis by Project, Task and Employee";
                                    lblReportName.Text = "Activity Analysis by Project, Task and Employee";
                                    break;
                                case "emp":
                                    StrReportPath = "\\Task\\activityAnalysisbyEmpandTask.rdlc";
                                    strReportName = "Activity Analysis by Employee & Task";
                                    lblReportName.Text = "TActivity Analysis by Employee & Task";
                                    break;
                            }

                        }
                    }

              
                if (ds.Tables[0].Rows.Count > 0)
                {
                    divreport.Visible = true;
                    ReportViewer1.Visible = true;
                    Session["TaskTable"] = ds.Tables[0];

                    ReportViewer1.LocalReport.ReportPath = p + StrReportPath;
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
                    param[3] = new ReportParameter("reportfilter", strreportfileter, true);
                  
                    ReportDataSource rds1 = new ReportDataSource("DataSet1", ds.Tables[0]);


                    this.ReportViewer1.LocalReport.DataSources.Clear();

                    this.ReportViewer1.LocalReport.EnableExternalImages = true;

                    this.ReportViewer1.LocalReport.DataSources.Add(rds1);
                    this.ReportViewer1.LocalReport.SetParameters(param);


                    this.ReportViewer1.LocalReport.Refresh();



                    ReportViewer1.LocalReport.DisplayName = strReportName;


                    divnodata.Visible = false;
                }
                else
                {
                    divnodata.Visible = true;
                    divreport.Visible = false;
                    ReportViewer1.Visible = false;
                    Session["TaskTable"] = null;
                }
                dsexcel = ds;




                //   ReportViewer1.ProcessingMode = ProcessingMode.Local;
                //LocalReport rep = ReportViewer1.LocalReport;

                //reportViewer1.LocalReport.ReportEmbeddedResource = System.IO.Directory.GetCurrentDirectory() + @"\Reports\Rdlc\PaidBill_Check.rdlc";

                // ReportViewer1.LocalReport.ReportPath = p + "\\aging\\agingrdlc.rdlc";

            }
            catch (Exception ex)
            {
            }




        }


        protected void btnsearch_Click(object sender, EventArgs e)
        {
            fillgrid();

        }
        protected void btnrefresh_Click(object sender, EventArgs e)
        {
            fillgrid();
        }

        #region Export
        protected string bindheader()
        {
            string str = "";
            string Companyname = Session["companyname"].ToString();
            string companyaddress = Session["companyaddress"].ToString();
            string date = "<b>Date:</b> ";

            if (txtfromdate.Text != txttodate.Text)
            {
                date += txtfromdate.Text + " - " + txttodate.Text;
            }
            else
            {
                date += txtfromdate.Text;
            }
            string headerstr = "";


            str = headerstr +
        @"<tr>
            <td colspan='7' align='left'>
                <h2 style='color:blue;'>
                   " + Companyname + @"
                </h2>
            </td>
        </tr>
<tr>
            <td  colspan='7'  align='left'>
               
                   " + companyaddress + @"
               
            </td>
        </tr>
        <tr>
            <td colspan='7'  align='left'>
                <h4>
                   Employee Timesheet Report From " + date + @"
                </h4>
            </td>
        </tr>
      
       
        <tr>
        <td colspan='7'>&nbsp;
        </td>

        </tr>";

            return str;


        }
        protected void btnexportcsv_Click(object sender, EventArgs e)
        {
            DataTable dt = new DataTable();
            StringBuilder sb = new StringBuilder();
            sb.Append(@"<table>" + bindheader() + @"<tr ><th style='background-color:blue;color:#ffffff;'>Day</th><th style='background-color:blue;color:#ffffff;'>Date</th><th style='background-color:blue;color:#ffffff;'>Project Id</th><th style='background-color:blue;color:#ffffff;'>Project Name</th>
                <th style='background-color:blue;color:#ffffff;'>Task ID</th><th style='background-color:blue;color:#ffffff;'>Description</th><th style='background-color:blue;color:#ffffff;'>Hrs.</th>");

            if (Session["tasktable"] != null)
            {
                dt = ((DataTable)Session["tasktable"]).Copy();


                DataView view = new DataView(dt);
                view.Sort = "empname ASC";


                DataTable sortedDT = view.ToTable();
                DataView view1 = new DataView(sortedDT);

                DataTable distinctValues = view1.ToTable(true, "empid");
                double totalhrs = 0, totalbill = 0, totalub = 0;
                for (int i = 0; i < distinctValues.Rows.Count; i++)
                {
                    double hrs = 0;
                    DataTable dtfinal = new DataTable();
                    dtfinal = filerbyemp("empid='" + distinctValues.Rows[i][0].ToString() + "'", dt);
                    dtfinal.DefaultView.Sort = "date1 ASC";


                    DataTable dtfinal1 = new DataTable();

                    dtfinal1 = filerbyemp("isbillable=1", dtfinal);
                    int count = dtfinal1.Rows.Count;
                    int j = 0;
                    if (dtfinal1.Rows.Count > 0)
                    {
                        for (j = 0; j < count; j++)
                        {
                            sb.Append(@"<tr><td>" + Convert.ToDateTime(dtfinal1.Rows[j]["date1"].ToString()).ToString("ddd") + "</td>");
                            sb.Append(@"<td>" + dtfinal1.Rows[j]["date"].ToString() + "</td>");
                            sb.Append(@"<td>" + dtfinal1.Rows[j]["projectcode"].ToString() + "</td>");
                            sb.Append(@"<td>" + dtfinal1.Rows[j]["projectname"].ToString() + "</td>");
                            sb.Append(@"<td>" + dtfinal1.Rows[j]["taskcodename"].ToString() + "</td>");
                            sb.Append(@"<td>" + dtfinal1.Rows[j]["description"].ToString() + "</td>");
                            sb.Append(@"<td>" + dtfinal1.Rows[j]["hours"].ToString() + "</td>");
                            hrs += Convert.ToDouble(dtfinal1.Rows[j]["hours"]);
                            if (Convert.ToBoolean(dtfinal1.Rows[j]["isbillable"]))
                            {

                                sb.Append(@"<td></td></tr>");
                            }
                            else
                            {
                                sb.Append(@"<td style='color:red;'>NB</td></tr>");

                            }


                            if (j == count - 1)
                            {
                                sb.Append(@"<tr><td></td>");
                                sb.Append(@"<td></td>");
                                sb.Append(@"<td></td>");
                                sb.Append(@"<td></td>");
                                sb.Append(@"<td></td>");
                                sb.Append(@"<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;font-weight:bold;'>" + dtfinal1.Rows[j]["empname"].ToString() + "(" + dtfinal1.Rows[j]["loginid"].ToString() + ")" + "</td>");
                                sb.Append(@"<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;font-weight:bold;'>" + hrs.ToString("0.00") + "</td><td></td></tr>");
                                totalhrs += hrs;
                                totalbill += hrs;
                                sb.Append(@"<tr><td></td>");
                                sb.Append(@"<td></td>");
                                sb.Append(@"<td></td>");
                                sb.Append(@"<td></td>");
                                sb.Append(@"<td></td>");
                                sb.Append(@"<td></td>");
                                sb.Append(@"<td></td>");
                                sb.Append(@"<td></td></tr>");
                            }

                        }


                    }

                    j = 0;
                    double hrs1 = 0;

                    DataTable dtfinal2 = new DataTable();

                    dtfinal2 = filerbyemp("isbillable=0", dtfinal);
                    count = dtfinal2.Rows.Count;
                    if (dtfinal2.Rows.Count > 0)
                    {
                        for (j = 0; j < count; j++)
                        {
                            sb.Append(@"<tr><td>" + Convert.ToDateTime(dtfinal2.Rows[j]["date1"].ToString()).ToString("ddd") + "</td>");
                            sb.Append(@"<td>" + dtfinal2.Rows[j]["date"].ToString() + "</td>");
                            sb.Append(@"<td>" + dtfinal2.Rows[j]["projectcode"].ToString() + "</td>");
                            sb.Append(@"<td>" + dtfinal2.Rows[j]["projectname"].ToString() + "</td>");
                            sb.Append(@"<td>" + dtfinal2.Rows[j]["taskcodename"].ToString() + "</td>");
                            sb.Append(@"<td>" + dtfinal2.Rows[j]["description"].ToString() + "</td>");
                            sb.Append(@"<td>" + dtfinal2.Rows[j]["hours"].ToString() + "</td>");
                            hrs1 += Convert.ToDouble(dtfinal2.Rows[j]["hours"]);

                            if (Convert.ToBoolean(dtfinal2.Rows[j]["isbillable"]))
                            {

                                sb.Append(@"<td></td></tr>");
                            }
                            else
                            {
                                sb.Append(@"<td style='color:red;'>NB</td></tr>");

                            }


                            if (j == count - 1)
                            {
                                sb.Append(@"<tr><td></td>");
                                sb.Append(@"<td></td>");
                                sb.Append(@"<td></td>");
                                sb.Append(@"<td></td>");
                                sb.Append(@"<td></td>");
                                sb.Append(@"<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;font-weight:bold;'>" + dtfinal.Rows[0]["empname"].ToString() + "(" + dtfinal2.Rows[j]["loginid"].ToString() + ")" + "</td>");
                                sb.Append(@"<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;font-weight:bold;'>" + hrs1.ToString("0.00") + "</td><td style='color:red;'>NB</td></tr>");
                                totalhrs += hrs1;
                                totalub += hrs1;
                                sb.Append(@"<tr><td></td>");
                                sb.Append(@"<td></td>");
                                sb.Append(@"<td></td>");
                                sb.Append(@"<td></td>");
                                sb.Append(@"<td></td>");
                                sb.Append(@"<td></td>");
                                sb.Append(@"<td></td>");
                                sb.Append(@"<td></td></tr>");
                            }

                        }


                    }

                    sb.Append(@"<tr><td></td>");
                    sb.Append(@"<td></td>");
                    sb.Append(@"<td></td>");
                    sb.Append(@"<td></td>");
                    sb.Append(@"<td style='font-weight:bold;'>Employee Total</td>");
                    sb.Append(@"<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;font-weight:bold;'>" + dtfinal.Rows[0]["empname"].ToString() + "(" + dtfinal.Rows[0]["loginid"].ToString() + ")" + "</td>");
                    sb.Append(@"<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;font-weight:bold;'>" + (hrs + hrs1).ToString("0.00") + "</td><td></td></tr>");

                    sb.Append(@"<tr><td></td>");
                    sb.Append(@"<td></td>");
                    sb.Append(@"<td></td>");
                    sb.Append(@"<td></td>");
                    sb.Append(@"<td></td>");
                    sb.Append(@"<td></td>");
                    sb.Append(@"<td></td>");
                    sb.Append(@"<td></td></tr>");


                }


                sb.Append(@"<tr><td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;font-weight:bold;'>Total</td>");


                sb.Append(@"<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;font-weight:bold;'>" + totalbill.ToString("0.00") + "</td><td style='font-weight:bold;'>B</td></tr>");

                sb.Append(@"<tr><td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td></tr>");

                // UB

                sb.Append(@"<tr><td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;font-weight:bold;'>Total</td>");


                sb.Append(@"<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;font-weight:bold;'>" + totalub.ToString("0.00") + "</td><td style='font-weight:bold;'>UB</td></tr>");


                sb.Append(@"<tr><td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td></tr>");

                // GT
                sb.Append(@"<tr style='color:blue;'><td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;font-weight:bold;'>Grand Total</td>");


                sb.Append(@"<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;font-weight:bold;'>" + totalhrs.ToString("0.00") + "</td><td></td></tr>");


            }
            sb.Append("</table>");
            objexcel.downloadFile(sb.ToString(), "TimeSheetReport.xls");

        }
        private DataTable filerbyemp(string id, DataTable dt)
        {
            DataView dv = new DataView(dt);
            dv.RowFilter = id;
            return dv.ToTable();

        }
        #endregion



    }
}