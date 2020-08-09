using AjaxControlToolkit;
using empTimeSheet.DataClasses.DAL;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using uploadimage;

namespace empTimeSheet
{
    public partial class asset_AssetMaster : System.Web.UI.Page
    {
        #region "Global variable Declaration"
        GeneralMethod objgen = new GeneralMethod();
        ClsUser objuser = new ClsUser();
        DataSet ds = new DataSet();
        DataAccess objda = new DataAccess();
        Cls_Asset objAsset = new Cls_Asset();
        static DataSet dsexcel = new DataSet();
        excelexport objexcel = new excelexport();
        string depid = "";
        #endregion

        #region "Page Load Event"
        protected void Page_Load(object sender, EventArgs e)
        {
            txtPurchaseDate.Attributes.Add("readonly", "readonly");
            txtdescription.Attributes.Add("maxlength", "40");
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                if (!objda.checkUserInroles("90"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
                blank();
                fillemployee();
                filldepartment();
                fillVendor();
                fillCategory();
                fillCondition();
                fillgrid();
            }
        }
        #endregion

        #region"Fill All Employees"
        protected void fillemployee()
        {
            objuser.action = "select";
            objuser.companyid = Session["companyid"].ToString();
            objuser.id = "";
            ds = objuser.ManageEmployee();
            objgen.fillActiveInactiveDDL(ds.Tables[0], dropemployee, "username", "nid");
            ListItem li = new ListItem("--Select Employee--", "");
            dropemployee.Items.Insert(0, li);
            //dropemployee.Text = Session["userid"].ToString();
            dropemployee.SelectedIndex = 0;
        }
        #endregion

        #region"Fill All Departments"
        public void filldepartment()
        {
            objda.id = "";
            objda.name = "";
            objda.company = Session["companyid"].ToString();
            objda.action = "select";
            ds = objda.department();
            DropDepartment.DataSource = ds;
            DropDepartment.DataTextField = "department";
            DropDepartment.DataValueField = "nid";
            DropDepartment.DataBind();

            DropSearchDepartment.DataSource = ds;
            DropSearchDepartment.DataTextField = "department";
            DropSearchDepartment.DataValueField = "nid";
            DropSearchDepartment.DataBind();

            ListItem li = new ListItem("--Select--", "");
            DropDepartment.Items.Insert(0, li);
            DropDepartment.SelectedIndex = 0;

            ListItem li1 = new ListItem("--All Department--", "");
            DropSearchDepartment.Items.Insert(0, li1);
            DropSearchDepartment.SelectedIndex = 0;

        }
        #endregion

        #region"Fill All Vendors"
        public void fillVendor()
        {
            objAsset.companyId = Session["companyid"].ToString();
            objAsset.action = "selectVendor";
            ds = objAsset.ManageAsset();
            dropvendor.DataSource = ds;
            dropvendor.DataTextField = "VenderName";
            dropvendor.DataValueField = "nid";
            dropvendor.DataBind();

            DropRepairvndr.DataSource = ds;
            DropRepairvndr.DataTextField = "VenderName";
            DropRepairvndr.DataValueField = "nid";
            DropRepairvndr.DataBind();

            ListItem li = new ListItem("--Select--", "");
            dropvendor.Items.Insert(0, li);
            dropvendor.SelectedIndex = 0;

            ListItem li1 = new ListItem("--Select Vendor--", "");
            DropRepairvndr.Items.Insert(0, li1);
            DropRepairvndr.SelectedIndex = 0;

        }
        #endregion

        #region"Fill All Category"
        public void fillCategory()
        {
            objAsset.companyId = Session["companyid"].ToString();
            objAsset.action = "selectCategory";
            ds = objAsset.ManageAsset();
            dropcategory.DataSource = ds;
            dropcategory.DataTextField = "categoryname";
            dropcategory.DataValueField = "nid";
            dropcategory.DataBind();

            DropSearchCategory.DataSource = ds;
            DropSearchCategory.DataTextField = "categoryname";
            DropSearchCategory.DataValueField = "nid";
            DropSearchCategory.DataBind();

            ListItem li = new ListItem("--Select--", "");
            dropcategory.Items.Insert(0, li);
            dropcategory.SelectedIndex = 0;

            ListItem li1 = new ListItem("--All Category--", "");
            DropSearchCategory.Items.Insert(0, li1);
            DropSearchCategory.SelectedIndex = 0;

        }
        #endregion

        #region"Fill All Conditions"
        public void fillCondition()
        {
            objAsset.companyId = Session["companyid"].ToString();
            objAsset.action = "selectCondition";
            ds = objAsset.ManageAsset();
            dropworkingcondition.DataSource = ds;
            dropworkingcondition.DataTextField = "name";
            dropworkingcondition.DataValueField = "nid";
            dropworkingcondition.DataBind();

            ListItem li = new ListItem("--Select--", "");
            dropworkingcondition.Items.Insert(0, li);
            dropworkingcondition.SelectedIndex = 0;

        }
        #endregion

        #region "Button Submit Click Event
        protected void btnsubmit_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                objAsset.nid = hidid.Value;
                objAsset.companyId = Session["companyid"].ToString();

                objAsset.action = "checkexist";
                objAsset.Code = txtcode.Text;
                objAsset.name = txtname.Text;
                ds = objAsset.ManageAsset();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    GeneralMethod.alert(this.Page, "As set Code already exists!");
                    ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);
                    updatePanelAssign.Update();
                    return;
                }

