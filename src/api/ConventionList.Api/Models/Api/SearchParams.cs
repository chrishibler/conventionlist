namespace ConventionList.Api.Models.Api;

public record class SearchParams(Category? CategoryFilter,
                                 string? Search,
                                 DateTime? StartRange,
                                 DateTime? EndRange,
                                 OrderBy OrderBy = OrderBy.Distance,
                                 int? DistanceInMiles = null)
{
    public bool HasSearchFilter => !string.IsNullOrWhiteSpace(Search);

    public bool HasCategoryFilter => CategoryFilter is not null and not Category.Unknown;

    public bool HasStartRangeFilter => StartRange != null;

    public bool HasEndRangeFilter => EndRange != null;

    public bool ValidDateRange => StartRange <= EndRange;

    public IQueryable<Convention> ApplyFilter(IQueryable<Convention> query)
    {
        if (HasCategoryFilter)
        {
            query = query.Where(c => c.Category == CategoryFilter);
        }

        if (HasStartRangeFilter)
        {
            query = query.Where(c => c.StartDate >= StartRange || c.EndDate <= StartRange);
        }

        if (HasEndRangeFilter)
        {
            query = query.Where(c => c.EndDate <= EndRange);
        }

        if (HasSearchFilter)
        {
            string lowerSearch = Search!.ToLower(System.Globalization.CultureInfo.CurrentCulture);
#pragma warning disable CA1304 // Specify CultureInfo
#pragma warning disable CA1862 // Use the 'StringComparison' method overloads to perform case-insensitive string comparisons
#pragma warning disable CA1311 // Specify a culture or use an invariant version
            query = query.Where(c => c.Name.ToLower().Contains(lowerSearch)
                                 || (c.City != null && c.City.ToLower().Contains(lowerSearch))
                                 || (c.VenueName != null && c.VenueName.ToLower().Contains(lowerSearch)));
#pragma warning restore CA1311 // Specify a culture or use an invariant version
#pragma warning restore CA1862 // Use the 'StringComparison' method overloads to perform case-insensitive string comparisons
#pragma warning restore CA1304 // Specify CultureInfo
        }

        return query;
    }
}
