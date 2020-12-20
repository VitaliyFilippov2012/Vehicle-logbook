using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using FCM.Business.Enums;
using FCM.Business.IServices;
using FCM.Business.Models.SupportModels;
using Microsoft.EntityFrameworkCore;

namespace FCM.Business.IoCServices
{
    public class AuditService : Service, IAuditService
    {
        public AuditService(IDbModel dbModel) : base(dbModel)
        {
        }

        public async Task<List<SyncEntity>> GetAllEventsByTypeAfterDate(Guid userId, string lastDateSync, ActionType type)
        {
            var dateSync = ParseToDateTime(lastDateSync);
            var actions = await DbContext.ActionAudit.Where(x => x.IdUser == userId && x.Action == type.ToString())
                .ToListAsync();
            return actions.Where(x => ParseToDateTime(x.DateUpdate).CompareTo(dateSync) == 1).Select(x=> new SyncEntity(){ EntityId = x.EntityId, EntityName = x.Entity, ActionDate = x.DateUpdate, ActionSide = ActionSide.Server.ToString()}).ToList();
        }

        public Task<bool> ExistsInfoToSync(string lastDateSync, Guid userId)
        {
            var dateSync = ParseToDateTime(lastDateSync);
            return DbContext.ActionAudit.Where(x => x.IdUser == userId).Select(x => ParseToDateTime(x.DateUpdate)).Where(x => x.CompareTo(dateSync) == 1).AnyAsync();
        }

        private static DateTime ParseToDateTime(string lastDateSync)
        {
            if(lastDateSync.Length > 19)
                lastDateSync = lastDateSync.Remove(19);
            return DateTime.ParseExact(lastDateSync, "yyyy-MM-dd HH:mm:ss", System.Globalization.CultureInfo.InvariantCulture);
        }
    }
}
