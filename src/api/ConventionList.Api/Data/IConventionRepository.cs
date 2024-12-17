using ConventionList.Api.Models.Api;

namespace ConventionList.Api.Data;

public interface IConventionRepository
{
    public Task<ConventionsResult> GetAdminConventions(
        SearchParams? searchParams,
        int page,
        int pageSize,
        CancellationToken cancellationToken
    );

    public Task<ApiConvention?> GetConvention(Guid id, CancellationToken cancellationToken);

    public Task<ConventionsResult> GetConventionsByBounds(
        Bounds bounds,
        int page,
        int pageSize,
        CancellationToken cancellationToken
    );

    public Task<ConventionsResult> GetConventions(
        SearchParams? searchParams,
        double? lon,
        double? lat,
        int page,
        int pageSize,
        CancellationToken cancellationToken
    );

    public Task<string?> GetSubmitterId(Guid conventionId);

    public Task<List<ApiConvention>> GetUserConventions(
        SearchParams? searchParams,
        string userId,
        int pageSize,
        int page,
        CancellationToken cancellationToken
    );

    public Task<ApiConvention> AddConvention(
        NewApiConvention newCon,
        string userId,
        CancellationToken cancellationToken
    );

    public Task DeleteConvention(Guid id, CancellationToken cancellationToken);

    public Task UpdateConvention(
        ApiConvention apiConvention,
        string editorUserId,
        CancellationToken cancellationToken
    );
}
