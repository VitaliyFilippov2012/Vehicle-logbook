using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using FCM.Business.IServices;
using FCM.Business.Models;
using Microsoft.EntityFrameworkCore;

namespace FCM.Business.IoCServices
{
    public class ServicesService : Service, IServicesService
    {
        public ServicesService(IDbModel dbModel) : base(dbModel)
        {
        }

        public Task<IEnumerable<Models.CarServices>> GetAllService()
        {
            throw new NotImplementedException();
        }

        public Task<IEnumerable<Models.CarServices>> GetServiceById(Guid idService)
        {
            throw new NotImplementedException();
        }

        public Task<IEnumerable<Models.CarServices>> GetServiceByIds(IEnumerable<Guid> idServices)
        {
            throw new NotImplementedException();
        }

        public async Task<IEnumerable<TypeServices>> GetTypeService()
        {
            return await DbContext.TypeServices.ToListAsync();
        }
    }
}
