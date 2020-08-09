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
    public partial class ManualInvoice : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds1 = new DataSet();
        DataSet ds = new DataSet();
        ClsAdmin objadmin = new ClsAdmin();
        public string strtask = "";
        DataSet dsexcel = new DataSet();
        public string strproject = "", strtime = "", strsno = "", strcurrency = "$";
        public decimal totalhours = 0;
        protected void Page_Load(object sender, EventArgs e)
        {

            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                txtinvoicedate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");
                //role 37 indicates Create Invoice
                if (!objda.checkUserInroles("37"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
                hidrowno.Value = "0";
                filltaxmaster();
                bindmaxinvoice();
                fillcurrency();
                // fillproject();
                filltasks();
                hidsno.Value = "1";
                strsno = "1";
                txtinvoicedate.Text = GeneralMethod.getLocalDate();
                if (Request.QueryString["invoiceid"] != null && Request.QueryString["invoiceid"].ToString() != "")
                {

                    objts.nid = Request.QueryString["invoiceid"].ToString();
                    objts.invoiceno = "";
                    objts.companyId = Session["companyid"].ToString();
                    objts.action = "selectinvoicebynumber";
                    ds = objts.GetInvoice();
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        hidid.Value = Request.QueryString["invoiceid"].ToString();
                        // h1headr.InnerHtml = "Update Invoice";
                        txtinvoicenum.Text = ds.Tables[0].Rows[0]["invoiceno"].ToString();
                        txtinvoicenum.Enabled = false;
                    }

                    //ScriptManager.RegisterStartupScript(Page, typeof(Page), "MyKey", "<script type='text/javascript'> $(document).ready(function () {bindinvoicebynumber('" + hidid.Value + "','nid'); });</script>", false);
                }
            }
        }
        //protected void Page_Unload(object sender, EventArgs e) {
        //    if (hidid.Value!="")
        //    {


        //        ScriptManager.RegisterStartupScript(Page, typeof(Page), "MyKey", "<script type='text/javascript'> $(document).ready(function () {bindinvoicebynumber('" + hidid.Value + "','nid'); });</script>", false);
        //    }
        //}
        /// <summary>
        /// Bind tax masters dropdownlist to apply taxes
        /// </summary>
        protected void filltaxmaster()
        {
            objts.action = "select";
            objts.nid = "";
            objts.companyId = Session["companyid"].ToString();
            ds = objts.ManageTax();

            if (ds.Tables[0].Rows.Count > 0)
            {
                droptax.DataTextField = "name";
                droptax.DataValueField = "nidwithtax";
                droptax.DataSource = ds;
                droptax.DataBind();

            }
            ListItem li = new ListItem("--None--", "");
            droptax.Items.Insert(0, li);
            droptax.SelectedIndex = 0;
        }

        /// <summary>
        /// Bind currency according to current company
        /// </summary>
        protected void fillcurrency()
        {
            objadmin.action = "select";
            objadmin.nid = Session["companyid"].ToString();
            ds = objadmin.ManageCompany();
            if (ds.Tables[0].Rows.Count > 0)
            {
                strcurrency = ds.Tables[0].Rows[0]["symbol"].ToString();
            }
        }

        //Get maximum invoice number
        protected void bindmaxinvoice()
        {
            objts.action = "getmaxinvoice";
            objts.companyId = Session["companyid"].ToString();
            ds = objts.GetInvoice();
            if (ds.Tables[0].Rows.Count > 0)
            {
                txtinvoicenum.Text = ds.Tables[0].Rows[0]["invoiceno"].ToString();
                txtprefix.Text = ds.Tables[0].Rows[0]["prefix"].ToString();
                txtpostfix.Text = ds.Tables[0].Rows[0]["postfix"].ToString();
                hidmaxinvoiceno.Value = ds.Tables[0].Rows[0]["invoiceno"].ToString();
            }

        }

        /// <summary>
        /// Fill project dropdown
        /// </summary>
        protected void fillproject()
        {
            //objts.name = "";
            //objts.action = "select";
            //objts.companyId = Session["companyid"].ToString();
            //objts.nid = "";
            //ds = objts.ManageProject();
            //if (ds.Tables[0].Rows.Count > 0)
            //{
            //    dropProject.DataTextField = "projectcodename";
            //    dropProject.DataValueField = "nid";
            //    dropProject.DataSource = ds;
            //    dropProject.DataBind();
            //}
            //ListItem li = new ListItem("", "");
            //dropProject.Items.Insert(0, li);
        }

        /// <summary>
        /// Fill tasks drop down When makes new entry in timesheet
        /// </summary>
        protected void filltasks()
        {
            objts.name = "";
            objts.action = "select";
            objts.companyId = Session["companyid"].ToString();
            objts.nid = "";
            objts.type = "Expense";
            //if (Session["deptid"] != null)
            //    objts.deptID = Session["deptid"].ToString();
            //else
            objts.deptID = "";
            objts.Status = "";
            ds = objts.ManageTasks();
            ViewState["task"] = ds.Tables[0];
            StringBuilder options = new StringBuilder();
            //options.Append("<option value='' >--Add New--</option>");
            options.Append("<option selected='selected' value=''></option>");
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                //if (i == 0)
                //    options.Append("<option selected='selected' value=''></option>");
                //else
                options.Append("<option value='" + ds.Tables[0].Rows[i]["taskvalue"].ToString() + "#" + ds.Tables[0].Rows[i]["TETYPE"].ToString() + "' >" + ds.Tables[0].Rows[i]["taskcodename"].ToString() + " (" + ds.Tables[0].Rows[i]["description"].ToString() + ")</option>");
            }

            strtask = options.ToString();
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
        public static string getclientaddress(string nid, string todate)
        {

            //if (todate == "")
            {
             DateTime   todatex = Convert.ToDateTime(todate);
                    // DateTime.Now.ToString("MM/dd/yyyy");
            }
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();
            string msg = "failure";
            try
            {
                if (nid == "")
                    objts.nid = "0";
                else
                    objts.nid = nid;
                objts.to = todate;
                objts.action = "getprojectdetail";
                ds = objts.ManageProject();
                string address = "";
                string grt = "0.00";
                string expensetax = "0.00";
                string taxid = "";
                string clientretainer = "0.00", pServiceamt = "0.00", pExpamt = "0.00", pContAmt = "0.00", pCtype = "", pComplete = "0.00";
                string serviceamt = "0.00", expamt = "0.00", serHrs = "0.00", prebilled = "0.00";
                string lastinvoice = "", lastinvDate = "", lastinvamt = "0.00",usedservice = "0.00",usedexp = "0.00";
                string toooodate = "";
                if (ds.Tables[0].Rows.Count > 0)
                {
                    if (ds.Tables.Count > 0)
                    {
                        address = ds.Tables[0].Rows[0]["clientname"].ToString() + "!!!";
                        address += ds.Tables[0].Rows[0]["company"].ToString() + "!!!";
                        address += ds.Tables[0].Rows[0]["designation"].ToString() + "!!!";
                        address += ds.Tables[0].Rows[0]["street"].ToString() + "!!!";
                        address += ds.Tables[0].Rows[0]["street2"].ToString() + "!!!";
                        address += ds.Tables[0].Rows[0]["city"].ToString() + "!!!";
                        address += ds.Tables[0].Rows[0]["state"].ToString() + "!!!";
                        address += ds.Tables[0].Rows[0]["country"].ToString() + "!!!";
                        address += ds.Tables[0].Rows[0]["zip"].ToString() + "!!!";




                        if (ds.Tables[0].Rows[0]["GRT"] != null)
                        {
                            grt = ds.Tables[0].Rows[0]["GRT"].ToString();
                        }
                        if (ds.Tables[0].Rows[0]["clientretainer"] != null)
                        {
                            clientretainer = ds.Tables[0].Rows[0]["clientretainer"].ToString();
                        }
                        if (ds.Tables[0].Rows[0]["ExpenseTax"] != null)
                        {
                            expensetax = ds.Tables[0].Rows[0]["ExpenseTax"].ToString();
                        }
                        if (ds.Tables[0].Rows[0]["nidwithtax"] != null)
                        {
                            taxid = ds.Tables[0].Rows[0]["nidwithtax"].ToString();
                        }

                        pServiceamt = Convert.ToDouble(ds.Tables[0].Rows[0]["serviceAmt"]).ToString("0.00");
                        pExpamt = Convert.ToDouble(ds.Tables[0].Rows[0]["expAmt"]).ToString("0.00");
                        pContAmt = Convert.ToDouble(ds.Tables[0].Rows[0]["contractAmt"]).ToString("0.00");
                        pCtype = ds.Tables[0].Rows[0]["contractType"].ToString();
                        pComplete = Convert.ToDouble(ds.Tables[0].Rows[0]["completePercent"]).ToString("0.00");
                    }
                    toooodate = "ds.Tables[1].Rows[0]";//["todate"].ToString();
                    if (ds.Tables[1].Rows.Count > 0)
                    {
                        serviceamt = Convert.ToDouble(ds.Tables[1].Rows[0]["serviceamt"]).ToString("0.00");
                        expamt = Convert.ToDouble(ds.Tables[1].Rows[0]["expamt"]).ToString("0.00");
                        serHrs = Convert.ToDouble(ds.Tables[1].Rows[0]["totalhrs"]).ToString("0.00");
                        prebilled = Convert.ToDouble(ds.Tables[1].Rows[0]["prebilled"]).ToString("0.00");
                        lastinvoice = ds.Tables[1].Rows[0]["lastinvoice"].ToString();
                        lastinvDate = ds.Tables[1].Rows[0]["lastinvoicedate"].ToString();
                        usedservice = ds.Tables[1].Rows[0]["usedservice"].ToString();
                        usedexp = ds.Tables[1].Rows[0]["usedexp"].ToString();
                       
                        if (ds.Tables[1].Rows[0]["lasinvamt"] != null && ds.Tables[1].Rows[0]["lasinvamt"].ToString() != "")
                            lastinvamt = Convert.ToDouble(ds.Tables[1].Rows[0]["lasinvamt"]).ToString("0.00");
                        else
                            lastinvamt = "";
                    }

                }
                string custominvoiceno = "", prefix = "", sufix = "";



                if (ds.Tables[0].Rows[0]["iscustominvoice"].ToString().ToLower() == "yes")
                {
                    objts.action = "getmaxinvoicebyproject";
                    objts.projectid = nid;
                    ds = objts.GetInvoice();
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        if (ds.Tables[0].Rows[0]["projectsno"] != null)
                        {
                            custominvoiceno = ds.Tables[0].Rows[0]["projectsno"].ToString();
                            prefix = ds.Tables[0].Rows[0]["prefix"].ToString();
                            sufix = ds.Tables[0].Rows[0]["postfix"].ToString();

                        }
                    }
                }
                else
                {
                    objts.action = "getmaxinvoice";
                    objts.companyId = ds.Tables[0].Rows[0]["companyid"].ToString();
                    objts.projectid = nid;
                    ds = objts.GetInvoice();

                    prefix = ds.Tables[0].Rows[0]["prefix"].ToString();
                    sufix = ds.Tables[0].Rows[0]["postfix"].ToString();
                }
                return address + "####" + custominvoiceno + "####" + grt + "####" + expensetax + "####" + taxid + "####" + clientretainer + "####" + prefix + "####" + sufix + "####" + pServiceamt + "####" + pExpamt + "####" + pContAmt + "####" + pCtype + "####" + pComplete + "####" + serviceamt + "####" + expamt + "####" + serHrs + "####" + prebilled + "####" + 
                    lastinvoice + "####" + lastinvDate + "####" + lastinvamt+
                     "####" + usedservice + "####" +usedexp+"####"+ toooodate;
            }
            catch (Exception ex)
            {
                //msg = ex.Message.ToString();
                return msg;
            }
        }


        /// <summary>
        /// Save Invoice information
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        /// 
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string saveinvoice(string nid, string invoiceno, string invoicedate, string companyid, string projectid, string subtotal, string taxamount, string totalamount, string discount, string amountpaid, string dueamount, string address, string userid, string invoicedetail, string memo, string markbilled, string taxid, string taxpercent, string invoicetype, string retainage, string contactperson, string street2, string state, string city, string country, string zip, string billedtask)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            GeneralMethod objgen = new GeneralMethod();
            DataSet ds = new DataSet();
            DataTable dt = new DataTable();
            string msg = "success";
            try
            {
                if (subtotal == "")
                {
                    subtotal = "0.00";
                }
                if (discount == "")
                {
                    discount = "0.00";
                }
                if (taxamount == "")
                {
                    taxamount = "0.00";
                }
                if (amountpaid == "")
                {
                    amountpaid = "0.00";
                }
                if (dueamount == "")
                {
                    dueamount = "0.00";
                }
                if (retainage == "")
                {
                    retainage = "0.00";
                }
                objts.nid = nid;
                objts.invoiceno = invoiceno;
                objts.date = invoicedate;
                objts.companyId = companyid;
                objts.projectid = projectid;
                objts.subamount = subtotal;
                objts.tax = taxamount;
                objts.totalamount = totalamount;
                objts.discount = discount;
                objts.retainage = "0.00";
                objts.amountpaid = amountpaid;
                objts.dueamount = dueamount;
                objts.description = address;
                objts.CreatedBy = userid;
                objts.remark = memo;
                objts.isbilled = markbilled;
                objts.taxid = taxid;
                objts.taxpercent = taxpercent;
                objts.type = invoicetype;
                objts.retainage = retainage;

                objts.contact = contactperson;
                objts.address2 = street2;
                objts.city = city;
                objts.state = state;
                objts.country = country;
                objts.zip = zip;

                objts.taskid = billedtask;
                dt = objgen.deserializetoDataTable(invoicedetail);
                ds = objts.insertInvoice(dt);
                if (ds != null)
                {
                    if (ds.Tables.Count > 0)
                    {
                        if (ds.Tables[0].Rows.Count > 0)
                        {
                            if (ds.Tables[0].Rows[0]["nid"].ToString() == "0")
                                msg = "Already Exists";
                        }
                    }
                }
                return msg;
            }
            catch (Exception ex)
            {
                msg = ex.Message.ToString();
                return msg;
            }

        }


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getinvoicedetailbyinvoicenumber(string invoicenum, string companyid, string recordtype)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            GeneralMethod objgen = new GeneralMethod();
            DataSet ds = new DataSet();
            string msg = "failure";
            try
            {
                if (recordtype == "nid")
                {
                    objts.nid = invoicenum;
                    objts.invoiceno = "";
                }
                else
                {
                    objts.nid = "";
                    objts.invoiceno = invoicenum;
                }
                objts.companyId = companyid;
                objts.action = "selectinvoicebynumber";
                ds = objts.GetInvoice();
                msg = objgen.serilizeinJson(ds.Tables[0]);
                return msg;
            }
            catch (Exception ex)
            {
                //msg = ex.Message.ToString();
                return msg;
            }

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getBillableTask(string projectid,string fromdate,string todate,string invoiceid)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            GeneralMethod objgen = new GeneralMethod();
            DataSet ds = new DataSet();
            string msg = "failure";
            try
            {

                objts.projectid = projectid;
                objts.from = fromdate;
                objts.to = todate;
                objts.action = "selectunbillingtask";
                objts.invoiceno = invoiceid;
                ds = objts.GetInvoice();
                msg = objgen.serilizeinJson(ds.Tables[0]);
                return msg;
            }
            catch (Exception ex)
            {
                //msg = ex.Message.ToString();
                return msg;
            }

        }



        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getinvoicedetailbyid(string nid)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            GeneralMethod objgen = new GeneralMethod();
            DataSet ds = new DataSet();
            string msg = "failure";
            try
            {

                objts.nid = nid;
                objts.action = "select";
                ds = objts.GetInvoice();
                msg = objgen.serilizeinJson(ds.Tables[1]);
                return msg;
            }
            catch (Exception ex)
            {
                //msg = ex.Message.ToString();
                return msg;
            }

        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        //Get maximum invoice number
        public static string getmaxinvoice(string companyid, string projectid)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();
            string msg = "failure";
            try
            {
                objts.action = "getmaxinvoice";
                objts.companyId = companyid;
                objts.projectid = projectid;
                ds = objts.GetInvoice();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    msg = ds.Tables[0].Rows[0]["invoiceno"].ToString() + "###" + ds.Tables[0].Rows[0]["prefix"].ToString() + "###" + ds.Tables[0].Rows[0]["postfix"].ToString();
                }
                return msg;
            }
            catch (Exception ex)
            {
                //msg = ex.Message.ToString();
                return msg;
            }

        }

    }
}