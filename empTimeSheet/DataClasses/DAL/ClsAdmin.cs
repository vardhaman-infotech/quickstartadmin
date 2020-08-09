using System.Data;
using empTimeSheet.DataClasses.DAL;
using System.Web;

public class ClsAdmin : clsDAL
{
    DataSet ds = new DataSet();


    #region properties

    private string _nid, _loginid, _action, _pass, _parentid, _symbol;
    private string _Name, _address, _cityId, _stateId, _countryId, _zip, _phone, _fax, _contactPerson, _email, _website, _logoURL, _creationDate, _imgurl;
    private string _userType, _companyId, _roles, _managerid, _submitTo, _deptId, _desigId, _joinDate, _releasedDate, _remark, _userid, _status, _code, _mobile;
    private string _keyword, _fromdate, _todate, _fname, _lname;
    private string _senderemail, _senderpass, _receivermail, _mailhost, _servercompnyname, _emailnotification, _scheduleemail, _leaveemail;
    private string _invoicetemplate,_invno,_prefix,_sufix,_timezone;
    private string _machineReadrUsrName, _machineReadrPswd;



    public string machineReadrUsrName { get { return this._machineReadrUsrName; } set { this._machineReadrUsrName = value.Trim(); } }
    public string machineReadrPswd { get { return this._machineReadrPswd; } set { this._machineReadrPswd = value.Trim(); } }
    public string timezone
    {
        get
        {
            return this._timezone;
        }
        set
        {
            this._timezone = value.Trim();
        }
    }

    public string invno
    {
        get
        {
            return this._invno;
        }
        set
        {
            this._invno = value.Trim();
        }
    }
    public string prefix
    {
        get
        {
            return this._prefix;
        }
        set
        {
            this._prefix = value.Trim();
        }
    }
    public string sufix
    {
        get
        {
            return this._sufix;
        }
        set
        {
            this._sufix = value.Trim();
        }
    }

    public string invoicetemplate
    {
        get
        {
            return this._invoicetemplate;
        }
        set
        {
            this._invoicetemplate = value.Trim();
        }
    }
    public string leaveemail
    {
        get
        {
            return this._leaveemail;
        }
        set
        {
            this._leaveemail = value.Trim();
        }
    }
    public string scheduleemail
    {
        get
        {
            return this._scheduleemail;
        }
        set
        {
            this._scheduleemail = value.Trim();
        }
    }
    public string emailnotification
    {
        get
        {
            return this._emailnotification;
        }
        set
        {
            this._emailnotification = value.Trim();
        }
    }
    public string servercompnyname
    {
        get
        {
            return this._servercompnyname;
        }
        set
        {
            this._servercompnyname = value.Trim();
        }
    }
    public string mailhost
    {
        get
        {
            return this._mailhost;
        }
        set
        {
            this._mailhost = value.Trim();
        }
    }
    public string receivermail
    {
        get
        {
            return this._receivermail;
        }
        set
        {
            this._receivermail = value.Trim();
        }
    }
    public string senderpass
    {
        get
        {
            return this._senderpass;
        }
        set
        {
            this._senderpass = value.Trim();
        }
    }
    public string senderemail
    {
        get
        {
            return this._senderemail;
        }
        set
        {
            this._senderemail = value.Trim();
        }
    }
    public string fname
    {
        get
        {
            return this._fname;
        }
        set
        {
            this._fname = value.Trim();
        }
    }
    public string lname
    {
        get
        {
            return this._lname;
        }
        set
        {
            this._lname = value.Trim();
        }
    }
    public string nid
    {
        get
        {
            return this._nid;
        }
        set
        {
            this._nid = value.Trim();
        }
    }
    public string loginid
    {
        get
        {
            return this._loginid;
        }
        set
        {
            this._loginid = value.Trim();
        }
    }
    public string action
    {
        get
        {
            return this._action;
        }
        set
        {
            this._action = value.Trim();
        }
    }

    public string pass
    {
        get
        {
            return this._pass;
        }
        set
        {
            this._pass = value.Trim();
        }
    }

