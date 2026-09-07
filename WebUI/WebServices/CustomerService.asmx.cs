using System;
using System.Data;
using System.Web.Services;
using System.Web.Script.Services;
using System.Collections.Generic;
using BusinessLayer;

namespace WebUI.WebServices
{
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    [ScriptService]
    public class CustomerService : System.Web.Services.WebService
    {
        private CustomerBLL customerBLL = new CustomerBLL();

        private void GetSessionIdentity(out int currentUserId, out bool isSuperAdmin)
        {
            currentUserId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 0;
            isSuperAdmin = Session["UserRole"] != null &&
                Session["UserRole"].ToString().Equals("Super Admin", StringComparison.OrdinalIgnoreCase);
        }

        [WebMethod(EnableSession = true)]
        public object GetAllCustomers()
        {
            try
            {
                int currentUserId; bool isSuperAdmin;
                GetSessionIdentity(out currentUserId, out isSuperAdmin);

                DataTable dt = customerBLL.GetAllCustomers(currentUserId, isSuperAdmin, "");
                return new { success = true, data = ToList(dt), currentUserId = currentUserId, isSuperAdmin = isSuperAdmin };
            }
            catch (Exception ex)
            {
                return new { success = false, message = ex.Message };
            }
        }

        [WebMethod(EnableSession = true)]
        public object SearchCustomers(string searchTerm)
        {
            try
            {
                int currentUserId; bool isSuperAdmin;
                GetSessionIdentity(out currentUserId, out isSuperAdmin);

                DataTable dt = customerBLL.GetAllCustomers(currentUserId, isSuperAdmin, searchTerm);
                return new { success = true, data = ToList(dt), currentUserId = currentUserId, isSuperAdmin = isSuperAdmin };
            }
            catch (Exception ex)
            {
                return new { success = false, message = ex.Message };
            }
        }

        [WebMethod(EnableSession = true)]
        public object SaveCustomer(int customerId, string customerCode, string customerName,
            string contactPerson, string phoneNumber, string email, string deliveryAddress)
        {
            if (string.IsNullOrWhiteSpace(customerCode) || string.IsNullOrWhiteSpace(customerName))
            {
                return new { success = false, message = "Customer Code and Name are required fields." };
            }

            try
            {
                int currentUserId; bool isSuperAdmin;
                GetSessionIdentity(out currentUserId, out isSuperAdmin);

                customerBLL.SaveCustomer(customerId, customerCode, customerName, contactPerson,
                    phoneNumber, email, deliveryAddress, currentUserId, isSuperAdmin);

                return new { success = true, message = "Customer saved successfully." };
            }
            catch (Exception ex)
            {
                return new { success = false, message = ex.Message };
            }
        }

        [WebMethod(EnableSession = true)]
        public object GetCustomersPaged(int limit, int offset, string sort, string order, string search)
        {
            try
            {
                int currentUserId; bool isSuperAdmin;
                GetSessionIdentity(out currentUserId, out isSuperAdmin);

                int pageSize = limit > 0 ? limit : 10;
                int pageNumber = (offset / pageSize) + 1;
                string sortColumn = string.IsNullOrEmpty(sort) ? "CustomerId" : sort;
                string sortDirection = string.IsNullOrEmpty(order) ? "DESC" : order.ToUpper();
               
                var result = customerBLL.GetCustomersPaged(currentUserId, isSuperAdmin, search, sortColumn, sortDirection, pageNumber, pageSize);

                return new { total = result.Total, rows = ToList(result.Rows) };
            }
            catch (Exception ex)
            {
                return new { total = 0, rows = new object[0], error = ex.Message };
            }
        }

        [WebMethod(EnableSession = true)]
        public object DeleteCustomer(int customerId)
        {
            try
            {
                int currentUserId; bool isSuperAdmin;
                GetSessionIdentity(out currentUserId, out isSuperAdmin);

                customerBLL.DeleteCustomer(customerId, currentUserId, isSuperAdmin);
                return new { success = true, message = "Customer deleted successfully." };
            }
            catch (Exception ex)
            {
                return new { success = false, message = ex.Message };
            }
        }

        private List<Dictionary<string, object>> ToList(DataTable dt)
        {
            var list = new List<Dictionary<string, object>>();
            if (dt == null) return list;

            foreach (DataRow row in dt.Rows)
            {
                var dict = new Dictionary<string, object>();
                foreach (DataColumn col in dt.Columns)
                {
                    dict[col.ColumnName] = row[col] == DBNull.Value ? null : row[col];
                }
                list.Add(dict);
            }
            return list;
        }
    }
}