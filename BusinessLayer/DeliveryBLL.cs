using DataAccessLayer;
using System;
using System.Collections.Generic;
using System.Data;
using System.Configuration;
using System.Data.SqlClient;
using static BusinessLayer.CustomerBLL;

namespace BusinessLayer
{
    public class DeliveryBLL
    {
        public DataTable GetAllDeliveries()
        {
            return SqlHelper.ExecuteDataTable("sp_GetAllDeliveries");
        }

        public DataTable GetAllCustomersSimple()
        {
            return SqlHelper.ExecuteDataTable("sp_GetCustomersSimple");
        }

        public DataTable GetAllDriversSimple()
        {
            return SqlHelper.ExecuteDataTable("sp_GetDriversSimple");
        }

        public DataTable GetDeliveryById(int deliveryId)
        {
            SqlParameter[] parameters = { new SqlParameter("@DeliveryId", deliveryId) };
            return SqlHelper.ExecuteDataTable("sp_GetDeliveryById", parameters);
        }

        public DataTable GetFilteredDeliveriesTable(string keyword, string status)
        {
            DataTable dt = new DataTable();
            string connStr = ConfigurationManager.ConnectionStrings["DeliveryDBConn"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT 
                        d.DeliveryId AS OrderId,
                        d.CustomerId,
                        d.DriverId,
                        c.CustomerName,
                        dr.DriverName,
                        d.DeliveryAddress,
                        d.CreatedDate,
                        d.CurrentStatus
                    FROM Deliveries d
                    LEFT JOIN Customers c ON d.CustomerId = c.CustomerId
                    LEFT JOIN Drivers dr ON d.DriverId = dr.DriverId
                    WHERE (@CurrentStatus = '' OR d.CurrentStatus = @CurrentStatus)
                      AND (@Keyword = ''
                           OR c.CustomerName LIKE '%' + @Keyword + '%'
                           OR dr.DriverName LIKE '%' + @Keyword + '%'
                           OR c.DeliveryAddress LIKE '%' + @Keyword + '%')";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CurrentStatus", status ?? string.Empty);
                    cmd.Parameters.AddWithValue("@Keyword", keyword ?? string.Empty);

                    conn.Open();
                    SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                    adapter.Fill(dt);
                }

            }
            return dt;
        }

        public List<object> GetFilteredDeliveriesList(string keyword, string status)
        {
            DataTable dt = GetFilteredDeliveriesTable(keyword, status);
            List<object> list = new List<object>();
            foreach (DataRow row in dt.Rows)
            {
                list.Add(new
                {
                    OrderId = Convert.ToInt32(row["OrderId"]),
                    CustomerId = row["CustomerId"] == DBNull.Value ? 0 : Convert.ToInt32(row["CustomerId"]),
                    DriverId = row["DriverId"] == DBNull.Value ? 0 : Convert.ToInt32(row["DriverId"]),
                    CustomerName = row["CustomerName"].ToString(),
                    DriverName = row["DriverName"].ToString(),
                    DeliveryAddress = row["DeliveryAddress"].ToString(),
                    CreatedDate = Convert.ToDateTime(row["CreatedDate"]).ToString("yyyy-MM-dd HH:mm"),
                    CurrentStatus = row["CurrentStatus"].ToString()
                });
            }
            return list;
        }

        public DataTable GetDeliveriesForGrid()
        {
            return SqlHelper.ExecuteDataTable("sp_GetDeliveriesForGrid");
        }

        public DataSet GetDeliveryDetailsForEdit(int deliveryId)
        {
            SqlParameter[] parameters = { new SqlParameter("@DeliveryId", deliveryId) };
            return SqlHelper.ExecuteDataSet("sp_GetDeliveryDetails", parameters);
        }

        public bool CanModify(int deliveryId, int currentUserId, bool isSuperAdmin)
        {
            if (isSuperAdmin) return true;

            SqlParameter[] parameters = { new SqlParameter("@DeliveryId", deliveryId) };
            DataTable dt = SqlHelper.ExecuteDataTable("sp_GetDeliveryOwner", parameters);

            if (dt.Rows.Count == 0) return false;
            int createdBy = Convert.ToInt32(dt.Rows[0]["CreatedBy"]);
            return createdBy == currentUserId;
        }

        public PagedResult GetDeliveriesPaged(int currentUserId, bool isSuperAdmin, string searchTerm,
     string sortColumn, string sortDirection, int pageNumber, int pageSize)
        {
            SqlParameter totalOut = new SqlParameter("@TotalCount", SqlDbType.Int) { Direction = ParameterDirection.Output };

            SqlParameter[] parameters = {
        new SqlParameter("@CurrentUserId", currentUserId),
        new SqlParameter("@IsSuperAdmin", isSuperAdmin),
        new SqlParameter("@SearchTerm", (object)searchTerm ?? string.Empty),
        new SqlParameter("@SortColumn", (object)sortColumn ?? "DeliveryId"),
        new SqlParameter("@SortDirection", (object)sortDirection ?? "DESC"),
        new SqlParameter("@PageNumber", pageNumber),
        new SqlParameter("@PageSize", pageSize),
        totalOut
    };

            DataTable dt = SqlHelper.ExecuteDataTable("sp_GetDeliveriesPaged", parameters);

            return new PagedResult { Rows = dt, Total = totalOut.Value != DBNull.Value ? Convert.ToInt32(totalOut.Value) : 0 };
        }
        public SaveDeliveryResult SaveDeliveryWithItems(
            int deliveryId, DateTime deliveryDate, int customerId, int driverId,
            string address, string notes, string status,
            DataTable items, int currentUserId, bool isSuperAdmin,
            DbTransactionContext ctx = null)
        {
            if (deliveryId > 0 && !CanModify(deliveryId, currentUserId, isSuperAdmin))
            {
                return new SaveDeliveryResult { Success = false, Message = "Permission Denied! You do not have access to change this record." };
            }

            bool ownsTransaction = (ctx == null);
            if (ownsTransaction) ctx = new DbTransactionContext();

            try
            {
                SqlParameter[] parameters =
                {
                    new SqlParameter("@DeliveryId", deliveryId),
                    new SqlParameter("@DeliveryDate", deliveryDate),
                    new SqlParameter("@CustomerId", customerId),
                    new SqlParameter("@DriverId", driverId),
                    new SqlParameter("@DeliveryAddress", address),
                    new SqlParameter("@DeliveryNotes", (object)notes ?? DBNull.Value),
                    new SqlParameter("@CurrentStatus", status),
                    new SqlParameter("@CreatedBy", currentUserId),
                    new SqlParameter("@Items", items) { SqlDbType = SqlDbType.Structured, TypeName = "dbo.DeliveryItemTableType" }
                };

                object result = SqlHelper.ExecuteScalar("sp_SaveDeliveryWithItems", parameters, ctx);
                int newId = result != null ? Convert.ToInt32(result) : deliveryId;

                if (ownsTransaction) ctx.Commit();

                return new SaveDeliveryResult
                {
                    Success = true,
                    DeliveryId = newId,
                    Message = deliveryId > 0 ? $"Delivery #{newId} updated successfully." : "New delivery record created successfully."
                };
            }
            catch
            {
                if (ownsTransaction) ctx.Rollback();
                throw;
            }
            finally
            {
                if (ownsTransaction) ctx.Dispose();
            }
        }

        public DeleteResult DeleteDelivery(int deliveryId, int currentUserId, bool isSuperAdmin, DbTransactionContext ctx = null)
        {
            if (!CanModify(deliveryId, currentUserId, isSuperAdmin))
            {
                return new DeleteResult { Success = false, Message = "Permission Denied! You do not have access to change or delete this record." };
            }

            bool ownsTransaction = (ctx == null);
            if (ownsTransaction) ctx = new DbTransactionContext();

            try
            {
                SqlParameter[] parameters = { new SqlParameter("@DeliveryId", deliveryId) };
                SqlHelper.ExecuteNonQuery("sp_DeleteDeliveryRecord", parameters, ctx);

                if (ownsTransaction) ctx.Commit();
                return new DeleteResult { Success = true, Message = "Delivery record deleted successfully." };
            }
            catch
            {
                if (ownsTransaction) ctx.Rollback();
                throw;
            }
            finally
            {
                if (ownsTransaction) ctx.Dispose();
            }
        }

        public int UpdateDeliveryStatus(int deliveryId, string status, DbTransactionContext ctx = null)
        {
            bool ownsTransaction = (ctx == null);
            if (ownsTransaction) ctx = new DbTransactionContext();

            try
            {
                SqlParameter[] parameters =
                {
                    new SqlParameter("@DeliveryId", deliveryId),
                    new SqlParameter("@Status", status)
                };
                int rows = SqlHelper.ExecuteNonQuery("sp_UpdateDeliveryStatus", parameters, ctx);

                if (ownsTransaction) ctx.Commit();
                return rows;
            }
            catch
            {
                if (ownsTransaction) ctx.Rollback();
                throw;
            }
            finally
            {
                if (ownsTransaction) ctx.Dispose();
            }
        }
    }

    public class SaveDeliveryResult
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public int DeliveryId { get; set; }
    }

    public class DeleteResult
    {
        public bool Success { get; set; }
        public string Message { get; set; }
    }
}