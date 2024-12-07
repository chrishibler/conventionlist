using System.Security.Claims;
using AutoMapper;
using ConventionList.Api.Auth;
using ConventionList.Api.Data;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace ConventionList.Api.Commands;

public record DeleteConventionCommand(Guid Id, ClaimsPrincipal? User) : IRequest<IEvent>;

public class DeleteConventionHandler(ConventionListDbContext db)
    : IRequestHandler<DeleteConventionCommand, IEvent>
{
    public async Task<IEvent> Handle(
        DeleteConventionCommand request,
        CancellationToken cancellationToken
    )
    {
        var existingCon = await db.Conventions.SingleOrDefaultAsync(
            d => d.Id == request.Id,
            cancellationToken
        );

        if (existingCon == null)
        {
            return new ConventionNotFoundEvent();
        }

        var user = request.User;
        if (user == null || !user.IsSubmitterOrAdmin(existingCon))
        {
            return new InvalidUserEvent();
        }

        _ = db.Conventions.Remove(existingCon);
        _ = await db.SaveChangesAsync(cancellationToken);

        return new SuccessEvent();
    }
}
