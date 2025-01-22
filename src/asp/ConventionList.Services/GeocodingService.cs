using ConventionList.Core.Interfaces;
using ConventionList.Core.Mapping;
using ConventionList.Core.Models;
using ConventionList.Core.Specifications;
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
        var repo = scope.ServiceProvider.GetRequiredService<IRepository<Convention>>();
        var spec = new GetConventionsToGeocodeSpecification();
        var consToGeocode = await repo.ListAsync(spec);

        foreach (var con in consToGeocode)
        {
            logger.LogInformation("Geocoding {ConName}", con.Name);
            try
            {
                var position = await geocoder.Geocode(con);
                con.Position = PointFactory.CreatePoint(position);
                await repo.UpdateAsync(con);
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
