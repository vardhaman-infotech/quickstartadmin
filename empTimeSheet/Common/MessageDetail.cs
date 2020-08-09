using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SignalRChat.Common
{
    public class MessageDetail
    {
        public string UserID { get; set; }
        public string UserName { get; set; }

        public string Message { get; set; }
        public string touserid { get; set; }

        public DateTime Date { get; set; }
        public int id { get; set; }
        public int status { get; set; }
        public string companyid { get; set; }
       
    
    }
}