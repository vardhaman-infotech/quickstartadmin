using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.Web.Script.Serialization;
using System.Collections.Generic;
using System.Text.RegularExpressions;

public class GeneralMethod
{

    public static int addminutes = -749;
    public GeneralMethod()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public string serilizeinJson(DataTable dt)
    {
        JavaScriptSerializer serializer = new JavaScriptSerializer();

        List<Dictionary<string, object>> list = new List<Dictionary<string, object>>();

        foreach (DataRow row in dt.Rows)
        {
            Dictionary<string, object> dict = new Dictionary<string, object>();

            foreach (DataColumn col in dt.Columns)
            {
                dict[col.ColumnName] = row[col];
            }
            list.Add(dict);
        }



        return serializer.Serialize(list);

    }
    // C# Function to Convert Json string to C# Datatable
    public DataTable deserializetoDataTable(string jsonString)
    {
        DataTable dt = new DataTable();
        dt = (DataTable)Newtonsoft.Json.JsonConvert.DeserializeObject(jsonString, (typeof(DataTable)));

        return dt;
    }

  
    #region FillCombo
    /// <summary>
    /// Purpose	:	Get Called whenever the Page is Loaded
    /// </summary>
    /// <param name="ddlr">Reference of the Dropdownlist control</param>
    /// <param name="dt">DataTable</param>
    /// <param name="displayField">This is a string</param>
    /// <param name="valuefeild">This is a string</param>
    /// <param name="all">Boolean Value</param>		
    public void FillCombo(DropDownList ddl, DataTable dt, string displayField, string valueField, bool all)
    {
        try
        {
            ListItem ddlItem;
            ddl.Items.Clear();

            ddl.DataSource = dt;
            ddl.DataTextField = displayField;
            ddl.DataValueField = valueField;
            ddl.DataBind();

            if (all == true)
            {
                ddlItem = new ListItem("All", "0");
                ddl.Items.Add(ddlItem);
            }

        }
        catch
        {
        }

    }

    public void FillCombo(DropDownList ddl, DataTable dt, string displayField, string valueField)
    {
        ddl.DataSource = dt;
        ddl.DataTextField = displayField;
        ddl.DataValueField = valueField;
        ddl.DataBind();
    }
    public void FillChek(CheckBoxList ddl, DataTable dt, string displayField, string valueField)
    {
        ddl.DataSource = dt;
        ddl.DataTextField = displayField;
        ddl.DataValueField = valueField;
        ddl.DataBind();
    }

    public void fillActiveInactiveDDL(DataTable dt, DropDownList ddl, string TextField, string ValueField)
    {

        if (dt != null && dt.Rows.Count > 0)
        {
            foreach (DataRow row in dt.Rows)
            {
                ListItem item = new ListItem(row["" + TextField + ""].ToString(), row["" + ValueField + ""].ToString());
                if (row["activeStatus"].ToString().ToLower() == "block") //if active, then red
                {
                    item.Attributes.Add("class", "inactiveoption");
                    item.Attributes.Add("title", "Inactive Employee");
                }
                ddl.Items.Add(item);
            }
        }
    }

    public void fillActiveInactiveCheck(DataTable dt, CheckBoxList ddl, string TextField, string ValueField)
    {

        if (dt != null && dt.Rows.Count > 0)
        {
            foreach (DataRow row in dt.Rows)
            {
                ListItem item = new ListItem(row["" + TextField + ""].ToString(), row["" + ValueField + ""].ToString());
                if (row["activeStatus"].ToString().ToLower() == "block") //if active, then red
                {
                    item.Attributes.Add("class", "inactiveoption");
                    item.Attributes.Add("title", "Inactive Employee");
                }
                ddl.Items.Add(item);
            }
        }
    }

    #endregion

    #region validate user

