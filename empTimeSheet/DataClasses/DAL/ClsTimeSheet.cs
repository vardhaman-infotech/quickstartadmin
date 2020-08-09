using System.Data;
using System.Data.SqlClient;
using empTimeSheet.DataClasses.DAL;
using System.Web;

public class ClsTimeSheet : clsDAL
{

    private string _action, _nid, _Code, _name, _companyId, _clientid, _managerId, _contractType, _Status, _contractAmt, _expAmt;
    private string _serviceAmt, _startdate, _duedate, _completePercent, _currencyID, _iscustominvoice, _invoicePrefix, _invoiceSuffix, _invoicesno;
    private string _remark, _CreatedBy, _keyword, _from, _to, _frequency, _po, _description, _isbillable, _deptID, _costrate, _billrate;
    private string _empid, _taskid, _projectid, _hours, _isbilled, _tax, _type;
    private string _grade, _groupid;
    private string _parentid, _maintaskid, _title, _creationdate, _allocationid, _comments, _assignmentid, _eststartdate, _enddate;

    private string _expenseid, _units, _cost, _MU, _date, _amount, _reimbursable;

    private string _invoiceno, _subamount, _discount, _retainage, _amountpaid, _totalamount, _dueamount;
    private string _paymentmode, _checkno, _grt, _taxid, _taxpercent, _originalfile, _savedfile, _submittype, _submitto, _taskStatus, _id, _taskType, _address2, _contact, _state, _city, _country, _zip, _isRemimb;
    private string _TBillable, _Tmemorequired, _EBillable, _Ememorequired, _budgetedHours, _TReadonly, _EReadOnly;
    public DataTable dt;

    private string _recurAmt, _recurintPeriod, _recurstartdate, _recurenddate;

    #region Variables

    public string EReadOnly { get { return this._EReadOnly; } set { this._EReadOnly = value.Trim(); } }
    public string TReadonly { get { return this._TReadonly; } set { this._TReadonly = value.Trim(); } }




    public string budgetedHours { get { return this._budgetedHours; } set { this._budgetedHours = value.Trim(); } }
    public string Ememorequired { get { return this._Ememorequired; } set { this._Ememorequired = value.Trim(); } }
    public string EBillable { get { return this._EBillable; } set { this._EBillable = value.Trim(); } }
    public string Tmemorequired { get { return this._Tmemorequired; } set { this._Tmemorequired = value.Trim(); } }
    public string TBillable { get { return this._TBillable; } set { this._TBillable = value.Trim(); } }

    public string isRemimb { get { return this._isRemimb; } set { this._isRemimb = value.Trim(); } }
    public string address2 { get { return this._address2; } set { this._address2 = value.Trim(); } }
    public string contact { get { return this._contact; } set { this._contact = value.Trim(); } }
    public string state { get { return this._state; } set { this._state = value.Trim(); } }
    public string city { get { return this._city; } set { this._city = value.Trim(); } }
    public string country { get { return this._country; } set { this._country = value.Trim(); } }
    public string zip { get { return this._zip; } set { this._zip = value.Trim(); } }

    public string taskStatus { get { return this._taskStatus; } set { this._taskStatus = value.Trim(); } }
    public string id { get { return this._id; } set { this._id = value.Trim(); } }
    public string taskType { get { return this._taskType; } set { this._taskType = value.Trim(); } }
    public string submittype { get { return this._submittype; } set { this._submittype = value.Trim(); } }
    public string submitto { get { return this._submitto; } set { this._submitto = value.Trim(); } }
    public string originalfile { get { return this._originalfile; } set { this._originalfile = value.Trim(); } }
    public string savedfile { get { return this._savedfile; } set { this._savedfile = value.Trim(); } }
    public string grt { get { return this._grt; } set { this._grt = value.Trim(); } }
    public string paymentmode { get { return this._paymentmode; } set { this._paymentmode = value.Trim(); } }
    public string checkno { get { return this._checkno; } set { this._checkno = value.Trim(); } }
    public string invoiceno { get { return this._invoiceno; } set { this._invoiceno = value.Trim(); } }
    public string subamount { get { return this._subamount; } set { this._subamount = value.Trim(); } }
    public string discount { get { return this._discount; } set { this._discount = value.Trim(); } }
    public string retainage { get { return this._retainage; } set { this._retainage = value.Trim(); } }
    public string amountpaid { get { return this._amountpaid; } set { this._amountpaid = value.Trim(); } }
    public string totalamount { get { return this._totalamount; } set { this._totalamount = value.Trim(); } }
    public string dueamount { get { return this._dueamount; } set { this._dueamount = value.Trim(); } }

