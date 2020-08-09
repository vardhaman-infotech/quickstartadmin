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


namespace empTimeSheet
{
    public partial class project_log : System.Web.UI.Page
    {
        GeneralMethod objgen = new GeneralMethod();
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        DataSet ds = new DataSet();
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                //role 9 indicates Approve Task
                if (!objda.checkUserInroles("110"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
                txtfrom.Text = Convert.ToDateTime(GeneralMethod.getEmpDate()).AddYears(-1).ToString("MM/dd/yyyy");
                txtto.Text = Convert.ToDateTime(GeneralMethod.getEmpDate()).AddDays(7).ToString("MM/dd/yyyy");
                fillevenetype();
                fillproject();
                fillemp();
               
            }
        }
        public void fillevenetype()
        {
            objda.id = "";
            objda.action = "select";
            objda.location = "4";
            objda.title = "";
            objda.company = Session["companyid"].ToString();
            ds = objda.ManageInformationType();
            StringBuilder sb = new StringBuilder();
            if(ds.Tables[0].Rows.Count>0)
            {
              
                for(int i=0;i<ds.Tables[0].Rows.Count;i++)
                {
                    sb.Append("<option value='"+ds.Tables[0].Rows[i]["nid"].ToString()+"'>"+ds.Tables[0].Rows[i]["typetitle"].ToString()+"</option>");

                }
              
            }
            else
            {
                sb.Append("<option value=''>" + "--Select--" + "</option>");
            }
            diveventtype.InnerHtml = sb.ToString();

        }
        public void fillemp()
        {
            objuser.action = "select";
            objuser.companyid = Session["companyid"].ToString();
            objuser.id = "";
            ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0)
            {
                //dropemployee.DataSource = ds;
                //dropemployee.DataTextField = "username";
                //dropemployee.DataValueField = "nid";
                //dropemployee.DataBind();
                objgen.fillActiveInactiveDDL(ds.Tables[0], dropemployee, "username", "nid");

                ListItem li = new ListItem("--All Employees--", "");
                dropemployee.Items.Insert(0, li);

            }

            dropemployee.SelectedIndex = 0;



        }
        protected void fillproject()
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            droproject.Items.Clear();
            objts.name = "";
            objts.action = "selectbyclient";
            objts.clientid = "";
            objts.companyId = Session["companyid"].ToString();
            objts.nid = "";
            ds = objts.ManageProject();
            if (ds.Tables[0].Rows.Count > 0)
            {
                droproject.DataSource = ds;
                droproject.DataTextField = "projectcode";
                droproject.DataValueField = "nid";
                droproject.DataBind();

                droproject.Items.Insert(0, new ListItem("--Select--", ""));
                droproject.SelectedIndex = 0;
            }



        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string saveProjectLog(string nid, string typeid, string eventlog, string edate, string empid, string fdate, string cdate, string addedby, string companyid, string projectid)
        {
            string msg = "failure";
            GeneralMethod objgen = new GeneralMethod();
            DataSet ds = new DataSet();
            ClsUser obj = new ClsUser();
            string[] nid1 = nid.Split('#');
            string[] typeid1 = typeid.Split('#');
            string[] eventlog1 = eventlog.Split('#');
            string[] edate1 = edate.Split('#');
            string[] empid1 = empid.Split('#');
            string[] fdate1 = fdate.Split('#');
            string[] cdate1 = cdate.Split('#');           
            string[] projecti1 = projectid.Split('#');           

            try
            {

                for (int i = 0; i < typeid1.Length; i++)
                {
                    if (typeid1[i] != "")
                    {
                        obj.action = "insert";
                        obj.id = nid1[i];
                        obj.typeid = typeid1[i];
                        obj.remark = eventlog1[i];
                        obj.dob = edate1[i];
                        obj.empid = empid1[i];
                        obj.projectid = projecti1[i];
                        obj.dob1 = fdate1[i];
                        obj.dob2 = cdate1[i];
                        obj.userid = addedby;
                        obj.companyid = companyid;
                        ds = obj.manageProjectLog();

                    }

                }

                msg = "1";
                return msg;
            }
            catch { return msg; }



        }



        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getProjectLog(string empid, string compid, string fromdate, string todate, string projectid)
        {
            string msg = "failure";
            GeneralMethod objgen = new GeneralMethod();
            DataSet ds = new DataSet();
            ClsUser obj = new ClsUser();

            try
            {
                obj.fromdate = fromdate;
                obj.todate = todate;
                obj.empid = empid;
                obj.companyid = compid;
                obj.projectid = projectid;
                obj.action = "select";
                ds = obj.manageProjectLog();

                msg = objgen.serilizeinJson(ds.Tables[0]);
                return msg;
            }
            catch { return msg; }



        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string deleteLog(string nid)
        {
            string msg = "failure";
            GeneralMethod objgen = new GeneralMethod();
            DataSet ds = new DataSet();
            ClsUser obj = new ClsUser();

            try
            {

                obj.id = nid;
                obj.action = "delete";
                ds = obj.manageProjectLog();
                msg = "1";
                return msg;
            }
            catch { return msg; }



        }
    }
}