namespace ConventionList.Core.Models;

public record class ConventionsResult(
    int CurrentPage,
    int PageSize,
    List<ApiConvention> Conventions
);
