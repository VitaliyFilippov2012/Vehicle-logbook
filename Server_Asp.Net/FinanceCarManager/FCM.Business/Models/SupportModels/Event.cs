using System;
using System.Collections.Generic;
using System.Text;

namespace FCM.Business.Models.SupportModels
{
    public class Event
    {
        public Guid EventId { get; set; }
        public Guid IdTypeEvents { get; set; }
        public Guid IdUser { get; set; }
        public Guid IdCar { get; set; }
        public DateTime Date { get; set; }
        public decimal Costs { get; set; }
        public decimal? UnitPrice { get; set; }
        public string Comment { get; set; }
        public long? Mileage { get; set; }
        public byte[] Photo { get; set; }
        public string AddressStation { get; set; }
    }
}
