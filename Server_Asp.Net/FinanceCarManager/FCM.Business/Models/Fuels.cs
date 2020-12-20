using System;
using System.Collections.Generic;

namespace FCM.Business.Models
{
    public partial class Fuels
    {
        public Guid FuelId { get; set; }
        public Guid IdEvent { get; set; }
        public float Volume { get; set; }

        public virtual CarEvents IdEventNavigation { get; set; }
    }
}
