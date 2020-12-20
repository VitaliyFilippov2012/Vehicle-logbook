using System.Threading.Tasks;
using FCM.Business.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;

namespace FCM.Business
{
    public partial class MasterCarManagerContext : DbContext, IDbModel
    {
        public MasterCarManagerContext()
        {
            MyDatabase = Database;
        }

        public MasterCarManagerContext(DbContextOptions<MasterCarManagerContext> options)
            : base(options)
        {
        }

        public DatabaseFacade MyDatabase { get; }
        public virtual DbSet<ActionAudit> ActionAudit { get; set; }
        public virtual DbSet<Authentication> Authentication { get; set; }
        public virtual DbSet<CarEvents> CarEvents { get; set; }
        public virtual DbSet<CarServices> CarServices { get; set; }
        public virtual DbSet<Cars> Cars { get; set; }
        public virtual DbSet<Details> Details { get; set; }
        public virtual DbSet<Fuels> Fuels { get; set; }
        public virtual DbSet<TypeEvents> TypeEvents { get; set; }
        public virtual DbSet<TypeServices> TypeServices { get; set; }
        public virtual DbSet<Users> Users { get; set; }
        public virtual DbSet<UsersCars> UsersCars { get; set; }

        public Task<int> SaveDbChangesAsync()
        {
            return this.SaveChangesAsync();
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
               optionsBuilder.UseSqlServer("Server=DESKTOP-GU3DGFA\\VITALI_DESKTOP;Initial Catalog=Master_CarManager;Integrated Security=True");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<ActionAudit>(entity =>
            {
                entity.HasKey(e => new { e.EntityId, e.DateUpdate, e.IdUser });

                entity.Property(e => e.DateUpdate)
                    .HasMaxLength(50)
                    .IsUnicode(false);

                entity.Property(e => e.Action)
                    .IsRequired()
                    .HasMaxLength(20)
                    .IsUnicode(false);

                entity.Property(e => e.Entity)
                    .IsRequired()
                    .HasMaxLength(50)
                    .IsUnicode(false);

                entity.HasOne(d => d.IdUserNavigation)
                    .WithMany(p => p.ActionAudit)
                    .HasForeignKey(d => d.IdUser)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_ActionAudit_User");
            });

            modelBuilder.Entity<Authentication>(entity =>
            {
                entity.HasKey(e => e.Login);

                entity.ToTable("AUTHENTICATION");

                entity.Property(e => e.Login).HasMaxLength(50);

                entity.Property(e => e.DisableUser).HasDefaultValueSql("((0))");

                entity.Property(e => e.IdUser)
                    .HasColumnName("idUser")
                    .HasDefaultValueSql("(newid())");

                entity.Property(e => e.LastModify).HasColumnType("date");

                entity.Property(e => e.Password)
                    .IsRequired()
                    .HasMaxLength(32);

                entity.HasOne(d => d.IdUserNavigation)
                    .WithMany(p => p.Authentication)
                    .HasForeignKey(d => d.IdUser)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Authentication_User");
            });

            modelBuilder.Entity<CarEvents>(entity =>
            {
                entity.HasKey(e => e.EventId)
                    .HasName("PK_Events");

                entity.Property(e => e.EventId).HasDefaultValueSql("(newid())");

                entity.Property(e => e.AddressStation)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.Comment)
                    .HasMaxLength(200)
                    .IsUnicode(false);

                entity.Property(e => e.Costs).HasColumnType("money");

                entity.Property(e => e.Date).HasColumnType("date");

                entity.Property(e => e.IdCar).HasColumnName("idCar");

                entity.Property(e => e.IdTypeEvents).HasColumnName("idTypeEvents");

                entity.Property(e => e.IdUser).HasColumnName("idUser");

                entity.Property(e => e.Photo).HasColumnName("photo");

                entity.Property(e => e.UnitPrice).HasColumnType("money");

                entity.HasOne(d => d.IdCarNavigation)
                    .WithMany(p => p.CarEvents)
                    .HasForeignKey(d => d.IdCar)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Events_Car");

                entity.HasOne(d => d.IdTypeEventsNavigation)
                    .WithMany(p => p.CarEvents)
                    .HasForeignKey(d => d.IdTypeEvents)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Events_TypeEvents");

                entity.HasOne(d => d.IdUserNavigation)
                    .WithMany(p => p.CarEvents)
                    .HasForeignKey(d => d.IdUser)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Events_User");
            });

            modelBuilder.Entity<CarServices>(entity =>
            {
                entity.HasKey(e => e.ServiceId)
                    .HasName("PK_Service");

                entity.Property(e => e.ServiceId).HasDefaultValueSql("(newid())");

                entity.Property(e => e.IdEvent).HasColumnName("idEvent");

                entity.Property(e => e.IdTypeService).HasColumnName("idTypeService");

                entity.Property(e => e.Name)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.HasOne(d => d.IdEventNavigation)
                    .WithMany(p => p.CarServices)
                    .HasForeignKey(d => d.IdEvent)
                    .OnDelete(DeleteBehavior.Cascade)
                    .HasConstraintName("FK_Services_Events");

                entity.HasOne(d => d.IdTypeServiceNavigation)
                    .WithMany(p => p.CarServices)
                    .HasForeignKey(d => d.IdTypeService)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Services_TypeServices");
            });

