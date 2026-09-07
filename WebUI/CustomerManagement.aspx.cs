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
        protected void Page_Load(object sender, EventArgs e)
        {
                if (Session["UserId"] == null)
                {
                  
                    Response.Redirect("~/Login.aspx", false);
                   
                }
        }
        
    }
}