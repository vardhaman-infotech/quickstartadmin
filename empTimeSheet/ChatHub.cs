using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.SignalR;
using System.Threading.Tasks;
using System.Collections.Concurrent;
using SignalRChat.Common;
using System.Data;
namespace empTimeSheet
{
    public class ChatHub : Hub
    {
        #region Data Members
        
        
        static List<UserDetail> ConnectedUsers = new List<UserDetail>();
        static List<MessageDetail> CurrentMessage = new List<MessageDetail>();

        #endregion

        #region Methods

        /// <summary>
        /// This method fills the List of users
        /// Call GeneralMethod class function to get list of all users
        /// </summary>

        public static void fillallusers()
        {
           
            if (ConnectedUsers.Count == 0)
            {
                DataSet ds = new DataSet();
                DataAccess objda = new DataAccess();
                ds = objda.getallUsers();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                    {
                        ConnectedUsers.Add(new UserDetail { ConnectionId = "", UserName = ds.Tables[0].Rows[i]["fullname"].ToString(), UserId = ds.Tables[0].Rows[i]["nid"].ToString(), Status = "0", Designation = ds.Tables[0].Rows[i]["designation"].ToString(), Profileimg = ds.Tables[0].Rows[i]["imgurl"].ToString(), companyid = ds.Tables[0].Rows[i]["companyid"].ToString().ToUpper(), chatstatus = ds.Tables[0].Rows[i]["chatstatus"].ToString() });


                    }

                }
            }

        }
        public void changeuserchatstatus(string userid,string companyid, string status)
        {
            var id = Context.ConnectionId;
            var item = ConnectedUsers.FirstOrDefault(x => x.UserId == userid && x.companyid == companyid);
            if (item != null)
            {

                item.chatstatus = status;
            }
            DataAccess objda = new DataAccess();
            objda.loginid = userid;
            objda.company = companyid;
            objda.status = status;
            objda.changechatStatus();

            Clients.All.changechatstatus(id,userid, status);
        }
        public void Connect(string userName, string userid, string designation, string profileimg, string companyid,string chatstatus)
        {
            var id = Context.ConnectionId;         
            Groups.Add(id, companyid);  

            if (ConnectedUsers.Count(x => x.ConnectionId == id && x.companyid == companyid) == 0)
            {

                if (ConnectedUsers.Count(x => x.UserId == userid) == 0)
                    ConnectedUsers.Add(new UserDetail { ConnectionId = id, UserName = userName, UserId = userid, companyid = companyid, Status = "1", Designation = designation, Profileimg = profileimg,chatstatus=chatstatus });
                else
                {
                    var item = ConnectedUsers.FirstOrDefault(x => x.UserId == userid);
                    if (item != null)
                    {
                        item.Status = "1";
                        item.UserName = userName;
                        item.Profileimg = profileimg;
                        item.Designation = designation;
                        item.ConnectionId = id;
                        item.chatstatus = chatstatus;
                    }

                }

                // send to caller
                var userlist = from a in ConnectedUsers

                               where (a.companyid == companyid.ToUpper())
                               orderby a.UserName
                               select a
                                ;
                Clients.Caller.onConnected(id, userName, userlist);
                           

                // send to all except caller client
                Clients.Group(companyid).onNewUserConnected(id, userName, userid, "1", designation, profileimg,chatstatus);

            }

          
            
        }

        public void IsTyping(string toUserId, string fromuserid, string fromusername)
        {
            // do stuff with the html
            SayWhoIsTyping(toUserId,fromuserid,fromusername); //call the function to send the html to the other clients
        }

        public void SayWhoIsTyping(string toUserId, string fromuserid, string fromusername)
        {
            var touser = ConnectedUsers.FirstOrDefault(x => x.UserId == toUserId);
            string html = fromusername;

            Clients.Client(touser.ConnectionId).sayWhoIsTyping(html, fromuserid);
        }

        /// <summary>
        /// Send messages to all users
        /// </summary>
        /// <param name="userName"></param>
        /// <param name="message"></param>
        public void SendMessageToAll(string userName, string message)
        {
            // store last 100 messages in cache
            removeMessagefromCache();

            // Broad cast message
            Clients.All.messageReceived(userName, message);
        }

        //public void SendPrivateMessage(string toUserId, string message)
        //{

        //    string fromUserId = Context.ConnectionId;

        //    var toUser = ConnectedUsers.FirstOrDefault(x => x.ConnectionId == toUserId);
        //    var fromUser = ConnectedUsers.FirstOrDefault(x => x.ConnectionId == fromUserId);

        //    if (toUser != null && fromUser != null)
        //    {
        //        // send to 
        //        Clients.Client(toUserId).sendPrivateMessage(fromUserId, fromUser.UserName, message);

        //        // send to caller user
        //        Clients.Caller.sendPrivateMessage(toUserId, fromUser.UserName, message);
        //    }

        //}

        /// <summary>
        /// Send message to a single user
        /// </summary>
        /// <param name="toUserId"></param>
        /// <param name="message"></param>
        /// 
        public string getdatetime()
        {
            return Convert.ToDateTime(DateTime.UtcNow.ToString()).ToString("hh:mm tt", new System.Globalization.CultureInfo("en-US"));
        }
        public string getdate()
        {
            return Convert.ToDateTime(DateTime.UtcNow.ToString()).ToString("MM/dd/yyyy hh:mm tt", new System.Globalization.CultureInfo("en-US"));
        }

