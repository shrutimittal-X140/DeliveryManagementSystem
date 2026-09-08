using System;
using System.Web;
using System.Web.Services;
using System.Web.Script.Services;
using System.Collections.Generic;
using BusinessLayer;
using DataAccessLayer;
using System.Data.SqlClient;

namespace WebUI.WebServices
{
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [ScriptService]
    public class ReportService : WebService
    {
        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public object GetReports(string keyword, string status)
        {
            if (HttpContext.Current.Session["UserId"] == null)
                return new { success = false, message = "Session expired." };
            try
            {
                DeliveryBLL deliveryBll = new DeliveryBLL();
                var records = deliveryBll.GetFilteredDeliveriesList(keyword, status);
                return new { success = true, data = records, role = HttpContext.Current.Session["UserRole"]?.ToString() };
            }
            catch (Exception ex)
            {
                return new { success = false, message = ex.Message };
            }
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public object UpdateRecord(int orderId, int customerId, int driverId, string customerName, string driverName, string address)
        {
            try
            {
                if (HttpContext.Current.Session["UserId"] == null)
                {
                    return new { success = false, message = "Session expired. Please log in again." };
                }
                if (string.IsNullOrWhiteSpace(customerName))
                {
                    return new { success = false, message = "Customer Name cannot be empty." };
                }

                if (customerId > 0)
                {
                    SqlParameter[] custParams = new SqlParameter[]
                    {
                        new SqlParameter("@CustomerId", customerId),
                        new SqlParameter("@CustomerName", (customerName ?? "").Trim()),
                        new SqlParameter("@Address", (address ?? "").Trim())
                    };
                    SqlHelper.ExecuteNonQuery("sp_UpdateCustomerReportInfo", custParams);
                }
                if (driverId > 0)
                {
                    SqlParameter[] driverParams = new SqlParameter[]
                    {
                        new SqlParameter("@DriverId", driverId),
                        new SqlParameter("@DriverName", (driverName ?? "").Trim())
                    };
                    SqlHelper.ExecuteNonQuery("sp_UpdateDriverReportInfo", driverParams);
                }
                if (orderId > 0)
                {
                    SqlParameter[] deliveryParams = new SqlParameter[]
                    {
                        new SqlParameter("@DeliveryId", orderId),
                        new SqlParameter("@DeliveryAddress", (address ?? "").Trim())
                    };
                    SqlHelper.ExecuteNonQuery("sp_UpdateDeliveryAddress", deliveryParams);
                }

                return new { success = true, message = "Record updated successfully." };
            }
            catch (Exception ex)
            {
                return new { success = false, message = "SQL/C# EXCEPTION: " + (ex.InnerException != null ? ex.InnerException.Message : ex.Message) };
            }
        }
    }
}