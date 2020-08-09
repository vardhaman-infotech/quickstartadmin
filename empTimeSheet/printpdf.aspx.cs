using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using iTextSharp.text.html.simpleparser;
using iTextSharp.text;

using iTextSharp.text.pdf;


using System.IO;
using System.Text.RegularExpressions;


namespace empTimeSheet
{
    public partial class printpdf : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (Session["ctrl"] == null)
            {
                return;

            }

            Control ctrl = (Control)Session["ctrl"];

            DownloadAsPDF(ctrl);
            //Response.ContentType = "application/pdf";

            //Response.AddHeader("content-disposition", "inline;filename=" + "report" + ".pdf");

            //Response.Cache.SetCacheability(HttpCacheability.NoCache);

            //StringWriter sw = new StringWriter();

            //HtmlTextWriter hw = new HtmlTextWriter(sw);

            
            //ctrl.RenderControl(hw);
            //string sb = sw.ToString().Replace("class=\"maintable\"", "style=\"font-family:Calibri;font-size:10pt;border:solid 1px #000000;max-width:800px;\"");
            //sb = sb.ToString().Replace("class=\"mainrptdiv\"", "width=\"800\" style=\"width:800px;padding:10px;\"");
            
            //StringReader sr = new StringReader(sb);
            //iTextSharp.text.Document pdfDoc = new iTextSharp.text.Document(iTextSharp.text.PageSize.A4, 0f, 0f, 0f, 0f);
            ////a6 size 5.8*4.1
            ////a7 size 4.1*2.9

            //HTMLWorker htmlparser = new HTMLWorker(pdfDoc);

            //PdfWriter.GetInstance(pdfDoc, Response.OutputStream);

            //pdfDoc.Open();
            //iTextSharp.text.html.simpleparser.StyleSheet styles = new iTextSharp.text.html.simpleparser.StyleSheet();
            //htmlparser.Parse(sr);

            //pdfDoc.Close();


            //Response.Write(pdfDoc);

            //Response.Flush();
            //Response.Clear(); 
        }
        public void DownloadAsPDF(Control dvHtml)
        {
            try
            {
                string strHtml = string.Empty;
                string filename = Session["userid"].ToString() + "_" + System.DateTime.UtcNow.ToFileTimeUtc() + ".pdf";
                string pdfFileName = Request.PhysicalApplicationPath + "\\webfile\\temp\\" + filename;

                StringWriter sw = new StringWriter();
                HtmlTextWriter hw = new HtmlTextWriter(sw);
                dvHtml.RenderControl(hw);
                StringReader sr = new StringReader(sw.ToString());
                strHtml = sr.ReadToEnd();
                sr.Close();
                if (Session["header"] != null)
                    strHtml = Session["header"].ToString() + strHtml;

                Regex reg = new Regex("<a .+?</a>", RegexOptions.IgnoreCase | RegexOptions.Singleline);
                 Regex reg1 = new Regex("<span>.+?</span>", RegexOptions.IgnoreCase | RegexOptions.Singleline); 
                strHtml = reg.Replace(strHtml, "");
               strHtml = reg1.Replace(strHtml, "");
               strHtml = strHtml.Replace("font-size:10pt", "font-size:9pt");
               strHtml = strHtml.Replace("font-size:9pt", "font-size:8pt");
                CreatePDFFromHTMLFile(strHtml, pdfFileName);

                //Response.ContentType = "application/x-download";
                //Response.AddHeader("Content-Disposition", string.Format("attachment; filename=\"{0}\"", "GenerateHTMLTOPDF.pdf"));
                //Response.WriteFile(pdfFileName);
                //Response.Flush();
                //Response.End();
                Session["css"] = null;
                Session["ctrl"] = null;
                Session["header"] = null;
                string s = "window.open('webfile/temp/" + filename + "', '_blank');window.close();";

                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>" + s + "</script>", false);
            }
            catch (Exception ex)
            {
                Response.Write(ex.Message);
            }
        }

        public void CreatePDFFromHTMLFile(string HtmlStream, string FileName)
        {
            try
            {
                object TargetFile = FileName;
                string ModifiedFileName = string.Empty;
                string FinalFileName = string.Empty;


                GeneratePDF.HtmlToPdfBuilder builder = new GeneratePDF.HtmlToPdfBuilder(iTextSharp.text.PageSize.A3);
                builder.AddStyle("td", "border:solid 1px #000000");
                GeneratePDF.HtmlPdfPage first = builder.AddPage();
                
                first.AppendHtml(HtmlStream);
                byte[] file = builder.RenderPdf();
              
                File.WriteAllBytes(TargetFile.ToString(), file);

                iTextSharp.text.pdf.PdfReader reader = new iTextSharp.text.pdf.PdfReader(TargetFile.ToString());
                ModifiedFileName = TargetFile.ToString();
                ModifiedFileName = ModifiedFileName.Insert(ModifiedFileName.Length - 4, "1");

                iTextSharp.text.pdf.PdfEncryptor.Encrypt(reader, new FileStream(ModifiedFileName, FileMode.Append), iTextSharp.text.pdf.PdfWriter.STRENGTH128BITS, "", "", iTextSharp.text.pdf.PdfWriter.AllowPrinting);
                reader.Close();
                if (File.Exists(TargetFile.ToString()))
                    File.Delete(TargetFile.ToString());
                FinalFileName = ModifiedFileName.Remove(ModifiedFileName.Length - 5, 1);
                File.Copy(ModifiedFileName, FinalFileName);
                if (File.Exists(ModifiedFileName))
                    File.Delete(ModifiedFileName);

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public override void VerifyRenderingInServerForm(Control control)
        {

            /* Verifies that the control is rendered */

        }
    }
}