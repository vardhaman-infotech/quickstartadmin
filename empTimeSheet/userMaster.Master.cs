using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.Services;
using System.Web.Script.Services;
using System.IO;
using System.Text;

namespace empTimeSheet
{
    public partial class userMaster : System.Web.UI.MasterPage
    {
        ClsUser objuser = new ClsUser();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();
        DataAccess objda = new DataAccess();
        string sPageName = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            string sPagePath = System.Web.HttpContext.Current.Request.Url.AbsolutePath;
            System.IO.FileInfo oFileInfo = new System.IO.FileInfo(sPagePath);
            sPageName = (oFileInfo.Name).ToLower();

            if (!IsPostBack)
            {
                hidloginid.Value = Session["userid"].ToString();
                hidcompanyid.Value = Session["companyid"].ToString();


                hidchatDesignation.Value = Session["designation"].ToString();
                hidchatphoto.Value = Session["profilephoto"].ToString();
                hidchatstatus.Value = Session["chatstatus"].ToString();
                hidchatloginid.Value = Session["userid"].ToString().ToLower();
                hidchatname.Value = Session["UserName"].ToString();
                hidchatgroupid.Value = Session["CompanyId"].ToString().ToUpper();

                if (Session["livedemo"] != null)
                {
                    hidisdemo.Value = Session["livedemo"].ToString();
                }

               


                binduserdetail();

                if (Session["usertype"].ToString() == "Admin")
                {
                    lnkdashboard.HRef = "AdminDashboard.aspx";
                    setAdminReports();
                }
                else
                {
                    setroles();
                }

                activatemenu();
                bindtasksummary();
                bindtasknotification();
                bindannoucementnotification();
                bindfavtask();
            }
        }

        /// <summary>
        /// Bind user details
        /// </summary>
        protected void binduserdetail()
        {
            if (Session["profilephoto"].ToString() != "")
                imgphoto.Src = "webfile/profile/thumb/" + Session["profilephoto"].ToString();
            lnkmainusername.Text = Session["UserName"].ToString();
            litusername.Text = Session["UserName"].ToString();

        }

       protected void setAdminReports()
        {
            System.Data.DataSet ds = new System.Data.DataSet();
            objda.id = Session["userid"].ToString();
            ds = objda.getAdminRoleReport();

            StringBuilder sb = new StringBuilder();
            if (ds.Tables[1].Rows.Count > 0)
            {
                for (int i = 0; i < ds.Tables[1].Rows.Count; i++)
                {
                    sb.Append("<li><a><i>" + ds.Tables[1].Rows[i]["rGroup"].ToString() + "</i>");
                    DataTable dt = new DataTable();
                    dt = filterrole("rGroup='" + ds.Tables[1].Rows[i]["rGroup"].ToString() + "'", ds);
                    if (dt.Rows.Count > 0)
                    {
                        sb.Append("<div></div></a><ul class='submenu1'>");
                        for (int j = 0; j < dt.Rows.Count; j++)
                        {
                            if (dt.Rows[j]["linkname"].ToString() != "")
                            {

                                string[] linkname = dt.Rows[j]["linkname"].ToString().Split('#');
                                string[] linkpagename = dt.Rows[j]["pages"].ToString().Split('#');
                                for (int k = 0; k < linkname.Length; k++)
                                {
                                    sb.Append("<li><a href='" + linkpagename[k] + "'><i class='fa fa-folder'></i>" + linkname[k] + "</a></li>");
                                }
                            }

                        }
                        sb.Append("</ul>");
                    }
                    else
                    {
                        sb.Append("</a>");

                    }

                    sb.Append("</li>");
                }

            }
            litlinks.Text = sb.ToString();
        }


