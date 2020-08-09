using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.Services;
using System.Web.Script.Services;

namespace empTimeSheet
{
    public partial class Appoint_Availability : System.Web.UI.Page
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
                txtDate_CalendarExtender.StartDate = Convert.ToDateTime(GeneralMethod.getEmpDate());
                txtDate_CalendarExtender1.StartDate = Convert.ToDateTime(GeneralMethod.getEmpDate());
                txtfrom.Text = GeneralMethod.getEmpDate();
                txtto.Text =Convert.ToDateTime( GeneralMethod.getEmpDate()).AddDays(7).ToString("MM/dd/yyyy");
                appointment_minDate.Value = txtfrom.Text;
                fillemp();
                //role 9 indicates Approve Task
                if (!objda.checkUserInroles("107"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
            }
        }
        public void fillemp()
        {
            obj.action = "getEmployee";
            obj.companyid = Session["companyid"].ToString();
            ds = obj.APP_ManageAvailability();
            dropemployee.DataSource = ds;
            dropemployee.DataTextField = "fullname";
            dropemployee.DataValueField = "nid";
            dropemployee.DataBind();

            if(ds.Tables[0].Rows.Count>0)
            {
                try
                {
                    dropemployee.Text = Session["userid"].ToString();
                }
                catch
                {
                    dropemployee.SelectedIndex = 0;
                }

            }

           

        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string saveEmpAvailability(string nid, string empid, string aDate, string afrmDate, string aToDate)
        {
            string msg = "failure";
            GeneralMethod objgen = new GeneralMethod();
            DataSet ds = new DataSet();
            ClsAppointment obj = new ClsAppointment();
            string[] nid1 = nid.Split('#');
            string[] aDate1 = aDate.Split('#');
            string[] afrmDate1 = afrmDate.Split('#');
            string[] aToDate1 = aToDate.Split('#');

            try
            {

                for (int i = 0; i < aDate1.Length; i++)
                {
                    if (aDate1[i] != "")
                    {
                        obj.empid = empid;
                        obj.aDate = aDate1[i];
                        obj.afrmTime = afrmDate1[i];
                        obj.aToTime = aToDate1[i];
                        obj.nid = nid1[i];
                        obj.action = "insert";
                        ds = obj.APP_ManageAvailability();

                    }

                }

                msg = "1";
                return msg;
            }
            catch { return msg; }



        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getAppointments(string nid)
        {
            string msg = "failure";
            GeneralMethod objgen = new GeneralMethod();
            DataSet ds = new DataSet();
            ClsAppointment obj = new ClsAppointment();

            try
            {
                obj.fromdate = "";
                obj.todate = "";

                obj.status = "";               
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
        public static string getEmpAvailability(string empid, string compid, string fromdate, string todate)
        {
            string msg = "failure";
            GeneralMethod objgen = new GeneralMethod();
            DataSet ds = new DataSet();
            ClsAppointment obj = new ClsAppointment();

            try
            {
                obj.fromdate = fromdate;
                obj.todate = todate;
                obj.empid = empid;
                obj.companyid = compid;
                obj.nid = "";
                obj.action = "select";
                ds = obj.APP_ManageAvailability();

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
                ds = obj.APP_ManageAvailability();
                msg = "1";
                return msg;
            }
            catch { return msg; }



        }

    }
}