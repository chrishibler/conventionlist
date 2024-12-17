using ConventionList.Api.Data;
using ConventionList.Api.Mapping;
using ConventionList.Api.Models;
using ConventionList.Domain.Models;

namespace ConventionList.Api.Services;

public class GeocodingService(
    IMapsSearchClient client,
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
                    var position = await Geocode(con);
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

    public async Task<Geocoordinate> Geocode(Convention con)
    {
        if (con.PostalCode == null && con.City == null)
            throw new InvalidOperationException("No location data.");

        var position = await client.SearchAddressAsync(
            $"{con.PostalCode} {con.City} {con.State} {con.Country}"
        );

        return new Geocoordinate(position.Latitude, position.Longitude);
    }
}
