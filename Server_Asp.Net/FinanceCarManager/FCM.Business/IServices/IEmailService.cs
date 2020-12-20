using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace FCM.Business.IoCServices
{
    public interface IEmailService
    {
        Task SendEmailMessageAsync(string message, string emailTo, string emailFrom = "iDonateBelarus@yandex.ru");
    }
}
