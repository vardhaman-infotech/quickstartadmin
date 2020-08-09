using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SignalRChat.Common
{
    public class UserDetail
    {
        public string ConnectionId { get; set; }
        public string UserName { get; set; }
        public string UserId { get; set; }
        public string companyid { get; set; }
        public string Status { get; set; }
        public string Profileimg { get; set; }
        public string Designation { get; set; }
        public string chatstatus { get; set; }
    }
}