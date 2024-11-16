using System.ComponentModel.DataAnnotations;

namespace ConventionList.Api.Models.Api;

public class NewApiConvention
{
    [Required]
    public Category Category { get; set; }

    [Required]
    public string Name { get; set; } = "";

    public string? Description { get; set; }

    [Required]
    public DateTime StartDate { get; set; }

    [Required]
    public DateTime EndDate { get; set; }

    public string? WebsiteAddress { get; set; }

    public string? VenueName { get; set; }

    public string? Address1 { get; set; }

    public string? Address2 { get; set; }

    [Required]
    public string? City { get; set; }

    public string? State { get; set; }

    [Required]
    public string? PostalCode { get; set; }

    [Required]
    public string? Country { get; set; } = "US";

    public bool IsApproved { get; set; }
}
