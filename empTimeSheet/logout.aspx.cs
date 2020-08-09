using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class manage_logout : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //Remove all session
        Session.Abandon();
        Response.Cookies["quickstart"].Expires = DateTime.Now;
        if (Request.QueryString["requestid"] != null)
        {
            Response.Redirect("default.aspx?action=logout&requestid=" + Request.QueryString["requestid"].ToString());

        }
        else if (Request.QueryString["appointmentid"] != null)
        {
            Response.Redirect("default.aspx?action=logout&appointmentid=" + Request.QueryString["appointmentid"].ToString());
        }
        else
        {
            Response.Redirect("default.aspx?action=logout");
        }
    }
}
