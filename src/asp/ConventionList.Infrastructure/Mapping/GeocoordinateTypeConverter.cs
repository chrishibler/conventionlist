using AutoMapper;
using ConventionList.Core.Mapping;
using ConventionList.Core.Models;
using NetTopologySuite.Geometries;

namespace ConventionList.Infrastructure.Mapping;

public class GeocoordinateTypeConverter : ITypeConverter<Geocoordinate?, Point?>
{
    public Point? Convert(Geocoordinate? source, Point? destination, ResolutionContext context)
    {
        return PointFactory.CreatePoint(source);
    }
}
