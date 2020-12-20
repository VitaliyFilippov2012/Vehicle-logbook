
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using FCM.Business.Models;

namespace FCM.Business.IServices
{
    public interface IAuthService
    {
        Task<Guid?> GetUserIdByPasswLoginAsync(string login, string password);
        Task<Authentication> GetUserByIdAsync(Guid id);
        Task RegisterUserAsync(Authentication authentication);
        Task<bool> UpdateUserCredentialsAsync(Authentication authentication);

    }
}
