using Coherency.Application.DTOs;
using Coherency.Domain.Entities;
using Coherency.Domain.Interfaces;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Configuration;

namespace Coherency.Application.Services;

public interface IAuthService
{
    Task<LoginResponseDto> LoginAsync(LoginRequestDto loginRequest, string? ipAddress = null, string? userAgent = null);
    Task<LoginResponseDto> RegisterAsync(RegisterRequestDto registerRequest);
}

public class AuthService : IAuthService
{
    private readonly IUserRepository _userRepository;
    private readonly IUserCredentialRepository _credentialRepository;
    private readonly ILoginAttemptRepository _loginAttemptRepository;
    private readonly IPasswordService _passwordService;
    private readonly ITokenService _tokenService;
    private readonly ILogger<AuthService> _logger;
    private readonly IConfiguration _configuration;

    // Account lockout settings
    private readonly int _maxFailedAttempts;
    private readonly TimeSpan _lockoutDuration;
    private readonly TimeSpan _failedAttemptWindow;

    public AuthService(
        IUserRepository userRepository,
        IUserCredentialRepository credentialRepository,
        ILoginAttemptRepository loginAttemptRepository,
        IPasswordService passwordService,
        ITokenService tokenService,
        ILogger<AuthService> logger,
        IConfiguration configuration)
    {
        _userRepository = userRepository;
        _credentialRepository = credentialRepository;
        _loginAttemptRepository = loginAttemptRepository;
        _passwordService = passwordService;
        _tokenService = tokenService;
        _logger = logger;
        _configuration = configuration;

        _maxFailedAttempts = _configuration.GetValue<int>("Security:MaxFailedAttempts", 5);
        _lockoutDuration = TimeSpan.FromMinutes(_configuration.GetValue<int>("Security:LockoutDurationMinutes", 30));
        _failedAttemptWindow = TimeSpan.FromMinutes(_configuration.GetValue<int>("Security:FailedAttemptWindowMinutes", 15));
    }

