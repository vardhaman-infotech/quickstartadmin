using System;
using System.Web;
using System.Data.SqlClient;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using System.Data.Common;
using System.Data;
using System.Net.Mail;



public class DataAccess
{
    DataSet ds = new DataSet();
    static string connString = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["conn"].ConnectionString;
    DbCommand dbcommand;
    SqlDatabase db = new SqlDatabase(connString);
    public static SqlConnection scon = new SqlConnection(connString);
    private string _loginid, _password, _usertype, _dob, _dob2, _date, _name, _id, _empid, _taskid, _projectid, _clientid, _description, _action, _company, _parentid, _status;
    private string _filetype, _originalfile, _savedfile, _recordid;

    private string _title, _isalldayevent, _eventttype, _layerid, _time1, _time2, _eventRepeat, _location, _imgPath;
    private string _moduleid, _ctrlType, _ctrlVal, _recid, _recNid, _udfNID, _valueNid;

    public DataAccess()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    #region Variables
    public string valueNid
    {
        get
        {
            return this._valueNid;
        }
        set
        {
            this._valueNid = value.Trim();
        }
    }
    public string udfNID
    {
        get
        {
            return this._udfNID;
        }
        set
        {
            this._udfNID = value.Trim();
        }
    }
    public string moduleid
    {
        get
        {
            return this._moduleid;
        }
        set
        {
            this._moduleid = value.Trim();
        }
    }
    public string ctrlType
    {
        get
        {
            return this._ctrlType;
        }
        set
        {
            this._ctrlType = value.Trim();
        }
    }
    public string ctrlVal
    {
        get
        {
            return this._ctrlVal;
        }
        set
        {
            this._ctrlVal = value.Trim();
        }
    }
    public string recid
    {
        get
        {
            return this._recid;
        }
        set
        {
            this._recid = value.Trim();
        }
    }
    public string recNid
    {
        get
        {
            return this._recNid;
        }
        set
        {
            this._recNid = value.Trim();
        }
    }



    public string imgPath
    {
        get
        {
            return this._imgPath;
        }
        set
        {
            this._imgPath = value.Trim();
        }
    }
    public string location
    {
        get
        {
            return this._location;
        }
        set
        {
            this._location = value.Trim();
        }
    }
    public string eventRepeat
    {
        get
        {
            return this._eventRepeat;
        }
        set
        {
            this._eventRepeat = value.Trim();
        }
    }
    public string time1
    {
        get
        {
            return this._time1;
        }
        set
        {
            this._time1 = value.Trim();
        }
    }
    public string time2
    {
        get
        {
            return this._time2;
        }
        set
        {
            this._time2 = value.Trim();
        }
    }

    public string title
    {
        get
        {
            return this._title;
        }
        set
        {
            this._title = value.Trim();
        }
    }




    public string isalldayevent
    {
        get
        {
            return this._isalldayevent;
        }
        set
        {
            this._isalldayevent = value.Trim();
        }
    }
    public string eventttype
    {
        get
        {
            return this._eventttype;
        }
        set
        {
            this._eventttype = value.Trim();
        }
    }
    public string layerid
    {
        get
        {
            return this._layerid;
        }
        set
        {
            this._layerid = value.Trim();
        }
    }
    public string originalfile
    {
        get
        {
            return this._originalfile;
        }
        set
        {
            this._originalfile = value.Trim();
        }
    }

    public string recordid
    {
        get
        {
            return this._recordid;
        }
        set
        {
            this._recordid = value.Trim();
        }
    }

    public string savedfile
    {
        get
        {
            return this._savedfile;
        }
        set
        {
            this._savedfile = value.Trim();
        }
    }

