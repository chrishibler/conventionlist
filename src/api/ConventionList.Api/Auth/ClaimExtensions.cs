using System.Security.Claims;
using ConventionList.Api.Models;

namespace ConventionList.Api.Auth;

static class ClaimExtensions
{
    public static bool HasPermission(this ClaimsPrincipal user, string issuer, string permission)
    {
        bool hasPermission = user.Claims.Any(c =>
            c.Type == Permissions.ClaimType && c.Issuer == issuer && permission == c.Value
        );
        return hasPermission;
    }

    public static string? SubjectId(this ClaimsPrincipal user)
    {
        return user.FindFirstValue(ClaimTypes.NameIdentifier);
    }

    public static bool HasPermission(this ClaimsPrincipal user, string permission)
    {
        bool hasPermission = user.Claims.Any(c =>
            c.Type == Permissions.ClaimType && c.Value == permission
        );
        return hasPermission;
    }

    public static bool IsSubmitterOrAdmin(this ClaimsPrincipal user, Convention con)
    {
        return user.SubjectId() == con.SubmitterId || IsAdmin(user);
    }

    public static bool IsAdmin(this ClaimsPrincipal user)
    {
        return user.HasPermission(Permissions.ManageAllConventions);
    }
}
