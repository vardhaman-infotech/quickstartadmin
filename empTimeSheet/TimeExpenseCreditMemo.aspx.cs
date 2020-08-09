using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.IO;
using System.Web.UI.HtmlControls;

namespace empTimeSheet
{
    public partial class TimeExpenseCreditMemo : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds1 = new DataSet();
        DataSet ds = new DataSet();
        DataSet dsexcel = new DataSet();
        decimal totalhrs = 0, totalbhrs = 0, totalcost = 0, totalamount = 0;
        decimal emptotalhrs = 0, emptotalbhrs = 0, emptotalcost = 0, emptotalamount = 0;
        decimal ptotalhrs = 0, ptotalbhrs = 0, ptotalcost = 0, ptotalamount = 0;
        decimal ctotalhrs = 0, ctotalbhrs = 0, ctotalcost = 0, ctotalamount = 0;

        string loginid = "",projectid="",clientid="";
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();

            if (!IsPostBack)
            {

                if (!objda.checkUserInroles("8"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }

                txtfrmdate.Text = Convert.ToDateTime(GeneralMethod.getLocalDate()).AddDays(-7).ToString("MM/dd/yyyy");
                txttodate.Text = GeneralMethod.getLocalDate();

                fillclient();
                fillproject();
                fillemployee();
                // searchdata();
            }
        }

