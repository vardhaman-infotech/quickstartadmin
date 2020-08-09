using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.IO;
using System.Linq;
using System.Web;

namespace empTimeSheet.DataClasses
{
    public class ImportExcel
    {
        public string selectFromExcel(string path, DataTable dt,DataTable dtcol)
        {
            string result = "1";
             Microsoft.Office.Interop.Excel.Application app = new Microsoft.Office.Interop.Excel.Application();
            Microsoft.Office.Interop.Excel.Workbook workBook = app.Workbooks.Open(path, 0, true, 5, "", "", true, Microsoft.Office.Interop.Excel.XlPlatform.xlWindows, "\t", false, false, 0, true, 1, 0);
            Microsoft.Office.Interop.Excel.Worksheet workSheet = (Microsoft.Office.Interop.Excel.Worksheet)workBook.ActiveSheet;
           
           
          
            DataRow row;
            
            int columnCount = workSheet.UsedRange.Columns.Count;
            int rowcount = workSheet.UsedRange.Rows.Count;


            if (rowcount > 1 && columnCount>0)
            {
                for (int i = 2; i <= rowcount; i++)
                {
                    row = dt.NewRow();
                    for (int j = 0; j < dtcol.Rows.Count; j++)
                    {
                        int colnum = Convert.ToInt32(dtcol.Rows[j]["conval"]);
                      
                        object obj=((Microsoft.Office.Interop.Excel.Range)workSheet.Cells[i, colnum]).Value2;
                        string val = "";

                        double tmp;


                        if (Double.TryParse(Convert.ToString(obj), out tmp) && (dtcol.Rows[j]["colname"].ToString().ToLower() == "duedate" || dtcol.Rows[j]["colname"].ToString().ToLower() == "fyending"))
                        {

                            try
                            {
                                val = DateTime.FromOADate(Convert.ToDouble(obj)).ToString("MM/dd/yyyy");
                            }
                            catch
                            {
                                val = Convert.ToString(obj);
                            }
                            
                        }
                        else
                        {
                            val = Convert.ToString(obj);
                        }
                        row[dtcol.Rows[j]["colname"].ToString()] = val.Trim();
                    }
                    dt.Rows.Add(row);
                }

            }
            else
            {
                result = "-1";
            }
                
            app.Workbooks.Close();
            return result;
        }
    }
}