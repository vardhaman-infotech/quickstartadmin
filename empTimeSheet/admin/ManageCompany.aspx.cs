using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.IO;


namespace emptimesheet.admin
{
    public partial class ManageCompany : System.Web.UI.Page
    {
        ClsAdmin objda = new ClsAdmin();
        ClsUser objuser = new ClsUser();
        DataSet ds = new DataSet();
        DataSet ds1 = new DataSet();
        protected void Page_Load(object sender, EventArgs e)
        {
            //Ajax.Utility.RegisterTypeForAjax(typeof(admin_ManageCompany));
            if (!objda.validatelogin())
                Response.Redirect("logout.aspx");


            Page.Form.Attributes.Add("enctype", "multipart/form-data");


            if (!Page.IsPostBack)
            {
                divnodatafound.Visible = false;
                bindcountry();
                bindgrid();
                bindcurrency();

            }

        }

        protected void bindcurrency()
        {
            objda.action = "selectcurrency";
            ds = objda.ManageMaster();
            if (ds.Tables[0].Rows.Count > 0)
            {
                ddlcurrency.DataTextField = "symbol";
                ddlcurrency.DataValueField = "nid";
                ddlcurrency.DataSource = ds;
                ddlcurrency.DataBind();
            }
            ListItem li = new ListItem();
            li.Text = "--Select Currency--";
            li.Value = "";
            ddlcurrency.Items.Insert(0, li);
        }
        //Bind dropdown of country
        protected void bindcountry()
        {
            objda.nid = "";
            objda.action = "selectcountry";
            ds1 = objda.ManageMaster();
            if (ds1.Tables[0].Rows.Count > 0)
            {
                txtCountry.DataTextField = "countryname";
                txtCountry.DataValueField = "nid";
                txtCountry.DataSource = ds1;
                txtCountry.DataBind();

            }
            ListItem li = new ListItem();
            li.Text = "--Select--";
            li.Value = "";
            txtCountry.Items.Insert(0, li);


            bindstate();
        }
        /// <summary>
        /// Bind drop down of state
        /// 
        protected void bindstate()
        {
            objda.nid = "";
            objda.parentid = txtCountry.Text;
            objda.action = "selectstate";
            ds1 = objda.ManageMaster();
            if (ds1.Tables[0].Rows.Count > 0)
            {
                txtState.DataTextField = "statename";
                txtState.DataValueField = "nid";
                txtState.DataSource = ds1;
                txtState.DataBind();

            }
            ListItem li = new ListItem();
            li.Text = "--Select--";
            li.Value = "";
            txtState.Items.Insert(0, li);
            bindcity();
        }
        protected void ddlcountry_SelectedIndexChanged(object sender, EventArgs e)
        {
            bindstate();
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>openpopup();</script>", false);

        }
        /// <summary>
        /// Bind drop down of city
        /// 
        protected void bindcity()
        {
            objda.nid = "";
            objda.parentid = txtState.Text;
            objda.action = "selectcity";
            ds1 = objda.ManageMaster();
            if (ds1.Tables[0].Rows.Count > 0)
            {
                txtCity.DataTextField = "cityname";
                txtCity.DataValueField = "cityname";
                txtCity.DataSource = ds1;
                txtCity.DataBind();

            }
            ListItem li = new ListItem();
            li.Text = "--Select--";
            li.Value = "";
            txtCity.Items.Insert(0, li);
        }

        protected void ddlstate_SelectedIndexChanged(object sender, EventArgs e)
        {
            bindcity();
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>openpopup();</script>", false);
        }