        protected void setroles()
        {
            System.Data.DataSet ds = new System.Data.DataSet();
            objda.id = Session["userid"].ToString();
            ds = objda.getUserInRoleswithReport();
            //Check for VIEW inner links role
            //if user does not have roles 1,2,3,4,10 and 11 then hide the VIEW link
            if (!objda.validatedRoles("1", ds) && !objda.validatedRoles("2", ds) && !objda.validatedRoles("3", ds) && !objda.validatedRoles("4", ds) && !objda.validatedRoles("10", ds) && !objda.validatedRoles("11", ds) && !objda.validatedRoles("35", ds) && !objda.validatedRoles("41", ds))
            {
                liview.Visible = false;
            }
            else
            {
                if (!objda.validatedRoles("1", ds))
                {
                    lnkdept.Visible = false;
                    lnkdesig.Visible = false;
                }
                if (!objda.validatedRoles("2", ds))
                {
                    lnkemp.Visible = false;
                }
                if (!objda.validatedRoles("3", ds))
                {
                    lnkclient.Visible = false;
                    lnkclientaddress.Visible = false;
                    lnkproject.Visible = false;
                }

                if (!objda.validatedRoles("4", ds))
                {
                    lnktaksmanage.Visible = false;
                    lnkexpensemanage.Visible = false;
                }
                if (!objda.validatedRoles("10", ds))
                {
                    lnkannouncement.Visible = false;
                }
                //if (!objda.validatedRoles("11", ds))
                //{
                //    lnkServerMaster.Visible = false;
                //}
                if (!objda.validatedRoles("35", ds))
                {
                    lnkfilecategory.Visible = false;
                }
                if (!objda.validatedRoles("41", ds))
                {
                    lnktax.Visible = false;
                }
            }

            //if (!objda.validatedRoles("44", ds))
            //{
            //    lnktimeexpensereport.Visible = false;
            //    littimesummaryByEmp.Visible = false;
            //    linkexpensedetbyEmp.Visible = false;
            //    lnktimeexpenseclientreport.Visible = false;

            //}

            if (!objda.validatedRoles("5", ds) && !objda.validatedRoles("6", ds))
            {
                lnkschedule.Visible = false;
            }
            if (!objda.validatedRoles("7", ds) && !objda.validatedRoles("8", ds) && !objda.validatedRoles("15", ds))
            {
                lnkassign.Visible = false;
                
            }
            if (!objda.validatedRoles("85", ds) && !objda.validatedRoles("25", ds))
            {

                lnksheetview.Visible = false;
            }
            if (!objda.validatedRoles("86", ds) && !objda.validatedRoles("87", ds))
            {

                lnkexpenselog.Visible = false;
            }
          
           


            //if (!objda.validatedRoles("16", ds))
            //{
            //    lnkschedulereport.Visible = false;
            //  //  lnkschedulereport1.Visible = false;
            //}
            //Check for Payroll inner links roles
            if (!objda.validatedRoles("17", ds))
            {
                lnkissueleave.Visible = false;
            }

           

            if (!objda.validatedRoles("20", ds))
            {
                lnkGenerateSalary.Visible = false;
            }

            if (!objda.validatedRoles("23", ds) && !objda.validatedRoles("24", ds) && !objda.validatedRoles("110", ds) && !objda.validatedRoles("113", ds))
            {
                liprojectmanagement.Visible = false;
               
            }
            else
            {
                if (!objda.validatedRoles("110", ds))
                {
                    lnkprojectlog.Visible = false;
                }
                if (!objda.validatedRoles("23", ds))
                {
                    lnkprojectforecasting.Visible = false;
                }
                if (!objda.validatedRoles("24", ds))
                {
                    lnkprojectallocation.Visible = false;
                  
                }
                if (!objda.validatedRoles("113", ds))
                {
                    lnkprojectbudgeting.Visible = false;

                }
            }
            //Check for FILE MANAGER role
            if (!objda.validatedRoles("26", ds))
            {
                liadminsetting.Visible = false;
                liemailfilesharing.Visible = false;

            } if (!objda.validatedRoles("18", ds))
            {
                lnkadminholiday.Visible = false;
            }

            //check informationtype
            if (!objda.validatedRoles("109", ds))
            {
                liinformationtype.Visible = false;
            }
            //Check for FILE MANAGER role
            if (!objda.validatedRoles("36", ds))
            {
                lnkfilemanager.Visible = false;
            }

            if (!objda.validatedRoles("37", ds) && !objda.validatedRoles("38", ds) && !objda.validatedRoles("40", ds) && !objda.validatedRoles("42", ds))
            {
                liBilling.Visible = false;
            }
            else
            {
                if (!objda.validatedRoles("37", ds) && !objda.validatedRoles("40", ds))
                {
                    liinvoice.Visible = false;
                    liinvoicereview.Visible = false;
                    lisavedinvoice.Visible = false;
                }
                else
                {
                    if (!objda.validatedRoles("37", ds) && objda.validatedRoles("40", ds))
                    {
                        liinvoice.Visible = false;
                    }

                }

                if (!objda.validatedRoles("38", ds))
                {
                    liPayment.Visible = false;
                    liPaymentReview.Visible = false;
                }
                if (!objda.validatedRoles("42", ds))
                {
                    litransstatement.Visible = false;
                }
            }



            if (!objda.validatedRoles("27", ds) && !objda.validatedRoles("28", ds))
            {
                lnkclientgroup.Visible = false;
            }
            if (!objda.validatedRoles("29", ds) && !objda.validatedRoles("30", ds))
            {
                lnkempgroup.Visible = false;
            }
            if (!objda.validatedRoles("31", ds) && !objda.validatedRoles("32", ds))
            {
                lnkProjectGroup.Visible = false;
            }
            if (!objda.validatedRoles("33", ds) && !objda.validatedRoles("34", ds))
            {
                lnkexpensegroup.Visible = false;
            }
            /////////////////////
            if (!objda.validatedRoles("17", ds) && !objda.validatedRoles("18", ds))
            {
                lnkleaverquest.Visible = false;
                lnkholidaycal.Visible = false;

            }

            if (!objda.validatedRoles("101", ds) && !objda.validatedRoles("102", ds) && !objda.validatedRoles("103", ds))
            {
                liAttendance.Visible = false;
            }

            if (!objda.validatedRoles("90", ds) && !objda.validatedRoles("91", ds) && !objda.validatedRoles("92", ds) && !objda.validatedRoles("93", ds) && !objda.validatedRoles("95", ds))
            {
                liasset.Visible = false;

            }
            else
            {
                if (!objda.validatedRoles("90", ds))
                {
                    lnkAssetMaster.Visible = false;
                }
                if (!objda.validatedRoles("91", ds))
                {
                    lnkAssetCategory.Visible = false;
                }
                if (!objda.validatedRoles("92", ds))
                {
                    lnkvendor.Visible = false;
                }
                if (!objda.validatedRoles("93", ds) && !objda.validatedRoles("94", ds))
                {
                    lnkAssetTransfer.Visible = false;
                }


            }

            if (!objda.validatedRoles("108", ds))
            {
                liappointments.Visible = false;

            }
            StringBuilder sb = new StringBuilder();
            if (ds.Tables[1].Rows.Count > 0)
            {
                for (int i = 0; i < ds.Tables[1].Rows.Count; i++)
                {
                    sb.Append("<li><a><i>" + ds.Tables[1].Rows[i]["rGroup"].ToString() + "</i>");
                    DataTable dt = new DataTable();
                    dt = filterrole("rGroup='" + ds.Tables[1].Rows[i]["rGroup"].ToString() + "'", ds);
                    if (dt.Rows.Count > 0)
                    {
                        sb.Append("<div></div></a><ul class='submenu1'>");
                        for (int j = 0; j < dt.Rows.Count; j++)
                        {
                            if (dt.Rows[j]["linkname"].ToString() != "")
                            {

                                string[] linkname = dt.Rows[j]["linkname"].ToString().Split('#');
                                string[] linkpagename = dt.Rows[j]["pages"].ToString().Split('#');
                                for (int k = 0; k < linkname.Length; k++)
                                {
                                    sb.Append("<li><a href='" + linkpagename[k] + "'><i class='fa fa-folder'></i>" + linkname[k] + "</a></li>");
                                }
                            }

                        }
                        sb.Append("</ul>");
                    }
                    else
                    {
                        sb.Append("</a>");

                    }

                    sb.Append("</li>");
                }

            }
            litlinks.Text = sb.ToString();

        }

