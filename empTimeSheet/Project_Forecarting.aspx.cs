using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace empTimeSheet
{
    public partial class Project_Forecarting : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds1 = new DataSet();
        DataSet ds = new DataSet();
      
        string selected = "",projectid="";
        protected static TreeNode lastexpandednode = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            txtdescription.Attributes.Add("maxlength", "500");
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                if (!objda.checkUserInroles("23"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
                multiview1.ActiveViewIndex = 0;
              
                filltasks();
                fillproject();
              //  fillmenu();



            }

        }


        protected void treeview_SelectedNodeChanged(object sender, EventArgs e)
        {
            //ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>findtree();</script>", false);
            //blank();

            //settext();


        }


        /// <summary>
        /// Fill tasks drop down for searching
        /// </summary>
        protected void filltasks()
        {
            objts.name = "";
            objts.action = "select";
            objts.companyId = Session["companyid"].ToString();
            objts.nid = "";
            //objts.type = "Task";

            objts.deptID = "";
            ds = objts.ManageTasks();

            droptask.DataSource = ds;
            droptask.DataTextField = "taskcodename";
            droptask.DataValueField = "nid";
            droptask.DataBind();

            ListItem li = new ListItem("", "");
            droptask.Items.Insert(0, li);
        }
        /// <summary>
        /// Fill Projects drop down for seraching
        /// </summary>
        protected void fillproject()
        {
            dropproject.Items.Clear();
            objts.name = "";
            objts.action = "selectbyclient";
            objts.clientid = "";
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

            ListItem li = new ListItem("--Select--", "");
            dropproject.Items.Insert(0, li);

        }

        public void fillmenu()
        {
            selected = hidselected.Value;

            objts.action = "selectLinkModule";
            objts.nid = dropproject.Text;
            //objts.nid = "";
            ds = objts.Manageprojectmodule();
            treemenu.Nodes.Clear();
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                projectid = ds.Tables[0].Rows[i]["nid"].ToString();
                TreeNode root = new TreeNode(ds.Tables[0].Rows[i]["projectCode"].ToString(), ds.Tables[0].Rows[i]["nid"].ToString() + "#" + "project");
                root.NavigateUrl = "#" + ds.Tables[0].Rows[i]["nid"].ToString() + "#" + "project";
                root.SelectAction = TreeNodeSelectAction.SelectExpand;
                root.ToolTip = ds.Tables[0].Rows[i]["projectCode"].ToString();
                createfirstnode(root, ds.Tables[1], ds.Tables[0].Rows[i]["nid"].ToString());
                treemenu.Nodes.Add(root);
                root.Expand();


            }

            if (lastexpandednode != null)
            {
                foreach (TreeNode n in treemenu.Nodes)
                {
                    if (n.Text == lastexpandednode.Text)
                    {
                        n.Expand();
                        break;
                    }
                }

            }
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>findtree();</script>", false);

        }
        public void createfirstnode(TreeNode node, DataTable Dt, string projectid)
        {
            DataRow[] Rows = Dt.Select("parentid ='0' AND  projectid = '" + projectid + "'");
            if (Rows.Length == 0) { return; }


            for (int i = 0; i < Rows.Length; i++)
            {
                TreeNode Childnode = new TreeNode(Rows[i]["title"].ToString(), Rows[i]["projectid"].ToString() + "#Module#" + Rows[i]["nid"].ToString());
                Childnode.NavigateUrl = "#" + Rows[i]["projectid"].ToString() + "#Module#" + Rows[i]["nid"].ToString() + "#MainTask#" + Rows[i]["maintaskid"].ToString();
                Childnode.SelectAction = TreeNodeSelectAction.SelectExpand;
                Childnode.ToolTip = Rows[i]["title"].ToString();
                // node.Expand();
                node.Expanded = false;
                node.ChildNodes.Add(Childnode);
                if (selected != "")
                {

                    if (selected == Childnode.Text)
                    {
                        Childnode.ExpandAll();
                    }
                }

                CreateNode(Childnode, Dt, Rows[i]["nid"].ToString());

            }

        }
        public void CreateNode(TreeNode node, DataTable Dt, string parentid)
        {
            DataRow[] Rows = Dt.Select("parentid ='" + parentid + "'");
            if (Rows.Length == 0) { return; }
            for (int i = 0; i < Rows.Length; i++)
            {
                TreeNode Childnode = new TreeNode(Rows[i]["title"].ToString(), Rows[i]["nid"].ToString() + "#Module#" + Rows[i]["projectid"].ToString());
                Childnode.NavigateUrl = "#" + Rows[i]["projectid"].ToString() + "#Module#" + Rows[i]["nid"].ToString() + "#MainTask#" + Rows[i]["maintaskid"].ToString();
                Childnode.SelectAction = TreeNodeSelectAction.SelectExpand;
                Childnode.ToolTip = Rows[i]["title"].ToString();

                //node.Expand();
                node.ChildNodes.Add(Childnode);

                if (selected != "")
                {

                    if (selected == Childnode.Text)
                    {
                        Childnode.ExpandAll();
                    }
                }
                CreateNode(Childnode, Dt, Rows[i]["nid"].ToString());
            }
        }
        protected void btnsave_Click(object sender, EventArgs e)
        {
            save();
            blank();



        }
        protected void btnback_Click(object sender, EventArgs e)
        {
            multiview1.ActiveViewIndex = 0;
        }
        public void save()
        {
            string[] str = hidselectednode.Value.Split('#');


            if (hidparent.Value == "")
            {
                objts.parentid = "0";

                objts.projectid = hidproject.Value;
            }
            else
            {
                objts.parentid = hidparent.Value;
                objts.projectid = hidproject.Value;
            }
            objts.nid = hidid.Value;
            objts.maintaskid = droptask.Text;
            objts.title = txttitle.Text;
            //if (droptask.Text == "")
            //{
            objts.eststartdate = txtstartdate.Text;
            objts.enddate = txtenddate.Text;
            objts.hours = txtesthrs.Text;
            if (txtcomplete.Text != "")
                objts.completePercent = txtcomplete.Text;
            else
                objts.completePercent = "0";
            //}
            //else
            //{
            //    objts.eststartdate = "";
            //    objts.enddate = "";
            //    objts.hours = "";
            //    objts.completePercent = "";
            //}

            objts.description = txtdescription.Text;

            objts.CreatedBy = Session["userid"].ToString();
            objts.companyId = Session["companyid"].ToString();
            objts.action = "insertprojectmodule";
            objts.Manageprojectmodule();
            fillmenu();

            ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>fillproject('ctl00_ContentPlaceHolder1_treemenut0','#" + projectid + "#project');</script>", false);



        }


        //Delete a menu
        protected void btndelete_Click(object sender, EventArgs e)
        {

            string[] str = hidselectednode.Value.Split('#');
            objts.nid = str[3];
            {
                objts.action = "deleteproject";
                objts.Manageprojectmodule();
            }
            blank();
            fillmenu();

        }
        public void blank()
        {
            hidid.Value = "";
            txttitle.Text = "";
            droptask.SelectedIndex = 0;

            txtesthrs.Text = "";
            txtdescription.Text = "";
            txtstartdate.Text = "";
            txtcomplete.Text = "";


        }
        protected void dropproject_SelectedIndexChanged(object sender, EventArgs e)
        {

          

        }
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            fillmenu();
            multiview1.ActiveViewIndex = 1;
            inv_projectname.InnerHtml = dropproject.SelectedItem.Text;
            ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>fillproject('ctl00_ContentPlaceHolder1_treemenut0','#" + projectid + "#project');</script>", false);

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]

        public static string getdetail(string selectedval)
        {

            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();
            string[] str = selectedval.Split('#');
            //objts.parentid = str[3];

            if (str.Length == 3)
            {
                objts.nid = "";
            }
            else
            {
                objts.nid = str[3];

            }
            string msg = "";
            msg = "failure";
            objts.action = "selectlink";
            try
            {
                ds = objts.Manageprojectmodule();
                msg = ds.Tables[0].Rows[0]["maintaskid"].ToString() + "###" + ds.Tables[0].Rows[0]["title"].ToString() + "###" + ds.Tables[0].Rows[0]["eststartdate"].ToString() + "###" +
                    ds.Tables[0].Rows[0]["esthours"].ToString() + "###" + ds.Tables[0].Rows[0]["description"].ToString() + "###" + ds.Tables[0].Rows[0]["percomplete"].ToString() + "###" + ds.Tables[0].Rows[0]["projectid"].ToString() + "###" + ds.Tables[0].Rows[0]["estenddate"].ToString() + "###" + ds.Tables[0].Rows[0]["chieldcount"].ToString();
                return msg;
            }
            catch (Exception ex)
            {

                return msg;
            }

        }
    }


}