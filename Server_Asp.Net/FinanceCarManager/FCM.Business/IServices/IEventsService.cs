using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using FCM.Business.Models;
using FCM.Business.Models.SupportModels;

namespace FCM.Business.IServices
{
    public interface IEventsService
    {
        Task<IEnumerable<Event>> GetCarEventsAsync(Guid carId);

        Task<CarEvents> GetEventByIdAsync(Guid id);

        Task<EventService> GetServiceEventByIdAsync(Guid idEvent);

        Task<Fuel> GetFuelEventByIdAsync(Guid idEvent);

        Task<IEnumerable<TypeEvents>> GetTypeEventsAsync();

        Task<IEnumerable<Fuel>> GetCarFuelsEventsAsync(Guid carId);

        Task<IEnumerable<EventService>> GetCarServiceEventsAsync(Guid carId);

        Task<bool> DeleteCarEventAsync(Guid eventId);

        Task<bool> CreateCarFuelEventAsync(Fuel fuelEvent);

        Task<bool> CreateCarServiceEventAsync(EventService serviceEvent);

        Task<bool> CreateCarEventAsync(Event carEvent);

        Task<bool> UpdateCarFuelEventAsync(Fuel fuelEvent);

        Task<bool> UpdateCarServiceEventAsync(EventService serviceEvent);

        Task<bool> UpdateCarEventAsync(Event carEvent);
    }
}
