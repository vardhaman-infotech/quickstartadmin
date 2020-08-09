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
namespace empTimeSheet
{
    public partial class employee : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        GeneralMethod objgen = new GeneralMethod();
        ClsPayroll objpayroll = new ClsPayroll();
        DataSet ds = new DataSet();
        DataSet ds2 = new DataSet();
        DataTable distrolegroup = new DataTable();
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                if (!objda.checkUserInroles("2"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
                bindtimezone();


                fillcurrency();
                filldepartment();
                filldesignation();
                fillroles();
                fillgrid();
                fillcountry();
                btndelete.Visible = false;
                fillbranch();

            }
        }


        protected void bindtimezone()
        {

            ds = objda.getAllTimeZone();
            if (ds.Tables[0].Rows.Count > 0)
            {
                droptimezone.DataTextField = "displayname";
                droptimezone.DataValueField = "nid";
                droptimezone.DataSource = ds;
                droptimezone.DataBind();
            }
            ListItem li = new ListItem();
            li.Text = "--Select Timezone--";
            li.Value = "";
            droptimezone.Items.Insert(0, li);

            droptimezone.Text = Session["timeid"].ToString();
        }

        //Bind Different exiting rle type to make user roles selection easy, we are not going to save this value.

        public void fillbranch()
        {
            objda.action = "select";
            objda.company = Session["companyid"].ToString();
            objda.id = "";
            ds = objda.ManageBranch();
            if (ds.Tables[0].Rows.Count > 0)
            {
                dropemptype.DataTextField = "branchname";
                dropemptype.DataValueField = "nid";
                dropemptype.DataSource = ds;
                dropemptype.DataBind();
                ListItem li = new ListItem("--Select Branch--", "");
                dropemptype.Items.Insert(0, li);
            }
        }
        public DataTable filterroles(string id, DataTable dt)
        {
            DataView dv = new DataView(dt);
            dv.RowFilter = id;
            return dv.ToTable();
        }

