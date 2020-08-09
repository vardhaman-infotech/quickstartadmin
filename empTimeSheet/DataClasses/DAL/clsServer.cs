using System.Data;
using empTimeSheet.DataClasses.DAL;


public class clsServer:clsDAL
{
   

    private string _action, _nid, _serverid, _date, _ramutilization, _cpuutilization, _usedspace, _createdby, _companyid, _from, _to, _clientid, _name, _type;
    private string _logid, _logtype, _eventid, _description, _severity, _actionperform, _remark, _title, _originalfilename, _uploadfilename;
    private string _servercode, _servername, _domain, _macaddress, _serialno, _serverrole, _configid, _configvalue, _IsUpdated, _UpdateSummary, _TakenBackup, _BackupDescription;

    #region Variables
    public string TakenBackup { get { return this._TakenBackup; } set { this._TakenBackup = value.Trim(); } }
    public string BackupDescription { get { return this._BackupDescription; } set { this._BackupDescription = value.Trim(); } }
    public string IsUpdated { get { return this._IsUpdated; } set { this._IsUpdated = value.Trim(); } }
    public string UpdateSummary { get { return this._UpdateSummary; } set { this._UpdateSummary = value.Trim(); } }
    public string name { get { return this._name; } set { this._name = value.Trim(); } }
    public string type { get { return this._type; } set { this._type = value.Trim(); } }
    public string servercode { get { return this._servercode; } set { this._servercode = value.Trim(); } }
    public string servername { get { return this._servername; } set { this._servername = value.Trim(); } }
    public string domain { get { return this._domain; } set { this._domain = value.Trim(); } }
    public string macaddress { get { return this._macaddress; } set { this._macaddress = value.Trim(); } }
    public string seriolno { get { return this._serialno; } set { this._serialno = value.Trim(); } }
    public string serverrole { get { return this._serverrole; } set { this._serverrole = value.Trim(); } }
    public string serverid { get { return this._serverid; } set { this._serverid = value.Trim(); } }
    public string configid { get { return this._configid; } set { this._configid = value.Trim(); } }
    public string configvalue { get { return this._configvalue; } set { this._configvalue = value.Trim(); } }
    public string action { get { return this._action; } set { this._action = value.Trim(); } }
    public string nid { get { return this._nid; } set { this._nid = value.Trim(); } }

    public string date { get { return this._date; } set { this._date = value.Trim(); } }
    public string ramutilization { get { return this._ramutilization; } set { this._ramutilization = value.Trim(); } }
    public string cpuutilization { get { return this._cpuutilization; } set { this._cpuutilization = value.Trim(); } }
    public string usedspace { get { return this._usedspace; } set { this._usedspace = value.Trim(); } }
    public string createdby { get { return this._createdby; } set { this._createdby = value.Trim(); } }
    public string companyid { get { return this._companyid; } set { this._companyid = value.Trim(); } }
    public string from { get { return this._from; } set { this._from = value.Trim(); } }
    public string to { get { return this._to; } set { this._to = value.Trim(); } }
    public string logid { get { return this._logid; } set { this._logid = value.Trim(); } }
    public string logtype { get { return this._logtype; } set { this._logtype = value.Trim(); } }
    public string eventid { get { return this._eventid; } set { this._eventid = value.Trim(); } }
    public string description { get { return this._description; } set { this._description = value.Trim(); } }
    public string severity { get { return this._severity; } set { this._severity = value.Trim(); } }
    public string actionperform { get { return this._actionperform; } set { this._actionperform = value.Trim(); } }
    public string remark { get { return this._remark; } set { this._remark = value.Trim(); } }
    public string title { get { return this._title; } set { this._title = value.Trim(); } }
    public string originalfilename { get { return this._originalfilename; } set { this._originalfilename = value.Trim(); } }
    public string uploadfilename { get { return this._uploadfilename; } set { this._uploadfilename = value.Trim(); } }
    public string clientid { get { return this._clientid; } set { this._clientid = value.Trim(); } }

    #endregion

    #region Server Log
    public DataSet ServerLogDetail()
    {
        dbcommand = db.GetStoredProcCommand("sp_ServerLogDetail", action, nid, serverid, logid, logtype, eventid, description, severity, actionperform, remark, companyid, title, originalfilename, uploadfilename);
        return db.ExecuteDataSet(dbcommand);
    }
    public DataSet ServerLog()
    {
        dbcommand = db.GetStoredProcCommand("sp_ServerLogNew", action, nid, serverid, date, ramutilization, cpuutilization, usedspace, createdby, clientid, companyid, from, to, IsUpdated, UpdateSummary, TakenBackup, BackupDescription);
        return db.ExecuteDataSet(dbcommand);
    }
    #endregion

    #region  Sever Master
    public DataSet Config()
    {
        dbcommand = db.GetStoredProcCommand("sp_ConfigMaster", action, nid, name, type, companyid);
        return db.ExecuteDataSet(dbcommand);
    }
    public DataSet Server()
    {
        dbcommand = db.GetStoredProcCommand("sp_Server", action, nid, servercode, servername, clientid, domain, serverrole, companyid, createdby, serverid, configid, configvalue);
        return db.ExecuteDataSet(dbcommand);

    }
    #endregion
}
