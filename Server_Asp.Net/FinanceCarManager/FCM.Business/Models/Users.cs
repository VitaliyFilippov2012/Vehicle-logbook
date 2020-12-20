using System;
using System.Collections.Generic;

namespace FCM.Business.Models
{
    public partial class Users
    {
        public Users()
        {
            ActionAudit = new HashSet<ActionAudit>();
            Authentication = new HashSet<Authentication>();
            CarEvents = new HashSet<CarEvents>();
            UsersCars = new HashSet<UsersCars>();
        }

        public Guid UserId { get; set; }
        public string Sex { get; set; }
        public DateTime Birthday { get; set; }
        public string Name { get; set; }
        public string Lastname { get; set; }
        public string Patronymic { get; set; }
        public string Address { get; set; }
        public string Phone { get; set; }
        public string City { get; set; }
        public byte[] Photo { get; set; }

        public virtual ICollection<ActionAudit> ActionAudit { get; set; }
        public virtual ICollection<Authentication> Authentication { get; set; }
        public virtual ICollection<CarEvents> CarEvents { get; set; }
        public virtual ICollection<UsersCars> UsersCars { get; set; }
    }
}
