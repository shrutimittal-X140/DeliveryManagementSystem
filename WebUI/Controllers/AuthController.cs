using System;
using System.Data;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using BusinessLayer;

namespace WebUI.Controllers
{
    public class LoginModel
    {
        public string Username { get; set; }
        public string Password { get; set; }
    }

    public class RegisterModel
    {
        public string Username { get; set; }
        public string Password { get; set; }
        public string FullName { get; set; }
    }

    public class AuthController : ApiController
    {
        private UserBLL userBLL = new UserBLL();

        [HttpPost]
        [Route("api/auth/login")]
        public IHttpActionResult Login([FromBody] LoginModel model)
        {
            if (model == null || string.IsNullOrWhiteSpace(model.Username) || string.IsNullOrWhiteSpace(model.Password))
            {
                return Ok(new { success = false, message = "Please enter both Username and Password." });
            }

            DataTable dt = userBLL.AuthenticateUser(model.Username, model.Password);

            if (dt != null && dt.Rows.Count > 0)
            {

                if (HttpContext.Current != null && HttpContext.Current.Session != null)
                {
                    HttpContext.Current.Session["UserId"] = dt.Rows[0]["UserId"];
                    HttpContext.Current.Session["Username"] = dt.Rows[0]["Username"];
                    HttpContext.Current.Session["FullName"] = dt.Rows[0]["FullName"];
                    HttpContext.Current.Session["Role"] = dt.Rows[0]["RoleName"];
                    HttpContext.Current.Session["RoleId"] = dt.Rows[0]["RoleId"];
                }

                return Ok(new { success = true, redirect = "Dashboard.aspx" });
            }

            return Ok(new { success = false, message = "Invalid username or password." });
        }

        public class RegisterModel
        {
            public string Username { get; set; }
            public string Password { get; set; }
            public string FullName { get; set; }
            public int RoleId { get; set; }
        }

        [HttpPost]
        [Route("api/auth/register")]
        public IHttpActionResult Register([FromBody] RegisterModel model)
        {
            if (model == null || string.IsNullOrWhiteSpace(model.FullName) || string.IsNullOrWhiteSpace(model.Username) || string.IsNullOrWhiteSpace(model.Password) || model.RoleId <= 0)
            {
                return Ok(new { success = false, message = "Please fill in all mandatory fields including Role." });
            }

            try
            {
                DataTable dt = userBLL.RegisterUser(model.Username, model.Password, model.FullName, model.RoleId);
                return Ok(new { success = true, message = "Account created successfully! You can now log in." });
            }
            catch (Exception ex)
            {
                return Ok(new { success = false, message = ex.Message });
            }
        }
    }
}