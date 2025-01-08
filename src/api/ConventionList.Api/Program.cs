using System.Text.Json.Serialization;
using ConventionList.Api.Auth;
using ConventionList.Api.Extensions;
using ConventionList.Api.Middleware;
using ConventionList.Core.Interfaces;
using ConventionList.Infrastructure;
using ConventionList.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);
Host.CreateDefaultBuilder(args).UseSystemd();

builder.Configuration.AddEnvironmentVariables();

builder
    .Services.AddSingleton<IAuthorizationHandler, HasPermissionHandler>()
    .AddScoped<IConventionRepository, ConventionRepository>()
    .AddDb(builder.Configuration)
    .AddAppAuthorization(builder.Configuration)
    .AddCorsPolicy()
    .AddAppLogging()
    .AddTransient<IGeocoder, Geocoder>()
    .AddGeocodingService()
    .AddAppAuthentication(builder.Configuration)
    .AddMediatR(cfg => cfg.RegisterServicesFromAssembly(typeof(Program).Assembly))
    .AddAutoMapper(AppDomain.CurrentDomain.GetAssemblies())
    .AddHttpClient()
    .AddGoogleMapsSearchClient(builder.Configuration)
    .AddConventionSceneSync()
    .AddFanConsSync()
    .AddHtmlFixService()
    .AddProblemDetails()
    .AddControllers()
    .AddJsonOptions(x =>
    {
        x.JsonSerializerOptions.Converters.Add(new JsonStringEnumConverter());
    });

var app = builder.Build();
app.ConfigureExceptionHandler(app.Logger);
app.Migrate();
app.UseMiddleware<RequestLoggingMiddleware>();
app.UseCors();
app.UseAuthentication();
app.UseRouting();
app.UseAuthorization();
app.MapControllers();

app.Run();
