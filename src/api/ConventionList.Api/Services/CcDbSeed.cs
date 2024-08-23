using ConventionList.Api.Data;
using ConventionList.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace ConventionList.Api.Services;

public class CcDbSeed
{
    public static void Seed(ConventionListDbContext dbContext, ILoggerFactory loggerFactory)
    {
        try
        {
            dbContext.Database.Migrate();

            if (!dbContext.Users.Any(u => u.Id == User.ConventionSceneSyncUserId))
            {
                _ = dbContext.Add(new User { Id = User.ConventionSceneSyncUserId });
            }

            if (!dbContext.Users.Any(u => u.Id == User.FanConsSyncUserId))
            {
                _ = dbContext.Add(new User { Id = User.FanConsSyncUserId });
            }

            dbContext.SaveChanges();
        }
        catch (Exception ex)
        {
            var log = loggerFactory.CreateLogger<CcDbSeed>();
            log.LogError(ex, "An error occurred while migrating the database.");
            throw;
        }
    }
}