using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.Script.Services;
using Ajax;
using System.Globalization;
using System.IO;

namespace empTimeSheet
{
    public partial class ExpenseLog : System.Web.UI.Page
    {
        public string strproject = "", strtime = "", strsno = ""; public decimal totalhours = 0;
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds1 = new DataSet();
        DataSet ds = new DataSet();
        public string strtask = "";
        DataSet dsexcel = new DataSet();
       
        protected void Page_Load(object sender, EventArgs e)
        {
            Ajax.Utility.RegisterTypeForAjax(typeof(Timesheet));
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {

                //role 9 indicates Approve Task
                if (objda.checkUserInroles("7"))
                {
                    ViewState["add"] = "1";
                }
                else
                {

                    ViewState["add"] = null;

                }
                if (objda.checkUserInroles("25"))
                {
                    ViewState["approvetimesheet"] = "1";
                    btnapprove.Visible = true;
                    btnreject.Visible = true;
                }
                else
                {
                    ViewState["approvetimesheet"] = null;
                    btnapprove.Visible = false;
                    btnreject.Visible = false;

                }
                hidcompanyid.Value = Session["companyid"].ToString();
                hiduserid.Value = Session["userid"].ToString();

                string todaydate = GeneralMethod.getLocalDate();

                txtfrom.Text = System.DateTime.Now.AddDays(-7).ToString("MM/dd/yyyy");
                txtto.Text = System.DateTime.Now.ToString("MM/dd/yyyy");

                hidrowno.Value = "0";
                fillemployee();
                fillproject();
                fillexpenses();
                fillexpenses1();
                hidsno.Value = "1";
                strsno = "1";
                searchdata();
            }
        }
              /// <summary>
        /// Fill Employee to select for those logged in user is a Manager
        /// </summary>
        protected void fillemployee()
        {
           
            if (ViewState["add"] == null && ViewState["approvetimesheet"] == null)
            {
                ListItem li = new ListItem(Session["username"].ToString(), Session["userid"].ToString());
                dropemployee.Items.Insert(0, li);
                dropemployee.SelectedIndex = 0;
            }
            else
            {
               
                    objuser.action = "selectactive";
                    objuser.companyid = Session["companyid"].ToString();
                    objuser.id = "";
                    ds = objuser.ManageEmployee();
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        dropemployee.DataSource = ds;
                        dropemployee.DataTextField = "username";
                        dropemployee.DataValueField = "nid";
                        dropemployee.DataBind();

                    }

                    dropemployee.Text = Session["userid"].ToString();
               
            }
        }

