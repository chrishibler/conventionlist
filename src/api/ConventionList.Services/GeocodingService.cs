using ConventionList.Repository;
using ConventionList.Repository.Mapping;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;

namespace ConventionList.Services;

public class GeocodingService(
    IGeocoder geocoder,
    ILogger<GeocodingService> logger,
    IServiceScopeFactory scopeFactory
) : HostedService
{
    public override Task StartAsync(CancellationToken cancellationToken)
    {
        logger.LogInformation("GeocodingService running");
        Timer = new Timer(DoWork, null, TimeSpan.FromSeconds(30), TimeSpan.FromDays(1));
        return Task.CompletedTask;
    }

    private async void DoWork(object? state)
    {
        try
        {
            using var scope = scopeFactory.CreateScope();
            var db = scope.ServiceProvider.GetRequiredService<ConventionListDbContext>();
            var consToGeocode = db.Conventions.Where(c => c.Position == null).ToList();

            foreach (var con in consToGeocode)
            {
                logger.LogInformation("Geocoding {ConName}", con.Name);
                try
                {
                    var position = await geocoder.Geocode(con);
                    con.Position = GeocoordinateTypeConverter.ToPoint(position);
                    await db.SaveChangesAsync();
                }
                catch (Exception ex)
                {
                    logger.LogError(ex, "Error geocoding {ConName}.", con.Name);
                }
            }
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Exception loading cons to geocode.");
        }
    }

    public override Task StopAsync(CancellationToken cancellationToken)
    {
        logger.LogInformation("CalendarSync service is stopping");
        Timer?.Change(Timeout.Infinite, 0);
        return Task.CompletedTask;
    }
}
