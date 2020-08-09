using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Data;
using System.IO;
using System.Web.Services;
using System.Web.Script.Services;

namespace empTimeSheet
{
    public partial class ServerLog : System.Web.UI.Page
    {
        DataRow itemdr;
      
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();
        clsServer objserver = new clsServer();
        public string strsno = "1";
        protected string UploadFolderPath = "~/webfile/serverfiles/";
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!IsPostBack)
            {
                if (!objda.checkUserInroles("12"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
                txtlogdate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");
                hidrowno.Value = "1";
                hidsno.Value = "1";
                strsno = "1";
                hidcompanyid.Value = Session["companyid"].ToString();
                // Session["itemtable"] = null;

                fillclient();
                bindserver();
                createtable();
            }
        }
        /// <summary>
        /// Fill clients 
        /// </summary>
        protected void fillclient()
        {
            objuser.clientname = "";
            objuser.action = "select";
            objuser.companyid = Session["companyid"].ToString();
            objuser.id = "";
            ds = objuser.client();
            if (ds.Tables[0].Rows.Count > 0)
            {
                ddlclient.DataSource = ds;
                ddlclient.DataTextField = "clientcodewithname";
                ddlclient.DataValueField = "nid";
                ddlclient.DataBind();
                ListItem li = new ListItem("--Select Client--", "");
                ddlclient.Items.Insert(0, li);
                ddlclient.SelectedIndex = 0;
            }
        }

        /// <summary>
        /// On selection of a cleint bind all servers for that particular client
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ddlclient_SelectedIndexChanged(object sender, EventArgs e)
        {
            //blank();
            rptinner.DataSource = null;
            rptinner.DataBind();
            bindserver();
            upadatepanel1.Update();
        }
        protected void txtlogdate_TextChanged(object sender, EventArgs e)
        {
            blank();
            checkexists();
        }
        /// <summary>
        /// Bind Server on basis of client
        /// </summary>
        public void bindserver()
        {
            ddlserver.Items.Clear();
            if (ddlclient.Text != "")
            {
                objserver.action = "select";
                objserver.servername = "";
                objserver.nid = "";

                objserver.companyid = Session["companyId"].ToString();
                objserver.clientid = ddlclient.Text;

                ds = objserver.Server();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    ddlserver.DataSource = ds;
                    ddlserver.DataTextField = "ServerName";
                    ddlserver.DataValueField = "nid";
                    ddlserver.DataBind();

                }
            }
            ListItem li = new ListItem("--Select Server--", "");
            ddlserver.Items.Insert(0, li);
            ddlserver.SelectedIndex = 0;

        }

        /// <summary>
        /// On Selected Index Change Event for Server
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ddlserver_SelectedIndexChanged(object sender, EventArgs e)
        {
          //  string str = ddlserver.Text;
            //blank();
          //  ddlserver.Text = str;
            fillserverdetails();
            checkexists();
            upadatepanel1.Update();
        }

        /// <summary>
        /// Fill Basic Detail For Server
        /// </summary>
        public void fillserverdetails()
        {
            if (ddlserver.Text != "")
            {
                objserver.action = "select";
                objserver.name = "";
                objserver.nid = ddlserver.Text;

                objserver.companyid = Session["companyId"].ToString();
                objserver.clientid = "";

                ds = objserver.Server();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    rptinner.DataSource = ds;
                    rptinner.DataBind();
                    // divNewServerLog.Visible = true;
                    return;
                }

            }

