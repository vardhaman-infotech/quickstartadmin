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

namespace empTimeSheet
{
    public partial class assetTransferMaster : System.Web.UI.Page
    {
        #region "Global variable Declaration"
        public Cls_Asset clsObject = new Cls_Asset();
        GeneralMethod objgen = new GeneralMethod();
        ClsUser objuser = new ClsUser();
        DataSet ds = new DataSet();
        DataAccess objda = new DataAccess();
        Cls_Asset objAsset = new Cls_Asset();
        static DataSet dsexcel = new DataSet();
        excelexport objexcel = new excelexport();

        #endregion

        #region member variables

        #endregion

        #region "Page Load Event"
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                TransferAsset_hiduserid.Value = Session["userid"].ToString();
                objda.action = "getUserInRoles";
                objda.id = Session["userid"].ToString();
                ds = objda.getUserInRoles();
                if (!objda.checkUserInroles("93") && !objda.checkUserInroles("95"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
                

                if (objda.validatedRoles("93", ds))
                {
                    ViewState["add"] = "1";
                }

                if (objda.validatedRoles("95", ds))
                {
                    ViewState["approve"] = "1";
                    AsssetTransfer_isapprove.Value = "1";

                    lbtnapprove.Visible = true;
                    lbtnreject.Visible = true;
                }
                else
                {
                    lbtnapprove.Visible = false;
                    lbtnreject.Visible = false;
                }
                txtfrom.Text = DateTime.Now.AddDays(-7).ToString("MM/dd/yyyy");
                txtto.Text = DateTime.Now.AddDays(1).ToString("MM/dd/yyyy");
                hidfromdate.Value = txtfrom.Text;
                hidtodate.Value = txtto.Text;
                //   fillCategory();
                filldepartment();
                fillgrid();

                fillemployee();
                fillVendor();
            }
        }
        #endregion

        #region "DataGridview Row Command Event"
        protected void dgnews_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "edititem")
            {
                blank();
                hidid.Value = e.CommandArgument.ToString();
                objAsset.nid = hidid.Value;
                //assetId = objAsset.nid;
                objAsset.companyId = Session["companyid"].ToString();
                objAsset.action = "select";
                ds = objAsset.trasferAssets();
                ddlasset.Disabled = true;
                hidasset.Value = ds.Tables[0].Rows[0]["assetid"].ToString();
                ddlasset.Value = ds.Tables[0].Rows[0]["asset"].ToString();
                hidtransfer_date.Value = ds.Tables[0].Rows[0]["preTransDate"].ToString();
                if (ds.Tables[0].Rows[0]["duedate1"].ToString() == "" && ds.Tables[0].Rows[0]["duedate1"] == null)
                {
                    txtDueDate.Text = "";
                }
                else
                {
                    txtDueDate.Text = ds.Tables[0].Rows[0]["duedate1"].ToString();
                }
                dropTransferTo.SelectedValue = ds.Tables[0].Rows[0]["transferTo"].ToString();

                if (ds.Tables[0].Rows[0]["transferTo"].ToString() == "Individual")
                {
                    employee_div_display.Style.Add("display", "block");
                    drop_employeName.Text = ds.Tables[0].Rows[0]["transferToID"].ToString();

                }
                else if (ds.Tables[0].Rows[0]["transferTo"].ToString() == "Repair")
                { vendor_div_display.Style.Add("display", "block"); drop_vendorName.Text = ds.Tables[0].Rows[0]["transferToID"].ToString(); }

                drop_departmentName.SelectedValue = ds.Tables[0].Rows[0]["deptid"].ToString();
                txt_Notes.Text = ds.Tables[0].Rows[0]["notes"].ToString();
                txt_TransferDate.Text = ds.Tables[0].Rows[0]["transferDate"].ToString();
                btnsubmit.Text = "Update";
                ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>opendiv();</script>", false);
                updatePanelAssign.Update();
            }

