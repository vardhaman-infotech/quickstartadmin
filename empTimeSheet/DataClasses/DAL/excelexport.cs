using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Net;
using System.Collections;
using System.Drawing.Text;
using System.Text;
using System.Reflection;
using System.IO;

/// <summary>
/// Summary description for excelexport
/// </summary>
public class excelexport
{
    public excelexport()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public void generateexcelfile(DataSet ds, string filename)
    {
        int i = 0;
        string header = "", body = "";

        //create header for excelsheet
        if (ds.Tables.Count > 0)
        {
            for (i = 0; i < ds.Tables[0].Columns.Count; i++)
            {
                header = header + (char)34 + ds.Tables[0].Columns[i].ColumnName.ToString() + (char)34 + ",";
            }
            header = header.Substring(0, header.Length - 1);
        }

        //iterate into the row
        for (int k = 0; k < ds.Tables.Count; k++)
        {
            for (int j = 0; j < ds.Tables[k].Rows.Count; j++)
            {
                for (i = 0; i < ds.Tables[k].Columns.Count; i++)
                {
                    body = body + (char)34 + ds.Tables[k].Rows[j][ds.Tables[k].Columns[i].ColumnName.ToString()].ToString() + (char)34 + ",";
                }
                body = body.Substring(0, body.Length - 1) + Environment.NewLine;
            }

        }
        body = header + Environment.NewLine + body;
        downloadFile(body, filename);
    }

    public void ExportDataSetToExcel(DataSet ds, string filename)
    {
        HttpResponse response = HttpContext.Current.Response;

        // first let's clean up the response.object   
        response.Clear();
        response.Charset = "";

        // set the response mime type for excel   
        response.ContentType = "application/vnd.ms-excel";
        response.AddHeader("Content-Disposition", "attachment;filename=\"" + filename + "\"");

        // create a string writer   
        using (StringWriter sw = new StringWriter())
        {
            using (HtmlTextWriter htw = new HtmlTextWriter(sw))
            {
                // instantiate a datagrid   
                DataGrid dg = new DataGrid();
                dg.DataSource = ds.Tables[0];

                dg.DataBind();
                dg.RenderControl(htw);
                response.Write(sw.ToString());
                response.End();
            }
        }

    }
    public void ExportControlToExcel(Control dv, string filename, string fileheading)
    {
        HttpResponse response = HttpContext.Current.Response;

        // first let's clean up the response.object   
        response.Clear();
        response.Charset = "";
        int status = 0;
        // set the response mime type for excel   
        response.ContentType = "application/vnd.ms-excel";
        response.AddHeader("Content-Disposition", "attachment;filename=\"" + filename + "\"");

        // create a string writer   
        using (StringWriter sw = new StringWriter())
        {
            using (HtmlTextWriter htw = new HtmlTextWriter(sw))
            {
                // render div 
                dv.RenderControl(htw);
                if (status == 0)
                {
                    response.Write(fileheading);
                    status = 1;

                }
                response.Write(sw.ToString());
                response.End();
            }
        }

    }



    public void ExportDataTableToExcel(DataTable dtdata, string filename)
    {
        HttpResponse Response = HttpContext.Current.Response;

        Response.ClearContent();
        Response.Charset = "";
        // Response.AddHeader("content-disposition", attach);
        Response.AddHeader("Content-Disposition", "attachment;filename=\"" + filename + "\"");
        Response.ContentType = "application/msexcel";
        //Response.ContentType = "application/vnd.ms-excel";
        if (dtdata != null)
        {
            foreach (DataColumn dc in dtdata.Columns)
            {
                Response.Write(dc.ColumnName + "\t");
                //sep = ";";
            }
            Response.Write(System.Environment.NewLine);
            foreach (DataRow dr in dtdata.Rows)
            {
                for (int i = 0; i < dtdata.Columns.Count; i++)
                {
                    Response.Write(dr[i].ToString() + "\t");
                }
                Response.Write("\n");
            }
            Response.End();
        }
    }



