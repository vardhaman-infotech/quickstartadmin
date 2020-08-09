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
    public partial class WorkAllocation : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();
        DataSet dsexcel = new DataSet();
        public string strsno = "";
        protected void Page_Load(object sender, EventArgs e)
        {

            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                txtfromdate.Text = System.DateTime.Now.AddDays(-2).ToString("MM/dd/yyyy");
                txttodate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");

                txtscheduledate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");
                Page.ClientScript.RegisterHiddenField("viewstatetodaydate", txtscheduledate.Text);
                System.Data.DataSet ds = new System.Data.DataSet();
                objda.id = Session["userid"].ToString();
                ds = objda.getUserInRoles();

                if (Session["usertype"].ToString() != "Admin")
                {
                    if (!objda.checkUserInroles("7") && !objda.checkUserInroles("8"))
                    {
                        Response.Redirect("UserDashboard.aspx");
                    }
                    else
                    {
                        if (objda.checkUserInroles("7"))
                        {
                            ViewState["add"] = "1";
                            Page.ClientScript.RegisterHiddenField("viewstateadd", ViewState["add"].ToString());

                        }
                        else
                        {
                            ViewState["add"] = null;
                            Page.ClientScript.RegisterHiddenField("viewstateadd", "");

                        }
                        if (objda.checkUserInroles("15"))
                        {
                            ViewState["isadmin"] = "1";

                        }
                        else
                        {
                            ViewState["isadmin"] = null;
                        }
                    }
                }
                else
                {
                    ViewState["add"] = "1";
                    Page.ClientScript.RegisterHiddenField("viewstateadd", ViewState["add"].ToString());
                    ViewState["isadmin"] = "1";
                }


              
                AssignedTask_hidrowno.Value = "1";
                AssignedTask_hidsno.Value = "2";

                fillemployee();
                filladdemployee();
                fillclient();
             
                fillproject();
                fillsearchmanager();
                fillmanager();
                filltasks();
              
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


                //Whenever user open assign task page, Set all task notification status as "READ"
                resertasknoti();
                ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>searchdata();</script>", false);




            }
        }
        protected void resertasknoti()
        {
            objts.action = "setstatusasreadbydate";
            objts.empid = Session["userid"].ToString();
            objts.from = txtfromdate.Text;
            objts.to = txttodate.Text;
            objts.AssignTasks();
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

            ListItem li = new ListItem("--All Projects--", "");
            dropproject.Items.Insert(0, li);

        }
        protected void ddlclient_SelectedIndexChanged(object sender, EventArgs e)
        {
            //*fillpopproject();
            ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);

        }

        protected void dropclient_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            fillproject();
            updatePanelSearch.Update();


        }
      
        /// <summary>
        /// Bind list of managers for searching
        /// </summary>
        protected void fillsearchmanager()
        {
            dropassign.Items.Clear();
            //This action selects the employee according to Roles id "7", if you chnage the roles please change in Stored Procedure too.
            if (ViewState["add"] != null && ViewState["add"].ToString() == "1" && ViewState["isadmin"] == null)
            {
                ListItem li2 = new ListItem(Session["username"].ToString(), Session["userid"].ToString());
                dropassign.Items.Insert(0, li2);
                dropassign.SelectedIndex = 0;

                return;
            }
            objuser.action = "selectassignmanagerself";
            objuser.companyid = Session["companyid"].ToString();
            objuser.id = "";
            objuser.managerid = Session["userid"].ToString();
            objuser.activestatus = ""; 
            ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0)
            {
                //dropassign.DataSource = ds;
                //dropassign.DataTextField = "username";
                //dropassign.DataValueField = "nid";
                //dropassign.DataBind();
                objgen.fillActiveInactiveDDL(ds.Tables[0], dropassign, "username", "nid");


            }

            ListItem li = new ListItem("--All Manager--", "");
            dropassign.Items.Insert(0, li);

        }

        /// <summary>
        /// Bind list of managers who assigned the tasks
        /// </summary>
        protected void fillmanager()
        {

            ddlmanager.Items.Clear();
            if (ViewState["add"] != null && ViewState["add"].ToString() == "1" && ViewState["isadmin"] == null)
            {
                ListItem li2 = new ListItem(Session["username"].ToString(), Session["userid"].ToString());

                ddlmanager.Items.Insert(0, li2);
                ddlmanager.SelectedIndex = 0;
                return;
            }

            //This action selects the employee according to Roles id "7", if you chnage the roles please change in Stored Procedure too.
            objuser.action = "selectassignmanagerself";
            objuser.companyid = Session["companyid"].ToString();
            objuser.id = "";
            objuser.managerid = Session["userid"].ToString();
            objuser.activestatus = "active";
            ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0)
            {
                //ddlmanager.DataSource = ds;
                //ddlmanager.DataTextField = "username";
                //ddlmanager.DataValueField = "nid";
                //ddlmanager.DataBind();
                objgen.fillActiveInactiveDDL(ds.Tables[0], ddlmanager, "username", "nid");


            }


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
            objts.type = "Task";
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
                objuser.action = "selectbymanagerwith";
                objuser.companyid = Session["companyid"].ToString();
                objuser.id = "";
                objuser.managerid = Session["userid"].ToString();
                ds = objuser.ManageEmployee();
                objgen.fillActiveInactiveDDL(ds.Tables[0], dropemployee, "username","nid");

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


            dsexcel = ds;
        }
        /// <summary>
        /// Move to clicked page number
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        ///  //***//
        //protected void dgnews_PageIndexChanging(object sender, GridViewPageEventArgs e)
        //{
        //    dgnews.PageIndex = e.NewPageIndex;
        //    fillgrid();
        //    ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>scrolltotopofList();</script>", false);

        //}

        /// <summary>
        /// Paging- Go to previous page
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        ///  //***//
        //protected void lnkprevious_Click(object sender, EventArgs e)
        //{
        //    if (dgnews.PageIndex > 0)
        //    {
        //        dgnews.PageIndex = dgnews.PageIndex - 1;
        //        fillgrid();
        //    }
        //}

        /// <summary>
        /// Paging- Move to next page
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        ///  //***//
        //protected void lnknext_Click(object sender, EventArgs e)
        //{
        //    if (int.Parse(lbltotalrecord.Text) > int.Parse(lblend.Text))
        //    {
        //        dgnews.PageIndex = dgnews.PageIndex + 1;
        //        fillgrid();
        //    }
        //}

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
            //***//
            //fillgrid();
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

                // Literal ltrhours = (Literal)e.Row.FindControl("ltrhours");
                Literal ltrremark = (Literal)e.Row.FindControl("ltrremark");
                // Literal ltrstatus = (Literal)e.Row.FindControl("ltrstatus");
                LinkButton lbtndel = (LinkButton)e.Row.FindControl("lbtndelete");
                // LinkButton lbtnstatus = (LinkButton)e.Row.FindControl("lbtnstatus");
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



                        }



                    }
                    else
                    {

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

            if (e.CommandName.ToLower() == "del")
            {
                objts.nid = e.CommandArgument.ToString();
                objts.action = "delete";
                objts.AssignTasks();
                //***//
                //fillgrid();
            }
        }


        #region SORTING


        /// <summary>
        /// List sorting on a specified SortExpression in Design view
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        ///  //***//
        //protected void dgnews_Sorting(object sender, GridViewSortEventArgs e)
        //{

        //    //Retrieve the table from the session object.
        //    DataTable dt = Session["TaskTable"] as DataTable;

        //    if (dt != null)
        //    {

        //        //Sort the data.
        //        dt.DefaultView.Sort = e.SortExpression + " " + GetSortDirection(e.SortExpression);
        //        dgnews.DataSource = Session["TaskTable"];
        //        dgnews.DataBind();
        //    }

        //}


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


        protected void btnexportcsv_Click(object sender, EventArgs e)
        {   //***//
            fillgrid();
            string rpthtml = bindheader("excel");

            for (int i = 0; i < dsexcel.Tables[0].Rows.Count; i++)
            {
                rpthtml = rpthtml + "<tr><td>" + Convert.ToString(i + 1) + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["date"].ToString() +
                    "</td><td>" + dsexcel.Tables[0].Rows[i]["Lastmodifieddate"].ToString() +
                    "</td><td>" + dsexcel.Tables[0].Rows[i]["empname"].ToString() + "</td><td>" + dsexcel.Tables[0].Rows[i]["projectname"].ToString()
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
            response.AddHeader("Content-Disposition", "attachment;filename=\"Assigned Task.xls\"");

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
         @"tr>
            <td colspan='14' align='center'>
                <h2>
                   " + Companyname + @"
                </h2>
            </td>
        </tr>
<tr>
            <td colspan='14' align='center'>
                <h4>
                   " + companyaddress + @"
                </h4>
            </td>
        </tr>
        <tr>
            <td colspan='14' align='center'>
                <h4>
                    Assigned Tasks Report
                </h4>
            </td>
        </tr>
        <tr>
            <td colspan='14'>
                &nbsp;
            </td>
        </tr>
       
        <tr>
        <td colspan='14'>
        " + date + "<br/>" + employee + "<br/>" + client + "<br/>" + task + "<br/>" + status +



        @"</td>

        </tr>
       <tr>
        <td colspan='14'>&nbsp;</td></tr>
       </table>

        <table align='left' cellpadding='5' width='100%' cellspacing='0' style='font-family: Calibri;
         font-size: 12px; text-align: left;' border='0'> 
         <tr style='font-weight: bold; background: #395ba4; color: #ffffff;'>
        <td style='width=38px;'width='100px'>S.No</td>
        <td>Assign Date</td>
        <td>Last Updated Date</td>
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
                //ddlclient.DataSource = ds;
                //ddlclient.DataTextField = "clientcodewithname";
                //ddlclient.DataValueField = "nid";
                //ddlclient.DataBind();
                //ListItem li = new ListItem("--Select--", "");
                //ddlclient.Items.Insert(0, li);
            }


        }

        /// <summary>
        /// Fill Employee to select for those logged in user is a Manager
        /// </summary>
        protected void filladdemployee()
        {
            if (objda.checkUserInroles("7"))
            {
                objuser.action = "selectbymanagerwith";
                objuser.companyid = Session["companyid"].ToString();
                objuser.id = "";
                objuser.managerid = Session["userid"].ToString();
                ds = objuser.ManageEmployee();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    ddlemployee.DataSource = ds;
                    ddlemployee.DataTextField = "username";
                    ddlemployee.DataValueField = "nid";
                    ddlemployee.DataBind();

                }

                // ddlemployee.Text = Session["userid"].ToString();
                ListItem li = new ListItem("--Select Employee--", "");
                ddlemployee.Items.Insert(0, li);
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
            objts.clientid = "";
            //* objts.projectid = ddlproject.Text;
            //*objts.taskid = hidtasks.Value;
            objts.companyId = Session["companyid"].ToString();
            objts.CreatedBy = Session["userid"].ToString();
            objts.hours = ddlmanager.Text;
            objts.nid = "";
            objts.action = "insert";
            ds = objts.AssignTasks();
            GeneralMethod.alert(this, "Tasks assigned successfully to " + ddlemployee.SelectedItem.Text);
            blank();
            //***//
            //fillgrid();
            updatePanelAssign.Update();
        }

        /// <summary>
        /// Reset values of new Assign task POP UP
        /// </summary>
        protected void blank()
        {
            //* txtsearchtask.Text = "";

            txtscheduledate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");
            // ddlclient.SelectedIndex = 0;
            //* ddlproject.SelectedIndex = 0;
            ddlemployee.Text = Session["userid"].ToString();
            //* hidtasks.Value = "";
            ddlmanager.SelectedIndex = 0;

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
            //*filladdtasks();
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>opendiv();</script>", false);

        }

        protected void btnrefresh_Click(object sender, EventArgs e)
        {
            //***//
            //fillgrid();
        }


        #region WebMethods

       

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
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]

        public static StatusDetails[] getstatusdata(string nid)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();

            List<StatusDetails> items = new List<StatusDetails>();
            objts.action = "selectstatus";
            objts.nid = nid;
            ds = objts.AssignTasks();
            string grade = "", laststatus = "";
            if (ds.Tables[0].Rows.Count > 0)
            {
                if (ds.Tables[1].Rows.Count > 0)
                {
                    grade = Convert.ToString(ds.Tables[1].Rows[0]["grade"]);
                    laststatus = Convert.ToString(ds.Tables[1].Rows[0]["status"]);
                }
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    StatusDetails stdtl = new StatusDetails();
                    stdtl.nid = ds.Tables[0].Rows[i]["nid"].ToString();
                    stdtl.statusdate = ds.Tables[0].Rows[i]["statusdate"].ToString();
                    stdtl.Status = ds.Tables[0].Rows[i]["Status"].ToString();
                    stdtl.TimeTaken = ds.Tables[0].Rows[i]["TimeTaken"].ToString();
                    stdtl.remark = ds.Tables[0].Rows[i]["remark"].ToString();
                    stdtl.taskstatus = ds.Tables[0].Rows[i]["taskstatus"].ToString();
                    stdtl.grade = grade;
                    stdtl.laststatus = laststatus;
                    items.Add(stdtl);
                }
            }
            return items.ToArray();
        }
        public class StatusDetails
        {
            public string nid { get; set; }
            public string statusdate { get; set; }
            public string Status { get; set; }
            public string TimeTaken { get; set; }
            public string remark { get; set; }
            public string taskstatus { get; set; }
            public string grade { get; set; }
            public string laststatus { get; set; }

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]

        public static string deletestatus(string nid)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();
            string msg = "failure";
            try
            {
                objts.nid = nid;
                objts.action = "deletestatus";
                ds = objts.AssignTasks();
                string lastupdate = "";
                if (ds.Tables[0].Rows[0]["LastUpdatedDate"] != null)
                {
                    lastupdate = ds.Tables[0].Rows[0]["LastUpdatedDate"].ToString();
                }
                msg = ds.Tables[0].Rows[0]["status"].ToString() + "," + ds.Tables[0].Rows[0]["timetaken"].ToString() + "," + ds.Tables[0].Rows[0]["remark"].ToString() + "," + lastupdate;
                return msg;
            }
            catch (Exception ex)
            {

                return msg;
            }
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]

        public static string selectstatus(string nid)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();
            string msg = "failure";
            try
            {
                objts.nid = nid;

                objts.action = "selectassignmentstatus";
                ds = objts.AssignTasks();
                if (ds.Tables[1].Rows.Count > 0)
                {
                    msg = ds.Tables[1].Rows[0]["status"].ToString();
                }
                else
                {
                    msg = "";
                }

                return msg;
            }
            catch (Exception ex)
            {

                return msg;
            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]

        public static string savestatus(string nid, string status, string newdate, string timetaken, string remark, string statusid, string isupdatestatus, string userid, string companyid)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();
            string msg = "failure";
            try
            {

                objts.Status = status;

                objts.action = "insertassignmentstatuswithtimesheet";
                objts.date = newdate;
                objts.groupid = nid;
                objts.nid = statusid;
                objts.hours = timetaken;

                objts.remark = remark;
                if (statusid != "")
                {
                    if (isupdatestatus != "1")
                    {
                        objts.groupid = "";
                    }
                }
                objts.CreatedBy = userid;
                objts.companyId = companyid;
                ds = objts.AssignTasks();
                string lastupdate = "";
                if (ds.Tables[0].Rows[0]["LastUpdatedDate"] != null)
                {
                    lastupdate = ds.Tables[0].Rows[0]["LastUpdatedDate"].ToString();
                }
                msg = ds.Tables[0].Rows[0]["status"].ToString() + "," + ds.Tables[0].Rows[0]["timetaken"].ToString() + "," + ds.Tables[0].Rows[0]["remark"].ToString() + "," + lastupdate;
                return msg;
            }
            catch (Exception ex)
            {
                return msg;
            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]

        public static string assignTask(string empid, string date, string projectid, string taskid, string companyid, string createdby, string hours, string remark,string budgethrs)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();
            string msg = "success";
            try
            {
                objts.empid = empid;
                objts.date = date;
                objts.clientid = "";
                objts.projectid = projectid;
                objts.taskid = taskid;
                objts.companyId = companyid;
                objts.CreatedBy = createdby;
                objts.hours = hours;
                objts.nid = "";
                objts.remark = remark;
                objts.budgetedHours = budgethrs;
                objts.action = "insertmultiprojecttask";
                ds = objts.AssignTasks();
                msg = ds.Tables[0].Rows[0]["groupid"].ToString();
                return msg;
            }
            catch (Exception ex)
            {
                msg = ex.Message;
                return msg;
            }
        }

        /// <summary>
        /// This webmethod returns assigned task data as per searching parameter or with nid
        /// Here sno parameter indicates the last sno of previously fecthed record, so we can get data after the given sno (to reduce data load in fetching data)
        /// </summary>
        /// <param name="nid"></param>
        /// <param name="empid"></param>
        /// <param name="status"></param>
        /// <param name="clientid"></param>
        /// <param name="projectid"></param>
        /// <param name="taskid"></param>
        /// <param name="fromdate"></param>
        /// <param name="todate"></param>
        /// <param name="assignedby"></param>
        /// <returns></returns>

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]

        public static string getassignedtask(string nid, string empid, string status, string clientid, string projectid, string taskid, string fromdate, string todate, string assignedby, string sno, string maxnid)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            GeneralMethod objgen = new GeneralMethod();
            DataSet ds = new DataSet();
            string msg = "failure";
            try
            {

                if (nid != "")
                {
                    objts.nid = nid;
                    objts.action = "selectbygroupid";
                }
                else
                {
                    objts.empid = empid;
                    objts.action = "selectbypaging";
                    objts.nid = "";
                    objts.Status = status;
                    objts.clientid = clientid;
                    objts.projectid = projectid;
                    objts.taskid = taskid;
                    objts.from = fromdate;
                    objts.to = todate;
                    objts.CreatedBy = assignedby;
                    objts.groupid = sno;
                    objts.hours = maxnid;
                }
                ds = objts.AssignTasks();
                string result = objgen.serilizeinJson(ds.Tables[0]);
                if (ds.Tables[1].Rows.Count > 0)
                {
                    int lastindex = result.LastIndexOf(']');
                    string maxid = "";
                    if (ds.Tables[1].Rows[0]["maxnid"] != null && ds.Tables[1].Rows[0]["maxnid"].ToString() != "")
                    {
                        maxid = "{\"maxnid\":" + ds.Tables[1].Rows[0]["maxnid"].ToString() + "}";
                        if (result != "[]")
                        {
                            maxid = "," + maxid;
                        }
                    }
                    result = result.Insert(lastindex, maxid);

                }
                return result;
            }
            catch (Exception ex)
            {
                return msg;
            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string deleteassignedtask(string nid)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
            string msg = "success";
            try
            {
                objts.nid = nid;
                objts.action = "delete";
                objts.AssignTasks();
                return msg;
            }
            catch (Exception ex)
            {
                msg = ex.Message.ToString();
                return msg;
            }
        }

        #endregion

    }
}