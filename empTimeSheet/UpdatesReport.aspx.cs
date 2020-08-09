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
    public partial class UpdatesReport : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        clsServer objserver = new clsServer();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();
        static DataSet dsexcel = new DataSet();
        excelexport objexcel = new excelexport();
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                if (!objda.checkUserInroles("13"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
              
                txtfromdate.Text = System.DateTime.Now.AddDays(-7).ToString("MM/dd/yyyy");
                txttodate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");

                fillclient();
                fillsever();
                fillgrid();
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
                dropclient.SelectedIndex = 0;
            }
            ListItem li = new ListItem("--All Clients--", "");
            dropclient.Items.Insert(0, li);
            dropclient.SelectedIndex = 0;

        }
        /// <summary>
        /// Bins servers according to client
        /// </summary>
        public void fillsever()
        {
            dropserver.Items.Clear();
            if (dropclient.Text != "")
            {
                objserver.action = "select";
                objserver.servername = "";
                objserver.nid = "";

                objserver.companyid = Session["companyId"].ToString();
                objserver.clientid = dropclient.Text;
                //objuser.companyid = Session["companyId"].ToString();
                ds = objserver.Server();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    dropserver.DataSource = ds;
                    dropserver.DataTextField = "ServerName";
                    dropserver.DataValueField = "nid";
                    dropserver.DataBind();

                }
            }
            ListItem li = new ListItem("--All Server--", "");
            dropserver.Items.Insert(0, li);
            dropserver.SelectedIndex = 0;

        }
        /// <summary>
        /// Fill Report
        /// </summary>
        protected void fillgrid()
        {
            objserver.action = "getserverreport";
            objserver.nid = "";
            objserver.clientid = dropclient.Text;
            objserver.serverid = dropserver.Text;
            objserver.from = txtfromdate.Text;
            objserver.to = txttodate.Text;
            objserver.companyid = Session["companyid"].ToString();
            ds = objserver.ServerLog();

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

                divnodata.Visible = false;
                dgnews.DataSource = ds;
                dgnews.DataBind();
                btnexportcsv.Enabled = true;

            }
            else
            {

                if (!IsPostBack)
                    divnodata.Visible = false;
                else
                    divnodata.Visible = true;
                dgnews.DataSource = null;
                dgnews.DataBind();
                btnexportcsv.Enabled = false;
            }
            dsexcel = ds;
        }

        /// <summary>
        /// When selects a client
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dropclient_SelectedIndexChanged(object sender, EventArgs e)
        {
            fillsever();
        }

        /// <summary>
        /// When click on search button, bind the grid according to selected parameters
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnsearch_click(object sender, EventArgs e)
        {
            fillgrid();

        }

        /// <summary>
        /// Bind report header with selected parameters and Company Name 
        /// </summary>
        /// <param name="type"></param>
        protected string bindheader(string type)
        {
            string str = "";
            string Companyname = System.Web.Configuration.WebConfigurationManager.AppSettings["ServerCompanyName"].ToString();
            string client = "<b>Client:</b> ", Server = "<b>Server:</b> ", date = "<b>Date:</b> ";
            if (dropclient.Text == "")
            {
                client += "All";
            }
            else
            {
                client += dropclient.SelectedItem.Text;
            }
            if (dropserver.Text == "")
            {
                Server += "All";
            }
            else
            {
                Server += dropserver.SelectedItem.Text;
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
                    <td  align='center' colspan='5'>
                        <h1>
                            " + Companyname + @"
                        </h1>
                    </td>
                </tr>
             
               <tr>
                <td colspan='5'>&nbsp;</td></tr>
              

                           <tr>
                                <td align='center' colspan='5' >
                                    <h4>
                                        Server Updates Report
                                    </h4>
                                </td>
                            </tr>
                            <tr>
                                <td >
                                    &nbsp;
                                </td>
                            </tr>

                            <tr>
                            <td>
                            " + date + "<br/>" + client + "<br/>" + Server +

                   @"</td>
                    
                            </tr>
<tr><td colspan='5'>&nbsp;</td></tr>
 </table>  
<table width='100%' cellpadding='5' cellspacing='0' style='font-family: Calibri;
                        font-size: 12px; text-align: left;' border='0'>
                      
<tr style='font-weight: bold; background: #395ba4; color: #ffffff;'>
 <td>Client Name</td>
 <td>Server ID</td>
 <td>Server Name</td>
 <td>Date</td>
 <td>Update Summary</td>
                                                                     
</tr>";
            return str;
        }


        /// <summary>
        ///Export file to excel 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>

        protected void btnexportcsv_Click(object sender, EventArgs e)
        {
          
            fillgrid();
            string rpthtml = bindheader("excel");
            for (int i = 0; i < dsexcel.Tables[0].Rows.Count; i++)
            {
                rpthtml = rpthtml + "<tr><td>" + dsexcel.Tables[0].Rows[i]["Clientname"].ToString() +
                    "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["servercode"].ToString() + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["servername"].ToString() + "</td>" +
                   "<td>" + dsexcel.Tables[0].Rows[i]["date"].ToString() + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["updatesummary"].ToString() + "</td></tr>";
            }

            HtmlGenericControl divgen = new HtmlGenericControl();

            divgen.InnerHtml = rpthtml;
            HttpResponse response = HttpContext.Current.Response;
            // first let's clean up the response.object   
            response.Clear();
            response.Charset = "";
            // set the response mime type for excel   
            response.ContentType = "application/vnd.ms-excel";
            response.AddHeader("Content-Disposition", "attachment;filename=\"ServerUpdatesReport.xls\"");
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
    }
}