using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.UI.HtmlControls;
using System.IO;
using Microsoft.Reporting.WebForms;

namespace empTimeSheet
{
    public partial class InvoiceReview : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();
        DataSet ds1 = new DataSet();
        ClsAdmin objadmin = new ClsAdmin();
        excelexport objexcel = new excelexport();
        DataSet dsexcel = new DataSet();
        public string strcurrency = "$";
        protected void Page_Load(object sender, EventArgs e)
        {

            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                txtfromdate.Text = "01/01/" + (DateTime.Now.Year).ToString() + "";
                txttodate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");

                if (!objda.checkUserInroles("37"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
                if (objda.checkUserInroles("40"))
                {
                    ViewState["edit"] = "1";
                }
                else
                {
                    ViewState["edit"] = null;

                }
                fillstate();
                fillclient();
                fillproject();
                fillcurrency();
                searchdata();
            }
        }
        protected void fillstate()
        {
            dropstate.Items.Clear();

            objda.id = "";
            objda.parentid = "";
            objda.action = "selectstate";
            ds1 = objda.ManageMaster();
            dropstate.DataSource = ds1;
            dropstate.DataTextField = "statename";
            dropstate.DataValueField = "nid";
            dropstate.DataBind();

            ListItem li = new ListItem("--All States--", "");

            dropstate.Items.Insert(0, li);
            dropstate.SelectedIndex = 0;
        }

        protected void searchdata()
        {
            hidprojectname.Value = dropproject.SelectedItem.Text;
            hidclientname.Value = dropclient.SelectedItem.Text;
            hidfromdate.Value = txtfromdate.Text;
            hidtodate.Value = txttodate.Text;
            hidprojects.Value = dropproject.Text;
            hidclients.Value = dropclient.Text;
            hidinvoiceno.Value = txtinvno.Text;
            fillgrid();
        }
        /// <summary>
        /// Bind currency according to current company
        /// </summary>
        protected void fillcurrency()
        {
            objadmin.action = "select";
            objadmin.nid = Session["companyid"].ToString();
            ds = objadmin.ManageCompany();
            if (ds.Tables[0].Rows.Count > 0)
            {
                strcurrency = ds.Tables[0].Rows[0]["symbol"].ToString();
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

        }
        protected void ddlclient_SelectedIndexChanged(object sender, EventArgs e)
        {
            //fillpopproject();
            ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);

        }
        protected void dropclient_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            fillproject();
            updatePanelSearch.Update();
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
             
            }
            ListItem li = new ListItem("--All Clients--", "");
            dropclient.Items.Insert(0, li);
        }
        protected void fillgrid()
        {
            Session["TaskTable"] = null;

            objts.action = "select";
            objts.companyId = Session["companyid"].ToString();
            objts.clientid = hidclients.Value;
            objts.projectid = hidprojects.Value;
            objts.invoiceno = hidinvoiceno.Value;
            objts.from = hidfromdate.Value;
            objts.to = hidtodate.Value;
            objts.Status = "";
            objts.nid = "";
            if (dropstate.Text != "")
            {
                objts.remark = dropstate.SelectedItem.Text;
            }
            else
            {
                objts.remark = "";
            }

            objts.type = "generated";
            ds = objts.GetInvoice();



            if (ds.Tables[0].Rows.Count > 0)
            {
                Session["TaskTable"] = ds.Tables[0];
                dgnews.DataSource = ds;
                dgnews.DataBind();
                //  btnexportcsv.Enabled = true;

                divnodata.Visible = false;
                dgnews.Visible = true;



            }
            else
            {

                //  btnexportcsv.Enabled = false;
                if (IsPostBack)
                {
                    divnodata.Visible = true;
                }
                dgnews.Visible = false;

                Session["TaskTable"] = null;
            }
            updatePanelData.Update();
            dsexcel = ds;
            ScriptManager.RegisterStartupScript(updatePanelData, updatePanelData.GetType(), "key", "<script type='text/javascript'>fixheader();</script>", false);
        }


        /// <summary>
        /// Makes row as clickable and show and hide Set status link according to current status and user role
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dgnews_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.Header)
                e.Row.TableSection = TableRowSection.TableHeader;

            if (e.Row.RowType == DataControlRowType.Footer)
                e.Row.TableSection = TableRowSection.TableFooter;
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Cells[0].Attributes.Add("onclick", Page.ClientScript.GetPostBackClientHyperlink(dgnews, "RowCommand$" + DataBinder.Eval(e.Row.DataItem, "nid").ToString()));
                e.Row.Cells[1].Attributes.Add("onclick", Page.ClientScript.GetPostBackClientHyperlink(dgnews, "RowCommand$" + DataBinder.Eval(e.Row.DataItem, "nid").ToString()));
                e.Row.Cells[2].Attributes.Add("onclick", Page.ClientScript.GetPostBackClientHyperlink(dgnews, "RowCommand$" + DataBinder.Eval(e.Row.DataItem, "nid").ToString()));
                e.Row.Cells[3].Attributes.Add("onclick", Page.ClientScript.GetPostBackClientHyperlink(dgnews, "RowCommand$" + DataBinder.Eval(e.Row.DataItem, "nid").ToString()));
                e.Row.Cells[4].Attributes.Add("onclick", Page.ClientScript.GetPostBackClientHyperlink(dgnews, "RowCommand$" + DataBinder.Eval(e.Row.DataItem, "nid").ToString()));
                e.Row.Cells[5].Attributes.Add("onclick", Page.ClientScript.GetPostBackClientHyperlink(dgnews, "RowCommand$" + DataBinder.Eval(e.Row.DataItem, "nid").ToString()));
                e.Row.Cells[6].Attributes.Add("onclick", Page.ClientScript.GetPostBackClientHyperlink(dgnews, "RowCommand$" + DataBinder.Eval(e.Row.DataItem, "nid").ToString()));
                e.Row.Cells[7].Attributes.Add("onclick", Page.ClientScript.GetPostBackClientHyperlink(dgnews, "RowCommand$" + DataBinder.Eval(e.Row.DataItem, "nid").ToString()));

                e.Row.Attributes["onmouseover"] = "this.style.cursor='pointer'";
                LinkButton btndel = (LinkButton)e.Row.FindControl("lbtndelete");
                HtmlAnchor lbtnedit = (HtmlAnchor)e.Row.FindControl("lbtnedit");
                Literal ltrpaidamountthroughinvoice = (Literal)e.Row.FindControl("ltrpaidamountthroughinvoice");
                Literal ltrpaidamount = (Literal)e.Row.FindControl("ltrpaidamount");

                if (ViewState["edit"] == null)
                {
                    lbtnedit.Visible = false;
                }
                else
                {
                    //If recived paymeny for invoice then disable edit on it.
                    if (ltrpaidamount.Text != "")
                    {
                        if (Convert.ToDecimal(ltrpaidamount.Text) > 0)
                        {
                            lbtnedit.Visible = false;
                        }
                    }
                }

                if (DataBinder.Eval(e.Row.DataItem, "paymentstatus").ToString().ToLower() == "paid")
                {
                    e.Row.Cells[8].Attributes.Add("onclick", Page.ClientScript.GetPostBackClientHyperlink(dgnews, "RowCommand$" + DataBinder.Eval(e.Row.DataItem, "nid").ToString()));
                    lbtnedit.Visible = false;
                    btndel.Visible = false;
                }
                else
                {
                    objts.action = "checkinvoiceexistsinpayment";
                    objts.invoiceno = DataBinder.Eval(e.Row.DataItem, "nid").ToString();
                    ds1 = objts.GetPaymentDetails();
                    if (ds.Tables.Count > 0)
                    {
                        if (ds1.Tables[0].Rows.Count > 0)
                        {
                            btndel.Visible = false;
                        }
                    }
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
                objts.GetInvoice();
                fillgrid();
            }
            if (e.CommandName.ToLower() == "rowcommand")
            {
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('ViewInvoice.aspx?invoiceid=" + e.CommandArgument.ToString() + "','_blank');", true);

            }
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
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            searchdata();

        }
        protected void btnrefresh_Click(object sender, EventArgs e)
        {
            searchdata();
        }
        protected void PaggedGridbtnedit_Click(object sender, EventArgs e)
        {
            string HTMLTemplatePath = Server.MapPath("EmailTemplates/invEmail.html");
            string HTMLBODY = File.Exists(HTMLTemplatePath) ? File.ReadAllText(HTMLTemplatePath) : "";
            try
            {
                string p = Server.MapPath("rdlcreport\\invoice");
                string logosmall = "";
                string logobig = "";
                string writepath ="";

                //   ReportViewer1.ProcessingMode = ProcessingMode.Local;
                //LocalReport rep = ReportViewer1.LocalReport;

                //reportViewer1.LocalReport.ReportEmbeddedResource = System.IO.Directory.GetCurrentDirectory() + @"\Reports\Rdlc\PaidBill_Check.rdlc";
                objts.nid = hidid.Value;
                ds = objts.printinvoice();

                if (ds.Tables[0].Rows.Count > 0)
                {

                   HTMLBODY= HTMLBODY.Replace("#CompanyName#", ds.Tables[0].Rows[0]["companyname"].ToString());
                   HTMLBODY= HTMLBODY.Replace("#ClientID#", ds.Tables[0].Rows[0]["clientcode"].ToString());
                   HTMLBODY= HTMLBODY.Replace("#ProjectID#", ds.Tables[0].Rows[0]["projectcode"].ToString());
                   HTMLBODY= HTMLBODY.Replace("#InvNo#", ds.Tables[0].Rows[0]["invoiceno"].ToString());
                  HTMLBODY=  HTMLBODY.Replace("#InvAmount#", ds.Tables[0].Rows[0]["amountdue"].ToString());
                  HTMLBODY = HTMLBODY.Replace("#InvDueAmount#", ds.Tables[0].Rows[0]["amountdue"].ToString());
                  HTMLBODY = HTMLBODY.Replace("#InvAmount#", ds.Tables[0].Rows[0]["totalamount"].ToString());
                   HTMLBODY= HTMLBODY.Replace("#ClientName#", ds.Tables[0].Rows[0]["clientname"].ToString());
                   HTMLBODY= HTMLBODY.Replace("#ProjectName#", ds.Tables[0].Rows[0]["projectname"].ToString());
                   HTMLBODY= HTMLBODY.Replace("#InvDate#", ds.Tables[0].Rows[0]["invoicedate"].ToString());

                    txtsubject.Text = " Invoice from  " + ds.Tables[0].Rows[0]["companyname"].ToString();
                   
                    txtreceiver.Text = ds.Tables[0].Rows[0]["clientemail"].ToString();

                    writepath = Server.MapPath("webfile\\temp\\invoice_" + ds.Tables[0].Rows[0]["invoiceno"].ToString() + ".pdf");

                    litfilename.Text = "<a target='_blank' href='webfile/temp/invoice_" + ds.Tables[0].Rows[0]["invoiceno"].ToString() + ".pdf'>  <img src='Libraryimg/pdf.png' />" + ds.Tables[0].Rows[0]["invoiceno"].ToString() + ".pdf </a>";

                }
                Editor1.Content = HTMLBODY;


                int num = 8;
                if (ds.Tables[3].Rows[0]["nid"].ToString() == "1")
                    num = 2;


                if (ds.Tables[1].Rows.Count < num)
                {
                    for (int i = ds.Tables[1].Rows.Count; i <= num; i++)
                    {
                        DataRow row = ds.Tables[1].NewRow();

                        ds.Tables[1].Rows.Add(row);

                    }
                    ds.Tables[1].AcceptChanges();
                }


                Warning[] warnings;
                string[] streamIds;
                string mimeType = string.Empty;
                string encoding = string.Empty;
                string extension = string.Empty;


                ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);
                updateemail.Update();

                ReportParameter[] param = new ReportParameter[1];

                if (ds.Tables[0].Rows[0]["logosmall"].ToString() == "")
                {
                    logosmall = "images\\nologo.png";

                }
                else
                {
                    logosmall = "webfile\\" + ds.Tables[0].Rows[0]["logosmall"].ToString();

                }

                if (ds.Tables[0].Rows[0]["logoURL"].ToString() == "")
                {
                    logobig = "images\\nologo.png";

                }
                else
                {
                    logobig = "webfile\\" + ds.Tables[0].Rows[0]["logoURL"].ToString();

                }
                param[0] = new ReportParameter("filename", "file:\\" + Server.MapPath(logobig), true);
               // param[1] = new ReportParameter("logosmall", "file:\\" + Server.MapPath(logosmall), true);


                ReportDataSource rds1 = new ReportDataSource("DataSet1", ds.Tables[0]);
                ReportDataSource rds2 = new ReportDataSource("DataSet2", ds.Tables[1]);
                ReportDataSource rds3 = new ReportDataSource("DataSet3", ds.Tables[2]);


                ReportViewer viewer = new ReportViewer();

                viewer.LocalReport.Refresh();
                viewer.LocalReport.ReportPath = p + "\\" + ds.Tables[3].Rows[0]["rdlcfile"].ToString();
                viewer.LocalReport.EnableExternalImages = true;
                viewer.LocalReport.SetParameters(param);
                viewer.LocalReport.DataSources.Add(rds1); // Add  datasource here      
                viewer.LocalReport.DataSources.Add(rds2);
                viewer.LocalReport.DataSources.Add(rds3);

                viewer.LocalReport.DisplayName = ds.Tables[0].Rows[0]["invoiceno"].ToString();
                byte[] bytes = viewer.LocalReport.Render("PDF", null, out mimeType, out encoding, out extension, out streamIds, out warnings);

               

                FileStream fs = new FileStream(writepath, FileMode.Create);
                fs.Write(bytes, 0, bytes.Length);
                fs.Close();

                Session["invoicenum"] = "invoice_" + ds.Tables[0].Rows[0]["invoiceno"].ToString()+".pdf";




            }
            catch (System.Threading.ThreadAbortException lException)
            {


                // do nothing

            }
            catch (Exception ex)
            {
                Session["invoicenum"] = null;
            }
        }
        protected void btnsubmit_Click(object sender, EventArgs e)
        {
            if (Session["invoicenum"] != null && Convert.ToString(Session["invoicenum"]) != "")
            {
                try
                {
                    string msg = objda.SendEmail(txtreceiver.Text+",", txtsubject.Text, Editor1.Content, "", "", Session["invoicenum"].ToString());
                    if (msg == "Sent")
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>alert('Email sent successfully!');</script>", false);
                    }
                }
                catch
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();alert('Error in sending email!');</script>", false);

                }


            }
            else
            {

                ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();alert('Error in generating invoice, Please try again later!');</script>", false);
            }

        }

        #region Export
        protected string bindheader(string type)
        {
            string str = "";
            string Companyname = Session["companyname"].ToString();
            string companyaddress = Session["companyaddress"].ToString();
            string client = "<b>Client:</b> ", date = "<b>Date:</b> ", projectname = "<b>Project: </b>";
            if (hidclients.Value == "")
            {
                client += "All";
            }
            else
            {
                client += hidclientname.Value;
            }
            if (hidprojects.Value == "")
            {
                projectname += "All";
            }
            else
            {
                projectname += hidprojectname.Value;
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
            <td colspan='7' align='left'>
                <h2>
                   " + Companyname + @"
                </h2>
            </td>
        </tr>
<tr>
            <td colspan='7' align='left'>
                <h4>
                   " + companyaddress + @"
                </h4>
            </td>
        </tr>
        <tr>
            <td colspan='7' align='left'>
                <h4>
                   Invoice Review Report
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
        " + date + "<br/>" + client + "<br/>" +

       @"</td>

        </tr>
       <tr>
        <td colspan='7'>&nbsp;</td></tr>
       </table><table width='100%' cellpadding='5' cellspacing='0' style='font-family: Calibri;
                        font-size: 12px; text-align: left;' border='1'>
                       
                         
  <tr style='font-weight: bold; background: #395ba4; color: #ffffff;'>
 <td>S.No.</td>
 <td>Invoice No.</td>
 <td>Date</td>
 <td>Project Code</td>
 <td>Project Name</td>
 <td>Total amount</td>
  <td>Amount Paid</td>
<td>Due Amount</td>
                                                               
</tr>";
            return str;


        }
        protected void btnexportcsv_Click(object sender, EventArgs e)
        {

            fillgrid();
            string rpthtml = bindheader("excel");
            for (int i = 0; i < dsexcel.Tables[0].Rows.Count; i++)
            {
                rpthtml = rpthtml + "<tr><td>" + Convert.ToString(i + 1) + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["invoiceno"].ToString() +
                    "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["invoicedate"].ToString() + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["projectCode"].ToString() + "</td>" +
                   "<td>" + dsexcel.Tables[0].Rows[i]["projectname"].ToString() + "</td>" + "<td>" + strcurrency + dsexcel.Tables[0].Rows[i]["totalamount"].ToString() + "<td>"
                   + strcurrency + dsexcel.Tables[0].Rows[i]["invoicepaidamount"].ToString() + "</td>" + "<td>" + strcurrency + dsexcel.Tables[0].Rows[i]["invoicedueamount"].ToString() + "</td></tr>";

                //rpthtml = rpthtml + "<tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td<td>&nbsp;</td><td>&nbsp;</td>" + "<td>&nbsp;</td></td></tr>";
            }

            HtmlGenericControl divgen = new HtmlGenericControl();


            divgen.InnerHtml = rpthtml;
            HttpResponse response = HttpContext.Current.Response;

            // first let's clean up the response.object   
            response.Clear();
            response.Charset = "";

            // set the response mime type for excel   
            response.ContentType = "application/vnd.ms-excel";
            response.AddHeader("Content-Disposition", "attachment;filename=\"InvoiceReviewReport.xls\"");

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
                DataView view = new DataView(dt);
                view.Sort = e.SortExpression + " " + GetSortDirection(e.SortExpression);


                DataTable sortedDT = view.ToTable();



                dgnews.DataSource = sortedDT;
                dgnews.DataBind();
                updatePanelData.Update();
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
    }
}