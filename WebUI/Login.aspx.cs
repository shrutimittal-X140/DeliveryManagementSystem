using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace WebUI
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["SuccessMessage"] != null)
                {
                    lblMessage.Text = Session["SuccessMessage"].ToString();
                    pnlError.CssClass = "alert alert-success py-2 px-3 small rounded-3 mb-3 text-start";
                    pnlError.Visible = true;

                    Session.Remove("SuccessMessage");
                }
                else if (Session["ErrorMessage"] != null)
                {
                    lblMessage.Text = Session["ErrorMessage"].ToString();
                    pnlError.CssClass = "alert alert-danger py-2 px-3 small rounded-3 mb-3 text-start";
                    pnlError.Visible = true;

                    Session.Remove("ErrorMessage");
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            try
            {
                string username = txtUsername.Text.Trim();
                string password = txtPassword.Text.Trim();

                if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
                {
                    lblMessage.Text = "Please enter both Username and Password.";
                    pnlError.CssClass = "alert alert-danger py-2 px-3 small rounded-3 mb-3 text-start";
                    pnlError.Visible = true;
                    return;
                }

                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@Username", username),
                    new SqlParameter("@Password", password)
                };

                DataTable dt = DbConnection.ExecuteSelectStoredProcedure("sp_AuthenticateUser", parameters);

                if (dt != null && dt.Rows.Count > 0)
                {
                    DataRow userRow = dt.Rows[0];

                    Session["UserId"] = userRow["UserId"].ToString();
                    Session["Username"] = userRow["Username"].ToString();

                    string roleId = "";
                    if (dt.Columns.Contains("RoleId"))
                    {
                        roleId = userRow["RoleId"].ToString();
                        Session["RoleId"] = roleId;
                    }

                    string roleName = "";
                    if (dt.Columns.Contains("Role"))
                    {
                        roleName = userRow["Role"].ToString();
                    }
                    else if (dt.Columns.Contains("RoleName"))
                    {
                        roleName = userRow["RoleName"].ToString();
                    }
                    else if (dt.Columns.Contains("UserRole"))
                    {
                        roleName = userRow["UserRole"].ToString();
                    }

                   
                    if (roleId == "2" || roleName.Trim().Equals("Super Admin", StringComparison.OrdinalIgnoreCase))
                    {
                        roleName = "Super Admin";
                    }

                    Session["Role"] = roleName;
                    Session["UserRole"] = roleName;
                    Session["RoleName"] = roleName;

                    Response.Redirect("Dashboard.aspx", false);
                    Context.ApplicationInstance.CompleteRequest();
                }
                else
                {
                    lblMessage.Text = "Invalid username or password.";
                    pnlError.CssClass = "alert alert-danger py-2 px-3 small rounded-3 mb-3 text-start";
                    pnlError.Visible = true;
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Login failed: " + ex.Message;
                pnlError.CssClass = "alert alert-danger py-2 px-3 small rounded-3 mb-3 text-start";
                pnlError.Visible = true;
            }
        }
    }
}