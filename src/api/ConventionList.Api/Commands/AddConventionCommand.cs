using ConventionList.Core.Interfaces;
using ConventionList.Core.Models;
using MediatR;

namespace ConventionList.Api.Commands;

public record AddConventionCommand(NewApiConvention NewCon, string UserId)
    : IRequest<ApiConvention>;

public class AddConventionHandler(IConventionRepository repo)
    : IRequestHandler<AddConventionCommand, ApiConvention>
{
    public Task<ApiConvention> Handle(
        AddConventionCommand request,
        CancellationToken cancellationToken
    )
    {
        return repo.AddConvention(request.NewCon, request.UserId, cancellationToken);
    }
}
