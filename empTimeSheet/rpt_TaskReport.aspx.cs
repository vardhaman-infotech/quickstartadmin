using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using System.Data;
using System.Xml.Linq;
using System.Web;
using System.Linq;
using System.Text;
using Microsoft.Reporting.WebForms;
using System.Xml;
using System.IO;


namespace empTimeSheet
{
    public partial class rpt_TaskReport : System.Web.UI.Page
    {
        string pa = HttpContext.Current.Server.MapPath("~/xmlColumn.xml");
        XDocument xmlDoc=new XDocument();
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds1 = new DataSet();
        DataSet ds = new DataSet();
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!objda.checkUserInroles("79"))
            {
                Response.Redirect("UserDashboard.aspx");
            }
            if (!Page.IsPostBack)
            {
                filldepartment();
                fillclient();


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
        public void fillclient()
        {
            DataTable dtColum = new DataTable();
            dtColum = GetLeftPanel("tasklist");
            if (dtColum.Rows.Count > 0)
            {
                dropclient.DataSource = dtColum;
                dropclient.DataTextField = "name";
                dropclient.DataValueField = "Value";
                dropclient.DataBind();


            }

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
            
            hidsearchdrpclient.Value = getchkval(dropclient);
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

                //List<ColumnReport> lstColumnes = new List<ColumnReport>();
                objts.empid = "";
                objts.clientid = "";
                objts.taskid = "";
                objts.Status = "";
                objts.CreatedBy = "";
                objts.managerId = "";
                objts.from = "";
                objts.to = "";
                objts.projectid = "";
                objts.isbillable = "";
                objts.isbilled = "";
                objts.taskStatus = "";
                objts.type = "";
                objts.id = dropdeptsearch.Text;
                objts.action = "taskmaster";

            //objts.action = "select";
            //objts.companyId = Session["companyid"].ToString();
            //objts.nid = "";
            //objts.deptID = dropdeptsearch.Text;
            //objts.type = "Task";
            
            //ds = objts.ManageTasks();
                ds = objts.timesheetrdlcreport();

            if (ds.Tables[0].Rows.Count > 0)
            {

                divnodata.Visible = false;

                divreport.Visible = true;
                ReportViewer1.LocalReport.ReportPath = p + "\\task\\TaskListrdlc.rdlc";
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
                string strvalue = getchkval(dropclient);
                if (strvalue == "")
                    strvalue = "taskCode,taskname,description,costrate,billrate,bhours,isbillable,tax,";

                param[2] = new ReportParameter("companyphone", strccontact, true);
                param[3] = new ReportParameter("SelectColumn", strvalue, true);


                ReportDataSource rds1 = new ReportDataSource("DataSet1", ds.Tables[0]);


                this.ReportViewer1.LocalReport.DataSources.Clear();

                this.ReportViewer1.LocalReport.EnableExternalImages = true;

                this.ReportViewer1.LocalReport.DataSources.Add(rds1);
                this.ReportViewer1.LocalReport.SetParameters(param);


                this.ReportViewer1.LocalReport.Refresh();



                ReportViewer1.LocalReport.DisplayName = "Task Managment Report";
            }
            else
            {
                divnodata.Visible = true;
                divreport.Visible = false;

            }
                //GestorReport gi = new GestorReport(p + "\\task\\TaskListrdlc.rdlc", "Dades", "capsCol", "valCol", lstColumnes);
                //XmlDocument reportAjustat = gi.Configurar();

                //// Configurem el report al viewer...: Report, paràmetres i datasets
                //ReportViewer1.LocalReport.ReportPath = string.Empty;
                //ReportViewer1.LocalReport.DataSources.Clear();

                //// A. The dataset with the data   
                //ReportViewer1.LocalReport.DataSources.Add(new ReportDataSource("DataSet1", ds.Tables[0]));

                //// B. THE REPORT
                //byte[] rdlBytes = Encoding.UTF8.GetBytes(reportAjustat.OuterXml);
                //MemoryStream stream = new MemoryStream(rdlBytes);
                //ReportViewer1.LocalReport.LoadReportDefinition(stream);

                //// C. Some parameters
                //ReportParameter[] parametres = new ReportParameter[1];
                //parametres[0] = new ReportParameter("VisibilitatColumnaAfortunat", "S", true);
                //ReportViewer1.LocalReport.SetParameters(parametres);

                ////// Refresquem i avall que fa baixada!
                ////ReportViewer1.RefreshReport();
                ////ReportViewer1.Show();


              
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
    public class GestorReport
    {
        private string _pathReport, _nomTaula, _prefixColTitol, _prefixColValor;
        private List<ColumnReport> _lstColumnes;

        public GestorReport(string pathReport, string tableName, string prefixColTitle, string prefixColValue, List<ColumnReport> lstColumnes)
        {
            _pathReport = pathReport;
            _nomTaula = tableName;
            _lstColumnes = lstColumnes;
            _prefixColTitol = prefixColTitle;
            _prefixColValor = prefixColValue;
        }

        public XmlDocument Configurar()
        {
            // 1. Obtenim el report
            XmlDocument objXmlDocument = new XmlDocument();
            objXmlDocument.Load(_pathReport);
            XmlNamespaceManager mgr = new XmlNamespaceManager(objXmlDocument.NameTable);
            string uri = "http://schemas.microsoft.com/sqlserver/reporting/2008/01/reportdefinition";
            mgr.AddNamespace("df", uri);

            // Val, ara obtenim totes les columnes on hi ha els tamanys!
            XmlNodeList wCols = objXmlDocument.SelectNodes(String.Format("/df:Report/df:Body/df:ReportItems/df:Tablix[@Name='{0}']/df:TablixBody/df:TablixColumns/df:TablixColumn/df:Width", _nomTaula), mgr);

            IEnumerator<ColumnReport> it = _lstColumnes.GetEnumerator();
            for (int i = 0; i < _lstColumnes.Count; i++)
            {
                ColumnReport ci = _lstColumnes[i];

                // Som-hi... què hem de fer?
                // 0. Configurar l'amplada
                // Això va per ordre...segons la i on estem ja l'hi podem anar endinyant l'amplada
                wCols[i].InnerText = ci.Width + "cm";

                // Ara anem a per les coses serioses
                XmlNode campTitol = objXmlDocument.SelectSingleNode(String.Format("/df:Report/df:Body/df:ReportItems/df:Tablix[@Name='{0}']/df:TablixBody/df:TablixRows/df:TablixRow/df:TablixCells/df:TablixCell/df:CellContents/df:Textbox[@Name='{1}{2}']", _nomTaula, _prefixColTitol, ci.ColPosition), mgr);
                XmlNode campValor = objXmlDocument.SelectSingleNode(String.Format("/df:Report/df:Body/df:ReportItems/df:Tablix[@Name='{0}']/df:TablixBody/df:TablixRows/df:TablixRow/df:TablixCells/df:TablixCell/df:CellContents/df:Textbox[@Name='{1}{2}']", _nomTaula, _prefixColValor, ci.ColPosition), mgr);

                // 1. Configurem la visibilitat
                if (!ci.Visible)
                {
                    XmlElement nVis = objXmlDocument.CreateElement("Visibility", uri);
                    XmlElement nHid = objXmlDocument.CreateElement("Hidden", uri);
                    nHid.InnerText = "true";
                    nVis.AppendChild(nHid);
                    campTitol.AppendChild(nVis);

                    wCols[i].InnerText = "0cm";
                }


                if (!ci.Visible)
                {
                    //XmlNode campVisibilitatValor = campValor.SelectSingleNode("./df:Visibility/df:Hidden", mgr);
                    XmlElement nVis = objXmlDocument.CreateElement("Visibility", uri);
                    XmlElement nHid = objXmlDocument.CreateElement("Hidden", uri);
                    nHid.InnerText = "true";
                    nVis.AppendChild(nHid);
                    campValor.AppendChild(nVis);

                    wCols[i].InnerText = "0cm";
                }

                // 2. Configurar el títol de la columna (es podría fer per paràmetres però sudem)
                XmlNode campTitolValor = campTitol.SelectSingleNode("./df:Paragraphs/df:Paragraph/df:TextRuns/df:TextRun/df:Value", mgr);
                campTitolValor.InnerText = ci.ColumnTitle;

                // 3. Configurar la fòrmula
                XmlNode campValorValor = campValor.SelectSingleNode("./df:Paragraphs/df:Paragraph/df:TextRuns/df:TextRun/df:Value", mgr);
                campValorValor.InnerText = ci.FieldFormula;
            }

            return objXmlDocument;
        }
    }
    public class ColumnReport : IComparable
    {
        private string _titolColumna, _formulaColumna;
        private int _ample, _posicio;
        private bool _visible;

        public string ColumnTitle
        {
            get { return _titolColumna; }
            set { _titolColumna = value; }
        }

        public string FieldFormula
        {
            get { return _formulaColumna; }
            set { _formulaColumna = value; }
        }

        public int Width
        {
            get { return _ample; }
            set { _ample = value; }
        }

        public int ColPosition
        {
            get { return _posicio; }
            set { _posicio = value; }
        }

        public bool Visible
        {
            get { return _visible; }
            set { _visible = value; }
        }

        #region Miembros de IComparable

        public int CompareTo(object obj)
        {
            return this.ColPosition.CompareTo(((ColumnReport)obj).ColPosition);
        }

        #endregion

    }
}