using System.Security.Cryptography;
using System.Text;
using Konscious.Security.Cryptography;
namespace Coherency.Application.Services;


public interface IPasswordService
{
    string GenerateSalt();
    string HashPassword(string password, string salt);
    bool VerifyPassword(string password, string salt, string hash);
}


public class PasswordService : IPasswordService
{
    private const int SaltSize = 32; // 256 bits
    private const int HashSize = 32; // 256 bits
    private const int Iterations = 4;
    private const int MemorySize = 1024 * 64; // 64 MB
    private const int DegreeOfParallelism = 8;

    public string GenerateSalt()
    {
        var salt = new byte[SaltSize];
        using var rng = RandomNumberGenerator.Create();
        rng.GetBytes(salt);
        return Convert.ToBase64String(salt);
    }

    public string HashPassword(string password, string salt)
    {
        var saltBytes = Convert.FromBase64String(salt);
        var passwordBytes = Encoding.UTF8.GetBytes(password);

        using var argon2 = new Argon2id(passwordBytes)
        {
            Salt = saltBytes,
            DegreeOfParallelism = DegreeOfParallelism,
            Iterations = Iterations,
            MemorySize = MemorySize
        };

        var hash = argon2.GetBytes(HashSize);
        return Convert.ToBase64String(hash);
    }

    public bool VerifyPassword(string password, string salt, string hash)
    {
        var computedHash = HashPassword(password, salt);
        return computedHash == hash;
    }
}