        /// <summary>
        /// When search any record
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            searchdata();
            fillproject();
            fillexpenses();
            ScriptManager.RegisterStartupScript(this, GetType(), "msg", "<script>showdetails();</script>", false);
      
        }
        protected void searchdata()
        {
            hidempid.Value = dropemployee.Text;
            hidempname.Value = dropemployee.SelectedItem.Text;
            hidfromdate.Value = txtfrom.Text;
            hidtodate.Value = txtto.Text;
            fillgrid();
        }
        protected void lnkrefresh_Click(object sender, EventArgs e)
        {
            fillgrid();
        }
           /// <summary>
        /// Bind Past activities
        /// </summary>
        protected void fillgrid()
        {
            // trheader.Visible = true;

            objts.from = hidfromdate.Value;
            objts.to = hidtodate.Value;
            objts.empid = hidempid.Value;
            objts.action = "select";

            if (ViewState["approvetimesheet"] == null  && (ViewState["add"]!=null && ViewState["add"].ToString() == "1"))
            {
                if (hidempid.Value != Session["userid"].ToString())
                {
                    objts.managerId = Session["userid"].ToString();
                    objts.action = "selectbymanagerassignedtasks";
                    divtableaddnew.Visible = false;
                }
                else
                {
                    divtableaddnew.Visible = true;
                }
            }
                        
          
            objts.nid = "";
            ds = objts.ManageExpenseLog();
           
            dgnews.DataSource = ds;
            dgnews.DataBind();
            dsexcel = ds;
            upadatepanel1.Update();
        }
         /// <summary>
        /// Fill project dropdown
        /// </summary>
        protected void fillproject()
        {
            objts.name = "";
            objts.action = "select";
            objts.companyId = Session["companyid"].ToString();
            objts.nid = "";
            ds = objts.ManageProject();
            StringBuilder options = new StringBuilder();
            options.Append("<option selected='selected'  value='' ></option>");
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {

                options.Append("<option value='" + ds.Tables[0].Rows[i]["nid"].ToString() + "' >" + ds.Tables[0].Rows[i]["projectcodename"].ToString() + "</option>");
            }
            ViewState["project"] = ds.Tables[0];
            strproject = options.ToString();


        }
           /// <summary>
        /// Fill project dropdown
        /// </summary>
        protected void fillexpenses()
        {
            objts.name = "";
            objts.action = "select";
            objts.companyId = Session["companyid"].ToString();
            objts.nid = "";

            objts.deptID = "";
            objts.type = "Expense";
            ds = objts.ManageTasks();
            StringBuilder options = new StringBuilder();

            //options.Append("<option value='' >--Add New--</option>");
            options.Append("<option   selected='selected' value='' ></option>");

            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                if (i == 0)
                    options.Append("<option    value='" + ds.Tables[0].Rows[i]["taskvalue"].ToString() + "' >" + ds.Tables[0].Rows[i]["taskcodename"].ToString() + " (" + ds.Tables[0].Rows[i]["description"].ToString() + ")</option>");
                else
                    options.Append("<option    value='" + ds.Tables[0].Rows[i]["taskvalue"].ToString() + "' >" + ds.Tables[0].Rows[i]["taskcodename"].ToString() + " (" + ds.Tables[0].Rows[i]["description"].ToString() + ")</option>");
            }


            strtask = options.ToString();
        }


        protected void fillexpenses1()
        {
            objts.name = "";
            objts.action = "select";
            objts.companyId = Session["companyid"].ToString();
            objts.nid = "";

            objts.deptID = "";
            objts.type = "Expense";
            ds = objts.ManageTasks();
            StringBuilder options = new StringBuilder();
            //options.Append("<option value='' >--Add New--</option>");
            options.Append("<option   selected='selected' value='' ></option>");


            ViewState["task"] = ds.Tables[0];

        }

            /// <summary>
        /// event fires when clicks to Edit/Delete in List
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dgnews_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "upd")
            {
                GridViewRow row = (GridViewRow)((Control)e.CommandSource).NamingContainer;
                int index = row.RowIndex;
                objts.projectid = ((DropDownList)dgnews.Rows[index].FindControl("dropproject")).Text;
                objts.date = ((TextBox)dgnews.Rows[index].FindControl("txtdate")).Text;
                objts.description = ((TextBox)dgnews.Rows[index].FindControl("txtdesc")).Text;
                objts.units = ((TextBox)dgnews.Rows[index].FindControl("txtunits")).Text;
                objts.cost = ((TextBox)dgnews.Rows[index].FindControl("txtcost")).Text;
                objts.MU = ((TextBox)dgnews.Rows[index].FindControl("txtmu")).Text;
                objts.amount = ((TextBox)dgnews.Rows[index].FindControl("txtamount")).Text;
                string[] expensevalue = ((DropDownList)dgnews.Rows[index].FindControl("droptask")).Text.Split('#');
                objts.expenseid = expensevalue[0];
                CheckBox chkbilable = ((CheckBox)dgnews.Rows[index].FindControl("chkbillable"));
                if (chkbilable.Checked == true)
                    objts.isbillable = "1";
                else

                    objts.isbillable = "0";

                CheckBox chkreimbursable = ((CheckBox)dgnews.Rows[index].FindControl("chkreimbursable"));
                if (chkreimbursable.Checked == true)
                    objts.reimbursable = "1";
                else

                    objts.reimbursable = "0";

                objts.remark = ((HtmlGenericControl)dgnews.Rows[index].FindControl("hidmemoedit")).InnerHtml;
                objts.nid = e.CommandArgument.ToString();
                objts.action = "insert";
                objts.ManageExpenseLog();

            }
            if (e.CommandName == "del")
            {
                objts.action = "delete";
                objts.nid = e.CommandArgument.ToString();
                objts.ManageExpenseLog();
                fillgrid();
            }

            ScriptManager.RegisterStartupScript(this, GetType(), "msg", "<script>showhidepast('none');</script>", false);
        }

        /// <summary>
        /// Aprrove/ Reject the selected rows
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void setstatus(object sender, EventArgs e)
        {
            LinkButton btnstatus = (LinkButton)sender;
            bool ischkd = false;
            string status = btnstatus.Text;
            if (btnstatus.ID.ToString().ToLower() == "btnapprove")
            {
                status = "Approved";
            }
            else
            {
                status = "Rejected";
            }
            for (int i = 0; i < dgnews.Rows.Count; i++)
            {
                //Literal ltrempid = (Literal)dgnews.Rows[i].FindControl("ltrempid");
                CheckBox chkapprove = (CheckBox)dgnews.Rows[i].FindControl("chkapprove");

                HtmlInputHidden hidactiviyid = (HtmlInputHidden)dgnews.Rows[i].FindControl("hidnid1");
                if (chkapprove.Enabled == true && chkapprove.Checked == true)
                {
                    ischkd = true;
                    objts.nid = hidactiviyid.Value;
                    objts.Status = status;
                    objts.action = "setstatus";
                    objts.empid = Session["userid"].ToString();
                    objts.ManageExpenseLog();
                    fillproject();
                    fillexpenses();

                }
            }
            if (!ischkd)
                ScriptManager.RegisterStartupScript(this, GetType(), "show", "<script>alert('Please select a row for approval.');</script>", false);
            else
                fillgrid();

            ScriptManager.RegisterStartupScript(this, GetType(), "msg", "<script>showhidepast('none');</script>", false);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dgnews_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.Header)
            {
                HtmlInputCheckBox chkSelect = (HtmlInputCheckBox)e.Row.FindControl("chkSelect");
                if (ds.Tables[0].Rows.Count > 0)
                {
                    //If user have right to approve timesheet the show Grid header Checkbox
                    if (ViewState["approvetimesheet"] == null)

                        chkSelect.Visible = false;
                    else

                        chkSelect.Visible = true;
                }
                else
                {
                    chkSelect.Visible = false;
                }
            }
            if (e.Row.RowType == DataControlRowType.DataRow || e.Row.RowState != DataControlRowState.Edit || e.Row.RowState != (DataControlRowState.Alternate | DataControlRowState.Edit))
            {

                CheckBox chkbillable = (CheckBox)e.Row.FindControl("chkbillable");
                if (chkbillable != null)
                {
                    if (Convert.ToBoolean(DataBinder.Eval(e.Row.DataItem, "isbillable")) == true)
                    {
                        chkbillable.Checked = true;
                    }

                    else
                    {
                        chkbillable.Checked = false;
                    }
                }
                CheckBox chkreimbursable = (CheckBox)e.Row.FindControl("chkreimbursable");
                if (chkreimbursable != null)
                {
                    if (Convert.ToBoolean(DataBinder.Eval(e.Row.DataItem, "reimbursable")) == true)
                    {
                        chkreimbursable.Checked = true;
                    }

                    else
                    {
                        chkreimbursable.Checked = false;
                    }
                }
            }
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                CheckBox chkapprove = (CheckBox)e.Row.FindControl("chkapprove");
                if (DataBinder.Eval(e.Row.DataItem, "status").ToString().ToLower() == "approved" || DataBinder.Eval(e.Row.DataItem, "status").ToString().ToLower() == "rejected")
                {
                   
                   
                    ((LinkButton)e.Row.FindControl("lbtndelete")).Visible = false;
                    chkapprove.Checked = true;
                    chkapprove.Enabled = false;
                    e.Row.Cells[13].Text = "";
                }
                if (ViewState["approvetimesheet"] == null)
               {
                    chkapprove.Visible = false;
                }
                else
                {
                    chkapprove.Visible = true;
                }

            }
            if (e.Row.RowType == DataControlRowType.DataRow && (e.Row.RowState == DataControlRowState.Edit || e.Row.RowState == (DataControlRowState.Alternate | DataControlRowState.Edit)))
            {
                DropDownList dropproject = (DropDownList)e.Row.FindControl("dropproject");
                DropDownList droptask = (DropDownList)e.Row.FindControl("droptask");
                TextBox txtunits = (TextBox)e.Row.FindControl("txtunits");
                CheckBox chkbillable = (CheckBox)e.Row.FindControl("chkbillableedit");
                CheckBox chkreimbursable = (CheckBox)e.Row.FindControl("chkreimbursableedit");

                if (ViewState["project"] == null)
                    fillproject();
                if (ViewState["task"] != null)
                    fillexpenses1();
                if (ViewState["project"] != null)
                {
                    dropproject.DataSource = (DataTable)ViewState["project"];
                    dropproject.DataTextField = "projectcodename";
                    dropproject.DataValueField = "nid";
                    dropproject.DataBind();
                }
                if (ViewState["task"] != null)
                {
                    droptask.DataSource = (DataTable)ViewState["task"];
                    droptask.DataTextField = "taskcodename";
                    droptask.DataValueField = "taskvalue";
                    droptask.DataBind();
                }
                droptask.Text = DataBinder.Eval(e.Row.DataItem, "expensevalue").ToString();
                dropproject.Text = DataBinder.Eval(e.Row.DataItem, "projectid").ToString();
                if (Convert.ToBoolean(DataBinder.Eval(e.Row.DataItem, "isbillable")) == true)
                {
                    chkbillable.Checked = true;
                }
                else
                {
                    chkbillable.Checked = false;
                }
                if (Convert.ToBoolean(DataBinder.Eval(e.Row.DataItem, "reimbursable")) == true)
                {
                    chkreimbursable.Checked = true;
                }
                else
                {
                    chkreimbursable.Checked = false;
                }

            }
        }

        /// <summary>
        /// Save expense details
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        /// 
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string savetimesheet(string taskdate, string projectid, string taskid, string cost, string description, string units, string amount, string billable,string mu,string reimbursable,string memo, string companyid, string empid)
        {
            string msg = "";
            msg = "success";
            ClsTimeSheet objts = new ClsTimeSheet();
            string[] date1 = taskdate.Split('#');
            string[] project1 = projectid.Split('#');
            string[] task1 = taskid.Split('#');
            string[] cost1 = cost.Split('#');

            string[] des1 = description.Split('#');

            string[] units1 = units.Split('#');

            string[] amount1 = amount.Split('#');

            string[] mu1 = mu.Split('#');
            string[] billable1 = billable.Split('#');
            string[] reimbursable1 = reimbursable.Split('#');
            string[] memo1 = memo.Split('#');
            try
            {
                objts.action = "insert";
                objts.nid = "";
                objts.companyId = companyid;
                for (int i = 1; i < date1.Length; i++)
                {
                    objts.empid = empid;
                    objts.projectid = project1[i];
                    objts.date = date1[i];
                    objts.description = des1[i];
                    objts.units = units1[i];
                    objts.expenseid = task1[i];
                    objts.Status = "Submitted";
                    objts.isbillable = billable1[i];
                    objts.reimbursable = reimbursable1[i];
                    objts.remark = memo1[i];
                    if (cost1[i] != "")
                    {
                        objts.cost = cost1[i];
                    }
                    else
                    {
                        objts.cost = "0";
                    }
                    if (mu1[i] != "")
                    {
                        objts.MU = mu1[i];
                    }
                    else
                    {
                        objts.MU = "0";
                    }
                    if (amount1[i] != "")
                    {
                        objts.amount = amount1[i];
                    }
                    else
                    {
                        objts.amount = "0";
                    }
                    objts.ManageExpenseLog();

                }
               
          


            }
            catch (Exception ex)
            {
                msg = ex.Message;

            }
            return msg;
        }


        protected void save(object sender, EventArgs e)
        {
            //string msg = "";
            //msg = "success";
            //string[] date1 = hidtask_date.Value.Split('#');
            //string[] project1 = hidtask_project.Value.Split('#');
            //string[] task1 = hidtask_task.Value.Split('#');


            //string[] des1 = hidtask_description.Value.Split('#');
            //string[] hours11 = hidtask_units.Value.Split('#');
            //string[] billable1 = hidtask_billable.Value.Split('#');
            //string[] cost1 = hidtask_cost.Value.Split('#');
            //string[] mu1 = hidtask_mu.Value.Split('#');
            //string[] amount1 = hidtask_amount.Value.Split('#');

            //try
            //{
            //    objts.action = "insert";
            //    objts.nid = "";
            //    objts.companyId = Session["companyid"].ToString();
            //    for (int i = 1; i < date1.Length; i++)
            //    {
            //        objts.empid = dropemployee.Text;
            //        objts.projectid = project1[i];
            //        objts.date = date1[i];
            //        objts.description = des1[i];
            //        objts.units = hours11[i];
            //        objts.expenseid = task1[i];
            //        objts.Status = "Submitted";
            //        objts.isbillable = billable1[i];
            //        if (cost1[i] != "")
            //        {
            //            objts.cost = cost1[i];
            //        }
            //        else
            //        {
            //            objts.cost = "0";
            //        }
            //        if (mu1[i] != "")
            //        {
            //            objts.MU = mu1[i];
            //        }
            //        else
            //        {
            //            objts.MU = "0";
            //        }
            //        if (amount1[i] != "")
            //        {
            //            objts.amount = amount1[i];
            //        }
            //        else
            //        {
            //            objts.amount = "0";
            //        }
            //        objts.ManageExpenseLog();

            //    }
            //    blank();
            //    GeneralMethod.alert(this.Page, "Saved Successfully!");
            //    fillgrid();
            //    ScriptManager.RegisterStartupScript(this, GetType(), "msg", "<script>showhidepast('none');</script>", false);


            //}
            //catch (Exception ex)
            //{
            //    msg = ex.Message;

            //}
        }


        /// <summary>
        /// Reset values
        /// </summary>
        protected void blank()
        {
            //hidrowno.Value = "0";
            //strsno = "1";
            //hidtask_billable.Value = "";
            //hidtask_date.Value = "";
            //hidtask_description.Value = "";
            //hidtask_units.Value = "";
            //hidtask_project.Value = "";
            //hidtask_task.Value = "";
            //hidtask_cost.Value = "";
            //hidtask_mu.Value = "";
            //hidtask_amount.Value = "";
            //fillproject();
            //fillexpenses();
        }

        protected void dgnews_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            dgnews.EditIndex = -1;
            fillgrid();
        }
        /// <summary>
        /// When any task selected in grid view
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void droptask_selectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;
            GridViewRow row = (GridViewRow)ddl.NamingContainer;
            int index = row.RowIndex;
            string[] expensevalue = ((DropDownList)dgnews.Rows[index].FindControl("droptask")).Text.Split('#');
            objts.expenseid = expensevalue[0];
            CheckBox chkbilable = ((CheckBox)dgnews.Rows[index].FindControl("chkbillableedit"));
            if (expensevalue[1] == "1")
                chkbilable.Checked = true;
            else
                chkbilable.Checked = false;
            ((TextBox)dgnews.Rows[index].FindControl("txtdesc")).Text = expensevalue[2];

        }

        /// <summary>
        /// Event calll when user save changes (Update) in grid
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dgnews_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {

            GridViewRow row = (GridViewRow)dgnews.Rows[e.RowIndex];

            int index = row.RowIndex;
            objts.projectid = ((DropDownList)dgnews.Rows[index].FindControl("dropproject")).Text;
            objts.date = ((TextBox)dgnews.Rows[index].FindControl("txtdate")).Text;
            objts.units = ((TextBox)dgnews.Rows[index].FindControl("txtunits")).Text;
            objts.description = ((TextBox)dgnews.Rows[index].FindControl("txtdesc")).Text;
            objts.cost = ((TextBox)dgnews.Rows[index].FindControl("txtcost")).Text;
            objts.MU = ((TextBox)dgnews.Rows[index].FindControl("txtmu")).Text;
            objts.amount = ((TextBox)dgnews.Rows[index].FindControl("txtamount")).Text;

            string[] expensevalue = ((DropDownList)dgnews.Rows[index].FindControl("droptask")).Text.Split('#');
            objts.expenseid = expensevalue[0];
            CheckBox chkbilable = ((CheckBox)dgnews.Rows[index].FindControl("chkbillableedit"));
            if (chkbilable.Checked == true)
                objts.isbillable = "1";
            else

                objts.isbillable = "0";

            CheckBox chkreimbursable = ((CheckBox)dgnews.Rows[index].FindControl("chkreimbursableedit"));
            if (chkreimbursable.Checked == true)
                objts.reimbursable = "1";
            else

                objts.reimbursable = "0";

            objts.remark = ((HtmlGenericControl)dgnews.Rows[index].FindControl("hidmemoedit")).InnerHtml;

            objts.nid = ((HtmlInputHidden)row.FindControl("hidnid1")).Value;
            objts.action = "insert";
            objts.ManageExpenseLog();

            dgnews.EditIndex = -1;
            fillgrid();
        }

        /// <summary>
        /// Event calls when user clicks delete inside grid
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dgnews_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            GridViewRow row = (GridViewRow)dgnews.Rows[e.RowIndex];
            objts.action = "delete";
            objts.nid = ((HtmlInputHidden)row.FindControl("hidnid")).Value;
            objts.ManageExpenseLog();
            fillgrid();
        }

        protected void dgnews_RowEditing(object sender, GridViewEditEventArgs e)
        {
            dgnews.EditIndex = e.NewEditIndex;
            fillgrid();
        }

          protected void btnexportcsv_Click(object sender, EventArgs e)
        {
            fillgrid();
            string rpthtml = bindheader("excel");

            for (int i = 0; i < dsexcel.Tables[0].Rows.Count; i++)
            {
                rpthtml = rpthtml + "<tr><td>" + Convert.ToString(i + 1) + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["date"].ToString() +
                    "</td><td>" + dsexcel.Tables[0].Rows[i]["empname"].ToString()
                    + "</td><td>" + dsexcel.Tables[0].Rows[i]["projectname"].ToString() + "</td><td>" + dsexcel.Tables[0].Rows[i]["codename"].ToString() + "</td>"
                    + "<td>" + dsexcel.Tables[0].Rows[i]["description"].ToString() + "</td><td>" + dsexcel.Tables[0].Rows[i]["Units"].ToString() + "</td>"
                    + "<td>" + dsexcel.Tables[0].Rows[i]["cost"].ToString() + "</td><td>" + dsexcel.Tables[0].Rows[i]["mu"].ToString()
                    + "</td><td>" + dsexcel.Tables[0].Rows[i]["amount"].ToString()
                    + "</td><td>" + dsexcel.Tables[0].Rows[i]["isbillable"].ToString()
                    + "</td><td>" + dsexcel.Tables[0].Rows[i]["reimbursable"].ToString()
                    + "</td><td>" + dsexcel.Tables[0].Rows[i]["memo"].ToString()
                    + "</td><td>" + dsexcel.Tables[0].Rows[i]["status"].ToString()
                    + "</td></tr>";
            }

            HtmlGenericControl divgen = new HtmlGenericControl();

            divgen.InnerHtml = rpthtml;

            HttpResponse response = HttpContext.Current.Response;

            // first let's clean up the response.object   
            response.Clear();
            response.Charset = "";

            // set the response mime type for excel   
            response.ContentType = "application/vnd.ms-excel";
            response.AddHeader("Content-Disposition", "attachment;filename=\"HCLLPTimesheet.xls\"");

            // create a string writer   
            using (StringWriter sw = new StringWriter())
            {
                using (HtmlTextWriter htw = new HtmlTextWriter(sw))
                {
                    System.Web.UI.HtmlControls.HtmlGenericControl dv = new System.Web.UI.HtmlControls.HtmlGenericControl();
                    dv.InnerHtml = divgen.InnerHtml.Replace("border='0'", "border='1'");
                    //dv.InnerHtml = dv.InnerHtml.Replace("<tr><td colspan='6'><hr style='width:100%;' /></td>", "");

                    dv.RenderControl(htw);
                    response.Write(sw.ToString());
                    response.End();
                }
            }


        }
        protected string bindheader(string type)
        {
            string str = "";
            string Companyname = Session["companyname"].ToString();
            string companyaddress = Session["companyaddress"].ToString();
            string client = "<b>Client:</b> ", employee = "<b>Employee:</b> ", date = "<b>Date:</b> ";
            if (hidempid.Value == "")
            {
                employee += "All";
            }
            else
            {
                client += hidempname.Value;
            }

            if (hidfromdate.Value != hidtodate.Value)
            {
                date += hidfromdate.Value + " - " + hidtodate.Value;
            }
            else
            {
                date += hidfromdate.Value;
            }
            string headerstr = "<table width='100%'>";
            if (type == "excel")
            {
                headerstr = "<table width='100%' border='1'>";

            }

            str = headerstr +
         @"<tr>
            <td colspan='16' align='left'>
                <h2>
                   " + Companyname + @"
                </h2>
            </td>
        </tr>
<tr>
            <td colspan='16' align='left'>
                <h4>
                   " + companyaddress + @"
                </h4>
            </td>
        </tr>
        <tr>
            <td colspan='16' align='center'>
                <h4>
                    Expense Log
</h4>
            </td>
        </tr>
        <tr>
            <td colspan='16'>
                &nbsp;
            </td>
        </tr>
       
        <tr>
        <td colspan='16'>
        " + date + "<br/>" + employee + "<br/>" +



        @"</td>

        </tr>
       <tr>
        <td colspan='16'>&nbsp;</td></tr>
       </table>

        <table align='left' cellpadding='5' width='100%' cellspacing='0' style='font-family: Calibri;
         font-size: 12px; text-align: left;' border='0'> 
         <tr style='font-weight: bold; background: #395ba4; color: #ffffff;'>
        <td style='width=38px;'width='100px'>S.No</td>
        <td>Date</td>
      
        <td>Employee</td>
        <td>Project</td>
        <td>Expense</td>
        <td>Description</td>
        <td>Hours</td>
        <td>Description</td>
        <td>Units</td>
        <td>Cost</td>
        <td>MU</td>
        <td>Amount</td>
        <td>IsBillable</td>
        <td>Reimbursable</td>
        <td>Memo</td>
        <td>Status</td>                                                             
                                                            
        </tr>";

            return str;

        }


    }
}