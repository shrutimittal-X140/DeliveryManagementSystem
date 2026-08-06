using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace WebUI
{
    public class DbConnection
    {
        private static readonly string ConnectionString = ConfigurationManager.ConnectionStrings["DeliveryDbConn"].ConnectionString;

        public static SqlConnection GetConnection()
        {
            SqlConnection conn = new SqlConnection(ConnectionString);
            if (conn.State == ConnectionState.Closed)
            {
                conn.Open();
            }
            return conn;
        }

        public static DataTable ExecuteSelectStoredProcedure(string spName, SqlParameter[] parameters = null)
        {
            using (SqlConnection conn = GetConnection())
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

        public static int ExecuteNonQueryStoredProcedure(string spName, SqlParameter[] parameters)
        {
            using (SqlConnection conn = GetConnection())
            {
                using (SqlCommand cmd = new SqlCommand(spName, conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    if (parameters != null)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }

                    return cmd.ExecuteNonQuery();
                }
            }
        }
    }
}