        public DataTable filterrole(string str, DataSet ds)
        {
            DataView dv = new DataView(ds.Tables[0]);
            dv.RowFilter = str;
            return dv.ToTable();
        }

        /// <summary>
        /// 
        /// </summary>
        protected void activatemenu()
        {
            switch (sPageName)
            {
                case "dashboard.aspx":
                    lnkdashboard.Attributes.Add("class", "active");
                    break;

                case "filemanager.aspx":
                    lnkcompany.Attributes.Add("class", "active");
                    break;

                case "employee.aspx":
                case "client.aspx":
                case "project.aspx":
                case "task.aspx":
                case "expensemaster.aspx":
                case "department.aspx":
                case "designation.aspx":
                case "servers.aspx":
                case "annoncements.aspx":
                case "filecategorymaster.aspx":
                    lnkview.Attributes.Add("class", "active");
                    break;

                case "clientgroup.aspx":
                case "employeegroup.aspx":
                case "projectgroup.aspx":
                case "expensegroup.aspx":
                    lnkgroups.Attributes.Add("class", "active");
                    break;

                case "leaverequest.aspx":
                case "issueleave.aspx":
                case "holiday.aspx":
                case "gensalary.aspx":
                    lnkpayroll.Attributes.Add("class", "active");
                    break;

                case "assignedtasks.aspx":
                case "serverlog.aspx":
                case "timesheet.aspx":
                    lnktimesheet.Attributes.Add("class", "active");
                    break;

                case "viewschedule.aspx":
                    lnkschedule.Attributes.Add("class", "active");
                    break;

                //case "projectforecasting.aspx":
                //case "projectallocation.aspx":
                //    lnkprojectmanagement.Attributes.Add("class", "active");

                case "assignedtasksreport.aspx":
                case "schedulereport.aspx":
                case "schedulereport_summary.aspx":
                case "cumulativereport.aspx":
                case "performancereport.aspx":
                case "leavereport.aspx":
                case "payrollreport.aspx":
                case "projectallocationreport.aspx":

                    lnkreport.Attributes.Add("class", "active");
                    break;

              
              

            }
        }


