using System.Data;
using empTimeSheet.DataClasses.DAL;
using System.Web;

namespace empTimeSheet
{
    public class clsLogin:clsDAL
    {
      
        private string _loginid, _password, _usertype, _dob,_action,_company,_deviceID;
  

        public clsLogin()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        #region Variables
        public string deviceID
        {
            get
            {
                return this._deviceID;
            }
            set
            {
                this._deviceID = value.Trim();
            }
        }
        public string company
        {
            get
            {
                return this._company;
            }
            set
            {
                this._company = value.Trim();
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

        public string password
        {
            get
            {
                return this._password;
            }
            set
            {
                this._password = value.Trim();
            }
        }
        public string usertype
        {
            get
            {
                return this._usertype;
            }
            set
            {
                this._usertype = value.Trim();
            }
        }
        public string dob
        {
            get
            {
                return this._dob;
            }
            set
            {
                this._dob = value.Trim();
            }
        }
        #endregion

        public string getsubdomain(System.Uri url)
        {
            string host = url.Host;
            int index = host.IndexOf(".");
            if (host.Split('.').Length > 1)
            {
                return host.Substring(0, index);
            }
            return "";
        }
        public DataSet ExecuteString(string str)
        {
            dbcommand = db.GetSqlStringCommand(str);
            return db.ExecuteDataSet(dbcommand);
           

        }
        public DataSet login()
        {
            dbcommand = db.GetStoredProcCommand("sp_login", loginid, password, company, action);
           return  db.ExecuteDataSet(dbcommand);
            
        }

        public DataSet Mob_Login()
        {
            dbcommand = db.GetStoredProcCommand("sp_Mob_Login", action, loginid, password, company, deviceID);
            return db.ExecuteDataSet(dbcommand);

        }
    }
}