using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using FCM.Business.IServices;

namespace FCM.Business.IoCServices
{
    public class CryptographyService : ICryptographyService
    {
        private readonly byte[] _aeskey = Encoding.Default.GetBytes("B&E(H+MbQeThWmZq4t7w!z%C*F-J@NcR");

        public string EncryptString(string str)
        {
            var alphabet = str.ToList();
            if (Math.Sqrt(alphabet.Count) % 1 != 0)
            {
                while (Math.Sqrt(alphabet.Count) % 1 != 0)
                {
                    alphabet.Add('q');
                }
            }

            var row = Math.Sqrt(alphabet.Count);

            var newAlphabet = new List<char>();
            var c = true;
            var j = 0;
            while (c)
            {
                for (var i = j; i != (int) row - 1 & i < alphabet.Count; i += (int) row)
                    newAlphabet.Add(alphabet[i]);

                if (j == (int) row - 1)
                {
                    for (var i = (int) row - 1; i < alphabet.Count; i += (int) row)
                        newAlphabet.Add(alphabet[i]);
                    c = false;
                }

                j++;
            }

            var result = "";
            newAlphabet.ForEach(x => result += x);
            return result;
        }

        public string DecryptString(string str)
        {
            var alphabet = str.ToList();
            var baseAlphabet = new List<char>();
            var row = Math.Sqrt(alphabet.Count);
            var c = true;
            var j = 0;
            while (c)
            {
                for (var i = j; i != (int)row - 1 & i < alphabet.Count; i += (int)row)
                    baseAlphabet.Add(alphabet[i]);

                if (j == (int)row - 1)
                {
                    for (var i = (int)row - 1; i < alphabet.Count; i += (int)row)
                        baseAlphabet.Add(alphabet[i]);
                    c = false;
                }
                j++;
            }

            var result = "";
            baseAlphabet.ForEach(x => result += x);
            return result.Replace("q"," ");
        }
    }
}
