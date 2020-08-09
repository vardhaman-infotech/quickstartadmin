using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;


namespace emptimesheet.admin
{
    public partial class ManageCity : System.Web.UI.Page
    {
        ClsAdmin objda = new ClsAdmin();
        DataSet ds = new DataSet();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!objda.validatelogin())
                Response.Redirect("logout.aspx");

            divnodatafound.Visible = false;

            if (!Page.IsPostBack)
            {
                bindcountry();
                bindstate();
                bindgrid();
            }
        }
        //Bind dropdown of country
        protected void bindcountry()
        {
            objda.action = "selectstate";
            ds = objda.ManageMaster();
            if (ds.Tables[0].Rows.Count > 0)
            {
                ddlcountry.DataTextField = "countryname";
                ddlcountry.DataValueField = "nid";
                ddlcountry.DataSource = ds;
                ddlcountry.DataBind();

            }
            ListItem li = new ListItem();
            li.Text = "--Select--";
            li.Value = "";
            ddlcountry.Items.Insert(0, li);


            bindstate();
        }
        /// <summary>
        /// Bind drop down of state
        /// 
        protected void bindstate()
        {
            objda.parentid = ddlcountry.Text;
            objda.action = "selectstate";
            ds = objda.ManageMaster();
            if (ds.Tables[0].Rows.Count > 0)
            {
                ddlstate.DataTextField = "statename";
                ddlstate.DataValueField = "nid";
                ddlstate.DataSource = ds;
                ddlstate.DataBind();

            }
            ListItem li = new ListItem();
            li.Text = "--Select--";
            li.Value = "";
            ddlstate.Items.Insert(0, li);
        }
        protected void ddlcountry_SelectedIndexChanged(object sender, EventArgs e)
        {
            bindstate();

            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>openpopup();</script>", false);
        }
        /// <summary>
        /// Bind List of cities
        /// </summary>
        public void bindgrid()
        {
            objda.action = "selectcity";

            ds = objda.ManageMaster();

            int start = dgnews.PageSize * dgnews.CurrentPageIndex;
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
                divnodatafound.Visible = false;
                dgnews.Visible = true;
            }
            else
            {
              
                divnodatafound.Visible = true;
                dgnews.Visible = false;
            }
        }
        protected void dgnews_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
        {
            dgnews.CurrentPageIndex = e.NewPageIndex;
            bindgrid();

        }
        public void blank()
        {
            txtName.Value = "";
            ddlcountry.SelectedIndex = 0;
            ddlstate.SelectedIndex = 0;
            hidid.Value = "";
            hiduser.Value = "";
        }
        protected void btnsave_Click(object sender, EventArgs e)
        {

            objda.nid = hidid.Value;

            objda.Name = txtName.Value;
            objda.parentid = ddlstate.Text;

            objda.action = "checkcityexists";

            ds = objda.ManageMaster();
            if (ds != null)
            {
                if (ds.Tables[0].Rows.Count > 0)
                {
                    if (ds.Tables[0].Rows[0][0].ToString() == "0")
                    {
                       
                        txtName.Focus();
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('City already exists!');</script>", false);

                        return;
                    }
                }
            }

            objda.action = "insertcity";
            ds = objda.ManageMaster();
            if (ds.Tables[0].Rows.Count > 0)
            {
                blank();
                bindgrid();
              
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('Saved successfully!');</script>", false);

            }

           
        }
        protected void dgnews_ItemCommand1(object source, DataGridCommandEventArgs e)
        {
            if (e.CommandName == "delete")
            {
                objda.action = "deletecity";
                divmsg.Style.Add("display", "none");
                objda.nid = e.CommandArgument.ToString();
                objda.ManageMaster();

                bindgrid();
                blank();

            }
            if (e.CommandName == "edit")
            {
                objda.action = "selectcity";
                divmsg.Style.Add("display", "none");
                objda.nid = e.CommandArgument.ToString();
                hidid.Value = objda.nid;
                ds = objda.ManageMaster();

                ddlcountry.Text = ds.Tables[0].Rows[0]["countryid"].ToString();

                ddlstate.Text = ds.Tables[0].Rows[0]["stateid"].ToString();
                txtName.Value = ds.Tables[0].Rows[0]["cityname"].ToString();
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>openpopup();</script>", false);

            }

        }
        protected void lnkprevious_Click(object sender, EventArgs e)
        {
            if (dgnews.CurrentPageIndex > 0)
            {
                dgnews.CurrentPageIndex = dgnews.CurrentPageIndex - 1;
                bindgrid();
            }
        }
        protected void lnknext_Click(object sender, EventArgs e)
        {
            if (int.Parse(lbltotalrecord.Text) > int.Parse(lblend.Text))
            {
                dgnews.CurrentPageIndex = dgnews.CurrentPageIndex + 1;
                bindgrid();
            }
        }
    }
}