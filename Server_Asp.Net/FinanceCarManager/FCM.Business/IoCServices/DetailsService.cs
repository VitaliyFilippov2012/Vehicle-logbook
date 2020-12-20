using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using FCM.Business.IServices;
using FCM.Business.Models;
using Microsoft.EntityFrameworkCore;

namespace FCM.Business.IoCServices
{
    public class DetailsService : Service, IDetailsService
    {
        public DetailsService(IDbModel dbModel) : base(dbModel)
        {
        }

        public Task<IEnumerable<Details>> GetAllDetails()
        {
            throw new NotImplementedException();
        }

        public Task<IEnumerable<Details>> GetDetailById(Guid idDetail)
        {
            throw new NotImplementedException();
        }

        public async Task<IEnumerable<Details>> GetDetailsByServiceId(Guid serviceId)
        {
            return await DbContext.Details.Where(x => x.IdService == serviceId).ToListAsync();
        }
    }
}
