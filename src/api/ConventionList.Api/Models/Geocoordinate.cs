using NetTopologySuite;
using NetTopologySuite.Geometries;

namespace ConventionList.Api.Models;

public readonly record struct Geocoordinate(double Latitude, double Longitude)
{
    private static readonly GeometryFactory GeoFactory = NtsGeometryServices.Instance.CreateGeometryFactory(srid: 4326);

    public Point ToPoint()
    {
        var location = GeoFactory.CreatePoint(new Coordinate(Longitude, Latitude));
        return location;
    }
}
