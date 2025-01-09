using Ardalis.Specification;

namespace ConventionList.Core.Interfaces;

public interface IRepository<T> : IRepositoryBase<T>, IReadRepositoryBase<T>
    where T : class { }
