using ConventionList.Api.Models;
using ConventionList.Domain.Models;

namespace ConventionList.Api.Data;

public static class SearchParamsExtensions
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
#pragma warning disable CA1304 // Specify CultureInfo
#pragma warning disable CA1862 // Use the 'StringComparison' method overloads to perform case-insensitive string comparisons
#pragma warning disable CA1311 // Specify a culture or use an invariant version
            query = query.Where(c =>
                c.Name.ToLower().Contains(lowerSearch)
                || (c.City != null && c.City.ToLower().Contains(lowerSearch))
                || (c.VenueName != null && c.VenueName.ToLower().Contains(lowerSearch))
            );
#pragma warning restore CA1311 // Specify a culture or use an invariant version
#pragma warning restore CA1862 // Use the 'StringComparison' method overloads to perform case-insensitive string comparisons
#pragma warning restore CA1304 // Specify CultureInfo
        }

        return query;
    }
}