    public string action { get { return this._action; } set { this._action = value.Trim(); } }
    public string nid { get { return this._nid; } set { this._nid = value.Trim(); } }
    public string Code { get { return this._Code; } set { this._Code = value.Trim(); } }
    public string name { get { return this._name; } set { this._name = value.Trim(); } }
    public string companyId { get { return this._companyId; } set { this._companyId = value.Trim(); } }
    public string clientid { get { return this._clientid; } set { this._clientid = value.Trim(); } }
    public string managerId { get { return this._managerId; } set { this._managerId = value.Trim(); } }
    public string contractType { get { return this._contractType; } set { this._contractType = value.Trim(); } }
    public string Status { get { return this._Status; } set { this._Status = value.Trim(); } }
    public string contractAmt { get { return this._contractAmt; } set { this._contractAmt = value.Trim(); } }
    public string expAmt { get { return this._expAmt; } set { this._expAmt = value.Trim(); } }
    public string serviceAmt { get { return this._serviceAmt; } set { this._serviceAmt = value.Trim(); } }
    public string startdate { get { return this._startdate; } set { this._startdate = value.Trim(); } }
    public string duedate { get { return this._duedate; } set { this._duedate = value.Trim(); } }
    public string completePercent { get { return this._completePercent; } set { this._completePercent = value.Trim(); } }
    public string currencyID { get { return this._currencyID; } set { this._currencyID = value.Trim(); } }
    public string iscustominvoice { get { return this._iscustominvoice; } set { this._iscustominvoice = value.Trim(); } }
    public string invoicePrefix { get { return this._invoicePrefix; } set { this._invoicePrefix = value.Trim(); } }
    public string invoiceSuffix { get { return this._invoiceSuffix; } set { this._invoiceSuffix = value.Trim(); } }
    public string invoicesno { get { return this._invoicesno; } set { this._invoicesno = value.Trim(); } }
    public string remark { get { return this._remark; } set { this._remark = value.Trim(); } }
    public string frequency { get { return this._frequency; } set { this._frequency = value.Trim(); } }
    public string po { get { return this._po; } set { this._po = value.Trim(); } }


    public string CreatedBy { get { return this._CreatedBy; } set { this._CreatedBy = value.Trim(); } }
    public string keyword { get { return this._keyword; } set { this._keyword = value.Trim(); } }
    public string from { get { return this._from; } set { this._from = value.Trim(); } }
    public string to { get { return this._to; } set { this._to = value.Trim(); } }

    public string description { get { return this._description; } set { this._description = value.Trim(); } }
    public string isbillable { get { return this._isbillable; } set { this._isbillable = value.Trim(); } }
    public string deptID { get { return this._deptID; } set { this._deptID = value.Trim(); } }
    public string costrate { get { return this._costrate; } set { this._costrate = value.Trim(); } }
    public string billrate { get { return this._billrate; } set { this._billrate = value.Trim(); } }
    public string empid { get { return this._empid; } set { this._empid = value.Trim(); } }
    public string taskid { get { return this._taskid; } set { this._taskid = value.Trim(); } }
    public string projectid { get { return this._projectid; } set { this._projectid = value.Trim(); } }
    public string hours { get { return this._hours; } set { this._hours = value.Trim(); } }
    public string isbilled { get { return this._isbilled; } set { this._isbilled = value.Trim(); } }

