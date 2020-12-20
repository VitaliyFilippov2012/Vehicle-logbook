using System;
using System.Collections.Generic;
using System.Runtime.Serialization;

namespace SynchronizationService.Model
{
    [Serializable]
    [DataContract]
    public class SynchronizationContract
    {
        [DataMember]
        public string LastSyncDate { get; set; }

        [DataMember]
        public List<SynchronizationDataMember> SynchronizationDataMembers { get; set; }
    }
}
