using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebUI
{
    public partial class DeliveryManagement : System.Web.UI.Page
    {
        private string ConnStr => ConfigurationManager.ConnectionStrings["DeliveryDbConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null) { Response.Redirect("Login.aspx"); return; }

            if (!IsPostBack)
            {
                BindDropdowns();
                ResetFormToCreateMode();
                BindDeliveriesGrid();
            }
        }

        private void ResetFormToCreateMode()
        {
            hfDeliveryId.Value = "0";

            txtDeliveryDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            txtAddress.Text = string.Empty;
            txtNotes.Text = string.Empty;

            if (ddlCustomer.Items.Count > 0) ddlCustomer.SelectedIndex = 0;
            if (ddlDriver.Items.Count > 0) ddlDriver.SelectedIndex = 0;
            if (ddlStatus.Items.Count > 0) ddlStatus.SelectedIndex = 0;

            DataTable dt = new DataTable();
            dt.Columns.Add("ItemCode", typeof(string));
            dt.Columns.Add("ItemName", typeof(string));
            dt.Columns.Add("Quantity", typeof(int));

            dt.Rows.Add("", "", 1);
            ViewState["CurrentItems"] = dt;

            gvItems.DataSource = dt;
            gvItems.DataBind();
        }

        private void BindDropdowns()
        {
            using (SqlConnection con = new SqlConnection(ConnStr))
            {
                con.Open();

                using (SqlCommand cmd = new SqlCommand("SELECT CustomerId, CustomerName FROM Customers", con))
                {
                    DataTable dtCustomers = new DataTable();
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dtCustomers);
                    }
                    ddlCustomer.DataSource = dtCustomers;
                    ddlCustomer.DataTextField = "CustomerName";
                    ddlCustomer.DataValueField = "CustomerId";
                    ddlCustomer.DataBind();
                }

                using (SqlCommand cmd = new SqlCommand("SELECT DriverId, DriverName FROM Drivers", con))
                {
                    DataTable dtDrivers = new DataTable();
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dtDrivers);
                    }
                    ddlDriver.DataSource = dtDrivers;
                    ddlDriver.DataTextField = "DriverName";
                    ddlDriver.DataValueField = "DriverId";
                    ddlDriver.DataBind();
                }
            }
        }

        protected void btnAddRow_Click(object sender, EventArgs e)
        {
            SyncGridToDataTable();
            DataTable dt = (DataTable)ViewState["CurrentItems"];
            dt.Rows.Add("", "", 1);
            ViewState["CurrentItems"] = dt;
            gvItems.DataSource = dt;
            gvItems.DataBind();
        }

        protected void gvItems_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "RemoveRow")
            {
                SyncGridToDataTable();
                DataTable dt = (DataTable)ViewState["CurrentItems"];
                int index = Convert.ToInt32(e.CommandArgument);
                if (dt.Rows.Count > 1)
                {
                    dt.Rows.RemoveAt(index);
                    ViewState["CurrentItems"] = dt;
                    gvItems.DataSource = dt;
                    gvItems.DataBind();
                }
            }
        }

        private void SyncGridToDataTable()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("ItemCode", typeof(string));
            dt.Columns.Add("ItemName", typeof(string));
            dt.Columns.Add("Quantity", typeof(int));

            foreach (GridViewRow row in gvItems.Rows)
            {
                TextBox txtCode = (TextBox)row.FindControl("txtItemCode");
                TextBox txtName = (TextBox)row.FindControl("txtItemName");
                TextBox txtQty = (TextBox)row.FindControl("txtQuantity");

                dt.Rows.Add(txtCode.Text, txtName.Text, Convert.ToInt32(string.IsNullOrEmpty(txtQty.Text) ? "1" : txtQty.Text));
            }
            ViewState["CurrentItems"] = dt;
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtDeliveryDate.Text) || string.IsNullOrWhiteSpace(txtAddress.Text))
            {
                ShowAlert("Delivery Date and Delivery Address are required.", "danger");
                return;
            }

            SyncGridToDataTable();
            DataTable dtItems = (DataTable)ViewState["CurrentItems"];
            int currentUserId = Convert.ToInt32(Session["UserId"]);
            int deliveryId = !string.IsNullOrEmpty(hfDeliveryId.Value) ? Convert.ToInt32(hfDeliveryId.Value) : 0;

            string role = Session["Role"]?.ToString() ?? "";
            string roleId = Session["RoleId"]?.ToString() ?? "";
            bool isSuperAdmin = roleId == "2" || role.Equals("Super Admin", StringComparison.OrdinalIgnoreCase);

            using (SqlConnection con = new SqlConnection(ConnStr))
            {
                con.Open();

                if (deliveryId > 0 && !isSuperAdmin)
                {
                    int createdBy = 0;
                    using (SqlCommand cmdCheck = new SqlCommand(
                        "SELECT CreatedBy FROM Deliveries WHERE DeliveryId = @Id", con))
                    {
                        cmdCheck.Parameters.AddWithValue("@Id", deliveryId);
                        object result = cmdCheck.ExecuteScalar();

                        if (result == null)
                        {
                            ShowAlert("Delivery record not found. It may have been deleted.", "danger");
                            ResetFormToCreateMode();
                            BindDeliveriesGrid();
                            return;
                        }
                        createdBy = Convert.ToInt32(result);
                    }

                    if (createdBy != currentUserId)
                    {
                        ShowAlert("Permission Denied! You do not have access to change this record.", "danger");
                        ResetFormToCreateMode();
                        BindDeliveriesGrid();
                        return;
                    }
                }

                SqlTransaction tran = con.BeginTransaction();

                try
                {
                    int targetDeliveryId;

                    if (deliveryId > 0)
                    {
                        targetDeliveryId = deliveryId;

                        using (SqlCommand cmdUpdate = new SqlCommand("sp_UpdateDeliveryRecord", con, tran))
                        {
                            cmdUpdate.CommandType = CommandType.StoredProcedure;
                            cmdUpdate.Parameters.AddWithValue("@DeliveryId", targetDeliveryId);
                            cmdUpdate.Parameters.AddWithValue("@DeliveryDate", txtDeliveryDate.Text);
                            cmdUpdate.Parameters.AddWithValue("@CustomerId", ddlCustomer.SelectedValue);
                            cmdUpdate.Parameters.AddWithValue("@DriverId", ddlDriver.SelectedValue);
                            cmdUpdate.Parameters.AddWithValue("@DeliveryAddress", txtAddress.Text);
                            cmdUpdate.Parameters.AddWithValue("@DeliveryNotes", txtNotes.Text);
                            cmdUpdate.Parameters.AddWithValue("@CurrentStatus", ddlStatus.SelectedValue);
                            cmdUpdate.ExecuteNonQuery();
                        }

                        using (SqlCommand cmdDelItems = new SqlCommand("DELETE FROM DeliveryItems WHERE DeliveryId = @DeliveryId", con, tran))
                        {
                            cmdDelItems.Parameters.AddWithValue("@DeliveryId", targetDeliveryId);
                            cmdDelItems.ExecuteNonQuery();
                        }
                    }
                    else
                    {
                        string insertMaster = @"INSERT INTO Deliveries (DeliveryDate, CustomerId, DriverId, DeliveryAddress, DeliveryNotes, CurrentStatus, CreatedBy)
                                                OUTPUT INSERTED.DeliveryId
                                                VALUES (@Date, @Cust, @Driver, @Addr, @Notes, @Status, @CreatedBy)";

                        SqlCommand cmdMaster = new SqlCommand(insertMaster, con, tran);
                        cmdMaster.Parameters.AddWithValue("@Date", txtDeliveryDate.Text);
                        cmdMaster.Parameters.AddWithValue("@Cust", ddlCustomer.SelectedValue);
                        cmdMaster.Parameters.AddWithValue("@Driver", ddlDriver.SelectedValue);
                        cmdMaster.Parameters.AddWithValue("@Addr", txtAddress.Text);
                        cmdMaster.Parameters.AddWithValue("@Notes", txtNotes.Text);
                        cmdMaster.Parameters.AddWithValue("@Status", ddlStatus.SelectedValue);
                        cmdMaster.Parameters.AddWithValue("@CreatedBy", currentUserId);

                        targetDeliveryId = (int)cmdMaster.ExecuteScalar();
                    }

                    foreach (DataRow dr in dtItems.Rows)
                    {
                        string insertItem = @"INSERT INTO DeliveryItems (DeliveryId, ItemCode, ItemName, Quantity)
                                              VALUES (@DeliveryId, @Code, @Name, @Qty)";
                        SqlCommand cmdItem = new SqlCommand(insertItem, con, tran);
                        cmdItem.Parameters.AddWithValue("@DeliveryId", targetDeliveryId);
                        cmdItem.Parameters.AddWithValue("@Code", dr["ItemCode"]);
                        cmdItem.Parameters.AddWithValue("@Name", dr["ItemName"]);
                        cmdItem.Parameters.AddWithValue("@Qty", dr["Quantity"]);
                        cmdItem.ExecuteNonQuery();
                    }

                    tran.Commit();

                    string msg = deliveryId > 0 ? $"Delivery #{deliveryId} updated successfully." : "New delivery record created successfully.";
                    ShowAlert(msg, "success");

                    ResetFormToCreateMode();
                    BindDeliveriesGrid();
                }
                catch (Exception ex)
                {
                    tran.Rollback();
                    ShowAlert("Error saving delivery: " + ex.Message, "danger");
                }
            }
        }

        private void BindDeliveriesGrid()
        {
            using (SqlConnection con = new SqlConnection(ConnStr))
            {
                string query = @"SELECT d.DeliveryId, d.DeliveryNumber, d.DeliveryDate, d.DeliveryAddress,
                                         d.DeliveryNotes, d.CurrentStatus, d.CreatedBy,
                                         c.CustomerName, dr.DriverName
                                  FROM Deliveries d
                                  LEFT JOIN Customers c ON c.CustomerId = d.CustomerId
                                  LEFT JOIN Drivers dr ON dr.DriverId = d.DriverId
                                  ORDER BY d.DeliveryId DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvDeliveries.DataSource = dt;
                    gvDeliveries.DataBind();
                }
            }
        }

        protected void gvDeliveries_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditRow" || e.CommandName == "DeleteRow")
            {
                int index = Convert.ToInt32(e.CommandArgument);

                int deliveryId = Convert.ToInt32(gvDeliveries.DataKeys[index].Values["DeliveryId"]);
                string createdBy = gvDeliveries.DataKeys[index].Values["CreatedBy"]?.ToString() ?? "";

                string role = Session["Role"]?.ToString() ?? "";
                string roleId = Session["RoleId"]?.ToString() ?? "";
                string currentUserId = Session["UserId"]?.ToString() ?? "";

                bool isSuperAdmin = roleId == "2" || role.Equals("Super Admin", StringComparison.OrdinalIgnoreCase);
                bool isOwner = createdBy == currentUserId;

                if (!isSuperAdmin && !isOwner)
                {
                    ShowAlert("Permission Denied! You do not have access to change or delete this record.", "danger");
                    return;
                }

                if (e.CommandName == "EditRow")
                {
                    LoadDeliveryForEdit(deliveryId);
                }
                else if (e.CommandName == "DeleteRow")
                {
                    DeleteDeliveryRecord(deliveryId);
                }
            }
        }

        private void LoadDeliveryForEdit(int deliveryId)
        {
            using (SqlConnection con = new SqlConnection(ConnStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_GetDeliveryDetails", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@DeliveryId", deliveryId);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataSet ds = new DataSet();
                    da.Fill(ds);

                    if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {

                        hfDeliveryId.Value = deliveryId.ToString();

                        DataRow dr = ds.Tables[0].Rows[0];
                        txtDeliveryDate.Text = Convert.ToDateTime(dr["DeliveryDate"]).ToString("yyyy-MM-dd");

                        if (ddlCustomer.Items.FindByValue(dr["CustomerId"].ToString()) != null)
                            ddlCustomer.SelectedValue = dr["CustomerId"].ToString();

                        if (ddlDriver.Items.FindByValue(dr["DriverId"].ToString()) != null)
                            ddlDriver.SelectedValue = dr["DriverId"].ToString();

                        txtAddress.Text = dr["DeliveryAddress"].ToString();
                        txtNotes.Text = dr["DeliveryNotes"]?.ToString() ?? "";

                        if (ddlStatus.Items.FindByValue(dr["CurrentStatus"].ToString()) != null)
                            ddlStatus.SelectedValue = dr["CurrentStatus"].ToString();
                    }

                    if (ds.Tables.Count > 1 && ds.Tables[1].Rows.Count > 0)
                    {
                        DataTable dtItems = ds.Tables[1];
                        ViewState["CurrentItems"] = dtItems;
                        gvItems.DataSource = dtItems;
                        gvItems.DataBind();
                    }
                    else
                    {
                        DataTable dt = new DataTable();
                        dt.Columns.Add("ItemCode", typeof(string));
                        dt.Columns.Add("ItemName", typeof(string));
                        dt.Columns.Add("Quantity", typeof(int));
                        dt.Rows.Add("", "", 1);

                        ViewState["CurrentItems"] = dt;
                        gvItems.DataSource = dt;
                        gvItems.DataBind();
                    }
                }
            }

            ShowAlert($"Delivery #{deliveryId} loaded successfully for editing.", "info");
        }

        private void DeleteDeliveryRecord(int deliveryId)
        {
            using (SqlConnection con = new SqlConnection(ConnStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_DeleteDeliveryRecord", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@DeliveryId", deliveryId);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            ShowAlert("Delivery record deleted successfully.", "success");
            ResetFormToCreateMode();
            BindDeliveriesGrid();
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Login.aspx");
        }

        private void ShowAlert(string msg, string type)
        {
            lblAlert.Text = msg;
            pnlAlert.CssClass = $"alert alert-{type}";
            pnlAlert.Visible = true;
        }
    }
}