    public string Name { get { return this._Name; } set { this._Name = value.Trim(); } }
    public string address { get { return this._address; } set { this._address = value.Trim(); } }
    public string cityId { get { return this._cityId; } set { this._cityId = value.Trim(); } }
    public string stateId { get { return this._stateId; } set { this._stateId = value.Trim(); } }
    public string countryId { get { return this._countryId; } set { this._countryId = value.Trim(); } }
    public string zip { get { return this._zip; } set { this._zip = value.Trim(); } }
    public string phone { get { return this._phone; } set { this._phone = value.Trim(); } }
    public string fax { get { return this._fax; } set { this._fax = value.Trim(); } }
    public string contactPerson { get { return this._contactPerson; } set { this._contactPerson = value.Trim(); } }
    public string email { get { return this._email; } set { this._email = value.Trim(); } }
    public string website { get { return this._website; } set { this._website = value.Trim(); } }
    public string logoURL { get { return this._logoURL; } set { this._logoURL = value.Trim(); } }
    public string creationDate { get { return this._creationDate; } set { this._creationDate = value.Trim(); } }
    public string imgurl { get { return this._imgurl; } set { this._imgurl = value.Trim(); } }
    public string parentid { get { return this._parentid; } set { this._parentid = value.Trim(); } }
    public string symbol { get { return this._symbol; } set { this._symbol = value.Trim(); } }
    public string userType { get { return this._userType; } set { this._userType = value.Trim(); } }
    public string companyId { get { return this._companyId; } set { this._companyId = value.Trim(); } }
    public string roles { get { return this._roles; } set { this._roles = value.Trim(); } }
    public string managerid { get { return this._managerid; } set { this._managerid = value.Trim(); } }
    public string submitTo { get { return this._submitTo; } set { this._submitTo = value.Trim(); } }
    public string deptId { get { return this._deptId; } set { this._deptId = value.Trim(); } }
    public string desigId { get { return this._desigId; } set { this._desigId = value.Trim(); } }
    public string joinDate { get { return this._joinDate; } set { this._joinDate = value.Trim(); } }
    public string releasedDate { get { return this._releasedDate; } set { this._releasedDate = value.Trim(); } }
    public string remark { get { return this._remark; } set { this._remark = value.Trim(); } }
    public string userid { get { return this._userid; } set { this._userid = value.Trim(); } }
    public string status { get { return this._status; } set { this._status = value.Trim(); } }
    public string code { get { return this._code; } set { this._code = value.Trim(); } }
    public string mobile { get { return this._mobile; } set { this._mobile = value.Trim(); } }
    public string keyword { get { return this._keyword; } set { this._keyword = value.Trim(); } }
    public string fromdate { get { return this._fromdate; } set { this._fromdate = value.Trim(); } }
    public string todate { get { return this._todate; } set { this._todate = value.Trim(); } }



    #endregion

    #region general function
    public bool validatelogin()
    {
        if ((HttpContext.Current.Session["adminid"] != null) && (HttpContext.Current.Session["adminname"] != null))
            return true;
        else
            return false;
    }
    #endregion

    #region methods

    public DataSet ManageAdmin()
    {
        dbcommand = db.GetStoredProcCommand("sp_ManageAdmin", loginid, pass, action, nid);
        ds = db.ExecuteDataSet(dbcommand);
        return ds;


    }
    public DataSet ManageCompany()
    {
        dbcommand = db.GetStoredProcCommand("sp_ManageCompany", action, nid, code, Name, address, cityId, stateId, countryId, zip, phone, fax, contactPerson, email, website, imgurl, creationDate, symbol, logoURL, invno, prefix, sufix);
        ds = db.ExecuteDataSet(dbcommand);
        return ds;

    }
    public DataSet ManageMaster()
    {
        dbcommand = db.GetStoredProcCommand("sp_managemaster", action, nid, Name, parentid, symbol);
        ds = db.ExecuteDataSet(dbcommand);
        return ds;

    }
    //Manage Employee
    public DataSet ManageUser()
    {
        //dbcommand = db.GetStoredProcCommand("sp_ManageUser", action, nid, loginid, Name, pass, userType, companyId, roles, managerid, submitTo, deptId, desigId, joinDate, releasedDate, userid, creationDate, status, code, address, cityId, stateId, zip, countryId, email, phone, mobile, fax, remark, keyword, fromdate, todate);
        dbcommand = db.GetStoredProcCommand("sp_ManageEmployee", action, nid, loginid, fname, lname, pass, userType, companyId, roles, managerid, submitTo, deptId, desigId, joinDate, releasedDate, userid, status, imgurl, email);

        ds = db.ExecuteDataSet(dbcommand);
        return ds;

    }

    public DataSet ManageAddress()
    {
        dbcommand = db.GetStoredProcCommand("sp_address", action, nid, companyId, userid, userType, Name, address, cityId, stateId, countryId, zip, email, phone, mobile, fax, remark);
        return db.ExecuteDataSet(dbcommand);

    }

    public DataSet ManageSettings()
    {
        dbcommand = db.GetStoredProcCommand("sp_Settings", action, companyId, Name, email, website, senderemail, senderpass, receivermail, mailhost, servercompnyname, emailnotification, logoURL, imgurl, userid, scheduleemail, leaveemail, symbol, invoicetemplate, invno, prefix, sufix, timezone, machineReadrUsrName, machineReadrPswd);
        ds = db.ExecuteDataSet(dbcommand);
        return ds;

    }

    public DataSet CompanySettings()
    {
        dbcommand = db.GetStoredProcCommand("sp_CompanySettings", action, companyId, Name, email, website, senderemail, senderpass, receivermail, mailhost, servercompnyname, emailnotification, logoURL, imgurl, userid, scheduleemail, leaveemail, symbol, invoicetemplate, invno, prefix, sufix, timezone, machineReadrUsrName, machineReadrPswd, contactPerson, address, cityId, stateId, countryId, zip, phone, fax);
        ds = db.ExecuteDataSet(dbcommand);
        return ds;

    }
    public DataSet getCompanybyCode()
    {
        dbcommand = db.GetStoredProcCommand("sp_getCompanybyCode", code);
        ds = db.ExecuteDataSet(dbcommand);
        return ds;
    }

    #endregion
}
