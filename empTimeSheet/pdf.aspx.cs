
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


using iTextSharp.text;
using iTextSharp.text.pdf;
using iTextSharp.tool.xml;
using iTextSharp.tool.xml.html;
using iTextSharp.tool.xml.parser;
using iTextSharp.tool.xml.pipeline.css;
using iTextSharp.tool.xml.pipeline.end;
using iTextSharp.tool.xml.pipeline.html;
namespace empTimeSheet
{
    public partial class pdf : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["ctrl"] != null)
            {
                print();
            }
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
        public void print()
        {
            string rpthtml = bindheader();
            // string rpthtml = "";
            string filename = System.DateTime.UtcNow.ToFileTimeUtc() + ".pdf";
            string html = readHTML();
            html = rpthtml + html;
            HttpContext.Current.Response.Clear();
            HttpContext.Current.Response.ContentType = "application/pdf";

            ////define pdf filename
            HttpContext.Current.Response.AddHeader("content-disposition", "attachment; filename=" + filename);


            //Generate PDF
            using (var document = new Document(iTextSharp.text.PageSize.B4))
            {
            

                //define output control HTML
                var memStream = new MemoryStream();
                TextReader xmlString = new StringReader(html);

                PdfWriter writer = PdfWriter.GetInstance(document, memStream);

                //open doc
                document.Open();

                // register all fonts in current computer
                FontFactory.RegisterDirectories();

                // Set factories
                var htmlContext = new HtmlPipelineContext(null);
                htmlContext.SetTagFactory(Tags.GetHtmlTagProcessorFactory());

                // Set css
                ICSSResolver cssResolver = XMLWorkerHelper.GetInstance().GetDefaultCssResolver(false);
              


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



                // Export
                IPipeline pipeline = new CssResolverPipeline(cssResolver,
                                                             new HtmlPipeline(htmlContext,
                                                                              new PdfWriterPipeline(document, writer)));
                var worker = new XMLWorker(pipeline, true);
                var xmlParse = new XMLParser(true, worker);
                xmlParse.Parse(xmlString);
                xmlParse.Flush();

                document.Close();
                document.Dispose();

                HttpContext.Current.Response.BinaryWrite(memStream.ToArray());
            }

            HttpContext.Current.Response.End();
            HttpContext.Current.Response.Flush();
        }



    }
}
