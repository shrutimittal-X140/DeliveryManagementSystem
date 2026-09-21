using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Services;
using System.Web.Script.Services;
using BusinessLayer;

namespace WebUI.WebServices
{
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    [ScriptService]
    public class ItemService : WebService
    {
        private readonly ItemBLL itemBLL = new ItemBLL();

        private string GetCurrentUsername()
        {
            if (Session == null) return null;
            return Session["Username"]?.ToString()
                ?? Session["UserName"]?.ToString()
                ?? Session["User"]?.ToString()
                ?? Session["userid"]?.ToString();
        }

        private string GetCurrentRole()
        {
            if (Session == null) return null;
            return Session["Role"]?.ToString()
                ?? Session["UserRole"]?.ToString()
                ?? Session["role"]?.ToString();
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public object GetItems()
        {
            try
            {
                string currentUsername = GetCurrentUsername();
                string currentRole = GetCurrentRole();

                if (string.IsNullOrEmpty(currentUsername) || string.IsNullOrEmpty(currentRole))
                {
                    return new { success = false, message = "Session expired. Please log in again." };
                }

                DataTable dt = itemBLL.GetAllItems();
                List<object> list = new List<object>();

                foreach (DataRow row in dt.Rows)
                {
                    string createdBy = row.Table.Columns.Contains("CreatedBy") && row["CreatedBy"] != DBNull.Value
                        ? row["CreatedBy"].ToString()
                        : "";

                    bool canEdit = currentRole.Equals("Super Admin", StringComparison.OrdinalIgnoreCase) ||
                                  createdBy.Equals(currentUsername, StringComparison.OrdinalIgnoreCase);

                    list.Add(new
                    {
                        ItemId = Convert.ToInt32(row["ItemId"]),
                        ItemCode = row["ItemCode"].ToString(),
                        ItemName = row["ItemName"].ToString(),
                        UnitPrice = Convert.ToDecimal(row["UnitPrice"]),
                        IsActive = Convert.ToBoolean(row["IsActive"]),
                        CreatedBy = createdBy,
                        CanEdit = canEdit
                    });
                }

                return new { success = true, data = list, currentUser = currentUsername, currentRole = currentRole };
            }
            catch (Exception ex)
            {
                return new { success = false, message = ex.Message };
            }
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public object SaveItem(int itemId, string itemCode, string itemName, decimal unitPrice, bool isActive)
        {
            try
            {
                string currentUsername = GetCurrentUsername();
                string currentRole = GetCurrentRole();

                if (string.IsNullOrEmpty(currentUsername) || string.IsNullOrEmpty(currentRole))
                {
                    return new { success = false, message = "Session expired. Please log in again." };
                }

                if (itemId > 0)
                {
                    DataTable dt = itemBLL.GetItemById(itemId);
                    if (dt != null && dt.Rows.Count > 0)
                    {
                        string createdBy = dt.Rows[0].Table.Columns.Contains("CreatedBy") && dt.Rows[0]["CreatedBy"] != DBNull.Value
                            ? dt.Rows[0]["CreatedBy"].ToString()
                            : "";

                        if (!currentRole.Equals("Super Admin", StringComparison.OrdinalIgnoreCase) &&
                            !createdBy.Equals(currentUsername, StringComparison.OrdinalIgnoreCase))
                        {
                            return new { success = false, message = "Access Denied: You can only edit items created by you." };
                        }
                    }
                }

                bool result = itemBLL.SaveItem(itemId, itemCode, itemName, unitPrice, isActive, currentUsername);
                return new { success = result, message = result ? "Item saved successfully." : "Failed to save item." };
            }
            catch (Exception ex)
            {
                return new { success = false, message = ex.Message };
            }
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public object GetItemById(int itemId)
        {
            try
            {
                DataTable dt = itemBLL.GetItemById(itemId);
                if(dt == null || dt.Rows.Count == 0)
                {
                    return new { success = false, message = "Item not found." };
                }
                DataRow row = dt.Rows[0];
                return new
                {
                    success = true,
                    ItemId = Convert.ToInt32(row["ItemId"]),
                    ItemCode = row["ItemCode"].ToString(),
                    ItemName = row["ItemName"].ToString(),
                    UnitPrice = Convert.ToDecimal(row["UnitPrice"]),
                    IsActive = Convert.ToBoolean(row["IsActive"])
                };
            }catch (Exception ex)
            {
                return new { success = false, message = ex.Message };
            }
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public object DeleteItem(int itemId)
        {
            try
            {
                string currentUsername = GetCurrentUsername();
                string currentRole = GetCurrentRole();

                if (string.IsNullOrEmpty(currentUsername) || string.IsNullOrEmpty(currentRole))
                {
                    return new { success = false, message = "Session expired. Please log in again." };
                }

                DataTable dt = itemBLL.GetItemById(itemId);
                if (dt != null && dt.Rows.Count > 0)
                {
                    string createdBy = dt.Rows[0].Table.Columns.Contains("CreatedBy") && dt.Rows[0]["CreatedBy"] != DBNull.Value
                        ? dt.Rows[0]["CreatedBy"].ToString()
                        : "";

                    if (!currentRole.Equals("Super Admin", StringComparison.OrdinalIgnoreCase) &&
                        !createdBy.Equals(currentUsername, StringComparison.OrdinalIgnoreCase))
                    {
                        return new { success = false, message = "Access Denied: You can only delete items created by you." };
                    }
                }

                bool result = itemBLL.DeleteItem(itemId);
                return new { success = result, message = result ? "Item deleted." : "Failed to delete item." };
            }
            catch (Exception ex)
            {
                return new { success = false, message = ex.Message };
            }
        }
    }
}