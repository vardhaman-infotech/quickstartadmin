using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Data;
using System.IO;

namespace empTimeSheet.Client
{
    public partial class EmpTimeSheet : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds1 = new DataSet();
        DataSet ds = new DataSet();
        DataSet dsexcel = new DataSet();
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validateClientlogin();
            if (!Page.IsPostBack)
            {
                txtfrom.Text = System.DateTime.Now.AddDays(-7).ToString("MM/dd/yyyy");
                txtto.Text = System.DateTime.Now.ToString("MM/dd/yyyy");
                fillproject();
                fillemployee();
                searchdata();
            }

        }

        protected void btnsearch_Click(object sender, EventArgs e)
        {
            searchdata();
        }
        protected void searchdata()
        {
            hidfromdate.Value = txtfrom.Text;
            hidtodate.Value = txtto.Text;
            hidempid.Value = dropemployee.Text;
            hidprojectid.Value = dropproject.Text;
            hidsearchemp.Value = dropemployee.SelectedItem.Text;
            hidsearchproject.Value = dropproject.SelectedItem.Text;
            fillgrid();
        }

        /// <summary>
        /// Fill empoyee drop down for searching
        /// </summary>
        protected void fillemployee()
        {
            dropemployee.Items.Clear();
            objts.name = "";
            objts.action = "selectclientwiseemployee";
            //Pass clientid in 'managerid' param
            objts.managerId = Session["clientloginid"].ToString();

            objts.nid = "";
            ds = objts.ManageTimesheet();
            if (ds.Tables[0].Rows.Count > 0)
            {
                dropemployee.DataSource = ds;
                dropemployee.DataTextField = "empname";
                dropemployee.DataValueField = "nid";
                dropemployee.DataBind();
            }

            ListItem li = new ListItem("--All Employees--", "");
            dropemployee.Items.Insert(0, li);

        }


        /// <summary>
        /// Fill Projects drop down for seraching
        /// </summary>
        protected void fillproject()
        {
            dropproject.Items.Clear();
            objts.name = "";
            objts.action = "selectbyclient";

            objts.clientid = Session["clientloginid"].ToString();
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


        /// <summary>
        /// Bind employee activities
        /// </summary>
        protected void fillgrid()
        {
            objts.from = hidfromdate.Value;
            objts.to = hidtodate.Value;
            objts.empid = hidempid.Value;
            objts.projectid = hidprojectid.Value;
            objts.managerId = Session["clientloginid"].ToString();
            objts.companyId = Session["companyid"].ToString();
            objts.action = "selecttimesheetforclient";
            objts.nid = "";
            ds = objts.ManageTimesheet();
            int start = dgnews.PageSize * dgnews.PageIndex;
            int end = start + dgnews.PageSize;
            start = start + 1;
            if (end >= ds.Tables[0].Rows.Count)
                end = ds.Tables[0].Rows.Count;
            lblstart.Text = start.ToString();
            lblend.Text = end.ToString();
            lbltotalrecord.Text = ds.Tables[0].Rows.Count.ToString();
            if(ds.Tables[0].Rows.Count>0)
            {
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
            }
            dgnews.DataSource = ds;
            dgnews.DataBind();
            if(ds.Tables[1].Rows.Count>0)
            {
                ltrtotalhours.Text = "Total Hours: <b>" + ds.Tables[1].Rows[0]["totalhours"].ToString() + "</b>";
            }
            else
            {
                ltrtotalhours.Text = "";
            }
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

        protected void dgnews_OnRowDataBound(object sender, GridViewRowEventArgs e)
        {

            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Literal ltrhours = (Literal)e.Row.FindControl("ltrhours");

                hidtotalhours.Value = (Convert.ToDecimal(hidtotalhours.Value) + Convert.ToDecimal(ltrhours.Text)).ToString("0.00");
            }
            if (e.Row.RowType == DataControlRowType.Footer)
            {
                Literal ltrtotalhours = (Literal)e.Row.FindControl("ltrtotalhours");
                ltrtotalhours.Text = hidtotalhours.Value;
            }
        }


        #region EXPORT TO EXCEL
        /// <summary>
        /// Export file to excel
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnexportcsv_Click(object sender, EventArgs e)
        {
            string rpthtml = "";

            fillgrid();
            rpthtml = bindlistviewheader("excel");

            for (int i = 0; i < dsexcel.Tables[0].Rows.Count; i++)
            {
                rpthtml = rpthtml + "<tr><td>" + dsexcel.Tables[0].Rows[i]["date"].ToString() +
                    "</td><td>" + dsexcel.Tables[0].Rows[i]["projectcode"].ToString() +
                    "</td><td>" + dsexcel.Tables[0].Rows[i]["empname"].ToString() + "</td><td>" + dsexcel.Tables[0].Rows[i]["taskcodenamesmall"].ToString()
                    + "</td><td>" + dsexcel.Tables[0].Rows[i]["taskdescription"].ToString() + "</td><td>" + dsexcel.Tables[0].Rows[i]["Hours"].ToString()
                    + "</td><td>" + dsexcel.Tables[0].Rows[i]["description"].ToString()
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
            response.AddHeader("Content-Disposition", "attachment;filename=\"timesheet.xls\"");

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

        /// <summary>
        /// Bind export file header
        /// </summary>
        /// <param name="type"></param>
        /// <returns></returns>
        protected string bindlistviewheader(string type)
        {
            string Companyname = Session["clientcompanyname"].ToString();

            string str = "";
            string project = "<b>Project:</b> ";
            string employee = "<b>Employee:</b>";
            string date = "<b>Date:</b> ";
            if (hidprojectid.Value == "")
            {
                project += "All";
            }
            else
            {
                project += hidsearchproject.Value;
            }
            if (hidfromdate.Value != hidtodate.Value)
            {
                date += hidfromdate.Value + " - " + hidtodate.Value;
            }
            else
            {
                date += hidfromdate.Value;
            }
            if(hidempid.Value=="")
            {
                employee += "All";
            }
            else
            {
                employee += hidsearchemp.Value;
            }
            string headerstr = "<table width='100%'>";
            if (type == "excel")
            {
                headerstr = "<table width='100%' border='1'>";

            }
           
            str = headerstr +
         @"<tr>
            <td colspan='7' align='center'>
                <h2>
                    " + Companyname + @"
                </h2>
            </td>
        </tr>
        <tr>
            <td colspan='7' align='center'>
                <h4>
                    Timesheet
                </h4>
            </td>
        </tr>
        <tr>
            <td colspan='7'>
                &nbsp;
            </td>
        </tr>
       
        <tr>
        <td colspan='7'>
        " + date + "<br/>" + employee + "<br/>" + project + "<br/>" +

        @"</td>

        </tr>
       <tr>
        <td colspan='7'>&nbsp;</td></tr>
       </table>

        <table align='left' cellpadding='7' width='100%' cellspacing='0' style='font-family: Calibri;font-size: 12px; text-align: left;' border='0'> 
         <tr style='font-weight: bold; background: #395ba4; color: #ffffff;'>
        <td>Date</td>
        <td>Project ID</td>
        <td>Employee</td>
        <td>Task ID</td>
        <td>Description</td>
        <td>Hours</td>
        <td>Activity</td>
                                                                                                                                                                                                                                                   
        </tr>";

            return str;

        }



        #endregion
    }
}