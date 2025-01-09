using AutoMapper;
using ConventionList.Core.Interfaces;
using ConventionList.Core.Models;
using ConventionList.Core.Specifications;
using MediatR;

namespace ConventionList.Api.Queries;

public record GetConventionsByBoundsQuery(Bounds Bounds, int Page = 1, int PageSize = 20)
    : IRequest<ConventionsResult>;

public class GetConventionsByBoundsHandler(IRepository<Convention> repo, IMapper mapper)
    : IRequestHandler<GetConventionsByBoundsQuery, ConventionsResult>
{
    public async Task<ConventionsResult> Handle(
        GetConventionsByBoundsQuery request,
        CancellationToken cancellationToken
    )
    {
        var spec = new GetConventionsByBoundsSpecification(
            request.Bounds,
            request.Page,
            request.PageSize,
            mapper
        );

        var cons = await repo.ListAsync(spec, cancellationToken);

        return new ConventionsResult(request.Page, request.PageSize, cons);
    }
}
