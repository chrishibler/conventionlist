using System.Security.Claims;
using AutoMapper;
using ConventionList.Api.Auth;
using ConventionList.Api.Data;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace ConventionList.Api.Commands;

public record DeleteConventionCommand(Guid Id, ClaimsPrincipal? User) : IRequest<IEvent>;

public class DeleteConventionHandler(IConventionRepository repo)
    : IRequestHandler<DeleteConventionCommand, IEvent>
{
    public async Task<IEvent> Handle(
        DeleteConventionCommand request,
        CancellationToken cancellationToken
    )
    {
        string? submitterId = await repo.GetSubmitterId(request.Id);
        if (submitterId == null)
        {
            return new ConventionNotFoundEvent();
        }

        var user = request.User;
        if (user == null || !user.IsSubmitterOrAdmin(submitterId))
        {
            return new InvalidUserEvent();
        }

        await repo.DeleteConvention(request.Id, cancellationToken);

        return new SuccessEvent();
    }
}
