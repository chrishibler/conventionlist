using AutoMapper;
using ConventionList.Api.Data;
using ConventionList.Api.Mapping;
using ConventionList.Api.Models;
using ConventionList.Api.Models.Api;
using ConventionList.Api.Services;
using MediatR;

namespace ConventionList.Api.Commands;

public record AddConventionCommand(NewApiConvention NewCon, string UserId)
    : IRequest<ApiConvention>;

public class AddConventionHandler(
    ConventionListDbContext db,
    IMapper mapper,
    GeocodingService geocoder,
    ILogger<AddConventionHandler> log
) : IRequestHandler<AddConventionCommand, ApiConvention>
{
    public async Task<ApiConvention> Handle(
        AddConventionCommand request,
        CancellationToken cancellationToken
    )
    {
        var con = mapper.Map<Convention>(request.NewCon);
        con.Id = Guid.NewGuid();
        con.Editor = request.UserId;
        con.SubmitterId = request.UserId;
        try
        {
            var position = await geocoder.Geocode(con);
            con.Position = GeocoordinateTypeConverter.ToPoint(position);
        }
        catch (Exception ex)
        {
            log.LogError(ex, "Could not geocode con {ConName}", con.Name);
        }
        _ = db.Conventions.Add(con);
        _ = await db.SaveChangesAsync(cancellationToken);
        var apiConvention = mapper.Map<ApiConvention>(con);

        return apiConvention;
    }
}
