using ConventionList.Core.Models;

namespace ConventionList.Infrastructure;

static class SearchParamsExtensions
{
    public static bool HasSearchFilter(this SearchParams searchParams) =>
        !string.IsNullOrWhiteSpace(searchParams.Search);

    public static IQueryable<Convention> ApplyFilter(
        this SearchParams searchParams,
        IQueryable<Convention> query
    )
    {
        if (searchParams.Approved != null)
        {
            query = query.Where(c => c.IsApproved == searchParams.Approved);
        }

        if (searchParams.HasSearchFilter())
        {
            // Using ToLower instead of standard CurrentCultureIgnoreCase
            // because EF does not like CurrentCultureIgnoreCase
            string lowerSearch = searchParams.Search!.ToLower(
                System.Globalization.CultureInfo.CurrentCulture
            );
#pragma warning disable CA1862 // Use the 'StringComparison' method overloads to perform case-insensitive string comparisons
            query = query.Where(c =>
                c.Name.ToLower().Contains(lowerSearch)
                || (c.City != null && c.City.ToLower().Contains(lowerSearch))
                || (c.VenueName != null && c.VenueName.ToLower().Contains(lowerSearch))
            );
#pragma warning restore CA1862 // Use the 'StringComparison' method overloads to perform case-insensitive string comparisons
        }

        return query;
    }
}
