using Ardalis.Specification;
using ConventionList.Core.Models;

namespace ConventionList.Core.Specifications;

public class GetHtmlFixableConventionsSpecification : Specification<Convention>
{
    public GetHtmlFixableConventionsSpecification()
    {
        Query.Where(c => c.Name.Contains("&amp;") || c.Name.Contains("&#039;"));
    }
}
