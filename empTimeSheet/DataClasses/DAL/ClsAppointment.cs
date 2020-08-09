using System.Data;
using System.Data.SqlClient;
using empTimeSheet.DataClasses.DAL;
using System.Web;


public class ClsAppointment : clsDAL
{
    private string _action,_nid,_empid,_aDate,_afrmTime,_aToTime,_fromdate,_todate,_companyid,_desig,_email,_address,_status,_vname,_city,_state,_zip,_service,_sloatid,
    _contact,_rectype;

    #region Variables
    public string rectype { get { return this._rectype; } set { this._rectype = value.Trim(); } }
    public string sloatid { get { return this._sloatid; } set { this._sloatid = value.Trim(); } }
    public string service { get { return this._service; } set { this._service = value.Trim(); } }
    public string contact { get { return this._contact; } set { this._contact = value.Trim(); } }
    public string city { get { return this._city; } set { this._city = value.Trim(); } }
    public string state { get { return this._state; } set { this._state = value.Trim(); } }
    public string zip { get { return this._zip; } set { this._zip = value.Trim(); } }

    public string desig { get { return this._desig; } set { this._desig = value.Trim(); } }
    public string email { get { return this._email; } set { this._email = value.Trim(); } }
    public string address { get { return this._address; } set { this._address = value.Trim(); } }
    public string status { get { return this._status; } set { this._status = value.Trim(); } }
    public string vname { get { return this._vname; } set { this._vname = value.Trim(); } }
  

    public string action { get { return this._action; } set { this._action = value.Trim(); } }
    public string nid { get { return this._nid; } set { this._nid = value.Trim(); } }
    public string empid { get { return this._empid; } set { this._empid = value.Trim(); } }
    public string aDate { get { return this._aDate; } set { this._aDate = value.Trim(); } }
    public string afrmTime { get { return this._afrmTime; } set { this._afrmTime = value.Trim(); } }
    public string aToTime { get { return this._aToTime; } set { this._aToTime = value.Trim(); } }
    public string companyid { get { return this._companyid; } set { this._companyid = value.Trim(); } }
    public string fromdate { get { return this._fromdate; } set { this._fromdate = value.Trim(); } }
    public string todate { get { return this._todate; } set { this._todate = value.Trim(); } }
    #endregion
    
    
    public DataSet APP_ManageAvailability()
    {
        dbcommand = db.GetStoredProcCommand("sp_APP_ManageAvailability", action, nid, empid, aDate, afrmTime, aToTime, fromdate, todate, companyid, rectype);
        return db.ExecuteDataSet(dbcommand);
    }
    public DataSet APP_ManageAppointment()
    {
        dbcommand = db.GetStoredProcCommand("sp_APP_ManageAppointment", action, nid, empid, aDate, afrmTime, aToTime, vname, desig, companyid, email, address, city, state, zip, service, contact, status, fromdate, todate);
        return db.ExecuteDataSet(dbcommand);
    }

    public DataSet APP_ManageAppointment_new()
    {
        dbcommand = db.GetStoredProcCommand("sp_APP_ManageAppointment_new", action, nid, empid,sloatid, aDate, afrmTime, aToTime, vname, desig, companyid, email, address, city, state, zip, service, contact, status, fromdate, todate);
        return db.ExecuteDataSet(dbcommand);
    }


    public DataSet APP_getAvailability()
    {
        dbcommand = db.GetStoredProcCommand("sp_APP_getAvailability", empid, aDate);
        return db.ExecuteDataSet(dbcommand);
    }
}
