using ConventionList.Api.Exceptions;
using ConventionList.Api.Models;
using Geocoding;
using Geocoding.Google;

namespace ConventionList.Api.Services;

public class GoogleMapsSearchClient(string apiKey) : IMapsSearchClient
{
    public async Task<Geocoordinate> SearchAddressAsync(string address)
    {
        IGeocoder geocoder = new GoogleGeocoder() { ApiKey = apiKey };

        var addresses = await geocoder.GeocodeAsync(address);
        if (address.Length == 0)
            throw new NoAddressFoundException($"{address} not found.");

        var position = new Geocoordinate(addresses.First().Coordinates.Latitude,
                                         addresses.First().Coordinates.Longitude);
        return position;
    }
}