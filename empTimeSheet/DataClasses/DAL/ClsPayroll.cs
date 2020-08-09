using System.Data;
using System.Data.SqlClient;
using empTimeSheet.DataClasses.DAL;

public class ClsPayroll : clsDAL
{

    private string _action, _nid, _Empid, _Date, _NumofDays, _RequestDate, _Leavetypeid, _Description, _Createdby, _Status, _Remark, _ApprovDate, _Companyid, _from, _to, _type;
    private string _year, _month, _name;
    private string _title, _calType, _calGroup, _amount;
    private string _totalCTC, _ctcDuration, _structureid, _basicsalary, _bankname, _accountnum, _pfaccountnum;
    private string _startdate, _enddate, _date, _empSalaryId, _MasterId, _salaryid, _bonus, _TotalEarnings, _TotalDeduction, _NetPayment, _payabledays;
    private string _paymentstatus, _PaymentMode, _CheckNo,_holidaytype;
    private string _monthto,_loginid;
    DataTable dt;

    #region Variables
    public string loginid { get { return this._loginid; } set { this._loginid = value.Trim(); } }
    public string holidaytype { get { return this._holidaytype; } set { this._holidaytype = value.Trim(); } }
    public string monthto { get { return this._monthto; } set { this._monthto = value.Trim(); } }
    public string basicsalary { get { return this._basicsalary; } set { this._basicsalary = value.Trim(); } }
    public string bankname { get { return this._bankname; } set { this._bankname = value.Trim(); } }
    public string accountnum { get { return this._accountnum; } set { this._accountnum = value.Trim(); } }
    public string pfaccountnum { get { return this._pfaccountnum; } set { this._pfaccountnum = value.Trim(); } }

    public string structureid { get { return this._structureid; } set { this._structureid = value.Trim(); } }
    public string ctcDuration { get { return this._ctcDuration; } set { this._ctcDuration = value.Trim(); } }
    public string totalCTC { get { return this._totalCTC; } set { this._totalCTC = value.Trim(); } }
    public string amount { get { return this._amount; } set { this._amount = value.Trim(); } }
    public string title { get { return this._title; } set { this._title = value.Trim(); } }
    public string calType { get { return this._calType; } set { this._calType = value.Trim(); } }
    public string calGroup { get { return this._calGroup; } set { this._calGroup = value.Trim(); } }

    public string action { get { return this._action; } set { this._action = value.Trim(); } }
    public string nid { get { return this._nid; } set { this._nid = value.Trim(); } }
    public string Empid { get { return this._Empid; } set { this._Empid = value.Trim(); } }
    public string Date { get { return this._Date; } set { this._Date = value.Trim(); } }
    public string NumofDays { get { return this._NumofDays; } set { this._NumofDays = value.Trim(); } }
    public string RequestDate { get { return this._RequestDate; } set { this._RequestDate = value.Trim(); } }
    public string Leavetypeid { get { return this._Leavetypeid; } set { this._Leavetypeid = value.Trim(); } }
    public string Description { get { return this._Description; } set { this._Description = value.Trim(); } }
    public string Createdby { get { return this._Createdby; } set { this._Createdby = value.Trim(); } }
    public string Status { get { return this._Status; } set { this._Status = value.Trim(); } }
    public string Remark { get { return this._Remark; } set { this._Remark = value.Trim(); } }
    public string ApprovDate { get { return this._ApprovDate; } set { this._ApprovDate = value.Trim(); } }
    public string companyid { get { return this._Companyid; } set { this._Companyid = value.Trim(); } }
    public string from { get { return this._from; } set { this._from = value.Trim(); } }
    public string to { get { return this._to; } set { this._to = value.Trim(); } }
    public string type { get { return this._type; } set { this._type = value.Trim(); } }


    public string year { get { return this._year; } set { this._year = value.Trim(); } }
    public string month { get { return this._month; } set { this._month = value.Trim(); } }
    public string name { get { return this._name; } set { this._name = value.Trim(); } }



    public string startdate { get { return this._startdate; } set { this._startdate = value.Trim(); } }
    public string enddate { get { return this._enddate; } set { this._enddate = value.Trim(); } }

