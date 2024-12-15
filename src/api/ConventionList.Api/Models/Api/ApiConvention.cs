namespace ConventionList.Api.Models.Api;

public record ApiConvention(
    Guid Id,
    Category Category,
    string Name,
    string? Description,
    DateTime StartDate,
    DateTime EndDate,
    string? WebsiteAddress,
    string? VenueName,
    string? Address1,
    string? Address2,
    string? City,
    string? State,
    string? PostalCode,
    string? Country,
    Geocoordinate? Position,
    bool IsApproved = false
);
