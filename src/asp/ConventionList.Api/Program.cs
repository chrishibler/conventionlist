using System.Text.Json.Serialization;
using ConventionList.Api.Auth;
using ConventionList.Api.Extensions;
using ConventionList.Api.Middleware;
using ConventionList.Core.Interfaces;
using ConventionList.Core.Models;
using ConventionList.Infrastructure;
using ConventionList.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);
Host.CreateDefaultBuilder(args).UseSystemd();

builder.Configuration.AddEnvironmentVariables();

builder
    .Services.AddSingleton<IAuthorizationHandler, HasPermissionHandler>()
    .AddScoped<IRepository<Convention>, EfRepository<Convention>>()
    .AddDb(builder.Configuration)
    .AddAppAuthorization()
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
app.UseRouting();
app.UseCors();
app.UseMiddleware<RequestLoggingMiddleware>();
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();

app.Run();
