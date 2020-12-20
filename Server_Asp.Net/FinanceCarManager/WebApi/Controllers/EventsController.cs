using System;
using System.Threading.Tasks;
using FCM.Business.IServices;
using FCM.Business.Models;
using FCM.Business.Models.SupportModels;
using Microsoft.AspNetCore.Mvc;
using WebApi.Aspects;
using WebApi.Services;
using WebApi.Shared;

namespace WebApi.Controllers
{
    public class EventsController : Controller
    {
        private readonly IEventsService _eventsService;

        public EventsController(IEventsService eventsService)
        {
            _eventsService = eventsService;
        }

        [HttpGet]
        [AuthenticationFilter]
        [Route("events/carId/{carId:guid}")]
        public async Task<EventsWrapper> GetAllCarEventsAsync(Guid carId)
        {
            if (!Validate()) return null;
            return new EventsWrapper
            {
                Events = await _eventsService.GetCarEventsAsync(carId),
                Fuels = await _eventsService.GetCarFuelsEventsAsync(carId),
                EventServices = await _eventsService.GetCarServiceEventsAsync(carId)
            };
        }

        [HttpGet]
        [AuthenticationFilter]
        [Route("event/{eventId}")]
        public async Task<CarEvents> GetEventById(Guid eventId)
        {
            if (!Validate()) return null;
            return await _eventsService.GetEventByIdAsync(eventId);
        }

        [HttpGet]
        [AuthenticationFilter]
        [Route("fuel/{eventId}")]
        public async Task<Fuel> GetFuelById(Guid eventId)
        {
            if (!Validate()) return null;
            return await _eventsService.GetFuelEventByIdAsync(eventId);
        }

        [HttpGet]
        [AuthenticationFilter]
        [Route("service/{eventId}")]
        public async Task<EventService> GetServicesById(Guid eventId)
        {
            if (!Validate()) return null;
            return await _eventsService.GetServiceEventByIdAsync(eventId);
        }

        [HttpPost]
        [AuthenticationFilter]
        [Route("create/event")]
        public async Task<bool> CreateEvent([FromBody]Event carEvent)
        {
            if (!Validate()) return false;
            return await _eventsService.CreateCarEventAsync(carEvent);
        }

        [HttpPost]
        [AuthenticationFilter]
        [Route("create/fuel")]
        public async Task<bool> CreateFuel([FromBody]Fuel eventFuel)
        {
            if (!Validate()) return false;
            return await _eventsService.CreateCarFuelEventAsync(eventFuel);
        }

        [HttpPost]
        [AuthenticationFilter]
        [Route("create/service")]
        public async Task<bool> CreateServices([FromBody]EventService eventService)
        {
            if (!Validate()) return false;
            return await _eventsService.CreateCarServiceEventAsync(eventService);
        }

        [HttpPut]
        [AuthenticationFilter]
        [Route("update/event")]
        public async Task<bool> UpdateEvent([FromBody]Event carEvent)
        {
            if (!Validate()) return false;
            return await _eventsService.UpdateCarEventAsync(carEvent);
        }

        [HttpPut]
        [AuthenticationFilter]
        [Route("update/fuel")]
        public async Task<bool> UpdateFuel([FromBody]Fuel eventFuel)
        {
            if (!Validate()) return false;
            return await _eventsService.UpdateCarFuelEventAsync(eventFuel);
        }

        [HttpPut]
        [AuthenticationFilter]
        [Route("update/service")]
        public async Task<bool> UpdateServices([FromBody]EventService eventService)
        {
            if (!Validate()) return false;
            return await _eventsService.UpdateCarServiceEventAsync(eventService);
        }

        [HttpDelete]
        [AuthenticationFilter]
        [Route("event/{eventId}")]
        public async Task<bool> DeleteEventById(Guid eventId)
        {
            if (!Validate()) return false;
            return await _eventsService.DeleteCarEventAsync(eventId);
        }
        private bool Validate()
        {
            var headers = HttpContext.Request.Headers;
            if (!headers.TryGetValue("Token", out var token))
                return false;
            var userId = TokenServiceHelper.GetUserId(token);
            if (string.IsNullOrWhiteSpace(userId))
                return false;
            return true;
        }
    }
}
