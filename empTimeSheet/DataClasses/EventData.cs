using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.Collections.Generic;

/// <summary>
/// Summary description for eventData
/// </summary>
public class Event
{
    public string NID { get; set; }
    public string EventID { get; set; }
    public string LayerID { get; set; }
    public string EventName { get; set; }
    public string StartDate { get; set; }
    public string EndDate { get; set; }
    public string Color { get; set; }
    public string Userid { get; set; }
    public string StartTime { get; set; }
    public string EndTime { get; set; }
    public string Description { get; set; }
    public string createdbyName { get; set; }
    public string eventtype { get; set; }
    public string eventrepeat { get; set; }
    public string Location { get; set; }
    public string AllDayEvent { get; set; }   public string recType { get; set; }
      public string classname { get; set; }
      public string daynum { get; set; }
      public string monthnum { get; set; }
      public DateTime date1 { get; set; }
    public string clientid { get; internal set; }
    public string empid { get;   set; }
}

