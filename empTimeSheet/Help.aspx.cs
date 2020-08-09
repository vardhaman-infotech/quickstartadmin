using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script.Services;
using System.Data;

namespace empTimeSheet
{
    public partial class Help : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();

        DataSet ds = new DataSet();
        DataSet ds1 = new DataSet();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (Request.QueryString["keyword"] != null)
                {
                    txtkeywords.Text = Request.QueryString["keyword"].ToString();
                }
                //Call method to bind help topics
                fillleft("");

                if (ds.Tables[0].Rows.Count > 0)
                {
                    //If there exists any help topics, then bind detail of first help topic at right side of window
                    fillright(ds.Tables[0].Rows[0]["nid"].ToString(), "");

                }
                if (Request.QueryString["q"] != null && Request.QueryString["q"].ToString() != "" && Request.QueryString["id"] != null)
                {
                    hidid.Value = Request.QueryString["id"].ToString();
                    txtkeywords.Text = Request.QueryString["q"].ToString();
                    fillright(Request.QueryString["id"].ToString(), Request.QueryString["q"].ToString());
                }

            }

        }
        /// <summary>
        /// Bind help topics
        /// </summary>
        public void fillleft(string category)
        {
            objda.id = "";
            objda.action = "select";
            objda.name = category;
            ds = objda.HelpMaster();
            Repeater1.DataSource = ds;
            Repeater1.DataBind();


        }

        /// <summary>
        /// Bind selected topic's description
        /// </summary>
        /// <param name="nid"></param>
        /// <param name="topic"></param>
        public void fillright(string nid, string topic)
        {
            objda.id = nid;
            hidid.Value = nid;
            objda.name = topic;
            objda.action = "selectbytopic";

            ds = objda.HelpMaster();
            if (ds.Tables[0].Rows.Count > 0)
            {
                Repeater2.DataSource = ds;
                Repeater2.DataBind();
                Repeater2.Visible = true;
                divnodatafound.InnerHtml = "";
                divnodatafound.Visible = false;
            }
            else
            {
                Repeater2.Visible = false;
                divnodatafound.InnerHtml = "No result found"; divnodatafound.Visible = true;
            }
            activaterow();

        }
        protected void Repeater1_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {

        }
        protected void activaterow()
        {
            for (int i = 0; i < Repeater1.Items.Count; i++)
            {
                HtmlGenericControl helpli = (HtmlGenericControl)Repeater1.Items[i].FindControl("helpli");
                LinkButton libtn = (LinkButton)Repeater1.Items[i].FindControl("lbtnli");
                HtmlInputHidden hidnid = (HtmlInputHidden)Repeater1.Items[i].FindControl("hidnid");

                if (hidnid.Value == hidid.Value)
                {
                    if (i % 2 == 0)
                    {
                        //libtn.Attributes.Add("class", "active");
                        helpli.Attributes.Add("class", "even active");
                    }
                    else
                    {
                        helpli.Attributes.Add("class", "odd active");

                    }
                }
                else
                {
                    if (i % 2 == 0)
                        helpli.Attributes.Add("class", "even");
                    else
                        helpli.Attributes.Add("class", "odd");

                }
            }
        }
        protected void Repeater1_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "view")
            {

                string[] arr = e.CommandArgument.ToString().Split(';');
                Response.Redirect("Help.aspx?q=" + arr[1] + "&id=" + arr[0]);
                //txtkeywords.Text = "";
                ////fillright(e.CommandArgument.ToString(), "");

            }
        }
        protected void Repeater2_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "view")
            {
                string[] arr = e.CommandArgument.ToString().Split(';');

                fillright(arr[0], "");

                fillleft(arr[1]);
                //txtkeywords.Text = "";
            }

        }

        /// <summary>
        /// Method to show intellisense when user search any topic
        /// </summary>
        /// <param name="prefixText"></param>
        /// <returns></returns>
        [ScriptMethod()]
        [WebMethod]
        public static List<string> getTopic(string prefixText)
        {
            DataAccess objda = new DataAccess();
            DataSet ds1 = new DataSet();
            objda.action = "selectbytopic";
            objda.name = prefixText;
            ds1 = objda.HelpMaster();
            List<string> items = new List<string>();
            if (ds1.Tables[0].Rows.Count > 0)
            {
                for (int i = 0; i < ds1.Tables[0].Rows.Count; i++)
                {
                    items.Add(ds1.Tables[0].Rows[i]["topic"].ToString().ToLower());

                }

            }
            var returnList = items.Where(item => item.Contains(prefixText.ToLower())).ToList();
            returnList.Sort();
            return returnList;

        }

        /// <summary>
        /// Search keyword
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            Response.Redirect("Help.aspx?q=" + txtkeywords.Text + "&id=");
            //fillright("", );
        }
    }
}