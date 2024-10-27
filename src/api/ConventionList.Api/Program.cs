using System.Reflection;
using System.Security.Claims;
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

string? connectionString = builder.Configuration.GetConnectionString(
    "PostgresDatabaseConventionList"
);

// Console.WriteLine($"*************************");
// Console.WriteLine($"*** Connection string = {connectionString}");
// Console.WriteLine($"*************************");
Console.WriteLine($"*********{builder.Configuration["Auth0:Domain"]}");
Console.WriteLine($"*********{builder.Configuration["Auth0:Audience"]}");
Console.WriteLine($"*********{logFileLocation}");

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
        "manage:myconventions",
        policy => policy.Requirements.Add(new HasScopeRequirement("manage:myconventions", domain))
    );
    options.AddPolicy(
        "manage:allconventions",
        policy => policy.Requirements.Add(new HasScopeRequirement("manage:allconventions", domain))
    );
});
builder.Services.AddSingleton<IAuthorizationHandler, HasScopeHandler>();
builder.Services.AddControllers();
builder.Services.AddAutoMapper(typeof(Program));
builder.Services.AddHttpClient();
builder.Services.AddGoogleMapsSearchClient(builder);
builder.Services.AddGeocodingService();
builder.Services.AddConventionSceneSync();
builder.Services.AddFanConsSync();
builder.Services.AddHtmlFixService();

var app = builder.Build();
app.Migrate();
app.UseMiddleware<RequestLoggingMiddleware>();
app.UseCors();
app.UseAuthentication();
app.UseRouting();
app.UseAuthorization();
app.MapControllers();

app.Run();
