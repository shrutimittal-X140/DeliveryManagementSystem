using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace DataAccessLayer
{
    public class SqlHelper
    {
        private static readonly string connStr = ConfigurationManager.ConnectionStrings["DeliveryDbConn"].ConnectionString;

      
        public static DataTable ExecuteDataTable(string spName, SqlParameter[] parameters = null)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand(spName, conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    if (parameters != null)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        return dt;
                    }
                }
            }
        }
    }
}