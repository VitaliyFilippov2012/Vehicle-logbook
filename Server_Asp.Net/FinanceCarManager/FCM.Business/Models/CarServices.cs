using System;
using System.Collections.Generic;
using Newtonsoft.Json;

namespace FCM.Business.Models
{
    public partial class CarServices
    {
        public CarServices()
        {
            Details = new HashSet<Details>();
        }

        public Guid ServiceId { get; set; }
        public Guid IdEvent { get; set; }
        public Guid IdTypeService { get; set; }
        public string Name { get; set; }

        [JsonIgnore]
        public virtual CarEvents IdEventNavigation { get; set; }
        public virtual TypeServices IdTypeServiceNavigation { get; set; }
        public virtual ICollection<Details> Details { get; set; }
    }
}