        public void bindgrid()
        {
            objda.action = "select";
            objda.nid = "";
            ds = objda.ManageCompany();


            if (ds.Tables[0].Rows.Count > 0)
            {
                getpageindex(ds.Tables[0].Rows.Count);
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

        public void getpageindex(int count)
        {
            if (count <= dgnews.CurrentPageIndex * dgnews.PageSize)
            {
                dgnews.CurrentPageIndex = dgnews.CurrentPageIndex - 1;
            }
        }
        protected void dgnews_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
        {
            dgnews.CurrentPageIndex = e.NewPageIndex;
            bindgrid();


        }
        public void blank()
        {
            txtaddress.Value = "";
            txtCity.SelectedIndex = 0;
            txtcode.Text = "";
            txtCompany.Text = "";
            txtcontactperson.Value = "";
            txtCountry.Text = "";
            txtemail.Text = "";
            txtFax.Value = "";
            txtphone.Value = "";
            txtState.SelectedIndex = 0;
            txtwebsite.Value = "";
            txtZip.Value = "";
            hidid.Value = "";
            txtCountry.SelectedIndex = 0;
            txtfname.Value = "";
            txtlname.Value = "";
            txtpassword.Text = "";
            hidempid.Value = "";
            txtloginid.Value = "";
            txtloginid.Disabled = false;
            ddlcurrency.SelectedIndex = 0;

        }
        protected void btnsave_Click(object sender, EventArgs e)
        {
            objda.nid = hidid.Value;
            objda.code = txtcode.Text;
            objda.Name = txtCompany.Text;
            objda.action = "checkexists";
            ds = objda.ManageCompany();
            if (ds.Tables[0].Rows.Count > 0)
            {
                txtcode.Focus();
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('Company code already exists');</script>", false);

                return;
            }
            objda.action = "insert";
            objda.address = txtaddress.Value;
            objda.cityId = txtCity.SelectedItem.Text;
            objda.stateId = txtState.SelectedItem.Text;
            objda.countryId = txtCountry.SelectedItem.Text;
            objda.zip = txtZip.Value;
            objda.phone = txtphone.Value;
            objda.fax = txtFax.Value;
            objda.contactPerson = txtcontactperson.Value;
            objda.email = txtemail.Text;
            objda.website = txtwebsite.Value;
            //imgurl used to Pass LogoURL value
            objda.imgurl = hidlogo.Value;
            //logoURL used to pass LogoIcon value
            objda.logoURL = hidlogoicon.Value;
            objda.creationDate = GeneralMethod.getLocalDateTime();
            objda.symbol = ddlcurrency.Text;
            ds = objda.ManageCompany();
            if (ds.Tables[0].Rows.Count > 0)
            {
                hidid.Value = ds.Tables[0].Rows[0]["nid"].ToString();
                objda.action = "checkexist";
                objda.loginid = txtloginid.Value;
                objda.userType = "admin";
                objda.companyId = hidid.Value;
                objda.nid = hidempid.Value;
                objda.deptId = "";
                objda.desigId = "";
             
                ds = objda.ManageUser();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    txtloginid.Value = "";
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('Login Id already exists');</script>", false);

                }
                objda.action = "insert";
                objda.companyId = hidid.Value;
                objda.status = "Active";
                objda.userid = Session["adminid"].ToString();
                objda.fname = txtfname.Value;
                objda.lname = txtlname.Value;
                objda.loginid = txtloginid.Value;
                objda.pass = txtpassword.Text;
                ds = objda.ManageUser();
            }

            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('Record saved successfully');</script>", false);

            bindgrid();
            blank();


        }
        protected void dgnews_ItemCommand1(object source, DataGridCommandEventArgs e)
        {
            //Delete company
            if (e.CommandName == "delete")
            {
                divmsg.Style.Add("display", "none");
                objda.action = "delete";
                objda.nid = e.CommandArgument.ToString();
                objda.ManageCompany();
                bindgrid();

            }
            //Edit company
            if (e.CommandName == "edit")
            {
                divmsg.Style.Add("display", "none");
                hidid.Value = e.CommandArgument.ToString();

                binddetails();
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>openpopup();</script>", false);
            }

        }
        protected void binddetails()
        {
            objda.nid = hidid.Value;
            objda.action = "select";
            ds = objda.ManageCompany();
            txtCompany.Text = ds.Tables[0].Rows[0]["companyname"].ToString();
            hidcompany.Value = ds.Tables[0].Rows[0]["nid"].ToString();
            ListItem itemToSelect;
            if (Convert.ToString(ds.Tables[0].Rows[0]["countryid"]) != "")
            {
                //Get the List Item if matched with the name existing in database COUNTRY field
                itemToSelect = txtCountry.Items.FindByText(ds.Tables[0].Rows[0]["countryid"].ToString());

                //Check whether item found or not, NULL indicates- item not found
                if (itemToSelect != null)
                {
                    //if found- select Listitem's value in dropdown
                    txtCountry.Text = itemToSelect.Value;

                }
                bindstate();
            }

            if (Convert.ToString(ds.Tables[0].Rows[0]["stateid"]) != "")
            {
                //Get the List Item if matched with the name existing in database State field
                itemToSelect = txtState.Items.FindByText(ds.Tables[0].Rows[0]["stateid"].ToString());

                //Check whether item found or not, NULL indicates- item not found
                if (itemToSelect != null)
                {
                    //if found- select Listitem's value in dropdown
                    txtState.Text = itemToSelect.Value;

                }
                bindcity();
            }
            txtCity.Text = ds.Tables[0].Rows[0]["cityid"].ToString();
            txtcode.Text = ds.Tables[0].Rows[0]["compcode"].ToString();

            txtaddress.Value = ds.Tables[0].Rows[0]["address"].ToString();
            txtZip.Value = ds.Tables[0].Rows[0]["zip"].ToString();
            txtFax.Value = ds.Tables[0].Rows[0]["fax"].ToString();
            txtemail.Text = ds.Tables[0].Rows[0]["email"].ToString();
            txtcontactperson.Value = ds.Tables[0].Rows[0]["contactperson"].ToString();
            txtphone.Value = ds.Tables[0].Rows[0]["phone"].ToString();
            txtwebsite.Value = ds.Tables[0].Rows[0]["website"].ToString();

            if (ds.Tables[0].Rows[0]["logoURL"] != null && ds.Tables[0].Rows[0]["logoURL"].ToString() != "")
            {
                hidlogo.Value = ds.Tables[0].Rows[0]["logoURL"].ToString();

                imglogo.ImageUrl = "../webfile/" + ds.Tables[0].Rows[0]["logoURL"].ToString();
            }
            if (ds.Tables[0].Rows[0]["LogoIcon"] != null && ds.Tables[0].Rows[0]["LogoIcon"].ToString() != "")
            {
                hidlogoicon.Value = ds.Tables[0].Rows[0]["LogoIcon"].ToString();

                imglogoicon.ImageUrl = "../webfile/" + ds.Tables[0].Rows[0]["LogoIcon"].ToString();
            }
            if (ds.Tables[1].Rows.Count > 0)
            {
                hidempid.Value = ds.Tables[1].Rows[0]["nid"].ToString();
                txtfname.Value = ds.Tables[1].Rows[0]["fname"].ToString();
                txtlname.Value = ds.Tables[1].Rows[0]["lname"].ToString();
                txtloginid.Value = ds.Tables[1].Rows[0]["loginid"].ToString();
                txtloginid.Disabled = true;
                txtpassword.Text = ds.Tables[1].Rows[0]["password"].ToString();
            }
            if (ds.Tables[0].Rows[0]["currencyid"] != null)
            {
                ddlcurrency.Text = ds.Tables[0].Rows[0]["currencyid"].ToString();
            }
        }


        //Use the following code to show company limitatiion message on add new button click
        protected void btnaddnew_click(object sender, EventArgs e)
        {

            ScriptManager.RegisterStartupScript(this, GetType(), "add", "showdivnews();", false);

        }

        protected void btnupload_click(object sender, EventArgs e)
        {
            if (fileuploadlogo.HasFile)
            {
                if (fileuploadlogo.PostedFile.ContentType == "image/jpeg" || fileuploadlogo.PostedFile.ContentType == "image/png" || fileuploadlogo.PostedFile.ContentType == "image/gif" || fileuploadlogo.PostedFile.ContentType == "image/psd")
                {
                    TimeSpan ts = DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0, 0);
                    string FormatedDateTime = Convert.ToInt64(ts.TotalSeconds).ToString();
                    string ssUniqueId = DateTime.UtcNow.ToString("fffffff");
                    string date = DateTime.Now.ToString("MMddyyyy");
                    string unid = date + "_" + ssUniqueId;

                    string extn = Path.GetExtension(fileuploadlogo.FileName).ToString().ToLower();
                    fileuploadlogo.SaveAs(AppDomain.CurrentDomain.BaseDirectory + "webfile\\" + unid + extn);
                    imglogo.ImageUrl = "../webfile/" + unid + extn;
                    hidlogo.Value = unid + extn;
                }


            }

            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>openpopup();</script>", false);
        }
        protected void btnuploadicon_click(object sender, EventArgs e)
        {
            if (fileuploadicon.HasFile)
            {
                if (fileuploadicon.PostedFile.ContentType == "image/jpeg" || fileuploadicon.PostedFile.ContentType == "image/png" || fileuploadicon.PostedFile.ContentType == "image/gif" || fileuploadicon.PostedFile.ContentType == "image/psd")
                {
                    TimeSpan ts = DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0, 0);
                    string FormatedDateTime = Convert.ToInt64(ts.TotalSeconds).ToString();
                    string ssUniqueId = DateTime.UtcNow.ToString("fffffff");
                    string date = DateTime.Now.ToString("MMddyyyy");
                    string unid = "logoicon_" + date + "_" + ssUniqueId;

                    string extn = Path.GetExtension(fileuploadicon.FileName).ToString().ToLower();
                    fileuploadicon.SaveAs(AppDomain.CurrentDomain.BaseDirectory + "webfile\\" + unid + extn);
                    imglogoicon.ImageUrl = "../webfile/" + unid + extn;
                    hidlogoicon.Value = unid + extn;
                }


            }

            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>openpopup();</script>", false);
        }
    }
}