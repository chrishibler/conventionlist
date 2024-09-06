using ConventionList.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace ConventionList.Api.Data;

public class ConventionListDbContext(DbContextOptions<ConventionListDbContext> options)
    : DbContext(options)
{
    public DbSet<Convention> Conventions { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Convention>().Property(c => c.Category).HasConversion<string>();

        base.OnModelCreating(modelBuilder);
    }
}
