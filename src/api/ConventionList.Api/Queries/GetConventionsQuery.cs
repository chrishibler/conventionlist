using AutoMapper;
using ConventionList.Core.Interfaces;
using ConventionList.Core.Models;
using ConventionList.Core.Specifications;
using MediatR;

namespace ConventionList.Api.Queries;

public record GetConventionsQuery(
    int Page = 1,
    int PageSize = 20,
    double? Lat = null,
    double? Lon = null,
    SearchParams? SearchParams = null
) : IRequest<ConventionsResult>;

public class GetConventionsHandler(IRepository<Convention> repo, IMapper mapper)
    : IRequestHandler<GetConventionsQuery, ConventionsResult>
{
    public async Task<ConventionsResult> Handle(
        GetConventionsQuery request,
        CancellationToken cancellationToken
    )
    {
        var spec = new GetConventionsSpecification(
            mapper,
            request.Page,
            request.PageSize,
            request.Lat,
            request.Lon,
            request.SearchParams
        );

        var cons = await repo.ListAsync(spec, cancellationToken);

        return new ConventionsResult(request.Page, request.PageSize, cons);
    }
}
