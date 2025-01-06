using System.Web;
using ConventionList.Repository;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;

namespace ConventionList.Services;

public class HtmlFixService(IServiceScopeFactory scopeFactory, ILogger<HtmlFixService> logger)
    : HostedService(TimeSpan.FromSeconds(5), TimeSpan.FromDays(1))
{
    public override Task StartAsync(CancellationToken cancellationToken)
    {
        logger.LogInformation($"{nameof(HtmlFixService)} running");
        return base.StartAsync(cancellationToken);
    }

    protected override async Task DoWork(object? state)
    {
        try
        {
            using var scope = scopeFactory.CreateScope();
            var repo = scope.ServiceProvider.GetRequiredService<IConventionRepository>();
            var consToFix = await repo.GetHtmlFixableConventions();
            foreach (var con in consToFix)
            {
                logger.LogInformation("Fixing {ConName}", con.Name);
                try
                {
                    con.Name = HttpUtility.HtmlDecode(con.Name);
                    await repo.SaveChangesAsync();
                }
                catch (Exception ex)
                {
                    logger.LogError(ex, "Error HTML fixing {ConName}.", con.Name);
                }
            }
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Exception loading cons to fix.");
        }
    }

    public override Task StopAsync(CancellationToken cancellationToken)
    {
        logger.LogInformation($"{nameof(HtmlFixService)} is stopping");
        return base.StopAsync(cancellationToken);
    }
}
