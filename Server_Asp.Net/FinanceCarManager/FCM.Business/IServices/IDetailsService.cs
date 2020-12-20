using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using FCM.Business.Models;

namespace FCM.Business.IServices
{
    public interface IDetailsService
    {
        Task<IEnumerable<Details>> GetDetailById(Guid idDetail);

        Task<IEnumerable<Details>> GetDetailsByServiceId(Guid serviceId);
    }
}
