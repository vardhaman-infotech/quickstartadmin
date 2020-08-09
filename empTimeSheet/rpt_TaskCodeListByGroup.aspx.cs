using Microsoft.Reporting.WebForms;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

namespace empTimeSheet
{
    public partial class rpt_TaskCodeListByGroup : System.Web.UI.Page
    {
        string pa = HttpContext.Current.Server.MapPath("~/xmlColumn.xml");
        XDocument xmlDoc = new XDocument();
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds1 = new DataSet();
        DataSet ds = new DataSet();
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!objda.checkUserInroles("80"))
            {
                Response.Redirect("UserDashboard.aspx");
            }
            if (!Page.IsPostBack)
            {
                filldepartment();
               


            }

        }

        public void filldepartment()
        {
            objda.id = "";
            objda.name = "";
            objda.company = Session["companyid"].ToString();
            objda.action = "select";
            ds = objda.department();



            dropdeptsearch.DataSource = ds;
            dropdeptsearch.DataTextField = "department";
            dropdeptsearch.DataValueField = "nid";
            dropdeptsearch.DataBind();

            ListItem li = new ListItem("--All Department--", "");

            dropdeptsearch.Items.Insert(0, li);
            dropdeptsearch.SelectedIndex = 0;
        }
       
        public DataTable GetLeftPanel(string tablename)
        {
            xmlDoc = XDocument.Load(pa.ToString());
            IEnumerable<XElement> elem_list = from elem in xmlDoc.Descendants("table")
                                              where elem.Attribute("ID").Value == tablename.ToString()
                                              select elem;
            XElement[] elem_Array = elem_list.ToArray();
            DataTable dt = new DataTable(tablename);
            dt.Columns.Add("name");
            dt.Columns.Add("value");

            //XAttribute[] arr_Nodes = null;

            foreach (XElement elem in elem_Array)
            {
                for (int i = 0; i < elem.Element("LeftPanel").Elements("Button").Count(); i++)
                {
                    DataRow ro = dt.NewRow();
                    ro["name"] = elem.Element("LeftPanel").Elements("Button").Attributes("Name").ToArray()[i].Value.ToString();
                    ro["value"] = elem.Element("LeftPanel").Elements("Button").Attributes("value").ToArray()[i].Value.ToString();
                    dt.Rows.Add(ro);
                }

            }

            return dt;
        }
        private string getchkval(CheckBoxList chk)
        {
            StringBuilder sb = new StringBuilder();
            for (var i = 0; i < chk.Items.Count; i++)
            {
                if (chk.Items[i].Selected)
                {
                    sb.Append(chk.Items[i].Value + ",");
                }
            }

            return sb.ToString();
        }
        protected void searchdata()
        {

           
            fillgrid();


        }
        protected void fillgrid()
        {


            f_ReportLoad();

        }
        private void f_ReportLoad()
        {
            try
            {
                string p = Server.MapPath("rdlcreport");
                string strccontact = "";

               
                objts.empid = "";
                objts.clientid = "";
                objts.taskid = "";
                objts.Status = dropTaskStatus.Text;
                objts.CreatedBy = "";
                objts.managerId = "";
                objts.from = txtfromdate.Text;
                objts.to = txttodate.Text;
                objts.projectid = "";
                objts.isbillable =dropbillable.SelectedValue;
                objts.isbilled = dropbilled.SelectedValue;
                objts.taskStatus = dropTaskStatus.SelectedValue;
                objts.type = droptasktype.SelectedValue;
                objts.id = dropdeptsearch.Text;
                objts.taskType = "";
                objts.action = "TaskCodeListbyGroup";

                
                ds = objts.timesheetrdlcreport();





                if (ds.Tables[0].Rows.Count > 0)
                {
                    divnodata.Visible = false;

                    divreport.Visible = true;
                    ReportViewer1.LocalReport.ReportPath = p + "\\task\\taskcodelistbygrouprdlc.rdlc";
                    ReportParameter[] param = new ReportParameter[4];



                    param[0] = new ReportParameter("companyname", Session["companyname"].ToString(), true);
                    param[1] = new ReportParameter("companyaddress", Session["companyaddress"].ToString(), true);

                    if (ds.Tables[1].Rows.Count > 0)
                    {
                        if (ds.Tables[1].Rows[0]["phone"].ToString() != "")
                            strccontact += "Tel: " + ds.Tables[1].Rows[0]["phone"].ToString() + " ";
                        if (ds.Tables[1].Rows[0]["fax"].ToString() != "")
                            strccontact += "Fax: " + ds.Tables[1].Rows[0]["fax"].ToString() + " ";
                        if (ds.Tables[1].Rows[0]["email"].ToString() != "")
                            strccontact += "<br/>" + ds.Tables[1].Rows[0]["email"].ToString() + " ";
                        if (ds.Tables[1].Rows[0]["website"].ToString() != "")
                            strccontact += "<br/>" + ds.Tables[1].Rows[0]["website"].ToString() + " ";

                    }
                    param[2] = new ReportParameter("companyphone", strccontact, true);
                    string imagepath = Server.MapPath("images");
                    param[3] = new ReportParameter("ImgPath", "file:\\" + imagepath, true);


                    ReportDataSource rds1 = new ReportDataSource("DataSet1", ds.Tables[0]);


                    this.ReportViewer1.LocalReport.DataSources.Clear();

                    this.ReportViewer1.LocalReport.EnableExternalImages = true;

                    this.ReportViewer1.LocalReport.DataSources.Add(rds1);
                    this.ReportViewer1.LocalReport.SetParameters(param);


                    this.ReportViewer1.LocalReport.Refresh();



                    ReportViewer1.LocalReport.DisplayName = "Group Activity Code Master File";
                }
                else
                {
                    divnodata.Visible = true;
                    divreport.Visible = false;

                }

            }
            catch (Exception ex)
            {
            }

        }
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            searchdata();
        }
    }
   
   
}