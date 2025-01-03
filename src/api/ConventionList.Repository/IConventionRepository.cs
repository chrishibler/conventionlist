using ConventionList.Domain.Models;

namespace ConventionList.Repository;

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

    public Task<List<Convention>> GetConventionsToGeocode();

    public Task<List<Convention>> GetHtmlFixableConventions();

    public Task<Convention?> GetLatestConventionByName(string name);

    public Task Add(Convention con);

    public void Update(Convention con);

    public Task SaveChangesAsync();
}
