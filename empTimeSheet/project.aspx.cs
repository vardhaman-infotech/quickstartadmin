using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using System.IO;



namespace empTimeSheet
{
    public partial class project : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds1 = new DataSet();
        DataSet ds = new DataSet();
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                if (!objda.checkUserInroles("3"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
                filltaxmaster();
                fillgrid();
                fillcurrency();
                fillclients();
                fillpaymentterm();
                fillmanager();
                fillgroups();
            }
        }

       
        public void fillgroups()
        {

            objuser.action = "select";


            objuser.id = "";
            objuser.createdby = "";
            objuser.clientname = "";
            objuser.name = "";
            objuser.companyid = Session["companyid"].ToString();
            ds = objuser.ManageProjectGroup();
            if (ds.Tables[0].Rows.Count > 0)
            {
                chkClientGroup.DataSource = ds;
                chkClientGroup.DataTextField = "grouptitle";
                chkClientGroup.DataValueField = "nid";
                chkClientGroup.DataBind();

            }
        }

        protected void filltaxmaster()
        {
            objts.action = "select";
            objts.nid = "";
            objts.companyId = Session["companyid"].ToString();
            ds = objts.ManageTax();
            if (ds.Tables[0].Rows.Count > 0)
            {
                droptax.DataTextField = "namewithtax";
                droptax.DataValueField = "nid";
                droptax.DataSource = ds;
                droptax.DataBind();

            }
            ListItem li = new ListItem("--Select Tax--", "");
            droptax.Items.Insert(0, li);
            droptax.SelectedIndex = 0;
        }
        protected void btnexportcsv_Click(object sender, EventArgs e)
        {
            DataTable dt = new DataTable();
            StringBuilder sb = new StringBuilder();
            bindheader();
            fillgrid();
            if (ds.Tables[0].Rows.Count > 0)
            {
                sb.Append("<table cellpadding='4' cellspacing='0' style='font-family:Calibri;font-size:12px;' border='0'>" + bindheader() + "<tr><th style='text-align:center;'>S.No.</th><th  style='text-align:left;'>Project Code</th><th style='text-align:left;'>Project Name</th><th style='text-align:left;'>Client Code</th><th style='text-align:left;'>Client Name</th><th>Manager</th><th>Contract Type</th><th>Project Status</th> <th>Contract Amount</th><th>Service Amount</th><th>Exp Amount</th><th>Complete Percent</th><th>Creation Date</th><th>Start Date</th><th>Due Date</th></tr>");

                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    if (ds.Tables[0].Rows[i]["projectstatus"].ToString().ToLower() == "block")
                    {
                        sb.Append("<tr style= 'color:red;'><td style='text-align:center;'>" + (i + 1).ToString() + "</td><td>" + ds.Tables[0].Rows[i]["projectCode"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["projectname"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["clientcode"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["clientname"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["empname"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["contractType"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["projectStatus"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["contractAmt"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["serviceAmt"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["expAmt"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["completePercent"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["creationDate"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["startDate"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["dueDate"].ToString() + "</td></tr>");
                    }
                    else
                    {
                        sb.Append("<tr><td style='text-align:center;'>" + (i + 1).ToString() + "</td><td>" + ds.Tables[0].Rows[i]["projectCode"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["projectname"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["clientcode"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["clientname"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["empname"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["contractType"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["projectStatus"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["contractAmt"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["serviceAmt"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["expAmt"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["completePercent"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["creationDate"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["startDate"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["dueDate"].ToString() + "</td></tr>");
                    }

                }
                sb.Append("</table>");

            }
            //using (XLWorkbook wb = new XLWorkbook())
            //{
            //    wb.Worksheets.Add(ds.Tables[0]);

            //    Response.Clear();
            //    Response.Buffer = true;
            //    Response.Charset = "";
            //    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            //    Response.AddHeader("content-disposition", "attachment;filename=GridView.xlsx");
            //    using (MemoryStream MyMemoryStream = new MemoryStream())
            //    {
            //        wb.SaveAs(MyMemoryStream);
            //        MyMemoryStream.WriteTo(Response.OutputStream);
            //        Response.Flush();
            //        Response.End();
            //    }
            //}
            //Response.AppendHeader("content-disposition", "attachment;filename=ExportedHtml.xls");
            //Response.Charset = "";
            //Response.Cache.SetCacheability(HttpCacheability.NoCache);
            //Response.ContentType = "application/vnd.ms-excel";
            //this.EnableViewState = false;
            //Response.Write(sb.ToString());
            //Response.End();
            excelexport objexcel = new excelexport();
            objexcel.downloadFile(sb.ToString(), "Projects.xls");

        }
        protected string bindheader()
        {
            string str = "";
            string Companyname = Session["companyname"].ToString();

            str += "<tr><td colspan='15' style='background-color:blue;color:#ffffff;font-size:16px;' align='center'>" + Companyname + "</td></tr>";
            str += "<tr><td colspan='15' style='background-color:blue;color:#ffffff;font-size:14px;' align='center'>Project List</td></tr>";

            return str;

        }
        /// <summary>
        /// Fill Employee to select as a manager
        /// </summary>
        protected void fillmanager()
        {
            objuser.action = "selectactive";
            objuser.companyid = Session["companyid"].ToString();
            objuser.id = "";
            ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0)
            {
                dropmanager.DataSource = ds;
                dropmanager.DataTextField = "username";
                dropmanager.DataValueField = "nid";
                dropmanager.DataBind();
                ListItem li = new ListItem("--Select Manager--", "");
                dropmanager.Items.Insert(0, li);
                dropmanager.SelectedIndex = 0;
            }
        }

        /// <summary>
        /// Fill client's drop down
        /// </summary>
        protected void fillclients()
        {
            objuser.clientname = "";
            objuser.action = "select";
            objuser.companyid = Session["companyid"].ToString();
            objuser.id = "";
            ds = objuser.client();
            if (ds.Tables[0].Rows.Count > 0)
            {
                dropclient.DataTextField = "clientname";
                dropclient.DataValueField = "nid";
                dropclient.DataSource = ds;
                dropclient.DataBind();

                dropclient1.DataTextField = "clientname";
                dropclient1.DataValueField = "nid";
                dropclient1.DataSource = ds;
                dropclient1.DataBind();
            }
            ListItem li = new ListItem("--Select Client--", "");
            dropclient.Items.Insert(0, li);
            dropclient.SelectedIndex = 0;

            dropclient1.Items.Insert(0, new ListItem("--All Clients--", ""));
            dropclient1.SelectedIndex = 0;
        }
        /// <summary>
        /// Fill currency
        /// </summary>
        public void fillcurrency()
        {
            objda.action = "getcurrency";
            ds = objda.currency();
            dropcurrency.DataSource = ds;
            dropcurrency.DataTextField = "currencyName";
            dropcurrency.DataValueField = "nid";
            dropcurrency.DataBind();
        }

        public void fillpaymentterm()
        {
            objda.action = "select";
            objda.name = "";
            objda.id = "";
            objda.company = Session["companyid"].ToString();
            ds = objda.ManagePaymentTerm();
            droppaymentterm.DataSource = ds;
            droppaymentterm.DataTextField = "payTerm";
            droppaymentterm.DataValueField = "nid";
            droppaymentterm.DataBind();

            ListItem li = new ListItem("--Select Payment Term--", "");
            droppaymentterm.Items.Insert(0, li);
            droppaymentterm.SelectedIndex = 0;


            

        }
        protected void liaddnew_Click(object sender, EventArgs e)
        {
            blank();
            ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);
        }


        public void blank()
        {
            txtcode.Text = string.Empty;
            txtcode.Enabled = true;

            txtcontractamt.Text = string.Empty;
            txtenddate.Text = string.Empty;
            txtexpamt.Text = string.Empty;
            txtinvoicenumber.Text = string.Empty;
            txtname.Text = string.Empty;
            txtpercent.Text = string.Empty;
            txtBudgetedHours.Text = string.Empty;
            txtprefix.Text = string.Empty;
            txtserviceamt.Text = string.Empty;
            txtstartdate.Text = string.Empty;
            txtSuffix.Text = string.Empty;
            hidid.Value = "";
            dropactive.SelectedIndex = 0;
            dropclient.SelectedIndex = 0;
            dropcontracttype.SelectedIndex = 0;
            dropcurrency.SelectedIndex = 0;
            dropmanager.SelectedIndex = 0;
            dropfrequency.SelectedIndex = 0;
            txtPO.Text = string.Empty;
            chkcustominvoice.Checked = false;
            txtinvoicenumber.Enabled = false;
            txtprefix.Enabled = false;
            txtSuffix.Enabled = false;
            txtremark.Text = "";
            btnsubmit.Text = "Save";
            btndelete.Visible = false;
            droptax.SelectedIndex = 0;
            txtexpensetax.Text = "0.00";

            dropTbillable.Checked = false;
            dropTmemoreq.Checked = false;
            dropEbillable.Checked = false;
            dropEmonoreq.Checked = false;
            chkTExpenseDesc.Checked = false;
            chkTTaskDesc.Checked = false;

        

        }
        protected void btnsubmit_Click(object sender, EventArgs e)
        {
            objts.nid = hidid.Value;
            objts.companyId = Session["companyid"].ToString();
            objts.action = "checkexist";
            objts.Code = txtcode.Text;
            ds = objts.ManageProject();
            if (ds.Tables[0].Rows.Count > 0)
            {

                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "<script type='text/javascript'>alert('Project ID already exists!');opendiv();fixheader();</script>", false);
                return;
            }

            objts.action = "insert";
            objts.nid = hidid.Value;

            objts.name = txtname.Text;
            objts.companyId = Session["companyid"].ToString();
            objts.clientid = dropclient.Text;
            objts.managerId = dropmanager.Text;
            objts.contractType = dropcontracttype.Text;
            objts.Status = dropactive.Text;
            objts.amount = droppaymentterm.Text;
            if (txtcontractamt.Text != "")
                objts.contractAmt = txtcontractamt.Text;
            else
                objts.contractAmt = "0.00";

            if (txtexpamt.Text != "")
                objts.expAmt = txtexpamt.Text;
            else
                objts.expAmt = "0.00";
            if (txtserviceamt.Text != "")
                objts.serviceAmt = txtserviceamt.Text;
            else
                objts.serviceAmt = "0.00";

            objts.startdate = txtstartdate.Text;
            objts.duedate = txtenddate.Text;
            if (txtpercent.Text != "")
                objts.completePercent = txtpercent.Text;
            else
                objts.completePercent = "0.00";

            if (txtpercent.Text != "")
                objts.budgetedHours = txtBudgetedHours.Text;
            else
                objts.budgetedHours = "0.00";
    
            objts.currencyID = dropcurrency.Text;
            if (chkcustominvoice.Checked == true)
            {
                objts.iscustominvoice = "Yes";
            }
            else
            {
                objts.iscustominvoice = "No";

            }

            objts.grt = "0.00";

            objts.tax = droptax.Text;

            objts.invoicePrefix = txtprefix.Text;
            objts.invoiceSuffix = txtSuffix.Text;
            if (txtinvoicenumber.Text != "")
                objts.invoicesno = txtinvoicenumber.Text;
            else
                objts.invoicesno = "0";
            objts.remark = txtremark.Text;
            objts.frequency = dropfrequency.Text;
            objts.po = txtPO.Text;
            objts.CreatedBy = Session["userid"].ToString();
         
            objts.TBillable = (dropTbillable.Checked) ? "Yes" : "No";
            objts.EBillable = (dropEbillable.Checked) ? "Yes" : "No";

            objts.Tmemorequired = (dropTmemoreq.Checked) ? "Yes" : "No";
            objts.Ememorequired = (dropEmonoreq.Checked) ? "Yes" : "No";

            objts.TReadonly = (chkTTaskDesc.Checked) ? "Yes" : "No";
            objts.EReadOnly = (chkTExpenseDesc.Checked) ? "Yes" : "No";


            if (txtRecurringAmt.Text != "")
                objts.recurAmt = txtRecurringAmt.Text;
            else
                objts.recurAmt = "0.00";

            objts.recurintPeriod = txtIntervalperiod.Text;
            objts.recurrstartdate = txtrecurringStartdate.Text;
            objts.recurrenddate = txtrecurringEnddate.Text;

            ds = objts.ManageProject();

            string strgroup = "";
            for (int i = 0; i < chkClientGroup.Items.Count; i++)
            {
                if (chkClientGroup.Items[i].Selected)
                {
                    strgroup = strgroup + chkClientGroup.Items[i].Value + ",";
                }
            }
            objuser.id = ds.Tables[0].Rows[0]["nid"].ToString();
            objuser.clientname = strgroup;
           // objuser.id = objuser.userid;
            objuser.action = "insertclientingroup";
            ds = objuser.ManageProjectGroup();


            blank();
            fillgrid();
            if (hidid.Value != "")
            {
                GeneralMethod.alert(this.Page, "Information updated Successfully!");
            }
            else
                GeneralMethod.alert(this.Page, "Saved Successfully!");


        }
        /// <summary>
        /// When search any record
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>


        protected void btndelete_Click(object sender, EventArgs e)
        {
            objts.action = "delete";
            objts.nid = hidid.Value;
            ds = objts.ManageProject();
            fillgrid();
            if (ds.Tables[0].Rows[0]["Status"].ToString() == "Delete")
            {
                GeneralMethod.alert(this.Page, "Deleted Successfully!");
            }
            else {
                GeneralMethod.alert(this.Page, "Project is in use. Project cannot delete!");
            }


        }
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            dgnews.PageIndex = 0;
            fillgrid();
        }
        public void fillgrid()
        {
            objts.name = txtsearch.Text;
            objts.action = "select";
            objts.companyId = Session["companyid"].ToString();
            objts.nid = "";
            objts.clientid = dropclient1.Text;
            objts.contractType = dropcontracttype1.Text;
            objts.Status = drostatus.Text;
            ds = objts.ManageProject();

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
                objts.action = "delete";
                objts.nid = e.CommandArgument.ToString();
                ds = objts.ManageProject();
                if (ds.Tables[0].Rows[0]["Status"].ToString() == "Delete")
                {
                    GeneralMethod.alert(this.Page, "Deleted Successfully!");
                }
                else
                {
                    GeneralMethod.alert(this.Page, "Project is in use. Project cannot delete!");
                }
                fillgrid();
               
            }
            if (e.CommandName.ToLower() == "detail")
            {
              

            }
        }

        protected void PaggedGridbtnedit_Click(object sender, EventArgs e)
        {   
            objts.action = "select";
            objts.nid = hidid.Value;
            blank();
            hidid.Value = objts.nid;
            ds = objts.ManageProject();
            if (ds.Tables[0].Rows.Count > 0)
            {
                hidid.Value = ds.Tables[0].Rows[0]["nid"].ToString();
                txtcode.Text = ds.Tables[0].Rows[0]["projectCode"].ToString();
                // txtcode.Enabled = false;

                txtname.Text = ds.Tables[0].Rows[0]["projectname"].ToString();
                dropclient.Text = ds.Tables[0].Rows[0]["clientid"].ToString();
                try
                {
                    dropmanager.Text = ds.Tables[0].Rows[0]["managerId"].ToString();
                }
                catch
                {
                    dropmanager.SelectedIndex = 0;
                }

                dropcontracttype.Text = ds.Tables[0].Rows[0]["contractType"].ToString();
                dropactive.Text = ds.Tables[0].Rows[0]["projectStatus"].ToString();
                txtcontractamt.Text = ds.Tables[0].Rows[0]["contractAmt"].ToString();
                txtexpamt.Text = ds.Tables[0].Rows[0]["expAmt"].ToString();
                txtserviceamt.Text = ds.Tables[0].Rows[0]["serviceAmt"].ToString();
                txtstartdate.Text = ds.Tables[0].Rows[0]["startdate"].ToString();
                txtenddate.Text = ds.Tables[0].Rows[0]["duedate"].ToString();
                droppaymentterm.Text = ds.Tables[0].Rows[0]["payterm"].ToString();
                txtpercent.Text = ds.Tables[0].Rows[0]["completePercent"].ToString();
                txtBudgetedHours.Text = ds.Tables[0].Rows[0]["budgetedHours"].ToString();
                dropcurrency.Text = ds.Tables[0].Rows[0]["currencyID"].ToString();
                if (ds.Tables[0].Rows[0]["iscustominvoice"].ToString() == "Yes")
                {
                    chkcustominvoice.Checked = true;
                    txtprefix.Enabled = true;
                    txtSuffix.Enabled = true;
                    txtinvoicenumber.Enabled = true;
                }
                else
                {
                    chkcustominvoice.Checked = false;
                    txtprefix.Enabled = false;
                    txtSuffix.Enabled = false;
                    txtinvoicenumber.Enabled = false;
                }
                txtprefix.Text = ds.Tables[0].Rows[0]["invoicePrefix"].ToString();
                txtSuffix.Text = ds.Tables[0].Rows[0]["invoiceSuffix"].ToString();
                txtinvoicenumber.Text = ds.Tables[0].Rows[0]["invoicesno"].ToString();
                txtremark.Text = ds.Tables[0].Rows[0]["remark"].ToString();
                txtPO.Text = ds.Tables[0].Rows[0]["PO"].ToString();
                dropfrequency.Text = ds.Tables[0].Rows[0]["frequency"].ToString();

                txtRecurringAmt.Text = ds.Tables[0].Rows[0]["RecurringAmt"].ToString();
                txtIntervalperiod.Text = ds.Tables[0].Rows[0]["IntervalPeriod"].ToString();
                txtrecurringStartdate.Text = ds.Tables[0].Rows[0]["RecurringStartdate"].ToString();
                txtrecurringEnddate.Text = ds.Tables[0].Rows[0]["RecurringEnddate"].ToString();
                //dropTbillable.Text = ds.Tables[0].Rows[0]["TBillable"].ToString();
                //dropTmemoreq.Text = ds.Tables[0].Rows[0]["Tmemorequired"].ToString();
                //dropEbillable.Text = ds.Tables[0].Rows[0]["EBillable"].ToString();
                //dropEmonoreq.Text = ds.Tables[0].Rows[0]["Ememorequired"].ToString();

                dropTbillable.Checked = (ds.Tables[0].Rows[0]["TBillable"].ToString()=="Yes") ? true :false;
                dropTmemoreq.Checked = (ds.Tables[0].Rows[0]["Tmemorequired"].ToString() == "Yes") ? true : false;
                dropEbillable.Checked = (ds.Tables[0].Rows[0]["EBillable"].ToString() == "Yes") ? true : false;
                dropEmonoreq.Checked = (ds.Tables[0].Rows[0]["Ememorequired"].ToString() == "Yes") ? true : false;

                chkTTaskDesc.Checked = (ds.Tables[0].Rows[0]["TDesReadonly"].ToString() == "Yes") ? true : false;
                chkTExpenseDesc.Checked = (ds.Tables[0].Rows[0]["EDesReadOnly"].ToString() == "Yes") ? true : false;  



                // txtexpensetax.Text = ds.Tables[0].Rows[0]["ExpenseTax"].ToString();
                // txtgrt.Text = ds.Tables[0].Rows[0]["GRT"].ToString();
                droptax.Text = ds.Tables[0].Rows[0]["taxid"].ToString();
                btnsubmit.Text = "Update";

                for (int i = 0; i < chkClientGroup.Items.Count; i++)
                {
                    chkClientGroup.Items[i].Selected = false;

                    if (ds.Tables[2].Rows.Count > 0)
                    {
                        for (int j = 0; j < ds.Tables[2].Rows.Count; j++)
                        {
                            if (ds.Tables[2].Rows[j]["nid"].ToString() == chkClientGroup.Items[i].Value)
                            {
                                chkClientGroup.Items[i].Selected = true;
                            }

                        }

                    }
                }



                btndelete.Visible = true;
                upadatepanel1.Update();
                ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);
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

                //if (DataBinder.Eval(e.Row.DataItem, "activestatus") != null && DataBinder.Eval(e.Row.DataItem, "activestatus").ToString().ToLower() != "active")
                //{

                //    e.Row.CssClass = "inactiverecord";
                //}

            }
        }



    }
}