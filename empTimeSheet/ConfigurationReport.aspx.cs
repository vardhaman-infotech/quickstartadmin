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
    public partial class ConfigurationReport : System.Web.UI.Page
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
                if (!objda.checkUserInroles("14"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }

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
        /// When selects a client
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dropclient_SelectedIndexChanged(object sender, EventArgs e)
        {
            fillsever();
        }

        /// <summary>
        /// Fill Report
        /// </summary>
        protected void fillgrid()
        {
            objserver.action = "select";
            objserver.nid = "";
            objserver.clientid = dropclient.Text;
            objserver.nid = dropserver.Text;

            objserver.companyid = Session["companyid"].ToString();
            ds = objserver.Server();

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

            }
            else
            {

                if (!IsPostBack)
                    divnodata.Visible = false;
                else
                    divnodata.Visible = true;
                dgnews.DataSource = null;
                dgnews.DataBind();
            }
            dsexcel = ds;

        }

        /// <summary>
        /// When click on search button, bind the grid according to selected parameters
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnsearch_click(object sender, EventArgs e)
        {
            fillgrid();
            multiview1.ActiveViewIndex = 0;
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

        protected void dgnews_ItemCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName.ToLower() == "viewdetail")
            {
                string[] args = e.CommandArgument.ToString().Split(';');
                fillFullReport(args[0], args[1]);
             //   btnexportcsv.Visible = false;
                multiview1.ActiveViewIndex = 1;
            }
        }


        protected void btnFullReport_click(object sender, EventArgs e)
        {
                
                fillFullReport(dropserver.Text,dropclient.Text);
                multiview1.ActiveViewIndex = 1;   

        }

        public void fillFullReport(string serverid, string clientid)
        {

            objserver.action = "getconfigurationreport";
            objserver.nid = serverid;
            objserver.clientid = clientid;

            objserver.companyid = Session["companyid"].ToString();
            ds = objserver.Server();

            repclients.DataSource = ds;
            repclients.DataBind();
        }

        protected void repclients_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                Repeater repinner = (Repeater)e.Item.FindControl("replogreport");
                repinner.DataSource = filterdataset(ds.Tables[1], "clientid", DataBinder.Eval(e.Item.DataItem, "clientid").ToString());
                repinner.DataBind();
            }
        }

        protected void replogreport_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {

                Repeater repinner = (Repeater)e.Item.FindControl("rptconfig");
                repinner.DataSource = ds.Tables[2];
                repinner.DataBind();



            }
        }

        protected void rptconfig_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                HtmlInputHidden hidserid = (HtmlInputHidden)e.Item.Parent.Parent.FindControl("hidserid");
                DataTable dtserconfig = filterdataset(ds.Tables[3], "serverid", hidserid.Value);
                DataList repinner = (DataList)e.Item.FindControl("rptconfig_inner");
                repinner.DataSource = filterdataset(dtserconfig, "type", DataBinder.Eval(e.Item.DataItem, "type").ToString());
                repinner.DataBind();


            }
        }
        public DataTable filterdataset(DataTable dt, string col, string val)
        {
            DataView dv = new DataView(dt);
            dv.RowFilter = col + "='" + val + "'";
            return dv.ToTable();

        }

        protected void btnback_Click(object sender, EventArgs e)
        {
            btnexportcsv.Visible = true;
            multiview1.ActiveViewIndex = 0;
        }


        /// <summary>
        /// Bind report header with selected parameters and Company Name 
        /// </summary>
        /// <param name="type"></param>
        protected string bindheader(string type)
        {
            string Companyname = System.Web.Configuration.WebConfigurationManager.AppSettings["ServerCompanyName"].ToString();

            string headerstr = "<table width='100%'>";
            if (type == "excel")
            {
                headerstr = "<table width='100%'>";

            }

            headerstr = headerstr +
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
                 <td colspan='5'align='center'>
                                    <h4>
                                        Server Configuration Report
                                    </h4>
                                </td>
                  </tr>
                   <tr>
                     <td>
                                    &nbsp;
                     </td>
                            </tr>

                             </table>";

            return headerstr;
        }

        /// <summary>
        /// Export report to excel
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnexportcsv_Click(object sender, EventArgs e)
        {
            if (multiview1.ActiveViewIndex == 0)
            {
                exportsummary();
            }
            else
            {
                 string rpthtml = bindheader("excel");
                 rpthtml = rpthtml + @"<table width='100%' cellpadding='5' cellspacing='0' style='font-family: Calibri;   font-size: 12px; text-align: left;' border='0'>
<tr><td align='center'>Server Configuration Report</td> </tr>
<tr><td>&nbsp;</td></tr><tr><td>";
                HtmlGenericControl divgen = new HtmlGenericControl();
                StringWriter sw1 = new StringWriter();
                HtmlTextWriter hw1 = new HtmlTextWriter(sw1);
                DivExport.RenderControl(hw1);
                divgen.InnerHtml = rpthtml +  sw1.ToString() + "</td></tr></table>";

                HttpResponse response = HttpContext.Current.Response;
                // first let's clean up the response.object   
                response.Clear();
                response.Charset = "";
                // set the response mime type for excel   
                response.ContentType = "application/vnd.ms-excel";
                response.AddHeader("Content-Disposition", "attachment;filename=\"ServerConfigurationReport.xls\"");
                // create a string writer   
                using (StringWriter sw = new StringWriter())
                {
                    using (HtmlTextWriter htw = new HtmlTextWriter(sw))
                    {
                        System.Web.UI.HtmlControls.HtmlGenericControl dv = new System.Web.UI.HtmlControls.HtmlGenericControl();
                        dv.InnerHtml = divgen.InnerHtml.Replace("border='0'", "border='1'");
                        dv.InnerHtml = divgen.InnerHtml.Replace("border=\"0\"", "border='1'");

                        dv.RenderControl(htw);
                        response.Write(sw.ToString());
                        response.End();
                    }
                }
            }
         
        }

        protected void exportsummary()
        {
            fillgrid();
            if (dsexcel != null)
            {
                if (dsexcel.Tables[0].Rows.Count > 0)
                {
                    string rpthtml = bindheader("excel");
                    rpthtml = rpthtml + @"<table width='100%' cellpadding='5' cellspacing='0' style='font-family: Calibri;   font-size: 12px; text-align: left;' border='0'>
<tr><td colspan='5' align='center'>Configuration Report</td> </tr>
<tr><td colspan='5'>&nbsp;</td></tr>
                         
  <tr style='font-weight: bold; background: #395ba4; color: #ffffff;'>
 <td width='100px' align='left'>S.No.</td>
 <td>Server ID</td>
 <td>Server Name</td>
 <td>Client Name </td>
 <td>Domain</td>                                                        
</tr>";
                    for (int i = 0; i < dsexcel.Tables[0].Rows.Count; i++)
                    {

                        rpthtml = rpthtml + "<tr><td>" + Convert.ToString(i + 1) + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["ServerCode"].ToString() +
                        "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["ServerName"].ToString() + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["clientname"].ToString() +
                        "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["domain"].ToString() + "</td></tr>";
                    }

                    HtmlGenericControl divgen = new HtmlGenericControl();


                    divgen.InnerHtml = rpthtml;
                    HttpResponse response = HttpContext.Current.Response;

                    // first let's clean up the response.object   
                    response.Clear();
                    response.Charset = "";

                    // set the response mime type for excel   
                    response.ContentType = "application/vnd.ms-excel";
                    response.AddHeader("Content-Disposition", "attachment;filename=\"ConfigurationReport.xls\"");

                    // create a string writer   
                    using (StringWriter sw = new StringWriter())
                    {
                        using (HtmlTextWriter htw = new HtmlTextWriter(sw))
                        {
                            System.Web.UI.HtmlControls.HtmlGenericControl dv = new System.Web.UI.HtmlControls.HtmlGenericControl();
                            dv.InnerHtml = divgen.InnerHtml.Replace("border='0'", "border='1'");
                            dv.InnerHtml = divgen.InnerHtml.Replace("colspan='7'", "colspan='9'");
                            //dv.InnerHtml = dv.InnerHtml.Replace("<tr><td colspan='6'><hr style='width:100%;' /></td>", "");

                            dv.RenderControl(htw);
                            response.Write(sw.ToString());
                            response.End();
                        }
                    }

                }
            }

        }



    }
}