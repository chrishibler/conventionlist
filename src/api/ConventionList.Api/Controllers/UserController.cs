using AutoMapper;
using ConventionList.Api.Auth;
using ConventionList.Api.Data;
using ConventionList.Api.Models.Api;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ConventionList.Api.Controllers;

[Route("[controller]")]
[ApiController]
public class UserController(
    ConventionListDbContext db,
    IMapper mapper,
    ILogger<UserController> logger
) : ControllerBase
{
    // users/conventions
    [HttpGet("conventions")]
    [Authorize("manage:myconventions")]
    public async Task<ActionResult<ConventionsResult>> GetConventions(
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 20,
        [FromQuery] SearchParams? searchParams = null
    )
    {
        string? userId = HttpContext.User.SubjectId();
        if (string.IsNullOrWhiteSpace(userId))
        {
            return Forbid();
        }

        var query = db.Conventions.AsQueryable();
        query = searchParams?.ApplyFilter(query) ?? query;
        query = query.Where(c => c.SubmitterId == HttpContext.User.SubjectId());
        query = query.OrderBy(c => c.StartDate).ThenBy(c => c.Name);

        int totalCount = query.Count();
        int totalPages = (int)Math.Ceiling((double)totalCount / pageSize);

        var cons = await query
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .Select(c => mapper.Map<ApiConvention>(c))
            .ToListAsync();
        return Ok(new ConventionsResult(totalCount, totalPages, page, pageSize, cons));
    }

    [HttpGet("{userId}/conventions")]
    [Authorize("manage:allconventions")]
    public async Task<ActionResult<ApiConvention>> Get(
        [FromRoute] string userId,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 20
    )
    {
        var query = db.Conventions.AsQueryable();
        query = query.Where(c => c.SubmitterId == userId);
        query = query.OrderBy(c => c.StartDate).ThenBy(c => c.Name);

        int totalCount = query.Count();
        int totalPages = (int)Math.Ceiling((double)totalCount / pageSize);

        var cons = await query
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .Select(c => mapper.Map<ApiConvention>(c))
            .ToListAsync();
        return Ok(new ConventionsResult(totalCount, totalPages, page, pageSize, cons));
    }
}
