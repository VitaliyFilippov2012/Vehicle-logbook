using System;
using System.Collections.Generic;
using Newtonsoft.Json;

namespace FCM.Business.Models
{
    public partial class CarEvents
    {
        public CarEvents()
        {
            CarServices = new HashSet<CarServices>();
            Fuels = new HashSet<Fuels>();
        }

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

        [JsonIgnore]
        public virtual Cars IdCarNavigation { get; set; }
        public virtual TypeEvents IdTypeEventsNavigation { get; set; }
        [JsonIgnore]
        public virtual Users IdUserNavigation { get; set; }
        [JsonIgnore]
        public virtual ICollection<CarServices> CarServices { get; set; }
        [JsonIgnore]
        public virtual ICollection<Fuels> Fuels { get; set; }
    }
}
