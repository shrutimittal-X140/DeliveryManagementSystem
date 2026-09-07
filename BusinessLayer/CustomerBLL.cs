 using System;
using System.Data;
using System.Data.SqlClient;
using DataAccessLayer;

namespace BusinessLayer
{
    public class CustomerBLL
    {
        public DataTable GetAllCustomers(int currentUserId, bool isSuperAdmin, string searchQuery, DbTransactionContext ctx = null)
        {
            bool ownsConnection = (ctx == null);
            if (ownsConnection) ctx = new DbTransactionContext();

            try
            {
                SqlParameter[] parameters = {
                    new SqlParameter("@CurrentUserId", currentUserId),
                    new SqlParameter("@IsSuperAdmin", isSuperAdmin),
                    new SqlParameter("@SearchQuery", (object)searchQuery ?? string.Empty)
                };
                return SqlHelper.ExecuteDataTable("sp_GetCustomers", parameters, ctx);
            }
            finally
            {
                if (ownsConnection) ctx.Dispose();
            }
        }

        public int SaveCustomer(int customerId, string customerCode, string customerName, string contactPerson,
            string phoneNumber, string email, string deliveryAddress, int currentUserId, bool isSuperAdmin, DbTransactionContext ctx = null)
        {
            bool ownsTransaction = (ctx == null);
            if (ownsTransaction) ctx = new DbTransactionContext();

            try
            {
                SqlParameter[] parameters = {
                    new SqlParameter("@CustomerId", customerId),
                    new SqlParameter("@CustomerCode", customerCode),
                    new SqlParameter("@CustomerName", customerName),
                    new SqlParameter("@ContactPerson", (object)contactPerson ?? DBNull.Value),
                    new SqlParameter("@PhoneNumber", (object)phoneNumber ?? DBNull.Value),
                    new SqlParameter("@Email", (object)email ?? DBNull.Value),
                    new SqlParameter("@DeliveryAddress", (object)deliveryAddress ?? DBNull.Value),
                    new SqlParameter("@CurrentUserId", currentUserId),
                    new SqlParameter("@IsSuperAdmin", isSuperAdmin)
                };

                int result = SqlHelper.ExecuteNonQuery("sp_SaveCustomer", parameters, ctx);

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

        public int DeleteCustomer(int customerId, int currentUserId, bool isSuperAdmin, DbTransactionContext ctx = null)
        {
            bool ownsTransaction = (ctx == null);
            if (ownsTransaction) ctx = new DbTransactionContext();

            try
            {
                SqlParameter[] parameters = {
                    new SqlParameter("@CustomerId", customerId),
                    new SqlParameter("@CurrentUserId", currentUserId),
                    new SqlParameter("@IsSuperAdmin", isSuperAdmin)
                };

                int result = SqlHelper.ExecuteNonQuery("sp_DeleteCustomer", parameters, ctx);

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
        public class PagedResult
        {
            public DataTable Rows { get; set; }
            public int Total { get; set; }
        }

        public PagedResult GetCustomersPaged(int currentUserId, bool isSuperAdmin, string searchTerm,
            string sortColumn, string sortDirection, int pageNumber, int pageSize)
        {
            SqlParameter totalOut = new SqlParameter("@TotalCount", SqlDbType.Int) { Direction = ParameterDirection.Output };

            SqlParameter[] parameters = {
        new SqlParameter("@CurrentUserId", currentUserId),
        new SqlParameter("@IsSuperAdmin", isSuperAdmin),
        new SqlParameter("@SearchTerm", (object)searchTerm ?? string.Empty),
        new SqlParameter("@SortColumn", (object)sortColumn ?? "CustomerId"),
        new SqlParameter("@SortDirection", (object)sortDirection ?? "DESC"),
        new SqlParameter("@PageNumber", pageNumber),
        new SqlParameter("@PageSize", pageSize),
        totalOut
    };

            DataTable dt = SqlHelper.ExecuteDataTable("sp_GetCustomersPaged", parameters);

            return new PagedResult { Rows = dt, Total = totalOut.Value != DBNull.Value ? Convert.ToInt32(totalOut.Value) : 0 };
        }
    }
}