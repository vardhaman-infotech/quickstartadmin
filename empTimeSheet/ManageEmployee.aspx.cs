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
    public partial class ManageEmployee : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DataAccess objda = new DataAccess();
            GeneralMethod objgen = new GeneralMethod();
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                if (!objda.checkUserInroles("2"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
            }
        }


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getCurrency()
        {
            DataAccess objda = new DataAccess();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();
            objda.action = "getcurrency";
            ds = objda.currency();
            string result = objgen.serilizeinJson(ds.Tables[0]);
            return result;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getTimeZone()
        {
            DataAccess objda = new DataAccess();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();
            ds = objda.getAllTimeZone();
            string result = objgen.serilizeinJson(ds.Tables[0]);
            return result;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getDepartment(string companyid)
        {
            DataAccess objda = new DataAccess();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();
            objda.id = "";
            objda.name = "";
            objda.company = companyid;
            objda.action = "select";
            ds = objda.department();
            string result = objgen.serilizeinJson(ds.Tables[0]);
            return result;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getDesignation(string companyid)
        {
            DataAccess objda = new DataAccess();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();
            objda.id = "";
            objda.name = "";
            objda.company = companyid;
            objda.action = "select";
            ds = objda.designation();
            string result = objgen.serilizeinJson(ds.Tables[0]);
            return result;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string DeleteType(string companyid, string locid, string nid)
        {
            DataAccess objda = new DataAccess();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();

            objda.action = "delete";
            objda.id = nid;
            if (locid == "dept")
                ds = objda.department();
            else
                ds = objda.designation();
            string result = objgen.serilizeinJson(ds.Tables[0]);
            return result;
        }



        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string deleterolegroup(string RoleGroupId)
        {
            DataAccess objda = new DataAccess();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();
            objda.id = RoleGroupId;

            objda.action = "delete";
            ds = objda.ManageRoleGroup();
            string result = objgen.serilizeinJson(ds.Tables[0]);
            return result;
        }


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string SaveType(string companyid, string typeid, string typetitle, string nid)
        {
            DataAccess objda = new DataAccess();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();
            int status = 1;
            string result = "";
            objda.action = "insert";

            if (typetitle == "")
            {
                status = 0;
                result = @"[{""result"":""0"",""msg"":""Please fill required fields""}]";
            }
            if (status == 1)
            {
                string[] typetitle1 = typetitle.Split('#');
                string[] nid1 = nid.Split('#');
                if (typetitle1.Length > 0)
                {
                    for (int i = 0; i < typetitle1.Length; i++)
                    {
                        if (typetitle1[i] != "")
                        {
                            objda.id = nid1[i];
                            objda.name = typetitle1[i];
                            objda.loginid = "0";
                            objda.description = typetitle1[i];
                            objda.action = "insert";
                            objda.company = companyid;
                            if (typeid == "dept")
                                ds = objda.department();
                            else
                                ds = objda.designation();

                        }
                    }
                }

                result = @"[{""result"":""1"",""msg"":""""}]";

            }
            return result;
        }


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string saverolegroup(string nid, string rolename, string roleid, string companyid)
        {
            DataAccess objda = new DataAccess();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();
            objda.id = nid;
            objda.company = companyid;
            objda.name = rolename;
            objda.description = roleid;
            objda.action = "insert";
            ds = objda.ManageRoleGroup();
            string result = "1";
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                result = ds.Tables[0].Rows[i]["recordUpdated"].ToString();
            }
            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getRoleGroup(string companyid, string nid)
        {
            DataAccess objda = new DataAccess();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();
            objda.id = nid;
            objda.company = companyid;
            objda.action = "select";
            ds = objda.ManageRoleGroup();
            string result = objgen.serilizeinJson(ds.Tables[0]);
            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getRoleHTML()
        {
            DataAccess objda = new DataAccess();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();
            objda.id = "";
            objda.name = "";

            objda.action = "getallroles";
            ds = objda.ManageRoleGroup();

            StringBuilder sb = new StringBuilder();
            string result = "";
            int num = 0;
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                if (num == 0)
                {
                    result += "<tr>";

                }
                result += "<td> <div class='roleheader color'>" + ds.Tables[0].Rows[i]["rGroup"].ToString() + "</div><div class='roleBox'>";
                DataTable dtbyInt = new DataTable();
                dtbyInt = objgen.filterTable("rGroup='" + ds.Tables[0].Rows[i]["rGroup"].ToString() + "'", ds.Tables[1]);
                for (int j = 0; j < dtbyInt.Rows.Count; j++)
                {
                    result += "<div><input type='checkbox' name='chkrole' value='" + dtbyInt.Rows[j]["nid"].ToString() + "' /><span>" + dtbyInt.Rows[j]["roleName"].ToString() + "</span></div>";
                }
                result += "</div></td>";
                if (num == 2)
                {
                    result += "</tr>";
                    num = 0;

                }
                else
                {
                    num = num + 1;
                }
            }




            return result;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getBranch(string companyid)
        {
            DataAccess objda = new DataAccess();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();
            objda.id = "";
            objda.name = "";
            objda.company = companyid;
            objda.action = "select";
            ds = objda.ManageBranch();
            string result = objgen.serilizeinJson(ds.Tables[0]);
            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getManager(string companyid)
        {
            ClsUser objuser = new ClsUser();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();
            objuser.action = "selectactive";
            objuser.id = "";
            objuser.companyid = companyid;
            ds = objuser.ManageEmployee();
            string result = objgen.serilizeinJson(ds.Tables[0]);
            return result;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getdata(string nid, string companyid)
        {
            ClsUser objuser = new ClsUser();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();

            objuser.fname = "";
            objuser.action = "select";
            objuser.companyid = companyid;
            objuser.id = nid;
            objuser.activestatus = "";
            objuser.deptid = "";
            ds = objuser.ManageEmployee();
            string result = "";
            if (nid == "")
            {
                result = objgen.serilizeinJson(ds.Tables[0]);
            }
            else
            {
                result = objgen.serilizeinJson(ds.Tables[0]);
                if (ds.Tables[1].Rows.Count > 0)
                {
                    result = result + "##{}##" + objgen.serilizeinJson(ds.Tables[1]);
                }
                else
                {
                    result = result + "##{}##" + "";
                }

                if (ds.Tables[2].Rows.Count > 0)
                {
                    result = result + "##{}##" + objgen.serilizeinJson(ds.Tables[2]);
                }
                else
                {
                    result = result + "##{}##" + "";
                }
            }
            return result;
        }


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string deletedata(string companyid, string nid)
        {
            ClsUser objda = new ClsUser();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();

            objda.action = "delete";
            objda.id = nid;

            ds = objda.ManageEmployee();
            string result = objgen.serilizeinJson(ds.Tables[0]);
            return result;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string savedata(string id, string companyid, string loginid, string enrollno, string fname, string lname, string password, string usertype, string roles, string managerid, string submitto, string deptid, string desigid, string joindate, string releaseddate, string createdby, string activestatus, string email, string imgurl, string timezone, string dob, string hidaddress, string name, string street, string city, string state, string country, string zip, string addressemail, string phone, string mobile, string fax, string remark, string hidrate, string billrate, string payrate, string overtimeBillRate, string overtimePayrate,
            string currencyId, string overheadMulti, string salaryAmount, string appointment)
        {
            ClsUser objuser = new ClsUser();
            GeneralMethod objgen = new GeneralMethod();
            DataSet ds = new DataSet();
            string result = "";


            objuser.id = id;
            objuser.companyid = companyid;
            objuser.action = "insert";
            objuser.loginid = loginid;
            objuser.enrollno = enrollno;
            objuser.fname = fname;
            objuser.lname = lname;
            objuser.password = password;
            objuser.usertype = usertype;
            if (objuser.usertype == "Admin")
                objuser.roles = "";
            else
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
            objuser.appointment = appointment == "1" ? true : false;
            objuser.dob = dob;
            ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0 && ds.Tables[0].Rows[0]["result"].ToString() == "1")
            {
                objuser.action = "insert";
                objuser.id = hidaddress;
                objuser.userid = ds.Tables[0].Rows[0]["nid"].ToString();
                objuser.name = name;
                objuser.street = street;
                objuser.city = city;
                objuser.state = state;
                objuser.country = country;
                objuser.usertype = "Employee";
                objuser.zip = zip;
                objuser.email = addressemail;
                objuser.phone = phone;
                objuser.mobile = mobile;
                objuser.fax = fax;
                objuser.remark = remark;
                ds = objuser.address();

                objuser.action = "insert";
                objuser.id = hidrate;
                objuser.empid = objuser.userid;
                if (billrate == "")
                    billrate = "0";
                if (payrate == "")
                    payrate = "0";

                if (overtimeBillRate == "")
                    overtimeBillRate = "0";

                if (overtimePayrate == "")
                    overtimePayrate = "0";

                if (overheadMulti == "")
                    overheadMulti = "1";

                if (salaryAmount == "")
                    salaryAmount = "0";
                if (overheadMulti == "")
                    overheadMulti = "1";


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
            else
            {
                result = @"[{""result"":""0"",""msg"":""" + ds.Tables[0].Rows[0]["msg"].ToString() + @"""}]";
            }



            return result;

        }

    }
}