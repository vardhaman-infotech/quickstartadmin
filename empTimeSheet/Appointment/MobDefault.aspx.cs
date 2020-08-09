using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.Services;
using System.Web.Script.Services;
using System.Web.UI.HtmlControls;
using System.IO;

namespace empTimeSheet.Appointment
{
    public partial class MobDefault : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (Request.QueryString["company"] != null)
                {
                    ClsAdmin objda = new ClsAdmin();
                    DataSet ds = new DataSet();
                    objda.code = Request.QueryString["company"].ToString();
                    ds = objda.getCompanybyCode();
                    if (ds.Tables[0].Rows.Count == 0)
                    {
                        Response.Redirect("error.html");
                    }
                    else
                    {
                        this.Page.Title = ds.Tables[0].Rows[0]["companyname"].ToString();
                        litcompanyname.Text = ds.Tables[0].Rows[0]["companyname"].ToString();
                        litcompanyname2.Text = ds.Tables[0].Rows[0]["companyname"].ToString();
                    
                        ((HtmlImage)this.Master.FindControl("imglogo")).Src = "../webfile/" + ds.Tables[0].Rows[0]["logoURL"].ToString();
                        app_hid_company.Value = ds.Tables[0].Rows[0]["nid"].ToString();
                    }

                }
                else
                {
                    Response.Redirect("error.html");
                }
                fillemp();
            }
        }
        public void fillemp()
        {
            DataSet ds = new DataSet();
            ClsAppointment obj = new ClsAppointment();
            obj.action = "getEmployee";
            obj.companyid = app_hid_company.Value;
            ds = obj.APP_ManageAvailability();
            dropcontactperson.DataSource = ds;
            dropcontactperson.DataTextField = "fullname";
            dropcontactperson.DataValueField = "nid";
            dropcontactperson.DataBind();

            dropcontactperson.Items.Insert(0, new ListItem("-Select--", ""));



        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getEmpAvailabilitybyid(string nid)
        {
            string msg = "failure";
            GeneralMethod objgen = new GeneralMethod();
            DataSet ds = new DataSet();
            ClsAppointment obj = new ClsAppointment();

            try
            {
                obj.action = "select";

                obj.nid = nid;


                ds = obj.APP_ManageAvailability();
                msg = objgen.serilizeinJson(ds.Tables[0]);
                return msg;
            }
            catch { return msg; }



        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getEmpAvailability(string empid)
        {
            string msg = "failure";
            GeneralMethod objgen = new GeneralMethod();
            DataSet ds = new DataSet();
            ClsAppointment obj = new ClsAppointment();

            try
            {
                obj.aDate = GeneralMethod.getLocalDate();

                obj.empid = empid;


                ds = obj.APP_getAvailability();
                msg = ds.Tables[0].Rows[0][0].ToString();
                return msg;
            }
            catch { return msg; }



        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string saveEmpAvailability(string sloatid, string empid, string aDate, string frmTime, string ToTime, string vName, string designation, string company, string email, string contactno, string service)
        {
            string msg = "failure";
            GeneralMethod objgen = new GeneralMethod();
            DataSet ds = new DataSet();
            ClsAppointment obj = new ClsAppointment();

            DataAccess objda = new DataAccess();
            try
            {
                DateTime timetotime = new DateTime();
                string totime;
                timetotime = Convert.ToDateTime(aDate + " " + frmTime);
                timetotime = timetotime.AddHours(1);

                totime = timetotime.ToString(@"hh:mm:ss tt", new System.Globalization.CultureInfo("en-US")).ToLower();

                obj.aDate = aDate;
                obj.afrmTime = frmTime;

                obj.aToTime = string.Join("", totime.Split(default(string[]), StringSplitOptions.RemoveEmptyEntries));
                obj.vname = vName;
                obj.desig = designation;
                obj.companyid = company;
                obj.email = email;
                obj.contact = contactno;
                obj.service = service;
                obj.nid = "";
                obj.status = "Pending";
                obj.sloatid = sloatid;
                obj.empid = empid;
                obj.action = "insert";
                ds = obj.APP_ManageAppointment_new();

                if (ds.Tables[0].Rows.Count > 0)
                {
                    try
                    {
                        string HTMLTemplatePath = HttpContext.Current.Server.MapPath("~/EmailTemplates/appointmentReqForAdmin.htm");
                        string HTMLBODY = File.Exists(HTMLTemplatePath) ? File.ReadAllText(HTMLTemplatePath) : "";
                        HTMLBODY = HTMLBODY.Replace(@"##logourl##", ds.Tables[0].Rows[0]["schedulerURL"].ToString() + "/webfile/" + ds.Tables[0].Rows[0]["logourl"].ToString());
                        HTMLBODY = HTMLBODY.Replace("##company##", ds.Tables[0].Rows[0]["companyname"].ToString());
                        HTMLBODY = HTMLBODY.Replace("##date##", ds.Tables[0].Rows[0]["adate1"].ToString() + " " + ds.Tables[0].Rows[0]["frmTime"].ToString().Replace("am", " AM").Replace("pm", " PM"));

                        HTMLBODY = HTMLBODY.Replace("##Date##", ds.Tables[0].Rows[0]["adate1"].ToString());
                        HTMLBODY = HTMLBODY.Replace(" ##purpose##", ds.Tables[0].Rows[0]["service"].ToString());
                        HTMLBODY = HTMLBODY.Replace(" ##visitorname##", ds.Tables[0].Rows[0]["vName"].ToString());
                        HTMLBODY = HTMLBODY.Replace("##empname##", ds.Tables[0].Rows[0]["empname"].ToString());
                        HTMLBODY = HTMLBODY.Replace("##company##", ds.Tables[0].Rows[0]["company"].ToString());
                        HTMLBODY = HTMLBODY.Replace("##email##", ds.Tables[0].Rows[0]["email"].ToString());
                        HTMLBODY = HTMLBODY.Replace("##contact##", ds.Tables[0].Rows[0]["contactno"].ToString());
                        HTMLBODY = HTMLBODY.Replace(@"##appurl##", ds.Tables[0].Rows[0]["schedulerURL"].ToString() + "/Appoint_ViewAppointments.aspx?appointmentid=" + ds.Tables[0].Rows[0]["nid"].ToString());

                        string msg1 = objda.SendAppEmail(ds.Tables[0].Rows[0]["empemail"].ToString() + ",", "New Appointment Request for Date " + ds.Tables[0].Rows[0]["adate1"].ToString(), HTMLBODY, "garima.pathak@harshwal.com,", "", "", ds.Tables[0].Rows[0]["company"].ToString());
                        if (msg1 == "Sent")
                        {
                        }
                    }
                    catch
                    {

                    }

                }
                msg = "1";
                return msg;
            }
            catch { return msg; }



        }
    }
}