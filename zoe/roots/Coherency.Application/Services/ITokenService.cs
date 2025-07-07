using Coherency.Domain.Entities;
using System.Security.Claims;

namespace Coherency.Application.Services;

public class TokenResult
{
    public string Token { get; set; } = string.Empty;
    public DateTime ExpiresAt { get; set; }
}

public interface ITokenService
{
    TokenResult GenerateToken(User user);
    ClaimsPrincipal? ValidateToken(string token);
}