                //objAsset.action = "changeimg";
                //ds = objAsset.ManageAsset();

                objAsset.action = "insert";
                //objAsset.nid = hidid.Value;
                objAsset.Code = txtcode.Text;
                objAsset.CategoryID = dropcategory.Text;
                objAsset.name = txtname.Text;
                objAsset.assetDesc = txtdescription.Text;

                objAsset.department = DropDepartment.Text;
                objAsset.assetBarcode = txtbarcode.Text;
                objAsset.serialNo = txtserialno.Text;
                objAsset.ItemWaranty = txtwaranty.Text;

                objAsset.AssetCondition = dropworkingcondition.Text;
                objAsset.vendorId = dropvendor.Text;
                objAsset.manuCompany = txtmanufacture.Text;
                objAsset.price = txtprice.Text;

                objAsset.invoice = txtinvoicenumber.Text;
                objAsset.currentLocation = dropLocation.Text;
                if (dropLocation.Text == "Individual")
                {
                    objAsset.locationId = dropemployee.Text;
                }
                else if (dropLocation.Text == "Repair")
                {
                    objAsset.locationId = DropRepairvndr.Text;
                }

                objAsset.manuCompany = txtmanufacture.Text;
                objAsset.Notes = txtremark.Text;
                objAsset.recType = "Add";
                objAsset.transferBy = Session["userid"].ToString();
                objAsset.transferDate = txtDate.Text;
                objAsset.PurchaseDate = txtPurchaseDate.Text;

                //objAsset.imgURL = ViewState["filename"].ToString();

                if (Session["filename"] != null)
                    objAsset.imgURL = Session["filename"].ToString();

