using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Threading.Tasks;

namespace SynchronizationService.Model
{
    [Serializable]
    [DataContract]
    public class SynchronizationDataMember
    {
        [DataMember]
        public string Entity { get; set; }
        [DataMember]
        public Guid EntityId { get; set; }
        [DataMember]
        public string ActionType { get; set; }
        [DataMember]
        public string ActionSide { get; set; }
        [DataMember]
        public string ActionDate { get; set; }
    }
}
