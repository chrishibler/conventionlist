using Ardalis.Specification.EntityFrameworkCore;
using ConventionList.Core.Interfaces;

namespace ConventionList.Infrastructure;

public class EfRepository<T>(ConventionListDbContext dbContext)
    : RepositoryBase<T>(dbContext),
        IRepository<T>
    where T : class { }
