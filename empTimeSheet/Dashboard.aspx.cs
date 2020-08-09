using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using System.Web.UI.DataVisualization.Charting;
using System.Drawing;
using System.Web.Services;
using System.Web.Script.Services;
using System.Text;

namespace timeSheet
{
    public partial class Dashboard : System.Web.UI.Page
    {
        ClsUser objuser = new ClsUser();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();
        DataSet ds2 = new DataSet();
        DataAccess objda = new DataAccess();
        ClsTimeSheet objts = new ClsTimeSheet();
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();

            objda.id = Session["userid"].ToString();
            ds = objda.getUserInRoles();


            if (objda.validatedRoles("99", ds))
            {
                Dashboard_hidAddEvent.Value = "1";
            }
            if (objda.validatedRoles("100", ds))
            {
                Dashboard_hidAddPEvent.Value = "1";
            }

            if (!objda.validatedRoles("5", ds) && !objda.validatedRoles("6", ds))
            {
                lnkclient.Visible = false;
            }
            if (!objda.validatedRoles("5", ds) && !objda.validatedRoles("6", ds))
            {
                lnkemp.Visible = false;
            }
            if (!objda.validatedRoles("5", ds) && !objda.validatedRoles("6", ds))
            {
                lnkclient.Visible = false;
            }
            if (!objda.validatedRoles("5", ds) && !objda.validatedRoles("6", ds))
            {
                lnkclient.Visible = false;
            }

            if (!IsPostBack)
            {
                bindprojects();
                //  bindgradeschart();
                bindlayer();
            }
            //    bindannouncement();
            //    bindschedules();
            //    //linktodaydate.Text = "Today date: " + GeneralMethod.getdatetime();
            //    Calendar1.TodaysDate = Convert.ToDateTime(GeneralMethod.getdatetime());
            //}

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
        public void bindperformancechart()
        {

        }

        /// <summary>
        /// Bind list of announcements
        /// </summary>
        //protected void bindannouncement()
        //{
        //    objda.dob = GeneralMethod.getLocalDate();
        //    objda.company = Session["companyid"].ToString();
        //    objda.action = "selectfordashboard";
        //    ds = objda.AnnouncementMaster();
        //    if (ds.Tables[0].Rows.Count > 0)
        //    {
        //        rptannouncement.DataSource = ds;
        //        rptannouncement.DataBind();
        //    }
        //    else
        //    {
        //        rptannouncement.DataSource = null;
        //        rptannouncement.DataBind();
        //    }
        //}

        ///// <summary>
        ///// Bind Top 10 Recently assigned tasks
        ///// </summary>
        //protected void bindschedules()
        //{
        //    if (objda.checkUserInroles("7"))
        //    {
        //        objts.empid = "";
        //        //Check whether logged user have right for view Other's assigned tasks or not
        //        //If user have right to see other's assigned tasks then show all the assigned tasks on dashborad
        //        if (objda.checkUserInroles("15"))
        //        {
        //            objts.CreatedBy = "";
        //        }
        //        else
        //        {
        //            //if user is manager but do not have right to see other's assigned tasks then pass CREATEDBY to its own id
        //            //This will fetch the data by manager
        //            objts.CreatedBy = Session["userid"].ToString();
        //        }
        //    }
        //    else
        //    {
        //        objts.empid = Session["userid"].ToString();
        //    }

        //    objts.action = "selectfordashboard";
        //    ds = objts.AssignTasks();
        //    if (ds.Tables[0].Rows.Count > 0)
        //    {
        //        rptdata.DataSource = ds;
        //        rptdata.DataBind();
        //    }
        //}

        ////---------------------------CALENDAR----------------------------

        ////Bind calendar date as current date when user clicks on Today date link
        //protected void linktodaydate_Click(object sender, EventArgs e)
        //{
        //    Calendar1.VisibleDate = Convert.ToDateTime(GeneralMethod.getdatetime());
        //}

        ////Bind event Schedule and Task's list on date selection
        //protected void Calendar1_SelectionChanged(object sender, EventArgs e)
        //{
        //    fillgrid();
        //}

