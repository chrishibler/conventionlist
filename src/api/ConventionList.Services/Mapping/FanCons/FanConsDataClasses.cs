using System.Text.Json.Serialization;

namespace ConventionList.Services.Mapping.FanCons;

public class FanConEvent
{
    [JsonPropertyName("@context")]
    public string? Context { get; set; }

    [JsonPropertyName("@type")]
    public string? Type { get; set; }

    public string? Name { get; set; }

    [JsonPropertyName("startDate")]
    public DateTime? StartDate { get; set; }

    [JsonPropertyName("endDate")]
    public DateTime? EndDate { get; set; }

    [JsonPropertyName("eventStatus")]
    public string? EventStatus { get; set; }

    [JsonPropertyName("eventAttendanceMode")]
    public string? EventAttendanceMode { get; set; }

    public string? Url { get; set; }

    public FanConsOffer? Offers { get; set; }

    public string? Description { get; set; }

    public string? Image { get; set; }

    public Location? Location { get; set; }
}

public class FanConsOffer
{
    [JsonPropertyName("@type")]
    public string? Type { get; set; }

    public string? Url { get; set; }
}

public class Location
{
    [JsonPropertyName("@type")]
    public string? Type { get; set; }

    public string? Name { get; set; }

    public Address? Address { get; set; }
}

public class Address
{
    [JsonPropertyName("@type")]
    public string? Type { get; set; }

    [JsonPropertyName("addressLocality")]
    public string? AddressLocality { get; set; }

    [JsonPropertyName("addressRegion")]
    public string? AddressRegion { get; set; }

    [JsonPropertyName("postalCode")]
    public string? PostalCode { get; set; }

    [JsonPropertyName("addressCountry")]
    public string? AddressCountry { get; set; }
}
