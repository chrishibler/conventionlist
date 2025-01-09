using Ardalis.Specification;
using AutoMapper;
using ConventionList.Core.Models;

namespace ConventionList.Core.Specifications;

public class GetAdminConventionsSpecification : Specification<Convention, ApiConvention>
{
    public GetAdminConventionsSpecification(
        IMapper mapper,
        int page = 1,
        int pageSize = 20,
        SearchParams? searchParams = null
    )
    {
        searchParams?.ApplyFilter(Query);
        Query
            .OrderByDescending(c => c.StartDate)
            .ThenBy(c => c.Name)
            .Skip((page - 1) * pageSize)
            .Take(pageSize);

        Query.Select(c => mapper.Map<ApiConvention>(c));
    }
}
