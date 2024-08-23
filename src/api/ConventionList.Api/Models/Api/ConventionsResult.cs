namespace ConventionList.Api.Models.Api;

public record class ConventionsResult(int TotalCount,
                                      int TotalPages,
                                      int CurrentPage,
                                      int PageSize,
                                      List<ApiConvention> Conventions)
{
}
