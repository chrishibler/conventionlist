using Newtonsoft.Json;

namespace ConventionList.Api.Mapping.FanCons;

public class FanConEvent
{
    [JsonProperty("@context")]
    public string? Context { get; set; }

    [JsonProperty("@type")]
    public string? Type { get; set; }

    public string? Name { get; set; }

    [JsonProperty("startDate")]
    public DateTime? StartDate { get; set; }

    [JsonProperty("endDate")]
    public DateTime? EndDate { get; set; }

    [JsonProperty("eventStatus")]
    public string? EventStatus { get; set; }

    [JsonProperty("eventAttendanceMode")]
    public string? EventAttendanceMode { get; set; }

    public string? Url { get; set; }

    public FanConsOffer? Offers { get; set; }

    public string? Description { get; set; }

    public string? Image { get; set; }

    public Location? Location { get; set; }
}

public class FanConsOffer
{
    [JsonProperty("@type")]
    public string? Type { get; set; }

    public string? Url { get; set; }
}

public class Location
{
    [JsonProperty("@type")]
    public string? Type { get; set; }

    public string? Name { get; set; }

    public Address? Address { get; set; }
}

public class Address
{
    [JsonProperty("@type")]
    public string? Type { get; set; }

    [JsonProperty("addressLocality")]
    public string? AddressLocality { get; set; }

    [JsonProperty("addressRegion")]
    public string? AddressRegion { get; set; }

    [JsonProperty("postalCode")]
    public string? PostalCode { get; set; }

    [JsonProperty("addressCountry")]
    public string? AddressCountry { get; set; }
}
