using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

namespace BusinessLayer
{
    public static class EncryptionHelper
    {
      
        private static readonly string SecretKey = "DeliveryERP_SecretKey_@2026#Db"; 
        private static readonly string SecretIV = "DeliveryERP_IV#1";           

        public static string Encrypt(string plainText)
        {
            if (string.IsNullOrEmpty(plainText)) return plainText;

            byte[] keyBytes = Encoding.UTF8.GetBytes(SecretKey);
            byte[] ivBytes = Encoding.UTF8.GetBytes(SecretIV);

            using (Aes aes = Aes.Create())
            {
                aes.Key = keyBytes;
                aes.IV = ivBytes;

                ICryptoTransform encryptor = aes.CreateEncryptor(aes.Key, aes.IV);

                using (MemoryStream ms = new MemoryStream())
                {
                    using (CryptoStream cs = new CryptoStream(ms, encryptor, CryptoStreamMode.Write))
                    {
                        using (StreamWriter sw = new StreamWriter(cs))
                        {
                            sw.Write(plainText);
                        }
                    }
                    return Convert.ToBase64String(ms.ToArray());
                }
            }
        }

        public static string Decrypt(string cipherText)
        {
            if (string.IsNullOrEmpty(cipherText)) return cipherText;

            byte[] keyBytes = Encoding.UTF8.GetBytes(SecretKey);
            byte[] ivBytes = Encoding.UTF8.GetBytes(SecretIV);

            using (Aes aes = Aes.Create())
            {
                aes.Key = keyBytes;
                aes.IV = ivBytes;

                ICryptoTransform decryptor = aes.CreateDecryptor(aes.Key, aes.IV);

                using (MemoryStream ms = new MemoryStream(Convert.FromBase64String(cipherText)))
                {
                    using (CryptoStream cs = new CryptoStream(ms, decryptor, CryptoStreamMode.Read))
                    {
                        using (StreamReader sr = new StreamReader(cs))
                        {
                            return sr.ReadToEnd();
                        }
                    }
                }
            }
        }
    }
}