        protected void bindtasksummary()
        {
            objts.empid = Session["userid"].ToString();
            objts.action = "gettaskssummary";
            ds = objts.AssignTasks();
            if (ds.Tables[0].Rows.Count > 0)
            {
                ltrtotalassignedtasks.Text = ds.Tables[0].Rows[0]["totalassignedtasks"].ToString();
                // ltrNotStartedTasks.Text = ds.Tables[0].Rows[0]["totalnotstartedtasks"].ToString();
                ltrInProcessTasks.Text = ds.Tables[0].Rows[0]["totalinprocesstasks"].ToString();
                ltrCompletedTasks.Text = ds.Tables[0].Rows[0]["totalcompletedtasks"].ToString();
            }


        }

        #region Announcement Notifications
        //Bind list of last announcement
        protected void bindannoucementnotification()
        {
            objda.loginid = Session["userid"].ToString();
            objda.action = "getcountofunreadnoti";
            objda.company = Session["companyid"].ToString();
            ds = objda.AnnouncementMaster();
            if (ds.Tables[0].Rows.Count > 0)
            {
                if (ds.Tables[0].Rows[0]["numofnotification"].ToString() == "0")
                {
                    spanannouncenoti.InnerHtml = "";
                }
                else
                    spanannouncenoti.InnerHtml = ds.Tables[0].Rows[0]["numofnotification"].ToString();
            }

        }
        protected void bindfavtask()
        {
            objuser.userid = Session["userid"].ToString();

            objuser.action = "getfavReportHTML";
            ds = objuser.FavouriteReports();

            StringBuilder sb = new StringBuilder();



            if (ds.Tables[1].Rows.Count > 0)
            {




                for (int i = 0; i < ds.Tables[1].Rows.Count; i++)
                {
                    sb.Append("<li class='favtitle'><i class='fa fa-file'></i>" + ds.Tables[1].Rows[i]["rGroup"].ToString() + "</li>");

                    DataTable dt = new DataTable();
                    dt = filterrole("rGroup='" + ds.Tables[1].Rows[i]["rGroup"].ToString() + "'", ds);

                    for (int j = 0; j < dt.Rows.Count; j++)
                    {
                        sb.Append("<li><a href='" + dt.Rows[j]["rlink"].ToString() + "'><i class='reporticon'>"+ dt.Rows[j]["rname"].ToString() +"</i></a></li>");

                    }


                }

            }
            else
            {
                sb.Append("<li class='nofavtask'>No Favourite Report in this list</li>");


            }
            litfavtask.Text = sb.ToString();

        }

        #endregion



        #region Tasks Notifications
        //Bind list of last announcement
        protected void bindtasknotification()
        {
            objts.empid = Session["userid"].ToString();
            objts.action = "getcountofunreadnoti";
            objts.companyId = Session["companyid"].ToString();
            ds = objts.AssignTasks();
            if (ds.Tables[0].Rows.Count > 0)
            {
                if (ds.Tables[0].Rows[0]["numofnotification"].ToString() == "0")
                {
                    spantasknoti.InnerHtml = "";
                }
                else
                    spantasknoti.InnerHtml = ds.Tables[0].Rows[0]["numofnotification"].ToString();
            }
            //rpttask.DataSource = ds.Tables[1];
            //rpttask.DataBind();
        }


        #endregion




    }
}