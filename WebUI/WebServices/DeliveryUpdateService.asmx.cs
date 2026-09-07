using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;

namespace WebUI
{
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    [System.Web.Script.Services.ScriptService]
    public class DeliveryUpdateService : WebService
    {
        private string ConnStr => ConfigurationManager.ConnectionStrings["DeliveryDbConn"].ConnectionString;

        [WebMethod(EnableSession = true)]
        public object GetDeliveriesDropdown()
        {
            if (Session["UserId"] == null)
            {
                return new { success = false, message = "Session expired", redirect = true };
            }

            var list = new List<object>();
            using (SqlConnection con = new SqlConnection(ConnStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_GetDeliveriesForGrid", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            string delNumber = dr["DeliveryNumber"] != DBNull.Value ? dr["DeliveryNumber"].ToString() : "";
                            string status = dr["CurrentStatus"] != DBNull.Value ? dr["CurrentStatus"].ToString() : "";

                            list.Add(new
                            {
                                Value = dr["DeliveryId"].ToString(),
                                Text = delNumber + " - " + status
                            });
                        }
                    }
                }
            }
            return new { success = true, data = list };
        }
        [WebMethod(EnableSession = true)]
        public object GetDeliveryRecord(int deliveryId)
        {
            if (Session["UserId"] == null)
            {
                return new { success = false, message = "Session expired", redirect = true };
            }

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
                            string deliveredAtStr = dr["DeliveredAt"] != DBNull.Value
                                ? Convert.ToDateTime(dr["DeliveredAt"]).ToString("yyyy-MM-dd HH:mm:ss")
                                : "N/A";

                            return new
                            {
                                success = true,
                                currentStatus = dr["CurrentStatus"].ToString(),
                                deliveryNotes = dr["DeliveryNotes"] == DBNull.Value ? "" : dr["DeliveryNotes"].ToString(),
                                failureReason = dr["FailureReason"] == DBNull.Value ? "" : dr["FailureReason"].ToString(),
                                deliveredAt = deliveredAtStr
                            };
                        }
                    }
                }
            }
            return new { success = false, message = "Record not found." };
        }

        [WebMethod(EnableSession = true)]
        public object UpdateDeliveryStatus(int deliveryId, string status, string notes, string failureReason)
        {
            if (Session["UserId"] == null)
            {
                return new { success = false, message = "Session expired", redirect = true };
            }

            if (status == "Failed" && string.IsNullOrWhiteSpace(failureReason))
            {
                return new { success = false, message = "Please record a Failure Reason before marking the delivery as Failed." };
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
                    cmd.Parameters.AddWithValue("@Notes", (notes ?? "").Trim());
                    cmd.Parameters.AddWithValue("@FailureReason", status == "Failed" ? failureReason.Trim() : (object)DBNull.Value);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            return new { success = true, message = "Delivery status, timestamp, and notes recorded successfully." };
        }

    }
}