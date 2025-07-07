using Coherency.Domain.Entities;
using Coherency.Domain.Interfaces;
using Coherency.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace Coherency.Infrastructure.Repositories;

public class UserCredentialRepository : IUserCredentialRepository
{
    private readonly ApplicationDbContext _context;

    public UserCredentialRepository(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<UserCredential?> GetByUserIdAsync(Guid userId)
    {
        return await _context.UserCredentials
            .FirstOrDefaultAsync(uc => uc.UserId == userId);
    }

    public async Task<UserCredential> CreateAsync(UserCredential credential)
    {
        _context.UserCredentials.Add(credential);
        await _context.SaveChangesAsync();
        return credential;
    }

    public async Task UpdateAsync(UserCredential credential)
    {
        credential.UpdatedAt = DateTime.UtcNow;
        _context.UserCredentials.Update(credential);
        await _context.SaveChangesAsync();
    }

    public async Task IncrementFailedAttemptsAsync(Guid userId)
    {
        var credential = await _context.UserCredentials
            .FirstOrDefaultAsync(uc => uc.UserId == userId);

        if (credential != null)
        {
            credential.FailedLoginAttempts++;
            credential.UpdatedAt = DateTime.UtcNow;
            await _context.SaveChangesAsync();
        }
    }

    public async Task ResetFailedAttemptsAsync(Guid userId)
    {
        var credential = await _context.UserCredentials
            .FirstOrDefaultAsync(uc => uc.UserId == userId);

        if (credential != null)
        {
            credential.FailedLoginAttempts = 0;
            credential.AccountLockedUntil = null;
            credential.UpdatedAt = DateTime.UtcNow;
            await _context.SaveChangesAsync();
        }
    }

    public async Task LockAccountAsync(Guid userId, DateTime lockUntil)
    {
        var credential = await _context.UserCredentials
            .FirstOrDefaultAsync(uc => uc.UserId == userId);

        if (credential != null)
        {
            credential.AccountLockedUntil = lockUntil;
            credential.UpdatedAt = DateTime.UtcNow;
            await _context.SaveChangesAsync();
        }
    }
}