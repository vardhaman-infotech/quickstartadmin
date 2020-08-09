using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Data;
using System.IO;

namespace empTimeSheet
{
    public partial class PerformanceReport : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();

        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                
                if (!objda.checkUserInroles("9"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
                
                txtfromdate.Text = Convert.ToDateTime(GeneralMethod.getLocalDate()).ToString("MM/dd/yyyy");
                txttodate.Text = Convert.ToDateTime(GeneralMethod.getLocalDate()).ToString("MM/dd/yyyy");
                fillemployee();
                filltasks();
                fillclient();
                fillgrid();
            }
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
            objuser.action = "select";
            objuser.companyid = Session["companyid"].ToString();
            objuser.id = "";
            ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0)
            {
                objgen.fillActiveInactiveDDL(ds.Tables[0], dropemployee, "username", "nid");

            }

            ListItem li = new ListItem("--All Employees--", "");
            dropemployee.Items.Insert(0, li);
            dropemployee.Text = Session["userid"].ToString();


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

        /// <summary>
        /// Fill Report
        /// </summary>
        protected void fillgrid()
        {
            objts.action = "select";
            objts.nid = "";
            objts.empid = dropemployee.Text;
            objts.clientid = dropclient.Text;
            objts.taskid = droptask.Text;
            objts.from = txtfromdate.Text;
            objts.to = txttodate.Text;
            objts.companyId = Session["companyid"].ToString();
            ds = objts.GetPerformanceRpt();
            if (ds.Tables[0].Rows.Count > 0)
            {
                
                divnodata.Visible = false;
                dgnews.DataSource = ds;
                dgnews.DataBind();
                rptreport.DataSource = ds;
                rptreport.DataBind();
            }
            else
            {

                rptreport.DataSource = null;
                rptreport.DataBind();
                if (!IsPostBack)
                    divnodata.Visible = false;
                else                 
                    divnodata.Visible = true;
                dgnews.DataSource = null;
                dgnews.DataBind();
            }

        }


        protected void btnsearch_click(object sender, EventArgs e)
        {
            fillgrid();
        }
        protected void bindheader(string type)
        {
            string client = "<b>Client:</b> ", employee = "<b>Employee:</b> ", task = "<b>Task:</b> ", status = "<b>Status:</b> ", date = "<b>Date:</b> ";
            if (dropclient.Text == "")
            {
                client += "All";
            }
            else
            {
                client += dropclient.SelectedItem.Text;
            }
            if (dropemployee.Text == "")
            {
                employee += "All";
            }
            else
            {
                employee += dropemployee.SelectedItem.Text;
            }
            
            if (droptask.Text == "")
            {
                task += "All";
            }
            else
            {
                task += droptask.SelectedItem.Text;
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
                headerstr = "<table width='100%' border='1'>";

            }

            ltrreport.Text = headerstr +
        @"<tr>
            <td colspan='7' align='center'>
                <h2>
                    Harshwal & Company LLP
                </h2>
            </td>
        </tr>
        <tr>
            <td colspan='7' align='center'>
                <h4>
                    Assigned Tasks Report
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
        " + date + "<br/>" + employee + "<br/>" + client + "<br/>" + task + "<br/>" + status +



       @"</td>

        </tr>
       <tr>
        <td colspan='7'>&nbsp;</td></tr>
       </table>";



        }
        protected void btnexportcsv_Click(object sender, EventArgs e)
        {
           // bindheader("excel");
            HtmlGenericControl divgen = new HtmlGenericControl();


            StringWriter sw1 = new StringWriter();

            HtmlTextWriter hw1 = new HtmlTextWriter(sw1);

            divreport.RenderControl(hw1);


            divgen.InnerHtml = sw1.ToString();
            HttpResponse response = HttpContext.Current.Response;

            // first let's clean up the response.object   
            response.Clear();
            response.Charset = "";

            // set the response mime type for excel   
            response.ContentType = "application/vnd.ms-excel";
            response.AddHeader("Content-Disposition", "attachment;filename=\"HCLLP-PerformanceReport.xls\"");

            // create a string writer   
            using (StringWriter sw = new StringWriter())
            {
                using (HtmlTextWriter htw = new HtmlTextWriter(sw))
                {
                    System.Web.UI.HtmlControls.HtmlGenericControl dv = new System.Web.UI.HtmlControls.HtmlGenericControl();
                    dv.InnerHtml = divgen.InnerHtml.Replace("border='0'", "border='1'");
 
                    dv.RenderControl(htw);
                    response.Write(sw.ToString());
                    response.End();
                }
            }


        }

    }
}