using ConventionList.Api.Models;
using NetTopologySuite.Geometries;

namespace ConventionList.Api.Extensions;

public static class PointExtensions
{
    public static Geocoordinate? ToGeocoordinate(this Point? point)
    {
        if (point is null)
            return null;

        return new Geocoordinate(point.Y, point.X);
    }

    public static Point? ToPoint(this Geocoordinate? coord)
    {
        if (!coord.HasValue)
            return null;

        Coordinate c = new(coord.Value!.Longitude, coord.Value!.Latitude);
        return new Point(c);
    }
}
