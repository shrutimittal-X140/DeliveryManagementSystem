using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebUI.Models
{
    public class DeliveryModel
    {
        public int DeliveryId { get; set; }
        public int CustomerId { get; set; }
        public int Driverid { get; set; }
        public string PickupAddress { get; set; }
        public string DropAddress { get; set; }
        public string Status { get; set; }
        public DateTime DeliveryDate { get; set; }
    }
}