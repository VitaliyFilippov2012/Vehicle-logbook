using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using FCM.Business.Models;

namespace FCM.Business.IServices
{
    public interface ICarsService
    {
        Task<IEnumerable<Cars>> GetAllUserCarsAsync(Guid userid);
        Task<IEnumerable<Cars>> GetCarByIdAsync(Guid idCar);
        Task<Guid> CreateCarAsync(Cars car, Guid userId);
        Task<bool> UpdateCarAsync(Cars car);
        Task<bool> ShareCarWithOtherUserAsync(Guid carId, string email,string uri);
        Task<bool> AddShareCarAsync(string str);
        Task<bool> DeleteShareCarAsync(Guid carId, Guid userId);

    }
}
