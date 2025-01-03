using ConventionList.Domain.Models;
using NetTopologySuite.Geometries;

namespace ConventionList.Api.Extensions;

public static class ConventionExtensions
{
    public static double Distance(this Convention con, Point location)
    {
        if (con.Position == null)
            return double.MaxValue;
        return con.Position?.Distance(location) ?? double.MaxValue;
    }
}