    public string expenseid { get { return this._expenseid; } set { this._expenseid = value.Trim(); } }
    public string units { get { return this._units; } set { this._units = value.Trim(); } }
    public string cost { get { return this._cost; } set { this._cost = value.Trim(); } }
    public string MU { get { return this._MU; } set { this._MU = value.Trim(); } }
    public string reimbursable { get { return this._reimbursable; } set { this._reimbursable = value.Trim(); } }
    public string date { get { return this._date; } set { this._date = value.Trim(); } }
    public string amount { get { return this._amount; } set { this._amount = value.Trim(); } }
    public string tax { get { return this._tax; } set { this._tax = value.Trim(); } }
    public string type { get { return this._type; } set { this._type = value.Trim(); } }
    public string taxid { get { return this._taxid; } set { this._taxid = value.Trim(); } }
    public string taxpercent { get { return this._taxpercent; } set { this._taxpercent = value.Trim(); } }

    public string grade { get { return this._grade; } set { this._grade = value.Trim(); } }
    public string groupid { get { return this._groupid; } set { this._groupid = value.Trim(); } }

    public string allocationid { get { return this._allocationid; } set { this._allocationid = value.Trim(); } }
    public string comments { get { return this._comments; } set { this._comments = value.Trim(); } }
    public string assignmentid { get { return this._assignmentid; } set { this._assignmentid = value.Trim(); } }
    public string parentid { get { return this._parentid; } set { this._parentid = value.Trim(); } }
    public string maintaskid { get { return this._maintaskid; } set { this._maintaskid = value.Trim(); } }
    public string title { get { return this._title; } set { this._title = value.Trim(); } }
    public string creationdate { get { return this._creationdate; } set { this._creationdate = value.Trim(); } }
    public string eststartdate { get { return this._eststartdate; } set { this._eststartdate = value.Trim(); } }
    public string enddate { get { return this._enddate; } set { this._enddate = value.Trim(); } }
    #endregion
    public string recurAmt { get { return this._recurAmt; } set { this._recurAmt = value.Trim(); } }
    public string recurintPeriod { get { return this._recurintPeriod; } set { this._recurintPeriod = value.Trim(); } }
    public string recurrenddate { get { return this._recurenddate; } set { this._recurenddate = value.Trim(); } }
    public string recurrstartdate { get { return this._recurstartdate; } set { this._recurstartdate = value.Trim(); } }
    #region Method

    public DataSet ManageProject()
    {
        dbcommand = db.GetStoredProcCommand("sp_project", action, nid, Code, name, companyId, clientid, managerId, contractType,
                     Status, contractAmt, expAmt, serviceAmt, startdate, duedate, completePercent, currencyID, iscustominvoice, invoicePrefix,
                     invoiceSuffix, invoicesno, remark, frequency, po, grt, tax, CreatedBy, keyword, from, to, amount, TBillable, Tmemorequired, EBillable, Ememorequired, budgetedHours, TReadonly, EReadOnly,
                     recurAmt, recurintPeriod, recurrstartdate, recurrenddate);
        return db.ExecuteDataSet(dbcommand);
    }

    public DataSet ManageTax()
    {
        dbcommand = db.GetStoredProcCommand("sp_TaxMaster", action, nid, name, tax, CreatedBy, companyId);
        return db.ExecuteDataSet(dbcommand);
    }
    public DataSet ManageTasks()
    {
        dbcommand = db.GetStoredProcCommand("sp_task", action, nid, Code, name, description, isbillable, Status, companyId, deptID, CreatedBy, costrate, billrate, tax, type, hours, isRemimb, MU);
        return db.ExecuteDataSet(dbcommand);
    }
    public DataSet GetBudgetedReport()
    {
        dbcommand = db.GetStoredProcCommand("sp_GetBudgetedReport", action, companyId, deptID, keyword);
        return db.ExecuteDataSet(dbcommand);
    }

