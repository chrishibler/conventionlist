using ConventionList.Domain.Models;

namespace ConventionList.Api.Services;

public interface IMapsSearchClient
{
    public Task<Geocoordinate> SearchAddressAsync(string address);
}
