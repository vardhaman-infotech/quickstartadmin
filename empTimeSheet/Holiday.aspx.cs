using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.UI.HtmlControls;
using System.IO;
using System.Collections;

namespace empTimeSheet
{
    public partial class Holiday : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        DataSet ds = new DataSet();
        GeneralMethod objgen = new GeneralMethod();
        ClsPayroll objpayroll = new ClsPayroll();
        static DataSet dsexcel = new DataSet();
        excelexport objexcel = new excelexport();
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                if (objda.checkUserInroles("18"))
                {

                    ViewState["add"] = "1";
                    dgnews.Columns[3].Visible = true;
                 

                }
                else
                {
                    liaddnew.Visible = false;
                    ViewState["add"] = null;
                    dgnews.Columns[3].Visible = false;
                   
                }

                txtdate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");
                fillyear();
               
                fillbranch();
                fillgrid();

            }

        }

        protected void fillbranch()
        {
            objda.company = Session["companyid"].ToString();
            objda.action = "select";
            objda.id="";
            ds = objda.ManageBranch();
            if (ds.Tables[0].Rows.Count > 0)
            {
                dropbranch.DataTextField = "branchname";
                dropbranch.DataValueField = "nid";
                dropbranch.DataSource = ds;
                dropbranch.DataBind();
                ListItem li = new ListItem("--All Branches--", "");
                dropbranch.Items.Insert(0, li);

                dropbranchsearch.DataTextField = "branchname";
                dropbranchsearch.DataValueField = "nid";
                dropbranchsearch.DataSource = ds;
                dropbranchsearch.DataBind();
                ListItem li1 = new ListItem("--All Branches--", "");
                dropbranchsearch.Items.Insert(0, li);

                dropbranchsearch.Text = Session["branch"].ToString();

                if (ViewState["add"] != null && ViewState["add"].ToString() == "1")
                {
                    dropbranchsearch.Enabled = true;
                }
                else
                {
                    dropbranchsearch.Enabled = false;
                }
            }
        }

        /// <summary>
        /// Fill year drop down where fill year from 2013 to current year
        /// </summary>
        protected void fillyear()
        {

            var al = new ArrayList();

            for (var i = System.DateTime.Now.AddYears(1).Year; i >=1999; i--)
            {
                al.Add(i);
            }
            dropyear.DataSource = al;
            dropyear.DataBind();
            dropyear.Text = System.DateTime.Now.Year.ToString();
        }

        //Fill Holiday in Grid
        public void fillgrid()
        {
            objpayroll.nid = "";
            objpayroll.action = "select";
            objpayroll.companyid = Session["companyid"].ToString();
            objpayroll.Createdby = Session["username"].ToString();
            objpayroll.year = dropyear.Text;
            objpayroll.month = dropmonth.Text;
            objpayroll.name = txtsearch.Text;
            objpayroll.type = dropbranchsearch.Text;
            objpayroll.holidaytype = dropholidaytype.Text;
            //--Here we are using created param to pass holiday type
            objpayroll.Createdby = dropholidaytype.Text;

            ds = objpayroll.Holiday();
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
                dgnews.DataSource = ds;
                dgnews.DataBind();
                dgnews.Visible = true;
                divnodata.Visible = false;
                btnexportcsv.Enabled = true;
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
                btnexportcsv.Enabled = false;
                dgnews.Visible = false;
                divnodata.Visible = true;
            }
            dsexcel = ds;

        }

        /// <summary>
        /// blank Data
        /// </summary>
        public void blank()
        {

            txtdate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");
            txtholidayname.Text = "";
            hidid.Value = "";

            btnsubmit.Text = "Submit";
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
        protected void dgnews_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                LinkButton lbtndelete = (LinkButton)e.Row.FindControl("lbtndelete");
                LinkButton lbtnedit = (LinkButton)e.Row.FindControl("lbtnedit");
                if (ViewState["add"] != null && ViewState["add"].ToString() == "1")
                {
                    lbtndelete.Visible = true;
                    lbtnedit.Visible = true;
                    dgnews.Columns[3].Visible = true;
                }
                else
                {
                    lbtndelete.Visible = false;
                    lbtnedit.Visible = false;
                    dgnews.Columns[3].Visible = false;
                }
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
        /// event fires when clicks to Edit/Delete in List
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dgnews_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            objpayroll.nid = e.CommandArgument.ToString();
            if (e.CommandName.ToLower() == "viewdetail")
            {
                hidid.Value = objpayroll.nid;

                objpayroll.action = "select";
                objpayroll.name = txtsearch.Text;

                ds = objpayroll.Holiday();
                txtdate.Text = ds.Tables[0].Rows[0]["date"].ToString();
                txtholidayname.Text = ds.Tables[0].Rows[0]["name"].ToString();
                dropbranch.Text = ds.Tables[0].Rows[0]["branchtype"].ToString();
                dropholidaytype2.Text = ds.Tables[0].Rows[0]["branchtype"].ToString();
                btnsubmit.Text = "Update";
                ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);

            }
            if (e.CommandName == "del")
            {
                objpayroll.action = "delete";
                objpayroll.Holiday();
                fillgrid();
            }


        }
        /// <summary>
        /// For Serching 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            dgnews.PageIndex = 0;
            fillgrid();
        }
        /// <summary>
        /// Add New Holiday
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>

        protected void liaddnew_Click(object sender, EventArgs e)
        {
            blank();
        }
        /// <summary>
        /// Save Holiday
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>

        protected void btnsubmit_Click(object sender, EventArgs e)
        {


            objpayroll.nid = hidid.Value;
            objpayroll.action = "checkexists";
            objpayroll.Date = txtdate.Text;
            objpayroll.name = txtholidayname.Text;
            objpayroll.type = dropbranch.Text;
            //objda.titleid = droptitle.Text;
            //PAss this action to check whether name already exists or not
            objpayroll.holidaytype = dropholidaytype2.Text;
            objpayroll.companyid = Session["CompanyId"].ToString();
            objpayroll.Createdby = Session["username"].ToString();
            ds = objpayroll.Holiday();
            //If DS return some row means- entered name already exists, in this case ALERT user with appropriate message
            if (ds.Tables[0].Rows.Count > 0)
            {
                GeneralMethod.alert(this.Page, "Holiday name already exists");
                //Focus on named textbox
                txtholidayname.Focus();
                //Reopen the popup
                ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);
                return;
            }
            else
            {
                objpayroll.action = "insert";
                //objda.name = txtname.Text;

                objpayroll.Createdby = Session["userid"].ToString();

                ds = objpayroll.Holiday();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    blank();
                    fillgrid();

                    GeneralMethod.alert(this.Page, "Saved successfully!");
                }
                else
                {
                    GeneralMethod.alert(this.Page, "Could not save, try again.");

                }
            }

        }
        /// <summary>
        /// Delete Holiday
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>

        protected void btndelete_Click(object sender, EventArgs e)
        {
            objpayroll.action = "delete";
            objpayroll.nid = hidid.Value;
            ds = objpayroll.Holiday();
            blank();
            fillgrid();
            GeneralMethod.alert(this.Page, "Deleted Successfully!");
        }

        /// <summary>
        /// Bind report header with selected parameters and Company Name 
        /// </summary>
        /// <param name="type"></param>
        protected string bindheader(string type)
        {
            string str = "";
            string Companyname = Session["companyname"].ToString();
            string companyaddress = Session["companyaddress"].ToString();
            string Year = "<b>Year:</b> ", Month = "<b>Month:</b> ";
            if (dropyear.Text == "")
            {
                Year += "All";
            }
            else
            {
                Year += dropyear.SelectedItem.Text;
            }
            if (dropmonth.Text == "")
            {
                Month += "All";
            }
            else
            {
                Month += dropmonth.SelectedItem.Text;
            }


            string headerstr = "<table width='100%'>";
            if (type == "excel")
            {
                headerstr = "<table width='100%'>";

            }

            str = headerstr +
        @"<tr>
                    <td  align='center' colspan='3'>
                        <h1>
                            " + Companyname + @"
                        </h1>
                    </td>
                </tr>
             <tr>
                    <td  align='center' colspan='3'>
                        <h4>
                            " + companyaddress + @"
                        </h4>
                    </td>
                </tr>
               <tr>
                <td colspan='3'>&nbsp;</td></tr>
              

                           <tr>
                                <td align='center' colspan='3' >
                                    <h4>
                                        Holiday Report
                                    </h4>
                                </td>
                            </tr>
                            <tr>
                                <td colspan='3'>
                                    &nbsp;
                                </td>
                            </tr>

                            <tr>
                            <td colspan='3'>
                            " + Month + "<br/>" + Year + "<br/>" +

                   @"</td>
                    
                            </tr>
<tr><td colspan='3'>&nbsp;</td></tr>
 </table>  
<table align='left' cellpadding='5' width='100%' cellspacing='0' style='font-family: Calibri;
                        font-size: 12px; text-align: left;' border='0'>
                      
<tr style='font-weight: bold; background: #395ba4; color: #ffffff;'>
<td style='width=38px;'width='100px'>S.No</td>
 <td>Date</td>
 <td>Holiday Name</td>
 
                                                                     
</tr>";
            return str;
        }
        protected void btnexportcsv_Click(object sender, EventArgs e)
        {

            fillgrid();
            string rpthtml = bindheader("excel");
            for (int i = 0; i < dsexcel.Tables[0].Rows.Count; i++)
            {
                rpthtml = rpthtml + "<tr><td>" + Convert.ToString(i + 1) + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["date"].ToString() +
                    "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["name"].ToString() + "</td>" + "</td></tr>";
            }

            HtmlGenericControl divgen = new HtmlGenericControl();

            divgen.InnerHtml = rpthtml;
            HttpResponse response = HttpContext.Current.Response;
            // first let's clean up the response.object   
            response.Clear();
            response.Charset = "";
            // set the response mime type for excel   

            response.ContentType = "application/vnd.ms-excel";
            response.AddHeader("Content-Disposition", "attachment;filename=\"HolidayReport.xls\"");
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