    public DataSet ManageExpenseGroup()
    {
        dbcommand = db.GetStoredProcCommand("sp_ExpenseGroup", action, nid, name, taskid, type, CreatedBy, companyId);
        return db.ExecuteDataSet(dbcommand);
    }

    //------------------------------------Manage Expenses-------------------------------------------------------------

    public DataSet ManageExpenses()
    {
        dbcommand = db.GetStoredProcCommand("sp_expense", action, nid, Code, name, description, costrate, billrate, isbillable, companyId, Status, CreatedBy);
        return db.ExecuteDataSet(dbcommand);
    }


    public DataSet ReviewTimeExpense()
    {
        dbcommand = db.GetStoredProcCommand("sp_Reviewtimeexp", action, nid, date, empid, projectid, taskid, description, hours, units, Status, from, to);
        return db.ExecuteDataSet(dbcommand);
    }


    #endregion


    #region Assign Tasks
    public DataSet AssignTasks()
    {
        dbcommand = db.GetStoredProcCommand("sp_Assignment", action, nid, date, empid, clientid, taskid, Status, hours, remark, grade, description, companyId, CreatedBy, from, to, groupid, projectid, budgetedHours);
        return db.ExecuteDataSet(dbcommand);
    }
    public DataSet Mob_MyRandonInfo()
    {
        dbcommand = db.GetStoredProcCommand("sp_Mob_MyRandonInfo", action, empid);
        return db.ExecuteDataSet(dbcommand);
    }
    public DataSet assigntaskreport()
    {
        dbcommand = db.GetStoredProcCommand("sp_assigntaskreport", empid, clientid, taskid, Status, CreatedBy, from, to, projectid);
        return db.ExecuteDataSet(dbcommand);
    }
    public DataSet timesheetreport()
    {
        dbcommand = db.GetStoredProcCommand("sp_timesheetreport", empid, clientid, taskid, Status, CreatedBy, from, to, projectid, action, HttpContext.Current.Session["companyid"].ToString());
        return db.ExecuteDataSet(dbcommand);
    }
    public DataSet TimeExpenseReport()
    {
        dbcommand = db.GetStoredProcCommand("sp_TimeExpenseReport", action, empid, clientid, companyId, projectid, from, to);
        return db.ExecuteDataSet(dbcommand);
    }
    public DataSet TimeExpenseClientReport()
    {
        dbcommand = db.GetStoredProcCommand("sp_TimeExpenseClientReport", action, empid, clientid, companyId, projectid, from, to);
        return db.ExecuteDataSet(dbcommand);
    }
    public DataSet ExpenseDetailReport()
    {
        dbcommand = db.GetStoredProcCommand("sp_ExpenseDetailByEmp", action, empid, clientid, companyId, projectid, from, to);
        return db.ExecuteDataSet(dbcommand);
    }
    public DataSet AgingReport()
    {
        dbcommand = db.GetStoredProcCommand("sp_AgingReport", action, clientid, companyId, projectid, from, to, managerId, invoiceno);
        return db.ExecuteDataSet(dbcommand);
    }

    public DataSet Budget_Report()
    {
        dbcommand = db.GetStoredProcCommand("rpt_Budget_Report", action, clientid, companyId, projectid, from, to);
        return db.ExecuteDataSet(dbcommand);
    }
    #endregion


    #region Schedule

