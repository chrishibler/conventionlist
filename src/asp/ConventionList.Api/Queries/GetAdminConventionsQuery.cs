using AutoMapper;
using ConventionList.Core.Interfaces;
using ConventionList.Core.Models;
using ConventionList.Core.Specifications;
using MediatR;

namespace ConventionList.Api.Queries;

public record GetAdminConventionsQuery(
    int Page = 1,
    int PageSize = 20,
    SearchParams? SearchParams = null
) : IRequest<ConventionsResult>;

public class GetAdminConventionsHandler(IRepository<Convention> repo, IMapper mapper)
    : IRequestHandler<GetAdminConventionsQuery, ConventionsResult>
{
    public async Task<ConventionsResult> Handle(
        GetAdminConventionsQuery request,
        CancellationToken cancellationToken
    )
    {
        var spec = new GetAdminConventionsSpecification(
            mapper,
            request.Page,
            request.PageSize,
            request.SearchParams
        );
        var cons = await repo.ListAsync(spec, cancellationToken);

        return new ConventionsResult(request.Page, request.PageSize, cons);
    }
}
