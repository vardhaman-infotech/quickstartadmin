using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.Script.Services;
using MKB.TimePicker;


namespace empTimeSheet
{
    public partial class AttendenceReader : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();     
        GeneralMethod objgen = new GeneralMethod();
        ClsAttendence objAtt = new ClsAttendence();
        ClsUser objuser = new ClsUser();
        DataSet ds = new DataSet();
        StringBuilder sb = new StringBuilder();     
        DataSet dsexcel = new DataSet();
    
        
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {

               

                if (objda.checkUserInroles("101"))
                {
                    Att_hidAdd.Value = "1";
                }
                if (objda.checkUserInroles("102"))
                {
                    Att_hidview.Value = "1";
                }
                if (objda.checkUserInroles("103"))
                {
                    Att_hidViewOthers.Value = "1";
                }


                if (Att_hidAdd.Value != "1" && Att_hidview.Value != "1" && Att_hidViewOthers.Value != "1")
                {
                    Response.Redirect("UserDashboard.aspx");
                
                }

                if (Att_hidAdd.Value != "1")
                {
                    linkaddnew.Visible = false;
                }

              


                //role 9 indicates Approve Task
                if(!objda.checkUserInroles("10"))
                {
                    linkaddnew.Visible = false;
                }
   
                string todaydate = GeneralMethod.getLocalDate();

                txtfrom.Text = System.DateTime.Now.AddDays(-6).ToString("MM/dd/yyyy");
                txtto.Text = System.DateTime.Now.ToString("MM/dd/yyyy"); 
                txtdate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");
               // fillgrid();
                fillemployee();
               
               
              

            }
        }

        protected void fillemployee()
        {
            objuser.action = "SelectactiveWithEnrollNo";
            objuser.companyid = Session["companyid"].ToString();
            objuser.id = "";
            ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0)
            {
                //dropemployee.DataSource = ds;
                //dropemployee.DataTextField = "username";
                //dropemployee.DataValueField = "nid";
                //dropemployee.DataBind();
                objgen.fillActiveInactiveDDL(ds.Tables[0], dropemployee, "username", "enrollno");
                ListItem li = new ListItem("--All Employees--", "");
                dropemployee.Items.Insert(0, li);
            }

            objAtt.Enrollno = Session["userid"].ToString();
            objAtt.Action = "getEnrollNo";
            ds = objAtt.OpAttendance();

            if (ds.Tables[0].Rows.Count > 0)
            {
                if (ds.Tables[0].Rows[0]["enrollno"] != null && ds.Tables[0].Rows[0]["enrollno"].ToString() != "")
                    Att_EnrollNo.Value = ds.Tables[0].Rows[0]["enrollno"].ToString();
                else
                    Att_EnrollNo.Value = "0";
            }
        }


   

        public void bindhtml()
        {
           
            if (ds.Tables[0].Rows.Count > 0)
            {
                sb.Append("<table class='table table-success mb30'>");
                sb.Append("<tr class='gridheader'>");

                for (int i = 0; i < ds.Tables[0].Columns.Count; i++) {

                    sb.Append("<th>" + ds.Tables[0].Columns[i].ColumnName + "</th>");
                }
                sb.Append("</tr>");


               

                for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                {
                    sb.Append("<tr>");
                    for (int i = 0; i < ds.Tables[0].Columns.Count; i++)
                    {

                        sb.Append("<td>" + ds.Tables[0].Rows[j][i].ToString() + "</td>");
                    }
                    sb.Append("</tr>");
                
                }
                   

                    sb.Append("</table>");
            }



        }
        

        public void fillgrid()
        {
            objAtt.Action = "DateFilter";

            objAtt.Enrollno = "";
            objAtt.Date = txtfrom.Text;
            objAtt.EndDate = txtto.Text;
            objAtt.CompanyID = Session["CompanyId"].ToString();
            ds = objAtt.GetAttendence();
           
            bindhtml();
           

        }



        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]

        public static string getAttandence(string fromdate, string todate, string companyid,string userid)
        {

            StringBuilder sb = new StringBuilder();
            ClsAttendence objAtt = new ClsAttendence();
            objAtt.Action = "DateFilter";

            objAtt.Enrollno = userid;
            objAtt.Date = fromdate;
            objAtt.EndDate = todate;
            objAtt.CompanyID = companyid;
            DataSet ds = new DataSet();
            ds = objAtt.GetAttendence();


            if (ds.Tables[0].Rows.Count > 0)
            {
                if (ds.Tables[0].Rows.Count > 0)
                {
                    sb.Append("<table class='table table-success mb30'>");
                    sb.Append("<tr class='gridheader'>");

                    for (int i = 0; i < ds.Tables[0].Columns.Count; i++)
                    {

                        sb.Append("<th>" + ds.Tables[0].Columns[i].ColumnName + "</th>");
                    }
                    sb.Append("</tr>");




                    for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                    {
                        sb.Append("<tr>");
                        for (int i = 0; i < ds.Tables[0].Columns.Count; i++)
                        {

                            sb.Append("<td>" + ds.Tables[0].Rows[j][i].ToString() + "</td>");
                        }
                        sb.Append("</tr>");

                    }


                    sb.Append("</table>");
                }

            }

            return sb.ToString();
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]

        public static string getNID(string enrollno,string pdate, string companyid)
        {
            StringBuilder sb = new StringBuilder();
            ClsAttendence objAtt = new ClsAttendence();
            DataSet ds = new DataSet();
            objAtt.Enrollno = enrollno;
            objAtt.Action = "getnid";
            objAtt.Date = pdate;
            objAtt.CompanyID = companyid;
            ds = objAtt.OpAttendance();
            if (ds.Tables[0].Rows.Count > 0)
            {
                sb.Append(ds.Tables[0].Rows[0]["intime"].ToString() + "###");
                sb.Append(ds.Tables[0].Rows[0]["outtime"].ToString() + "###");
                sb.Append(ds.Tables[0].Rows[0]["inNid"].ToString() + "###");
                sb.Append(ds.Tables[0].Rows[0]["onid"].ToString());
               
            }

            return sb.ToString();
        }


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]

        public static string manualAtt(string enrollno, string pdate, string inTime, string outTime,string companyid, string inNid, string oNid, string Addedby)
        {
            StringBuilder sb = new StringBuilder();
            ClsAttendence objAtt = new ClsAttendence();
            DataSet ds = new DataSet();
            objAtt.Enrollno = enrollno;
            objAtt.Action = "Insert";
            objAtt.Date = pdate;
            objAtt.CompanyID = companyid;
            objAtt.Ptime = inTime;
            objAtt.PTime1 = outTime;
            objAtt.Inid = inNid;
            objAtt.Onid = oNid;
            objAtt.AddedBy = ""; 
            ds = objAtt.OpAttendance();
            string msg = "";
            if (ds.Tables[0].Rows.Count > 0)
            {
                msg = ds.Tables[0].Rows[0][1].ToString();
              

            }

            return msg;
        }

        protected void btnexportcsv_Click(object sender, EventArgs e)
        {
            fillgrid();


            excelexport objexcel = new excelexport();

            objexcel.downloadFile(sb.ToString(), "EmployeeAttendance.xls");


        }


        protected void btnsearch_Click(object sender, EventArgs e)
        {
            fillgrid();
        }

       
        protected void btnsubmit_Click(object sender, EventArgs e)
        {
         
        }

      

      

     
    }
}