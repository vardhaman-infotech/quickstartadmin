using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.UI.HtmlControls;
using System.IO;
using System.Text;

namespace empTimeSheet
{
    public partial class rpt_timeSummary : System.Web.UI.Page
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

                if (!objda.validatedRoles("44", ds))
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
            objts.action = "timesummary";
            objts.CreatedBy = "";
            ds = objts.timesheetreport();

            DataTable dt = new DataTable();
            StringBuilder sb = new StringBuilder();
            StringBuilder sb1 = new StringBuilder();


            sb.Append(@"<table align='center'  class='table maintable' width='100%' border='0' cellspacing='0' cellpadding='4' >");

            if (ds.Tables[0].Rows.Count > 0)
            {
                divnodata.Visible = false;
                divreport.Visible = true;
                double stotalhrs = 0, stotalamount = 0;

                DataView view = new DataView(ds.Tables[0]);
                view.Sort = "projectcode ASC";
                DataTable sortedDT = view.ToTable();





                DataView viewproject = new DataView(sortedDT);
              
                DataTable distinctproject = viewproject.ToTable(true, "projectid");


             


                //Project Loop
                for (int j = 0; j < distinctproject.Rows.Count; j++)
                {

                    DataTable dtprojectname = new DataTable();
                    dtprojectname = filerbyemp("projectid='" + distinctproject.Rows[j][0].ToString() + "'", sortedDT);
                    sb.Append(@"<tr><td colspan='5'>&nbsp;</td></tr><tr><th  colspan='5' style='font-size:14px;font-weight:bold;color:#585858;'>Project ID: Name (Manager) <span style='color:#EB8806;'>" + dtprojectname.Rows[0]["projectcode"].ToString() + "</span>- <span style='color:#b867bf;font-style:italic;'>" + dtprojectname.Rows[0]["projectname"].ToString() + "</span>&nbsp;<span style='color:#0da08b;'>" + dtprojectname.Rows[0]["managername"].ToString() + "</span></th></tr>");
                    sb.Append(@"<tr bgcolor='#e0e0e0' style='font-weight:bold;color:#585858;background:#e0e0e0;' ><td style='border-top:solid 1px #585858;border-bottom:solid 1px #585858;' width='12%'>Employee Name</td><td width='20%' style='border-top:solid 1px #585858;border-bottom:solid 1px #585858;'>Task ID</td><td width='48%' style='border-top:solid 1px #585858;border-bottom:solid 1px #585858;'>Description</td><td width='10%' style='border-top:solid 1px #585858;border-bottom:solid 1px #585858;text-align:right;'>Hours</td><td width='10%' style='border-top:solid 1px #585858;border-bottom:solid 1px #585858;text-align:right;'>Amount</td></tr>");



                    DataView viewemp = new DataView(filerbyemp("projectid='" + distinctproject.Rows[j][0].ToString() + "'", sortedDT));
                    viewemp.Sort = "loginid ASC";

                    DataTable distemp = viewemp.ToTable(true, "empid");

                    double projecthrs = 0, projectamt = 0;
                   

                    if (distemp.Rows.Count > 0)
                    {
                     
                        //Employee Loop
                        for (int k = 0; k < distemp.Rows.Count; k++)
                        {
                            DataTable dtempname = new DataTable();
                            dtempname = filerbyemp("empid='" + distemp.Rows[k][0].ToString() + "'", dtprojectname);

                            sb.Append(@"<tr><th colspan='5' style='color:#585858;border-bottom:solid 1px #bebebe;'><span style='color:#BB0E50;'>" + dtempname.Rows[0]["loginid"].ToString() + "</span>-" + dtempname.Rows[0]["empname"].ToString() + "</th></tr>");

                            DataTable dttask = new DataTable();
                            dttask = filerbyemp("empid='" + distemp.Rows[k][0].ToString() + "'", dtempname);

                            DataView viewtask = new DataView(dttask);
                            viewtask.Sort = "taskcodename ASC";
                            DataTable dtfinaltask = viewtask.ToTable();

                            double hrs = 0, amt = 0;
                            string billstr = "";
                            double emphrs = 0, empamt = 0;
                            for (int l = 0; l < dtfinaltask.Rows.Count; l++)
                            {
                                hrs = Convert.ToDouble(dtfinaltask.Rows[l]["hours"]);
                                amt = Convert.ToDouble(dtfinaltask.Rows[l]["payrate"]);
                               

                                emphrs += hrs;
                              
                                empamt += amt;

                                sb.Append(@"<tr><td></td><td>" + dtfinaltask.Rows[l]["taskcodename"].ToString() + "</td><td>" + dtfinaltask.Rows[l]["task"].ToString() + "</td><td style='text-align:right;'>" + hrs.ToString("0.00") + "</td><td style='text-align:right;'>" + amt.ToString("0.00") + "</td></tr>");


                            }
                            projecthrs += emphrs;
                           
                            projectamt += empamt;
                            sb.Append(@"<tr><td colspan='3' style='text-align:right;font-weight:bold;'><span style='color:#BB0E50;'>" + dtempname.Rows[0]["loginid"].ToString() + "</span> Total:</td><td style='border-top:solid 1px #585858;border-bottom:solid 1px #585858;text-align:right;'>" + emphrs.ToString("0.00") + "</td><td style='border-top:solid 1px #585858;border-bottom:solid 1px #585858;text-align:right;'>" + empamt.ToString("0.00") + "</td></tr>");



                        }
                    }
                  



                    //Total of service
                   
                   

                  
                    // Total of all employees in a project

                    sb.Append(@"<tr><td colspan='5'>&nbsp;</td></tr><tr><td colspan='3' style='text-align:right;font-weight:bold;'><span style='color:#309774;'>Project " + dtprojectname.Rows[0]["projectcode"].ToString() + "</span> Total:</td><td style='border-top:solid 1px #585858;border-bottom:solid 1px #585858;text-align:right;'>" + projecthrs.ToString("0.00") + "</td><td style='border-top:solid 1px #585858;border-bottom:solid 1px #585858;text-align:right;'>" + projectamt.ToString("0.00") + "</td></tr>");


                    stotalhrs += projecthrs;
                   
                    stotalamount += projectamt;

                }
               


                sb.Append(@"<tr><td colspan='5'>&nbsp;</td></tr><tr><td colspan='3' style='text-align:right;font-weight:bold;'>Grand <span style='color:#585858;'>TOTAL:</span></td><td style='border-top:solid 1px #585858;border-bottom:solid 1px #585858;text-align:right;'>" + stotalhrs.ToString("0.00") + "</td><td style='border-top:solid 1px #585858;border-bottom:solid 1px #585858;text-align:right;'>" + stotalamount.ToString("0.00") + "</td></tr>");




            }
            else
            {
                divnodata.Visible = false;
                divreport.Visible = true;
            }
            sb.Append("</table>");
            divreport.InnerHtml = sb.ToString();
            updatePanelData.Update();
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

