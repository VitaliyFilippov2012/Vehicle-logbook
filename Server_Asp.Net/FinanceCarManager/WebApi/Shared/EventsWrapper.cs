using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using FCM.Business.Models.SupportModels;

namespace WebApi.Shared
{
    public class EventsWrapper
    {
        public IEnumerable<EventService> EventServices { get; set; }
        public IEnumerable<Event> Events { get; set; }
        public IEnumerable<Fuel> Fuels { get; set; }
    }
}
