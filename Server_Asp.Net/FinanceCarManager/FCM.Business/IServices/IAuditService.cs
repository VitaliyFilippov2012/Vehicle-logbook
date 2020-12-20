
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using FCM.Business.Enums;
using FCM.Business.Models.SupportModels;

namespace FCM.Business.IServices
{
    public interface IAuditService
    {
        Task<List<SyncEntity>> GetAllEventsByTypeAfterDate(Guid userId, string lastDateSync, ActionType type);
    }
}
