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
using System.Text.RegularExpressions;
namespace empTimeSheet
{
    public partial class expenseslog : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds1 = new DataSet();
        DataSet ds = new DataSet();
        public string strtask = "";
        DataSet dsexcel = new DataSet();
        public string strproject = "", strtime = "", strsno = ""; public decimal totalhours = 0;
        public double totalhrs = 0;
        protected void Page_Load(object sender, EventArgs e)
        {

            objgen.validatelogin();
            if (!Page.IsPostBack)
            {

                //role 9 indicates Approve Task
                if (objda.checkUserInroles("86"))
                {
                    ViewState["add"] = "1";
                }
                else
                {
                    ViewState["add"] = null;
                    divtableaddnew.Visible = false;
                }
                if (objda.checkUserInroles("87"))
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

                timesheet_hidrowno.Value = "0";
                fillemployee();
                fillproject();
                timesheet_hidsno.Value = "1";
                strsno = "1";
                searchdata();

            }
        }
        protected void fillproject()
        {
            dropproject1.Items.Clear();
            objts.name = "";
            objts.action = "selectbyclient";
            objts.clientid = "";
            objts.companyId = Session["companyid"].ToString();
            objts.nid = "";
            ds = objts.ManageProject();
            if (ds.Tables[0].Rows.Count > 0)
            {
                dropproject1.DataSource = ds;
                dropproject1.DataTextField = "projectcode";
                dropproject1.DataValueField = "nid";
                dropproject1.DataBind();

                dropproject1.Items.Insert(0, new ListItem("--All Projects--", ""));
                dropproject1.SelectedIndex = 0;
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

                //objuser.action = "select";
                //objuser.companyid = Session["companyid"].ToString();
                //objuser.id = Session["userid"].ToString(); ;
                objuser.action = "selectbymanagerwith";
                objuser.companyid = Session["companyid"].ToString();
                objuser.managerid = Session["userid"].ToString();
                objuser.id = "";

                ds = objuser.ManageEmployee();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    //dropemployee.DataSource = ds;
                    //dropemployee.DataTextField = "username";
                    //dropemployee.DataValueField = "nid";
                    //dropemployee.DataBind();
                    objgen.fillActiveInactiveDDL(ds.Tables[0], dropemployee, "username", "nid");

                 //   ListItem li = new ListItem("--All Employees--", "");
                  //  dropemployee.Items.Insert(0, li);
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

            ScriptManager.RegisterStartupScript(this, GetType(), "msg", "<script>showdetails();</script>", false);

        }
        protected void searchdata()
        {
            timesheet_hidrowno.Value = "0";
            timesheet_hidsno.Value = "1";
            strsno = "1";
            timesheet_hidempid.Value = dropemployee.Text;
            hidempname.Value = dropemployee.SelectedItem.Text;
            hidfromdate.Value = txtfrom.Text;
            hidtodate.Value = txtto.Text;
            hidproject.Value = dropproject1.Text;
            fillgrid();
        }
        protected void lnkrefresh_Click(object sender, EventArgs e)
        {
            //timesheet_hidrowno.Value = "0";
            //timesheet_hidsno.Value = "1";
            //strsno = "1";
            //dgnews.EditIndex = -1;
            //fillgrid();
            Response.Redirect("expenseslog.aspx");
        }

        /// <summary>
        /// Bind Past activities
        /// </summary>
        protected void fillgrid()
        {
            // trheader.Visible = true;

            objts.from = hidfromdate.Value;
            objts.to = hidtodate.Value;
            objts.empid = timesheet_hidempid.Value;
            objts.projectid = hidproject.Value;
            objts.action = "select";

            if (ViewState["approvetimesheet"] == null && (ViewState["add"] != null && ViewState["add"].ToString() == "1"))
            {
                if (timesheet_hidempid.Value != Session["userid"].ToString())
                {
                    objts.managerId = Session["userid"].ToString();
                    objts.action = "selectbymanager";
                    dgnews.Columns[3].Visible = true;
                    divtableaddnew.Visible = false;
                }
                else
                {
                    dgnews.Columns[3].Visible = false;
                }
               
               
            }
            else
            {
                if (ViewState["approvetimesheet"] != null && timesheet_hidempid.Value == "")
                {
                    divtableaddnew.Visible = false;
                    dgnews.Columns[3].Visible = true;
                }
                else
                {
                    divtableaddnew.Visible = true;
                    dgnews.Columns[3].Visible = false;
                }
            }

            objts.nid = "";
            ds = objts.ManageExpenseLog();

            dgnews.DataSource = ds;
            dgnews.DataBind();
            timesheet_hidtotalhrs.Value = ds.Tables[0].Compute("Sum(amount)", "").ToString();
            dsexcel = ds;

            //if (ds.Tables[0].Rows.Count > 0)
            //{
            //    btnexportcsv.Visible = true;
            //    btnapprove.Visible = true;
            //    btnreject.Visible = true;
            //}
            //else
            //{

            //    btnexportcsv.Visible = false;
            //    btnapprove.Visible = false;
            //    btnreject.Visible = false;
            //}

            upadatepanel1.Update();
            upadatepanel1.Update();

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
                objts.projectid = ((HtmlInputHidden)dgnews.Rows[index].FindControl("hidproject")).Value;
                objts.date = ((TextBox)dgnews.Rows[index].FindControl("txtdate")).Text;
                objts.description = ((TextBox)dgnews.Rows[index].FindControl("txtdesc")).Text;
                objts.units = ((TextBox)dgnews.Rows[index].FindControl("txtunits")).Text;
                objts.cost = ((TextBox)dgnews.Rows[index].FindControl("txtcost")).Text;
                objts.MU = ((TextBox)dgnews.Rows[index].FindControl("txtmu")).Text;
                objts.amount = ((TextBox)dgnews.Rows[index].FindControl("txtamount")).Text;
                string[] taskvalue = ((HtmlInputHidden)dgnews.Rows[index].FindControl("hidtask")).Value.Split('#');
                objts.expenseid = taskvalue[0];
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
                dgnews.EditIndex = -1;
                fillgrid();
            }

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dgnews_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                if ((e.Row.RowState & DataControlRowState.Edit) > 0)
                {
                    HiddenField hdn = (HiddenField)e.Row.FindControl("hdndesceditable");
                    // bind DropDown manually
                    if (hdn.Value == "Yes")
                    {
                        TextBox txt = (TextBox)e.Row.FindControl("txtdesc");
                        txt.ReadOnly = true;

                    }
                }
            }


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
            CheckBox chkbillable = (CheckBox)e.Row.FindControl("chkbillableedit");


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


            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                ((System.Web.UI.WebControls.ImageButton)(e.Row.Cells[16].Controls[0])).ToolTip = "Click here to edit";

