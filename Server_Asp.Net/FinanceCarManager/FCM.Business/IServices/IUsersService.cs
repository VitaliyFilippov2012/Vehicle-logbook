using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using FCM.Business.Models;

namespace FCM.Business.IServices
{
    public interface IUsersService
    {
        Task<IEnumerable<Users>> GetAllUsersAsync();

        Task<Users> GetUserByIdAsync(Guid idUser);
        
        Task<Guid> CreateNewUserAsync(Users user);

        Task<Guid> GetUserByLoginAsync(string email);

        Task<bool> UpdateUserAsync(Users user);
    }
}
