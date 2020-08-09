using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using iTextSharp.text.html.simpleparser;
using iTextSharp.text;

using iTextSharp.text.pdf;


using System.IO;

namespace empTimeSheet
{
    public partial class InvoicePreview : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsTimeSheet objts = new ClsTimeSheet();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds = new DataSet();
        ClsAdmin objadmin = new ClsAdmin();
        public string strcurrency = "$";
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {
                if (!objda.checkUserInroles("37"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
                //Request.QueryString["invoiceno"] != null && 
                if (Request.QueryString["invoiceid"] != null)
                {
                    hidnid.Value = Request.QueryString["invoiceid"].ToString();
                    fillcurrency();
                    binddetail();
                }
            }
        }

        /// <summary>
        /// Bind currency according to current company
        /// </summary>
        protected void fillcurrency()
        {
            objadmin.action = "select";
            objadmin.nid = Session["companyid"].ToString();
            ds = objadmin.ManageCompany();
            if (ds.Tables[0].Rows.Count > 0)
            {
                strcurrency = ds.Tables[0].Rows[0]["symbol"].ToString();
            }
        }

        protected void binddetail()
        {
            objts.nid = hidnid.Value;
            objts.companyId = Session["companyid"].ToString();
            objts.action = "selectforinvoicedetailprint";
            ds = objts.GetInvoice();

            if (ds.Tables[0].Rows.Count > 0)
            {
                divinvdetail.InnerHtml = ds.Tables[0].Rows[0]["invoicedetail"].ToString();
              
            }
            if(ds.Tables[1].Rows.Count>0)
            {
                divinvdetailpage2.InnerHtml = ds.Tables[1].Rows[0]["invoicedetail"].ToString();
            }
        }

        protected void btnexportpdf_Click(object sender, EventArgs e)
        {
            //string rpthtml = bindheader("", "6");

            //Session["ctrl"] = divinvdetail;


            //string url = "printpdf.aspx";
            //string s = "window.open('" + url + "', '_blank');";

            //ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>" + s + "</script>", false);

            string filename = System.DateTime.UtcNow.ToFileTimeUtc() + ".pdf";
            Document document = new Document(PageSize.A4);
            PdfWriter writer = PdfWriter.GetInstance(document, new FileStream(Server.MapPath("~/webfile/temp/" + filename), FileMode.Create));
            document.Open();
            writer.PageEvent = new myPDFpgHandler();

            HTMLWorker hw = new HTMLWorker(document);
            string html = divinvdetail.InnerHtml.Replace("margin: 40px auto;", "margin: 0px auto;");
            StringReader sr = new StringReader(divinvdetail.InnerHtml);
            iTextSharp.tool.xml.XMLWorkerHelper.GetInstance().ParseXHtml(writer, document, sr);
            if (divinvdetailpage2.InnerHtml.Trim() != "")
            {
                document.NewPage();
                string htmlpage2 = divinvdetailpage2.InnerHtml.Replace("margin: 20px auto;", "margin: 0px auto;");
                StringReader sr1 = new StringReader(htmlpage2);
                iTextSharp.tool.xml.XMLWorkerHelper.GetInstance().ParseXHtml(writer, document, sr1);
            }
            //hw.Parse(new StringReader(HTML));
            
            document.Close();
            writer.Close();
            // ShowPdf(filename, filepath);
            PdfAction action = new PdfAction(PdfAction.PRINTDIALOG);

            string s = "window.open('webfile/temp/" + filename + "', '_blank');";

            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>" + s + "</script>", false);

        }
    }
    public class myPDFpgHandler : PdfPageEventHelper
    {
        PdfContentByte pdfContent;
        PdfTemplate template;
        protected BaseFont helv;
        BaseFont bf = null;