    public bool downloadFile(string body, string fileurl)
    {
        try
        {

            StringBuilder sSchema = new StringBuilder();
            sSchema.Append("<html xmlns:v=\"urn:schemas-microsoft-com:vml\" xmlns:o=\"urn:schemas-microsoft-com:office:office\" xmlns:x=\"urn:schemas-microsoft-com:office:excel\" xmlns=\"http://www.w3.org/TR/REC-html40\"> <head><meta http-equiv=\"Content-Type\" content=\"text/html;charset=windows-1252\"><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>ExportToExcel</x:Name><x:WorksheetOptions><x:Panes></x:Panes></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head> <body>");
            sSchema.Append(body + "</body></html>");

            WebClient req = new WebClient();
            CredentialCache mycache = new CredentialCache();
            HttpResponse response = HttpContext.Current.Response;

          

            response.Clear();
            response.ClearContent();
            response.ClearHeaders();
            response.Buffer = true;
         
            response.AddHeader("Content-Disposition", "attachment;filename=\"" + fileurl + "\"");
           

            response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
           // HttpContext.Current.Response.AddHeader("content-disposition", String.Format(@"attachment;filename={0}.xlsx", sheetName.Replace(" ", "_")));
            response.ContentEncoding = System.Text.Encoding.Unicode;
            response.BinaryWrite(System.Text.Encoding.Unicode.GetPreamble());
            response.Write(sSchema);
            response.End();



           
        }
        catch (Exception ex)
        {
            Console.Write(ex.Message);
        }
        return true;
    }
    public void generateexcelfile2(DataTable dt, string filename)
    {
        int i = 0;
        string header = "", body = "";

        //create header for excelsheet

        for (i = 0; i < dt.Columns.Count; i++)
        {
            header = header + (char)34 + dt.Columns[i].ColumnName.ToString() + (char)34 + ",";
        }
        header = header.Substring(0, header.Length - 1);


        //iterate into the row

        for (int j = 0; j < dt.Rows.Count; j++)
        {
            for (i = 0; i < dt.Columns.Count; i++)
            {
                body = body + (char)34 + dt.Rows[j][dt.Columns[i].ColumnName.ToString()].ToString() + (char)34 + ",";
            }
            body = body.Substring(0, body.Length - 1) + Environment.NewLine;
        }


        body = header + Environment.NewLine + body;
        downloadFile(body, filename);
    }
    public void exportcontrolinexcel(Control ctrl, string filename)
    {


        string attachment = "attachment; filename='" + filename + "'.xls";
        HttpResponse Response = HttpContext.Current.Response;
        Response.ClearContent();

        Response.AddHeader("content-disposition", attachment);

        Response.ContentType = "application/ms-Excel";

        StringWriter sw = new StringWriter();

        HtmlTextWriter htw = new HtmlTextWriter(sw);

        ctrl.RenderControl(htw);

        Response.Write(sw.ToString());

        Response.End();


    }
    public void exportcontrolinexcel2(DataGrid ctrl, string filename)
    {

        HttpResponse Response = HttpContext.Current.Response;
        Response.AddHeader("content-disposition", "attachment;filename=MAUnpaid_CopyInstr_Details.xls");
        Response.ContentEncoding = Encoding.UTF7;
        Response.ContentType = "application/vnd.xls";
        System.IO.StringWriter stringWrite = new System.IO.StringWriter();
        System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
        ctrl.RenderControl(htmlWrite);
        Response.Write(stringWrite.ToString());
        Response.End();

    }


