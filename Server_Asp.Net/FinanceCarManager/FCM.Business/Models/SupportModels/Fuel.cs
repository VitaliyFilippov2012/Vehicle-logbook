using System;
using System.Collections.Generic;
using System.Text;

namespace FCM.Business.Models.SupportModels
{
    public class Fuel : Event
    {
        public Guid FuelId { get; set; }
        public float Volume { get; set; }
    }
}