        /// <summary>
        /// Fill list of existing clients For Search
        /// </summary>
        public void fillclient()
        {
            objuser.action = "select";

            objuser.name = "";
            objuser.id = "";
            objuser.companyid = Session["companyId"].ToString();
            ds = objuser.client();
            if (ds.Tables[0].Rows.Count > 0)
            {
                drpclient.DataSource = ds;
                drpclient.DataTextField = "clientcodewithname";
                drpclient.DataValueField = "nid";
                drpclient.DataBind();
                ListItem li = new ListItem("--All Clients--", "");
                drpclient.Items.Insert(0, li);
                drpclient.SelectedIndex = 0;

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
            objts.clientid = drpclient.Text;
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
        protected void drpclient_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            fillproject();
        }
        /// <summary>
        /// Paging- Go to previous page
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void lnkprevious_Click(object sender, EventArgs e)
        {
            //if (dgnews.PageIndex > 0)
            //{
            //    dgnews.PageIndex = dgnews.PageIndex - 1;
            //    fillgrid();
            //}
        }

        /// <summary>
        /// Paging- Move to next page
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void lnknext_Click(object sender, EventArgs e)
        {
            //if (int.Parse(lbltotalrecord.Text) > int.Parse(lblend.Text))
            //{
            //    dgnews.PageIndex = dgnews.PageIndex + 1;
            //    fillgrid();
            //}
        }

        /// <summary>
        /// When search any record
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnsearch_click(object sender, EventArgs e)
        {
            searchdata();
        }
        protected void searchdata()
        {
            hidsearchfromdate.Value = txtfrmdate.Text;
            hidsearchtodate.Value = txttodate.Text;
            hidsearchdrpclient.Value = drpclient.Text;
            hidsearchdrpproject.Value = dropproject.Text;
            hidsearchdroemployee.Value = drpemployee.Text;
            hidsearchdrpclientname.Value = drpclient.SelectedItem.Text;
            hidsearchdrpprojectname.Value = dropproject.SelectedItem.Text;
            hidsearchdroemployeename.Value = drpemployee.SelectedItem.Text;
            fillgrid();
        }

        //Fill clients
        protected void fillgrid()
        {
            objts.action = "selectclients";
            objts.clientid = hidsearchdrpclient.Value;
            objts.projectid = hidsearchdrpproject.Value;
            objts.empid = hidsearchdroemployee.Value;
            objts.from = hidsearchfromdate.Value;
            objts.to = hidsearchtodate.Value;
            objts.companyId = Session["companyid"].ToString();
            ds = objts.TimeExpenseReport();
            ctotalhrs = 0;
            ctotalbhrs = 0;
            ctotalcost = 0;
            ctotalamount = 0;
            if (ds.Tables[0].Rows.Count > 0)
            {
                rptclients.DataSource = ds.Tables[0];
                rptclients.DataBind();
                divnodata.Visible = false;
            }
            else
            {
                divnodata.Visible = true;
                rptclients.DataSource = null;
                rptclients.DataBind();
            }
        }


        protected void rptclients_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                objts.action = "selectprojects";
                objts.clientid = DataBinder.Eval(e.Item.DataItem, "nid").ToString();

                objts.projectid = hidsearchdrpproject.Value;
                objts.empid = hidsearchdroemployee.Value;
                objts.from = hidsearchfromdate.Value;
                objts.to = hidsearchtodate.Value;
                objts.companyId = Session["companyid"].ToString();
                ds = objts.TimeExpenseReport();
                Repeater rptprojects = (Repeater)e.Item.FindControl("rptprojects");
                ptotalhrs = 0;
                ptotalbhrs = 0;
                ptotalcost = 0;
                ptotalamount = 0;
                clientid = DataBinder.Eval(e.Item.DataItem, "clientcode").ToString();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    rptprojects.DataSource = ds;
                    rptprojects.DataBind();
                }
            }
            if (e.Item.ItemType == ListItemType.Footer)
            {
                ((Literal)e.Item.FindControl("ltrhrs")).Text = ctotalhrs.ToString("0.00");
                ((Literal)e.Item.FindControl("ltrbhrs")).Text = ctotalbhrs.ToString("0.00");
                ((Literal)e.Item.FindControl("ltrcost")).Text = ctotalcost.ToString("0.00");
                ((Literal)e.Item.FindControl("ltramount")).Text = ctotalamount.ToString("0.00");
              
            }
        }

        protected void rptprojects_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                objts.action = "selectempforservices";

                objts.projectid = DataBinder.Eval(e.Item.DataItem, "nid").ToString();

                objts.empid = hidsearchdroemployee.Value;
                objts.from = hidsearchfromdate.Value;
                objts.to = hidsearchtodate.Value;
                objts.companyId = Session["companyid"].ToString();
                ds = objts.TimeExpenseReport();
                Repeater rptemployees = (Repeater)e.Item.FindControl("rptemployees");
                emptotalhrs = 0;
                emptotalbhrs = 0;
                emptotalcost = 0;
                emptotalamount = 0;
               projectid = DataBinder.Eval(e.Item.DataItem, "projectcode").ToString();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    rptemployees.DataSource = ds;
                    rptemployees.DataBind();
                }


            }
            if (e.Item.ItemType == ListItemType.Footer)
            {
                ((Literal)e.Item.FindControl("ltrhrs")).Text = ptotalhrs.ToString("0.00");
                ((Literal)e.Item.FindControl("ltrbhrs")).Text = ptotalbhrs.ToString("0.00");
                ((Literal)e.Item.FindControl("ltrcost")).Text = ptotalcost.ToString("0.00");
                ((Literal)e.Item.FindControl("ltramount")).Text = ptotalamount.ToString("0.00");

                ((Literal)e.Item.FindControl("ltrclientid")).Text = clientid;

            }
        }
        protected void rptemployees_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                objts.action = "selecttasks";

                objts.projectid = DataBinder.Eval(e.Item.DataItem, "projectid").ToString();

                objts.empid = DataBinder.Eval(e.Item.DataItem, "nid").ToString();
                objts.from = hidsearchfromdate.Value;
                objts.to = hidsearchtodate.Value;
                objts.companyId = Session["companyid"].ToString();
                ds = objts.TimeExpenseReport();
                Repeater rpttasks = (Repeater)e.Item.FindControl("rpttasks");
                totalhrs = 0;
                totalbhrs = 0;
                totalcost = 0;
                totalamount = 0;
                loginid = DataBinder.Eval(e.Item.DataItem, "loginid").ToString();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    rpttasks.DataSource = ds;
                    rpttasks.DataBind();
                }
             
            }
            if (e.Item.ItemType == ListItemType.Footer)
            {
                ((Literal)e.Item.FindControl("ltrhrs")).Text = emptotalhrs.ToString("0.00");
                ((Literal)e.Item.FindControl("ltrbhrs")).Text = emptotalbhrs.ToString("0.00");
                ((Literal)e.Item.FindControl("ltrcost")).Text = emptotalcost.ToString("0.00");
                ((Literal)e.Item.FindControl("ltramount")).Text = emptotalamount.ToString("0.00");
                ((Literal)e.Item.FindControl("ltrshrs")).Text = emptotalhrs.ToString("0.00");
                ((Literal)e.Item.FindControl("ltrsbhrs")).Text = emptotalbhrs.ToString("0.00");
                ((Literal)e.Item.FindControl("ltrscost")).Text = emptotalcost.ToString("0.00");
                ((Literal)e.Item.FindControl("ltrsamount")).Text = emptotalamount.ToString("0.00");
                ((Literal)e.Item.FindControl("ltrphrs")).Text = emptotalhrs.ToString("0.00");
                ((Literal)e.Item.FindControl("ltrpbhrs")).Text = emptotalbhrs.ToString("0.00");
                ((Literal)e.Item.FindControl("ltrpcost")).Text = emptotalcost.ToString("0.00");
                ((Literal)e.Item.FindControl("ltrpamount")).Text = emptotalamount.ToString("0.00");
                ((Literal)e.Item.FindControl("ltrprojectid")).Text = projectid;

            }
        }
        protected void rpttasks_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                totalhrs = totalhrs + Convert.ToDecimal(DataBinder.Eval(e.Item.DataItem, "timetaken"));
                totalbhrs = totalbhrs + Convert.ToDecimal(DataBinder.Eval(e.Item.DataItem, "bhours"));
                totalcost = totalcost + Convert.ToDecimal(DataBinder.Eval(e.Item.DataItem, "costrate"));
                totalamount = totalamount + Convert.ToDecimal(DataBinder.Eval(e.Item.DataItem, "amount"));

                emptotalhrs = emptotalhrs + Convert.ToDecimal(DataBinder.Eval(e.Item.DataItem, "timetaken"));
                emptotalbhrs = emptotalbhrs + Convert.ToDecimal(DataBinder.Eval(e.Item.DataItem, "bhours"));
                emptotalcost = emptotalcost + Convert.ToDecimal(DataBinder.Eval(e.Item.DataItem, "costrate"));
                emptotalamount = emptotalamount + Convert.ToDecimal(DataBinder.Eval(e.Item.DataItem, "amount"));

                ptotalhrs = ptotalhrs + Convert.ToDecimal(DataBinder.Eval(e.Item.DataItem, "timetaken"));
                ptotalbhrs = ptotalbhrs + Convert.ToDecimal(DataBinder.Eval(e.Item.DataItem, "bhours"));
                ptotalcost = ptotalcost + Convert.ToDecimal(DataBinder.Eval(e.Item.DataItem, "costrate"));
                ptotalamount = ptotalamount + Convert.ToDecimal(DataBinder.Eval(e.Item.DataItem, "amount"));


                ctotalhrs = ctotalhrs + Convert.ToDecimal(DataBinder.Eval(e.Item.DataItem, "timetaken"));
                ctotalbhrs = ctotalbhrs + Convert.ToDecimal(DataBinder.Eval(e.Item.DataItem, "bhours"));
                ctotalcost = ctotalcost + Convert.ToDecimal(DataBinder.Eval(e.Item.DataItem, "costrate"));
                ctotalamount = ctotalamount + Convert.ToDecimal(DataBinder.Eval(e.Item.DataItem, "amount"));

            }
            if (e.Item.ItemType == ListItemType.Footer)
            {
                ((Literal)e.Item.FindControl("ltrloginid")).Text = loginid;
                ((Literal)e.Item.FindControl("ltrhrs")).Text = totalhrs.ToString("0.00");                
                ((Literal)e.Item.FindControl("ltrbhrs")).Text = totalbhrs.ToString("0.00");
                ((Literal)e.Item.FindControl("ltrcost")).Text = totalcost.ToString("0.00");
                ((Literal)e.Item.FindControl("ltramount")).Text = totalamount.ToString("0.00");

            }
        }

        /// <summary>
        /// fiil List of Employee For Search
        /// </summary>
        private void fillemployee()
        {

            objuser.loginid = "";
            objuser.name = "";
            objuser.companyid = Session["companyid"].ToString();
            objuser.action = "select";
            objuser.activestatus = "";
            ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0)
            {
                objgen.fillActiveInactiveDDL(ds.Tables[0], drpemployee, "username", "nid");
                ListItem li = new ListItem("--All Employees--", "");
                drpemployee.Items.Insert(0, li);
                drpemployee.SelectedIndex = 0;
            }

        }
        /// <summary>
        /// Refresh the grid, so changes made by any other can reflect.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnrefresh_Click(object sender, EventArgs e)
        {
            fillgrid();
        }

        protected void btnexportcsv_Click(object sender, EventArgs e)
        {

            //fillgrid();
            //string rpthtml = bindheader("excel");
            //for (int i = 0; i < dsexcel.Tables[0].Rows.Count; i++)
            //{
            //    rpthtml = rpthtml + "<tr><td>" + Convert.ToString(i + 1) + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["date"].ToString() + ' ' + dsexcel.Tables[0].Rows[i]["Time"].ToString() +
            //        "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["empname"].ToString() + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["clientname"].ToString() + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["projectcode"].ToString() + "</td>"
            //        + "<td>" + dsexcel.Tables[0].Rows[i]["scheduletype"].ToString() + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["status"].ToString() + "</td>"
            //        + "<td>" + dsexcel.Tables[0].Rows[i]["remark"].ToString() + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["username"].ToString() + "</td></tr>";
            //}

            HtmlGenericControl divgen = new HtmlGenericControl();

            // divgen.InnerHtml = rpthtml;
            HttpResponse response = HttpContext.Current.Response;
            // first let's clean up the response.object   
            response.Clear();
            response.Charset = "";
            // set the response mime type for excel   

            response.ContentType = "application/vnd.ms-excel";
            response.AddHeader("Content-Disposition", "attachment;filename=\"ClientScheduleReport.xls\"");
            // create a string writer   
            using (StringWriter sw = new StringWriter())
            {
                using (HtmlTextWriter htw = new HtmlTextWriter(sw))
                {
                    System.Web.UI.HtmlControls.HtmlGenericControl dv = new System.Web.UI.HtmlControls.HtmlGenericControl();
                    dv.InnerHtml = divreport.InnerHtml.Replace("border='0'", "border='1'");

                    dv.RenderControl(htw);
                    response.Write(sw.ToString());
                    response.End();
                }
            }
        }

        /// <summary>
        /// Bind Header of excel Report
        /// </summary>
        /// <param name="type"></param>
        /// <returns></returns>
        protected string bindheader(string type)
        {
            string str = "";
            string Companyname = Session["companyname"].ToString();
            string companyaddress = Session["companyaddress"].ToString();
            string client = "<b>Client:</b> ", employee = "<b>Employee:</b> ", task = "<b>Task:</b> ", status = "<b>Status:</b> ", date = "<b>Date:</b> ";
            if (hidsearchdrpclient.Value == "")
            {
                client += "All";
            }
            else
            {
                client += hidsearchdrpclientname.Value;
            }
            if (hidsearchdroemployee.Value == "")
            {
                employee += "All";
            }
            else
            {
                employee += hidsearchdroemployeename.Value;
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
            <td colspan='9' align='center'>
                <h2>
                   " + Companyname + @"
                </h2>
            </td>
        </tr>
<tr>
            <td colspan='9' align='center'>
                <h4>
                   " + companyaddress + @"
                </h4>
            </td>
        </tr>
        <tr>
            <td colspan='9' align='center'>
                <h4>
                    Schedule Report
                </h4>
            </td>
        </tr>
        <tr>
            <td colspan='9'>
                &nbsp;
            </td>
        </tr>
       
        <tr>
        <td colspan='9'>
        " + date + "<br/>" + employee + "<br/>" + client + "<br/>" + task + "<br/>" + status +



       @"</td>

        </tr>
       <tr>
        <td colspan='9'>&nbsp;</td></tr>
       </table>
<table align='left' cellpadding='5' width='100%' cellspacing='0' style='font-family: Calibri;
                        font-size: 12px; text-align: left;' border='0'>
                      
<tr style='font-weight: bold; background: #395ba4; color: #ffffff;'>
<td style='width=38px;'width='100px'>S.No</td>
 <td> Date/Time</td>
 <td>Employee</td>
 <td>Client</td>
 <td>Project</td>
 <td>Schedule Type</td>
 <td>Status</td>
 <td>Remark</td>
 <td>Last Modify By</td>
                                                                     
</tr>";


            return str;
        }





    }
}