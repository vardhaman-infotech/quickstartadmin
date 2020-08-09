using empTimeSheet.DataClasses.DAL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace empTimeSheet
{
    public partial class Asset_ItemCategory : System.Web.UI.Page
    {
        #region "Global Variable Declaration"
        Cls_Asset objda = new Cls_Asset();
        DataSet ds = new DataSet();
        GeneralMethod objgen = new GeneralMethod();
        ClsUser objuser = new ClsUser();
        DataAccess objdac = new DataAccess();
        #endregion

        #region "Page Load Event"
        protected void Page_Load(object sender, EventArgs e)
        {
            txtdes.Attributes.Add("maxlength", "40");
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {

                if (!objdac.checkUserInroles("91"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }

                btndelete.Visible = false;
                liaddnew.Visible = false;
                //   filleml();
                fillgrid();
                fillCategory();

            }
        }
        #endregion
     
        #region "save category in database"
        protected void btnsubmit_Click(object sender, EventArgs e)
        {
            objda.nid = hidid.Value;
            objda.companyId = Session["companyid"].ToString();
            objda.action = "checkexist";

            objda.CategoryID = txtcode.Text;
            objda.CategoryName = txtname.Text;

            ds = objda.AssetCategory();
            if (ds.Tables[0].Rows.Count > 0)
            {
                GeneralMethod.alert(this.Page, "Category Code already exists!");
                return;
            }
            objda.action = "insert";
            objda.nid = hidid.Value;
            objda.CategoryID = txtcode.Text;
            objda.CategoryName = txtname.Text;
            objda.CategoryDesc = txtdes.Text;
            objda.ParentId = "";

            ds = objda.AssetCategory();
            fillCategory();
            fillgrid();
            blank();

            GeneralMethod.alert(this.Page, "Saved Successfully!");
        }
        #endregion

        #region "fill parent category dropdown"
        public void fillCategory()
        {
            //objda.nid = "";
            //objda.action = "select";
            //objda.companyId = Session["companyid"].ToString();
            //objda.CategoryName = "";
           
            //ds = objda.AssetCategory();
            //AddTopMenuItems(ds.Tables[0]);
            //TreeView1.CollapseAll();
            

        }

        //private void AddTopMenuItems(DataTable menuData)
        //{
        //    try
        //    {
        //        DataView view = new DataView(menuData);
        //        view.RowFilter = "parentid=''";
        //        //TreeNode root = new TreeNode("Classfications", 0, 0);
        //        //tvClassification.Nodes.Add(root);
        //        //root.Checked = true;
        //        TreeNode nonenode = new TreeNode("&lt;None&gt", "0");
        //        nonenode.Selected = true;
        //        TreeView1.Nodes.Add(nonenode);


        //        foreach (DataRowView row in view)
        //        {
        //            TreeNode parentNode = new TreeNode(row["categoryname"].ToString(), row["nid"].ToString());

        //            TreeView1.Nodes.Add(parentNode);

        //            if (menuData.Rows.Count > 0)
        //            {
        //                AddChildMenuItem(menuData, parentNode, Convert.ToInt32(row["nid"].ToString()));
        //            }

        //        }
        //    }
        //    catch (Exception ex)
        //    {
               

        //    }

        //}

        //private void AddChildMenuItem(DataTable menuData, TreeNode parentNode, int ParentID)
        //{
        //    try
        //    {
        //        DataView view = new DataView(menuData);
        //        view.RowFilter = "parentId='" + ParentID + "'";
        //        foreach (DataRowView row in view)
        //        {

        //            TreeNode node = new TreeNode(row["categoryname"].ToString(), row["nid"].ToString());
        //            parentNode.ChildNodes.Add(node);
                   

        //            AddChildMenuItem(menuData, node, Convert.ToInt32(row["nid"].ToString()));

        //        }

        //    }
        //    catch (Exception ex)
        //    {
              
        //    }
        //}


   

        #endregion

        #region "Button Search Click Event"
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            fillgrid();
        }
        #endregion

        #region "Repeater dgnews fill"
        private void fillgrid()
        {
            objda.nid = "";
            objda.action = "select";
            objda.companyId = Session["companyid"].ToString();
            objda.CategoryName = txtsearch.Text;
            ds = objda.AssetCategory();
            if (ds.Tables[0].Rows.Count > 0)
            {
                dgnews.DataSource = ds;
                dgnews.DataBind();
                dgnews.Visible = true;
                nodata.Visible = false;
            }
            else
            {
                dgnews.Visible = false;
                nodata.Visible = true;
            }

        }
        #endregion

        #region "Blank All Controls"
        private void blank()
        {
            enableUIs();
            txtcode.Text = string.Empty;
            txtdes.Text = string.Empty;
            txtname.Text = string.Empty;
            hidid.Value = "";
            btndelete.Visible = false;
            liaddnew.Visible = false;
            btnsubmit.Text = "Submit";
           

            //node.Selected = true;
        }
        #endregion

        #region "Delete category from database"
        protected void btndelete_Click(object sender, EventArgs e)
        {
            try {
                objda.action = "delete";
                objda.nid = hidid.Value;
                ds = objda.AssetCategory();

                fillCategory();
                fillgrid();
                blank();
                if (ds.Tables[0].Rows[0][0].ToString() == "1")
                { 
                GeneralMethod.alert(this.Page, "Deleted Successfully!");
            }else
                {
                    GeneralMethod.alert(this.Page, "Category is Exists in Category Master cannot delete this record!");
                }
            }
            catch(Exception ex) { }
        }
        #endregion

        #region "Row Commant Event of Repeater"
        protected void dgnews_RowCommand(object sender, RepeaterCommandEventArgs e)
        {

            if (e.CommandName.ToLower() == "detail")
            {
                hidid.Value = e.CommandArgument.ToString();
                objda.nid = e.CommandArgument.ToString();
                objda.action = "select";
                objda.CategoryName = "";

                ds = objda.AssetCategory();

                txtcode.Text = ds.Tables[0].Rows[0]["categorycode"].ToString();
                txtname.Text = ds.Tables[0].Rows[0]["categoryname"].ToString();
                txtdes.Text = ds.Tables[0].Rows[0]["categorydesc"].ToString();
                //dropparentID.Text = ds.Tables[0].Rows[0]["parentid"].ToString();
                btnsubmit.Text = "Update";
                btndelete.Visible = true;
                liaddnew.Visible = true;
            }
        }
        #endregion

        #region "Disable Controls"
        private void disableUIs()
        {
            txtcode.Enabled = false;
            txtname.Enabled = false;
            txtdes.Enabled = false;
           // dropparentID.Enabled = false;
        }
        #endregion

        #region "Enable Controls"
        private void enableUIs()
        {
            txtcode.Enabled = true;
            txtname.Enabled = true;
            txtdes.Enabled = true;
           // dropparentID.Enabled = true;
        }
        #endregion

        #region "Link Button Add New Click Event"
        protected void liaddnew_Click(object sender, EventArgs e)
        {
            blank();
        }
        #endregion
    }
}