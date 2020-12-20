using System;
using System.Collections.Generic;
using System.Runtime.Serialization;

namespace FCM.Business.Models.SupportModels
{
    [Serializable]
    [DataContract]
    public class SyncEntity
    {
        [DataMember]
        public string EntityName { get; set; }
        [DataMember]
        public Guid EntityId { get; set; }
        [DataMember]
        public string ActionDate { get; set; }
        [DataMember]
        public string ActionSide { get; set; } = Enums.ActionSide.Client.ToString();
    }

    public class SyncEntityComparer : IEqualityComparer<SyncEntity>
    {
        public bool Equals(SyncEntity x, SyncEntity y)
        {
            return x != null && (y != null && x.EntityId == y.EntityId);
        }

        public int GetHashCode(SyncEntity obj)
        {
            return obj.EntityId.GetHashCode();
        }
    }
}
