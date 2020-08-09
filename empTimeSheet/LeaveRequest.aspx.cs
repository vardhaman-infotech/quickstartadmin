using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Data;
using System.IO;
using System.Web.Services;
using System.Web.Script.Services;

namespace empTimeSheet
{
    public partial class LeaveRequest : System.Web.UI.Page
    {

        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsTimeSheet objts = new ClsTimeSheet();
        ClsPayroll objpayroll = new ClsPayroll();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();
        static DataSet dsexcel = new DataSet();
        excelexport objexcel = new excelexport();
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
               
              
                txtfromdate.Text = System.DateTime.Now.AddDays(-7).ToString("MM/dd/yyyy");
                txttodate.Text = System.DateTime.Now.AddMonths(1).ToString("MM/dd/yyyy");
                txtfromdate.Attributes.Add("readonly", "radonly");
                txttodate.Attributes.Add("readonly", "radonly");
                txtdescription.Attributes.Add("maxlength", "500");
                txtleavedate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");

                if (objda.checkUserInroles("17"))
                {

                    ViewState["add"] = "1";
                    if (Request.QueryString["RequestId"] != null && Request.QueryString["RequestId"].ToString() != "")
                    {
                        hidnid.Value = Request.QueryString["RequestId"].ToString();
                    }
                }
                else
                {
                    ViewState["add"] = null;
                    hidnid.Value = "";
                   
                }

