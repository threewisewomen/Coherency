using Coherency.Domain.Entities;
using Coherency.Domain.Interfaces;
using Coherency.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace Coherency.Infrastructure.Repositories;

public class LoginAttemptRepository : ILoginAttemptRepository
{
    private readonly ApplicationDbContext _context;

    public LoginAttemptRepository(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<LoginAttempt> CreateAsync(LoginAttempt loginAttempt)
    {
        _context.LoginAttempts.Add(loginAttempt);
        await _context.SaveChangesAsync();
        return loginAttempt;
    }

    // This method can be used for analyzing patterns across all users
    public async Task<int> GetRecentFailedAttemptsCountAsync(string email, TimeSpan timeWindow)
    {
        var cutoffTime = DateTime.UtcNow.Subtract(timeWindow);
        return await _context.LoginAttempts
            .Where(la => la.Email.ToLower() == email.ToLower()
                      && la.AttemptResult == LoginAttemptResult.Failed
                      && la.AttemptedAt >= cutoffTime)
            .CountAsync();
    }

    // Additional method for getting recent attempts by user ID
    public async Task<int> GetRecentFailedAttemptsCountByUserIdAsync(Guid userId, TimeSpan timeWindow)
    {
        var cutoffTime = DateTime.UtcNow.Subtract(timeWindow);
        return await _context.LoginAttempts
            .Where(la => la.UserId == userId
                      && la.AttemptResult == LoginAttemptResult.Failed
                      && la.AttemptedAt >= cutoffTime)
            .CountAsync();
    }

    // Get all login attempts for a user (for admin/security analysis)
    public async Task<List<LoginAttempt>> GetUserLoginHistoryAsync(Guid userId, int limit = 50)
    {
        return await _context.LoginAttempts
            .Where(la => la.UserId == userId)
            .OrderByDescending(la => la.AttemptedAt)
            .Take(limit)
            .ToListAsync();
    }

    // Get recent suspicious activity (multiple failed attempts from different IPs)
    public async Task<List<LoginAttempt>> GetSuspiciousActivityAsync(string email, TimeSpan timeWindow)
    {
        var cutoffTime = DateTime.UtcNow.Subtract(timeWindow);
        return await _context.LoginAttempts
            .Where(la => la.Email.ToLower() == email.ToLower()
                      && la.AttemptResult == LoginAttemptResult.Failed
                      && la.AttemptedAt >= cutoffTime)
            .OrderByDescending(la => la.AttemptedAt)
            .ToListAsync();
    }
}