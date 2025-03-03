using System.Web;
using ConventionList.Core.Interfaces;
using ConventionList.Core.Models;
using ConventionList.Core.Specifications;
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
            var repo = scope.ServiceProvider.GetRequiredService<IRepository<Convention>>();
            var spec = new GetHtmlFixableConventionsSpecification();
            var consToFix = await repo.ListAsync(spec);
            foreach (var con in consToFix)
            {
                logger.LogInformation("Fixing {ConName}", con.Name);
                try
                {
                    con.Name = HttpUtility.HtmlDecode(con.Name);
                    // Executing Update each time b/c it's more important that the data is fixed than performance
                    await repo.UpdateAsync(con);
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
