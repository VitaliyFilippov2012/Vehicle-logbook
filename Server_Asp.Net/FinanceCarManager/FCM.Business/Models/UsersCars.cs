using System;
using System.Collections.Generic;

namespace FCM.Business.Models
{
    public partial class UsersCars
    {
        public Guid IdUser { get; set; }
        public Guid IdCar { get; set; }

        public virtual Cars IdCarNavigation { get; set; }
        public virtual Users IdUserNavigation { get; set; }
    }
}