        #region Export
        protected void bindheader()
        {
            string str = "";
            string Companyname = Session["companyname"].ToString();
            string companyaddress = Session["companyaddress"].ToString();

            string headerstr = "<table width='100%'><tr><td></td><td></td><td></td><td></td><td></td></tr>";


            str = headerstr +
        @"
            
            <tr><td colspan='2'></td><td  colspan='3' style='border:solid 2px #1caf9a;text-align:right;'>
                <h3>
                    
Time Summary by Project, Employee & Task
                </h3></td></tr><tr><td height='10'>&nbsp;</td></tr>
            

<tr><td  colspan='3' style='width:70%;'>
                <h2>
                   " + Companyname + @"
                </h2>
        </td><td colspan='2' align='right' style='font-size:11px;'>Printed on: " + GeneralMethod.getLocalDateTime() + @"</td></tr>
<tr><td colspan='5'>
                <h5>
                   " + companyaddress + @"
                </h5>
         </td></tr>
   <tr><td  colspan='5' height='10'>&nbsp;</td></tr><tr><td  colspan='5' height='10'>Time Entry Date: "+txtfromdate.Text+" to "+txttodate.Text+"</td></tr></table>";


            Session["header"] = str;
            Session["css"] = "timeexp";
        }
        protected void lblexportpdf_Click(object sender, EventArgs e)
        {
            bindheader();
            Session["ctrl"] = divreport;
            string url = "pdf.aspx";
            string s = "window.open('" + url + "', '_blank');";

            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>" + s + "</script>", false);


        }
        protected void btnexportcsv_Click(object sender, EventArgs e)
        {
            DataTable dt = new DataTable();
            StringBuilder sb = new StringBuilder();
            bindheader();

            sb.Append(Session["header"].ToString() + divreport.InnerHtml);

            objexcel.downloadFile(sb.ToString(), "TimeSummaryReport.xls");

        }
        private DataTable filerbyemp(string id, DataTable dt)
        {
            DataView dv = new DataView(dt);
            dv.RowFilter = id;
            return dv.ToTable();

        }
        #endregion


        #region SORTING
        /// <summary>
        /// List sorting on a specified SortExpression in Design view
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>

        public override void VerifyRenderingInServerForm(Control control)
        {

            /* Verifies that the control is rendered */

        }
        #endregion
    }
}