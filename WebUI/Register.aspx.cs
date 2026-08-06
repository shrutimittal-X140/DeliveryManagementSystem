using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace WebUI
{
    public partial class Register : System.Web.UI.Page
    {
        private string GetConnectionString()
        {
            if (ConfigurationManager.ConnectionStrings["DBConnection"] != null)
            {
                return ConfigurationManager.ConnectionStrings["DBConnection"].ConnectionString;
            }
            if (ConfigurationManager.ConnectionStrings["DefaultConnection"] != null)
            {
                return ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            }
            if (ConfigurationManager.ConnectionStrings.Count > 0)
            {
                return ConfigurationManager.ConnectionStrings[ConfigurationManager.ConnectionStrings.Count - 1].ConnectionString;
            }

            return @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=DeliveryManagementDB;Integrated Security=True;";
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindRoles();
            }
        }

        private void BindRoles()
        {
            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                using (SqlCommand cmd = new SqlCommand("SELECT RoleId, RoleName FROM Roles", con))
                {
                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        ddlRole.DataSource = dr;
                        ddlRole.DataTextField = "RoleName"; 
                        ddlRole.DataValueField = "RoleId";   
                        ddlRole.DataBind();
                    }
                }
            }
        }
        protected void btnRegister_Click(object sender, EventArgs e)
        {
            try
            {
              
                string fullName = txtFullName.Text.Trim();
                string username = txtUsername.Text.Trim();
                string password = txtPassword.Text.Trim();
                int roleId = Convert.ToInt32(ddlRole.SelectedValue);

                if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
                {
                    lblMessage.Text = "Please enter all required fields.";
                    lblMessage.CssClass = "d-block mb-3 text-start small fw-bold text-danger";
                    return;
                }

                string connStr = GetConnectionString();

                using (SqlConnection con = new SqlConnection(connStr))
                {
        
                    string query = @"INSERT INTO Users (Username, Password, FullName, RoleId) 
                                     VALUES (@Username, @Password, @FullName, @RoleId)";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@Username", username);
                        cmd.Parameters.AddWithValue("@Password", password);
                        cmd.Parameters.AddWithValue("@FullName", fullName);
                        cmd.Parameters.AddWithValue("@RoleId", roleId);

                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

            
                Session["SuccessMessage"] = "Account registered successfully! Please sign in.";
                Response.Redirect("Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Registration failed: " + ex.Message;
                lblMessage.CssClass = "d-block mb-3 text-start small fw-bold text-danger";
            }
        }
    }
}