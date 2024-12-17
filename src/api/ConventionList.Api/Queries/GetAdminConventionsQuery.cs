using ConventionList.Api.Data;
using ConventionList.Api.Models;
using ConventionList.Domain.Models;
using MediatR;

namespace ConventionList.Api.Queries;

public record GetAdminConventionsQuery(
    int Page = 1,
    int PageSize = 20,
    SearchParams? SearchParams = null
) : IRequest<ConventionsResult>;

public class GetAdminConventionsHandler(IConventionRepository repo)
    : IRequestHandler<GetAdminConventionsQuery, ConventionsResult>
{
    public Task<ConventionsResult> Handle(
        GetAdminConventionsQuery request,
        CancellationToken cancellationToken
    )
    {
        return repo.GetAdminConventions(
            request.SearchParams,
            request.Page,
            request.PageSize,
            cancellationToken
        );
    }
}
