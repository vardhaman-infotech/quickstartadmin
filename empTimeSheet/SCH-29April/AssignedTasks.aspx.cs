using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Data;
using System.Web.Services;
using System.Web.Script.Services;
using System.IO;

namespace empTimeSheet
{
    public partial class AssignedTasks : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();
        DataSet dsexcel = new DataSet();
        protected void Page_Load(object sender, EventArgs e)
        {

            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                txtfromdate.Text = System.DateTime.Now.AddDays(-2).ToString("MM/dd/yyyy");
                txttodate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");

                txtscheduledate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");

                System.Data.DataSet ds = new System.Data.DataSet();
                objda.id = Session["userid"].ToString();
                ds = objda.getUserInRoles();

                if (!objda.validatedRoles("7", ds) && !objda.validatedRoles("8", ds))
                {
                    Response.Redirect("Dashboard.aspx");
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

                //Check whether logged user have right for view Other's assigned tasks or not
                if (objda.validatedRoles("15", ds))
                {
                    ViewState["isadmin"] = "1";
                }
                else
                {
                    ViewState["isadmin"] = null;
                }

                fillemployee();
                filladdemployee();
                fillclient();
                filladdclient();
                fillproject();

                fillmanager();
                filltasks();
                filladdtasks();
                fillpopproject();
                //fillassignedby();
                if (Request.QueryString["date"] != null && Request.QueryString["task"] != null && Request.QueryString["emp"] != null)
                {
                    try
                    {
                        txtfromdate.Text = Request.QueryString["date"].ToString();
                        txttodate.Text = Request.QueryString["date"].ToString();
                        dropemployee.Text = Request.QueryString["emp"].ToString();
                        droptask.Text = Request.QueryString["task"].ToString();
                        dropassign.SelectedIndex = 0;
                    }
                    catch (Exception ex)
                    {
                    }
                }

                searchdata();
            }
        }
        /// <summary>
        /// //UNUSED NOW
        /// if you want to apply searching by assigned by then use this
        /// Fill ASsigned by for searching
        /// </summary>
        //protected void fillassignedby()
        //{
        //    dropassignedby.Items.Clear();

        //    if (ViewState["add"] != null && ViewState["add"].ToString() == "1")
        //    {
        //        objuser.action = "select";
        //        objuser.companyid = Session["companyid"].ToString();
        //        objuser.id = "";
        //        ds = objuser.ManageEmployee();
        //        if (ds.Tables[0].Rows.Count > 0)
        //        {
        //            dropassignedby.DataSource = ds;
        //            dropassignedby.DataTextField = "username";
        //            dropassignedby.DataValueField = "nid";
        //            dropassignedby.DataBind();

        //        }

        //    }
        //    else
        //    {
        //        objuser.action = "selectassignmanager";
        //        objuser.companyid = Session["companyid"].ToString();
        //        objuser.id = "";
        //        ds = objuser.ManageEmployee();
        //        if (ds.Tables[0].Rows.Count > 0)
        //        {
        //            dropassignedby.DataSource = ds;
        //            dropassignedby.DataTextField = "username";
        //            dropassignedby.DataValueField = "nid";
        //            dropassignedby.DataBind();

        //        }
        //        ListItem li = new ListItem(Session["username"].ToString(), Session["userid"].ToString());
        //        dropassignedby.Items.Insert(0, li);

        //    }
        //    ListItem li1 = new ListItem("--All--", "");
        //    dropassignedby.Items.Insert(0, li1);
        //}

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

