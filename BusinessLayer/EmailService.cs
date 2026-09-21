using System;
using System.Configuration;
using System.Net;
using System.Net.Mail;
using System.Threading.Tasks;

namespace BusinessLayer
{
    public static class EmailService
    {
        public static async Task<(bool Success, string Error)> SendDeliveryNotificationAsync(string customerEmail, string customerName, int deliveryId)
        {
            if (string.IsNullOrWhiteSpace(customerEmail))
                return (false, "No customer email provided.");

            try
            {
                string host = ConfigurationManager.AppSettings["SmtpHost"];
                int port = Convert.ToInt32(ConfigurationManager.AppSettings["SmtpPort"]);
                string senderEmail = ConfigurationManager.AppSettings["SenderEmail"];
                string senderPassword = ConfigurationManager.AppSettings["SenderPassword"];
                bool enableSsl = Convert.ToBoolean(ConfigurationManager.AppSettings["EnableSmtpSsl"]);

                using (SmtpClient client = new SmtpClient(host, port))
                {
                    client.Credentials = new NetworkCredential(senderEmail, senderPassword);
                    client.EnableSsl = enableSsl;

                    using (MailMessage mail = new MailMessage())
                    {
                        mail.From = new MailAddress(senderEmail, "DeliveryERP System");
                        mail.To.Add(customerEmail);
                        mail.Subject = $"Your Delivery #{deliveryId} Has Been Delivered!";
                        mail.Body = $@"
                            <h2>Hello {customerName},</h2>
                            <p>Good news! Your delivery <strong>#{deliveryId}</strong> status has been updated to <strong>Delivered</strong>.</p>
                            <p>Thank you for choosing DeliveryERP!</p>";
                        mail.IsBodyHtml = true;

                        await client.SendMailAsync(mail);
                        return (true, null);
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Email sending failed: " + ex.Message);
                return (false, ex.Message);
            }
        }
    }
}