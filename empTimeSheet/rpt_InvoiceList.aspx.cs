using System;
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
    public partial class rpt_InvoiceList : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();

        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();

        DataSet ds = new DataSet();
        DataSet dsexcel = new DataSet();
        double amtCurrent = 0, amt1 = 0, amt2 = 0, amt3 = 0, amtBal = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();

            if (!IsPostBack)
            {

                if (!objda.checkUserInroles("46"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }

                txtfromdate.Text = Convert.ToDateTime(GeneralMethod.getLocalDate()).AddMonths(-2).ToString("MM/dd/yyyy");
                txttodate.Text = GeneralMethod.getLocalDate();

                fillclient();
                fillproject();

            }
        }
        /// <summary>
        /// Fill list of existing clients For Search
        /// </summary>
        public void fillclient()
        {
            ClsUser objuser = new ClsUser();
            objuser.action = "select";

            objuser.name = "";
            objuser.id = "";
            objuser.companyid = Session["companyId"].ToString();
            ds = objuser.client();
            if (ds.Tables[0].Rows.Count > 0)
            {
                dropclient.DataSource = ds;
                dropclient.DataTextField = "clientcodewithname";
                dropclient.DataValueField = "nid";
                dropclient.DataBind();
                ListItem li = new ListItem("--All Clients--", "");
                dropclient.Items.Insert(0, li);
                dropclient.SelectedIndex = 0;

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
            updatePanelSearch.Update();

        }
        protected void drpclient_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            fillproject();
        }

        protected void fillgrid()
        {
            Session["TaskTable"] = null;

            objts.action = "selectreport";
            objts.companyId = Session["companyid"].ToString();
            objts.clientid = hidclients.Value;
            objts.projectid = hidprojects.Value;
            objts.invoiceno = hidinvoiceno.Value;
            objts.from = hidfromdate.Value;
            objts.to = hidtodate.Value;
            objts.Status = "";
            objts.nid = "";
            objts.remark = "";

            objts.type = "generated";
            ds = objts.GetInvoice();

           

            if (ds.Tables[0].Rows.Count > 0)
            {
                Session["TaskTable"] = ds.Tables[0];
                dgnews.DataSource = ds;
                dgnews.DataBind();
                //  btnexportcsv.Enabled = true;
                divreport.Visible = true;
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
                divreport.Visible = false;
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
            
          
            litamount1.Text = "$" + amt1.ToString("0.00");
            litamount2.Text = "$" + amt2.ToString("0.00");
           
        }


        /// <summary>
        /// Bind list of existing Members
        /// </summary>
        protected void btnsearch_click(object sender, EventArgs e)
        {
            searchdata();
        }
        protected void searchdata()
        {
            hidprojectname.Value = dropproject.SelectedItem.Text;
            hidclientname.Value = dropclient.SelectedItem.Text;
            hidfromdate.Value = txtfromdate.Text;
            hidtodate.Value = txttodate.Text;
            hidprojects.Value = dropproject.Text;
            hidclients.Value = dropclient.Text;
            hidinvoiceno.Value =txtinvno.Text;
            fillgrid();

            
        }


        protected void dgnews_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
             
                amt1 += Convert.ToDouble(DataBinder.Eval(e.Row.DataItem, "subamount").ToString());
                amt2 += Convert.ToDouble(DataBinder.Eval(e.Row.DataItem, "totalamount").ToString());
              



            }
        }

        /// <summary>
        /// Fires when any button clicks from given list
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>


        #region SORTING


        /// <summary>
        /// When data row creates, check column is sorted then check for its current sorting order and apply arrow image according to that
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
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
                                    image.ImageUrl = System.Web.Configuration.WebConfigurationManager.AppSettings["SchedulerURL"] + "/images/asc.png";
                                }
                                else
                                {
                                    image.ImageUrl = System.Web.Configuration.WebConfigurationManager.AppSettings["SchedulerURL"] + "/images/desc.png";
                                }
                                cell.Controls.Add(image);
                                // return;
                            }
                            else
                            {
                                image.ImageUrl = System.Web.Configuration.WebConfigurationManager.AppSettings["SchedulerURL"] + "/images/updown.png";
                                cell.Controls.Add(image);
                            }
                        }
                        else
                        {
                            image.ImageUrl = System.Web.Configuration.WebConfigurationManager.AppSettings["SchedulerURL"] + "/images/updown.png";
                            cell.Controls.Add(image);
                        }
                    }
                }
            }
        }

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
                DataTable dtnew = dt.Clone();

                foreach (DataRow dr in dt.Rows)
                {
                    dtnew.ImportRow(dr);
                }
                //Sort the data.
                dtnew.DefaultView.Sort = e.SortExpression + " " + GetSortDirection(e.SortExpression);
                dgnews.DataSource = dtnew;
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

        #region PAGING
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
        /// Move to previous page from current page
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
        /// Move to next page from current page
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

        #endregion
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
        public override void VerifyRenderingInServerForm(Control control)
        {
            /* Verifies that the control is rendered */
        }
        protected void btnexportpdf_Click(object sender, EventArgs e)
        {
            bindheader();
            Session["ctrl"] = null;

            Session["ctrl"] = divreport;

            string url = "PrintPDFDoc.aspx";
            string s = "window.open('" + url + "', '_blank');";

            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>" + s + "</script>", false);
        }






        protected void bindheader()
        {
            string str = "";
            string Companyname = Session["companyname"].ToString();
            string companyaddress = Session["companyaddress"].ToString();

            string headerstr = "<table width='100%'>";


            str = headerstr +
        @"
            
            <tr><td style='width:70%;'></td><td style='width:30%;border:solid 2px #1caf9a;'>
                <h3>
                    
Invoice List
                </h3></td></tr><tr><td height='10'>&nbsp;</td></tr>
            

<tr><td  style='width:70%;'>
                <h2>
                   " + Companyname + @"
                </h2>
        </td><td align='right' style='font-size:11px;'>Printed on: " + GeneralMethod.getLocalDateTime() + @"</td></tr>
<tr><td>
                <h5>
                   " + companyaddress + @"
                </h5>
         </td></tr>
   <tr><td  style='width:70%;' height='10'>&nbsp;</td><td  style='width:30%;'></td></tr></table>";


            Session["header"] = str;
            Session["css"] = "invlist";
        }
    }

}