using System;
using System.Collections.Generic;

namespace FCM.Business.Models
{
    public partial class Authentication
    {
        public Guid IdUser { get; set; }
        public string Password { get; set; }
        public string Login { get; set; }
        public DateTime LastModify { get; set; }
        public bool? DisableUser { get; set; }

        public virtual Users IdUserNavigation { get; set; }
    }
}
