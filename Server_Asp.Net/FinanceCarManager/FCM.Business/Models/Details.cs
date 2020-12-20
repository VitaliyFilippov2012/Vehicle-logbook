using System;
using System.Collections.Generic;
using Newtonsoft.Json;

namespace FCM.Business.Models
{
    public partial class Details
    {
        public Guid DetailId { get; set; }
        public Guid IdCar { get; set; }
        public Guid IdService { get; set; }
        public string Name { get; set; }
        public string Type { get; set; }

        [JsonIgnore]
        public virtual Cars IdCarNavigation { get; set; }
        [JsonIgnore]
        public virtual CarServices IdServiceNavigation { get; set; }
    }
}
