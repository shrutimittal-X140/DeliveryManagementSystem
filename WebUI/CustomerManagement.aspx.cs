using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebUI
{
    public partial class CustomerManagement : System.Web.UI.Page
    {
        private string GetConnectionString()
        {
            return ConfigurationManager.ConnectionStrings["DeliveryDbConn"].ConnectionString;
        }

        private T FindControlRecursive<T>(Control root, string id) where T : Control
        {
            if (root == null) return null;
            if (root.ID == id && root is T control) return control;

            foreach (Control child in root.Controls)
            {
                T foundChild = FindControlRecursive<T>(child, id);
                if (foundChild != null) return foundChild;
            }
            return null;
        }

        private bool IsSuperAdmin()
        {
            string role = (Session["RoleId"] ?? Session["Role"] ?? Session["UserRole"])?.ToString().Trim() ?? "";
            int.TryParse(role, out int roleId);

        
            return roleId == 2 || role.Equals("Super Admin", StringComparison.OrdinalIgnoreCase);
        }

        private bool IsAdmin()
        {
            string role = (Session["RoleId"] ?? Session["Role"] ?? Session["UserRole"])?.ToString().Trim() ?? "";
            int.TryParse(role, out int roleId);

         
            return roleId == 1 || role.Equals("Admin", StringComparison.OrdinalIgnoreCase);
        }

        private bool HasPageAccess()
        {
            return IsSuperAdmin() || IsAdmin();
        }

        private string GetCurrentUserId()
        {
            return (Session["UserId"] ?? Session["UserName"] ?? Session["User"])?.ToString().Trim() ?? "";
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserId"] == null)
                {
                    Session["ErrorMessage"] = "Please sign in to access Customer Management.";
                    Response.Redirect("Login.aspx", false);
                    Context.ApplicationInstance.CompleteRequest();
                    return;
                }

                if (!HasPageAccess())
                {
                    Session["ErrorMessage"] = "Access Restricted: You do not have permission to access Customer Management.";
                    Response.Redirect("Dashboard.aspx", false);
                    Context.ApplicationInstance.CompleteRequest();
                    return;
                }

                LoadCustomers();
            }
        }

        public void LoadCustomers(string searchQuery = "")
        {
            string connStr = GetConnectionString();

            using (SqlConnection con = new SqlConnection(connStr))
            {
                // ISNULL and NULLIF handle empty/null database fields so table cells display '-' instead of invisible blank spaces
                string query = @"SELECT 
                                    CustomerId, 
                                    CustomerCode, 
                                    CustomerName, 
                                    ISNULL(NULLIF(ContactPerson, ''), '-') AS ContactPerson, 
                                    ISNULL(NULLIF(PhoneNumber, ''), '-') AS PhoneNumber, 
                                    ISNULL(NULLIF(Email, ''), '-') AS Email, 
                                    ISNULL(NULLIF(DeliveryAddress, ''), '-') AS DeliveryAddress, 
                                    CreatedBy 
                                 FROM Customers";

                if (!string.IsNullOrEmpty(searchQuery))
                {
                    query += " WHERE CustomerName LIKE @Search OR CustomerCode LIKE @Search OR PhoneNumber LIKE @Search OR Email LIKE @Search";
                }

                query += " ORDER BY CustomerId DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    if (!string.IsNullOrEmpty(searchQuery))
                    {
                        cmd.Parameters.AddWithValue("@Search", "%" + searchQuery.Trim() + "%");
                    }

                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);

                        GridView gvCustomers = FindControlRecursive<GridView>(Page, "gvCustomers");
                        if (gvCustomers != null)
                        {
                            gvCustomers.DataSource = dt;
                            gvCustomers.DataBind();
                        }
                    }
                }
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            TextBox txtSearch = FindControlRecursive<TextBox>(Page, "txtSearch");
            string query = txtSearch != null ? txtSearch.Text : "";
            LoadCustomers(query);
        }

        protected void btnSaveCustomer_Click(object sender, EventArgs e)
        {
            if (!HasPageAccess())
            {
                ShowAlert("Access Restricted: You do not have permission to perform this action.");
                return;
            }

            HiddenField hfCustomerId = FindControlRecursive<HiddenField>(Page, "hfCustomerId");
            TextBox txtCustomerCode = FindControlRecursive<TextBox>(Page, "txtCustomerCode");
            TextBox txtCustomerName = FindControlRecursive<TextBox>(Page, "txtCustomerName");
            TextBox txtContactPerson = FindControlRecursive<TextBox>(Page, "txtContactPerson");
            TextBox txtPhoneNumber = FindControlRecursive<TextBox>(Page, "txtPhoneNumber");
            TextBox txtEmail = FindControlRecursive<TextBox>(Page, "txtEmail");
            TextBox txtDeliveryAddress = FindControlRecursive<TextBox>(Page, "txtDeliveryAddress");

            int customerId = 0;
            if (hfCustomerId != null && !string.IsNullOrEmpty(hfCustomerId.Value))
            {
                int.TryParse(hfCustomerId.Value, out customerId);
            }

            if (customerId > 0 && !CanUserModifyCustomer(customerId))
            {
                ShowAlert("Access Denied: You do not have access to modify this customer as it was created by another user.");
                return;
            }

            string customerCode = txtCustomerCode?.Text.Trim();
            string customerName = txtCustomerName?.Text.Trim();
            string contactPerson = txtContactPerson?.Text.Trim();
            string phoneNumber = txtPhoneNumber?.Text.Trim();
            string email = txtEmail?.Text.Trim();
            string deliveryAddress = txtDeliveryAddress?.Text.Trim();

            if (string.IsNullOrEmpty(customerName))
            {
                ShowAlert("Customer Name is required!");
                OpenModalScript();
                return;
            }

            if (string.IsNullOrEmpty(customerCode))
            {
                customerCode = "CUST-" + DateTime.Now.Ticks.ToString().Substring(12);
            }

            string connStr = GetConnectionString();

            using (SqlConnection con = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;

                    if (customerId > 0)
                    {
                        cmd.CommandText = "sp_UpdateCustomer";
                        cmd.Parameters.AddWithValue("@CustomerId", customerId);
                    }
                    else
                    {
                        cmd.CommandText = "sp_SaveCustomer";
                        cmd.Parameters.AddWithValue("@CreatedBy", GetCurrentUserId());
                    }

                    cmd.Parameters.AddWithValue("@CustomerCode", customerCode);
                    cmd.Parameters.AddWithValue("@CustomerName", customerName);
                    cmd.Parameters.AddWithValue("@ContactPerson", string.IsNullOrEmpty(contactPerson) ? (object)DBNull.Value : contactPerson);
                    cmd.Parameters.AddWithValue("@PhoneNumber", string.IsNullOrEmpty(phoneNumber) ? (object)DBNull.Value : phoneNumber);
                    cmd.Parameters.AddWithValue("@Email", string.IsNullOrEmpty(email) ? (object)DBNull.Value : email);
                    cmd.Parameters.AddWithValue("@DeliveryAddress", string.IsNullOrEmpty(deliveryAddress) ? (object)DBNull.Value : deliveryAddress);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            ClearFormFields();
            LoadCustomers();
        }

        protected void gvCustomers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditCustomer")
            {
                int customerId = Convert.ToInt32(e.CommandArgument);

                if (!CanUserModifyCustomer(customerId))
                {
                    ShowAlert("Access Denied: You do not have access to edit this customer as it was created by another user.");
                    return;
                }

                LoadCustomerForEdit(customerId);
            }
            else if (e.CommandName == "DeleteCustomer")
            {
                int customerId = Convert.ToInt32(e.CommandArgument);

                if (!CanUserModifyCustomer(customerId))
                {
                    ShowAlert("Access Denied: You do not have access to delete this customer as it was created by another user.");
                    return;
                }

                DeleteCustomer(customerId);
                ClearFormFields();
                LoadCustomers();
            }
        }

        private bool CanUserModifyCustomer(int customerId)
        {
            // Super Admin (RoleId = 2) has full edit & delete permissions
            if (IsSuperAdmin()) return true;

            // Admin (RoleId = 1) can edit or delete only entries created by themselves
            if (IsAdmin())
            {
                string creatorId = GetCustomerCreatorId(customerId);
                string currentUserId = GetCurrentUserId();

                return !string.IsNullOrEmpty(creatorId) && creatorId.Equals(currentUserId, StringComparison.OrdinalIgnoreCase);
            }

            return false;
        }

        private string GetCustomerCreatorId(int customerId)
        {
            string creator = "";
            string connStr = GetConnectionString();

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "SELECT CreatedBy FROM Customers WHERE CustomerId = @CustomerId";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@CustomerId", customerId);
                    con.Open();
                    object result = cmd.ExecuteScalar();
                    if (result != null && result != DBNull.Value)
                    {
                        creator = result.ToString();
                    }
                }
            }
            return creator;
        }

        private void LoadCustomerForEdit(int customerId)
        {
            string connStr = GetConnectionString();

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "SELECT CustomerId, CustomerCode, CustomerName, ContactPerson, PhoneNumber, Email, DeliveryAddress FROM Customers WHERE CustomerId = @CustomerId";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@CustomerId", customerId);
                    con.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            HiddenField hfCustomerId = FindControlRecursive<HiddenField>(Page, "hfCustomerId");
                            TextBox txtCustomerCode = FindControlRecursive<TextBox>(Page, "txtCustomerCode");
                            TextBox txtCustomerName = FindControlRecursive<TextBox>(Page, "txtCustomerName");
                            TextBox txtContactPerson = FindControlRecursive<TextBox>(Page, "txtContactPerson");
                            TextBox txtPhoneNumber = FindControlRecursive<TextBox>(Page, "txtPhoneNumber");
                            TextBox txtEmail = FindControlRecursive<TextBox>(Page, "txtEmail");
                            TextBox txtDeliveryAddress = FindControlRecursive<TextBox>(Page, "txtDeliveryAddress");
                            Button btnSaveCustomer = FindControlRecursive<Button>(Page, "btnSaveCustomer");

                            if (hfCustomerId != null) hfCustomerId.Value = reader["CustomerId"].ToString();
                            if (txtCustomerCode != null) txtCustomerCode.Text = reader["CustomerCode"].ToString();
                            if (txtCustomerName != null) txtCustomerName.Text = reader["CustomerName"].ToString();
                            if (txtContactPerson != null) txtContactPerson.Text = reader["ContactPerson"] != DBNull.Value ? reader["ContactPerson"].ToString() : "";
                            if (txtPhoneNumber != null) txtPhoneNumber.Text = reader["PhoneNumber"] != DBNull.Value ? reader["PhoneNumber"].ToString() : "";
                            if (txtEmail != null) txtEmail.Text = reader["Email"] != DBNull.Value ? reader["Email"].ToString() : "";
                            if (txtDeliveryAddress != null) txtDeliveryAddress.Text = reader["DeliveryAddress"] != DBNull.Value ? reader["DeliveryAddress"].ToString() : "";

                            if (btnSaveCustomer != null) btnSaveCustomer.Text = "Update Customer";

                            // Triggers modal via pure JavaScript to bypass jQuery ($) reference errors
                            OpenModalScript();
                        }
                    }
                }
            }
        }

        private void OpenModalScript()
        {
            string script = @"
                setTimeout(function() {
                    var el = document.getElementById('customerModal');
                    if (el) {
                        if (typeof bootstrap !== 'undefined' && bootstrap.Modal) {
                            var myModal = bootstrap.Modal.getOrCreateInstance(el);
                            myModal.show();
                        } else if (typeof $ !== 'undefined') {
                            $('#customerModal').modal('show');
                        } else {
                            el.style.display = 'block';
                            el.classList.add('show');
                            document.body.classList.add('modal-open');
                            
                            if (!document.getElementById('customModalBackdrop')) {
                                var backdrop = document.createElement('div');
                                backdrop.id = 'customModalBackdrop';
                                backdrop.className = 'modal-backdrop fade show';
                                document.body.appendChild(backdrop);
                            }
                        }
                    }
                }, 100);";

            ScriptManager.RegisterStartupScript(this, GetType(), "OpenCustomerModalScript", script, true);
        }

        private void ShowAlert(string message)
        {
            string script = $"alert('{message.Replace("'", "\\'")}');";
            ScriptManager.RegisterStartupScript(this, GetType(), "AlertMessageScript", script, true);
        }

        private void ClearFormFields()
        {
            HiddenField hfCustomerId = FindControlRecursive<HiddenField>(Page, "hfCustomerId");
            TextBox txtCustomerCode = FindControlRecursive<TextBox>(Page, "txtCustomerCode");
            TextBox txtCustomerName = FindControlRecursive<TextBox>(Page, "txtCustomerName");
            TextBox txtContactPerson = FindControlRecursive<TextBox>(Page, "txtContactPerson");
            TextBox txtPhoneNumber = FindControlRecursive<TextBox>(Page, "txtPhoneNumber");
            TextBox txtEmail = FindControlRecursive<TextBox>(Page, "txtEmail");
            TextBox txtDeliveryAddress = FindControlRecursive<TextBox>(Page, "txtDeliveryAddress");
            Button btnSaveCustomer = FindControlRecursive<Button>(Page, "btnSaveCustomer");

            if (hfCustomerId != null) hfCustomerId.Value = "0";
            if (txtCustomerCode != null) txtCustomerCode.Text = "";
            if (txtCustomerName != null) txtCustomerName.Text = "";
            if (txtContactPerson != null) txtContactPerson.Text = "";
            if (txtPhoneNumber != null) txtPhoneNumber.Text = "";
            if (txtEmail != null) txtEmail.Text = "";
            if (txtDeliveryAddress != null) txtDeliveryAddress.Text = "";
            if (btnSaveCustomer != null) btnSaveCustomer.Text = "Save Customer";
        }

        private void DeleteCustomer(int customerId)
        {
            string connStr = GetConnectionString();

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "DELETE FROM Customers WHERE CustomerId = @CustomerId";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@CustomerId", customerId);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        protected void gvCustomers_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridView gvCustomers = FindControlRecursive<GridView>(Page, "gvCustomers");
            if (gvCustomers != null)
            {
                gvCustomers.PageIndex = e.NewPageIndex;
                LoadCustomers();
            }
        }
    }
}