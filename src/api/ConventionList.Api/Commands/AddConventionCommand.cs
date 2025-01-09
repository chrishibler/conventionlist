using AutoMapper;
using ConventionList.Core.Interfaces;
using ConventionList.Core.Models;
using MediatR;

namespace ConventionList.Api.Commands;

public record AddConventionCommand(NewApiConvention NewCon, string UserId)
    : IRequest<ApiConvention>;

public class AddConventionHandler(IRepository<Convention> repo, IMapper mapper)
    : IRequestHandler<AddConventionCommand, ApiConvention>
{
    public async Task<ApiConvention> Handle(
        AddConventionCommand request,
        CancellationToken cancellationToken
    )
    {
        Convention con = mapper.Map<Convention>(request.NewCon);
        con.SubmitterId = request.UserId;
        con = await repo.AddAsync(con, cancellationToken);
        return mapper.Map<ApiConvention>(con);
    }
}
