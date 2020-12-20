using System.Threading.Tasks;
using FCM.Business.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;

namespace FCM.Business
{
    public interface IDbModel
    {
        DbSet<Authentication> Authentication { get; set; }
        DbSet<ActionAudit> ActionAudit { get; set; }
        DbSet<Cars> Cars { get; set; }
        DbSet<Details> Details { get; set; }
        DbSet<CarEvents> CarEvents { get; set; }
        DbSet<Fuels> Fuels { get; set; }
        DbSet<CarServices> CarServices { get; set; }
        DbSet<TypeEvents> TypeEvents { get; set; }
        DbSet<TypeServices> TypeServices { get; set; }
        DbSet<Users> Users { get; set; }
        DbSet<UsersCars> UsersCars { get; set; }
        Task<int> SaveDbChangesAsync();
        DatabaseFacade MyDatabase { get; }
    }
}
