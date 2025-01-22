using Ardalis.Specification;
using ConventionList.Core.Models;

namespace ConventionList.Core.Specifications;

public class GetConventionsToGeocodeSpecification : Specification<Convention>
{
    public GetConventionsToGeocodeSpecification()
    {
        Query.Where(c => c.Position == null);
    }
}
