using AutoMapper;
using ConventionList.Api.Models;
using NetTopologySuite;
using NetTopologySuite.Geometries;

namespace ConventionList.Api.Mapping;

public class GeocoordinateTypeConverter : ITypeConverter<Geocoordinate?, Point?>
{
    private static readonly GeometryFactory GeoFactory =
        NtsGeometryServices.Instance.CreateGeometryFactory(srid: 4326);

    public static Point? ToPoint(Geocoordinate? coord)
    {
        if (coord is null)
        {
            return null;
        }
        var location = GeoFactory.CreatePoint(new Coordinate(coord.Longitude, coord.Latitude));
        return location;
    }

    public Point? Convert(Geocoordinate? source, Point? destination, ResolutionContext context)
    {
        return ToPoint(source);
    }
}
