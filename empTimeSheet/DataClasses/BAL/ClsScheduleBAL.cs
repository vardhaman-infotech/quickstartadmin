using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Text;

namespace empTimeSheet.DataClasses.BAL
{
    public class ClsScheduleBAL
    {
        public string scheduleHTML(DataTable dt,string strhead,string strpre)
        {
            StringBuilder sb = new StringBuilder();
            
            if (dt.Rows.Count > 0)
            {
              
                sb.Append(@"<div class='divgroupTitle'><table> <tr> <td style='width: 39%'> <div class='divgroupTitleLeft'></div> </td> <td><div class='divgroupTitleMid'>"+strhead+@"</div> </td><td style='width: 39%'><div class='divgroupTitleRight'></div></td></tr> </table> </div>");
                for(int i=0;i<dt.Rows.Count;i++)
                {

                    string idtxt = dt.Rows[i]["nid"].ToString().Replace(",","");// strpre + i.ToString()
                    sb.Append(@"<div class='clear'></div><div class='schedulebox'><div class='col-sm-7'><div class='datebox dateviewdet' id='dateviewdet" + idtxt + "'><div class='datedetail'>  " + dt.Rows[i]["wDname"].ToString() + @" <span>" + dt.Rows[i]["theDay"].ToString() + @" </span> </div> <div class='monthdetail'>" + dt.Rows[i]["theMonth"].ToString() + @" </div> </div>");
                    sb.Append(@" <div class='detail'> <h1>" + dt.Rows[i]["clientname"].ToString() + @" </h1><p>" + dt.Rows[i]["empname"].ToString() + @" </p> </div> </div> <div class='col-sm-5 mar'><div class='col-sm-5 worktype'>");
                    if (dt.Rows[i]["scheduletype"].ToString() == "Field")
                    {
                        sb.Append("<div class='field'>Field Work</div>");
                    }
                    else
                    {
                        sb.Append("<div class='office'>Office Work</div>");
                    }

                    sb.Append(@"</div> <div class='col-sm-7'>");

                    if (dt.Rows[i]["status"].ToString() == "Confirmed by the Client")
                    {
                        sb.Append("<div class='schstatus schstatus-green linkschstatus' id='linkschstatus" + idtxt + "'  title='Set Status'>  Confirmed by the Client  <a> <img src='images/arrow_down.png' /></a></div>");
                    }
                    else if (dt.Rows[i]["status"].ToString() == "Non-Confirmed by the Client")
                    {
                        sb.Append("<div class='schstatus schstatus-away linkschstatus' id='linkschstatus" + idtxt + "'  title='Set Status'>  Non-Confirmed by the Client  <a> <img src='images/arrow_down.png' /></a></div>");
                    }
                    else if (dt.Rows[i]["status"].ToString() == "Postponed" || dt.Rows[i]["status"].ToString() == "Cancelled")
                    {
                        sb.Append("<div class='schstatus schstatus-red linkschstatus' id='linkschstatus" + idtxt + "'  title='Set Status'>  " + dt.Rows[i]["status"].ToString() + "  <a > <img src='images/arrow_down.png' /></a></div>");
                    }
                    else
                    {
                        sb.Append("<div class='schstatus linkschstatus' id='linkschstatus" + idtxt + "' title='Set Status' >  " + dt.Rows[i]["status"].ToString() + "  <a> <img src='images/arrow_down.png' /></a></div>");

                    }

                    sb.Append("</div> <div class='clear'></div><input type='hidden' id='hidschid" + idtxt + "' value='" + Convert.ToDateTime(dt.Rows[i]["date"]).ToString("MM/dd/yyyy") + "#" + dt.Rows[i]["clientid"].ToString() + "#" + dt.Rows[i]["projectid"].ToString() + "#" + dt.Rows[i]["groupid"].ToString() + "#" + dt.Rows[i]["scheduletype"].ToString() + "#" + dt.Rows[i]["status"].ToString() + "#" + dt.Rows[i]["empid"].ToString() + "'/><input type='hidden' id='hidschnid" + idtxt + "' value='" + dt.Rows[i]["nid"].ToString() + "'/><div class='col-sm-12'><div class='linkbox'>  <a id='linkschview" + idtxt + "' class='linkschview' title='View detail'> <img src='images/view.png' /></a><a id='linkschemail" + idtxt + "' class='linkschemail' title='Email this schedule'> <img src='images/email-icon.png' /></a> <a id='linkschedit" + idtxt + "' data-val='' class='linkschedit' title='Edit schedule'> <img src='images/edit.png' /></a><a id='linkschdelete" + idtxt + "' class='linkschdelete' title='Delete this record'><img src='images/delete.png' /></a>  </div> </div></div> <div class='clear'></div></div>");
                }

            }
            return sb.ToString();

        }
        public void sendreschedulemail(DataTable dt, string companyid)
        {
            ClsUser objuser = new ClsUser();
            DataAccess objda = new DataAccess();
            DataSet ds = new DataSet();
            string bccemail = "";
            string receiver = "";
            string cc = "";
            string bcc = bccemail;
            string filename = "";
            string message = "";
            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {
                    //Get users who have Access to Add Schedule to Send Email CC
                    cc = objda.GetCompanyProperty("ReceiverMail") + ",";

                    objuser.action = "selectschedulemanager";
                    objuser.companyid = companyid;
                    objuser.id = "";
                    ds = objuser.ManageEmployee();
                    if (ds != null)
                    {
                        if (ds.Tables[1].Rows.Count > 0)
                        {
                            //This will return all managers Email Id separated by comma
                            if (ds.Tables[1].Rows[0]["EmailCC"] != null)
                                cc = ds.Tables[1].Rows[0]["EmailCC"].ToString();

                        }
                    }

                    for (int i = 0; i < dt.Rows.Count; i++)
                    {

                        receiver = dt.Rows[i]["emailid"].ToString() + ",";
                        message = dt.Rows[i]["mailmessage"].ToString();
                        string subject = dt.Rows[i]["mailsubject"].ToString();
                        try
                        {
                            objda.SendEmail(receiver, subject, message, cc, bcc, filename);

                        }
                        catch
                        {

                        }
                       


                    }
                }
            }

        }
    }
}