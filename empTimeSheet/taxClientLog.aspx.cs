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
    public partial class taxClientLog : System.Web.UI.Page
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

                filltaxyear();
                fillusers();
              
            }
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string deletelog(string id)
        {
            string result = "";
            clsTax objtax = new clsTax();
            DataSet ds1 = new DataSet();

            objtax.action = "delete";
            objtax.nid = id;
            ds1 = objtax.Tax_Tax_Log();
            result = "";
            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string gettaxlogbynid(string id)
        {
            clsTax objtax = new clsTax();
            DataSet ds1 = new DataSet();
            GeneralMethod objgen = new GeneralMethod();

            objtax.action = "select";
            objtax.nid = id;
            ds1 = objtax.Tax_Tax_Log();
            string result = objgen.serilizeinJson(ds1.Tables[0]);
            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string savedata(string nid,string taxCompanyID,string  actionId,string  aDate,string  actionDetail,string  comments,string  actionByID,string  recDate,string createdby,string remark)
        {
            string result = "";
            clsTax objtax = new clsTax();
            GeneralMethod objgen = new GeneralMethod();
            try
            {
                string[] actionId1=actionId.Split('#');
                string[] aDate1 = aDate.Split('#');
                string[] actionDetail1 = actionDetail.Split('#');
                string[] comments1 = comments.Split('#');
                string[] actionByID1 = actionByID.Split('#');
                string[] recDate1 = recDate.Split('#');
                objtax.action = "insert";
                for (int i = 0; i < actionId1.Length; i++)
                {
                    if(actionId1[i]!="")
                    {
                        
                        if (i == 0)
                        {
                            objtax.nid = nid;

                        }
                        else
                        {
                            objtax.nid = "";

                        }
                        objtax.taxCompanyID = taxCompanyID;
                        objtax.actionId = actionId1[i];
                        objtax.aDate = aDate1[i];
                        objtax.actionDetail = actionDetail1[i];
                        objtax.comments = comments1[i];
                        if (actionByID1[i] == "")
                        {
                            objtax.actionByID =createdby;
                        }
                      
                        else{
                            objtax.actionByID = actionByID1[i];
                        }
                        objtax.recDate = recDate1[i];
                        objtax.userid = createdby;
                        objtax.remark = remark;
                        objtax.Tax_Tax_Log();
                    }
                }
                
            }
            catch (Exception ex)
            {
                result = ex.ToString();
            }


            return result;
        }


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getProjects(string taxyear, string companyid)
        {
            clsTax objtax = new clsTax();
            DataSet ds1 = new DataSet();
            GeneralMethod objgen = new GeneralMethod();
            objtax.action = "getCLientbyTaxYear";
            objtax.name = "";
            objtax.projectID = "";

            objtax.companyId = companyid;
            objtax.nid = "";
            objtax.taxYear = taxyear;
            ds1 = objtax.Tax_Tax_Client();
            string result = objgen.serilizeinJson(ds1.Tables[0]);
            return result;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string gettaxlog(string taxcompanyid, string companyid)
        {
            clsTax objtax = new clsTax();
            DataSet ds1 = new DataSet();
            GeneralMethod objgen = new GeneralMethod();
            objtax.action = "select";          
            objtax.companyId = companyid;
            objtax.nid = "";
            objtax.taxCompanyID = taxcompanyid;
            ds1 = objtax.Tax_Tax_Log();
            string result = objgen.serilizeinJson(ds1.Tables[0]);
            return result;
        }
        public void fillusers()
        {
            ClsUser objuser = new ClsUser();
            objuser.action = "select";
            objuser.companyid = Session["companyid"].ToString();
            objuser.id = "";
            ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0)
            {
                //dropemployee.DataSource = ds;
                //dropemployee.DataTextField = "username";
                //dropemployee.DataValueField = "nid";
                //dropemployee.DataBind();
                objgen.fillActiveInactiveDDL(ds.Tables[0], droppreperedby4, "username", "nid");
                objgen.fillActiveInactiveDDL(ds.Tables[0], dropfinilizedby5, "username", "nid");

                ListItem li = new ListItem("--Select--", "");
                droppreperedby4.Items.Insert(0, li);
                dropfinilizedby5.Items.Insert(0, li);

            }

            droppreperedby4.SelectedIndex = 0;
            dropfinilizedby5.SelectedIndex = 0;
        }
        public void filltaxyear()
        {
            objtax.action = "gettaxyear";
           
            objtax.companyId = Session["companyid"].ToString();
            objtax.nid = "";
            objtax.taxYear = "";
            ds = objtax.Tax_Tax_Client();

            txtyear.DataSource = ds;
            txtyear.DataTextField = "taxyear";
            txtyear.DataValueField = "taxyear";
            txtyear.DataBind();
            txtyear.Items.Insert(0, new ListItem("--Select--", ""));




        }
    }
}