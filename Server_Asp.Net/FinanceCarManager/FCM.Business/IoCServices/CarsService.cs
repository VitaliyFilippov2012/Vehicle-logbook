using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using FCM.Business.IServices;
using FCM.Business.Models;
using Microsoft.EntityFrameworkCore;
using FCM.Business.Models.SupportModels;

namespace FCM.Business.IoCServices
{
    public class CarsService : Service, ICarsService
    {
        private readonly IUsersService _userService;
        private readonly ICryptographyService _cryptographyService;
        private readonly IEmailService _emailService;

        public CarsService(IDbModel dbModel, IUsersService usersService, ICryptographyService cryptographyService, IEmailService emailService) : base(dbModel)
        {
            _userService = usersService;
            _cryptographyService = cryptographyService;
            _emailService = emailService;
        }

        public async Task<IEnumerable<Cars>> GetAllUserCarsAsync(Guid userid)
        {
            return await DbContext.UsersCars.Where(x => x.IdUser == userid).Join(DbContext.Cars, x => x.IdCar, c => c.CarId, (x, c) => c).Include(x => x.CarEvents).ToListAsync();
        }

        public async Task<IEnumerable<Cars>> GetCarByIdAsync(Guid idCar)
        {
            return await DbContext.Cars.Where(x => x.CarId == idCar).ToListAsync();
        }

        public async Task<Guid> CreateCarAsync(Cars car, Guid userId)
        {
            using (var transaction = DbContext.MyDatabase.BeginTransaction())
            {
                try
                {
                    await DbContext.Cars.AddAsync(car);
                    await DbContext.SaveDbChangesAsync();
                    await DbContext.UsersCars.AddAsync(new UsersCars() { IdUser = userId, IdCar = car.CarId });
                    await DbContext.SaveDbChangesAsync();
                    transaction.Commit();
                    return car.CarId;
                }
                catch
                {
                    transaction.Rollback();
                    return Guid.Empty;
                }
            }
        }

        public async Task<bool> UpdateCarAsync(Cars car)
        {
            var carForUpdate = await DbContext.Cars.Where(x => x.CarId == car.CarId).FirstOrDefaultAsync();
            if (carForUpdate == null)
                return false;
            carForUpdate.Active = car.Active;
            carForUpdate.Comment = car.Comment;
            carForUpdate.Mark = car.Mark;
            carForUpdate.Model = car.Model;
            carForUpdate.Photo = car.Photo;
            carForUpdate.Power = car.Power;
            carForUpdate.TypeFuel = car.TypeFuel;
            carForUpdate.TypeTransmission = car.TypeTransmission;
            carForUpdate.Vin = car.Vin;
            carForUpdate.VolumeEngine = car.VolumeEngine;
            carForUpdate.YearIssue = car.YearIssue;
            await DbContext.SaveDbChangesAsync();
            return true;
        }

        public async Task<bool> ShareCarWithOtherUserAsync(Guid carId, string email, string uri)
        {
            if (string.IsNullOrWhiteSpace(email))
                return false;
            var userId = await _userService.GetUserByLoginAsync(email);
            if (userId == Guid.Empty)
                return false;
            var json = carId + userId.ToString();
            var encryptJson = _cryptographyService.EncryptString(json);
            var message = "Follow the link to add a common car\n Link: " + uri + encryptJson;
            await _emailService.SendEmailMessageAsync(message, email);
            return true;
        }

        public async Task<bool> AddShareCarAsync(string str)
        {
            using (var transaction = DbContext.MyDatabase.BeginTransaction())
            {
                try
                {
                    if (string.IsNullOrWhiteSpace(str))
                        return false;

                    var decryptJson = _cryptographyService.DecryptString(str);
                    var share = new ShareCarWithUserWrapper()
                    {
                        CarId = Guid.Parse(decryptJson.Remove(36)),
                        UserId = Guid.Parse(decryptJson.Replace(decryptJson.Remove(36), ""))
                    };
                    await DbContext.UsersCars.AddAsync(new UsersCars() { IdUser = share.UserId, IdCar = share.CarId });
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

        public async Task<bool> DeleteShareCarAsync(Guid carId, Guid userId)
        {
            var car = await DbContext.UsersCars.Where(x => x.IdUser == userId && x.IdCar == carId).FirstOrDefaultAsync();
            if (car == null)
                return true;
            DbContext.UsersCars.Remove(car);
            await DbContext.SaveDbChangesAsync();
            return true;
        }
    }
}
