using AutoMapper;
using ConventionList.Api.Data;
using ConventionList.Api.Models;
using Ical.Net;

namespace ConventionList.Api.Services;

public sealed class ConventinSceneCalendarSync(
    ILogger<ConventinSceneCalendarSync> logger,
    IServiceScopeFactory scopeFactory,
    IHttpClientFactory clientFactory,
    IMapper autoMapper,
    GeocodingService geocodingService
) : HostedService
{
    private const string IcalUrl = "https://www.conventionscene.com/?feed=gigpress-ical";
    public const string ConventionSceneSyncUserId = "convention_scene_sync_user";

    public override Task StartAsync(CancellationToken cancellationToken)
    {
        logger.LogInformation("Calendar sync running");
        Timer = new Timer(DoWork, null, TimeSpan.FromSeconds(20), TimeSpan.FromDays(1));
        return Task.CompletedTask;
    }

    private async void DoWork(object? state)
    {
        using var scope = scopeFactory.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<ConventionListDbContext>();

        try
        {
            var calendar = await LoadCalendar();
            foreach (var evnt in calendar.Events)
            {
                logger.LogInformation("Event id: {CalendarEventId}", evnt.Uid);
                try
                {
                    var conventionSceneCon = autoMapper.Map<Convention>(evnt);
                    var existingCon = db.Conventions.FirstOrDefault(c =>
                        c.Name == conventionSceneCon.Name
                    );
                    if (existingCon == null && conventionSceneCon.EndDate >= DateTime.UtcNow.Date)
                    {
                        try
                        {
                            var position = await geocodingService.Geocode(conventionSceneCon);
                            conventionSceneCon.Position = position.ToPoint();
                        }
                        catch (Exception ex)
                        {
                            logger.LogError(
                                ex,
                                "Error geocoding FanConsCon {ConName}",
                                conventionSceneCon.Name
                            );
                        }
                        conventionSceneCon.Name = HtmlFixService.ReplaceHtmlChars(
                            conventionSceneCon.Name
                        );

                        db.Conventions.Add(conventionSceneCon);
                    }
                    else if (
                        existingCon is not null
                        && existingCon.SubmitterId == ConventionSceneSyncUserId
                    )
                    {
                        autoMapper.Map(conventionSceneCon, existingCon);
                        db.Conventions.Update(existingCon);
                    }

                    await db.SaveChangesAsync();
                }
                catch (Exception ex)
                {
                    logger.LogError(ex, "Exception syncing calendar event");
                }
            }
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Exception loading calendar for sync");
        }
    }

    public override Task StopAsync(CancellationToken cancellationToken)
    {
        logger.LogInformation("CalendarSync service is stopping");
        Timer?.Change(Timeout.Infinite, 0);
        return Task.CompletedTask;
    }

    public async Task<Calendar> LoadCalendar()
    {
        using var httpClient = clientFactory.CreateClient();
        using var icsResponse = await httpClient.GetAsync(IcalUrl);
        if (!icsResponse.IsSuccessStatusCode)
        {
            logger.LogWarning(message: "ICS response: {StatusCode}", icsResponse.StatusCode);
            throw new HttpRequestException("failed to get calendar");
        }

        string icsContent = await icsResponse.Content.ReadAsStringAsync();
        if (string.IsNullOrWhiteSpace(icsContent))
        {
            logger.LogWarning("Null ics response");
            throw new InvalidOperationException("Calendar response has an empty body");
        }

        var calendar = Calendar.Load(icsContent);
        return calendar;
    }
}
