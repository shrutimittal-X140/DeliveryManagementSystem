using System;
using System.Collections.Generic;
using System.Data;
using System.Web.Services;
using System.Web.Script.Services;
using BusinessLayer;

namespace WebUI.WebServices
{
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    [ScriptService]
    public class DriverService : System.Web.Services.WebService
    {
        private DriverBLL driverBLL = new DriverBLL();

        private void GetSessionIdentity(out int currentUserId, out bool isSuperAdmin)
        {
            currentUserId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 0;
            isSuperAdmin = Session["UserRole"] != null &&
                Session["UserRole"].ToString().Equals("Super Admin", StringComparison.OrdinalIgnoreCase);
        }

        [WebMethod(EnableSession = true)]
        public object GetDriversPaged(int limit, int offset, string sort, string order, string search)
        {
            try
            {
                int currentUserId; bool isSuperAdmin;
                GetSessionIdentity(out currentUserId, out isSuperAdmin);

                int pageSize = limit > 0 ? limit : 10;
                int pageNumber = (offset / pageSize) + 1;
                string sortColumn = string.IsNullOrEmpty(sort) ? "DriverId" : sort;
                string sortDirection = string.IsNullOrEmpty(order) ? "DESC" : order.ToUpper();

                var result = driverBLL.GetDriversPaged(currentUserId, isSuperAdmin, search, sortColumn, sortDirection, pageNumber, pageSize);

                return new { total = result.Total, rows = ToList(result.Rows) };
            }
            catch (Exception ex)
            {
                return new { total = 0, rows = new object[0], error = ex.Message };
            }
        }

        [WebMethod(EnableSession = true)]
        public object GetDashboardCounts()
        {
            try
            {
                DataTable dt = driverBLL.GetDashboardCounts();
                if (dt.Rows.Count == 0) return new { success = false };

                DataRow row = dt.Rows[0];
                return new
                {
                    success = true,
                    totalDrivers = row["TotalDrivers"],
                    totalCustomers = row["TotalCustomers"],
                    totalDeliveries = row["TotalDeliveries"]
                };
            }
            catch (Exception ex)
            {
                return new { success = false, message = ex.Message };
            }
        }

        [WebMethod(EnableSession = true)]
        public object SaveDriver(int driverId, string driverCode, string driverName, string phoneNumber, string email, string vehicleNumber, bool isActive)
        {
            if(string.IsNullOrWhiteSpace(driverCode) || string.IsNullOrWhiteSpace(driverName) || string.IsNullOrWhiteSpace(phoneNumber) || string.IsNullOrWhiteSpace(vehicleNumber))
            {
                return new { success = false, message = "Please fill in all required fields." };
            }

            try
            {
                int currentUserId; bool isSuperAdmin;
                GetSessionIdentity(out currentUserId, out isSuperAdmin);

                driverBLL.SaveDriver(driverId, driverCode, driverName, phoneNumber, email, vehicleNumber, isActive, currentUserId);

                return new { success = true, message = driverId > 0 ? "Driver updated successfully." : "Driver saved sucessfully." };
            }
            catch(Exception ex)
            {
                return new { success = false, message = ex.Message };

            }
        }

        [WebMethod(EnableSession = true)]
        public object DeleteDriver(int driverId)
        {
            try
            {
                driverBLL.DeleteDriver(driverId);
                return new { success = true, message = "Driver deleted successfully." };
            }
            catch (Exception ex)
            {
                return new { success = false, message = ex.Message };
            }
        }

        private List<Dictionary<string, object>> ToList(DataTable dt)
        {
            var list = new List<Dictionary<string, object>>();
            foreach (DataRow row in dt.Rows)
            {
                var dict = new Dictionary<string, object>();
                foreach (DataColumn col in dt.Columns)
                {
                    dict[col.ColumnName] = row[col] == DBNull.Value ? null : row[col];
                }
                list.Add(dict);
            }
            return list;
        }
    }
}