    /// <summary>
    /// Download file with a virtual name
    /// </summary>
    /// <param name="uploadfile"></param>
    /// <param name="downloadfile"></param>
    /// <returns></returns>
    public bool downloadVirturalfile(string uploadfile, string downloadfile, string directory)
    {
        bool status = true;

        //Location of orginal file is LIBRARY folder, Set here location of your file
        string path = HttpContext.Current.Server.MapPath(directory + "/" + uploadfile); //get physical file path from server
        string name = Path.GetFileName(path); //get file name
        string type = "";
        string ext = Path.GetExtension(path); //get file extension

        if (ext != null)
        {
            switch (ext.ToLower())
            {
                case ".mp3":
                    type = "audio/MPEG";
                    break;
                case ".wav":
                    type = "audio/x-wav";
                    break;
                case ".mp2":
                case ".mpa":
                case ".mpe":
                case ".mpeg":
                case ".mpv2":
                    type = "video/mpeg";
                    break;
                case ".avi":
                    type = "video/x-msvideo";
                    break;
                case ".htm":
                case ".html":
                    type = "text/HTML";
                    break;

                case ".txt":
                    type = "text/plain";
                    break;
                case ".png":
                    type = "image/PNG";
                    break;
                case ".gif":
                    type = "image/GIF";
                    break;
                case ".jpg":
                    type = "image/JPG";
                    break;
                case ".pdf":
                    type = "Application/pdf";
                    break;

                case ".doc":
                case ".docx":
                case ".rtf":
                    type = "Application/msword";
                    break;
                case ".xls":
                case ".xlsx":
                case ".csv":
                    type = "Application/msexcel";
                    break;
                default:
                    type = "";
                    break;
            }
        }
        downloadfile = HttpContext.Current.Server.UrlDecode(downloadfile);
        HttpContext.Current.Response.AppendHeader("content-disposition", "attachment; filename=\"" + downloadfile + "\"");

        if (type != "")
            HttpContext.Current.Response.ContentType = type;

        try
        {


            HttpContext.Current.Response.WriteFile(path);
            HttpContext.Current.Response.End(); //give POP to user for file downlaod
            status = true;
        }
        catch (Exception ex)
        {
            string str = ex.ToString();
            status = false;
        }


        return status;



    }



    public bool downloadAttachment(string uploadfile, string downloadfile)
    {
        bool status = true;

        //Location of orginal file is LIBRARY folder, Set here location of your file
        string path = HttpContext.Current.Server.MapPath("attachment/" + uploadfile); //get physical file path from server
        string name = Path.GetFileName(path); //get file name
        string type = "";
        string ext = Path.GetExtension(path); //get file extension

        if (ext != null)
        {
            switch (ext.ToLower())
            {
                case ".mp3":
                    type = "audio/MPEG";
                    break;
                case ".wav":
                    type = "audio/x-wav";
                    break;
                case ".mp2":
                case ".mpa":
                case ".mpe":
                case ".mpeg":
                case ".mpv2":
                    type = "video/mpeg";
                    break;
                case ".avi":
                    type = "video/x-msvideo";
                    break;
                case ".htm":
                case ".html":
                    type = "text/HTML";
                    break;

                case ".txt":
                    type = "text/plain";
                    break;

                case ".gif":
                    type = "image/GIF";
                    break;
                case ".jpg":
                    type = "image/JPG";
                    break;
                case ".pdf":
                    type = "Application/pdf";
                    break;

                case ".doc":
                case ".docx":
                case ".rtf":
                    type = "Application/msword";
                    break;
                case ".xls":
                case ".xlsx":
                case ".csv":
                    type = "Application/msexcel";
                    break;
                default:
                    type = "";
                    break;
            }
        }
        downloadfile = HttpContext.Current.Server.UrlDecode(downloadfile);
        HttpContext.Current.Response.AppendHeader("content-disposition", "attachment; filename=\"" + downloadfile + "\"");

        if (type != "")
            HttpContext.Current.Response.ContentType = type;

        try
        {


            HttpContext.Current.Response.WriteFile(path);
            HttpContext.Current.Response.End(); //give POP to user for file downlaod
            status = true;
        }
        catch (Exception ex)
        {
            string str = ex.ToString();
            status = false;
        }


        return status;



    }

}
