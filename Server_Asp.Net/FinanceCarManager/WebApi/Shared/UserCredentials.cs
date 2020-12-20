using System;

namespace WebApi.Shared
{
    [Serializable]
    public class UserCredentials
    {
        public string Password { get; set; }

        public string Login { get; set; }
    }
}
