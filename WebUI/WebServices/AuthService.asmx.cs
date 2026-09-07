using System;
using System.Data;
using System.Web.Services;
using System.Web.Script.Services;
using BusinessLayer;

namespace WebUI.WebServices
{
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [ScriptService]
    public class AuthService : System.Web.Services.WebService
    {
        private UserBLL userBLL = new UserBLL();

        [WebMethod(EnableSession = true)]
        public object Login(string username, string password)
        {
            if (string.IsNullOrWhiteSpace(username) || string.IsNullOrWhiteSpace(password))
                return new { success = false, message = "Please enter both Username and Password." };

            try
            {
                DataTable dt = userBLL.AuthenticateUser(username, password);

                if (dt != null && dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    Session["UserId"] = row["UserId"];
                    Session["Username"] = row["Username"];
                    Session["FullName"] = row["FullName"];
                    Session["UserRole"] = row["RoleName"];

                    return new { success = true, redirect = "Dashboard.aspx" };
                }

                return new { success = false, message = "Invalid username or password." };
            }
            catch (Exception ex)
            {
                return new { success = false, message = ex.Message };
            }
        }

        [WebMethod]
        public object Register(string fullName, string username, string password, int roleId)
        {
            if (string.IsNullOrWhiteSpace(fullName) || string.IsNullOrWhiteSpace(username) ||
                string.IsNullOrWhiteSpace(password) || roleId <= 0)
                return new { success = false, message = "Please fill in all mandatory fields including Role." };

            try
            {
                userBLL.RegisterUser(username, password, fullName, roleId);
                return new { success = true, message = "Account created successfully! You can now log in." };
            }
            catch (Exception ex)
            {
                return new { success = false, message = ex.Message };
            }
        }
    }
}