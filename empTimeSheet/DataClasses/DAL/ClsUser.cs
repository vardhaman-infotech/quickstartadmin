using System.Data;
using empTimeSheet.DataClasses.DAL;


public class ClsUser : clsDAL
{
    private string _action, _activestatus, _billrate, _city, _companyid, _createdby, _currencyId, _deptid, _desigid, _email, _empid, _fax, _id, _joindate, _loginid, _managerid, _mobile, _name, _overheadMulti, _overtimeBillRate, _overtimePayrate, _password, _PayPeriod, _payrate, _phone, _releaseddate, _remark, _roles, _salaryAmount, _state, _street, _submitto, _userid, _username, _usertype, _zip;
    private string _clientname, _companyname, _fname, _lname, _country, _website, _imgurl, _address2, _workphone, _timezone, _roletype, _enrollno, _dob, _typeid,_dob1,_dob2,_dob3,_projectid,_fromdate,_todate;


    public ClsUser()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    #region Variables
    public string projectid { get { return this._projectid; } set { this._projectid = value.Trim(); } }
    public string fromdate { get { return this._fromdate; } set { this._fromdate = value.Trim(); } }
    public string todate { get { return this._todate; } set { this._todate = value.Trim(); } }

    public string dob1 { get { return this._dob1; } set { this._dob1 = value.Trim(); } }
    public string dob2 { get { return this._dob2; } set { this._dob2 = value.Trim(); } }
    public string dob3 { get { return this._dob3; } set { this._dob3 = value.Trim(); } }
    public string dob { get { return this._dob; } set { this._dob = value.Trim(); } }
    public string enrollno { get { return this._enrollno; } set { this._enrollno = value.Trim(); } }
    public string roletype { get { return this._roletype; } set { this._roletype = value.Trim(); } }
    public string workphone { get { return this._workphone; } set { this._workphone = value.Trim(); } }
    public string address2 { get { return this._address2; } set { this._address2 = value.Trim(); } }
    public string website { get { return this._website; } set { this._website = value.Trim(); } }
    public string lname { get { return this._lname; } set { this._lname = value.Trim(); } }
    public string fname { get { return this._fname; } set { this._fname = value.Trim(); } }
    public string companyname { get { return this._companyname; } set { this._companyname = value.Trim(); } }
    public string clientname { get { return this._clientname; } set { this._clientname = value.Trim(); } }
    public string action { get { return this._action; } set { this._action = value.Trim(); } }
    public string activestatus { get { return this._activestatus; } set { this._activestatus = value.Trim(); } }
    public string billrate { get { return this._billrate; } set { this._billrate = value.Trim(); } }
    public string city { get { return this._city; } set { this._city = value.Trim(); } }
    public string companyid { get { return this._companyid; } set { this._companyid = value.Trim(); } }
    public string createdby { get { return this._createdby; } set { this._createdby = value.Trim(); } }
    public string currencyId { get { return this._currencyId; } set { this._currencyId = value.Trim(); } }
    public string deptid { get { return this._deptid; } set { this._deptid = value.Trim(); } }
    public string desigid { get { return this._desigid; } set { this._desigid = value.Trim(); } }
    public string email { get { return this._email; } set { this._email = value.Trim(); } }
    public string empid { get { return this._empid; } set { this._empid = value.Trim(); } }
    public string fax { get { return this._fax; } set { this._fax = value.Trim(); } }
    public string id { get { return this._id; } set { this._id = value.Trim(); } }
    public string joindate { get { return this._joindate; } set { this._joindate = value.Trim(); } }
    public string loginid { get { return this._loginid; } set { this._loginid = value.Trim(); } }
    public string managerid { get { return this._managerid; } set { this._managerid = value.Trim(); } }
    public string mobile { get { return this._mobile; } set { this._mobile = value.Trim(); } }
    public string name { get { return this._name; } set { this._name = value.Trim(); } }
    public string overheadMulti { get { return this._overheadMulti; } set { this._overheadMulti = value.Trim(); } }
    public string overtimeBillRate { get { return this._overtimeBillRate; } set { this._overtimeBillRate = value.Trim(); } }
    public string overtimePayrate { get { return this._overtimePayrate; } set { this._overtimePayrate = value.Trim(); } }
    public string password { get { return this._password; } set { this._password = value.Trim(); } }
    public string PayPeriod { get { return this._PayPeriod; } set { this._PayPeriod = value.Trim(); } }
    public string payrate { get { return this._payrate; } set { this._payrate = value.Trim(); } }
    public string phone { get { return this._phone; } set { this._phone = value.Trim(); } }
    public string releaseddate { get { return this._releaseddate; } set { this._releaseddate = value.Trim(); } }
    public string remark { get { return this._remark; } set { this._remark = value.Trim(); } }
    public string roles { get { return this._roles; } set { this._roles = value.Trim(); } }
    public string salaryAmount { get { return this._salaryAmount; } set { this._salaryAmount = value.Trim(); } }
    public string state { get { return this._state; } set { this._state = value.Trim(); } }
    public string street { get { return this._street; } set { this._street = value.Trim(); } }
    public string submitto { get { return this._submitto; } set { this._submitto = value.Trim(); } }
    public string userid { get { return this._userid; } set { this._userid = value.Trim(); } }
    public string username { get { return this._username; } set { this._username = value.Trim(); } }
    public string usertype { get { return this._usertype; } set { this._usertype = value.Trim(); } }
    public string zip { get { return this._zip; } set { this._zip = value.Trim(); } }
    public string country { get { return this._country; } set { this._country = value.Trim(); } }
    public string imgurl { get { return this._imgurl; } set { this._imgurl = value.Trim(); } }
    public string timezone { get { return this._timezone; } set { this._timezone = value.Trim(); } }
    public string typeid { get { return this._typeid; } set { this._typeid = value.Trim(); } }

