using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Text;

namespace empTimeSheet.DataClasses.BAL
{
    public class ClsToDoListBAL
    {
        public string todayHTML(DataTable dt, string strhead, string strpre)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(@"<div class='task-hding'>" + strhead + "</div> <div class='clear'></div>");
            if (dt.Rows.Count > 0)
            {
               
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    sb.Append(@" <div class='todolist-box' id='todo_" + strpre + "_" + i.ToString() + "' data-todoid='" + dt.Rows[i]["nid"].ToString() + "'> <div id='todo_" + strpre + "_" + i.ToString() + "_text' class='todo-text todo-text-" + dt.Rows[i]["taskStatus"].ToString() + "'><p title='Click here to edit'>" + dt.Rows[i]["notes"].ToString() + "</p></div>");

                    sb.Append(@"<div class='divtodo-ctrl'><ul><li><input type='hidden' id='todo_" + strpre + "_" + i.ToString() + "_hiddate' class='tohiddate' value='" + dt.Rows[i]["date1"].ToString() + "' /> <img src='images/todo-calendar-gray.png' alt='' class='todoimgdate' title='Change date'/></li> <li> <div id='todo_" + strpre + "_" + i.ToString() + "_divstatus' title='Change task status' class='status_box_inner status-box todo-" + dt.Rows[i]["taskStatus"].ToString() + "'></div> <div class='todo_statusDrop' id='todo_" + strpre + "_" + i.ToString() + "_divstatus_drop'> <ul> <li>  <a data-status='Default'> <div class='status-box todo-Default'></div>Default</a></li> <li> <a data-status='Pending'><div class='status-box todo-Pending'></div>  Pending</a> </li> <li><a data-status='Complete'><div class='status-box todo-Complete'></div> Complete</a> </li> <li><a data-status='Cancelled'><div class='status-box todo-Cancelled'></div> Cancelled</a></li> <li> <a data-status='Delete'> <div class='status-box'> <img src='images/delete.png' /></div> Delete</a></li> </ul></div></li></ul> </div></div> <div class='clear'></div>");


                   
                }

            }
            else
            {
                sb.Append(@"<div class='notodaytask'>No task exists.</div>");
            }
            return sb.ToString();

        }

        public string upComingHTML(DataTable dt, string strhead, string strpre)
        {
            StringBuilder sb = new StringBuilder();
           
            if (dt.Rows.Count > 0)
            {
                sb.Append(@"<div class='task-hding'>" + strhead + "</div> <div class='clear'></div>");
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    sb.Append(@"<fieldset class='todolist-box' id='todo_" + strpre + "_" + i.ToString() + "' data-todoid='" + dt.Rows[i]["nid"].ToString() + "'><div class='date-round date-round-" + dt.Rows[i]["taskStatus"].ToString() + " todoimgdate' title='Change date'>" + dt.Rows[i]["theDay"].ToString().ToUpper() + "</div> <input type='hidden' id='todo_" + strpre + "_" + i.ToString() + "_hiddate' class='tohiddate' value='" + dt.Rows[i]["date1"].ToString() + "' /><legend>" + dt.Rows[i]["theMonth"].ToString() + "</legend><div id='todo_" + strpre + "_" + i.ToString() + "_text' class='col-sm-12 col-md-11 todo-text todo-text-" + dt.Rows[i]["taskStatus"].ToString() + "'><p title='Click here to edit'>" + dt.Rows[i]["notes"].ToString() + "</p></div> <div class='col-sm-12 col-md-1 f_right'><div id='todo_" + strpre + "_" + i.ToString() + "_divstatus' title='Change task status' class='status_box_inner status-box todo-" + dt.Rows[i]["taskStatus"].ToString() + "'></div> <div id='todo_" + strpre + "_" + i.ToString() + "_divstatus_drop' class='todo_statusDrop'> <ul> <li> <a data-status='Default'> <div class='status-box todo-Default'></div>Default</a> </li><li> <a data-status='Pending'> <div class='status-box todo-Pending'></div>Pending</a></li><li> <a data-status='Complete'><div class='status-box todo-Complete'></div>Complete</a> </li> <li> <a data-status='Cancelled'><div class='status-box todo-Cancelled'></div> Cancelled</a></li><li> <a data-status='Delete'> <div class='status-box'><img src='images/delete.png' /> </div>Delete</a> </li> </ul> </div> </div></fieldset> <div class='clear'></div>");



                }

            }
           
            return sb.ToString();

        }
    }
}