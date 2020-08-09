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


namespace empTimeSheet
{
    public partial class Appoint_ViewAppointments : System.Web.UI.Page
    {
        GeneralMethod objgen = new GeneralMethod();
        DataAccess objda = new DataAccess();
        ClsAppointment obj = new ClsAppointment();
        DataSet ds = new DataSet();
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {

                txtfrom.Text = GeneralMethod.getEmpDate();
                txtto.Text = DateTime.Now.AddDays(15).ToString("MM/dd/yyyy");
                appointment_minDate.Value = txtfrom.Text;

                //role 9 indicates Approve Task
                if (!objda.checkUserInroles("108"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }

                if (Request.QueryString["appointmentid"] != null)
                {
                    obj.fromdate = "";
                    obj.todate = "";
                    obj.companyid = "";
                    obj.status = "";
                    obj.nid = Request.QueryString["appointmentid"].ToString();
                    obj.action = "select";
                    ds = obj.APP_ManageAppointment_new();
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>openstatus(" + Request.QueryString["appointmentid"].ToString() + ");</script>", false);
                    }

                }
            }
        }



        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string savestatus(string aDate, string frmTime, string ToTime, string status, string nid)
        {
            string msg = "failure";
            GeneralMethod objgen = new GeneralMethod();
            DataSet ds = new DataSet();
            ClsAppointment obj = new ClsAppointment();
            DataAccess objda = new DataAccess();

            try
            {

                obj.aDate = aDate;
                obj.afrmTime = frmTime;
                obj.aToTime = ToTime;

                obj.nid = nid;
                obj.status = status;
                obj.action = "setstatus";
                ds = obj.APP_ManageAppointment_new();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    try
                    {
                        string HTMLTemplatePath = HttpContext.Current.Server.MapPath("EmailTemplates/aapoitmentemail.htm");
                        string HTMLBODY = File.Exists(HTMLTemplatePath) ? File.ReadAllText(HTMLTemplatePath) : "";
                        HTMLBODY = HTMLBODY.Replace(@"##logourl##", ds.Tables[0].Rows[0]["schedulerURL"].ToString() + "/webfile/" + ds.Tables[0].Rows[0]["logourl"].ToString());
                        HTMLBODY = HTMLBODY.Replace("##company##", ds.Tables[0].Rows[0]["companyname"].ToString());
                        HTMLBODY = HTMLBODY.Replace("##date##", ds.Tables[0].Rows[0]["adate1"].ToString() + " " + ds.Tables[0].Rows[0]["frmTime"].ToString().Replace("am", " AM").Replace("pm"," PM"));
                        HTMLBODY = HTMLBODY.Replace(" ##purpose##", ds.Tables[0].Rows[0]["service"].ToString());
                        HTMLBODY = HTMLBODY.Replace(" ##visitorname##", ds.Tables[0].Rows[0]["vName"].ToString());
                        HTMLBODY = HTMLBODY.Replace("##empname##", ds.Tables[0].Rows[0]["empname"].ToString());
                        HTMLBODY = HTMLBODY.Replace("##phone##", ds.Tables[0].Rows[0]["phone"].ToString());

                        string msg1 = objda.SendAppEmail(ds.Tables[0].Rows[0]["email"].ToString() + ",", "Confirmation Email: Appointment with " + ds.Tables[0].Rows[0]["companyname"].ToString(), HTMLBODY, ds.Tables[0].Rows[0]["empemail"].ToString() + ",", "", "", ds.Tables[0].Rows[0]["companyname"].ToString());
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

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string deleteAppointment(string nid)
        {
            string msg = "failure";
            GeneralMethod objgen = new GeneralMethod();
            DataSet ds = new DataSet();
            ClsAppointment obj = new ClsAppointment();

            try
            {

                obj.nid = nid;
                obj.action = "delete";
                ds = obj.APP_ManageAppointment_new();
                msg = "1";
                return msg;
            }
            catch { return msg; }



        }

    }
}