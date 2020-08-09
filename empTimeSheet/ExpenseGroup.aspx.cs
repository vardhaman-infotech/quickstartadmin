﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.UI.HtmlControls;
using System.IO;

namespace empTimeSheet
{
    public partial class ExpenseGroup : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsTimeSheet objts = new ClsTimeSheet();
        ClsUser objuser = new ClsUser();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();
        DataSet dsexcel = new DataSet();
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();

            if (!IsPostBack)
            {
                if (Session["usertype"].ToString() == "Admin")
                {
                    ViewState["view"] = "1";
                    ViewState["add"] = "1";
                }
                else
                {
                    System.Data.DataSet ds = new System.Data.DataSet();
                    objda.id = Session["userid"].ToString();
                    ds = objda.getUserInRoles();

                    //if (!objda.validatedRoles("27", ds) && !objda.validatedRoles("28", ds))
                    //{
                    //    Response.Redirect("UserDashboard.aspx");
                    //}
                    if (!objda.validatedRoles("33", ds) && !objda.validatedRoles("34", ds))
                    {
                        Response.Redirect("UserDashboard.aspx");
                    }
                    if (objda.validatedRoles("33", ds))
                    {
                        ViewState["add"] = "1";

                    }
                    else
                    {
                        liaddnew.Visible = false;
                        ViewState["add"] = null;

                    }
                    if (objda.validatedRoles("34", ds))
                    {
                        ViewState["view"] = "1";
                    }
                    else
                    {
                        ViewState["view"] = null;
                    }
                }
                fillexpenses();
                fillpopexpense();
                filladdemployees();
                searchdata();

            }

        }
        /// <summary>
        /// Fill TASKS List boxes
        /// </summary>
        protected void fillpopexpense()
        {
            listcode2.Items.Clear();
            listcode1.Items.Clear();
            objts.name = "";
            objts.action = "select";
            objts.companyId = Session["companyid"].ToString();
            objts.nid = "";

            objts.deptID = "";
            objts.type = "Expense";
            ds = objts.ManageTasks();
            listcode1.DataSource = ds;
            listcode1.DataTextField = "taskcodename";
            listcode1.DataValueField = "nid";
            listcode1.DataBind();


            int count = listcode1.Items.Count;
            string[] clientval = hidclients.Value.Split(',');
            string[] clientname = hidclientname.Value.Split(',');
            for (int i = 0; i < clientval.Length - 1; i++)
            {
                ListItem li = new ListItem(clientname[i], clientval[i]);
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
        /// Fill TASKS List boxes
        /// </summary>
        protected void filladdemployees()
        {
            listavailcode2.Items.Clear();
            listavailcode1.Items.Clear();
            objuser.action = "selectactive";

            objuser.name = "";
            objuser.id = "";
            objuser.companyid = Session["companyId"].ToString();
            ds = objuser.ManageEmployee();

            listavailcode1.DataSource = ds;
            listavailcode1.DataTextField = "username";
            listavailcode1.DataValueField = "nid";
            listavailcode1.DataBind();


            int count = listavailcode1.Items.Count;
            string[] groupval = hidgroupid.Value.Split(',');
            string[] groupname = hidgroupname.Value.Split(',');
            for (int i = 0; i < groupval.Length - 1; i++)
            {
                ListItem li = new ListItem(groupname[i], groupval[i]);
                listavailcode2.Items.Add(li);
            }

            int count2 = listavailcode2.Items.Count;
            for (int i = 0; i < count; i++)
            {
                for (int j = 0; j < count2; j++)
                {
                    //Remove the expenses from Listcode1 those are already exists in group
                    if (listavailcode1.Items[i].Value == listavailcode2.Items[j].Value)
                    {
                        listavailcode1.Items.RemoveAt(i);
                        count = listavailcode1.Items.Count;
                        i = i - 1;
                        break;
                    }
                }
            }
        }

        /// <summary>
        /// Fill list of existing clients For Search
        /// </summary>
        protected void fillexpenses()
        {
            dropExpense.Items.Clear();
            objts.name = "";
            objts.action = "select";
            objts.companyId = Session["companyid"].ToString();
            objts.nid = "";
            objts.deptID = "";
            objts.type = "Expense";
            ds = objts.ManageTasks();
        
            if (ds.Tables[0].Rows.Count > 0)
            {
                dropExpense.DataSource = ds;
                dropExpense.DataTextField = "taskcodename";
                dropExpense.DataValueField = "nid";
                dropExpense.DataBind();
            }

            ListItem li = new ListItem("--All Expense--", "");
            dropExpense.Items.Insert(0, li);

        }



        protected void searchdata()
        {
            hidsearchtitle.Value = txtsearch.Text;
            hidsearchclientid.Value = dropExpense.Text;
            hidsearchclientname.Value = dropExpense.SelectedItem.Text;
            fillgrid();
        }

        /// <summary>
        /// Fill list of existing client groups
        /// </summary>
        protected void fillgrid()
        {
            Session["TaskTable"] = null;
            if (ViewState["view"] != null)
                objts.action = "select";
            else
                objts.action = "selectbyuser";

            objts.nid = "";
            objts.CreatedBy = Session["userid"].ToString();
            objts.taskid = hidsearchclientid.Value;
            objts.name = hidsearchtitle.Value;
            objts.companyId = Session["companyid"].ToString();
            ds = objts.ManageExpenseGroup();
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
                // btnexportcsv.Enabled = true;

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
            // updatePanelData.Update();
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

        protected void dgnews_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {

                if (DataBinder.Eval(e.Row.DataItem, "createdby").ToString() != Session["userid"].ToString())
                {
                    LinkButton lbtnedit = (LinkButton)e.Row.FindControl("lbtnedit");
                    LinkButton lbtnsettings = (LinkButton)e.Row.FindControl("lbtnsetting");

                    LinkButton lbtndelete = (LinkButton)e.Row.FindControl("lbtndelete");
                    lbtnedit.Visible = false;
                    lbtndelete.Visible = false;
                    lbtnsettings.Visible = false;

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
                objts.ManageExpenseGroup();
                fillgrid();
            }
            if (e.CommandName.ToLower() == "edititem")
            {
                hidid.Value = e.CommandArgument.ToString();
                hidclients.Value = "";
                hidclientname.Value = "";
                fillexpensegroup();
                ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);
            }
            if (e.CommandName.ToLower() == "view")
            {
                hidid.Value = e.CommandArgument.ToString();
                ds = getdetails();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    ltrcreatedby.Text = ds.Tables[0].Rows[0]["username"].ToString();
                    ltrcreationdate.Text = ds.Tables[0].Rows[0]["creationdate"].ToString();
                    ltrgrouptitle.InnerHtml = ds.Tables[0].Rows[0]["grouptitle"].ToString();
                }
                if (ds.Tables[1].Rows.Count > 0)
                {
                    rptstatus.DataSource = ds.Tables[1];
                    rptstatus.DataBind();
                    divnodataforstatus.Visible = false;
                }
                else
                {
                    rptstatus.DataSource = null;
                    rptstatus.DataBind();
                    divnodataforstatus.Visible = true;
                }

                updatePanelStatus.Update();
                hidcurrentview.Value = "detail";
                multiview1.ActiveViewIndex = 1;

            }
            if (e.CommandName.ToLower() == "settings")
            {
                hidgroupid.Value = "";
                hidgroupname.Value = "";
                hidid.Value = e.CommandArgument.ToString();
                ds = getdetails();

                ltravailtogrouptitle.Text = ds.Tables[0].Rows[0]["grouptitle"].ToString();
                ltravailtocreatedby.Text = ds.Tables[0].Rows[0]["username"].ToString();
                ltravailtocreationdate.Text = ds.Tables[0].Rows[0]["creationdate"].ToString();

                if (ds.Tables[2].Rows.Count > 0)
                {

                    listavailcode2.DataTextField = "empname";
                    listavailcode2.DataValueField = "empid";
                    listavailcode2.DataSource = ds.Tables[2];
                    listavailcode2.DataBind();
                    int count = listavailcode1.Items.Count;
                    for (int j = 0; j < ds.Tables[2].Rows.Count; j++)
                    {
                        hidgroupid.Value = hidgroupid.Value + ds.Tables[2].Rows[j]["empid"].ToString() + ",";
                        hidgroupname.Value = hidgroupname.Value + ds.Tables[2].Rows[j]["empname"].ToString() + ",";
                    }
                    for (int i = 0; i < count; i++)
                    {
                        for (int j = 0; j < ds.Tables[2].Rows.Count; j++)
                        {
                            //Remove the expenses from Listcode1 those are already exists in group
                            if (listavailcode1.Items[i].Value == ds.Tables[2].Rows[j]["empid"].ToString())
                            {
                                listavailcode1.Items.RemoveAt(i);
                                count = listavailcode1.Items.Count;
                                i = i - 1;
                                break;
                            }
                        }
                    }

                }


                ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opensettingsdiv();</script>", false);

            }
        }
        protected DataSet getdetails()
        {
            objts.nid = hidid.Value;
            objts.name = "";
            objts.type = "Expense";
            objts.companyId = Session["companyid"].ToString();
            objts.action = "selectbygroup";
            ds = objts.ManageExpenseGroup();

            return ds;

        }
        /// <summary>
        /// Fill the existing expenses of selected group
        /// </summary>
        protected void fillexpensegroup()
        {
            fillpopexpense();
           
            ds = getdetails();
            if (ds.Tables[0].Rows.Count > 0)
            {
                txtgroup.Text = ds.Tables[0].Rows[0]["grouptitle"].ToString();
            }

            if (ds.Tables[1].Rows.Count > 0)
            {
                listcode2.DataTextField = "taskcodename";
                listcode2.DataValueField = "expenseid";
                listcode2.DataSource = ds.Tables[1];
                listcode2.DataBind();
                int count = listcode1.Items.Count;
                for (int j = 0; j < ds.Tables[1].Rows.Count; j++)
                {
                    hidclients.Value = hidclients.Value + ds.Tables[1].Rows[j]["expenseid"].ToString() + ",";
                    hidclientname.Value = hidclientname.Value + ds.Tables[1].Rows[j]["taskcodename"].ToString() + ",";
                }
                for (int i = 0; i < count; i++)
                {
                    for (int j = 0; j < ds.Tables[1].Rows.Count; j++)
                    {
                        //Remove the expenses from Listcode1 those are already exists in group
                        if (listcode1.Items[i].Value == ds.Tables[1].Rows[j]["expenseid"].ToString())
                        {
                            listcode1.Items.RemoveAt(i);
                            count = listcode1.Items.Count;
                            i = i - 1;
                            break;
                        }
                    }
                }
            }
            // updatePanelAssign.Update();

        }

        /// <summary>
        /// Save New Assigned task
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnsubmit_Click(object sender, EventArgs e)
        {

            objts.taskid = hidclients.Value;
            objts.name = txtgroup.Text;
            objts.companyId = Session["companyid"].ToString();
            objts.CreatedBy = Session["userid"].ToString();
            objts.nid = hidid.Value;
            objts.action = "insert";
            ds = objts.ManageExpenseGroup();
            if (ds.Tables[0].Rows.Count > 0)
            {
                if (ds.Tables[0].Rows[0][0].ToString() == "failure")
                {
                    GeneralMethod.alert(this, "Group title alreay exists, please try again!");
                    ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);

                    txtgroup.Focus();
                    return;
                }
                GeneralMethod.alert(this, "Saved successfully");
                blank();
                fillpopexpense();
                searchdata();
                // updatePanelAssign.Update();
            }

        }

        /// <summary>
        /// Reset values of new Assign task POP UP
        /// </summary>
        protected void blank()
        {
            hidclients.Value = "";
            hidclientname.Value = "";
            txtgroup.Text = "";
            hidid.Value = "";

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


        #region EXPORT TO EXCEL
        protected void btnexportcsv_Click(object sender, EventArgs e)
        {
            string rpthtml = "";
            if (hidcurrentview.Value == "detail")
            {
                dsexcel = getdetails();
                rpthtml = binddetailheader("excel");

                for (int i = 0; i < dsexcel.Tables[1].Rows.Count; i++)
                {
                    rpthtml = rpthtml + "<tr><td>" + Convert.ToString(i + 1) + "</td>" + "<td>" + dsexcel.Tables[1].Rows[i]["taskcodename"].ToString() +
                        "</td><td>" + dsexcel.Tables[1].Rows[i]["taskname"].ToString() +

                       "</td></tr>";
                }
            }
            else
            {
                fillgrid();
                rpthtml = bindlistviewheader("excel");

                for (int i = 0; i < dsexcel.Tables[0].Rows.Count; i++)
                {
                    rpthtml = rpthtml + "<tr><td>" + Convert.ToString(i + 1) + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["grouptitle"].ToString() +
                        "</td><td>" + dsexcel.Tables[0].Rows[i]["numofexpenses"].ToString() +
                        "</td><td>" + dsexcel.Tables[0].Rows[i]["username"].ToString() + "</td><td>" + dsexcel.Tables[0].Rows[i]["creationdate"].ToString()
                      + "</td></tr>";
                }
            }
            HtmlGenericControl divgen = new HtmlGenericControl();

            divgen.InnerHtml = rpthtml;

            HttpResponse response = HttpContext.Current.Response;

            // first let's clean up the response.object   
            response.Clear();
            response.Charset = "";

            // set the response mime type for excel   
            response.ContentType = "application/vnd.ms-excel";
            response.AddHeader("Content-Disposition", "attachment;filename=\"HCLLPExpenseGroup-Report.xls\"");

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
        protected string bindlistviewheader(string type)
        {
            string Companyname = Session["companyname"].ToString();

            string str = "";
            string expense = "<b>Expense:</b> ", Keyword = "<b>Keyword:</b>";
            if (hidsearchclientid.Value == "")
            {
                expense += "All";
            }
            else
            {
                expense += hidsearchclientname.Value;
            }
            Keyword = hidsearchtitle.Value;
            string headerstr = "<table width='100%'>";
            if (type == "excel")
            {
                headerstr = "<table width='100%' border='1'>";

            }

            str = headerstr +
         @"<tr>
            <td colspan='5' align='center'>
                <h2>
                    " + Companyname + @"
                </h2>
            </td>
        </tr>
        <tr>
            <td colspan='5' align='center'>
                <h4>
                    Expense Groups Report
                </h4>
            </td>
        </tr>
        <tr>
            <td colspan='5'>
                &nbsp;
            </td>
        </tr>
       
        <tr>
        <td colspan='5'>
        " + expense + "<br/>" + Keyword + "<br/>" +



        @"</td>

        </tr>
       <tr>
        <td colspan='5'>&nbsp;</td></tr>
       </table>

        <table align='left' cellpadding='5' width='100%' cellspacing='0' style='font-family: Calibri;
         font-size: 12px; text-align: left;' border='0'> 
         <tr style='font-weight: bold; background: #395ba4; color: #ffffff;'>
        <td style='width=38px;'width='100px'>S.No</td>
        <td>Group Title</td>
        <td>No. of Projects</td>
        <td>Created By</td>
        <td>Creation Date</td>
                                                                                                                                                                                                                                                   
        </tr>";

            return str;

        }


        protected string binddetailheader(string type)
        {
            string Companyname = Session["companyname"].ToString();

            string str = "";
            string grouptitle = "<b>Title:</b> ", createdby = "<b>Created By:</b>", creationdate = "<b>Creation Date:</b>";
            grouptitle = grouptitle + dsexcel.Tables[0].Rows[0]["grouptitle"].ToString();
            createdby = createdby + dsexcel.Tables[0].Rows[0]["username"].ToString();
            creationdate = creationdate + dsexcel.Tables[0].Rows[0]["creationdate"].ToString();

            string headerstr = "<table width='100%'>";
            if (type == "excel")
            {
                headerstr = "<table width='100%' border='1'>";

            }

            str = headerstr +
         @"<tr>
            <td colspan='3' align='center'>
                <h2>
                    " + Companyname + @"
                </h2>
            </td>
        </tr>
        <tr>
            <td colspan='3' align='center'>
                <h4>
                    Expense Group Detail Report
                </h4>
            </td>
        </tr>
        <tr>
            <td colspan='3'>
                &nbsp;
            </td>
        </tr>
       
        <tr>
        <td colspan='3'>
        " + grouptitle + "<br/>" + createdby + "<br/>" + creationdate + "<br/>" +



        @"</td>

        </tr>
       <tr>
        <td colspan='3'>&nbsp;</td></tr>
       </table>

        <table align='left' cellpadding='5' width='100%' cellspacing='0' style='font-family: Calibri;
         font-size: 12px; text-align: left;' border='0'> 
         <tr style='font-weight: bold; background: #395ba4; color: #ffffff;'>
        <td style='width=38px;'width='100px'>S.No</td>
        <td>Project ID</td>
        <td>Project  Name</td>
    
                                                                                                                                                                                                                                                   
        </tr>";

            return str;

        }
        #endregion

        protected void btnback_Click(object sender, EventArgs e)
        {
            hidid.Value = "";
            hidcurrentview.Value = "list";
            multiview1.ActiveViewIndex = 0;
        }

        protected void btnsettings_Click(object sender, EventArgs e)
        {
            objts.nid = hidid.Value;
            objts.taskid = hidgroupid.Value;
            objts.action = "updatesettings";
            objts.ManageExpenseGroup();
            blank();
        }
    }
}