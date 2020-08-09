using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Data;
using System.Web.Services;
using System.Web.Script.Services;
using System.Text;
using empTimeSheet.DataClasses.DAL;

namespace empTimeSheet
{
    public partial class Tax_MasterFile : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        GeneralMethod objgen = new GeneralMethod();
        clsTax objtax = new clsTax();
        DataSet ds = new DataSet();
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                filltaxcompany();
                filltaxyear();
            }
        }

        public void filltaxcompany()
        {
            objtax.action = "select";
            objtax.companyId = Session["companyid"].ToString();
            objtax.nid = "";
            objtax.taxYear = "0";
            objtax.name = "";
            ds = objtax.Tax_Tax_Client();
            if(ds.Tables[0].Rows.Count>0)
            {
                txttaxclient.DataSource = ds;
                txttaxclient.DataTextField = "name";
                txttaxclient.DataValueField = "nid";
                txttaxclient.DataBind();
            }
            txttaxclient.Items.Insert(0, new ListItem("--All--", ""));
            txttaxclient.SelectedIndex = 0;
        }
        public void filltaxyear()
        {
            objtax.action = "gettaxyear";
            objtax.companyId = Session["companyid"].ToString();
            ds = objtax.Tax_Tax_Client();
            if (ds.Tables[0].Rows.Count > 0)
            {
                txtyear.DataSource = ds;
                txtyear.DataTextField = "taxyear";
                txtyear.DataValueField = "taxyear";
                txtyear.DataBind();
            }
            txtyear.Items.Insert(0, new ListItem("--All--", ""));
            txtyear.SelectedIndex = 0;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getdata(string taxcompany,string taxyear, string companyid,string rectype)
        {
            clsTax objts = new clsTax();
            DataSet ds1 = new DataSet();
            GeneralMethod objgen = new GeneralMethod();
          
            objts.companyId = companyid;
            objts.nid = taxcompany;
            objts.taxYear = taxyear;
            objts.typeid = rectype;
            ds1 = objts.Tax_Log_Report();
            string result = objgen.serilizeinJson(ds1.Tables[0]);
            return result;
        }
    }
}