using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.UI.HtmlControls;
namespace empTimeSheet
{
    public partial class PayrollPlan : System.Web.UI.Page
    {
        GeneralMethod objgen = new GeneralMethod();
        ClsPayroll objda = new ClsPayroll();
        DataSet ds = new DataSet();
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                fillincome();
                fillDeduction();
            
            
            }
        }
        public void fillincome()
        {
            objda.action = "select";
            objda.calType = "Earnings";
            objda.calGroup = "All";
            objda.companyid = Session["companyid"].ToString();
            ds = objda.salaryStructure();
            if (ds.Tables[0].Rows.Count > 0)
            {

                repearning.DataSource = ds;
                repearning.DataBind();
                repearning.Visible = true;
            }
            else
            {
                repearning.Visible = false;
            
            }
        }

        public void fillDeduction()
        {
            objda.action = "select";
            objda.calType = "Deductions";
            objda.calGroup = "All";
            objda.companyid = Session["companyid"].ToString();
            ds = objda.salaryStructure();
            if (ds.Tables[0].Rows.Count > 0)
            {

                repdeduction.DataSource = ds;
                repdeduction.DataBind();
                repdeduction.Visible = true;
            }
            else
            {
                repdeduction.Visible = false;

            }
        }


        protected void btnsubmit_Click(object sender, EventArgs e)
        {
            if (repearning.Items.Count > 0)
            {
                for (int i = 0; i < repearning.Items.Count; i++)
                {
                    objda.action = "insert";
                    objda.nid = ((HtmlInputHidden)repearning.Items[i].FindControl("hidid")).Value;
                    objda.title = ((TextBox)repearning.Items[i].FindControl("txttitle")).Text;
                    objda.amount = ((TextBox)repearning.Items[i].FindControl("txtamount")).Text;
                    ds = objda.salaryStructure();
                }
            
            }

            if (repdeduction.Items.Count > 0)
            {
                for (int i = 0; i < repdeduction.Items.Count; i++)
                {
                    objda.action = "insert";
                    objda.nid = ((HtmlInputHidden)repdeduction.Items[i].FindControl("hidid")).Value;
                    objda.title = ((TextBox)repdeduction.Items[i].FindControl("txttitle")).Text;
                    objda.amount = ((TextBox)repdeduction.Items[i].FindControl("txtamount")).Text;
                    ds = objda.salaryStructure();
                }

            }

            GeneralMethod.alert(this.Page, "Saved Successfully!");
            

        }
    }
}