                CheckBox chkapprove = (CheckBox)e.Row.FindControl("chkapprove");
                chkbillable.Enabled = false;
                if (DataBinder.Eval(e.Row.DataItem, "status").ToString().ToLower() == "approved" || DataBinder.Eval(e.Row.DataItem, "status").ToString().ToLower() == "rejected")
                {
                    ((LinkButton)e.Row.FindControl("lbtndelete")).Visible = false;
                    chkapprove.Checked = true;




                    chkapprove.Enabled = false;



                    if (ViewState["approvetimesheet"] == null)
                    {
                        ((System.Web.UI.WebControls.ImageButton)(e.Row.Cells[16].Controls[0])).Visible = false;
                        ((System.Web.UI.WebControls.ImageButton)(e.Row.Cells[16].Controls[0])).ToolTip = "";
                    }


                }
                else
                {
                    chkapprove.Enabled = true;
                }
                if (ViewState["approvetimesheet"] == null)
                {
                    chkapprove.Visible = false;

                    if (DataBinder.Eval(e.Row.DataItem, "empid").ToString() != Session["userid"].ToString())
                    {
                        ((LinkButton)e.Row.FindControl("lbtndelete")).Visible = false;
                        ((System.Web.UI.WebControls.ImageButton)(e.Row.Cells[16].Controls[0])).Visible = false;
                        ((System.Web.UI.WebControls.ImageButton)(e.Row.Cells[16].Controls[0])).ToolTip = "";
                    
                    }



                }
                else
                {
                    chkapprove.Visible = true;
                    ((LinkButton)e.Row.FindControl("lbtndelete")).Visible = true;
                }

                if (Convert.ToBoolean(DataBinder.Eval(e.Row.DataItem, "isbillable")) == false || DataBinder.Eval(e.Row.DataItem, "status").ToString().ToLower() == "rejected")
                {

                    e.Row.Attributes.Add("class", "gridred");
                }


