using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using System.Web.Script.Services;
using System.IO;

namespace empTimeSheet.API
{
    /// <summary>
    /// Summary description for QuickStartAPI
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    [System.Web.Script.Services.ScriptService]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 

    public class QuickStartAPI : System.Web.Services.WebService
    {
        GeneralMethod objGen = new GeneralMethod();
        private void ResponseData(string strJSON)
        {

            Context.Response.Clear();
            Context.Response.ContentType = "application/json";
            Context.Response.Flush();
            Context.Response.Write(strJSON);

        }
        private void ResponseError()
        {


            Context.Response.StatusCode = 403;
            Context.ApplicationInstance.CompleteRequest();

        }

        private bool checkAppKey(string userid, string appID)
        {

            clsLogin objda = new clsLogin();
            DataSet ds = new DataSet();
            objda.loginid = userid;
            objda.password = appID;
            objda.action = "checkAppKey";
            ds = objda.Mob_Login();
            if (ds.Tables[0].Rows.Count > 0)
                return true;
            else
                return
                    false;


        }


       

        [WebMethod]
        [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
        public void GetCompanyDetailbyCode(string CompanyCode)
        {
            ClsAdmin objda = new ClsAdmin();
            DataSet ds = new DataSet();
            objda.code = CompanyCode;
            ds = objda.getCompanybyCode();

            if (ds.Tables[0].Rows.Count > 0)
                ResponseData(objGen.serilizeinJson(ds.Tables[0]));
            else
                ResponseData("[]");


        }

        [WebMethod]
        [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
        public void GetLogin(string loginid, string password, string companyID, string deviceID)
        {
            clsLogin objda = new clsLogin();
            DataSet ds = new DataSet();
            objda.loginid = loginid;
            objda.password = password;
            objda.action = "checklogin";
            objda.deviceID = deviceID;
            objda.company = companyID;
            ds = objda.Mob_Login();

            if (ds.Tables[0].Rows.Count > 0)
                ResponseData(objGen.serilizeinJson(ds.Tables[0]));
            else
                ResponseData("[]");

        }
        [WebMethod]
        [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
        public void GetAllEmployee(string EmpID, string AppLoginKey, string CompanyID)
        {
            ClsUser objuser = new ClsUser();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();

            if (checkAppKey(EmpID, AppLoginKey))
            {
                objuser.loginid = "";
                objuser.name = "";
                objuser.companyid = CompanyID;
                objuser.action = "select";
                objuser.activestatus = "active";
                ds = objuser.ManageEmployee();

                if (ds.Tables[0].Rows.Count > 0)
                    ResponseData(objGen.serilizeinJson(ds.Tables[0]));
                else
                    ResponseData("[]");
            }
            else
            {
                ResponseError();
            }



        }
        [WebMethod]
        [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
        public void GetAllEmployeeByRole(string EmpID, string AppLoginKey, string CompanyID,string approvRole)
        {
            ClsUser objuser = new ClsUser();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();

            if (checkAppKey(EmpID, AppLoginKey))
            {
                objuser.loginid = "";
                if (approvRole == "1")
                    objuser.id = "";
                else
                    objuser.id = EmpID;

                objuser.name = "";
                objuser.companyid = CompanyID;
                objuser.action = "select";
                objuser.activestatus = "active";
                ds = objuser.ManageEmployee();

                if (ds.Tables[0].Rows.Count > 0)
                    ResponseData(objGen.serilizeinJson(ds.Tables[0]));
                else
                    ResponseData("[]");
            }
            else
            {
                ResponseError();
            }



        }
        [WebMethod]
        [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
        public void GetUserRoles(string EmpID, string AppLoginKey, string CompanyID,string pageID)
        {
            DataAccess objda = new DataAccess();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();
            string str = "";
            string add = "0", view = "0", approve = "0";
            if (checkAppKey(EmpID, AppLoginKey))
            {

                switch (pageID)
                {
                    case "schedule":
                        if (objda.checkUserInroles("5"))
                        {
                            add = "1";
                        }

                        str = @"[{""add"":""" + add + @""",""edit"":""" + add + @""",""delete"":""" + add + @""",""setstatus"":""" + add + @"""}]";
                        break;
                    case "timesheet":
                        if (objda.checkUserInroles("85"))
                        {
                            add = "1";
                        }
                        if (objda.checkUserInroles("25"))
                        {
                            approve = "1";
                        }
                        str = @"[{""add"":"""+add+@""",""approve"":"""+approve+@"""}]";
                        break;

                    case "expenses":
                        if (objda.checkUserInroles("86"))
                        {
                            add = "1";
                        }
                        if (objda.checkUserInroles("87"))
                        {
                            approve = "1";
                        }
                        str = @"[{""add"":""" + add + @""",""approve"":""" + approve + @"""}]";
                        break;

                }

                ResponseData(str);
            }
            else
            {
                ResponseError();
            }



        }


        [WebMethod]
        [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
        public void GetAllProject(string EmpID, string AppLoginKey, string CompanyID)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();

            if (checkAppKey(EmpID, AppLoginKey))
            {
                objts.action = "selectforApp";
                objts.companyId = CompanyID;
                objts.nid = "";
                ds = objts.ManageProject();

                if (ds.Tables[0].Rows.Count > 0)
                    ResponseData(objGen.serilizeinJson(ds.Tables[0]));
                else
                    ResponseData("[]");
            }
            else
            {
                ResponseError();
            }



        }

        [WebMethod]
        [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
        public void GetMyRandomInfo(string EmpID, string AppLoginKey, string CompanyID)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();

            if (checkAppKey(EmpID, AppLoginKey))
            {
                objts.empid = EmpID;
                objts.action = "tasksummary";
                ds = objts.Mob_MyRandonInfo();
                if (ds.Tables[0].Rows.Count > 0)
                    ResponseData(objGen.serilizeinJson(ds.Tables[0]));
                else
                    ResponseData("[]");
            }
            else
            {
                ResponseError();
            }



        }








        #region Schedule

        [WebMethod]
        [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
        public void GetTodaySchedule(string EmpID, string AppLoginKey, string CompanyID, string TodayDate)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();

            if (checkAppKey(EmpID, AppLoginKey))
            {
                empTimeSheet.DataClasses.BAL.ClsScheduleBAL objSch = new empTimeSheet.DataClasses.BAL.ClsScheduleBAL();
                objts.nid = "";
                objts.action = "selectgroup";
                objts.companyId = CompanyID;
                objts.from = TodayDate;
                objts.to = TodayDate;
                objts.clientid = "";
                objts.projectid = "";
                objts.empid = EmpID;
                objts.Status = "";
                objts.remark = "";
                ds = objts.schedule();
                if (ds.Tables[0].Rows.Count > 0)
                    ResponseData(objGen.serilizeinJson(ds.Tables[0]));
                else
                    ResponseData("[]");
            }
            else
            {
                ResponseError();
            }



        }

        [WebMethod]
        [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
        public void GetSchedule(string EmpID, string AppLoginKey, string CompanyID, string fromDate, string toDate, string status, string action)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();

            if (checkAppKey(EmpID, AppLoginKey))
            {
                empTimeSheet.DataClasses.BAL.ClsScheduleBAL objSch = new empTimeSheet.DataClasses.BAL.ClsScheduleBAL();
                objts.nid = "";
                objts.action = "selectgroup";
                objts.companyId = CompanyID;
                objts.from = fromDate;
                objts.to = toDate;
                objts.clientid = "";
                objts.projectid = "";
                if (action == "my")
                    objts.empid = EmpID;
                else
                    objts.empid = "";
                objts.Status = status;
                objts.remark = "";
                ds = objts.schedule();
                if (ds.Tables[0].Rows.Count > 0)
                    ResponseData(objGen.serilizeinJson(ds.Tables[0]));
                else
                    ResponseData("[]");
            }
            else
            {
                ResponseError();
            }



        }

        [WebMethod]
        [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
        public void ModifyScheduleStatus(string EmpID, string AppLoginKey, string CompanyID, string nid, string newStatus)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();

            if (checkAppKey(EmpID, AppLoginKey))
            {
                objts.projectid = "";
                objts.groupid = "";
                objts.empid = EmpID;
                objts.date = "";
                objts.remark = "";
                objts.Status = newStatus;
                objts.companyId = CompanyID;
                objts.nid = nid;
                objts.action = "setgroupstatus";

                ds = objts.schedule();
                if (ds.Tables[0].Rows.Count > 0)
                    ResponseData(objGen.serilizeinJson(ds.Tables[0]));
                else
                    ResponseData("[]");
            }
            else
            {
                ResponseError();
            }



        }
        [WebMethod]
        [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
        public void GetScheduleDetail(string EmpID, string AppLoginKey, string CompanyID, string nid)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();

            if (checkAppKey(EmpID, AppLoginKey))
            {
                empTimeSheet.DataClasses.BAL.ClsScheduleBAL objSch = new empTimeSheet.DataClasses.BAL.ClsScheduleBAL();
                objts.nid = nid;
                objts.action = "getDetailByGroup";
                objts.companyId = CompanyID;

                ds = objts.schedule();
                if (ds.Tables[0].Rows.Count > 0)
                {

                    ResponseData(objGen.serilizeinJson(ds.Tables[0]));

                }

                else
                    ResponseData("[]");
            }
            else
            {
                ResponseError();
            }



        }

        [WebMethod]
        [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
        public void DeleteScheduleEMP(string EmpID, string AppLoginKey, string CompanyID, string nid)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();

            if (checkAppKey(EmpID, AppLoginKey))
            {
                empTimeSheet.DataClasses.BAL.ClsScheduleBAL objSch = new empTimeSheet.DataClasses.BAL.ClsScheduleBAL();
                objts.nid = nid;
                objts.action = "delete";
                objts.companyId = CompanyID;
                ds = objts.schedule();
                if (ds.Tables[0].Rows.Count > 0)
                    ResponseData(objGen.serilizeinJson(ds.Tables[0]));
                else
                    ResponseData("[]");
            }
            else
            {
                ResponseError();
            }



        }

        [WebMethod]
        [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
        public void DeleteSchedule(string EmpID, string AppLoginKey, string CompanyID, string nid)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();

            if (checkAppKey(EmpID, AppLoginKey))
            {
                empTimeSheet.DataClasses.BAL.ClsScheduleBAL objSch = new empTimeSheet.DataClasses.BAL.ClsScheduleBAL();
                objts.nid = nid;
                objts.action = "deleteGRpup";
                objts.companyId = CompanyID;
                ds = objts.schedule();
                if (ds.Tables[0].Rows.Count > 0)
                    ResponseData(objGen.serilizeinJson(ds.Tables[0]));
                else
                    ResponseData("[]");
            }
            else
            {
                ResponseError();
            }



        }


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string PostSchedule(string companyid, string nid, string empid, string clientid, string date, string time, string status, string remark, string createdby, string groupid, string projectid)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();
            empTimeSheet.DataClasses.BAL.ClsScheduleBAL objsch = new empTimeSheet.DataClasses.BAL.ClsScheduleBAL();
            string result = "";

            objts.from = date;
            objts.to = date;
            objts.clientid = clientid;

            objts.date = time;
            objts.hours = time;
            objts.companyId = companyid;
            objts.CreatedBy = createdby;
            objts.empid = empid;
            objts.projectid = projectid;
            objts.groupid = groupid;
            objts.type = "Field";
            objts.Status = status;
            objts.remark = remark;
            objts.nid = nid;

            if (nid != "")
            {
                objts.action = "modify";
                objts.nid = nid;
                ds = objts.schedule();
                result = objgen.serilizeinJson(ds.Tables[0]);
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
                                    objsch.sendreschedulemail(ds.Tables[1], companyid);
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
        #endregion


        #region Appointment
        [WebMethod]
        [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
        public void GetTodayAppointment(string EmpID, string UserType, string AppLoginKey, string CompanyID, string TodayDate)
        {
            ClsAppointment objts = new ClsAppointment();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();

            if (checkAppKey(EmpID, AppLoginKey))
            {

                objts.nid = "";
                objts.action = "selectforApp";
                objts.desig = "My";
                objts.companyid = CompanyID;
                objts.fromdate = TodayDate;
                objts.todate = TodayDate;
                objts.empid = EmpID;
                objts.status = "";

                ds = objts.APP_ManageAppointment_new();
                if (ds.Tables[0].Rows.Count > 0)
                    ResponseData(objGen.serilizeinJson(ds.Tables[0]));
                else
                    ResponseData("[]");
            }
            else
            {
                ResponseError();
            }



        }

        [WebMethod]
        [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
        public void GetAppointment(string EmpID, string UserType, string AppLoginKey, string CompanyID, string fromDate, string toDate, string status, string action)
        {
            ClsAppointment objts = new ClsAppointment();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();

            if (checkAppKey(EmpID, AppLoginKey))
            {

                objts.nid = "";
                objts.action = "selectforApp";
                objts.companyid = CompanyID;
                objts.fromdate = fromDate;
                objts.todate = toDate;
                objts.empid = EmpID;
                objts.desig = action;
                objts.status = status;

                ds = objts.APP_ManageAppointment_new();
                if (ds.Tables[0].Rows.Count > 0)
                    ResponseData(objGen.serilizeinJson(ds.Tables[0]));
                else
                    ResponseData("[]");
            }
            else
            {
                ResponseError();
            }



        }

        [WebMethod]
        [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
        public void ModifyAppointmentStatus(string EmpID, string AppLoginKey, string CompanyID, string nid, string newStatus)
        {
            ClsAppointment objts = new ClsAppointment();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();

            if (checkAppKey(EmpID, AppLoginKey))
            {

                objts.empid = EmpID;
                objts.status = newStatus;
                objts.nid = nid;
                objts.action = "setstatus";

                ds = objts.APP_ManageAppointment_new();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    ResponseData(objGen.serilizeinJson(ds.Tables[1]));
                }

                else
                    ResponseData("[]");
            }
            else
            {
                ResponseError();
            }



        }

        [WebMethod]
        [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
        public void GetAppointmentDetail(string EmpID, string AppLoginKey, string CompanyID, string nid)
        {
            GeneralMethod objgen = new GeneralMethod();
            DataSet ds = new DataSet();
            ClsAppointment obj = new ClsAppointment();


            if (checkAppKey(EmpID, AppLoginKey))
            {


                obj.nid = nid;
                obj.action = "select";
                ds = obj.APP_ManageAppointment_new();

                if (ds.Tables[0].Rows.Count > 0)
                    ResponseData(objGen.serilizeinJson(ds.Tables[0]));
                else
                    ResponseData("[]");
            }
            else
            {
                ResponseError();
            }

        }

        [WebMethod]
        [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
        public void DeleteAppointment(string EmpID, string AppLoginKey, string CompanyID, string nid)
        {
            GeneralMethod objgen = new GeneralMethod();
            DataSet ds = new DataSet();
            ClsAppointment obj = new ClsAppointment();


            if (checkAppKey(EmpID, AppLoginKey))
            {


                obj.nid = nid;
                obj.action = "delete";
                ds = obj.APP_ManageAppointment_new();

                if (ds.Tables[0].Rows.Count > 0)
                    ResponseData(objGen.serilizeinJson(ds.Tables[0]));
                else
                    ResponseData("[]");
            }
            else
            {
                ResponseError();
            }

        }

        #endregion
        #region Timesheet
        [WebMethod]
        [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
        public void GetTimeSheet(string EmpID, string AppLoginKey, string CompanyID, string fromDate, string toDate, string empNid, string projectNid)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();

            if (checkAppKey(EmpID, AppLoginKey))
            {

                objts.from = fromDate;
                objts.to = toDate;
                objts.empid = empNid;
                objts.action = "select";
                objts.projectid = projectNid;
                objts.nid = "";
                ds = objts.ManageTimesheet();             
                if (ds.Tables[0].Rows.Count > 0)
                    ResponseData(objGen.serilizeinJson(ds.Tables[0]));
                else
                    ResponseData("[]");
            }
            else
            {
                ResponseError();
            }



        }
        [WebMethod]
        [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
        public void GetTaskCode(string EmpID, string AppLoginKey, string CompanyID)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();

            if (checkAppKey(EmpID, AppLoginKey))
            {

                objts.name = "";
                objts.action = "select";
                objts.type = "Task";
                objts.companyId = CompanyID;
                objts.nid = "";
                objts.deptID = "";
                objts.Status = "active";
                ds = objts.ManageTasks();

                if (ds.Tables[0].Rows.Count > 0)
                    ResponseData(objGen.serilizeinJson(ds.Tables[0]));
                else
                    ResponseData("[]");
            }
            else
            {
                ResponseError();
            }



        }

        [WebMethod]
        [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
        public void PostTimeSheet(string EmpID, string AppLoginKey, string CompanyID,string nid, string taskdate, string projectid, string taskid, string hours, string description, string billable, string memo, string billrate, string payrate)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();

            if (checkAppKey(EmpID, AppLoginKey))
            {

              
                objts.companyId = CompanyID;
                objts.nid = "";
                objts.action = "insert";
                objts.empid = EmpID;
                objts.projectid = projectid;
                objts.startdate = taskdate;
                objts.description = description;
                objts.hours = hours;
                objts.taskid = taskid;
                objts.Status = "Submitted";
                objts.isbillable = billable;
                objts.keyword = memo;
                objts.billrate = billrate;
                objts.costrate = payrate;
                objts.ManageTimesheet();


                ResponseData(@"[{""result"":""1"",""msg"":""Saved successfully""}]");
            }
            else
            {
                ResponseError();
            }



        }
        #endregion

        #region Expenses
        [WebMethod]
        [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
        public void GetExpenseLog(string EmpID, string AppLoginKey, string CompanyID, string fromDate, string toDate, string empNid, string projectNid)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();

            if (checkAppKey(EmpID, AppLoginKey))
            {

                objts.from = fromDate;
                objts.to = toDate;
                objts.empid = empNid;
                objts.action = "select";
                objts.projectid = projectNid;
                objts.nid = "";
                ds = objts.ManageExpenseLog();
                if (ds.Tables[0].Rows.Count > 0)
                    ResponseData(objGen.serilizeinJson(ds.Tables[0]));
                else
                    ResponseData("[]");
            }
            else
            {
                ResponseError();
            }



        }
        [WebMethod]
        [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
        public void GetExpenseCode(string EmpID, string AppLoginKey, string CompanyID)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();

            if (checkAppKey(EmpID, AppLoginKey))
            {

                objts.name = "";
                objts.action = "select";
                objts.type = "Expense";
                objts.companyId = CompanyID;
                objts.nid = "";
                objts.deptID = "";
                objts.Status = "active";
                ds = objts.ManageTasks();

                if (ds.Tables[0].Rows.Count > 0)
                    ResponseData(objGen.serilizeinJson(ds.Tables[0]));
                else
                    ResponseData("[]");
            }
            else
            {
                ResponseError();
            }



        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public void uploadExpFile()
        {
            try
            {
                HttpPostedFile file = HttpContext.Current.Request.Files.Count > 0 ? HttpContext.Current.Request.Files[0] : null;
                if (file != null)
                {
                    string path = Server.MapPath("~/webfile/attachfiles/");
                  

                    String extension = Path.GetExtension(file.FileName);

                    string filename = System.DateTime.Now.ToString("ddMMyyyyhhmmss") + extension;

                    //string path = Server.MapPath(HttpContext.Current.Request.ApplicationPath+"/photo/"+filename);





                    file.SaveAs(path + "/" + filename);                   


                    ResponseData(@"[{""result"":""1"",""savedfileName"":""""" + filename + @""",""message"":""""}]");




                }
                else
                {
                    ResponseData(@"[{""result"":""0"",""filename"":"""",""message"":""File does not exist""}]");


                }
            }

            catch (Exception ex)
            {
                ResponseData(@"[{""result"":""0"",""filename"":"""",""message"":""" + ex.Message + @"""}]");

            }
        }



        [WebMethod]
        [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
        public void PostExpenses(string EmpID, string AppLoginKey, string CompanyID, string nid, string expDate, string projectid, string expenseid, string cost, string description, string units, string amount, string billable, string mu, string reimbursable, string memo, string companyid, string empid, string originalfile, string savedfile)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();

            if (checkAppKey(EmpID, AppLoginKey))
            {


                objts.empid = empid;
                objts.projectid = projectid;
                objts.date = expDate;
                objts.description = description;
                objts.units =units;
                objts.expenseid = expenseid;
                objts.Status = "Submitted";
                objts.isbillable = billable;
                objts.reimbursable = reimbursable;
                objts.remark = memo;
                if (cost != "")
                {
                    objts.cost = cost;
                }
                else
                {
                    objts.cost = "0";
                }
                if (mu != "")
                {
                    objts.MU = mu;
                }
                else
                {
                    objts.MU = "0";
                }
                if (amount != "")
                {
                    objts.amount = amount;
                }
                else
                {
                    objts.amount = "0";
                }

                objts.originalfile = originalfile;
                objts.savedfile = savedfile;
                objts.ManageExpenseLog();


                ResponseData(@"[{""result"":""1"",""msg"":""Saved successfully""}]");
            }
            else
            {
                ResponseError();
            }



        }
        #endregion
    }
}
