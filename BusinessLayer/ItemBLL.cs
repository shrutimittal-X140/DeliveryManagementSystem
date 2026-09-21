using DataAccessLayer;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer
{
    public class ItemBLL
    {
        public DataTable GetAllItems()
        {
            DataSet ds = SqlHelper.ExecuteDataSet("sp_GetItems", null);
            return (ds != null && ds.Tables.Count > 0 ? ds.Tables[0] : new DataTable());
        }

        public DataTable GetItemById(int itemId)
        {
            SqlParameter[] parameters = new SqlParameter[]
            {
                new SqlParameter("@ItemId", itemId)
            };

            DataSet ds = SqlHelper.ExecuteDataSet("sp_GetItemById", parameters);
            return (ds != null && ds.Tables.Count > 0 ? ds.Tables[0] : new DataTable());
        }

        public bool SaveItem(int itemId, string itemCode, string itemName, decimal unitPrice, bool isActive, string createdBy)
        {
            SqlParameter[] parameters = new SqlParameter[]
            {
                new SqlParameter("@ItemId", itemId),
                new SqlParameter("@ItemCode", itemCode),
                new SqlParameter("@ItemName",itemName),
                new SqlParameter("@UnitPrice", unitPrice),
                new SqlParameter("@IsActive", isActive),
                new SqlParameter("@CreatedBy", (object)createdBy ?? DBNull.Value)
            };

            object result = SqlHelper.ExecuteScalar("sp_SaveItem", parameters);
            return result != null && result != DBNull.Value && Convert.ToInt32(result) > 0;
        }

        public bool DeleteItem(int itemId)
        {
            SqlParameter[] parameters = new SqlParameter[]
            {
                new SqlParameter("@ItemId", itemId)
            };

            object result = SqlHelper.ExecuteScalar("sp_DeleteItem", parameters);
            return result != null && result != DBNull.Value && Convert.ToInt32(result) > 0;
        }
    }
}