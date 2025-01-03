using AutoMapper;
using ConventionList.Domain;
using ConventionList.Domain.Models;
using ConventionList.Repository;
using ConventionList.Repository.Mapping;
using ConventionList.Repository.Mapping.FanCons;
using HtmlAgilityPack;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

namespace ConventionList.Services;

public sealed class FanConsSync(
    ILogger<FanConsSync> logger,
    IServiceScopeFactory scopeFactory,
    IMapper autoMapper,
    IGeocoder geocoder
) : HostedService
{
    public override Task StartAsync(CancellationToken cancellationToken)
    {
        logger.LogInformation("FanCons sync running");
        Timer = new Timer(DoWork, null, TimeSpan.FromSeconds(5), TimeSpan.FromDays(1));
        return Task.CompletedTask;
    }

    private async void DoWork(object? state)
    {
        try
        {
            using var scope = scopeFactory.CreateScope();
            var repo = scope.ServiceProvider.GetRequiredService<IConventionRepository>();
            var fanconsConventions = await GetFanConsConventions();

            foreach (var fanConsCon in fanconsConventions)
            {
                logger.LogInformation("Processing FanCons con {Name}", fanConsCon.Name);

                try
                {
                    fanConsCon.Name = HtmlFixService.ReplaceHtmlChars(fanConsCon.Name);
                    var existingCon = await repo.GetLatestConventionByName(fanConsCon.Name);
                    if (existingCon == null || existingCon.StartDate >= fanConsCon.StartDate)
                    {
                        try
                        {
                            var position = await geocoder.Geocode(fanConsCon);
                            fanConsCon.Position = GeocoordinateTypeConverter.ToPoint(position);
                        }
                        catch (Exception ex)
                        {
                            logger.LogError(
                                ex,
                                "Error geocoding FanConsCon {ConName}",
                                fanConsCon.Name
                            );
                        }
                        fanConsCon.Name = HtmlFixService.ReplaceHtmlChars(fanConsCon.Name);
                        fanConsCon.Category = Category.Unlisted;
                        await PoulateConventionUrl(fanConsCon);
                        fanConsCon.IsApproved = true;
                        await repo.Add(fanConsCon);
                    }
                    else if (
                        UserIds.FanConsSyncUserId == existingCon.SubmitterId
                        && string.IsNullOrWhiteSpace(existingCon.Editor)
                    )
                    {
                        if (
                            fanConsCon.WebsiteAddress is not null
                            && fanConsCon.WebsiteAddress.Contains(
                                "fancons.com/events",
                                StringComparison.CurrentCultureIgnoreCase
                            )
                        )
                        {
                            await PoulateConventionUrl(fanConsCon);
                        }
                        autoMapper.Map(fanConsCon, existingCon);
                        existingCon.Category ??= Category.Unlisted;
                        repo.Update(existingCon);
                    }

                    await repo.SaveChangesAsync();
                }
                catch (Exception ex)
                {
                    logger.LogError(ex, "Exception processing FanCons con");
                }
            }
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Exception loading FanCons data");
        }
    }

    public override Task StopAsync(CancellationToken cancellationToken)
    {
        logger.LogInformation("CalendarSync service is stopping");
        Timer?.Change(Timeout.Infinite, 0);
        return Task.CompletedTask;
    }

    public async Task<List<Convention>> GetFanConsConventions()
    {
        using var httpClient = new HttpClient();
        var response = await httpClient.GetAsync("https://fancons.com/events/");
        logger.LogInformation("FanCons response: {StatusCode}", response.StatusCode);
        HtmlDocument htmlDoc = new();
        htmlDoc.LoadHtml(await response.Content.ReadAsStringAsync());
        string jsonData =
            htmlDoc.DocumentNode.SelectNodes("/html[1]/body[1]/script[1]").First().InnerText
            ?? throw new InvalidOperationException("No FanCons json data found");

        var fanConsEvents = JsonConvert.DeserializeObject<List<FanConEvent>>(jsonData) ?? [];

        var fanconConventions = fanConsEvents
            .Select(autoMapper.Map<Convention>)
            .Where(c => c is not null && c.EndDate >= DateTime.UtcNow.Date)
            .ToList();

        return fanconConventions;
    }

    private async Task PoulateConventionUrl(Convention con)
    {
        try
        {
            logger.LogInformation("Getting URL for FanCons con {ConName}", con.Name);
            using var httpClient = new HttpClient();
            var response = await httpClient.GetAsync(con.WebsiteAddress);
            var htmlDoc = new HtmlDocument();
            htmlDoc.LoadHtml(await response.Content.ReadAsStringAsync());
            string conLink = htmlDoc
                .DocumentNode.SelectNodes("//a[@href]")
                .First(n => n.InnerText == "Visit Convention Site")
                .GetAttributeValue("href", null)
                .Replace(
                    "fancons.com",
                    "conventionlist.org",
                    StringComparison.CurrentCultureIgnoreCase
                );
            con.WebsiteAddress = conLink;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Could not get URL from FanCons for {ConName}", con.Name);
        }
    }
}