    public void validatelogin()
    {
        if ((HttpContext.Current.Session["userid"] == null) || (HttpContext.Current.Session["usertype"] == null) || (HttpContext.Current.Session["companyid"] == null) || (HttpContext.Current.Session["username"] == null) || (HttpContext.Current.Session["chatstatus"] == null) || (HttpContext.Current.Session["designation"] == null) || (HttpContext.Current.Session["profilephoto"] == null) || (HttpContext.Current.Session["branch"] == null) || (HttpContext.Current.Session["companyaddress"] == null) || (HttpContext.Current.Session["timeid"] == null) || (HttpContext.Current.Session["timediff"] == null) || (HttpContext.Current.Session["emptimediff"] == null))
            //Set Cookies
            if (HttpContext.Current.Request.Cookies["quickstart"] != null && HttpContext.Current.Request.Cookies["quickstart"]["branch"] != null && HttpContext.Current.Request.Cookies["quickstart"]["companyaddress"] != null &&
                HttpContext.Current.Request.Cookies["quickstart"]["timeid"] != null && HttpContext.Current.Request.Cookies["quickstart"]["timediff"] != null && HttpContext.Current.Request.Cookies["quickstart"]["emptimediff"] != null)
            {
                HttpContext.Current.Session["userid"] = HttpUtility.UrlDecode(HttpContext.Current.Request.Cookies["quickstart"]["userid"].ToString());
                HttpContext.Current.Session["username"] = HttpUtility.UrlDecode(HttpContext.Current.Request.Cookies["quickstart"]["username"].ToString());
                HttpContext.Current.Session["companyname"] = HttpUtility.UrlDecode(HttpContext.Current.Request.Cookies["quickstart"]["companyname"].ToString());
                HttpContext.Current.Session["companyaddress"] = HttpUtility.UrlDecode(HttpContext.Current.Request.Cookies["quickstart"]["companyaddress"].ToString());
                HttpContext.Current.Session["companyid"] = HttpContext.Current.Request.Cookies["quickstart"]["companyid"].ToString();
                HttpContext.Current.Session["usertype"] = HttpUtility.UrlDecode(HttpContext.Current.Request.Cookies["quickstart"]["usertype"].ToString());
                HttpContext.Current.Session["deptid"] = HttpContext.Current.Request.Cookies["quickstart"]["deptid"].ToString();
                HttpContext.Current.Session["chatstatus"] = HttpContext.Current.Request.Cookies["quickstart"]["chatstatus"].ToString();
                HttpContext.Current.Session["designation"] = HttpUtility.UrlDecode(HttpContext.Current.Request.Cookies["quickstart"]["designation"].ToString());
                HttpContext.Current.Session["profilephoto"] = HttpUtility.UrlDecode(HttpContext.Current.Request.Cookies["quickstart"]["profilephoto"].ToString());
                HttpContext.Current.Session["branch"] = HttpUtility.UrlDecode(HttpContext.Current.Request.Cookies["quickstart"]["branch"].ToString());
                HttpContext.Current.Session["timeid"] = HttpUtility.UrlDecode(HttpContext.Current.Request.Cookies["quickstart"]["timeid"].ToString());
                HttpContext.Current.Session["timediff"] = HttpUtility.UrlDecode(HttpContext.Current.Request.Cookies["quickstart"]["timediff"].ToString());
                HttpContext.Current.Session["emptimediff"] = HttpUtility.UrlDecode(HttpContext.Current.Request.Cookies["quickstart"]["emptimediff"].ToString());

                if (HttpContext.Current.Request.Cookies["quickstart"]["livedemo"] != null)
                {
                    HttpContext.Current.Session["livedemo"] = HttpUtility.UrlDecode(HttpContext.Current.Request.Cookies["quickstart"]["livedemo"].ToString());
                }


            }
            else
            {
                
                if (HttpContext.Current.Request.QueryString["requestid"] != null)
                    HttpContext.Current.Response.Redirect("logout.aspx?requestid=" + HttpContext.Current.Request.QueryString["requestid"].ToString());
                else if (HttpContext.Current.Request.QueryString["appointmentid"] != null)
                    HttpContext.Current.Response.Redirect("logout.aspx?appointmentid=" + HttpContext.Current.Request.QueryString["appointmentid"].ToString());
                else
                    HttpContext.Current.Response.Redirect("logout.aspx");
            }


    }
    public void validateClientlogin()
    {
        if ((HttpContext.Current.Session["clientloginid"] == null) || (HttpContext.Current.Session["clientname"] == null) || (HttpContext.Current.Session["clientcompanyname"] == null) || (HttpContext.Current.Session["companyname"] == null) || (HttpContext.Current.Session["companyid"] == null))
        {
            HttpContext.Current.Response.Redirect("logout.aspx");

        }
    }
    public DataTable filterTable(string id, DataTable dt)
    {
        DataView dv = new DataView(dt);
        dv.RowFilter = id;
        return dv.ToTable();

    }
    #endregion





