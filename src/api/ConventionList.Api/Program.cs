using ConventionList.Api.Data;
using ConventionList.Api.Extensions;
using ConventionList.Api.Middleware;
using Microsoft.EntityFrameworkCore;
using Serilog;

var builder = WebApplication.CreateBuilder(args);
Host.CreateDefaultBuilder(args).UseSystemd();

Log.Logger = new LoggerConfiguration()
    .MinimumLevel.Debug()
    .WriteTo.File("logs/conventionlist.log")
    .CreateLogger();

builder.Services.AddSerilog();

string? connectionString = builder.Configuration.GetConnectionString(
    "PostgresDatabaseConventionList"
);

// Console.WriteLine($"*************************");
// Console.WriteLine($"*** Connection string = {connectionString}");
// Console.WriteLine($"*************************");

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

builder.Services.AddControllers();
builder.Services.AddAutoMapper(typeof(Program));
builder.Services.AddHttpClient();
builder.Services.AddGoogleMapsSearchClient(builder);
builder.Services.AddGeocodingService();
builder.Services.AddConventionSceneSync();
builder.Services.AddFanConsSync();

var app = builder.Build();
app.Migrate();
app.UseMiddleware<RequestLoggingMiddleware>();
app.UseRouting();
app.UseCors();
app.UseAuthentication();
app.UseAuthorization();
app.SeedDb();
app.MapControllers();

app.Run();
