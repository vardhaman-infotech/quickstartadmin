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
    public partial class ExpenseDetailByEmployee : System.Web.UI.Page
    {

        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();

        DataSet ds = new DataSet();
        DataSet dsexcel = new DataSet();

        decimal ptotalhrs = 0, ptotalbhrs = 0, ptotalcost = 0, ptotalamount = 0;
        decimal ctotalhrs = 0, ctotalbhrs = 0, ctotalcost = 0, ctotalamount = 0;

        string clientid = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();

            if (!IsPostBack)
            {
               
                if (!objda.checkUserInroles("44"))
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
                ListItem li = new ListItem("--Select Client--", "");
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
            rptEmployee.PageIndex = 0;
            fillgrid();
        }

        //Fill clients
        protected void fillgrid()
        {
            objts.action = "selectempforexpenses";
            objts.clientid = hidsearchdrpclient.Value;
            objts.projectid = hidsearchdrpproject.Value;
            objts.empid = hidsearchdroemployee.Value;
            objts.from = hidsearchfromdate.Value;
            objts.to = hidsearchtodate.Value;
            objts.companyId = Session["companyid"].ToString();
            ds = objts.ExpenseDetailReport();
            ctotalhrs = 0;
            ctotalbhrs = 0;
            ctotalcost = 0;
            ctotalamount = 0;
            int start = rptEmployee.PageSize * rptEmployee.PageIndex;
            int end = start + rptEmployee.PageSize;
            start = start + 1;
            if (end >= ds.Tables[0].Rows.Count)
                end = ds.Tables[0].Rows.Count;
            lblstart.Text = start.ToString();
            lblend.Text = end.ToString();
            lbltotalrecord.Text = ds.Tables[0].Rows.Count.ToString();
            if (ds.Tables[0].Rows.Count > 0)
            {
                rptEmployee.DataSource = ds.Tables[0];
                rptEmployee.DataBind();
                divnodata.Visible = false;
                lbtnpdf.Enabled = true;
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
                divnodata.Visible = true;
                rptEmployee.DataSource = null;
                rptEmployee.DataBind();
                lbtnpdf.Enabled = false;
                lblstart.Text = "0";
                lnkprevious.Enabled = false;
                lnknext.Enabled = false;
            }
        }


        protected void rptEmployee_ItemDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                objts.action = "selectexpensedetail";

                objts.clientid = hidsearchdrpclient.Value;
                objts.projectid = hidsearchdrpproject.Value;
                objts.empid = DataBinder.Eval(e.Row.DataItem, "nid").ToString();
                objts.from = hidsearchfromdate.Value;
                objts.to = hidsearchtodate.Value;
                objts.companyId = Session["companyid"].ToString();
                ds = objts.ExpenseDetailReport();
                Repeater rptprojects = (Repeater)e.Row.FindControl("rptprojects");
                ptotalhrs = 0;
                ptotalbhrs = 0;
                ptotalcost = 0;
                ptotalamount = 0;
               // clientid = DataBinder.Eval(e.Row.DataItem, "clientcode").ToString();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    rptprojects.DataSource = ds;
                    rptprojects.DataBind();
                }
            }
            if (e.Row.RowType == DataControlRowType.Footer)
            {
                //((Literal)e.Item.FindControl("ltrhrs")).Text = ctotalhrs.ToString("0.00");
                //((Literal)e.Item.FindControl("ltrbhrs")).Text = ctotalbhrs.ToString("0.00");
                //((Literal)e.Item.FindControl("ltrcost")).Text = ctotalcost.ToString("0.00");
                //((Literal)e.Item.FindControl("ltramount")).Text = ctotalamount.ToString("0.00");

            }
        }

        protected void rptprojects_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                //objts.action = "selectprojectwiseserviceexpense";

                //objts.projectid = DataBinder.Eval(e.Item.DataItem, "nid").ToString();
                //objts.empid = hidsearchdroemployee.Value;
                //objts.from = hidsearchfromdate.Value;
                //objts.to = hidsearchtodate.Value;
                //objts.companyId = Session["companyid"].ToString();
                //ds = objts.TimeExpenseReport();
                //Literal ltrdetail = (Literal)e.Item.FindControl("ltrprojectdetails");
                //if (ds.Tables[0].Rows.Count > 0)
                //{
                //    ltrdetail.Text = ds.Tables[0].Rows[0]["details"].ToString();

                //    ptotalhrs = ptotalhrs + Convert.ToDecimal(ds.Tables[0].Rows[0]["totalhrs"]);
                //    ptotalbhrs = ptotalhrs + Convert.ToDecimal(ds.Tables[0].Rows[0]["totalbhrs"]);
                //    ptotalcost = ptotalhrs + Convert.ToDecimal(ds.Tables[0].Rows[0]["totalcost"]);
                //    ptotalamount = ptotalhrs + Convert.ToDecimal(ds.Tables[0].Rows[0]["totalamount"]);

                //    ctotalhrs = ctotalhrs + Convert.ToDecimal(ds.Tables[0].Rows[0]["totalhrs"]);
                //    ctotalbhrs = ctotalbhrs + Convert.ToDecimal(ds.Tables[0].Rows[0]["totalbhrs"]);
                //    ctotalcost = ctotalcost + Convert.ToDecimal(ds.Tables[0].Rows[0]["totalcost"]);
                //    ctotalamount = ctotalamount + Convert.ToDecimal(ds.Tables[0].Rows[0]["totalamount"]);
                //}


            }
            if (e.Item.ItemType == ListItemType.Footer)
            {
                //((Literal)e.Item.FindControl("ltrhrs")).Text = ptotalhrs.ToString("0.00");
                //((Literal)e.Item.FindControl("ltrbhrs")).Text = ptotalbhrs.ToString("0.00");
                //((Literal)e.Item.FindControl("ltrcost")).Text = ptotalcost.ToString("0.00");
                //((Literal)e.Item.FindControl("ltramount")).Text = ptotalamount.ToString("0.00");

                //((Literal)e.Item.FindControl("ltrclientid")).Text = clientid;

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
        /// Move to clicked page number
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dgnews_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            rptEmployee.PageIndex = e.NewPageIndex;
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
            if (rptEmployee.PageIndex > 0)
            {
                rptEmployee.PageIndex = rptEmployee.PageIndex - 1;
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
                rptEmployee.PageIndex = rptEmployee.PageIndex + 1;
                fillgrid();
            }
        }
        public override void VerifyRenderingInServerForm(Control control)
        {
            /* Verifies that the control is rendered */
        }
        protected void btnexportpdf_Click(object sender, EventArgs e)
        {
            Session["ctrl"] = null;
            string rpthtml = bindheader();
            ltrreporthead.InnerHtml = rpthtml;
            Session["ctrl"] = divreport;

            string url = "printpdf.aspx";
            string s = "window.open('" + url + "', '_blank');";

            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>" + s + "</script>", false);
        }
        /// <summary>
        /// Bind Header of excel Report
        /// </summary>
        /// <param name="type"></param>
        /// <returns></returns>
        protected string bindheader()
        {
            string str = "";
            string Companyname = Session["companyname"].ToString();
            string companyaddress = Session["companyaddress"].ToString();
            string client = "<b>Client:</b> ", employee = "<b>Employee:</b> ", project = "<b>Project:</b> ", date = "<b>Date:</b> ";
            if (hidsearchdrpclient.Value == "")
            {
                client = "";
            }
            else
            {
                client += hidsearchdrpclientname.Value + "<br/>";
            }
            if (hidsearchdroemployee.Value == "")
            {
                employee = "";
            }
            else
            {
                employee += hidsearchdroemployeename.Value + "<br/>";
            }
            if (hidsearchdrpproject.Value == "")
            {
                project = "";
            }
            else
            {
                project += hidsearchdrpprojectname.Value + "<br/>";
            }

            if (hidsearchfromdate.Value != hidsearchtodate.Value)
            {
                date += hidsearchfromdate.Value + " - " + hidsearchtodate.Value + "<br/>";
            }
            else
            {
                date += hidsearchfromdate.Value + "<br/>";
            }
            string headerstr = "<table width='100%' style='font-size:10px;font-family:calibri;'>";


            str = headerstr +
        @"
            <tr>
            <td  align='center'>
                <h3>
                    
Expense Detail by Employee
                </h3>
            </td>
        </tr>
<tr>
            <td >
                &nbsp;
            </td>
        </tr>
<tr>
            <td  align='left'>
                <h3>
                   " + Companyname + @"
                </h3>
            </td>
        </tr>
<tr>
            <td align='left'>
                <h5>
                   " + companyaddress + @"
                </h5>
            </td>
        </tr>
       
        <tr>
            <td >
                &nbsp;
            </td>
        </tr>
       
        <tr>
        <td>
        " + date + client + project + employee +



       @"</td>

        </tr>
       <tr>
        <td height='20'>&nbsp;</td></tr>
       </table>";


            return str;
        }





    }
}