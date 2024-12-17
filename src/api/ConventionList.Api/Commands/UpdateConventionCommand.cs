using System.Security.Claims;
using ConventionList.Api.Auth;
using ConventionList.Api.Data;
using ConventionList.Api.Models.Api;
using MediatR;

namespace ConventionList.Api.Commands;

public record UpdateConventionCommand(Guid Id, ApiConvention UpdatedCon, ClaimsPrincipal? User)
    : IRequest<IEvent>;

public class UpdateConventionHandler(IConventionRepository repo)
    : IRequestHandler<UpdateConventionCommand, IEvent>
{
    public async Task<IEvent> Handle(
        UpdateConventionCommand request,
        CancellationToken cancellationToken
    )
    {
        var submitterId = await repo.GetSubmitterId(request.Id);
        if (submitterId == null)
        {
            return new ConventionNotFoundEvent();
        }

        var user = request.User;
        if (user == null || !user.IsSubmitterOrAdmin(submitterId))
        {
            return new InvalidUserEvent();
        }

        await repo.UpdateConvention(request.UpdatedCon, submitterId, cancellationToken);

        return new SuccessEvent();
    }
}
