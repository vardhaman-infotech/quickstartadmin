using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Data;
using System.IO;
using System.Text;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script.Services;
using System.Web.Script.Serialization;
using System.IO.Compression;
using AjaxControlToolkit;
using System.Net;


namespace empTimeSheet
{
    public partial class FileManager : System.Web.UI.Page
    {
        bool issearch = false;
        GeneralMethod objGen = new GeneralMethod();
        DataAccess objda = new DataAccess();
        ClsFile objfile = new ClsFile();
        ClsUser objuser = new ClsUser();
        excelexport objexcel = new excelexport();
        DataSet ds = new DataSet();
        DataTable tblfile = new DataTable();
        DataRow itemdr;
        DataColumn itemdc;
        protected void Page_Load(object sender, EventArgs e)
        {
            //Check whether use is valid or not

            objGen.validatelogin();

            if (!objda.checkUserInroles("36"))
            {
                Response.Redirect("UserDashboard.aspx");
            }
            if (!Page.IsPostBack)
            {
                MultiView1.ActiveViewIndex = 0;
                fillemployee();
                filldepartment();
                fillmembers();
                //Uncomment following code if you are redirecting from another page and want to navigate to specific user's directory
                //if (Request.QueryString["user"] != null && Request.QueryString["libraryid"] != null)
                //{
                //    ViewState["drive"] = "user";

                //    objuser.id = Request.QueryString["libraryid"].ToString();
                //    objuser.action = "select";
                //    ds = objuser.ManageEmployee();
                //    if (ds.Tables[0].Rows.Count > 0)
                //    {
                //        ViewState["driveid"] = ds.Tables[0].Rows[0]["nid"].ToString();
                //        ViewState["drivename"] = ds.Tables[0].Rows[0]["username"].ToString();
                //        bindgrid();
                //    }


                //}
            }
        }

        /// <summary>
        /// Create folder with all employees name
        /// </summary>
        protected void fillemployee()
        {
            
            objfile.name = txtsearchfile.Text;
            objfile.action = "selectemployees";
            objfile.companyid = Session["companyid"].ToString();
            objfile.nid = "";
            ds = objfile.managefiles();
            if (ds.Tables[0].Rows.Count > 0)
            {               
                switch (dropviewas.Text)
                {
                    case "Name":
                        ds.Tables[0].DefaultView.Sort = "username";
                        break;
                    case "Modificationdatedesc":
                        ds.Tables[0].DefaultView.Sort = "lastmodified desc";
                        break;
                    case "Modificationdate":
                        ds.Tables[0].DefaultView.Sort = "lastmodified";
                        break;
                    case "creationdate":
                        ds.Tables[0].DefaultView.Sort = "creationdate";
                        break;

                }
                dlemployee.DataSource = ds.Tables[0];
                dlemployee.DataBind();
            }
            else
            {
                dlemployee.DataSource = null;
                dlemployee.DataBind();
            }
        }
        public void filldepartment()
        {
            objda.id = "";
            objda.action = "select";
            objda.company = Session["companyid"].ToString();
            objda.name = txtsearch.Text;
            ds = objda.department();
            dropdepartment.DataSource = ds;
            dropdepartment.DataTextField = "department";
            dropdepartment.DataValueField = "nid";
            dropdepartment.DataBind();

            ListItem li = new ListItem("--All Departments--", "");
            dropdepartment.Items.Insert(0, li);
            dropdepartment.SelectedIndex = 0;

        }

