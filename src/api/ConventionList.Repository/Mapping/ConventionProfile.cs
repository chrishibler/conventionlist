using AutoMapper;
using ConventionList.Domain.Models;
using NetTopologySuite.Geometries;

namespace ConventionList.Repository.Mapping;

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

        CreateMap<Point, Geocoordinate>().ConvertUsing(typeof(PointTypeConverter));

        CreateMap<Convention, ApiConvention>();

        CreateMap<Geocoordinate, Point>().ConvertUsing(typeof(GeocoordinateTypeConverter));

        CreateMap<ApiConvention, Convention>()
            .ForMember(
                dest => dest.StartDate,
                opt => opt.MapFrom(src => src.StartDate.ToUniversalTime())
            )
            .ForMember(
                dest => dest.EndDate,
                opt => opt.MapFrom(src => src.EndDate.ToUniversalTime())
            );

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
