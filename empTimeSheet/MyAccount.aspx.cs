using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.IO;
using System.Web.UI.HtmlControls;
using uploadimage;
using System.Web.Services;
using System.Web.Script.Services;
using System.Text.RegularExpressions;
using System.Text;


namespace empTimeSheet
{
    public partial class MyAccount : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds1 = new DataSet();
        DataSet ds = new DataSet();
        imageupload objimg = new imageupload();
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();

            Page.Form.Attributes.Add("enctype", "multipart/form-data");
            if (!IsPostBack)
            {
                ViewState["profileimg"] = "nophoto.png";
                hidid.Value = Session["userid"].ToString();
                //Go to fill user deatils

                binddetail();
                //  fillcountry();
                bind();
                timesheet_hidrowno.Value = "0";
                timesheet_hidsno.Value = "1";
                fillfavReport();
                fillfavSelectedReport();


            }
        }
        public DataTable filterrole(string str, DataSet ds)
        {
            DataView dv = new DataView(ds.Tables[0]);
            dv.RowFilter = str;
            return dv.ToTable();
        }
        public void fillfavReport()
        {

            objuser.userid =Session["userid"].ToString();

            objuser.action = "getallreports";           
            ds = objuser.FavouriteReports();

            StringBuilder sb = new StringBuilder();
            if (ds.Tables[1].Rows.Count > 0)
            {
                int num=0;
                for (int i = 0; i < ds.Tables[1].Rows.Count; i++)
                {
                   // sb.Append("<li><a><i>" + ds.Tables[1].Rows[i]["rGroup"].ToString() + "</i></a>");
                    DataTable dt = new DataTable();
                    dt = filterrole("rGroup='" + ds.Tables[1].Rows[i]["rGroup"].ToString() + "'", ds);
                    if (dt.Rows.Count > 0)
                    {
                       // ListItem li = new ListItem(ds.Tables[1].Rows[i]["rGroup"].ToString(), ds.Tables[1].Rows[i]["rGroup"].ToString());
                       // li.Attributes.Add("style", "color:blue");
                       //// li.Enabled = false;
                       // listcode1.Items.Insert(num, li);
                       // num = num + 1;

                        for (int j = 0; j < dt.Rows.Count; j++)
                        {
                            if (dt.Rows[j]["linkname"].ToString() != "")
                            {

                                string[] linkname = dt.Rows[j]["linkname"].ToString().Split('#');
                                string[] linkpagename = dt.Rows[j]["pages"].ToString().Split('#');
                                for (int k = 0; k < linkname.Length; k++)
                                {
                                    ListItem li = new ListItem(linkname[k], linkpagename[k]);
                                    li.Attributes.Add("data-category", ds.Tables[1].Rows[i]["rGroup"].ToString());
                                    listcode1.Items.Insert(num, li);
                                   num=num+1;
                                }
                            }

                        }
                       
                    }

                   
                }

            }
           
        }

        public void fillfavSelectedReport()
        {

            objuser.userid = Session["userid"].ToString();

            objuser.action = "getfavReport";
            ds = objuser.FavouriteReports();

            StringBuilder sb = new StringBuilder();
            StringBuilder sb1 = new StringBuilder();
            if (ds.Tables[0].Rows.Count > 0)
            {
                for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                {
                    sb.Append(ds.Tables[0].Rows[j]["rname"].ToString() + "#");
                    sb1.Append(ds.Tables[0].Rows[j]["rlink"].ToString() + "#");
                    hidexpense.Value = sb1.ToString();
                    hidexpense1.Value = sb.ToString();
                 // listcode2.Items.Insert(j, new ListItem(ds.Tables[0].Rows[j]["rname"].ToString(), ds.Tables[0].Rows[j]["rlink"].ToString()));

                }

            }

        }
        protected void btnsavefavtask_OnClick(object sender, EventArgs e)
        {
            objuser.userid = Session["userid"].ToString();

            objuser.action = "insert";
            objuser.lname = hidexpense.Value;
            objuser.fname = hidexpense1.Value;
            ds = objuser.FavouriteReports();

            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('Saved successfully!');hidediv();</script>", false);
            updateFavReport.Update();
        
        }
        protected void btnChangeEmail_OnClick(object sender, EventArgs e)
        {
            objuser.id = hidid.Value;

            objuser.action = "editemail";
            objuser.usertype = Session["usertype"].ToString();
            objuser.email = txtemail.Text;
            ds = objuser.ManageEmployee();

            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('Your Email ID changed successfully!');hidediv();</script>", false);
            bindEmail();
        }

        protected void btnChangeCell_OnClick(object sender, EventArgs e)
        {
            objuser.id = hidaddress.Value;
            objuser.action = "editcell";
            objuser.phone = txtCell.Text;
            ds = objuser.address();
            ScriptManager.RegisterStartupScript(updateemail.Page, updateemail.GetType(), "temp", "<script type='text/javascript'>alert('Your Cell changed successfully!');hidediv();</script>", false);
            bindCell();
            updateemail.Update();
        }

        protected void btnChangeSkype_OnClick(object sender, EventArgs e)
        {
            objuser.id = hidaddress.Value;
            objuser.action = "editskype";
            objuser.fax = txtSkype.Text;
            ds = objuser.address();
            ScriptManager.RegisterStartupScript(updateemail.Page, updateemail.GetType(), "temp", "<script type='text/javascript'>alert('Your Skype ID changed successfully!');hidediv();</script>", false);
            bindSkype();
            updateemail.Update();

        }



        protected void bindEmail()
        {
            objuser.id = hidid.Value;
            objuser.usertype = Session["usertype"].ToString();
            objuser.action = "selectfulldetail";
            ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0)
            {

                ltrEmail.Text = ds.Tables[0].Rows[0]["email"].ToString();
            }
            updateemail.Update();
        }

        protected void bindCell()
        {
            objuser.id = hidid.Value;
            objuser.usertype = Session["usertype"].ToString();
            objuser.action = "selectfulldetail";
            ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0)
            {

                ltrPhone.Text = ds.Tables[0].Rows[0]["phone"].ToString();
            }

        }

        protected void bindSkype()
        {
            objuser.id = hidid.Value;
            objuser.usertype = Session["usertype"].ToString();
            objuser.action = "selectfulldetail";
            ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0)
            {
                ltrSkype.Text = ds.Tables[0].Rows[0]["skypeid"].ToString();

            }
        }

        public void bind()
        {
            objuser.id = hidid.Value;
            objuser.usertype = Session["usertype"].ToString();
            objuser.action = "selectfulldetail";
            ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0)
            {
                txtemail.Text = ds.Tables[0].Rows[0]["email"].ToString();
                txtCell.Text = ds.Tables[0].Rows[0]["phone"].ToString();
                txtSkype.Text = ds.Tables[0].Rows[0]["skypeid"].ToString();


            }
        }


        //Change password
        protected void btnChangePass_OnClick(object sender, EventArgs e)
        {
            objuser.id = Session["userid"].ToString();

            objuser.password = txtOldPass.Text.Trim();

            objuser.action = "checkpassword";
            ds = objuser.ManageEmployee();

            if (ds.Tables[0].Rows.Count > 0)
            {
                lblError1.Text = "";
                objuser.password = txtNew.Text.Trim();
                objuser.action = "updatepass";
                ds = objuser.ManageEmployee();

                ScriptManager.RegisterStartupScript(updatechangePass, updatechangePass.GetType(), "temp", "<script type='text/javascript'>alert('Your password changed successfully!');hidediv();</script>", false);
            }
            else
            {
                txtOldPass.Text = "";
                lblError1.Text = "Your password does not match with our record.";
            }
            updatechangePass.Update();
        }

        protected void btnReset_OnClick(object sender, EventArgs e)
        {
            txtNew.Text = "";
            txtOldPass.Text = "";
            txtConfirm.Text = "";
        }


        //Bind User profile details
        protected void binddetail()
        {

            objuser.id = hidid.Value;
            objuser.usertype = Session["usertype"].ToString();
            objuser.action = "selectfulldetail";
            ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0)
            {

                //bind form view to show details
                //fromBasicDetail.DataSource = ds;
                //fromBasicDetail.DataBind();

               
                hidaddress.Value = ds.Tables[0].Rows[0]["addressid"].ToString();
                litusername1.Text = ds.Tables[0].Rows[0]["username"].ToString().Trim() + ", ";
                litdsignation1.Text = ds.Tables[0].Rows[0]["designation"].ToString().Trim();
                litdepartment1.Text = ds.Tables[0].Rows[0]["department"].ToString();
                ltrAddress1.Text = ds.Tables[0].Rows[0]["street"].ToString();
                ltrAddress2.Text = ds.Tables[0].Rows[0]["city"].ToString();
                ltrAddress3.Text = ds.Tables[0].Rows[0]["state"].ToString();
                ltrEmail.Text = ds.Tables[0].Rows[0]["email"].ToString();
                ltrPhone.Text = ds.Tables[0].Rows[0]["phone"].ToString();
                ltrSkype.Text = ds.Tables[0].Rows[0]["skypeid"].ToString();



            }
        }


        //When user clicks to edit profile
        protected void lbtneditprofile_Click(object sender, EventArgs e)
        {
            //Change the form view from "VIEW" to "EDIT", where it will show the textboxes
            //fromBasicDetail.ChangeMode(FormViewMode.Edit);
            binddetail();
        }



       

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string DeleteFav_Task(string id)
        {
            string str = "success";
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();

            objts.nid = id;
            objts.action = "delete";
            ds = objts.manageFavoriteTasks();


            return str;
        }



        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getFavTaskDetail(string id)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();
            objts.nid = id;
            objts.action = "select";
            ds = objts.manageFavoriteTasks();
            string str = "";
            if (ds.Tables[1].Rows.Count > 0)
            {
                str = objgen.serilizeinJson(ds.Tables[1]);


            }
            return str;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getFavTask(string userid)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();
            objts.empid = userid;
            objts.action = "selectHTML";
            ds = objts.manageFavoriteTasks();
            string str = "";
            if (ds.Tables[0].Rows.Count > 0)
            {
                str = ds.Tables[0].Rows[0][0].ToString();


            }
            return str;
        }


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string savetimesheet(string nid, string title, string favnid, string taskdate, string projectid, string taskid, string hours, string description, string billable, string empid, string memo)
        {
            string msg = "";
            msg = "success";
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();
            string[] favnid1 = Regex.Split(favnid, "###");
            string[] date1 = Regex.Split(taskdate, "###");
            string[] project1 = Regex.Split(projectid, "###");
            string[] task1 = Regex.Split(taskid, "###");
            string[] hours11 = Regex.Split(hours, "###");

            string[] des1 = Regex.Split(description, "###");
            string[] billable1 = Regex.Split(billable, "###");
            string[] memo1 = Regex.Split(memo, "###");




            try
            {
                objts.action = "insert";
                objts.nid = nid;
                objts.empid = empid;
                objts.title = title;
                ds = objts.manageFavoriteTasks();

                if (ds.Tables[0].Rows.Count > 0)
                {

                    objts.id = ds.Tables[0].Rows[0]["nid"].ToString();

                    objts.action = "insertdetail";
                    for (int i = 1; i < date1.Length; i++)
                    {


                        objts.nid = favnid1[i];
                        objts.projectid = project1[i];
                        objts.startdate = date1[i];
                        objts.description = des1[i];
                        objts.hours = hours11[i];
                        objts.taskid = task1[i];

                        objts.isbillable = billable1[i];
                        objts.remark = memo1[i];

                        objts.manageFavoriteTasks();

                    }

                }





            }
            catch (Exception ex)
            {
                msg = ex.Message;

            }
            return msg;
        }

    }
}