            modelBuilder.Entity<Cars>(entity =>
            {
                entity.HasKey(e => e.CarId);

                entity.HasIndex(e => e.Vin)
                    .HasName("UQ__Cars__C5DF234C7A2097F9")
                    .IsUnique();

                entity.Property(e => e.CarId).HasDefaultValueSql("(newid())");

                entity.Property(e => e.Active).HasDefaultValueSql("((1))");

                entity.Property(e => e.Comment)
                    .HasMaxLength(17)
                    .IsUnicode(false);

                entity.Property(e => e.Mark)
                    .IsRequired()
                    .HasMaxLength(20)
                    .IsUnicode(false);

                entity.Property(e => e.Model)
                    .IsRequired()
                    .HasMaxLength(20)
                    .IsUnicode(false);

                entity.Property(e => e.Photo).HasColumnName("photo");

                entity.Property(e => e.TypeFuel)
                    .IsRequired()
                    .HasMaxLength(20)
                    .IsUnicode(false);

                entity.Property(e => e.TypeTransmission)
                    .IsRequired()
                    .HasMaxLength(20)
                    .IsUnicode(false);

                entity.Property(e => e.Vin)
                    .IsRequired()
                    .HasColumnName("VIN")
                    .HasMaxLength(17)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<Details>(entity =>
            {
                entity.HasKey(e => e.DetailId);

                entity.Property(e => e.DetailId).HasDefaultValueSql("(newid())");

                entity.Property(e => e.IdCar).HasColumnName("idCar");

                entity.Property(e => e.IdService).HasColumnName("idService");

                entity.Property(e => e.Name)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.Type)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.HasOne(d => d.IdCarNavigation)
                    .WithMany(p => p.Details)
                    .HasForeignKey(d => d.IdCar)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Details_Cars");

                entity.HasOne(d => d.IdServiceNavigation)
                    .WithMany(p => p.Details)
                    .HasForeignKey(d => d.IdService)
                    .OnDelete(DeleteBehavior.Cascade)
                    .HasConstraintName("FK_Details_Service");
            });

            modelBuilder.Entity<Fuels>(entity =>
            {
                entity.HasKey(e => e.FuelId);

                entity.Property(e => e.FuelId).HasDefaultValueSql("(newid())");

                entity.Property(e => e.IdEvent).HasColumnName("idEvent");

                entity.HasOne(d => d.IdEventNavigation)
                    .WithMany(p => p.Fuels)
                    .HasForeignKey(d => d.IdEvent)
                    .OnDelete(DeleteBehavior.Cascade)
                    .HasConstraintName("FK_Fuels_Events");
            });

            modelBuilder.Entity<TypeEvents>(entity =>
            {
                entity.HasKey(e => e.TypeEventId);

                entity.HasIndex(e => e.TypeName)
                    .HasName("UQ__TypeEven__D4E7DFA8D9B6AA55")
                    .IsUnique();

                entity.Property(e => e.TypeEventId).HasDefaultValueSql("(newid())");

                entity.Property(e => e.TypeName)
                    .IsRequired()
                    .HasMaxLength(20)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<TypeServices>(entity =>
            {
                entity.HasKey(e => e.TypeServiceId)
                    .HasName("PK_TypeService");

                entity.HasIndex(e => e.TypeName)
                    .HasName("UQ__TypeServ__D4E7DFA8E3B1CFD2")
                    .IsUnique();

                entity.Property(e => e.TypeServiceId).HasDefaultValueSql("(newid())");

                entity.Property(e => e.TypeName)
                    .IsRequired()
                    .HasMaxLength(20)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<Users>(entity =>
            {
                entity.HasKey(e => e.UserId);

                entity.Property(e => e.UserId).HasDefaultValueSql("(newid())");

                entity.Property(e => e.Address)
                    .IsRequired()
                    .HasMaxLength(60);

                entity.Property(e => e.Birthday).HasColumnType("date");

                entity.Property(e => e.City)
                    .IsRequired()
                    .HasMaxLength(20);

                entity.Property(e => e.Lastname)
                    .IsRequired()
                    .HasMaxLength(20);

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(20);

                entity.Property(e => e.Patronymic)
                    .IsRequired()
                    .HasMaxLength(30);

                entity.Property(e => e.Phone).HasMaxLength(20);

                entity.Property(e => e.Photo).HasColumnName("photo");

                entity.Property(e => e.Sex)
                    .IsRequired()
                    .HasMaxLength(1);
            });

            modelBuilder.Entity<UsersCars>(entity =>
            {
                entity.HasKey(e => new { e.IdUser, e.IdCar });

                entity.Property(e => e.IdUser).HasColumnName("idUser");

                entity.Property(e => e.IdCar).HasColumnName("idCar");

                entity.HasOne(d => d.IdCarNavigation)
                    .WithMany(p => p.UsersCars)
                    .HasForeignKey(d => d.IdCar)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_UserCars_Car");

                entity.HasOne(d => d.IdUserNavigation)
                    .WithMany(p => p.UsersCars)
                    .HasForeignKey(d => d.IdUser)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_UserCars_User");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
