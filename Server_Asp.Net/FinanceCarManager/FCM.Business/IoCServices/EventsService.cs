
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using FCM.Business.IServices;
using FCM.Business.Models;
using FCM.Business.Models.SupportModels;
using Microsoft.EntityFrameworkCore;

namespace FCM.Business.IoCServices
{
    public class EventsService : Service, IEventsService
    {
        private readonly IDetailsService _detailsService;

        public EventsService(IDbModel dbModel, IDetailsService detailsService) : base(dbModel)
        {
            _detailsService = detailsService;
        }

        public async Task<IEnumerable<Event>> GetCarEventsAsync(Guid carId)
        {
            var allEvents =  DbContext.CarEvents.Where(x => x.IdCar == carId);
            var fuels = allEvents.Join(DbContext.Fuels, x => x.EventId, p => p.IdEvent, (x, p) => x.EventId);
            var services = allEvents.Join(DbContext.CarServices, x => x.EventId, p => p.IdEvent, (x, p) => x.EventId);
            return await allEvents.Where(x => !fuels.Union(services).Contains(x.EventId)).Select(x=> Event(x)).ToListAsync();
        }

        private static Event Event(CarEvents carEvents)
        {
            return new Event()
            {
                EventId = carEvents.EventId,
                AddressStation = carEvents.AddressStation,
                Comment = carEvents.Comment,
                Costs = carEvents.Costs,
                Date = carEvents.Date,
                IdCar = carEvents.IdCar,
                IdTypeEvents = carEvents.IdTypeEvents,
                IdUser = carEvents.IdUser,
                Mileage = carEvents.Mileage,
                UnitPrice = carEvents.UnitPrice,
                Photo = carEvents.Photo,
            };
        }

        private static CarEvents Event(Event carEvents)
        {
            return new CarEvents()
            {
                EventId = carEvents.EventId,
                AddressStation = carEvents.AddressStation,
                Comment = carEvents.Comment,
                Costs = carEvents.Costs,
                Date = carEvents.Date,
                IdCar = carEvents.IdCar,
                IdTypeEvents = carEvents.IdTypeEvents,
                IdUser = carEvents.IdUser,
                Mileage = carEvents.Mileage,
                UnitPrice = carEvents.UnitPrice,
                Photo = carEvents.Photo,
            };
        }
        private static Fuels FuelToCarFuelsEvent(Fuel carFuelEvent)
        {
            return new Fuels()
            {
                IdEvent = carFuelEvent.EventId,
                FuelId = carFuelEvent.FuelId,
                Volume = carFuelEvent.Volume,
            };
        }

        private static CarServices EventToCarServices(EventService carEvents)
        {
            return new CarServices()
            {
                IdEvent = carEvents.EventId,
                Name = carEvents.Name,
                ServiceId = carEvents.ServiceId,
                IdTypeService = carEvents.IdTypeService
            };
        }

        private static CarEvents EventToCarEvents(Event carEvents)
        {
            return new CarEvents()
            {
                EventId = carEvents.EventId,
                IdTypeEvents = carEvents.IdTypeEvents,
                IdUser = carEvents.IdUser,
                IdCar = carEvents.IdCar,
                Date = carEvents.Date,
                Costs = carEvents.Costs,
                UnitPrice = carEvents.UnitPrice,
                Comment = carEvents.Comment,
                Mileage = carEvents.Mileage,
                Photo = carEvents.Photo,
                AddressStation = carEvents.AddressStation
            };
        }

        public async Task<IEnumerable<Fuel>> GetCarFuelsEventsAsync(Guid carId)
        {
            return await DbContext.CarEvents.Where(x => x.IdCar == carId).Join(DbContext.Fuels, x=> x.EventId, f => f.IdEvent,(x,f)=> Fuel(x, f)).ToListAsync();
        }

        private static Fuel Fuel(CarEvents carEvents, Fuels fuels)
        {
            return new Fuel()
            {
                EventId = carEvents.EventId,
                AddressStation = carEvents.AddressStation,
                Comment = carEvents.Comment,
                Costs = carEvents.Costs,
                Date = carEvents.Date,
                FuelId = fuels.FuelId,
                IdCar = carEvents.IdCar,
                IdTypeEvents = carEvents.IdTypeEvents,
                IdUser = carEvents.IdUser,
                Mileage = carEvents.Mileage,
                UnitPrice = carEvents.UnitPrice,
                Photo = carEvents.Photo,
                Volume = fuels.Volume
            };
        }

        private static Fuels Fuel(Fuel fuels)
        {
            return new Fuels()
            {
                FuelId = fuels.FuelId,
                Volume = fuels.Volume
            };
        }

        public async Task<IEnumerable<EventService>> GetCarServiceEventsAsync(Guid carId)
        {
            var events = await DbContext.CarEvents.Where(x => x.IdCar == carId)
                .Join(DbContext.CarServices, x => x.EventId, s => s.IdEvent, (x, s) => EventService(x, s)).ToListAsync();
            foreach (var e in events)
            {
                e.Details = await _detailsService.GetDetailsByServiceId(e.ServiceId);
            }
            return events;
        }
        
        public async Task<bool> DeleteCarEventAsync(Guid eventId)
        {
            using (var transaction = DbContext.MyDatabase.BeginTransaction())
            {
                try
                {
                    var deleteEvent = await DbContext.CarEvents.Where(x => x.EventId == eventId).FirstOrDefaultAsync();
                    if (deleteEvent == null)
                        return false;
                    DbContext.CarEvents.Remove(deleteEvent);
                    await DbContext.SaveDbChangesAsync();
                    transaction.Commit();
                    return true;
                }
                catch
                {
                    transaction.Rollback();
                    return false;
                }
            }
        }

