using System;

namespace FCM.Business.Models
{
    public partial class ActionAudit
    {
        public string Entity { get; set; }
        public Guid EntityId { get; set; }
        public Guid IdUser { get; set; }
        public string Action { get; set; }
        public string DateUpdate { get; set; }

        public virtual Users IdUserNavigation { get; set; }
    }
}
