using System;
using System.Collections.Generic;

namespace FCM.Business.Models
{
    public partial class TypeServices
    {
        public TypeServices()
        {
            CarServices = new HashSet<CarServices>();
        }

        public Guid TypeServiceId { get; set; }
        public string TypeName { get; set; }

        public virtual ICollection<CarServices> CarServices { get; set; }
    }
}