    public bool appointment { get;   set; }

    #endregion

    public DataSet address()
    {
        dbcommand = db.GetStoredProcCommand("sp_address", action, id, companyid, userid, usertype, name, street, city, state, country, zip, email, phone, mobile, fax, remark);
        return db.ExecuteDataSet(dbcommand);

    }

    public DataSet emprate()
    {
        dbcommand = db.GetStoredProcCommand("sp_emprate", action, id, empid, billrate, payrate, overtimeBillRate, overtimePayrate, overheadMulti, currencyId, PayPeriod, salaryAmount);
        return db.ExecuteDataSet(dbcommand);

    }

    public DataSet ManageEmployee()
    {
        dbcommand = db.GetStoredProcCommand("sp_ManageEmployee", action, id, loginid, fname, lname, password, usertype, companyid, roles, managerid, submitto, deptid, desigid, joindate, releaseddate, createdby, activestatus, imgurl, email,timezone,enrollno,dob,appointment);
        return db.ExecuteDataSet(dbcommand);

    }
    public DataSet FavouriteReports()
    {
        dbcommand = db.GetStoredProcCommand("sp_FavouriteReports", action, userid, fname, lname);
        return db.ExecuteDataSet(dbcommand);

    }
    public DataSet client()
    {
        dbcommand = db.GetStoredProcCommand("sp_client", action, id, companyid, managerid, createdby, loginid, companyname, clientname, activestatus, street, city, state, country, zip, email, phone, mobile, fax, website,desigid,address2,workphone);
        return db.ExecuteDataSet(dbcommand);

    }
    public DataSet ManageClientGroup()
    {
        dbcommand = db.GetStoredProcCommand("sp_ClientGroup", action, id, name, clientname, createdby, companyid);
        return db.ExecuteDataSet(dbcommand);

    }
    public DataSet ManageProjectGroup()
    {
        dbcommand = db.GetStoredProcCommand("sp_ProjectGroup", action, id, name, clientname, createdby, companyid);
        return db.ExecuteDataSet(dbcommand);
    }
    public DataSet ManageEmployeeGroup()
    {
        dbcommand = db.GetStoredProcCommand("sp_EmployeeGroup", action, id, name, empid, createdby, companyid);
        return db.ExecuteDataSet(dbcommand);

    }
    public DataSet manageProjectLog()
    {
        dbcommand = db.GetStoredProcCommand("sp_manageProjectLog", action, id,typeid,remark,dob,empid,projectid,dob1,dob2,userid, companyid,fromdate,todate);
        return db.ExecuteDataSet(dbcommand);
    }

   
}
