using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.IO;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.Script.Services;
namespace empTimeSheet
{
    public partial class chatmessage : System.Web.UI.Page
    {
        GeneralMethod objGen = new GeneralMethod();
        static int previousselectedinddex = 0;
        DataAccess objda = new DataAccess();
        static DataSet dsexcel = new DataSet();
        DataSet ds = new DataSet();

        protected void Page_Load(object sender, EventArgs e)
        {
            objGen.validatelogin();
            hidcompanyid.Value = Session["companyid"].ToString();

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getUserList(string userid)
        {
            GeneralMethod objGen = new GeneralMethod();
            DataAccess objda = new DataAccess();
            DataSet ds = new DataSet();
            objda.loginid = userid;
            objda.action = "getlastchatwithall";

            ds = objda.chatmessage();
            string result = objGen.serilizeinJson(ds.Tables[0]);
            return result;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getMessage(string fromuserid, string touserid, string companyid)
        {
            GeneralMethod objGen = new GeneralMethod();
            DataAccess objda = new DataAccess();
            DataSet ds = new DataSet();
            objda.loginid = fromuserid;
            objda.action = "getallchatwithuserbydate1";
            objda.id = touserid;
            objda.company = companyid;
            ds = objda.chatmessage();
            string result = objGen.serilizeinJson(ds.Tables[0]);
            return result;
        }


    }
}