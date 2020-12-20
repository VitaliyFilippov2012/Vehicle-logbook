using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApi.Shared
{
    public class Car
    {
        public Guid? CarId { get; set; }
        public string TypeFuel { get; set; }
        public string TypeTransmission { get; set; }
        public string Mark { get; set; }
        public string Model { get; set; }
        public int VolumeEngine { get; set; }
        public int Power { get; set; }
        public bool Active { get; set; }
        public string Vin { get; set; }
        public string Comment { get; set; }
        public byte[] Photo { get; set; }
        public int YearIssue { get; set; }
    }
}
