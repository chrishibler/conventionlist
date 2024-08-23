using AutoMapper;
using Azure;
using Azure.Maps.Search;
using ConventionList.Api.Services;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.Identity.Web;

namespace ConventionList.Api.Extensions;

public static class ServiceCollectionExtensions
{
    private const string GoogleMapsApiKey = "GoogleMaps:ApiKey";

    public static void AddGeocodingService(this IServiceCollection services)
    {
        services.AddSingleton<GeocodingService>();
        services.AddHostedService((serviceProvider) =>
        {
            GeocodingService service = new(
                serviceProvider.GetRequiredService<IMapsSearchClient>(),
                serviceProvider.GetRequiredService<ILogger<GeocodingService>>(),
                serviceProvider.GetRequiredService<IServiceScopeFactory>()
            );
            return service;
        });
    }

    public static void AddConventionSceneSync(this IServiceCollection services)
    {
        services.AddHostedService((serviceProvider) =>
        {
            ConventinSceneCalendarSync service = new(serviceProvider.GetRequiredService<ILogger<ConventinSceneCalendarSync>>(),
                                                     serviceProvider.GetRequiredService<IServiceScopeFactory>(),
                                                     serviceProvider.GetRequiredService<IHttpClientFactory>(),
                                                     serviceProvider.GetRequiredService<IMapper>(),
                                                     serviceProvider.GetRequiredService<GeocodingService>());
            return service;
        });
    }

    public static void AddFanConsSync(this IServiceCollection services)
    {
        services.AddHostedService((serviceProvider) =>
        {
            FanConsSync service = new(serviceProvider.GetRequiredService<ILogger<FanConsSync>>(),
                                      serviceProvider.GetRequiredService<IServiceScopeFactory>(),
                                      serviceProvider.GetRequiredService<IMapper>(),
                                      serviceProvider.GetRequiredService<GeocodingService>());
            return service;
        });
    }

    public static void AddGoogleMapsSearchClient(this IServiceCollection services, WebApplicationBuilder builder)
    {
        string? key = builder.Configuration[GoogleMapsApiKey];
        if (key is null or "")
        {
            throw new InvalidOperationException("No Google maps subscription key found.");
        }

        GoogleMapsSearchClient clClient = new(key);
        services.AddSingleton<IMapsSearchClient>(clClient);
    }
}
