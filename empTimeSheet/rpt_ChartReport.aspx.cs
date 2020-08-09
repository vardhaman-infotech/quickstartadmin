using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.Services;
using System.Web.Script.Services;
using System.Text;

namespace empTimeSheet
{
    public partial class rpt_ChartReport : System.Web.UI.Page
    {
        ClsTimeSheet objts = new ClsTimeSheet();
        DataSet ds = new DataSet();
        GeneralMethod objgen = new GeneralMethod();
        DataAccess objda = new DataAccess();
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                if (!objda.checkUserInroles("111"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
                fillyear();
            }

        }
        public void fillyear()
        {
            int j = 0;
            for (int i = (DateTime.Now.AddYears(4)).Year; i >= (DateTime.Now.AddYears(-10)).Year; i--)
            {
                dropyear.Items.Insert(j, new ListItem(i.ToString(), i.ToString()));
            }
            dropyear.Text = DateTime.Now.Year.ToString();

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getChartReport(string action,string year,string companyid)
        {
            DataAccess objda = new DataAccess();
            GeneralMethod objgen = new GeneralMethod();

            DataSet ds = new DataSet();
            string msg = "failure";
            try
            {

                objda.id = Convert.ToDateTime(GeneralMethod.getLocalDate()).Year.ToString();
                objda.action = action;
                objda.id = year;
                objda.company = companyid;
                ds = objda.getchartreport();
                msg = objgen.serilizeinJson(ds.Tables[0]);
                return msg;
            }
            catch (Exception ex)
            {
                //msg = ex.Message.ToString();
                return msg;
            }

        }
    }
}