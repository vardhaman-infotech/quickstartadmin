using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Data;
using System.Web.Services;
using System.Web.Script.Services;
using System.IO;

namespace empTimeSheet
{
    public partial class ProjectAllocation : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds1 = new DataSet();
        DataSet ds = new DataSet();
        DataSet dsexcel = new DataSet();
        int index = 0;
        protected static TreeNode lastexpandednode = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                if (!objda.checkUserInroles("24"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
                
                allcation_empid.Value = Session["userid"].ToString();
                objda.id = Session["userid"].ToString();
                ds = objda.getUserInRoles();

                if (!objda.validatedRoles("24", ds))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
                if (objda.validatedRoles("24", ds))
                {
                    ViewState["add"] = "1";
                }
                else
                {
                    // liaddnew.Visible = false;
                    ViewState["add"] = null;
                }

                //Check whether logged user have right for view Other's assigned tasks or not
                if (objda.validatedRoles("15", ds))
                {
                    ViewState["isadmin"] = "1";
                }
                else
                {
                    ViewState["isadmin"] = null;
                }

                txtdate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");


                filladdemployee();
                fillmanager();
                fillproject();
                fillmenu();

                divmsg.Visible = false;

            }

        }
        /// <summary>
        /// Fill Projects drop down for seraching
        /// </summary>
        protected void fillproject()
        {
            objts.name = "";
            objts.action = "getproject";
            objts.clientid = "";
            objts.companyId = Session["companyid"].ToString();
            objts.nid = "";
            ds = objts.rpt_ProjectAllocation();
            if (ds.Tables[0].Rows.Count > 0)
            {
                dropproject.DataSource = ds;
                dropproject.DataTextField = "projectcodename";
                dropproject.DataValueField = "projectid";
                dropproject.DataBind();
            }


            ListItem li = new ListItem("--All Projects--", "");
            dropproject.Items.Insert(0, li);

        }
        protected void treeview_SelectedNodeChanged(object sender, EventArgs e)
        {

            fillgrid();

        }
        public void fillmenu()
        {
            objts.action = "selectLinkModuleAllocation";
            objts.nid = dropproject.Text;
            //objts.nid = "";
            ds = objts.Manageprojectmodule();
            treemenu.Nodes.Clear();
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                TreeNode root = new TreeNode(ds.Tables[0].Rows[i]["projectCode"].ToString(), ds.Tables[0].Rows[i]["nid"].ToString() + "#" + "project");
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
                TreeNode Childnode = new TreeNode(Rows[i]["title"].ToString(), Rows[i]["projectid"].ToString() + "#Module#" + Rows[i]["nid"].ToString());
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
                TreeNode Childnode = new TreeNode(Rows[i]["title"].ToString(), Rows[i]["projectid"].ToString() + "#Module#" + Rows[i]["nid"].ToString());
                // Childnode.NavigateUrl = "#" + Rows[i]["projectid"].ToString() + "#Module#" + Rows[i]["nid"].ToString() + "#MainTask#" + Rows[i]["maintaskid"].ToString();
                Childnode.SelectAction = TreeNodeSelectAction.SelectExpand;
                Childnode.ToolTip = Rows[i]["title"].ToString();

                //node.Expand();
                node.ChildNodes.Add(Childnode);

                node.Expanded = false;
                CreateNode(Childnode, Dt, Rows[i]["nid"].ToString());
            }
        }

        protected void fillmanager()
        {

            dropopmanager.Items.Clear();
            if (ViewState["add"] != null && ViewState["add"].ToString() == "1" && ViewState["isadmin"] == null)
            {
                ListItem li2 = new ListItem(Session["username"].ToString(), Session["userid"].ToString());

                dropopmanager.Items.Insert(0, li2);
                dropopmanager.SelectedIndex = 0;
                return;
            }

            //This action selects the employee according to Roles id "7", if you chnage the roles please change in Stored Procedure too.
            objuser.action = "selectassignmanager";
            objuser.companyid = Session["companyid"].ToString();
            objuser.id = "";
            objuser.activestatus = "active";
            ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0)
            {

                //dropopmanager.DataSource = ds;
                //dropopmanager.DataTextField = "username";
                //dropopmanager.DataValueField = "nid";
                //dropopmanager.DataBind();
                objgen.fillActiveInactiveDDL(ds.Tables[0], dropopmanager, "username", "nid");

            }


            ListItem li1 = new ListItem("--Select Manager--", "");
            dropopmanager.Items.Insert(0, li1);


        }



        /// <summary>
        /// Fill Employee to select for those logged in user is a Manager
        /// </summary>
        protected void filladdemployee()
        {
            if (objda.checkUserInroles("24"))
            {
                objuser.action = "selectactive";
                objuser.companyid = Session["companyid"].ToString();
                objuser.id = "";
                ds = objuser.ManageEmployee();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    droppopemployee.DataSource = ds;
                    droppopemployee.DataTextField = "username";
                    droppopemployee.DataValueField = "nid";
                    droppopemployee.DataBind();

                }

                droppopemployee.Text = Session["userid"].ToString();
            }
            else
            {
                ListItem li = new ListItem(Session["username"].ToString(), Session["userid"].ToString());
                droppopemployee.Items.Insert(0, li);
                droppopemployee.SelectedIndex = 0;
            }

        }


        protected void dropproject_SelectedIndexChanged(object sender, EventArgs e)
        {
            fillmenu();
        }


        protected void fillgrid()
        {

            objts.action = "selectforallocation";
            string[] str = treemenu.SelectedNode.Value.Split('#');
            if (str.Length == 3)
            {
                objts.projectid = str[0];
                objts.nid = str[2];
            }
            else
            {
                objts.projectid = str[0];
                objts.nid = "";

            }


            ds = objts.Manageprojectmodule();


            if (ds.Tables[0].Rows.Count > 0)
            {

                rptinner.DataSource = ds;
                rptinner.DataBind();





            }
            else
            {

            }

        }

        protected void rptinner_OnItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {

                HtmlAnchor linkassign = (HtmlAnchor)e.Item.FindControl("linkassign");
                HtmlGenericControl litassign = (HtmlGenericControl)e.Item.FindControl("litassignto");
                HtmlGenericControl litstatus = (HtmlGenericControl)e.Item.FindControl("litstatus");


                if (DataBinder.Eval(e.Item.DataItem, "employeename").ToString().TrimEnd(',') != "")
                {
                    litassign.InnerHtml = "Assigned to <b>" + DataBinder.Eval(e.Item.DataItem, "employeename").ToString() + "</b>";
                
                }
                linkassign.InnerHtml = "Assign";
                linkassign.Attributes.Add("onclick", "assigntask('A','" + DataBinder.Eval(e.Item.DataItem, "nid").ToString() + "',this.id,'" + litassign.ClientID.ToString() + "')");
               
                if (Convert.ToDecimal(DataBinder.Eval(e.Item.DataItem, "percomplete").ToString()) == 0)
                {
                    litstatus.InnerHtml = "0%  (<a onclick='openstatusdiv(" + DataBinder.Eval(e.Item.DataItem, "nid").ToString() + "," + litstatus.ClientID.ToString() + ");' >Set Status</a>)";
                }
                else if (Convert.ToDecimal(DataBinder.Eval(e.Item.DataItem, "percomplete").ToString()) > 0 && Convert.ToDecimal(DataBinder.Eval(e.Item.DataItem, "percomplete").ToString()) < 100)
                {
                    litstatus.InnerHtml = DataBinder.Eval(e.Item.DataItem, "percomplete").ToString() + "% Completed (<a onclick='openstatusdiv(" + DataBinder.Eval(e.Item.DataItem, "nid").ToString() + "," + litstatus.ClientID.ToString() + ");' >Set Status</a>)";
                }
                else
                {
                    litstatus.InnerHtml = DataBinder.Eval(e.Item.DataItem, "percomplete").ToString() + "% Completed";

                }

            }
        }
        protected void rptinner_OnItemCommand(object sender, RepeaterCommandEventArgs e)
        {

        }


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]

        public static string assign_task(string struserid, string strnid, string strempid, string strmanagerid, string strdate)
        {

            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();

            objts.nid = strnid;
            objts.empid = strempid;
            objts.hours = strmanagerid;
            objts.date = strdate;
            objts.CreatedBy = struserid;
            string msg = "";
            msg = "failure";
            objts.action = "insertassigntask";
            try
            {
                ds = objts.AssignTasks();

                if (ds.Tables.Count > 0)
                {
                    if (ds.Tables[0].Rows.Count > 0)
                    {

                        msg = ds.Tables[0].Rows[0]["employeename"].ToString().TrimEnd(',');

                    }

                }


                return msg;
            }
            catch (Exception ex)
            {

                return msg;
            }

        }


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]

        public static string release_task(string struserid, string strnid)
        {

            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();

            objts.nid = strnid;
            string msg = "";
            msg = "failure";
            objts.action = "releasetask";
            try
            {
                ds = objts.AssignTasks();

                msg = "success";


                return msg;
            }
            catch (Exception ex)
            {

                return msg;
            }

        }



        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]

        public static string savestatus(string statusid, string status, string startdate, string percentage, string enddate)
        {

            ClsTimeSheet objts = new ClsTimeSheet();
            DataSet ds = new DataSet();

            objts.action = "updatestatus";
            objts.nid = statusid;

            objts.eststartdate = startdate;
            objts.completePercent = percentage;
            objts.enddate = enddate;
            
            string msg = "";
            msg = "failure";
            try
            {
               ds= objts.Manageprojectmodule();
                msg = ds.Tables[0].Rows[0]["percentage"].ToString();
                return msg;
            }
            catch (Exception ex)
            {
                
                return msg;
            }

        }
    }
}