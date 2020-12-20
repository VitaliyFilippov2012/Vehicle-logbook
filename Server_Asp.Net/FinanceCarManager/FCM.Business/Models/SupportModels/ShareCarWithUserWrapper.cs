using System;
using System.Collections.Generic;
using System.Text;

namespace FCM.Business.Models.SupportModels
{
    public class ShareCarWithUserWrapper
    {
        public Guid CarId { get; set; }
        public Guid UserId { get; set; }
    }
}
