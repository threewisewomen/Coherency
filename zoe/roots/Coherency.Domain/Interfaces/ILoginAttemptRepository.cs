using Coherency.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Coherency.Domain.Interfaces
{
    public interface ILoginAttemptRepository
    {
        Task<LoginAttempt> CreateAsync(LoginAttempt loginAttempt);
        Task<int> GetRecentFailedAttemptsCountAsync(string email, TimeSpan timeWindow);
    }
}
