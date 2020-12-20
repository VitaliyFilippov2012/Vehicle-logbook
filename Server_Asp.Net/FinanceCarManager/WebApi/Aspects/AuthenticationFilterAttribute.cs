using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc.Filters;
using WebApi.Services;

namespace WebApi.Aspects
{
    public class AuthenticationFilterAttribute : ActionFilterAttribute
    {
        private const string TokenParameterName = "Token";
        
        public override async Task OnActionExecutionAsync(ActionExecutingContext context, ActionExecutionDelegate next)
        {
            await base.OnActionExecutionAsync(context, next);
            var headers = context.HttpContext.Request.Headers;
            if (!headers.TryGetValue(TokenParameterName, out var token))
                return;

            if (!TokenServiceHelper.ValidateToken(token))
                context.HttpContext.Response.StatusCode = 401;
        }
    }
}
