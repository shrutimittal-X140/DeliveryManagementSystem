using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Services;
using System.Web.Script.Services;
using BusinessLayer;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using static BusinessLayer.CustomerBLL;
using System.Web.Management;
using System.Linq.Expressions;
using System.Configuration;

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
        public object GetDeliveriesPaged(int limit, int offset, string sort, string order, string search)
        {
            if (CurrentUserId() == 0)
                return new { total = 0, rows = new object[0] };

            int pageSize = limit > 0 ? limit : 10;
            int pageNumber = (pageSize > 0 ? (offset / pageSize) : 0) + 1;

            PagedResult result = deliveryBLL.GetDeliveriesPaged(
                CurrentUserId(), IsSuperAdmin(), search,
                string.IsNullOrWhiteSpace(sort) ? "DeliveryId" : sort,
                string.IsNullOrWhiteSpace(order) ? "desc" : order,
                pageNumber, pageSize
            );

            List<object> rows = new List<object>();
            foreach (DataRow row in result.Rows.Rows)
            {
                rows.Add(new
                {
                    DeliveryId = row["DeliveryId"],
                    DeliveryNumber = row.Table.Columns.Contains("DeliveryNumber") ? row["DeliveryNumber"]?.ToString() : "DEL-" + row["DeliveryId"],
                    DeliveryDate = row.Table.Columns.Contains("DeliveryDate") && row["DeliveryDate"] != DBNull.Value
                        ? Convert.ToDateTime(row["DeliveryDate"]).ToString("yyyy-MM-dd") : "",
                    CustomerName = row.Table.Columns.Contains("CustomerName") ? row["CustomerName"]?.ToString() : "",
                    DriverName = row.Table.Columns.Contains("DriverName") ? row["DriverName"]?.ToString() : "",
                    DeliveryAddress = row.Table.Columns.Contains("DeliveryAddress") ? row["DeliveryAddress"]?.ToString() : "",
                    CurrentStatus = row.Table.Columns.Contains("CurrentStatus") ? row["CurrentStatus"]?.ToString() : ""
                });
            }

            return new { total = result.Total, rows = rows };
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public object TrackDelivery(int deliveryId)
        {
            try
            {
                if(deliveryId <= 0)
                {
                    return new  {success = false, message = "Please enter a valid Delivery ID."};
                }

                DataTable dt = deliveryBLL.TrackDelivery(deliveryId);
                if ( dt == null || dt.Rows.Count == 0 )
                {
                    return new { success = false, message = "No delivery found with that ID." };
                }

                DataRow row = dt.Rows[0];
                return new
                {
                    success = true,
                    deliveryNumber = row["DeliveryNumber"].ToString(),
                    deliveryDate = row["DeliveryDate"] != DBNull.Value ? Convert.ToDateTime(row["DeliveryDate"]).ToString("yyyy-MM-dd") : "",
                    currentStatus = row["CurrentStatus"].ToString(),
                    deliveryAddress = row["DeliveryAddress"]?.ToString(),
                    customerName = row["CustomerName"]?.ToString(),
                    driverName = row["DriverName"]?.ToString()
                };
            } catch (Exception ex) {
                return new { success = false, message = "Error: " + ex.Message };
            } 
        }
    [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public object GetDriverWorkload()
        {
            if (CurrentUserId() == 0) return new { success = false, message = "Unauthorised" };
            
            try
            {
                DataTable dt = deliveryBLL.GetDriverWorkload();
                List<object> list = new List<object>();

                foreach (DataRow row in dt.Rows)
                {
                    list.Add(new
                    {
                         DriverId = Convert.ToInt32(row["DriverId"]),
                         DriverName = row["DriverName"].ToString(),
                         ActiveCount = Convert.ToInt32(row["ActiveCount"]),
                         DeliveredCount = Convert.ToInt32(row["DeliveredCount"]),
                         TotalCount = Convert.ToInt32(row["TotalCount"])
                    });
                }
                return new { success = true, data = list };
            }
            catch (Exception ex)
            {
                return new { success = false, message = ex.Message };
            }

        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public object SaveDelivery(int deliveryId, string deliveryDate, int customerId, int driverId, string address, string notes, string status, List<DeliveryItemDto> items)
        {
            try
            {
                int currentUserId = CurrentUserId();
                bool isSuperAdmin = IsSuperAdmin();

                DataTable dtItems = new DataTable();
                dtItems.Columns.Add("ItemCode", typeof(string));
                dtItems.Columns.Add("ItemName", typeof(string));
                dtItems.Columns.Add("Quantity", typeof(int));

                if (items != null)
                {
                    foreach (var item in items)
                    {
                        dtItems.Rows.Add(item.ItemCode ?? "", item.ItemName ?? "", item.Quantity);
                    }
                }

                DateTime dateParsed = Convert.ToDateTime(deliveryDate);

                SaveDeliveryResult result = deliveryBLL.SaveDeliveryWithItems(
                    deliveryId, dateParsed, customerId, driverId, address, notes, status, dtItems, currentUserId, isSuperAdmin
                );

                if (!result.Success)
                {
                    return new { success = false, message = result.Message };
                }

                string flashMessage = "Delivery saved successfully.";
                bool emailSent = false;

                if (status.Equals("Delivered", StringComparison.OrdinalIgnoreCase))
                {
                    var customer = deliveryBLL.GetCustomerById(customerId);

                    if (customer != null && !string.IsNullOrEmpty(customer.Email))
                    {
                        var emailResult = Task.Run(() => EmailService.SendDeliveryNotificationAsync(customer.Email, customer.Name, result.DeliveryId)).Result;
                        emailSent = emailResult.Success;

                        flashMessage = emailSent
                            ? $"Delivery marked as Delivered. Notification email sent to {customer.Email}."
                            : $"Delivery saved as Delivered, but email failed: {emailResult.Error}";
                    }
                    else
                    {
                        flashMessage = "Delivery marked as Delivered, but no valid email found for this customer.";
                    }
                }

                return new { success = true, message = flashMessage, emailSent = emailSent, deliveryId = result.DeliveryId };
            }
            catch (Exception ex)
            {
                return new { success = false, message = "Error: " + ex.Message };
            }
        }

        [WebMethod(EnableSession = true)]
        public object GetAllItemsSimple()
        {
            if (CurrentUserId() == 0) return new { success = false, message = "Unauthorized" };

            ItemBLL itemBLL = new ItemBLL();
            DataTable dt = itemBLL.GetAllItems();
            List<object> items = new List<object>();

            foreach ( DataRow row in dt.Rows)
            {
                bool isActive = row.Table.Columns.Contains("IsActive") && row["IsActive"] != DBNull.Value && Convert.ToBoolean(row["IsActive"]);
                if (!isActive) continue;

                items.Add(new
                {
                    ItemId = Convert.ToInt32(row["ItemId"]),
                    ItemCode = row["ItemCode"].ToString(),
                    ItemName = row["ItemName"].ToString()
                });  
            }
            return new { success = true, items = items };
        }

        [WebMethod(EnableSession = true)]
        public object DeleteDelivery(int deliveryId)
        {
            if (CurrentUserId() == 0) return new { success = false, message = "Session expired. Please log in again." };
            var result = deliveryBLL.DeleteDelivery(deliveryId, CurrentUserId(), IsSuperAdmin());
            return new { success = result.Success, message = result.Message };
        }
    }

    public class DeliveryItemDto
    {
        public string ItemCode { get; set; }
        public string ItemName { get; set; }
        public int Quantity { get; set; }
    }
}