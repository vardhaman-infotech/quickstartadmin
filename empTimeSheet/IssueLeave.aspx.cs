using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Data;
using System.IO;
using System.Web.Services;
using System.Web.Script.Services;
namespace empTimeSheet
{
    public partial class IssueLeave : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsTimeSheet objts = new ClsTimeSheet();
        ClsPayroll objpayroll = new ClsPayroll();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();
        static DataSet dsexcel = new DataSet();
        excelexport objexcel = new excelexport();
        protected void Page_Load(object sender, EventArgs e)
        {
            txtdescription.Attributes.Add("maxlength", "500");
            txtleavedate.Attributes.Add("readonly", "readonly");
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {


                txtleavedate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");

                if (!objda.checkUserInroles("17"))
                {

                    Response.Redirect("UserDashboard.aspx");
                }
                //If user have right to Approve Leaves of Employee

                if (objda.checkUserInroles("17"))
                {

                    ViewState["add"] = "1";
                }
                else
                {
                    ViewState["add"] = null;
                }
                fillleavetype();
                fillemployee();

            }

        }
        
        // <summary>
        /// Fill Leave Type drop down for seraching
        /// </summary>
        protected void fillleavetype()
        {

            ddlleavetype.Items.Clear();

            objpayroll.action = "selectleavetype";
            objpayroll.companyid = Session["companyId"].ToString();
            ds = objpayroll.LeaveRequest();

            if (ds.Tables[0].Rows.Count > 0)
            {

                ddlleavetype.DataSource = ds;
                ddlleavetype.DataTextField = "LeaveType";
                ddlleavetype.DataValueField = "nid";
                ddlleavetype.DataBind();
            }

            ListItem li1 = new ListItem("--Select--", "");
            ddlleavetype.Items.Insert(0, li1);

        }



        /// <summary>
        /// Fill Employee to select for those who have admin Right
        /// </summary>
        protected void fillemployee()
        {

            objuser.action = "selectactive";
            objuser.companyid = Session["companyid"].ToString();
            objuser.id = "";
            ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0)
            {

                ddlEmployee.DataSource = ds;
                ddlEmployee.DataTextField = "username";
                ddlEmployee.DataValueField = "nid";
                ddlEmployee.DataBind();
                ddlEmployee.Enabled = true;

            }

            ListItem li = new ListItem("--Select Employee--", "");

