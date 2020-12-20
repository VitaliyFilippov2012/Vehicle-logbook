using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.IdentityModel.Tokens;
using WebApi.Shared;
using FCM.Business.IServices;

namespace WebApi.Services
{
    public static class TokenServiceHelper
    {
        private static IAuthService _authService;

        public static async Task<LoginResult> GetTokenAsync(UserCredentials credentials, IAuthService authService)
        {
            _authService = authService;
            var identity = await GetIdentity(credentials.Login, credentials.Password);
            if (identity == null)
                return null;

            var now = DateTime.UtcNow;
            var jwt = new JwtSecurityToken(
                issuer: AuthOptions.ISSUER,
                audience: AuthOptions.AUDIENCE,
                notBefore: now,
                claims: identity.Claims,
                expires: now.Add(TimeSpan.FromMinutes(AuthOptions.LIFETIME)),
                signingCredentials: new SigningCredentials(AuthOptions.GetSymmetricSecurityKey(),
                    SecurityAlgorithms.HmacSha256));
            return !Guid.TryParse(identity.Name, out _) ? null : new LoginResult() { AccessToken = new JwtSecurityTokenHandler().WriteToken(jwt) };
        }

        public static bool ValidateToken(string token)
        {
            return !string.IsNullOrEmpty(GetUserId(token));
        }

        public static string GetUserId(string token)
        {
            var identity = GetTokenIdentity(token);
            if (identity == null || !identity.IsAuthenticated)
                return "";

            var userIdClaim = identity.FindFirst(ClaimTypes.Name);
            var userId = userIdClaim?.Value;
            return userId;
        }

        private static async Task<Guid?> GetUserIdAsync(string login, string password)
        {
            return await _authService.GetUserIdByPasswLoginAsync(login, password);
        }

        private static async Task<ClaimsIdentity> GetIdentity(string login, string password)
        {
            var userId = await GetUserIdAsync(login, password);
            if (!userId.HasValue || userId.Value == Guid.Empty)
                return null;
            var claims = new List<Claim> { new Claim(ClaimsIdentity.DefaultNameClaimType, userId.ToString()) };

            return new ClaimsIdentity(claims, "Token", ClaimsIdentity.DefaultNameClaimType,
                ClaimsIdentity.DefaultRoleClaimType);
        }

        private static ClaimsIdentity GetTokenIdentity(string token)
        {
            var simplePrinciple = GetPrincipal(token);
            return simplePrinciple?.Identity as ClaimsIdentity;
        }

        private static JwtSecurityTokenHandler GeTokenHandler(string token)
        {
            var tokenHandler = new JwtSecurityTokenHandler();
            return new JwtSecurityTokenHandler().ReadToken(token) is JwtSecurityToken ? tokenHandler : null;
        }

        public static ClaimsPrincipal GetPrincipal(string token)
        {
            try
            {
                var tokenHandler = GeTokenHandler(token);
                return tokenHandler.ValidateToken(token, AuthOptions.GetValidatingParameters(), out _);
            }
            catch (Exception exception)
            {
                Debug.WriteLine($"FCM_Exception: {exception.Message}");
                return null;
            }
        }
    }
}
