using AutoMapper;
using ConventionList.Api.Models;
using ConventionList.Api.Services.Utils;
using Ical.Net.CalendarComponents;

namespace ConventionList.Api.Mapping.FanCons;

public class ConventionSceneProfile : Profile
{
    public ConventionSceneProfile()
    {
        CreateMap<CalendarEvent, Convention>()
            .ForMember(dest => dest.SubmitterId, opt => opt.MapFrom(src => User.ConventionSceneSyncUserId))
            .ForMember(dest => dest.Category, opt => opt.MapFrom(src => GetCategory(src)))
            .ForMember(dest => dest.ExternalId, opt => opt.MapFrom(src => GetExternalId(src)))
            .ForMember(dest => dest.ExternalSource, opt => opt.MapFrom(src => "conventionscene.com"))
            .ForMember(dest => dest.Name, opt => opt.MapFrom(src => GetConventionName(src)))
            .ForMember(dest => dest.VenueName, opt => opt.MapFrom(src => GetVenueName(src)))
            .ForMember(dest => dest.StartDate, opt => opt.MapFrom(src => src.Start.Date.ToUniversalTime()))
            .ForMember(dest => dest.EndDate, opt => opt.MapFrom(src => src.End.Date.ToUniversalTime()))
            .ForMember(dest => dest.City, opt => opt.MapFrom(src => GetCity(src)))
            .ForMember(dest => dest.State, opt => opt.MapFrom(src => GetState(src)))
            .ForMember(dest => dest.Country, opt => opt.MapFrom(src => GetCountry(src)))
            .ForMember(dest => dest.WebsiteAddress, opt => opt.MapFrom(src => GetUrl(src)))
            .ForMember(dest => dest.Position, opt => opt.Ignore());
    }

    public string GetConventionName(CalendarEvent calEvent) => GetLocationPart(calEvent, LocationPart.ConName) ?? "Unkown Name";
    public string? GetVenueName(CalendarEvent calEvent) => GetLocationPart(calEvent, LocationPart.VenueName);
    public string? GetCity(CalendarEvent calEvent) => GetLocationPart(calEvent, LocationPart.City);
    public string? GetCountry(CalendarEvent calEvent) => GetLocationPart(calEvent, LocationPart.Country);
    public Category GetCategory(CalendarEvent calEvent)
    {
        //"summary": "Comic Book Convention at Beyond Comicon",
        if (string.IsNullOrWhiteSpace(calEvent.Summary))
        {
            return Category.Unknown;
        }

        string[] parts = calEvent.Summary.Split("at");
        string categoryString = parts.ElementAtOrDefault(0)?.Trim() ?? "";
        if (categoryString.Contains("Anime", StringComparison.OrdinalIgnoreCase))
        {
            return Category.Anime;
        }
        else if (categoryString.Contains("Science", StringComparison.OrdinalIgnoreCase))
        {
            return Category.ScienceFictionAndFantasy;
        }
        else if (categoryString.Contains("Gaming", StringComparison.OrdinalIgnoreCase))
        {
            return Category.Gaming;
        }
        else if (categoryString.Contains("Comic", StringComparison.OrdinalIgnoreCase))
        {
            return Category.Comics;
        }
        else if (categoryString.Contains("Book", StringComparison.OrdinalIgnoreCase))
        {
            return Category.Book;
        }
        else if (categoryString.Contains("Collect", StringComparison.OrdinalIgnoreCase))
        {
            return Category.Collectibles;
        }
        else if (categoryString.Contains("Sports", StringComparison.OrdinalIgnoreCase))
        {
            return Category.Sports;
        }
        else
        {
            return Category.Unknown;
        }
    }

    public string? GetState(CalendarEvent calEvent)
    {
        // "Location: California. "
        // "Location: Germany. "
        if (string.IsNullOrWhiteSpace(calEvent.Description))
        {
            return null;
        }

        string[] parts = calEvent.Description.Split(':');
        if (parts.Length >= 2)
        {
            string stateFullName = parts[1].Trim().Replace(".", "");
            try
            {
                return AddressUtils.GetStateAbbreviationByName(stateFullName);
            }
            catch (Exception) { }
        }

        return null;
    }
    public string GetExternalId(CalendarEvent calEvent) => calEvent.Uid;

    public string GetExternalSource() => "conventionscene.com";

    private static string? GetLocationPart(CalendarEvent calEvent, LocationPart locationPart)
    {
        // LOCATION: My Hero Convention: TX Smash\, Irving\, TX\, US
        // LOCATION: Shoff Promotions Comic Book and Non-Sports Card Show\, Annandale Fire Station\, Annandale\, US
        // LOCATION: DualCon\, Charleston Coliseum &Convention Center\, Charleston\, US
        // LOCATION: Beyond Comicon\, Marjorie and William McDonald Center\, North Miami Beach\, US
        if (string.IsNullOrWhiteSpace(calEvent.Location))
        {
            return null;
        }

        string[] parts = calEvent.Location.Split(", ");
        if (parts.Length == 0)
        {
            return null;
        }

        string? part = null;
        switch (locationPart)
        {
            case LocationPart.ConName:
                return parts[0].Trim();
            case LocationPart.Country:
                return parts.Last().Trim();
            case LocationPart.VenueName:
                if (parts.Length == 4)
                {
                    //  ConName, City, State, Country
                    if (AddressUtils.IsStateAbbreviation(parts[2]))
                    {
                        return null;
                    }
                    else
                    {
                        // ConName, VenueName, City, Country
                        return parts[1].Trim();
                    }
                }
                else
                {
                    return null;
                }
            case LocationPart.City:
                if (parts.Length == 3)
                {
                    // ConName, City, Country
                    return parts[1].Trim();
                }
                if (parts.Length == 4)
                {
                    return AddressUtils.IsStateAbbreviation(parts[^2]) ? parts[^3] : parts[^2];
                    // LOCATION:Anime Milwaukee\, Milwaukee\, WI\, US
                    //  ConName, City, State, Country
                    // ConName, VenueName, City, Country
                }
                else
                {
                    // Blah Blah, Blah, Blah, Blah, City, State, Country
                    // Blah Blah, Blah, Blah, Blah, City, Country
                    return AddressUtils.IsStateAbbreviation(parts[^2]) ? parts[^3] : parts[^2];
                }

            default:
                break;
        }


        return part;
    }

    private static string? GetUrl(CalendarEvent evnt)
    {
        if (evnt.Url.ToString().Contains("http://www.conventionscene.com"))
        {
            return null;
        }
        return evnt.Url.ToString();
    }

    private enum LocationPart
    {
        ConName,
        VenueName,
        City,
        Country
    }
}