        public void fillroles()
        {
            objda.action = "getroles";
            ds = objda.roles();
            DataView view1 = new DataView(ds.Tables[0]);
            distrolegroup = view1.ToTable(true, "rGroup");

            reproles.DataSource = distrolegroup;
            reproles.DataBind();

            //rbtnroles.DataSource = ds;
            //rbtnroles.DataTextField = "rolename";
            //rbtnroles.DataValueField = "nid";
            //rbtnroles.DataBind();


        }
        protected void reproles_ItemDataBound(object sender, DataListItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                CheckBoxList rbtnroles = ((CheckBoxList)e.Item.FindControl("rbtnroles"));

                rbtnroles.DataSource = filterroles("rGroup='" + DataBinder.Eval(e.Item.DataItem, "rGroup").ToString() + "'", ds.Tables[0]);
                rbtnroles.DataTextField = "rolename";
                rbtnroles.DataValueField = "nid";
                rbtnroles.DataBind();

            }
        }
        public void fillcurrency()
        {
            objda.action = "getcurrency";
            ds = objda.currency();
            dropcurrency.DataSource = ds;
            dropcurrency.DataTextField = "currencyName";
            dropcurrency.DataValueField = "nid";
            dropcurrency.DataBind();



        }

        public void filldepartment()
        {
            objda.id = "";
            objda.name = "";
            objda.company = Session["companyid"].ToString();
            objda.action = "select";
            ds = objda.department();
            dropdepartment.DataSource = ds;
            dropdepartment.DataTextField = "department";
            dropdepartment.DataValueField = "nid";
            dropdepartment.DataBind();

            dropdept.DataSource = ds;
            dropdept.DataTextField = "department";
            dropdept.DataValueField = "nid";
            dropdept.DataBind();


            ListItem li = new ListItem("--Select--", "");
            dropdepartment.Items.Insert(0, li);
            dropdepartment.SelectedIndex = 0;


            dropdept.Items.Insert(0, new ListItem("--All--", ""));
            dropdept.SelectedIndex = 0;
        }
        public void filldesignation()
        {
            objda.id = "";
            objda.name = "";
            objda.company = Session["companyid"].ToString();
            objda.action = "select";
            ds = objda.designation();
            dropdesignation.DataSource = ds;
            dropdesignation.DataTextField = "designation";
            dropdesignation.DataValueField = "nid";
            dropdesignation.DataBind();

            ListItem li = new ListItem("--Select--", "");
            dropdesignation.Items.Insert(0, li);
            dropdesignation.SelectedIndex = 0;


        }
        public void fillcountry()
        {
            objda.id = "";
            objda.action = "selectcountry";
            ds = objda.ManageMaster();
            dropcountry.DataSource = ds;
            dropcountry.DataTextField = "countryname";
            dropcountry.DataValueField = "nid";
            dropcountry.DataBind();
            ListItem li = new ListItem("--Select--", "");
            dropcountry.Items.Insert(0, li);
            dropcountry.SelectedIndex = 0;
            fillstate();
        }
        public void fillstate()
        {
            dropstate.Items.Clear();
            dropcity.Items.Clear();
            if (dropcountry.Text != "")
            {
                objda.id = "";
                objda.parentid = dropcountry.Text;
                objda.action = "selectstate";
                ds2 = objda.ManageMaster();
                dropstate.DataSource = ds2;
                dropstate.DataTextField = "statename";
                dropstate.DataValueField = "nid";
                dropstate.DataBind();
            }
            ListItem li = new ListItem("--Select--", "");
            dropstate.Items.Insert(0, li);
            dropstate.SelectedIndex = 0;
            fillcity();
        }

        public void fillcity()
        {
            dropcity.Items.Clear();
            if (dropstate.Text != "")
            {
                objda.id = "";
                objda.action = "selectcity";
                objda.parentid = dropstate.Text;
                ds2 = objda.ManageMaster();
                dropcity.DataSource = ds2;
                dropcity.DataTextField = "cityname";
                dropcity.DataValueField = "nid";
                dropcity.DataBind();
            }
            ListItem li = new ListItem("--Select--", "");
            dropcity.Items.Insert(0, li);
            dropcity.SelectedIndex = 0;
            if (Page.IsPostBack)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);
                updatecountry.Update();
            }


        }


        public void blank()
        {
            for (int i = 0; i < reproles.Items.Count; i++)
            {

                CheckBoxList rbtnroles = ((CheckBoxList)reproles.Items[i].FindControl("rbtnroles"));
                rbtnroles.ClearSelection();
            }



            hidid.Value = "";
            txtfname.Text = "";
            txtlname.Text = "";
            txtpassword.Text = "";
            txtempid.Text = "";
            dropmanager.SelectedIndex = 0;
            dropsubmitto.SelectedIndex = 0;
            dropdepartment.SelectedIndex = 0;
            dropdesignation.SelectedIndex = 0;
            txtjoin.Text = "";
            txtrelived.Text = "";
            txtcompanyemail.Text = "";
            dropactive.SelectedIndex = 0;
            hidaddress.Value = "";
            dropemptype.SelectedIndex = 0;
            txtlname.Text = "";
            dropcity.SelectedIndex = 0;
            dropstate.SelectedIndex = 0;
            dropcountry.SelectedIndex = 0;
            txtzip.Text = "";
            txtphone.Text = "";
            txtcell.Text = "";
            txtemail.Text = "";
            txtfax.Text = "";
            txtremark.Text = "";

            txtenrollno.Text = "";
            hidrate.Value = "";
            txtbillrate.Text = "";
            txtpayrate.Text = "";
            txtovertimebill.Text = "";
            txtovertimepayrate.Text = "";
            dropcurrency.SelectedIndex = 0;
            txtoverhead.Text = "";
            txtsalary.Text = "";
            btndelete.Visible = false;
            btnsubmit.Text = "Save";
            txtempid.Enabled = true;
            droptimezone.Text = Session["timeid"].ToString();

            txtdob.Text = "";
            droproletype.SelectedIndex = 0;


            //ltrNetSalary.InnerHtml = "0.00";
            //ltrtotaldeduction.InnerHtml = "0.00";
            //ltrGrossSalary.InnerText = "0.00";

        }
        protected void liaddnew_Click(object sender, EventArgs e)
        {
            blank();
            ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);
        }

        protected void btnexportcsv_Click(object sender, EventArgs e)
        {
            DataTable dt = new DataTable();
            StringBuilder sb = new StringBuilder();
            bindheader();
            fillgrid();
            if (ds.Tables[0].Rows.Count > 0)
            {
                sb.Append("<table cellpadding='4' cellspacing='0' style='font-family:Calibri;font-size:12px;' border='0'>" + bindheader() + "<tr><th style='text-align:center;'>S.No.</th><th style='text-align:left;'>Emp ID</th><th style='text-align:left;'>Emp Name</th><th style='text-align:left;'>Email</th><th style='text-align:left;'>Designation</th><th style='text-align:left;'>Department</th><th style='text-align:left;'>Join Date</th><th style='text-align:left;'>Released Date</th><th style='text-align:left;'>Active Status</th></tr>");

                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    if (ds.Tables[0].Rows[i]["activestatus"].ToString().ToLower() == "block")
                        sb.Append("<tr  style= 'color:red;'><td style='text-align:center;'>" + (i + 1).ToString() + "</td><td>" + ds.Tables[0].Rows[i]["loginid"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["fname"].ToString() + " " + ds.Tables[0].Rows[i]["lname"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["emailid"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["designation"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["department"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["joindate"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["releaseddate"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["activestatus"].ToString() + "</td></tr>");
                    else
                        sb.Append("<tr><td style='text-align:center;'>" + (i + 1).ToString() + "</td><td>" + ds.Tables[0].Rows[i]["loginid"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["fname"].ToString() + " " + ds.Tables[0].Rows[i]["lname"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["emailid"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["designation"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["department"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["joindate"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["releaseddate"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["activestatus"].ToString() + "</td></tr>");

                }
                sb.Append("</table>");

            }

            excelexport objexcel = new excelexport();
            objexcel.downloadFile(sb.ToString(), "Employee.xls");

        }
        protected string bindheader()
        {
            string str = "";
            string Companyname = Session["companyname"].ToString();

            str += "<tr><td colspan='9' style='background-color:blue;color:#ffffff;font-size:16px;' align='center'>" + Companyname + "</td></tr>";
            str += "<tr><td colspan='9' style='background-color:blue;color:#ffffff;font-size:14px;' align='center'>Employee List</td></tr>";

            return str;

        }
        protected void btnsubmit_Click(object sender, EventArgs e)
        {
            objuser.id = hidid.Value;
            objuser.companyid = Session["companyid"].ToString();
            objuser.action = "checkexist";
            objuser.loginid = txtempid.Text;
            objuser.enrollno = txtenrollno.Text;
            ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0)
            {
                if (ds.Tables[0].Rows[0]["etype"].ToString() == "empid")
                {
                    GeneralMethod.alert(this.Page, ds.Tables[0].Rows[0]["msg"].ToString());
                    ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);
                    return;
                }
                else
                {
                    if (txtenrollno.Text != "")
                    {
                        GeneralMethod.alert(this.Page, ds.Tables[0].Rows[0]["msg"].ToString());
                        ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);
                        return;
                    }

                }

            }
            string strroles = "";
            objuser.action = "insert";

            objuser.fname = txtfname.Text;
            objuser.lname = txtlname.Text;

            objuser.password = txtpassword.Text;
            objuser.usertype = "Employee";

            for (int k = 0; k < reproles.Items.Count; k++)
            {

                CheckBoxList rbtnroles = ((CheckBoxList)reproles.Items[k].FindControl("rbtnroles"));

                for (int i = 0; i < rbtnroles.Items.Count; i++)
                {
                    if (rbtnroles.Items[i].Selected == true)
                    {
                        strroles += rbtnroles.Items[i].Value + "#";
                    }
                }

            }


            objuser.roles = strroles;

            objuser.managerid = dropmanager.Text;
            objuser.submitto = dropsubmitto.Text;
            objuser.deptid = dropdepartment.Text;
            objuser.desigid = dropdesignation.Text;
            objuser.joindate = txtjoin.Text;
            objuser.releaseddate = txtrelived.Text;
            objuser.createdby = Session["userid"].ToString();
            objuser.activestatus = dropactive.Text;
            objuser.email = txtcompanyemail.Text;
            objuser.imgurl = dropemptype.Text;
            objuser.timezone = droptimezone.Text;
            objuser.roletype = droproletype.Text;
            objuser.dob = txtdob.Text;
            ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0)
            {
                objuser.action = "insert";
                objuser.id = hidaddress.Value;
                objuser.companyid = Session["companyid"].ToString();
                objuser.userid = ds.Tables[0].Rows[0]["nid"].ToString();
                objuser.name = txtlname.Text;
                objuser.street = txtstreet.Text;
                if (dropcity.Text != "")
                    objuser.city = dropcity.SelectedItem.Text;
                else
                    objuser.city = "";
                if (dropstate.Text != "")
                    objuser.state = dropstate.SelectedItem.Text;
                else
                    objuser.state = "";
                if (dropcountry.Text != "")
                    objuser.country = dropcountry.SelectedItem.Text;
                else
                    objuser.country = "";
                objuser.zip = txtzip.Text;
                objuser.email = txtemail.Text;
                objuser.phone = txtphone.Text;
                objuser.mobile = txtcell.Text;
                objuser.fax = txtfax.Text;
                objuser.remark = txtremark.Text;
                ds = objuser.address();

                objuser.action = "insert";
                objuser.id = hidrate.Value;
                objuser.empid = objuser.userid;
                if (txtbillrate.Text != "")
                    objuser.billrate = txtbillrate.Text;
                else
                    objuser.billrate = "0.00";

                if (txtpayrate.Text != "")
                    objuser.payrate = txtpayrate.Text;
                else
                    objuser.payrate = "0.00";

                if (txtovertimebill.Text != "")
                    objuser.overtimeBillRate = txtovertimebill.Text;
                else
                    objuser.overtimeBillRate = "0.00";
                if (txtovertimepayrate.Text != "")
                    objuser.overtimePayrate = txtovertimepayrate.Text;
                else
                    objuser.overtimePayrate = "0.00";

                objuser.currencyId = dropcurrency.Text;

                objuser.overheadMulti = txtoverhead.Text;
                if (txtsalary.Text != "")
                    objuser.salaryAmount = txtsalary.Text;
                else
                    objuser.salaryAmount = "0.00";

                ds = objuser.emprate();

                fillgrid();
                if (hidid.Value == "")
                {
                    blank();
                    GeneralMethod.alert(this.Page, "Saved Successfully!");
                }
                else
                {

                    GeneralMethod.alert(this.Page, "Information updated Successfully!");
                }


            }
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string savedata(string id, string companyid, string loginid, string enrollno, string fname, string lname, string password, string usertype, string roles, string managerid, string submitto, string deptid, string desigid, string joindate, string releaseddate, string createdby, string activestatus, string email, string imgurl, string timezone, string roletype, string dob, string hidaddress, string userid, string name, string street, string city, string state, string country, string zip, string addressemail, string phone, string mobile, string fax, string remark, string hidrate, string empid, string billrate, string payrate, string overtimeBillRate, string overtimePayrate, string currencyId, string overheadMulti, string salaryAmount)
        {
            ClsUser objuser = new ClsUser();
            GeneralMethod objgen = new GeneralMethod();
            DataSet ds = new DataSet();
            string result = "";
            int status = 1;

            objuser.id = id;
            objuser.companyid = companyid;
            objuser.action = "checkexist";
            objuser.loginid = loginid;
            objuser.enrollno = enrollno;
            ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0)
            {
                

                status = 0;
                result = @"[{""result"":""0"",""msg"":"""+ds.Tables[0].Rows[0]["msg"].ToString()+@"""}]";

            }
            if (status == 1)
            {
                objuser.action = "insert";

                objuser.fname = fname;
                objuser.lname = lname;
                objuser.password = password;
                objuser.usertype = usertype;
                objuser.roles = roles;
                objuser.managerid = managerid;
                objuser.submitto = submitto;
                objuser.deptid = deptid;
                objuser.desigid = desigid;
                objuser.joindate = joindate;
                objuser.releaseddate = releaseddate;
                objuser.createdby = createdby;
                objuser.activestatus = activestatus;
                objuser.email = email;
                objuser.imgurl = imgurl;
                objuser.timezone = timezone;
                objuser.roletype = roletype;
                objuser.dob = dob;
                ds = objuser.ManageEmployee();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    objuser.action = "insert";
                    objuser.id = hidaddress;
                    objuser.userid = userid;
                    objuser.name = name;
                    objuser.street = street;
                    objuser.city = city;
                    objuser.state = state;
                    objuser.country = country;
                    objuser.zip = zip;
                    objuser.email = addressemail;
                    objuser.phone = phone;
                    objuser.mobile = mobile;
                    objuser.fax = fax;
                    objuser.remark = remark;
                    ds = objuser.address();

                    objuser.action = "insert";
                    objuser.id = hidrate;
                    objuser.empid = empid;
                    objuser.billrate = billrate;
                    objuser.payrate = payrate;
                    objuser.overtimeBillRate = overtimeBillRate;
                    objuser.overtimePayrate = overtimePayrate;
                    objuser.currencyId = currencyId;
                    objuser.overheadMulti = overheadMulti;
                    objuser.salaryAmount = salaryAmount;

                    ds = objuser.emprate();

                    result = @"[{""result"":""1"",""msg"":""""}]";
                }
            }

            return result;

        }

        protected void dropcountry_SelectedIndexChanged(object sender, EventArgs e)
        {
            fillstate();
        }

        protected void dropstate_SelectedIndexChanged(object sender, EventArgs e)
        {
            fillcity();
        }

        /// <summary>
        /// Delete selected record
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btndelete_Click(object sender, EventArgs e)
        {
            objuser.action = "delete";
            objuser.id = hidid.Value;
            ds = objuser.ManageEmployee();
            blank();
            fillgrid();
            GeneralMethod.alert(this.Page, "Deleted Successfully!");
        }

        //------------------------------------------SALARY SETUP------------------------------------------------








        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string selectrolebytype(string roletype)
        {
            ClsUser objuser = new ClsUser();
            GeneralMethod objgen = new GeneralMethod();
            DataSet ds = new DataSet();
            string msg = "failure";

            try
            {

                objuser.action = "getrolesbytype";
                objuser.roles = roletype;
                ds = objuser.ManageEmployee();
                string result = objgen.serilizeinJson(ds.Tables[0]);
                return result;
            }
            catch (Exception ex)
            {
                return msg;
            }


        }


        /// <summary>
        /// When search any record
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>



        protected void btnsearch_Click(object sender, EventArgs e)
        {
            dgnews.PageIndex = 0;
            fillgrid();
        }
        public void fillgrid()
        {
            objuser.fname = txtsearch.Text;
            objuser.action = "select";
            objuser.companyid = Session["companyid"].ToString();
            objuser.id = "";
            objuser.activestatus = drostatus.Text;
            objuser.deptid = dropdept.Text;
            ds = objuser.ManageEmployee();

            DataTable dt = new DataTable();
            dt = ds.Tables[0];

            //int start = dgnews.PageSize * dgnews.PageIndex;
            //int end = start + dgnews.PageSize;
            //start = start + 1;
            //if (end >= ds.Tables[0].Rows.Count)
            //    end = ds.Tables[0].Rows.Count;
            //lblstart.Text = start.ToString();
            //lblend.Text = end.ToString();
            //lbltotalrecord.Text = ds.Tables[0].Rows.Count.ToString();

            if (ds.Tables[0].Rows.Count > 0)
            {
                //if (ViewState["SortDirection"] != null && ViewState["SortExpression"] != null)
                //{
                //    dt.DefaultView.Sort = ViewState["SortExpression"].ToString() + " " + ViewState["SortDirection"].ToString();
                //}
                Session["TaskTable"] = dt;

                dgnews.DataSource = dt;
                dgnews.DataBind();
                btnexportcsv.Enabled = true;

                nodata.Visible = false;
                dgnews.Visible = true;
                lnkprevious.Enabled = true;
                lnknext.Enabled = true;
                if (lbltotalrecord.Text == lblend.Text)
                {
                    lnknext.Enabled = false;
                }
                if (lblstart.Text == "1")
                {
                    lnkprevious.Enabled = false;
                }


            }
            else
            {
                lblstart.Text = "0";
                lnkprevious.Enabled = false;
                lnknext.Enabled = false;
                //  btnexportcsv.Enabled = false;
                if (IsPostBack)
                {
                    nodata.Visible = true;
                }
                dgnews.Visible = false;

                Session["TaskTable"] = null;
            }

            if (!Page.IsPostBack)
            {
                objuser.action = "selectactive";
                objuser.id = "";
                ds = objuser.ManageEmployee();


                dropmanager.DataSource = ds;
                dropmanager.DataTextField = "username";
                dropmanager.DataValueField = "nid";




                dropsubmitto.DataSource = ds;
                dropsubmitto.DataTextField = "username";
                dropsubmitto.DataValueField = "nid";

                dropmanager.DataBind();
                dropsubmitto.DataBind();

                ListItem li = new ListItem("", "");
                dropmanager.Items.Insert(0, li);
                dropsubmitto.Items.Insert(0, li);

                dropmanager.SelectedIndex = 0;
                dropsubmitto.SelectedIndex = 0;


            }
            updateData.Update();
            ScriptManager.RegisterStartupScript(updateData, updateData.GetType(), "key", "<script type='text/javascript'>fixheader();</script>", false);

        }
        protected void dgnews_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            dgnews.PageIndex = e.NewPageIndex;
            fillgrid();

        }

        /// <summary>
        /// Paging- Go to previous page
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void lnkprevious_Click(object sender, EventArgs e)
        {
            if (dgnews.PageIndex > 0)
            {
                dgnews.PageIndex = dgnews.PageIndex - 1;
                fillgrid();
            }
        }

        /// <summary>
        /// Paging- Move to next page
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void lnknext_Click(object sender, EventArgs e)
        {
            if (int.Parse(lbltotalrecord.Text) > int.Parse(lblend.Text))
            {
                dgnews.PageIndex = dgnews.PageIndex + 1;
                fillgrid();
            }
        }



        protected void dgnews_RowCommand(object sender, GridViewCommandEventArgs e)
        {


            if (e.CommandName.ToLower() == "remove")
            {
                objuser.action = "delete";
                objuser.id = e.CommandArgument.ToString();
                ds = objuser.ManageEmployee();

                fillgrid();
                GeneralMethod.alert(this.Page, "Deleted Successfully!");
            }
            if (e.CommandName.ToLower() == "detail")
            {


            }
        }
        /// <summary>
        /// For Sorting in Grid View
        /// </summary>
        /// <param name="source"></param>
        /// <param name="e"></param>
        protected void dgnews_Sorting(object source, GridViewSortEventArgs e)
        {
            //Retrieve the table from the session object.
            DataTable dt = Session["TaskTable"] as DataTable;

            if (dt != null)
            {

                //Sort the data.
                dt.DefaultView.Sort = e.SortExpression + " " + GetSortDirection(e.SortExpression);
                dgnews.DataSource = Session["TaskTable"];
                dgnews.DataBind();
            }
            ScriptManager.RegisterStartupScript(updateData, updateData.GetType(), "key", "<script type='text/javascript'>fixheader();</script>", false);
        }
        protected void dgnews_RowCreated(object sender, GridViewRowEventArgs e)
        {
            //check if it is a header row
            //since allowsorting is set to true, column names are added as command arguments to
            //the linkbuttons by DOTNET API
            if (e.Row.RowType == DataControlRowType.Header)
            {
                LinkButton btnSort;
                Image image;
                //iterate through all the header cells
                foreach (TableCell cell in e.Row.Cells)
                {
                    //check if the header cell has any child controls
                    if (cell.HasControls())
                    {
                        //get reference to the button column
                        btnSort = (LinkButton)cell.Controls[0];
                        image = new Image();
                        if (ViewState["SortExpression"] != null)
                        {
                            //see if the button user clicked on and the sortexpression in the viewstate are same
                            //this check is needed to figure out whether to add the image to this header column nor not
                            if (btnSort.CommandArgument == ViewState["SortExpression"].ToString())
                            {
                                //following snippet figure out whether to add the up or down arrow
                                //based on the sortdirection
                                if (ViewState["SortDirection"].ToString() == "ASC")
                                {
                                    image.ImageUrl = "/images/asc.png";
                                }
                                else
                                {
                                    image.ImageUrl = "/images/desc.png";
                                }
                                cell.Controls.Add(image);
                                // return;
                            }
                            else
                            {
                                image.ImageUrl = "/images/updown.png";
                                cell.Controls.Add(image);
                            }
                        }
                        else
                        {
                            image.ImageUrl = "/images/updown.png";
                            cell.Controls.Add(image);
                        }
                    }
                }
            }
        }
        /// <summary>
        /// Get direction for sorting
        /// </summary>
        /// <param name="column"></param>
        /// <returns></returns>
        private string GetSortDirection(string column)
        {

            string sortDirection = "DESC";


            // Retrieve the last column that was sorted.
            string sortExpression = ViewState["SortExpression"] as string;

            if (sortExpression != null)
            {
                // Check if the same column is being sorted.
                // Otherwise, the default value can be returned.
                if (sortExpression == column)
                {
                    string lastDirection = ViewState["SortDirection"] as string;
                    if ((lastDirection != null) && (lastDirection == "ASC"))
                    {
                        sortDirection = "DESC";
                    }
                    if ((lastDirection != null) && (lastDirection == "DESC"))
                    {
                        sortDirection = "ASC";
                    }
                }
            }

            // Save new values in ViewState.
            ViewState["SortDirection"] = sortDirection;
            ViewState["SortExpression"] = column;

            return sortDirection;
        }

        protected void dgnews_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.Header)
                e.Row.TableSection = TableRowSection.TableHeader;

            if (e.Row.RowType == DataControlRowType.DataRow)
            {

                if (DataBinder.Eval(e.Row.DataItem, "activestatus") != null && DataBinder.Eval(e.Row.DataItem, "activestatus").ToString().ToLower() != "active")
                {

                    e.Row.CssClass = "inactiverecord";
                }

            }
        }

        protected void PaggedGridbtnedit_Click(object sender, EventArgs e)
        {


            objuser.id = hidid.Value;
            blank();
            hidid.Value = objuser.id;
            objuser.action = "select";

            ds = objuser.ManageEmployee();

            if (ds.Tables[0].Rows.Count > 0)
            {
                txtempid.Text = ds.Tables[0].Rows[0]["loginid"].ToString();
                txtfname.Text = ds.Tables[0].Rows[0]["fname"].ToString();
                txtlname.Text = ds.Tables[0].Rows[0]["lname"].ToString();
                txtpassword.Text = ds.Tables[0].Rows[0]["password"].ToString();
                txtcompanyemail.Text = ds.Tables[0].Rows[0]["emailid"].ToString();
                try
                {
                    dropmanager.Text = ds.Tables[0].Rows[0]["managerid"].ToString();
                }
                catch
                {
                    dropmanager.SelectedIndex = 0;
                }
                try
                {
                    dropsubmitto.Text = ds.Tables[0].Rows[0]["submitto"].ToString();
                }
                catch
                {
                    dropsubmitto.SelectedIndex = 0;
                }
                try
                {
                    dropdepartment.Text = ds.Tables[0].Rows[0]["deptid"].ToString();
                }
                catch
                {
                    dropdepartment.SelectedIndex = 0;
                }



                dropdesignation.Text = ds.Tables[0].Rows[0]["desigid"].ToString();
                txtjoin.Text = ds.Tables[0].Rows[0]["joindate"].ToString();
                txtrelived.Text = ds.Tables[0].Rows[0]["releaseddate"].ToString();
                txtenrollno.Text = ds.Tables[0].Rows[0]["enrollno"].ToString();
                droproletype.Text = ds.Tables[0].Rows[0]["roletype"].ToString();
                droptimezone.Text = ds.Tables[0].Rows[0]["timezone"].ToString();

                txtdob.Text = ds.Tables[0].Rows[0]["dob"].ToString();

                if (ds.Tables[0].Rows[0]["branchtype"] != null && ds.Tables[0].Rows[0]["branchtype"].ToString() != "")
                    dropemptype.Text = ds.Tables[0].Rows[0]["branchtype"].ToString();
                dropactive.Text = ds.Tables[0].Rows[0]["activestatus"].ToString();

                for (int i = 0; i < reproles.Items.Count; i++)
                {

                    CheckBoxList rbtnroles = ((CheckBoxList)reproles.Items[i].FindControl("rbtnroles"));

                    rbtnroles.ClearSelection();

                }



                if (ds.Tables[0].Rows[0]["roles"].ToString() != "")
                {
                    string[] strroles = ds.Tables[0].Rows[0]["roles"].ToString().Split('#');
                    for (int i = 0; i < strroles.Length; i++)
                    {
                        for (int k = 0; k < reproles.Items.Count; k++)
                        {

                            CheckBoxList rbtnroles = ((CheckBoxList)reproles.Items[k].FindControl("rbtnroles"));

                            for (int j = 0; j < rbtnroles.Items.Count; j++)
                            {

                                if (rbtnroles.Items[j].Value == strroles[i])
                                {
                                    rbtnroles.Items[j].Selected = true;

                                }

                            }

                        }





                    }

                }

                if (ds.Tables[1].Rows.Count > 0)
                {
                    //Fill Address
                    hidaddress.Value = ds.Tables[1].Rows[0]["nid"].ToString();
                    txtstreet.Text = ds.Tables[1].Rows[0]["street"].ToString();


                    ListItem itemToSelect = dropcountry.Items.FindByText(ds.Tables[1].Rows[0]["country"].ToString());
                    if (itemToSelect != null)
                    {
                        dropcountry.Text = itemToSelect.Value;
                    }
                    fillstate();

                    ListItem itemToSelect1 = dropstate.Items.FindByText(ds.Tables[1].Rows[0]["state"].ToString());
                    if (itemToSelect1 != null)
                    {
                        dropstate.Text = itemToSelect1.Value;

                    }
                    fillcity();

                    ListItem itemToSelect2 = dropcity.Items.FindByText(ds.Tables[1].Rows[0]["city"].ToString());
                    if (itemToSelect2 != null)
                    {
                        dropcity.Text = itemToSelect2.Value;
                    }


                    txtzip.Text = ds.Tables[1].Rows[0]["zip"].ToString();
                    txtemail.Text = ds.Tables[1].Rows[0]["email"].ToString();
                    txtphone.Text = ds.Tables[1].Rows[0]["phone"].ToString();
                    txtcell.Text = ds.Tables[1].Rows[0]["mobile"].ToString();
                    txtfax.Text = ds.Tables[1].Rows[0]["fax"].ToString();
                    txtremark.Text = ds.Tables[1].Rows[0]["remark"].ToString();
                }
                else
                {
                    hidaddress.Value = "";
                }
                if (ds.Tables[2].Rows.Count > 0)
                {

                    hidrate.Value = ds.Tables[2].Rows[0]["nid"].ToString();
                    txtbillrate.Text = ds.Tables[2].Rows[0]["billrate"].ToString();
                    txtpayrate.Text = ds.Tables[2].Rows[0]["payrate"].ToString();
                    txtovertimebill.Text = ds.Tables[2].Rows[0]["overtimeBillRate"].ToString();
                    txtovertimepayrate.Text = ds.Tables[2].Rows[0]["overtimePayrate"].ToString();
                    dropcurrency.Text = ds.Tables[2].Rows[0]["currencyId"].ToString();
                    txtoverhead.Text = ds.Tables[2].Rows[0]["overheadMulti"].ToString();
                    txtsalary.Text = ds.Tables[2].Rows[0]["salaryAmount"].ToString();
                }
                else
                {
                    hidrate.Value = "";
                }

                btndelete.Visible = true;
                btnsubmit.Text = "Update";
                //  txtempid.Enabled = false;





                ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);
                upadatepanel1.Update();
            }
        }



    }
}