using Ardalis.Specification;
using AutoMapper;
using ConventionList.Core.Models;

namespace ConventionList.Core.Specifications;

public class GetUserConventionsSpecification : Specification<Convention, ApiConvention>
{
    public GetUserConventionsSpecification(
        SearchParams? searchParams,
        IMapper mapper,
        string userId,
        int pageSize,
        int page
    )
    {
        searchParams?.ApplyFilter(Query);
        Query
            .Where(c => c.SubmitterId == userId)
            .OrderBy(c => c.StartDate)
            .ThenBy(c => c.Name)
            .Skip((page - 1) * pageSize)
            .Take(pageSize);

        Query.Select(c => mapper.Map<ApiConvention>(c));
    }
}
