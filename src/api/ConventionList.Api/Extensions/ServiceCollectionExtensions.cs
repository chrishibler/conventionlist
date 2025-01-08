using System.Reflection;
using System.Security.Claims;
using AutoMapper;
using ConventionList.Api.Auth;
using ConventionList.Core.Interfaces;
using ConventionList.Infrastructure;
using ConventionList.Services;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Serilog;

namespace ConventionList.Api.Extensions;

public static class ServiceCollectionExtensions
{
    private const string GoogleMapsApiKey = "GoogleMaps:ApiKey";
    private const string AuthDomainKey = "Auth0:Domain";
    private const string AuthAudienceKey = "Auth0:Audience";
    private const string DbConnectionKey = "PostgresDatabaseConventionList";

    public static IServiceCollection AddGeocodingService(this IServiceCollection services)
    {
        _ = services.AddHostedService(
            (serviceProvider) =>
            {
                GeocodingService service =
                    new(
                        serviceProvider.GetRequiredService<IGeocoder>(),
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
                ConventinSceneCalendarSyncService service =
                    new(
                        serviceProvider.GetRequiredService<
                            ILogger<ConventinSceneCalendarSyncService>
                        >(),
                        serviceProvider.GetRequiredService<IHttpClientFactory>(),
                        serviceProvider.GetRequiredService<IMapper>(),
                        serviceProvider.GetRequiredService<IGeocoder>(),
                        serviceProvider.GetRequiredService<IServiceScopeFactory>()
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
                FanConsSyncService service =
                    new(
                        serviceProvider.GetRequiredService<ILogger<FanConsSyncService>>(),
                        serviceProvider.GetRequiredService<IServiceScopeFactory>(),
                        serviceProvider.GetRequiredService<IMapper>(),
                        serviceProvider.GetRequiredService<IGeocoder>()
                    );
                return service;
            }
        );
        return services;
    }

    public static IServiceCollection AddGoogleMapsSearchClient(
        this IServiceCollection services,
        ConfigurationManager config
    )
    {
        string? key = config[GoogleMapsApiKey];
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
        services.AddHostedService(
            (factory) =>
                new HtmlFixService(
                    factory.GetRequiredService<IServiceScopeFactory>(),
                    factory.GetRequiredService<ILogger<HtmlFixService>>()
                )
        );
        return services;
    }

    public static IServiceCollection AddAppLogging(this IServiceCollection services)
    {
        string logFileLocation =
            $"{Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location)}/logs/conventionlist.log";
        Log.Logger = new LoggerConfiguration()
            .MinimumLevel.Debug()
            .WriteTo.File(logFileLocation)
            .CreateLogger();

        services.AddSerilog();

        return services;
    }

    public static IServiceCollection AddAppAuthentication(
        this IServiceCollection services,
        ConfigurationManager config
    )
    {
        var domain = $"https://{config[AuthDomainKey]}";
        services
            .AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
            .AddJwtBearer(options =>
            {
                options.Authority = domain;
                options.Audience = config[AuthAudienceKey];
                options.TokenValidationParameters = new TokenValidationParameters
                {
                    NameClaimType = ClaimTypes.NameIdentifier,
                };
            });

        return services;
    }

    public static IServiceCollection AddCorsPolicy(this IServiceCollection services)
    {
        services.AddCors(options =>
        {
            options.AddDefaultPolicy(policy =>
            {
                policy.AllowAnyOrigin();
                policy.AllowAnyHeader();
                policy.AllowAnyMethod();
            });
        });
        return services;
    }

    public static IServiceCollection AddDb(
        this IServiceCollection services,
        ConfigurationManager config
    )
    {
        string? connectionString = config.GetConnectionString(DbConnectionKey);

        services.AddDbContext<ConventionListDbContext>(options =>
            options.UseNpgsql(connectionString, x => x.UseNetTopologySuite())
        );

        return services;
    }

    public static IServiceCollection AddAppAuthorization(
        this IServiceCollection services,
        ConfigurationManager config
    )
    {
        _ = services
            .AddSingleton<IAuthorizationHandler, HasPermissionHandler>()
            .AddAuthorizationBuilder()
            .AddPolicy(
                Permissions.ManageMyConventions,
                policy =>
                    policy.Requirements.Add(
                        new HasPermissionRequirement(
                            Permissions.ManageMyConventions,
                            config[AuthDomainKey]!
                        )
                    )
            )
            .AddPolicy(
                Permissions.ManageAllConventions,
                policy =>
                    policy.Requirements.Add(
                        new HasPermissionRequirement(
                            Permissions.ManageAllConventions,
                            config[AuthDomainKey]!
                        )
                    )
            );

        return services;
    }
}