        ///// <summary>
        ///// fill events for selected date on calendar by user
        ///// </summary>
        //public void fillgrid()
        //{
        //    objts.from = Calendar1.SelectedDate.ToString("MM/dd/yyyy");
        //    objts.to = Calendar1.SelectedDate.ToString("MM/dd/yyyy");
        //    objts.nid = "";
        //    objts.action = "selectforhome";
        //    objts.companyId = Session["CompanyId"].ToString();
        //    if (objda.checkUserInroles("5"))
        //    {
        //        objts.empid = "";
        //    }
        //    else
        //    {
        //        objts.empid = Session["userid"].ToString();
        //    }
        //    if (objda.checkUserInroles("7"))
        //    {
        //        objts.managerId = "";
        //    }
        //    else
        //    {
        //        objts.managerId = Session["userid"].ToString();
        //    }
        //    ds = objts.GetCalendar();
        //    if (ds.Tables[0].Rows.Count > 0)
        //    {
        //        repeatorevent.DataSource = ds.Tables[1];
        //        repeatorevent.DataBind();
        //        divmsg.InnerHtml = "";
        //        repeatorevent.Visible = true;
        //    }
        //    else
        //    {
        //        divmsg.InnerHtml = "No event exists at selected date.";
        //        repeatorevent.Visible = false;
        //    }
        //    //pop up list of events
        //    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>openeventdiv();</script>", false);
        //}


        ////When calendar renders, bind events for given month
        //protected void Calendar1_DayRender(object sender, DayRenderEventArgs e)
        //{
        //    int status = 0;
        //    if (e.Day.Date != Calendar1.TodaysDate)
        //        e.Cell.CssClass = "calitem";
        //    if (ds2.Tables.Count == 0)
        //    {
        //        DateTime dt = e.Day.Date.AddDays(7);
        //        var thisMonthStart = dt.AddDays(1 - dt.Day);

        //        var thisMonthEnd = thisMonthStart.AddMonths(1).AddSeconds(-1);

        //        objts.from = thisMonthStart.ToString("MM/dd/yyyy");
        //        objts.to = thisMonthEnd.ToString("MM/dd/yyyy");
        //        objts.companyId = Session["CompanyId"].ToString();
        //        if (objda.checkUserInroles("5"))
        //        {
        //            objts.empid = "";
        //        }
        //        else
        //        {
        //            objts.empid = Session["userid"].ToString();
        //        }
        //        if (objda.checkUserInroles("7"))
        //        {
        //            objts.managerId = "";
        //        }
        //        else
        //        {
        //            objts.managerId = Session["userid"].ToString();
        //        }

        //        objts.action = "selectforhome";
        //        ds2 = objts.GetCalendar();
        //    }
        //    if (ds2.Tables[0].Rows.Count > 0)
        //    {
        //        string events = "";

        //        foreach (DataRow dr in ds2.Tables[1].Select("startdate = '" + e.Day.Date.ToString() + "'"))
        //        {
        //            events += "<li>" + dr["title"].ToString() + "</li>";
        //        }

        //        for (int i = 0; i < ds2.Tables[0].Rows.Count; i++)
        //        {
        //            DateTime matchdate = Convert.ToDateTime(ds2.Tables[0].Rows[i]["startdate"].ToString());
        //            if (e.Day.Date == matchdate)
        //            {

        //                //if (e.Day.Date != Calendar1.TodaysDate)
        //                e.Cell.CssClass = "caleventback";

        //                e.Cell.ID = "<ul>" + events + "</ul>";

        //            }

        //        }
        //    }
        //}