    private int getpagesize()
    {
        return 100;

    }
    public void fillpage(int num, GridView dgnews, DropDownList droppage)
    {
        int pagessize = getpagesize();
        droppage.Items.Clear();
        int totalpage = 0, mod = 0, minpage = 0;
        if (num <= pagessize)
        {
            totalpage = 1;
            if (num > 0)
            {
                minpage = 1;
            }
            ListItem li = new ListItem(minpage.ToString() + "-" + num.ToString(), "0");
            droppage.Items.Insert(0, li);
        }
        else
        {
            totalpage = num / pagessize;
            mod = num % pagessize;
            if (mod != 0)
                totalpage = totalpage + 1;

            for (int i = 0; i < totalpage; i++)
            {
                int start = (i * pagessize) + 1;
                int end = (i + 1) * pagessize;
                if (i == totalpage - 1)
                {
                    if (mod != 0)
                        end = start + mod - 1;
                }
                ListItem li = new ListItem(start.ToString() + "-" + end.ToString(), i.ToString());
                droppage.Items.Insert(i, li);

            }
            droppage.SelectedIndex = dgnews.PageIndex;
        }


    }
    public static string getEmpDate()
    {
        return System.DateTime.Now.AddMinutes(Convert.ToDouble(HttpContext.Current.Session["emptimediff"])).ToString("MM/dd/yyyy");
    }
    public static string getLocalDate()
    {
        return System.DateTime.Now.AddMinutes(Convert.ToDouble(HttpContext.Current.Session["timediff"])).ToString("MM/dd/yyyy");
    }
    public static string getDateMMMddyyyy()
    {
        return System.DateTime.Now.AddMinutes(Convert.ToDouble(HttpContext.Current.Session["timediff"])).ToString("MMM dd,yyyy");
    }
    public static string getdatetime()
    {
        return System.DateTime.Now.AddMinutes(Convert.ToDouble(HttpContext.Current.Session["timediff"])).ToString();
    }
    public static string getLocalDateTime()
    {
        return System.DateTime.Now.AddMinutes(Convert.ToDouble(HttpContext.Current.Session["timediff"])).ToString("MM/dd/yyyy HH:mm");
    }
    public static string getLocalDateTimeAMPM()
    {
        return System.DateTime.Now.AddMinutes(Convert.ToDouble(HttpContext.Current.Session["timediff"])).ToString("MM/dd/yyyy hh:mm tt");
    }
    public static string getRegionDateTime()
    {
        return System.DateTime.Now.ToString("MMM dd,yyyy HH:mm");
    }
    public static string getmonthnamebyNum(int num)
    {
        string name = "";
        switch (num)
        {
            case 1:
                name = "Jan";
                break;

            case 2:
                name = "Feb";
                break;
            case 3:
                name = "Mar";
                break;
            case 4:
                name = "Apr";
                break;
            case 5:
                name = "May";
                break;
            case 6:
                name = "Jun";
                break;
            case 7:
                name = "Jul";
                break;
            case 8:
                name = "Aug";
                break;
            case 9:
                name = "Sep";
                break;
            case 10:
                name = "Oct";
                break;
            case 11:
                name = "Nov";
                break;
            case 12:
                name = "Dec";
                break;

            default:
                name = "Jan";
                break;

        }
        return name;

    }
    public static string getfilicon(string linktype, string ext)
    {
        string name = "";
        if (linktype.ToLower() == "file")
        {
            switch (ext)
            {
                case ".DOC":
                    name = "word.png";
                    break;
                case ".DOCX":
                    name = "word.png";
                    break;
                case ".LOG":
                    name = "text.png";
                    break;
                case ".RTF":
                    name = "text.png";
                    break;
                case ".TXT":
                    name = "text.png";
                    break;

                case ".PPT":
                    name = "ppt.png";
                    break;

                case ".PPTX":
                    name = "ppt.png";
                    break;

                case ".CSV":
                case ".XLS":
                case ".XLSX":
                    name = "excel.png";
                    break;

                case ".AIF":
                case ".IFF":
                case ".MP3":
                case ".WAV":
                case ".WMA":
                    name = "audio.png";
                    break;

                case ".FLV":
                case ".3GP":
                case ".ASX":
                case ".MP4":
                case ".MPG":
                case ".RM":
                case ".SWF":
                case ".VOB":
                case ".WMV":
                    name = "video.png";
                    break;

                case ".BMP":
                    name = "bmp.png";
                    break;

                case ".GIF":
                case ".JPG":
                case ".PNG":
                case ".PSD":
                case ".TIF":
                    name = "Image.png";
                    break;
                case ".PDF":
                    name = "pdf.png";
                    break;

                case ".RAR":
                    name = "rar.png";
                    break;

                case ".ZIP":
                    name = "zip.png";
                    break;
                default:
                    name = "unknown.png"; break;


            }

        }
        else
            name = "folder.png";
        return name;

    }




