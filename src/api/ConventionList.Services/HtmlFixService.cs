using System.Web;
using ConventionList.Repository;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;

namespace ConventionList.Services;

public class HtmlFixService(IServiceScopeFactory scopeFactory, ILogger<HtmlFixService> logger)
    : HostedService
{
    public override Task StartAsync(CancellationToken cancellationToken)
    {
        logger.LogInformation("HtmlFixService running");
        Timer = new Timer(DoWork, null, TimeSpan.FromSeconds(30), TimeSpan.FromDays(1));
        return Task.CompletedTask;
    }

    private async void DoWork(object? state)
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
                    con.Name = ReplaceHtmlChars(con.Name);
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
        logger.LogInformation("HtmlFixService is stopping");
        Timer?.Change(Timeout.Infinite, 0);
        return Task.CompletedTask;
    }

    public static string ReplaceHtmlChars(string input)
    {
        return HttpUtility.HtmlDecode(input);
    }
}
