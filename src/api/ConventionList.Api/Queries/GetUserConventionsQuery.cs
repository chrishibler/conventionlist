using System.Security.Claims;
using AutoMapper;
using ConventionList.Api.Auth;
using ConventionList.Api.Data;
using ConventionList.Api.Models.Api;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace ConventionList.Api.Queries;

public record GetUserConventionsQuery(
    ClaimsPrincipal? User,
    int Page = 1,
    int PageSize = 20,
    SearchParams? SearchParams = null
) : IRequest<(IEvent Result, ConventionsResult? conventions)>;

public class GetUserConventionsHandler(ConventionListDbContext db, IMapper mapper)
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

        var query = db.Conventions.AsQueryable();
        query = request.SearchParams?.ApplyFilter(query) ?? query;
        query = query.Where(c => c.SubmitterId == userId);
        query = query.OrderBy(c => c.StartDate).ThenBy(c => c.Name);

        int totalCount = query.Count();
        int totalPages = (int)Math.Ceiling((double)totalCount / request.PageSize);

        var cons = await query
            .Skip((request.Page - 1) * request.PageSize)
            .Take(request.PageSize)
            .Select(c => mapper.Map<ApiConvention>(c))
            .ToListAsync(cancellationToken);
        return (
            new SuccessEvent(),
            new ConventionsResult(totalCount, totalPages, request.Page, request.PageSize, cons)
        );
    }
}
