using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using FCM.Business.IServices;
using FCM.Business.Models;
using Microsoft.AspNetCore.Mvc;
using WebApi.Aspects;
using WebApi.Services;
using WebApi.Shared;

namespace WebApi.Controllers
{
    public class CarsController : Controller
    {
        private readonly ICarsService _carsService;

        public CarsController(ICarsService carsService)
        {
            _carsService = carsService;
        }

        [HttpGet]
        [AuthenticationFilter]
        [Route("cars/userId")]
        public async Task<IEnumerable<Cars>> GetCarsAsync()
        {
            var headers = HttpContext.Request.Headers;
            if (!headers.TryGetValue("Token", out var token))
                return null;
            var userId = TokenServiceHelper.GetUserId(token);
            if (string.IsNullOrWhiteSpace(userId))
                return null;
            return await _carsService.GetAllUserCarsAsync(Guid.Parse(userId));
        }

        [HttpGet]
        [AuthenticationFilter]
        [Route("car/{carId}")]
        public async Task<IEnumerable<Cars>> GetCarByIdName(Guid carId)
        {
            if (!Validate()) return null;
            return await _carsService.GetCarByIdAsync(carId);
        }

        [HttpPost]
        [AuthenticationFilter]
        [Route("car")]
        public async Task<Guid?> CreateCar([FromBody]Car car)
        {
            var headers = HttpContext.Request.Headers;
            if (!headers.TryGetValue("Token", out var token))
                return null;
            var userId = TokenServiceHelper.GetUserId(token);
            if (string.IsNullOrWhiteSpace(userId))
                return null;
            return await _carsService.CreateCarAsync(ConverToCar(car),Guid.Parse(userId));
        }

        [HttpPost]
        [AuthenticationFilter]
        [Route("car/shareCar/{carId}&{email}")]
        public async Task<bool> ShareCar(Guid carId, string email)
        {
            if (!Validate()) return false;
            var uri = Constants.URI_SERVER + "/fcm/addShareCar/";
            return await _carsService.ShareCarWithOtherUserAsync(carId,email,uri);
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

        [HttpGet]
        [Route("fcm/addShareCar/{json}")]
        public async Task<IActionResult> AddSharingCar(string json)
        {
            if(await _carsService.AddShareCarAsync(json))
                return View("CarAdded");
            return View("Oops");
        }

        [HttpDelete]
        [AuthenticationFilter]
        [Route("fcm/deleteShareCar/{carId}")]
        public async Task<bool> AddSharingCar(Guid carId)
        {
            var headers = HttpContext.Request.Headers;
            if (!headers.TryGetValue("Token", out var token))
                return false;
            var userId = TokenServiceHelper.GetUserId(token);
            if (string.IsNullOrWhiteSpace(userId))
                return false;
            return  await _carsService.DeleteShareCarAsync(carId,Guid.Parse(userId));
        }

        [HttpPut]
        [AuthenticationFilter]
        [Route("car")]
        public async Task<bool> UpdateCar([FromBody]Car car)
        {
            if (!Validate()) return false;
            return await _carsService.UpdateCarAsync(ConverToCar(car));
        }

        private Cars ConverToCar(Car car)
        {
            return new Cars()
            {
                CarId = car.CarId.Value,
                Active = car.Active,
                Comment = car.Comment,
                Mark = car.Mark,
                Model = car.Model,
                Photo = car.Photo,
                Power = car.Power,
                TypeFuel = car.TypeFuel,
                TypeTransmission = car.TypeTransmission,
                Vin = car.Vin,
                VolumeEngine = car.VolumeEngine,
                YearIssue = car.YearIssue,
            };
        }
    }
}
