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
using iTextSharp.tool.xml.html;
using System.Web.DynamicData;

namespace empTimeSheet
{
    public partial class Timesheet : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds1 = new DataSet();
        DataSet ds = new DataSet();
        public string strtask = "";
        DataSet dsexcel = new DataSet();
        public string strproject = "", strtime = "", strsno = ""; public decimal totalhours = 0; int editcellnum = 13; string myServerSideINT = "";
        public double totalhrs = 0;
        protected void Page_Load(object sender, EventArgs e)
        {

            objgen.validatelogin();
            if (!Page.IsPostBack)
            {

                //role 9 indicates Approve Task
                if (objda.checkUserInroles("85"))
                {
                    ViewState["add"] = "1";
                }
                else
                {
                    ViewState["add"] = null;
                    divtableaddnew.Visible = false;
                }
                if (objda.checkUserInroles("25"))
                {
                    ViewState["approvetimesheet"] = "1";
                    btnapprove.Visible = true;
                    btnreject.Visible = true;
                    timesheet_hidisapprove.Value = "1";
                    editcellnum = 13;


                }
                else
                {
                    ViewState["approvetimesheet"] = null;
                    timesheet_hidisapprove.Value = "0";
                    btnapprove.Visible = false;
                    btnreject.Visible = false;
                    dgnews.Columns[9].Visible = false;
                    dgnews.Columns[10].Visible = false;

                }
                hidcompanyid.Value = Session["companyid"].ToString();
                hiduserid.Value = Session["userid"].ToString();

                ClsUser objuser = new ClsUser();
                DataSet ds = new DataSet();
                GeneralMethod objgen = new GeneralMethod();

                objuser.fname = "";
                objuser.action = "select";
                objuser.companyid = hidcompanyid.Value;
                objuser.id = hiduserid.Value;
                objuser.activestatus = "";
                objuser.deptid = "";
                ds = objuser.ManageEmployee();
                timesheet_joindate.Value = ds.Tables[0].Rows[0]["joinDate"].ToString();
                hdnjoinDate_byEmp.Value = ds.Tables[0].Rows[0]["joinDate"].ToString();

                string todaydate = GeneralMethod.getLocalDate();

                txtfrom.Text = System.DateTime.Now.AddDays(-7).ToString("MM/dd/yyyy");
                txtto.Text = System.DateTime.Now.ToString("MM/dd/yyyy");

                timesheet_hidrowno.Value = "0";
                fillemployee();
                fillemployeesll();
                fillproject();
                timesheet_hidsno.Value = "1";
                strsno = "1";
                searchdata();
            }
            else if (this.ViewState["fillemployee"] != null)
            {
                fillviewStatetable();
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

        protected void fillemployeesll()
        {

            ClsUser objuser = new ClsUser();
            objuser.action = "selectactive";
            objuser.companyid = Session["companyid"].ToString();
            objuser.id = "";
            DataSet ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0)
            {
                //GeneralMethod objgen = new GeneralMethod();
                //  objgen.fillActiveInactiveDDL(ds.Tables[0], dropemployee, "username", "nid");
                //  dropemployee.Enabled = true;
                //dropspecific.DataSource = ds.Tables[0];
                //// dropemployee.DataTextField = "username";
                //// dropemployee.DataValueField = "nid";
                //dropspecific.DataBind();
                objgen.fillActiveInactiveDDL(ds.Tables[0], dropspecific, "username", "nid");


            }
        }
        #region {//Maitaining for employee Joining Date for validations}
        private void fillviewStatetable()
        {
            DataSet dsfillemployee = new DataSet();
            dsfillemployee = (DataSet)this.ViewState["fillemployee"];  //get estimate list from ViewState
            int empid = 0;
            if (dropemployee.SelectedIndex >= 0)
                int.TryParse(dropemployee.SelectedValue.Trim(), out empid);
            DataRow[] dataRowbyEmployee = dsfillemployee.Tables[0].Select("nid = '" + empid + "'");
            foreach (DataRow row in dataRowbyEmployee)
            {
                foreach (DataColumn column in row.Table.Columns)
                {
                    hdnjoinDate_byEmp.Value = row["joinDate"].ToString();
                    break;
                }
            }
        }
        #endregion

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

                objuser.action = "selectbymanagerwith";
                objuser.companyid = Session["companyid"].ToString();
                objuser.managerid = Session["userid"].ToString();
                objuser.id = "";
                ds = objuser.ManageEmployee();

                if (ds != null)
                {
                    if (this.ViewState["fillemployee"] == null)
                    {
                        this.ViewState.Add("fillemployee", ds);
                    }
                    else
                    {
                        this.ViewState["fillemployee"] = ds;
                    }
                }

                if (ds.Tables[0].Rows.Count > 0)
                {
                    //dropemployee.DataSource = ds;
                    //dropemployee.DataTextField = "username";
                    //dropemployee.DataValueField = "nid";
                    //dropemployee.DataBind();
                    objgen.fillActiveInactiveDDL(ds.Tables[0], dropemployee, "username", "nid");
                    // objgen.fillActiveInactiveDDL(ds.Tables[0], dropspecific, "username", "nid");

                    ListItem li = new ListItem("--All Employees--", "");
                    dropemployee.Items.Insert(0, li);

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
            timesheet_hidrowno.Value = "0";
            timesheet_hidsno.Value = "1";
            strsno = "1";
            dgnews.EditIndex = -1;
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
            objts.empid = timesheet_hidempid.Value;
            objts.action = "select";
            objts.projectid = hidproject.Value;

            if (timesheet_hidempid.Value == "")
            {
                dgnews.Columns[3].Visible = true;
            }
            else
            {
                dgnews.Columns[3].Visible = false;
            }

            if (ViewState["approvetimesheet"] == null && (ViewState["add"] != null && ViewState["add"].ToString() == "1"))
            {


                if (timesheet_hidempid.Value != Session["userid"].ToString())
                {
                    objts.managerId = Session["userid"].ToString();
                    objts.action = "selectforreview";
                    divtableaddnew.Visible = false;
                }
                else
                {
                    divtableaddnew.Visible = true;
                }

            }
            else
            {

                if (ViewState["approvetimesheet"] != null && timesheet_hidempid.Value == "")
                {
                    divtableaddnew.Visible = false;

                }
                else
                {
                    divtableaddnew.Visible = true;

                }
            }

            if (timesheet_hidisapprove.Value == "1")
            {
                editcellnum = 13;
            }
            objts.nid = "";
            ds = objts.ManageTimesheet();

            if (ds.Tables.Count > 1 && ds.Tables[1].Rows.Count > 0)
            {
                timesheet_hidbillrate.Value = ds.Tables[1].Rows[0]["billrate"].ToString();
                timesheet_hidpayrate.Value = ds.Tables[1].Rows[0]["payrate"].ToString();
            }
            else
            {
                timesheet_hidbillrate.Value = "0.00";
                timesheet_hidpayrate.Value = "0.00";
            }

            dgnews.DataSource = ds;
            dgnews.DataBind();

            if (ds.Tables[0].Rows.Count > 0)
            {
                if (ViewState["approvetimesheet"] != null)
                {
                    btnapprove.Visible = true;
                    btnreject.Visible = true;
                }
                btnexportcsv.Visible = true;
                btnreview.Visible = true;

            }
            else
            {
                btnexportcsv.Visible = false;
                btnapprove.Visible = false;
                btnreject.Visible = false;
                btnreview.Visible = false;

            }

            dsexcel = ds;
            timesheet_hidtotalhrs.Value = totalhrs.ToString("0.00");
            ScriptManager.RegisterStartupScript(this, GetType(), "msg", "<script>calhours();setdefaultcol();</script>", false);

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
                objts.startdate = ((TextBox)dgnews.Rows[index].FindControl("txtdate")).Text;
                objts.description = ((TextBox)dgnews.Rows[index].FindControl("txtdesc")).Text;

                objts.hours = ((TextBox)dgnews.Rows[index].FindControl("txthours")).Text;
                string[] taskvalue = ((HtmlInputHidden)dgnews.Rows[index].FindControl("hidtask")).Value.Split('#');
                objts.taskid = taskvalue[0];
                CheckBox chkbilable = ((CheckBox)dgnews.Rows[index].FindControl("chkbillable"));
                if (chkbilable.Checked == true)
                    objts.isbillable = "1";
                else

                    objts.isbillable = "0";
                objts.nid = e.CommandArgument.ToString();
                objts.remark = txtmemo.Content;
                objts.action = "insert";
                objts.ManageTimesheet();

            }
            if (e.CommandName == "del")
            {
                objts.action = "delete";
                objts.nid = e.CommandArgument.ToString();
                objts.ManageTimesheet();
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
                ((System.Web.UI.WebControls.ImageButton)(e.Row.Cells[editcellnum].Controls[0])).ToolTip = "Click here to edit";

                CheckBox chkapprove = (CheckBox)e.Row.FindControl("chkapprove");
                chkbillable.Enabled = false;
                if (DataBinder.Eval(e.Row.DataItem, "taskstatus").ToString().ToLower() == "approved" || DataBinder.Eval(e.Row.DataItem, "taskstatus").ToString().ToLower() == "rejected")
                {
                    ((HtmlGenericControl)e.Row.FindControl("divtaskstatus")).Attributes.Add("class", DataBinder.Eval(e.Row.DataItem, "taskstatus").ToString());
                    ((HtmlGenericControl)e.Row.FindControl("divtaskstatus")).Attributes.Add("title", DataBinder.Eval(e.Row.DataItem, "taskstatus").ToString());

                    ((LinkButton)e.Row.FindControl("lbtndelete")).Visible = false;
                    chkapprove.Checked = true;

                    chkapprove.Enabled = false;



                    if (ViewState["approvetimesheet"] == null)
                    {
                        ((System.Web.UI.WebControls.ImageButton)(e.Row.Cells[editcellnum].Controls[0])).Visible = false;
                        ((System.Web.UI.WebControls.ImageButton)(e.Row.Cells[editcellnum].Controls[0])).ToolTip = "";
                    }
                    else
                    {
                        ((LinkButton)e.Row.FindControl("lbtndelete")).Visible = true;
                    }


                }
                else
                {
                    if (DataBinder.Eval(e.Row.DataItem, "reviewby").ToString() != "")
                    {
                        ((LinkButton)e.Row.FindControl("lbtndelete")).Visible = false;
                        ((System.Web.UI.WebControls.ImageButton)(e.Row.Cells[editcellnum].Controls[0])).Visible = false;
                        ((HtmlGenericControl)e.Row.FindControl("divtaskstatus")).Attributes.Add("class", "review");
                        ((HtmlGenericControl)e.Row.FindControl("divtaskstatus")).Attributes.Add("title", "Reviewed by " + DataBinder.Eval(e.Row.DataItem, "reviewname").ToString());

                    }
                    else
                    {
                        ((HtmlGenericControl)e.Row.FindControl("divtaskstatus")).Attributes.Add("title", DataBinder.Eval(e.Row.DataItem, "taskstatus").ToString());

                        ((HtmlGenericControl)e.Row.FindControl("divtaskstatus")).Attributes.Add("class", DataBinder.Eval(e.Row.DataItem, "taskstatus").ToString());



                    }
                    chkapprove.Enabled = true;
                }

                if (DataBinder.Eval(e.Row.DataItem, "assignmentstatusid").ToString() != "" && DataBinder.Eval(e.Row.DataItem, "assignmentstatusid").ToString() != "0")
                {
                    ((LinkButton)e.Row.FindControl("lbtndelete")).Visible = false;
                    ((System.Web.UI.WebControls.ImageButton)(e.Row.Cells[editcellnum].Controls[0])).Enabled = false;
                    ((System.Web.UI.WebControls.ImageButton)(e.Row.Cells[editcellnum].Controls[0])).ToolTip = "Assigned Task";
                    ((System.Web.UI.WebControls.ImageButton)(e.Row.Cells[editcellnum].Controls[0])).ImageUrl = "images/assignedTask.png";
                }
                if (ViewState["approvetimesheet"] == null)
                {

                    if (DataBinder.Eval(e.Row.DataItem, "taskstatus").ToString().ToLower() != "approved" && DataBinder.Eval(e.Row.DataItem, "taskstatus").ToString().ToLower() != "rejected" && DataBinder.Eval(e.Row.DataItem, "submitto").ToString() == Session["userid"].ToString())
                    {
                        chkapprove.Enabled = true;
                    }
                    else
                    {
                        chkapprove.Visible = false;
                    }




                }
                else
                {
                    chkapprove.Visible = true;
                }

                if (Convert.ToBoolean(DataBinder.Eval(e.Row.DataItem, "isbillable")) == false || DataBinder.Eval(e.Row.DataItem, "taskstatus").ToString().ToLower() == "rejected")
                {

                    e.Row.Attributes.Add("class", "gridred");
                }


                if (Convert.ToBoolean(DataBinder.Eval(e.Row.DataItem, "isbilled")) == true && DataBinder.Eval(e.Row.DataItem, "taskstatus").ToString().ToLower() != "rejected")
                {

                    e.Row.Attributes.Add("class", "gridblue");
                }
                if (DataBinder.Eval(e.Row.DataItem, "taskstatus").ToString().ToLower() != "rejected")
                {
                    totalhrs += Convert.ToDouble(DataBinder.Eval(e.Row.DataItem, "Hours"));
                }

            }
            if (e.Row.RowType == DataControlRowType.DataRow && (e.Row.RowState == DataControlRowState.Edit || e.Row.RowState == (DataControlRowState.Alternate | DataControlRowState.Edit)))
            {

                chkbillable.Enabled = true;
                TextBox dropproject = (TextBox)e.Row.FindControl("dropproject");
                TextBox droptask = (TextBox)e.Row.FindControl("droptask");
                HtmlInputHidden hidproject = (HtmlInputHidden)e.Row.FindControl("hidproject");
                HtmlInputHidden hidtask = (HtmlInputHidden)e.Row.FindControl("hidtask");
                HtmlInputHidden hidmemoreq = (HtmlInputHidden)e.Row.FindControl("hiememorequire");

                HtmlInputHidden hidistaskreadonly = (HtmlInputHidden)e.Row.FindControl("hidistaskreadonly");

                TextBox txthours = (TextBox)e.Row.FindControl("txthours");
                ((TextBox)e.Row.FindControl("txtdesc")).Text = DataBinder.Eval(e.Row.DataItem, "description").ToString();
                txthours.Text = DataBinder.Eval(e.Row.DataItem, "Hours").ToString();

                droptask.Text = DataBinder.Eval(e.Row.DataItem, "taskcodenamesmall").ToString();
                dropproject.Text = DataBinder.Eval(e.Row.DataItem, "projectcode").ToString();
                hidtask.Value = DataBinder.Eval(e.Row.DataItem, "taskvalue").ToString();
                hidproject.Value = DataBinder.Eval(e.Row.DataItem, "projectid").ToString();
                hidproject.Value = DataBinder.Eval(e.Row.DataItem, "projectid").ToString();
                hidmemoreq.Value = DataBinder.Eval(e.Row.DataItem, "Tmemorequired").ToString();
                hidistaskreadonly.Value = DataBinder.Eval(e.Row.DataItem, "TDesReadonly").ToString();

                string strreadonly = "";
                if (DataBinder.Eval(e.Row.DataItem, "TDesReadonly").ToString() == "Yes")
                    strreadonly = "setreadonlybox('" + ((TextBox)e.Row.FindControl("txtdesc")).ClientID + "');";

                txtmemo.Content = DataBinder.Eval(e.Row.DataItem, "memo").ToString();
                try
                {
                    ((System.Web.UI.WebControls.ImageButton)(e.Row.Cells[editcellnum].Controls[0])).ToolTip = "Save Changes";
                    ((System.Web.UI.WebControls.ImageButton)(e.Row.Cells[editcellnum].Controls[2])).ToolTip = "Cancel";
                }
                catch (Exception ex)
                {
                }


                ScriptManager.RegisterStartupScript(this, GetType(), "msg", "<script>bindprojectautocompleter('" + dropproject.ClientID + "', '" + hidproject.ClientID + "');bindtaskautocompleter('" + droptask.ClientID + "', '" + hidtask.ClientID + "');" + strreadonly + "</script>", false);


            }
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                this.hdnflddate0.Value = DataBinder.Eval(e.Row.DataItem, "date").ToString();
            }
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
                CheckBox chkbillable = (CheckBox)dgnews.Rows[i].FindControl("chkbillableedit");
                HtmlInputHidden hidactiviyid = (HtmlInputHidden)dgnews.Rows[i].FindControl("hidnid1");
                if (chkapprove.Enabled == true && chkapprove.Checked == true)
                {
                    ischkd = true;
                    objts.nid = hidactiviyid.Value;
                    objts.Status = status;
                    if (chkbillable.Checked == true)
                        objts.isbillable = "1";
                    else
                        objts.isbillable = "0";
                    objts.action = "setstatus";
                    objts.empid = Session["userid"].ToString();
                    objts.ManageTimesheet();
                }
            }
            if (!ischkd)
                ScriptManager.RegisterStartupScript(this, GetType(), "show", "<script>alert('Please select a row for approval.');</script>", false);
            else
                fillgrid();

            //ScriptManager.RegisterStartupScript(this, GetType(), "msg", "<script>showhidepast('none');</script>", false);
        }

        protected void setreviewstatus(object sender, EventArgs e)
        {
            LinkButton btnstatus = (LinkButton)sender;

            bool ischkd = false;
            string status = btnstatus.Text;
            status = "review";
            for (int i = 0; i < dgnews.Rows.Count; i++)
            {
                //Literal ltrempid = (Literal)dgnews.Rows[i].FindControl("ltrempid");
                CheckBox chkapprove = (CheckBox)dgnews.Rows[i].FindControl("chkapprove");
                CheckBox chkbillable = (CheckBox)dgnews.Rows[i].FindControl("chkbillableedit");
                HtmlInputHidden hidactiviyid = (HtmlInputHidden)dgnews.Rows[i].FindControl("hidnid1");
                if (chkapprove.Enabled == true && chkapprove.Checked == true)
                {
                    ischkd = true;
                    objts.nid = hidactiviyid.Value;
                    objts.Status = status;
                    if (chkbillable.Checked == true)
                        objts.isbillable = "1";
                    else
                        objts.isbillable = "0";
                    objts.action = "reviewtask";
                    objts.empid = Session["userid"].ToString();
                    objts.ManageTimesheet();
                }
            }
            if (!ischkd)
                ScriptManager.RegisterStartupScript(this, GetType(), "show", "<script>alert('Please select a row for approval.');</script>", false);
            else
            {
                fillgrid();
                ScriptManager.RegisterStartupScript(this, GetType(), "show", "<script>alert('Task Reviewed Successfully.');</script>", false);
            }


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

            string date = "", projetid = "", description = "", hours = "", taskvalue1 = "", ismemovalue1 = "";
            int index = row.RowIndex;
            date = ((TextBox)dgnews.Rows[index].FindControl("txtdate")).Text;
            projetid = ((HtmlInputHidden)dgnews.Rows[index].FindControl("hidproject")).Value;
            description = ((TextBox)dgnews.Rows[index].FindControl("txtdesc")).Text;
            hours = ((TextBox)dgnews.Rows[index].FindControl("txthours")).Text;
            taskvalue1 = ((HtmlInputHidden)dgnews.Rows[index].FindControl("hidtask")).Value;
            ismemovalue1 = ((HtmlInputHidden)dgnews.Rows[index].FindControl("hiememorequire")).Value;

            if (ismemovalue1 == "Yes")
            {

                if (txtmemo.Content.Trim() == "")
                {
                    GeneralMethod.alert(this.Page, "Memo is required for selected project.");
                    return;
                }
            }

            if (date != "" && projetid != "" && hours != "" && taskvalue1 != "")
            {
                objts.projectid = projetid;
                objts.startdate = date;
                objts.description = description;
                objts.hours = hours;

                string[] taskvalue = taskvalue1.Split('#');
                objts.taskid = taskvalue[0];
                CheckBox chkbilable = ((CheckBox)dgnews.Rows[index].FindControl("chkbillableedit"));
                if (chkbilable.Checked == true)
                    objts.isbillable = "1";
                else

                    objts.isbillable = "0";
                objts.keyword = ((HtmlInputHidden)dgnews.Rows[index].FindControl("hidmemoedit")).Value;
                objts.nid = ((HtmlInputHidden)row.FindControl("hidnid1")).Value;
                objts.action = "insert";
                if (((TextBox)dgnews.Rows[index].FindControl("txtpayrate")).Text == "")
                    objts.costrate = "0";
                else
                    objts.costrate = ((TextBox)dgnews.Rows[index].FindControl("txtpayrate")).Text;


                if (((TextBox)dgnews.Rows[index].FindControl("txtbillrate")).Text == "")
                    objts.billrate = "0";
                else
                    objts.billrate = ((TextBox)dgnews.Rows[index].FindControl("txtbillrate")).Text;




                objts.ManageTimesheet();
                dgnews.EditIndex = -1;
                fillgrid();
            }

            else
            {
                GeneralMethod.alert(this.Page, "Please fill Date, Project, Task and Hours all required field");
            }
        }

        protected void dgnews_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            GridViewRow row = (GridViewRow)dgnews.Rows[e.RowIndex];
            objts.action = "delete";
            objts.nid = ((HtmlInputHidden)row.FindControl("hidnid")).Value;
            objts.ManageTimesheet();
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
            objts.action = "selectforautocompleter";
            objts.type = "Task";
            objts.companyId = companyid;
            objts.nid = "";
            objts.deptID = "";

            ds1 = objts.ManageTasks();

            string result = objgen.serilizeinJson(ds1.Tables[0]);
            return result;
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
            objts.action = "selectHTML1";
            ds = objts.manageFavoriteTasks();
            string str = "";
            if (ds.Tables[0].Rows.Count > 0)
            {
                str = ds.Tables[0].Rows[0][0].ToString();


            }
            return str;
        }




        /// <summary>
        /// Save time sheet information
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string savetimesheet(string taskdate, string projectid, string taskid, string hours, string description, string billable, string companyid, string empid, string memo, string billrate, string payrate, string submittype, string submitto)
        {
            string msg = "";
            msg = "success";
            ClsTimeSheet objts = new ClsTimeSheet();
            string[] date1 = Regex.Split(taskdate, "###");
            string[] project1 = Regex.Split(projectid, "###");
            string[] task1 = Regex.Split(taskid, "###");
            string[] hours11 = Regex.Split(hours, "###");

            string[] des1 = Regex.Split(description, "###");
            string[] billable1 = Regex.Split(billable, "###");
            string[] memo1 = Regex.Split(memo, "###");
            string[] billrate1 = Regex.Split(billrate, "###");
            string[] payrate1 = Regex.Split(payrate, "###");

            objts.submitto = submitto;
            objts.submittype = submittype;

            try
            {
                objts.action = "insert";
                objts.nid = "";
                objts.companyId = companyid;
                for (int i = 1; i < date1.Length; i++)
                {
                    objts.empid = empid;
                    objts.projectid = project1[i];
                    objts.startdate = date1[i];
                    objts.description = des1[i];
                    objts.hours = hours11[i];
                    objts.taskid = task1[i];
                    objts.Status = "Submitted";
                    objts.isbillable = billable1[i];
                    objts.keyword = memo1[i];
                    objts.billrate = billrate1[i];
                    objts.costrate = payrate1[i];
                    objts.ManageTimesheet();

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

                rpthtml = rpthtml + "<tr " + (Convert.ToBoolean(dsexcel.Tables[0].Rows[i]["isbillable"]) == true ? "" : " style='color:red;' ") + "><td>" + Convert.ToString(i + 1) + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["date"].ToString() +
                    "</td><td>" + dsexcel.Tables[0].Rows[i]["empname"].ToString()
                    + "</td><td>" + dsexcel.Tables[0].Rows[i]["projectcode"].ToString() + "</td><td>" + dsexcel.Tables[0].Rows[i]["projectname"].ToString() + "</td><td>" + dsexcel.Tables[0].Rows[i]["taskcodenamesmall"].ToString() + "</td><td>" + dsexcel.Tables[0].Rows[i]["hours"].ToString() + "</td><td>" + dsexcel.Tables[0].Rows[i]["description"].ToString() + "</td><td>" + (Convert.ToBoolean(dsexcel.Tables[0].Rows[i]["isbillable"]) == true ? "Yes" : "No") + "</td><td>" + dsexcel.Tables[0].Rows[i]["taskstatus"].ToString() + "</td><td>" + dsexcel.Tables[0].Rows[i]["memo"].ToString() + "</td></tr>";
            }

            excelexport objexcel = new excelexport();

            objexcel.downloadFile(rpthtml.ToString(), "TimeEntry.xls");


        }
        protected string bindheader(string type)
        {
            string str = "";
            string Companyname = Session["companyname"].ToString();
            string companyaddress = Session["companyaddress"].ToString();
            string client = "", date = "<b>Date:</b> ";


            if (hidfromdate.Value != hidtodate.Value)
            {
                date += hidfromdate.Value + " - " + hidtodate.Value;
            }
            else
            {
                date += hidfromdate.Value;
            }
            string headerstr = "<table width='100%' border='0'>";
            if (type == "excel")
            {
                headerstr = "<table width='100%' border='0' >";

            }

            str = headerstr +
         @"<tr>
            <td colspan='10' align='left'>
                <h2>
                   " + Companyname + @"
                </h2>
            </td>
        </tr>
        <tr>
            <td colspan='10' align='left'>
                <h4>
                   " + companyaddress + @"
                </h4>
            </td>
        </tr>
      
        <tr>
            <td colspan='10' align='center'>
                <h4>
                    Employee Timesheet
</h4>
            </td>
        </tr>
        <tr>
            <td colspan='10'>
                &nbsp;
            </td>
        </tr>
       
        <tr>
        <td colspan='10'>
        " + date + "<br/>" +



        @"</td>

        </tr>
       <tr>
        <td colspan='11'>&nbsp;</td></tr>
       </table>

        <table align='left' cellpadding='5' width='100%' cellspacing='0' style='font-family: Calibri;
         font-size: 12px; text-align: left;' border='0'> 
         <tr style='font-weight: bold; background: #395ba4; color: #ffffff;'>
        <td style='width=38px;'width='100px'>S.No</td>
        <td>Date</td>
      
        <td>Employee</td>
 <td>Project ID</td>
        <td>Project Name</td>
        <td>Task ID</td>
      
        <td>Hours</td>
        <td>Description</td>
        <td>IsBillable</td>
        <td>Status</td>                                                             
        <td>Memo</td>                                                                                                                                                                                                                                     
        </tr>";

            return str;

        }
    }
}