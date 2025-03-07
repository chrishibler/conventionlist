using AutoMapper;
using ConventionList.Core.Models;
using NetTopologySuite.Geometries;

namespace ConventionList.Infrastructure.Mapping;

public class PointTypeConverter : ITypeConverter<Point?, Geocoordinate?>
{
    public Geocoordinate? Convert(
        Point? source,
        Geocoordinate? destination,
        ResolutionContext context
    )
    {
        if (source is null)
        {
            return null;
        }
        return source.ToGeocoordinate();
    }
}