    public string date { get { return this._date; } set { this._date = value.Trim(); } }
    public string empSalaryId { get { return this._empSalaryId; } set { this._empSalaryId = value.Trim(); } }
    public string MasterId { get { return this._MasterId; } set { this._MasterId = value.Trim(); } }
    public string salaryid { get { return this._salaryid; } set { this._salaryid = value.Trim(); } }
    public string bonus { get { return this._bonus; } set { this._bonus = value.Trim(); } }
    public string TotalEarnings { get { return this._TotalEarnings; } set { this._TotalEarnings = value.Trim(); } }
    public string TotalDeduction { get { return this._TotalDeduction; } set { this._TotalDeduction = value.Trim(); } }
    public string NetPayment { get { return this._NetPayment; } set { this._NetPayment = value.Trim(); } }
    public string payabledays { get { return this._payabledays; } set { this._payabledays = value.Trim(); } }
    public string paymentstatus { get { return this._paymentstatus; } set { this._paymentstatus = value.Trim(); } }
    public string PaymentMode { get { return this._PaymentMode; } set { this._PaymentMode = value.Trim(); } }
    public string CheckNo { get { return this._CheckNo; } set { this._CheckNo = value.Trim(); } }

    #endregion


    #region Payroll
    public DataSet LeaveRequest()
    {
        dbcommand = db.GetStoredProcCommand("sp_LeaveRequest", action, nid, Empid, Date, NumofDays, RequestDate, Leavetypeid, Description, Createdby, Status, Remark, ApprovDate, companyid, from, to, loginid);
        return db.ExecuteDataSet(dbcommand);
    }
    public DataSet Holiday()
    {
        dbcommand = db.GetStoredProcCommand("sp_holiday", action, nid, Date, name, companyid, Createdby, from, to, year, month, type, holidaytype);
        return db.ExecuteDataSet(dbcommand);
    }

    public DataSet salaryStructure()
    {
        dbcommand = db.GetStoredProcCommand("salaryStructure", action, nid, title, amount, calType, calGroup, companyid);
        return db.ExecuteDataSet(dbcommand);
    }
    public DataSet EmpSalarySetUp()
    {
        dbcommand = db.GetStoredProcCommand("sp_EmpSalarySetUp", action, nid, Empid, totalCTC, ctcDuration, structureid, amount, title, calType, companyid, basicsalary, bankname, accountnum, pfaccountnum);
        return db.ExecuteDataSet(dbcommand);
    }
    public DataSet GenerateSalary()
    {
        dbcommand = db.GetStoredProcCommand("sp_GenerateSalary", action, nid, Empid, month, year, startdate, enddate, date, empSalaryId, MasterId, amount, salaryid,
        bonus, TotalEarnings, TotalDeduction, NetPayment, payabledays, paymentstatus, PaymentMode, CheckNo, Createdby, companyid, from, to);
        return db.ExecuteDataSet(dbcommand);
    }
    public DataSet InsertSalary()
    {
        dbcommand = db.GetStoredProcCommand("sp_InsertSalary", action, nid, month, year, startdate, enddate, Createdby, companyid,dt);
        return db.ExecuteDataSet(dbcommand);
    }

    public DataSet InsertSalary(DataTable dt)
    {

        DataSet ds = new DataSet();
        SqlCommand cmd = new SqlCommand();
        SqlConnection con;
        con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["conn"].ConnectionString);
        cmd.Connection = con;
        con.Close();
        cmd.CommandText = "sp_InsertSalary";
        cmd.Parameters.Clear();
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@action", action);
        cmd.Parameters.AddWithValue("@nid", nid);
        cmd.Parameters.AddWithValue("@month", month);
        cmd.Parameters.AddWithValue("@year", year);
        cmd.Parameters.AddWithValue("@startdate",startdate);
        cmd.Parameters.AddWithValue("@enddate", enddate);
        cmd.Parameters.AddWithValue("@createdby", Createdby);
        cmd.Parameters.AddWithValue("@companyid", companyid);
        cmd.Parameters.AddWithValue("@tbl1", dt).SqlDbType = SqlDbType.Structured;
        SqlDataAdapter adapt = new SqlDataAdapter(cmd);
        con.Open();
        adapt.Fill(ds);
        //Execute
        // cmd.ExecuteNonQuery();
        con.Close();

        return ds;
    }

    #region report
    public DataSet PayrollReport()
    {
        dbcommand = db.GetStoredProcCommand("sp_PayrollReport", action, nid, month,monthto, year, startdate, enddate,Empid, Createdby, companyid,salaryid,empSalaryId);
        return db.ExecuteDataSet(dbcommand);
    }

    #endregion
    #endregion
}