    public DataSet schedule()
    {
        dbcommand = db.GetStoredProcCommand("sp_Schedule", action, nid, empid, clientid, date, hours, Status, remark, CreatedBy, companyId, from, to, projectid, groupid, type);
        return db.ExecuteDataSet(dbcommand);


    }
    public DataSet insertschedule()
    {
        dbcommand = db.GetStoredProcCommand("sp_insertschedule", empid, clientid, date, Status, remark, CreatedBy, companyId, from, to, projectid, type);
        return db.ExecuteDataSet(dbcommand);


    }
    public DataSet checkschedule()
    {
        dbcommand = db.GetStoredProcCommand("sp_checkschedulexists", empid, clientid, companyId, from, to);
        return db.ExecuteDataSet(dbcommand);
    }
    public DataSet checkschedulexists_WebServices()
    {
        dbcommand = db.GetStoredProcCommand("sp_checkschedulexists_WebServices", empid, clientid, companyId, from, to);
        return db.ExecuteDataSet(dbcommand);
    }
    public DataSet checkAttendanceLogin_WebServices()
    {
        dbcommand = db.GetStoredProcCommand("sp_checkAttendanceLogin", id, parentid, companyId);
        return db.ExecuteDataSet(dbcommand);
    }
    public DataSet getCodeByNidforSchedule()
    {
        dbcommand = db.GetStoredProcCommand("sp_getCodeByNidforSchedule", empid, clientid);
        return db.ExecuteDataSet(dbcommand);
    }
    public DataSet GetPerformanceRpt()
    {
        dbcommand = db.GetStoredProcCommand("sp_performanceReport", empid, clientid, taskid, companyId, from, to);
        return db.ExecuteDataSet(dbcommand);


    }

    public DataSet GetCalendar()
    {
        //Here "managerid" used to Pass employee ID to get Assigned TAsks and "empid" to pass employee id for Schedule
        dbcommand = db.GetStoredProcCommand("sp_calendar", action, empid, managerId, from, to, companyId);
        return db.ExecuteDataSet(dbcommand);


    }
    #endregion

    #region Timesheet

    public DataSet manageFavoriteTasks()
    {
        dbcommand = db.GetStoredProcCommand("manageFavoriteTasks", action, nid, title, empid, taskid, startdate, projectid, hours, description, isbillable, remark, id
            );
        return db.ExecuteDataSet(dbcommand);
    }

    public DataSet ManageTimesheet()
    {
        dbcommand = db.GetStoredProcCommand("sp_timesheet", action, nid, taskid, startdate, empid, projectid, hours, description, isbillable, Status, companyId, isbilled, invoicesno, keyword, from, to, managerId, billrate, costrate, submittype, submitto
            );
        return db.ExecuteDataSet(dbcommand);
    }
    public DataSet ManageExpenseLog()
    {
        dbcommand = db.GetStoredProcCommand("sp_ExpenseLog", action, nid, expenseid, date, empid, projectid, description, units, cost, MU, amount, isbillable, Status, companyId, isbilled, invoicesno, keyword, from, to, managerId, reimbursable, remark, originalfile, savedfile);
        return db.ExecuteDataSet(dbcommand);
    }

    public DataSet timesheetrdlcreport()
    {
        dbcommand = db.GetStoredProcCommand("rpt_taskReport", empid, clientid, taskid, Status, CreatedBy, managerId, from, to, projectid, isbillable, isbilled, taskStatus, type, action, id, HttpContext.Current.Session["companyid"].ToString(), taskType);
        return db.ExecuteDataSet(dbcommand);
    }

    public DataSet TimesheetforDashboard()
    {
        dbcommand = db.GetStoredProcCommand("sp_TimesheetforDashboard", action, nid, empid, companyId, id
            );
        return db.ExecuteDataSet(dbcommand);
    }
    #endregion

    #region allocation task
    public DataSet Manageprojectmodule()
    {
        dbcommand = db.GetStoredProcCommand("sp_projectmodule", action, nid, assignmentid, projectid, parentid, maintaskid, title, eststartdate, enddate, hours, description, CreatedBy, creationdate, completePercent, clientid, empid, managerId, allocationid, companyId, groupid, from, to, Status, remark, hours, grade, comments);
        return db.ExecuteDataSet(dbcommand);
    }
    public DataSet rpt_ProjectAllocation()
    {
        dbcommand = db.GetStoredProcCommand("rpt_ProjectAllocation", action, nid, clientid, companyId);
        return db.ExecuteDataSet(dbcommand);
    }