    public string filetype
    {
        get
        {
            return this._filetype;
        }
        set
        {
            this._filetype = value.Trim();
        }
    }
    public string status
    {
        get
        {
            return this._status;
        }
        set
        {
            this._status = value.Trim();
        }
    }
    public string parentid
    {
        get
        {
            return this._parentid;
        }
        set
        {
            this._parentid = value.Trim();
        }
    }
    public string name
    {
        get
        {
            return this._name;
        }
        set
        {
            this._name = value.Trim();
        }
    }
    public string date
    {
        get
        {
            return this._date;
        }
        set
        {
            this._date = value.Trim();
        }
    }
    public string dob2
    {
        get
        {
            return this._dob2;
        }
        set
        {
            this._dob2 = value.Trim();
        }
    }
    public string clientid
    {
        get
        {
            return this._clientid;
        }
        set
        {
            this._clientid = value.Trim();
        }
    }
    public string description
    {
        get
        {
            return this._description;
        }
        set
        {
            this._description = value.Trim();
        }
    }
    public string id
    {
        get
        {
            return this._id;
        }
        set
        {
            this._id = value.Trim();
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
    public string projectid
    {
        get
        {
            return this._projectid;
        }
        set
        {
            this._projectid = value.Trim();
        }
    }
    public string taskid
    {
        get
        {
            return this._taskid;
        }
        set
        {
            this._taskid = value.Trim();
        }
    }

    public string empid
    {
        get
        {
            return this._empid;
        }
        set
        {
            this._empid = value.Trim();
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

    public string employee { get; internal set; }
    #endregion

    #region common Function
    /// <summary>
    /// send to multi receiver
    /// Send email with CC and BCC and file
    /// </summary>
    /// <param name="receiver"></param>
    /// <param name="subject"></param>
    /// <param name="message"></param>
    /// <param name="cc"></param>
    /// <param name="bcc"></param>
    /// <param name="filename"></param>
    /// <returns></returns>
    /// 

    public void sendExchangeEmail()
    {
        try
        {
            Microsoft.Exchange.WebServices.Data.ExchangeService service = new Microsoft.Exchange.WebServices.Data.ExchangeService();
            service.Credentials = new Microsoft.Exchange.WebServices.Data.WebCredentials("info@harshwal.com", "Hcllp@2009~", "mail.harshwal.com");
            service.Url = new Uri("https://mail.harshwal.com/EWS/Exchange.asmx");
            // Set the URL.
            //service.AutodiscoverUrl("User1@contoso.com");

            Microsoft.Exchange.WebServices.Data.EmailMessage message = new Microsoft.Exchange.WebServices.Data.EmailMessage(service);

            // Add properties to the email message.
            message.Subject = "Interesting";
            message.Body = "The merger is finalized.";
            message.ToRecipients.Add("sanjay.gupta@harshwal.com");

            // Send the email message and save a copy.
            message.SendAndSaveCopy();
          
        }

        catch (Exception ex)
        {


        }

    }
    public string SendAppEmail(string receiver, string subject, string message, string cc, string bcc, string filename,string sendername)
    {
        string sender = System.Web.Configuration.WebConfigurationManager.AppSettings["SenderEmail"].ToString();
        string pass = System.Web.Configuration.WebConfigurationManager.AppSettings["SenderPass"].ToString();
        string hostname = System.Web.Configuration.WebConfigurationManager.AppSettings["MailHost"].ToString();

        ClsAdmin objadmin = new ClsAdmin();
        objadmin.action = "select";
        objadmin.companyId = "1";
        ds = objadmin.ManageSettings();
        if (ds.Tables[0].Rows.Count > 0)
        {
            if (ds.Tables[0].Rows[0]["SenderEmail"].ToString() != "" && ds.Tables[0].Rows[0]["SenderPass"].ToString() != "")
            {
                sender = ds.Tables[0].Rows[0]["SenderEmail"].ToString();
                pass = ds.Tables[0].Rows[0]["SenderPass"].ToString();
                hostname = ds.Tables[0].Rows[0]["MailHost"].ToString();
            }
        }

        System.Net.Mail.MailMessage mail = new System.Net.Mail.MailMessage();
        string msg = "";
        if (receiver != "")
        {
            string[] strto = receiver.Split(',');

            for (int i = 0; i < strto.Length - 1; i++)
            {
                if (strto[i] != "")
                {
                    mail.To.Add(new MailAddress(strto[i]));
                }

            }
        }

        mail.From = new MailAddress(sender, sendername);
        mail.Subject = subject;
        mail.Body = message;
        if (cc != "")
        {
            string[] strcc = cc.Split(',');

            for (int i = 0; i < strcc.Length - 1; i++)
            {
                mail.CC.Add(new MailAddress(strcc[i]));

            }
        }
        if (bcc != "")
        {
            string[] strbcc = bcc.Split(',');

            for (int i = 0; i < strbcc.Length - 1; i++)
            {
                mail.Bcc.Add(new MailAddress(strbcc[i]));

            }
        }
        if (filename != "")
        {

            mail.Attachments.Add(new System.Net.Mail.Attachment(HttpContext.Current.Server.MapPath("webfile/temp/" + filename)));
        }
        mail.IsBodyHtml = true;
        SmtpClient smtp = new SmtpClient();
        smtp.Host = hostname;

        smtp.Credentials = new System.Net.NetworkCredential(sender, pass);
        //  smtp.DeliveryMethod = SmtpDeliveryMethod.Network;
        //smtp.Port = 25;
        //smtp.EnableSsl = true;
        try
        {
            smtp.Send(mail); msg = "Sent";
        }
        catch (Exception ex)
        {

            msg = ex.ToString();
        }

        return msg;
    }

    public string SendEmail(string receiver, string subject, string message, string cc, string bcc, string filename)
    {
        string sender = System.Web.Configuration.WebConfigurationManager.AppSettings["SenderEmail"].ToString();
        string pass = System.Web.Configuration.WebConfigurationManager.AppSettings["SenderPass"].ToString();
        string hostname = System.Web.Configuration.WebConfigurationManager.AppSettings["MailHost"].ToString();

        ClsAdmin objadmin = new ClsAdmin();
        objadmin.action = "select";
        objadmin.companyId = "1";
        ds = objadmin.ManageSettings();
        if (ds.Tables[0].Rows.Count > 0)
        {
            if (ds.Tables[0].Rows[0]["SenderEmail"].ToString() != "" && ds.Tables[0].Rows[0]["SenderPass"].ToString() != "")
            {
                sender = ds.Tables[0].Rows[0]["SenderEmail"].ToString();
                pass = ds.Tables[0].Rows[0]["SenderPass"].ToString();
                hostname = ds.Tables[0].Rows[0]["MailHost"].ToString();
            }
        }

        System.Net.Mail.MailMessage mail = new System.Net.Mail.MailMessage();
        string msg = "";
        if (receiver != "")
        {
            string[] strto = receiver.Split(',');

            for (int i = 0; i < strto.Length - 1; i++)
            {
                if (strto[i] != "")
                {
                    mail.To.Add(new MailAddress(strto[i]));
                }

            }
        }

        mail.From = new MailAddress(sender);
        mail.Subject = subject;
        mail.Body = message;
        if (cc != "")
        {
            string[] strcc = cc.Split(',');

            for (int i = 0; i < strcc.Length - 1; i++)
            {
                mail.CC.Add(new MailAddress(strcc[i]));

            }
        }
        if (bcc != "")
        {
            string[] strbcc = bcc.Split(',');

            for (int i = 0; i < strbcc.Length - 1; i++)
            {
                mail.Bcc.Add(new MailAddress(strbcc[i]));

            }
        }
        if (filename != "")
        {

            mail.Attachments.Add(new System.Net.Mail.Attachment(HttpContext.Current.Server.MapPath("webfile/temp/" + filename)));
        }
        mail.IsBodyHtml = true;
        SmtpClient smtp = new SmtpClient();
        smtp.Host = hostname;

        smtp.Credentials = new System.Net.NetworkCredential(sender, pass);
        //  smtp.DeliveryMethod = SmtpDeliveryMethod.Network;
        //smtp.Port = 25;
        //smtp.EnableSsl = true;
        try
        {
            smtp.Send(mail); msg = "Sent";
        }
        catch (Exception ex)
        {

            msg = ex.ToString();
        }

        return msg;
    }

    public string SendEmail(string receiver, string subject, string message, string cc, string bcc, string filename,string companyid)
    {
        string sender = System.Web.Configuration.WebConfigurationManager.AppSettings["SenderEmail"].ToString();
        string pass = System.Web.Configuration.WebConfigurationManager.AppSettings["SenderPass"].ToString();
        string hostname = System.Web.Configuration.WebConfigurationManager.AppSettings["MailHost"].ToString();

        ClsAdmin objadmin = new ClsAdmin();
        objadmin.action = "select";
        objadmin.companyId = companyid;
        ds = objadmin.ManageSettings();
        if (ds.Tables[0].Rows.Count > 0)
        {
            if (ds.Tables[0].Rows[0]["SenderEmail"].ToString() != "" && ds.Tables[0].Rows[0]["SenderPass"].ToString() != "")
            {
                sender = ds.Tables[0].Rows[0]["SenderEmail"].ToString();
                pass = ds.Tables[0].Rows[0]["SenderPass"].ToString();
                hostname = ds.Tables[0].Rows[0]["MailHost"].ToString();
            }
           
        }

        System.Net.Mail.MailMessage mail = new System.Net.Mail.MailMessage();
        string msg = "";
        if (receiver != "")
        {
            string[] strto = receiver.Split(',');

            for (int i = 0; i < strto.Length - 1; i++)
            {
                if (strto[i]!="")
                {
                    mail.To.Add(new MailAddress(strto[i]));
                }
               

            }
        }

        mail.From = new MailAddress(sender);
        mail.Subject = subject;
        mail.Body = message;
        if (cc != "")
        {
            string[] strcc = cc.Split(',');

            for (int i = 0; i < strcc.Length - 1; i++)
            {
                mail.CC.Add(new MailAddress(strcc[i]));

            }
        }
        if (bcc != "")
        {
            string[] strbcc = bcc.Split(',');

            for (int i = 0; i < strbcc.Length - 1; i++)
            {
                mail.Bcc.Add(new MailAddress(strbcc[i]));

            }
        }
        if (filename != "")
        {

            mail.Attachments.Add(new System.Net.Mail.Attachment(HttpContext.Current.Server.MapPath("webfile/temp/" + filename)));
        }
        mail.IsBodyHtml = true;
        SmtpClient smtp = new SmtpClient();
        smtp.Host = hostname;

        smtp.Credentials = new System.Net.NetworkCredential(sender, pass);
        //  smtp.DeliveryMethod = SmtpDeliveryMethod.Network;
        //smtp.Port = 25;
        //smtp.EnableSsl = true;
        try
        {
            smtp.Send(mail); msg = "Sent";
        }
        catch (Exception ex)
        {

            msg = ex.ToString();
        }

        return msg;
    }

    public string GetCompanyProperty(string property)
    {
        ClsAdmin objadmin = new ClsAdmin();
        string result = "";
        objadmin.action = "select";
        objadmin.companyId = HttpContext.Current.Session["companyid"].ToString();
        ds = objadmin.ManageSettings();
        if (ds.Tables[0].Rows.Count > 0)
        {
            if (ds.Tables[0].Rows[0]["" + property + ""] != null)
                result = ds.Tables[0].Rows[0]["" + property + ""].ToString();
        }
        if (result == "")
        {
            result = System.Web.Configuration.WebConfigurationManager.AppSettings["" + property + ""].ToString();
        }
        return result;
    }
    #endregion

    #region Previleges

    public DataSet getallrole()
    {
        dbcommand = db.GetStoredProcCommand("sp_rolemaster", "getallrole", "", "", "", "");
        ds = db.ExecuteDataSet(dbcommand);
        return ds;

    }

    public bool checkUserInroles(string roleid)
    {
        if (HttpContext.Current.Session["usertype"].ToString()=="Admin")
        {
            return true;

        }
        else
        {
            dbcommand = db.GetStoredProcCommand("sp_rolemaster", "getUserInRoles", "", HttpContext.Current.Session["userid"].ToString(), "", roleid);
            ds = db.ExecuteDataSet(dbcommand);
            if (ds.Tables[0].Rows.Count > 0)
                return true;
            else
                return false;
        }
       

    }
    public DataTable checkUserInroles(string roleid, DataSet ds)
    {
        DataView dv = new DataView(ds.Tables[0]);
        dv.RowFilter = "nid='" + roleid + "'";
        return dv.ToTable();
    }
    public DataSet getUserInRoles()
    {
        dbcommand = db.GetStoredProcCommand("sp_rolemaster", "getUserInRoles", loginid, id, "", "");
        ds = db.ExecuteDataSet(dbcommand);
        return ds;

    }
    public DataSet getUserInRoleswithReport()
    {
        dbcommand = db.GetStoredProcCommand("sp_rolemaster", "getUserInRoleswithReport", loginid, id, "", "");
        ds = db.ExecuteDataSet(dbcommand);
        return ds;

    }
    public DataSet getAdminRoleReport()
    {
        dbcommand = db.GetStoredProcCommand("sp_rolemaster", "getallreports", loginid, id, "", "");
        ds = db.ExecuteDataSet(dbcommand);
        return ds;

    }
    public DataSet selectdata()
    {
        dbcommand = db.GetSqlStringCommand(description);     
        return db.ExecuteDataSet(dbcommand);

    }
    public bool validatedRoles(string roleid, DataSet ds)
    {
        DataTable dt = new DataTable();
        dt = checkUserInroles(roleid, ds);
        if (dt.Rows.Count > 0)
            return true;
        else
            return false;
    }

    #endregion
    public DataSet ManagePaymentTerm()
    {
        dbcommand = db.GetStoredProcCommand("sp_ManagePaymentTerm", action, id, name, description, company);
        return db.ExecuteDataSet(dbcommand);

    }
    public DataSet ManageInformationType()
    {
        dbcommand = db.GetStoredProcCommand("sp_ManageInformationType", action, id, location, title, description,company);
        return db.ExecuteDataSet(dbcommand);

    }
    public DataSet getImportCol()
    {
        dbcommand = db.GetStoredProcCommand("sp_getImportCol", action);
        return db.ExecuteDataSet(dbcommand);

    }
    public DataSet designation()
    {
        dbcommand = db.GetStoredProcCommand("sp_Designation", action, id, name, description, company);
        return db.ExecuteDataSet(dbcommand);

    }
    public DataSet department()
    {
        dbcommand = db.GetStoredProcCommand("sp_Department", action, id, name, description, company, loginid);
        return db.ExecuteDataSet(dbcommand);

    }
    public DataSet ManageUserDefinedField()
    {
        dbcommand = db.GetStoredProcCommand("sp_ManageUserDefinedField", action, id, name, moduleid, description, ctrlType, valueNid, ctrlVal, udfNID, recid, company);
        return db.ExecuteDataSet(dbcommand);

    }
    public DataSet roles()
    {
        dbcommand = db.GetStoredProcCommand("sp_roles", action);
        return db.ExecuteDataSet(dbcommand);

    }
    public DataSet ManageRoleGroup()
    {
        dbcommand = db.GetStoredProcCommand("sp_ManageRoles", action,id,name,description,company);
        return db.ExecuteDataSet(dbcommand);

    }
    public DataSet currency()
    {
        dbcommand = db.GetStoredProcCommand("sp_currency", action);
        return db.ExecuteDataSet(dbcommand);

    }
    public DataSet ManageMaster()
    {
        dbcommand = db.GetStoredProcCommand("sp_managemaster", action, id, name, parentid, "");
        return db.ExecuteDataSet(dbcommand);


    }

    public DataSet manageattachfile()
    {
        dbcommand = db.GetStoredProcCommand("mamageattachfile", action, id, filetype, recordid, originalfile, savedfile);
        return db.ExecuteDataSet(dbcommand);


    }
    public DataSet AnnouncementMaster()
    {
        dbcommand = db.GetStoredProcCommand("sp_AnnouncementMaster", action, id, name, description, dob, dob2, loginid, usertype, company, imgPath);
        ds = db.ExecuteDataSet(dbcommand);
        return ds;
    }
    public DataSet ManageBranch()
    {
        dbcommand = db.GetStoredProcCommand("sp_ManageBranch", action, id, name, company);
        return db.ExecuteDataSet(dbcommand);

    }

    public DataSet HelpMaster()
    {
        dbcommand = db.GetStoredProcCommand("sp_HelpMaster", action, id, name, description, parentid);
        return db.ExecuteDataSet(dbcommand);
    }

    #region chatFunctions
    public DataSet getallUsers()
    {
        dbcommand = db.GetStoredProcCommand("getallUsers");
        ds = db.ExecuteDataSet(dbcommand);
        return ds;
    }
    public DataSet changechatStatus()
    {
        dbcommand = db.GetStoredProcCommand("changechatStatus", loginid, company, status);
        ds = db.ExecuteDataSet(dbcommand);
        return ds;
    }
    public DataSet chatmessage()
    {
        dbcommand = db.GetStoredProcCommand("sp_chatmessage", loginid, id, action, dob, HttpContext.Current.Session["companyId"].ToString());
        ds = db.ExecuteDataSet(dbcommand);
        return ds;
    }
    public DataSet getAllTimeZone()
    {
        dbcommand = db.GetStoredProcCommand("getAllTimeZone");
        ds = db.ExecuteDataSet(dbcommand);
        return ds;
    }
   

    public DataSet InsertChat(DataTable dt)
    {
        DataSet ds = new DataSet();
        SqlCommand cmd = new SqlCommand();
        SqlConnection con;
        con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["conn"].ConnectionString);
        cmd.Connection = con;
        con.Close();
        cmd.CommandText = "sp_InsertChat";
        cmd.Parameters.Clear();
        cmd.CommandType = CommandType.StoredProcedure;

        cmd.Parameters.AddWithValue("@tbl", dt).SqlDbType = SqlDbType.Structured;
        SqlDataAdapter adapt = new SqlDataAdapter(cmd);
        con.Open();
        adapt.Fill(ds);
        //Execute
        // cmd.ExecuteNonQuery();
        con.Close();

        return ds;
    }


    public DataSet manageEvents()
    {
        dbcommand = db.GetStoredProcCommand("sp_manageEvents", action, id, title, description, dob, time1, dob2, time2, isalldayevent, eventttype, loginid, layerid, eventRepeat, location, company);
        ds = db.ExecuteDataSet(dbcommand);
        return ds;

    }
    public DataSet getDashboardCal()
    {
        dbcommand = db.GetStoredProcCommand("sp_getDashboardCal", empid, company);
        ds = db.ExecuteDataSet(dbcommand);
        return ds;

    }
    public DataSet getSchedule()
    {
        dbcommand = db.GetStoredProcCommand("sp_getSchedule", empid, company,projectid,clientid,employee);
        ds = db.ExecuteDataSet(dbcommand);
        return ds;

    }
    public DataSet getScheduleCalendar()
    {
        dbcommand = db.GetStoredProcCommand("sp_getScheduleCalendar", empid, company, projectid, clientid, employee,status);
        ds = db.ExecuteDataSet(dbcommand);
        return ds;

    }
    public DataSet getEmptimeMonthwise()
    {
        dbcommand = db.GetStoredProcCommand("sp_getEmptimeMonthwise", empid, id);
        ds = db.ExecuteDataSet(dbcommand);
        return ds;

    }

    public DataSet getchartreport()
    {
        dbcommand = db.GetStoredProcCommand("sp_getchartreport", action, id,company);
        ds = db.ExecuteDataSet(dbcommand);
        return ds;

    }
    public DataSet LayerMaster()
    {
        dbcommand = db.GetStoredProcCommand("sp_LayerMaster");
        ds = db.ExecuteDataSet(dbcommand);
        return ds;

    }
    public DataSet ToDoList()
    {
        dbcommand = db.GetStoredProcCommand("sp_ToDoList",action,id,dob,empid,description,status);
        ds = db.ExecuteDataSet(dbcommand);
        return ds;

    }
    
    #endregion
}
