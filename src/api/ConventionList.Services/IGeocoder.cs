using ConventionList.Domain.Models;

namespace ConventionList.Services;

public interface IGeocoder
{
    Task<Geocoordinate> Geocode(Convention con);
}
