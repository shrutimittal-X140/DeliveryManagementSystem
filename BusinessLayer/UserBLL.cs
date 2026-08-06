using System.Data;
using System.Data.SqlClient;
using DataAccessLayer;

namespace BusinessLayer
{
    public class UserBLL
    {
        public DataTable AuthenticateUser(string username, string password)
        {

            string encryptedPassword = EncryptionHelper.Encrypt(password);
            SqlParameter[] parameters = {
                new SqlParameter("@Username", username),
                new SqlParameter("@Password",encryptedPassword)
            };

            return SqlHelper.ExecuteDataTable("sp_AuthenticateUser", parameters);
        }
        public DataTable RegisterUser(string username, string password, string fullName, int roleId)
        {
            string encryptedPassword = EncryptionHelper.Encrypt(password);
            SqlParameter[] parameters = new SqlParameter[]
            {
        new SqlParameter("@Username", username),
        new SqlParameter("@Password", encryptedPassword),
        new SqlParameter("@FullName", fullName),
        new SqlParameter("@RoleId", roleId)
            };

            return SqlHelper.ExecuteDataTable("sp_RegisterUser", parameters);
        }
    }
}