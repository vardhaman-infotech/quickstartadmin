using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.Services;
using System.Web.Script.Services;
using empTimeSheet.DataClasses;

namespace empTimeSheet
{
    public partial class projectBudget : System.Web.UI.Page
    {
        GeneralMethod objgen = new GeneralMethod();
        DataAccess objda = new DataAccess();
        public string strimportcol = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {


                //role 9 indicates Approve Task
                if (!objda.checkUserInroles("113"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }

                Session["importfile"] = null;
                fillimportcol();
            }
        }
        public void fillimportcol()
        {
            DataSet ds = new DataSet();
            objda.action = "8";
            ds = objda.getImportCol();
            if (ds.Tables[0].Rows.Count > 0)
            {
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    strimportcol += "<tr onclick='selecttd(0,this.id);' class='tblcolleft' id='tdcol" + ds.Tables[0].Rows[i]["nid"].ToString() + "'><td> <span id='spancol" + ds.Tables[0].Rows[i]["nid"].ToString() + "'>" + ds.Tables[0].Rows[i]["alies"].ToString() + "</span><input type='hidden' id='hidcol" + ds.Tables[0].Rows[i]["nid"].ToString() + "' value='" + ds.Tables[0].Rows[i]["colname"].ToString() + "' /></td></tr>";
                }
            }
        }


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string importTask(string path, string cols, string val, string companyid)
        {
            path = HttpContext.Current.Server.MapPath("webfile/temp/" + path);
            DataAccess objda = new DataAccess();
            ClsTimeSheet objtax = new ClsTimeSheet();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();
            ImportExcel objimport = new ImportExcel();
            string[] cols1 = cols.Split('#');
            string[] val1 = val.Split('#');

            DataTable dt = new DataTable();
            DataTable dtcol = new DataTable();
            dtcol.Columns.Add(new DataColumn("conval"));
            dtcol.Columns.Add(new DataColumn("colname"));


            for (int i = 0; i < cols1.Length; i++)
            {
                if (cols1[i] != "")
                {
                    DataRow ro = dtcol.NewRow();
                    ro["colname"] = cols1[i];
                    char c = Convert.ToChar(val1[i]);
                    ro["conval"] = char.ToUpper(c) - 64;
                    dtcol.Rows.Add(ro);

                }

            }


            objda.action = "8";
            ds = objda.getImportCol();
            if (ds.Tables[0].Rows.Count > 0)
            {
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    dt.Columns.Add(new DataColumn(ds.Tables[0].Rows[i]["colname"].ToString()));

                }
            }
            string result = objimport.selectFromExcel(path, dt, dtcol);
            if (result == "-1")
            {
                return result;
            }
            else
            {
                objtax.companyId = companyid;
                ds = objtax.Budget_Import(dt);
                result = objgen.serilizeinJson(ds.Tables[0]);
                return result;
            }


        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getProjects(string prefixText, string companyid)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds1 = new DataSet();
            GeneralMethod objgen = new GeneralMethod();
            objts.name = "";
            objts.action = "selectforautocompleter";
            objts.companyId = companyid;
            objts.nid = "";
            ds1 = objts.ManageProject();
            string result = objgen.serilizeinJson(ds1.Tables[0]);
            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getTasks(string companyid)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds1 = new DataSet();
            GeneralMethod objgen = new GeneralMethod();
        
            objts.action = "getTasks";          
            objts.companyId = companyid;         
            ds1 = objts.Budget_Manage();

            string result = objgen.serilizeinJson(ds1.Tables[0]);
            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getdataforDetail(string nid, string projectid, string companyid)
        {
            ClsTimeSheet objda = new ClsTimeSheet();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();

            objda.action = "detail";
            objda.nid = nid;
            objda.companyId = companyid;
            objda.projectid = projectid;
            ds = objda.Budget_Manage();
            return (objgen.serilizeinJson(ds.Tables[0]));

        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getdata(string nid, string projectid, string companyid)
        {
            ClsTimeSheet objda = new ClsTimeSheet();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();

            objda.action = "select";
            objda.nid = nid;
            objda.companyId = companyid;
            objda.projectid = projectid;
            ds = objda.Budget_Manage();
            return (objgen.serilizeinJson(ds.Tables[0]));

        }


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string deletedata(string nid, string companyid)
        {
            ClsTimeSheet objda = new ClsTimeSheet();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();

            objda.action = "delete";
            objda.nid = nid;
            objda.companyId = companyid;
            ds = objda.Budget_Manage();
            return (objgen.serilizeinJson(ds.Tables[0]));

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string deleteTask(string nid, string companyid)
        {
            ClsTimeSheet objda = new ClsTimeSheet();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();

            objda.action = "deleteTask";
            objda.nid = nid;
            objda.companyId = companyid;
            ds = objda.Budget_Manage();
            return (objgen.serilizeinJson(ds.Tables[0]));

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string savedata(string nid, string projectid, string budgetTitle, string createdby, string companyid, string tbl, string isimport)
        {
            string result = "";
            int status = 1;
            if (projectid == "" || budgetTitle == "")
            {
                status = 0;
                result = @"[{""result"":""0"",""msg"":""Please fill required fields""}]";
            }
            if (status == 1)
            {
                ClsTimeSheet objda = new ClsTimeSheet();
                DataSet ds = new DataSet();
                GeneralMethod objgen = new GeneralMethod();
                DataTable dt = new DataTable();

                dt = objgen.deserializetoDataTable(tbl);
                objda.nid = nid;
                objda.title = budgetTitle;
                objda.projectid = projectid;
                objda.companyId = companyid;
                objda.CreatedBy = createdby;
                objda.Status = isimport;
                ds = objda.Budget_Insert(dt);
                result = @"[{""result"":""1"",""msg"":""""}]";
            }

            return result;

        }

    }
}