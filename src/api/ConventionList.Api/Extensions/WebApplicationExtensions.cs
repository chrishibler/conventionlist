using ConventionList.Api.Data;
using ConventionList.Api.Services;
using Microsoft.EntityFrameworkCore;

namespace ConventionList.Api.Extensions;

public static class WebApplicationExtensions
{
    public static void Migrate(this WebApplication app)
    {
        using var serviceScope = app
            .Services.GetRequiredService<IServiceScopeFactory>()
            .CreateScope();
        {
            var db = serviceScope.ServiceProvider.GetRequiredService<ConventionListDbContext>();
            db.Database.Migrate();
        }
    }
}