                fillleavetype();
                fillemployee();
                fillgrid();
            }

        }

        // <summary>
        /// Fill Leave Type drop down for seraching
        /// </summary>
        protected void fillleavetype()
        {
            dropleavetype.Items.Clear();
            ddlleavetype.Items.Clear();

            objpayroll.action = "selectleavetype";
            objpayroll.companyid = Session["companyId"].ToString();
            ds = objpayroll.LeaveRequest();

            if (ds.Tables[0].Rows.Count > 0)
            {
                dropleavetype.DataSource = ds;
                dropleavetype.DataTextField = "LeaveType";
                dropleavetype.DataValueField = "nid";
                dropleavetype.DataBind();

                ddlleavetype.DataSource = ds;
                ddlleavetype.DataTextField = "LeaveType";
                ddlleavetype.DataValueField = "nid";
                ddlleavetype.DataBind();
            }

            ListItem li = new ListItem("--All Leave Type--", "");
            dropleavetype.Items.Insert(0, li);
            ListItem li1 = new ListItem("--Select--", "");
            ddlleavetype.Items.Insert(0, li1);

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
                dropemployee.Enabled = false;

            }
            else
            {
                objuser.action = "selectactive";
                objuser.companyid = Session["companyid"].ToString();
                objuser.id = "";
                ds = objuser.ManageEmployee();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    objgen.fillActiveInactiveDDL(ds.Tables[0], dropemployee, "username", "nid");
                    dropemployee.Enabled = true;

                }

                ListItem li = new ListItem("--All Employees--", "");
                dropemployee.Items.Insert(0, li);
                dropemployee.SelectedIndex = 0;
            }
        }



        protected void fillgrid()
        {
            Session["TaskTable"] = null;
           // txtleavedate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");
            objpayroll.Empid = dropemployee.Text;
            objpayroll.from = txtfromdate.Text;

            objpayroll.to = txttodate.Text;
            objpayroll.Status = dropstatus.Text;
            objpayroll.Leavetypeid = dropleavetype.Text;
            objpayroll.companyid = Session["companyid"].ToString();
            objpayroll.action = "select";
            objpayroll.Date = txtleavedate.Text;

            if (txtleavedate.Text == "")
            {
                objpayroll.Date = System.DateTime.Now.ToString("MM/dd/yyyy");
            }
            objpayroll.nid = hidnid.Value;
            objpayroll.loginid = Session["userid"].ToString();
            ds = objpayroll.LeaveRequest();
          

            if (ds.Tables[0].Rows.Count > 0)
            {
                Session["TaskTable"] = ds.Tables[0];

                dgnews.DataSource = ds;
                dgnews.DataBind();
                divnodata.Visible = false;
                dgnews.Visible = true;

                //btnexportcsv.Enabled = true;
            }
            else
            {

                if (IsPostBack)
                {
                    divnodata.Visible = true;
                }
                dgnews.Visible = false;
               // btnexportcsv.Enabled = false;
            }
            if (ds.Tables[1].Rows.Count > 0)
            {
                litpl.Text = ds.Tables[1].Rows[0]["noofpaid"].ToString();

                litapl.Text = ds.Tables[1].Rows[0]["totalacc"].ToString();
                littakenpl.Text = ds.Tables[1].Rows[0]["totalpaid"].ToString();
                littakenupl.Text = ds.Tables[1].Rows[0]["unpaidleave"].ToString();
                litbalancepl.Text = ds.Tables[1].Rows[0]["remAcc"].ToString();
                if (ds.Tables[1].Rows[0]["joindate"].ToString()!="")
                CalendarExtender1.StartDate = (Convert.ToDateTime(ds.Tables[1].Rows[0]["joindate"]));
              
                hidaccleave.Value = ds.Tables[1].Rows[0]["remAcc"].ToString();
                if (ds.Tables[1].Rows[0]["isapppaid"].ToString() == "No")
                {

                    for (int i = 0; i < ddlleavetype.Items.Count; i++)
                    {
                        if (ddlleavetype.Items[i].Value == "1" || ddlleavetype.Items[i].Value == "5")
                        {
                            ddlleavetype.Items[i].Attributes.Add("style","display:none;");
                        }
                    }
                }
                if (txtleavedate.Text == "")
                {
                    litleavestatus.Text = System.DateTime.Now.ToString("MM/dd/yyyy");
                }
                else {
                    litleavestatus.Text = txtleavedate.Text;
                }
              
            }
            dsexcel = ds;
            updatePanelData.Update();

            ScriptManager.RegisterStartupScript(updatePanelData, updatePanelData.GetType(), "key", "<script type='text/javascript'>fixheader();</script>", false);
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
                dgnews.DataSource = dt;
                dgnews.DataBind();
            }

        }


        /// <summary>
        /// Get current sort direction from ViewState[""SortDirection""], and return its reverse for sorting and again assign returned direction to ViewState[""SortDirection""] 
        /// </summary>
        /// <param name=""column""></param>
        /// <returns></returns>"
        /// 
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
        // <summary>
        /// Save New Assigned task
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnsubmit_Click(object sender, EventArgs e)
        {
            objpayroll.nid = hidid.Value;
            objpayroll.Date = txtleavedate.Text;
            objpayroll.NumofDays = txtnoofdays.Text;
            objpayroll.Description = txtdescription.Text;
            objpayroll.Leavetypeid = ddlleavetype.Text;
            if (objpayroll.Leavetypeid == "4" || objpayroll.Leavetypeid == "5" || objpayroll.Leavetypeid == "6")
            {
                hidtodate.Value = txtleavedate.Text;
                objpayroll.NumofDays = "1";
            }

            objpayroll.Empid = Session["userid"].ToString();
            objpayroll.Createdby = Session["userid"].ToString();
            //Used RequestDate parameter for LeaveToDate here
            objpayroll.RequestDate = hidtodate.Value;
            objpayroll.action = "insert";
            objpayroll.companyid = Session["companyid"].ToString();
            ds = objpayroll.LeaveRequest();
            sendemail(ds.Tables[0].Rows[0]["nid"].ToString());
           
            blank();
            fillgrid();
            if(hidid.Value == "")
            GeneralMethod.alert(this.Page, "Leave Request Sent Successfully.");
            else
                GeneralMethod.alert(this.Page, "Leave Request modified Successfully.");

            updatePanelAssign.Update();
        }



        public void blank()
        {
            txtleavedate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");
            txtnoofdays.Text = "";
            txtdescription.Text = "";
            hidid.Value = "";
            hidtodate.Value = "";
            ddlleavetype.SelectedIndex = 0;
            btnsubmit.Text = "Save";
            divtodate.InnerHtml = "";
            divtodate.Style.Add("display", "none");
        }
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            hidnid.Value = "";
            fillgrid();

        }
        protected void dgnews_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.Header)
                e.Row.TableSection = TableRowSection.TableHeader;
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                LinkButton lbtndelete = (LinkButton)e.Row.FindControl("lbtndelete");
                Label ltrcurrentstatus = (Label)e.Row.FindControl("ltrcurrentstatus");
                //LinkButton lbtnstatus = (LinkButton)e.Row.FindControl("lbtnstatus");
                HtmlAnchor lbtnedit = (HtmlAnchor)e.Row.FindControl("lbtnedit");
                LinkButton lbtnapprove = (LinkButton)e.Row.FindControl("lbtnapprove");
                LinkButton lbtnreject = (LinkButton)e.Row.FindControl("lbtnreject");


                if (DataBinder.Eval(e.Row.DataItem, "status").ToString().ToLower() != "pending")
                {
                    lbtnedit.Visible = false;
                    ltrcurrentstatus.Visible = true;
                    //lbtnstatus.Visible = false;
                    lbtnapprove.Visible = false;
                    lbtnreject.Visible = false;
                    ltrcurrentstatus.Text = DataBinder.Eval(e.Row.DataItem, "status").ToString() + " by " + DataBinder.Eval(e.Row.DataItem, "approvedusername").ToString() +
                                            " on " + DataBinder.Eval(e.Row.DataItem, "approveddate").ToString() + " <br/>";
                    // + DataBinder.Eval(e.Row.DataItem, "remark").ToString();
                    if (DataBinder.Eval(e.Row.DataItem, "status").ToString().ToLower() == "approved")
                    {
                        ltrcurrentstatus.Style.Add("color", "green");
                    }
                    else
                    {
                        ltrcurrentstatus.Style.Add("color", "red");
                    }
                    if (ViewState["add"] != null && ViewState["add"].ToString() == "1")
                    {
                        lbtndelete.Visible = true;
                    }
                    else
                    {
                        lbtndelete.Visible = false;
                    }
                }
                else
                {
                    lbtnedit.Visible = true;
                    lbtnedit.Attributes.Add("onclick", "clickedit(" + DataBinder.Eval(e.Row.DataItem, "nid").ToString() + ")");
                    if (ViewState["add"] != null && ViewState["add"].ToString() == "1")
                    {
                        //lbtnstatus.Visible = true;
                        lbtnapprove.Visible = true;
                        lbtnreject.Visible = true;
                        //ltrcurrentstatus.Text = "";
                        ltrcurrentstatus.Visible = false;
                    }
                    else
                    {
                        ltrcurrentstatus.Visible = true;
                        lbtnapprove.Visible = false;
                        lbtnreject.Visible = false;
                    }




                }
            }
        }
        /// <summary>
        /// event fires when clicks to Edit/Delete in List
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void PaggedGridbtnedit_Click(object sender, EventArgs e)
        {
           
            objpayroll.nid = hidid.Value;
            objpayroll.action = "select";
            ds = objpayroll.LeaveRequest();
            txtleavedate.Text = ds.Tables[0].Rows[0]["LeaveDate"].ToString();
            txtnoofdays.Text = ds.Tables[0].Rows[0]["NumOfDays"].ToString();
            txtdescription.Text = ds.Tables[0].Rows[0]["Description"].ToString();
            ddlleavetype.Text = ds.Tables[0].Rows[0]["LeaveTypeid"].ToString();
            hidtodate.Value = ds.Tables[0].Rows[0]["LeaveToDate"].ToString();
            if (ds.Tables[0].Rows[0]["LeaveTypeid"].ToString() == "4" || ds.Tables[0].Rows[0]["LeaveTypeid"].ToString() == "5" || ds.Tables[0].Rows[0]["LeaveTypeid"].ToString() == "6")
            {
                divnumofdays.Style.Add("display", "none");
                divtodate.Style.Add("display", "none");
            }
            else
            {
                divnumofdays.Style.Add("display", "block");
                divtodate.Style.Add("display", "block");
                if (ds.Tables[0].Rows[0]["LeaveToDate"].ToString() == ds.Tables[0].Rows[0]["LeaveDate"].ToString())
                    divtodate.InnerHtml = "You are requesting leave for <b>  " + ds.Tables[0].Rows[0]["LeaveDate"].ToString() + "</b>";
                else
                    divtodate.InnerHtml = "You are requesting leave from <b>  " + ds.Tables[0].Rows[0]["LeaveDate"].ToString() + "</b> to <b>" + ds.Tables[0].Rows[0]["LeaveToDate"].ToString() + "</b>";

            }
            btnsubmit.Text = "Update";

            ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);
            updatePanelAssign.Update();
        }
        
        protected void dgnews_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "edititem")
            {
               


            }
            if (e.CommandName == "Approved" || e.CommandName == "Rejected")
            {

                // hidid.Value = e.CommandArgument.ToString();
                //objpayroll.action = "select";
                //objpayroll.nid = hidid.Value;
                //ds = objpayroll.LeaveRequest();
                //if (ds.Tables[0].Rows[0]["Leavedate"].ToString() == ds.Tables[0].Rows[0]["LeaveToDate"].ToString())
                //{
                //    ltrdate.Text = ds.Tables[0].Rows[0]["Leavedate"].ToString();
                //}
                //else
                //    ltrdate.Text = ds.Tables[0].Rows[0]["Leavedate"].ToString() + " - " + ds.Tables[0].Rows[0]["LeaveToDate"].ToString();
                //ltrempname.Text = ds.Tables[0].Rows[0]["empname"].ToString();
                //ltrstatus.Text = e.CommandArgument.ToString();
                //ltrrequestdate.Text = ds.Tables[0].Rows[0]["requestdate"].ToString();
                //fillgrid();
                //ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>openstatusdiv();</script>", false);
                objpayroll.nid = e.CommandArgument.ToString();
                objpayroll.Createdby = Session["userid"].ToString();
                objpayroll.action = "setstatus";
                objpayroll.Status = e.CommandName.ToString();
                objpayroll.Remark = "";
                objpayroll.LeaveRequest();
                sendstatusemail(e.CommandArgument.ToString());
                fillgrid();               
                updatePanelStatus.Update();
            }
            if (e.CommandName == "del")
            {
                objpayroll.nid = e.CommandArgument.ToString();
                objpayroll.action = "delete";
                objpayroll.LeaveRequest();
                fillgrid();
            }


        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]

        public static string getLeaveToDate(string LeaveDate, string NumOfDays, string empid)
        {
            string msg = "";
            msg = "success";
            if (LeaveDate != "" && NumOfDays != "")
            {
                ClsPayroll objpayroll = new ClsPayroll();
                DataSet ds = new DataSet();

                objpayroll.action = "getLeaveToDate";
                objpayroll.Date = LeaveDate;
                objpayroll.NumofDays = NumOfDays;
                objpayroll.Empid = empid;
                try
                {
                    ds = objpayroll.LeaveRequest();
                    if (LeaveDate != ds.Tables[0].Rows[0]["LeaveDate"].ToString())
                    {
                        msg = "fail";
                    }
                    else
                    {
                        msg = ds.Tables[0].Rows[0]["LeaveToDate"].ToString();
                    }
                    return msg;
                }
                catch (Exception ex)
                {
                    msg = ex.Message;
                    return msg;
                }
            }
            else
            {
                return msg;
            }

        }
        protected void btnsave_Click(object sender, EventArgs e)
        {
            objpayroll.nid = hidid.Value;
            objpayroll.Createdby = Session["userid"].ToString();
            objpayroll.action = "setstatus";
            objpayroll.Status = ddlstaus.Text;
            objpayroll.Remark = "";
            objpayroll.LeaveRequest();
            // txtremark.Text = "";
            ddlstaus.SelectedIndex = 0;
            fillgrid();
            GeneralMethod.alert(this.Page, "Leave's status updated successfully");

        }

        protected void btnrefresh_Click(object sender, EventArgs e)
        {
            fillgrid();
        }


        #region Export
        protected string bindheader(string type)
        {
            string str = "";
            string Companyname = objda.GetCompanyProperty("CompanyName");
            string companyaddress = Session["companyaddress"].ToString();
            string Status = "<b>Client:</b> ", employee = "<b>Employee:</b> ", LeaveType = "<b>Task:</b> ", status = "<b>Status:</b> ", date = "<b>Date:</b> ";
            if (dropstatus.Text == "")
            {
                Status += "All";
            }
            else
            {
                Status += dropstatus.SelectedItem.Text;
            }
            if (dropemployee.Text == "")
            {
                employee += "All";
            }
            else
            {
                employee += dropemployee.SelectedItem.Text;
            }
            if (dropstatus.Text == "")
            {
                status += "All";
            }
            else
            {
                status += dropstatus.SelectedItem.Text;
            }

            if (txtfromdate.Text != txttodate.Text)
            {
                date += txtfromdate.Text + " - " + txttodate.Text;
            }
            else
            {
                date += txtfromdate.Text;
            }
            string headerstr = "<table width='100%'>";
            if (type == "excel")
            {
                headerstr = "<table width='100%'>";

            }

            str = headerstr +
        @"<tr>
            <td colspan='11' align='center'>
                <h2>
                   " + Companyname + @"
                </h2>
            </td>
        </tr>
<tr>
            <td colspan='11' align='left'>
                <h4>
                   " + companyaddress + @"
                </h4>
            </td>
        </tr>
        <tr>
            <td colspan='11' align='center'>
                <h4>
                    Leaves Request Report
                </h4>
            </td>
        </tr>
        <tr>
            <td colspan='11'>
                &nbsp;
            </td>
        </tr>
       
        <tr>
        <td colspan='11'>
        " + date + "<br/>" + employee + "<br/>" + LeaveType + "<br/>" + status +

       @"</td>

        </tr>
       <tr>
        <td colspan='11'>&nbsp;</td></tr>
       </table><table width='100%' cellpadding='5' cellspacing='0' style='font-family: Calibri;   font-size: 12px; text-align: left;' border='0'>
                       
                         
  <tr style='font-weight: bold; background: #395ba4; color: #ffffff;'>
 <td>S.No.</td>
 <td>Employee</td>
<td>From Date</td>
 <td>To Date</td>
 <td>Days</td>
 <td>Leave Type</td>
  <td>Description</td>
 <td>Requested Date</td>
<td>Status</td>
<td>Approved By</td>
<td>Approved Date</td>                                                          
</tr>";
            return str;


        }
        protected void btnexportcsv_Click(object sender, EventArgs e)
        {

            fillgrid();
            string rpthtml = bindheader("excel");
            for (int i = 0; i < dsexcel.Tables[0].Rows.Count; i++)
            {

                rpthtml = rpthtml + "<tr><td>" + Convert.ToString(i + 1) + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["empname"].ToString() + "</td>"
                + "<td>" + dsexcel.Tables[0].Rows[i]["Leavedate"].ToString() + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["LeaveTodate"].ToString() +
               "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["NumOfDays"].ToString() + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["LeaveType"].ToString() + "</td>"
                + "<td>" + dsexcel.Tables[0].Rows[i]["Description"].ToString() + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["RequestDate"].ToString() + "</td>" +
              "<td>" + dsexcel.Tables[0].Rows[i]["status"].ToString() + "</td><td>" + dsexcel.Tables[0].Rows[i]["approvedusername"].ToString() + "</td><td>" + dsexcel.Tables[0].Rows[i]["ApprovedDate"].ToString() + "</td></tr>";
            }

            HtmlGenericControl divgen = new HtmlGenericControl();


            divgen.InnerHtml = rpthtml;
            HttpResponse response = HttpContext.Current.Response;

            // first let's clean up the response.object   
            response.Clear();
            response.Charset = "";

            // set the response mime type for excel   
            response.ContentType = "application/vnd.ms-excel";
            response.AddHeader("Content-Disposition", "attachment;filename=\"LeavesReport.xls\"");

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
        #endregion

        /// <summary>
        /// Send mail when staus has changed
        /// </summary>
        /// <param name="date"></param>
        /// <param name="client"></param>
        /// <param name="hidstatus"></param>
        /// <param name="newstatus"></param>
        protected void sendstatusemail(string id)
        {

            string bccemail = "";
            string cc = "";
            string bcc = bccemail;
            string filename = "";
            string date = "";
            string receiver = "";
            //Get users who have Access to Add Schedule to Send Email CC
            cc = objda.GetCompanyProperty("ReceiverMail") + ",";

            objpayroll.action = "selectleavemanager";
            objpayroll.companyid = Session["companyid"].ToString();
           
            ds = objpayroll.LeaveRequest();
            if (ds != null)
            {
                if (ds.Tables[1].Rows.Count > 0)
                {
                    if (ds.Tables[1].Rows[0]["EmailCC"] != null)
                    {
                        cc = ds.Tables[1].Rows[0]["EmailCC"].ToString();
                    }

                }
                if (ds.Tables.Count > 1)
                {
                    if (ds.Tables[2].Rows.Count > 0)
                    {
                        if (ds.Tables[2].Rows[0]["manageremail"].ToString() != "")
                        {
                            receiver = ds.Tables[2].Rows[0]["manageremail"].ToString() + ",";
                        
                        }
                    
                    }
                }
            }
         
            objpayroll.nid = id;
            objpayroll.action = "select";
            ds = objpayroll.LeaveRequest();
            if (ds.Tables[0].Rows.Count > 0)
            {
                string subject = ds.Tables[0].Rows[0]["status"].ToString() + " Leave";
               

                string HTMLTemplatePath = Server.MapPath("EmailTemplates/LeaveStatus.html");

                string HTMLBODY = File.ReadAllText(HTMLTemplatePath);


                 receiver += ds.Tables[0].Rows[0]["emailid"].ToString() + ",";
            
               
                if (ds.Tables[0].Rows[0]["LeaveDate"].ToString() == ds.Tables[0].Rows[0]["LeaveToDate"].ToString())
                {
                    date = "for " + ds.Tables[0].Rows[0]["LeaveDate"].ToString();
                }
                else
                {
                    date = " from " + ds.Tables[0].Rows[0]["LeaveDate"].ToString() + "-" + ds.Tables[0].Rows[0]["LeaveToDate"].ToString() + " to ";
                }
                HTMLBODY = HTMLBODY.Replace("##empname##", ds.Tables[0].Rows[0]["empname"].ToString());
              
                HTMLBODY = HTMLBODY.Replace("##requestid##", ds.Tables[0].Rows[0]["nid"].ToString());               
                HTMLBODY = HTMLBODY.Replace("##date##", date);
                HTMLBODY = HTMLBODY.Replace("##status##", ds.Tables[0].Rows[0]["status"].ToString());
                HTMLBODY = HTMLBODY.Replace("##site##", ds.Tables[0].Rows[0]["schedulerURL"].ToString());
                HTMLBODY = HTMLBODY.Replace("##approvedusername##", ds.Tables[0].Rows[0]["approvedusername"].ToString());

                objda.SendEmail(receiver, subject, HTMLBODY, cc, bcc, filename);

            }
        }


        /// <summary>
        /// Send mail when staus has changed
        /// </summary>
        /// <param name="date"></param>
        /// <param name="client"></param>
        /// <param name="hidstatus"></param>
        /// <param name="newstatus"></param>
        protected void sendemail(string id)
        {

            string bccemail = "";
            string cc = "";
            string bcc = bccemail;
            string filename = "";
            string date = "";
            string receiver = "";
            //Get users who have Access to Add Schedule to Send Email CC
            cc = objda.GetCompanyProperty("ReceiverMail") + ",";

            objpayroll.action = "selectleavemanager";
            objpayroll.companyid = Session["companyid"].ToString();
            objpayroll.nid = id;
            ds = objpayroll.LeaveRequest();
            if (ds != null)
            {
                if (ds.Tables[1].Rows.Count > 0)
                {
                    if (ds.Tables[1].Rows[0]["EmailCC"] != null)
                    {
                        cc = ds.Tables[1].Rows[0]["EmailCC"].ToString();
                    }

                }
                if (ds.Tables.Count > 1)
                {
                    if (ds.Tables[2].Rows.Count > 0)
                    {
                        if (ds.Tables[2].Rows[0]["manageremail"].ToString() != "")
                        {
                            receiver = ds.Tables[2].Rows[0]["manageremail"].ToString() + ",";

                        }

                    }
                }
            }
         

            objpayroll.nid = id;
            objpayroll.action = "select";
            ds = objpayroll.LeaveRequest();
            if (ds.Tables[0].Rows.Count > 0)
            {
                string subject = "Employee Leave Request";
                if (hidid.Value != "")
                    subject = "Employee Leave Request Modified";

                receiver += ds.Tables[0].Rows[0]["emailid"].ToString() + ",";

                string HTMLTemplatePath = Server.MapPath("EmailTemplates/LeaveRequest.html");

                string HTMLBODY = File.ReadAllText(HTMLTemplatePath);

                if (ds.Tables[0].Rows[0]["LeaveDate"].ToString() == ds.Tables[0].Rows[0]["LeaveToDate"].ToString())
                {
                    date = "for " + ds.Tables[0].Rows[0]["LeaveDate"].ToString();
                }
                else
                {
                    date = " from " + ds.Tables[0].Rows[0]["LeaveDate"].ToString() + " to " + ds.Tables[0].Rows[0]["LeaveToDate"].ToString();
                }
                HTMLBODY = HTMLBODY.Replace("##empname##", ds.Tables[0].Rows[0]["empname"].ToString());
                HTMLBODY = HTMLBODY.Replace("##numofdays##", ds.Tables[0].Rows[0]["numofdays"].ToString());
                HTMLBODY = HTMLBODY.Replace("##leavetype##", ds.Tables[0].Rows[0]["LeaveType"].ToString());
                HTMLBODY = HTMLBODY.Replace("##empid##", ds.Tables[0].Rows[0]["emploginid"].ToString());
                HTMLBODY = HTMLBODY.Replace("##requestid##", ds.Tables[0].Rows[0]["nid"].ToString());

                HTMLBODY = HTMLBODY.Replace("##site##", ds.Tables[0].Rows[0]["schedulerURL"].ToString());
              

                HTMLBODY = HTMLBODY.Replace("##date##", date);
                HTMLBODY = HTMLBODY.Replace("##LeaveType##", ds.Tables[0].Rows[0]["LeaveType"].ToString());

                HTMLBODY = HTMLBODY.Replace("##description##", ds.Tables[0].Rows[0]["description"].ToString());

                objda.SendEmail(receiver, subject, HTMLBODY, cc, bcc, filename);

            }
        }

        protected void txtleavedate_TextChanged(object sender, EventArgs e)
        {
            //txtleavedate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");

            DateTime leavedate;
            if (!DateTime.TryParseExact(txtleavedate.Text, "MM/dd/yyyy",
                                   System.Globalization.CultureInfo.InvariantCulture,
                                        System.Globalization.DateTimeStyles.None,
                                    out leavedate))
            {
                txtleavedate.Text = GeneralMethod.getLocalDate();
                ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>alert('Invalid Date');</script>", false);
                updateleavestatus.Update();
                return;
            }
         

            objpayroll.Empid = "";
            objpayroll.from = "";

            objpayroll.to = "";
            objpayroll.Status ="";
            objpayroll.Leavetypeid = "";
            objpayroll.companyid = Session["companyid"].ToString();
            objpayroll.action = "getleavedetail";
            objpayroll.RequestDate = txtleavedate.Text;

            if (txtleavedate.Text == "")
            {
                objpayroll.Date = System.DateTime.Now.ToString("MM/dd/yyyy");
            }
            else
            {
                objpayroll.Date = txtleavedate.Text;
            }
            objpayroll.nid = "";
            objpayroll.loginid = Session["userid"].ToString();
            ds = objpayroll.LeaveRequest();

            if (ds.Tables[0].Rows.Count > 0)
            {
                litpl.Text = ds.Tables[0].Rows[0]["noofpaid"].ToString();

                litapl.Text = ds.Tables[0].Rows[0]["totalacc"].ToString();
                littakenpl.Text = ds.Tables[0].Rows[0]["totalpaid"].ToString();
                littakenupl.Text = ds.Tables[0].Rows[0]["unpaidleave"].ToString();
                litbalancepl.Text = ds.Tables[0].Rows[0]["remAcc"].ToString();


             

                hidaccleave.Value = ds.Tables[0].Rows[0]["remAcc"].ToString();
                if (ds.Tables[0].Rows[0]["isapppaid"].ToString() == "No")
                {

                    for (int i = 0; i < ddlleavetype.Items.Count; i++)
                    {
                        if (ddlleavetype.Items[i].Value == "1" || ddlleavetype.Items[i].Value == "5")
                        {
                            ddlleavetype.Items[i].Attributes.Add("style", "display:none;");
                        }
                    }
                }

                if (txtleavedate.Text == "")
                {
                    litleavestatus.Text = System.DateTime.Now.ToString("MM/dd/yyyy");
                }
                else
                {
                    litleavestatus.Text = txtleavedate.Text;
                }
                updateleavestatus.Update();
                ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>resetleave();</script>", false);
            }


        }
    }

}




