using AutoMapper;
using ConventionList.Api.Data;
using ConventionList.Api.Models;
using ConventionList.Api.Models.Api;
using MediatR;
using Microsoft.EntityFrameworkCore;
using NetTopologySuite;
using NetTopologySuite.Geometries;

namespace ConventionList.Api.Queries;

public record GetConventionsQuery(
    int Page = 1,
    int PageSize = 20,
    double? Lat = null,
    double? Lon = null,
    SearchParams? SearchParams = null
) : IRequest<ConventionsResult>;

public class GetConventionsHandler(ConventionListDbContext db, IMapper mapper)
    : IRequestHandler<GetConventionsQuery, ConventionsResult>
{
    public async Task<ConventionsResult> Handle(
        GetConventionsQuery request,
        CancellationToken cancellationToken
    )
    {
        var query = db.Conventions.AsQueryable();
        query = request.SearchParams?.ApplyFilter(query) ?? query;

        if (
            request.Lat is not null
            && request.Lon is not null
            && request.SearchParams?.OrderBy == OrderBy.Distance
        )
        {
            var geoFactory = NtsGeometryServices.Instance.CreateGeometryFactory(srid: 4326);
            var location = geoFactory.CreatePoint(
                new Coordinate((double)request.Lon!, (double)request.Lat!)
            );
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
        int totalPages = (int)Math.Ceiling((double)totalCount / request.PageSize);

        var cons = await query
            .Skip((request.Page - 1) * request.PageSize)
            .Take(request.PageSize)
            .Select(c => mapper.Map<ApiConvention>(c))
            .ToListAsync(cancellationToken);
        return new ConventionsResult(totalCount, totalPages, request.Page, request.PageSize, cons);
    }
}
