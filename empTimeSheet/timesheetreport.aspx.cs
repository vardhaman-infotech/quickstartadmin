using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.UI.HtmlControls;
using System.IO;
using System.Text;

namespace empTimeSheet
{
    public partial class timesheetreport : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();
        DataSet dsexcel = new DataSet();
        excelexport objexcel = new excelexport();
         string colcount = "8";
        protected void Page_Load(object sender, EventArgs e)
        {

            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                txtfrmdate.Text = System.DateTime.Now.AddDays(-2).ToString("MM/dd/yyyy");
                txttodate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");

                System.Data.DataSet ds = new System.Data.DataSet();
                objda.id = Session["userid"].ToString();
                ds = objda.getUserInRoles();

                if(Session["usertype"].ToString()!="Admin")
                {
                    if (!objda.checkUserInroles("97"))
                    {
                        Response.Redirect("UserDashboard.aspx");
                    }
                }

               
                
                fillemployee();
                fillclient();
                fillproject();


                fillgrid();

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
            objts.clientid = "";
            objts.companyId = Session["companyid"].ToString();
            objts.nid = "";
            ds = objts.ManageProject();
            if (ds.Tables[0].Rows.Count > 0)
            {
                dropproject.DataSource = ds;
                dropproject.DataTextField = "projectcode";
                dropproject.DataValueField = "nid";
                dropproject.DataBind();
            }



        }





        /// <summary>
        /// Bind list of managers who assigned the tasks
        /// </summary>


