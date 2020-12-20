using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace FCM.Business.IServices
{
    public interface IServicesService
    {
        Task<IEnumerable<Models.CarServices>> GetAllService();

        Task<IEnumerable<Models.CarServices>> GetServiceById(Guid idService);

        Task<IEnumerable<Models.CarServices>> GetServiceByIds(IEnumerable<Guid> idServices);

        Task<IEnumerable<Models.TypeServices>> GetTypeService();

    }
}
