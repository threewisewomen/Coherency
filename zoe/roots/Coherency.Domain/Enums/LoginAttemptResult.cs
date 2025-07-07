using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Coherency.Domain.Entities
{
    public enum LoginAttemptResult
    {
        Success = 0,
        Failed = 1,
        Blocked = 2
    }

}
