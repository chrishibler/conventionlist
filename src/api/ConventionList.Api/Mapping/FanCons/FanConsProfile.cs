using System.Web;
using AutoMapper;
using ConventionList.Api.Models;
using ConventionList.Api.Services;

namespace ConventionList.Api.Mapping.FanCons;

public class FanConConventionProfile : Profile
{
    public FanConConventionProfile()
    {
        CreateMap<FanConEvent, Convention>()
            .ForMember(dest => dest.Position, opt => opt.Ignore())
            .ForMember(dest => dest.VenueName, opt => opt.MapFrom(src => GetVenueName(src)))
            .ForMember(dest => dest.City, opt => opt.MapFrom(src => GetCity(src)))
            .ForMember(dest => dest.State, opt => opt.MapFrom(src => GetState(src)))
            .ForMember(dest => dest.Country, opt => opt.MapFrom(src => GetCountry(src)))
            .ForMember(dest => dest.PostalCode, opt => opt.MapFrom(src => GetPostalCode(src)))
            .ForMember(dest => dest.WebsiteAddress, opt => opt.MapFrom(src => src.Url))
            .ForMember(dest => dest.StartDate, opt => opt.MapFrom(src => GetStartDate(src)))
            .ForMember(dest => dest.EndDate, opt => opt.MapFrom(src => GetEndDate(src)))
            .ForMember(dest => dest.Description, opt => opt.MapFrom(src => GetDescription(src)))
            .ForMember(dest => dest.ExternalSource, opt => opt.MapFrom(src => "fancons.com"))
            .ForMember(
                dest => dest.SubmitterId,
                opt => opt.MapFrom(src => FanConsSync.FanConsSyncUserId)
            );
    }

    private static DateTime GetStartDate(FanConEvent evnt) =>
        evnt.StartDate?.ToUniversalTime() ?? DateTime.MinValue;

    private static DateTime GetEndDate(FanConEvent evnt) =>
        evnt.EndDate?.ToUniversalTime() ?? DateTime.MinValue;

    private static string? GetCity(FanConEvent evnt) =>
        HttpUtility.HtmlDecode(evnt.Location?.Address?.AddressLocality);

    private static string? GetState(FanConEvent evnt) =>
        HttpUtility.HtmlDecode(evnt.Location?.Address?.AddressRegion);

    private static string? GetCountry(FanConEvent evnt) =>
        HttpUtility.HtmlDecode(evnt.Location?.Address?.AddressCountry);

    private static string? GetPostalCode(FanConEvent evnt) =>
        HttpUtility.HtmlDecode(evnt.Location?.Address?.PostalCode);

    private static string? GetVenueName(FanConEvent evnt) =>
        HttpUtility.HtmlDecode(evnt.Location?.Name);

    private static string? GetDescription(FanConEvent evnt) =>
        HttpUtility.HtmlDecode(evnt.Description);
}
