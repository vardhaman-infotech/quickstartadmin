using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace empTimeSheet
{
    public partial class Servers : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        clsServer objserver = new clsServer();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!IsPostBack)
            {
                if (!objda.checkUserInroles("11"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
                //multiview1.ActiveViewIndex = 1;
                fillclient();

                bindconfigtype();
                fillroles();
                fillgrid();
            }
        }

        /// <summary>
        /// Bind server roles
        /// </summary>
        public void fillroles()
        {
            objserver.action = "selectserverroles";
            objserver.companyid = Session["companyid"].ToString();
            ds = objserver.Server();
            rbtnroles.DataSource = ds;
            rbtnroles.DataTextField = "rolename";
            rbtnroles.DataValueField = "nid";
            rbtnroles.DataBind();

        }


        //Popup Add new div
        protected void liaddnew_Click(object sender, EventArgs e)
        {
            blank();
            btnsubmit.Text = "Save";
            btndelete.Visible = false;
            //multiview1.ActiveViewIndex = 0;
        }

        /// <summary>
        /// Fill list of existing clients For Search
        /// </summary>
        public void fillclient()
        {
            objuser.action = "select";
            objuser.name = "";
            objuser.id = "";
            objuser.companyid = Session["companyId"].ToString();
            //objuser.companyid = Session["companyId"].ToString();
            ds = objuser.client();
            if (ds.Tables[0].Rows.Count > 0)
            {
                ddlclient.DataSource = ds;
                ddlclient.DataTextField = "clientname";
                ddlclient.DataValueField = "nid";
                ddlclient.DataBind();
                ListItem li = new ListItem("--Select Client--", "");
                ddlclient.Items.Insert(0, li);
                ddlclient.SelectedIndex = 0;

                dropclient.DataSource = ds;
                dropclient.DataTextField = "clientname";
                dropclient.DataValueField = "nid";
                dropclient.DataBind();
                ListItem li1 = new ListItem("--All Clients--", "");
                dropclient.Items.Insert(0, li1);
                dropclient.SelectedIndex = 0;

            }

        }

        /// <summary>
        /// Bind Configuration Type
        /// </summary>
        protected void bindconfigtype()
        {
            objserver.action = "selectdistincttype";
            objserver.companyid = Session["companyId"].ToString();


            ds = objserver.Config();
            if (ds.Tables[0].Rows.Count > 0)
            {
                rptconfig.DataSource = ds;
                rptconfig.DataBind();

            }
        }


        //Fill Department List from Database
        public void fillgrid()
        {
            objserver.nid = "";
            objserver.action = "select";
            objserver.companyid = Session["companyid"].ToString();
            objserver.servername = txtsearch.Text;
            objserver.clientid = dropclient.Text;
            ds = objserver.Server();
            if (ds.Tables[0].Rows.Count > 0)
            {
                dgnews.Visible = true;
                nodata.Visible = false;
                dgnews.DataSource = ds;
                dgnews.DataBind();


            }
            else
            {
                dgnews.Visible = false;
                nodata.Visible = true;
            }

        }

        protected void rptconfig_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                Repeater rptinner = (Repeater)e.Item.FindControl("rptinner");
                TextBox txtvalue = (TextBox)e.Item.FindControl("txtvalue");
                objserver.type = DataBinder.Eval(e.Item.DataItem, "type").ToString();
                //objuser.name = DataBinder.Eval(e.Item.DataItem, "name").ToString();
                objserver.action = "select";
                ds = objserver.Config();
                if (ds.Tables.Count > 0)
                {
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        rptinner.DataSource = ds;
                        rptinner.DataBind();
                        return;
                    }
                }
                //ltrmsg.Text = "Not logged in";
            }
        }
        /// <summary>
        /// Delete selected record
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btndelete_Click(object sender, EventArgs e)
        {
            objserver.action = "delete";
            objserver.nid = hidid.Value;
            ds = objserver.Server();
            blank();
            fillgrid();
            GeneralMethod.alert(this.Page, "Deleted Successfully!");
        }

        /// <summary>
        /// Save server details
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnsubmit_Click(object sender, EventArgs e)
        {
            objserver.action = "insert";
            objserver.nid = hidid.Value;
            objserver.createdby = Session["userid"].ToString();
            objserver.clientid = ddlclient.Text;
            objserver.domain = txt_domain.Text;
            objserver.servercode = txt_serverid.Text;
            objserver.servername = txt_servername.Text;
            string strroles = "";
            for (int i = 0; i < rbtnroles.Items.Count; i++)
            {
                if (rbtnroles.Items[i].Selected == true)
                {
                    strroles += rbtnroles.Items[i].Value + "#";
                }
            }
            objserver.serverrole = strroles;
            objserver.companyid = Session["companyid"].ToString();
            ds = objserver.Server();
            if (ds.Tables[0].Rows.Count > 0)
            {

                for (int i = 0; i < rptconfig.Items.Count; i++)
                {

                    Repeater rptinner = (Repeater)rptconfig.Items[i].FindControl("rptinner");
                    for (int j = 0; j < rptinner.Items.Count; j++)
                    {
                        TextBox txtvalue = (TextBox)rptinner.Items[j].FindControl("txtvalue");
                        HiddenField hidconfigid = (HiddenField)rptinner.Items[j].FindControl("hidconfigid");
                        HiddenField hidserverconfigid = (HiddenField)rptinner.Items[j].FindControl("hidserverconfigid");
                        objserver.nid = hidserverconfigid.Value;
                        objserver.serverid = ds.Tables[0].Rows[0]["nid"].ToString();
                        objserver.configid = hidconfigid.Value;
                        objserver.configvalue = txtvalue.Text;
                        objserver.action = "insertserverconfig";
                        objserver.Server();

                    }
                }
            }


            fillgrid();
            if (hidid.Value == "")
            {
                blank();
                GeneralMethod.alert(this.Page, "Saved Successfully!");
            }
            else
            {
                GeneralMethod.alert(this.Page, "Information updated Successfully!");
            }

        }

        /// <summary>
        /// Reset form's values
        /// </summary>
        protected void blank()
        {
            rbtnroles.ClearSelection();
            ddlclient.SelectedIndex = 0;
            txt_domain.Text = "";
            txt_serverid.Text = "";
            txt_servername.Text = "";
            for (int i = 0; i < rptconfig.Items.Count; i++)
            {

                Repeater rptinner = (Repeater)rptconfig.Items[i].FindControl("rptinner");
                for (int j = 0; j < rptinner.Items.Count; j++)
                {
                    TextBox txtvalue = (TextBox)rptinner.Items[j].FindControl("txtvalue");
                    HiddenField hidconfigid = (HiddenField)rptinner.Items[j].FindControl("hidconfigid");
                    HiddenField hidserverconfigid = (HiddenField)rptinner.Items[j].FindControl("hidserverconfigid");
                    hidserverconfigid.Value = "";
                    txtvalue.Text = "";
                }
            }
            hidid.Value = "";

        }

        /// <summary>
        /// When search by keyword, call the fillgrid function
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            fillgrid();
        }

        /// <summary>
        /// When user clicks on any row in grid
        /// Bind the Server details
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>

        protected void dgnews_RowCommand(object sender, RepeaterCommandEventArgs e)
        {

            if (e.CommandName.ToLower() == "detail")
            {
                blank();
                hidid.Value = e.CommandArgument.ToString();

                binddetails();
                btnsubmit.Text = "Update";
                btndelete.Visible = true;
            }
        }

        /// <summary>
        /// Bind server details
        /// </summary>
        protected void binddetails()
        {
            objserver.nid = hidid.Value;
            objserver.action = "select";
            ds = objserver.Server();
            ddlclient.Text = ds.Tables[0].Rows[0]["clientid"].ToString();
            txt_domain.Text = ds.Tables[0].Rows[0]["Domain"].ToString();
            txt_serverid.Text = ds.Tables[0].Rows[0]["ServerCode"].ToString();
            txt_servername.Text = ds.Tables[0].Rows[0]["ServerName"].ToString();

            for (int j = 0; j < rbtnroles.Items.Count; j++)
            {
                rbtnroles.Items[j].Selected = false;
            }


            if (ds.Tables[0].Rows[0]["serverroles"].ToString() != "")
            {
                string[] strroles = ds.Tables[0].Rows[0]["serverroles"].ToString().Split('#');
                for (int i = 0; i < strroles.Length; i++)
                {
                    for (int j = 0; j < rbtnroles.Items.Count; j++)
                    {

                        if (rbtnroles.Items[j].Value == strroles[i])
                        {
                            rbtnroles.Items[j].Selected = true;

                        }

                    }

                }

            }

            if (ds.Tables[1].Rows.Count > 0)
            {

                for (int i = 0; i < rptconfig.Items.Count; i++)
                {

                    Repeater rptinner = (Repeater)rptconfig.Items[i].FindControl("rptinner");
                    for (int j = 0; j < rptinner.Items.Count; j++)
                    {
                        TextBox txtvalue = (TextBox)rptinner.Items[j].FindControl("txtvalue");
                        HiddenField hidconfigid = (HiddenField)rptinner.Items[j].FindControl("hidconfigid");
                        HiddenField hidserverconfigid = (HiddenField)rptinner.Items[j].FindControl("hidserverconfigid");

                        for (int k = 0; k < ds.Tables[1].Rows.Count; k++)
                        {
                            if (hidconfigid.Value == ds.Tables[1].Rows[k]["ConfigId"].ToString())
                            {

                                txtvalue.Text = ds.Tables[1].Rows[k]["ConfigValue"].ToString();
                                hidserverconfigid.Value = ds.Tables[1].Rows[k]["nid"].ToString();

                                break;
                            }


                        }
                    }
                }



            }


        }
    }
}


