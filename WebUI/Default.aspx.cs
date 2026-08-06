using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebUI
{
    public partial class Default : Page
    {
        private string GetConnectionString()
        {
            return ConfigurationManager.ConnectionStrings["DeliveryDbConn"].ConnectionString;
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["Username"]!= null)
                {
                    lnkLogin.Visible = false;
                }else
                {
                    lnkLogin.Visible = true;
                }
                LoadHomeAnalytics();
            }
        }

        private void LoadHomeAnalytics()
        {
            try
            {
                string connStr = GetConnectionString();
                using(SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    string statusQuery = @"
                        SELECT CurrentStatus, COUNT(*) AS StatusCount 
                        FROM Deliveries 
                        GROUP BY CurrentStatus";

                    using (SqlCommand cmd = new SqlCommand(statusQuery, con))
                    {
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                string status = reader["CurrentStatus"]?.ToString().Trim();
                                int count = Convert.ToInt32(reader["StatusCount"]);

                                if (string.Equals(status, "Pending", StringComparison.OrdinalIgnoreCase))
                                    hfPending.Value = count.ToString();
                                else if (string.Equals(status, "Out For Delivery", StringComparison.OrdinalIgnoreCase))
                                    hfOFD.Value = count.ToString();
                                else if (string.Equals(status, "Delivered", StringComparison.OrdinalIgnoreCase))
                                    hfDelivered.Value = count.ToString();
                                else if (string.Equals(status, "Failed", StringComparison.OrdinalIgnoreCase))
                                    hfFailed.Value = count.ToString();
                            }
                        }
                    }
                    string driverQuery = "SELECT  COUNT(*) FROM Drivers";
                    using (SqlCommand cmd = new SqlCommand(driverQuery, con))
                    {
                        hfTotalDrivers.Value = Convert.ToInt32(cmd.ExecuteScalar()).ToString();
                    }

                    string customerQuery = "SELECT COUNT(*) FROM Customers";
                    using(SqlCommand cmd = new SqlCommand(customerQuery,con))
                    {
                        hfTotalCustomers.Value = Convert.ToInt32(cmd.ExecuteScalar()).ToString();
                    }
                }
            }
            catch
            {
                hfPending.Value = "0";
                hfOFD.Value = "0";
                hfDelivered.Value = "0";
                hfFailed.Value = "0";
                hfTotalDrivers.Value = "0";
                hfTotalCustomers.Value = "0";
            }
        }
    }
}