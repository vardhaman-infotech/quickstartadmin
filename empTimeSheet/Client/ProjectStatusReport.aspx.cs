using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Web.UI.HtmlControls;
using System.IO;
using System.Data;

namespace empTimeSheet.Client
{
    public partial class ProjectStatusReport : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();
        DataSet dsexcel = new DataSet();
        int index = 0;
        protected static TreeNode lastexpandednode = null;
        protected void Page_Load(object sender, EventArgs e)
        {

            objgen.validateClientlogin();

            if (!IsPostBack)
            {
                fillproject();
                if (Request.QueryString["projectid"] != null)
                {
                    dropproject.Text = Request.QueryString["projectid"].ToString();
                }
                fillmenu();
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
            objts.clientid = Session["clientloginid"].ToString();
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

        protected void btnsearch_Click(object sender, EventArgs e)
        {
            fillmenu();
        }

        public void fillmenu()
        {
            objts.action = "selectClientLinkModuleallocation";
            objts.nid = dropproject.Text;
            objts.clientid = Session["clientloginid"].ToString();
            objts.companyId = Session["companyid"].ToString();
            //objts.nid = "";
            ds = objts.Manageprojectmodule();
            if (ds.Tables[0].Rows.Count > 0)
            {
                divmsg.Visible = false;
            }
            else
                divmsg.Visible = true;
            treemenu.Nodes.Clear();
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                TreeNode root = new TreeNode( ds.Tables[0].Rows[i]["projectCode"].ToString() + " (" + ds.Tables[0].Rows[i]["percomplete"].ToString() + "%)", ds.Tables[0].Rows[i]["nid"].ToString() + "#" + "project");
                // root.NavigateUrl = "#" + ds.Tables[0].Rows[i]["nid"].ToString() + "#" + "project";
                root.SelectAction = TreeNodeSelectAction.SelectExpand;
                root.ToolTip = ds.Tables[0].Rows[i]["projectCode"].ToString();
                createfirstnode(root, ds.Tables[1], ds.Tables[0].Rows[i]["nid"].ToString());
                treemenu.Nodes.Add(root);



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


        }
        public void createfirstnode(TreeNode node, DataTable Dt, string projectid)
        {
            DataRow[] Rows = Dt.Select("parentid ='0' AND  projectid = '" + projectid + "'");
            if (Rows.Length == 0) { return; }


            for (int i = 0; i < Rows.Length; i++)
            {
                TreeNode Childnode = new TreeNode( Rows[i]["title"].ToString() +  "<span class='spanpercentage'> (" + Rows[i]["completionpercentage"].ToString() + "%)</span>", Rows[i]["projectid"].ToString() + "#Module#" + Rows[i]["nid"].ToString());
                // Childnode.NavigateUrl = "#" + Rows[i]["projectid"].ToString() + "#Module#" + Rows[i]["nid"].ToString() + "#MainTask#" + Rows[i]["maintaskid"].ToString();
                Childnode.SelectAction = TreeNodeSelectAction.SelectExpand;
                Childnode.ToolTip = Rows[i]["title"].ToString();
                // node.Expand();
                node.Expanded = false;
                node.ChildNodes.Add(Childnode);


                CreateNode(Childnode, Dt, Rows[i]["nid"].ToString());

            }

        }
        public void CreateNode(TreeNode node, DataTable Dt, string parentid)
        {
            DataRow[] Rows = Dt.Select("parentid ='" + parentid + "'");
            if (Rows.Length == 0) { return; }
            for (int i = 0; i < Rows.Length; i++)
            {
                TreeNode Childnode = new TreeNode(Rows[i]["title"].ToString() + " <span class='spanpercentage'> (" + Rows[i]["completionpercentage"].ToString() + "%)</span>", Rows[i]["projectid"].ToString() + "#Module#" + Rows[i]["nid"].ToString());
                // Childnode.NavigateUrl = "#" + Rows[i]["projectid"].ToString() + "#Module#" + Rows[i]["nid"].ToString() + "#MainTask#" + Rows[i]["maintaskid"].ToString();
                Childnode.SelectAction = TreeNodeSelectAction.SelectExpand;
                Childnode.ToolTip = Rows[i]["title"].ToString();

                //node.Expand();
                node.ChildNodes.Add(Childnode);

                node.Expanded = false;
                CreateNode(Childnode, Dt, Rows[i]["nid"].ToString());
            }
        }



        protected void btnexportcsv_Click(object sender, EventArgs e)
        {
            //convertTreeViewToDataSet();
           // converttoexl();
            string csvData = "";
            string str = "";
             string Companyname = Session["clientcompanyname"].ToString();

           
            string project = "<b>Project:</b> ";
            if (dropproject.Text == "")
            {
                project += "All";
            }
            else
            {
                project += dropproject.SelectedItem.Text;
            }

            str = Companyname + "\n" + "Project Status Report\n\n";
      

            BuildCSV(treemenu.Nodes, ref csvData, 0);
            str = str + csvData;

            HttpResponse response = HttpContext.Current.Response;

            // first let's clean up the response.object   
            response.Clear();
            response.Charset = "";

            // set the response mime type for excel   
            response.ContentType = "application/vnd.ms-excel";
            response.AddHeader("Content-Disposition", "attachment;filename=\"ProjectStatusReport.csv\"");

            // create a string writer   
            using (StringWriter sw = new StringWriter())
            {
                using (HtmlTextWriter htw = new HtmlTextWriter(sw))
                {

                    response.Write(str);
                    response.End();
                }
            }

          
        }
    

        private void BuildCSV(TreeNodeCollection nodes, ref string csvData, int depth)
        {
            foreach (TreeNode node in nodes)
            {
                string nodetext = node.Text.Replace("<span class='spanpercentage'>", "");
                nodetext = nodetext.Replace("</span>", "");
                csvData = csvData + new String(',', depth) + nodetext + "\n";

                if (node.ChildNodes.Count > 0)
                    BuildCSV(node.ChildNodes, ref csvData, depth + 1);
            }

        }

 
    }
}