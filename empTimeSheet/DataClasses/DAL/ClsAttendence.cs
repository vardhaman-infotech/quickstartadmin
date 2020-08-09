using System.Data;
using empTimeSheet.DataClasses.DAL;


public class ClsAttendence : clsDAL
{

    public string _action, _enrollno, _date, _companyid, _ptime, _ptime1, _inid, _onid, _addedby, _endDate;

    public string Action { get { return this._action; } set { this._action = value.Trim(); } }
    public string Enrollno { get { return this._enrollno; } set { this._enrollno = value.Trim(); } }
    public string Date { get { return this._date; } set { this._date = value.Trim(); } }
    public string Ptime { get { return this._ptime; } set { this._ptime = value.Trim(); } }
    public string PTime1 { get { return this._ptime1; } set { this._ptime1 = value.Trim(); } }
    public string Inid { get { return this._inid; } set { this._inid = value.Trim(); } }
    public string Onid { get { return this._onid; } set { this._onid = value.Trim(); } }
    public string AddedBy { get { return this._addedby; } set { this._addedby = value.Trim(); } }

    public string EndDate { get { return this._endDate; } set { this._endDate = value.Trim(); } }
    public string CompanyID { get { return this._companyid; } set { this._companyid = value; } }

    public DataSet GetAttendence()
    {
        dbcommand = db.GetStoredProcCommand("sp_GetAttendence", Action, Enrollno, Date, EndDate, CompanyID);
        return db.ExecuteDataSet(dbcommand);
    }

    public DataSet OpAttendance()
    {
        dbcommand = db.GetStoredProcCommand("sp_Attendance", Action, Enrollno, Date, Ptime, PTime1, CompanyID, Inid, Onid, AddedBy);
        return db.ExecuteDataSet(dbcommand);
    }
}