    public static String Number2String(int number, bool isCaps)
    {

        Char c = (Char)((isCaps ? 65 : 97) + (number - 1));

        return c.ToString();

    }

    public static void alert(Page page, string msg)
    {
        ScriptManager.RegisterStartupScript(page, page.GetType(), "temp", "<script type='text/javascript'>alert('" + msg + "');</script>", false);

    }
    public static void runJs(Page page, string strjs)
    {
        ScriptManager.RegisterStartupScript(page, page.GetType(), "temp", "<script type='text/javascript'>" + strjs + "</script>", false);

    }


}

public class DateRange
{
    public string fromdate;
    public string todate;
    public string datetext;


    public static DateRange getLastDates(string type)
    {
        DateTime date1 = new DateTime(), date2 = new DateTime();

        var today = Convert.ToDateTime(GeneralMethod.getdatetime());
        DayOfWeek weekStart = DayOfWeek.Monday; // or Sunday, or whenever
        DateTime startingDate = today;


        switch (type)
        {
            case "Quarterly":
                int quarterNumber = (today.Month - 1) / 3 + 1;
                date1 = new DateTime(today.Year, (quarterNumber - 1) * 3 + 1, 1);
                date2 = date1.AddMonths(3).AddDays(-1);
                break;
            case "Monthly":
                var month = new DateTime(today.Year, today.Month, 1);
                date1 = month.AddMonths(-1);
                date2 = month.AddDays(-1);
                break;
            case "Weekly":

                while (startingDate.DayOfWeek != weekStart)
                    startingDate = startingDate.AddDays(-1);

                date1 = startingDate.AddDays(-7);
                date2 = startingDate.AddDays(-1);
                break;
            case "Biweekly":

                while (startingDate.DayOfWeek != weekStart)
                    startingDate = startingDate.AddDays(-1);

                date1 = startingDate.AddDays(-14);
                date2 = startingDate.AddDays(-1);
                break;

            case "Current Month":

                date1 = new DateTime(today.Year, today.Month, 1);
                date2 = date1.AddMonths(1).AddDays(-1);
                break;

            case "Next Month":
                date1 = new DateTime(today.AddMonths(1).Year, today.AddMonths(1).Month, 1);
                date2 = date1.AddMonths(1).AddDays(-1);
                break;
            case "Current Week":

                date1 = today.AddDays(-(int)today.DayOfWeek);
                date2 = date1.AddDays(7).AddSeconds(-1);
                break;
            case "Next Week":

                date1 = today.AddDays(7);
                date1 = date1.AddDays(-(int)date1.DayOfWeek);
                date2 = date1.AddDays(7).AddSeconds(-1);
                break;

        }

        var result = new DateRange
        {
            fromdate = date1.ToString("MM/dd/yyyy"),
            todate = date2.ToString("MM/dd/yyyy")
        };
        return result;
    }

