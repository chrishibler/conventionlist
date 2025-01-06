using ConventionList.Repository;
using ConventionList.Repository.Mapping;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;

namespace ConventionList.Services;

public class GeocodingService(
    IGeocoder geocoder,
    ILogger<GeocodingService> logger,
    IServiceScopeFactory scopeFactory
) : HostedService(TimeSpan.FromSeconds(30), TimeSpan.FromDays(1))
{
    public override Task StartAsync(CancellationToken cancellationToken)
    {
        logger.LogInformation($"{nameof(GeocodingService)} running");
        return base.StartAsync(cancellationToken);
    }

    protected override async Task DoWork(object? state)
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

    public override Task StopAsync(CancellationToken cancellationToken)
    {
        logger.LogInformation($"{nameof(GeocodingService)} service is stopping");
        return base.StopAsync(cancellationToken);
    }
}
