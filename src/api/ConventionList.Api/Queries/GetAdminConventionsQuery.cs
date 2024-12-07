using AutoMapper;
using ConventionList.Api.Data;
using ConventionList.Api.Models.Api;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace ConventionList.Api.Queries;

public record GetAdminConventionsQuery(
    int Page = 1,
    int PageSize = 20,
    SearchParams? SearchParams = null
) : IRequest<ConventionsResult>;

public class GetAdminConventionsHandler(ConventionListDbContext db, IMapper mapper)
    : IRequestHandler<GetAdminConventionsQuery, ConventionsResult>
{
    public async Task<ConventionsResult> Handle(
        GetAdminConventionsQuery request,
        CancellationToken cancellationToken
    )
    {
        var query = db.Conventions.AsQueryable();
        query = request.SearchParams?.ApplyFilter(query) ?? query;
        query = query.OrderByDescending(c => c.StartDate).ThenBy(c => c.Name);

        int totalCount = query.Count();
        int totalPages = (int)Math.Ceiling((double)totalCount / request.PageSize);

        var cons = await query
            .Skip((request.Page - 1) * request.PageSize)
            .Take(request.PageSize)
            .Select(c => mapper.Map<ApiConvention>(c))
            .ToListAsync(cancellationToken);
        return new ConventionsResult(totalCount, totalPages, request.Page, request.PageSize, cons);
    }
}
