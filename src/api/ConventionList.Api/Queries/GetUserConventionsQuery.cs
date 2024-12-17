using System.Security.Claims;
using ConventionList.Api.Auth;
using ConventionList.Api.Data;
using ConventionList.Api.Models.Api;
using MediatR;

namespace ConventionList.Api.Queries;

public record GetUserConventionsQuery(
    ClaimsPrincipal? User,
    int Page = 1,
    int PageSize = 20,
    SearchParams? SearchParams = null
) : IRequest<(IEvent Result, ConventionsResult? conventions)>;

public class GetUserConventionsHandler(IConventionRepository repo)
    : IRequestHandler<GetUserConventionsQuery, (IEvent Result, ConventionsResult? conventions)>
{
    public async Task<(IEvent Result, ConventionsResult? conventions)> Handle(
        GetUserConventionsQuery request,
        CancellationToken cancellationToken
    )
    {
        string? userId = request.User?.SubjectId();
        if (string.IsNullOrWhiteSpace(userId))
        {
            return (new InvalidUserEvent(), null);
        }

        var cons = await repo.GetUserConventions(
            request.SearchParams,
            userId,
            request.PageSize,
            request.Page,
            cancellationToken
        );

        int totalCount = cons.Count;
        int totalPages = (int)Math.Ceiling((double)totalCount / request.PageSize);

        return (
            new SuccessEvent(),
            new ConventionsResult(totalCount, totalPages, request.Page, request.PageSize, cons)
        );
    }
}
