using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebUI
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string role = (Session["RoleId"] ?? Session["Role"] ?? Session["UserRole"])?.ToString().Trim() ?? "";
                int.TryParse(role, out int roleId);

                bool isSuperAdmin = roleId == 2 ||
                                    role.Equals("Super Admin", StringComparison.OrdinalIgnoreCase) ||
                                    role.Equals("SuperAdmin", StringComparison.OrdinalIgnoreCase);
                var lnkDriver = FindControl("lnkDriverManagement") ?? FindControl("navDriver");
                var lnkCustomer = FindControl("lnkCustomermanagement") ?? FindControl("navCustomer");

                if (lnkDriver != null) lnkDriver.Visible = isSuperAdmin;
                if (lnkCustomer != null) lnkCustomer.Visible = isSuperAdmin;
            }

        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            
            Session.Clear();
            Session.Abandon();
            Session.RemoveAll();
            if (Request.Cookies["ASP.NET_SessionId"] != null)
            {
                Response.Cookies["ASP.NET_SessionId"].Value = string.Empty;
                Response.Cookies["ASP.NET_SessionId"].Expires = DateTime.Now.AddMonths(-1);
            }
            Response.Redirect("~/Login.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }
    }
}