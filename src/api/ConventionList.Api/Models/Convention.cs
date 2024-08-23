using System.ComponentModel.DataAnnotations;
using NetTopologySuite.Geometries;

namespace ConventionList.Api.Models;

public class Convention
{
    public Guid Id { get; set; }

    public string? SubmitterId { get; set; }

    public User? Submitter { get; set; }

    public Category Category { get; set; }

    public string? ExternalId { get; set; }

    public string? ExternalSource { get; set; }

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

    public string? City { get; set; }

    public string? State { get; set; }

    public string? PostalCode { get; set; }

    public string? Country { get; set; } = "US";

    // [Column(TypeName = "geography (point)")]
    public Point? Position { get; set; }
}