                ds = objAsset.ManageAsset();
                //if (ds.Tables[0].Rows.Count > 0)
                //{
                blank();
                fillgrid();
                GeneralMethod.alert(this.Page, "Saved Successfully!");
                //Session["filename"] = null;
                updatePanelAssign.Update();
                //}
            }
        }

        #endregion

        #region Fill Grid of Asset Master
        protected void fillgrid()
        {
            objAsset.companyId = Session["companyid"].ToString();
            objAsset.CategoryID = DropSearchCategory.Text;
            objAsset.department = DropSearchDepartment.Text;
            objAsset.name = txtSearchAsset.Text;
            //objAsset.Code = txtSearchAsset.Text;
            objAsset.action = "select";
            objAsset.nid = hidid.Value;
            objAsset.locationId = "";
            ds = objAsset.ManageAsset();

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
                divnodata.Visible = false;
                dgnews.Visible = true;

                //btnexportcsv.Enabled = true;
            }
            else
            {

                if (IsPostBack)
                {
                    divnodata.Visible = true;
                }
                dgnews.Visible = false;
                //btnexportcsv.Enabled = false;
            }
            dsexcel = ds;
            ScriptManager.RegisterStartupScript(updatePanelData, updatePanelData.GetType(), "key", "<script type='text/javascript'>fixheader();</script>", false);
            updatePanelData.Update();
        }

        #endregion

        #region Blank All Controls
        public void blank()
        {
            //txtDate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");
            txtcode.Text = "";
            txtdescription.Text = "";
            hidid.Value = "";
            txtname.Text = "";
            dropcategory.SelectedIndex = 0;
            txtserialno.Text = "";
            txtbarcode.Text = "";
            txtwaranty.Text = "";
            dropworkingcondition.SelectedIndex = 0;
            dropLocation.SelectedIndex = 0;
            DropDepartment.SelectedIndex = 0;
            txtremark.Text = "";
            txtDate.Text = "";
            dropLocation.Enabled = true;
            DropDepartment.Enabled = true;
            txtDate.Enabled = true;
            Session["filename"] = null;
            dropemployee.Enabled = true;
            DropRepairvndr.Enabled = true;


        }
        #endregion

        #region "Search Buttton Click"
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            hidid.Value = "";
            fillgrid();
        }
        #endregion

        #region "DataGridview Row Command Event"
        protected void dgnews_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "edititem")
            {
                hidid.Value = e.CommandArgument.ToString();
                objAsset.nid = hidid.Value;
                objAsset.action = "select";
                ds = objAsset.ManageAsset();

                txtcode.Text = ds.Tables[0].Rows[0]["assetcode"].ToString();
                txtname.Text = ds.Tables[0].Rows[0]["assetname"].ToString();
                txtdescription.Text = ds.Tables[0].Rows[0]["assetDesc"].ToString();
                dropcategory.Text = ds.Tables[0].Rows[0]["cetegoryid"].ToString();
                txtbarcode.Text = ds.Tables[0].Rows[0]["assetBarCode"].ToString();
                txtserialno.Text = ds.Tables[0].Rows[0]["serialNo"].ToString();
                txtwaranty.Text = ds.Tables[0].Rows[0]["ItemWaranty"].ToString();
                dropworkingcondition.Text = ds.Tables[0].Rows[0]["assetCondition"].ToString();
                dropLocation.Text = ds.Tables[0].Rows[0]["currentLocation"].ToString();
                txtPurchaseDate.Text = ds.Tables[0].Rows[0]["purchaseDate"].ToString();
                //dropLocation.Enabled = false;

                //if (ds.Tables[0].Rows[0]["currentLocation"].ToString() == "Individual")
                //{
                //    divEmployee.Style.Add("display", "block");
                //    dropemployee.Text = ds.Tables[0].Rows[0]["locationId"].ToString();
                //}
                //else
                //{
                //    divEmployee.Style.Add("display", "none");
                //    dropemployee.SelectedIndex = 0;
                //}

                if (ds.Tables[0].Rows[0]["currentLocation"].ToString() == "Individual")
                {
                    divEmployee.Style.Add("display", "block");
                    dropemployee.Text = ds.Tables[0].Rows[0]["locationId"].ToString();
                }
                else if (ds.Tables[0].Rows[0]["currentLocation"].ToString() == "Repair")
                {
                    divVendor.Style.Add("display", "block");
                    DropRepairvndr.Text = ds.Tables[0].Rows[0]["locationId"].ToString();
                }

                //dropemployee.Enabled = false;
               // DropRepairvndr.Enabled = false;
                DropDepartment.Text = ds.Tables[0].Rows[0]["department"].ToString();
               // DropDepartment.Enabled = false;
                txtremark.Text = ds.Tables[0].Rows[0]["notes"].ToString();
                dropvendor.Text = ds.Tables[0].Rows[0]["vendorId"].ToString();
                txtmanufacture.Text = ds.Tables[0].Rows[0]["manuCompany"].ToString();
                txtinvoicenumber.Text = ds.Tables[0].Rows[0]["invoice"].ToString();
                txtprice.Text = ds.Tables[0].Rows[0]["price"].ToString();
                if (ds.Tables[0].Rows[0]["imgurl"].ToString() != null)
                    DisplayImg.Src = "~/webfile/Asset/" + ds.Tables[0].Rows[0]["imgurl"].ToString();
                else
                    DisplayImg.Src = "~/webfile/profile/nophoto.png";
                txtDate.Enabled = false;
                btnsubmit.Text = "Update";

                ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);
                updatePanelAssign.Update();
            }

            if (e.CommandName == "del")
            {
                objAsset.nid = e.CommandArgument.ToString();
                objAsset.action = "delete";
                objAsset.ManageAsset();
                fillgrid();
            }
            if (e.CommandName == "historyOfItem")
            {
                hidid.Value = e.CommandArgument.ToString();
                objAsset.nid = hidid.Value;

                objAsset.action = "select";
                ds = objAsset.ManageAsset();
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "key", "<script type='text/javascript'>openHistoryDiv();</script>", false);

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "scr", "javascript:displayHistoryThroughImages('" + objAsset.nid + "')", true);
                updatePanelImageHistory.Update();
                Span2.InnerText = "History of : " + ds.Tables[0].Rows[0]["assetname"].ToString();
            }
        }
        protected void PaggedGridbtnedit_Click(object sender, EventArgs e)
        {
          
            objAsset.nid = hidid.Value;
            objAsset.action = "select";
            ds = objAsset.ManageAsset();

            txtcode.Text = ds.Tables[0].Rows[0]["assetcode"].ToString();
            txtname.Text = ds.Tables[0].Rows[0]["assetname"].ToString();
            txtdescription.Text = ds.Tables[0].Rows[0]["assetDesc"].ToString();
            dropcategory.Text = ds.Tables[0].Rows[0]["cetegoryid"].ToString();
            txtbarcode.Text = ds.Tables[0].Rows[0]["assetBarCode"].ToString();
            txtserialno.Text = ds.Tables[0].Rows[0]["serialNo"].ToString();
            txtwaranty.Text = ds.Tables[0].Rows[0]["ItemWaranty"].ToString();
            dropworkingcondition.Text = ds.Tables[0].Rows[0]["assetCondition"].ToString();
            dropLocation.Text = ds.Tables[0].Rows[0]["currentLocation"].ToString();
            txtPurchaseDate.Text = ds.Tables[0].Rows[0]["purchaseDate"].ToString();
           /// dropLocation.Enabled = false;

            //if (ds.Tables[0].Rows[0]["currentLocation"].ToString() == "Individual")
            //{
            //    divEmployee.Style.Add("display", "block");
            //    dropemployee.Text = ds.Tables[0].Rows[0]["locationId"].ToString();
            //}
            //else
            //{
            //    divEmployee.Style.Add("display", "none");
            //    dropemployee.SelectedIndex = 0;
            //}

            if (ds.Tables[0].Rows[0]["currentLocation"].ToString() == "Individual")
            {
                divEmployee.Style.Add("display", "block");
                dropemployee.Text = ds.Tables[0].Rows[0]["locationId"].ToString();
            }
            else if (ds.Tables[0].Rows[0]["currentLocation"].ToString() == "Repair")
            {
                divVendor.Style.Add("display", "block");
                DropRepairvndr.Text = ds.Tables[0].Rows[0]["locationId"].ToString();
            }

          ///  dropemployee.Enabled = false;
           /// DropRepairvndr.Enabled = false;
            DropDepartment.Text = ds.Tables[0].Rows[0]["department"].ToString();
           /// DropDepartment.Enabled = false;
            txtremark.Text = ds.Tables[0].Rows[0]["notes"].ToString();
            dropvendor.Text = ds.Tables[0].Rows[0]["vendorId"].ToString();
            txtmanufacture.Text = ds.Tables[0].Rows[0]["manuCompany"].ToString();
            txtinvoicenumber.Text = ds.Tables[0].Rows[0]["invoice"].ToString();
            txtprice.Text = ds.Tables[0].Rows[0]["price"].ToString();
            if (ds.Tables[0].Rows[0]["imgurl"].ToString() != null)
                DisplayImg.Src = "~/webfile/Asset/" + ds.Tables[0].Rows[0]["imgurl"].ToString();
            else
                DisplayImg.Src = "~/webfile/profile/nophoto.png";
            //txtDate.Enabled = false;
            btnsubmit.Text = "Update";

            ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);
            updatePanelAssign.Update();
        }
        protected void btnHistory_Click(object sender, EventArgs e)
        {
            objAsset.nid = hidid.Value;

            objAsset.action = "select";
            ds = objAsset.ManageAsset();
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "key", "<script type='text/javascript'>openHistoryDiv();</script>", false);

            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "scr", "javascript:displayHistoryThroughImages('" + objAsset.nid + "')", true);
            updatePanelImageHistory.Update();
            Span2.InnerText = "History of : " + ds.Tables[0].Rows[0]["assetname"].ToString();
        }
        #endregion

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getImagesPath(string assetId)
        {
            StringBuilder sb = new StringBuilder();
            Cls_Asset objAsset = new Cls_Asset();
            DataSet ds = new DataSet();
            GeneralMethod objgen = new GeneralMethod();
            objAsset.AssetId = assetId;
            //  objAsset.companyId = Session["companyid"].ToString();
            objAsset.action = "selectforhistory";
            ds = objAsset.trasferAssets();
            sb.Append('{');

            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                switch (ds.Tables[0].Rows[i]["transferTo"].ToString())
                {
                    case "Individual":
                        {
                            if (ds.Tables[0].Rows[i]["imgurl"].ToString() != "")
                            {
                                sb.Append("\"pathImage" + i + "\"" + ":\"" + "webfile//profile//thumb//" + ds.Tables[0].Rows[i]["imgurl"].ToString() + "@" + ds.Tables[0].Rows[i]["transferdate"].ToString() + "@" + ds.Tables[0].Rows[i]["Location"].ToString() + "\"");

                            }
                            else
                            {
                                sb.Append("\"pathImage" + i + "\"" + ":\"images//" + "Individualss.png@" + ds.Tables[0].Rows[i]["transferdate"].ToString() + "@" + ds.Tables[0].Rows[i]["Location"].ToString() + "\"");
                            }
                            break;
                        }
                    case "Stock":
                        {
                            sb.Append("\"pathImage" + i + "\"" + ":\"images//" + "Stocks.png@" + ds.Tables[0].Rows[i]["transferdate"].ToString() + "@" + ds.Tables[0].Rows[i]["Location"].ToString() + "\"");
                            break;
                        }

                    case "Store":
                        {
                            sb.Append("\"pathImage" + i + "\"" + ":\"images//" + "Stores.png@" + ds.Tables[0].Rows[i]["transferdate"].ToString() + "@" + ds.Tables[0].Rows[i]["Location"].ToString() + "\"");
                            break;
                        }
                    case "Inuse":
                        {
                            sb.Append("\"pathImage" + i + "\"" + ":\"images//" + "InUses.png@" + ds.Tables[0].Rows[i]["transferdate"].ToString() + "@" + ds.Tables[0].Rows[i]["Location"].ToString() + "\"");
                            break;
                        }
                    case "Repair":
                        {
                            sb.Append("\"pathImage" + i + "\"" + ":\"images//" + "Repairs.png@" + ds.Tables[0].Rows[i]["transferdate"].ToString() + "@" + ds.Tables[0].Rows[i]["Location"].ToString() + "\"");
                            break;
                        }
                }
                if (i != ds.Tables[0].Rows.Count - 1)
                {
                    sb.Append(',');
                    sb.Append("\"pathImage" + i + 0 + 0 + "\"" + ":\"images//" + "arrows.png@" + ds.Tables[0].Rows[i]["transferdate"].ToString() + "@" + ds.Tables[0].Rows[i]["Location"].ToString() + "\"");
                    sb.Append(',');
                }
            }
            sb.Append('}');
            return sb.ToString();
        }

        #region "DataGridView PageIndex Changing Event"
        protected void dgnews_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            dgnews.PageIndex = e.NewPageIndex;
            fillgrid();
        }
        #endregion

        #region "DatagridView Row DataBound Event"
        protected void dgnews_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.Header)
                e.Row.TableSection = TableRowSection.TableHeader;
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                LinkButton lbtndelete = (LinkButton)e.Row.FindControl("lbtndelete");
                Label ltrcurrentstatus = (Label)e.Row.FindControl("ltrcurrentstatus");
                LinkButton lbtnedit = (LinkButton)e.Row.FindControl("lbtnedit");
                LinkButton lbtnHistory = (LinkButton)e.Row.FindControl("lbtnHistory");
                Image imgloc = (Image)e.Row.FindControl("imgloc");

                if (DataBinder.Eval(e.Row.DataItem, "currentLocation").ToString().ToLower() == "individual")
                {
                    imgloc.ImageUrl = "/images/Emp.png";
                }
                else if (DataBinder.Eval(e.Row.DataItem, "currentLocation").ToString().ToLower() == "store")
                {
                    imgloc.ImageUrl = "/images/Store.png";
                }
                else if (DataBinder.Eval(e.Row.DataItem, "currentLocation").ToString().ToLower() == "repair")
                {
                    imgloc.ImageUrl = "/images/Repair.png";
                }
                else if (DataBinder.Eval(e.Row.DataItem, "currentLocation").ToString().ToLower() == "stock")
                {
                    imgloc.ImageUrl = "/images/Stock.png";
                }
                else if (DataBinder.Eval(e.Row.DataItem, "currentLocation").ToString().ToLower() == "inuse")
                {
                    imgloc.ImageUrl = "/images/use.png";
                }
            }
        }
        #endregion

        #region "Button Refresh Click Event"
        protected void btnrefresh_Click(object sender, EventArgs e)
        {
            fillgrid();
        }
        #endregion

        #region "Empoyee DropDown list Selected indecx Changed Event"
        protected void employee_selecetdIndexChanged(object sender, EventArgs e)
        {
            objuser.action = "select";
            objuser.companyid = Session["companyid"].ToString();
            objuser.id = dropemployee.Text;
            ds = objuser.ManageEmployee();
            DropDepartment.Enabled = false;
            DropDepartment.Text = ds.Tables[0].Rows[0]["deptid"].ToString();
            updatePanelSearch.Update();
        }

        #endregion

        #region "Previous Link Button Click Event"
        protected void lnkprevious_Click(object sender, EventArgs e)
        {
            if (dgnews.PageIndex > 0)
            {
                dgnews.PageIndex = dgnews.PageIndex - 1;
                fillgrid();
            }
        }
        #endregion

        #region "Next Link Button Click Event"
        protected void lnknext_Click(object sender, EventArgs e)
        {
            if (int.Parse(lbltotalrecord.Text) > int.Parse(lblend.Text))
            {
                dgnews.PageIndex = dgnews.PageIndex + 1;
                fillgrid();
            }
        }
        #endregion


        //protected void btnupload_Click(object sender, EventArgs e)
        //{
        //    //if (FileUpload1.HasFile)
        //    //{
        //    //    string filename = "";
        //    //    string path2 = "";
        //    //    string datetime = DateTime.Now.ToFileTimeUtc().ToString();
        //    //    try
        //    //    {
        //    //        objuser.id = Session["userid"].ToString();
        //    //        String extension = Path.GetExtension(FileUpload1.PostedFile.FileName);
        //    //        if (extension.ToUpper() != ".JPG" && extension.ToUpper() != ".JPEG" && extension.ToUpper() != ".PNG" && extension.ToUpper() != ".GIF")
        //    //        {

        //    //            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('Selected file  has invalid format');</script>", false);
        //    //            return;
        //    //        }
        //    //        filename = "Asset" + datetime + extension;
        //    //        ViewState["filename"] = filename;
        //    //        //string path = Server.MapPath(FileUpload1.PostedFile.FileName);
        //    //        string path = AppDomain.CurrentDomain.BaseDirectory + "\\webfile\\Asset\\" + filename;
        //    //        ViewState["path"] = @"webfile/Asset/" + filename;
        //    //        FileUpload1.SaveAs(path);
        //    //        path = Server.MapPath("webfile/Asset/" + filename);
        //    //        path2 = Server.MapPath("webfile/Asset/thumb/" + filename);

        //    //        objimg.CreateThumbnail(100, 100, path, path2);

        //    //        //Find image control shown on top from Master page and change url
        //    //        //HtmlImage homethumbimage = (HtmlImage)this.Master.FindControl("imgphoto");

        //    //        //if (homethumbimage != null)
        //    //        //{
        //    //        //    homethumbimage.Src = "webfile/Asset/thumb/" + filename;
        //    //        //}

        //    //    }
        //    //    catch (Exception ex)
        //    //    {

        //    //        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('" + ex.ToString() + "'Server error please try again later.');</script>", false);
        //    //        return;

        //    //    }
        //    //    //objuser.imgurl = ViewState["filename"].ToString();
        //    //    //objuser.action = "changephoto";
        //    //    //ds = objuser.ManageEmployee();
        //    //    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>opendiv();</script>", false);
        //    //}

        //    //else
        //    //{
        //    //    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('Please select a file');</script>", false);
        //    //    return;
        //    //}


        //}

        protected string UploadFolderPath = "~/webfile/Asset/";
        protected string strfilename = "";
        protected void FileUploadComplete(object sender, EventArgs e)
        {

            //String extension = Path.GetExtension(System.IO.Path.GetFileName(AsyncFileUpload1.FileName));
            //if (extension.ToUpper() != ".JPG" && extension.ToUpper() != ".JPEG" && extension.ToUpper() != ".PNG" && extension.ToUpper() != ".GIF")
            //{
            //    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('Selected file  has invalid format');</script>", false);
            //    return;
            //}

            //string filename = DateTime.Now.ToFileTimeUtc().ToString()+extension;         
            //AsyncFileUpload1.SaveAs(Server.MapPath(this.UploadFolderPath) + filename);
            //strfilename = filename;
            //Session["filename"] = filename;

            string filename = System.IO.Path.GetFileName(AsyncFileUpload1.FileName);
            AsyncFileUpload1.SaveAs(Server.MapPath(this.UploadFolderPath) + filename);
            Session["filename"] = filename;



        }


    }
}