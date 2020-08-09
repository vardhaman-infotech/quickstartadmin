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
    public partial class ServerLogReport : System.Web.UI.Page
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
                if (!objda.validatedRoles("13", ds))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
                txtfromdate.Text = System.DateTime.Now.AddDays(-7).ToString("MM/dd/yyyy");
                txttodate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");
                multiview1.ActiveViewIndex = 0;
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

            ListItem li = new ListItem("--Select Client--", "");
            dropclient.Items.Insert(0, li);
            dropclient.SelectedIndex = 0;
        }

        public void filllogentryrepeter()
        {
            objserver.action = "select";
            //objserver = "";
            objserver.nid = "";
            objserver.logid = hidid.Value;

            objserver.companyid = Session["companyId"].ToString();
            //objserver.clientname = "";
            //objuser.companyid = Session["companyId"].ToString();
            ds = objserver.ServerLogDetail();
            if (ds.Tables[0].Rows.Count > 0)
            {
                // rptlogentry.DataSource = ds;
                // rptlogentry.DataBind();
                //multiview1.ActiveViewIndex = 2;
                //ListItem li = new ListItem("--All Server--", "");
                //ddlserver.Items.Insert(0, li);
                //ddlserver.SelectedIndex = 0;

            }
        }

        protected void bindattachment()
        {
            objserver.action = "selectfile";
            objserver.logid = hidid.Value;

            ds = objserver.ServerLogDetail();
            if (ds.Tables[0].Rows.Count > 0)
            {
                //trattachment.Visible = true;
                //trlink.Visible = false;
                // repattachment.DataSource = ds;
                // repattachment.DataBind();

            }

        }
        /// <summary>
        /// When selects a client
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dropclient_SelectedIndexChanged(object sender, EventArgs e)
        {
            fillsever();
            updatePanelSearch.Update();
        }

        protected void dgnews_ItemCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName.ToLower() == "viewdetail")
            {
                string[] args = e.CommandArgument.ToString().Split(';');

                fillFullReport(args[0], args[0], args[1]);

                multiview1.ActiveViewIndex = 1;
            }
            if (e.CommandName.ToLower() == "download")
            {
                objserver.action = "selectfile";
                ds = objserver.ServerLogDetail();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    repattachment1.DataSource = ds.Tables[0];
                    repattachment1.DataBind();
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>openattach();</script>", false);
                }
                return;
            }
            if (e.CommandName == "showlog")
            {
                string[] args = e.CommandArgument.ToString().Split(';');
                objserver.logid = args[0];
                objserver.action = "select";
                objserver.logtype = args[1];
                ds = objserver.ServerLogDetail();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    ltrloghead.Text = args[1] + " Log Details";
                    rptstatus.DataSource = ds;
                    rptstatus.DataBind();
                    ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);
                }

            }

        }


        public void fillFullReport(string from, string to, string serverid)
        {
            objserver.from = from;
            objserver.to = to;
            objserver.action = "getCompleteReport";
            objserver.nid = serverid;
            objserver.companyid = Session["companyid"].ToString();
            ds = objserver.ServerLog();
            litfromdate.Text = from;
            littodate.Text = to;

            rptinner.DataSource = ds;
            rptinner.DataBind();

            if (ds.Tables[1].Rows.Count > 0)
            {
                rptconfig.DataSource = ds.Tables[1];
                rptconfig.DataBind();
                rptconfig.Visible = true;
                div1.Visible = false;

            }
            else
            {
                rptconfig.Visible = false;
                div1.Visible = true;
            }

            if (ds.Tables[3].Rows.Count > 0)
            {
                replogreport.DataSource = ds.Tables[3];
                replogreport.DataBind();
                replogreport.Visible = true;
                divnolog.Visible = false;
            }
            else
            {
                divnolog.Visible = true;
                replogreport.Visible = false;

            }

            dsexcel = ds;
        }
        protected void dgnews_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                LinkButton lbtncritical = (LinkButton)e.Row.FindControl("lbtncritical");
                LinkButton lbtnerror = (LinkButton)e.Row.FindControl("lbtnerror");
                LinkButton lbtnwarning = (LinkButton)e.Row.FindControl("lbtnwarning");
                LinkButton lbtnattachment = (LinkButton)e.Row.FindControl("lbtnattachment");

                if (Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "criticallog").ToString()) <= 0)
                {
                    lbtncritical.Attributes["onclick"] = "return false;";
                }
                if (Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "errorlog").ToString()) <= 0)
                {
                    lbtnerror.Attributes["onclick"] = "return false;";
                }
                if (Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "warninglog").ToString()) <= 0)
                {
                    lbtnwarning.Attributes["onclick"] = "return false;";
                }
                if (Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "numofattachment").ToString()) <= 0)
                {
                    lbtnattachment.Text = "";
                }
                else
                {
                    lbtnattachment.Text = "Attachment (" + DataBinder.Eval(e.Row.DataItem, "numofattachment").ToString() + ")";
                }

            }
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
            objserver.action = "getreport";
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
        protected void btnFullReport_click(object sender, EventArgs e)
        {

            if (dropserver.Text != "")
            {

                fillFullReport(txtfromdate.Text, txttodate.Text, dropserver.Text);
          
                        multiview1.ActiveViewIndex = 1;
                
            }
            else
            {
                GeneralMethod.alert(this, "Select a server name");
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




        protected void btn_back1_Click(object sender, EventArgs e)
        {
            multiview1.ActiveViewIndex = 0;

        }



        public string setname(string name)
        {

            if (name.Length <= 18)
                return name;
            else
            {
                int pos = name.LastIndexOf('.') + 1;
                int len = name.Length - 1;
                string ext = name.Substring(pos, len - pos + 1);
                string name2 = name.Substring(0, pos);
                return name.Substring(0, 15) + "..." + ext;
            }

        }

        protected void repattachment1_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "download")
            {
                string[] args = e.CommandArgument.ToString().Split(';');


                try
                {
                    if (!objexcel.downloadVirturalfile(args[0], args[1], "webfile/serverfiles"))
                    {
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('File is not available or temporarily removed');</script>", false);
                        return;
                    }




                }
                catch
                {
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('File is not available or temporarily removed');</script>", false);
                    return;
                }


            }
        }
        protected void repattachment_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "download")
            {
                string[] args = e.CommandArgument.ToString().Split(';');


                try
                {
                    if (!objexcel.downloadVirturalfile(args[0], args[1], "webfile/serverfiles"))
                    {
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('File is not available or temporarily removed');</script>", false);
                        return;
                    }




                }
                catch
                {
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('File is not available or temporarily removed');</script>", false);
                    return;
                }


            }
            if (e.CommandName == "delete")
            {

            }

            //if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            //{
            //    Repeater repattachment = (Repeater)e.Item.FindControl("repattachment");
            //}

        }
        protected void rptconfig_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {

                DataList repinner = (DataList)e.Item.FindControl("rptconfig_inner");
                repinner.DataSource = filterdataset(ds.Tables[2], "type", DataBinder.Eval(e.Item.DataItem, "type").ToString());
                repinner.DataBind();


            }
        }
        public DataTable filterdataset(DataTable dt, string col, string val)
        {
            DataView dv = new DataView(dt);
            dv.RowFilter = col + "='" + val + "'";
            return dv.ToTable();

        }
        protected void replogreport_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                if (DataBinder.Eval(e.Item.DataItem, "isupdated") != null && DataBinder.Eval(e.Item.DataItem, "isupdated").ToString() != "Yes")
                {
                    HtmlGenericControl divUpdateSummary = (HtmlGenericControl)e.Item.FindControl("divUpdateSummary");
                    divUpdateSummary.Visible = false;
                }
                Repeater repinner = (Repeater)e.Item.FindControl("rptlogentry");
                repinner.DataSource = filterdataset(ds.Tables[4], "logid", DataBinder.Eval(e.Item.DataItem, "nid").ToString());
                repinner.DataBind();

                Repeater repattachment = (Repeater)e.Item.FindControl("repattachment");
                DataTable dtattach = filterdataset(ds.Tables[5], "logid", DataBinder.Eval(e.Item.DataItem, "nid").ToString());
                if (dtattach.Rows.Count > 0)
                {
                    repattachment.DataSource = dtattach;
                    repattachment.DataBind();
                }
                else
                {
                    HtmlGenericControl divnoattachment = (HtmlGenericControl)e.Item.FindControl("divnoattachment");
                    divnoattachment.Visible = true;
                }

            }
        }


        //------------------ EXPORT to EXCEL


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
                    <td  align='center' colspan='7'>
                        <h1>
                            " + Companyname + @"
                        </h1>
                    </td>
                </tr>
             
               <tr>
                <td colspan='7'>&nbsp;</td></tr>
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
                fillexcelreport();
                ltrreport.Text = bindheader("excel");

                HtmlGenericControl divgen = new HtmlGenericControl();
                StringWriter sw1 = new StringWriter();
                HtmlTextWriter hw1 = new HtmlTextWriter(sw1);
                divdetailreport.RenderControl(hw1);
                divgen.InnerHtml = sw1.ToString();
                HttpResponse response = HttpContext.Current.Response;
                // first let's clean up the response.object   
                response.Clear();
                response.Charset = "";
                // set the response mime type for excel   
                response.ContentType = "application/vnd.ms-excel";
                response.AddHeader("Content-Disposition", "attachment;filename=\"ServerLogReport.xls\"");
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

                rptinner1.DataSource = null;
                rptinner1.DataBind();

                rptconfig1.DataSource = null;
                rptconfig1.DataBind();

                replogreport1.DataSource = null;
                replogreport1.DataBind();
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
<tr><td colspan='9' align='center'>Server Log Summary Report</td> </tr>
<tr><td colspan='9'>&nbsp;</td></tr>
                         
  <tr style='font-weight: bold; background: #395ba4; color: #ffffff;'>
 <td>S.No.</td>
 <td>Date</td>
 <td>Server ID</td>
 <td>Server Name</td>
 <td>RAM Utilization</td>
 <td>CPU Utilization</td>
  <td>Free Space</td>