        /// <summary>
        /// Bind projects status 
        /// </summary>
        protected void bindprojects()
        {
            //objts.action = "getprojectstatus";
            //objts.empid = Session["userid"].ToString();
            //ds = objts.AssignTasks();
            //if (ds.Tables[0].Rows.Count > 0)
            //{
            //    rptprojectstatus.DataSource = ds;
            //    rptprojectstatus.DataBind();
            //}
            //else
            //{
            //    rptprojectstatus.DataSource = null;
            //    rptprojectstatus.DataBind();
            //}
        }
        protected void rptprojectstatus_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                decimal projectcompletionstatus = Convert.ToDecimal(DataBinder.Eval(e.Item.DataItem, "projectstatus").ToString());
                HtmlGenericControl divprogressbar = (HtmlGenericControl)e.Item.FindControl("divprogressbar");
                divprogressbar.Style.Add("width", projectcompletionstatus + "%");
                if (projectcompletionstatus == 100)
                {
                    divprogressbar.Attributes.Add("class", "progress-bar progress-bar-primary");
                }
                else if (projectcompletionstatus > 90)
                {
                    divprogressbar.Attributes.Add("class", "progress-bar progress-bar-warning");

                }
                else if (projectcompletionstatus > 10)
                {
                    divprogressbar.Attributes.Add("class", "progress-bar progress-bar-success");

                }
                else
                {
                    divprogressbar.Attributes.Add("class", "progress-bar progress-bar-danger");

                }
            }
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
        public static List<Event> AddNewEvent(string nid, string title, string description, string dob, string time1, string dob2, string time2, string isalldayevent, string eventttype, string loginid, string layerid, string repeat, string location,string companyid)
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
        public static List<Event> GetEvents1(string userid, string nid,string companyid)
        {
            List<Event> events = new List<Event>();

            DataAccess objda = new DataAccess();
            DataSet ds = new DataSet();

            objda.id = nid;
            objda.action = "select";
            objda.loginid = userid;
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
                        int num = 0;
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


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]

