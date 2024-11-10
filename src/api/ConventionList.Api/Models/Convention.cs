using System.ComponentModel.DataAnnotations;
using Microsoft.EntityFrameworkCore;
using NetTopologySuite.Geometries;

namespace ConventionList.Api.Models;

[Index(nameof(Name))]
[Index(nameof(VenueName))]
[Index(nameof(City))]
[Index(nameof(StartDate))]
public class Convention
{
    public Guid Id { get; set; }

    public string? SubmitterId { get; set; }

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

    public Point? Position { get; set; }

    public bool IsApproved { get; set; }
}
