using System.Data;
using System.Data.SqlClient;
using empTimeSheet.DataClasses.DAL;
using System.Web;


namespace empTimeSheet.DataClasses.DAL
{
    public class clsTax : clsDAL
    {
        #region "Variables"
        private string _action, _nid, _name, _companyId, _projectID,_typeid,_taxtypeID,_taxYear,_taxFormID,_yearEndDate,_dueDate,_LastYRTax,_lastYRRefund,_userid;
        private string _taxCompanyID, _actionId, _aDate, _actionDetail, _comments, _actionByID, _recDate, _remark, _prevaig, _prevTotalTax;
        private string _address, _city, _email, _state, _phone, _zip,_taxpaid;
        #endregion

        #region Properties

        public string taxpaid { get { return this._taxpaid; } set { this._taxpaid = value.Trim(); } }
        public string address { get { return this._address; } set { this._address = value.Trim(); } }
        public string city { get { return this._city; } set { this._city = value.Trim(); } }
        public string email { get { return this._email; } set { this._email = value.Trim(); } }
        public string state { get { return this._state; } set { this._state = value.Trim(); } }
        public string phone { get { return this._phone; } set { this._phone = value.Trim(); } }
        public string zip { get { return this._zip; } set { this._zip = value.Trim(); } }

        public string prevaig { get { return this._prevaig; } set { this._prevaig = value.Trim(); } }
        public string prevTotalTax { get { return this._prevTotalTax; } set { this._prevTotalTax = value.Trim(); } }
        public string taxCompanyID { get { return this._taxCompanyID; } set { this._taxCompanyID = value.Trim(); } }
        public string actionId { get { return this._actionId; } set { this._actionId = value.Trim(); } }
        public string aDate { get { return this._aDate; } set { this._aDate = value.Trim(); } }
        public string actionDetail { get { return this._actionDetail; } set { this._actionDetail = value.Trim(); } }
        public string comments { get { return this._comments; } set { this._comments = value.Trim(); } }
        public string actionByID { get { return this._actionByID; } set { this._actionByID = value.Trim(); } }
        public string recDate { get { return this._recDate; } set { this._recDate = value.Trim(); } }

        public string action { get { return this._action; } set { this._action = value.Trim(); } }
        public string nid { get { return this._nid; } set { this._nid = value.Trim(); } }      
        public string name { get { return this._name; } set { this._name = value.Trim(); } }
        public string companyId { get { return this._companyId; } set { this._companyId = value.Trim(); } }
        public string projectID { get { return this._projectID; } set { this._projectID = value.Trim(); } }
        public string typeid { get { return this._typeid; } set { this._typeid = value.Trim(); } }
        public string taxtypeID { get { return this._taxtypeID; } set { this._taxtypeID = value.Trim(); } }
        public string taxYear { get { return this._taxYear; } set { this._taxYear = value.Trim(); } }
        public string taxFormID { get { return this._taxFormID; } set { this._taxFormID = value.Trim(); } }
        public string yearEndDate { get { return this._yearEndDate; } set { this._yearEndDate = value.Trim(); } }
        public string dueDate { get { return this._dueDate; } set { this._dueDate = value.Trim(); } }
        public string LastYRTax { get { return this._LastYRTax; } set { this._LastYRTax = value.Trim(); } }
        public string lastYRRefund { get { return this._lastYRRefund; } set { this._lastYRRefund = value.Trim(); } }
        public string userid { get { return this._userid; } set { this._userid = value.Trim(); } }
        public string remark { get { return this._remark; } set { this._remark = value.Trim(); } }
     

       

        #endregion

        #region "Methods"
        public DataSet Tax_ImportClient(DataTable dt)
        {

            DataSet ds = new DataSet();
            SqlCommand cmd = new SqlCommand();
            SqlConnection con;
            con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["conn"].ConnectionString);
            cmd.Connection = con;
            con.Close();
            cmd.CommandText = "sp_Tax_ImportClient";
            cmd.Parameters.Clear();
            cmd.CommandType = CommandType.StoredProcedure;

         
            cmd.Parameters.AddWithValue("@tbl1", dt).SqlDbType = SqlDbType.Structured;
            cmd.Parameters.AddWithValue("@companyid", companyId);
            SqlDataAdapter adapt = new SqlDataAdapter(cmd);
            con.Open();
            adapt.Fill(ds);
            //Execute
            // cmd.ExecuteNonQuery();
            con.Close();

            return ds;
        }
        public DataSet Tax_ImportClient_new(DataTable dt)
        {

            DataSet ds = new DataSet();
            SqlCommand cmd = new SqlCommand();
            SqlConnection con;
            con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["conn"].ConnectionString);
            cmd.Connection = con;
            con.Close();
            cmd.CommandText = "sp_Tax_ImportClient_new";
            cmd.Parameters.Clear();
            cmd.CommandType = CommandType.StoredProcedure;


            cmd.Parameters.AddWithValue("@tbl1", dt).SqlDbType = SqlDbType.Structured;
            cmd.Parameters.AddWithValue("@companyid", companyId);
            SqlDataAdapter adapt = new SqlDataAdapter(cmd);
            con.Open();
            adapt.Fill(ds);
            //Execute
            // cmd.ExecuteNonQuery();
            con.Close();

            return ds;
        }
        public DataSet Tax_Log_Report()
        {
            dbcommand = db.GetStoredProcCommand("sp_Tax_Tax_Log_Report", nid, taxYear, companyId,typeid);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet Tax_Tax_Company()
        {
            dbcommand = db.GetStoredProcCommand("sp_Tax_Tax_Company", action, nid, projectID, typeid, taxtypeID, taxYear, taxFormID, yearEndDate, dueDate, LastYRTax, lastYRRefund, companyId, name, prevaig, prevTotalTax,address,city,state,zip,email,phone);
            return db.ExecuteDataSet(dbcommand);
        }

        public DataSet Tax_Tax_Client()
        {
            dbcommand = db.GetStoredProcCommand("sp_Tax_Tax_Client", action, nid, name, address, city, state, zip, phone, email, typeid, taxtypeID, taxFormID, taxYear, yearEndDate,dueDate, prevaig, prevTotalTax, taxpaid,lastYRRefund,companyId);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet Tax_Tax_Log()
        {
            dbcommand = db.GetStoredProcCommand("sp_Tax_Tax_Log", action, nid, taxCompanyID, actionId, aDate, actionDetail, comments, actionByID, recDate, userid, companyId,remark);
            return db.ExecuteDataSet(dbcommand);
        }

        #endregion
    }
}