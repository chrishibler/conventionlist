using ConventionList.Api.Data;
using Microsoft.EntityFrameworkCore;
using ConventionList.Api.Extensions;
using ConventionList.Api.Middleware;

var builder = WebApplication.CreateBuilder(args);
Host.CreateDefaultBuilder(args).UseSystemd();
builder.Services.AddLogging();

string? connectionString = builder.Configuration.GetConnectionString("PostgresDatabaseConventionList");
// Console.WriteLine($"*************************");
// Console.WriteLine($"*** Connection string = {connectionString}");
// Console.WriteLine($"*************************");

// Postgres
builder.Services.AddDbContext<ConventionListDbContext>(options => options.UseNpgsql(connectionString, x => x.UseNetTopologySuite()));

builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(
        policy =>
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
builder.Services.AddLogging(loggingBuilder =>
{
    loggingBuilder.AddConsole();
    loggingBuilder.AddDebug();
});

var app = builder.Build();
app.UseMiddleware<RequestLoggingMiddleware>();
app.UsePathBase("/api");
app.UseRouting();
app.UseCors();
app.UseAuthentication();
app.UseAuthorization();
app.SeedDb();
app.MapControllers();

app.Run();
