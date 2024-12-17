using Azure.Maps.Search;
using ConventionList.Api.Exceptions;
using ConventionList.Domain.Models;

namespace ConventionList.Api.Services;

public class AzureMapsSearchClient(MapsSearchClient client) : IMapsSearchClient
{
    public async Task<Geocoordinate> SearchAddressAsync(string address)
    {
        var response = await client.SearchAddressAsync(address);
        if (response.Value.NumResults == 0)
            throw new NoAddressFoundException($"{address} not found.");
        var position = new Geocoordinate(
            response.Value.Results[0].Position.Latitude,
            response.Value.Results[0].Position.Longitude
        );
        return position;
    }
}
