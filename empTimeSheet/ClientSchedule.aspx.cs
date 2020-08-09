using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.Services;
using System.Web.Script.Services;
using System.Text;
using empTimeSheet.DataClasses.BAL;
using System.IO;

namespace empTimeSheet
{
    public partial class ClientSchedule : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DataAccess objda = new DataAccess();
            GeneralMethod objgen = new GeneralMethod();
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                System.Data.DataSet ds = new System.Data.DataSet();
                objda.id = Session["userid"].ToString();
                ds = objda.getUserInRoles();
                fillemployee();
                fillclients();
                if (Session["usertype"].ToString() != "Admin")
                {
                    if (!objda.validatedRoles("5", ds) && !objda.validatedRoles("6", ds))
                    {
                        Response.Redirect("UserDashboard.aspx");
                    }

                    if (objda.validatedRoles("5", ds))
                    {
                        ViewState["add"] = "1";

                    }
                    else
                    {

                        ViewState["add"] = null;

                    }
                }
                else
                {
                    ViewState["add"] = "1";
                }
            }
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getClient(string companyid)
        {
            ClsUser objuser = new ClsUser();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();
            objuser.action = "selectforautocompleter";
            objuser.companyid = companyid;
            ds = objuser.client();
            string result = objgen.serilizeinJson(ds.Tables[0]);
            return result;
        }
        protected void fillclients()
        {
            ClsUser objuser = new ClsUser();
            objuser.action = "select";

            objuser.name = "";
            objuser.id = "";
            objuser.companyid = Session["companyId"].ToString();
           DataSet ds = objuser.client();
            if (ds.Tables[0].Rows.Count > 0)
            {
                dropclient.DataSource = ds;
               // dropclient.DataTextField = "clientcodewithname";
               // dropclient.DataValueField = "nid";
                dropclient.DataBind();


            }

        }
        protected void dropemployee_DataBound(object sender, EventArgs  e)
        {
             
        }
        protected void fillemployee()
        {
           
                ClsUser objuser = new ClsUser();
                objuser.action = "selectactive";
                objuser.companyid = Session["companyid"].ToString();
                objuser.id = "";
               DataSet ds = objuser.ManageEmployee();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    //GeneralMethod objgen = new GeneralMethod();
                  //  objgen.fillActiveInactiveDDL(ds.Tables[0], dropemployee, "username", "nid");
                  //  dropemployee.Enabled = true;
                dropemployee.DataSource = ds.Tables[0];
               // dropemployee.DataTextField = "username";
               // dropemployee.DataValueField = "nid";
                dropemployee.DataBind();



            }

            ListItem li = new ListItem("--All Employees--", "");
                //dropemployee.Items.Insert(0, li);
               // dropemployee.SelectedIndex = 0;
             
        }


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getProject(string companyid, string clientid)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();
            objts.action = "selectforautocompleter1";
            objts.companyId = companyid;
            objts.clientid = clientid;
            ds = objts.ManageProject();
            string result = objgen.serilizeinJson(ds.Tables[0]);
            return result;
        }



        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getEmployee(string companyid)
        {
            ClsUser objuser = new ClsUser();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();
            objuser.loginid = "";
            objuser.name = "";
            objuser.companyid = companyid;
            objuser.action = "select";
            objuser.activestatus = "active";
            ds = objuser.ManageEmployee();
            string result = objgen.serilizeinJson(ds.Tables[0]);
            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getdata(string companyid, string fromdate, string todate, string status, string schtype, string client, string project)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();
            ClsScheduleBAL objSch = new ClsScheduleBAL();
            objts.nid = "";
            objts.action = "selectgroup";
            objts.companyId = companyid;
            objts.from = fromdate;
            objts.to = todate;
            objts.clientid = client;
            objts.projectid = project;
            objts.empid = "";
            objts.Status = status;
            objts.remark = schtype;
            ds = objts.schedule();

            string result = "";

            DataTable dtbyItem = new DataTable();
            var cWeek = DateRange.getLastDates("Current Week");
            var NWeek = DateRange.getLastDates("Next Week");


            dtbyItem = objgen.filterTable("date>=#01/01/" + (DateTime.Now.Year - 1).ToString() + "# and date<=#12/31/" + (DateTime.Now.Year - 1).ToString() + "#", ds.Tables[0]);
            result = objSch.scheduleHTML(dtbyItem, "Previous Year Schedules", "pys");

            dtbyItem = objgen.filterTable("date>=#01/01/" + DateTime.Now.Year.ToString() + "# and date<#" + cWeek.fromdate + "#", ds.Tables[0]);
            result = result + objSch.scheduleHTML(dtbyItem, "Older Schedules", "os");


            dtbyItem = objgen.filterTable("date>=#" + cWeek.fromdate + "# and date<=#" + cWeek.todate + "#", ds.Tables[0]);
            result = result + objSch.scheduleHTML(dtbyItem, "Current Week Schedules", "cv");

            dtbyItem = objgen.filterTable("date>=#" + NWeek.fromdate + "# and date<=#" + NWeek.todate + "#", ds.Tables[0]);
            result = result + objSch.scheduleHTML(dtbyItem, "Next Week Schedules", "nv");

            dtbyItem = objgen.filterTable("date>#" + NWeek.todate + "#", ds.Tables[0]);
            result = result + objSch.scheduleHTML(dtbyItem, "Upcoming Schedules", "uc");



            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getExportdata(string companyid, string fromdate, string todate, string status, string schtype, string client, string project)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet dsexcel = new DataSet();

            string result = "";
            objts.nid = "";
            objts.action = "select";
            objts.companyId = companyid;
            objts.from = fromdate;
            objts.to = todate;
            objts.clientid = client;
            objts.projectid = project;
            objts.empid = "";
            objts.Status = status;
            objts.remark = schtype;
            dsexcel = objts.schedule();


            if (dsexcel.Tables[0].Rows.Count > 0)
            {
                result = @"<table align='left' cellpadding='5' width='100%' cellspacing='0' style='font-family: Calibri;font-size: 12px; text-align: left;' border='0'>       
<tr style='font-weight: bold; background: #395ba4; color: #ffffff;'><th style='width=50px;'width='100px'>S. No.</th> <th> Date</th> <th> Time</th><th>Employee</th> <th>Client</th> <th>Project</th> <th>Schedule Type</th> <th>Status</th> <th>Remark</th> <th>Last Modified By</th> </tr>";



                for (int i = 0; i < dsexcel.Tables[0].Rows.Count; i++)
                {
                    result = result + "<tr><td>" + Convert.ToString(i + 1) + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["date"].ToString() +
                        "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["Time"].ToString() + "</td><td>" + dsexcel.Tables[0].Rows[i]["empname"].ToString() + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["clientname"].ToString() + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["projectcode"].ToString() + "</td>"
                        + "<td>" + dsexcel.Tables[0].Rows[i]["scheduletype"].ToString() + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["status"].ToString() + "</td>"
                        + "<td>" + dsexcel.Tables[0].Rows[i]["remark"].ToString() + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["username"].ToString() + "</td></tr>";
                }
                result += "</table>";
            }
            return result;
        }




        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string generateemail(string companyid, string nid)
        {

            string result = "";
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();
            ClsScheduleBAL objSch = new ClsScheduleBAL();

            objts.action = "getDetailByGroup";
            objts.companyId = companyid;
            objts.nid = nid;

            ds = objts.schedule();

            try
            {
                //Read File Data            
                string HTMLBODY = File.Exists(HttpContext.Current.Server.MapPath("EmailTemplates/clientschedule.htm")) ? File.ReadAllText(HttpContext.Current.Server.MapPath("EmailTemplates/clientschedule.htm")) : "";

                HTMLBODY = HTMLBODY.Replace("#URL#", ds.Tables[1].Rows[0]["schedulerURL"].ToString());
                HTMLBODY = HTMLBODY.Replace("##Date##", ds.Tables[0].Rows[0]["date"].ToString() + " " + ds.Tables[0].Rows[0]["time"].ToString());
                HTMLBODY = HTMLBODY.Replace("##ClientName##", ds.Tables[0].Rows[0]["clientname"].ToString());
                HTMLBODY = HTMLBODY.Replace("##ProjectName##", ds.Tables[0].Rows[0]["projectname"].ToString());
                HTMLBODY = HTMLBODY.Replace("##ClientAddress##", ds.Tables[0].Rows[0]["clientaddress"].ToString());
                HTMLBODY = HTMLBODY.Replace("##Status##", ds.Tables[0].Rows[0]["status"].ToString());
                HTMLBODY = HTMLBODY.Replace("##CompanyContact##", ds.Tables[1].Rows[0]["phone"].ToString());
                HTMLBODY = HTMLBODY.Replace("##CompanyName##", ds.Tables[1].Rows[0]["companyname"].ToString());
                string strreceiver = "", strrecName = "";
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    if (ds.Tables[0].Rows[i]["emailid"].ToString() != "")
                    {
                        strreceiver += ds.Tables[0].Rows[i]["emailid"].ToString() + ",";

                    }
                    if ((i - 1) != ds.Tables[0].Rows.Count)
                        strrecName += ds.Tables[0].Rows[i]["fname"].ToString() + ", ";
                    else
                        strrecName += ds.Tables[0].Rows[i]["fname"].ToString();
                }
                HTMLBODY = HTMLBODY.Replace("[FirstName]", strrecName);
                result = "1####" + strrecName + "####" + strreceiver + "####" + "Re: Schedule with - " + ds.Tables[0].Rows[0]["clientname"].ToString() + "####" + HTMLBODY;

            }
            catch (Exception ex)
            {
                result = @"0####" + ex.ToString();
            }

            return result;

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string sendScheduletoMail(string receiver, string subject, string detail, string companyid)
        {
            GeneralMethod objgen = new GeneralMethod();
            string result = "";
            DataAccess objda = new DataAccess();

            try
            {

                result = objda.SendEmail(receiver + ",", subject, detail, "", "", "", companyid);

                result = "1";
            }
            catch (Exception ex)
            {
                result = ex.ToString();
            }

            return result;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getDetailData(string companyid, string nid)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();
            ClsScheduleBAL objSch = new ClsScheduleBAL();

            objts.action = "getDetailByGroup";
            objts.companyId = companyid;
            objts.nid = nid;

            ds = objts.schedule();

            string result = "";

            result = objgen.serilizeinJson(ds.Tables[0]);
            return result;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string deleteGroupSchedule(string companyid, string nid, string action)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();
            ClsScheduleBAL objSch = new ClsScheduleBAL();
            objts.nid = nid;

            if (action == "one")
                objts.action = "delete";
            else
                objts.action = "deleteGRpup";
            objts.companyId = companyid;
            ds = objts.schedule();
            string result = "";
            result = objgen.serilizeinJson(ds.Tables[0]);
            return result;
        }


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string changeStatus(string companyid, string nid, string action, string empid, string projectid, string groupid, string newdate, string status, string remark, string createdby)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();
            ClsScheduleBAL objSch = new ClsScheduleBAL();

            objts.projectid = projectid;
            objts.groupid = groupid;
            objts.empid = empid;
            objts.date = newdate;
            objts.remark = remark;
            objts.Status = status;
            objts.companyId = companyid;
            objts.nid = nid;
            if (action == "one")
                objts.action = "setstatus";
            else
                objts.action = "setgroupstatus";

            ds = objts.schedule();
            string result = "";
            result = objgen.serilizeinJson(ds.Tables[0]);
            return result;
        }



        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string saveSchedule(string action, string companyid, string nid, string empid, string clientid, string fromdate, string todate, string time, string status, string remark, string createdby, string groupid, string projectid, string scheduletype)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();
            ClsScheduleBAL objsch = new ClsScheduleBAL();
            string result = "";

            objts.from = fromdate;
            objts.to = todate;
            objts.clientid = clientid;

            objts.date = time;
            objts.hours = time;
            objts.companyId = companyid;
            objts.CreatedBy = createdby;
            objts.empid = empid;
            objts.projectid = projectid;
            objts.groupid = groupid;
            objts.type = scheduletype;
            objts.Status = status;
            objts.remark = remark;
            objts.nid = nid;

            if (nid != "")
            {
                objts.action = "modify";
                objts.nid = nid;
                ds = objts.schedule();
                result = objgen.serilizeinJson(ds.Tables[0]);
                try
                {
                 //   objsch.sendreschedulemail(ds.Tables[1], companyid);
                }
                catch { }
            }
            else
            {
                ds = objts.insertschedule();
                if (ds.Tables[0].Rows[0]["errormessage"].ToString() == "")
                {
                    if (ds.Tables.Count > 1)
                    {
                        if (ds.Tables[1].Rows.Count > 0)
                        {
                            if (objts.type.ToLower() != "office")
                            {
                                try
                                {
                                   //  objsch.sendreschedulemail(ds.Tables[1], companyid);
                                }
                                catch { }

                            }
                        }
                    }
                    result = @"[{""result"":""1"",""msg"":""""}]";
                }
                else
                {
                    result = @"[{""result"":""0"",""msg"":""" + ds.Tables[0].Rows[0]["errormessage"].ToString() + @"""}]";
                }
            }






            return result;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string UpdateTime(string schduleId, string startDate, string endDate)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();
            ClsScheduleBAL objsch = new ClsScheduleBAL();
            string result = "";

            objts.from = startDate;
            objts.to = endDate;
            objts.nid = schduleId;

            objts.CreatedBy = HttpContext.Current.Session["userid"].ToString().ToLower();
            objts.action = "modifydate";

            ds = objts.schedule();
            result = objgen.serilizeinJson(ds.Tables[0]);


            return result;
        }


        [System.Web.Services.WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static List<Event> GetEvents1(string userid, string companyid)
        {
            List<Event> events = new List<Event>();

            DataAccess objda = new DataAccess();
            DataSet ds = new DataSet();



            objda.empid = userid;
            objda.company = companyid;

            ds = objda.getDashboardCal();
            if (ds.Tables[0].Rows.Count > 0)
            {

                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {

                    string enddate = "";
                    if (Convert.ToDateTime(ds.Tables[0].Rows[i]["startdate"]) != Convert.ToDateTime(ds.Tables[0].Rows[i]["enddate"]))
                    {
                        enddate = Convert.ToDateTime(ds.Tables[0].Rows[i]["enddate"]).ToString("MM/dd/yyyy") + " " + ds.Tables[0].Rows[i]["endtime"].ToString();
                    }
                    if (ds.Tables[0].Rows[i]["eventRepeat"].ToString() != "")
                    {
                        int num = 0;
                        DateTime dt1 = Convert.ToDateTime(ds.Tables[0].Rows[i]["startdate"]);
                        DateTime dt2 = Convert.ToDateTime(ds.Tables[0].Rows[i]["enddate"]);
                        while (dt1 <= dt2)
                        {
                            events.Add(new Event()
                            {
                                NID = ds.Tables[0].Rows[i]["nid"].ToString(),
                                EventID = "event_" + ds.Tables[0].Rows[i]["nid"].ToString(),
                                LayerID = ds.Tables[0].Rows[i]["layerid"].ToString(),
                                EventName = ds.Tables[0].Rows[i]["title"].ToString(),
                                StartDate = dt1.ToString("MM/dd/yyyy") + " " + ds.Tables[0].Rows[i]["starttime"].ToString(),
                                EndDate = dt1.ToString("MM/dd/yyyy") + " " +
                                ds.Tables[0].Rows[i]["endtime"].ToString(),
                                Color = "#" + ds.Tables[0].Rows[i]["color"].ToString(),
                                Userid = ds.Tables[0].Rows[i]["createdby"].ToString(),
                                Description = ds.Tables[0].Rows[i]["eventDes"].ToString(),
                                StartTime = ds.Tables[0].Rows[i]["starttime"].ToString(),
                                recType = "Event",
                                daynum = Convert.ToDateTime(ds.Tables[0].Rows[i]["startdate"]).Day.ToString(),
                                monthnum = Convert.ToDateTime(ds.Tables[0].Rows[i]["startdate"]).Month.ToString(),
                                EndTime = dt1.ToString("MM/dd/yyyy"),
                                date1 = Convert.ToDateTime(ds.Tables[0].Rows[i]["startdate"])

                            });

                            switch (ds.Tables[0].Rows[i]["eventRepeat"].ToString().ToLower())
                            {


                                case "daily":
                                    dt1 = dt1.AddDays(1);
                                    break;
                                case "weekly":
                                    dt1 = dt1.AddDays(7);
                                    break;
                                case "monthly":
                                    dt1 = dt1.AddMonths(1);
                                    break;

                            }
                        }


                    }
                    else
                    {
                        events.Add(new Event()
                        {
                            NID = ds.Tables[0].Rows[i]["nid"].ToString(),
                            EventID = "event_" + ds.Tables[0].Rows[i]["nid"].ToString(),
                            LayerID = ds.Tables[0].Rows[i]["layerid"].ToString(),
                            EventName = ds.Tables[0].Rows[i]["title"].ToString(),
                            StartDate = Convert.ToDateTime(ds.Tables[0].Rows[i]["startdate"]).ToString("MM/dd/yyyy") + " " + ds.Tables[0].Rows[i]["starttime"].ToString(),
                            EndDate = enddate,
                            Color = "#" + ds.Tables[0].Rows[i]["color"].ToString(),
                            Userid = ds.Tables[0].Rows[i]["createdby"].ToString(),
                            Description = ds.Tables[0].Rows[i]["eventDes"].ToString(),
                            recType = "Event",
                            daynum = Convert.ToDateTime(ds.Tables[0].Rows[i]["startdate"]).Day.ToString(),
                            monthnum = Convert.ToDateTime(ds.Tables[0].Rows[i]["startdate"]).Month.ToString(),
                            StartTime = ds.Tables[0].Rows[i]["starttime"].ToString(),
                            EndTime = Convert.ToDateTime(ds.Tables[0].Rows[i]["startdate"]).ToString("MM/dd/yyyy"),
                            date1 = Convert.ToDateTime(ds.Tables[0].Rows[i]["startdate"])

                        });

                    }

                }


            }
            if (ds.Tables[1].Rows.Count > 0)
            {
                for (int i = 0; i < ds.Tables[1].Rows.Count; i++)
                {
                    events.Add(new Event()
                    {
                        NID = ds.Tables[1].Rows[i]["nid"].ToString(),
                        EventID = "schedule_" + ds.Tables[1].Rows[i]["nid"].ToString(),
                        LayerID = "",
                        EventName = ds.Tables[1].Rows[i]["projectCode"].ToString(),
                        StartDate = Convert.ToDateTime(ds.Tables[1].Rows[i]["date"]).ToString("MM/dd/yyyy") + " " + ds.Tables[1].Rows[i]["time"].ToString(),
                        EndDate = "",
                        Color = "#" + "#e0e0e0",
                        Userid = ds.Tables[1].Rows[i]["empid"].ToString(),
                        recType = "Schedule",
                        Description = ds.Tables[1].Rows[i]["empname"].ToString(),
                        classname = "event_sch",
                        daynum = Convert.ToDateTime(ds.Tables[1].Rows[i]["date"]).Day.ToString(),
                        monthnum = Convert.ToDateTime(ds.Tables[1].Rows[i]["date"]).Month.ToString(),
                        StartTime = ds.Tables[1].Rows[i]["time"].ToString(),
                        EndTime = Convert.ToDateTime(ds.Tables[1].Rows[i]["date"]).ToString("MM/dd/yyyy"),
                        date1 = Convert.ToDateTime(ds.Tables[1].Rows[i]["date"])

                    });
                }
            }

            if (ds.Tables[2].Rows.Count > 0)
            {
                for (int i = 0; i < ds.Tables[2].Rows.Count; i++)
                {
                    events.Add(new Event()
                    {
                        NID = ds.Tables[2].Rows[i]["nid"].ToString(),
                        EventID = "app_" + ds.Tables[2].Rows[i]["nid"].ToString(),
                        LayerID = "",
                        EventName = ds.Tables[2].Rows[i]["empname"].ToString(),
                        StartDate = Convert.ToDateTime(ds.Tables[2].Rows[i]["aDate"]).ToString("MM/dd/yyyy") + " " + ds.Tables[2].Rows[i]["frmTime"].ToString(),
                        EndDate = "",
                        Userid = ds.Tables[2].Rows[i]["empid"].ToString(),
                        recType = "Appointment",
                        Description = ds.Tables[2].Rows[i]["vName"].ToString(),
                        classname = "event_app",
                        daynum = Convert.ToDateTime(ds.Tables[2].Rows[i]["aDate"]).Day.ToString(),
                        monthnum = Convert.ToDateTime(ds.Tables[2].Rows[i]["aDate"]).Month.ToString(),
                        StartTime = ds.Tables[2].Rows[i]["frmTime"].ToString(),
                        EndTime = Convert.ToDateTime(ds.Tables[2].Rows[i]["aDate"]).ToString("MM/dd/yyyy"),
                        date1 = Convert.ToDateTime(ds.Tables[2].Rows[i]["aDate"])

                    });
                }
            }
            List<Event> SortedList = events.OrderBy(o => o.date1).ToList();
            return SortedList;
        }



        [System.Web.Services.WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static List<Event> GetEvents(string userid, string companyid,
          string status, string client, string project, string employee)
        {
            List<Event> events = new List<Event>();
            DataAccess objda = new DataAccess();
            DataSet ds = new DataSet();
            objda.empid = userid;
            objda.company = companyid;
            objda.clientid = client;
            objda.projectid = project;
            objda.employee = employee;
            objda.status = status;
            ds = objda.getScheduleCalendar();
             
            if (ds.Tables[0].Rows.Count > 0)
            {
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    events.Add(new Event()
                    {

                        StartDate = Convert.ToDateTime(ds.Tables[0].Rows[i]["date"]).ToString("MM/dd/yyyy") + " " + ds.Tables[0].Rows[i]["time"].ToString(),
                        EndDate = Convert.ToDateTime(ds.Tables[0].Rows[i]["enddate"]).ToString("MM/dd/yyyy") + " " + ds.Tables[0].Rows[i]["endtime"].ToString(),
                        clientid = ds.Tables[0].Rows[i]["clientid"].ToString(),
                        EventName = ds.Tables[0].Rows[i]["projectCode"].ToString(),
                        empid = "",// ds.Tables[0].Rows[i]["empid"].ToString(),
                        NID = ds.Tables[0].Rows[i]["nid"].ToString(),
                        //NID = ds.Tables[0].Rows[i]["nid"].ToString(),
                        //EventID = "schedule_" + ds.Tables[0].Rows[i]["nid"].ToString(),
                        //LayerID = "",
                        //EventName = ds.Tables[0].Rows[i]["projectCode"].ToString(),
                        //StartDate = Convert.ToDateTime(ds.Tables[0].Rows[i]["date"]).ToString("MM/dd/yyyy") + " " + ds.Tables[0].Rows[i]["time"].ToString(),
                        //EndDate = "",
                        //Color = "#" + "#e0e0e0",
                        //Userid = ds.Tables[0].Rows[i]["empid"].ToString(),
                        //recType = "Schedule",
                        //Description = ds.Tables[0].Rows[i]["empname"].ToString(),
                        //classname = "event_sch",
                        //clientid = ds.Tables[0].Rows[i]["clientid"].ToString(),
                        //daynum = Convert.ToDateTime(ds.Tables[0].Rows[i]["date"]).Day.ToString(),
                        //monthnum = Convert.ToDateTime(ds.Tables[0].Rows[i]["date"]).Month.ToString(),
                        //StartTime = ds.Tables[0].Rows[i]["time"].ToString(),
                        //EndTime = Convert.ToDateTime(ds.Tables[0].Rows[i]["date"]).ToString("MM/dd/yyyy"),
                        //date1 = Convert.ToDateTime(ds.Tables[0].Rows[i]["date"])

                    });
                }
            }

           
            List<Event> SortedList = events.OrderBy(o => o.date1).ToList();
            return SortedList;
        }

        
    }
}