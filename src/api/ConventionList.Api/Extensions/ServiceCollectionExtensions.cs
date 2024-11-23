using AutoMapper;
using ConventionList.Api.Services;

namespace ConventionList.Api.Extensions;

public static class ServiceCollectionExtensions
{
    private const string GoogleMapsApiKey = "GoogleMaps:ApiKey";

    public static IServiceCollection AddGeocodingService(this IServiceCollection services)
    {
        services.AddSingleton<GeocodingService>();
        services.AddHostedService(
            (serviceProvider) =>
            {
                GeocodingService service =
                    new(
                        serviceProvider.GetRequiredService<IMapsSearchClient>(),
                        serviceProvider.GetRequiredService<ILogger<GeocodingService>>(),
                        serviceProvider.GetRequiredService<IServiceScopeFactory>()
                    );
                return service;
            }
        );
        return services;
    }

    public static IServiceCollection AddConventionSceneSync(this IServiceCollection services)
    {
        services.AddHostedService(
            (serviceProvider) =>
            {
                ConventinSceneCalendarSync service =
                    new(
                        serviceProvider.GetRequiredService<ILogger<ConventinSceneCalendarSync>>(),
                        serviceProvider.GetRequiredService<IServiceScopeFactory>(),
                        serviceProvider.GetRequiredService<IHttpClientFactory>(),
                        serviceProvider.GetRequiredService<IMapper>(),
                        serviceProvider.GetRequiredService<GeocodingService>()
                    );
                return service;
            }
        );
        return services;
    }

    public static IServiceCollection AddFanConsSync(this IServiceCollection services)
    {
        services.AddHostedService(
            (serviceProvider) =>
            {
                FanConsSync service =
                    new(
                        serviceProvider.GetRequiredService<ILogger<FanConsSync>>(),
                        serviceProvider.GetRequiredService<IServiceScopeFactory>(),
                        serviceProvider.GetRequiredService<IMapper>(),
                        serviceProvider.GetRequiredService<GeocodingService>()
                    );
                return service;
            }
        );
        return services;
    }

    public static IServiceCollection AddGoogleMapsSearchClient(
        this IServiceCollection services,
        WebApplicationBuilder builder
    )
    {
        string? key = builder.Configuration[GoogleMapsApiKey];
        if (key is null or "")
        {
            throw new InvalidOperationException("No Google maps subscription key found.");
        }

        GoogleMapsSearchClient clClient = new(key);
        services.AddSingleton<IMapsSearchClient>(clClient);
        return services;
    }

    public static IServiceCollection AddHtmlFixService(this IServiceCollection services)
    {
        services.AddHostedService<HtmlFixService>(
            (factory) =>
                new HtmlFixService(
                    factory.GetRequiredService<IServiceScopeFactory>(),
                    factory.GetRequiredService<ILogger<HtmlFixService>>()
                )
        );
        return services;
    }
}
