using System;
using System.Collections.Generic;
using System.Runtime.Serialization;
using FCM.Business.Models.SupportModels;

namespace SynchronizationService.Model
{
    [Serializable]
    [DataContract]
    public class SynchronizationClientDataContract
    {
        [DataMember]
        public string LastSyncDate { get; set; }
        [DataMember]
        public List<SyncEntity> Delete { get; set; }
        [DataMember]
        public List<SyncEntity> Post { get; set; }
        [DataMember]
        public List<SyncEntity> Put { get; set; }
    }
}
