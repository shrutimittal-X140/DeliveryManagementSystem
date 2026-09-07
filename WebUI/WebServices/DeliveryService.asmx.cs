using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Services;
using System.Web.Script.Services;
using BusinessLayer;
using System.Data.SqlClient;
using System.Linq;

namespace WebUI.WebServices
{
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    [ScriptService]
    public class DeliveryService : System.Web.Services.WebService
    {
        private readonly DeliveryBLL deliveryBLL = new DeliveryBLL();

        private bool IsSuperAdmin()
        {
            if (HttpContext.Current.Session == null) return false;
            string role = HttpContext.Current.Session["UserRole"]?.ToString() ?? string.Empty;
            //string roleId = HttpContext.Current.Session["RoleId"]?.ToString() ?? string.Empty;
            string cleanedRole = role.Replace(" ", "").Trim();

            return cleanedRole.Equals("SuperAdmin", StringComparison.OrdinalIgnoreCase) ||
                   cleanedRole.Equals("Admin", StringComparison.OrdinalIgnoreCase);

        }

        private int CurrentUserId()
        {
            if (HttpContext.Current.Session?["UserId"] == null) return 0;
            return Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        }

        [WebMethod(EnableSession = true)]
        public object GetInitialData()
        {
            if (CurrentUserId() == 0) return new { success = false, message = "Unauthorized" };

            DataTable dtGrid = deliveryBLL.GetDeliveriesForGrid();
            List<object> gridList = new List<object>();

            foreach (DataRow row in dtGrid.Rows)
            {
                gridList.Add(new
                {
                    DeliveryId = row["DeliveryId"],
                    CustomerName = row["CustomerName"]?.ToString(),
                    DriverName = row["DriverName"]?.ToString(),
                    DeliveryDate = row["DeliveryDate"] != DBNull.Value ? Convert.ToDateTime(row["DeliveryDate"]).ToString("yyyy-MM-dd") : "",
                    DeliveryAddress = row["DeliveryAddress"]?.ToString(),
                    CurrentStatus = row["CurrentStatus"]?.ToString()
                });
            }

            List<object> customers = new List<object>();
            foreach (DataRow row in deliveryBLL.GetAllCustomersSimple().Rows)
            {
                customers.Add(new { CustomerId = row["CustomerId"], CustomerName = row["CustomerName"].ToString() });
            }

            List<object> drivers = new List<object>();
            foreach (DataRow row in deliveryBLL.GetAllDriversSimple().Rows)
            {
                drivers.Add(new { DriverId = row["DriverId"], DriverName = row["DriverName"].ToString() });
            }

            return new { success = true, gridData = gridList, customers = customers, drivers = drivers };
        }

        [WebMethod(EnableSession = true)]
        public object LoadDelivery(int deliveryId)
        {
            if (CurrentUserId() == 0) return new { success = false, message = "Unauthorized" };

            DataSet ds = deliveryBLL.GetDeliveryDetailsForEdit(deliveryId);
            if (ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0)
                return new { success = false, message = "Delivery profile not found." };

            DataRow dr = ds.Tables[0].Rows[0];
            var master = new
            {
                DeliveryId = deliveryId,
                DeliveryDate = Convert.ToDateTime(dr["DeliveryDate"]).ToString("yyyy-MM-dd"),
                CustomerId = dr["CustomerId"] != DBNull.Value ? Convert.ToInt32(dr["CustomerId"]) : 0,
                DriverId = dr["DriverId"] != DBNull.Value ? Convert.ToInt32(dr["DriverId"]) : 0,
                DeliveryAddress = dr["DeliveryAddress"].ToString(),
                DeliveryNotes = dr["DeliveryNotes"]?.ToString() ?? "",
                CurrentStatus = dr["CurrentStatus"].ToString()
            };

            List<object> items = new List<object>();
            if (ds.Tables.Count > 1)
            {
                foreach (DataRow row in ds.Tables[1].Rows)
                {
                    items.Add(new
                    {
                        ItemCode = row["ItemCode"]?.ToString(),
                        ItemName = row["ItemName"]?.ToString(),
                        Quantity = row["Quantity"] != DBNull.Value ? Convert.ToInt32(row["Quantity"]) : 1
                    });
                }
            }

