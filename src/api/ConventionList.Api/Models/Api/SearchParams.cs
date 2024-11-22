namespace ConventionList.Api.Models.Api;

public record class SearchParams(string? Search, bool? approved, OrderBy OrderBy = OrderBy.Distance)
{
    public bool HasSearchFilter => !string.IsNullOrWhiteSpace(Search);

    public IQueryable<Convention> ApplyFilter(IQueryable<Convention> query)
    {
        if (approved != null)
        {
            query = query.Where(c => c.IsApproved == approved);
        }

        if (HasSearchFilter)
        {
            // Using ToLower instead of standard CurrentCultureIgnoreCase
            // because EF does not like CurrentCultureIgnoreCase
            string lowerSearch = Search!.ToLower(System.Globalization.CultureInfo.CurrentCulture);
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
