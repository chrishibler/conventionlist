using ConventionList.Core.Interfaces;
using ConventionList.Core.Models;
using MediatR;

namespace ConventionList.Api.Queries;

public record GetConventionsByBoundsQuery(Bounds Bounds, int Page = 1, int PageSize = 20)
    : IRequest<ConventionsResult>;

public class GetConventionsByBoundsHandler(IConventionRepository repo)
    : IRequestHandler<GetConventionsByBoundsQuery, ConventionsResult>
{
    public Task<ConventionsResult> Handle(
        GetConventionsByBoundsQuery request,
        CancellationToken cancellationToken
    )
    {
        return repo.GetConventionsByBounds(
            request.Bounds,
            request.Page,
            request.PageSize,
            cancellationToken
        );
    }
}
