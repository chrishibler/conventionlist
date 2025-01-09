using System.Security.Claims;
using AutoMapper;
using ConventionList.Api.Auth;
using ConventionList.Api.Events;
using ConventionList.Core.Interfaces;
using ConventionList.Core.Models;
using ConventionList.Core.Specifications;
using MediatR;

namespace ConventionList.Api.Queries;

public record GetUserConventionsQuery(
    ClaimsPrincipal? User,
    int Page = 1,
    int PageSize = 20,
    SearchParams? SearchParams = null
) : IRequest<(IEvent Result, ConventionsResult? conventions)>;

public class GetUserConventionsHandler(IRepository<Convention> repo, IMapper mapper)
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

        var spec = new GetUserConventionsSpecification(
            request.SearchParams,
            mapper,
            userId,
            request.PageSize,
            request.Page
        );

        var cons = await repo.ListAsync(spec, cancellationToken);

        return (new SuccessEvent(), new ConventionsResult(request.Page, request.PageSize, cons));
    }
}
