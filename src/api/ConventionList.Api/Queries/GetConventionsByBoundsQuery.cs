using AutoMapper;
using ConventionList.Api.Data;
using ConventionList.Api.Models.Api;
using MediatR;
using Microsoft.EntityFrameworkCore;
using NetTopologySuite;
using NetTopologySuite.Geometries;

namespace ConventionList.Api.Queries;

public record GetConventionsByBoundsQuery(Bounds Bounds, int Page = 1, int PageSize = 20)
    : IRequest<ConventionsResult>;

public class GetConventionsByBoundsHandler
    : IRequestHandler<GetConventionsByBoundsQuery, ConventionsResult>
{
    private readonly ConventionListDbContext db;
    private readonly IMapper mapper;

    public GetConventionsByBoundsHandler(ConventionListDbContext db, IMapper mapper)
    {
        this.db = db;
        this.mapper = mapper;
    }

    public async Task<ConventionsResult> Handle(
        GetConventionsByBoundsQuery request,
        CancellationToken cancellationToken
    )
    {
        var bounds = request.Bounds;
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
        int totalPages = (int)Math.Ceiling((double)totalCount / request.PageSize);

        var cons = await query
            .Skip((request.Page - 1) * request.PageSize)
            .Take(request.PageSize)
            .Select(c => mapper.Map<ApiConvention>(c))
            .ToListAsync(cancellationToken);
        return new ConventionsResult(totalCount, totalPages, request.Page, request.PageSize, cons);
    }
}
