using ConventionList.Api.Events;
using ConventionList.Domain.Models;
using ConventionList.Repository;
using MediatR;

namespace ConventionList.Api.Queries;

public record GetConventionQuery(Guid Id) : IRequest<(IEvent Result, ApiConvention? Convention)>;

public class GetConventionHandler(IConventionRepository repo)
    : IRequestHandler<GetConventionQuery, (IEvent Result, ApiConvention? Convention)>
{
    public async Task<(IEvent Result, ApiConvention? Convention)> Handle(
        GetConventionQuery request,
        CancellationToken cancellationToken
    )
    {
        var convention = await repo.GetConvention(request.Id, cancellationToken);
        if (convention is null)
        {
            return (new ConventionNotFoundEvent(), null);
        }

        return (new SuccessEvent(), convention);
    }
}
