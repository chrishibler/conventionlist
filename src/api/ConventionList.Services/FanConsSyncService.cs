using System.Web;
using AutoMapper;
using ConventionList.Core;
using ConventionList.Core.Interfaces;
using ConventionList.Core.Mapping;
using ConventionList.Core.Models;
using ConventionList.Core.Specifications;
using ConventionList.Services.Mapping.FanCons;
using HtmlAgilityPack;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

namespace ConventionList.Services;

public sealed class FanConsSyncService(
    ILogger<FanConsSyncService> logger,
    IServiceScopeFactory scopeFactory,
    IMapper autoMapper,
    IGeocoder geocoder
) : HostedService(TimeSpan.FromSeconds(5), TimeSpan.FromDays(1))
{
    public override Task StartAsync(CancellationToken cancellationToken)
    {
        logger.LogInformation($"{nameof(FanConsSyncService)} sync running");
        return base.StartAsync(cancellationToken);
    }

    protected override async Task DoWork(object? state)
    {
        try
        {
            using var scope = scopeFactory.CreateScope();
            var repo = scope.ServiceProvider.GetRequiredService<IRepository<Convention>>();
            var fanconsConventions = await GetFanConsConventions();

            foreach (var fanConsCon in fanconsConventions)
            {
                logger.LogInformation("Processing FanCons con {Name}", fanConsCon.Name);

                try
                {
                    Geocoordinate? position = null;
                    fanConsCon.Name = HttpUtility.HtmlDecode(fanConsCon.Name);
                    var spec = new GetConventionsInStartDateOrderSpecification(
                        HttpUtility.HtmlDecode(fanConsCon.Name)
                    );
                    var existingCon = await repo.FirstOrDefaultAsync(spec);
                    if (existingCon == null && fanConsCon.EndDate >= DateTime.UtcNow.Date)
                    {
                        try
                        {
                            position = await geocoder.Geocode(fanConsCon);
                        }
                        catch (Exception ex)
                        {
                            logger.LogError(
                                ex,
                                "Error geocoding FanConsCon {ConName}",
                                fanConsCon.Name
                            );
                        }
                        fanConsCon.Name = HttpUtility.HtmlDecode(fanConsCon.Name);
                        fanConsCon.Category = Category.Unlisted;
                        await PoulateConventionUrl(fanConsCon);
                        fanConsCon.IsApproved = true;
                        fanConsCon.Position = PointFactory.CreatePoint(position);
                        await repo.AddAsync(fanConsCon);
                    }
                    else if (
                        existingCon is not null
                        && UserIds.FanConsSyncUserId == existingCon.SubmitterId
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
                        await repo.UpdateAsync(existingCon);
                    }
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
