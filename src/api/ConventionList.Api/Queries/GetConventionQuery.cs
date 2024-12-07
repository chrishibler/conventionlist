using AutoMapper;
using ConventionList.Api.Data;
using ConventionList.Api.Models.Api;
using MediatR;

namespace ConventionList.Api.Queries;

public record GetConventionQuery(Guid Id) : IRequest<(IEvent Result, ApiConvention? Convention)>;

public class GetConventionHandler(ConventionListDbContext db, IMapper mapper)
    : IRequestHandler<GetConventionQuery, (IEvent Result, ApiConvention? Convention)>
{
    public async Task<(IEvent Result, ApiConvention? Convention)> Handle(
        GetConventionQuery request,
        CancellationToken cancellationToken
    )
    {
        var convention = await db.Conventions.FindAsync(request.Id, cancellationToken);
        if (convention == null)
        {
            return (new ConventionNotFoundEvent(), null);
        }

        return (new SuccessEvent(), mapper.Map<ApiConvention>(convention));
    }
}
