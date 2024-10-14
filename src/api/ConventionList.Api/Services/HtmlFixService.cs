using ConventionList.Api.Data;
using ConventionList.Api.Models;
using Microsoft.Extensions.DependencyInjection;

namespace ConventionList.Api.Services;

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
            var db = scope.ServiceProvider.GetRequiredService<ConventionListDbContext>();
            var consToFix = db.Conventions.Where(c =>
                c.Name.Contains("&amp;") || c.Name.Contains("&#039;")
            );

            foreach (var con in consToFix)
            {
                logger.LogInformation("Fixing {ConName}", con.Name);
                try
                {
                    con.Name = ReplaceHtmlChars(con.Name);
                    await db.SaveChangesAsync();
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
        return input.Trim().Replace("&amp;", "&").Replace("&#039;", "'");
    }
}
