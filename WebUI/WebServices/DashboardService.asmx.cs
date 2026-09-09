using BusinessLayer;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;

namespace WebUI.WebServices
{
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    [System.Web.Script.Services.ScriptService] 
    public class DashboardService : System.Web.Services.WebService
    {
        [WebMethod]
        public object GetDashboardMetrics()
        {
            try
            {
                DeliveryBLL deliveryBLL = new DeliveryBLL();

               
                DataTable dt = deliveryBLL.GetFilteredDeliveriesTable(string.Empty, string.Empty);

                int total = dt.Rows.Count;
                int pending = 0, ofd = 0, delivered = 0, failed = 0;

                foreach (DataRow row in dt.Rows)
                {
                    string status = row["CurrentStatus"] == DBNull.Value ? "" : row["CurrentStatus"].ToString();
                    string norm = status.ToLower().Replace(" ", "");

                    if (norm.Contains("pending")) pending++;
                    else if (norm.Contains("outfordelivery") || norm.Contains("transit")) ofd++;
                    else if (norm.Contains("delivered")) delivered++;
                    else if (norm.Contains("fail") || norm.Contains("cancel")) failed++;
                }

                var stats = new Dictionary<string, object>
                {
                    { "TotalDeliveries", total },
                    { "PendingCount", pending },
                    { "OutForDeliveryCount", ofd },
                    { "DeliveredCount", delivered },
                    { "FailedCount", failed }
                };

              
                DataView dv = dt.DefaultView;
                dv.Sort = "CreatedDate DESC";

                var recentDeliveries = new List<object>();
                int count = 0;
                foreach (DataRowView rowView in dv)
                {
                    if (count >= 8) break;
                    DataRow row = rowView.Row;

                    recentDeliveries.Add(new
                    {
                        DeliveryNo = "Del-" + row["OrderId"].ToString(),
                        CustomerName = string.IsNullOrWhiteSpace(row["CustomerName"]?.ToString()) ? "N/A" : row["CustomerName"].ToString(),
                        DriverName = string.IsNullOrWhiteSpace(row["DriverName"].ToString()) ? "Unassigned" : row["DriverName"].ToString(),
                        DeliveryDate = row["CreatedDate"] == DBNull.Value ? "" : Convert.ToDateTime(row["CreatedDate"]).ToString("dd-MM-yyyy"),
                        Address = row["DeliveryAddress"].ToString(),
                        CurrentStatus = row["CurrentStatus"].ToString()
                    }) ;
                    count++;
                }

                return new { success = true, stats = stats, deliveries = recentDeliveries };
            }
            catch (Exception ex)
            {
                return new { success = false, message = ex.Message };
            }
        }
    }
}