            if (items.Count == 0) items.Add(new { ItemCode = "", ItemName = "", Quantity = 1 });

            return new { success = true, master = master, items = items };
        }

        [WebMethod(EnableSession = true)]
        public object SaveDelivery(int deliveryId, string deliveryDate, int customerId, int driverId, string address, string notes, string status, List<DeliveryItemInput> items)
        {
            if (CurrentUserId() == 0) return new { success = false, message = "Session expired. Please log in again." };

            DataTable dtItems = new DataTable();
            dtItems.Columns.Add("ItemCode", typeof(string));
            dtItems.Columns.Add("ItemName", typeof(string));
            dtItems.Columns.Add("Quantity", typeof(int));

            if (items != null)
            {
                foreach (var item in items)
                {
                    dtItems.Rows.Add(item.ItemCode, item.ItemName, item.Quantity);
                }
            }
            if (dtItems.Rows.Count == 0) dtItems.Rows.Add("", "", 1);
        
            var result = deliveryBLL.SaveDeliveryWithItems(
                deliveryId, Convert.ToDateTime(deliveryDate), customerId, driverId,
                address, notes, status, dtItems, CurrentUserId(), IsSuperAdmin()
            );

            return new { success = result.Success, message = result.Message };
        }
        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public object GetDeliveriesPaged(int limit, int offset, string sort, string order, string search)
        {
            if (Session["UserId"] == null)
            {
                return new { total = 0, rows = new List<object>() };
            }

            DeliveryBLL deliveryBLL = new DeliveryBLL();
            DataTable dt = deliveryBLL.GetDeliveriesForGrid();

            List<object> deliveries = new List<object>();
           
  
                        foreach(DataRow dr in dt.Rows)
                        {
                            deliveries.Add(new
                            {
                                DeliveryId = Convert.ToInt32(dr["DeliveryId"]),
                                DeliveryNumber = dr["DeliveryNumber"] != DBNull.Value ? dr["DeliveryNumber"].ToString() : "",
                                DeliveryDate = dr["DeliveryDate"] != DBNull.Value ? Convert.ToDateTime(dr["DeliveryDate"]).ToString("yyyy-MM-dd") : "",
                                CustomerName = dr["CustomerName"] != DBNull.Value ? dr["CustomerName"].ToString() : "N/A",
                                DriverName = dr["DriverName"] != DBNull.Value ? dr["DriverName"].ToString() : "Unassigned",
                                DeliveryAddress = dr["DeliveryAddress"] != DBNull.Value ? dr["DeliveryAddress"].ToString() : "",
                                CurrentStatus = dr["CurrentStatus"] != DBNull.Value ? dr["CurrentStatus"].ToString() : ""
                            });
                        }
           
            if (!string.IsNullOrEmpty(search))
            {
                search = search.ToLower();
                deliveries = deliveries.Where(x =>
                    x.GetType().GetProperty("DeliveryNumber").GetValue(x, null).ToString().ToLower().Contains(search) ||
                    x.GetType().GetProperty("CustomerName").GetValue(x, null).ToString().ToLower().Contains(search) ||
                    x.GetType().GetProperty("DriverName").GetValue(x, null).ToString().ToLower().Contains(search) ||
                    x.GetType().GetProperty("CurrentStatus").GetValue(x, null).ToString().ToLower().Contains(search)
                ).ToList();
            }
            int totalCount = deliveries.Count; 
            var pagedRows = deliveries.Skip(offset).Take(limit).ToList();

            return new
            {
                total = totalCount,
                rows = pagedRows
            };
        }


        [WebMethod(EnableSession = true)]
        public object DeleteDelivery(int deliveryId)
        {
            if (CurrentUserId() == 0) return new { success = false, message = "Session expired. Please log in again." };
            var result = deliveryBLL.DeleteDelivery(deliveryId, CurrentUserId(), IsSuperAdmin());
            return new { success = result.Success, message = result.Message };
        }
    }

    public class DeliveryItemInput
    {
        public string ItemCode { get; set; }
        public string ItemName { get; set; }
        public int Quantity { get; set; }
    }
}