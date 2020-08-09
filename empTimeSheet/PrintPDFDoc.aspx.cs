using iTextSharp.text;
using iTextSharp.text.html.simpleparser;
using iTextSharp.text.pdf;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace empTimeSheet
{
    public partial class PrintPDFDoc : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["ctrl"] == null && Session["ctrl1"] == null)
            {
                return;

            }



            pdfWithCSS();
            // pdfwcss();
        }
        public void pdfWithCSS()
        {
           string rpthtml = bindheader();
           // string rpthtml = "";
            string filename = System.DateTime.UtcNow.ToFileTimeUtc() + ".pdf";
            iTextSharp.text.Document doc = new iTextSharp.text.Document(iTextSharp.text.PageSize.B4
);
            iTextSharp.text.pdf.PdfWriter writer = iTextSharp.text.pdf.PdfWriter.GetInstance(doc, new FileStream(Server.MapPath("~/webfile/temp/" + filename), FileMode.Create));
            iTextSharp.tool.xml.pipeline.html.HtmlPipelineContext htmlContext = new iTextSharp.tool.xml.pipeline.html.HtmlPipelineContext(null);

            htmlContext.SetTagFactory(iTextSharp.tool.xml.html.Tags.GetHtmlTagProcessorFactory());

            //create a cssresolver to apply css
            iTextSharp.tool.xml.pipeline.css.ICSSResolver cssResolver = iTextSharp.tool.xml.XMLWorkerHelper.GetInstance().GetDefaultCssResolver(false);

            //cssResolver.AddCss("th{background-color:#1caf9a;color:#ffffff;font-size:12px;padding:4px;}", true);
            cssResolver.AddCss("th{font-size:12px;padding:4px;color:#1caf9a;}", true);
            cssResolver.AddCss("td{font-size:12px;padding:4px;}", true);

            //  cssResolver.AddCss("table{border-left: solid 1px #dadada;border-top:solid 1px #ffffff;}", true);
            cssResolver.AddCss("img{display:none;}", true);
            cssResolver.AddCss("a{color:#1caf9a;font-size:12px;}", true);
            cssResolver.AddCss("h3{font-size:15px;float:right;text-align:right;width:20%;font-waight:bold;border:2px solid #1caf9a;}", true);
            cssResolver.AddCss("h2{font-size:16px;text-align:left;font-waight:bold;color:#1caf9a;}", true);
            cssResolver.AddCss("h5{font-size:12px;}", true);

            if (Session["css"] != null)
            {
                if (Session["css"].ToString() == "invlist")
                {
                    cssResolver.AddCss(".odd td{border-bottom:solid 1px #e0e0e0;padding:4px;}", true);
                    cssResolver.AddCss(".gridheader th{border-bottom:solid 1px #e0e0e0;}", true);
                    cssResolver.AddCss(".even td{border-bottom:solid 1px #e0e0e0;padding:4px;}", true);
                    cssResolver.AddCss(".bordercss{border-left:solid 1px #e0e0e0;}", true);
                    cssResolver.AddCss(".bordercss1{border-right:solid 1px #e0e0e0;}", true);
                }
                if (Session["css"].ToString() == "timeexp")
                {

                    // cssResolver.AddCss(".aright{text-align:right;}", true);
                }


            }


            //Create and attach pipline, without pipline parser will not work on css
            iTextSharp.tool.xml.IPipeline pipeline = new iTextSharp.tool.xml.pipeline.css.CssResolverPipeline(cssResolver, new iTextSharp.tool.xml.pipeline.html.HtmlPipeline(htmlContext, new iTextSharp.tool.xml.pipeline.end.PdfWriterPipeline(doc, writer)));
          
            //Create XMLWorker and attach a parser to it
            iTextSharp.tool.xml.XMLWorker worker = new iTextSharp.tool.xml.XMLWorker(pipeline, true);
            iTextSharp.tool.xml.parser.XMLParser xmlParser = new iTextSharp.tool.xml.parser.XMLParser(worker);

            //All is well open documnet and start writing.
            doc.Open();
            string htmltext = readHTML();

            rpthtml += htmltext;

            using (StringReader reader = new StringReader(rpthtml))
            {


                //xmlParser.Parse(new StringReader(rpthtml));

                try
                {
                    xmlParser.Parse(reader);
                }
                catch
                {
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('File is too large')</script>", false);
                }

            }


            //Done! close the documnet
            doc.Close();
            Session["css"] = null;
            Session["ctrl"] = null;
            Session["header"] = null;
            string s = "window.open('webfile/temp/" + filename + "', '_blank');window.close();";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>" + s + "</script>", false);

        }

    
        public string readHTML()
        {
            string strHtml = string.Empty;
            if (Session["ctrl1"] != null)
            {
                strHtml = Session["ctrl1"].ToString();

            }
            else
            {
                Control ctrl = (Control)Session["ctrl"];


                StringWriter sw = new StringWriter();
                HtmlTextWriter hw = new HtmlTextWriter(sw);
                ctrl.RenderControl(hw);
                StringReader sr = new StringReader(sw.ToString());
                strHtml = sr.ReadToEnd();
            }
            return strHtml;
        }

        protected string bindheader()
        {
            string headerstr = "";
            if (Session["header"] != null)
                headerstr = Session["header"].ToString();





            return headerstr;
        }


        public override void VerifyRenderingInServerForm(Control control)
        {

            /* Verifies that the control is rendered */

        }
    }
}