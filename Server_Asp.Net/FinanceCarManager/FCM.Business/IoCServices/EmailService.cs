using System;
using System.Net;
using System.Net.Mail;
using System.Threading;
using System.Threading.Tasks;

namespace FCM.Business.IoCServices
{
    public class EmailService : IEmailService
    {
        public async Task SendEmailMessageAsync(string message, string emailTo, string emailFrom = "iDonateBelarus@yandex.ru")
        {
            MailAddress from = new MailAddress(emailFrom, "Support FinanceCarManager");
            MailAddress to = new MailAddress(emailTo);
            MailMessage m = new MailMessage(from, to)
            {
                Subject = "Heeeyyy my friend",
                Body = message
            };
            SmtpClient smtp = new SmtpClient("smtp.yandex.ru", 587)
            {
                Credentials = new NetworkCredential(emailFrom, "igiveapieceofheart"),
                EnableSsl = true
            };
            var sending = true;
            while (sending)
            {
                try
                {
                    await smtp.SendMailAsync(m);
                    sending = false;
                }
                catch
                {
                    Thread.Sleep(1000);
                    sending = true;
                }
                
            }
        }
    }
}
