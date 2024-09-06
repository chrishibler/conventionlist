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
        }
        catch (Exception ex)
        {
            var log = loggerFactory.CreateLogger<CcDbSeed>();
            log.LogError(ex, "An error occurred while migrating the database.");
            throw;
        }
    }
}