    public async Task<LoginResponseDto> LoginAsync(LoginRequestDto loginRequest, string? ipAddress = null, string? userAgent = null)
    {
        try
        {
            // Get user by email first to check specific user's failed attempts
            var user = await _userRepository.GetByEmailAsync(loginRequest.Email);

            if (user != null)
            {
                // Get user credentials to check account lock status and failed attempts
                var credential = await _credentialRepository.GetByUserIdAsync(user.Id);
                if (credential != null)
                {
                    // Check if account is locked
                    if (credential.AccountLockedUntil.HasValue && credential.AccountLockedUntil > DateTime.UtcNow)
                    {
                        await LogLoginAttemptAsync(user.Id, loginRequest.Email, LoginAttemptResult.Blocked,
                            "Account locked", ipAddress, userAgent);

                        return new LoginResponseDto
                        {
                            Success = false,
                            Message = $"Account is locked until {credential.AccountLockedUntil:yyyy-MM-dd HH:mm:ss} UTC."
                        };
                    }

                    // Check for too many recent failed attempts (using credential table)
                    if (credential.FailedLoginAttempts >= _maxFailedAttempts)
                    {
                        // Lock the account
                        var lockUntil = DateTime.UtcNow.Add(_lockoutDuration);
                        await _credentialRepository.LockAccountAsync(user.Id, lockUntil);

                        await LogLoginAttemptAsync(user.Id, loginRequest.Email, LoginAttemptResult.Blocked,
                            "Too many failed attempts - account locked", ipAddress, userAgent);

                        return new LoginResponseDto
                        {
                            Success = false,
                            Message = "Account temporarily locked due to too many failed attempts. Please try again later."
                        };
                    }
                }
            }

            // Continue with user validation
            if (user == null)
            {
                await LogLoginAttemptAsync(null, loginRequest.Email, LoginAttemptResult.Failed,
                    "User not found", ipAddress, userAgent);

                return new LoginResponseDto
                {
                    Success = false,
                    Message = "Invalid email or password."
                };
            }

            // Check if user is active
            if (!user.IsActive)
            {
                await LogLoginAttemptAsync(user.Id, loginRequest.Email, LoginAttemptResult.Failed,
                    "Account inactive", ipAddress, userAgent);

                return new LoginResponseDto
                {
                    Success = false,
                    Message = "Account is inactive. Please contact support."
                };
            }

            // Get user credentials (we already have it if user exists, but need to handle null case)
            var userCredential = await _credentialRepository.GetByUserIdAsync(user.Id);
            if (userCredential == null)
            {
                _logger.LogError("User {UserId} found but no credentials exist", user.Id);
                return new LoginResponseDto
                {
                    Success = false,
                    Message = "Authentication failed. Please contact support."
                };
            }

            // Verify password
            var isPasswordValid = _passwordService.VerifyPassword(
                loginRequest.Password, userCredential.PasswordSalt, userCredential.PasswordHash);

            if (!isPasswordValid)
            {
                // Increment failed attempts in credentials table
                await _credentialRepository.IncrementFailedAttemptsAsync(user.Id);

                await LogLoginAttemptAsync(user.Id, loginRequest.Email, LoginAttemptResult.Failed,
                    "Invalid password", ipAddress, userAgent);

                return new LoginResponseDto
                {
                    Success = false,
                    Message = "Invalid email or password."
                };
            }

            // Successful login - reset failed attempts and update last login
            await _credentialRepository.ResetFailedAttemptsAsync(user.Id);
            await _userRepository.UpdateLastLoginAsync(user.Id);

            var token = _tokenService.GenerateToken(user);

            await LogLoginAttemptAsync(user.Id, loginRequest.Email, LoginAttemptResult.Success,
                null, ipAddress, userAgent);

            return new LoginResponseDto
            {
                Success = true,
                Message = "Login successful.",
                Token = token.Token,
                ExpiresAt = token.ExpiresAt,
                User = new UserDto
                {
                    Id = user.Id,
                    Username = user.Username,
                    Email = user.Email,
                    FirstName = user.FirstName,
                    LastName = user.LastName,
                    IsActive = user.IsActive,
                    IsEmailVerified = user.IsEmailVerified,
                    LastLoginAt = DateTime.UtcNow
                }
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error during login for email {Email}", loginRequest.Email);
            return new LoginResponseDto
            {
                Success = false,
                Message = "An error occurred during login. Please try again."
            };
        }
    }

    public async Task<LoginResponseDto> RegisterAsync(RegisterRequestDto registerRequest)
    {
        try
        {
            // Check if email already exists
            if (await _userRepository.EmailExistsAsync(registerRequest.Email))
            {
                return new LoginResponseDto
                {
                    Success = false,
                    Message = "Email already exists."
                };
            }

            // Check if username already exists
            if (await _userRepository.UsernameExistsAsync(registerRequest.Username))
            {
                return new LoginResponseDto
                {
                    Success = false,
                    Message = "Username already exists."
                };
            }

            // Create user
            var user = new User
            {
                Username = registerRequest.Username,
                Email = registerRequest.Email.ToLowerInvariant(),
                FirstName = registerRequest.FirstName,
                LastName = registerRequest.LastName
            };

            var createdUser = await _userRepository.CreateAsync(user);

            // Create credentials
            var salt = _passwordService.GenerateSalt();
            var hash = _passwordService.HashPassword(registerRequest.Password, salt);

            var credential = new UserCredential
            {
                UserId = createdUser.Id,
                PasswordHash = hash,
                PasswordSalt = salt,
                HashAlgorithm = "Argon2id"
            };

            await _credentialRepository.CreateAsync(credential);

            _logger.LogInformation("New user registered: {Email}", registerRequest.Email);

            return new LoginResponseDto
            {
                Success = true,
                Message = "Registration successful. Please verify your email."
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error during registration for email {Email}", registerRequest.Email);
            return new LoginResponseDto
            {
                Success = false,
                Message = "An error occurred during registration. Please try again."
            };
        }
    }

    private async Task LogLoginAttemptAsync(Guid? userId, string email, LoginAttemptResult result,
        string? failureReason, string? ipAddress, string? userAgent)
    {
        var loginAttempt = new LoginAttempt
        {
            UserId = userId,
            Email = email,
            AttemptResult = result,
            FailureReason = failureReason,
            IpAddress = ipAddress,
            UserAgent = userAgent
        };

        await _loginAttemptRepository.CreateAsync(loginAttempt);
    }
}