    public DataSet GetProjectAllocationReport()
    {
        dbcommand = db.GetStoredProcCommand("sp_ProjectAllocationReport", action, projectid, companyId);
        return db.ExecuteDataSet(dbcommand);
    }
    public DataSet GetClientsProjectAllocationReport()
    {
        dbcommand = db.GetStoredProcCommand("sp_ClientsProjectAllocationReport", action, clientid, projectid, companyId);
        return db.ExecuteDataSet(dbcommand);
    }
    #endregion


    #region Invoice

    public DataSet insertInvoice(DataTable dt)
    {

        DataSet ds = new DataSet();
        SqlCommand cmd = new SqlCommand();
        SqlConnection con;
        con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["conn"].ConnectionString);
        cmd.Connection = con;
        con.Close();
        cmd.CommandText = "sp_Insertinvoice";
        cmd.Parameters.Clear();
        cmd.CommandType = CommandType.StoredProcedure;

        cmd.Parameters.AddWithValue("@nid", nid);
        cmd.Parameters.AddWithValue("@invoiceno", invoiceno);
        cmd.Parameters.AddWithValue("@invoicedate", date);
        cmd.Parameters.AddWithValue("@companyid", companyId);
        cmd.Parameters.AddWithValue("@projectid", projectid);
        cmd.Parameters.AddWithValue("@subamount", subamount);
        cmd.Parameters.AddWithValue("@tax", tax);
        cmd.Parameters.AddWithValue("@totalamount", totalamount);
        cmd.Parameters.AddWithValue("@discount", discount);
        cmd.Parameters.AddWithValue("@retainage", retainage);
        cmd.Parameters.AddWithValue("@amountpaid", amountpaid);
        cmd.Parameters.AddWithValue("@dueamount", dueamount);
        cmd.Parameters.AddWithValue("@billingaddress", description);
        cmd.Parameters.AddWithValue("@createdby", CreatedBy);
        cmd.Parameters.AddWithValue("@memo", remark);
        cmd.Parameters.AddWithValue("@markbilled", isbilled);
        cmd.Parameters.AddWithValue("@taxid", taxid);
        cmd.Parameters.AddWithValue("@taxpercent", taxpercent);
        cmd.Parameters.AddWithValue("@invoicetype", type);
        cmd.Parameters.AddWithValue("@contactperson", contact);
        cmd.Parameters.AddWithValue("@address2", address2);
        cmd.Parameters.AddWithValue("@state", state);
        cmd.Parameters.AddWithValue("@city", city);
        cmd.Parameters.AddWithValue("@country", country);
        cmd.Parameters.AddWithValue("@zip", zip);
        cmd.Parameters.AddWithValue("@billedtask", taskid);
        cmd.Parameters.AddWithValue("@tbl1", dt).SqlDbType = SqlDbType.Structured;
        SqlDataAdapter adapt = new SqlDataAdapter(cmd);
        con.Open();
        adapt.Fill(ds);
        //Execute
        // cmd.ExecuteNonQuery();
        con.Close();

