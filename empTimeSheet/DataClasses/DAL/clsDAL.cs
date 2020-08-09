using System.Data.SqlClient;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using System.Data.Common;

namespace empTimeSheet.DataClasses.DAL
{
    public class clsDAL
    {
        static string connString = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["conn"].ConnectionString;
        public DbCommand dbcommand;
        public SqlDatabase db = new SqlDatabase(connString);
        public static SqlConnection scon = new SqlConnection(connString);
    }
}