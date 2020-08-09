
using iTextSharp.text;
using iTextSharp.text.pdf;
using iTextSharp.text.pdf.parser;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace empTimeSheet
{
    public partial class masksoftware : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnmask_Click(object sender, EventArgs e)
        {

            if (FileUpload1.HasFile)
            {
                string filename = "";
                string path2 = "";

                try
                {
                   
                    TimeSpan ts = DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0, 0);
                    string FormatedDateTime = Convert.ToInt64(ts.TotalSeconds).ToString();
                    string ssUniqueId = DateTime.UtcNow.ToString("fffffff");
                    string date = DateTime.Now.ToString("MMddyyyy");
                    string unid = date + "_" + ssUniqueId;

                    String extension =System.IO.Path.GetExtension(FileUpload1.PostedFile.FileName);
                   
                    filename = unid + extension;
                    Session["uploadfile"] = filename;
                    //string path = Server.MapPath(FileUpload1.PostedFile.FileName);
                    string path = AppDomain.CurrentDomain.BaseDirectory + "\\webfile\\" + filename;
                    ViewState["path"] = @"webfile/" + filename;
                    FileUpload1.SaveAs(path);
                    path = Server.MapPath("webfile/" + filename);

                    VerySimpleReplaceText(Server.MapPath("webfile/" + filename), Server.MapPath("webfile/new_" + filename));
                }
                catch (Exception ex)
                {

                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('" + ex.ToString() + "'Server error please try again later.');</script>", false);
                    return;

                }
               
            }
            else
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('Please select a file');</script>", false);
                return;
            }

        }



      
        void VerySimpleReplaceText(string OrigFile, string ResultFile)
        {
            using (var reader = new PdfReader(OrigFile))
            {
                using (var fileStream = new FileStream(ResultFile, FileMode.Create, FileAccess.Write))
                {
                    var document = new Document(reader.GetPageSizeWithRotation(1));
                    var writer = PdfWriter.GetInstance(document, fileStream);

                    document.Open();

                    for (var i = 1; i <= reader.NumberOfPages; i++)
                    {
                        document.NewPage();

                        var baseFont = BaseFont.CreateFont(BaseFont.HELVETICA_BOLD, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
                        var importedPage = writer.GetImportedPage(reader, i);

                        var contentByte = writer.DirectContent;
                        contentByte.BeginText();
                        contentByte.SetFontAndSize(baseFont, 12);

                        var multiLineString = "Sanjay\n".Split('\n');

                        foreach (var line in multiLineString)
                        {
                            contentByte.ShowTextAligned(PdfContentByte.ALIGN_LEFT, line, 200, 200, 0);
                        }

                        contentByte.EndText();
                        contentByte.AddTemplate(importedPage, 0, 0);
                    }

                    document.Close();
                    writer.Close();
                }
            }


        }

        //Create a PDF from existing and with a template




      

        //=======================================================
        //Service provided by Telerik (www.telerik.com)
        //Conversion powered by NRefactory.
        //Twitter: @telerik
        //Facebook: facebook.com/telerik
        //=======================================================

    }
}