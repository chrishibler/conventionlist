using AutoMapper;
using ConventionList.Api.Mapping;
using ConventionList.Api.Models;
using ConventionList.Api.Models.Api;
using ConventionList.Api.Services;
using Microsoft.EntityFrameworkCore;
using NetTopologySuite;
using NetTopologySuite.Geometries;

namespace ConventionList.Api.Data;

public class ConventionRepository(
    ConventionListDbContext db,
    IMapper mapper,
    GeocodingService geocoder,
    ILogger<ConventionRepository> log
) : IConventionRepository
{
    public async Task<ConventionsResult> GetAdminConventions(
        SearchParams? searchParams,
        int page,
        int pageSize,
        CancellationToken cancellationToken
    )
    {
        var query = db.Conventions.AsQueryable();
        query = searchParams?.ApplyFilter(query) ?? query;
        query = query.OrderByDescending(c => c.StartDate).ThenBy(c => c.Name);

        int totalCount = query.Count();
        int totalPages = (int)Math.Ceiling((double)totalCount / pageSize);

        var cons = await query
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .Select(c => mapper.Map<ApiConvention>(c))
            .ToListAsync(cancellationToken);

        return new ConventionsResult(totalCount, totalPages, page, pageSize, cons);
    }

    public async Task<ApiConvention?> GetConvention(Guid id, CancellationToken cancellationToken)
    {
        var convention = await db.Conventions.FindAsync(id, cancellationToken);
        if (convention is null)
        {
            return null;
        }
        return mapper.Map<ApiConvention>(convention);
    }

    public async Task<ConventionsResult> GetConventionsByBounds(
        Bounds bounds,
        int page,
        int pageSize,
        CancellationToken cancellationToken
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
            .ToListAsync(cancellationToken);
        return new ConventionsResult(totalCount, totalPages, page, pageSize, cons);
    }

    public async Task<ConventionsResult> GetConventions(
        SearchParams? searchParams,
        double? lon,
        double? lat,
        int page,
        int pageSize,
        CancellationToken cancellationToken
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
            .ToListAsync(cancellationToken);
        return new ConventionsResult(totalCount, totalPages, page, pageSize, cons);
    }

    public async Task<string?> GetSubmitterId(Guid conventionId)
    {
        var convention = await db.Conventions.FindAsync(conventionId, CancellationToken.None);
        return convention?.SubmitterId;
    }

    public Task<List<ApiConvention>> GetUserConventions(
        SearchParams? searchParams,
        string userId,
        int pageSize,
        int page,
        CancellationToken cancellationToken
    )
    {
        var query = db.Conventions.AsQueryable();
        query = searchParams?.ApplyFilter(query) ?? query;
        query = query.Where(c => c.SubmitterId == userId);
        query = query.OrderBy(c => c.StartDate).ThenBy(c => c.Name);

        return query
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .Select(c => mapper.Map<ApiConvention>(c))
            .ToListAsync(cancellationToken);
    }

    public async Task<ApiConvention> AddConvention(
        NewApiConvention newCon,
        string userId,
        CancellationToken cancellationToken
    )
    {
        var con = mapper.Map<Convention>(newCon);
        con.Id = Guid.NewGuid();
        con.Editor = userId;
        con.SubmitterId = userId;
        try
        {
            var position = await geocoder.Geocode(con);
            con.Position = GeocoordinateTypeConverter.ToPoint(position);
        }
        catch (Exception ex)
        {
            log.LogError(ex, "Could not geocode con {ConName}", con.Name);
        }
        _ = db.Conventions.Add(con);
        _ = await db.SaveChangesAsync(cancellationToken);
        var apiConvention = mapper.Map<ApiConvention>(con);
        return apiConvention;
    }

    public async Task DeleteConvention(Guid id, CancellationToken cancellationToken)
    {
        Convention? con = await db.Conventions.FindAsync(id, cancellationToken);
        if (con is null)
        {
            throw new InvalidOperationException($"Convention {id} not found");
        }
        db.Remove(con);
        await db.SaveChangesAsync(cancellationToken);
    }

    public async Task UpdateConvention(
        ApiConvention apiConvention,
        string editorUserId,
        CancellationToken cancellationToken
    )
    {
        Convention? existingCon =
            await db.Conventions.FindAsync(apiConvention.Id, cancellationToken)
            ?? throw new InvalidOperationException($"Convention {apiConvention.Id} not found");
        mapper.Map(apiConvention, existingCon);
        existingCon.Editor = editorUserId;
        db.SaveChanges();
    }
}
