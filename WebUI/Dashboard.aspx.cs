using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebUI
{
    public partial class Dashboard : System.Web.UI.Page
    {
        private string ConnStr => ConfigurationManager.ConnectionStrings["DeliveryDbConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ApplyRolePermissions();
                LoadDashboardData();
            }
        }

        private void ApplyRolePermissions()
        {
            string userRole = Session["UserRole"] != null ? Session["UserRole"].ToString() : "Super Admin";

            divDrivers.Visible = true;
            divCustomers.Visible = true;
            divDeliveries.Visible = true;
            divReports.Visible = true;
        }

        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            LoadDashboardData();
        }

        private void LoadDashboardData()
        {
            int pendingCount = 0;
            int ofdCount = 0;
            int deliveredCount = 0;
            int failedCount = 0;

            using (SqlConnection con = new SqlConnection(ConnStr))
            {
                con.Open();

            
                string statusCountQuery = @"
                    SELECT CurrentStatus, COUNT(*) AS StatusCount 
                    FROM Deliveries 
                    GROUP BY CurrentStatus";

                using (SqlCommand cmd = new SqlCommand(statusCountQuery, con))
                {
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            string status = reader["CurrentStatus"]?.ToString().Trim();
                            int count = Convert.ToInt32(reader["StatusCount"]);

                            if (string.Equals(status, "Pending", StringComparison.OrdinalIgnoreCase))
                            {
                                pendingCount = count;
                            }
                            else if (string.Equals(status, "Out For Delivery", StringComparison.OrdinalIgnoreCase))
                            {
                                ofdCount = count;
                            }
                            else if (string.Equals(status, "Delivered", StringComparison.OrdinalIgnoreCase))
                            {
                                deliveredCount = count;
                            }
                            else if (string.Equals(status, "Failed", StringComparison.OrdinalIgnoreCase))
                            {
                                failedCount = count;
                            }
                        }
                    }
                }

                int totalDeliveries = pendingCount + ofdCount + deliveredCount + failedCount;

             
                lblGaugeTotal.Text = totalDeliveries.ToString();
                lblTotalDeliveries.Text = totalDeliveries.ToString();
                lblPending.Text = pendingCount.ToString();
                lblOutForDelivery.Text = ofdCount.ToString();
                lblDelivered.Text = deliveredCount.ToString();
                lblFailedDeliveries.Text = failedCount.ToString();

               
                string recentOrdersQuery = @"
                    SELECT TOP 10 
                        ISNULL(d.DeliveryNumber, 'DEL-' + CAST(d.DeliveryId AS VARCHAR)) AS DeliveryNo,
                        ISNULL(c.CustomerName, 'N/A') AS CustomerName,
                        ISNULL(dr.DriverName, 'Unassigned') AS DriverName,
                        d.DeliveryDate,
                        d.DeliveryAddress AS Address,
                        d.CurrentStatus
                    FROM Deliveries d
                    LEFT JOIN Customers c ON d.CustomerId = c.CustomerId
                    LEFT JOIN Drivers dr ON d.DriverId = dr.DriverId
                    ORDER BY d.DeliveryId DESC";

                using (SqlCommand cmd = new SqlCommand(recentOrdersQuery, con))
                {
                    DataTable dt = new DataTable();
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }

                    gvRecentDeliveries.DataSource = dt;
                    gvRecentDeliveries.DataBind();
                }
            }
        }

        protected void btnManageCustomers_Click(object sender, EventArgs e)
        {
            Response.Redirect("CustomerManagement.aspx");
        }

        public string GetStatusBadgeClass(object statusObj)
        {
            if (statusObj == null) return "badge-status";

            string status = statusObj.ToString().ToLower();

            switch (status)
            {
                case "pending":
                    return "badge-status badge-status-pending";
                case "out for delivery":
                    return "badge-status badge-status-ofd";
                case "delivered":
                    return "badge-status badge-status-delivered";
                case "failed":
                    return "badge-status badge-status-failed";
                default:
                    return "badge-status";
            }
        }
    }
}