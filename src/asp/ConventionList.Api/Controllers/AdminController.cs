using ConventionList.Api.Auth;
using ConventionList.Api.Models;
using ConventionList.Api.Queries;
using ConventionList.Core.Models;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ConventionList.Api.Controllers;

[Route("[controller]")]
[Authorize(Permissions.ManageAllConventions)]
[ApiController]
public class AdminController(IMediator mediator) : ControllerBase
{
    // admin/conventions
    [HttpGet("conventions")]
    public async Task<ActionResult<ConventionsResult>> GetConventions(
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 20,
        [FromQuery] SearchParams? searchParams = null
    )
    {
        var cons = await mediator.Send(new GetAdminConventionsQuery(page, pageSize, searchParams));

        return Ok(cons);
    }
}
