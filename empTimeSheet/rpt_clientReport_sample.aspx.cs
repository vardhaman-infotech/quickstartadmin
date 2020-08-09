using Microsoft.Reporting.WebForms;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace empTimeSheet
{
    public partial class rpt_clientReport_sample : System.Web.UI.Page
    {

        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        excelexport objexcel = new excelexport();
        DataSet ds = new DataSet();



        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();

            if (!IsPostBack)
            {

                if (!objda.checkUserInroles("84") && !objda.checkUserInroles("70"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }

                txtfrmdate.Text = Convert.ToDateTime(GeneralMethod.getLocalDate()).AddDays(-7).ToString("MM/dd/yyyy");
                txttodate.Text = GeneralMethod.getLocalDate();


                if (Request.QueryString["report"] != null)
                {
                    reportname.Text = Request.QueryString["report"].ToString();
                }
                if (Request.QueryString["reportname"] != null)
                {
                    reportname1.Text = Request.QueryString["reportname"].ToString();
                }


                fillemployee();
                fillclient();
                fillproject();
                fillmanager();

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

            if (ViewState["add"] != null && ViewState["add"].ToString() == "1" && ViewState["isadmin"] == null)
            {
                ListItem li2 = new ListItem(Session["username"].ToString(), Session["userid"].ToString());
                dropassign.Items.Insert(0, li2);
                dropassign.SelectedIndex = 0;

                return;
            }

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
                //ListItem li = new ListItem("--All Clients--", "");
                //dropclient.Items.Insert(0, li);
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
            hidsearchfromdate.Value = txtfrmdate.Text;
            hidsearchtodate.Value = txttodate.Text;
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
            divreport.InnerHtml = getreport();
            upadatepanel.Update();
        }
        protected string getreport()
        {
            var cultureInfo = new System.Globalization.CultureInfo("en-US");
            objts.action = "ProjectTimeAndExpense";
            objts.empid = getchkval(dropemployee);
            objts.clientid = getchkval(dropclient);
            objts.taskid = "";
            objts.Status = "";
            objts.CreatedBy = dropassign.Text;
            objts.managerId = dropassign.Text;
            objts.from = txtfrmdate.Text;
            objts.to = txttodate.Text;
            objts.projectid = getchkval(dropproject);
            objts.isbillable = dropbillable.SelectedValue.ToString();
            objts.isbilled = dropbilled.SelectedValue.ToString();
            objts.taskStatus = dropTaskStatus.Text;
            objts.type = "";
            objts.id = "";
            objts.taskType = "";
            ds = objts.timesheetrdlcreport();

            DataTable dt = new DataTable();
            StringBuilder sb = new StringBuilder();

            if (ds.Tables[0].Rows.Count > 0)
            {
                dt = ds.Tables[0];
                sb.Append(@"<table cellpadding='4' >");

                DataView view = new DataView(dt);
                view.Sort = "clientcode ASC";


                DataTable sortedDT = view.ToTable();
                DataView view1 = new DataView(sortedDT);

                DataTable distinctValues = view1.ToTable(true, "clientid");

                double thrs = 0, tbhrs = 0, tcost = 0, tamt = 0;
                double tshrs = 0, tsbhrs = 0, tscost = 0, tsamt = 0;

                //Client Loop 1
                for (int i = 0; i < distinctValues.Rows.Count; i++)
                {
                    double chrs = 0, cbhrs = 0, ccost = 0, camt = 0;
                    double cshrs = 0, csbhrs = 0, cscost = 0, csamt = 0;
                    DataTable dtfinal = new DataTable();

                    dtfinal = filerbyemp("clientid='" + distinctValues.Rows[i]["clientid"].ToString() + "'", dt);
                    sb.Append("<tr><td colspan='8'>" + "<b>Client ID: <b><span style='color:#ed5210;font-waight:bold;'>" + dtfinal.Rows[0]["clientcode"].ToString() + "</span> - " + dtfinal.Rows[0]["clientname"].ToString() + "</td></tr>");
                    sb.Append("<tr><td colspan='8'>&nbsp;</td></tr>");
                    DataView viewproject = new DataView(dtfinal);
                    viewproject.Sort = "projectcode ASC";

                    DataTable distinctproject = viewproject.ToTable(true, "projectid");

                    sb.Append("<tr><th style='color:blue;border-top:solid 2px blue;border-bottom:solid 2px blue;text-align:left;' width='120'>Date</th>");
                    sb.Append("<th style='color:blue;border-top:solid 2px blue;border-bottom:solid 2px blue;text-align:left;'>Task ID</th>");
                    sb.Append("<th style='color:blue;border-top:solid 2px blue;border-bottom:solid 2px blue;text-align:left;'>Description</th>");
                    sb.Append("<th style='color:blue;border-top:solid 2px blue;border-bottom:solid 2px blue;text-align:right;' width='80'>Hrs</th>");
                    sb.Append("<th style='color:blue;border-top:solid 2px blue;border-bottom:solid 2px blue;text-align:right;' width='80'>B-Hr/Unit</th>");
                    sb.Append("<th style='color:blue;border-top:solid 2px blue;border-bottom:solid 2px blue;text-align:right;' width='80'>Bill Rate</th>");
                    sb.Append("<th style='color:blue;border-top:solid 2px blue;border-bottom:solid 2px blue;text-align:right;' width='80'>Cost</th>");
                    sb.Append("<th style='color:blue;border-top:solid 2px blue;border-bottom:solid 2px blue;text-align:right;' width='100'>Amount</th></tr>");

                    //Project Loop 2
                    #region projectid
                    for (int j = 0; j < distinctproject.Rows.Count; j++)
                    {
                        double phrs = 0, pbhrs = 0, pcost = 0, pamt = 0;
                        DataTable dtfinalProject = new DataTable();
                        dtfinalProject = filerbyemp("projectid='" + distinctproject.Rows[j]["projectid"].ToString() + "'", dtfinal);
                        sb.Append("<tr><td colspan='8'>&nbsp;</td></tr>");
                        sb.Append("<tr style='background-color:#e0e0e0;'><td colspan='8'>" + "<span style='font-size:10pt;font-waight:bold;color:#333333;'>Project ID - Name (Manager) </span><span style='font-weight:bold;font-size:9pt;color:#000000;'>" + dtfinalProject.Rows[0]["projectcode"].ToString() + ": - </span><span style='font-size:9pt;color:#823CAE;'>" + dtfinalProject.Rows[0]["projectname"].ToString() + "</span> (" + "<span style='font-weight:bold;font-size:10pt;color:#01A634;'>" + dtfinalProject.Rows[0]["managername"].ToString() + "</span>)</td></tr>");
                      

                        DataView viewService = new DataView(dtfinalProject);
                        viewService.Sort = "TEType ASC";
                        DataTable distinctService = viewService.ToTable(true, "TEType");

                        // Service Type Loop 3
                        #region servicetype
                        for (int k = 0; k < distinctService.Rows.Count; k++)
                        {
                            double shrs = 0, sbhrs = 0, scost = 0, samt = 0;
                            string servicetype = "";
                            if (distinctService.Rows[k]["TEType"].ToString() == "Task")
                            {
                                servicetype = "Services";
                            }
                            else
                            {
                                servicetype = "Expenses";
                            }
                            DataTable dtfinalService = new DataTable();
                            dtfinalService = filerbyemp("TEType='" + distinctService.Rows[k]["TEType"].ToString() + "'", dtfinalProject);
                            sb.Append("<tr><td colspan='8'>&nbsp;</td></tr>");
                            sb.Append("<tr><td colspan='8' style='color:#1CC3D2;font-weight:bold;'>" + servicetype + ":</td></tr>");
                          

                            DataView viewEmp = new DataView(dtfinalService);
                            viewEmp.Sort = "empcode ASC";
                            DataTable distinctEmp = viewEmp.ToTable(true, "empid");

                            //Emp id loop 4
                            #region EMPID
                            for (int l = 0; l < distinctEmp.Rows.Count; l++)
                            {
                                double emphrs = 0, empbhrs = 0, empcost = 0, empamt = 0;

                                DataTable dtFinalEmp1 = new DataTable();
                                dtFinalEmp1 = filerbyemp("empid='" + distinctEmp.Rows[l]["empid"].ToString() + "'", dtfinalService);
                                sb.Append("<tr><td colspan='8'>&nbsp;</td></tr>");
                                sb.Append("<tr><td colspan='8'>" + "<span style='color:#E10082;font-weight:bold;'>" + dtFinalEmp1.Rows[0]["empcode"].ToString() + "</span> - " + dtFinalEmp1.Rows[0]["empname"].ToString() + "</td></tr>");
                                sb.Append("<tr><td colspan='8'>&nbsp;</td></tr>");

                                DataView viewEmp1 = new DataView(dtFinalEmp1);
                                viewEmp1.Sort = "date ASC";
                               
                                DataTable dtFinalEmp = viewEmp1.ToTable();
                                
                                for (int m = 0; m < dtFinalEmp.Rows.Count; m++)
                                {
                                    string strhrs = "", strbrate = "";
                                    double bilhours = 0,hours=0;
                                    if (dtFinalEmp.Rows[m]["TEType"].ToString() == "Expense")
                                    {
                                        strhrs = "-";
                                        strbrate = "-";
                                        bilhours = Convert.ToDouble(dtFinalEmp.Rows[m]["hours1"]);
                                        hours = 0;
                                    }
                                    else
                                    {
                                        bilhours = Convert.ToDouble(dtFinalEmp.Rows[m]["bilhrs"]);
                                        strhrs = dtFinalEmp.Rows[m]["hours"].ToString();
                                        strbrate = String.Format("{0:C}", dtFinalEmp.Rows[m]["Tbillrate"].ToString());
                                        hours = Convert.ToDouble(dtFinalEmp.Rows[m]["hours1"]);
                                    }

                                    emphrs += Convert.ToDouble(hours);
                                    empbhrs += bilhours;
                                    empcost += Convert.ToDouble(dtFinalEmp.Rows[m]["Tcostrate"]);
                                    empamt += Convert.ToDouble(dtFinalEmp.Rows[m]["amount1"]);

                                    shrs += Convert.ToDouble(hours);
                                    sbhrs += bilhours;
                                    scost += Convert.ToDouble(dtFinalEmp.Rows[m]["Tcostrate"]);
                                    samt += Convert.ToDouble(dtFinalEmp.Rows[m]["amount1"]);


                                    phrs += Convert.ToDouble(hours);
                                    pbhrs += bilhours;
                                    pcost += Convert.ToDouble(dtFinalEmp.Rows[m]["Tcostrate"]);
                                    pamt += Convert.ToDouble(dtFinalEmp.Rows[m]["amount1"]);

                                    if (dtFinalEmp.Rows[m]["TEType"].ToString() == "Task")
                                    {
                                        cshrs += Convert.ToDouble(hours);
                                        csbhrs += bilhours;
                                        cscost += Convert.ToDouble(dtFinalEmp.Rows[m]["Tcostrate"]);
                                        csamt += Convert.ToDouble(dtFinalEmp.Rows[m]["amount1"]);
                                    }
                                    else
                                    {
                                        chrs += Convert.ToDouble(hours);
                                        cbhrs += bilhours;
                                        ccost += Convert.ToDouble(dtFinalEmp.Rows[m]["Tcostrate"]);
                                        camt += Convert.ToDouble(dtFinalEmp.Rows[m]["amount1"]);
                                    }





                                    sb.Append("<tr><td  style='text-align:left;'>" + dtFinalEmp.Rows[m]["date"].ToString() + "</td>");
                                    sb.Append("<td>" + dtFinalEmp.Rows[m]["taskcode"].ToString() + " : "+dtFinalEmp.Rows[m]["taskname"].ToString() +"</td>");
                                    sb.Append("<td>" + dtFinalEmp.Rows[m]["description"].ToString() + "</td>");
                                    sb.Append("<td style='text-align:right;'>" + strhrs + "</td>");
                                    sb.Append("<td style='text-align:right;'>" + bilhours.ToString("0.00") + "</td>");
                                    sb.Append("<td style='text-align:right;'>" + strbrate + "</td>");
                                    sb.Append("<td style='text-align:right;'>" + String.Format("{0:C}", dtFinalEmp.Rows[m]["Tcostrate"].ToString()) + "</td>");
                                    sb.Append("<td style='text-align:right;'>" + String.Format("{0:C}", dtFinalEmp.Rows[m]["amount1"].ToString()) + "</td></tr>");

                                }

                                sb.Append("<tr style='font-weight:bold;text-align:right;'><td colspan='3'>" + "<span style='color:#E10082;font-weight:bold;'>" + dtFinalEmp.Rows[0]["empcode"].ToString() + "</span> Total: " + "</td>");
                                sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'>" + emphrs.ToString("0.00") + "</td>");
                                sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'>" + empbhrs.ToString("0.00") + "</td>");
                                sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'></td>");
                                sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'>" + String.Format("{0:C}", empcost.ToString("0.00")) + "</td>");
                                sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'>" + String.Format("{0:C}", empamt.ToString("0.00")) + "</td></tr>");

                            }
                            #endregion
                            //End Empid Loop 4
                            sb.Append("<tr><td colspan='8'>&nbsp;</td></tr>");
                            sb.Append("<tr style='font-weight:bold;text-align:right;'><td colspan='3'>" + "Project <span style='color:#823cae;font-weight:bold;'> " + dtfinalProject.Rows[0]["projectcode"].ToString() + "</span> <span style='color:#1CC3D2;font-weight:bold;'>" + servicetype + "</span> Total: " + "</td>");
                            sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'>" + shrs.ToString("0.00") + "</td>");
                            sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'>" + sbhrs.ToString("0.00") + "</td>");
                            sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'></td>");
                            sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'>" + String.Format("{0:C}", scost.ToString("0.00")) + "</td>");
                            sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'>" + String.Format("{0:C}", samt.ToString("0.00")) + "</td></tr>");





                        } //End Service Type Loop 3
                        #endregion
                        sb.Append("<tr><td colspan='8'>&nbsp;</td></tr>");
                        sb.Append("<tr style='font-weight:bold;text-align:right;'><td colspan='3'>" + "Project <span style='color:#1CC3D2;font-weight:bold;'> " + dtfinalProject.Rows[0]["projectcode"].ToString() + "</span> Total: " + "</td>");
                        sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'>" + phrs.ToString("0.00") + "</td>");
                        sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'>" + pbhrs.ToString("0.00") + "</td>");
                        sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'></td>");
                        sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'>" + String.Format("{0:C}", pcost.ToString("0.00")) + "</td>");
                        sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'>" + String.Format("{0:C}", pamt.ToString("0.00")) + "</td></tr>");

                    }
                    #endregion
                    //End Project Loop 2
                    sb.Append("<tr><td colspan='8'>&nbsp;</td></tr>");
                    sb.Append("<tr style='font-weight:bold;text-align:right;'><td colspan='3'>" + "Client <span style='color:#ed5210;font-weight:bold;'> " + dtfinal.Rows[0]["clientcode"].ToString() + "</span> <span style='color:#1CC3D2;font-weight:bold;'> Service </span> Total: " + "</td>");
                    sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'>" + cshrs.ToString("0.00") + "</td>");
                    sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'>" + csbhrs.ToString("0.00") + "</td>");
                    sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'></td>");
                    sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'>" + String.Format("{0:C}", cscost.ToString("0.00")) + "</td>");
                    sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'>" + String.Format("{0:C}", csamt.ToString("0.00")) + "</td></tr>");

                    sb.Append("<tr style='font-weight:bold;text-align:right;'><td colspan='3'>" + "Client <span style='color:#ed5210;font-weight:bold;'> " + dtfinal.Rows[0]["clientcode"].ToString() + "</span> <span style='color:#1CC3D2;font-weight:bold;'> Expense </span> Total: " + "</td>");
                    sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'>" + chrs.ToString("0.00") + "</td>");
                    sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'>" + cbhrs.ToString("0.00") + "</td>");
                    sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'></td>");
                    sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'>" + String.Format("{0:C}", ccost.ToString("0.00")) + "</td>");
                    sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'>" + String.Format("{0:C}", camt.ToString("0.00")) + "</td></tr>");
                    sb.Append("<tr><td colspan='8'>&nbsp;</td></tr>");
                    sb.Append("<tr style='font-weight:bold;text-align:right;'><td colspan='3'>" + "Client <span style='color:#ed5210;font-weight:bold;'> " + dtfinal.Rows[0]["clientcode"].ToString() + "</span> Total: " + "</td>");
                    sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'>" + (chrs+cshrs).ToString("0.00") + "</td>");
                    sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'>" + (cbhrs+csbhrs).ToString("0.00") + "</td>");
                    sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'></td>");
                    sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'>" + String.Format("{0:C}", (ccost+cscost).ToString("0.00")) + "</td>");
                    sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'>" + String.Format("{0:C}", (camt+csamt).ToString("0.00")) + "</td></tr>");

                    tshrs += cshrs;
                    tsbhrs += csbhrs;
                    tscost += cscost;
                    tsamt += csamt;

                    thrs += chrs;
                    tbhrs += cbhrs;
                    tcost += ccost;
                    tamt += camt;
    
                }
                //End CLient Loop 1

                sb.Append("<tr><td colspan='8'>&nbsp;</td></tr>");
                sb.Append("<tr><td colspan='8'>&nbsp;</td></tr>");
                sb.Append("<tr style='font-weight:bold;text-align:right;'><td colspan='3'>" + "Grand Total Services: " + "</td>");
                sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'>" + tshrs.ToString("0.00") + "</td>");
                sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'>" + tsbhrs.ToString("0.00") + "</td>");
                sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'></td>");
                sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'>" + String.Format("{0:C}", tscost.ToString("0.00")) + "</td>");
                sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'>" + String.Format("{0:C}", tsamt.ToString("0.00")) + "</td></tr>");

                sb.Append("<tr style='font-weight:bold;text-align:right;'><td colspan='3'>" + "Grand Total Expenses: " + "</td>"); 
                sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'>" + thrs.ToString("0.00") + "</td>");
                sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'>" + tbhrs.ToString("0.00") + "</td>");
                sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'></td>");
                sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'>" + String.Format("{0:C}", tcost.ToString("0.00")) + "</td>");
                sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'>" + String.Format("{0:C}", tamt.ToString("0.00")) + "</td></tr>");

                sb.Append("<tr style='font-weight:bold;text-align:right;'><td colspan='3'>" + "Grand Total: " + "</td>"); 
                sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'>" + (thrs + tshrs).ToString("0.00") + "</td>");
                sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'>" + (tbhrs + tsbhrs).ToString("0.00") + "</td>");
                sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'></td>");
                sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'>" + String.Format(cultureInfo,"{0:C0}", (tcost + tscost).ToString("0.00")) + "</td>");
                sb.Append("<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;'>" + String.Format(cultureInfo,"{0:C0}", (tamt + tsamt).ToString("0.00")) + "</td></tr>");



                sb.Append("</table>");


            }

            return sb.ToString();
            //objexcel.downloadFile(sb.ToString(), "Client Time and Exp Report.xls");

        }


        protected void btnexportcsv_Click(object sender, EventArgs e)
        {
            objexcel.downloadFile(getreport(), "Client Time and Exp Report.xls");

        }
        private DataTable filerbyemp(string id, DataTable dt)
        {
            DataView dv = new DataView(dt);
            dv.RowFilter = id;
            return dv.ToTable();

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

        protected void chkcost_CheckedChanged(object sender, EventArgs e)
        {
            fillgrid();
        }

        /// <summary>
        /// Bind Header of excel Report
        /// </summary>
        /// <param name="type"></param>
        /// <returns></returns>

    }
}