        return ds;
    }

    public DataSet GetInvoice()
    {
        dbcommand = db.GetStoredProcCommand("sp_invoice", action, nid, invoiceno, date, companyId, projectid, subamount, tax, totalamount, discount, retainage, amountpaid, dueamount, description, remark, CreatedBy, from, to, clientid, Status, type);
        return db.ExecuteDataSet(dbcommand);
    }
    public DataSet printinvoice()
    {
        dbcommand = db.GetStoredProcCommand("sp_printinvoice", nid);
        return db.ExecuteDataSet(dbcommand);
    }
    public DataSet insertinvoicepayment()
    {
        dbcommand = db.GetStoredProcCommand("sp_InsertInvPayment", nid, date, clientid, projectid, invoiceno, amount, paymentmode, checkno, totalamount, CreatedBy, remark, companyId, type, retainage);
        return db.ExecuteDataSet(dbcommand);
    }
    public DataSet GetPaymentDetails()
    {
        dbcommand = db.GetStoredProcCommand("sp_InvoicePayment", action, nid, date, clientid, projectid, invoiceno, paymentmode, checkno, amount, CreatedBy, remark, companyId, from, to);
        return db.ExecuteDataSet(dbcommand);
    }

    #endregion

    #region "Client Report"
    public DataSet ManageProjectMasterClient()
    {
        dbcommand = db.GetStoredProcCommand("sp_projectMasterClient", action, nid, projectid, name, companyId, clientid, managerId, contractType,
                     Status, contractAmt, expAmt, serviceAmt, startdate, duedate, completePercent, currencyID, iscustominvoice, invoicePrefix,
                     invoiceSuffix, invoicesno, remark, frequency, po, grt, tax, CreatedBy, keyword, from, to);
        return db.ExecuteDataSet(dbcommand);
    }

    public DataSet Clientrdlcreport()
    {
        dbcommand = db.GetStoredProcCommand("rpt_ClientReport", action, clientid, HttpContext.Current.Session["companyid"].ToString(), empid);
        return db.ExecuteDataSet(dbcommand);
    }
    #endregion

    public DataSet Invoicerdlcreport()
    {
        dbcommand = db.GetStoredProcCommand("rpt_invoiceReport", action, invoiceno, HttpContext.Current.Session["companyid"].ToString(), projectid, CreatedBy, from, to, clientid, Status, type);
        return db.ExecuteDataSet(dbcommand);
    }
    #region Budget

    public DataSet Budget_Insert(DataTable dt)
    {

        DataSet ds = new DataSet();
        SqlCommand cmd = new SqlCommand();
        SqlConnection con;
        con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["conn"].ConnectionString);
        cmd.Connection = con;
        con.Close();
        cmd.CommandText = "sp_Budget_Insert";
        cmd.Parameters.Clear();
        cmd.CommandType = CommandType.StoredProcedure;
       
        cmd.Parameters.AddWithValue("@nid", nid);
        cmd.Parameters.AddWithValue("@projectid", projectid);
        cmd.Parameters.AddWithValue("@budgetTitle", title);
        cmd.Parameters.AddWithValue("@createdby", CreatedBy);       
        cmd.Parameters.AddWithValue("@companyid", companyId);
        cmd.Parameters.AddWithValue("@isimport", Status);
        cmd.Parameters.AddWithValue("@tbl", dt).SqlDbType = SqlDbType.Structured;
        SqlDataAdapter adapt = new SqlDataAdapter(cmd);
        con.Open();
        adapt.Fill(ds);
        //Execute
        // cmd.ExecuteNonQuery();
        con.Close();

        return ds;
    }

    public DataSet Budget_Import(DataTable dt)
    {

        DataSet ds = new DataSet();
        SqlCommand cmd = new SqlCommand();
        SqlConnection con;
        con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["conn"].ConnectionString);
        cmd.Connection = con;
        con.Close();
        cmd.CommandText = "sp_Budget_Import";
        cmd.Parameters.Clear();
        cmd.CommandType = CommandType.StoredProcedure;
       
        cmd.Parameters.AddWithValue("@companyid", companyId);
        cmd.Parameters.AddWithValue("@tbl", dt).SqlDbType = SqlDbType.Structured;
        SqlDataAdapter adapt = new SqlDataAdapter(cmd);
        con.Open();
        adapt.Fill(ds);
        //Execute
        // cmd.ExecuteNonQuery();
        con.Close();

        return ds;
    }

    public DataSet Budget_Manage()
    {
        dbcommand = db.GetStoredProcCommand("sp_Budget_Manage", action, nid, projectid, companyId);
        return db.ExecuteDataSet(dbcommand);
    }
    #endregion
}

