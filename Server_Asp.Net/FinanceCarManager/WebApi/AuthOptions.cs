using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.IdentityModel.Tokens;

namespace WebApi
{
    public class AuthOptions
    {
        public const string ISSUER = "AuthServerCore";
        public const string AUDIENCE = "FinanceCarManager";
        const string KEY = "vitaliy_filippov_poibms3_8";
        public const int LIFETIME = 60;
        public static SymmetricSecurityKey GetSymmetricSecurityKey()
        {
            return new SymmetricSecurityKey(Encoding.ASCII.GetBytes(KEY));
        }

        public static TokenValidationParameters GetValidatingParameters()
        {
            return new TokenValidationParameters()
            {
                RequireExpirationTime = true,
                ValidateIssuer = true,
                ValidIssuer = ISSUER,
                ValidAudience = AUDIENCE,
                ValidateAudience = true,
                IssuerSigningKey = AuthOptions.GetSymmetricSecurityKey()
            };
        }
    }
}
