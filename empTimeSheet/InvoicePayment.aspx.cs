using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace empTimeSheet
{
    public partial class InvoicePayment : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();
        ClsAdmin objadmin = new ClsAdmin();
        excelexport objexcel = new excelexport();
        DataSet dsexcel = new DataSet();
        public string strcurrency = "$";
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {               
                txtdate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");
                //Role 38 indicates 'Receive Payment'
                if (!objda.checkUserInroles("38"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
                fillclient();
                fillproject();
                fillcurrency();
            }
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
        /// <summary>
        /// Fill Projects drop down for seraching
        /// </summary>
        protected void fillproject()
        {
            dropproject.Items.Clear();
            objts.name = "";
            objts.action = "selectbyclient";
            objts.clientid = dropclient.Text;
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

            ListItem li = new ListItem("--Select Projects--", "");
            dropproject.Items.Insert(0, li);

        }
        protected void ddlclient_SelectedIndexChanged(object sender, EventArgs e)
        {
            //fillpopproject();
            ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);
        }

        protected void dropclient_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            fillproject();
          
            updatePanelSearch.Update();
        }

        /// <summary>
        /// Fill clients drop down for searching
        /// </summary>
        protected void fillclient()
        {
            objuser.clientname = "";
            objuser.action = "select";
            objuser.companyid = Session["companyid"].ToString();
            objuser.managerid = "";
            objuser.id = "";
            ds = objuser.client();
            if (ds.Tables[0].Rows.Count > 0)
            {
                dropclient.DataSource = ds;
                dropclient.DataTextField = "clientcodewithname";
                dropclient.DataValueField = "nid";
                dropclient.DataBind();
                ListItem li = new ListItem("--Select Clients--", "");
                dropclient.Items.Insert(0, li);
            }

        }

        protected void btnsearch_Click(object sender, EventArgs e)
        {
            searchdata();
          

            fillgrid();
        }
        protected void searchdata()
        {
            hidclientid.Value = dropclient.Text;
            hidprojectid.Value = dropproject.Text;

            ddlpaymentmethod.SelectedIndex = 0;
            txtamount.Text = "0.00";
            chkapplyretainer.Checked = false;
            txtcheckno.Text = "";
            fillgrid();
        }
        protected void btnrefresh_Click(object sender, EventArgs e)
        {
            fillgrid();
        }
        
        protected void fillretainer()
        {
            objts.action = "getclientretainer";
            objts.clientid = hidclientid.Value;
            ds = objts.GetInvoice();
            if(ds.Tables[0].Rows.Count>0)
            {
                txtClientRetainer.Text = Convert.ToDecimal(ds.Tables[0].Rows[0]["clientretaineramount"]).ToString("0.00");
            }
        }
        protected void fillgrid()
        {
            fillretainer();

            Session["TaskTable"] = null;

            objts.action = "selectdueinvoices";
            objts.companyId = Session["companyid"].ToString();
            objts.clientid = dropclient.Text;
            objts.projectid = dropproject.Text;
            hidclientid.Value = dropclient.Text;
            hidprojectid.Value = dropproject.Text;
            objts.invoiceno = "";
            objts.nid = "";
            //Statuus value can be 'Paid/Due'
            objts.Status = "due";
            objts.type = "generated";
            ds = objts.GetInvoice();
            divpayment.Visible = true;
            if (ds.Tables[0].Rows.Count > 0)
            {
                Session["TaskTable"] = ds.Tables[0];                
                dgnews.DataSource = ds;
                dgnews.DataBind();
               
                //txtamount.Enabled = true;
                //txtcheckno.Enabled = true;
                //txtdate.Enabled = true;
                //ddlpaymentmethod.Enabled = true;
               // lnkpayment.Visible = true;
                divnodata.Visible = false;
            }
            else
            {
                //txtamount.Enabled = false;
                //txtcheckno.Enabled = false;
                //txtdate.Enabled = false;
                //ddlpaymentmethod.Enabled = false;
                dgnews.DataSource = null;
                dgnews.DataBind();          
                Session["TaskTable"] = null;
                //lnkpayment.Visible = false;
                divnodata.Visible = true;
                //divpayment.Visible = false;
            }
            //updatePanelData.Update();
            dsexcel = ds;
        }

        protected void btnsave_Click(object sender, EventArgs e)
        {

            if (txtdate.Text != "" && txtamount.Text != "")
            {
                decimal totalamount = Convert.ToDecimal(txtamount.Text);

                objts.date = txtdate.Text;
                objts.paymentmode = ddlpaymentmethod.Text;
                objts.checkno = txtcheckno.Text;
                objts.totalamount = txtamount.Text;
                objts.clientid = hidclientid.Value;
                objts.projectid = hidprojectid.Value;
                objts.type = "Payment";
                objts.remark = "Payment Received";
                string invoiceid = "";
                string amountapplied = "";
                for (int i = 0; i < dgnews.Rows.Count; i++)
                {
                    CheckBox chkapply = (CheckBox)dgnews.Rows[i].FindControl("chkapply");
                    HiddenField hidinvoiceid = (HiddenField)dgnews.Rows[i].FindControl("hidinvoiceid");
                    TextBox txtamtapplied = (TextBox)dgnews.Rows[i].FindControl("txtamtapplied");
                    if (chkapply.Checked == true)
                    {
                        invoiceid = invoiceid + hidinvoiceid.Value + "#";
                        amountapplied = amountapplied + txtamtapplied.Text + "#";
                    }
                }
                objts.invoiceno = invoiceid;
                objts.amount = amountapplied;
               if(hidretainageapplied.Value!="")
               {
                   objts.retainage = hidretainageapplied.Value;
               }
               else
               {
                   objts.retainage = "0.00";
               }
                objts.CreatedBy = Session["userid"].ToString();
                objts.companyId = Session["companyid"].ToString();
                objts.nid = "";
                objts.action = "insert";
                ds = objts.insertinvoicepayment();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    GeneralMethod.alert(this.Page, "Payment information saved successfully");
                    blank();
                }
                else
                {
                    GeneralMethod.alert(this.Page, "Information not saved, please try again later.");
                }
            }
            else
            {
                if (txtamount.Text == "")
                {
                    RequiredFieldValidator1.Visible = true;
                    RequiredFieldValidator1.ErrorMessage = "*";
                    RequiredFieldValidator1.IsValid = false;
                }
                else
                {
                    if (Convert.ToDecimal(txtamount.Text) <= 0)
                    {
                        CustomValidator1.Visible = true;
                        CustomValidator1.IsValid = false;
                    }
                }
                if (txtdate.Text == "")
                {
                    RequiredFieldValidator4.Visible = true;
                    RequiredFieldValidator4.ErrorMessage = "*";
                    RequiredFieldValidator4.IsValid = false;
                }
                
                GeneralMethod.alert(this.Page, "Please fill all the required fileds");
            }
        }

        protected void blank()
        {
            txtdate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");
            ddlpaymentmethod.SelectedIndex = 0;
            txtamount.Text = "0.00";
            txtcheckno.Text = "";
            chkapplyretainer.Checked = false;
            fillgrid();
        }
    }
}