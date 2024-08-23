using ConventionList.Api.Models;

namespace ConventionList.Api.Extensions;

public static class PointExtensions
{
    public static Geocoordinate? ToGeocoordinate(this Convention con)
    {
        if (con.Position is null)
            return null;

        return new Geocoordinate(con.Position.Y, con.Position.X);
    }
}
