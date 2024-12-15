using AutoMapper;
using ConventionList.Api.Extensions;
using ConventionList.Api.Models;
using NetTopologySuite.Geometries;

namespace ConventionList.Api.Mapping;

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