            ddlEmployee.Items.Insert(0, li);
            ddlEmployee.SelectedIndex = 0;
        }




        // <summary>
        /// Save New Assigned task
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnsubmit_Click(object sender, EventArgs e)
        {
            objpayroll.nid = "";
            objpayroll.Date = txtleavedate.Text;
            objpayroll.NumofDays = txtnoofdays.Text;
            objpayroll.Description = txtdescription.Text;
            objpayroll.Leavetypeid = ddlleavetype.Text;
            if (objpayroll.Leavetypeid == "4" || objpayroll.Leavetypeid == "5")
            {
                hidtodate.Value = txtleavedate.Text;
                objpayroll.NumofDays = "1";
            }
            objpayroll.RequestDate = hidtodate.Value;
            objpayroll.Empid = ddlEmployee.Text;
            objpayroll.Createdby = Session["userid"].ToString();
            objpayroll.Status = "Approved";
            objpayroll.type = "Emergency";
            objpayroll.action = "insertemergencyleave";
            objpayroll.companyid = Session["companyid"].ToString();

            ds = objpayroll.LeaveRequest();
            sendemail(ds.Tables[0].Rows[0]["nid"].ToString());
            GeneralMethod.alert(this.Page, "Saved Successfully.");

            blank();

            updatePanelAssign.Update();
        }

        protected void sendemail(string id)
        {

            string bccemail = "";
            string cc = "";
            string bcc = bccemail;
            string filename = "";
            string date = "";
            string receiver = "";
            //Get users who have Access to Add Schedule to Send Email CC
            cc = objda.GetCompanyProperty("ReceiverMail") + ",";

            objpayroll.action = "selectleavemanager";
            objpayroll.companyid = Session["companyid"].ToString();
            objpayroll.nid = id;
            ds = objpayroll.LeaveRequest();
            if (ds != null)
            {
                if (ds.Tables[1].Rows.Count > 0)
                {
                    if (ds.Tables[1].Rows[0]["EmailCC"] != null)
                    {
                        cc = ds.Tables[1].Rows[0]["EmailCC"].ToString();
                    }

                }
                if (ds.Tables.Count > 1)
                {
                    if (ds.Tables[2].Rows.Count > 0)
                    {
                        if (ds.Tables[2].Rows[0]["manageremail"].ToString() != "")
                        {
                            receiver = ds.Tables[2].Rows[0]["manageremail"].ToString() + ",";

                        }

                    }
                }
            }


            objpayroll.nid = id;
            objpayroll.action = "select";
            ds = objpayroll.LeaveRequest();
            if (ds.Tables[0].Rows.Count > 0)
            {
                string subject = "Issued Leave";
                

                receiver += ds.Tables[0].Rows[0]["emailid"].ToString() + ",";

                string HTMLTemplatePath = Server.MapPath("EmailTemplates/issueleave.html");

                string HTMLBODY = File.ReadAllText(HTMLTemplatePath);

                if (ds.Tables[0].Rows[0]["LeaveDate"].ToString() == ds.Tables[0].Rows[0]["LeaveToDate"].ToString())
                {
                    date = "for " + ds.Tables[0].Rows[0]["LeaveDate"].ToString();
                }
                else
                {
                    date = " from " + ds.Tables[0].Rows[0]["LeaveDate"].ToString() + " to " + ds.Tables[0].Rows[0]["LeaveToDate"].ToString();
                }
                HTMLBODY = HTMLBODY.Replace("##empname##", ds.Tables[0].Rows[0]["empname"].ToString());
                HTMLBODY = HTMLBODY.Replace("##numofdays##", ds.Tables[0].Rows[0]["numofdays"].ToString());
                HTMLBODY = HTMLBODY.Replace("##leavetype##", ds.Tables[0].Rows[0]["LeaveType"].ToString());
                HTMLBODY = HTMLBODY.Replace("##empid##", ds.Tables[0].Rows[0]["emploginid"].ToString());
                HTMLBODY = HTMLBODY.Replace("##requestid##", ds.Tables[0].Rows[0]["nid"].ToString());

                HTMLBODY = HTMLBODY.Replace("##site##", ds.Tables[0].Rows[0]["schedulerURL"].ToString());


                HTMLBODY = HTMLBODY.Replace("##date##", date);
                HTMLBODY = HTMLBODY.Replace("##LeaveType##", ds.Tables[0].Rows[0]["LeaveType"].ToString());

                HTMLBODY = HTMLBODY.Replace("##description##", ds.Tables[0].Rows[0]["description"].ToString());

                objda.SendEmail(receiver, subject, HTMLBODY, cc, bcc, filename);

            }
        }
        public void blank()
        {
            txtleavedate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");
            txtnoofdays.Text = "";
            txtdescription.Text = "";
            ddlleavetype.SelectedIndex = 0;
            ddlEmployee.SelectedIndex = 0;
            hidtodate.Value = "";
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]

        public static string getLeaveToDate(string LeaveDate, string NumOfDays, string empid,string companyid)
        {
            string msg = "";
            msg = "success";
            if (LeaveDate != "" && NumOfDays != "")
            {
                ClsPayroll objpayroll = new ClsPayroll();
                DataSet ds = new DataSet();

                objpayroll.action = "getLeaveToDate";
                objpayroll.Date = LeaveDate;
                objpayroll.NumofDays = NumOfDays;
                objpayroll.Empid = empid;
                objpayroll.companyid = companyid;
                try
                {
                    ds = objpayroll.LeaveRequest();
                    if (LeaveDate != ds.Tables[0].Rows[0]["LeaveDate"].ToString())
                    {
                        msg = "fail";
                    }
                    else
                    {
                        msg = ds.Tables[0].Rows[0]["LeaveToDate"].ToString();
                    }
                    return msg;
                }
                catch (Exception ex)
                {
                    msg = ex.Message;
                    return msg;
                }
            }
            else
            {
                return msg;
            }

        }

        protected void ddlEmployee_SelectedIndexChanged(object sender, EventArgs e)
        {

            objpayroll.Empid = "";
            objpayroll.from = "";

            objpayroll.to = "";
            objpayroll.Status = "";
            objpayroll.Leavetypeid = "";
            objpayroll.companyid = Session["companyid"].ToString();
            objpayroll.action = "getleavedetail";
            objpayroll.RequestDate = txtleavedate.Text;

            if (txtleavedate.Text == "")
            {
                objpayroll.Date = System.DateTime.Now.ToString("MM/dd/yyyy");
            }
            else
            {
                objpayroll.Date = txtleavedate.Text;
            }
            objpayroll.nid = "";
            objpayroll.loginid = ddlEmployee.SelectedValue;
           DataSet dsx = objpayroll.LeaveRequest();

            litpl.Text = dsx.Tables[0].Rows[0]["noofpaid"].ToString();

            litapl.Text = dsx.Tables[0].Rows[0]["totalacc"].ToString();
            littakenpl.Text = dsx.Tables[0].Rows[0]["totalpaid"].ToString();
            littakenupl.Text = dsx.Tables[0].Rows[0]["unpaidleave"].ToString();
            litbalancepl.Text = dsx.Tables[0].Rows[0]["remAcc"].ToString();
            tblstatus.Visible = true;
        }
    }

     
}

