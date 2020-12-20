using System;
using System.ComponentModel.DataAnnotations;

namespace WebApi.Aspects
{
    public class DateAttribute : RangeAttribute
    {
        public DateAttribute() : base(typeof(DateTime), DateTime.Now.AddYears(-120).ToShortDateString(), DateTime.Now.ToShortDateString())
        {

        }
    }
}