        /// <summary>
        /// Bind files grid
        /// </summary>
        public void bindgrid()
        {
            divsearch.Visible = true;
            MultiView1.ActiveViewIndex = 0;
            hidselect.Value = "";
            if (ViewState["drive"] == null)
            {
                MultiView1.ActiveViewIndex = 0;
                divnav.Visible = false;
                uloperation.Visible = false;
                hidid2.Value = "";
                return;
            }
            divnav.Visible = true;

            uloperation.Visible = true;
            lbtnupload.Visible = true;
            lbtncopy.Visible = false;
            lbtnmove.Visible = false;
            lbtnnew.Visible = true;
            lbtnsitemapinner.Text = hidid2.Value;

            MultiView1.ActiveViewIndex = 1;


            lbtndir.Text = ViewState["drivename"].ToString();
            sitemapInnerlink.Visible = false;

            if (hidparentid.Value == "0")
            {
                lbtnupload.Visible = false;
                lbtnmove.Visible = false;
                lbtncopy.Visible = false;
                fillcategory();
            }
            else {
                lbtnmove.Visible = true;
            }

            objfile.action = "selectfile";
            objfile.loginid = ViewState["driveid"].ToString();
            objfile.createdby = Session["userid"].ToString();
            objfile.companyid = Session["companyId"].ToString();
            objfile.nid = "";
            objfile.type = ViewState["drive"].ToString();
            objfile.userid = hidid2.Value;

            objfile.parent = hidparentid.Value;
            if (issearch)
            {
                objfile.name = txtsearchfile.Text;
            }
            else
            {
                objfile.name = "";
            }
            ds = objfile.managefiles();

            if (ds.Tables[0].Rows.Count > 0)
            {
                switch (dropviewas.Text)
                {
                    case "Name":
                        ds.Tables[0].DefaultView.Sort = "originalfilename1, linktype";
                        break;
                    case "Modificationdatedesc":
                        ds.Tables[0].DefaultView.Sort = "sortModDate desc, linktype";
                        break;
                    case "Modificationdate":
                        ds.Tables[0].DefaultView.Sort = "sortModDate, linktype";
                        break;
                    case "creationdate":
                        ds.Tables[0].DefaultView.Sort = "sortAddDate, linktype";
                        break;

                }

                // FileInfo f = new FileInfo("");
                ds.Tables[0].Columns.Add("FileSize");
                foreach (DataRow dr in ds.Tables[0].Rows) {
                    if (dr["linktype"].ToString() == "file")
                    {
                        dr["FileSize"] = getfilesize(dr["uploadfilename"].ToString());
                    }
                }
                dlfile.Visible = true;
                tblfilelist.Visible = false;
                dlfile.DataSource = ds.Tables[0];
                dlfile.DataBind();

            }
            else
            {
                tblfilelist.Visible = true;
                dlfile.Visible = false;
            }
            if (ds.Tables[1].Rows.Count > 0)
            {
                dlnav.Visible = true;
                dlnav.DataSource = ds.Tables[1];
                dlnav.DataBind();

            }
            else
            {
                dlnav.Visible = false;
            }

        }
        protected void OnItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                //Reference the Repeater Item.
                RepeaterItem item = e.Item;