<td>Critical</td>
<td>Error</td>
<td>Warning</td>
                                                          
</tr>";
                    for (int i = 0; i < dsexcel.Tables[0].Rows.Count; i++)
                    {

                        rpthtml = rpthtml + "<tr><td>" + Convert.ToString(i + 1) + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["date"].ToString() +
                        "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["ServerCode"].ToString() + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["ServerName"].ToString() + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["Ramutilization"].ToString() + "</td>" +
                       "<td>" + dsexcel.Tables[0].Rows[i]["CPUUtilization"].ToString() + "</td><td>"
                       + dsexcel.Tables[0].Rows[i]["Usedspace"].ToString() + "</td><td>"
                       + dsexcel.Tables[0].Rows[i]["criticallog"].ToString() + "</td><td>"
                       + dsexcel.Tables[0].Rows[i]["errorlog"].ToString() + "</td><td>"
                       + dsexcel.Tables[0].Rows[i]["warninglog"].ToString() + "</td></tr>";
                    }

                    HtmlGenericControl divgen = new HtmlGenericControl();


                    divgen.InnerHtml = rpthtml;
                    HttpResponse response = HttpContext.Current.Response;

                    // first let's clean up the response.object   
                    response.Clear();
                    response.Charset = "";

                    // set the response mime type for excel   
                    response.ContentType = "application/vnd.ms-excel";
                    response.AddHeader("Content-Disposition", "attachment;filename=\"ServerLogSummary.xls\"");

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

        protected void btnback_Click(object sender, EventArgs e)
        {
            multiview1.ActiveViewIndex = 0;
        }

        /// <summary>
        /// Fill Report to Export to Excel
        /// </summary>
        public void fillexcelreport()
        {

            litfromdate1.Text = txtfromdate.Text;
            littodate1.Text = txttodate.Text;
            rptinner1.DataSource = dsexcel;
            rptinner1.DataBind();

            if (dsexcel.Tables[1].Rows.Count > 0)
            {
                rptconfig1.DataSource = dsexcel.Tables[1];
                rptconfig1.DataBind();
                rptconfig1.Visible = true;
                div1.Visible = false;

            }
            else
            {
                rptconfig1.Visible = false;
                div1.Visible = true;
            }

            if (dsexcel.Tables[3].Rows.Count > 0)
            {
                replogreport1.DataSource = dsexcel.Tables[3];
                replogreport1.DataBind();
                replogreport1.Visible = true;
            }
            else
            {
                replogreport1.Visible = false;

            }


        }
        protected void rptconfig1_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {

                DataList repinner = (DataList)e.Item.FindControl("rptconfig_inner1");
                repinner.DataSource = filterdataset(dsexcel.Tables[2], "type", DataBinder.Eval(e.Item.DataItem, "type").ToString());
                repinner.DataBind();


            }
        }
        protected void replogreport1_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {

                Repeater repinner = (Repeater)e.Item.FindControl("rptlogentry1");
                repinner.DataSource = filterdataset(dsexcel.Tables[4], "logid", DataBinder.Eval(e.Item.DataItem, "nid").ToString());
                repinner.DataBind();

            }
        }
    }
}