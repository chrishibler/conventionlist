using ConventionList.Domain.Exceptions;
using ConventionList.Domain.Models;
using Geocoding.Google;

namespace ConventionList.Services;

public class GoogleMapsSearchClient(string apiKey) : IMapsSearchClient
{
    public async Task<Geocoordinate> SearchAddressAsync(string address)
    {
        var geocoder = new GoogleGeocoder() { ApiKey = apiKey };

        var addresses = await geocoder.GeocodeAsync(address);
        if (address.Length == 0)
            throw new NoAddressFoundException($"{address} not found.");

        var position = new Geocoordinate(
            addresses.First().Coordinates.Latitude,
            addresses.First().Coordinates.Longitude
        );
        return position;
    }
}
