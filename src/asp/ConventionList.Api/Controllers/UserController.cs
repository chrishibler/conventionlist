using ConventionList.Api.Auth;
using ConventionList.Api.Events;
using ConventionList.Api.Queries;
using ConventionList.Core.Models;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ConventionList.Api.Controllers;

[Route("[controller]")]
[ApiController]
public class UserController(IMediator mediator) : ControllerBase
{
    // users/conventions
    [HttpGet("conventions")]
    [Authorize(Permissions.ManageMyConventions)]
    public async Task<ActionResult<ConventionsResult>> GetConventions(
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 20,
        [FromQuery] SearchParams? searchParams = null
    )
    {
        var (Result, Conventions) = await mediator.Send(
            new GetUserConventionsQuery(HttpContext.User, page, pageSize, searchParams)
        );

        return Result switch
        {
            InvalidUserEvent => Forbid(),
            _ => Ok(Conventions),
        };
    }
}
