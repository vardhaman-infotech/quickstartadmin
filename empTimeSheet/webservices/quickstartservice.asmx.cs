using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;


namespace empTimeSheet.webservices
{
    /// <summary>
    /// Summary description for quickstartservice
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    [System.Web.Script.Services.ScriptService]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    // [System.Web.Script.Services.ScriptService]
    public class quickstartservice : System.Web.Services.WebService
    {
        ClsTimeSheet objts = new ClsTimeSheet();
        DataSet ds = new DataSet();

        [WebMethod]
        public string checkempschedule(string from, string to, string clientid, string companyId, string empid)
        {
            string msg = "";
            objts.from = from;
            objts.to = to;
            objts.clientid = clientid;
            objts.companyId = companyId;
            objts.projectid = clientid;
            objts.empid = empid;
            ds = objts.checkschedulexists_WebServices();
            if (ds.Tables[0].Rows.Count > 0)
            {
                if (ds.Tables[0].Rows[0]["errormessage"] != null && ds.Tables[0].Rows[0]["errormessage"].ToString() != "")
                {
                    msg = ds.Tables[0].Rows[0]["errormessage"].ToString();

                }
            }
            return msg;
        }


        [WebMethod]
        public string checkAttendanceLogin_WebServices(string username, string password, string companyid)
        {
            string msg = "";
            objts.id = username;
            objts.parentid = password;
            objts.companyId = companyid;
            ds = objts.checkAttendanceLogin_WebServices();
            if (ds.Tables[0].Rows.Count > 0)
            {
                msg = ds.Tables[0].Rows[0]["nid"].ToString();
            }
            else
            {
                msg = "";
            }
            return msg;
        }

        public DataTable deserializetoDataTable(string jsonString)
        {
            DataTable dt = new DataTable();
            dt = (DataTable)Newtonsoft.Json.JsonConvert.DeserializeObject(jsonString, (typeof(DataTable)));

            return dt;
        }



        [WebMethod]
        public string saveAttendanceData(string data, string companyid)
        {
            string msg = "0";
            DataTable dt = new DataTable();
            dt = deserializetoDataTable(data);


            DataSet ds = new DataSet();
            SqlCommand cmd = new SqlCommand();
            SqlConnection con;
            con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["conn"].ConnectionString);
            cmd.Connection = con;
            con.Close();
            cmd.CommandText = "sp_InsertAttendance_WebService";
            cmd.Parameters.Clear();
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@tbl1", dt).SqlDbType = SqlDbType.Structured;
            cmd.Parameters.AddWithValue("@companyid", companyid);


            SqlDataAdapter adapt = new SqlDataAdapter(cmd);
            con.Open();
            adapt.Fill(ds);
            //Execute
            // cmd.ExecuteNonQuery();
            con.Close();

            if (ds.Tables[0].Rows.Count > 0)
            {
                msg = ds.Tables[0].Rows[0][0].ToString();
            }

            return msg;
        }



        #region todo list
      
        [WebMethod]
        public string insertToDoList(string taskDate, string empid, string notes, string taskStatus)
        {
            DataAccess objda = new DataAccess();
            string msg = "";
            objda.dob = taskDate;
            objda.empid = empid;
            objda.id = "";
            objda.description = notes;
            objda.status = taskStatus;
            objda.action = "insert";
            try
            {
                objda.ToDoList();
                msg = "1";
            }
            catch (Exception ex)
            {
                msg = ex.ToString();

            }
            return msg;
        }

        [WebMethod]
        public string updateToDoList(string action, string nid, string desc)
        {
            DataAccess objda = new DataAccess();
            string msg = "";
            if (action == "1")
            {
                objda.action = "updatedate";
                objda.dob = desc;
            }
            else if (action == "2")
            {
                objda.action = "updatestatus";
                objda.status = desc;

            }
            else if (action == "3")
            {
                objda.action = "delete";
                objda.status = "";

            }
            else if (action == "4")
            {
                objda.action = "updatedesc";
                objda.description = desc;

            }

            objda.id = nid;

            try
            {
                objda.ToDoList();
                msg = "1";
            }
            catch (Exception ex)
            {
                msg = ex.ToString();

            }
            return msg;
        }



        [WebMethod]        
        public string getToDoList(string empid)
        {
            DataAccess objda = new DataAccess();
            empTimeSheet.DataClasses.BAL.ClsToDoListBAL objtodo = new empTimeSheet.DataClasses.BAL.ClsToDoListBAL();
            GeneralMethod objgen = new GeneralMethod();

            string result = "";        
            objda.empid = empid;
            objda.id = "";
            objda.action = "select";
            string tDay = "";
            try
            {
                ds = objda.ToDoList();
                tDay = ds.Tables[1].Rows[0]["empdate"].ToString();
                
                DataTable dtbyItem = new DataTable();

                //Fill Today List 
                if (ds.Tables[0].Rows.Count > 0)
                {
                    dtbyItem = objgen.filterTable("date1=#" + tDay + "#", ds.Tables[0]);
                    result = objtodo.todayHTML(dtbyItem, "Today's Tasks", "t");

                    dtbyItem = objgen.filterTable("date1>#" + tDay + "#", ds.Tables[0]);
                    result = result+objtodo.upComingHTML(dtbyItem, "Upcoming Tasks", "u");

                    dtbyItem = objgen.filterTable("date1<#" + tDay + "#", ds.Tables[0]);
                    result = result + objtodo.upComingHTML(dtbyItem, "Previous Tasks", "p");

                }
                else
                {
                    result = "<div class='task-hding'>Today's Task</div> <div class='clear'></div><div class='notodaytask'>No task exists.</div>";
                }



            }
            catch (Exception ex)
            {
                result = ex.ToString();

            }
            return result;
        }
        #endregion


    }
}
