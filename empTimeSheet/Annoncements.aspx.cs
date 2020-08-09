using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.IO;
using System.Text;
using System.Web.UI.HtmlControls;
using System.Globalization;

namespace empTimeSheet
{
    public partial class Annoncements : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();
    
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {

                if (!objda.checkUserInroles("10"))
                {
                    lbtnaddnew.Visible = false;
                    btnsubmit.Visible = false;
                    chkavailableToLogin.Enabled = false;
                    editimage.Visible = false;
                    ViewState["add"] = null;
                    cid.Visible = false;
                }
                else
                {
                    
                    ViewState["add"] = "1";
                }

                if (Request.QueryString["id"] != null && Request.QueryString["id"].ToString() != "")
                {
                    binddetail(Request.QueryString["id"].ToString());
                }
                fillgrid();
               
            }
        }


        //bind list of announcements
        public void fillgrid()
        {
            objda.id = "";
            objda.action = "selectbyAdmin";
            objda.name = txtSearch.Text;

            objda.company = Session["CompanyId"].ToString();
            ds = objda.AnnouncementMaster();
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
                divmsg.InnerHtml = "";
                dgnews.Visible = true;
                divmsg.Visible = false;
            }
            else
            {
                divmsg.InnerHtml = "No record found.";
                dgnews.Visible = false;
                lblstart.Text = "0";
                lblend.Text = "0";
                divmsg.Visible = true;
            }
        }

        //Delete Annoucement
        protected void DeleteAnnounce(string id)
        {

            objda.action = "delete";
            objda.id = id;
            objda.AnnouncementMaster();
            fillgrid();

        }

        //Edit Announcement
        protected void EditAnnounce(string id)
        {
            hidid.Value = id;
            objda.id = id;
            objda.company = Session["CompanyId"].ToString();
            objda.action = "select";
            ds = objda.AnnouncementMaster();
            txttitle.Text = ds.Tables[0].Rows[0]["title"].ToString();
            txtdesc.Text = ds.Tables[0].Rows[0]["description"].ToString();
            txtdisplayon.Text = ds.Tables[0].Rows[0]["displaydate"].ToString();
            litaddesby.Text = ds.Tables[0].Rows[0]["name"].ToString();
            litadderon.Text = ds.Tables[0].Rows[0]["adddate"].ToString();

            if (ds.Tables[0].Rows[0]["imagePath"].ToString() == null || ds.Tables[0].Rows[0]["imagePath"].ToString() == "")
            {
                Image1.ImageUrl = "images/Announcement/calendar.png";
            }
            else
            {
                Image1.ImageUrl = "images/Announcement/" + ds.Tables[0].Rows[0]["imagePath"].ToString();
            }
            if (Convert.ToBoolean(ds.Tables[0].Rows[0]["availableToLogin"].ToString()) == true)
                chkavailableToLogin.Checked = true;
            else
                chkavailableToLogin.Checked = false;
            btnsubmit.Text = "Update";
            if (ViewState["add"] != null && ViewState["add"].ToString() != "1")
            {
                legendaction.InnerHtml = "Edit Announcement";
            }
            else
            {
                legendaction.InnerHtml = "Announcement Details";

            }

            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>openAddEdit();</script>", false);
        }

        //Popup announcment details in popup
        protected void binddetail(string id)
        {
            hidid.Value = id;
            objda.id = id;
            objda.company = Session["CompanyId"].ToString();
            objda.action = "select";
            ds = objda.AnnouncementMaster();
            lblTitle.Text = ds.Tables[0].Rows[0]["title"].ToString();
            lbldesc.Text = ds.Tables[0].Rows[0]["description"].ToString();
            lbladdedby.Text = ds.Tables[0].Rows[0]["name"].ToString();
            lbladdedon.Text = ds.Tables[0].Rows[0]["adddate"].ToString();
            if (ds.Tables[0].Rows[0]["imagePath"].ToString() == null || ds.Tables[0].Rows[0]["imagePath"].ToString() == "")
            {
                Image2.ImageUrl = "images/Announcement/calendar.png";
            }
            else
            {
                Image2.ImageUrl = "images/Announcement/" + ds.Tables[0].Rows[0]["imagePath"].ToString();
            }
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>opendiv();</script>", false);
        }

        /// <summary>
        /// Make rows as clickable to see details
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dgnews_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                LinkButton lbtndel = (LinkButton)e.Row.FindControl("cid");
                Label lblid = (Label)e.Row.FindControl("lblid");
                HtmlGenericControl divtop = (HtmlGenericControl)e.Row.FindControl("announcetop");        
                divtop.Attributes.Add("onclick", Page.ClientScript.GetPostBackClientHyperlink(dgnews, "RowCommand$" + DataBinder.Eval(e.Row.DataItem, "nid").ToString()));
                divtop.Attributes["onmouseover"] = "this.style.cursor='pointer'";

                HtmlImage img = (HtmlImage)e.Row.FindControl("imgannoIcon");
                if (DataBinder.Eval(e.Row.DataItem, "imagePath") != null && DataBinder.Eval(e.Row.DataItem, "imagePath").ToString() != "")
                {
                    img.Src = "images/Announcement/" + DataBinder.Eval(e.Row.DataItem, "imagePath").ToString();
                }
                else
                {
                    img.Src = "images/Announcement/colorwheel.png";
                
                }

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

       

        protected void dgnews_RowCommand(object sender, GridViewCommandEventArgs e)
        {
           
           
            if (e.CommandName.ToLower() == "rowcommand")
            {

                binddetail(e.CommandArgument.ToString());
            }

        }
      
        public void blank()
        {
            hidid.Value = "";
            txttitle.Text = "";
            txtdesc.Text = "";
            txtdisplayon.Text = GeneralMethod.getLocalDate();
            tradded.Visible = false;
            btnsubmit.Text = "Save";
            legendaction.InnerHtml = "Add New Announcement";
        }

        public string Processdate(object myValue)
        {
            string strr = myValue.ToString();
            string[] date = strr.Split(new char[] { '/' });
            return date[1];
        }

        public string ProcessMonth(object myValue)
        {
            DateTime anndate = (Convert.ToDateTime(myValue.ToString()));
            int month = anndate.Month;
            return CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(month);
        }


        //Popup Add new div
        protected void lbtnaddnew_Click(object sender, EventArgs e)
        {
            blank();
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>openAddEdit();</script>", false);
        }

        //Edit Announcement
        protected void editimage_Click(object sender, ImageClickEventArgs e)
        {
            EditAnnounce(hidid.Value);
        }

        //Delete Announcement
        protected void cid_Click(object sender, EventArgs e)
        {
            DeleteAnnounce(hidid.Value);
        }

        //Search Announcement
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            dgnews.PageIndex = 0;
            fillgrid();
        }

        //Save announcment details
        protected void btnsubmit_Click(object sender, EventArgs e)
        {
            objda.action = "insert";
            objda.id = hidid.Value;
            objda.name = txttitle.Text;
            objda.company = Session["CompanyId"].ToString();
            objda.description = txtdesc.Text;
            objda.dob = txtdisplayon.Text;
            objda.dob2 = GeneralMethod.getLocalDate();
            objda.loginid = Session["userid"].ToString();
            objda.imgPath = Announcement_hidicon.Value;
            //Here user type parameter to Show Announcement on login page
            if (chkavailableToLogin.Checked == true)
                objda.usertype = "1";
            else
                objda.usertype = "0";
            ds = objda.AnnouncementMaster();
            blank();
            fillgrid();
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('Saved Successfully.');</script>", false);
           

        }
      


    }
}