using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.Services;
using System.Web.Script.Services;

namespace empTimeSheet
{
    public partial class fileshare : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        GeneralMethod objgen = new GeneralMethod();
        ClsPayroll objpayroll = new ClsPayroll();
        DataSet ds = new DataSet();
        DataSet ds2 = new DataSet();
        
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                if (!objda.checkUserInroles("25"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
                fillgrid();

            }
        }

        public void fillgrid()
        {
            objuser.fname =txtname.Text;
            objuser.action = "select";
            objuser.companyid = Session["companyid"].ToString();
            objuser.id = "";
            objda.status = "active";
            ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0)
            {
               // nodata.Visible = false;
                dgnews.Visible = true;
                dgnews.DataSource = ds;
                dgnews.DataBind();




            }
            else
            {
                dgnews.Visible = false;
              //  nodata.Visible = true;
            }
        
        }

        protected void dgnews_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {

                DropDownList ddl = (DropDownList)e.Row.FindControl("ddlopen");
                if (DataBinder.Eval(e.Row.DataItem, "isfileshare").ToString() == "On")
                {
                    ddl.SelectedIndex = 0;
                }
                else
                {
                    ddl.SelectedIndex = 1;
                
                }

              //  e.Row.Cells[0].Attributes.Add("onclick", Page.ClientScript.GetPostBackClientHyperlink(dgnews, "RowCommand$" + DataBinder.Eval(e.Row.DataItem, "nid").ToString()));

               // e.Row.Attributes["onmouseover"] = "this.style.cursor='pointer'";
            }
        }


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string saveempFileSize(string nid, string grade)
        {

            ClsUser objts = new ClsUser();
            string msg = "";
            msg = "success";
            objts.action = "savefilesize";
            objts.id = nid;

            objts.activestatus = grade;

            try
            {
                objts.ManageEmployee();
                return msg;
            }
            catch (Exception ex)
            {
                msg = ex.Message;
                return msg;
            }

        }



        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string saveempFileShare(string nid, string grade)
        {
          
            ClsUser objts = new ClsUser();
            string msg = "";
            msg = "success";
            objts.action = "savefileshare";
            objts.id = nid;

            objts.activestatus = grade;
           
            try
            {
                objts.ManageEmployee();
                return msg;
            }
            catch (Exception ex)
            {
                msg = ex.Message;
                return msg;
            }

        }


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string saveempFileLink(string nid)
        {

            ClsUser objts = new ClsUser();
            DataSet ds=new DataSet();
            string msg = "";
            msg = "failed";
            objts.action = "setfilesharelink";
            objts.id = nid;

         

            try
            {
                ds=objts.ManageEmployee();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    msg = ds.Tables[0].Rows[0]["filesharelink"].ToString();
                }
                return msg;
            }
            catch (Exception ex)
            {
                msg = ex.Message;
                return msg;
            }

        }

        protected void btnsearch_Click(object sender, EventArgs e)
        {
            fillgrid();
        }

    }
}