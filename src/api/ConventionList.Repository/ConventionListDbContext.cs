using ConventionList.Domain.Models;
using Microsoft.EntityFrameworkCore;

namespace ConventionList.Repository;

public class ConventionListDbContext(DbContextOptions<ConventionListDbContext> options)
    : DbContext(options)
{
    public required DbSet<Convention> Conventions { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Convention>().Property(c => c.Category).HasConversion<string>();

        base.OnModelCreating(modelBuilder);
    }
}
