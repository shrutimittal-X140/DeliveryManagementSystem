using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebUI
{
    public partial class SearchReports : Page
    {
        private readonly string connStr = ConfigurationManager.ConnectionStrings["DeliveryDbConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

          
            string role = Session["UserRole"]?.ToString();
            if (role != "Admin" && role != "Super Admin")
            {
                Response.Redirect("Dashboard.aspx?error=unauthorized");
                return;
            }

            if (!IsPostBack)
            {
                BindSearchResults();
            }
        }

        protected void btnApplyFilter_Click(object sender, EventArgs e)
        {
            gvSearchResults.PageIndex = 0;
            BindSearchResults();
        }

        protected void gvSearchResults_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvSearchResults.PageIndex = e.NewPageIndex;
            BindSearchResults();
        }

        private void BindSearchResults()
        {
            DataTable dt = GetFilteredData();
            gvSearchResults.DataSource = dt;
            gvSearchResults.DataBind();
        }

        private DataTable GetFilteredData()
        {
            DataTable dt = new DataTable();

            string keyword = txtKeywords.Text.Trim();
            string status = ddlStatus.SelectedValue;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"SELECT 
                            d.DeliveryId AS OrderId, 
                            ISNULL(c.CustomerName, 'N/A') AS CustomerName, 
                            ISNULL(dr.DriverName, 'Unassigned') AS DriverName, 
                            ISNULL(c.DeliveryAddress, 'N/A') AS DeliveryAddress, 
                            d.CreatedDate, 
                            d.CurrentStatus 
                         FROM Deliveries d
                         LEFT JOIN Customers c ON d.CustomerId = c.CustomerId
                         LEFT JOIN Drivers dr ON d.DriverId = dr.DriverId
                         WHERE (@Keyword = '' 
                             OR CAST(d.DeliveryId AS VARCHAR) LIKE '%' + @Keyword + '%' 
                             OR c.CustomerName LIKE '%' + @Keyword + '%' 
                             OR dr.DriverName LIKE '%' + @Keyword + '%')
                           AND (@CurrentStatus = '' OR d.CurrentStatus = @CurrentStatus)
                         ORDER BY d.CreatedDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Keyword", keyword);
                    cmd.Parameters.AddWithValue("@CurrentStatus", status);

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }

            return dt;
        }
        protected string GetStatusBadgeCss(string status)
        {
            switch (status)
            {
                case "Pending":
                    return "badge-pending";
                case "In Transit":
                    return "badge-intransit";
                case "Delivered":
                    return "badge-delivered";
                case "Cancelled":
                    return "badge-cancelled";
                default:
                    return "bg-secondary";
            }
        }

        protected void btnExport_Click(object sender, EventArgs e)
        {
            DataTable dt = GetFilteredData();

            StringBuilder sb = new StringBuilder();
            sb.AppendLine("Order ID,Customer Name,Driver Name,Delivery Address,Date Created,Status");

            foreach (DataRow row in dt.Rows)
            {
                string orderId = row["OrderId"].ToString().Replace(",", " ");
                string customer = row["CustomerName"].ToString().Replace(",", " ");
                string driver = row["DriverName"].ToString().Replace(",", " ");
                string address = row["DeliveryAddress"].ToString().Replace(",", " ");
                string createdDate = Convert.ToDateTime(row["CreatedDate"]).ToString("yyyy-MM-dd HH:mm");
                string status = row["CurrentStatus"].ToString();

                sb.AppendLine($"{orderId},{customer},{driver},{address},{createdDate},{status}");
            }

            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=DeliveryReport_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".csv");
            Response.Charset = "";
            Response.ContentType = "text/csv";
            Response.Output.Write(sb.ToString());
            Response.Flush();
            Response.End();
        }
    }
}