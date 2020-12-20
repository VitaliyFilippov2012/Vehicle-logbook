using System;
using System.Linq;
using System.Threading.Tasks;
using FCM.Business.IServices;
using Microsoft.AspNetCore.Mvc;
using WebApi.Aspects;
using WebApi.Services;
using WebApi.Shared;

namespace WebApi.Controllers
{
    public class StaticDataController : Controller
    {
        private readonly IUsersService _userService;
        private readonly IServicesService _serviceService;
        private readonly IEventsService _eventsService;

        public StaticDataController(IUsersService userService, IServicesService serviceService, IEventsService eventsService)
        {
            _userService = userService;
            _serviceService = serviceService;
            _eventsService = eventsService;
        }

        [HttpGet]
        [AuthenticationFilter]
        [Route("data/getStaticInfo")]
        public async Task<StaticDataWrapper> GetStaticData()
        {
            var headers = HttpContext.Request.Headers;
            if(!headers.TryGetValue("Token", out var token))
                return null;
            var userId = TokenServiceHelper.GetUserId(token);
            if (string.IsNullOrWhiteSpace(userId))
                return null;
            var user = await _userService.GetUserByIdAsync(Guid.Parse(userId));
            var typeServices = await _serviceService.GetTypeService();
            var typeEvents = await _eventsService.GetTypeEventsAsync();
            var result = new StaticDataWrapper()
            {
                UserInfo = new UserInfo()
                {
                    UserId = user.UserId,
                    Address = user.Address,
                    Birthday = user.Birthday,
                    City = user.City,
                    Lastname = user.Lastname,
                    Name = user.Name,
                    Patronymic = user.Patronymic,
                    Phone = user.Phone,
                    Sex = user.Sex,
                    Photo = user.Photo
                },
                TypeServices = typeServices.Select(x => new Shared.Type() {TypeId = x.TypeServiceId, TypeName = x.TypeName})
                    .ToList(),
                TypeEvents = typeEvents.Select(x => new Shared.Type() {TypeId = x.TypeEventId, TypeName = x.TypeName})
                    .ToList(),
            };

            return result;
        }
    }
}