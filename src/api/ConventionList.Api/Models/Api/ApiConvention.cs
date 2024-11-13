namespace ConventionList.Api.Models.Api;

public class ApiConvention
{
    public Guid Id { get; set; }

    public Category Category { get; set; }

    public string Name { get; set; } = "";

    public string? Description { get; set; }

    public DateTime StartDate { get; set; }

    public DateTime EndDate { get; set; }

    public string? WebsiteAddress { get; set; }

    public string? VenueName { get; set; }

    public string? Address1 { get; set; }

    public string? Address2 { get; set; }

    public string? City { get; set; }

    public string? State { get; set; }

    public string? PostalCode { get; set; }

    public string? Country { get; set; } = "US";

    public Geocoordinate? Position { get; set; }

    public bool IsApproved { get; set; }
}