            if (e.CommandName == "del")
            {
                objAsset.nid = e.CommandArgument.ToString();
                objAsset.action = "delete";
                objAsset.trasferAssets();
                fillgrid();
            }
        }
        #endregion

        #region "DatagridView Row DataBound Event"
        protected void dgnews_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                if (DataBinder.Eval(e.Row.DataItem, "nid").ToString() == DataBinder.Eval(e.Row.DataItem, "transferid").ToString())
                {
                    ((LinkButton)e.Row.FindControl("lbtndelete")).Visible = true;
                    ((LinkButton)e.Row.FindControl("lbtnedit")).Visible = true;
                }

                Image imgloc = (Image)e.Row.FindControl("imgloc");

                string transferto = DataBinder.Eval(e.Row.DataItem, "transferto").ToString().ToLower();
                if (transferto == "individual")
                {
                    imgloc.ImageUrl = "/images/Emp.png";
                }
                else if (transferto == "store")
                {
                    imgloc.ImageUrl = "/images/Store.png";
                }
                else if (transferto == "repair")
                {
                    imgloc.ImageUrl = "/images/Repair.png";
                }
                else if (transferto == "stock")
                {
                    imgloc.ImageUrl = "/images/Stock.png";
                }
                else if (transferto == "inuse")
                {
                    imgloc.ImageUrl = "/images/use.png";
                }
                CheckBox chkRow = (e.Row.FindControl("chkapprovebox") as CheckBox);

                if (DataBinder.Eval(e.Row.DataItem, "approvestatus").ToString().ToLower() == "approved" || DataBinder.Eval(e.Row.DataItem, "approvestatus").ToString().ToLower() == "rejected")
                {
                    chkRow.Enabled = false;
                    chkRow.Checked = true;
                    ((HtmlGenericControl)e.Row.FindControl("divtaskstatus")).Attributes.Add("class", DataBinder.Eval(e.Row.DataItem, "approvestatus").ToString());
                    ((HtmlGenericControl)e.Row.FindControl("divtaskstatus")).Attributes.Add("title", DataBinder.Eval(e.Row.DataItem, "statusdetail").ToString());
                    if (AsssetTransfer_isapprove.Value != "1")
                    {
                        ((LinkButton)e.Row.FindControl("lbtndelete")).Visible = false;
                        ((LinkButton)e.Row.FindControl("lbtnedit")).Visible = false;
                    }
                }
                else
                {
                  
                    ((HtmlGenericControl)e.Row.FindControl("divtaskstatus")).Attributes.Add("class", "Submitted");
                   
                    chkRow.Enabled = true;
                }
                
                if (AsssetTransfer_isapprove.Value == "1")
                {

                    chkRow.Visible = true;
                    
                   
                }
                else
                {

                    chkRow.Visible = false;
                }


            }
        }
        #endregion

        #region "Search Buttton Click"
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            hidid.Value = "";
            hidfromdate.Value = txtfrom.Text;
            hidtodate.Value = txtto.Text;
            fillgrid();
        }
        #endregion

        #region Fill Grid of Asset Master
        protected void fillgrid()
        {
            objAsset.companyId = Session["companyid"].ToString();
            objAsset.department = DropSearchDepartment.Text;
            objAsset.name = txtSearchAsset.Text;

            objAsset.from = hidfromdate.Value;
            objAsset.to = hidtodate.Value;
        
            if (AsssetTransfer_isapprove.Value == "1")
                objAsset.transferBy = "";
            else
                objAsset.transferBy = Session["userid"].ToString();  
      
            objAsset.nid = "";
            objAsset.status = drostatus.SelectedValue;
            objAsset.action = "select";
            ds = objAsset.trasferAssets();
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
            updatePanelData.Update();
        }

        #endregion
        protected void setstatus(object sender, EventArgs e)
        {
            LinkButton btnstatus = (LinkButton)sender;

            bool ischkd = false;
            string status = btnstatus.Text;
            if (btnstatus.ID.ToString().ToLower() == "lbtnapprove")
            {
                status = "Approved";
            }
            else
            {
                status = "Rejected";
            }
            for (int i = 0; i < dgnews.Rows.Count; i++)
            {
                CheckBox chkapprove = (CheckBox)dgnews.Rows[i].FindControl("chkapprovebox");
                HtmlInputHidden hidactiviyid = (HtmlInputHidden)dgnews.Rows[i].FindControl("hidnid1");
                if (chkapprove.Enabled == true && chkapprove.Checked == true)
                {
                    ischkd = true;
                    objAsset.nid = hidactiviyid.Value;
                    objAsset.status = status;
                    objAsset.transferBy = Session["userid"].ToString();
                    objAsset.action = "approvettransfer";
                    objAsset.trasferAssets();
                }
            }
            if (!ischkd)
                ScriptManager.RegisterStartupScript(this, GetType(), "show", "<script>alert('Please select a row for approval.');</script>", false);
            else
                fillgrid();
        }

        protected void lbtnreject_Click(object sender, EventArgs e)
        {

        }
        protected void lnkprevious_Click(object sender, EventArgs e)
        {
            if (dgnews.PageIndex > 0)
            {
                dgnews.PageIndex = dgnews.PageIndex - 1;
                fillgrid();
            }
        }
        protected void lnknext_Click(object sender, EventArgs e)
        {
            if (int.Parse(lbltotalrecord.Text) > int.Parse(lblend.Text))
            {
                dgnews.PageIndex = dgnews.PageIndex + 1;
                fillgrid();
            }
        }

        #region fill vendor in dropdown
        private void fillVendor()
        {
            clsObject.companyId = Session["companyid"].ToString();
            clsObject.action = "selectVendor";
            ds = clsObject.ManageAsset();
            drop_vendorName.DataSource = ds;
            drop_vendorName.DataTextField = "VenderName";
            drop_vendorName.DataValueField = "nid";
            drop_vendorName.DataBind();

            ListItem li = new ListItem("--Select--", "");
            drop_vendorName.Items.Insert(0, li);
            drop_vendorName.SelectedIndex = 0;
        }
        #endregion

        #region fills the UI with empty space
        public void blank()
        {
            dropTransferTo.SelectedIndex = 0;
            txt_TransferDate.Text = string.Empty;
            drop_vendorName.SelectedIndex = 0;
            txtDueDate.Text = string.Empty;
            txt_Notes.Text = string.Empty;
            drop_employeName.SelectedIndex = 0;
            drop_departmentName.SelectedIndex = 0;
            ddlasset.Disabled = false;
            employee_div_display.Style.Add("display", "none");
            vendor_div_display.Style.Add("display", "none");
        }
        #endregion

        #region this  web service functon is cale from json when need to fetch the data corresponding to the entered text in asset search textbox
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getAllAsset(string prefixText, string companyid,string isapprove,string empid)
        {
            Cls_Asset objts = new Cls_Asset();
            DataSet ds1 = new DataSet();
            GeneralMethod objgen = new GeneralMethod();
            objts.name = "";
            if (isapprove == "1")
            {
                objts.nid = "";
                objts.action = "selectforautocompleter";
            }
            else
            {
                objts.action = "selectforautocompleterbuemp";
                objts.nid = empid;
            }
         
            objts.companyId = companyid;
           
            ds1 = objts.ManageAsset();
            string result = objgen.serilizeinJson(ds1.Tables[0]);
            return result;
        }
        #endregion

        #region this webservice function is called when we pass the id of selected asset to get the data corresponding to that asset row in DB
        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getAssetDetail(string nid)
        {
            StringBuilder sb = new StringBuilder();

            Cls_Asset objts = new Cls_Asset();
            DataSet ds = new DataSet();

            objts.action = "select";
            objts.nid = nid;
            ds = objts.ManageAsset();

            if (ds.Tables[0].Rows.Count > 0)
            {

                sb.Append(ds.Tables[0].Rows[0]["assetname"].ToString() + "###");
                sb.Append(ds.Tables[0].Rows[0]["assetCode"].ToString() + "###");
                sb.Append(ds.Tables[0].Rows[0]["categoryname"].ToString() + "###");
                sb.Append(ds.Tables[0].Rows[0]["Location"].ToString() + "###");
                sb.Append(ds.Tables[0].Rows[0]["transferedon"].ToString() + "###");
                sb.Append(ds.Tables[0].Rows[0]["transferid"].ToString() + "###");
                sb.Append(ds.Tables[0].Rows[0]["transferDate"].ToString() + "###");

            }
            return sb.ToString();
        }
        #endregion

        #region update department on emplyee selection
        protected void employee_selecetdIndexChanged(object sender, EventArgs e)
        {
            objuser.action = "select";
            objuser.companyid = Session["companyid"].ToString();
            objuser.id = drop_employeName.Text;
            ds = objuser.ManageEmployee();

            drop_departmentName.Enabled = false;
            drop_departmentName.Text = ds.Tables[0].Rows[0]["deptid"].ToString();

            updatePanelSearch.Update();
            /*
            Cls_Asset objts = new Cls_Asset();
            DataSet ds1 = new DataSet();
            GeneralMethod objgen = new GeneralMethod();
            objts.name = "";
            objts.action = "select";
            objts.companyId = Session["companyid"].ToString(); 
            objts.nid = drop_employeName.SelectedItem.Value;
            ds1 = objts.ManageGetDepartByEmployee();
            drop_departmentName.SelectedItem.Value = drop_employeName.SelectedItem.Value;
            */
        }
        #endregion

        #region"Fill All Employees"
        protected void fillemployee()
        {
            objuser.action = "select";
            objuser.companyid = Session["companyid"].ToString();
            objuser.id = "";
            ds = objuser.ManageEmployee();
            objgen.fillActiveInactiveDDL(ds.Tables[0], drop_employeName, "username", "nid");

            ListItem li = new ListItem("--Select Employee--", "");
            drop_employeName.Items.Insert(0, li);
            //dropemployee.Text = Session["userid"].ToString();
            drop_employeName.SelectedIndex = 0;

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
            drop_departmentName.DataSource = ds;
            drop_departmentName.DataTextField = "department";
            drop_departmentName.DataValueField = "nid";
            drop_departmentName.DataBind();
            ListItem li = new ListItem("--Select--", "");
            drop_departmentName.Items.Insert(0, li);
            drop_departmentName.SelectedIndex = 0;



            DropSearchDepartment.DataSource = ds;
            DropSearchDepartment.DataTextField = "department";
            DropSearchDepartment.DataValueField = "nid";
            DropSearchDepartment.DataBind();
            ListItem li1 = new ListItem("--All Department--", "");
            DropSearchDepartment.Items.Insert(0, li1);
            DropSearchDepartment.SelectedIndex = 0;
        }
        #endregion

        #region button reset click
        protected void btnbtnReset_Click(object sender, EventArgs e)
        {
            clsObject.nid = hidid.Value;
            blank();
            GeneralMethod.alert(this.Page, "Reseted Successfully!");
        }
        #endregion

        #region save button submit
        protected void btnsubmit_Click(object sender, EventArgs e)
        {

            clsObject.nid = hidid.Value;
            if (hidid.Value != "")
                clsObject.action = "insert";
            else
            {
                if (AsssetTransfer_isapprove.Value == "1")
                {
                    clsObject.action = "insert";
                }
                else
                {
                    clsObject.action = "insertrequest";
                }

            }
            //if (Convert.ToDateTime(hidtransfer_date.Value) > Convert.ToDateTime(txt_TransferDate.Text)) {
            //    GeneralMethod.alert(this.Page, "You cannot transfer befor last transere date !");
            //    return;
            //}
            clsObject.AssetId = hidasset.Value;

            clsObject.cLocationId = hidlocationid.Value;
            clsObject.transferTo = dropTransferTo.SelectedValue;
            clsObject.transferBy = Session["userid"].ToString();
            clsObject.transferDate = txt_TransferDate.Text;
            if (string.IsNullOrEmpty(txtDueDate.Text)) {

               // clsObject.dueDate = DBNull.Value.ToString();
            }
            else { 

            clsObject.dueDate = txtDueDate.Text;
            }
            clsObject.Notes = txt_Notes.Text;
            clsObject.recType = "transfer";
            clsObject.department = drop_departmentName.Text;

            /*The switch statement below fills in the selected dropdown value in the tranferToID variable of clsObject*/
            switch (dropTransferTo.SelectedValue)
            {
                case "Individual":
                    {
                        clsObject.transferToID = drop_employeName.Text;
                        break;
                    }
                case "Repair":
                    {
                        clsObject.transferToID = drop_vendorName.Text; break;
                    }
                default: { clsObject.transferToID = ""; break; }

            }
            clsObject.companyId = Session["companyid"].ToString();
            clsObject.trasferAssets();
            blank();
            fillgrid();
            GeneralMethod.alert(this.Page, "Saved Successfully!");
        }
        #endregion

        #region "DataGridView PageIndex Changing Event"
        protected void dgnews_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            dgnews.PageIndex = e.NewPageIndex;
            fillgrid();
        }
        #endregion

        #region "Button Refresh Click Event"
        protected void btnrefresh_Click(object sender, EventArgs e)
        {
            fillgrid();
        }
        #endregion

        #region Export
        protected string bindheader(string type)
        {
            string str = "";
            string Companyname = objda.GetCompanyProperty("CompanyName");
            string companyaddress = Session["companyaddress"].ToString();

            string headerstr = "<table width='100%'>";
            if (type == "excel")
            {
                headerstr = "<table width='100%'>";

            }

            str = headerstr +
        @"<tr>
            <td colspan='6' align='center'>
                <h2>
                   " + Companyname + @"
                </h2>
            </td>
        </tr>
<tr>
            <td colspan='6' align='left'>
                <h4>
                   " + companyaddress + @"
                </h4>
            </td>
        </tr>
        <tr>
            <td colspan='6' align='center'>
                <h4>
                    Asset Transfer Report
                </h4>
            </td>
        </tr>
        <tr>
            <td colspan='6'>
                &nbsp;
            </td>
        </tr>
       
        <tr>
        <td colspan='6'>
        </td>

        </tr>
       <tr>
        <td colspan='11'>&nbsp;</td></tr>
       </table><table width='100%' cellpadding='5' cellspacing='0' style='font-family: Calibri;   font-size: 12px; text-align: left;' border='0'>
                       
                         
  <tr style='font-weight: bold; background: #395ba4; color: #ffffff;'>
 <td>S.No.</td>
 <td>Transfer Date</td>
<td>Asset Code</td>
 <td>Asset Name</td>
 <td>Current Location</td>
 <td>Department</td>                                                          
</tr>";
            return str;


        }
        protected void btnexportcsv_Click(object sender, EventArgs e)
        {

            fillgrid();
            string rpthtml = bindheader("excel");
            for (int i = 0; i < dsexcel.Tables[0].Rows.Count; i++)
            {

                rpthtml = rpthtml + "<tr><td>" + Convert.ToString(i + 1) + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["transferDate"].ToString() + "</td>"
                + "<td>" + dsexcel.Tables[0].Rows[i]["assetcode"].ToString() + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["assetname"].ToString() +
               "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["location"].ToString() + "</td>" + "<td>" + dsexcel.Tables[0].Rows[i]["departmentname"].ToString() + "</td>"
                + "</td></tr>";
            }

            HtmlGenericControl divgen = new HtmlGenericControl();

            divgen.InnerHtml = rpthtml;
            HttpResponse response = HttpContext.Current.Response;

            // first let's clean up the response.object   
            response.Clear();
            response.Charset = "";

            // set the response mime type for excel   
            response.ContentType = "application/vnd.ms-excel";
            response.AddHeader("Content-Disposition", "attachment;filename=\"AssetTransferReport.xls\"");

            // create a string writer   
            using (StringWriter sw = new StringWriter())
            {
                using (HtmlTextWriter htw = new HtmlTextWriter(sw))
                {
                    System.Web.UI.HtmlControls.HtmlGenericControl dv = new System.Web.UI.HtmlControls.HtmlGenericControl();
                    dv.InnerHtml = divgen.InnerHtml.Replace("border='0'", "border='1'");
                    //dv.InnerHtml = dv.InnerHtml.Replace("<tr><td colspan='6'><hr style='width:100%;' /></td>", "");

                    dv.RenderControl(htw);
                    response.Write(sw.ToString());
                    response.End();
                }
            }


        }
        #endregion

    }
}