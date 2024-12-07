using System.Security.Claims;
using AutoMapper;
using ConventionList.Api.Auth;
using ConventionList.Api.Data;
using ConventionList.Api.Models.Api;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace ConventionList.Api.Commands;

public record UpdateConventionCommand(Guid Id, ApiConvention UpdatedCon, ClaimsPrincipal? User)
    : IRequest<IEvent>;

public class UpdateConventionHandler(ConventionListDbContext db, IMapper mapper)
    : IRequestHandler<UpdateConventionCommand, IEvent>
{
    public async Task<IEvent> Handle(
        UpdateConventionCommand request,
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

        mapper.Map(request.UpdatedCon, existingCon);
        existingCon.Editor = user.SubjectId()!;
        db.SaveChanges();

        return new SuccessEvent();
    }
}