            rptinner.DataSource = null;
            rptinner.DataBind();

        }

        /// <summary>
        /// Check whether Log already exists for selected client server on selected date
        /// </summary>
        protected void checkexists()
        {
            objserver.nid = "";
            headlogentry.Visible = false;
            objserver.action = "checkexists";
            objserver.date = txtlogdate.Text;
            objserver.serverid = ddlserver.Text;
            ds = objserver.ServerLog();
            if (ds.Tables[0].Rows.Count > 0)
            {
                GeneralMethod.alert(this.Page, "Log already exists");
                rbtncpuutilization.Text = ds.Tables[0].Rows[0]["CPUUtilization"].ToString();
                rbtnramutilization.Text = ds.Tables[0].Rows[0]["RAMUtilization"].ToString();

                rdlupdated.Text = ds.Tables[0].Rows[0]["IsUpdated"].ToString();
                txtUpdateSummary.Text = ds.Tables[0].Rows[0]["UpdateSummary"].ToString();
                if (ds.Tables[0].Rows[0]["IsUpdated"] != null && ds.Tables[0].Rows[0]["IsUpdated"].ToString() == "Yes")
                {
                    divupdated.Style.Add("display", "block");
                }
                else
                {
                    divupdated.Style.Add("display", "none");
                }
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>showupdate();</script>", false);
                rdlbackup.Text = ds.Tables[0].Rows[0]["TakenBackUp"].ToString();
                txtbackupdescription.Text = ds.Tables[0].Rows[0]["BackupDescription"].ToString();
                if (ds.Tables[0].Rows[0]["TakenBackUp"] != null && ds.Tables[0].Rows[0]["TakenBackUp"].ToString() == "Yes")
                {
                    divbackup.Style.Add("display", "block");
                }
                else
                {
                    divbackup.Style.Add("display", "none");
                }
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>showbackup();</script>", false);

                //rbtnramutilization.Attributes.AddAttributes("", "");


                string[] spacearr = ds.Tables[0].Rows[0]["Usedspace"].ToString().Split(' ');
                txt_space.Text = spacearr[0];
                ddlspece.Text = spacearr[1];
                hidserverlogid.Value = ds.Tables[0].Rows[0]["nid"].ToString();
                if (ds.Tables[2].Rows.Count > 0)
                {
                    createtable();
                    Session["itemtable"] = ds.Tables[2];
                    hidfilecount.Value = ds.Tables[2].Rows.Count.ToString();
                    repattachment.DataSource = ds.Tables[2];
                    repattachment.DataBind();
                }
                if (ds.Tables[1].Rows.Count > 0)
                {
                    dgnews.DataSource = ds.Tables[1];
                    dgnews.DataBind();
                    headlogentry.Visible = true;
                }
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>setramcolor();</script>", false);
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>setcpucolor();</script>", false);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>showbackup();</script>", false);

            }
        }

        /// <summary>
        /// Save Data 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>

        protected void save(object sender, EventArgs e)
        {
            //objserver.empid = dropemployee.Text;
            objserver.serverid = ddlserver.Text;
            objserver.clientid = ddlclient.Text;
            objserver.date = txtlogdate.Text;
            objserver.ramutilization = rbtnramutilization.Text;
            objserver.cpuutilization = rbtncpuutilization.Text;
            objserver.usedspace = txt_space.Text + " " + ddlspece.Text;
            objserver.IsUpdated = rdlupdated.Text;
            objserver.createdby = Session["userid"].ToString();
            if (objserver.IsUpdated == "Yes")
                objserver.UpdateSummary = txtUpdateSummary.Text;
            else
                objserver.UpdateSummary = "";

            objserver.TakenBackup = rdlbackup.Text;
            if (objserver.TakenBackup == "Yes")
                objserver.BackupDescription = txtbackupdescription.Text;
            else
                objserver.BackupDescription = "";


            objserver.action = "insert";
            objserver.nid = hidserverlogid.Value;
            objserver.companyid = Session["companyid"].ToString();
            ds = objserver.ServerLog();
            if (ds.Tables[0].Rows.Count > 0)
            {
                string msg = "";
                msg = "success";
                string[] logtype1 = hidlog.Value.Split(new string[] { "###" }, StringSplitOptions.None);
                string[] eventid1 = hidevent.Value.Split(new string[] { "###" }, StringSplitOptions.None);
                string[] Des1 = hiddes.Value.Split(new string[] { "###" }, StringSplitOptions.None);
                string[] level1 = hidlevel.Value.Split(new string[] { "###" }, StringSplitOptions.None);
                string[] action1 = hidaction.Value.Split(new string[] { "###" }, StringSplitOptions.None);
                string[] remark1 = hidremark.Value.Split(new string[] { "###" }, StringSplitOptions.None);

                try
                {


                    for (int i = 1; i < logtype1.Length; i++)
                    {
                        if (logtype1[i] != "--Select--" && logtype1[i]!="")
                        {
                            objserver.logid = ds.Tables[0].Rows[0]["nid"].ToString();
                            objserver.nid = "";
                            objserver.logtype = logtype1[i];
                            objserver.eventid = eventid1[i];
                            objserver.description = Des1[i];
                            objserver.severity = level1[i];
                            objserver.actionperform = action1[i];
                            objserver.remark = remark1[i];

                            objserver.ServerLogDetail();
                        }
                    }
                    if (Session["itemtable"] != null)
                    {
                        DataTable itemtable = (DataTable)Session["itemtable"];
                        for (int i = 0; i < itemtable.Rows.Count; i++)
                        {
                            if (itemtable.Rows[i]["attachid"] != null && itemtable.Rows[i]["attachid"].ToString() == "")
                            {
                                objserver.logid = ds.Tables[0].Rows[0]["nid"].ToString();
                                objserver.nid = "";
                                objserver.title = itemtable.Rows[i]["title"].ToString();
                                objserver.originalfilename = itemtable.Rows[i]["originalfilename"].ToString();
                                objserver.uploadfilename = itemtable.Rows[i]["uploadfilename"].ToString();
                                objserver.action = "insertfile";
                                objserver.ServerLogDetail();
                            }
                        }
                    }
                    GeneralMethod.alert(this.Page, "Saved Successfully!");
                    blank();
                    txtlogdate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");
                    rptinner.DataSource = null;
                    rptinner.DataBind();
                    ddlserver.SelectedIndex = 0;


                }

                catch (Exception ex)
                {
                    msg = ex.Message;

                }
            }
        }

        /// <summary>
        /// Reset values
        /// </summary>
        protected void blank()
        {
            //reset basic details
            //ddlserver.SelectedIndex = 0;
            //txtlogdate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");
           // ddlserver.SelectedIndex = 0;
           // ddlclient.SelectedIndex = 0;
            //rptinner.Visible = false;
            txt_space.Text = "";
            rbtncpuutilization.SelectedIndex = 0;
            rbtnramutilization.SelectedIndex = 0;
            ddlspece.SelectedIndex = 0;
            rdlupdated.ClearSelection();
            txtUpdateSummary.Text = "";
            divupdated.Style.Add("display", "none");

            rdlbackup.ClearSelection();
            txtbackupdescription.Text = "";
            divbackup.Style.Add("display", "none");

            //Reset Log entry details
            hidrowno.Value = "1";
            hidsno.Value = "1";
            strsno = "1";
            hidevent.Value = "";
            hidfilecount.Value = "";
            hidlevel.Value = "";
            hidlog.Value = "";
            hidremark.Value = "";

            //Reset attachment details
            txtattachmenttitle.Text = "";
            Session["itemtable"] = null;
            repattachment.DataSource = null;
            repattachment.DataBind();
            headlogentry.Visible = false;
            //Reset Server details Repeater
           // rptinner.DataSource = null;
           //  rptinner.DataBind();
            createtable();

            dgnews.DataSource = null;
            dgnews.DataBind();
            hidserverlogid.Value = "";
            //hide add new div
            //  divNewServerLog.Visible = false;
        }

        /// <summary>
        /// Add New Log Entry
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void liaddnew_Click(object sender, EventArgs e)
        {
            blank();
            ddlclient.SelectedIndex = 0;
        }


        protected void FileUploadComplete(object sender, EventArgs e)
        {
            string datetime = DateTime.Now.ToFileTimeUtc().ToString();
            string filename = "";
            string filename1 = System.IO.Path.GetFileName(AsyncFileUpload1.FileName);
            String extension = Path.GetExtension(AsyncFileUpload1.FileName);

            filename = datetime + "_" + Session["userid"].ToString() + extension;

            AsyncFileUpload1.SaveAs(Server.MapPath(this.UploadFolderPath) + filename);
            DataTable itemtable = (DataTable)Session["itemtable"];
            itemdr = itemtable.NewRow();

            if (itemtable.Rows.Count < 0)
            {
                itemdr["nid"] = 1;
                hidfilecount.Value = "1";
            }
            else
            {
                hidfilecount.Value = (Convert.ToInt32(itemtable.Rows.Count) + 1).ToString();
                itemdr["nid"] = Convert.ToInt32(itemtable.Rows.Count) + 1;
            }
            itemdr["title"] = txtattachmenttitle.Text;
            itemdr["originalfilename"] = filename1;
            itemdr["uploadfilename"] = filename;
            itemdr["attachid"] = "";
            itemtable.Rows.Add(itemdr);

            Session["itemtable"] = itemtable;
            fillattachment();

            btnupload.Visible = true;
        }
        protected void btnupload_Click(object sender, EventArgs e)
        {
            fillattachment();
            AsyncFileUpload1.ClearAllFilesFromPersistedStore();
            txtattachmenttitle.Text = "";
        }

        protected void repattachment_ItemDataBound(object sender, DataListCommandEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {

                LinkButton lb = (LinkButton)repattachment.FindControl("linkdownload");
                if (lb != null)
                    ScriptManager.GetCurrent(this).RegisterAsyncPostBackControl(lb);


            }
        }

        /// <summary>
        /// Create table
        /// </summary>
        protected void createtable()
        {
            DataRow itemdr;
            DataColumn itemdc;
            DataTable itemtable = new DataTable();
            itemdc = new DataColumn("nid", System.Type.GetType("System.String"));
            itemtable.Columns.Add(itemdc);
            itemdc = new DataColumn("title", System.Type.GetType("System.String"));
            itemtable.Columns.Add(itemdc);
            itemdc = new DataColumn("originalfilename", System.Type.GetType("System.String"));
            itemtable.Columns.Add(itemdc);
            itemdc = new DataColumn("uploadfilename", System.Type.GetType("System.String"));
            itemtable.Columns.Add(itemdc);
            itemdc = new DataColumn("attachid", System.Type.GetType("System.String"));
            itemtable.Columns.Add(itemdc);
            Session["itemtable"] = itemtable;


        }

        protected void repattachment_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "delete")
            {

                string nid = e.CommandArgument.ToString();

                DataTable itemtable = (DataTable)Session["itemtable"];
                for (int i = 0; i < itemtable.Rows.Count; i++)
                {
                    if (itemtable.Rows[i]["nid"].ToString() == nid)
                    {

                        itemtable.Rows.RemoveAt(i);

                        if (itemtable.Rows[i]["attachid"].ToString() != "")
                        {
                            objserver.nid = itemtable.Rows[i]["attachid"].ToString();
                            objserver.action = "deletefile";
                            objserver.ServerLogDetail();

                        }
                        i = i - 1;


                    }

                }
                fillattachment();
            }

        }

        /// <summary>
        /// Fill attachment grid
        /// </summary>
        public void fillattachment()
        {
            DataTable itemtable = (DataTable)Session["itemtable"];
            if (itemtable.Rows.Count > 0)
            {
                repattachment.Visible = true;
                repattachment.DataSource = itemtable;
                repattachment.DataBind();
            }
            else
            {
                repattachment.Visible = false;
            }
        }



        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]

        public static string geteventdesc(string eventid, string companyid)
        {
            clsServer objserver = new clsServer();
            DataSet ds = new DataSet();
            string msg = "";
            msg = "failure";
            objserver.action = "getdescription";
            objserver.eventid = eventid;
            objserver.companyid = companyid;

            try
            {
                ds = objserver.ServerLogDetail();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    msg = ds.Tables[0].Rows[0]["description"].ToString();
                }
                return msg;
            }
            catch (Exception ex)
            {
                //msg = ex.Message;
                return msg;
            }

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getbackupdesc(string serverid, string companyid)
        {
            clsServer objserver = new clsServer();
            DataSet ds = new DataSet();
            string msg = "";
            msg = "failure";
            objserver.action = "getbackupdescription";
            objserver.serverid = serverid;
            objserver.companyid = companyid;

            try
            {
                ds = objserver.ServerLog();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    msg = ds.Tables[0].Rows[0]["BackupDescription"].ToString();
                }
                return msg;
            }
            catch (Exception ex)
            {
                //msg = ex.Message;
                return msg;
            }

        }


        //---------------------EDIT-------------------
        protected void fillgrid()
        {
            objserver.action = "select";
            objserver.logid = hidserverlogid.Value;
            objserver.serverid = "";
            objserver.logtype = "";
            ds = objserver.ServerLogDetail();
            if (ds.Tables[0].Rows.Count > 0)
            {
                dgnews.DataSource = ds;
                dgnews.DataBind();
                headlogentry.Visible = true;
            }
            else
            {
                dgnews.DataSource = null;
                dgnews.DataBind();
                headlogentry.Visible = false;
            }
        }

        /// <summary>
        /// event fires when clicks to Edit/Delete in List
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dgnews_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "del")
            {
                objserver.action = "delete";
                objserver.nid = e.CommandArgument.ToString();
                objserver.ServerLogDetail();
                fillgrid();
            }


        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dgnews_RowDataBound(object sender, GridViewRowEventArgs e)
        {

            if (e.Row.RowType == DataControlRowType.DataRow && (e.Row.RowState == DataControlRowState.Edit || e.Row.RowState == (DataControlRowState.Alternate | DataControlRowState.Edit)))
            {
                DropDownList ddllog = (DropDownList)e.Row.FindControl("ddllog");
                DropDownList ddlseverity = (DropDownList)e.Row.FindControl("ddlseverity");

                DropDownList ddlaction = (DropDownList)e.Row.FindControl("ddlaction");

                ddllog.Text = DataBinder.Eval(e.Row.DataItem, "Logtype").ToString();
                ddlseverity.Text = DataBinder.Eval(e.Row.DataItem, "Severity").ToString();
                ddlaction.Text = DataBinder.Eval(e.Row.DataItem, "ActionPerformed").ToString();

            }
        }

        protected void dgnews_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            dgnews.EditIndex = -1;
            fillgrid();
        }
        protected void dgnews_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {

            GridViewRow row = (GridViewRow)dgnews.Rows[e.RowIndex];

            //DropDownList dropproject = (DropDownList)row.FindControl("dropproject");
            //DropDownList droptask = (DropDownList)row.FindControl("droptask");
            //TextBox txthours = (TextBox)row.FindControl("txthours");
            //CheckBox chkbillable = (CheckBox)row.FindControl("chkbillable1");
            int index = row.RowIndex;
            objserver.logtype = ((DropDownList)dgnews.Rows[index].FindControl("ddllog")).Text;
            objserver.eventid = ((TextBox)dgnews.Rows[index].FindControl("txt_eventid")).Text;
            objserver.description = ((TextBox)dgnews.Rows[index].FindControl("txt_description")).Text;
            objserver.severity = ((DropDownList)dgnews.Rows[index].FindControl("ddlseverity")).Text;
            objserver.actionperform = ((DropDownList)dgnews.Rows[index].FindControl("ddlaction")).Text;
            objserver.remark = ((TextBox)dgnews.Rows[index].FindControl("txt_remark")).Text;
            objserver.nid = ((HtmlInputHidden)dgnews.Rows[index].FindControl("hidnid1")).Value;
            objserver.action = "insert";
            objserver.ServerLogDetail();

            dgnews.EditIndex = -1;
            fillgrid();
        }
        protected void dgnews_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            GridViewRow row = (GridViewRow)dgnews.Rows[e.RowIndex];
            //objserver.action = "delete";
            //objserver.nid = ((HtmlInputHidden)row.FindControl("hidnid")).Value;
            //objserver.ManageTimesheet();
            //fillgrid();

        }
        protected void dgnews_RowEditing(object sender, GridViewEditEventArgs e)
        {
            dgnews.EditIndex = e.NewEditIndex;
            fillgrid();
        }


    }
}