        public async Task<bool> CreateCarFuelEventAsync(Fuel fuelEvent)
        {
            using (var transaction = DbContext.MyDatabase.BeginTransaction())
            {
                try
                {
                    await DbContext.CarEvents.AddAsync(EventToCarEvents(fuelEvent));
                    await DbContext.SaveDbChangesAsync();
                    await DbContext.Fuels.AddAsync(FuelToCarFuelsEvent(fuelEvent));
                    await DbContext.SaveDbChangesAsync();
                    transaction.Commit();
                    return true;
                }
                catch
                {
                    transaction.Rollback();
                    return false;
                }
            }
        }

        public async Task<bool> CreateCarServiceEventAsync(EventService serviceEvent)
        {
            using (var transaction = DbContext.MyDatabase.BeginTransaction())
            {
                try
                {
                    await DbContext.CarEvents.AddAsync(EventToCarEvents(serviceEvent));
                    await DbContext.SaveDbChangesAsync();
                    await DbContext.CarServices.AddAsync(EventToCarServices(serviceEvent));
                    await DbContext.SaveDbChangesAsync();

                    if (serviceEvent.Details?.Any() == true)
                    {
                        await DbContext.Details.AddRangeAsync(serviceEvent.Details);
                        await DbContext.SaveDbChangesAsync();
                    }

                    transaction.Commit();
                    return true;
                }
                catch
                {
                    transaction.Rollback();
                    return false;
                }
            }
        }

        public async Task<bool> CreateCarEventAsync(Event carEvent)
        {
            await DbContext.CarEvents.AddAsync(Event(carEvent));
            await DbContext.SaveDbChangesAsync();
            return true;
        }

        public async Task<bool> UpdateCarFuelEventAsync(Fuel fuelEvent)
        {
            using (var transaction = DbContext.MyDatabase.BeginTransaction())
            {
                try
                {
                    DbContext.CarEvents.Update(EventToCarEvents(fuelEvent));
                    await DbContext.SaveDbChangesAsync();
                    DbContext.Fuels.Update(FuelToCarFuelsEvent(fuelEvent));
                    await DbContext.SaveDbChangesAsync();
                    transaction.Commit();
                    return true;
                }
                catch
                {
                    transaction.Rollback();
                    return false;
                }
            }
        }

        public async Task<bool> UpdateCarServiceEventAsync(EventService serviceEvent)
        {
            using (var transaction = DbContext.MyDatabase.BeginTransaction())
            {
                try
                {
                    DbContext.CarEvents.Update(EventToCarEvents(serviceEvent));
                    await DbContext.SaveDbChangesAsync();
                    DbContext.CarServices.Update(EventToCarServices(serviceEvent));
                    await DbContext.SaveDbChangesAsync();

                    if (serviceEvent.Details?.Any() == true)
                    {
                        DbContext.Details.UpdateRange(serviceEvent.Details);
                        await DbContext.SaveDbChangesAsync();
                    }
                    transaction.Commit();
                    return true;
                }
                catch
                {
                    transaction.Rollback();
                    return false;
                }
            }
        }

        public async Task<bool> UpdateCarEventAsync(Event carEvent)
        {
            using (var transaction = DbContext.MyDatabase.BeginTransaction())
            {
                try
                {
                    DbContext.CarEvents.Update(Event(carEvent));
                    await DbContext.SaveDbChangesAsync();
                    transaction.Commit();
                    return true;
                }
                catch
                {
                    transaction.Rollback();
                    return false;
                }
            }
        }

        private static EventService EventService(CarEvents carEvents, CarServices serviceEvents)
        {
            return new EventService()
            {
                EventId = carEvents.EventId,
                AddressStation = carEvents.AddressStation,
                Comment = carEvents.Comment,
                Costs = carEvents.Costs,
                Date = carEvents.Date,
                ServiceId = serviceEvents.ServiceId,
                IdCar = carEvents.IdCar,
                IdTypeEvents = carEvents.IdTypeEvents,
                IdUser = carEvents.IdUser,
                Mileage = carEvents.Mileage,
                UnitPrice = carEvents.UnitPrice,
                Photo = carEvents.Photo,
                IdTypeService = serviceEvents.IdTypeService,
                Name = serviceEvents.Name,
                Details = serviceEvents.Details?.ToList() ?? new List<Details>()
            };
        }

        public async Task<CarEvents> GetEventByIdAsync(Guid idEvent)
        {
            return await DbContext.CarEvents.Where(x => x.EventId == idEvent).FirstOrDefaultAsync();
        }

        public async Task<Fuel> GetFuelEventByIdAsync(Guid idEvent)
        {
            return await DbContext.CarEvents.Where(x => x.EventId == idEvent).Join(DbContext.Fuels.Where(x=>x.IdEvent == idEvent), x => x.EventId, f => f.IdEvent, (x, f) => Fuel(x, f)).FirstOrDefaultAsync();
        }

        public async Task<EventService> GetServiceEventByIdAsync(Guid idEvent)
        {
            return await DbContext.CarEvents.Where(x => x.EventId == idEvent).Join(DbContext.CarServices.Include(nameof(Details)).Where(x => x.IdEvent == idEvent), x => x.EventId, f => f.IdEvent, (x, f) => EventService(x, f)).FirstOrDefaultAsync();
        }

        public async Task<IEnumerable<TypeEvents>> GetTypeEventsAsync()
        {
            return await DbContext.TypeEvents.ToListAsync();
        }
    }
}