                //Reference the Controls.
               LinkButton lnk = item.FindControl("lbtnuserfile") as LinkButton;
               //lnk.Text=
            }
        }
        public string getfilesize(string filename ) {
            FileInfo f = new FileInfo(Server.MapPath("webfile/" + Session["companyid"].ToString())+"/"+ filename); 
            if (f.Length > 1048576)
            {
                return (Convert.ToDecimal(f.Length )/ 1048576).ToString("#.##") + " MB";
            }
            else if (f.Length > 1024)
            {
                return (Convert.ToDecimal(f.Length) / 1024).ToString("#.##") + " KB";
            }
            else
            {
                return f.Length + " Byte";
            }
         
            }
        /// <summary>
        /// Bind those file categories those category folder yet not created under the current user's directory
        /// If all category folders has added the Hide the "Create New" button for directory
        /// </summary>

        protected void fillcategory()
        {
            objfile.name = txtsearchfile.Text;
            objfile.loginid = ViewState["driveid"].ToString();
            objfile.companyid = Session["companyid"].ToString();
            objfile.action = "selectcategories";
            ds = objfile.managefiles();

            if (ds.Tables[0].Rows.Count > 0)
            {
                dlcategory.DataSource = ds;
                dlcategory.DataBind();
                btncreatenew.Visible = true;
            }
            else
            {
                dlcategory.DataSource = null;
                dlcategory.DataBind();
                btncreatenew.Visible = false;
            }
        }

        /// <summary>
        /// When click on any employee folders
        /// Call bind gris function to bind files of that specific employee
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dlemployee_ItemCommand(object sender, RepeaterCommandEventArgs e)
        {
            string[] arr = e.CommandArgument.ToString().Split(';');
            ViewState["drive"] = "user";
            ViewState["driveid"] = arr[0];
            ViewState["drivename"] = arr[1];

            txtsearchfile.Text = "";
            issearch = false;
            bindgrid();

        }


        protected void lbtnsharedfile_Click(object sender, EventArgs e)
        {
            ViewState["drive"] = "shared";
            bindgrid();
        }

        //When clicks on Root link (Home), show ll employees folder on screen

        protected void lbtnroort_Click(object sender, EventArgs e)
        {
            hidparentid.Value = "0";
            hidid2.Value = "";
            ViewState["drive"] = null;
            bindgrid();
            MultiView1.ActiveViewIndex = 0;
        }
        protected void lbtnsitemapinner_Click(object sender, EventArgs e)
        {
            hidparentid.Value = "0";
            // 08/21/2014 03:33 PM sanjay

            bindgrid();
        }
        protected void lbtndir_Click(object sender, EventArgs e)
        {
            issearch = false;
            txtsearchfile.Text = "";
            hidparentid.Value = "0";
            hidid2.Value = "";
            // 08/21/2014 03:33 PM sanjay

            bindgrid();
        }
        protected void dlnav_ItemCommand(object source, DataListCommandEventArgs e)
        {
            if (e.CommandName == "goto")
            {
                int i = e.Item.ItemIndex;
                hidparentid.Value = e.CommandArgument.ToString();

                if (ViewState["drive"].ToString() == "user")
                {
                    hidid2.Value = "";
                }
                else
                {
                    hidid2.Value = ((HtmlInputHidden)dlnav.Items[i].FindControl("hidloginid")).Value;

                }
                issearch = false;
                txtsearchfile.Text = "";
                bindgrid();

            }
        }
        protected void dlfile_ItemCommand(object source, DataListCommandEventArgs e)
        {
            int i = e.Item.ItemIndex;
            if (e.CommandName == "select")
            {
                HtmlAnchor lbtn = (HtmlAnchor)dlfile.Items[i].FindControl("lbtndir");
                LinkButton lbtnselect = (LinkButton)dlfile.Items[i].FindControl("lbtnselect");
                if (lbtnselect.Text == "Select")
                {
                    hidselect.Value = hidselect.Value + "#" + e.CommandArgument.ToString();
                    //bindgrid();
                    lbtn.Attributes.Add("Class", "active");
                    lbtnselect.Text = "Unselect";
                }
                else
                {
                    hidselect.Value = hidselect.Value.ToString().Replace("#" + e.CommandArgument.ToString(), "");

                    lbtn.Attributes.Add("Class", "");
                    lbtnselect.Text = "Select";
                }


            }
            if (e.CommandName == "open")
            {
                HtmlInputHidden hidtype = (HtmlInputHidden)dlfile.Items[i].FindControl("hidlinktype");
                if (hidtype.Value == "folder")
                {
                    hidparentid.Value = e.CommandArgument.ToString();
                    hidid2.Value = ((HtmlInputHidden)dlfile.Items[i].FindControl("hidloginid")).Value;
                    issearch = false;
                    txtsearchfile.Text = "";

                    bindgrid();
                }
                else
                {
                    objfile.nid = e.CommandArgument.ToString();
                    objfile.action = "selectfile";
                    objfile.loginid = ViewState["driveid"].ToString();
                    objfile.createdby = Session["userid"].ToString();
                    objfile.dob = GeneralMethod.getLocalDateTime();
                    ds = objfile.managefiles();

                    if (!objexcel.downloadVirturalfile(ds.Tables[0].Rows[0]["uploadfilename"].ToString(), ds.Tables[0].Rows[0]["originalfilename"].ToString(),"webfile/" + Session["companyid"].ToString()))
                    {
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('File is not available or temporarily removed.');</script>", false);
                        return;
                    }

                }
            }
            if (e.CommandName == "detail")
            {
                objfile.nid = e.CommandArgument.ToString();
                objfile.action = "selectfile";
                objfile.loginid = ViewState["driveid"].ToString();
                objfile.createdby = Session["userid"].ToString();
                objfile.dob = GeneralMethod.getLocalDateTime();
                objfile.companyid = Session["companyid"].ToString();
                ds = objfile.managefiles();

                if (ds.Tables[0].Rows.Count > 0)
                {
                    tdcreatedby.InnerHtml = "Created by: " + ds.Tables[0].Rows[0]["name"].ToString();
                    tdcreationdate.InnerHtml = "Creation date: " + ds.Tables[0].Rows[0]["adddate"].ToString();
                    tdlastmodificationdate.InnerHtml = "Modification date: " + ds.Tables[0].Rows[0]["modificationdate"].ToString();
                    //tdshareto.InnerHtml = "<b>Shared to:</b> " + ds.Tables[0].Rows[0]["sharedetail"].ToString();
                    if (ds.Tables[0].Rows[0]["linktype"].ToString() == "folder")
                    {
                        tdfilename.InnerHtml = "Directory Name: " + ds.Tables[0].Rows[0]["originalfilename"].ToString();
                    }
                    else
                    {
                        tdfilename.InnerHtml = "File Name: " + ds.Tables[0].Rows[0]["originalfilename"].ToString();

                    }

                    if (ds.Tables[0].Rows[0]["shareto"].ToString() != "")
                    {

                        divaccessdetail.Visible = true;
                        if (ds.Tables[1].Rows.Count > 0)
                        {
                            repdetail.Visible = true;
                            repdetail.DataSource = ds.Tables[1];
                            repdetail.DataBind();
                        }
                        else
                        {
                            repdetail.Visible = false;
                        }
                    }
                    else
                    {
                        divaccessdetail.Visible = false;
                    }

                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>openpop('popdetail');</script>", false);

                }
            }
            if (e.CommandName == "share")
            {
                hidfileid.Value = e.CommandArgument.ToString();
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>openpop('popshareuser');</script>", false);
            }
            if (e.CommandName == "edit")
            {
                dlfile.EditItemIndex = e.Item.ItemIndex;
                bindgrid();
            }
            if (e.CommandName == "delete")
            {
                objfile.nid = e.CommandArgument.ToString();
                objfile.action = "delete";
                dlfile.EditItemIndex = -1;
                ds = objfile.managefiles();
                bindgrid();
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'> alert('Deleted Successfully');</script>", false);

            }
            if (e.CommandName == "saverename")
            {
                objfile.nid = e.CommandArgument.ToString();
                objfile.name = ((TextBox)dlfile.Items[i].FindControl("txtrename")).Text;
                objfile.action = "rename";
                ds = objfile.managefiles();
                dlfile.EditItemIndex = -1;
                bindgrid();

            }
            if (e.CommandName == "resetrename")
            {
                dlfile.EditItemIndex = -1;
                bindgrid();
            }
        }
        protected void btncreatenew_Click(object sender, EventArgs e)
        {
            hidcategoryid.Value = "0";
            createnewdirectory();


        }
        protected void lbtnmove_Click(object sender, EventArgs e)
        {
            treemove.Nodes.Clear();
            tdcopycol.InnerHtml = "Move to";
            divcopytitle.InnerHtml = "Move";
            hidmoveaction.Value = "move";
            btncopy.Text = "Move";
            string rnid = hidMoveRid.Value;
            filltree("0");

        }
        public void filltree(string id)
        {

            objfile.nid = id;
            objfile.action = "selecttree";
            objfile.loginid = ViewState["driveid"].ToString();
            objfile.createdby = Session["userid"].ToString();
            objfile.companyid = Session["companyid"].ToString();
            ds = objfile.managefiles();
            string tmp;
            if (ds.Tables[0].Rows.Count > 0)
            {

                tmp = ds.Tables[0].Rows[0]["originalfilename"].ToString();
                TreeNode trnode = new TreeNode(tmp, ds.Tables[0].Rows[0]["nid"].ToString());
                treemove.Nodes.Add(trnode);
                for (int i = 0; i < ds.Tables[1].Rows.Count; i++)
                {
                    tmp = ds.Tables[1].Rows[i]["originalfilename"].ToString();
                    trnode = new TreeNode(tmp, ds.Tables[1].Rows[i]["nid"].ToString());
                    treemove.Nodes[0].ChildNodes.Add(trnode);
                }
            }
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'> openpop('popMove');</script>", false);

        }
        protected void lbtncopy_Click(object sender, EventArgs e)
        {
            treemove.Nodes.Clear();
            tdcopycol.InnerHtml = "Copy to";
            hidmoveaction.Value = "copy";
            divcopytitle.InnerHtml = "Copy";
            btncopy.Text = "Copy";
            filltree("0");
        }

        protected void treemove_SelectedNodeChanged(object sender, EventArgs e)
        {
            objfile.nid = treemove.SelectedNode.Value;
            objfile.action = "selecttree";
            objfile.loginid = ViewState["driveid"].ToString();
            objfile.createdby = Session["userid"].ToString();
            ds = objfile.managefiles();
            int i = 0;
            string tmp = "";
            if (treemove.SelectedNode.ChildNodes.Count == 0)
            {
                for (i = 0; i < ds.Tables[1].Rows.Count; i++)
                {
                    tmp = ds.Tables[1].Rows[i]["originalfilename"].ToString();
                    TreeNode trnode = new TreeNode(tmp, ds.Tables[1].Rows[i]["nid"].ToString());
                    treemove.SelectedNode.ChildNodes.Add(trnode);
                    treemove.SelectedNode.Expand();
                }
                if (i > 0)
                {
                    treemove.SelectedNode.Expand();
                }
            }
            else
            {
                treemove.SelectedNode.Expand();
            }
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'> openpop('popMove');</script>", false);
        }
        protected void btncopy_Click(object sender, EventArgs e)
        {
            if (treemove.SelectedNode == null)
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'> alert('Select Destination Directory');openpop('popMove');</script>", false);
                return;

            }
            if (hidselect.Value == "")
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'> alert('Select Item to Move or Copy.');</script>", false);
                return;

            }

            objfile.parent = treemove.SelectedNode.Value;
            if (hidmoveaction.Value == "copy")
            {
                objfile.action = "copy";
            }
            else
            {
                objfile.action = "move";
            }
            objfile.companyid = Session["companyId"].ToString();
            objfile.loginid = ViewState["driveid"].ToString();
            objfile.createdby = Session["userid"].ToString();
            string[] str = hidselect.Value.Split('#');
            if (str.Length == 0)
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'> alert('Select Item to Move or Copy.');</script>", false);
                return;

            }
            for (int i = 1; i < str.Length; i++)
            {
                objfile.nid = str[i];
                ds = objfile.managefiles();

            }

            bindgrid();

        }
        protected void btnupload_Click(object sender, EventArgs e)
        {
            string datetime = DateTime.Now.ToFileTimeUtc().ToString();


            if (Session["file"] != null)
            {
                tblfile = (DataTable)Session["file"];
                if (tblfile.Rows.Count > 0)
                {
                    try
                    {
                        objfile.companyid = Session["CompanyId"].ToString();
                        objfile.action = "insert";
                        objfile.dob = GeneralMethod.getLocalDateTime();
                        objfile.nid = "";
                        objfile.description = "File uploaded by " + Session["userid"].ToString();
                        objfile.parent = hidparentid.Value;
                        objfile.category = "0";
                        for (int i = 0; i < tblfile.Rows.Count; i++)
                        {

                            objfile.name = tblfile.Rows[i]["originalname"].ToString(); ;
                            objfile.mName = tblfile.Rows[i]["savename"].ToString();
                            objfile.type = ViewState["drive"].ToString();
                            objfile.linktype = "file";

                            objfile.imgurl = GeneralMethod.getfilicon("file", tblfile.Rows[i]["ext"].ToString().ToUpper());
                            objfile.loginid = ViewState["driveid"].ToString();
                            objfile.createdby = Session["userid"].ToString();
                            if (ViewState["drive"].ToString() == "meetingfile" || ViewState["drive"].ToString() == "shared")
                            {
                                objda.loginid = hidid2.Value;
                            }
                            //objfile.meetingid = hidid2.Value;
                            objfile.extension = tblfile.Rows[i]["ext"].ToString();
                            ds = objfile.managefiles();
                        }

                        bindgrid();
                        Session["file"] = null;
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>closepop('popupload');</script>", false);
                    }
                    catch
                    {
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('Error in Uploading');</script>", false);
                        return;

                    }
                }
                else
                {
                    Session["file"] = null;
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('File does not exist.');</script>", false);
                    return;

                }


            }
            else
            {

                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('File does not exist.');</script>", false);
                return;

            }
        }


        protected void dlfile_ItemDataBound(object sender, DataListItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {

                string val = DataBinder.Eval(e.Item.DataItem, "nid").ToString();
                //LinkButton lbtn = (LinkButton)e.Item.FindControl("lbtndir");
                //lbtn.OnClientClick = "return openselect(this.id,'" + val + "')";

                if (DataBinder.Eval(e.Item.DataItem, "linktype").ToString() == "file")
                {
                    LinkButton lb = (LinkButton)e.Item.FindControl("lbtnopen");
                    ScriptManager.GetCurrent(this).RegisterPostBackControl(lb);
                }
                if (ViewState["drive"] != null)
                {
                    if (DataBinder.Eval(e.Item.DataItem, "categoryid") != null && DataBinder.Eval(e.Item.DataItem, "categoryid").ToString() != "0")
                    {

                        LinkButton lbtnrename = (LinkButton)e.Item.FindControl("lbtnrename");

                        lbtnrename.Enabled = false;
                        lbtnrename.Style.Add("opacity", ".5");

                        lbtnrename.Style.Add("cursor", "default");

                    }
                }
                if (!issearch)
                {
                    ((HtmlContainerControl)e.Item.FindControl("divfilepath")).Visible = false;
                }
                else
                {
                    ((HtmlContainerControl)e.Item.FindControl("divfilepath")).Visible = true;
                }

            }
        }
        protected void dropdepartment_SelectedIndexChanged(object sender, EventArgs e)
        {
            fillmembers(); ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>openpop('popshareuser');</script>", false);
        }
        protected void txtsearch_TextChanged(object sender, EventArgs e)
        {
            fillmembers(); ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>openpop('popshareuser');</script>", false);
        }
        public void fillmembers()
        {


            objuser.action = "SearchActiveUsersExceptMe";
            objuser.deptid = dropdepartment.Text;
            objuser.fname = txtsearch.Text;
            objuser.id = Session["userid"].ToString();
            objuser.companyid = Session["CompanyId"].ToString();
            ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0)
            {
                DataList1.Visible = true;
                nodatfound.Visible = false;
                btnsend.Visible = true;
                DataList1.DataSource = ds;
                DataList1.DataBind();

            }
            else
            {
                DataList1.Visible = false;
                nodatfound.Visible = true;
                btnsend.Visible = false;
            }

        }

        protected void btnsend_Click(object sender, EventArgs e)
        {
            int status = 0;
            string str = "";
            for (int i = 0; i < DataList1.Items.Count; i++)
            {
                CheckBox chk = (CheckBox)DataList1.Items[i].FindControl("checkmember");
                if (chk.Checked == true)
                {
                    HtmlInputHidden hidempid = (HtmlInputHidden)DataList1.Items[i].FindControl("hidempid");
                    status = 1;
                    str += hidempid.Value + "#";

                }


            }
            if (status == 0)
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('Select User to share.');openpop('popshareuser');</script>", false);
                return;
            }

            objfile.nid = hidfileid.Value;
            objfile.action = "share";
            objfile.usertype = str;
            ds = objfile.managefiles();
            bindgrid();

        }

        [ScriptMethod()]
        [WebMethod]
        public static List<string> getName(string prefixText)
        {
            ClsUser objuser = new ClsUser();
            DataSet ds1 = new DataSet();
            objuser.id = "";
            objuser.action = "SearchActiveUsersExceptMe";
            objuser.deptid = "";
            objuser.fname = "";
            objuser.companyid = HttpContext.Current.Session["CompanyId"].ToString();
            ds1 = objuser.ManageEmployee();
            List<string> items = new List<string>();
            if (ds1.Tables[0].Rows.Count > 0)
            {
                for (int i = 0; i < ds1.Tables[0].Rows.Count; i++)
                {
                    items.Add(ds1.Tables[0].Rows[i]["username"].ToString().ToUpper());

                }

            }
            var returnList = items.Where(item => item.Contains(prefixText.ToUpper())).ToList();
            returnList.Sort();
            return returnList;

        }
        protected void lbtndelete_Click(object sender, EventArgs e)
        {

            //if (hidselect.Value == "")
            //{
            //    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'> alert('Select Item to delete');</script>", false);
            //    return;

            //}

            objfile.action = "delete";
            objfile.companyid = Session["companyId"].ToString();
            objfile.loginid = ViewState["driveid"].ToString();
            objfile.createdby = Session["userid"].ToString();

            //string[] str = hidselect.Value.Split('#');

            //if (str.Length == 0)
            //{
            //    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'> alert('Select Item to delete');</script>", false);
            //    return;

            //}
            if (dlfile.Items.Count == 0)
            {
                return;
            }
            int status = 0;
            for (int i = 0; i < dlfile.Items.Count; i++)
            {
                CheckBox chk = (CheckBox)dlfile.Items[i].FindControl("chkselect");
                if (chk.Checked)
                {
                    status = 1;
                    objfile.nid = ((HtmlInputHidden)dlfile.Items[i].FindControl("hidnid")).Value;
                    ds = objfile.managefiles();
                }

            }
            if (status == 0)
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'> alert('Select Item to delete');</script>", false);
                return;

            }
            bindgrid();
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'> alert('Deleted Successfully');</script>", false);

        }

        protected void dropviewas_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (MultiView1.ActiveViewIndex == 0)
            {
                fillemployee();
            }
            else
            {
                if (txtsearchfile.Text != "")
                {
                    issearch = true;

                }
                bindgrid();
            }
        }
        protected void dlcategory_ItemCommand(object sender, DataListCommandEventArgs e)
        {
            if (e.CommandName == "goto")
            {
                hidcategoryid.Value = e.CommandArgument.ToString();
                Literal ltrcategoryname = (Literal)e.Item.FindControl("ltrcategoryname");
                // txtdirname.Text = ltrcategoryname.Text;
                createnewdirectory();
            }
        }

        protected void createnewdirectory()
        {
            objfile.action = "insert";
            objfile.parent = hidparentid.Value;

            objfile.category = hidcategoryid.Value;

            objfile.loginid = ViewState["driveid"].ToString();
            objfile.createdby = Session["userid"].ToString();
            objfile.type = ViewState["drive"].ToString();
            objfile.name = txtdirname.Text;
            objfile.mName = txtdirname.Text;
            objfile.nid = "";
            objfile.dob = GeneralMethod.getLocalDateTime();
            objfile.description = "Created by " + Session["userid"].ToString();
            objfile.companyid = Session["companyId"].ToString();
            objfile.imgurl = GeneralMethod.getfilicon("folder", "");
            //objfile.meetingid = hidid2.Value;
            objfile.linktype = "folder";
            objfile.extension = "";
            ds = objfile.managefiles();
            txtdirname.Text = "";
            // hidparentid.Value = ds.Tables[0].Rows[0]["nid"].ToString();
            bindgrid();
            fillcategory();
        }

        protected void btnsearch_Click(object sender, EventArgs e)
        {
            if (MultiView1.ActiveViewIndex == 0)
            {
                fillemployee();
            }
            else
            {
                issearch = true;
                bindgrid();
            }
        }

        #region Upload Files

        public DataTable createtable()
        {

            DataColumn itemdc;
            DataTable itemtable = new DataTable();
            itemdc = new DataColumn("originalname", System.Type.GetType("System.String"));
            itemtable.Columns.Add(itemdc);
            itemdc = new DataColumn("savename", System.Type.GetType("System.String"));
            itemtable.Columns.Add(itemdc);
            itemdc = new DataColumn("ext", System.Type.GetType("System.String"));
            itemtable.Columns.Add(itemdc);
            return itemtable;
        }

        protected void AjaxFileUpload1_OnUploadComplete(object sender, AjaxFileUploadEventArgs file)
        {

            string datetime = DateTime.Now.ToFileTimeUtc().ToString();
            string filename = "";
            string originalfile = "";

            try
            {
                String extension = Path.GetExtension(file.FileName);
                filename = Session["userid"].ToString() + "_" + datetime + extension;
                originalfile = file.FileName;
                // Limit preview file for file equal or under 4MB only, otherwise when GetContents invoked
                // System.OutOfMemoryException will thrown if file is too big to be read.
                if (file.FileSize <= 1024 * 1024 * 50)
                {
                    Session["fileContentType_" + file.FileId] = file.ContentType;
                    Session["fileContents_" + file.FileId] = file.GetContents();

                    // Set PostedUrl to preview the uploaded file.         
                    // file.PostedUrl = string.Format("?preview=1&fileId={0}", file.FileId);
                    file.PostedUrl = "downloads.png";
                }
                else
                {
                    file.PostedUrl = "downloads.png";
                }


                string directory = @"webfile/" + Session["companyid"].ToString() + "/";
                // Since we never call the SaveAs method(), we need to delete the temporary fileß
                string dir = Server.MapPath(directory);
                if (!Directory.Exists(Server.MapPath(directory)))
                {
                    Directory.CreateDirectory(Server.MapPath(directory));

                }
                AjaxFileUpload1.SaveAs(MapPath(directory + filename), true);

                if (Session["file"] == null)
                {
                    tblfile = createtable();

                }
                else
                {
                    tblfile = (DataTable)Session["file"];

                }

                itemdr = tblfile.NewRow();



                itemdr["originalname"] = originalfile;

                itemdr["savename"] = filename;
                itemdr["ext"] = extension;
                tblfile.Rows.Add(itemdr);

                Session["file"] = tblfile;

                file.DeleteTemporaryData();

            }
            catch
            {
            }



        }

        protected void AjaxFileUpload1_UploadCompleteAll(object sender, AjaxFileUploadCompleteAllEventArgs e)
        {
            var startedAt = (DateTime)Session["uploadTime"];
            var now = DateTime.Now;
            e.ServerArguments = new JavaScriptSerializer()
                .Serialize(new
                {
                    duration = (now - startedAt).Seconds,
                    time = DateTime.Now.ToShortTimeString()
                });
        }

        protected void AjaxFileUpload1_UploadStart(object sender, AjaxFileUploadStartEventArgs e)
        {
            var now = DateTime.Now;
            e.ServerArguments = now.ToShortTimeString();
            Session["uploadTime"] = now;

        }

        /// <summary>
        /// Upload Files to FTP
        /// </summary>
        /// <param name="fileName"></param>
        /// <param name="data"></param>
        /// <param name="directoryname"></param>
        /// <param name="UploadDirectory"></param>
        /// <returns></returns>
        public static string UploadFile(string fileName, byte[] data, string directoryname)
        {
            try
            {
                string userName = System.Web.Configuration.WebConfigurationManager.AppSettings["ftpusername"].ToString();
                string password = System.Web.Configuration.WebConfigurationManager.AppSettings["ftppassword"].ToString();
                string FtpUrl = System.Web.Configuration.WebConfigurationManager.AppSettings["ftphost"].ToString();
                //string  = "ftp://citrix.harshwal.com/Sanjay_SaraTechnologies/";

                //string userName = @"hcllp\administrator"; // e.g. username
                //string password = @"Ka%45Md&x3004"; // e.g. password

                string PureFileName = new FileInfo(fileName).Name;
                string fullurl = FtpUrl + directoryname;
                // bool result = FtpDirectoryExists(FtpUrl + directoryname, userName, password);
                FtpWebRequest request;
                try
                {
                    request = (FtpWebRequest)WebRequest.Create(fullurl);
                    request.Credentials = new NetworkCredential(userName, password);
                    request.Method = WebRequestMethods.Ftp.MakeDirectory;
                    using (var resp = (FtpWebResponse)request.GetResponse())
                    {
                        //Console.WriteLine(resp.StatusCode);
                    }
                }
                catch (Exception ex)
                {
                }

                String uploadUrl = String.Format("{0}{1}/{2}", fullurl, "", PureFileName);
                request = (FtpWebRequest)FtpWebRequest.Create(uploadUrl);
                request.Proxy = null;
                request.Method = WebRequestMethods.Ftp.MakeDirectory;
                request.Method = WebRequestMethods.Ftp.UploadFile;
                request.Credentials = new NetworkCredential(userName, password);
                request.UseBinary = true;
                request.UsePassive = true;
                // byte[] data = File.ReadAllBytes(filefullpath);
                request.ContentLength = data.Length;
                Stream stream = request.GetRequestStream();
                stream.Write(data, 0, data.Length);
                stream.Close();
                FtpWebResponse res = (FtpWebResponse)request.GetResponse();
                return res.StatusDescription;
                // ScriptManager.RegisterStartupScript(this, GetType(), "key", "<script type='text/javascript'>alert("uploaded successfully");</script>", false);
                //GeneralMethod.alert(this.Page, "uploaded successfully");
            }
            catch (WebException e)
            {
                String status = ((FtpWebResponse)e.Response).StatusDescription;
                return status;
            }
        }

        #endregion

        #region Download File
        public bool DownloadFile(string directoryname, string filename)
        {
            return true;
        }

        #endregion
    }
}