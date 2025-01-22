using Ardalis.Specification;
using AutoMapper;
using ConventionList.Core.Models;
using NetTopologySuite;
using NetTopologySuite.Geometries;

namespace ConventionList.Core.Specifications;

public class GetConventionsSpecification : Specification<Convention, ApiConvention>
{
    public GetConventionsSpecification(
        IMapper mapper,
        int page = 1,
        int pageSize = 20,
        double? lat = null,
        double? lon = null,
        SearchParams? searchParams = null
    )
    {
        searchParams?.ApplyFilter(Query);
        if (lat is not null && lon is not null && searchParams?.OrderBy == OrderBy.Distance)
        {
            var geoFactory = NtsGeometryServices.Instance.CreateGeometryFactory(srid: 4326);
            var location = geoFactory.CreatePoint(new Coordinate((double)lon!, (double)lat!));
            Query.OrderBy(c =>
                c.Position == null ? double.MaxValue : c.Position.Distance(location)
            );
        }
        else
        {
            Query.OrderBy(c => c.StartDate).ThenBy(c => c.Name);
        }

        Query
            .Where(c => c.StartDate >= DateTime.UtcNow.Date)
            .Skip((page - 1) * pageSize)
            .Take(pageSize);

        Query.Select(c => mapper.Map<ApiConvention>(c));
    }
}
