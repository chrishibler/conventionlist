using AutoMapper;
using ConventionList.Domain.Models;
using ConventionList.Repository;
using ConventionList.Repository.Mapping;
using Ical.Net;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;

namespace ConventionList.Services;

public sealed class ConventinSceneCalendarSync(
    ILogger<ConventinSceneCalendarSync> logger,
    IHttpClientFactory clientFactory,
    IMapper autoMapper,
    IGeocoder geocoder,
    IServiceScopeFactory scopeFactory
) : HostedService
{
    private const string IcalUrl = "https://www.conventionscene.com/?feed=gigpress-ical";

    public override Task StartAsync(CancellationToken cancellationToken)
    {
        logger.LogInformation("Calendar sync running");
        Timer = new Timer(DoWork, null, TimeSpan.FromSeconds(20), TimeSpan.FromDays(1));
        return Task.CompletedTask;
    }

    private async void DoWork(object? state)
    {
        try
        {
            using var scope = scopeFactory.CreateScope();
            var repo = scope.ServiceProvider.GetRequiredService<IConventionRepository>();

            var calendar = await LoadCalendar();
            foreach (var evnt in calendar.Events)
            {
                logger.LogInformation("Event id: {CalendarEventId}", evnt.Uid);
                try
                {
                    var conventionSceneCon = autoMapper.Map<Convention>(evnt);
                    conventionSceneCon.Name = HtmlFixService.ReplaceHtmlChars(
                        conventionSceneCon.Name
                    );

                    var existingCon = await repo.GetLatestConventionByName(conventionSceneCon.Name);
                    if (existingCon == null && conventionSceneCon.EndDate >= DateTime.UtcNow.Date)
                    {
                        try
                        {
                            var position = await geocoder.Geocode(conventionSceneCon);
                            conventionSceneCon.Position = GeocoordinateTypeConverter.ToPoint(
                                position
                            );
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

                        conventionSceneCon.Category ??= Category.Unlisted;

                        conventionSceneCon.IsApproved = true;
                        await repo.Add(conventionSceneCon);
                    }
                    else if (
                        existingCon is not null
                        && string.IsNullOrWhiteSpace(existingCon.Editor)
                    )
                    {
                        autoMapper.Map(conventionSceneCon, existingCon);

                        existingCon.Category ??= Category.Unlisted;

                        repo.Update(existingCon);
                    }

                    await repo.SaveChangesAsync();
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
