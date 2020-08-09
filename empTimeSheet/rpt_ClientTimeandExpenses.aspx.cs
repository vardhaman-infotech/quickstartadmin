using Microsoft.Reporting.WebForms;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace empTimeSheet
{
    public partial class rpt_ClientTimeandExpenses : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();
        DataSet dsexcel = new DataSet();
        excelexport objexcel = new excelexport();
        protected void Page_Load(object sender, EventArgs e)
        {

            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                //txtfromdate.Text = System.DateTime.Now.AddDays(-2).ToString("MM/dd/yyyy");
                //txttodate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");

                System.Data.DataSet ds = new System.Data.DataSet();
                objda.id = Session["userid"].ToString();
                ds = objda.getUserInRoles();

                if (!objda.validatedRoles("7", ds) && !objda.validatedRoles("8", ds) && !objda.validatedRoles("15", ds))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
                if (objda.validatedRoles("7", ds))
                {
                    ViewState["add"] = "1";
                }
                else
                {
                    // liaddnew.Visible = false;
                    ViewState["add"] = null;
                }
                if (objda.validatedRoles("15", ds))
                {
                    ViewState["isadmin"] = "1";
                }
                else
                {
                    ViewState["isadmin"] = null;
                }

                fillclient();
                fillemployee();
                fillproject();
                //fillexpenses();
            }
        }

        protected void fillclient()
        {
            objuser.clientname = "";
            objuser.action = "select1";
            objuser.companyid = Session["companyid"].ToString();
            objuser.id = "";
            ds = objuser.client();
            if (ds.Tables[0].Rows.Count > 0)
            {
                dropclient.DataSource = ds;
                dropclient.DataTextField = "clientname";
                dropclient.DataValueField = "nid";
                dropclient.DataBind();
                //ListItem li = new ListItem("--All Clients--", "");
                //dropclient.Items.Insert(0, li);
            }


        }

        public void fillemployee()
        {
            objuser.fname = "";
            objuser.action = "select";
            objuser.companyid = Session["companyid"].ToString();
            objuser.id = "";
            ds = objuser.ManageEmployee();

            objuser.action = "selectactive";
            objuser.id = "";
            ds = objuser.ManageEmployee();

            dropEmployee.DataSource = ds;
            dropEmployee.DataTextField = "username";
            dropEmployee.DataValueField = "nid";

            dropEmployee.DataBind();
        }

        protected void fillproject()
        {
            dropproject.Items.Clear();
            objts.name = "";
            objts.action = "selectbyclient";
            objts.clientid = "";
            objts.companyId = Session["companyid"].ToString();
            objts.nid = "";
            ds = objts.ManageProject();
            if (ds.Tables[0].Rows.Count > 0)
            {
                dropproject.DataSource = ds;
                dropproject.DataTextField = "projectnamewithcode";
                dropproject.DataValueField = "nid";
                dropproject.DataBind();
            }
        }

        //protected void fillexpenses()
        //{
        //    dropExpense.Items.Clear();
        //    objts.name = "";
        //    objts.action = "select";
        //    objts.companyId = Session["companyid"].ToString();
        //    objts.nid = "";
        //    objts.deptID = "";
        //    objts.type = "Expense";
        //    ds = objts.ManageTasks();

        //    if (ds.Tables[0].Rows.Count > 0)
        //    {
        //        dropExpense.DataSource = ds;
        //        dropExpense.DataTextField = "taskcodename";
        //        dropExpense.DataValueField = "nid";
        //        dropExpense.DataBind();
        //    }
        //}

        private string getchkval(CheckBoxList chk)
        {
            StringBuilder sb = new StringBuilder();
            for (var i = 0; i < chk.Items.Count; i++)
            {
                if (chk.Items[i].Selected)
                {
                    sb.Append(chk.Items[i].Value + ",");
                }
            }

            return sb.ToString();
        }



        protected void fillgrid()
        {
            f_ReportLoad();
        }


        private void f_ReportLoad()
        {
            try
            {
                string p = Server.MapPath("rdlcreport");
                string strccontact = "";
                objts.clientid = "";
                objts.companyId = "";
                objts.empid = "";
                objts.action = "ClientMaster";
                ds = objts.Clientrdlcreport();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    divnodata.Visible = false;

                    divreport.Visible = true;

                    ReportViewer1.LocalReport.ReportPath = p + "\\client\\rpt_ClientMasterFile.rdlc";
                    ReportParameter[] param = new ReportParameter[3];

                    param[0] = new ReportParameter("companyname", Session["companyname"].ToString(), true);
                    param[1] = new ReportParameter("companyaddress", Session["companyaddress"].ToString(), true);

                    if (ds.Tables[1].Rows.Count > 0)
                    {
                        if (ds.Tables[1].Rows[0]["phone"].ToString() != "")
                            strccontact += "Tel: " + ds.Tables[1].Rows[0]["phone"].ToString() + " ";
                        if (ds.Tables[1].Rows[0]["fax"].ToString() != "")
                            strccontact += "Fax: " + ds.Tables[1].Rows[0]["fax"].ToString() + " ";
                        if (ds.Tables[1].Rows[0]["email"].ToString() != "")
                            strccontact += "<br/>" + ds.Tables[1].Rows[0]["email"].ToString() + " ";
                        if (ds.Tables[1].Rows[0]["website"].ToString() != "")
                            strccontact += "<br/>" + ds.Tables[1].Rows[0]["website"].ToString() + " ";

                    }
                    //string strvalue = "";

                    //strvalue = "taskCode,taskname,description,costrate,isbillable,isReimb,MuRate,tax,";

                    param[2] = new ReportParameter("companyphone", strccontact, true);
                    //param[3] = new ReportParameter("SelectColumn", strvalue, true);


                    ReportDataSource rds1 = new ReportDataSource("DataSet1", ds.Tables[0]);


                    this.ReportViewer1.LocalReport.DataSources.Clear();

                    this.ReportViewer1.LocalReport.EnableExternalImages = true;

                    this.ReportViewer1.LocalReport.DataSources.Add(rds1);
                    this.ReportViewer1.LocalReport.SetParameters(param);


                    this.ReportViewer1.LocalReport.Refresh();



                    ReportViewer1.LocalReport.DisplayName = "Client Master File";
                    divreport.Visible = true;
                    divnodata.Visible = false;
                }
                else
                {
                    divreport.Visible = false;
                    divnodata.Visible = true;
                }
            }
            catch (Exception ex)
            {
            }

        }
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            fillgrid();
        }
    }
}