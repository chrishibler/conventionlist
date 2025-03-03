namespace ConventionList.Core.Models;

public record class SearchParams(
    string? Search,
    bool? Approved,
    OrderBy OrderBy = OrderBy.Distance
);
