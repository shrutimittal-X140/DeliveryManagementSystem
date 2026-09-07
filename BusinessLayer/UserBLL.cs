using System;
using System.Data;
using System.Data.SqlClient;
using DataAccessLayer;

namespace BusinessLayer
{
    public class UserBLL
    {
        public DataTable AuthenticateUser(string username, string password, DbTransactionContext ctx = null)
        {
            bool ownsConnection = (ctx == null);
            if (ownsConnection) ctx = new DbTransactionContext();

            try
            {
                string encryptedPassword = EncryptionHelper.Encrypt(password);
                SqlParameter[] parameters = {
                    new SqlParameter("@Username", username),
                    new SqlParameter("@Password", encryptedPassword)
                };
                return SqlHelper.ExecuteDataTable("sp_AuthenticateUser", parameters, ctx);
            }
            finally
            {
                if (ownsConnection) ctx.Dispose();
            }
        }

        public DataTable RegisterUser(string username, string password, string fullName, int roleId,
            DbTransactionContext ctx = null)
        {
            bool ownsTransaction = (ctx == null);
            if (ownsTransaction) ctx = new DbTransactionContext();

            try
            {
                string encryptedPassword = EncryptionHelper.Encrypt(password);
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@Username", username),
                    new SqlParameter("@Password", encryptedPassword),
                    new SqlParameter("@FullName", fullName),
                    new SqlParameter("@RoleId", roleId)
                };

                DataTable result = SqlHelper.ExecuteDataTable("sp_RegisterUser", parameters, ctx);

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
    }
}