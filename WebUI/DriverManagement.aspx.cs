using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebUI
{
    public partial class DriverManagement : Page
    {
        private string ConnStr
        {
            get
            {
                var connSetting = ConfigurationManager.ConnectionStrings["DeliveryDbConn"];
                if (connSetting == null || string.IsNullOrEmpty(connSetting.ConnectionString))
                {
                    throw new Exception("Connection string 'DeliveryDbConn' was not found in Web.config.");
                }
                return connSetting.ConnectionString;
            }
        }

        private string CurrentUserId
        {
            get
            {
                if (Session["UserId"] != null) return Session["UserId"].ToString();
                if (Session["User_Id"] != null) return Session["User_Id"].ToString();
                if (Session["ID"] != null) return Session["ID"].ToString();
                if (Session["User"] != null) return Session["User"].ToString();
                if (Session["Username"] != null) return Session["Username"].ToString();
                return "SESSION_USER_NULL";
            }
        }

        private string CurrentUserRole
        {
            get
            {
                if (Session["Role"] != null) return Session["Role"].ToString();
                if (Session["UserRole"] != null) return Session["UserRole"].ToString();
                if (Session["RoleName"] != null) return Session["RoleName"].ToString();
                if (Session["RoleId"] != null) return Session["RoleId"].ToString();
                return "SESSION_ROLE_NULL";
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindDriverGrid();
                LoadMetrics();
            }
        }

        private void BindDriverGrid(string searchKey = "")
        {
            using (SqlConnection con = new SqlConnection(ConnStr))
            {
                string query = @"SELECT d.DriverId, 
                                        d.DriverCode, 
                                        d.DriverName, 
                                        d.PhoneNumber, 
                                        d.Email, 
                                        d.VehicleNumber, 
                                        d.IsActive, 
                                        ISNULL(u.Username, d.CreatedBy) AS CreatedBy 
                                 FROM Drivers d
                                 LEFT JOIN Users u ON TRY_CAST(d.CreatedBy AS INT) = u.UserId";

                if (!string.IsNullOrWhiteSpace(searchKey))
                {
                    query += " WHERE d.DriverName LIKE @Search OR d.DriverCode LIKE @Search OR d.PhoneNumber LIKE @Search";
                }
                query += " ORDER BY d.DriverId DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    if (!string.IsNullOrWhiteSpace(searchKey))
                    {
                        cmd.Parameters.AddWithValue("@Search", "%" + searchKey.Trim() + "%");
                    }
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        dt.Columns.Add("LoggedUserRole", typeof(string));
                        dt.Columns.Add("LoggedUserId", typeof(string));

                        foreach (DataRow row in dt.Rows)
                        {
                            row["LoggedUserRole"] = CurrentUserRole;
                            row["LoggedUserId"] = CurrentUserId;
                        }

                        gvDrivers.DataSource = dt;
                        gvDrivers.DataBind();
                    }
                }
            }
        }

        private void LoadMetrics()
        {
            using (SqlConnection con = new SqlConnection(ConnStr))
            {
                con.Open();

                using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Drivers", con))
                {
                    int totalDrivers = Convert.ToInt32(cmd.ExecuteScalar());
                    lblTotalDrivers.Text = totalDrivers.ToString();
                }

                using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Customers", con))
                {
                    int totalCustomers = Convert.ToInt32(cmd.ExecuteScalar());
                    lblTotalCustomers.Text = totalCustomers.ToString();
                }

                using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Deliveries", con))
                {
                    int totalDeliveries = Convert.ToInt32(cmd.ExecuteScalar());
                    lblTotalDeliveries.Text = totalDeliveries.ToString();
                }
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            gvDrivers.PageIndex = 0;
            BindDriverGrid(txtSearch.Text);
        }

        protected void gvDrivers_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvDrivers.PageIndex = e.NewPageIndex;
            BindDriverGrid(txtSearch.Text);
        }

        protected void btnOpenAddModal_Click(object sender, EventArgs e)
        {
            ClearModalFields();
            litModalTitle.Text = "Add Driver";
            ScriptManager.RegisterStartupScript(this, GetType(), "ShowModal", "openDriverModal();", true);
        }

        protected void gvDrivers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName != "EditDriver" && e.CommandName != "DeleteDriver") return;

            int driverId = Convert.ToInt32(e.CommandArgument);

            string createdBy = GetDriverCreatedBy(driverId);

            string role = CurrentUserRole.Trim();
            string userId = CurrentUserId.Trim();

            bool isSuperAdmin = role.Equals("Super Admin", StringComparison.OrdinalIgnoreCase) ||
                                role.Equals("SuperAdmin", StringComparison.OrdinalIgnoreCase) ||
                                role.Equals("2", StringComparison.OrdinalIgnoreCase);

            bool isCreator = !string.IsNullOrEmpty(userId) &&
                             createdBy.Trim().Equals(userId, StringComparison.OrdinalIgnoreCase);

            if (!isSuperAdmin && !isCreator)
            {
                ShowAlert("Permission Denied! You do not have access to edit or delete this record because it was created by another user.");
                return;
            }

            if (e.CommandName == "EditDriver")
            {
                LoadDriverForEdit(driverId);
                litModalTitle.Text = "Edit Driver";
                ScriptManager.RegisterStartupScript(this, GetType(), "ShowModal", "openDriverModal();", true);
            }
            else if (e.CommandName == "DeleteDriver")
            {
                DeleteDriver(driverId);
                BindDriverGrid(txtSearch.Text);
                LoadMetrics();
            }
        }

        private string GetDriverCreatedBy(int driverId)
        {
            string createdBy = string.Empty;
            using (SqlConnection con = new SqlConnection(ConnStr))
            {
                using (SqlCommand cmd = new SqlCommand("SELECT ISNULL(CreatedBy, '') FROM Drivers WHERE DriverId = @DriverId", con))
                {
                    cmd.Parameters.AddWithValue("@DriverId", driverId);
                    con.Open();
                    object result = cmd.ExecuteScalar();
                    if (result != null)
                    {
                        createdBy = result.ToString();
                    }
                }
            }
            return createdBy;
        }

        private void LoadDriverForEdit(int driverId)
        {
            using (SqlConnection con = new SqlConnection(ConnStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_GetDriverById", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@DriverId", driverId);

                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            hfDriverId.Value = dr["DriverId"].ToString();
                            txtDriverCode.Text = dr["DriverCode"].ToString();
                            txtDriverName.Text = dr["DriverName"].ToString();
                            txtPhoneNumber.Text = dr["PhoneNumber"].ToString();
                            txtEmail.Text = dr["Email"].ToString();
                            txtVehicleNumber.Text = dr["VehicleNumber"].ToString();
                            ddlStatus.SelectedValue = Convert.ToBoolean(dr["IsActive"]).ToString().ToLower();
                        }
                    }
                }
            }
        }

        protected void btnSaveDriver_Click(object sender, EventArgs e)
        {
            int driverId = Convert.ToInt32(hfDriverId.Value);

            if (driverId > 0)
            {
                string createdBy = GetDriverCreatedBy(driverId);
                string role = CurrentUserRole.Trim();
                string userId = CurrentUserId.Trim();

                bool isSuperAdmin = role.Equals("Super Admin", StringComparison.OrdinalIgnoreCase) ||
                                    role.Equals("SuperAdmin", StringComparison.OrdinalIgnoreCase) ||
                                    role.Equals("2", StringComparison.OrdinalIgnoreCase);

                bool isCreator = !string.IsNullOrEmpty(userId) &&
                                 createdBy.Trim().Equals(userId, StringComparison.OrdinalIgnoreCase);

                if (!isSuperAdmin && !isCreator)
                {
                    ShowAlert("Permission Denied! You do not have access to edit or delete this record because it was created by another user.");
                    ScriptManager.RegisterStartupScript(this, GetType(), "HideModal", "hideDriverModal();", true);
                    BindDriverGrid(txtSearch.Text);
                    return;
                }
            }

            using (SqlConnection con = new SqlConnection(ConnStr))
            {
                using (SqlCommand cmd = new SqlCommand(driverId == 0 ? "sp_SaveDriver" : "sp_UpdateDriver", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    if (driverId > 0)
                    {
                        cmd.Parameters.AddWithValue("@DriverId", driverId);
                    }

                    cmd.Parameters.AddWithValue("@DriverCode", txtDriverCode.Text.Trim());
                    cmd.Parameters.AddWithValue("@DriverName", txtDriverName.Text.Trim());
                    cmd.Parameters.AddWithValue("@PhoneNumber", txtPhoneNumber.Text.Trim());
                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                    cmd.Parameters.AddWithValue("@VehicleNumber", txtVehicleNumber.Text.Trim());
                    cmd.Parameters.AddWithValue("@IsActive", Convert.ToBoolean(ddlStatus.SelectedValue));

                    if (driverId == 0)
                    {
                        cmd.Parameters.AddWithValue("@CreatedBy", !string.IsNullOrEmpty(CurrentUserId) ? CurrentUserId : "Admin");
                    }

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            ScriptManager.RegisterStartupScript(this, GetType(), "HideModal", "hideDriverModal();", true);
            BindDriverGrid(txtSearch.Text);
            LoadMetrics();
            ClearModalFields();
        }

        private void DeleteDriver(int driverId)
        {
            using (SqlConnection con = new SqlConnection(ConnStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_DeleteDriver", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@DriverId", driverId);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void ClearModalFields()
        {
            hfDriverId.Value = "0";
            txtDriverCode.Text = string.Empty;
            txtDriverName.Text = string.Empty;
            txtPhoneNumber.Text = string.Empty;
            txtEmail.Text = string.Empty;
            txtVehicleNumber.Text = string.Empty;
            ddlStatus.SelectedValue = "true";
        }

        private void ShowAlert(string message)
        {
            string script = $"alert('{message.Replace("'", "\\'")}');";
            ScriptManager.RegisterStartupScript(this, GetType(), "AccessDeniedAlert", script, true);
        }
    }
}