            ListItem li = new ListItem("--All Projects--", "");
            dropproject.Items.Insert(0, li);

        }
        protected void ddlclient_SelectedIndexChanged(object sender, EventArgs e)
        {
            fillpopproject();
            ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);

        }

        protected void dropclient_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            fillproject();
            updatePanelSearch.Update();


        }
        /// <summary>
        /// Fill projects drop down to add
        /// </summary>
        protected void fillpopproject()
        {
            ddlproject.Items.Clear();
            if (ddlclient.Text != "")
            {
                objts.name = "";
                objts.action = "selectbyclient";
                objts.clientid = ddlclient.Text;
                objts.companyId = Session["companyid"].ToString();
                objts.nid = "";
                ds = objts.ManageProject();
                if (ds.Tables[0].Rows.Count > 0)
                {

                    ddlproject.DataSource = ds;
                    ddlproject.DataTextField = "projectnamewithcode";
                    ddlproject.DataValueField = "nid";
                    ddlproject.DataBind();
                }

            }

            ListItem li1 = new ListItem("--Select--", "");
            ddlproject.Items.Insert(0, li1);

        }

        /// <summary>
        /// Bind list of managers who assigned the tasks
        /// </summary>
        protected void fillmanager()
        {
            dropassign.Items.Clear();
            ddlmanager.Items.Clear();
            if (ViewState["add"] != null && ViewState["add"].ToString() == "1" && ViewState["isadmin"] == null)
            {
                ListItem li2 = new ListItem(Session["username"].ToString(), Session["userid"].ToString());
                dropassign.Items.Insert(0, li2);
                dropassign.SelectedIndex = 0;
                ddlmanager.Items.Insert(0, li2);
                ddlmanager.SelectedIndex = 0;
                return;
            }

            //This action selects the employee according to Roles id "7", if you chnage the roles please change in Stored Procedure too.
            objuser.action = "selectassignmanager";
            objuser.companyid = Session["companyid"].ToString();
            objuser.id = "";
            ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0)
            {
                dropassign.DataSource = ds;
                dropassign.DataTextField = "username";
                dropassign.DataValueField = "nid";
                dropassign.DataBind();

                ddlmanager.DataSource = ds;
                ddlmanager.DataTextField = "username";
                ddlmanager.DataValueField = "nid";
                ddlmanager.DataBind();

            }

            ListItem li = new ListItem("--All Manager--", "");
            dropassign.Items.Insert(0, li);

            ListItem li1 = new ListItem("--Select Manager--", "");
            ddlmanager.Items.Insert(0, li1);


        }

        /// <summary>
        /// Fill tasks drop down for searching
        /// </summary>
        protected void filltasks()
        {
            objts.name = "";
            objts.action = "select";
            objts.companyId = Session["companyid"].ToString();
            objts.nid = "";

            objts.deptID = "";
            ds = objts.ManageTasks();

            droptask.DataSource = ds;
            droptask.DataTextField = "taskcodename";
            droptask.DataValueField = "nid";
            droptask.DataBind();

            ListItem li = new ListItem("--All Tasks--", "");
            droptask.Items.Insert(0, li);
        }



        /// <summary>
        /// Fill Employee to select for those who have admin Right
        /// </summary>
        protected void fillemployee()
        {
            if (ViewState["add"] == null || ViewState["add"].ToString() == "")
            {
                ListItem li = new ListItem(Session["username"].ToString(), Session["userid"].ToString());
                dropemployee.Items.Insert(0, li);
                dropemployee.SelectedIndex = 0;
            }
            else
            {
                objuser.action = "select";
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

                ListItem li = new ListItem("--All Employees--", "");
                dropemployee.Items.Insert(0, li);
                //dropemployee.Text = Session["userid"].ToString();
                dropemployee.SelectedIndex = 0;
            }


        }

        /// <summary>
        /// Fill clients drop down for searching
        /// </summary>
        protected void fillclient()
        {
            objuser.clientname = "";
            objuser.action = "select";
            objuser.companyid = Session["companyid"].ToString();
            objuser.id = "";
            ds = objuser.client();
            if (ds.Tables[0].Rows.Count > 0)
            {
                dropclient.DataSource = ds;
                dropclient.DataTextField = "clientcodewithname";
                dropclient.DataValueField = "nid";
                dropclient.DataBind();
                ListItem li = new ListItem("--All Clients--", "");
                dropclient.Items.Insert(0, li);
            }


        }
        protected void fillgrid()
        {
            Session["TaskTable"] = null;
            objts.empid = dropemployee.Text;
            objts.action = "selectbymanager";
            objts.nid = "";
            objts.Status = hidsearchdropstatus.Value;
            objts.clientid = hidsearchdropclient.Value;
            objts.projectid = hidsearchdropproject.Value;
            objts.taskid = hidsearchdroptask.Value;
            objts.from = hidsearchfromdate.Value;
            objts.to = hidsearchtodate.Value;
            objts.CreatedBy = hidsearchdroassign.Value;
            ds = objts.AssignTasks();

            int start = dgnews.PageSize * dgnews.PageIndex;
            int end = start + dgnews.PageSize;
            start = start + 1;
            if (end >= ds.Tables[0].Rows.Count)
                end = ds.Tables[0].Rows.Count;
            lblstart.Text = start.ToString();
            lblend.Text = end.ToString();
            lbltotalrecord.Text = ds.Tables[0].Rows.Count.ToString();

            if (ds.Tables[0].Rows.Count > 0)
            {
                Session["TaskTable"] = ds.Tables[0];
                dgnews.DataSource = ds;
                dgnews.DataBind();
                btnexportcsv.Enabled = true;
              
                divnodata.Visible = false;
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
                    divnodata.Visible = true;
                }
                dgnews.Visible = false;

                Session["TaskTable"] = null;
            }
            updatePanelData.Update();
            dsexcel = ds;
        }
        /// <summary>
        /// Move to clicked page number
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dgnews_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            dgnews.PageIndex = e.NewPageIndex;
            fillgrid();
            ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>scrolltotopofList();</script>", false);

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

        protected void btnsearch_Click(object sender, EventArgs e)
        {
            searchdata();

        }
        protected void searchdata()
        {
            hidsearchfromdate.Value = txtfromdate.Text;
            hidsearchtodate.Value = txttodate.Text;
            hidsearchdropemployee.Value = dropemployee.Text;
            hidsearchdropclient.Value = dropclient.Text;
            hidsearchdropproject.Value = dropproject.Text;
            hidsearchdroptask.Value = droptask.Text;
            hidsearchdropstatus.Value = dropstatus.Text;
            hidsearchdroassign.Value = dropassign.Text;

            hidsearchdropemployeename.Value = dropemployee.SelectedItem.Text;
            hidsearchdropclientname.Value = dropclient.SelectedItem.Text;
            hidsearchdropprojectname.Value = dropproject.SelectedItem.Text;
            hidsearchdroptaskname.Value = droptask.SelectedItem.Text;
            hidsearchdropstatusname.Value = dropstatus.SelectedItem.Text;
            hidsearchdroassignname.Value = dropassign.SelectedItem.Text;

            fillgrid();
        }
        protected void dgnews_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {

                DropDownList ddlgrade = (DropDownList)e.Row.FindControl("ddlgrade");
                // DropDownList ddlstatus = (DropDownList)e.Row.FindControl("ddlstatus");
                TextBox txtremark = (TextBox)e.Row.FindControl("txtremark");
                // TextBox txthours = (TextBox)e.Row.FindControl("txthours");
                TextBox txtcomments = (TextBox)e.Row.FindControl("txtcomments");

                Literal ltrgrade = (Literal)e.Row.FindControl("ltrgrade");
                Literal ltrcomments = (Literal)e.Row.FindControl("ltrcomments");

                Literal ltrhours = (Literal)e.Row.FindControl("ltrhours");
                Literal ltrremark = (Literal)e.Row.FindControl("ltrremark");
                Literal ltrstatus = (Literal)e.Row.FindControl("ltrstatus");
                LinkButton lbtndel = (LinkButton)e.Row.FindControl("lbtndelete");
                LinkButton lbtnstatus = (LinkButton)e.Row.FindControl("lbtnstatus");
                //if (DataBinder.Eval(e.Row.DataItem, "status") != null)
                //    ddlstatus.Text = DataBinder.Eval(e.Row.DataItem, "status").ToString();
                if (DataBinder.Eval(e.Row.DataItem, "grade") != null)
                    ddlgrade.Text = DataBinder.Eval(e.Row.DataItem, "grade").ToString();

                HtmlImage imgassignedby = (HtmlImage)e.Row.FindControl("imgassignedby");
                if (DataBinder.Eval(e.Row.DataItem, "assignedbyid").ToString().ToLower() == "self assigned")
                {
                    imgassignedby.Src = "images/graydot.png";
                }
                else
                {
                    imgassignedby.Src = "images/greendot.png";
                }
                //Hide DELETE button
                lbtndel.Visible = false;

                //Check whether work on task has started or not
                if (DataBinder.Eval(e.Row.DataItem, "status").ToString().ToLower().Trim() == "not started" || DataBinder.Eval(e.Row.DataItem, "status").ToString() == "")
                {
                    //If work has started then
                    //Check whether logged in user is a manager or not
                    //If it is a manager then , it can delete the task yet not started
                    if (ViewState["add"] != null && ViewState["add"].ToString() == "1")
                    {
                        lbtndel.Visible = true;
                    }
                    //If logged in user is not a manager - then check whether it is self assigned task?
                    //If it is self assigned task, then user can delete it. so show the delete button
                    else if (DataBinder.Eval(e.Row.DataItem, "createdby").ToString() == Session["userid"].ToString())
                    {
                        lbtndel.Visible = true;
                    }
                }

                if (ViewState["add"] != null && ViewState["add"].ToString() == "1")
                {

                    ddlgrade.Enabled = false;
                    ddlgrade.ToolTip = "Task Grade can be given after completion of task";
                    txtcomments.Enabled = true;
                    txtremark.Visible = true;


                    if (DataBinder.Eval(e.Row.DataItem, "empid").ToString() == Session["userid"].ToString())
                    {
                        if (DataBinder.Eval(e.Row.DataItem, "status").ToString().ToLower().Trim() == "completed")
                        {

                            //txtremark.Visible = false;
                            // txthours.Visible = false;
                            // ddlstatus.Visible = false;

                            //ltrhours.Visible = true;
                            //ltrremark.Visible = true;
                            //ltrstatus.Visible = true;
                            ddlgrade.Enabled = true;

                            lbtnstatus.ToolTip = "View Status";

                        }



                    }
                    else
                    {
                        lbtnstatus.ToolTip = "View Status";
                        if (DataBinder.Eval(e.Row.DataItem, "status").ToString().ToLower().Trim() == "completed")
                        {
                            ddlgrade.Enabled = true;
                        }
                        //txthours.Visible = false;
                        //txtremark.Visible = false;
                        //ddlstatus.Visible = false;

                        //ltrhours.Visible = true;
                        //ltrremark.Visible = true;
                        //ltrstatus.Visible = true;

                    }

                }
                else
                {
                    // lbtndel.Visible = false;
                    ddlgrade.Visible = false;
                    txtcomments.Visible = false;
                    ltrcomments.Visible = true;
                    ltrgrade.Visible = true;
                    txtremark.Visible = false;
                    ltrremark.Visible = true;

                    if (DataBinder.Eval(e.Row.DataItem, "status").ToString().ToLower().Trim() == "completed")
                    {
                        //txthours.Enabled = false;
                        //txtremark.Enabled = false;
                        //ddlstatus.Enabled = false;
                        lbtnstatus.ToolTip = "View Status";


                    }
                    else
                    {
                        if (DataBinder.Eval(e.Row.DataItem, "empid").ToString() == Session["userid"].ToString())
                        {
                            txtremark.Visible = true;
                            ltrremark.Visible = false;
                        }
                        //txthours.Enabled = false;
                        //txtremark.Enabled = false;
                        //ddlstatus.Enabled = false;

                    }

                }

            }
        }

        /// <summary>
        /// event fires when clicks to Edit/Delete in List
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dgnews_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "SetStatus")
            {
                spanstatushead.InnerHtml = "Task Status";
             

                //hidstatus.Value=arrstatus[];
                string[] args = e.CommandArgument.ToString().Split(';');
                hidid.Value = args[0];
                string currentstatus = "", currentemp = "";
                if (args.Length > 1)
                {
                    currentstatus = args[1];

                }
                if (args.Length > 2)
                {
                    currentemp = args[2];
                    hidcurrentemp.Value = currentemp;
                }


                fillstatusgrid();
                if (ViewState["add"] != null && ViewState["add"].ToString() == "1")
                {
                    if (currentemp != Session["userid"].ToString())
                    {
                        divnewstatus.Visible = false;
                        spanstatushead.InnerHtml = "View Task Status";
                    }
                }
              

            }

            if (e.CommandName.ToLower() == "del")
            {
                objts.nid = e.CommandArgument.ToString();
                objts.action = "delete";
                objts.AssignTasks();
                fillgrid();
            }
        }

        //Bind sattus on drop down according to Last status
        protected void binddropdownstatus(string currentstatus)
        {
                ddlstaus.DataSource = new string[] { "", "In Process", "Partially Completed", "Completed" };
                ddlstaus.DataBind();
            
                 if (currentstatus == "In Process") //show all
                 {
                        ddlstaus.DataSource = new string[] { "", "In Process", "Partially Completed", "Completed" };
                        ddlstaus.DataBind();
                 }
                 else if (currentstatus == "Partially Completed") //car loan
                 {
                        ddlstaus.DataSource = new string[] { "", "Partially Completed", "Completed" };
                        ddlstaus.DataBind();
                 }
                
        }

        #region SORTING


        /// <summary>
        /// List sorting on a specified SortExpression in Design view
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dgnews_Sorting(object sender, GridViewSortEventArgs e)
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

        }


        /// <summary>
        /// Get current sort direction from ViewState[""SortDirection""], and return its reverse for sorting and again assign returned direction to ViewState[""SortDirection""] 
        /// </summary>
        /// <param name=""column""></param>
        /// <returns></returns>"
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

        #endregion

        //[WebMethod]
        //[ScriptMethod(ResponseFormat = ResponseFormat.Json)]

        //public static string savestatus(string nid, string status, string remark, string hours)
        //{

        //    ClsTimeSheet objts = new ClsTimeSheet();
        //    string msg = "";
        //    msg = "success";
        //    objts.action = "setworkstatus";
        //    objts.nid = nid;
        //    objts.hours = hours;
        //    objts.Status = status;
        //    objts.remark = remark;
        //    try
        //    {
        //        objts.AssignTasks();
        //        return msg;
        //    }
        //    catch (Exception ex)
        //    {
        //        msg = ex.Message;
        //        return msg;
        //    }

        //}

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]

        public static string savegrade(string nid, string grade, string comments, string remark)
        {

            ClsTimeSheet objts = new ClsTimeSheet();
            string msg = "";
            msg = "success";
            objts.action = "setgrade";
            objts.nid = nid;

            objts.grade = grade;
            objts.remark = remark;
            objts.description = comments;
            try
            {
                objts.AssignTasks();
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

        public static string save_Remark(string nid, string remark)
        {

            ClsTimeSheet objts = new ClsTimeSheet();
            string msg = "";
            msg = "success";
            objts.action = "setRemark";
            objts.nid = nid;


            objts.remark = remark;

            try
            {
                objts.AssignTasks();
                return msg;
            }
            catch (Exception ex)
            {
                msg = ex.Message;
                return msg;
            }

        }
        protected void btnexportcsv_Click(object sender, EventArgs e)
        {
            fillgrid();
            string rpthtml = bindheader("excel");

            for (int i = 0; i < dsexcel.Tables[0].Rows.Count; i++)
            {
                rpthtml = rpthtml + "<tr><td>" + Convert.ToString(i + 1) + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["date"].ToString() +
                    "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["empname"].ToString() + "</td><td>" + dsexcel.Tables[0].Rows[i]["clientname"].ToString()
                    + "</td><td>" + dsexcel.Tables[0].Rows[i]["taskcodename"].ToString() + "</td>"
                    + "<td>" + dsexcel.Tables[0].Rows[i]["task"].ToString() + "</td><td>" + dsexcel.Tables[0].Rows[i]["bhours"].ToString() + "</td>"
                    + "<td>" + dsexcel.Tables[0].Rows[i]["totalhour"].ToString() + "</td><td>" + dsexcel.Tables[0].Rows[i]["status"].ToString()
                    + "</td><td>" + dsexcel.Tables[0].Rows[i]["remark"].ToString()
                    + "</td><td>" + dsexcel.Tables[0].Rows[i]["grade"].ToString() + "</td><td>" + dsexcel.Tables[0].Rows[i]["comments"].ToString()
                    + "</td><td>" + dsexcel.Tables[0].Rows[i]["username"].ToString() + "</td></tr>";
            }

            HtmlGenericControl divgen = new HtmlGenericControl();

            divgen.InnerHtml = rpthtml;

            HttpResponse response = HttpContext.Current.Response;

            // first let's clean up the response.object   
            response.Clear();
            response.Charset = "";

            // set the response mime type for excel   
            response.ContentType = "application/vnd.ms-excel";
            response.AddHeader("Content-Disposition", "attachment;filename=\"HCLLPAssignedTasks-Report.xls\"");

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
            string client = "<b>Client:</b> ", employee = "<b>Employee:</b> ", task = "<b>Task:</b> ", status = "<b>Status:</b> ", date = "<b>Date:</b> ";
            if (hidsearchdropclient.Value == "")
            {
                client += "All";
            }
            else
            {
                client += hidsearchdropclientname.Value;
            }
            if (hidsearchdropemployee.Value == "")
            {
                employee += "All";
            }
            else
            {
                employee += hidsearchdropemployeename.Value;
            }
            if (hidsearchdropstatus.Value == "")
            {
                status += "All";
            }
            else
            {
                status += hidsearchdropstatusname.Value;
            }
            if (hidsearchdroptask.Value == "")
            {
                task += "All";
            }
            else
            {
                task += hidsearchdroptaskname.Value;
            }
            if (hidsearchfromdate.Value != hidsearchtodate.Value)
            {
                date += hidsearchfromdate.Value + " - " + hidsearchtodate.Value;
            }
            else
            {
                date += hidsearchfromdate.Value;
            }
            string headerstr = "<table width='100%'>";
            if (type == "excel")
            {
                headerstr = "<table width='100%' border='1'>";

            }

            str = headerstr +
         @"<tr>
            <td colspan='13' align='center'>
                <h2>
                    Harshwal & Company LLP
                </h2>
            </td>
        </tr>
        <tr>
            <td colspan='13' align='center'>
                <h4>
                    Assigned Tasks Report
                </h4>
            </td>
        </tr>
        <tr>
            <td colspan='13'>
                &nbsp;
            </td>
        </tr>
       
        <tr>
        <td colspan='13'>
        " + date + "<br/>" + employee + "<br/>" + client + "<br/>" + task + "<br/>" + status +



        @"</td>

        </tr>
       <tr>
        <td colspan='13'>&nbsp;</td></tr>
       </table>

        <table align='left' cellpadding='5' width='100%' cellspacing='0' style='font-family: Calibri;
         font-size: 12px; text-align: left;' border='0'> 
         <tr style='font-weight: bold; background: #395ba4; color: #ffffff;'>
        <td style='width=38px;'width='100px'>S.No</td>
        <td> Date</td>
        <td>Employee</td>
        <td>Client</td>
        <td>Task ID</td>
        <td>Task Description</td>
        <td>B-Hours</td>
        <td>Time Taken</td>
        <td>Status</td>                                                             
        <td>Emp Remark</td>
        <td>Grade</td>
        <td>Comments</td>
        <td>Assigned BY</td>                                                                                                                                                                                                                                                    
        </tr>";

            return str;

        }
        protected void lbtnPDF_Click(object sender, EventArgs e)
        {
            bindheader("pdf");

           // Session["ctrl"] = divreport;

            string url = "printpdf.aspx";
            string s = "window.open('" + url + "', '_blank');";

            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>" + s + "</script>", false);

        }


        //------------ ASSIGN NEW TASK


        /// <summary>
        /// Fill TASKS List boxes
        /// </summary>
        protected void filladdtasks()
        {
            listcode2.Items.Clear();
            listcode1.Items.Clear();

            objts.name = "";
            objts.action = "select";
            objts.companyId = Session["companyid"].ToString();
            objts.nid = "";
            objts.name = "";
            objts.deptID = "";
            ds = objts.ManageTasks();

            listcode1.DataSource = ds;
            listcode1.DataTextField = "taskcodename";
            listcode1.DataValueField = "nid";
            listcode1.DataBind();


            int count = listcode1.Items.Count;
            string[] taskval = hidtasks.Value.Split(',');
            string[] taskname = hidtaskname.Value.Split(',');
            for (int i = 0; i < taskval.Length - 1; i++)
            {
                ListItem li = new ListItem(taskname[i], taskval[i]);
                listcode2.Items.Add(li);
            }

            int count2 = listcode2.Items.Count;
            for (int i = 0; i < count; i++)
            {
                for (int j = 0; j < count2; j++)
                {
                    //Remove the expenses from Listcode1 those are already exists in group
                    if (listcode1.Items[i].Value == listcode2.Items[j].Value)
                    {
                        listcode1.Items.RemoveAt(i);
                        count = listcode1.Items.Count;
                        i = i - 1;
                        break;
                    }
                }
            }
        }

        /// <summary>
        /// Fill clients to Save
        /// </summary>
        protected void filladdclient()
        {
            objuser.clientname = "";
            objuser.action = "selectactive";
            objuser.companyid = Session["companyid"].ToString();
            objuser.id = "";
            ds = objuser.client();
            if (ds.Tables[0].Rows.Count > 0)
            {
                ddlclient.DataSource = ds;
                ddlclient.DataTextField = "clientcodewithname";
                ddlclient.DataValueField = "nid";
                ddlclient.DataBind();
                ListItem li = new ListItem("--Select--", "");
                ddlclient.Items.Insert(0, li);
            }


        }

        /// <summary>
        /// Fill Employee to select for those logged in user is a Manager
        /// </summary>
        protected void filladdemployee()
        {
            if (objda.checkUserInroles("7"))
            {
                objuser.action = "selectactive";
                objuser.companyid = Session["companyid"].ToString();
                objuser.id = "";
                ds = objuser.ManageEmployee();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    ddlemployee.DataSource = ds;
                    ddlemployee.DataTextField = "username";
                    ddlemployee.DataValueField = "nid";
                    ddlemployee.DataBind();

                }

                ddlemployee.Text = Session["userid"].ToString();
            }
            else
            {
                ListItem li = new ListItem(Session["username"].ToString(), Session["userid"].ToString());
                ddlemployee.Items.Insert(0, li);
                ddlemployee.SelectedIndex = 0;
            }

        }

        /// <summary>
        /// Save New Assigned task
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnsubmit_Click(object sender, EventArgs e)
        {
            objts.empid = ddlemployee.Text;
            objts.date = txtscheduledate.Text;
            objts.clientid = ddlclient.Text;
            objts.projectid = ddlproject.Text;
            objts.taskid = hidtasks.Value;
            objts.companyId = Session["companyid"].ToString();
            objts.CreatedBy = Session["userid"].ToString();
            objts.hours = ddlmanager.Text;
            objts.nid = "";
            objts.action = "insert";
            ds = objts.AssignTasks();
            GeneralMethod.alert(this, "Tasks assigned successfully to " + ddlemployee.SelectedItem.Text);
            blank();
            fillgrid();
            updatePanelAssign.Update();
        }

        /// <summary>
        /// Reset values of new Assign task POP UP
        /// </summary>
        protected void blank()
        {
            hidtaskname.Value = "";
            txtscheduledate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");
            ddlclient.SelectedIndex = 0;
            ddlproject.SelectedIndex = 0;
            ddlemployee.Text = Session["userid"].ToString();
            hidtasks.Value = "";
            ddlmanager.SelectedIndex = 0;

        }

        /// <summary>
        /// /// No longer using below code
        /// Search tasks by entered keyword
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void txtsearchtask_SelecetdIndexChanged(object sender, EventArgs e)
        {
            filladdtasks();
            ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);

        }

        /// <summary>
        /// No longer using below code
        /// When click on add new button, reset values of pop up and bind the task's list and then show the pop up
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void lbtnadd_newClick(object sender, EventArgs e)
        {
            blank();
            filladdtasks();
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>opendiv();</script>", false);

        }

  

        //----------------------------SET STATUS---------------------

        protected void fillstatusgrid()
        {
            divnewstatus.Visible = true;
            objts.action = "selectstatus";
            objts.nid = hidid.Value;
            ds = objts.AssignTasks();
           
            if (ds.Tables[0].Rows.Count > 0)
            {
                rptstatus.DataSource = ds;
                rptstatus.DataBind();
                divprestatus.Visible = true;
                divnodataforpreviousstatus.Visible = false;
                binddropdownstatus(ds.Tables[0].Rows[ds.Tables[0].Rows.Count-1]["Status"].ToString());
                if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["Status"].ToString().ToLower() == "completed")
                {
                    divnewstatus.Visible = false;
                }
               
            }
            else
            {
                divprestatus.Visible = false;
                rptstatus.DataSource = null;
                rptstatus.DataBind();
                if (ViewState["add"] != null && ViewState["add"].ToString() == "1")
                {
                    divnodataforpreviousstatus.Visible = true;
                }
                binddropdownstatus("");
            }
            ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>openstatusdiv();</script>", false);

            updatePanelStatus.Update();
        }

        protected void rptstatus_OnItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                LinkButton lbtndelete = (LinkButton)e.Item.FindControl("lbtndelete");
                LinkButton lbtnedit = (LinkButton)e.Item.FindControl("lbtnedit");
                objts.nid = hidid.Value;
                objts.action = "select";
                ds = objts.AssignTasks();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    if (ds.Tables[0].Rows[0]["grade"] != null && ds.Tables[0].Rows[0]["grade"].ToString() != "")
                    {
                        lbtndelete.Visible = false;
                        lbtnedit.Visible = false;
                    }
                }

            }
        }
        protected void rptstatus_OnItemCommand(object sender, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "del")
            {
                objts.nid = e.CommandArgument.ToString();
                objts.action = "deletestatus";
                objts.AssignTasks();
                fillstatusgrid();
                fillgrid();
            }
            if (e.CommandName == "edititem")
            {

                objts.nid = e.CommandArgument.ToString();
                hidstatusid.Value = objts.nid;
                objts.action = "selectassignmentstatus";
                ds = objts.AssignTasks();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    txtnewdate.Text = ds.Tables[0].Rows[0]["StatusDate"].ToString();
                    txtTime.Text = ds.Tables[0].Rows[0]["TimeTaken"].ToString();
                   
                    txtremark.Text = ds.Tables[0].Rows[0]["remark"].ToString();
                    //Check whther it is Last Row, If current row is last row, then Status can be update
                    if (e.Item.ItemIndex == rptstatus.Items.Count - 1)
                    {
                        ddlstaus.Enabled = true;
                        hidIsUpdateStatus.Value = "1";
                        //We are retriving second last status for current task, so we will bind the status drop down according to that.
                        //Like if current status is "Complete" and Second last status is "Partially Complete" then status dropdown should show values only "Partially Complete" and "Complete" 
                        if (ds.Tables[1].Rows.Count > 0)
                        {
                            binddropdownstatus(ds.Tables[1].Rows[0]["status"].ToString());
                        }
                        else
                        {
                            binddropdownstatus("");
                        }
                    }
                 
                    //Else status cannot be updatable   
                    else
                    {
                        ddlstaus.Enabled = false;
                        hidIsUpdateStatus.Value = "";
                    }
                    ddlstaus.Text = ds.Tables[0].Rows[0]["Status"].ToString();
                    if (ddlstaus.Text == "Completed")
                    {
                        divnewstatus.Visible = true;
                    }
                   
                }
                ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>openstatusdiv();</script>", false);

                updatePanelStatus.Update();
            }
        }
        /// <summary>
        /// Set Status 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>


        protected void btnsave_Click(object sender, EventArgs e)
        {
            objts.Status = ddlstaus.Text;

            objts.action = "insertassignmentstatus";
            objts.date = txtnewdate.Text;
            objts.groupid = hidid.Value;
            objts.nid = hidstatusid.Value;
            objts.hours = txtTime.Text;
            objts.Status = ddlstaus.Text;
            objts.remark = txtremark.Text;
            if (hidstatusid.Value != "")
            {
                if (hidIsUpdateStatus.Value != "1")
                {
                    objts.groupid = "";
                }
            }
            objts.CreatedBy = Session["userid"].ToString();
            objts.companyId = Session["companyid"].ToString();
            ds = objts.AssignTasks();

            GeneralMethod.alert(this.Page, "Status updated successfully ");

            txtremark.Text = "";
            ddlstaus.SelectedIndex = 0;
            txtTime.Text = "";
            txtnewdate.Text = "";
            hidstatusid.Value = "";
            hidIsUpdateStatus.Value = "";
            fillgrid();
            fillstatusgrid();
            ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>openstatusdiv();</script>", false);

            updatePanelStatus.Update();

        }
        protected void btnrefresh_Click(object sender, EventArgs e)
        {
            fillgrid();
        }
    }
}