        public static string resettasknotification(string userid, string companyid)
        {

            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();
            string msg = "";
            msg = "failure";
            objts.action = "setstatusasread";
            objts.empid = userid;
            objts.AssignTasks();
            try
            {

                objts.action = "getcountofunreadnoti";
                objts.companyId = companyid;
                ds = objts.AssignTasks();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    if (ds.Tables[0].Rows[0]["numofnotification"].ToString() == "0")
                    {
                        msg = "";
                    }
                    else
                        msg = ds.Tables[0].Rows[0]["numofnotification"].ToString();
                }
                return msg;
            }
            catch (Exception ex)
            {
                msg = ex.Message;
                return msg;
            }

        }


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]

        public static string resetnotification(string userid, string companyid)
        {

            DataAccess objda = new DataAccess();
            DataSet ds = new DataSet();
            string msg = "";
            msg = "failure";
            objda.action = "setstatusasread";
            objda.loginid = userid;
            objda.AnnouncementMaster();
            try
            {
                objda.loginid = userid;
                objda.action = "getcountofunreadnoti";
                objda.company = companyid;
                ds = objda.AnnouncementMaster();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    if (ds.Tables[0].Rows[0]["numofnotification"].ToString() == "0")
                    {
                        msg = "";
                    }
                    else
                        msg = ds.Tables[0].Rows[0]["numofnotification"].ToString();
                }
                return msg;
            }
            catch (Exception ex)
            {
                msg = ex.Message;
                return msg;
            }

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]

        public static string binddetail(string id, string companyid)
        {
            StringBuilder sb = new StringBuilder();
            DataAccess objda = new DataAccess();
            DataSet ds = new DataSet();
            string[] notival = new string[4];
            objda.id = id;
            objda.company = companyid;
            objda.action = "select";
            ds = objda.AnnouncementMaster();
            if (ds.Tables[0].Rows.Count > 0)
            {
                sb.Append(ds.Tables[0].Rows[0]["title"].ToString() + "###");
                sb.Append(ds.Tables[0].Rows[0]["description"].ToString() + "###");
                sb.Append(ds.Tables[0].Rows[0]["name"].ToString() + "###");
                sb.Append(ds.Tables[0].Rows[0]["adddate"].ToString() + "###");
                if (ds.Tables[0].Rows[0]["imagePath"].ToString() == null || ds.Tables[0].Rows[0]["imagePath"].ToString() == "")
                {
                    sb.Append("images/Announcement/calendar.png" + "###");
                }
                else
                {
                    sb.Append("images/Announcement/" + ds.Tables[0].Rows[0]["imagePath"].ToString() + "###");
                }
            }

            return sb.ToString();
        }



        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]

        public static string bindtasknoti(string userid, string companyid)
        {

            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();
            string msg = "";
            msg = "failure";
            try
            {

                objts.empid = userid;
                objts.action = "gettasknoti";
                objts.companyId = companyid;
                ds = objts.AssignTasks();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    msg = ds.Tables[0].Rows[0]["tasknoti"].ToString();
                }
                else
                {
                    msg = "";
                }
                return msg;
            }
            catch (Exception ex)
            {
                msg = ex.Message;
                return msg;
            }

        }


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getDashboardNotification(string userid, string companyid)
        {

            DataAccess objda = new DataAccess();
            DataSet ds = new DataSet();
            string msg = "";
         
            try
            {

                objda.loginid = userid;
                objda.action = "getDashboardNotification";
                objda.company = companyid;
                ds = objda.AnnouncementMaster();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                    {
                        string imgurl = "images/Announcement/colorwheel.png";

                        if (ds.Tables[0].Rows[i]["imagePath"] != null && ds.Tables[0].Rows[i]["imagePath"].ToString() != "")
                        {
                            imgurl = "images/Announcement/" + ds.Tables[0].Rows[i]["imagePath"].ToString();
                        }
                       
                        string strr = ds.Tables[0].Rows[i]["displaydate"].ToString();
                        string[] date = strr.Split(new char[] { '/' });


                        msg += @"<li onclick='getNoti(" + ds.Tables[0].Rows[i]["nid"].ToString() + ");'><div  class='aicon'> <img  src='" + imgurl + @"' />
                         </div> <div id='divTitle' class='acontent'><h3>" + ds.Tables[0].Rows[i]["title"].ToString() + @"</h3>
 <p class='AnnounceDesc'> " + ds.Tables[0].Rows[i]["description1"].ToString() + @" </p>
</div>
                      
                        <div class='adate'><h4 >" + Convert.ToDateTime(ds.Tables[0].Rows[i]["displaydate"]).Day.ToString() + @"</h4><h5 >" + System.Globalization.CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(Convert.ToDateTime(ds.Tables[0].Rows[i]["displaydate"]).Month) + @"</h5>  </div><div class='clear'></div>";

                    }

                  
                }
                else
                {
                    msg = "";
                }
                return msg;
            }
            catch (Exception ex)
            {
       msg = "failure"; 
                return msg;
            }

        }


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]

        public static string bindannouncenoti(string userid, string companyid)
        {

            DataAccess objda = new DataAccess();
            DataSet ds = new DataSet();
            string msg = "";
            msg = "failure";
            try
            {

                objda.loginid = userid;
                objda.action = "getannouncenoti";
                objda.company = companyid;
                ds = objda.AnnouncementMaster();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    msg = ds.Tables[0].Rows[0]["announcenoti"].ToString();
                }
                else
                {
                    msg = "";
                }
                return msg;
            }
            catch (Exception ex)
            {
                msg = ex.Message;
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
        public static string TimesheetforDashboard(string empid,string companyid,string lastnid,string nid)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            GeneralMethod objgen = new GeneralMethod();

            DataSet ds = new DataSet();
            string msg = "failure";
            try
            {


                objts.action = "select";
                objts.empid = empid;
                objts.nid = nid;
                objts.companyId = companyid;
                objts.id = lastnid;
                ds = objts.TimesheetforDashboard();
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
        public static string getLeaveDetail(string empid)
        {
            ClsPayroll objpayroll = new ClsPayroll();
            GeneralMethod objgen = new GeneralMethod();

            DataSet ds = new DataSet();
            string msg = "failure";
            try
            {


                objpayroll.action = "getleavedetail";
                objpayroll.Date = GeneralMethod.getLocalDate();
                objpayroll.loginid = empid;
                ds = objpayroll.LeaveRequest();
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
        public static string getEmpMonthlyDetail(string empid)
        {
            DataAccess objda = new DataAccess();
            GeneralMethod objgen = new GeneralMethod();
            
            DataSet ds = new DataSet();
            string msg = "failure";
            try
            {
               
                objda.id =Convert.ToDateTime(GeneralMethod.getLocalDate()).Year.ToString();
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

    }
}