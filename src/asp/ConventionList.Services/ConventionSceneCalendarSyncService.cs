using System.Web;
using AutoMapper;
using ConventionList.Core.Interfaces;
using ConventionList.Core.Mapping;
using ConventionList.Core.Models;
using ConventionList.Core.Specifications;
using Ical.Net;
using Ical.Net.CalendarComponents;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;

namespace ConventionList.Services;

public sealed class ConventinSceneCalendarSyncService(
    ILogger<ConventinSceneCalendarSyncService> logger,
    IHttpClientFactory clientFactory,
    IMapper autoMapper,
    IGeocoder geocoder,
    IServiceScopeFactory scopeFactory
) : HostedService(TimeSpan.FromSeconds(5), TimeSpan.FromDays(1))
{
    private const string IcalUrl = "https://www.conventionscene.com/?feed=gigpress-ical";

    public override Task StartAsync(CancellationToken cancellationToken)
    {
        logger.LogInformation($"{nameof(ConventinSceneCalendarSyncService)} is starting");
        return base.StartAsync(cancellationToken);
    }

    protected override async Task DoWork(object? state)
    {
        try
        {
            using IServiceScope scope = scopeFactory.CreateScope();
            var repo = scope.ServiceProvider.GetRequiredService<IRepository<Convention>>();
            Calendar calendar = await LoadCalendar();
            foreach (CalendarEvent evnt in calendar.Events)
            {
                Geocoordinate? position = null;
                logger.LogInformation("Event id: {CalendarEventId}", evnt.Uid);
                try
                {
                    var conventionSceneCon = autoMapper.Map<Convention>(evnt);
                    conventionSceneCon.Name = HttpUtility.HtmlDecode(conventionSceneCon.Name);
                    var spec = new GetConventionsInStartDateOrderSpecification(
                        HttpUtility.HtmlDecode(conventionSceneCon.Name)
                    );
                    var existingCon = await repo.FirstOrDefaultAsync(spec);
                    if (existingCon == null && conventionSceneCon.EndDate >= DateTime.UtcNow.Date)
                    {
                        try
                        {
                            position = await geocoder.Geocode(conventionSceneCon);
                        }
                        catch (Exception ex)
                        {
                            logger.LogError(
                                ex,
                                "Error geocoding FanConsCon {ConName}",
                                conventionSceneCon.Name
                            );
                        }
                        conventionSceneCon.Name = HttpUtility.HtmlDecode(conventionSceneCon.Name);
                        conventionSceneCon.Category ??= Category.Unlisted;
                        conventionSceneCon.IsApproved = true;
                        conventionSceneCon.Position = PointFactory.CreatePoint(position);
                        await repo.AddAsync(conventionSceneCon);
                    }
                    else if (
                        existingCon is not null
                        && string.IsNullOrWhiteSpace(existingCon.Editor)
                    )
                    {
                        autoMapper.Map(conventionSceneCon, existingCon);
                        existingCon.Category ??= Category.Unlisted;
                        await repo.UpdateAsync(existingCon);
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
        logger.LogInformation($"{nameof(ConventinSceneCalendarSyncService)} is starting");
        return base.StopAsync(cancellationToken);
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
