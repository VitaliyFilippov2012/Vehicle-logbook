using System;
using System.Collections.Generic;
using System.Text;

namespace FCM.Business.IoCServices
{
    public abstract class Service
    {
        public readonly IDbModel DbContext;

        protected Service(IDbModel dbModel)
        {
            DbContext = dbModel;
        }
    }
}
