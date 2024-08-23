using AutoMapper;
using ConventionList.Api.Data;
using ConventionList.Api.Mapping.FanCons;
using ConventionList.Api.Models;
using HtmlAgilityPack;
using Newtonsoft.Json;

namespace ConventionList.Api.Services;

public sealed class FanConsSync(ILogger<FanConsSync> logger,
                                IServiceScopeFactory scopeFactory,
                                IMapper autoMapper,
                                GeocodingService geocodingService) : HostedService
{

    public override Task StartAsync(CancellationToken cancellationToken)
    {
        logger.LogInformation("FanCons sync running");
        Timer = new Timer(DoWork, null, TimeSpan.FromMinutes(5), TimeSpan.FromDays(1));
        return Task.CompletedTask;
    }

    private async void DoWork(object? state)
    {
        try
        {
            using var scope = scopeFactory.CreateScope();
            var db = scope.ServiceProvider.GetRequiredService<ConventionListDbContext>();
            var fanconsConventions = await GetFanConsConventions();

            foreach (var fanConsCon in fanconsConventions)
            {
                logger.LogInformation("Processing FanCons con {Name}", fanConsCon.Name);

                try
                {
                    var existingCon = db.Conventions.FirstOrDefault(c => c.Name == fanConsCon.Name);
                    if (existingCon == null)
                    {
                        try
                        {
                            var position = await geocodingService.Geocode(fanConsCon);
                            fanConsCon.Position = position.ToPoint();
                        }
                        catch (Exception ex)
                        {
                            logger.LogError(ex, "Error geocoding FanConsCon {ConName}", fanConsCon.Name);
                        }
                        fanConsCon.Name = fanConsCon.Name.Trim();
                        await PoulateConventionUrl(fanConsCon);
                        db.Conventions.Add(fanConsCon);
                    }
                    else if (User.SyncUserIds.Contains(existingCon.SubmitterId))
                    {
                        if (fanConsCon.WebsiteAddress is not null && fanConsCon.WebsiteAddress.Contains("fancons.com/events", StringComparison.CurrentCultureIgnoreCase))
                        {
                            await PoulateConventionUrl(fanConsCon);
                        }
                        autoMapper.Map(fanConsCon, existingCon);
                        db.Conventions.Update(existingCon);
                    }

                    await db.SaveChangesAsync();
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
        string jsonData = htmlDoc.DocumentNode.SelectNodes("/html[1]/body[1]/script[1]").First().InnerText
            ?? throw new InvalidOperationException("No FanCons json data found");

        var fanConsEvents = JsonConvert.DeserializeObject<List<FanConEvent>>(jsonData) ?? [];

        var fanconConventions = fanConsEvents
            .Select(autoMapper.Map<Convention>)
            .Where(c => c is not null && c.EndDate >= DateTime.UtcNow.Date).ToList();

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
            string conLink = htmlDoc.DocumentNode.SelectNodes("//a[@href]")
                                                  .First(n => n.InnerText == "Visit Convention Site")
                                                  .GetAttributeValue("href", null)
                                                  .Replace("fancons.com", "conventionlist.org", StringComparison.CurrentCultureIgnoreCase);
            con.WebsiteAddress = conLink;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Could not get URL from FanCons for {ConName}", con.Name);
        }
    }
}
