using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
namespace empTimeSheet
{
    public partial class LeaveDetails : System.Web.UI.Page
    {
        ClsPayroll objpayroll = new ClsPayroll();
        DataSet ds = new DataSet();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["empid"] != null && Request.QueryString["month"] != null && Request.QueryString["year"] != null)
                {
                    bindgrid();
                }
            }
        }
        protected void bindgrid()
        {
            dgdetails.DataSource = null;
            dgdetails.DataBind();
            divnodata.Visible = true;
            objpayroll.Empid = Request.QueryString["empid"].ToString();
            objpayroll.RequestDate = Request.QueryString["month"].ToString();
            objpayroll.NumofDays = Request.QueryString["year"].ToString();
            objpayroll.companyid = Session["companyid"].ToString();
            objpayroll.action = "Getemployeedetailedreport";
            ds = objpayroll.LeaveRequest();

            if (ds.Tables[0].Rows.Count > 0)
            {
                dgdetails.DataSource = ds;
                dgdetails.DataBind();
                divnodata.Visible = false;

            }
        
        }
        protected void dgdetails_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Display the company name in italics.
                foreach (TableCell column in e.Row.Cells)
                {
                    column.Text = Server.HtmlDecode(column.Text);
                }

            }
        }
    }
}