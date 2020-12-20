using System.ServiceModel;
using FCM.Business;
using FCM.Business.IoCServices;
using FCM.Business.IServices;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;
using Microsoft.Extensions.Hosting;
using Microsoft.IdentityModel.Tokens;
using Newtonsoft.Json;
using SoapCore;
using SynchronizationService.Service;

namespace WebApi
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        public void ConfigureServices(IServiceCollection services)
        {
            services.AddMvc();
            ConfigureAuthOptions(services);
            services.AddControllers();
            ConfigureIoC(services);
        }

        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            app.UseDefaultFiles();
            app.UseStaticFiles();
            app.UseHttpsRedirection();
            app.UseRouting();
            app.UseEndpoints(endpoints =>
            {
                endpoints.MapDefaultControllerRoute();
            });
            app.UseSoapEndpoint<ISoapService>("/Service.asmx", new BasicHttpBinding(), SoapSerializer.XmlSerializer);
        }

        private void ConfigureIoC(IServiceCollection services)
        {
            services.AddScoped<IDbModel, MasterCarManagerContext>();
            services.AddScoped<IUsersService, UsersService>();
            services.AddScoped<ICarsService, CarsService>();
            services.AddScoped<IServicesService, ServicesService>();
            services.AddScoped<IDetailsService, DetailsService>();
            services.AddScoped<IEventsService, EventsService>();
            services.AddScoped<IAuthService, AuthService>();
            services.AddScoped<IAuditService, AuditService>();
            services.AddScoped<IEmailService, EmailService>();
            services.AddScoped<ISoapService, SoapService>();
            services.AddScoped<ICryptographyService, CryptographyService>();
        }

        private void ConfigureAuthOptions(IServiceCollection services)
        {
            services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
                .AddJwtBearer(options =>
                {
                    options.RequireHttpsMetadata = false;
                    options.TokenValidationParameters = new TokenValidationParameters
                    {
                        ValidateIssuer = true,
                        ValidIssuer = AuthOptions.ISSUER,
                        ValidateAudience = true,
                        ValidAudience = AuthOptions.AUDIENCE,
                        ValidateLifetime = true,
                        IssuerSigningKey = AuthOptions.GetSymmetricSecurityKey(),
                        ValidateIssuerSigningKey = true,
                    };
                });

            services.AddControllers().AddNewtonsoftJson(options =>
                options.SerializerSettings.ReferenceLoopHandling = ReferenceLoopHandling.Ignore
            );

        }
    }
}
