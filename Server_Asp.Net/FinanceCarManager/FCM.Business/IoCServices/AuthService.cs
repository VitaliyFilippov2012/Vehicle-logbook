using System;
using System.Linq;
using System.Threading.Tasks;
using FCM.Business.IServices;
using FCM.Business.Models;
using Microsoft.EntityFrameworkCore;

namespace FCM.Business.IoCServices
{
    public class AuthService : Service, IAuthService
    {
        public AuthService(IDbModel dbModel) : base(dbModel)
        {
        }

        private bool CredentialsNotValid(string login, string password)
        {
            return string.IsNullOrEmpty(login) || string.IsNullOrEmpty(password);
        }

        public async Task<Guid?> GetUserIdByPasswLoginAsync(string login, string password)
        {
            return await DbContext.Authentication.Where(x => x.Login == login && x.Password == password).Select(x => x.IdUser).FirstOrDefaultAsync();
        }

        public Task<Authentication> GetUserByIdAsync(Guid id)
        {
            return DbContext.Authentication.Where(x => x.IdUser == id).FirstOrDefaultAsync();
        }

        public async Task RegisterUserAsync(Authentication authentication)
        {
            if (CredentialsNotValid(authentication.Login, authentication.Password))
                return;

            await DbContext.Authentication.AddAsync(authentication);
            await DbContext.SaveDbChangesAsync();
        }

        public async Task<bool> UpdateUserCredentialsAsync(Authentication authentication)
        {
            var authUser = await DbContext.Authentication.Where(x => x.IdUser == authentication.IdUser).FirstOrDefaultAsync();
            if (authUser == null)
                return false;
            authUser.Password = authentication.Password;
            authUser.DisableUser = authentication.DisableUser;
            authUser.LastModify = DateTime.Now;
            await DbContext.SaveDbChangesAsync();
            return true;
        }
    }
}
