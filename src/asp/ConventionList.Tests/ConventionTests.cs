using ConventionList.Api.Extensions;
using ConventionList.Core.Models;
using NetTopologySuite;
using NetTopologySuite.Geometries;

namespace ConventionList.Tests;

public class ConventionTest
{
    [Fact]
    public void ConventionsReturnedInDistanceOrder()
    {
        var geoFactory = NtsGeometryServices.Instance.CreateGeometryFactory(srid: 4326);
        var fresnoLocation = geoFactory.CreatePoint(new Coordinate(-119.7539328, 36.8508928));

        var columbusOhioLocation = geoFactory.CreatePoint(new Coordinate(-82.97168, 40.08134));

        var sanJoseLocation = geoFactory.CreatePoint(new Coordinate(-121.89108, 37.33418));
        Convention columbusCon = new()
        {
            Name = "Columbus Ohio Con",
            City = "Columbus",
            State = "OH",
            VenueName = "American Legion",
            Position = columbusOhioLocation
        };

        Convention sanJoseCon = new()
        {
            Name = "San Jose Con",
            City = "San Jose",
            State = "CA",
            VenueName = "Convention Center",
            Position = sanJoseLocation
        };
        double sanJoseDistance = sanJoseCon.Distance(fresnoLocation);
        double columbusDistance = columbusCon.Distance(fresnoLocation);

        Assert.True(columbusDistance > sanJoseDistance);
    }
}
