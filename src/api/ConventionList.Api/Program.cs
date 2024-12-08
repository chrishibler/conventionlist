using System.Text.Json.Serialization;
using ConventionList.Api.Auth;
using ConventionList.Api.Extensions;
using ConventionList.Api.Middleware;
using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);
Host.CreateDefaultBuilder(args).UseSystemd();

builder.Configuration.AddEnvironmentVariables();

builder
    .Services.AddSingleton<IAuthorizationHandler, HasPermissionHandler>()
    .AddDb(builder.Configuration)
    .AddAppAuthorization(builder.Configuration)
    .AddCorsPolicy()
    .AddAppLogging()
    .AddAppAuthentication(builder.Configuration)
    .AddMediatR(cfg => cfg.RegisterServicesFromAssembly(typeof(Program).Assembly))
    .AddAutoMapper(typeof(Program))
    .AddHttpClient()
    .AddGoogleMapsSearchClient(builder.Configuration)
    .AddGeocodingService()
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
