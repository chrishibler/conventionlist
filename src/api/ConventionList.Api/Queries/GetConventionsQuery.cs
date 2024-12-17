using ConventionList.Api.Data;
using ConventionList.Api.Models.Api;
using MediatR;

namespace ConventionList.Api.Queries;

public record GetConventionsQuery(
    int Page = 1,
    int PageSize = 20,
    double? Lat = null,
    double? Lon = null,
    SearchParams? SearchParams = null
) : IRequest<ConventionsResult>;

public class GetConventionsHandler(IConventionRepository repo)
    : IRequestHandler<GetConventionsQuery, ConventionsResult>
{
    public Task<ConventionsResult> Handle(
        GetConventionsQuery request,
        CancellationToken cancellationToken
    )
    {
        return repo.GetConventions(
            request.SearchParams,
            request.Lon,
            request.Lat,
            request.Page,
            request.PageSize,
            cancellationToken
        );
    }
}
