using ConventionList.Core.Models;

namespace ConventionList.Core.Interfaces;

public interface IGeocoder
{
    Task<Geocoordinate> Geocode(Convention con);
}
