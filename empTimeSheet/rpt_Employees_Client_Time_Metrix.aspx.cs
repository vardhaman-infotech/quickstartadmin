using Dinkum.Reports.budgetReport;
using Microsoft.Reporting.WebForms;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace empTimeSheet
{
    public partial class rpt_Employees_Client_Time_Metrix : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();
        DataSet dsexcel = new DataSet();
        DataSet dsNew = new DataSet();
        string reportName = "Employee-Client-Time Matrix Report";
        excelexport objexcel = new excelexport();
        List<string> colNames = new List<string>();
        Dictionary<string, string> clientNames = new Dictionary<string, string>();
        private MemoryStream m_rdl; // use to save the DB data in stream
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                txtfromdate.Text = System.DateTime.Now.AddDays(-2).ToString("MM/dd/yyyy");
                txttodate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");

                if (!objda.checkUserInroles("62"))
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
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            fillgrid();
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
                objts.taskType = "Task";
                objts.action = "clientmetrix";

                ds = objts.timesheetrdlcreport();
                DataView view = new DataView(ds.Tables[0]);
                view.Sort = "loginid ASC";
                DataTable sortedDT = view.ToTable();
                DataView view1 = new DataView(sortedDT);
                DataTable distinctLoginId = view1.ToTable(true, "loginid");

                DataView viewClientCode = new DataView(ds.Tables[0]);
                viewClientCode.Sort = "clientcode ASC";
                DataTable sortedCCodeDT = viewClientCode.ToTable();
                DataView viewClientCode1 = new DataView(sortedCCodeDT);
                DataTable distinctClientCode = viewClientCode1.ToTable(true, "clientcode");




                int numberOfCols = distinctLoginId.Rows.Count;

                DataTable dtNew = new DataTable();

                DataColumn Employee;
                int i = 0;
                Employee = new DataColumn("Employee", Type.GetType("System.String"));

                dtNew.Columns.Add(Employee);
                colNames.Add("Employee");
                int counter = 0;
                foreach (DataRow drowLogId in distinctClientCode.Rows)
                {

                 //   string[] split = drowLogId[0].ToString().Split(new Char[] { ' ', ',', '.', ':', '\t' });
                    string safeName = (string.Concat("", Regex.Replace(drowLogId[0].ToString(), "[)(-:0-9_]+", ""))).ToUpper();
                    DataColumn newCoulumn = new DataColumn(safeName, Type.GetType("System.String"));
                    dtNew.Columns.Add(newCoulumn);
                    colNames.Add(safeName.Replace(" ","").Replace("&",""));
                    counter++;
                }

                dsNew.Tables.Add(dtNew);


               
                int j = 0;
                try
                {
                    for (int ii = 0; ii < distinctLoginId.Rows.Count; ii++)
                    {
                        DataRow ro = dtNew.NewRow();

                        for (int jj = 0; jj < dsNew.Tables[0].Columns.Count; jj++)
                        {
                            if (jj == 0)
                            {
                                ro[0] = distinctLoginId.Rows[ii]["loginid"].ToString();// +" (" + dtr.Rows[0]["clientname"].ToString() + ")";
                                DataTable dtr = new DataTable();
                                dtr = f_FilterData(ds.Tables[0], "loginid='" + distinctLoginId.Rows[ii]["loginid"].ToString() + "'");
                                if (dtr.Rows.Count > 0)
                                {
                                    ro[0] = distinctLoginId.Rows[ii]["loginid"].ToString() +" -" + dtr.Rows[0]["empname"].ToString();
                                }
                            }
                            else
                            {
                                
                                DataTable dtr = new DataTable();
                                dtr = f_FilterData(ds.Tables[0], "clientcode='" + distinctClientCode.Rows[jj-1]["clientcode"].ToString() + "' AND loginid='" + distinctLoginId.Rows[ii]["loginid"].ToString() + "'");
                                if (dtr.Rows.Count > 0)
                                {
                                    if (dropbillable.SelectedValue.ToString() == "")
                                    {
                                        ro[jj] = dtr.Rows[0]["hours"].ToString();
                                    }
                                    else if (dropbillable.SelectedValue.ToString() == "1")
                                    {
                                        ro[jj] = dtr.Rows[0]["bilhrs"].ToString();
                                    }
                                    else if (dropbillable.SelectedValue.ToString() == "0")
                                    {
                                        ro[jj] = dtr.Rows[0]["ubbilhrs"].ToString();
                                    }
                                }
                                else
                                {
                                    ro[jj] = "0.00";
                                }
                                
                            }
                        }
                        dtNew.Rows.Add(ro);
                    }
                    dtNew.AcceptChanges();
                }
                catch (Exception ex) { Console.Write(ex); }


                if (numberOfCols > 0)
                {
                    if (m_rdl != null)
                        m_rdl.Dispose();
                    m_rdl = GenerateRdl(colNames); //Now that we have columns so generate rdl and return it in a stream.
                    DumpRdl(m_rdl);
                    ShowReport();
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
        #region Show the report generated
        private void ShowReport()
        {
            this.ReportViewer2.LocalReport.DataSources.Clear();
            ReportDataSource rds = new ReportDataSource("MyData", dsNew.Tables[0]);

            this.ReportViewer2.LocalReport.DataSources.Add(rds);
            this.ReportViewer2.LocalReport.EnableExternalImages = true;
            //   this.ReportViewer1.LocalReport.Refresh()();
            this.ReportViewer2.LocalReport.LoadReportDefinition(m_rdl);
            this.ReportViewer2.LocalReport.Refresh();
            this.ReportViewer2.LocalReport.DisplayName = "EmployeeClientReport";
        }
        #endregion
        #region GenerateRdl
        private MemoryStream GenerateRdl(List<string> allColumns)
        {
            MemoryStream ms = new MemoryStream();
            RdlGenerator gen = new RdlGenerator();
            RdlGenerator.allColumns = allColumns; //Intialize the RdlGenerator class with list of columns.
            ms = RdlGenerator.WriteStream(ms, "", txtfromdate.Text, txttodate.Text, dropbillable.SelectedItem.ToString(), reportName);// get the rdlc report proprties(entire structure) in a stream. 
            ms.Position = 0; // set the stream position to zero (in case if there is continous flow of stream for continous display).
            return ms;
        }
        #endregion
        #region Destroy Rdl
        private void DumpRdl(MemoryStream rdl)
        {
#if DEBUG_RDLC
            using (FileStream fs = new FileStream(@"c:\test.rdlc", FileMode.Create))
            {
                rdl.WriteTo(fs);
            }
#endif
        }
        #endregion
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
        public DataTable f_FilterData(DataTable dt, string module)
        {
            DataView dv = new DataView(dt);
            dv.RowFilter = module;
            return dv.ToTable();
        }
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


            //This action selects the employee according to Roles id "7", if you chnage the roles please change in Stored Procedure too.
            objuser.action = "selectassignmanager";
            objuser.companyid = Session["companyid"].ToString();
            objuser.id = "";
            ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0)
            {
                //dropassign.DataSource = ds;
                //dropassign.DataTextField = "username";
                //dropassign.DataValueField = "nid";
                //dropassign.DataBind();

                objgen.fillActiveInactiveDDL(ds.Tables[0], dropassign, "username", "nid");

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
    }
}