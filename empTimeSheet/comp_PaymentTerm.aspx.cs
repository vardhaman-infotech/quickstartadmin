using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.UI.HtmlControls;

namespace empTimeSheet
{
    public partial class comp_PaymentTerm : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        DataSet ds = new DataSet();
        GeneralMethod objgen = new GeneralMethod();
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                if (!objda.checkUserInroles("26"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
                fillgrid();
            }
        }
        public void fillgrid()
        {
            objda.id = "";
            objda.action = "select";
            objda.company = Session["companyid"].ToString();
            objda.name = "";
            ds = objda.ManagePaymentTerm();
            if (ds.Tables[0].Rows.Count > 0)
            {
                dgnews.DataSource = ds;
                dgnews.DataBind();
              


            }
            else
            {
               

            }

        }
        protected void dgnews_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EmptyInsert")
            {
                TextBox term = dgnews.FooterRow.FindControl("txtpayterm") as TextBox;
                TextBox gracedays = dgnews.FooterRow.FindControl("txtgracedays") as TextBox;

                objda.id = "";
                objda.name = term.Text;
                objda.description = gracedays.Text;
                objda.action = "insert";
                objda.company = Session["companyid"].ToString();
                ds = objda.ManagePaymentTerm();
                fillgrid();
                GeneralMethod.alert(this.Page, "Saved Successfully!");

            }
            if (e.CommandName == "del")
            {
                objda.id = e.CommandArgument.ToString();
                objda.action = "delete";
                objda.company = Session["companyid"].ToString();
                ds = objda.ManagePaymentTerm();
                fillgrid();
            }

        }
        protected void dgnews_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            dgnews.EditIndex = -1;
            fillgrid();
        }

        /// <summary>
        /// Update the existing row data
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dgnews_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {

            GridViewRow row = (GridViewRow)dgnews.Rows[e.RowIndex];


            int index = row.RowIndex;

            string hidid = ((HtmlInputHidden)dgnews.Rows[index].FindControl("hidid")).Value;
            string payterm = ((TextBox)dgnews.Rows[index].FindControl("txtpayterm")).Text;
            string gracedays = ((TextBox)dgnews.Rows[index].FindControl("txtgracedays")).Text;




            if (payterm != "" && gracedays != "")
            {
                objda.id = hidid;
                objda.name = payterm;
                objda.description = gracedays;
                objda.action = "insert";
                objda.company = Session["companyid"].ToString();
                ds = objda.ManagePaymentTerm();





                dgnews.EditIndex = -1;
                fillgrid();
            }

            else
            {
                GeneralMethod.alert(this.Page, "Please fill Pay Term or Grace Days!");
            }
        }

        protected void dgnews_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            GridViewRow row = (GridViewRow)dgnews.Rows[e.RowIndex];
            objda.action = "delete";
            objda.id = ((HtmlInputHidden)row.FindControl("hidid")).Value;
            objda.ManagePaymentTerm();



            fillgrid();

        }
        protected void dgnews_RowEditing(object sender, GridViewEditEventArgs e)
        {
            dgnews.EditIndex = e.NewEditIndex;
            fillgrid();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dgnews_RowDataBound(object sender, GridViewRowEventArgs e)
        {

            if (e.Row.RowType == DataControlRowType.Header)
            {

            }





            if (e.Row.RowType == DataControlRowType.DataRow)
            {



            }

        }

        protected void btnsubmit_Click(object sender, EventArgs e)
        
{ }
    }
}