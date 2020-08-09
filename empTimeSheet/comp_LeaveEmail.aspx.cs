using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
namespace empTimeSheet
{
    public partial class comp_LeaveEmail : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsAdmin objadmin = new ClsAdmin();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!objda.checkUserInroles("26"))
            {
                Response.Redirect("UserDashboard.aspx");
            }
            if (!Page.IsPostBack)
            {
                bindemployee();
                binddetail();
            }

        }
        protected void bindemployee()
        {
            listcode1.Items.Clear();

            objuser.action = "selectactive";
            objuser.companyid = Session["companyid"].ToString();
            objuser.id = "";
            ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0)
            {


                listcode1.DataSource = ds;
                listcode1.DataTextField = "username";
                listcode1.DataValueField = "nid";
                listcode1.DataBind();

            }
        }
        protected void binddetail()
        {
            objadmin.action = "selectleaveEmail";
            objadmin.companyId = Session["companyid"].ToString();

            ds = objadmin.CompanySettings();
            if (ds.Tables[0].Rows.Count > 0)
            {
                hidscheduleemailemp.Value = ds.Tables[1].Rows[0]["LeaveEmail"].ToString();
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    for (int j = 0; j < listcode1.Items.Count; j++)
                    {
                        if (listcode1.Items[j].Value == ds.Tables[0].Rows[i]["nid"].ToString())
                        {
                            ListItem li = new ListItem(listcode1.Items[j].Text, listcode1.Items[j].Value);
                            listcode2.Items.Add(li);
                            listcode1.Items.RemoveAt(j);

                            break;
                        }
                    }
                }

            }

        }
        protected void btnreset_Click(object sender, EventArgs e)
        { binddetail(); }
        protected void btnSave_OnClick(object sender, EventArgs e)
        {
            objadmin.action = "updateLeaveEmail";
            objadmin.companyId = Session["companyid"].ToString();
            string schedulemail = "";

            schedulemail = hidscheduleemailemp.Value;
            objadmin.leaveemail = schedulemail;
            ds = objadmin.CompanySettings();
            binddetail();
            GeneralMethod.alert(this.Page, "Information saved successfully!");

        }
    }
}