        /// <summary>
        /// Fill tasks drop down for searching
        /// </summary>



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
                objgen.fillActiveInactiveCheck(ds.Tables[0], dropemployee, "username", "nid");

            }


        }

        /// <summary>
        /// Fill clients drop down for searching
        /// </summary>
        protected void fillclient()
        {
            objuser.clientname = "";
            objuser.action = "select1";
            objuser.companyid = Session["companyid"].ToString();
            objuser.id = "";
            ds = objuser.client();
            if (ds.Tables[0].Rows.Count > 0)
            {
                dropclient.DataSource = ds;
                dropclient.DataTextField = "clientname";
                dropclient.DataValueField = "nid";
                dropclient.DataBind();
                //ListItem li = new ListItem("--All Clients--", "");
                //dropclient.Items.Insert(0, li);
            }


        }

        private string getchkval(CheckBoxList chk)
        {
            StringBuilder sb = new StringBuilder();
            for (var i = 0; i < chk.Items.Count; i++)
            {
                if (chk.Items[i].Selected)
                {
                    sb.Append(chk.Items[i].Value + ",");
                }
            }

            return sb.ToString();
        }



        protected void fillgrid()
        {
            Session["TaskTable"] = null;
            // objts.empid = dropemployee.Text;
            objts.empid = getchkval(dropemployee);

            objts.Status = "";
            objts.clientid = getchkval(dropclient);
            objts.projectid = getchkval(dropproject);
            objts.taskid = "";
            if (dropdaterange.Text == "Custom")
            {
                objts.from = txtfrmdate.Text;
                objts.to = txttodate.Text;
            }
            else
            {
                var result = DateRange.getLastDates(dropdaterange.Text);
                objts.from = result.fromdate;
                objts.to = result.todate;

            }
            hidfromdate.Value = objts.from;
            hidtodate.Value = objts.to;
            objts.CreatedBy = "";
            objts.action = "";

            if (chkmemo.Checked)
            {
                dgnews.Columns[6].Visible = true;
            }
            else
            {
                dgnews.Columns[6].Visible = false;
            
            }
            ds = objts.timesheetreport();

           
            DataTable dt = new DataTable();
            dt = ds.Tables[0];
            if (ds.Tables[0].Rows.Count > 0)
            {
               
                Session["TaskTable"] = dt;
                dgnews.DataSource = dt;
                dgnews.DataBind();
                btnexportcsv.Enabled = true;

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
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "<script type='text/javascript'>fixheader();</script>", false);
        }
     
       
        protected void dgnews_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            dgnews.PageIndex = e.NewPageIndex;
            fillgrid();
            ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>scrolltotopofList();</script>", false);
        }
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            dgnews.PageIndex = 0;
            ViewState["SortDirection"] = null;
            ViewState["SortExpression"] = null;


            fillgrid();

        }
        protected void btnrefresh_Click(object sender, EventArgs e)
        {
            fillgrid();
        }

        #region Export
        protected string bindheader()
        {
            string str = "";
            string Companyname = Session["companyname"].ToString();
            string companyaddress = Session["companyaddress"].ToString();
            string date = "<b>Date:</b> ";

            if (hidfromdate.Value  != hidtodate.Value)
            {
                date += hidfromdate.Value + " - " + hidtodate.Value;
            }
            else
            {
                date += hidfromdate.Value;
            }
            string headerstr = "";


            str = headerstr +
        @"<tr>
            <td colspan='"+colcount+@"' align='left'>
                <h2 style='color:blue;'>
                   " + Companyname + @"
                </h2>
            </td>
        </tr>
<tr>
            <td  colspan='"+colcount+@"'  align='left'>
               
                   " + companyaddress + @"
               
            </td>
        </tr>
        <tr>
            <td colspan='"+colcount+@"'  align='left'>
                <h4>
                   Employee Timesheet Report From " + date + @"
                </h4>
            </td>
        </tr>
      
       
        <tr>
        <td colspan='"+colcount+@"'>&nbsp;
        </td>

        </tr>";

            return str;


        }
        protected void btnexportcsv_Click(object sender, EventArgs e)
        {
           
            if (chkmemo.Checked)
            {
                colcount = "9";
            }


            DataTable dt = new DataTable();
            StringBuilder sb = new StringBuilder();
            sb.Append(@"<table>" + bindheader() + @"<tr ><th style='background-color:blue;color:#ffffff;'>Day</th><th style='background-color:blue;color:#ffffff;'>Date</th><th style='background-color:blue;color:#ffffff;'>Project Id</th><th style='background-color:blue;color:#ffffff;'>Project Name</th>
                <th style='background-color:blue;color:#ffffff;'>Task ID</th><th style='background-color:blue;color:#ffffff;'>Description</th>");

            if (chkmemo.Checked)
            {
                sb.Append("<th style='background-color:blue;color:#ffffff;'>Memo</th>");
            }
            sb.Append("<th style='background-color:blue;color:#ffffff;'>Hrs.</th><th style='background-color:blue;color:#ffffff;'></th>");

            if (Session["tasktable"] != null)
            {
                dt = ((DataTable)Session["tasktable"]).Copy();


                DataView view = new DataView(dt);
                view.Sort = "empname ASC";


                DataTable sortedDT = view.ToTable();
                DataView view1 = new DataView(sortedDT);

                DataTable distinctValues = view1.ToTable(true, "empid");
                double totalhrs = 0, totalbill = 0, totalub = 0;
                for (int i = 0; i < distinctValues.Rows.Count; i++)
                {
                    double hrs = 0;
                    DataTable dtfinal = new DataTable();
                    dtfinal = filerbyemp("empid='" + distinctValues.Rows[i][0].ToString() + "'", dt);
                    dtfinal.DefaultView.Sort = "date1 ASC";
                    sb.Append(@"<tr><td colspan='"+colcount+@"' style='color:blue;font-weight:bold;'>" + dtfinal.Rows[0]["empname"].ToString() + "(" + dtfinal.Rows[0]["loginid"].ToString() + ")" + "</td></tr>");
                   

                    DataTable dtfinal1 = new DataTable();
                   

                    dtfinal1 = filerbyemp("isbillable=1", dtfinal);
                    int count = dtfinal1.Rows.Count;
                    int j = 0;
                    if (dtfinal1.Rows.Count > 0)
                    {
                       
                        for (j = 0; j < count; j++)
                        {
                            string bgcolor = "";
                            if (j % 2 > 0)
                                bgcolor = " style='background-color:#E8F5FD;' ";
                            else
                                bgcolor = " style='background-color:#CBE5F5;' ";
                            sb.Append(@"<tr><td " + bgcolor + ">" + Convert.ToDateTime(dtfinal1.Rows[j]["date1"].ToString()).ToString("ddd") + "</td>");
                            sb.Append(@"<td " + bgcolor + ">" + dtfinal1.Rows[j]["date"].ToString() + "</td>");
                            sb.Append(@"<td " + bgcolor + ">" + dtfinal1.Rows[j]["projectcode"].ToString() + "</td>");
                            sb.Append(@"<td " + bgcolor + ">" + dtfinal1.Rows[j]["projectname"].ToString() + "</td>");
                            sb.Append(@"<td " + bgcolor + ">" + dtfinal1.Rows[j]["taskcodename"].ToString() + "</td>");
                            sb.Append(@"<td " + bgcolor + ">" + dtfinal1.Rows[j]["description"].ToString() + "</td>");
                            if (colcount == "9")
                            {
                                sb.Append(@"<td " + bgcolor + ">" + dtfinal1.Rows[j]["memo"].ToString() + "</td>");
                            }
                            sb.Append(@"<td " + bgcolor + ">" + dtfinal1.Rows[j]["hours"].ToString() + "</td>");
                            hrs += Convert.ToDouble(dtfinal1.Rows[j]["hours"]);
                            if (Convert.ToBoolean(dtfinal1.Rows[j]["isbillable"]))
                            {

                                sb.Append(@"<td></td></tr>");
                            }
                            else
                            {
                                sb.Append(@"<td style='color:red;'>NB</td></tr>");

                            }


                            if (j == count - 1)
                            {
                                sb.Append(@"<tr><td></td>");
                                sb.Append(@"<td></td>");
                                sb.Append(@"<td></td>");
                                sb.Append(@"<td></td>");
                                sb.Append(@"<td></td>");
                                if (colcount == "9")
                                {
                                    sb.Append(@"<td></td>");
                                }
                                sb.Append(@"<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;font-weight:bold;'>" + dtfinal1.Rows[j]["empname"].ToString() + "(" + dtfinal1.Rows[j]["loginid"].ToString() + ")" + "</td>");
                                sb.Append(@"<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;font-weight:bold;'>" + hrs.ToString("0.00") + "</td><td></td></tr>");
                                totalhrs += hrs;
                                totalbill += hrs;
                                sb.Append(@"<tr><td></td>");
                                sb.Append(@"<td></td>");
                                sb.Append(@"<td></td>");
                                sb.Append(@"<td></td>");
                                sb.Append(@"<td></td>");
                                sb.Append(@"<td></td>");
                                sb.Append(@"<td></td>");
                                if (colcount == "9")
                                {
                                    sb.Append(@"<td></td>");
                                }
                                sb.Append(@"<td></td></tr>");
                            }

                        }


                    }

                    j = 0;
                    double hrs1 = 0;

                    DataTable dtfinal2 = new DataTable();

                    dtfinal2 = filerbyemp("isbillable=0", dtfinal);
                    count = dtfinal2.Rows.Count;
                    if (dtfinal2.Rows.Count > 0)
                    {
                        for (j = 0; j < count; j++)
                        {
                            string bgcolor = "";
                            if (j % 2 > 0)
                                bgcolor = " style='background-color:#E8F5FD;' ";
                            else
                                bgcolor = " style='background-color:#CBE5F5;' ";
                            sb.Append(@"<tr><td " + bgcolor + ">" + Convert.ToDateTime(dtfinal2.Rows[j]["date1"].ToString()).ToString("ddd") + "</td>");
                            sb.Append(@"<td " + bgcolor + ">" + dtfinal2.Rows[j]["date"].ToString() + "</td>");
                            sb.Append(@"<td " + bgcolor + ">" + dtfinal2.Rows[j]["projectcode"].ToString() + "</td>");
                            sb.Append(@"<td " + bgcolor + ">" + dtfinal2.Rows[j]["projectname"].ToString() + "</td>");
                            sb.Append(@"<td " + bgcolor + ">" + dtfinal2.Rows[j]["taskcodename"].ToString() + "</td>");
                            sb.Append(@"<td " + bgcolor + ">" + dtfinal2.Rows[j]["description"].ToString() + "</td>");
                            if (colcount == "9")
                            {
                                sb.Append(@"<td " + bgcolor + ">" + dtfinal2.Rows[j]["memo"].ToString() + "</td>");
                            }
                            sb.Append(@"<td " + bgcolor + ">" + dtfinal2.Rows[j]["hours"].ToString() + "</td>");
                            hrs1 += Convert.ToDouble(dtfinal2.Rows[j]["hours"]);

                            if (Convert.ToBoolean(dtfinal2.Rows[j]["isbillable"]))
                            {

                                sb.Append(@"<td></td></tr>");
                            }
                            else
                            {
                                sb.Append(@"<td style='color:red;'>NB</td></tr>");

                            }


                            if (j == count - 1)
                            {
                                sb.Append(@"<tr><td></td>");
                                sb.Append(@"<td></td>");
                                sb.Append(@"<td></td>");
                                sb.Append(@"<td></td>");
                                sb.Append(@"<td></td>");
                                if (colcount == "9")
                                {
                                    sb.Append(@"<td></td>");
                                }
                                sb.Append(@"<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;font-weight:bold;'>" + dtfinal.Rows[0]["empname"].ToString() + "(" + dtfinal2.Rows[j]["loginid"].ToString() + ")" + "</td>");
                                sb.Append(@"<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;font-weight:bold;'>" + hrs1.ToString("0.00") + "</td><td style='color:red;'>NB</td></tr>");
                                totalhrs += hrs1;
                                totalub += hrs1;
                                sb.Append(@"<tr><td></td>");
                                sb.Append(@"<td></td>");
                                sb.Append(@"<td></td>");
                                sb.Append(@"<td></td>");
                                sb.Append(@"<td></td>");
                                if (colcount == "9")
                                {
                                    sb.Append(@"<td></td>");
                                }
                                sb.Append(@"<td></td>");
                                sb.Append(@"<td></td>");
                                sb.Append(@"<td></td></tr>");
                            }

                        }


                    }

                    sb.Append(@"<tr><td></td>");
                    sb.Append(@"<td></td>");
                    sb.Append(@"<td></td>");
                    sb.Append(@"<td></td>");
                    if (colcount == "9")
                    {
                        sb.Append(@"<td></td>");
                    }
                    sb.Append(@"<td style='font-weight:bold;'>Employee Total</td>");
                    sb.Append(@"<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;font-weight:bold;'>" + dtfinal.Rows[0]["empname"].ToString() + "(" + dtfinal.Rows[0]["loginid"].ToString() + ")" + "</td>");
                    sb.Append(@"<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;font-weight:bold;'>" + (hrs + hrs1).ToString("0.00") + "</td><td></td></tr>");

                    sb.Append(@"<tr><td></td>");
                    sb.Append(@"<td></td>");
                    sb.Append(@"<td></td>");
                    sb.Append(@"<td></td>");
                    sb.Append(@"<td></td>");
                    if (colcount == "9")
                    {
                        sb.Append(@"<td></td>");
                    }
                    sb.Append(@"<td></td>");
                    sb.Append(@"<td></td>");
                    sb.Append(@"<td></td></tr>");


                }


                sb.Append(@"<tr><td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td>");
                if (colcount == "9")
                {
                    sb.Append(@"<td></td>");
                }
                sb.Append(@"<td></td>");
                sb.Append(@"<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;font-weight:bold;'>Total</td>");


                sb.Append(@"<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;font-weight:bold;'>" + totalbill.ToString("0.00") + "</td><td style='font-weight:bold;'>B</td></tr>");

                sb.Append(@"<tr><td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td>");
                if (colcount == "9")
                {
                    sb.Append(@"<td></td>");
                }
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td></tr>");

                // UB

                sb.Append(@"<tr><td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td>");
                if (colcount == "9")
                {
                    sb.Append(@"<td></td>");
                }
                sb.Append(@"<td></td>");
                sb.Append(@"<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;font-weight:bold;'>Total</td>");


                sb.Append(@"<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;font-weight:bold;'>" + totalub.ToString("0.00") + "</td><td style='font-weight:bold;'>UB</td></tr>");


                sb.Append(@"<tr><td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td>");
                if (colcount == "9")
                {
                    sb.Append(@"<td></td>");
                }
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td></tr>");

                // GT
                sb.Append(@"<tr style='color:blue;'><td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td>");
                sb.Append(@"<td></td>");
                if (colcount == "9")
                {
                    sb.Append(@"<td></td>");
                }
                sb.Append(@"<td></td>");
                sb.Append(@"<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;font-weight:bold;'>Grand Total</td>");


                sb.Append(@"<td style='border-top:solid 1px #000000;border-bottom:solid 1px #000000;font-weight:bold;'>" + totalhrs.ToString("0.00") + "</td><td></td></tr>");


            }
            sb.Append("</table>");
            objexcel.downloadFile(sb.ToString(), "TimeSheetReport.xls");

        }
        private DataTable filerbyemp(string id, DataTable dt)
        {
            DataView dv = new DataView(dt);
            dv.RowFilter = id;
            return dv.ToTable();

        }
        #endregion

        protected void dgnews_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.Header)
                e.Row.TableSection = TableRowSection.TableHeader;
        }
       
      
        public override void VerifyRenderingInServerForm(Control control)
        {

            /* Verifies that the control is rendered */

        }
      
    }
}