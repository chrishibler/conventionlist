using ConventionList.Api.Auth;
using ConventionList.Api.Commands;
using ConventionList.Api.Events;
using ConventionList.Api.Queries;
using ConventionList.Core.Models;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ConventionList.Api.Controllers;

[Route("[controller]")]
[ApiController]
public class ConventionsController(IMediator mediator) : ControllerBase
{
    // Conventions
    [HttpGet]
    [AllowAnonymous]
    public async Task<ActionResult<ConventionsResult>> GetConventions(
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 20,
        [FromQuery] double? lat = null,
        [FromQuery] double? lon = null,
        [FromQuery] SearchParams? searchParams = null
    )
    {
        ConventionsResult cons = await mediator.Send(
            new GetConventionsQuery(page, pageSize, lat, lon, searchParams)
        );

        return Ok(cons);
    }

    // GET: conventions/bounds
    [HttpGet("bounds")]
    [AllowAnonymous]
    public async Task<ActionResult<ConventionsResult>> GetConventionsByBounds(
        [FromQuery] Bounds bounds,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 20
    )
    {
        var cons = await mediator.Send(new GetConventionsByBoundsQuery(bounds, page, pageSize));

        return Ok(cons);
    }

    // conventions/key
    [HttpGet("{id}")]
    public async Task<ActionResult<ApiConvention>> Get([FromRoute] Guid id)
    {
        var (Result, Convention) = await mediator.Send(new GetConventionQuery(id));

        if (Result is ConventionNotFoundEvent)
        {
            return NotFound();
        }

        return Ok(Convention);
    }

    [HttpPost]
    [Authorize(Permissions.ManageMyConventions)]
    public async Task<ActionResult<ApiConvention>> Post([FromBody] NewApiConvention newCon)
    {
        string? userId = HttpContext.User.SubjectId();
        if (userId is null)
            return Unauthorized("No user ID found");

        ApiConvention apiConvention = await mediator.Send(new AddConventionCommand(newCon, userId));

        return Created($"~conventions/{apiConvention.Id}", apiConvention);
    }

    [Authorize(Permissions.ManageMyConventions)]
    [HttpPut("{id}")]
    public async Task<ActionResult> Put([FromRoute] Guid id, [FromBody] ApiConvention updatedCon)
    {
        var result = await mediator.Send(
            new UpdateConventionCommand(id, updatedCon, HttpContext.User)
        );

        return result switch
        {
            ConventionNotFoundEvent => NotFound(),
            InvalidUserEvent => Forbid("User did not submit this convention"),
            _ => NoContent(),
        };
    }

    [Authorize(Permissions.ManageMyConventions)]
    [HttpDelete("{id}")]
    public async Task<ActionResult> Delete([FromRoute] Guid id)
    {
        var result = await mediator.Send(new DeleteConventionCommand(id, HttpContext.User));

        return result switch
        {
            ConventionNotFoundEvent => NotFound(),
            InvalidUserEvent => Forbid("User did not submit this convention"),
            _ => NoContent(),
        };
    }
}
