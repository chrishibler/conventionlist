using ConventionList.Core.Interfaces;
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
        var repo = scope.ServiceProvider.GetRequiredService<IConventionRepository>();
        var consToGeocode = await repo.GetConventionsToGeocode();

        foreach (var con in consToGeocode)
        {
            logger.LogInformation("Geocoding {ConName}", con.Name);
            try
            {
                var position = await geocoder.Geocode(con);
                repo.Update(con, position);
                await repo.SaveChangesAsync();
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
