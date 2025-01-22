using ConventionList.Core.Interfaces;
using ConventionList.Core.Models;

namespace ConventionList.Services;

public class Geocoder(IMapsSearchClient client) : IGeocoder
{
    public async Task<Geocoordinate> Geocode(Convention con)
    {
        if (con.PostalCode == null && con.City == null)
            throw new InvalidOperationException("No location data.");

        var position = await client.SearchAddressAsync(
            $"{con.PostalCode} {con.City} {con.State} {con.Country}"
        );

        return new Geocoordinate(position.Latitude, position.Longitude);
    }
}
