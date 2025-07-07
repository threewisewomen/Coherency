using Coherency.Application.DTOs;
using Coherency.Application.Services;
using Microsoft.AspNetCore.Mvc;
using System.Net;

namespace Coherency.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly IAuthService _authService;
    private readonly ILogger<AuthController> _logger;

    public AuthController(IAuthService authService, ILogger<AuthController> logger)
    {
        _authService = authService;
        _logger = logger;
    }

    [HttpPost("login")]
    public async Task<ActionResult<LoginResponseDto>> Login([FromBody] LoginRequestDto loginRequest)
    {
        try
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(new LoginResponseDto
                {
                    Success = false,
                    Message = "Invalid request data."
                });
            }

            var ipAddress = GetClientIpAddress();
            var userAgent = Request.Headers.UserAgent.ToString();

            var result = await _authService.LoginAsync(loginRequest, ipAddress, userAgent);

            if (result.Success)
            {
                return Ok(result);
            }

            return Unauthorized(result);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error in Login endpoint");
            return StatusCode(500, new LoginResponseDto
            {
                Success = false,
                Message = "An internal server error occurred."
            });
        }
    }

    [HttpPost("register")]
    public async Task<ActionResult<LoginResponseDto>> Register([FromBody] RegisterRequestDto registerRequest)
    {
        try
        {
            if (!ModelState.IsValid)
            {
                var errors = ModelState.Values
                    .SelectMany(v => v.Errors)
                    .Select(e => e.ErrorMessage)
                    .ToList();

                return BadRequest(new LoginResponseDto
                {
                    Success = false,
                    Message = string.Join("; ", errors)
                });
            }

            var result = await _authService.RegisterAsync(registerRequest);

            if (result.Success)
            {
                return CreatedAtAction(nameof(Register), result);
            }

            return BadRequest(result);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error in Register endpoint");
            return StatusCode(500, new LoginResponseDto
            {
                Success = false,
                Message = "An internal server error occurred."
            });
        }
    }

    private string? GetClientIpAddress()
    {
        // Check for forwarded IP first (in case of proxy/load balancer)
        var forwardedFor = Request.Headers["X-Forwarded-For"].FirstOrDefault();
        if (!string.IsNullOrEmpty(forwardedFor))
        {
            return forwardedFor.Split(',')[0].Trim();
        }

        var realIp = Request.Headers["X-Real-IP"].FirstOrDefault();
        if (!string.IsNullOrEmpty(realIp))
        {
            return realIp;
        }

        // Fallback to connection remote IP
        return Request.HttpContext.Connection.RemoteIpAddress?.ToString();
    }
}