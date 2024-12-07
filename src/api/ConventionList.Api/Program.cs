using System.Reflection;
using System.Security.Claims;
using System.Text.Json.Serialization;
using ConventionList.Api.Auth;
using ConventionList.Api.Data;
using ConventionList.Api.Extensions;
using ConventionList.Api.Middleware;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Serilog;

var builder = WebApplication.CreateBuilder(args);
Host.CreateDefaultBuilder(args).UseSystemd();

string logFileLocation =
    $"{Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location)}/logs/conventionlist.log";
Log.Logger = new LoggerConfiguration()
    .MinimumLevel.Debug()
    .WriteTo.File(logFileLocation)
    .CreateLogger();

builder.Services.AddSerilog();
builder.Configuration.AddEnvironmentVariables();

string? connectionString = builder.Configuration.GetConnectionString(
    "PostgresDatabaseConventionList"
);

// Program.cs
var domain = $"https://{builder.Configuration["Auth0:Domain"]}";
builder
    .Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.Authority = domain;
        options.Audience = builder.Configuration["Auth0:Audience"];
        options.TokenValidationParameters = new TokenValidationParameters
        {
            NameClaimType = ClaimTypes.NameIdentifier,
        };
    });

// Postgres
builder.Services.AddDbContext<ConventionListDbContext>(options =>
    options.UseNpgsql(connectionString, x => x.UseNetTopologySuite())
);

builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.AllowAnyOrigin();
        policy.AllowAnyHeader();
        policy.AllowAnyMethod();
    });
});

builder.Services.AddAuthorization(options =>
{
    options.AddPolicy(
        Permissions.ManageMyConventions,
        policy =>
            policy.Requirements.Add(
                new HasScopeRequirement(Permissions.ManageMyConventions, domain)
            )
    );
    options.AddPolicy(
        Permissions.ManageAllConventions,
        policy =>
            policy.Requirements.Add(
                new HasScopeRequirement(Permissions.ManageAllConventions, domain)
            )
    );
});
builder
    .Services.AddSingleton<IAuthorizationHandler, HasScopeHandler>()
    .AddMediatR(cfg => cfg.RegisterServicesFromAssembly(typeof(Program).Assembly))
    .AddAutoMapper(typeof(Program))
    .AddHttpClient()
    .AddGoogleMapsSearchClient(builder)
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
