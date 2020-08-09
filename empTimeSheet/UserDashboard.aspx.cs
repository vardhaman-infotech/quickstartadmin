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
using System.Web.UI.HtmlControls;

namespace empTimeSheet
{
    public partial class UserDashboard : System.Web.UI.Page
    {
        DataSet ds = new DataSet();
        DataAccess objda = new DataAccess();
        protected void Page_Load(object sender, EventArgs e)
        {

            GeneralMethod objgen = new GeneralMethod();
            objgen.validatelogin();

            objda.id = Session["userid"].ToString();
            ds = objda.getUserInRoles();

            if (objda.checkUserInroles("99"))
            {
                Dashboard_hidAddEvent.Value = "1";
            }
            if (objda.checkUserInroles("100"))
            {
                Dashboard_hidAddPEvent.Value = "1";
            }

            if (!IsPostBack)
            {

                bindlayer();
            }

        }
        protected void replayer_ItemDataBound(object sender, DataListItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {


                HtmlInputRadioButton chknchecklayer = (HtmlInputRadioButton)e.Item.FindControl("radionLayer");


                chknchecklayer.Attributes.Add("onclick", "seteventcolor(" + DataBinder.Eval(e.Item.DataItem, "nid").ToString() + ",this);");
            }
        }

        public void bindlayer()
        {
            ds = objda.LayerMaster();
            if (ds.Tables[0].Rows.Count > 0)
            {
                replayer.DataSource = ds;
                replayer.DataBind();
            }

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getEmpMonthlyDetail(string empid)
        {
            DataAccess objda = new DataAccess();
            GeneralMethod objgen = new GeneralMethod();

            DataSet ds = new DataSet();
            string msg = "failure";
            try
            {

                objda.id = Convert.ToDateTime(GeneralMethod.getLocalDate()).Year.ToString();
                objda.empid = empid;
                ds = objda.getEmptimeMonthwise();
                msg = objgen.serilizeinJson(ds.Tables[0]);
                return msg;
            }
            catch (Exception ex)
            {
                //msg = ex.Message.ToString();
                return msg;
            }

        }


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getChartReport(string action, string companyid)
        {
            DataAccess objda = new DataAccess();
            GeneralMethod objgen = new GeneralMethod();

            DataSet ds = new DataSet();
            string msg = "failure";
            try
            {

                objda.id = Convert.ToDateTime(GeneralMethod.getLocalDate()).Year.ToString();
                objda.action = action;
                objda.id = DateTime.Now.Year.ToString();
                objda.company = companyid;
                ds = objda.getchartreport();
                msg = objgen.serilizeinJson(ds.Tables[0]);
                return msg;
            }
            catch (Exception ex)
            {
                //msg = ex.Message.ToString();
                return msg;
            }

        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getEmpProcess(string empid)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            GeneralMethod objgen = new GeneralMethod();

            DataSet ds = new DataSet();
            string msg = "failure";
            try
            {


                objts.empid = empid;
                objts.action = "gettaskssummary";
                ds = objts.AssignTasks();
                msg = objgen.serilizeinJson(ds.Tables[0]);
                return msg;
            }
            catch (Exception ex)
            {
                //msg = ex.Message.ToString();
                return msg;
            }

        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getInvoices(string companyid)
        {
            ClsTimeSheet objda = new ClsTimeSheet();
            GeneralMethod objgen = new GeneralMethod();

            DataSet ds = new DataSet();
            string msg = "failure";
            try
            {


                objda.action = "latest";
                objda.id = DateTime.Now.Year.ToString();
                objda.companyId = companyid;
                ds = objda.GetInvoice();
                msg = objgen.serilizeinJson(ds.Tables[0]) + "###" + objgen.serilizeinJson(ds.Tables[1]) + "###" + objgen.serilizeinJson(ds.Tables[2]);
                return msg;
            }
            catch (Exception ex)
            {
                //msg = ex.Message.ToString();
                return msg;
            }

        }

        [System.Web.Services.WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static List<Event> getEventDetail(string nid)
        {
            List<Event> events = new List<Event>();

            DataAccess objda = new DataAccess();
            DataSet ds = new DataSet();

            objda.id = nid;
            objda.action = "select";


            ds = objda.manageEvents();
            if (ds.Tables[0].Rows.Count > 0)
            {
                string enddate = "";

                if (ds.Tables[0].Rows[0]["enddate"].ToString() != ds.Tables[0].Rows[0]["starttime"].ToString())
                {
                    enddate = Convert.ToDateTime(ds.Tables[0].Rows[0]["enddate"]).ToString("MM/dd/yyyy");

                }
                events.Add(new Event()
                {
                    NID = ds.Tables[0].Rows[0]["nid"].ToString(),
                    EventID = ds.Tables[0].Rows[0]["nid"].ToString(),
                    LayerID = ds.Tables[0].Rows[0]["layerid"].ToString(),
                    EventName = ds.Tables[0].Rows[0]["title"].ToString(),
                    StartDate = Convert.ToDateTime(ds.Tables[0].Rows[0]["startdate"]).ToString("MM/dd/yyyy"),
                    EndDate = enddate,
                    Color = ds.Tables[0].Rows[0]["css"].ToString(),
                    Userid = ds.Tables[0].Rows[0]["createdby"].ToString(),
                    StartTime = ds.Tables[0].Rows[0]["starttime"].ToString(),
                    EndTime = ds.Tables[0].Rows[0]["endtime"].ToString(),
                    Description = ds.Tables[0].Rows[0]["eventDes"].ToString(),
                    createdbyName = ds.Tables[0].Rows[0]["createdbyName"].ToString(),
                    eventtype = ds.Tables[0].Rows[0]["eventtype"].ToString(),
                    eventrepeat = ds.Tables[0].Rows[0]["eventrepeat"].ToString(),
                    Location = ds.Tables[0].Rows[0]["location"].ToString(),
                    AllDayEvent = ds.Tables[0].Rows[0]["isalldayevent"].ToString()

                });




            }


            return events;
        }
        [System.Web.Services.WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static List<Event> AddNewEvent(string nid, string title, string description, string dob, string time1, string dob2, string time2, string isalldayevent, string eventttype, string loginid, string layerid, string repeat, string location, string companyid)
        {
            List<Event> events = new List<Event>();

            DataAccess objda = new DataAccess();
            DataSet ds = new DataSet();
            objda.id = nid;
            objda.action = "insert";
            objda.title = title;
            objda.description = description;
            objda.dob = dob;
            objda.time1 = time1.Replace("p", " p").Replace("a", " ");
            objda.dob2 = dob2;
            objda.time2 = time2.Replace("p", " p").Replace("a", " ");
            objda.location = location;
            objda.isalldayevent = isalldayevent;
            if (isalldayevent == "1")
            {
                objda.time1 = "";
                objda.time2 = "";

            }
            objda.eventttype = eventttype;
            objda.loginid = loginid;
            objda.layerid = layerid;
            objda.eventRepeat = repeat;
            objda.company = companyid;
            ds = objda.manageEvents();
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

                        DateTime dt1 = Convert.ToDateTime(ds.Tables[0].Rows[i]["startdate"]);
                        DateTime dt2 = Convert.ToDateTime(ds.Tables[0].Rows[i]["enddate"]);
                        while (dt1 <= dt2)
                        {
                            events.Add(new Event()
                            {
                                NID = ds.Tables[0].Rows[i]["nid"].ToString(),
                                EventID = ds.Tables[0].Rows[i]["nid"].ToString(),
                                LayerID = ds.Tables[0].Rows[i]["layerid"].ToString(),
                                EventName = ds.Tables[0].Rows[i]["title"].ToString(),
                                StartDate = dt1.ToString("MM/dd/yyyy") + " " + ds.Tables[0].Rows[i]["starttime"].ToString(),
                                EndDate = dt1.ToString("MM/dd/yyyy") + " " +
                                ds.Tables[0].Rows[i]["endtime"].ToString(),
                                Color = "#" + ds.Tables[0].Rows[i]["color"].ToString(),
                                Userid = ds.Tables[0].Rows[i]["createdby"].ToString()

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
                            EventID = ds.Tables[0].Rows[i]["nid"].ToString(),
                            LayerID = ds.Tables[0].Rows[i]["layerid"].ToString(),
                            EventName = ds.Tables[0].Rows[i]["title"].ToString(),
                            StartDate = Convert.ToDateTime(ds.Tables[0].Rows[i]["startdate"]).ToString("MM/dd/yyyy") + " " + ds.Tables[0].Rows[i]["starttime"].ToString(),
                            EndDate = enddate,
                            Color = "#" + ds.Tables[0].Rows[i]["color"].ToString(),
                            Userid = ds.Tables[0].Rows[i]["createdby"].ToString()

                        });

                    }
                }
            }
            return events;

        }

        [System.Web.Services.WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string updateevent(string eventid, string eventdate, string enddate, string userid)
        {
            string msg = "", date, date1 = "", time1 = "", time2 = "";
            DataAccess objda = new DataAccess();
            DataSet ds = new DataSet();
            objda.id = eventid;

            date = eventdate.Replace('T', ' ');
            date = date.Substring(0, 16);
            date = Convert.ToDateTime(date).ToString("MM/dd/yyyy");

            if (enddate != "")
            {
                date1 = enddate.Replace('T', ' ');
                date1 = date1.Substring(0, 16);
                date1 = Convert.ToDateTime(date1).ToString("MM/dd/yyyy");

            }

            objda.dob = date;
            objda.dob2 = date1;
            objda.action = "moveevent";
            objda.loginid = userid;
            objda.time1 = time1;
            objda.time2 = time2;

            try
            {
                ds = objda.manageEvents();
                if (ds.Tables.Count > 0)
                    msg = "notallowed";
                else
                    msg = "success";
            }
            catch { }
            return msg;

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
        public static string deleteevent(string nid)
        {
            string msg = "";
            DataAccess objda = new DataAccess();
            DataSet ds = new DataSet();

            objda.id = nid;
            objda.action = "delete";
            try
            {
                ds = objda.manageEvents();
            }
            catch (Exception ex)
            {

                msg = ex.ToString();
            }
            return msg;



        }


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getSchDetailData(string companyid, string nid)
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
        public static string getAppointments(string nid, string fromdate, string todate, string status, string companyid)
        {
            string msg = "failure";
            GeneralMethod objgen = new GeneralMethod();
            DataSet ds = new DataSet();
            ClsAppointment obj = new ClsAppointment();

            try
            {
                obj.fromdate = fromdate;
                obj.todate = todate;
                obj.companyid = companyid;
                obj.status = status;
                obj.nid = nid;
                obj.action = "select";
                ds = obj.APP_ManageAppointment_new();
                msg = objgen.serilizeinJson(ds.Tables[0]);
                return msg;
            }
            catch { return msg; }



        }
    }
}