        public override void OnEndPage(iTextSharp.text.pdf.PdfWriter writer, iTextSharp.text.Document document)
        {
            iTextSharp.text.Phrase p1Footer = new iTextSharp.text.Phrase("Thank you for your business.\nPlease remit payment to address above", iTextSharp.text.FontFactory.GetFont("verdana", 8));
            iTextSharp.text.Phrase p1Footer1 = new iTextSharp.text.Phrase("Page " + document.PageNumber.ToString(), iTextSharp.text.FontFactory.GetFont("verdana", 8));
            //iTextSharp.text.Image imgPDF = iTextSharp.text.Image.GetInstance(HttpRuntime.AppDomainAppPath + "\\Images\\logo.gif");
            PdfPTable pdfTabFooter = new PdfPTable(1);
            PdfPCell pdfCell1 = new PdfPCell(p1Footer);
            PdfPCell pdfCell2 = new PdfPCell(p1Footer1);
            pdfCell1.Phrase.Font.Color = iTextSharp.text.BaseColor.GRAY;
            pdfCell1.HorizontalAlignment = iTextSharp.text.Element.ALIGN_CENTER;
            pdfCell2.HorizontalAlignment = iTextSharp.text.Element.ALIGN_RIGHT;
            pdfCell1.Border = 0;
            pdfCell2.Border = 0;


            pdfTabFooter.TotalWidth = document.PageSize.Width - 40;
            //pdfCell1.Width = pdfTabFooter.TotalWidth - 40;
            //pdfCell2.Width = 40;

            float[] cfWidths = new float[] { 2f };
            // pdfTabFooter.SetWidths(cfWidths);
            pdfTabFooter.AddCell(pdfCell1);
            pdfTabFooter.AddCell(pdfCell2);

            //pdfTabFooter.TotalWidth = document.PageSize.Width - 20;
            pdfTabFooter.WriteSelectedRows(0, -1, 10, pdfTabFooter.TotalHeight, writer.DirectContent);
            //pdfTabFooter.WriteSelectedRows(0, -1, 10, document.PageSize.Height - 15, writer.DirectContent);
            document.SetMargins(document.LeftMargin, document.RightMargin, document.TopMargin + 30, document.BottomMargin + 30);
            pdfContent = writer.DirectContent;
            pdfContent.MoveTo(30, document.PageSize.Height - 50);
            //pdfContent.LineTo(document.PageSize.Width - 40, document.PageSize.Height - 40);
            pdfContent.Stroke();
        }
        public override void OnStartPage(PdfWriter writer, iTextSharp.text.Document document)
        {
           // iTextSharp.text.Phrase p1Footer = new iTextSharp.text.Phrase("Thank you for your business.\nPlease remit payment to address above", iTextSharp.text.FontFactory.GetFont("verdana", 8));
           // iTextSharp.text.Phrase p1Footer1 = new iTextSharp.text.Phrase("Page " + document.PageNumber.ToString(), iTextSharp.text.FontFactory.GetFont("verdana", 8));
           // //iTextSharp.text.Image imgPDF = iTextSharp.text.Image.GetInstance(HttpRuntime.AppDomainAppPath + "\\Images\\logo.gif");
           // PdfPTable pdfTabFooter = new PdfPTable(1);
           // PdfPCell pdfCell1 = new PdfPCell(p1Footer);
           // PdfPCell pdfCell2 = new PdfPCell(p1Footer1);
           // pdfCell1.Phrase.Font.Color = iTextSharp.text.BaseColor.GRAY;
           // pdfCell1.HorizontalAlignment = iTextSharp.text.Element.ALIGN_CENTER;
           // pdfCell2.HorizontalAlignment = iTextSharp.text.Element.ALIGN_RIGHT;
           // pdfCell1.Border = 0;
           // pdfCell2.Border = 0;


           // pdfTabFooter.TotalWidth = document.PageSize.Width-40;
           // //pdfCell1.Width = pdfTabFooter.TotalWidth - 40;
           // //pdfCell2.Width = 40;

           // float[] cfWidths = new float[] { 2f };
           //// pdfTabFooter.SetWidths(cfWidths);
           // pdfTabFooter.AddCell(pdfCell1);
           // pdfTabFooter.AddCell(pdfCell2);

           // //pdfTabFooter.TotalWidth = document.PageSize.Width - 20;
           // pdfTabFooter.WriteSelectedRows(0, -1, 10, pdfTabFooter.TotalHeight, writer.DirectContent);
           // //pdfTabFooter.WriteSelectedRows(0, -1, 10, document.PageSize.Height - 15, writer.DirectContent);
           // document.SetMargins(document.LeftMargin, document.RightMargin, document.TopMargin + 30, document.BottomMargin + 30);
           // pdfContent = writer.DirectContent;
           // pdfContent.MoveTo(30, document.PageSize.Height - 50);
           // //pdfContent.LineTo(document.PageSize.Width - 40, document.PageSize.Height - 40);
           // pdfContent.Stroke();
        }

    }
}