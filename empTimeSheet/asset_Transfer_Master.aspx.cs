using empTimeSheet.DataClasses.DAL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Text;

namespace empTimeSheet
{

    public partial class asset_Transfer_Master : System.Web.UI.Page
    {
        #region member variables
        static string assetId = string.Empty;
        static string cLocation = string.Empty;
        static string cLocationId = string.Empty;
        static string currentLocation = string.Empty;
        #endregion


        #region class instantiation
        public Cls_Asset clsObject = new Cls_Asset();
        GeneralMethod objgen = new GeneralMethod();
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        public DataSet ds = new DataSet();
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                filldepartment();
                fillemployee();
                fillVendor();
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
        }
        #endregion

        #region this  web service functon is cale from json when need to fetch the data corresponding to the entered text in asset search textbox
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getAllAsset(string prefixText, string companyid)
        {
            Cls_Asset objts = new Cls_Asset();
            DataSet ds1 = new DataSet();
            GeneralMethod objgen = new GeneralMethod();
            objts.name = "";
            objts.action = "selectforautocompleter";
            objts.companyId = companyid;
            objts.nid = "";
            ds1 = objts.ManageAsset();
            string result = objgen.serilizeinJson(ds1.Tables[0]);
            return result;
        }
        #endregion


        #region this webservice function is called when we pass the id of selected asset to get the data corresponding to that asset row in DB
        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getAllAssetData(string nid)
        {
            StringBuilder sb = new StringBuilder();
            assetId = nid;
            Cls_Asset objts = new Cls_Asset();
            DataSet ds = new DataSet();

            objts.action = "select";
            objts.nid = nid;
            ds = objts.ManageAsset();

            if (ds.Tables[0].Rows.Count > 0)
            {
                currentLocation = ds.Tables[0].Rows[0]["currentLocation"].ToString();
                sb.Append(ds.Tables[0].Rows[0]["assetname"].ToString() + "###");
                sb.Append(ds.Tables[0].Rows[0]["assetCode"].ToString() + "###");
                sb.Append(ds.Tables[0].Rows[0]["categoryname"].ToString() + "###");
                sb.Append(ds.Tables[0].Rows[0]["currentLocation"].ToString() + "###");
                sb.Append(ds.Tables[0].Rows[0]["creationdate"].ToString() + "###");

            }
            return sb.ToString();
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

            ListItem li = new ListItem("--All Employees--", "");
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

            clsObject.nid = "";
            clsObject.action = "insert";
            clsObject.AssetId = assetId;
            clsObject.cLocation = cLocation;
            clsObject.cLocationId = cLocationId;
            clsObject.transferTo = dropTransferTo.SelectedValue;
            clsObject.transferBy = Session["userid"].ToString();
            clsObject.transferDate = txt_TransferDate.Text;
            clsObject.dueDate = txtDueDate.Text;
            clsObject.Notes = txt_Notes.Text;
   
            /*The switch statement below fills in the selected dropdown value in the tranferToID variable of clsObject*/
            switch (dropTransferTo.SelectedValue)
            {
                case "Individual":
                    {
                        clsObject.transferToID = drop_departmentName.SelectedValue;
                        break;
                    }
                case "Repair":
                    {
                        clsObject.transferToID = drop_vendorName.SelectedValue; break;
                    }
                case "Stock":
                    {
                        clsObject.transferToID = dropTransferTo.SelectedValue;
                        break;
                    }
                case "Store":
                    {
                        clsObject.transferToID = dropTransferTo.SelectedValue;
                        break;
                    }
                case "Inuse":
                    {
                        clsObject.transferToID = dropTransferTo.SelectedValue;
                        break;
                    }
                default: { Console.WriteLine("check if data select in drop_transferTo combo is correct"); break; }

            }
            clsObject.companyId = Session["companyid"].ToString();
            clsObject.trasferAssets();
            blank();
            GeneralMethod.alert(this.Page, "Saved Successfully!");
        }
        #endregion
    }
}
