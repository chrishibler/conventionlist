using ConventionList.Domain.Models;

namespace ConventionList.Services;

public interface IMapsSearchClient
{
    public Task<Geocoordinate> SearchAddressAsync(string address);
}
