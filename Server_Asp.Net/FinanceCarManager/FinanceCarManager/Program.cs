using System;
using FCM.Business;

namespace FinanceCarManager
{
    class Program
    {
        static void Main(string[] args)
        {
            var d = new Master_CarManagerContext();
            var f = d.Users.Where(x => x.Name == "Vitali").ToList();
            Console.ReadKey();
        }
    }
}
