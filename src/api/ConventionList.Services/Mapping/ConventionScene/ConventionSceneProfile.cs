using AutoMapper;
using ConventionList.Core;
using ConventionList.Core.Models;
using ConventionList.Services.Utils;
using Ical.Net.CalendarComponents;

namespace ConventionList.Services.Mapping.ConventionScene;

public class ConventionSceneProfile : Profile
{
    public ConventionSceneProfile()
    {
        CreateMap<CalendarEvent, Convention>()
            .ForMember(
                dest => dest.SubmitterId,
                opt => opt.MapFrom(src => UserIds.ConventionSceneSyncUserId)
            )
            .ForMember(dest => dest.Category, opt => opt.MapFrom(src => GetCategory(src)))
            .ForMember(dest => dest.ExternalId, opt => opt.MapFrom(src => GetExternalId(src)))
            .ForMember(
                dest => dest.ExternalSource,
                opt => opt.MapFrom(src => "conventionscene.com")
            )
            .ForMember(dest => dest.Name, opt => opt.MapFrom(src => GetConventionName(src)))
            .ForMember(dest => dest.VenueName, opt => opt.MapFrom(src => GetVenueName(src)))
            .ForMember(
                dest => dest.StartDate,
                opt => opt.MapFrom(src => src.Start.Date.ToUniversalTime())
            )
            .ForMember(
                dest => dest.EndDate,
                opt => opt.MapFrom(src => src.End.Date.ToUniversalTime())
            )
            .ForMember(dest => dest.City, opt => opt.MapFrom(src => GetCity(src)))
            .ForMember(dest => dest.State, opt => opt.MapFrom(src => GetState(src)))
            .ForMember(dest => dest.Country, opt => opt.MapFrom(src => GetCountry(src)))
            .ForMember(dest => dest.WebsiteAddress, opt => opt.MapFrom(src => GetUrl(src)))
            .ForMember(dest => dest.Position, opt => opt.Ignore());
    }

    public static string GetConventionName(CalendarEvent calEvent) =>
        GetLocationPart(calEvent, LocationPart.ConName) ?? "Unkown Name";

    public static string? GetVenueName(CalendarEvent calEvent) =>
        GetLocationPart(calEvent, LocationPart.VenueName);

    public static string? GetCity(CalendarEvent calEvent) =>
        GetLocationPart(calEvent, LocationPart.City);

    public static string? GetCountry(CalendarEvent calEvent) =>
        GetLocationPart(calEvent, LocationPart.Country);

    public static Category GetCategory(CalendarEvent calEvent)
    {
        //"summary": "Comic Book Convention at Beyond Comicon",
        if (string.IsNullOrWhiteSpace(calEvent.Summary))
        {
            return Category.Unlisted;
        }

        string[] parts = calEvent.Summary.Split("at");
        string categoryString = parts[0].Trim();

        return categoryString switch
        {
            _ when categoryString.Contains("Comic", StringComparison.OrdinalIgnoreCase) =>
                Category.Comics,
            _ when categoryString.Contains("Anime", StringComparison.OrdinalIgnoreCase) =>
                Category.Anime,
            _ when categoryString.Contains("Science", StringComparison.OrdinalIgnoreCase) =>
                Category.ScienceFictionAndFantasy,
            _ when categoryString.Contains("Gaming", StringComparison.OrdinalIgnoreCase) =>
                Category.Gaming,
            _ when categoryString.Contains("Comic", StringComparison.OrdinalIgnoreCase) =>
                Category.Comics,
            _ when categoryString.Contains("Book", StringComparison.OrdinalIgnoreCase) =>
                Category.Book,
            _ when categoryString.Contains("Collect", StringComparison.OrdinalIgnoreCase) =>
                Category.Collectibles,
            _ when categoryString.Contains("Sports", StringComparison.OrdinalIgnoreCase) =>
                Category.Sports,
            _ => Category.Unlisted,
        };
    }

    public static string? GetState(CalendarEvent calEvent)
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
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
        }

        return null;
    }

    public static string GetExternalId(CalendarEvent calEvent) => calEvent.Uid;

    public static string GetExternalSource() => "conventionscene.com";

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
                else
                {
                    // LOCATION:Anime Milwaukee\, Milwaukee\, WI\, US
                    // ConName, City, State, Country
                    // ConName, VenueName, City, Country
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
        string url = evnt.Url.ToString();
        return url.Contains("http://www.conventionscene.com") ? null : url;
    }

    private enum LocationPart
    {
        ConName,
        VenueName,
        City,
        Country,
    }
}
