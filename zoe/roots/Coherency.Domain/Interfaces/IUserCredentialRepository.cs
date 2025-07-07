using Coherency.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Coherency.Domain.Interfaces
{
    public interface IUserCredentialRepository
    {
        Task<UserCredential?> GetByUserIdAsync(Guid userId);
        Task<UserCredential> CreateAsync(UserCredential credential);
        Task UpdateAsync(UserCredential credential);
        Task IncrementFailedAttemptsAsync(Guid userId);
        Task ResetFailedAttemptsAsync(Guid userId);
        Task LockAccountAsync(Guid userId, DateTime lockUntil);
    }

}
