using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace WebUI
{
    public partial class DeliveryUpdate : System.Web.UI.Page
    {
        private string ConnStr => ConfigurationManager.ConnectionStrings["DeliveryDbConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                BindDeliveriesDropdown(0);
            }
        }

        private void BindDeliveriesDropdown(int selectDeliveryId)
        {
            using (SqlConnection con = new SqlConnection(ConnStr))
            {
                string query = "SELECT DeliveryId, (DeliveryNumber + ' - ' + CurrentStatus) AS DisplayText FROM Deliveries ORDER BY DeliveryId DESC";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        ddlDeliveries.DataSource = reader;
                        ddlDeliveries.DataTextField = "DisplayText";
                        ddlDeliveries.DataValueField = "DeliveryId";
                        ddlDeliveries.DataBind();
                    }
                }
            }

            if (ddlDeliveries.Items.Count == 0) return;

            if (selectDeliveryId > 0 && ddlDeliveries.Items.FindByValue(selectDeliveryId.ToString()) != null)
            {
                ddlDeliveries.SelectedValue = selectDeliveryId.ToString();
            }

            LoadDeliveryRecord(Convert.ToInt32(ddlDeliveries.SelectedValue));
        }

        protected void ddlDeliveries_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDeliveryRecord(Convert.ToInt32(ddlDeliveries.SelectedValue));
        }

        private void LoadDeliveryRecord(int deliveryId)
        {
            using (SqlConnection con = new SqlConnection(ConnStr))
            {
                string query = "SELECT CurrentStatus, DeliveryNotes, FailureReason, DeliveredAt FROM Deliveries WHERE DeliveryId = @id";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@id", deliveryId);
                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            string status = dr["CurrentStatus"].ToString();
                            if (ddlStatus.Items.FindByValue(status) != null)
                            {
                                ddlStatus.SelectedValue = status;
                            }

                            txtNotes.Text = dr["DeliveryNotes"] == DBNull.Value ? "" : dr["DeliveryNotes"].ToString();
                            txtFailureReason.Text = dr["FailureReason"] == DBNull.Value ? "" : dr["FailureReason"].ToString();

                            pnlFailure.Visible = (ddlStatus.SelectedValue == "Failed");

                            if (dr["DeliveredAt"] != DBNull.Value)
                            {
                                lblDeliveredAt.Text = Convert.ToDateTime(dr["DeliveredAt"]).ToString("yyyy-MM-dd HH:mm:ss");
                            }
                            else
                            {
                                lblDeliveredAt.Text = "N/A";
                            }
                        }
                    }
                }
            }
        }

        protected void ddlStatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            pnlFailure.Visible = (ddlStatus.SelectedValue == "Failed");
        }

        protected void btnUpdateStatus_Click(object sender, EventArgs e)
        {
            if (ddlDeliveries.SelectedValue == null) return;

            int deliveryId = Convert.ToInt32(ddlDeliveries.SelectedValue);
            string status = ddlStatus.SelectedValue;

            if (status == "Failed" && string.IsNullOrWhiteSpace(txtFailureReason.Text))
            {
                ShowAlert("Please record a Failure Reason before marking the delivery as Failed.", "danger");
                return;
            }

            using (SqlConnection con = new SqlConnection(ConnStr))
            {
                string updateQuery = @"UPDATE Deliveries 
                                       SET CurrentStatus = @Status, 
                                           DeliveryNotes = @Notes, 
                                           FailureReason = @FailureReason,
                                           DeliveredAt = CASE WHEN @Status = 'Delivered' THEN GETDATE() ELSE DeliveredAt END
                                       WHERE DeliveryId = @DeliveryId";

                using (SqlCommand cmd = new SqlCommand(updateQuery, con))
                {
                    cmd.Parameters.AddWithValue("@DeliveryId", deliveryId);
                    cmd.Parameters.AddWithValue("@Status", status);
                    cmd.Parameters.AddWithValue("@Notes", txtNotes.Text.Trim());
                    cmd.Parameters.AddWithValue("@FailureReason", status == "Failed" ? txtFailureReason.Text.Trim() : (object)DBNull.Value);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            ShowAlert("Delivery status, timestamp, and notes recorded successfully.", "success");
            BindDeliveriesDropdown(deliveryId);
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Login.aspx");
        }

        private void ShowAlert(string message, string type)
        {
            lblAlert.Text = message;
            pnlAlert.CssClass = $"alert alert-{type} alert-dismissible fade show";
            pnlAlert.Visible = true;
        }
    }
}