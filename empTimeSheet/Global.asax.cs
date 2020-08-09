using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Routing;
using System.Web.Security;
using System.Web.SessionState;
using empTimeSheet;
using System.Web.Caching;
using empTimeSheet.DataClasses;

namespace EGovernanceWAP
{
    public class Global : System.Web.HttpApplication
    {
        private const string DummyCacheItemKey = "GagaGuguGigi";
        ClsEmailNoti obj = new ClsEmailNoti();
        protected void Application_Start(object sender, EventArgs e)
        {
            RouteTable.Routes.MapHubs();
            ChatHub.fillallusers();

          
        }
        private bool RegisterCacheEntry()
        {
            if (null != HttpContext.Current.Cache[DummyCacheItemKey]) return false;

            HttpContext.Current.Cache.Add(DummyCacheItemKey, "Test", null,
                DateTime.MaxValue, TimeSpan.FromHours(1),
                CacheItemPriority.Normal,
                new CacheItemRemovedCallback(CacheItemRemovedCallback));

            return true;
        }
        public void CacheItemRemovedCallback(string key, object value, CacheItemRemovedReason reason)
        {
            HitPage();
            DoWork();
        }
        private void HitPage()
        {
            obj.CalculateNotiEmail();
        }
        private void DoWork()
        {
            try
            {
                obj.sendNotEmail();
            }
            catch
            {

            }
        }
        protected void Session_Start(object sender, EventArgs e)
        {

        }
        protected void Application_BeginRequest(object sender, EventArgs e)
        {
            RegisterCacheEntry();
        }
        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }
        protected void Application_Error(object sender, EventArgs e)
        {

        }
        protected void Session_End(object sender, EventArgs e)
        {

        }
        protected void Application_End(object sender, EventArgs e)
        {

        }
    }
}