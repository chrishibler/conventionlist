using AutoMapper;
using ConventionList.Api.Auth;
using ConventionList.Api.Data;
using ConventionList.Api.Models;
using ConventionList.Api.Models.Api;
using ConventionList.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using NetTopologySuite;
using NetTopologySuite.Geometries;

namespace ConventionList.Api.Controllers;

[Route("[controller]")]
[ApiController]
public class ConventionsController(
    ConventionListDbContext db,
    IMapper mapper,
    ILogger<ConventionsController> log,
    GeocodingService geocoder
) : ControllerBase
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
        var query = db.Conventions.AsQueryable();
        query = searchParams?.ApplyFilter(query) ?? query;

        if (lat is not null && lon is not null && searchParams?.OrderBy == OrderBy.Distance)
        {
            var geoFactory = NtsGeometryServices.Instance.CreateGeometryFactory(srid: 4326);
            var location = geoFactory.CreatePoint(new Coordinate((double)lon!, (double)lat!));
            query = query.OrderBy(c =>
                c.Position == null ? double.MaxValue : c.Position.Distance(location)
            );
        }
        else
        {
            query = query.OrderBy(c => c.StartDate).ThenBy(c => c.Name);
        }

        query = query.Where(c => c.StartDate >= DateTime.UtcNow.Date);
        int totalCount = query.Count();
        int totalPages = (int)Math.Ceiling((double)totalCount / pageSize);

        var cons = await query
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .Select(c => mapper.Map<ApiConvention>(c))
            .ToListAsync();
        return Ok(new ConventionsResult(totalCount, totalPages, page, pageSize, cons));
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
        var points = new[]
        {
            new Coordinate(bounds.West, bounds.North), // TR
            new Coordinate(bounds.West, bounds.South), // BR
            new Coordinate(bounds.East, bounds.South), // BL
            new Coordinate(bounds.East, bounds.North), // TL
            new Coordinate(bounds.West, bounds.North), // TR
        };

        var query = db.Conventions.AsQueryable();
        var geoFactory = NtsGeometryServices.Instance.CreateGeometryFactory(srid: 4326);
        var polygon = geoFactory.CreatePolygon(points).Normalized().Reverse();
        query = query.Where(c => c.Position!.Within(polygon));

        int totalCount = query.Count();
        int totalPages = (int)Math.Ceiling((double)totalCount / pageSize);

        var cons = await query
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .Select(c => mapper.Map<ApiConvention>(c))
            .ToListAsync();
        return Ok(new ConventionsResult(totalCount, totalPages, page, pageSize, cons));
    }

    // conventions/key
    [HttpGet("{id}")]
    public async Task<ActionResult<ApiConvention>> Get([FromRoute] Guid id)
    {
        var convention = await db.Conventions.FindAsync(id);
        if (convention == null)
        {
            return NotFound();
        }

        return Ok(mapper.Map<ApiConvention>(convention));
    }

    [HttpPost]
    [Authorize("manage:myconventions")]
    public async Task<ActionResult<ApiConvention>> Post([FromBody] NewApiConvention newCon)
    {
        string? userId = HttpContext.User.SubjectId();
        if (userId is null)
            return Unauthorized("No user ID found");

        var con = mapper.Map<Convention>(newCon);
        con.Id = Guid.NewGuid();
        con.Editor = userId;
        con.SubmitterId = userId;
        await GeocodeCon(con);
        _ = db.Conventions.Add(con);
        try
        {
            _ = await db.SaveChangesAsync();
        }
        catch (Exception ex)
        {
            log.LogError("Error saving convention", ex);
        }
        var apiConvention = mapper.Map<ApiConvention>(con);

        return Created($"~conventions/{con.Id}", apiConvention);
    }

    [Authorize("manage:myconventions")]
    [HttpPut("{id}")]
    public async Task<ActionResult> Put([FromRoute] Guid id, [FromBody] Convention updatedCon)
    {
        var existingCon = await db.Conventions.SingleOrDefaultAsync(d => d.Id == id);
        if (existingCon == null)
        {
            return NotFound();
        }

        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        var user = HttpContext.User;
        if (!user.IsSubmitterOrAdmin(existingCon))
        {
            return Forbid("User did not submit this convention.");
        }

        try
        {
            mapper.Map(updatedCon, existingCon);
            existingCon.Editor = user.SubjectId()!;
            db.SaveChanges();
        }
        catch (Exception ex)
        {
            log.LogError("Error updating convention", ex);
        }

        return NoContent();
    }

    [Authorize("manage:myconventions")]
    [HttpDelete("{id}")]
    public async Task<ActionResult> Delete([FromRoute] Guid id)
    {
        var existingCon = await db.Conventions.SingleOrDefaultAsync(d => d.Id == id);
        if (existingCon == null)
        {
            return NotFound();
        }

        if (!HttpContext.User.IsSubmitterOrAdmin(existingCon))
        {
            return Forbid("User did not submit this convention.");
        }

        _ = db.Conventions.Remove(existingCon);
        try
        {
            _ = await db.SaveChangesAsync();
        }
        catch (Exception ex)
        {
            log.LogError("Error deleting convention", ex);
        }

        db.SaveChanges();
        return NoContent();
    }

    private async Task GeocodeCon(Convention con)
    {
        try
        {
            var position = await geocoder.Geocode(con);
            con.Position = position.ToPoint();
        }
        catch (Exception ex)
        {
            log.LogError(ex, "Could not geocode con {ConName}", con.Name);
        }
    }
}
