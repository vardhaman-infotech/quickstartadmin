using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using System.IO;
using System.Web.Services;
using System.Web.Script.Services;
using System.Web.UI.HtmlControls;


namespace empTimeSheet
{
    public partial class sample : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsFile objfile = new ClsFile();
        DataSet ds = new DataSet();
        DataSet dsexcel = new DataSet();
        GeneralMethod objGen = new GeneralMethod();
        protected void Page_Load(object sender, EventArgs e)
        {
          

        }



       
    }
}