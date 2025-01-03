namespace ConventionList.Domain.Models;

public record class ConventionsResult(
    int TotalCount,
    int TotalPages,
    int CurrentPage,
    int PageSize,
    List<ApiConvention> Conventions
);
