using Ardalis.Specification;
using ConventionList.Core.Models;

namespace ConventionList.Core.Specifications;

public class GetConventionsInStartDateOrderSpecification : Specification<Convention>
{
    public GetConventionsInStartDateOrderSpecification(string name)
    {
        Query.OrderByDescending(c => c.StartDate).Where(c => c.Name == name);
    }
}
