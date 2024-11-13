using AutoMapper;
using ConventionList.Api.Extensions;
using ConventionList.Api.Models;
using ConventionList.Api.Models.Api;

namespace ConventionList.Api.Mapping;

public class ConventionProfile : Profile
{
    // CreateMap(Source, Destination)
    public ConventionProfile()
    {
        CreateMap<Convention, Convention>()
            .ForMember(dest => dest.SubmitterId, act => act.Ignore())
            .ForMember(dest => dest.Id, act => act.Ignore())
            .ForMember(dest => dest.Position, act => act.Ignore())
            .ForMember(
                dest => dest.StartDate,
                opt => opt.MapFrom(src => src.StartDate.ToUniversalTime())
            )
            .ForMember(
                dest => dest.EndDate,
                opt => opt.MapFrom(src => src.EndDate.ToUniversalTime())
            );

        CreateMap<Convention, ApiConvention>()
            .ForMember(dest => dest.Position, opt => opt.MapFrom(src => src.ToGeocoordinate()));

        CreateMap<NewApiConvention, Convention>()
            .ForMember(
                dest => dest.StartDate,
                opt => opt.MapFrom(src => src.StartDate.ToUniversalTime())
            )
            .ForMember(
                dest => dest.EndDate,
                opt => opt.MapFrom(src => src.EndDate.ToUniversalTime())
            );
    }
}
