using System;

namespace WebApi.Shared
{
    [Serializable]
    public class LoginResult
    {
        public string AccessToken { get; set; }
    }
}
