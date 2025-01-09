using Ardalis.Specification;
using AutoMapper;
using ConventionList.Core.Models;
using NetTopologySuite;
using NetTopologySuite.Geometries;

namespace ConventionList.Core.Specifications;

public class GetConventionsByBoundsSpecification : Specification<Convention, ApiConvention>
{
    public GetConventionsByBoundsSpecification(
        Bounds bounds,
        int page,
        int pageSize,
        IMapper mapper
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

        var geoFactory = NtsGeometryServices.Instance.CreateGeometryFactory(srid: 4326);
        var polygon = geoFactory.CreatePolygon(points).Normalized().Reverse();
        Query.Where(c => c.Position!.Within(polygon)).Skip((page - 1) * pageSize).Take(pageSize);
        Query.Select(c => mapper.Map<ApiConvention>(c));
    }
}
