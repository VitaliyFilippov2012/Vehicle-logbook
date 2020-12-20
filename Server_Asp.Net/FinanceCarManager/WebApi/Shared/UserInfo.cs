using System;
using System.ComponentModel.DataAnnotations;
using WebApi.Aspects;

namespace WebApi.Shared
{
    [Serializable]
    public class UserInfo
    {
        public Guid UserId { get; set; }
        public string Sex { get; set; }

        [Date]
        [DisplayFormat(DataFormatString = "{0:dd-MM-yyyy}", ApplyFormatInEditMode = true)]
        public DateTime Birthday { get; set; }
        public string Name { get; set; }
        public string Lastname { get; set; }
        public string Patronymic { get; set; }
        public string Address { get; set; }
        public string Phone { get; set; }
        public string City { get; set; }
        public byte[] Photo { get; set; }
    }
}
