using AutoMapper;
using ConventionList.Api.Events;
using ConventionList.Core.Interfaces;
using ConventionList.Core.Models;
using MediatR;

namespace ConventionList.Api.Queries;

public record GetConventionQuery(Guid Id) : IRequest<(IEvent Result, ApiConvention? Convention)>;

public class GetConventionHandler(IRepository<Convention> repo, IMapper mapper)
    : IRequestHandler<GetConventionQuery, (IEvent Result, ApiConvention? Convention)>
{
    public async Task<(IEvent Result, ApiConvention? Convention)> Handle(
        GetConventionQuery request,
        CancellationToken cancellationToken
    )
    {
        var convention = await repo.GetByIdAsync(request.Id, cancellationToken);
        if (convention is null)
        {
            return (new ConventionNotFoundEvent(), null);
        }

        return (new SuccessEvent(), mapper.Map<ApiConvention>(convention));
    }
}
