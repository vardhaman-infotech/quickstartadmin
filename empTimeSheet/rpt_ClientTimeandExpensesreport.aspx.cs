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
    public partial class rpt_ClientTimeandExpensesreport : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();
        static DataSet dsexcel = new DataSet();
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

                if (!objda.validatedRoles("62", ds))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
                ViewState["add"] = "1";
                ViewState["isadmin"] = "1";

                fillemployee();
                fillclient();
                fillproject();


                //   fillgrid();
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
            if (ViewState["add"] == null || ViewState["add"].ToString() == "")
            {
                ListItem li = new ListItem(Session["username"].ToString(), Session["userid"].ToString());
                dropemployee.Items.Insert(0, li);
                dropemployee.SelectedIndex = 0;
                hidsemployeeid.Value = Session["userid"].ToString() + ",";

            }
            else
            {

                objuser.action = "select";
                objuser.companyid = Session["companyid"].ToString();
                objuser.id = "";
                ds = objuser.ManageEmployee();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    objgen.fillActiveInactiveCheck(ds.Tables[0], dropemployee, "username", "nid");

                }

                //ListItem li = new ListItem("--All Employees--", "");
                //dropemployee.Items.Insert(0, li);
                //dropemployee.SelectedIndex = 0;
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
            string url = System.Web.Configuration.WebConfigurationManager.AppSettings["SchedulerURL"].ToString();
            string imgurl = "images/nonbillable.png";
            imgurl = url + "/" + imgurl;

            Session["TaskTable"] = null;
            // objts.empid = dropemployee.Text;
            objts.empid = getchkval(dropemployee);

            objts.Status = "";
            objts.clientid = getchkval(dropclient);
            objts.projectid = getchkval(dropproject);
            objts.taskid = "";
            objts.from = txtfromdate.Text;
            objts.to = txttodate.Text;
            objts.action = "expenses";
            objts.CreatedBy = "";
            ds = objts.timesheetreport();

           

            if (ds.Tables[0].Rows.Count > 0)
            {
                divnodata.Visible = false;
                divreport.Visible = true;
              



            }
            else
            {
                divnodata.Visible = false;
                divreport.Visible = true;
            }
            f_ReportLoad();
           
            updatePanelData.Update();
        }
        private void f_ReportLoad()
        {
            try
            {
                string p = Server.MapPath("rdlcreport");
                string strccontact = "";


                ReportViewer1.LocalReport.ReportPath = p + "\\client\\clienttimeandExprdlc.rdlc";
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



                ReportViewer1.LocalReport.DisplayName = "Client Time and Expenes";
            }
            catch (Exception ex)
            {
            }




        }

        /// <summary>
        /// Paging- Go to previous page
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>

        protected void btnsearch_Click(object sender, EventArgs e)
        {
            fillgrid();

        }
        protected void btnrefresh_Click(object sender, EventArgs e)
        {
            fillgrid();
        }
    }
}