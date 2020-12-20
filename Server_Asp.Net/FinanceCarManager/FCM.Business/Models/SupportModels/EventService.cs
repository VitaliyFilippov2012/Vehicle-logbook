using System;
using System.Collections.Generic;
using System.Text;

namespace FCM.Business.Models.SupportModels
{
    public class EventService : Event
    {
        public Guid ServiceId { get; set; }
        public Guid IdTypeService { get; set; }
        public string Name { get; set; }
        public IEnumerable<Details> Details { get; set; }
    }
}
