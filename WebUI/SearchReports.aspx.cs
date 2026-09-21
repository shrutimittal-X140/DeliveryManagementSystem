using System;
using System.Data;
using System.Text;
using System.Web.UI;
using BusinessLayer;

namespace WebUI
{
    public partial class SearchReports : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            string role = Session["UserRole"]?.ToString();
            if (role != "Admin" && role != "Super Admin")
            {
                Response.Redirect("Dashboard.aspx?error=unauthorized");
                return;
            }

            if (!IsPostBack)
            {
                BindReportsData("", "");
            }
        }

        protected void btnApplyFilterServer_Click(object sender, EventArgs e)
        {
            BindReportsData(txtKeywords.Text.Trim(), ddlStatus.SelectedValue);
        }
        
        private void BindReportsData(string keyword, string status)
        {
            try
            {
                DeliveryBLL deliveryBLL = new DeliveryBLL();
                DataTable dt = deliveryBLL.GetFilteredDeliveriesTable(keyword, status);

                if(dt != null && dt.Rows.Count > 0)
                {
                    rptReportsTable.DataSource = dt;
                    rptReportsTable.DataBind();
                    lblMessage.Visible = false;
                }
                else
                {
                    rptReportsTable.DataSource = null;
                    rptReportsTable.DataBind();
                    lblMessage.Text = "No deliveries found matching your selected criteria.";
                    lblMessage.CssClass = "alert alert-warning fw-bold px-3 py-2 rounded-2 d-block";
                    lblMessage.Visible = true;
                }
            } catch ( Exception ex)
            {
                lblMessage.Text = "Error loading reports data logs: " + ex.Message;
                lblMessage.CssClass = "alert alert-danger fw-bold px-3 py-2 rounded-2 d-block";
                lblMessage.Visible = true;
            }
        }

        protected string GetStatusBadgeClass(string status)
        {
            if (string.IsNullOrEmpty(status)) return "bg-warning text-dark";
            string s = status.ToLower();
            if (s.Contains("pending")) return "bg-warning text-dark";
            if (s.Contains("transit") || s.Contains("out")) return "bg-info text-dark";
            if (s.Contains("delivered")) return "bg-success text-white";
            if (s.Contains("failed") || s.Contains("cancelled")) return "bg-danger text-white";
            return "bg-secondary text-white";
        }

        protected void btnExport_Click( object sender, EventArgs e)
        {
            string keyword = txtKeywords.Text.Trim();
            string status = ddlStatus.SelectedValue;

            DeliveryBLL deliveryBll = new DeliveryBLL();
            DataTable dt = deliveryBll.GetFilteredDeliveriesTable(keyword, status);

            StringBuilder sb = new StringBuilder();
            sb.AppendLine("Order ID, Customer Name, Driver Name, Delivery Address, Date Created, Status");

            foreach( DataRow row in dt.Rows)
            {
                sb.AppendLine($"{row["OrderId"]}, {row["CustomerName"].ToString().Replace(",", " ")},{row["DriverName"].ToString().Replace(",", " ")},{row["DeliveryAddress"].ToString().Replace(",", " ")},{Convert.ToDateTime(row["CreatedDate"]):yyyy-MM-dd HH:mm},{row["CurrentStatus"]}");

            }

            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment; filename = DeliveryReport_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".csv");
            Response.ContentType = "text/csv";
            Response.Output.Write(sb.ToString());
            Response.Flush();
            Response.End();
        } 
    }
}