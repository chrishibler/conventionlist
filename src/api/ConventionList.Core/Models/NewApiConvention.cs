using System.ComponentModel.DataAnnotations;

namespace ConventionList.Core.Models;

public record NewApiConvention(
    [Required] Category Category,
    [Required] string Name,
    string? Description,
    [Required] DateTime StartDate,
    [Required] DateTime EndDate,
    string? WebsiteAddress,
    string? VenueName,
    string? Address1,
    string? Address2,
    [Required] string City,
    string? State,
    [Required] string PostalCode,
    [Required] string Country,
    bool IsApproved = false
);
