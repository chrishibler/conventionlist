using ConventionList.Core.Models;
using NetTopologySuite;
using NetTopologySuite.Geometries;

namespace ConventionList.Core.Mapping;

public class PointFactory
{
    private static readonly GeometryFactory GeoFactory =
        NtsGeometryServices.Instance.CreateGeometryFactory(srid: 4326);

    public static Point? CreatePoint(Geocoordinate? coord)
    {
        if (coord is null)
        {
            return null;
        }
        var location = GeoFactory.CreatePoint(new Coordinate(coord.Longitude, coord.Latitude));
        return location;
    }
}
