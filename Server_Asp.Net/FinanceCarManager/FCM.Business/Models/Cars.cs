using System;
using System.Collections.Generic;
using Newtonsoft.Json;

namespace FCM.Business.Models
{
    public partial class Cars
    {
        public Cars()
        {
            CarEvents = new HashSet<CarEvents>();
            Details = new HashSet<Details>();
            UsersCars = new HashSet<UsersCars>();
        }

        public Guid CarId { get; set; }
        public string TypeFuel { get; set; }
        public string TypeTransmission { get; set; }
        public string Mark { get; set; }
        public string Model { get; set; }
        public int VolumeEngine { get; set; }
        public int Power { get; set; }
        public bool? Active { get; set; }
        public string Vin { get; set; }
        public string Comment { get; set; }
        public byte[] Photo { get; set; }
        public int YearIssue { get; set; }

        public virtual ICollection<CarEvents> CarEvents { get; set; }
        [JsonIgnore]
        public virtual ICollection<Details> Details { get; set; }
        [JsonIgnore]
        public virtual ICollection<UsersCars> UsersCars { get; set; }
    }
}
