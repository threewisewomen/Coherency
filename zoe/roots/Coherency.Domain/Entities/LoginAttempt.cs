using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Coherency.Domain.Entities
{
    public class LoginAttempt
    {
        public Guid Id { get; set; } = Guid.NewGuid();

        public Guid? UserId { get; set; }

        [Required]
        [MaxLength(255)]
        public string Email { get; set; } = string.Empty;

        public string? IpAddress { get; set; }
        public string? UserAgent { get; set; }

        [Required]
        public LoginAttemptResult AttemptResult { get; set; }

        [MaxLength(100)]
        public string? FailureReason { get; set; }

        public DateTime AttemptedAt { get; set; } = DateTime.UtcNow;

        // Navigation property
        public User? User { get; set; }
    }

}