    public static DateRange getLastDates(string type, string fromdate, string todate)
    {
        DateTime date1 = new DateTime(), date2 = new DateTime();

        var today = Convert.ToDateTime(GeneralMethod.getdatetime());
        DayOfWeek weekStart = DayOfWeek.Monday; // or Sunday, or whenever
        DateTime startingDate = today;
        var month = new DateTime(today.Year, today.Month, 1);
        string str = "";
       
        switch (type)
        {
            case "Custom":
                date1 = Convert.ToDateTime(fromdate);
                date2 = Convert.ToDateTime(todate);
                str = "Report From " + date1.ToString("MM/dd/yyyy") + " To " + date2.ToString("MM/dd/yyyy");
                break;
            case "Quarterly":
                int quarterNumber = (today.Month - 1) / 3 + 1;
                date1 = new DateTime(today.Year, (quarterNumber - 1) * 3 + 1, 1);
                date2 = date1.AddMonths(3).AddDays(-1);
                str = "Quarterly Report (From " + date1.ToString("MM/dd/yyyy") + " To " + date2.ToString("MM/dd/yyyy") + ")";
                break;
            case "Monthly":
               
                date1 = month.AddMonths(-1);
                date2 = month.AddDays(-1);
                str = "Monthly Report (From " + date1.ToString("MM/dd/yyyy") + " To " + date2.ToString("MM/dd/yyyy") + ")";
                break;
            case "Weekly":
                while (startingDate.DayOfWeek != weekStart)
                    startingDate = startingDate.AddDays(-1);

                date1 = startingDate.AddDays(-7);
                date2 = startingDate.AddDays(-1);
                str = "Weekly Report (From " + date1.ToString("MM/dd/yyyy") + " To " + date2.ToString("MM/dd/yyyy") + ")";
                break;
            case "Biweekly":

                while (startingDate.DayOfWeek != weekStart)
                    startingDate = startingDate.AddDays(-1);

                date1 = startingDate.AddDays(-14);
                date2 = startingDate.AddDays(-1);
                str = "Biweekly Report (From " + date1.ToString("MM/dd/yyyy") + " To " + date2.ToString("MM/dd/yyyy") + ")";
                break;
            case "Current Month":
                date1 = new DateTime(today.Year, today.Month, 1);
                date2 = date1.AddMonths(1).AddDays(-1);
                str = "Current Month Report (From " + date1.ToString("MM/dd/yyyy") + " To " + date2.ToString("MM/dd/yyyy") + ")";
                break;
            case "Next Month":
                date1 = new DateTime(today.AddMonths(1).Year, today.AddMonths(1).Month, 1);
                date2 = date1.AddMonths(1).AddDays(-1);
                str = "Next Month Report (From " + date1.ToString("MM/dd/yyyy") + " To " + date2.ToString("MM/dd/yyyy") + ")";
                break;
            case "Current Week":

                date1 = today.AddDays(-(int)today.DayOfWeek);
                date2 = date1.AddDays(7).AddSeconds(-1);
                str = "Current Week Report (From " + date1.ToString("MM/dd/yyyy") + " To " + date2.ToString("MM/dd/yyyy") + ")";
                break;
            case "Next Week":

                date1 = today.AddDays(7);
                date1 = date1.AddDays(-(int)date1.DayOfWeek);
                date2 = date1.AddDays(7).AddSeconds(-1);
                str = "Next Week Report (From " + date1.ToString("MM/dd/yyyy") + " To " + date2.ToString("MM/dd/yyyy") + ")";
                break;

            case "Today":


                date1 = today;
                date2 = today;
                str = "Report From " + date1.ToString("MM/dd/yyyy") + " To " + date2.ToString("MM/dd/yyyy") + "";
                break;
            case "All":
                date1 = Convert.ToDateTime("01/01/1970");
                //date2 = today.AddYears(2);
                date2 = today;
                str = "Report Date: All";
                break;
            case "AsOf":
                date1 = Convert.ToDateTime("01/01/1970");
                date2 = Convert.ToDateTime(todate);
                str = "Report As of " + date2.ToString("MM/dd/yyyy");
                break;
            case "AsOfLastMonth":
                date1 = Convert.ToDateTime("01/01/1970");                         
                date2 = month.AddDays(-1);
                str = "Report As of  Last Month (" + date2.ToString("MM/dd/yyyy")+")";
                break;
            case "AsOfLastYear":
                date1 = Convert.ToDateTime("01/01/1970");
                date2 = Convert.ToDateTime("12/31/"+(today.Year-1).ToString()+"");
                str = "Report As of  Last Year (" + date2.ToString("MM/dd/yyyy") + ")";
                break;
            case "ThisWeektoDate":
                date1 = today.AddDays(-(int)today.DayOfWeek);
                date2 =today;
                str = "This Week to Date Report (From " + date1.ToString("MM/dd/yyyy") + " To " + date2.ToString("MM/dd/yyyy") + ")";
                break;
            case "ThisMonthtoDate":
                date1 = new DateTime(today.Year, today.Month, 1);
                date2 = today;
                str = "This Month to Date Report (From " + date1.ToString("MM/dd/yyyy") + " To " + date2.ToString("MM/dd/yyyy") + ")";
                break;
            case "ThisYeartoDate":
                date1 = Convert.ToDateTime("01/01/" + (today.Year).ToString() + "");
                date2 = today;
                str = "This Year to Date Report (From " + date1.ToString("MM/dd/yyyy") + " To " + date2.ToString("MM/dd/yyyy") + ")";
                break;
            case "LastYeartoDate":
                date1 = Convert.ToDateTime("01/01/" + (today.Year-1).ToString() + "");
                date2 = today;
                str = "This Year to Date Report (From " + date1.ToString("MM/dd/yyyy") + " To " + date2.ToString("MM/dd/yyyy") + ")";
                break;
            case "This Calendar Year":
                date1 = Convert.ToDateTime("01/01/" + (today.Year).ToString() + "");
                date2 =  Convert.ToDateTime("12/31/" + (today.Year).ToString() + "");;
                str = "This Year Report (From " + date1.ToString("MM/dd/yyyy") + " To " + date2.ToString("MM/dd/yyyy") + ")";
                break;

            case "Last Calendar Year":
                date1 = Convert.ToDateTime("01/01/" + (today.Year-1).ToString() + "");
                date2 = Convert.ToDateTime("12/31/" + (today.Year-1).ToString() + ""); ;
                str = "Last Year Report (From " + date1.ToString("MM/dd/yyyy") + " To " + date2.ToString("MM/dd/yyyy") + ")";
                break;
          

        }

        var result = new DateRange
        {
            fromdate = date1.ToString("MM/dd/yyyy"),
            todate = date2.ToString("MM/dd/yyyy"),
            datetext=str
        };
        return result;
    }
}