        public void SendPrivateMessage(string toUserId, string message)
        {

            string fromConnectionID = Context.ConnectionId;
          

            var touser = ConnectedUsers.FirstOrDefault(x => x.UserId == toUserId);
            var fromuser = ConnectedUsers.FirstOrDefault(x => x.ConnectionId == fromConnectionID);
          
            int nid = 1;
            if (CurrentMessage.Count() > 0)
            {
                var item = CurrentMessage.OrderByDescending(i => i.id).FirstOrDefault();
                nid = item.id + 1;
            }
            if (touser != null && fromuser != null)
            {

                CurrentMessage.Add(new MessageDetail { UserID = fromuser.UserId, UserName = fromuser.UserName, Message = message, touserid = touser.UserId, Date = Convert.ToDateTime(getdatetime()), id = nid, status = 0, companyid = fromuser.companyid.ToString() });

                removeMessagefromCache();

                // send to 
                Clients.Client(touser.ConnectionId).sendPrivateMessage(fromuser.ConnectionId, fromuser.UserId, fromuser.UserName, message, getdate());

                // send to caller user
                Clients.Caller.sendPrivateMessage(touser.ConnectionId, toUserId, fromuser.UserName, message, getdate());


            }

        }

        /// <summary>
        /// Fill old message to chat windows (if any)
        /// </summary>
        /// <param name="touserid"></param>
        public void filloldmessage(string touserid)
        {
            string fromConnectionID = Context.ConnectionId;
            var touser = ConnectedUsers.FirstOrDefault(x => x.UserId == touserid);
            var fromuser = ConnectedUsers.FirstOrDefault(x => x.ConnectionId == fromConnectionID);

            //List<NewMessage> ConnectedUsers = new List<NewMessage>();

            // List<Student> students = GetStudents();

            var item = from a in CurrentMessage

                       where (a.companyid==fromuser.companyid.ToString() && a.UserID == fromuser.UserId.ToString() && a.touserid == touser.UserId.ToString()) || (a.UserID == touser.UserId.ToString() && a.touserid == fromuser.UserId.ToString())
                       orderby a.Date
                       select a;

            List<UserChatt.Common.NewMessage> msg = new List<UserChatt.Common.NewMessage>();
            foreach (var value in item)
            {
                msg.Add(new UserChatt.Common.NewMessage { UserID = value.UserID, UserName = value.UserName, Message = value.Message, Date = value.Date.ToString("MM/dd/yyyy hh:mm tt", new System.Globalization.CultureInfo("en-US")),companyid=fromuser.companyid });

            }

            //Clients.Caller.fillusermessage(touserid, CurrentMessage);
            Clients.Client(fromConnectionID).fillUserMessage(touserid, msg);
        }
      
        public override System.Threading.Tasks.Task OnDisconnected()
        {
            DataTable dt = new DataTable();
            DataSet ds = new DataSet();
            DataAccess objbal = new DataAccess();
            dt.Columns.Add("UserID", typeof(string));
            dt.Columns.Add("touserid", typeof(string));
            dt.Columns.Add("Message", typeof(string));
            dt.Columns.Add("Date", typeof(string));
            dt.Columns.Add("companyid", typeof(string));
            dt.Columns.Add("id", typeof(int));


            var msg = from a in CurrentMessage

                      where (a.status == 0)
                      orderby a.id
                      select a

                     ;
            if (msg != null)
            {
                if (msg.Count() > 0)
                {
                    foreach (var val in msg)
                    {
                        DataRow dr = dt.NewRow();
                        dr["UserID"] = val.UserID;
                        dr["touserid"] = val.touserid;
                        dr["Message"] = val.Message;
                        dr["Date"] = val.Date.ToString();
                        dr["id"] = val.id;
                        dr["companyid"] = val.companyid;
                        dt.Rows.Add(dr);
                    }
                    // When disconnects Insert all chat messages to Database
                    ds = objbal.InsertChat(dt);
                    if (ds.Tables.Count > 0)
                    {
                        if (ds.Tables[0].Rows.Count > 0)
                        {
                            foreach (var val in msg)
                            {
                                var item1 = CurrentMessage.FirstOrDefault(x => x.id == val.id);
                                item1.status = 1;
                            }


                        }

                    }

                }

            }


            var item = ConnectedUsers.FirstOrDefault(x => x.ConnectionId == Context.ConnectionId);

            if (item != null)
            {
                if (ConnectedUsers.Count > 50)
                {
                    ConnectedUsers.Remove(item);

                }
                else
                {
                    item.Status = "0";

                }
                var id = Context.ConnectionId;
                Groups.Remove(id, item.companyid);
                Clients.Group(item.companyid.ToString()).onUserDisconnected(item.UserId, item.UserName);

            }

            return base.OnDisconnected();
        }


        #endregion

        #region private Messages

        //Clear cache
        private void removeMessagefromCache()
        {
            // CurrentMessage.Add(new MessageDetail { UserName = userName, Message = message });

            if (CurrentMessage.Count > 400)
                CurrentMessage.RemoveAt(0);
        }

        #endregion
    }
}