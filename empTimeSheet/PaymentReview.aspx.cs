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
    public partial class PaymentReview : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();
        ClsAdmin objadmin = new ClsAdmin();
      
       
        public string strcurrency = "$";
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                txtfromdate.Text = "01/01/" + (DateTime.Now.Year).ToString() + "";
                txttodate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");

                //Role 38 indicates 'Receive Payment'
                if (!objda.checkUserInroles("38"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }

                fillclient();
                fillproject();
                fillcurrency();
                searchdata();
            }
        }

        protected void searchdata()
        {
           
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
                ListItem li = new ListItem("--All Clients--", "");
                dropclient.Items.Insert(0, li);
            }


        }


        protected void fillgrid()
        {
            Session["TaskTable"] = null;

            objts.action = "select";
            objts.nid = "";
            objts.companyId = Session["companyid"].ToString();
            objts.clientid = dropclient.Text;
            objts.projectid = dropproject.Text;
            objts.invoiceno =txtinvno.Text;
            objts.from =txtfromdate.Text;
            objts.to = txttodate.Text;
            ds = objts.GetPaymentDetails();

           

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
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "<script type='text/javascript'>fixheader();</script>", false);
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
            
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string clickstr = "clickedit(" + DataBinder.Eval(e.Row.DataItem, "nid").ToString() + ")";
                e.Row.Cells[0].Attributes.Add("onclick", clickstr);
                e.Row.Cells[1].Attributes.Add("onclick", clickstr);
                e.Row.Cells[2].Attributes.Add("onclick", clickstr);
                e.Row.Cells[3].Attributes.Add("onclick",clickstr);
                e.Row.Cells[4].Attributes.Add("onclick", clickstr);
               // e.Row.Cells[5].Attributes.Add("onclick", clickstr);
               // e.Row.Cells[6].Attributes.Add("onclick", Page.ClientScript.GetPostBackClientHyperlink(dgnews, "RowCommand$" + DataBinder.Eval(e.Row.DataItem, "nid").ToString()));

                e.Row.Attributes["onmouseover"] = "this.style.cursor='pointer'";

                


            }
        }
        protected void PaggedGridbtnedit_Click(object sender, EventArgs e)
        {
            binddetail();
           

        
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
                objts.GetPaymentDetails();
                fillgrid();
            }
            if (e.CommandName.ToLower() == "rowcommand")
            {
               

            }
        }

        protected void binddetail()
        {
            objts.action = "select";
            objts.nid = hidid.Value;
            ds = objts.GetPaymentDetails();
            if (ds.Tables[0].Rows.Count > 0)
            {
                rptsummary.DataSource = ds.Tables[0];
                rptsummary.DataBind();
            }
            if (ds.Tables.Count>1 && ds.Tables[1].Rows.Count > 0)
            {
                dgdetail.DataSource = ds.Tables[1];
                dgdetail.DataBind();
            }
            else
            {
                dgdetail.DataSource = null;
                dgdetail.DataBind();
            }
                 
            updatedetail.Update();
            ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);
        }

      
       
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            searchdata();

        }
      
       



    


       
    }
}