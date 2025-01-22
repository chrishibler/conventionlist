using Ical.Net;

namespace ConventionList.Tests;

public class ConventionSceneScraperTest
{
    [Fact]
    public void CalendarLoadsEvents()
    {
        string filename = "./Assets/convention-icalendar.ics";
        using var icsStream = File.OpenRead(filename);
        var calendar = Calendar.Load(icsStream);
        Assert.NotEmpty(calendar.Events);
    }
}
