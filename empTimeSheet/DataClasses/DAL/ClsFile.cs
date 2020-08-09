using System.Data;
using System.Data.SqlClient;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using System.Data.Common;



public class ClsFile
    {
        DataSet ds = new DataSet();
        static string connString = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["conn"].ConnectionString;
        DbCommand dbcommand;
        SqlDatabase db = new SqlDatabase(connString);
        public static SqlConnection scon = new SqlConnection(connString);
        private string _nid, _name, _companyid, _action, _userid;
        private string _mName, _dob, _type, _usertype, _linktype, _description, _extension, _parent, _imgurl, _createdby, _category, _loginid,_id,_sendername,_sharedid,_emailid,_sentto,_filecode,_originalfile,_savedfile;

        #region Variables
        public string originalfile { get { return this._originalfile; } set { this._originalfile = value.Trim(); } }
        public string savedfile { get { return this._savedfile; } set { this._savedfile = value.Trim(); } }
        public string sendername { get { return this._sendername; } set { this._sendername = value.Trim(); } }
        public string sharedid { get { return this._sharedid; } set { this._sharedid = value.Trim(); } }
        public string emailid { get { return this._emailid; } set { this._emailid = value.Trim(); } }
        public string sentto { get { return this._sentto; } set { this._sentto = value.Trim(); } }
        public string filecode { get { return this._filecode; } set { this._filecode = value.Trim(); } }

        public string id { get { return this._id; } set { this._id = value.Trim(); } }
        public string companyid { get { return this._companyid; } set { this._companyid = value.Trim(); } }
        public string action { get { return this._action; } set { this._action = value.Trim(); } }
        public string name { get { return this._name; } set { this._name = value.Trim(); } }
        public string userid { get { return this._userid; } set { this._userid = value.Trim(); } }
        public string loginid { get { return this._loginid; } set { this._loginid = value.Trim(); } }

        public string nid { get { return this._nid; } set { this._nid = value.Trim(); } }
        public string linktype { get { return this._linktype; } set { this._linktype = value.Trim(); } }
        public string mName { get { return this._mName; } set { this._mName = value.Trim(); } }
        public string parent { get { return this._parent; } set { this._parent = value.Trim(); } }
        public string extension { get { return this._extension; } set { this._extension = value.Trim(); } }
        public string type { get { return this._type; } set { this._type = value.Trim(); } }
        public string dob { get { return this._dob; } set { this._dob = value.Trim(); } }
  
        public string createdby { get { return this._createdby; } set { this._createdby = value.Trim(); } }  
        public string description { get { return this._description; } set { this._description = value.Trim(); } }
      
        public string imgurl { get { return this._imgurl; } set { this._imgurl = value.Trim(); } }
        public string category { get { return this._category; } set { this._category = value.Trim(); } }
        public string usertype { get { return this._usertype; } set { this._usertype = value.Trim(); } }
       

        #endregion


        #region Method
        public DataSet FileCategoryMaster()
        {
            dbcommand = db.GetStoredProcCommand("sp_FileCategoryMaster", action, nid, name, companyid);
            return db.ExecuteDataSet(dbcommand);
        }

        public DataSet managefiles()
        {
            dbcommand = db.GetStoredProcCommand("sp_managefiles", action, nid, name, mName, dob, companyid, type, userid, usertype, linktype, description, parent, imgurl, loginid, "", extension, createdby, category);
            ds = db.ExecuteDataSet(dbcommand);
            return ds;
        }

        public DataSet ManageEmailFileShare()
        {
            dbcommand = db.GetStoredProcCommand("ManageEmailFileShare", action, nid, dob, name,sharedid,originalfile,savedfile,emailid,sentto,filecode);
            ds = db.ExecuteDataSet(dbcommand);
            return ds;
        }
        #endregion

    }
