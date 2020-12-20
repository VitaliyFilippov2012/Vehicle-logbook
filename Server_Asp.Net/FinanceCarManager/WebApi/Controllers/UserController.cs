using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using FCM.Business.IServices;
using Microsoft.AspNetCore.Mvc;
using FCM.Business.Models;
using WebApi.Aspects;
using WebApi.Services;
using WebApi.Shared;

namespace WebApi.Controllers
{
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly IUsersService _userService;


        public UserController(IUsersService userService)
        {
            _userService = userService;
        }

        [HttpGet]
        [AuthenticationFilter]
        [Route("user/name/{name}")]
        public async Task<IEnumerable<Users>> GetUserByNameAsync(string name)
        {
            return (await _userService.GetAllUsersAsync()).Where(x=>x.Name == name).ToList();
        }

        [HttpGet]
        [AuthenticationFilter]
        [Route("user/id")]
        public async Task<Users> GetUserById()
        {
            var headers = HttpContext.Request.Headers;
            if (!headers.TryGetValue("Token", out var token))
                return null;
            var userId = TokenServiceHelper.GetUserId(token);
            if (string.IsNullOrWhiteSpace(userId))
                return null;
            return await _userService.GetUserByIdAsync(Guid.Parse(userId));
        }

        [HttpPut]
        [AuthenticationFilter]
        [Route("user")]
        public async Task<bool> UpdateUser([FromBody]UserInfo user)
        {
            var headers = HttpContext.Request.Headers;
            if (!headers.TryGetValue("Token", out var token))
                return false;
            var userId = TokenServiceHelper.GetUserId(token);
            if (string.IsNullOrWhiteSpace(userId))
                return false;
            return await _userService.UpdateUserAsync(new Users()
            {
                UserId = Guid.Parse(userId),
                Address = user.Address,
                Birthday = user.Birthday,
                City = user.City,
                Lastname = user.Lastname,
                Name = user.Name,
                Patronymic = user.Patronymic,
                Phone = user.Phone,
                Sex = user.Sex,
                Photo = user.Photo
            });
        }
    }
}