                if (Convert.ToBoolean(DataBinder.Eval(e.Row.DataItem, "isbilled")) == true && DataBinder.Eval(e.Row.DataItem, "status").ToString().ToLower() != "rejected")
                {

                    e.Row.Attributes.Add("class", "gridblue");
                }
                

            }
            if (e.Row.RowType == DataControlRowType.DataRow && (e.Row.RowState == DataControlRowState.Edit || e.Row.RowState == (DataControlRowState.Alternate | DataControlRowState.Edit)))
            {

                chkbillable.Enabled = true;
                TextBox dropproject = (TextBox)e.Row.FindControl("dropproject");
                string txtdate = "#"+((TextBox)e.Row.FindControl("txtdate")).ClientID.ToString();
                TextBox droptask = (TextBox)e.Row.FindControl("droptask");
                HtmlInputHidden hidproject = (HtmlInputHidden)e.Row.FindControl("hidproject");
                HtmlInputHidden hidtask = (HtmlInputHidden)e.Row.FindControl("hidtask");

                HtmlInputHidden hidmemoreq = (HtmlInputHidden)e.Row.FindControl("hiememorequire");


                droptask.Text = DataBinder.Eval(e.Row.DataItem, "taskcodenamesmall").ToString();
                dropproject.Text = DataBinder.Eval(e.Row.DataItem, "projectcode").ToString();
                hidtask.Value = DataBinder.Eval(e.Row.DataItem, "expensevalue").ToString();
                hidproject.Value = DataBinder.Eval(e.Row.DataItem, "projectid").ToString();
                hidmemoreq.Value = DataBinder.Eval(e.Row.DataItem, "Ememorequired").ToString();

                txtmemo.Content = DataBinder.Eval(e.Row.DataItem, "memo").ToString();
                try
                {

                    ((System.Web.UI.WebControls.ImageButton)(e.Row.Cells[16].Controls[0])).ToolTip = "Save Changes";
                    ((System.Web.UI.WebControls.ImageButton)(e.Row.Cells[16].Controls[0])).Attributes.Add("onclick", "return validategrid('" + hidproject .ClientID.ToString()+ "');");
                    ((System.Web.UI.WebControls.ImageButton)(e.Row.Cells[16].Controls[2])).ToolTip = "Cancel";
                }
                catch (Exception ex)
                {
                }


                ScriptManager.RegisterStartupScript(this, GetType(), "msg", "<script>bindprojectautocompleter('" + dropproject.ClientID + "', '" + hidproject.ClientID + "');bindtaskautocompleter('" + droptask.ClientID + "', '" + hidtask.ClientID + "'); $('" + txtdate + "').mask('99/99/9999');  $('"+txtdate+"').datepicker();</script>", false);


            }

        }
        protected string UploadFolderPath = "~/webfile/serverfiles/";
        protected string strsavedfile = "";
        protected string stroriginal = "";
        protected void FileUploadComplete(object sender, EventArgs e)
        {
           

        }
      
        /// <summary>
        /// Save time sheet information
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void save(object sender, EventArgs e)
        {
            //string msg = "";
            //msg = "success";
            //string[] date1 = hidtask_date.Value.Split('#');
            //string[] project1 = hidtask_project.Value.Split('#');
            //string[] task1 = hidtask_task.Value.Split('#');
            //string[] hours11 = hidtask_hours.Value.Split('#');

            //string[] des1 = hidtask_description.Value.Split('#');
            //string[] billable1 = hidtask_billable.Value.Split('#');

            //try
            //{
            //    objts.action = "insert";
            //    objts.nid = "";
            //    objts.companyId = Session["companyid"].ToString();
            //    for (int i = 1; i < date1.Length; i++)
            //    {
            //        objts.empid = timesheet_hidempid.Value;
            //        objts.projectid = project1[i];
            //        objts.startdate = date1[i];
            //        objts.description = des1[i];
            //        objts.hours = hours11[i];
            //        objts.taskid = task1[i];
            //        objts.Status = "Submitted";
            //        objts.isbillable = billable1[i];
            //        objts.ManageTimesheet();

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
            blank();
            GeneralMethod.alert(this.Page, "Saved Successfully!");
            fillgrid();
            // ScriptManager.RegisterStartupScript(this, GetType(), "msg", "<script>showhidepast('none');</script>", false);

        }


        /// <summary>
        /// set status 
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


                }
            }
            if (!ischkd)
                ScriptManager.RegisterStartupScript(this, GetType(), "show", "<script>alert('Please select a row for approval.');</script>", false);
            else
                fillgrid();


            //ScriptManager.RegisterStartupScript(this, GetType(), "msg", "<script>showhidepast('none');</script>", false);
        }


        /// <summary>
        /// Reset values
        /// </summary>
        protected void blank()
        {
            timesheet_hidrowno.Value = "0";
            strsno = "1";
            //hidtask_billable.Value = "";
            //hidtask_date.Value = "";
            //hidtask_description.Value = "";
            //hidtask_hours.Value = "";
            //hidtask_project.Value = "";
            //hidtask_task.Value = "";

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
            string[] taskvalue = ((DropDownList)dgnews.Rows[index].FindControl("droptask")).Text.Split('#');
            objts.taskid = taskvalue[0];
            CheckBox chkbilable = ((CheckBox)dgnews.Rows[index].FindControl("chkbillableedit"));
            if (taskvalue[1] == "1")
                chkbilable.Checked = true;
            else
                chkbilable.Checked = false;
            ((TextBox)dgnews.Rows[index].FindControl("txtdesc")).Text = taskvalue[2];

        }

        /// <summary>
        /// Cancel the row edit mode, and show it in normal mode
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dgnews_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            dgnews.EditIndex = -1;
            fillgrid();
        }

        /// <summary>
        /// Update the existing row data
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dgnews_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {

            GridViewRow row = (GridViewRow)dgnews.Rows[e.RowIndex];

            int index = row.RowIndex;

            string ismemovalue1 = ((HtmlInputHidden)dgnews.Rows[index].FindControl("hiememorequire")).Value;

            if (ismemovalue1 == "Yes")
            {

                if (txtmemo.Content.Trim() == "")
                {
                    GeneralMethod.alert(this.Page, "Memo is required for selected project.");
                    return;
                }
            }

            objts.projectid = ((HtmlInputHidden)dgnews.Rows[index].FindControl("hidproject")).Value;
            objts.date = ((TextBox)dgnews.Rows[index].FindControl("txtdate")).Text;
            objts.units = ((TextBox)dgnews.Rows[index].FindControl("txtunits")).Text;
            objts.description = ((TextBox)dgnews.Rows[index].FindControl("txtdesc")).Text;
            objts.cost = ((TextBox)dgnews.Rows[index].FindControl("txtcost")).Text;
            objts.MU = ((TextBox)dgnews.Rows[index].FindControl("txtmu")).Text;
            objts.amount = ((TextBox)dgnews.Rows[index].FindControl("txtamount")).Text;
            objts.remark = ((HtmlInputHidden)dgnews.Rows[index].FindControl("hidmemoedit")).Value;

            string[] taskvalue = ((HtmlInputHidden)dgnews.Rows[index].FindControl("hidtask")).Value.Split('#');
            objts.expenseid = taskvalue[0];
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


            objts.originalfile = ((HtmlInputHidden)dgnews.Rows[index].FindControl("hidoriginalfile")).Value;
            objts.savedfile = ((HtmlInputHidden)dgnews.Rows[index].FindControl("hidsavedfile")).Value;
            objts.nid = ((HtmlInputHidden)row.FindControl("hidnid1")).Value;
            objts.action = "insert";
            objts.ManageExpenseLog();

            dgnews.EditIndex = -1;
            fillgrid();
        }

        protected void dgnews_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            GridViewRow row = (GridViewRow)dgnews.Rows[e.RowIndex];
            objts.action = "delete";
            objts.nid = ((HtmlInputHidden)row.FindControl("hidnid")).Value;
            objts.ManageExpenseLog();
            dgnews.EditIndex = -1;
            fillgrid();

        }
        protected void dgnews_RowEditing(object sender, GridViewEditEventArgs e)
        {
            dgnews.EditIndex = e.NewEditIndex;

            
            fillgrid();
        }
        /// <summary>
        /// Get Projects with clients to bind for autocompleter
        /// </summary>
        /// <param name="prefixText"></param>
        /// <returns></returns>
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getProjects(string prefixText, string companyid)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds1 = new DataSet();
            GeneralMethod objgen = new GeneralMethod();
            objts.name = "";
            objts.action = "selectforautocompleter";
            objts.companyId = companyid;
            objts.nid = "";
            ds1 = objts.ManageProject();
            string result = objgen.serilizeinJson(ds1.Tables[0]);
            return result;
        }

        /// <summary>
        /// Get Tasks code and name to bind for autocompleter
        /// </summary>
        /// <param name="prefixText"></param>
        /// <returns></returns>
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getTasks(string companyid)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds1 = new DataSet();
            GeneralMethod objgen = new GeneralMethod();
            objts.name = "";
            objts.action = "selectexpforautocompleter";
            objts.companyId = companyid;
            objts.nid = "";

            objts.deptID = "";
            objts.type = "Expense";
            ds1 = objts.ManageTasks();



            string result = objgen.serilizeinJson(ds1.Tables[0]);
            return result;
        }



        /// <summary>
        /// Save time sheet information
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
       
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string savetimesheet(string taskdate, string projectid, string taskid, string cost, string description, string units, string amount, string billable, string mu, string reimbursable, string memo, string companyid, string empid, string originalfile, string savedfile)
        {
            string msg = "";
            msg = "success";
            ClsTimeSheet objts = new ClsTimeSheet();
            string[] date1 = Regex.Split(taskdate, "###");
            string[] project1 = Regex.Split(projectid, "###");
            string[] task1 = Regex.Split(taskid, "###");
            string[] cost1 = Regex.Split(cost, "###");

            string[] des1 = Regex.Split(description, "###");

            string[] units1 = Regex.Split(units, "###");

            string[] amount1 = Regex.Split(amount, "###");

            string[] mu1 = Regex.Split(mu, "###");
            string[] billable1 = Regex.Split(billable, "###");
            string[] reimbursable1 = Regex.Split(reimbursable, "###");
            string[] memo1 = Regex.Split(memo, "###");
            string[] orgfile1 = Regex.Split(originalfile, "###");
            string[] savedfile1 = Regex.Split(savedfile, "###");
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

                    objts.originalfile = orgfile1[i];
                    objts.savedfile = savedfile1[i];
                    objts.ManageExpenseLog();

                }




            }
            catch (Exception ex)
            {
                msg = ex.Message;

            }
            return msg;
        }

        protected void btnexportcsv_Click(object sender, EventArgs e)
        {
            fillgrid();
            string rpthtml = bindheader("excel");

            for (int i = 0; i < dsexcel.Tables[0].Rows.Count; i++)
            {
                rpthtml = rpthtml + "<tr"  + (Convert.ToBoolean(dsexcel.Tables[0].Rows[i]["isbillable"]) == true ? "" : " style='color:red;' ") + "><td>" + Convert.ToString(i + 1) + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["date"].ToString() +
                    "</td><td>" + dsexcel.Tables[0].Rows[i]["empname"].ToString()
                    + "</td><td>" + dsexcel.Tables[0].Rows[i]["projectcode"].ToString() + "</td><td>" + dsexcel.Tables[0].Rows[i]["taskcodenamesmall"].ToString() + "</td>"
                    + "<td>" + dsexcel.Tables[0].Rows[i]["description"].ToString() + "</td><td>" + Convert.ToDouble(dsexcel.Tables[0].Rows[i]["Units"]).ToString("0.00") + "</td>"
                    + "<td>" + Convert.ToDouble(dsexcel.Tables[0].Rows[i]["cost"]).ToString("0.00") + "</td><td>" + Convert.ToDouble(dsexcel.Tables[0].Rows[i]["mu"]).ToString("0.00")
                    + "</td><td>" + Convert.ToDouble(dsexcel.Tables[0].Rows[i]["amount"]).ToString("0.00")
                    + "</td><td>" + (Convert.ToBoolean(dsexcel.Tables[0].Rows[i]["isbillable"]) == true ? "Yes" : "No")
                    + "</td><td>" + (Convert.ToBoolean(dsexcel.Tables[0].Rows[i]["reimbursable"]) == true ? "Yes" : "No")
                    + "</td><td>" + dsexcel.Tables[0].Rows[i]["memo"].ToString()
                    + "</td><td>" + dsexcel.Tables[0].Rows[i]["status"].ToString()
                    + "</td></tr>";
            }
            excelexport objexcel = new excelexport();

            objexcel.downloadFile(rpthtml.ToString(), "Expenses.xls");


        }
        protected string bindheader(string type)
        {
            string str = "";
            string Companyname = Session["companyname"].ToString();
            string companyaddress = Session["companyaddress"].ToString();
            string date = "<b>Date:</b> ";

            if (hidfromdate.Value != hidtodate.Value)
            {
                date += hidfromdate.Value + " - " + hidtodate.Value;
            }
            else
            {
                date += hidfromdate.Value;
            }
           


            str =     @" <table align='left' cellpadding='5' width='100%' cellspacing='0' style='font-family: Calibri;
         font-size: 12px; text-align: left;' border='0'> <tr>
            <td colspan='14' align='left'>
                <h2 style='color:blue;'>
                   " + Companyname + @"
                </h2>
            </td>
        </tr>
<tr>
            <td  colspan='14'  align='left'>
               
                   " + companyaddress + @"
               
            </td>
        </tr>
        <tr>
            <td colspan='14'  align='left'>
                <h4>
                   Employee Expenses  From " + date + @"
                </h4>
            </td>
        </tr>
      
       
        <tr>
        <td>&nbsp;
        </td>

        </tr>";
       
         str+=@"<tr style='font-weight: bold; background: #395ba4; color: #ffffff;'>
        <td style='width=38px;'width='100px'>S.No</td>
        <td>Date</td>
      
        <td>Employee</td>
        <td>Project</td>
        <td>Expense</td>
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