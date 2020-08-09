using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.UI.HtmlControls;
using System.IO;
using System.Collections;
using System.Web.Services;
using System.Web.Script.Services;

namespace empTimeSheet
{
    public partial class GenSalary : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        DataSet ds = new DataSet();
        GeneralMethod objgen = new GeneralMethod();
        ClsPayroll objpayroll = new ClsPayroll();
        DataSet dsexcel = new DataSet();     
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                //if (objda.checkUserInroles("18"))
                //{

                //    ViewState["add"] = "1";


                //}               
                hidcompanyid.Value = Session["companyid"].ToString();
                fillyear();
                int month = System.DateTime.Now.Month;
                int year = System.DateTime.Now.Year;
                dropmonth.Text = month.ToString();
                dropyear.Text = year.ToString();
                ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>getstartenddate();</script>", false);

            }

        }
        protected void fillgrid()
        {
            Session["salarytable"] = null;
            dgnews.DataSource = null;
            dgnews.DataBind();
            divnodata.Visible = true;
            btnconfirm.Style.Add("display", "none");
            objpayroll.from = hidstartdate.Value;
            objpayroll.to = hidenddate.Value;
            objpayroll.month = hidmonth.Value;
            objpayroll.year = hidyear.Value;
            objpayroll.companyid = Session["companyid"].ToString();
            objpayroll.action = "getunpaidemployees";
            ds = objpayroll.GenerateSalary();
            if (ds.Tables[0].Rows.Count > 0)
            {
                rptworkingdaysdetail.DataSource = ds.Tables[0];
                rptworkingdaysdetail.DataBind();
            }
            if (ds.Tables[0].Rows.Count > 0)
            {
                dgnews.DataSource = ds.Tables[1];
                dgnews.DataBind();
                Session["salarytable"] = ds.Tables[1];
                divnodata.Visible = false;
                btnconfirm.Style.Add("display", "block");
            }
            
            //fillgrid();
            multiview1.ActiveViewIndex = 0;
            updateworkingdays.Update();
        }
        /// <summary>
        /// Fill year
        /// </summary>
        protected void fillyear()
        {

            var al = new ArrayList();

            for (var i = System.DateTime.Now.Year; i >= 2013; i--)
            {
                al.Add(i);
            }
            dropyear.DataSource = al;
            dropyear.DataBind();
            dropyear.Text = System.DateTime.Now.Year.ToString();
        }

        /// <summary>
        /// When user click on search
        /// Show total days, Total holidays and number of working days within selected criteria
        /// Also show Employees name whose salary has not generated for selected criteria
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            hidmonth.Value = dropmonth.Text;
            hidyear.Value = dropyear.Text;
            hidstartdate.Value = txtfromdate.Text;
            hidenddate.Value = txttodate.Text;
            fillgrid();

        }


        protected void dgnews_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                TextBox txtbonus = (TextBox)e.Row.FindControl("txtbonus");
                TextBox txtstartdate = (TextBox)e.Row.FindControl("txtstartdate");
                TextBox txtenddate = (TextBox)e.Row.FindControl("txtenddate");
                TextBox txtpresents = (TextBox)e.Row.FindControl("txtpresents");

            }

        }
        protected void btnconfirm_Click(object sender, EventArgs e)
        {
            hidSelectedEmp.Value = "";
            hidpayabledays.Value = "";
            DataTable dt = (DataTable)Session["salarytable"];
            for (int i = 0; i < dgnews.Rows.Count; i++)
            {
                HtmlInputHidden hidempid = (HtmlInputHidden)dgnews.Rows[i].FindControl("hidempid");
                for (int j = 0; j < dt.Rows.Count; j++)
                {
                    if (hidempid.Value == dt.Rows[j]["nid"].ToString())
                    {
                        CheckBox chkapprove = (CheckBox)dgnews.Rows[i].FindControl("chkapprove");
                        if (chkapprove.Checked == true)
                        {

                            //TextBox txtpresents = (TextBox)dgnews.Rows[i].FindControl("txtpresents");
                            Label ltremptotalworkingdays = (Label)dgnews.Rows[i].FindControl("ltremptotalworkingdays");
                            HtmlInputHidden hidemptotalworkingdays = (HtmlInputHidden)dgnews.Rows[i].FindControl("hidemptotalworkingdays");
                            HtmlInputHidden hidtotalearnings = (HtmlInputHidden)dgnews.Rows[i].FindControl("hidtotalearnings");
                            HtmlInputHidden hidtotaldeduction = (HtmlInputHidden)dgnews.Rows[i].FindControl("hidtotaldeduction");
                            HtmlInputHidden hidNetPayable = (HtmlInputHidden)dgnews.Rows[i].FindControl("hidNetPayable");
                            HtmlInputHidden hidtotalworkingdays = (HtmlInputHidden)dgnews.Rows[i].FindControl("hidtotalworkingdays");
                            HtmlInputHidden hidtotalpaidleaves = (HtmlInputHidden)dgnews.Rows[i].FindControl("hidtotalpaidleaves");
                            HtmlInputHidden hidtotalunpaidleaves = (HtmlInputHidden)dgnews.Rows[i].FindControl("hidtotalunpaidleaves");
                            HtmlInputHidden hidtotalpayabledays = (HtmlInputHidden)dgnews.Rows[i].FindControl("hidtotalpayabledays");
                            HtmlInputHidden hidtotalctc = (HtmlInputHidden)dgnews.Rows[i].FindControl("hidtotalctc");
                            HtmlInputHidden hidBasicSalary = (HtmlInputHidden)dgnews.Rows[i].FindControl("hidBasicSalary");

                            TextBox txtbonus = (TextBox)dgnews.Rows[i].FindControl("txtbonus");
                            TextBox txtstartdate = (TextBox)dgnews.Rows[i].FindControl("txtstartdate");
                            TextBox txtenddate = (TextBox)dgnews.Rows[i].FindControl("txtenddate");
                            dt.Rows[j]["totalearnings"] = hidtotalearnings.Value;
                            dt.Rows[j]["totaldeduction"] = hidtotaldeduction.Value;
                            dt.Rows[j]["netpayable"] = hidNetPayable.Value;
                            dt.Rows[j]["totalworkingdays"] = hidtotalworkingdays.Value;
                            dt.Rows[j]["totalpaidleaves"] = hidtotalpaidleaves.Value;
                            dt.Rows[j]["totalunpaidleaves"] = hidtotalunpaidleaves.Value;
                            dt.Rows[j]["totalpayabledays"] = hidtotalpayabledays.Value;
                            dt.Rows[j]["emptotalworkingdays"] = hidemptotalworkingdays.Value;
                            dt.Rows[j]["bonus"] = txtbonus.Text;
                            dt.Rows[j]["startdate"] = txtstartdate.Text;
                            dt.Rows[j]["enddate"] = txtenddate.Text;
                            dt.Rows[j]["basicsalary"] = hidBasicSalary.Value;
                            if (hidtotalctc.Value == "")
                            {
                                hidtotalctc.Value = "0";
                            }
                            dt.Rows[j]["totalctc"] = hidtotalctc.Value;


                            //hidSelectedEmp.Value = hidSelectedEmp.Value + hidempid.Value + "#";
                            // hidpayabledays.Value = hidSelectedEmp.Value + txtpresents.Text + "#";
                        }
                        else
                        {
                            dt.Rows.RemoveAt(j);
                        }
                        dt.AcceptChanges();
                    }
                }

            }
            // fillconfirmedgrid();
            dgconfirm.DataSource = dt;
            dgconfirm.DataBind();
            multiview1.ActiveViewIndex = 1;

        }

        //----------------------------------------SALALRY CONFIRMATION----------------------------------------------

        protected void dgconfirm_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Literal ltrbonus = (Literal)e.Row.FindControl("ltrbonus");
                Literal ltrNetPayable = (Literal)e.Row.FindControl("ltrNetPayable");
                Literal ltrtotalamt = (Literal)e.Row.FindControl("ltrtotalamt");
                ltrtotalamt.Text = (Convert.ToDecimal(ltrbonus.Text) + Convert.ToDecimal(ltrNetPayable.Text)).ToString("0.00");


            }
        }

        protected void fillconfirmedgrid()
        {
            objpayroll.Empid = hidSelectedEmp.Value;
            objpayroll.payabledays = hidpayabledays.Value;
            objpayroll.from = txtfromdate.Text;
            objpayroll.to = txttodate.Text;
            objpayroll.month = hidmonth.Value;
            objpayroll.year = hidyear.Value;
            objpayroll.companyid = Session["companyid"].ToString();
            objpayroll.action = "getconfirmationdetails";
            ds = objpayroll.GenerateSalary();
            dgconfirm.DataSource = ds;
            dgconfirm.DataBind();
        }

        protected void btnback_Click(object sender, EventArgs e)
        {
            multiview1.ActiveViewIndex = 0;
        }

        protected void btnsave_Click(object sender, EventArgs e)
        {
            DataTable dt = (DataTable)Session["salarytable"];
            dt.Columns.Add("totalamount", typeof(String));
            dt.Columns.Add("paymentstatus", typeof(String));
            dt.Columns.Add("paymentmode", typeof(String));
            dt.Columns.Add("checkno", typeof(String));
            for (int i = 0; i < dgconfirm.Rows.Count; i++)
            {
                HtmlInputHidden hidempid = (HtmlInputHidden)dgconfirm.Rows[i].FindControl("hidempid");
                for (int j = 0; j < dt.Rows.Count; j++)
                {
                    if (hidempid.Value == dt.Rows[j]["nid"].ToString())
                    {
                        Literal ltrtotalpayabledays = (Literal)dgconfirm.Rows[i].FindControl("ltrtotalpayabledays");
                        DropDownList ddlpaymentstatus = (DropDownList)dgconfirm.Rows[i].FindControl("ddlpaymentstatus");
                        DropDownList ddlpaymentmode = (DropDownList)dgconfirm.Rows[i].FindControl("ddlpaymentmode");
                        TextBox txtcheckno = (TextBox)dgconfirm.Rows[i].FindControl("txtcheckno");
                        Literal ltrtotalamt = (Literal)dgconfirm.Rows[i].FindControl("ltrtotalamt");
                        dt.Rows[j]["totalamount"] = ltrtotalamt.Text;
                        dt.Rows[j]["paymentstatus"] = ddlpaymentstatus.Text;
                        dt.Rows[j]["paymentmode"] = ddlpaymentmode.Text;
                        dt.Rows[j]["checkno"] = txtcheckno.Text;
                    }
                }
            }
            objpayroll.action = "insertsalary";
            objpayroll.nid = "";
            objpayroll.month = hidmonth.Value;
            objpayroll.year = hidyear.Value;
            objpayroll.startdate = hidstartdate.Value;
            objpayroll.enddate = hidenddate.Value;
            objpayroll.Createdby = Session["userid"].ToString();
            objpayroll.companyid = Session["companyid"].ToString();
            
            objpayroll.InsertSalary(dt);

            GeneralMethod.alert(this.Page, "Salary generate successfully");
            blank();

        }
    


        protected void blank()
        {
            Session["salarytable"] = null;
            dgconfirm.DataSource = null;
            dgconfirm.DataBind();
            fillgrid();
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]

        public static string getemployeeworkingdays(string empid, string startdate, string enddate, string month, string year, string companyid)
        {

            ClsPayroll objpayroll = new ClsPayroll();
            DataSet ds = new DataSet();
            string msg = "";
            msg = "fail";
            objpayroll.Empid = empid;
            objpayroll.action = "getemployeedetails";
            objpayroll.from = startdate;
            objpayroll.to = enddate;
            objpayroll.month = month;
            objpayroll.year = year;
            objpayroll.companyid = companyid;

            try
            {
                ds = objpayroll.GenerateSalary();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    msg = ds.Tables[0].Rows[0]["totalearnings"].ToString() + "#" + ds.Tables[0].Rows[0]["totaldeduction"].ToString()
                        + "#" + ds.Tables[0].Rows[0]["netpayable"].ToString() + "#" + ds.Tables[0].Rows[0]["totalpayabledays"].ToString()
                        + "#" + ds.Tables[0].Rows[0]["totalpaidleaves"].ToString() + "#" + ds.Tables[0].Rows[0]["totalunpaidleaves"].ToString()
                        + "#" + ds.Tables[0].Rows[0]["emptotalworkingdays"].ToString() + "#" + ds.Tables[0].Rows[0]["totalworkingdays"].ToString()
                        + "#" + ds.Tables[0].Rows[0]["currentctc"].ToString() + "#" + ds.Tables[0].Rows[0]["basicsalary"].ToString();


                }
                else
                    msg = "";
                return msg;
            }
            catch (Exception ex)
            {

                return msg;
            }

        }
    }
}