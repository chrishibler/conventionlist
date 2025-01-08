using ConventionList.Core.Models;

namespace ConventionList.Core.Interfaces;

public interface IMapsSearchClient
{
    public Task<Geocoordinate> SearchAddressAsync(string address);
}
