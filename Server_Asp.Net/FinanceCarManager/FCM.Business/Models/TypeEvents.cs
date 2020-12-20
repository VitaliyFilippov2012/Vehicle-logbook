using System;
using System.Collections.Generic;

namespace FCM.Business.Models
{
    public partial class TypeEvents
    {
        public TypeEvents()
        {
            CarEvents = new HashSet<CarEvents>();
        }

        public Guid TypeEventId { get; set; }
        public string TypeName { get; set; }

        public virtual ICollection<CarEvents> CarEvents { get; set; }
    }
}
