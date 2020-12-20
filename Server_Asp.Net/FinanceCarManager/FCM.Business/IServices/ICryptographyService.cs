namespace FCM.Business.IServices
{
    public interface ICryptographyService
    {
        string EncryptString(string str);

        string DecryptString(string str);
    }
}
