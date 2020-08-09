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
using empTimeSheet.DataClasses;

namespace empTimeSheet
{
    public partial class Tax_TaxClient : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        GeneralMethod objgen = new GeneralMethod();
        clsTax objtax = new clsTax();
        DataSet ds = new DataSet();
        public string strimportcol = "";
        #region jsoncall

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string savedata(string nid, string name, string address,string city, string state,string zip,string phone,string email,string typeid,string taxtypeID, string taxFormID,string taxYear,string yearEndDate,string dueDate, string prevaig,string prevTotalTax,string taxpaid,string lastYRRefund,string companyId)
        {
            string result = "";
            clsTax objtax = new clsTax();
            GeneralMethod objgen = new GeneralMethod();
            DataSet ds = new DataSet();
            try
            {
                objtax.action = "insert";
                objtax.nid = nid;
                objtax.name = name;
                objtax.address = address;
                objtax.city = city;
                objtax.state = state;
                objtax.zip = zip;
                objtax.phone = phone;
                objtax.email = email;

                objtax.typeid = typeid;
                objtax.taxtypeID = taxtypeID;
                objtax.taxYear = taxYear;
                objtax.taxFormID = taxFormID;
                objtax.yearEndDate = yearEndDate;
                objtax.dueDate = dueDate;
                objtax.prevaig = prevaig;
                objtax.prevTotalTax = prevTotalTax;

                objtax.taxpaid = taxpaid;
                objtax.lastYRRefund = lastYRRefund;
                objtax.companyId = companyId;
               
               
                ds = objtax.Tax_Tax_Client();
                result = objgen.serilizeinJson(ds.Tables[0]);
            }
            catch (Exception ex)
            {
                result = result = @"[{""result"":""0"",""msg"":""Error, Please try again""}]";
            }


            return result;
        }


      

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getTaxClientbyNid(string id, string taxyear)
        {
            clsTax objtax = new clsTax();
            DataSet ds1 = new DataSet();
            GeneralMethod objgen = new GeneralMethod();

            objtax.action = "select";
            objtax.nid = id;
            objtax.taxYear = taxyear;
            ds1 = objtax.Tax_Tax_Client();
            string result = objgen.serilizeinJson(ds1.Tables[0]);
            return result;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getTaxClientbyTaxYear(string nid, string taxyear, string companyid)
        {
            clsTax objtax = new clsTax();
            DataSet ds1 = new DataSet();
            GeneralMethod objgen = new GeneralMethod();

            objtax.action = "getbytaxyear";
           
            objtax.nid = nid;
            objtax.companyId = companyid;
            objtax.taxYear = taxyear;
            objtax.name = "";
            ds1 = objtax.Tax_Tax_Client();
            string result = objgen.serilizeinJson(ds1.Tables[0]);
            return result;
        }



        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string importtaxclient(string path, string cols, string val,string companyid)
        {
            path = HttpContext.Current.Server.MapPath("webfile/temp/" + path);
            DataAccess objda = new DataAccess();
            clsTax objtax = new clsTax();
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


            objda.action = "5";
            ds = objda.getImportCol();
            if (ds.Tables[0].Rows.Count > 0)
            {
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    dt.Columns.Add(new DataColumn(ds.Tables[0].Rows[i]["colname"].ToString()));

                }
            }
            string result = objimport.selectFromExcel(path, dt, dtcol);
            if (result=="-1")
            {
                return result;
            }
            else
            {
                objtax.companyId = companyid;
                ds = objtax.Tax_ImportClient_new(dt);
                result = objgen.serilizeinJson(ds.Tables[0]);
                return result;
            }

          
        }
        #endregion



        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                Session["importfile"] = null;
                if (!objda.checkUserInroles("44"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }

                fillType();
                fillTaxForm();
                fillTaxType();
                filltaxyear();
                fillGrid();
                fillimportcol();
            }
        }
        public void fillimportcol()
        {
            objda.action = "5";
            ds = objda.getImportCol();
            if (ds.Tables[0].Rows.Count > 0)
            {
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    strimportcol += "<tr onclick='selecttd(0,this.id);' class='tblcolleft' id='tdcol" + ds.Tables[0].Rows[i]["nid"].ToString() + "'><td> <span id='spancol" + ds.Tables[0].Rows[i]["nid"].ToString() + "'>" + ds.Tables[0].Rows[i]["alies"].ToString() + "</span><input type='hidden' id='hidcol" + ds.Tables[0].Rows[i]["nid"].ToString() + "' value='"+ ds.Tables[0].Rows[i]["colname"].ToString() + "' /></td></tr>";
                }
            }
        }


      
        public void filltaxyear()
        {
            objtax.action = "gettaxyear";
            objtax.companyId = Session["companyid"].ToString();
            ds = objtax.Tax_Tax_Client();
            if(ds.Tables[0].Rows.Count>0)
            {
                droptaxyear.DataSource = ds;
                droptaxyear.DataTextField = "taxyear";
                droptaxyear.DataValueField = "taxyear";
                droptaxyear.DataBind();
                droptaxyear.SelectedIndex = 0;
            }
            else
            {
                droptaxyear.Items.Insert(0, new ListItem(DateTime.Now.Year.ToString(), DateTime.Now.Year.ToString()));
            }
        }
        public void fillType()
        {
            objda.id = "";
            objda.action = "select";
            objda.location = "5";
            objda.title = "";
            objda.company = Session["companyid"].ToString();
            ds = objda.ManageInformationType();

            droptype.DataSource = ds;
            droptype.DataTextField = "typetitle";
            droptype.DataValueField = "nid";
            droptype.DataBind();

            droptype.Items.Insert(0, new ListItem("--Select--", ""));
            droptype.SelectedIndex = 0;

        }
        public void fillTaxType()
        {
            objda.id = "";
            objda.action = "select";
            objda.location = "7";
            objda.title = "";
            objda.company = Session["companyid"].ToString();
            ds = objda.ManageInformationType();
            droptaxtype.DataSource = ds;
            droptaxtype.DataTextField = "typetitle";
            droptaxtype.DataValueField = "nid";
            droptaxtype.DataBind();

            droptaxtype.Items.Insert(0, new ListItem("--Select--", ""));
            droptaxtype.SelectedIndex = 0;


        }
        public void fillTaxForm()
        {
            objda.id = "";
            objda.action = "select";
            objda.location = "6";
            objda.title = "";
            objda.company = Session["companyid"].ToString();
            ds = objda.ManageInformationType();
            drotaxform.DataSource = ds;
            drotaxform.DataTextField = "typetitle";
            drotaxform.DataValueField = "nid";
            drotaxform.DataBind();

            drotaxform.Items.Insert(0, new ListItem("--Select--", ""));
            drotaxform.SelectedIndex = 0;
        }
        public void fillGrid()
        {
            objtax.action = "select";
            objtax.name = txttaxclient.Text;
            objtax.projectID = "";

            objtax.companyId = Session["companyid"].ToString();
            objtax.nid = "";
            objtax.taxYear = droptaxyear.Text;
            ds = objtax.Tax_Tax_Client();
            if (ds.Tables[0].Rows.Count > 0)
            {
                dgnews.DataSource = ds;
                dgnews.DataBind();
                nodata.Visible = false;
                dgnews.Visible = true;
            }
            else
            {
                nodata.Visible = true;
                dgnews.Visible = false;
            }
            updatedata.Update();
            ScriptManager.RegisterStartupScript(updatedata, updatedata.GetType(), "key", "<script type='text/javascript'>fixheader();</script>", false);
        }
        protected void dgnews_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.Header)
                e.Row.TableSection = TableRowSection.TableHeader;
        }
        protected void dgnews_RowCommand(object sender, GridViewCommandEventArgs e)
        {


            if (e.CommandName.ToLower() == "remove")
            {
                objtax.action = "delete";
                objtax.nid = e.CommandArgument.ToString();
                ds = objtax.Tax_Tax_Client();

                fillGrid();
                GeneralMethod.alert(this.Page, "Deleted Successfully!");
            }

        }
        protected void btnsearch_Click(object sender, EventArgs e)
        {

            fillGrid();
        }
    }
}