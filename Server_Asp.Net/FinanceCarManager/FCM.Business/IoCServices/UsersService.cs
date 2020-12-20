using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using FCM.Business.IServices;
using FCM.Business.Models;
using Microsoft.EntityFrameworkCore;

namespace FCM.Business.IoCServices
{
    public class UsersService : Service, IUsersService
    {
        public UsersService(IDbModel dbModel) : base(dbModel)
        {
        }

        public async Task<IEnumerable<Users>> GetAllUsersAsync()
        {
            return await DbContext.Users.ToListAsync();
        }

        public async Task<Users> GetUserByIdAsync(Guid idUser)
        {
            return await DbContext.Users.Where(x => x.UserId == idUser).FirstOrDefaultAsync();
        }

        public async Task<IEnumerable<Cars>> GetUserCarsByUserIdAsync(Guid idUser)
        {
            return await DbContext.UsersCars.Where(x => x.IdUser == idUser).Select(x=>x.IdCarNavigation).ToListAsync();
        }

        public async Task<Guid> CreateNewUserAsync(Users user)
        {
            if(user.UserId == Guid.Empty)
                user.UserId = Guid.NewGuid();
            await DbContext.Users.AddAsync(user);
            return user.UserId;
        }

        public Task<Guid> GetUserByLoginAsync(string email)
        {
            return DbContext.Authentication.Where(x => x.Login == email).Select(x => x.IdUser).FirstOrDefaultAsync();
        }

        public async Task<bool> UpdateUserAsync(Users user)
        {
            using (var transaction = DbContext.MyDatabase.BeginTransaction())
            {
                try
                {
                    DbContext.Users.Update(user);
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
    }
}
