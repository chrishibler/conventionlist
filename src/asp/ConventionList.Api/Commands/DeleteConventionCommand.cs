using System.Security.Claims;
using ConventionList.Api.Auth;
using ConventionList.Api.Events;
using ConventionList.Core.Interfaces;
using ConventionList.Core.Models;
using MediatR;

namespace ConventionList.Api.Commands;

public record DeleteConventionCommand(Guid Id, ClaimsPrincipal? User) : IRequest<IEvent>;

public class DeleteConventionHandler(IRepository<Convention> repo)
    : IRequestHandler<DeleteConventionCommand, IEvent>
{
    public async Task<IEvent> Handle(
        DeleteConventionCommand request,
        CancellationToken cancellationToken
    )
    {
        var con = await repo.GetByIdAsync(request.Id, cancellationToken);
        string? submitterId = con?.SubmitterId;
        if (con == null)
        {
            return new ConventionNotFoundEvent();
        }

        var user = request.User;
        if (user is null || submitterId is null || !user.IsSubmitterOrAdmin(submitterId))
        {
            return new InvalidUserEvent();
        }

        await repo.DeleteAsync(con, cancellationToken);

        return new SuccessEvent();
    }
}
