using ConventionList.Core.Models;
using NetTopologySuite.Geometries;

namespace ConventionList.Infrastructure.Mapping;

static class PointExtensions
{
    public static Geocoordinate? ToGeocoordinate(this Point? point)
    {
        if (point is null)
            return null;

        return new Geocoordinate(point.Y, point.X);
    }
}
