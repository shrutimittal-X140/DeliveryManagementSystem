using DataAccessLayer;
using System;
using System.Data;
using System.Data.SqlClient;
using static BusinessLayer.CustomerBLL;

namespace BusinessLayer
{
    public class DriverBLL
    {
        public DataTable GetAllDrivers(DbTransactionContext ctx = null)
        {
            bool ownsConnection = (ctx == null);
            if (ownsConnection) ctx = new DbTransactionContext();

            try
            {
                return SqlHelper.ExecuteDataTable("sp_GetAllDrivers", null, ctx);
            }
            finally
            {
                if (ownsConnection) ctx.Dispose();
            }
        }

        public DataTable GetDriverById(int driverId, DbTransactionContext ctx = null)
        {
            bool ownsConnection = (ctx == null);
            if (ownsConnection) ctx = new DbTransactionContext();

            try
            {
                SqlParameter[] parameters =
                {
                    new SqlParameter("@DriverId", driverId)
                };
                return SqlHelper.ExecuteDataTable("sp_GetDriverbyId", parameters, ctx);
            }
            finally
            {
                if (ownsConnection) ctx.Dispose();
            }
        }

        public int SaveDriver(int driverId, string driverCode, string driverName, string phoneNumber,
              string email, string vehicleNumber, bool isActive, int createdBy, DbTransactionContext ctx = null)
        {
            bool ownsTransaction = (ctx == null);
            if (ownsTransaction) ctx = new DbTransactionContext();

            try
            {
                SqlParameter[] parameters =
                {
            new SqlParameter("@DriverId", SqlDbType.Int) { Value = driverId },
            new SqlParameter("@DriverCode", SqlDbType.NVarChar, 50) { Value = driverCode },
            new SqlParameter("@DriverName", SqlDbType.NVarChar, 100) { Value = driverName },
            new SqlParameter("@PhoneNumber", SqlDbType.NVarChar, 20) { Value = phoneNumber },
            new SqlParameter("@Email", SqlDbType.NVarChar, 100) { Value = (object)email ?? DBNull.Value },
            new SqlParameter("@VehicleNumber", SqlDbType.NVarChar, 50) { Value = vehicleNumber },
            new SqlParameter("@IsActive", SqlDbType.Bit) { Value = isActive },
            new SqlParameter("@CreatedBy", SqlDbType.Int) { Value = createdBy }
        };

                int result = SqlHelper.ExecuteNonQuery("sp_SaveDriver", parameters, ctx);

                if (ownsTransaction) ctx.Commit();
                return result;
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
        public int DeleteDriver(int driverId, DbTransactionContext ctx = null)
        {
            bool ownsTransaction = (ctx == null);
            if (ownsTransaction) ctx = new DbTransactionContext();

            try
            {
                SqlParameter[] parameters =
                {
                    new SqlParameter("@DriverId", driverId)
                };

                int result = SqlHelper.ExecuteNonQuery("sp_DeleteDriver", parameters, ctx);

                if (ownsTransaction) ctx.Commit();
                return result;
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

        public PagedResult GetDriversPaged(int currentUserId, bool isSuperAdmin, string searchTerm,
        string sortColumn, string sortDirection, int pageNumber, int pageSize)
        {
            SqlParameter totalOut = new SqlParameter("@TotalCount", SqlDbType.Int) { Direction = ParameterDirection.Output };

            SqlParameter[] parameters = {
                new SqlParameter("@CurrentUserId", currentUserId),
                new SqlParameter("@IsSuperAdmin", isSuperAdmin),
                new SqlParameter("@SearchTerm", (object)searchTerm ?? string.Empty),
                new SqlParameter("@SortColumn", (object)sortColumn ?? "DriverId"),
                new SqlParameter("@SortDirection", (object)sortDirection ?? "DESC"),
                new SqlParameter("@PageNumber", pageNumber),
                new SqlParameter("@PageSize", pageSize),
             totalOut
         };

            DataTable dt = SqlHelper.ExecuteDataTable("sp_GetDriversPaged", parameters);

            return new PagedResult { Rows = dt, Total = totalOut.Value != DBNull.Value ? Convert.ToInt32(totalOut.Value) : 0 };
        } 

        public DataTable GetDashboardCounts()
        {
            return SqlHelper.ExecuteDataTable("sp_GetDashboardCounts");
        }
    }
}